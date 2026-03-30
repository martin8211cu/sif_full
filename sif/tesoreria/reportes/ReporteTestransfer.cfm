<cfset titulo = 'Reporte de Transferencias'>
<cf_templateheader title="#titulo#">
<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfif isdefined('url.btnConsultar')>
	    <cfthrow message="ok">
		<cfinclude template="ReporteTestransfer-form.cfm">
	<cfelse>
		<cfinclude template="ReporteTestransfer-filtro.cfm">
	</cfif>
<cf_web_portlet_start _end>
