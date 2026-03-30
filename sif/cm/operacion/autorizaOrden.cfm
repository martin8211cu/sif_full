<cf_templateheader title="Autorizaci&oacute;n de Ordenes de Compra">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Solicitudes de Compra'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><cfinclude template="autorizaOrden-form.cfm"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>