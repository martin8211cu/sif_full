<cf_templateheader title="Control Estaciones de Combustible">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consolidado Ventas Diarias por Estaci&oacute;n'>
				<cfinclude template="/sif/portlets/pNavegacionGAS.cfm">
				<br>			
				<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="center">
							<cfinclude template="consolidadoVentas-form.cfm">
						</td>
					</tr>
				</table>
			<br>
		<cf_web_portlet_end>
	<cf_templatefooter>