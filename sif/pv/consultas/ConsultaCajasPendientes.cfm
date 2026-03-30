<cf_templateheader title="Punto de Venta - Consulta de Cajas Pendientes de Cierre">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Cajas Pendientes de Cierre">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="post" name="form1" action="ConsultaCajasPendientes-sql.cfm">
							<table width="99%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
								  	<td width="50%" valign="top">
										<cf_web_portlet_start border="true" titulo="Adelantos" skin="info1">
											<div align="justify">En este reporte 
											  se listan las cajas pendientes de cierre
											</div>
										<cf_web_portlet_end>
								  	</td>
									<td width="50%" valign="top">
								  	<table width="100%"  border="0" cellspacing="0" cellpadding="2">										
											<td align="right"><strong>Formato</strong></td>
											<td>
												<select name="formato" tabindex="6">
												<option value="HTML">HTML</option>
												<!---
												  <option value="flashpaper">Flash Paper</option>
												  <option value="pdf">Adobe PDF</option>
												  <option value="excel">Microsoft Excel</option>
												 --->
												</select>
											</td>
										</tr>
										<tr><td colspan="2">&nbsp;</td></tr>									  
										<tr><td colspan="2" align="center"><input type="submit" value="Generar" name="Generar"></td></tr>
                                    </table></td>
								</tr>
							</table>
						</form>
					</cfoutput>
		<cf_web_portlet_end>
<cf_templatefooter>	  
