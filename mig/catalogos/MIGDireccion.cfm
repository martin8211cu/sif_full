<cf_templateheader title="Direcci&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Direcci&oacute;n'>
	<cfif  (isdefined('form.MIGDid') and len(trim(form.MIGDid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGDid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="MIGDireccionform.cfm">
	<cfelse>
		<cfinclude template="MIGDireccionLista.cfm">
	</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>