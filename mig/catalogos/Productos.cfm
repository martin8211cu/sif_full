<cf_templateheader title="Catalogo Productos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catalogo Productos'>
		<cfif  (isdefined('form.MIGProid') and len(trim(form.MIGProid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGProid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="ProductosForm.cfm">
		<cfelse>
			<cfinclude template="ProductosLista.cfm">
		</cfif>
		<cfif isdefined ('form.Importar')>
			<cflocation url="ProductosImportador.cfm">
		</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>