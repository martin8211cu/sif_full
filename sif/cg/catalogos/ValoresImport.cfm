<cf_templateheader title="Importador de Valores para Catalogo de Plan de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Valores">			<cfinclude template="../../portlets/pNavegacion.cfm">
            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                <tr>
                    <td valign="top" width="50%">
	                    <cf_sifFormatoArchivoImpr EIcodigo="PC_CATALOGOS">
                    </td>
                    <td align="center" style="padding-left: 15px " valign="top">
                	    <cf_sifimportar EIcodigo="PC_CATALOGOS" mode="in" />
                    </td>
				</tr>
                <tr>
                    <td colspan="2" align="center">
	                    <input type="button" name="Regresar" value="Regresar" onClick="javascript: location.href = 'ValoresImport.cfm';">
                    </td>
                </tr>
                <tr><td colspan="2" align="center">&nbsp;</td></tr>
            </table>
		<cf_web_portlet_end>
<cf_templatefooter>



