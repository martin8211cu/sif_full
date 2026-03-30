<cf_templateheader title="Consulta de Gastos de Presupuesto (Por Centro)">
	<cf_web_portlet_start titulo="Consulta de Gastos del Presupuesto (Por Centro)">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<table width="100%">
						<tr valign="top">
							<td valign="top">	
								<cf_web_portlet_start border="true" titulo="Consulta de Gastos del Presupuesto (Por Centro)" skin="info1">
									<div align="justify">
									  <p>En &eacute;ste reporte 
									  se muestran seis columnas, tres para reflejar los resultados del mes y otros tres que reflejan 
									  los resultados acumulados al per&iacute;odo y mes solicitados, lo anterior según las cuentas 
									  presupuestarias del centro solicitado. Este reporte se puede generar en varios formatos,
										aumentando as&iacute; su utilidad  y eficiencia en el traslado de datos. </p>
								</div>
								<cf_web_portlet_end>
							</td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<cfinclude template="ConsGastosPresCentro-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>