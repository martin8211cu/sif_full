<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start border="true" titulo="Causas">
		<table width="100%">
			 <tr>
				<td valign="top">
				<cfif isdefined('url.QPCid') and len(trim(url.QPCid)) gt 0>
					<cfset form.QPCid=#url.QPCid#>
				</cfif>
				<cfif (isdefined('form.QPCid') and len(trim(form.QPCid)) and not isdefined ('form.Regresar')) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))>
					<cfinclude template="QPassRubros_form.cfm">
				<cfelse>
					<cfinclude template="QPassRubros_lista.cfm">				
				</cfif>
				</td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>
