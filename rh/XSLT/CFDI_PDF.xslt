<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" />
	<xsl:param name="FolioFiscal"/>
	<xsl:param name="NumeroCertificado"/>
	<xsl:param name="FechaCertificado"/>
	<xsl:param name="RegimenDesc"/>
	<xsl:param name="CentroFuncional"/>
	<xsl:param name="CodigoNomina"/>
	<xsl:param name="FechaEmision"/>
	<xsl:param name="ImgQR"/>
	<xsl:param name="Puesto"/>
	<xsl:param name="Direccion"/>
	
	<xsl:param name="selloSAT"/>
	<xsl:param name="selloCFDI"/>
	<xsl:param name="cadenaSAT"/>
	<xsl:param name="imgEmpresa"/>
	
	<xsl:param name="valCero"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="Comprobante" />
				</title>
				<xsl:apply-templates select="Comprobante" />
				<link rel="stylesheet" type="text/css" href="/rh/css/BoletasPagoconXSLT.css"/>
			</head>
			<body>
				<!-- Tabla principal -->
				<table align="center" width="100%" border="0">
					<tr>
						<td>
							<table align="left">
								<tr>
									<td align="left">
										<img alt="imgEmpresa" width="auto" height="80" src="{$imgEmpresa}"></img>
									</td>
								</tr>
							</table>
							<!-- Tabla encabezado -->
							<table class="tablaContenido" align="right" cellspacing="0" cellpadding="0" border="0">
								<tr class="fondo">
									
								
									<td>
										
											<strong>
												COMPROBANTE FISCAL DIGITAL
											</strong>
										
									</td>
									<td >
										
											<strong>
												RECIBO DE NÓMINA
											</strong>
										
									</td>
								</tr>
								<tr class="fondo">
									<td>
										
											<strong>
												RÉGIMEN
											</strong>
										
									</td>
									<td >
										<strong>
											FECHA Y HORA DE CERTIFICACIÓN
										</strong>
									</td>
								</tr>
								<tr>
									<td >
										<xsl:value-of select="Comprobante/Emisor/@RegimenFiscal" />
									</td>
									<td >
										<xsl:value-of select="$FechaCertificado" />
									</td>
								</tr>
								<tr class="fondo">
									<td >
										<strong>
											FOLIO FISCAL
										</strong>
									</td>
									<td >
										<strong>
											NÚMERO DE SERIE DEL CERTIFICADO DEL SAT
										</strong>
									</td>
								</tr>
								<tr>
									<td >
										<xsl:value-of select="$FolioFiscal" />
									</td>
									<td >
										<xsl:value-of select="$NumeroCertificado" />
									</td>
								</tr>
							</table><!-- Fin tabla encabezado -->
						</td>
					</tr>
					<tr><td></td></tr>
					<tr><td></td></tr>
					<tr>
						<td>
							<!-- Tabla de contenido -->
							<table align="center" width="100%" class="tablaContenido" cellspacing="0" cellpadding="0" >
								<tr class="fondo">
									<td colspan="2">
										
											<xsl:value-of select="Comprobante/Emisor/@Nombre"/>
										
									</td>
									<td >
										
											<strong>
												REGISTRO PATRONAL
											</strong>
										
									</td>
									<td colspan="2">
										
											<strong>
												RFC
											</strong>
										
									</td>
								</tr>
								<tr>
									<td colspan="2">
										
											<xsl:value-of select="Comprobante/Emisor/@Rfc"/>
										
									</td>
									<td>
										
											<xsl:value-of select="Comprobante/Complemento/Nomina/Emisor/@RegistroPatronal"/>
										
									</td>
									<td colspan="2">
										
											<xsl:value-of select="Comprobante/Emisor/@Rfc"/>
										
									</td>
									
								</tr>
								<tr class="fondo">
									<td>
										<strong>
											
												FOLIO
											
										</strong>
									</td>
									<td>
										<strong>
											
												No. DE CERTIFICADO
											
										</strong>
									</td>
									<td>
										<strong>
											
												FECHA Y HORA DE EMISIÓN
											
										</strong>
									</td>
									<td colspan="2">
										<strong>
											
												SERIE
											
										</strong>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="Comprobante/@Folio"/>
									</td>
									<td>
										<xsl:value-of select="Comprobante/@NoCertificado"/>
									</td>
									<td>
										<xsl:value-of select="$FechaEmision"/>
									</td>
									<td colspan="2">
										<xsl:value-of select="Comprobante/@Serie"/>
									</td>
								</tr>
								<tr class="fondo">
									<td >
										<strong>
											REGIMEN EMPLEADO
										</strong>
									</td>
									<td>
										<strong>
											DIRECCIÓN
										</strong>
									</td>
									<td>
										<strong>
											AREA
										</strong>
									</td>
									<td >
										<strong>
											NÓMINA
										</strong>
									</td>
									<td>
										<strong>
											TIPO DE NÓMINA
										</strong>
									</td>
								</tr>
								
								<tr>
									<td>
										<xsl:value-of select="$RegimenDesc"/>
									</td>
									<td>
										<xsl:value-of select="$Direccion"/>
									</td>
									<td>
										<xsl:value-of select="$CentroFuncional"/>
									</td>
									<td>
										<xsl:value-of select="$CodigoNomina"/>
									</td>
									<td>
										<xsl:value-of select="Comprobante/Complemento/Nomina/@TipoNomina"/>
									</td>
								</tr>
								<tr class="fondo">
									<td>
										<strong>
											No EMPLEADO
										</strong>
									</td>
									<td>
										<strong>
											NOMBRE COMPLETO
										</strong>
									</td>
									<td>
										<strong>
											RFC
										</strong>
									</td>
									<td colspan="2">
										<strong>
											CURP
										</strong>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@NumEmpleado"/>
									</td>
									<td>
										<xsl:value-of select="Comprobante/Receptor/@Nombre"/>
									</td>
									<td>
										<xsl:value-of select="Comprobante/Receptor/@Rfc"/>
									</td>
									<td colspan="2">
										<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@Curp"/>
									</td>
								</tr>
								
								<tr class="fondo">
									<td>
										<strong>
											DIAS TRABAJADOS
										</strong>
									</td>
									<td>
										<strong>
											PUESTO
										</strong>
									</td>
									<td>
										<strong>
											NSS
										</strong>
									</td>
									<td colspan="2">
										<strong>
											FECHA DE INGRESO
										</strong>
									</td>
								</tr>
								<tr>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Complemento/Nomina/@NumDiasPagados"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
											<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@Puesto"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@NumSeguridadSocial"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;" colspan="2">
										<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@FechaInicioRelLaboral"/>
									</td>
								</tr>
								<tr class="fondo">
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											PERIODO
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											FECHA DE PAGO
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											SUELDO BASE DE COTIZACIÓN
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;" colspan="2">
										<strong>
											SDI
										</strong>
									</td>
								</tr>
								<tr>
									<td style="padding-left:5px; padding-right:5px;">
										Del <xsl:value-of select="Comprobante/Complemento/Nomina/@FechaInicialPago"/> 
										al <xsl:value-of select="Comprobante/Complemento/Nomina/@FechaFinalPago"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Complemento/Nomina/@FechaPago"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@SalarioBaseCotApor"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;" colspan="2">
										<xsl:value-of select="Comprobante/Complemento/Nomina/Receptor/@SalarioDiarioIntegrado"/>
									</td>
								</tr>
								<tr bgcolor="#CDCDCD">
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											CANTIDAD
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											UNIDAD
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											DESCRIPCIÓN
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											P/UNITARIO
										</strong>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<strong>
											IMPORTE
										</strong>
									</td>
								</tr>
								<tr>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Conceptos/Concepto/@Cantidad"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Conceptos/Concepto/@ClaveUnidad"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Conceptos/Concepto/@Descripcion"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Conceptos/Concepto/@ValorUnitario"/>
									</td>
									<td style="padding-left:5px; padding-right:5px;">
										<xsl:value-of select="Comprobante/Conceptos/Concepto/@Importe"/>
									</td>
								</tr>
								
							</table><!-- Fin tabla de contenido -->
						</td>
					</tr>
					<tr><td></td></tr>
					<tr class="totales">
						<td style="border-spacing:0px;" class="totales">
							<!-- Inicio tabla de detalles -->
							<table align="center" width="100%" class="tablaContenido" cellspacing="0" cellpadding="0">
								<tr valign="top" class="totales">
									<td class="detalles">
										<table width="100%" class="tblDetalle" cellspacing="0" cellpadding="0">
											<tr valign="middle"  class="fondo">
												<td  colspan="3" align="center">
													<strong>PERCEPCIONES</strong>
												</td>
											</tr>
											<tr class="fondo">
												<td style="padding-left:2px; padding-right:2px; border-bottom:0px solid #CDCDCD;">
													<strong>CLAVE</strong>
												</td>
												<td style="padding-left:2px; padding-right:2px;">
													<strong>CONCEPTO</strong>
												</td>
												<td style="padding-left:2px; padding-right:2px;" align="right">
													<strong>IMPORTE</strong>
												</td>
											</tr>
											<xsl:for-each select="Comprobante/Complemento/Nomina/Percepciones/Percepcion">
												<tr >
													<td align="left">
														<xsl:value-of select="@Clave"/>
													</td>
													<td align="left">
														<xsl:value-of select="@Concepto"/>
													</td>
													<td align="right">
														<xsl:if test="@ImporteGravado > 0">
															<xsl:value-of select="@ImporteGravado"/>
														</xsl:if>
														<xsl:if test="@ImporteExento > 0">
															<xsl:value-of select="@ImporteExento"/>
														</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
									<td valign="top" class="detalles"><!-- Tabla OTROS PAGOS -->
										<table width="100%" class="tblDetalle" cellspacing="0" cellpadding="0">
											<tr bgcolor="#CDCDCD">
												<td style="padding-left:5px; padding-right:5px;" colspan="3" align="center">
													<strong>OTROS PAGOS</strong>
												</td>
											</tr>
											<tr bgcolor="#CDCDCD">
												<td style="padding-left:5px; padding-right:5px;" align="left">
													<strong>CLAVE</strong>
												</td>
												<td style="padding-left:5px; padding-right:5px;" align="left">
													<strong>CONCEPTO</strong>
												</td>
												<td style="padding-left:5px; padding-right:5px;" align="right">
													<strong>IMPORTE</strong>
												</td>
											</tr>
											<xsl:for-each select="Comprobante/Complemento/Nomina/OtrosPagos/OtroPago">
												<tr>
													<td style="padding-left:5px; padding-right:5px;" align="left">
														<xsl:value-of select="@Clave"/>
													</td>
													<td style="padding-left:5px; padding-right:5px;" align="left">
														<xsl:value-of select="@Concepto"/>
													</td>
													<td style="padding-left:5px; padding-right:5px;" align="right">
														<xsl:value-of select="@Importe"/>
													</td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="Comprobante/Complemento/Nomina/OtrosPagos/OtroPago/SubsidioAlEmpleo">
											<tr>
													<td style="padding-left:5px; padding-right:5px;" align="left">
														
													</td>
													<td style="padding-left:5px; padding-right:5px;" align="left">
														Subsidio Causado
													</td>
													<td style="padding-left:5px; padding-right:5px;" align="right">
														<xsl:value-of select="@SubsidioCausado"/>
													</td>
											</tr>
											</xsl:for-each>
										</table>
									</td>
									<td valign="top" class="detalles"><!-- TABLA DEDUCCIONES -->
										<table width="100%" class="tblDetalle" cellspacing="0" cellpadding="0">
											<tr bgcolor="#CDCDCD">
												<td colspan="3" align="center">
													<strong>DEDUCCIONES</strong>
												</td>
											</tr>
											<tr bgcolor="#CDCDCD">
												<td style="padding-left:5px; padding-right:5px;">
													<strong>CLAVE</strong>
												</td>
												<td style="padding-left:5px; padding-right:5px;">
													<strong>CONCEPTO</strong>
												</td>
												<td style="padding-left:5px; padding-right:5px;" align="right">
													<strong>IMPORTE</strong>
												</td>
											</tr>
											<!-- OPARRALES 2018-10-30 Validacion para Nominas(Especiales) que no llevan deducciones (Aguinaldos) -->
											<xsl:if test="Comprobante/Complemento/Nomina/Deducciones">
												<xsl:for-each select="Comprobante/Complemento/Nomina/Deducciones/Deduccion">
													<tr>
														<td style="padding-left:5px; padding-right:5px;" align="left">
															<xsl:value-of select="@Clave"/>
														</td>
														<td style="padding-left:5px; padding-right:5px;" align="left">
															<xsl:value-of select="@Concepto"/>
														</td>
														<td style="padding-left:5px; padding-right:5px;" align="right">
															<xsl:value-of select="@Importe"/>
														</td>
													</tr>
												</xsl:for-each>
											</xsl:if>
										</table>
									</td>
								</tr>
								<tr class="totales">
									<td align="right" class="total">
										<table width="100%" class="sinBordes" border="0" cellspacing="0" cellpadding="0">
											<tr class="sinBordes">
												<td class="sinBordes"><strong>TOTAL DE PERCEPCIONES</strong></td>
												<td class="sinBordes"></td>
												<td align="right" class="sinBordes"><xsl:value-of select="Comprobante/Complemento/Nomina/@TotalPercepciones"/></td>
											</tr>
										</table>
									</td>
									<td align="right" class="total">
										<table width="100%" class="sinBordes" border="0" cellspacing="0" cellpadding="0">
											<tr class="sinBordes">
												<td class="sinBordes"><strong>TOTAL OTROS PAGOS</strong></td>
												<td class="sinBordes"></td>
												<td align="right" class="sinBordes"><xsl:value-of select="Comprobante/Complemento/Nomina/@TotalOtrosPagos"/></td>
											</tr>
										</table>
									</td>
									<td align="right" class="total">
										<table width="100%" class="sinBordes" border="0" cellspacing="0" cellpadding="0">
											<tr class="sinBordes">
												<td class="sinBordes"><strong>TOTAL DEDUCCIONES</strong></td>
												<td class="sinBordes"></td>
												<td align="right" class="sinBordes">
													<!-- OPARRALES 2018-10-30 Validacion para Nominas(Especiales) que no llevan deducciones (Aguinaldos) -->
													<xsl:if test="not(Comprobante/Complemento/Nomina/@TotalDeducciones)">
														0.00
													</xsl:if>
													<xsl:if test="Comprobante/Complemento/Nomina/@TotalDeducciones">
														<xsl:value-of select="Comprobante/Complemento/Nomina/@TotalDeducciones"/>
													</xsl:if>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table><!-- Fin tabla de detalles -->
						</td>
					</tr>
					<tr><td></td></tr>
					<tr><td></td></tr>
					<tr><td></td></tr>
					<tr><td></td></tr>
					<tr class="descripciones">
						<td class="totales">
							<table class="descripciones" width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr class="totales"><!-- Tablas DESCRIPCION y TOTALES -->
									<td class="total" valign="top">
										<table class="sinBordes" width="50%" border="0" cellspacing="0" cellpadding="0">
											<tr class="sinBordes">
												<td></td>
												<td></td>
											</tr>
											<tr class="sinBordes">
												<td>Tipo de Nómina</td>
												<td></td>
											</tr>
											<tr class="sinBordes">
												<td>O = Nómina Ordinaria</td>
												<td></td>
											</tr>
											<tr class="sinBordes">
												<td>E = Nómina Extraordinaria</td>
												<td></td>
											</tr>
											<tr class="sinBordes">
												<td></td>
												<td></td>
											</tr>
											<tr class="sinBordes">
												<td colspan="2">Se adjunta recibo de nómina timbrado (.pdf y .xml)</td>
											</tr>
										</table>
									</td>
									
									<td class="total" valign="top" colspan="2">
										<table class="sinBordes" width="150%" border="0" cellspacing="0" cellpadding="0">
											<tr class="sinBordes">
												<td class="sinBordes" align="right">Subtotal</td>
												<td align="right"><xsl:value-of select="Comprobante/Conceptos/Concepto/@Importe"/></td>
											</tr>
											<tr class="sinBordes">
												<td class="sinBordes" align="right">Descuento</td>
												<td align="right">
													<!-- OPARRALES 2018-10-30 Validacion para Nominas(Especiales) que no llevan deducciones (Aguinaldos) -->
													<xsl:if test="not(Comprobante/Complemento/Nomina/@TotalDeducciones)">
														 <xsl:value-of select="$valCero"/>
													</xsl:if>
													<xsl:if test="Comprobante/Complemento/Nomina/@TotalDeducciones">
														<xsl:value-of select="Comprobante/Complemento/Nomina/@TotalDeducciones"/>
													</xsl:if>
												</td>
											</tr>
											<tr class="sinBordes">
												<td class="sinBordes" align="right">Total Otros Pagos</td>
												<td align="right"><xsl:value-of select="Comprobante/Complemento/Nomina/@TotalOtrosPagos"/></td>
											</tr>
											<tr class="sinBordes">
												<td align="right">Retenciones</td>
												<td align="right">
													<!-- OPARRALES 2018-10-30 Validacion para Nominas(Especiales) que no llevan deducciones (Aguinaldos) -->
													<xsl:if test="not(Comprobante/Complemento/Nomina/Deducciones/@TotalImpuestosRetenidos)">
														 <xsl:value-of select="$valCero"/>
													</xsl:if>
													<xsl:if test="Comprobante/Complemento/Nomina/Deducciones/@TotalImpuestosRetenidos">
														<xsl:value-of select="Comprobante/Complemento/Nomina/Deducciones/@TotalImpuestosRetenidos"/>
													</xsl:if>
												</td>
											</tr>
											<tr class="sinBordes">
												<td align="right">Total</td>
												<td align="right"><xsl:value-of select="Comprobante/@Total"/></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td></td><td></td></tr>
								<tr><td></td><td></td></tr>
								<tr><td></td><td></td></tr>
								<tr><td></td><td></td></tr>
								<tr class="totales">
									<td width="100%" class="total" valign="top" colspan="2">
										<table class="sinBordes" width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr class="sinBordes">
												<td width="14%">FORMA DE PAGO: </td>
												<td width="86%" align="left">Por definir</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td></td><td></td></tr>
								<tr class="totales">
									<td class="unBR" colspan="2" align="center">________________________________________</td>
								</tr>
								<tr>
									<td align="center" colspan="2"><font size="1">FIRMA DEL EMPLEADO</font></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
								</tr>
								
								<tr class="totales">
									<td class="sellos" >
										<strong>
											SELLO DIGITAL CFDI
										</strong>
									</td>
									<td rowspan="6" align="right">
										<!-- Para incluir variables del XSLT a un tag de HTML se debe encerrar en llaves -->
									<!-- 
										<img alt="ImgQR" width="150" height="150" src="data:image/jpeg;base64,{$ImgQR}">
	 									</img> 
	 								-->
	 									<img alt="ImgQR" width="110" height="110" src="{$ImgQR}" ismap="true"></img>
	 									 
										
									</td>
								</tr>
								<tr class="totales">
									<td class="sellos" style="width:180px">
										<xsl:value-of select="$selloCFDI"/>
									</td>
								</tr>
								<tr class="totales">
									<td class="sellos" style="width:100px">
										<strong>
											SELLO DIGITAL SAT
										</strong>
									</td>
								</tr>
								<tr class="totales">
									<td class="sellos" style="width:180px">
										<xsl:value-of select="$selloSAT"/>
									</td>
								</tr>
								<tr class="totales">
									<td class="sellos">
										<strong>
											CADENA ORIGINAL COMPLEMENTO CERTIFICACIÓN DIGITAL SAT
										</strong>
									</td>
								</tr>
								<tr class="totales">
									<td class="sellos" style="width:180px">
										<xsl:value-of select="$cadenaSAT"/>
									</td>
								</tr>
								
							</table>
							
						</td>
					</tr>
				</table><!-- Fin tabla principal -->
			</body>
		</html>
	</xsl:template>
</xsl:transform>