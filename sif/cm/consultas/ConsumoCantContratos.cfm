<!---	Creado: Rebeca Corrales Alfaro --->
<!---	Fecha:  27/07/2005 			   --->
<!---	Modificado por: 			   --->
<!--- 	Fecha: 		 				   --->

<cf_templateheader title="Compras - Consulta de Consumo de Cantidades en Contratos">
	<cf_templatecss>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Consumo de Cantidades en Contratos">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="get" name="form1" action="ConsumoCantContratos-sql.cfm">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="50%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cf_web_portlet_start border="true" titulo="Consumo de Cantidades en Contratos" skin="info1">
														<div align="justify">
														&Eacute;ste reporte muestran los bienes
														incorporados en los contratos para el 
														proveedor definido. 
														</div>
													<cf_web_portlet_end>
												</td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%"  border="0" cellspacing="2" cellpadding="0">
										  <tr>
											<td width="42%" align="right"><strong>Del Proveedor:</strong></td>
											<td>
												<cf_sifsociosnegocios2 form="form1" SNcodigo="SNcodigo" SNumero="SNumero" SNdescripcion="SNdescripcion" size = "40">
											</td>
										  </tr>
										  <tr>
										  	<td></td>
										  </tr>  
										  <tr>
										  	<td align="right"><strong>N&uacute;mero de Contrato:</strong></td>
											<td>
												<cf_sifContratos SNcodigo="SNcodigo" size = "40">
											</td>
										  </tr>
										  <tr>
										  	<td></td>
										  </tr>
										  <tr>
											<td align="right"><strong>Formato</strong></td>
											<td>
												<select name="formato">
													<option value="1">Flash Paper</option>
													<option value="2">Adobe PDF</option>
													<option value="3">Microsoft Excel</option>
												</select>
											</td>
										  </tr>
										  <tr>
											<td colspan="2" align="center">&nbsp;</td>
										  </tr>
										  <tr>
											<td colspan="2" align="center"><input type="submit" value="Consultar" name="Reporte"></td>
										  </tr>
										</table>
								  </td>
								</tr>
							</table>
						</form>
						<!--- Valida que el campo Proveedor siempre sea seleccionado
							 antes de Consultar--->
						<cf_qforms>
						<script language="javascript">
							objForm.SNcodigo.required = true;
							objForm.SNcodigo.description = "Proveedor";
						</script>
					</cfoutput>
				<cf_web_portlet_end>
	<cf_templatefooter>	  


