<cf_templateheader title="Tipo de Convenio">
	<cf_web_portlet_start border="true" titulo="Tipo de Convenio" skin="#Session.Preferences.Skin#">
		<table width="100%">
			 <tr>
				<td valign="top">
				<cfif isdefined('url.QPvtaConvid') and len(trim(url.QPvtaConvid)) gt 0>
					<cfset form.QPvtaConvid=#url.QPvtaConvid#>
				</cfif>
				<cfif (isdefined('form.QPvtaConvid') and len(trim(form.QPvtaConvid)) and not isdefined ('form.Regresar')) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))>
					<cfinclude template="QPassConvenio_form.cfm">
				<cfelse>
					<cfinclude template="QPassConvenio_lista.cfm">				
				</cfif>
				</td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>








