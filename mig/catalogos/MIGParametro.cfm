<cf_templateheader title="Par&aacute;metros de MIG">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Par&aacute;metros Generales del Modelo'>
	<cfif  (isdefined('form.MIGParid') and len(trim(form.MIGParid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGParid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="MIGParametroForm.cfm">
	<cfelse>
		<cfinclude template="MIGParametroLista.cfm">
	</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>