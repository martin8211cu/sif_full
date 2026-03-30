<cf_templateheader title="Compras - Facturas por Poliza ">
	<cfinclude template="../../portlets/pNavegacion.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Facturas por Póliza'>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
            	<td valign="top"> Lista de Facturas</td>
                <td width="60%">
                    <cfinclude template="FacturasPoliza-form.cfm">
                </td>
            </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>