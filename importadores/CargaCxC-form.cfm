<cf_templateheader title="Importaci&oacute;n de Documentos de Cuentas por Cobrar ">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n Masiva de Polizas">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'CARGACXC'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="CARGACXC" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Ir a Registro de Facturas" value="Ir a Registro de Facturas" onClick="javascript:location.href='/cfmx/sif/cc/operacion/listaDocumentosCC.cfm?sqlDone=ok&tipo=C'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
	<cf_web_portlet_end>
<cf_templatefooter>