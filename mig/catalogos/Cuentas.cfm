<cf_templateheader title="Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas'>
		<cfif  (isdefined('form.MIGCueid') and len(trim(form.MIGCueid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGCueid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="CuentasForm.cfm">
		<cfelse>
			<cfinclude template="CuentasLista.cfm">
		</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>


