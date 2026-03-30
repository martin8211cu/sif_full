<cf_dbfunction name="to_char" args="cs.RHCSmes" returnvariable="to_char_RHCSmes">
<cfif isdefined("BTNCERRAR_MES")>
	<!---************************************************************************--->
	<!---****** OJO SI SE TOCA ESTA CONSULTA REPLICAR EL CAMBIO EN EL FORM ******--->
	<cfquery name="rsFirsOpenMonth" datasource="#session.dsn#" maxrows="1">
		select distinct RHCSperiodo as Periodo, RHCSmes as MesInt, VSdesc as Mes
		from RHCesantiaSaldos cs, DatosEmpleado de, VSidioma vs, Idiomas i
		where cs.RHCScerrado = 0
			and de.DEid = cs.DEid
			and de.Ecodigo = #Session.Ecodigo#
			and vs.VSgrupo = 1
			and vs.VSvalor = #to_char_RHCSmes#
			and i.Iid = vs.Iid
			and i.Icodigo = '#session.idioma#'
		order by 1,2
	</cfquery>
	<!---****** OJO SI SE TOCA ESTA CONSULTA REPLICAR EL CAMBIO EN EL FORM ******--->
	<!---************************************************************************--->
	
	<cfinvoke component="rh.Componentes.RH_Cesantia" method="CierreMes">
		<cfinvokeargument name="ActualPeriod" 	value="#rsFirsOpenMonth.Periodo#" >
		<cfinvokeargument name="ActualMonth" 	value="#rsFirsOpenMonth.MesInt#" >
	</cfinvoke> 
	
<cfelseif isdefined("BTNRECALCULAR_DESDE")>
	<cfquery name="rsMonthsToReproc" datasource="#session.dsn#">
		select distinct RHCSperiodo as Periodo, RHCSmes as MesInt, VSdesc as Mes
		from RHCesantiaSaldos cs, DatosEmpleado de, VSidioma vs, Idiomas i
		where cs.RHCScerrado = 1
			and de.DEid = cs.DEid
			and de.Ecodigo = #Session.Ecodigo#
			and vs.VSgrupo = 1
			and vs.VSvalor = #to_char_RHCSmes#
			and i.Iid = vs.Iid
			and i.Icodigo = '#session.idioma#'
			<cfif isdefined("Form.DEid") and len(trim(Form.DEid)) GT 0>
				and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfif>
			and cs.RHCSperiodo * 100 + cs.RHCSmes
			>= <cfqueryparam cfsqltype="cf_sql_numeric" value="#abs(Form.Filtro_Periodo*100+Form.Filtro_Mes)#">
			<!--- La idea es que si vienen ambos en -1 todos los regs se reprocesan --->
		order by 1,2
	</cfquery>
	<cfloop query="rsMonthsToReproc">
		<cfif len(trim(Form.DEid)) eq 0><cfset Form.DEid = -1></cfif>		
		<cfinvoke component="rh.Componentes.RH_Cesantia" method="CierreMes">
			<cfinvokeargument name="ActualPeriod" 	value="#rsMonthsToReproc.Periodo#" >
			<cfinvokeargument name="ActualMonth" 	value="#rsMonthsToReproc.MesInt#" >
			<cfinvokeargument name="DEid" 			value="#Form.DEid#" >
			<cfinvokeargument name="Reproc" 		value="true" >
		</cfinvoke> 
	</cfloop>
</cfif>
<cflocation url="CaculoInteresesCesantia.cfm">