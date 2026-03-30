<!---  --->
<cf_templateheader title="Compras - Compradores ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Compradores'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="../../portlets/pNavegacionCM.cfm">
					</td>
				</tr>
				<tr>
					<td valign="top">
						<cfinclude template="ArbolComprad.cfm">
					</td>
					<td width="60%" valign="top">
						<cfinclude template="Compradores-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>