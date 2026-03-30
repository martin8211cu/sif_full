<!---
	Eduardo Gonzalez (APH)
	Componente desarrollado para la generacion del complemento de pago por COMPENSACION.
	(Se toma como base el componente XML33ReciboPago)
	28/06/2019
--->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>

<!--- INICIA - Generacion de XML para Recibo de Pago --->
    <cffunction name="XML33ReciboPagoCFDI" returntype="string">
		<cfargument name="ReciboPago"       type="query"    required="yes">
        <cfargument name="Folio"            type="numeric"  required="yes">
        <cfargument name="Serie"            type="string"   required="yes">
        <cfargument name="ReciboPagoCxC"    type="numeric"   required="yes">

        <!--- Datos de Emisor y receptor--->
		<cfset datosEmisor = GetLugarExpedicion(#session.Ecodigo#)>
		<cfquery name="rsRegFiscal" datasource="#session.dsn#">
			select ltrim(rtrim(ClaveSAT)) ClaveSAT from FARegFiscal where Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsCliente" datasource="#session.dsn#">
			select ltrim(rtrim(SNnombre)) SNnombre, ltrim(rtrim(SNidentificacion)) SNidentificacion,
			Ppais, IdFisc from SNegocios
			where Ecodigo = #session.Ecodigo#
			and SNcodigo = #ReciboPago.SNcodigo#
		</cfquery>

        <!--- Datos de Banco Ordenante y Beneficiario--->
        <cfif isDefined('arguments.ReciboPago.Pcodigo')>
<!---             Se busca informacion de bancos por MLibros --->
            <cfquery name="rsBancoOrdenante" datasource="#session.dsn#">
                select b.RFC, cb.CBcodigo Cta_Ordenante, b.Bdescripcion, b.BancoExtranjero
                    from HEFavor ef
                        inner join MLibros ml
                            on ef.Ddocumento = ml.MLdocumento
                        inner join Bancos b
                            on b.Bid = ml.Bid
                        inner join CuentasBancos cb
                            on ml.CBid = cb.CBid
                            and ml.Bid = cb.Bid
                    where ef.Ddocumento = '#arguments.ReciboPago.Pcodigo#' ;
            </cfquery>
            <cfif arguments.ReciboPagoCxC EQ 2>
                <!--- APLICACION DE DOCUMENTOS A FAVOR --->
                <cfquery name="rsDatosCtaOrdenanteDoc" datasource="#session.dsn#">
                    SELECT  hm.EMdocumento AS Documento, hm.EMdescripcionOD AS CtaOrdenante, EMRfcBcoOrdenante AS RfcBcoOrd
                    FROM HEMovimientos hm
                    WHERE hm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					  AND LTRIM(RTRIM(hm.EMdocumento)) = '#arguments.ReciboPago.Pcodigo#'
                </cfquery>
            </cfif>

			<!--- Se busca informacion de bancos por MLibros --->
            <cfquery name="rsBancoBeneficiario" datasource="#session.dsn#">
                select b.RFC, cb.CBcodigo as Cta_Beneficiario, b.Bdescripcion
                    from HEFavor ef
                        inner join MLibros ml
                            on ef.Ddocumento = ml.MLdocumento
                        inner join Bancos b
                            on b.Bid = ml.Bid
                        inner join CuentasBancos cb
                            on cb.CBid = ml.CBid
                    where ef.Ddocumento = '#arguments.ReciboPago.Pcodigo#' ;
            </cfquery>
		</cfif>

        <!--- c_FormaPago que acepta datos de cuenta Ordenante según catálogo SAT--->
        <cfset FPP_ConDatoBancoOrd = ['02','03','04','05','06','28','29','99']>
        <!--- c_FormaPago que acepta datos de cuenta Beneficiaria según catálogo SAT--->
        <cfset FPP_ConDatosBancoBen = ['02','03','04','05','28','29','99']>
        <!--- c_FormaPago que acepta nombre de banco Extranjero según catálogo SAT--->
        <cfset FPP_ConNombreBancoOrd = ['02','03','04','28','29','99']>
        <cfquery name="rsTotal" dbtype="query">
            select sum(MontoPagoDoc) Ptotal
            from ReciboPago
        </cfquery>
		<!--- SE OBTIENE LOS DATOS DE LA CUENTA ORDENANTE --->


        <!--- INICIA - Variables de xml --->
            <cfset rsCertificado 		= GetCertificado()>
            <cfset lVarNoCertificado	= rsCertificado.noCertificado>
            <cfset lVarCertificado		= rsCertificado.Certificado>
            <cfset lVarSerie			= Arguments.Serie>
            <cfset lVarFolio			= Arguments.Folio>
            <cfset lVarLugarExpedicion  = datosEmisor.LugarExpedicion>
            <cfset lVarNombreEmisor     = #Trim(datosEmisor.Enombre)#>
            <cfset lVarRFCEmisor        = #Trim(datosEmisor.Eidentificacion)#>
            <cfset lVarRegFiscal        = #Trim(rsRegFiscal.ClaveSAT)#>
            <cfset lVarNombreCliente    = #Trim(rsCliente.SNnombre)#>
            <cfset lVarRFCCliente       = #Trim(Replace(rsCliente.SNidentificacion,"-","","ALL"))#>
            <cfset lVarUsoCFDI			= "P01">
            <cfset lVarPais				= rsCliente.Ppais>
            <cfset lVarNumRegIdTrib		= rsCliente.IdFisc>
            <cfset lVarConceptoPago		= "84111506|1|ACT|Pago|0|0">
            <cfset lVarComplementoPago	= "1.0">
            <cfset lVarFechaPago		= ReciboPago.fechaAplicaPago>
            <cfset lVarMonedaP			= getMoneda(ReciboPago.McodigoP)>
            <cfset lVarTipoCambioP		= ReciboPago.Ptipocambio>
			<cfif isDefined("ReciboPago.DPTipoCambioME")>
            <cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambioME>
			<cfelse>
				<cfset lVarTCMonDiferentes	=  ReciboPago.Ptipocambio>
			</cfif>
            <cfset lVarMonto			= #NumberFormat(rsTotal.Ptotal,'9.00')#>
		    <cfset lVarFormaDePagoP		= "03"> <!--- se actualiza mas a delante, 03 por default--->
            <cfset lVarRfcEmisorCtaOrd  = "">
            <cfset lVarCtaOrdenante     = "">
            <cfset lVarRfcEmisorCtaBen  = "">
            <cfset lVarCtaBeneficiario  = "">
            <cfset lVarBancoExtranjero  = "">
        <!--- FIN - Variables de xml --->

        <cfif isDefined('arguments.ReciboPago.CodTipoPago')>
            <cfset lVarFormaDePagoP		= right("00#arguments.ReciboPago.CodTipoPago#",2)>
        </cfif>
        <cfset esExtranjero = false>

        <cfif rsBancoOrdenante.RecordCount gt 0>
            <cfset lVarRfcEmisorCtaOrd  = "#Replace(rsBancoOrdenante.RFC,' ','','all')#">
            <cfset lVarCtaOrdenante     = "#Replace(rsBancoOrdenante.Cta_Ordenante,' ','','all')#">
            <cfif rsBancoOrdenante.BancoExtranjero eq 1>
                <cfset esExtranjero = true>
                <cfset lVarRfcEmisorCtaOrd  = "XEXX010101000">
                <cfset lVarBancoExtranjero= "#rsBancoOrdenante.Bdescripcion#">
            </cfif>
        </cfif>
        <cfif rsBancoBeneficiario.RecordCount gt 0>
            <cfset lVarRfcEmisorCtaBen  = "#Replace(rsBancoBeneficiario.RFC,' ','','all')#">
            <cfset lVarCtaBeneficiario  = "#Replace(rsBancoBeneficiario.Cta_Beneficiario,' ','','all')#">
        </cfif>

        <!--- INICIA - Construccion de XML--->
		<cfoutput >
		    <CFXML VARIABLE="xml33">
                <cfdi:Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/3"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		            xmlns:pago10="http://www.sat.gob.mx/Pagos"
		            xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd
		                http://www.sat.gob.mx/Pagos http://www.sat.gob.mx/sitio_internet/cfd/Pagos/Pagos10.xsd"
		            Version="3.3"  Folio="#Arguments.Folio#" Sello="." Serie="#Arguments.Serie#" SubTotal="0" NoCertificado="#lVarNoCertificado#"
		            Certificado="#lVarCertificado#" Fecha="#ReciboPago.FechaEnc#" Moneda="XXX" Total="0" TipoDeComprobante="P"
		            LugarExpedicion="#lVarLugarExpedicion#">

		            <cfdi:Emisor Nombre = "#trim(lVarNombreEmisor)#" Rfc = "#trim(lVarRFCEmisor)#" RegimenFiscal = "#trim(lVarRegFiscal)#"/>

		            <cfdi:Receptor Nombre="#trim(lVarNombreCliente)#" Rfc="#trim(lVarRFCCliente)#" UsoCFDI="#lVarUsoCFDI#"/>

                    <cfdi:Conceptos>
                        <cfdi:Concepto ClaveProdServ="84111506" Cantidad="1" ClaveUnidad ="ACT" Descripcion="Pago" ValorUnitario="0" Importe="0"/>
                    </cfdi:Conceptos>

                    <cfdi:Complemento>
                        <pago10:Pagos Version="1.0">
                            <pago10:Pago
                                FechaPago="#lVarFechaPago#" FormaDePagoP="#lVarFormaDePagoP#" MonedaP="#lVarMonedaP#"

                                <cfif ArrayFind(FPP_ConDatoBancoOrd,lVarFormaDePagoP) gt 0>
									<cfif isDefined("rsDatosCtaOrdenanteDoc.RfcBcoOrd") AND #rsDatosCtaOrdenanteDoc.RfcBcoOrd# NEQ "">
										RfcEmisorCtaOrd="#rsDatosCtaOrdenanteDoc.RfcBcoOrd#"
									</cfif>
									<cfif isDefined("rsDatosCtaOrdenanteDoc.CtaOrdenante") AND #rsDatosCtaOrdenanteDoc.CtaOrdenante# NEQ "">
										CtaOrdenante="#rsDatosCtaOrdenanteDoc.CtaOrdenante#"
									</cfif>
                                </cfif>
                                <cfif ArrayFind(FPP_ConNombreBancoOrd,lVarFormaDePagoP) gt 0>
                                    <cfif esExtranjero> NomBancoOrdExt = "#lVarBancoExtranjero#" </cfif>
                                </cfif>
                                <cfif ArrayFind(FPP_ConDatosBancoBen,lVarFormaDePagoP) gt 0>
                                    RfcEmisorCtaBen="#lVarRfcEmisorCtaBen#" CtaBeneficiario="#lVarCtaBeneficiario#"
                                </cfif>

                                <cfif lVarMonedaP NEQ "MXN">TipoCambioP="#lVarTipoCambioP#" </cfif>
                                Monto="#lVarMonto#">

								<cfquery name="rsDocRel" datasource="#session.dsn#">
                                       SELECT DISTINCT d.TimbreFiscal,
                                               e.xmlTimbrado,
                                               d.Mcodigo,
                                               d.Dtotal,
                                               d.Dtipocambio AS OItipoCambio,
                                               d.Dsaldo AS Dsaldo,
                                               'PPD' AS c_metPago,
                                               t.CCTcodigo,
                                               d.TimbreFiscal
                                           FROM Documentos d
                                           INNER JOIN CCTransacciones t ON t.Ecodigo = d.Ecodigo
                                           AND t.CCTcodigo = d.CCTcodigo
                                           LEFT JOIN CERepositorio e ON e.Ecodigo = d.Ecodigo
                                           AND e.timbre = d.TimbreFiscal
                                           WHERE RTRIM(LTRIM(d.Ddocumento)) = '#TRIM(ReciboPago.DocCxc)#'
                                             AND d.Ecodigo = #session.Ecodigo#
                                           AND t.CCTtipo = 'D'
					            </cfquery>

                                   <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0 and rsDocRel.XMLtimbrado NEQ ''>
									<cfset xmltimbrado = XmlParse(rsDocRel.xmlTimbrado)>
									<cfset headAtt = xmltimbrado["cfdi:Comprobante"].XmlAttributes>
									<cfset lVarSerie = headAtt.Serie>
									<cfset lVarFolio = headAtt.Folio>
                                       <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>
									<cfset lVarImportePagado = ReciboPago.MontoPagoDoc>

									<cfset lVarPtotal = (ReciboPago.Ptotal) / lVarTCMonDiferentes>

                                       <cfset lVarMontoDocRel  = rsDocRel.Dtotal>
									<cfset lVarMetodoDePagoDR = "PPD">
                                       <pago10:DoctoRelacionado IdDocumento = "#rsDocRel.TimbreFiscal#"
                                           <cfif ReciboPagoCxC EQ 1 OR ReciboPagoCxC EQ 2>
											<cfif isDefined("lVarSerie") AND #lVarSerie# NEQ "NA" AND isDefined("lVarFolio") AND #lVarSerie# NEQ "NA">
												Serie ="#lVarSerie#" Folio="#lVarFolio#"
											<cfelse>
												<!--- Si no trae una serie y folio, significa que no se pudo obtener la información del XML
												      o no existe. --->
												<cfset lVarLenString = #LEN(ReciboPago.Ddocumento)#>
												Serie ="#MID(ReciboPago.Ddocumento,1,3)#" Folio="#MID(ReciboPago.Ddocumento,4,lVarLenString)#"
											</cfif>
										</cfif>
                                           MonedaDR = "#lVarMonedaDocRel#"
                                           <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0>
                                               ImpSaldoAnt="#NumberFormat((rsDocRel.Dsaldo + lVarImportePagado),'0.00')#"
                                               ImpSaldoInsoluto="#NumberFormat((rsDocRel.Dsaldo),'0.00')#"
                                           </cfif>
										<!--- MONEDA DEL PAGO --->
                                          <cfif lVarMonedaP NEQ lVarMonedaDocRel> TipoCambioDR ="1" </cfif>
                                           MetodoDePagoDR="#lVarMetodoDePagoDR#" NumParcialidad ="#ReciboPago.CantPagos#" ImpPagado = "#NumberFormat(lVarImportePagado,'9.00')#"
                                       />
                                   </cfif>
                            </pago10:Pago>
                        </pago10:Pagos>
                    </cfdi:Complemento>
		        </cfdi:Comprobante>
		    </CFXML>
		</cfoutput>
        <!--- FIN - Construccion de XML--->

        <!--- Remover Caracteres especiales --->
        <cfset xml33 = cleanXML(xml33)>

		<cfset xml33 = replace(xml33,"Fecha", " Fecha", "All")>

		<cfreturn xml33>
	</cffunction>
<!--- FIN - Generacion de XML para Recibo de Pago --->

    <cffunction name ="getMoneda" access = "private" returntyoe="string">
        <cfargument name="Mcodigo" type="numeric" required = "yes" default = -1>
		<cfquery name="rsMoneda" datasource="#session.dsn#">
			select ClaveSAT from Monedas
			where Ecodigo = #session.Ecodigo#
			and   Mcodigo = #arguments.Mcodigo#
		</cfquery>
		<cfreturn rsMoneda.ClaveSAT>
	</cffunction>

</cfcomponent>

