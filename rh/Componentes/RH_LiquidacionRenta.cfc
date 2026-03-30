
<cfcomponent>
	<!---	RESULTADO:
			Devuelve informacion necesaria y relacionada al empleado y la nomina:
				* Tipo de Nomina
				* fecha del cese
				* periodo del cese
				* mes del cese
	--->
	<cffunction name="obtener_DatosCese" access="package" output="true" returntype="struct" >
		<cfargument name="DEid" 	type="numeric" 	required="yes">
		<cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">

		<cfset struct_datos_cese = structnew() >
		<cfset struct_datos_cese.tcodigo 	= '' >
		<cfset struct_datos_cese.fecha_cese = '01/01/6100' >
		<cfset struct_datos_cese.periodo 	= 0 >
		<cfset struct_datos_cese.mes 		= 0 >

		<cfquery name="rs_datos_cese" datasource="#arguments.conexion#">
			select da.Tcodigo,
				   da.DLfvigencia,
				   da.DLfvigencia as fecha_cese,
				(	select max(CPperiodo)
					from CalendarioPagos
					where da.DLfvigencia between CPdesde and CPhasta
					and Tcodigo=da.Tcodigo
					and Ecodigo=da.Ecodigo ) as periodo,
				(	select max(CPmes)
					from CalendarioPagos
					where da.DLfvigencia between CPdesde and CPhasta
					and Tcodigo=da.Tcodigo
					and Ecodigo=da.Ecodigo ) as mes
			from DLaboralesEmpleado da, RHTipoAccion ta
			where da.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and ta.RHTid = da.RHTid
			and ta.RHTcomportam = 2
			and da.DLfvigencia = ( 	select max(dle.DLfvigencia)
									from DLaboralesEmpleado dle, RHTipoAccion ta1
									where dle.DEid = da.DEid
									  and dle.RHTid = ta1.RHTid
									  and ta1.RHTcomportam = 2 )
		</cfquery>

		<cfset struct_datos_cese.tcodigo 	= rs_datos_cese.Tcodigo >
		<cfset struct_datos_cese.fecha_cese = LSDateFormat(rs_datos_cese.fecha_cese, 'dd/mm/yyyy') >

		<cfif len(trim(rs_datos_cese.periodo)) >
			<cfset struct_datos_cese.periodo 	= rs_datos_cese.periodo >
		</cfif>
		<cfif len(trim(rs_datos_cese.periodo)) >
			<cfset struct_datos_cese.mes 		= rs_datos_cese.mes >
		</cfif>

		<cfreturn struct_datos_cese >
	</cffunction>

	<!---	RESULTADO:
			Devuelve el salario total recibido por el empleado para el periodo/mes de cese
			Ademas devuelve el monto total de renta que pago para el periodo/mes de cese
	--->
	<cffunction name="obtener_SalarioRenta" access="package" output="false" returntype="struct" >
		<cfargument name="DEid" 	type="numeric" 	required="yes">
		<cfargument name="periodo" 	type="numeric" 	required="yes">
		<cfargument name="mes" 		type="numeric" 	required="yes">
		<cfargument name="fecha"	type="string" 	required="yes">
		<cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">

		<!--- Total de salario percibido por el empleado a la fecha de su cese y total de renta pagada segun proyeccion --->
		<cfquery name="rs_salario" datasource="#arguments.conexion#">
			select DEid, coalesce(sum(SEsalariobruto), 0) as monto, sum(SErenta) as renta
			from HSalarioEmpleado hse, CalendarioPagos cp
			where hse.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and cp.CPid = hse.RCNid
			and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
			and cp.CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha)#">
			group by DEid
		</cfquery>

		<!--- incidencias pagadas al empleado --->
		<cfquery name="rs_incidencias" datasource="#arguments.conexion#">
			select coalesce(sum(ICvalor), 0) as monto
			from HIncidenciasCalculo hic, CIncidentes ci, HSalarioEmpleado hse, CalendarioPagos cp
			where hic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			   and hse.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			   and ci.CInorenta = 0
			   and ci.CIid = hic.CIid
			   and hse.RCNid = hic.RCNid
			   and hse.DEid = hic.DEid
			   and cp.CPid = hse.RCNid
			   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.periodo#">
			   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mes#">
		</cfquery>

		<cfset struct_datos_salario = structnew() >
		rs_incidencias.monto
		<cfset v_salario_monto = 0 >
		<cfif len(trim(rs_salario.monto)) >
			<cfset v_salario_monto = rs_salario.monto >
		</cfif>
		<cfset v_incidencias_monto = 0 >
		<cfif len(trim(rs_incidencias.monto)) >
			<cfset v_incidencias_monto = rs_incidencias.monto >
		</cfif>
		<cfset v_salario_renta = 0 >
		<cfif len(trim(rs_salario.renta)) >
			<cfset v_salario_renta = rs_salario.renta >
		</cfif>

		<cfset struct_datos_salario.salario = v_salario_monto + v_incidencias_monto >
		<cfset struct_datos_salario.renta = v_salario_renta >

		<cfreturn struct_datos_salario >
	</cffunction>

	<!---	RESULTADO:
			Devuelve el monto total de renta que debe pagar el empleado hasta su fecha de cese
			para el periodo/mes del cese.
	--->
	<cffunction name="obtener_Renta" access="package" output="false" returntype="string" >
		<cfargument name="monto"	type="string" 	required="yes">
		<cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo"  type="string" 	required="no" default="#Session.Ecodigo#">

		<cfquery name="rs_parametro35" datasource="#arguments.conexion#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 35
		</cfquery>

		<!--- cual tabla de renta utilizar, falta sacar el salario y hacer los calculos de cuanto se paga --->
		<cfquery name="rs_monto_renta" datasource="#arguments.conexion#">
			select coalesce( round(((<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.monto#"> - dir.DIRinf ) * (dir.DIRporcentaje / 100)) + dir.DIRmontofijo,2), 0 ) as renta
			from DImpuestoRenta dir, EImpuestoRenta eir
			where eir.EIRid=dir.EIRid
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between EIRdesde and EIRhasta
			  and eir.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_parametro35.Pvalor#">
			and <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.monto#"> between DIRinf and DIRsup
		</cfquery>

		<cfreturn rs_monto_renta.renta >

	</cffunction>

	<!---	RESULTADO:
			Devuelve el monto total por creditos fiscales asociados al empleado.
			Este monto va a ser restado al monto de renta ya calculado
	--->
	<cffunction name="obtener_CreditoFiscal" access="package" output="false" returntype="string" >
		<cfargument name="DEid"		 type="string" 	required="yes">
		<cfargument name="monto"	 type="string" 	required="yes">
		<cfargument name="fecha_liq" type="string" 	required="yes">
		<cfargument name="conexion"  type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo"   type="string" 	required="no" default="#Session.Ecodigo#">
		<cfquery name="rs_monto_credito_fiscal" datasource="#arguments.conexion#">
			select coalesce(sum(case when d.esporcentaje = 0
					then d.DCDvalor else (<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.monto#"> * d.DCDvalor / 100) end), 0) as monto
			from FEmpleado a, ConceptoDeduc f, EImpuestoRenta e, DConceptoDeduc d
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and a.FEdeducrenta > 0
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedatetime(arguments.fecha_liq)#"> between a.FEdeducdesde and a.FEdeduchasta
			  and a.FEidconcepto = f.CDid
			  and e.IRcodigo = f.IRcodigo
			  and e.EIRestado > 0
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fecha_liq)#"> between e.EIRdesde and e.EIRhasta
			  and d.CDid = f.CDid
			  and d.EIRid = e.EIRid
  		</cfquery>
		<cfreturn rs_monto_credito_fiscal.monto >
	</cffunction>

	<!--- 	RESULTADO:
			Metodo que se encarga de realizar los calculos de la renta real que debe pagar el empleado cesado.
	--->
	<cffunction name="calcular_Renta" access="public" output="true" returntype="string" >
		<cfargument name="DEid"		type="string" 	required="yes">
		<cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo"  type="string" 	required="no" default="#Session.Ecodigo#">

		<!--- 1. Recupera informacion del cese --->
		<cfset struct_datoscese = this.obtener_DatosCese( arguments.DEid ) >

		<!--- 2. Recupera informacion de los salarios obtenidos por el empleado en el periodo/mes en que fue cesado--->
		<cfset struct_salario = this.obtener_SalarioRenta( arguments.DEid, struct_datoscese.periodo, struct_datoscese.mes, struct_datoscese.fecha_cese ) >

		<!--- 3. Calcula la cantidad de renta que debe pagar el empleado en el periodo/mes cesado --->
		<cfset v_renta = this.obtener_Renta( struct_salario.salario ) >

		<!--- 4. Calculo de creditos fiscales --->
		<cfset v_monto_fiscal = this.obtener_CreditoFiscal(arguments.DEid, v_renta, struct_datoscese.fecha_cese ) >
		<cfif len(trim(v_monto_fiscal))>
			<cfset v_renta = v_renta - v_monto_fiscal >
			<cfif v_renta lt 0 >
				<cfset v_renta = 0 >
			</cfif>
		</cfif>

		<!--- 5. comparar lo que debio pagar contra lo que pago de renta, para devolver el exceso pagado --->
		<cfset diferencia = v_renta - struct_salario.renta >

		<cfif diferencia lt 0 >
			<cfreturn diferencia >
		</cfif>

		<cfreturn 0 >
	</cffunction>

</cfcomponent>