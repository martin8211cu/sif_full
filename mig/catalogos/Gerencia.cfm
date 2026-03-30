<cf_templateheader title="Gerencia">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Gerencia'>
	<cfif  (isdefined('form.MIGGid') and len(trim(form.MIGGid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGGid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="GerenciaForm.cfm">
	<cfelse>
		<cfinclude template="GerenciaLista.cfm">
	</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>