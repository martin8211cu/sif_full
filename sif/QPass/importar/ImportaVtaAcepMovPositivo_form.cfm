<cf_templateheader title=" Importaci&oacute;n Aceptación Ventas Movimientos Positivos (contingente)">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n Aceptación Ventas Movimientos Positivos (contingente)">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
            	<td colspan="3" align="center">&nbsp;</td></tr>
			<tr>
                <td align="center" width="2%">&nbsp;</td>
                <td align="center" valign="top" width="55%">
	                <cf_sifFormatoArchivoImpr EIcodigo = 'QPACTAVENPOS' tabindex="1">
                </td>
                <td align="center" style="padding-left: 15px " valign="top">
	                <cf_sifimportar EIcodigo="QPACTAVENPOS" mode="in"  tabindex="1">
                </td>
			</tr>
            <tr>
                <td colspan="2" align="center">
                    <cfoutput>
                        <input type="button" name="Regresar" value="Regresar" onClick="javascript: location.href = '../MenuQPass.cfm'">
                    </cfoutput>
                </td>
            </tr>
			<tr><td colspan="3" align="center">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
