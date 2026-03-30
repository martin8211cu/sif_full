<cf_templateheader title="&Aacute;rea">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&Aacute;rea'>
	<cfif  (isdefined('form.MIGArid') and len(trim(form.MIGArid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGArid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="AreaForm.cfm">
	<cfelse>
		<cfinclude template="AreaLista.cfm">
	</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>