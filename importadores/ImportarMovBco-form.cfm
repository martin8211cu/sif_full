<cf_templateheader title="Importaci&oacute;n de Movimientos Bancarios">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Movimentos Bancarios">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'MOVBANC'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="MOVBANC" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Ir a Registro de Movimentos" value="Ir a Registro de Movimentos" onClick="javascript:location.href='/cfmx/sif/mb/operacion/Movimientos.cfm'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<!---'/cfmx/sif/mb/operacion/Movimientos.cfm'--->