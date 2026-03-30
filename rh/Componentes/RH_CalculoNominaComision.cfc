?<cfcomponent>
	<cffunction name="CalculoNominaComision" access="public" output="true" >
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RCNid"   type="numeric" required="yes">
		<cfargument name="Tcodigo" type="string" 	required="yes">
		<cfargument name="RCdesde" type="string" required="yes">
		<cfargument name="RChasta" type="string" required="yes">		
		<cfargument name="IRcodigo" type="string" 	required="yes">
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="Ulocalizacion" type="string" required="no" default="00">
		<cfargument name="pDEid" type="numeric" required="no" default="false">		
		<cfargument name="debug" type="boolean" required="no" default="false">

		
		<!---ljimenez : leemos los valores de parametros que son utilizados--->
		<cfinvoke component="RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="330" default="0" returnvariable="vComisionSB"/>
		<cfinvoke component="RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="331" default="0" returnvariable="vComisionCSB"/>
		
		<cfinvoke component="RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="340" returnvariable="vpcisalariorebajo" 		default="" />
		<cfinvoke component="RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="350" returnvariable="vpcisalariobase" 		default=""/>
		<cfinvoke component="RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="360" returnvariable="vpcisalarioajuste" 		default="" />
		<cfinvoke component="RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="380" returnvariable="vpcisalariorebajoant" 	default="" />
		
		
		<cfset debug = 'false'>
		<cfif debug>
			vComisionSB 		: <cfdump var="#vComisionSB#">	 		<br>
			vComisionCSB		: <cfdump var="#vComisionCSB#">			<br>
			vpcisalariorebajo	: <cfdump var="#vpcisalariorebajo#">	<br>
			vpcisalariobase 	: <cfdump var="#vpcisalariobase#"> 		<br>
			vpcisalarioajuste	: <cfdump var="#vpcisalarioajuste#">	<br>
			vpcisalariorebajoant: <cfdump var="#vpcisalariorebajoant#"> <br>
		</cfif>
		
		
		<!--- Valida existencia de comisiones --->
		
		<cfquery name="rsComisiones" datasource="#arguments.conexion#">
			select 1 
			from RHComisionMonge 
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
		
		<cfif rsComisiones.recordcount eq 0 >
		
			<!--- ljimenez si no existen comisiones para la nomina en proceso aplica :
					1) Incidencia de monto base 
					2) Comisiones que fueron distribuidas 
					3) Ajustes que fueron distribuidos 
			--->
			
			<cfif vcomisionCSB  EQ 1>
			
				<cfquery name="rsCalendario" datasource="#arguments.conexion#">
					select CPmes, CPperiodo, CPdesde
						from CalendarioPagos
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				</cfquery>
				
				
				<cfquery name="rsComisionesPagadas" datasource="#arguments.conexion#">
					select *
					from RHComisionMonge 
					where CPid in (select min(CPid)  from CalendarioPagos
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
									and CPmes = #rsCalendario.CPmes#
									and CPperiodo = #rsCalendario.CPperiodo#
									and Tcodigo = '#arguments.Tcodigo#'
									and CPtipo = 0)
				</cfquery>
				
				<cf_dump var="#rsCalendario#">
				<cfabort>
				
				<cfif rsComisionesPagadas.recordcount GT 0 >
				
					<!--- ljimenez Inserta monto base de comisionistas 	--->
					
					<cfquery datasource="#arguments.conexion#" name="lejs">
						insert into IncidenciasCalculo( RCNid, DEid, CIid, Iid, 
														ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
														ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, RHSPEid )
						select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
								a.DEid, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalariobase#">,
								null,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPdesde#">, 
								RHCMmontobase * (Select CInegativo 
													from CIncidentes 
													Where CIid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalariobase#"> ), 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
								0, null, 0.00, RHCMmontobase * (Select CInegativo 
													from CIncidentes 
													Where CIid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalariobase#"> ), null, null
				
						from RHComisionMonge a, CalendarioPagos cp, SalarioEmpleado se 
						where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComisionesPagadas.CPid#">
						  and cp.CPid = a.CPid
						  <cfif arguments.pDEid GT 0>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
						  </cfif>
						  and se.DEid = a.DEid
						  and RHCMmontobase != 0
					</cfquery>	
					
					
					<!--- JCG Inserta comisiones que fueron distribuidas en varios tractos 	--->
					<cfquery datasource="#arguments.conexion#">
						insert into IncidenciasCalculo (
							RCNid, DEid, CIid, Iid, 
							ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
							ICcalculo, ICbatch, ICmontoant, ICmontores)
						select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
							a.DEid, b.CIid, null,
							cp.CPdesde, 
							b.RHCMmontocomision  / 2, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
							0, null, 0.00, 0.00
						from RHComisionMonge a, RHComisionMongeD b, CalendarioPagos cp, SalarioEmpleado se
						where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComisionesPagadas.CPid#">
						  and b.CPid = a.CPid
						  and b.DEid = a.DEid
						  and cp.CPid = a.CPid
						  <cfif arguments.pDEid GT 0>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
						  </cfif>
						  and se.DEid = a.DEid
						  and b.RHCMmontocomision != 0
						  and a.RHCMajuste = 0
						  and a.RHCMsalario != 0
						  	and a.RHCMcomisionsegunda  = (select (sum(RHCMmontocomision) / 2) from RHComisionMongeD x
						  										where a.DEid = x.DEid
						  										and a.CPid = x.CPid )
					</cfquery>
					
					<!--- JCG Inserta los ajustes que fueron distribuidas en varios tractos 	--->
					<cfquery datasource="#arguments.conexion#">
						insert into IncidenciasCalculo(	RCNid, DEid, CIid, Iid, 
														ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
														ICcalculo, ICbatch, ICmontoant, ICmontores)
						select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
								a.DEid, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalarioajuste#">, 
								null,
								cp.CPdesde, RHCMajuste, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
								0, null, 0.00, 0.00
				
						from RHComisionMonge a, CalendarioPagos cp, SalarioEmpleado se 
				
						where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComisionesPagadas.CPid#">
						  and cp.CPid = a.CPid
						  <cfif arguments.pDEid GT 0>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
						  </cfif>
							  and se.DEid = a.DEid
						  and RHCMajuste != 0
					</cfquery>	

				</cfif>
			</cfif>
		<cfreturn>
	</cfif>

	<cfif len(trim(vpcisalariorebajo)) is 0 or len(trim(vpcisalariobase)) is 0 or len(trim(vpcisalarioajuste)) is 0 or len(trim(vpcisalariorebajoant)) is 0>
		<cfreturn >
	</cfif>
	
		<!--- Borra las incidencias de las comisiones y sus respectivos ajustes --->
		<!--- Funciona en SqlServer, necesario para ORACLE??(aqui no funca, la pregunta es como pasar esto a oracle ) --->
		
		<cfquery datasource="#arguments.conexion#">
			delete from IncidenciasCalculo 
			from RHComisionMonge c, RHComisionMongeD cd
			where cd.CPid = c.CPid
			  and cd.DEid = c.DEid
			  and IncidenciasCalculo.RCNid = cd.CPid
			  and IncidenciasCalculo.DEid = cd.DEid
			  and cd.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			
			  <cfif arguments.pDEid GT 0>
				and cd.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
			  </cfif>
	
			  and (IncidenciasCalculo.CIid = cd.CIid 
				or IncidenciasCalculo.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalariorebajo#"> 
				or IncidenciasCalculo.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalariobase#">  
				or IncidenciasCalculo.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalarioajuste#"> )
		</cfquery>
	
		<!--- Coloca todos los valores a calcular en 0.00 para evitar que se mantengan valores de calculos anteriores --->
		<cfquery datasource="#arguments.conexion#">
			update RHComisionMonge 
			set RHCMcomision = 0, 
				RHCMcomisionsegunda = 0, 
				RHCMajuste = 0, 
				RHCMajustesegunda = 0
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  <cfif arguments.pDEid GT 0>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
			  </cfif>
		</cfquery>
		
		<!--- 1. Actualizar las comisiones del detalle del archivo --->
		<cfquery datasource="#arguments.conexion#">
			update RHComisionMonge
			set RHCMmontocomision = coalesce ( ( select sum(RHCMmontocomision)
											from RHComisionMongeD cd
											where cd.CPid = RHComisionMonge.CPid
											  and cd.DEid = RHComisionMonge.DEid) , 0.00 )
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  <cfif arguments.pDEid GT 0>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
			  </cfif>
		</cfquery>

		
		<!--- 3.3  Salario devengado en esta nomina (se toma de pagos empleado pues aun no se ha actualizado SalarioEmpleado) --->
		<cfquery datasource="#arguments.conexion#">
			update RHComisionMonge
			set RHCMsalario =  coalesce ( (	select sum(b.PEmontores)
												from PagosEmpleado b 
												where b.DEid = RHComisionMonge.DEid
												  and b.RCNid = RHComisionMonge.CPid
												  and PEtiporeg = 0
											), 0.00)
			where RHComisionMonge.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and RHCMmontocomision > 0.00
			  <cfif arguments.pDEid GT 0>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
			  </cfif>
		</cfquery>
		
		
		<!---JCG 2) Establece el monto de COMISIÓN cuando sí se alcanzó el mínimo comisionable --->
	
			<cfquery name="distribuye" datasource="#session.dsn#">
				update RHComisionMonge 
				set RHCMcomision = RHCMmontocomision
				where RHCMmontocomision >= RHCMminimo
			</cfquery>
			
 		<!---JCG 3) Establece el monto de AJUSTE cuando no se alcanzó el mínimo comisionable --->
	
			<cfquery name="distribuye" datasource="#session.dsn#">
				update RHComisionMonge 
				set RHCMajuste = RHCMminimo
				where RHCMmontocomision < RHCMminimo
			</cfquery>
			
		<!---JCG 2.  Si el empleado tiene salario y además gana comisión, se le distribuye mitad y mitad la comisión o el ajuste	--->
		<!---JCG 2.1 Se actualiza la comisión para pagar la midad en cada quincena --->

			<cfquery name="distribuye_comision" datasource="#session.dsn#">
				update RHComisionMonge
				set RHCMcomision  =  RHCMcomision / 2
					, RHCMcomisionsegunda  = RHCMcomision / 2
				where RHCMsalario != 0
				and RHCMcomision  != 0
				and RHCMcomisionsegunda  = 0
				and RHCMajuste  = 0
			</cfquery>
			
		<!---JCG 2.2 Se actualiza el ajuste para pagar la midad en cada quincena --->

			<cfquery name="distribuye_comision" datasource="#session.dsn#">
				update RHComisionMonge
				set RHCMajuste  =  RHCMajuste / 2
					, RHCMajustesegunda  = RHCMajuste / 2
				where RHCMsalario != 0
				and RHCMajustesegunda  = 0
				and RHCMajuste  != 0
			</cfquery>	
 

			<cfif vcomisionSB  EQ 1>
								
					<!--- 6.0 Inserta en la tabla de Incidencias Cálculo (nómina actual) --->
					
					<!--- 6.1 Inserta los montos de comisiones, Para aquellos que superaron el mínimo y no ganan salario --->
					
					<cfquery datasource="#arguments.conexion#">
						insert into IncidenciasCalculo (
							RCNid, DEid, CIid, Iid, 
							ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
							ICcalculo, ICbatch, ICmontoant, ICmontores)
						select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
							a.DEid, b.CIid, null,
							cp.CPdesde, b.RHCMmontocomision, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
							0, null, 0.00, 0.00
						from RHComisionMonge a, RHComisionMongeD b, CalendarioPagos cp, SalarioEmpleado se
						where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and b.CPid = a.CPid
						  and b.DEid = a.DEid
						  and cp.CPid = a.CPid
						  <cfif arguments.pDEid GT 0>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
						  </cfif>
						  and se.DEid = a.DEid
						  and se.RCNid = a.CPid
						  and b.RHCMmontocomision != 0
						  and a.RHCMajuste = 0
						  and a.RHCMsalario = 0
					</cfquery>	

					<!--- 6.2 Inserta los montos de comisiones, Para aquellos que superaron el mínimo y SÍ ganan salario --->
					
					<cfquery datasource="#arguments.conexion#">
						insert into IncidenciasCalculo (
							RCNid, DEid, CIid, Iid, 
							ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
							ICcalculo, ICbatch, ICmontoant, ICmontores)
						select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
							a.DEid, b.CIid, null,
							cp.CPdesde, 
							b.RHCMmontocomision  / 2, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
							0, null, 0.00, 0.00
						from RHComisionMonge a, RHComisionMongeD b, CalendarioPagos cp, SalarioEmpleado se
						where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and b.CPid = a.CPid
						  and b.DEid = a.DEid
						  and cp.CPid = a.CPid
						  <cfif arguments.pDEid GT 0>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
						  </cfif>
						  and se.DEid = a.DEid
						  and se.RCNid = a.CPid
						  and b.RHCMmontocomision != 0
						  and a.RHCMajuste = 0
						  and a.RHCMsalario != 0
						  	and a.RHCMcomision  = (select (sum(RHCMmontocomision) / 2) from RHComisionMongeD x
						  										where a.DEid = x.DEid
						  										and a.CPid = x.CPid )
					</cfquery>
					
					<!--- 6.5   Insertar los ajustes cuando apliquen --->
					<cfquery datasource="#arguments.conexion#">
						insert into IncidenciasCalculo(	RCNid, DEid, CIid, Iid, 
														ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, 
														ICcalculo, ICbatch, ICmontoant, ICmontores)
						select 	a.CPid, a.DEid, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#vpcisalarioajuste#">, 
								null,
								cp.CPdesde, RHCMajuste, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
								0, null, 0.00, 0.00
				
						from RHComisionMonge a, CalendarioPagos cp, SalarioEmpleado se 
				
						where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and cp.CPid = a.CPid
						  <cfif arguments.pDEid GT 0>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
						  </cfif>
							  and se.DEid = a.DEid
						  and se.RCNid = a.CPid
						  and RHCMajuste != 0
					</cfquery>	
			</cfif>	
			
		<cfreturn>	
	</cffunction>
</cfcomponent>
