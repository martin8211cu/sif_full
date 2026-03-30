<cf_templateheader title="Entrega y Recepci&oacute;n de Documentos y Efectivo">
	<cf_navegacion name="form.CCHTCid" navegacion="">
		<cfset titulo = 'Entrega y Recepci&oacute;n de Documentos y Efectivo'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="100%">
			 <tr>
				<td valign="top">
				<cfif isdefined("form.btnAplicar")or isdefined ("form.btnConfirmar")>
					<cfinclude template="TransaccionCustodiaP_sql.cfm">
				<cfelseif isdefined('form.CCHTCid') and len(trim(form.CCHTCid)) or isdefined('form.GELid') and len(trim(form.GELid))  or isdefined ('url.GELid')or isdefined('form.GEAid') and len(trim(form.GEAid))  or isdefined ('url.GEAid') <!---or isdefined('form.id') and len(trim(form.id))--->>
					<cfinclude template="TransaccionCustodiaP_form.cfm">
				<cfelse>
					<cfinclude template="TransaccionCustodiaP_lista.cfm">				
				</cfif>
				</td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>


