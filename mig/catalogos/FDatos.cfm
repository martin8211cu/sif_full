<cf_templateheader title="Datos Variables">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Datos Variables'>
		<cfif (isdefined ('form.MIGMid') and len(trim(form.MIGMid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGMid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="FDatosForm.cfm">
		<cfelse>
			<cfinclude template="FDatosLista.cfm">
		</cfif>
		<cfif isdefined ('form.Importar')>
			<cflocation url="FDatosImportador.cfm">
		</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>
