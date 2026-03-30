<cf_templateheader title="Regi&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Regi&oacute;n'>
	<cfif  (isdefined('form.MIGRid') and len(trim(form.MIGRid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGRid'))OR (isdefined('url.Nuevo'))>
		<cfinclude template="RegionForm.cfm">
	<cfelse>
		<cfinclude template="RegionLista.cfm">
	</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>