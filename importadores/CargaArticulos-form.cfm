<cf_templateheader title="Importaci&oacute;n de Artículos y Existencias Inventario">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Artículos y Existencias Inventario">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'CARGAART'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="CARGAART" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Ir a Ajustes de Inventario" value="Ir a Ajustes de Inventario" onClick="javascript:location.href='/cfmx/sif/iv/operacion/Ajustes-lista.cfm'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
	<cf_web_portlet_end>
<cf_templatefooter>