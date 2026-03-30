<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de activos'>
			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr> 
					<td valign="top" width="35%">
						<cfinclude template="arboltipoactivo.cfm">
					</td>
					<td valign="top" width="65%">
						<cfinclude template="formTipoactivo.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>