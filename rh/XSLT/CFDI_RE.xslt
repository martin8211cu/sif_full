<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes"/>
	
	<xsl:param name="imgEmpresa"/>
	<xsl:param name="DireccionEmpresa"/>
	<xsl:param name="RegimenDesc"/>
	<xsl:param name="DireccionComp"/>
	<xsl:param name="FormaPago"/>
	<xsl:param name="Mnombre"/>
	<xsl:param name="OItipoCambio"/>
	<xsl:param name="myStyle"/>
	<xsl:param name="myStyle2"/>
	<xsl:param name="cadenaSAT"/>
	<xsl:param name="sello"/>
	<xsl:param name="sdSAT"/>
	<xsl:param name="imgQR"/>
	<xsl:param name="saltoLinea"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>
					RECIBO DE PAGO
				</title>
<!-- 				<xsl:apply-templates select="Comprobante" /> -->
			</head>
			<body>
				<table border="0">
					<table border="0" cellspacing="0" cellpadding="0" width="100%"
						style="font-family:'Garamond';">
						<tr>
							<td height="100" valign="center" width="30%">
								<img alt="Logo_IMG" style="width: auto; height: 100px;" src="{$imgEmpresa}"></img>
							</td>
							<td align="center">
								<font size="2"><strong>
									<xsl:value-of select="Comprobante/Emisor/@Nombre"/>
									<br />
									<xsl:value-of select="Comprobante/Emisor/@Rfc"/>
									<br />
									<xsl:value-of select="$DireccionEmpresa"/>
								</strong></font>
							</td>
							<td align="center">
								<font size="2">
									<strong>
										Comprobante Fiscal
										<br />
										Recibo de Pago
									</strong>
								</font>
							</td>
						</tr>
						<tr>
							<td>
								<br />
							</td>
						</tr>
						<tr>
							<table style="border:outset thin; font-size:12px" width="99%">
									
										<tr>
											<td>
												<strong>Folio fiscal: </strong>
												<xsl:value-of select="Comprobante/Complemento/TimbreFiscalDigital/@UUID" />
											</td>
											<td>
												<strong>Serie y Folio interno: </strong>
												<xsl:value-of select="Comprobante/@Serie"/> - <xsl:value-of select="Comprobante/@Folio"/>
											</td>
										</tr>
										<tr>
											<td>
												<strong>No. de Serie del CSD del SAT: </strong>
												<xsl:value-of select="Comprobante/Complemento/TimbreFiscalDigital/@NoCertificadoSAT"/>
											</td>
											<td>
												<strong>Fecha
													y hora de emisión:
												</strong>
												<xsl:value-of select="Comprobante/Complemento/TimbreFiscalDigital/@FechaTimbrado"/>
											</td> <!--- #rsdatosfac.fecfac# - -->
										</tr>
										<tr>
											<td>
												<strong>No. de Serie del CSD del Emisor: </strong>
												<xsl:value-of select="Comprobante/@NoCertificado"/>
											</td>
											<td>
												<strong>Lugar
													emisión:
												</strong>
												<xsl:value-of select="Comprobante/@LugarExpedicion"/>
											</td>
										</tr>
										<tr>
											<td>
												<strong>Regimen fiscal: </strong>
												<xsl:value-of select="$RegimenDesc" />
											</td>
											<td>
											</td>
										</tr>
							</table>
						</tr>
						<tr>
							<td>
								<br />
							</td>
						</tr>
						<tr>
							<table style="border:outset thin; font-size:12px"
								width="99%">
								<tr>
									<td align="left">
										<strong>Nombre: </strong>
										<xsl:value-of select="Comprobante/Receptor/@Nombre"/>
									</td>
								</tr>
								<tr>
									<td align="left">
										<strong>R.F.C: </strong>
										<xsl:value-of select="Comprobante/Receptor/@Rfc"/>
									</td>
								</tr>
								<tr>
									<td align="left">
										<strong>Dirección:
										</strong>
										<xsl:value-of select="$DireccionComp"/>
									</td>
								</tr>
							</table>
						</tr>
						<tr>
							<td>
								<br />
							</td>
						</tr>
<!-- 						<xsl:if test="$usaINE = 1"> -->
<!-- 							<tr> -->
<!-- 								<table style="border:outset thin" class="areaFiltro" style="font-size:12px" -->
<!-- 									width="99%"> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											<strong>Tipo de Proceso:</strong>  <xsl:value-of select="$OITipoProcesoINE"/>   -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<xsl:if test="$OITipoProcesoINE = 'Ordinario'"> -->
<!-- 												<strong>Tipo Comite:</strong> -->
<!-- 											</xsl:if> -->
<!-- 											<xsl:if test="$OITipoProcesoINE != 'Ordinario'"> -->
<!-- 												<strong>Ambito:</strong> -->
<!-- 											</xsl:if> -->
											
