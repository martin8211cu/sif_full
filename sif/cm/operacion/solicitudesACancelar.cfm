<cf_templateheader title="Solicitudes de Compra">
	<cf_web_portlet_start titulo='Solicitudes de Compra'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfinclude template="SolicitudesACancelar-cancelar.cfm">
					<cfinclude template="solicitudes-filtroglobal.cfm">
					<cfinclude template="SolicitudesACancelar-lista.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>