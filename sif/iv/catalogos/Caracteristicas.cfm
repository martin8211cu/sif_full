<cf_templateheader title="Inventarios">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Caracter&iacute;sticas de Art&iacute;culos'>
			<cfinclude template="../../portlets/pNavegacionIV.cfm">
			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
				<cfinclude template="paramURL-FORM.cfm">

				<tr><td>&nbsp;</td></tr>
				<tr><td><cfinclude template="articulos-link.cfm"> </td></tr>

				<tr> 
					<td valign="top" width="65%">
						<cfinclude template="formCaracteristicas.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>