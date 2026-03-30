<cfif isdefined("url.chkNuevas")>
	<cfset session.chkNuevas = (url.chkNuevas EQ "1")>
	<cfabort>
</cfif>
<cfif isdefined("url.chkMesesAnt")>
	<cfset session.chkMesesAnt = (url.chkMesesAnt EQ "1")>
	<cfabort>
</cfif>

<cf_templateheader title="Importación de una Formulación Presupuestaria en una Version de Presupuesto">
	<cf_web_portlet_start titulo="Importación de una Formulación Presupuestaria">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="versiones_config.cfm">
		
		<!--- <cfset pantalla = 1> --->
		
		<cfif isdefined("form.CVid")>
			<cfset session.CVid = form.CVid>
			<cfinclude template="importacion_script.cfm">
		<cfelse>
			<cfinclude template="importacion_lista.cfm">
		</cfif>
		
	<cf_web_portlet_end>
<cf_templatefooter>