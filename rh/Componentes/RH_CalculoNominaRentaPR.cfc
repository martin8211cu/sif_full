<cfcomponent>
	<cffunction name="CalculoNominaRenta" access="public" output="true" >
		<cfargument name="conexion" 			type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="RCNid"   				type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric" 	required="yes">
		<cfargument name="Tcodigo" 				type="string" 	required="yes">
		<cfargument name="cantdias" 			type="numeric"	required="yes">
		<cfargument name="CantDiasMensual" 		type="numeric"	required="yes">
		<cfargument name="CantPagosRealizados" 	type="numeric"	required="yes">		
		<cfargument name="Factor" 				type="numeric"	required="yes">				
		<cfargument name="per" 					type="numeric"	required="yes">				
		<cfargument name="mes" 					type="numeric"	required="yes">				
		<cfargument name="IRcodigo" 			type="string" 	required="yes">
		<cfargument name="RCdesde" 				type="date" 	required="yes">
		<cfargument name="RChasta" 				type="date" 	required="yes">		

    	<cfset vfrecuencia = '' >
		<cfquery name="rsFrecuencia" datasource="#arguments.conexion#">
			select Ttipopago
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
		</cfquery>
		<cfset vfrecuencia = rsFrecuencia.Ttipopago >
		
		<cfif len(trim(vfrecuencia)) eq 0>
			<cfthrow message="Error. No se pudo obtener la frecuencia de pago para el tipo de n&oacute;mina #arguments.Tcodigo#">
		</cfif>

		<!---     1. Deducir Cargas pagadas por el empleado que disminuyen Renta.
			Se deducen del devengado total a proyectar las cargas del empleado 
			que esten marcadas como:  Disminuyen el monto imponible de Renta 
			Ejemplo.  Planes de Pension Voluntaria 	--->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
			set SEinorenta =  coalesce((select sum(cc.CCvaloremp)
										from CargasCalculo cc, DCargas dc
										where cc.RCNid = c.RCNid
										  and cc.DEid = c.DEid
										  and dc.DClinea = cc.DClinea
										  and dc.DCnorenta > 0), 0.00) 
			from SalarioEmpleado c
			where c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.SEcalculado = 0
		</cfquery>

		<!--- 	2. Calcular Salario Acumulado para Renta 
			Calcular el monto de pago de salario (por fechas trabajadas) que se toman en cuenta para la renta --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
			set SEacumulado = coalesce((	select sum(p.PEmontores) 
											from PagosEmpleado p, RHTipoAccion t
											where p.RCNid = SalarioEmpleado.RCNid 
											  and p.DEid = SalarioEmpleado.DEid 
											  and t.RHTid = p.RHTid
											  and t.RHTnorenta = 0 ), 0.00)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and SEcalculado = 0
		</cfquery>			  

		<!--- 	3.	Sumar al Salario Acumulado las Incidencias que apliquen para renta que se hayan aplicado en la nomina en proceso --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
			set SEacumulado = SEacumulado + coalesce((	select sum(b.ICmontores)
														from IncidenciasCalculo b, CIncidentes d
														where b.DEid = s.DEid 
														  and b.RCNid = s.RCNid
														  and d.CIid = b.CIid
														  and d.CInorenta = 0), 0.00)
			from SalarioEmpleado s
			where s.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and s.SEcalculado = 0
		</cfquery>		  

		<!--- 4.  Al acumulado, restar el monto de las cargas deducibles de renta por el factor --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
				set SEacumulado = SEacumulado - SEinorenta
			from SalarioEmpleado s
			where s.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and s.SEcalculado = 0
		</cfquery>

		 <!--- 5. Monto a proyectado se iguala al monto acumulado --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado
			set SEproyectado = SEacumulado 
			from SalarioEmpleado s
			where s.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and s.SEcalculado = 0
		</cfquery>

		<!--- 6. Monto a Deducir por Exencion Personal y por concesión por deducciones --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
			set SEproyectado = SEproyectado - coalesce((select b.EPmonto + (b.EPmontomultiplicador * a.ETNumConces)
														from EmpleadosTipo a, ExcepcionesPersonales b
														where a.DEid = c.DEid
														  and a.TEid = b.TEid 
														  and b.Ttipopago = <cfqueryparam cfsqltype="cf_sql_integer" value="#vfrecuencia#">	), 0.00)
			from SalarioEmpleado c
			where c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.SEcalculado < 1
		</cfquery>

		<!--- 7. Monto a Deducir del Impuesto de la Renta si hay conceptos de Deduccion asociados (conyuge o dependientes) --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
			set SEproyectado = SEproyectado - coalesce((	select sum(b.EPmontodependiente)
															from EmpleadosTipo a, ExcepcionesPersonales b, FEmpleado c
															where a.DEid = d.DEid
															  and a.DEid = c.DEid
															  and a.TEid = b.TEid 
															  and b.Ttipopago = <cfqueryparam cfsqltype="cf_sql_integer" value="#vfrecuencia#">
															  and c.FEdeducrenta > 0
															  and c.FEdeducdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
															  and c.FEdeduchasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#">), 0.00)
			from SalarioEmpleado d
			where d.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and d.SEcalculado < 1
		</cfquery>			  

		<!--- 	8.  Calculo del Impuesto sobre la Renta al salario
					Se utiliza la tabla de renta definida en la empresa, de acuerdo con el rango de fechas --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
				set SErenta = coalesce((select (c.SEproyectado * (e.DIRporcentaje /100)) - e.DIRmontofijo
										from EmpleadosTipo a, ExcepcionesPersonales b, EImpuestoRenta d, DImpuestoRenta e
										where a.DEid = c.DEid
										  and a.DEid = c.DEid
										  and a.TEid = b.TEid 
										  and b.Ttipopago = <cfqueryparam cfsqltype="cf_sql_integer" value="#vfrecuencia#">	
										  and b.IRcodigo = d.IRcodigo
										  and d.EIRestado = 1
										  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between d.EIRdesde and d.EIRhasta
										  and d.EIRid = e.EIRid
										  and c.SEproyectado >= e.DIRinf
										  and c.SEproyectado <= e.DIRsup
										),0.00)
			from SalarioEmpleado c
			where c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.SEcalculado = 0
		</cfquery>

		<!---  9. Si la renta proyectada es negativa, el monto a retener es cero  --->
		<cfquery datasource="#arguments.conexion#">
			update SalarioEmpleado 
				set SErenta = 0.00 
			from SalarioEmpleado c
			where c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.SEcalculado = 0
			  and coalesce(SErenta, 0.00) < 0.00
		</cfquery>
		
		<cfreturn>	
	</cffunction>
</cfcomponent>
