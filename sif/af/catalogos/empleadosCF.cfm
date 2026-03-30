<!--- Definición de Parámetros --->
<cfset CFidIni = "-1">
<cfset CFidFin = "-1">
<cfif isDefined("url.CFidIni") and not isDefined("form.CFidIni")>
	<cfset CFidIni = url.CFidIni>
</cfif>
<cfif isDefined("url.CFidFin") and not isDefined("form.CFidFin")>
	<cfset CFidFin = url.CFidFin>
</cfif>
<cfif isDefined("form.CFidIni") and not isDefined("url.CFidIni")>
	<cfset CFidIni = form.CFidIni>
</cfif>
<cfif isDefined("form.CFidFin") and not isDefined("url.CFidFin")>
	<cfset CFidFin = form.CFidFin>
</cfif>

<!--- Filtros para la Consulta de Centros Funcionales --->
<cfif CFidIni neq -1 and len(trim(CFidIni))>
	<cfquery name="rsCFuncionalIni" datasource="#Session.DSN#">
		select
			CFidIni = CFid,
			CFcodigoIni = CFcodigo,
			CFdescripcionIni = CFdescripcion
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		  and CFid = #CFidIni#
	</cfquery>
</cfif>

<cfif CFidFin neq -1 and len(trim(CFidFin))>
	<cfquery name="rsCFuncionalFin" datasource="#Session.DSN#">
		select
			CFidFin = CFid,
			CFcodigoFin = CFcodigo,
			CFdescripcionFin = CFdescripcion
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		  and CFid = #CFidFin#
	</cfquery>
</cfif>

<cf_templateheader title="Responsables de Activos">
		<cf_web_portlet_start titulo="Responsables de Activos">
			<!--- Lista de Empleados por Centro Funcional --->
			<cfinclude template="empleadosCF-lista.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>