<cf_templateheader title="Reportes de Saldos de Control de Presupuesto">
	<cf_web_portlet_start titulo="Reportes de Saldos de Control de Presupuesto">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
	
		<cfinclude template="rptSaldos_nuevos.cfm">
	
		<!--- <cfset pantalla = 1> --->
		<cfif isdefined("url.CPRid")>
			<cfset form.CPRid = url.CPRid>
		</cfif>
		<cfif isdefined("form.CPRid") and form.CPRid NEQ "">
			<cfinclude template="rptSaldos_filtros.cfm">
		<cfelseif isdefined("url.Verificar")>
			<cfinclude template="rptSaldos_verificaClasif.cfm">
		<cfelse>
			<cfinclude template="rptSaldos_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>