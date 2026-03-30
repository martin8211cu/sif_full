<cf_templateheader title="Generaci&oacute;n de Embarques por Orden de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generaci&oacute;n de Embarques por Orden de Compra'>
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td align="center">
						<cfinclude template="generarTrackingOC-form.cfm">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
