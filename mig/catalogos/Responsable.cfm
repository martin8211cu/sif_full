<cf_templateheader title="Reponsable">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Responsable'>
		<cfif  (isdefined('form.MIGReid') and len(trim(form.MIGReid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGReid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="ResponsableForm.cfm">
		<cfelse>
			<cfinclude template="ResponsableLista.cfm">
		</cfif>
		<cfif isdefined ('form.Importar')>
			<cflocation url="ResponsableImportador.cfm">
		</cfif>		
	<cf_web_portlet_end>	
<cf_templatefooter>