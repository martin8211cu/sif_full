<cf_templateheader title="Mantenimiento de Tesorería">
	<cfset titulo = 'Control de Bloques de Formularios por Cuenta Bancaria y Medio de Pago'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="90%" align="center" border="0">
			<tr>
				<td valign="top" width="50%">
					<BR>
					<form name="frmTES" style="margin:0;" method="post">
						<strong>Tesorería:</strong>
						<cf_cboTESid tipo="" onChange="document.frmTES.submit();" tabindex="1">
					</form>
					<BR>
				</td>
				<td valign="top" colspan="2" width="50%">&nbsp;
				</td>
			</tr>
			<tr>
				<td valign="top" align="left">
					<cfinclude template="controlFormulariosT_lista.cfm">
				</td>
				<td>&nbsp;</td>
				<td valign="top">
					<cfinclude template="controlFormulariosT_form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>