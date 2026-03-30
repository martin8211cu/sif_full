<cf_templateheader title="Importaci&oacute;n de Documentos de Cuentas por Pagar">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n Masiva de Polizas">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'CARGAREM'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="CARGAREM" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Ir a Registro de Remisiones" value="Ir a Registro de Remisiones" onClick="javascript:location.href='/cfmx/sif/cp/operacion/remisiones/RegistroRemisiones.cfm'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
	<cf_web_portlet_end>
<cf_templatefooter>