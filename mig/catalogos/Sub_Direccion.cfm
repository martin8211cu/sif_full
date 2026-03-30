<cf_templateheader title="Sub_Direcci&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Sub_Direcci&oacute;n'>
	<cfif  (isdefined('form.MIGSDid') and len(trim(form.MIGSDid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGSDid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="Sub_DireccionForm.cfm">
	<cfelse>
		<cfinclude template="Sub_DireccionLista.cfm">
	</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>