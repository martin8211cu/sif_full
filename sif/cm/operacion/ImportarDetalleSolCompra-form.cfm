<cf_templateheader title="Importaci&oacute;n de Detalle Solicitud de Compra">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n Detalle Solicitud de Compra">
    <cfset idSC=Session.ImportarDetalleSC.idSol>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'DET_SC'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="DET_SC" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='solicitudes.cfm'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
	<cf_web_portlet_end>
<cf_templatefooter>