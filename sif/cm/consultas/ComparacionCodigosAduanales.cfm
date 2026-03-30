<cf_templateheader title="Comparación de Códigos Aduanales">
	<cf_templatecss>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Comparación de Códigos Aduanales">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="post" name="form1" action="ComparacionCodigosAduanales-vista.cfm">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="50%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cf_web_portlet_start border="true" titulo="Comparación de Códigos Aduanales" skin="info1">
														<div align="justify">En &eacute;ste reporte 
														  comparan los códigos aduanales indicados
														  para las líneas de una póliza con los
														  códigos aduanales asociados a los artículos
														  de esas líneas en el sistema.
														</div>
													<cf_web_portlet_end>
												</td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%"  border="0" cellspacing="2" cellpadding="0">
											<tr>
												<td align="right"><strong>Fecha inicial</strong></td>
												<td><cf_sifcalendario form="form1" name="FechaInicial"></td>									
											</tr>
											<tr>
												<td align="right"><strong>Fecha final</strong></td>
												<td><cf_sifcalendario form="form1" name="FechaFinal"></td>
											</tr>
											<tr>
												<td align="right"><strong>Estado</strong></td>
												<td>
													<select name="Estado">
											  		<option value="0" selected>Todos</option>
											  		<option value="1">Abierta</option>
													<option value="2">Cerrada</option>
													</select>
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Póliza de Desalmacenaje</strong></td>
												<td><cf_sifpoliza form="form1"></td>
											</tr>
											<tr>
												<td colspan="2" align="center">&nbsp;</td>
											</tr>
											<tr>
												<td colspan="2" align="center"><input type="submit" value="Generar" name="Reporte"></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</form>
					</cfoutput>
				<cf_web_portlet_end>
	<cf_templatefooter>
