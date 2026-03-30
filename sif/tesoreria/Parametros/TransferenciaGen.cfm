<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinclude template="TransferenciaGen_ini.cfm">
<cf_templateheader title="Parametros para Generación de Transferencias Electrónicas">
	<cf_web_portlet_start titulo="Parametros para Generación de Transferencias Electrónicas">
		<table width="90%" align="center" border="0">
			<tr>
				<td valign="top" width="50%">
					<cfinclude template="TransferenciaGen_list.cfm">
				</td>
				<td valign="top" width="50%">
				<cfif isdefined("form.TESTGid") AND form.TESTGid NEQ "">
					<cfinclude template="TransferenciaGen_form.cfm">
				</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	
