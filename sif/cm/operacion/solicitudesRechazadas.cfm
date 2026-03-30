<cf_templateheader title="Solicitudes de Compra Rechazadas">
		<cf_web_portlet_start titulo='Solicitudes de Compra Rechazadas'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfinclude template="solicitudes-filtroglobal.cfm">
						<cfinclude template="solicitudesRechazadas-lista.cfm">
					</td>
				</tr>
			</table>
    	<cf_web_portlet_end>
<cf_templatefooter>