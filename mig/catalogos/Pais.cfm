<cf_templateheader title="Pa&iacute;s">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pa&iacute;s'>
	<cfif  (isdefined('form.MIGPaid') and len(trim(form.MIGPaid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGPaid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="PaisForm.cfm">
	<cfelse>
		<cfinclude template="PaisLista.cfm">
	</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>