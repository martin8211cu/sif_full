<cfif isdefined('url.debug')>
	<cfset session.debug = true>
<cfelse>	
	<cfset session.debug = false>
</cfif>
<cf_templateheader title="M&eacute;tricas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='M&eacute;tricas'>
		<cfif (isdefined ('form.MIGMid') and len(trim(form.MIGMid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGMid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="MetricasForm.cfm">
		<cfelse>
			<cfinclude template="MetricasLista.cfm">
		</cfif>
		<cfif isdefined ('form.Importar')>
			<cflocation url="MetricasImportador.cfm">
		</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>
