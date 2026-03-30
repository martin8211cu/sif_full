<cf_templateheader title="Consulta de Gastos de Presupuesto (Totales)">
	<cf_web_portlet_start titulo="Consulta de Gastos del Presupuesto (Totales)">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<table width="100%">
						<tr valign="top">
							<td valign="top">	
								<cf_web_portlet_start border="true" titulo="Consulta de Gastos del Presupuesto (Totales)" skin="info1">
									<div align="justify">
									  <p>En &eacute;ste reporte 
									  se muestran seis columnas, tres para reflejar los resultados del mes y otros tres que reflejan los resultados acumulados al per&iacute;odo y mes solicitados, totalizando s&oacute;lo cuentas que acepten movimientos. Este reporte
									  se  genera en el formato html. </p>
								</div>
								<cf_web_portlet_end>
							</td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<cfinclude template="ConsGastosPresTotales-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>