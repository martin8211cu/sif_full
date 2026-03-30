<cf_templateheader title="Ordenes de Compra Rechazadas">
	<cf_web_portlet_start titulo="Ordenes de Compra Rechazadas">
		<cfinclude template="/sif/portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="ordenCompra-filtroglobal.cfm">
					<cfinclude template="ordenCompraRechazada-lista.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>