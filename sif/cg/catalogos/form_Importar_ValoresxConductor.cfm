<cf_templateheader title="Importador de Valores por Conductor">
	<cf_web_portlet_start titulo="Importador de Valores por Conductores">
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="50%">
		<cf_sifFormatoArchivoImpr EIcodigo="CG_CONDVL">
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="CG_CONDVL" mode="in" />
	</td>
  </tr>
  <tr>
    <td colspan="2" align="center">
		<cfoutput>
            <input type="button" name="Regresar" value="Regresar" onClick="javascript: location.href = 'Valor_Conductor_form.cfm?CGCid=#url.CGCid#&smes=#url.smes#&speriodo=#url.speriodo#'">
        </cfoutput>
    </td>
  </tr>
  <tr><td colspan="2" align="center">&nbsp;</td></tr>
</table>

	<cf_web_portlet_end>
<cf_templatefooter>