<!-- 											   <xsl:value-of select="$OIComiteAmbito"/> -->
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 									<tr> -->
<!-- 										<xsl:if test="$OIEntidad NEQ ''"> -->
<!-- 											<td> -->
<!-- 												<strong>Entidad Federativa:</strong>  <xsl:value-of select="$OIEntidad"/>   -->
<!-- 											</td> -->
<!-- 										</xsl:if> -->
<!-- 										<xsl:if test="$OIIdContabilidadINE NEQ ''"> -->
<!-- 											<td> -->
<!-- 												<strong>ID Contabilidad:</strong>  <xsl:value-of select="$OIIdContabilidadINE"/> -->
<!-- 											</td> -->
<!-- 										</xsl:if> -->
<!-- 									</tr> -->
<!-- 								</table> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td> -->
<!-- 									<br /> -->
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 						</xsl:if> -->
						<tr>
								<table style="border:outset thin; font-size:12px" width="99%">
									<tr>
										<td align="left">
											<strong>RFC banco ordenante:</strong>
										</td>
										<td align="right">
											<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@RfcEmisorCtaOrd"/>
										</td>
										<td align="center">  
										</td>
										<td align="left">
											<strong>Forma de Pago:</strong>
										</td>
										<td align="right">
											<xsl:value-of select="$FormaPago"/>
										</td>
									</tr>
									<tr>
										<td align="left">
											<strong>Nombre del banco extranjero:</strong>
										</td>
										<td align="right">
											<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@NomBancoOrdExt"/>
										</td>
										<td align="center">  
										</td>
										<td align="left">
											<strong>Moneda:</strong>
										</td>
										<td align="right"><xsl:value-of select="$Mnombre"/></td>
									</tr>
									<tr>
										<td align="left">
											<strong>Número
												de cuenta ordenante:
											</strong>
										</td>
										<td align="right">
										<xsl:if test="Comprobante/Complemento/Pagos/Pago/@CtaOrdenante">
											<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@CtaOrdenante"/>
										</xsl:if>
										</td>
										<td align="center">  
										</td>
										<td align="left">
											<strong>Tipo de cambio:</strong>
										</td>
										<td align="right"><xsl:value-of select="$OItipoCambio"/></td>
									</tr>
									<tr>
										<td align="left">
											<strong>RFC banco beneficiario:</strong>
										</td>
										<td align="right">
											<xsl:if test="Comprobante/Complemento/Pagos/Pago/@RfcEmisorCtaBen">
												<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@RfcEmisorCtaBen"/>
											</xsl:if>
										</td>
										<td align="center">  
										</td>
										<td align="left">
											<strong>Monto:</strong>
										</td>
										<td align="right">
											<xsl:if test="Comprobante/Complemento/Pagos/Pago/@Monto">
												<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@Monto"/>
											</xsl:if>
										</td>
									</tr>
									<tr>
										<td align="left">
											<strong>Cuenta beneficiario:</strong>
										</td>
										<td align="right">
											<xsl:if test="Comprobante/Complemento/Pagos/Pago/@CtaBeneficiario">
												<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@CtaBeneficiario"/>
											</xsl:if>
										</td>
										<td align="center">  
										</td>
										<td align="left">
											<strong>Número
												de operación
											</strong>
										</td>
										<td align="right"></td>
									</tr>
									<tr>
										<td align="left">
											<strong>Fecha
												y hora de recepción
											</strong>
										</td>
										<td align="right">
										<xsl:if test="Comprobante/Complemento/Pagos/Pago/@FechaPago">
											<xsl:value-of select="Comprobante/Complemento/Pagos/Pago/@FechaPago"/>
										</xsl:if>
										</td>
										<td align="center">  
										</td>
										<td align="left">
											<strong></strong>
										</td>
										<td align="right"></td>
									</tr>
								</table>
						</tr>
						<tr>
							<td>
								<br />
							</td>
						</tr>
						<tr>
							<table cellpadding='3' cellspacing='0' style="border-collapse: collapse; font-size:12px"
								width="99%">
									<tr style="{$myStyle}">
										<td style="{$myStyle}">
											<strong>Cantidad</strong>
										</td>
										<td style="{$myStyle}">
											<strong>
												Clave
												<br/>
													Unidad de
													<br/>Medida
											</strong>
										</td>
										<td style="{$myStyle}">
											<strong>
												Clave de
												<br/>Servicio/Producto
											</strong>
										</td>
										<td style="{$myStyle}">
											<strong>Descripción
											</strong>
										</td>
										<td style="{$myStyle}">
											<strong>
												Precio
												<br/>Unitario
											</strong>
										</td>
										<td style="{$myStyle}">
											<strong>Importe</strong>
										</td>
									</tr>
											<tr style="{$myStyle}">
												<td style="{$myStyle}"><xsl:value-of select="Comprobante/Conceptos/Concepto/@Cantidad"/></td>
												<td style="{$myStyle}"><xsl:value-of select="Comprobante/Conceptos/Concepto/@ClaveUnidad"/></td>
												<td style="{$myStyle}"><xsl:value-of select="Comprobante/Conceptos/Concepto/@ClaveProdServ"/></td>
												<td style="{$myStyle}"><xsl:value-of select="Comprobante/Conceptos/Concepto/@Descripcion"/></td>
												<td style="{$myStyle}"><xsl:value-of select="Comprobante/Conceptos/Concepto/@ValorUnitario"/></td>
												<td style="{$myStyle}"><xsl:value-of select="Comprobante/Conceptos/Concepto/@Importe"/></td>
											</tr>
							</table>
						</tr>
						<tr>
							<td>
								<br />
							</td>
						</tr>
						<tr>
							<table cellpadding='3' cellspacing='0' style="border-collapse: collapse; font-size:12px" width="99%">
									<tr style="{$myStyle2}">
										<td style="{$myStyle2}">
											<strong>UUID</strong>
										</td>
										<td style="{$myStyle2}">
											<strong>Serie y folio</strong>
										</td>
										<td style="{$myStyle2}">
											<strong>Tipo de cambio</strong>
										</td>
										<td style="{$myStyle2}">
											<strong>Parcialidad</strong>
										</td>
										<td style="{$myStyle2}">
											<strong>Saldo anterior</strong>
										</td>
										<td style="{$myStyle2}">
											<strong>Importe pagado</strong>
										</td>
										<td style="{$myStyle2}">
											<strong>Saldo insoluto</strong>
										</td>
									</tr>
									<xsl:for-each select="Comprobante/Complemento/Pagos/Pago/DoctoRelacionado">
										<tr style="{$myStyle}">
											<td style="{$myStyle}"><xsl:value-of select="@IdDocumento"/></td>
											<td style="{$myStyle}">
												<xsl:value-of select="@Serie"/>
												<xsl:value-of select="@Folio"/>
											</td>
											<td style="{$myStyle}">
												<xsl:if test="@TipoCambioDR">
													<xsl:value-of select="@TipoCambioDR"/> 
												</xsl:if>
												<xsl:if test="@MonedaDR = 'MXN'">
													1.00
												</xsl:if>
											</td>
											<td style="{$myStyle}"><xsl:value-of select="@NumParcialidad"/></td>
											<td style="{$myStyle}"><xsl:value-of select="@ImpSaldoAnt"/></td>
											<td style="{$myStyle}"><xsl:value-of select="@ImpPagado"/></td>
											<td style="{$myStyle}"><xsl:value-of select="@ImpSaldoInsoluto"/></td>
										</tr>
									</xsl:for-each>
							</table>
						</tr>
						<tr>
							<td>
								<br />
							</td>
						</tr>
						<xsl:if test="$saltoLinea = 1">
							<div style="display:block; page-break-before:always; display: none;"></div>
						</xsl:if>
						<tr>
							<td>
								<table border="0" width="99%" style="font-size:10px">
									<tr>
										<div>
											<td width="77%">
												<!--- CADENA Y SELLO - -->
												<table border="0" width="99%" style="font-size:10px">
													<tr>
														<td>
															<strong>Cadena
																Original del complemento de certificación
																digital del SAT
															</strong>
														</td>
													</tr>
													<tr>
														<td>
															<strong style="font-family: 'Courier New'; font-size:8px;">
																<xsl:value-of select="$cadenaSAT"/>
															</strong>
														</td>
													</tr>
													<tr>
														<td>
															<strong>Sello Digital del Emisor</strong>
														</td>
													</tr>
													<tr>
														<td>
															<strong style="font-family: 'Courier New'; font-size:8px;">
																<xsl:value-of select="$sello"/>
															</strong>
														</td>
													</tr>
													<tr>
														<td>
															<strong>Sello Digital del SAT</strong>
														</td>
													</tr>
													<tr>
														<td>
															<strong	style="font-family: 'Courier New'; font-size:8px;">
																<xsl:value-of select="$sdSAT"/>
															</strong>
														</td>
													</tr>
												</table>
											</td>
											<td width="21%" valign="top" rowspan="4">
												<img alt="Logo_IMG" height="150" width="150" src="{$imgQR}"></img>												
											</td>
										</div>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<tr>
						<td>  
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:transform>