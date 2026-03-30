<cfoutput>
 
	<cf_foldersFacturacion name = "ruta">
	 <cfset path = "#ruta#/">
	<cfset logoEmpresa = getLogoEmpresa()>
	<cfset logoImage = ImageNew(logoEmpresa.ELogo)>
	<cfif NOT FileExists(path&"logoEmpresa.png")>
		<cfimage source="#logoImage#" action="write" destination="#path#logoEmpresa.png" overwrite="yes">
	</cfif>
	<!--- Querys AFGM-SPR CONTROL DE VERSIONES--->
			<cfquery name="rsVersionCFDI" datasource = "#Session.DSN#">
			select Pvalor 
			from Parametros
			where Pcodigo = '17200'
					and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfset version = "#rsVersionCFDI.Pvalor#">
	<!--- Fin Querys AFGM-SPR --->
	
	<!--- Query de Obtencion de Traslados--->
	<cfquery name="rsTotalComplemento" datasource="#session.dsn#">
		select FPE.IDpreFactura as FPE,Objimp.CSATcodigo as IdObjImp,round(FPE.Impuesto,2) as ImporteDR,FPD.TotalLinea as Base,
		convert(numeric(10,0),FPE.Impuesto) as ImpuestoValidador,FPD.Icodigo as CodigoImpuesto,i.ClaveSAT as ImpuestoDR,
		i.TasaOCuota as TasaOCuotaDR,i.TipoFactor as TipoFactorDR,concat(FCE.Serie,FCE.Folio) as DocsRelacionados,
		FPE.Total as TotalSubtotal, FPE.FAieps as Totalieps, FPE.Impuesto as TotalImpuesto
		from FAPreFacturaE FPE
		inner join FAPreFacturaD FPD
		on FPD.IDpreFactura = FPE.IDpreFactura
		inner join CSATObjImpuesto Objimp
		on Objimp.IdObjImp = FPD.IdImpuesto
		inner join Impuestos i
		on i.Icodigo = FPD.Icodigo
		inner join FA_CFDI_Emitido FCE
		on concat(FCE.Serie,FCE.Folio) = FPE.DdocumentoREF
		inner join FAEOrdenImpresion FOI 
		on FOI.OImpresionID = FCE.OImpresionID
		and FCE.timbre = FOI.TimbreFiscal
		inner join Documentos D
		on D.TimbreFiscal = FOI.TimbreFiscal
		group by FPE.IDpreFactura,Objimp.CSATcodigo,FPE.Impuesto,FPD.TotalLinea,FPD.Icodigo,i.ClaveSAT,i.TasaOCuota,i.TipoFactor,FCE.Serie,FCE.Folio,FPE.Total,FPE.FAieps
	</cfquery>
	<!--- Fin de Query de Obtencion de Traslados--->
	
	
	<cfset noBorder = "cellpadding='3' cellspacing='0'">
	<cf_foldersFacturacion>
	<cfdocument format="PDF" filename="#ruta#/#TRIM(rsDatosfac.fac)#.pdf" overwrite="true" pageType="letter">
	
		<style>
		table {
			font-family:'DejaVu Sans Condensed';
		}
		</style>
	
	
		<table border="0" cellspacing="0" cellpadding="0" width="99%">
			<tr>
				<td width="23%">
					<img src="file:///#path#logoEmpresa.png" alt="Logo_IMG" style="width: 190px; height: 73px;">
				</td>
				<td width="49%" style="font-size:13px">
				   <strong>#Trim(rsDatosEmpresa.Enombre)# <br/>
					#Trim(rsRFCEmpresa.Eidentificacion)# <br/>
					<cfif rsValFiscE.DirecFisc EQ 1>
						#rsDatosEmpresa.Calle# #rsDatosEmpresa.NumExt# #rsDatosEmpresa.NumInt#,
						#rsDatosEmpresa.Colonia# - #rsDatosEmpresa.Localidad#,
						#rsDatosEmpresa.Delegacion#,
						<cfif isDefined('rsDatosEmpresa.Referencia') and len('rsDatosEmpresa.Referencia')>
							#rsDatosEmpresa.Referencia#
						</cfif>
						C.P. #rsDatosEmpresa.codPostal#, #rsDatosEmpresa.Estado# - #rsDatosEmpresa.Pais#
					<cfelse>
						#rsDatosEmpresa.direccion1#, #rsDatosEmpresa.direccion2#
					</cfif></strong>
				</td>
				<td width="27%" style="font-size:13px">
					<strong>Comprobante Fiscal<br/>
						<cfif #rsDatosfac.CCTcodigo# EQ "FA">
						Factura
						<cfelseif #rsDatosfac.CCTcodigo# EQ "FC">
						Factura
						<cfelseif #rsDatosfac.CCTcodigo# EQ "ND">
						Nota de D&eacute;bito
						<cfelseif #rsDatosfac.CCTcodigo# EQ "RE" OR #rsDatosfac.CCTcodigo# EQ "CO" OR #rsDatosfac.CCTcodigo# EQ "EF" OR #rsDatosfac.CCTcodigo# EQ "RT">
						Recibo de Pago
						<cfelse>
						Nota de Cr&eacute;dito
						</cfif>
					</strong>
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;<br/></td></tr>
			<tr>
				<td colspan="4">
					<table style="border:outset thin" style="font-size:12px" width="99%" >
					  <cfset emiAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Emisor"].XmlAttributes>
					  <cfset headAtt = xmltimbrado["cfdi:Comprobante"].XmlAttributes>
						<tr>
							<td><strong>Folio fiscal: </strong>#rsdatosfac.timbre#</td>
							<td><strong>Serie y Folio interno: </strong>#rsDatosfac.serie# - #rsDatosfac.fac1#</td>
						</tr>
						<tr>
							<td><strong>No. de Serie del CSD del SAT: </strong>#rsdatosfac.certificadoSAT#</td>
							<td><strong>Fecha y hora de emisi&oacute;n: </strong>#rsdatosfac.fechaTimbrado#</td> <!--- #rsdatosfac.fecfac# --->
						</tr>
						<tr>
							<td><strong>No. de Serie del CSD del Emisor: </strong>#rsDatosfac.numcerfacele#</td>
							<td><strong>Lugar emisi&oacute;n: </strong>#headAtt.LugarExpedicion#</td>
						</tr>
						<tr>
							<cfquery name="q_regFiscal" datasource="#session.dsn#">
							  select CSATdescripcion from CSATRegFiscal where CSATcodigo = #emiAtt.RegimenFiscal#;
							</cfquery>
							<td><strong>Regimen fiscal: </strong>#q_regFiscal.CSATdescripcion#</td>
							<td><!---<strong>Cfdi Relacionado:</strong>---></td>
						</tr>
					</table>
				</td>
			</tr>
	
	
			<tr><td colspan="4">&nbsp;<br/></td></tr>
			<tr>
				<td colspan="4">
					<table style="border:outset thin" style="font-size:12px" width="99%" >
						<tr><td align = "left"><strong>Nombre: </strong>#rsDatosfac.snnombre#</td></tr>
						<tr><td align = "left"><strong>R.F.C: </strong>#rsdatosfac.snidentificacion#</td></tr>
						<tr>
							<td align = "left"><strong>Direcci&oacute;n: </strong>
								<cfif rsValFiscR.DirecFisc EQ 1>
									#rsDomFiscCliente.Calle# #rsDomFiscCliente.NumExt# #rsDomFiscCliente.NumInt#,
									#rsDomFiscCliente.Colonia# - #rsDomFiscCliente.Localidad#,
									#rsDomFiscCliente.Delegacion#,
									<cfif isDefined('rsDomFiscCliente.Referencia') and len(trim(rsDomFiscCliente.Referencia))>
									  #rsDomFiscCliente.Referencia#
									</cfif>
									C.P. #rsDomFiscCliente.codPostal#, #rsDomFiscCliente.Estado# - #rsDomFiscCliente.Pais#
								<cfelse>
									<cfif isDefined("rsDatosfac.DireccionCompleta")>
									  #rsDatosfac.DireccionCompleta#
									<cfelse>
									  #rsDatosfac.SNdireccion#
									</cfif>
								</cfif>
							</td>
						</tr>
						<cfif version eq "4.0">
						<tr>
							<cfset recAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Receptor"].XmlAttributes>
							<cfquery name="q_regFiscal" datasource="#session.dsn#">
							  select CSATdescripcion from CSATRegFiscal where CSATcodigo  = #recAtt.RegimenFiscalReceptor#;
							</cfquery>
							<td><strong>Regimen fiscal: </strong>#q_regFiscal.CSATdescripcion#</td>
							<td><!---<strong>Cfdi Relacionado:</strong>---></td>
						</tr>
						</cfif>
					</table>
				  </td>
			</tr>
			<tr><td colspan="4">&nbsp;<br/></td></tr>
			<cfif rsdatosfac.usaINE EQ 1 and isdefined("rsdatosfac.OITipoProcesoINE")>
			  <tr>
				<td colspan="4">
					<table style="border:outset thin" class="areaFiltro" style="font-size:12px" width="99%" >
					  <tr>
						<td>
						<strong>Tipo de Proceso:</strong>&nbsp;#rsdatosfac.OITipoProcesoINE#&nbsp;
					  </td>
					  <td>
						<cfif rsdatosfac.OITipoProcesoINE EQ 'Ordinario' >
						  <strong>Tipo Comite:</strong>
						<cfelse>
						  <strong>Ambito:</strong>
						</cfif>
						&nbsp;#rsdatosfac.OIComiteAmbito#
					  </td>
					  </tr>
					  <tr>
						<cfif rsdatosfac.OIEntidad NEQ ''>
						  <td><strong>Entidad Federativa:</strong>&nbsp;#rsdatosfac.OIEntidad#&nbsp;</td>
						</cfif>
						<cfif rsdatosfac.OIIdContabilidadINE NEQ ''>
						  <td><strong>ID Contabilidad:</strong>&nbsp;#rsdatosfac.OIIdContabilidadINE#</td>
						</cfif>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr><td colspan="4">&nbsp;<br/></td></tr>
			</cfif>
			<tr>
				<td colspan="4">
				<cfif rsVersionCFDI.Pvalor eq "3.3">
					<cfset pagoAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"].XmlAttributes>
					<cfelse>
					<cfset pagoAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"].XmlAttributes>
					</cfif>
					<table style="border:outset thin" style="font-size:12px" width="99%" >
						<tr>
						  <td align="left"><strong>RFC banco ordenante:</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.RfcEmisorCtaOrd')>#pagoAtt.RfcEmisorCtaOrd#</cfif></td>
						  <td align="center">&nbsp;</td>
						  <td align="left"><strong>Forma de Pago:</strong></td>
						  <td align="right">
							<cfif isdefined('pagoAtt.FormaDePagoP')>
							  <cfquery name="q_formaPago" datasource="#session.dsn#">
								select nombre_TipoPago from FATipoPago where TipoPagoSAT = '#pagoAtt.FormaDePagoP#' and ecodigo = #session.ecodigo#;
							  </cfquery>
							  #pagoAtt.FormaDePagoP# #q_formaPago.nombre_TipoPago#
							</cfif>
						  </td>
						</tr>
						<tr>
						  <td align="left"><strong>Nombre del banco extranjero:</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.NomBancoOrdExt')>#pagoAtt.NomBancoOrdExt#</cfif></td>
						  <td align="center">&nbsp;</td>
						  <td align="left"><strong>Moneda:</strong></td>
						  <td align="right">#Trim(rsDatosfac.Mnombre)#</td>
						</tr>
						<tr>
						  <td align="left"><strong>N&uacute;mero de cuenta ordenante:</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.CtaOrdenante')>#pagoAtt.CtaOrdenante#</cfif></td>
						  <td align="center">&nbsp;</td>
						  <td align="left"><strong>Tipo de cambio:</strong></td>
						  <td align="right">#numberformat(rsDatosfac.OItipoCambio, ",9.0000")#</td>
						</tr>
						<tr>
						  <td align="left"><strong>RFC banco beneficiario:</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.RfcEmisorCtaBen')>#pagoAtt.RfcEmisorCtaBen#</cfif></td>
						  <td align="center">&nbsp;</td>
						  <td align="left"><strong>Monto:</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.Monto')>#pagoAtt.Monto#</cfif></td>
						</tr>
						<tr>
						  <td align="left"><strong>Cuenta beneficiario:</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.CtaBeneficiario')>#pagoAtt.CtaBeneficiario#</cfif></td>
						  <td align="center">&nbsp;</td>
						  <td align="left"><strong>N&uacute;mero de operaci&oacute;n</strong></td>
						  <td align="right"></td>
						</tr>
						<tr>
						  <td align="left"><strong>Fecha y hora de recepci&oacute;n</strong></td>
						  <td align="right"><cfif isdefined('pagoAtt.FechaPago')>#pagoAtt.FechaPago#</cfif></td>
						  <td align="center">&nbsp;</td>
						  <td align="left"><strong></strong></td>
						  <td align="right"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;<br/></td></tr>
			<tr>
				<td colspan="4">
					  <table #noBorder# style="border-collapse: collapse; font-size:12px" width="99%" >
					  <cfset style = "border: 1px solid ##999; padding: 3px; text-align:center;">
					  <tr style="#style#">
						<td style="#style#"><strong>Cantidad</strong></td>
						<td style="#style#"><strong>Clave<br>Unidad de<br>Medida</strong></td>
						<td style="#style#"><strong>Clave de<br>Servicio/Producto</strong></td>
						<td style="#style#"><strong>Descripci&oacute;n</strong></td>
						<td style="#style#"><strong>Precio<br>Unitario</strong></td>
						<td style="#style#"><strong>Importe</strong></td>
					  </tr>
					  <cfset nodeArrayConceptos = xmltimbrado["cfdi:Comprobante"]["cfdi:Conceptos"]["cfdi:Concepto"]>
						<cfset att = nodeArrayConceptos.XmlAttributes>
						<tr style="#style#">
						  <td style="#style#">#att.Cantidad#</td>
						  <td style="#style#">#att.ClaveUnidad#</td>
						  <td style="#style#">#att.ClaveProdServ#</td>
						  <td style="#style#">#att.Descripcion#</td>
						  <td style="#style#">#att.ValorUnitario#</td>
						  <td style="#style#">#att.Importe#</td>
					  </tr>
				  </table>
				  </td>
			</tr>
			<tr><td colspan="4">&nbsp;<br/></td></tr>
			<tr>
				<td colspan="4">
					  <table #noBorder# style="border-collapse: collapse; font-size:11px" width="99%" >
					  <cfset style = "border: 1px solid ##999; padding: 1px;">
					  <tr style="#style#">
						<td style="#style#"><strong>UUID</strong></td>
						<td style="#style#"><strong>Serie y folio</strong></td>
						<td style="#style#"><strong>Tipo de cambio</strong></td>
						<td style="#style#"><strong>Parcialidad</strong></td>
						<td style="#style#"><strong>Saldo anterior</strong></td>
						<td style="#style#"><strong>Importe pagado</strong></td>
						<cfif rsVersionCFDI.Pvalor eq "4.0">
							<td style="#style#"><strong>SubTotal</strong></td>
							<td style="#style#"><strong>Impuesto</strong></td>
						</cfif>
						<td style="#style#"><strong>Saldo insoluto</strong></td>
					  </tr>
					  <cfif rsVersionCFDI.Pvalor eq "3.3">
					  <cfset nodeArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"]>
									<cfset toArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"]>
					  <cfelse>
								  <cfset nodeArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"]>
									<cfset toArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"]["pago20:DoctoRelacionado"]>
					  </cfif>
	
					  <cfloop index="i" from = "1" to = #ArrayLen(toArray)#>
						<cfset att = nodearray.XmlChildren[i].XmlAttributes>
						<cfset nodoImpuestosDR = nodearray.XmlChildren[i].XmlChildren>
										
						<tr style="font-size:9px; #style#">
						  <td style="#style#">#att.IdDocumento#</td>
						  <td style="#style#"><cfif isdefined('att.Serie')>#att.Serie#</cfif><cfif isdefined('att.Folio')>#att.Folio#</cfif></td>
						  <td align="right" style="#style#"><cfif isdefined('att.TipoCambioDR')>#att.TipoCambioDR#<cfelse><cfif isdefined('att.MonedaDR') && att.MonedaDR eq 'MXN'>1.00</cfif></cfif></td>
						  <td align="center" style="#style#">#att.NumParcialidad#</td>
						  <td align="right" style="#style#">#att.ImpSaldoAnt#</td>
						  <td align="right" style="#style#">#att.ImpPagado#</td>
	
											<cfif rsVersionCFDI.Pvalor eq "4.0">	
													<cfset varBaseDR = 0>
													<cfset varImporteDR = 0>
	
													<cfloop index="k" from = "1" to = #ArrayLen(nodoImpuestosDR)#>
											<cfset nodoTrasladosDR = nodoImpuestosDR[k].XmlChildren>
															
															<cfloop index="j" from = "1" to = #ArrayLen(nodoTrasladosDR)#>
																	<cfset nodoTrasladosDRAtt = nodoTrasladosDR[j].XmlChildren>
																	
																<cfloop index="h" from = "1" to = #ArrayLen(nodoTrasladosDRAtt)#>
																	<cfset att1 = nodoTrasladosDRAtt[h].XmlAttributes>
	
																	<cfset varBaseDR = (varBaseDR + att1.BaseDR)>
																	<cfset varImporteDR = (varImporteDR + att1.ImporteDR)>
																</cfloop>
															</cfloop>
	
													</cfloop>
	
													<cfset varSubtotal = att.ImpPagado - varImporteDR>
	
													<td align="right" style="#style#">#numberformat(varSubtotal,'_.__')#</td>
													<td align="right" style="#style#">#numberFormat(varImporteDR,'_.__')#</td>
											</cfif>
						  <td align="right" style="#style#">#att.ImpSaldoInsoluto#</td>
						</tr>
					  </cfloop>
				  </table>
				</td>
			</tr>
		
			<tr><td colspan="4">&nbsp;</td></tr>
			<cfif ArrayLen(nodearray.XmlChildren) gte 9 and ArrayLen(nodearray.XmlChildren) lte 16>
				<tr style="display:block; page-break-after:always; display: none;"><td colspan="4">&nbsp;</td></tr>
			</cfif>
			<tr>
			  <td colspan="4">
				<cfoutput>
				<table border="0"  width="99%" style="font-size:10px">
				  <tr>
					<td width="77%" valign="top">
					  <!--- CADENA Y SELLO --->
					  <table border="0"  width="99%"  style="font-size:11px">
						<tr>
						  <td><strong>Cadena Original del complemento de certificaci&oacute;n digital del SAT</strong></td>
						</tr>
						<tr>
							<td style="font-family: 'DejaVu Sans Condensed'; text-align:justify; font-size:9px;">#wrap(rsdatosfac.cadenaSAT,90,true)#</td>
						  </tr>
						<tr>
						  <td><strong>Sello Digital del Emisor</strong></td>
						</tr>
						<tr>
						   <td style="font-family: 'DejaVu Sans Condensed'; text-align:justify; font-size:9px;">#wrap(rsdatosfac.sello,90,true)#</td>
						 </tr>
						<tr>
						  <td><strong>Sello Digital del SAT</strong></td>
						</tr>
						<tr>
						   <td style="font-family: 'DejaVu Sans Condensed'; text-align:justify; font-size:9px;">#wrap(rsdatosfac.selloSAT,90,true)#</td>
						 </tr>
					  </table>
					</td>
					<td>&nbsp;</td>
					<td width="21%" valign="top">
					  <cfimage action="writeToBrowser" source="#ruta#/imgQR/#rsDatosfac.fac#.jpg" height=150 width=150>
					</td>
				  </tr>
				</table>
				</cfoutput>
			  </td>
			<tr>
		  </table>
	</cfdocument>
	</cfoutput>
	
	<cffunction  name="getLogoEmpresa">
		   <cfquery name="rsLogo" datasource="#session.dsn#">
				Select  Elogo , Ecodigo
				From  Empresa
				where Ereferencia = #session.Ecodigo#
			</cfquery>
		<cfreturn rsLogo>
	</cffunction>