<cf_templateheader title="Cuentas por Cobrar"> 
		
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
					titulo='Categorías de Socios de Negocios'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3" valign="top"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
					<tr valign="top"> 
						<td valign="top" width="40%"> 
							<cfinclude template="ArbolCategorias.cfm">
						</td>
						<td valign="top" width="5%">&nbsp;</td>
						<td width="50%" valign="top" ><cfinclude template="formCategoriaSNegocios.cfm"></td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
	<cf_templatefooter>