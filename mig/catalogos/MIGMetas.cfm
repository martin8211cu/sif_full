<cf_templateheader title="Catalogo Metas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catalogo Metas'>
		<cfif  (isdefined('form.MIGMetaid') and len(trim(form.MIGMetaid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGMetaid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="MIGMetasForm.cfm">
		<cfelse>
			<cfinclude template="MIGMetasLista.cfm">
		</cfif>
		<cfif isdefined ('form.Importar')>
			<cflocation url="MIGMetasImportador.cfm">
		</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>