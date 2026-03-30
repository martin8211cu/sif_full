<!---
Componente desarrollado para Generar el XML correspondiente para Recibo de Pago
Escrito por: Giancarlo Benítez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (YYYY-MM-DD) Descripcion
--->

<!---	select * from Documentos a
            Inner join DDocumentos b  
            where Ecodigo= #arguments.ReciboPago.Ecodigo# 
            and Mcodigo = #arguments.ReciboPago.McodigoP# 
            and Ddocumento = '#arguments.ReciboPago.DDocumento#'
            and SNcodigo = #arguments.ReciboPago.SNcodigo#--->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>

<!--- INICIA - Generacion de XML para Recibo de Pago --->
    <cffunction name="XML33ReciboPagoCFDI" returntype="string">
		<cfargument name="ReciboPago"       type="query"    required="yes">
        <cfargument name="Folio"            type="numeric"  required="yes">
        <cfargument name="Serie"            type="string"   required="yes">
        <cfargument name="ReciboPagoCxC"    type="numeric"   required="yes">

        <cfset ZonaHoraria = createObject("component","rh.Componentes.GeneraCFDIs.ZonaHoraria")>
        <cfset DiferenciaHorasTimbrado = ZonaHoraria.DiferenciaHorasTimbrado()>
        
        <cfif DiferenciaHorasTimbrado eq "">
            <cfset DiferenciaHorasTimbrado = 0>
        </cfif>
		<cfset Hora = timeFormat(now(), "HH")>
		<cfset Hora ="#Hora#"+"#DiferenciaHorasTimbrado#">
		<cfset Hora = NumberFormat(Hora, '00')>
        <cfset fechaHora= dateFormat(Now(),"yyyy-mm-dd") & "T" & timeFormat(now(), "#Hora#:mm:ss")> 

		<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
			select e.Mcodigo, e.Ecodigo, m.Miso4217
			from Empresa e
			inner join Moneda m
				on e.Mcodigo = m.Mcodigo
			where e.Ereferencia = #session.Ecodigo#
		</cfquery>
		<cfset _monedaLocal = rsMonedaLocal.Miso4217>
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
                    from EFavor ef
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
                    SELECT  hm.EMdocumento AS Documento, hm.EMdescripcionOD AS CtaOrdenante, hm.EMBancoIdOD AS BcoOrdenante, b.Bdescripcion AS NombreBancoOrd,
                        b.RFC AS RfcBcoOrd
                    FROM HEMovimientos hm
                        LEFT JOIN Bancos b ON b.Bid = hm.EMBancoIdOD AND b.Ecodigo = hm.Ecodigo
                    WHERE hm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					  AND LTRIM(RTRIM(hm.EMdocumento)) = '#arguments.ReciboPago.Pcodigo#'
                </cfquery>
            </cfif>
<!---             Si no hay registros se asume que en un Cobro de CxCy se busca la informcion de bancos --->
            <cfif isdefined('rsBancoOrdenante') and rsBancoOrdenante.RecordCount eq 0>
                <cfquery name="rsBancoOrdenante" datasource="#session.dsn#">
                    select b.RFC, cb.CBcodigo Cta_Ordenante, b.Bdescripcion, b.BancoExtranjero
                    from Pagos ep
                    inner join CuentasBancos cb on ep.CBid = cb.CBid and ep.Ecodigo = cb.Ecodigo
                    inner join Bancos b on cb.Bid = b.Bid and cb.Ecodigo = b.Ecodigo
                    where ep.Pcodigo = '#arguments.ReciboPago.Pcodigo#'
                </cfquery>
                <cfif arguments.ReciboPagoCxC EQ 2>
                    <!--- APLICACION DE DOCUMENTOS A FAVOR --->
                    <cfquery name="rsDatosCtaOrdenanteDoc" datasource="#session.dsn#">
                        SELECT hm.EMdocumento AS Documento,
                            hm.EMdescripcionOD AS CtaOrdenante,
                            hm.EMBancoIdOD AS BcoOrdenante,
                            b.Bdescripcion AS NombreBancoOrd,
                            b.RFC AS RfcBcoOrd
                        FROM BMovimientos e
                        INNER JOIN HEMovimientos hm ON e.Ecodigo = hm.Ecodigo
                        AND LTRIM(RTRIM(e.Ddocumento)) = LTRIM(RTRIM(hm.EMdocumento))
                        AND e.SNcodigo = hm.SNcodigo
                        AND e.Ocodigo = hm.Ocodigo
                        AND e.CCTcodigo = hm.TpoTransaccion
                        LEFT JOIN Bancos b ON b.Bid = hm.EMBancoIdOD
                        AND b.Ecodigo = hm.Ecodigo
                        WHERE e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                        <cfif isDefined("ReciboPago.Ddocumento") AND #ReciboPago.Ddocumento# NEQ "">
                            AND LTRIM(RTRIM(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ReciboPago.Ddocumento#">
                        </cfif>
                    </cfquery>
                </cfif>
            </cfif>
<!---             Se busca informacion de bancos por MLibros --->
            <cfquery name="rsBancoBeneficiario" datasource="#session.dsn#">
                select b.RFC, cb.CBcodigo as Cta_Beneficiario, b.Bdescripcion
                    from EFavor ef
                        inner join MLibros ml
                            on ef.Ddocumento = ml.MLdocumento
                        inner join Bancos b
                            on b.Bid = ml.Bid
                        inner join CuentasBancos cb
                            on cb.CBid = ml.CBid
                    where ef.Ddocumento = '#arguments.ReciboPago.Pcodigo#' ;
            </cfquery>
<!---             Si no hay registros se asume que en un Cobro de CxCy se busca la informcion de bancos --->
            <cfif isdefined('rsBancoBeneficiario') and rsBancoBeneficiario.RecordCount eq 0>
                <cfquery name="rsBancoBeneficiario" datasource="#session.dsn#">
                    select b.RFC, cb.CBcodigo as Cta_Beneficiario, b.Bdescripcion
                    from Pagos ep
                    inner join CuentasBancos cb on ep.CBid = cb.CBid and ep.Ecodigo = cb.Ecodigo
                    inner join Bancos b on cb.Bid = b.Bid and cb.Ecodigo = b.Ecodigo
                    where ep.Pcodigo = '#arguments.ReciboPago.Pcodigo#'
                </cfquery>
            </cfif>
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
			<cfelseif isDefined("ReciboPago.DPTipoCambio")>
				<cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambio>
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
        <cfelseif isDefined('arguments.ReciboPago.Pcodigo') and left(arguments.ReciboPago.Pcodigo, 4) eq 'CRC-'> <!--- para documentos de cobros de Vales --->
            <cfset _tp = listToArray(arguments.ReciboPago.Pcodigo,"-")>
            <cfif _tp[2] eq "E">
                <cfset lVarFormaDePagoP		= "01">
            </cfif>
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
		            Certificado="#lVarCertificado#" Fecha="#fechaHora#" Moneda="XXX" Total="0" TipoDeComprobante="P"
		            LugarExpedicion="#lVarLugarExpedicion#">

		            <cfdi:Emisor Nombre = "#trim(lVarNombreEmisor)#" Rfc = "#trim(lVarRFCEmisor)#" RegimenFiscal = "#trim(lVarRegFiscal)#"/>

		            <cfdi:Receptor Nombre="#trim(replace(lVarNombreCliente,"&","&amp;","ALL"))#" Rfc="#trim(replace(lVarRFCCliente,"&","&amp;","ALL"))#" UsoCFDI="#lVarUsoCFDI#"/>

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
										CtaOrdenante="#trim(rsDatosCtaOrdenanteDoc.CtaOrdenante)#"
									</cfif>
                                </cfif>
                                <cfif ArrayFind(FPP_ConNombreBancoOrd,lVarFormaDePagoP) gt 0>
                                    <cfif esExtranjero> NomBancoOrdExt = "#lVarBancoExtranjero#" </cfif>
                                </cfif>
                                <cfif ArrayFind(FPP_ConDatosBancoBen,lVarFormaDePagoP) gt 0>
                                    RfcEmisorCtaBen="#lVarRfcEmisorCtaBen#" CtaBeneficiario="#lVarCtaBeneficiario#"
                                </cfif>

                                <cfif lVarMonedaP NEQ trim(_monedaLocal)>TipoCambioP="#lVarTipoCambioP#" </cfif>
                                Monto="#lVarMonto#">
                                
                                <cfquery dbtype="query" name="rsCalcTotalPagado">
                                    select sum(MontoPagoDoc) totalPagado
                                    from ReciboPago
                                </cfquery>
                                <cfset _totPagado = rsCalcTotalPagado.totalPagado>
                                <cfset _totDoc = 0>
                                <cfloop query="ReciboPago">
                                    <cfset rsDocRel = getDocRel( ReciboPago.Ddocumento )>
                                    <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0>
                                        <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>
										<cfset lVarImportePagado = ReciboPago.MontoPagoDoc>
										<cfif lVarMonedaP EQ lVarMonedaDocRel>
											<cfset _lVarPtotal = ReciboPago.Ptotal>
										<cfelseif lVarMonedaP EQ trim(_monedaLocal) and lVarMonedaDocRel NEQ lVarMonedaP>
											<cfset _lVarPtotal = (ReciboPago.Ptotal / lVarTCMonDiferentes)>
										<cfelseif lVarTCMonDiferentes NEQ ''>
											<cfset _lVarPtotal = (ReciboPago.Ptotal * lVarTCMonDiferentes)>
										<cfelseif lVarMonedaP NEQ trim(_monedaLocal)>
											<cfset _lVarPtotal = ReciboPago.Ptotal / ReciboPago.Ptipocambio>
										<cfelse>
											<cfset _lVarPtotal = ReciboPago.Ptotal>
										</cfif>
                                        
                                        <cfif ReciboPago.MontoPagoDoc gte _lVarPtotal>
                                            <cfset _totDoc += _lVarPtotal>
                                        </cfif>
                                    </cfif>
                                </cfloop>
                               
                                

                                <cfset saldoPago = _totPagado - _totDoc>

                                <cfloop query="ReciboPago">
									
                                    <cfset rsDocRel = getDocRel( ReciboPago.Ddocumento )>

                                    <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0>
                                        <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>
                                        
                                        <cfif lVarMonedaP EQ lVarMonedaDocRel>
											<cfset lVarPtotal = ReciboPago.Ptotal>
										<cfelseif lVarMonedaP EQ trim(_monedaLocal) and lVarMonedaDocRel NEQ lVarMonedaP>
											<cfset lVarPtotal = (ReciboPago.Ptotal / lVarTCMonDiferentes)>
										<cfelseif lVarTCMonDiferentes NEQ ''>
											<cfset lVarPtotal = (ReciboPago.Ptotal * lVarTCMonDiferentes)>
										<cfelseif lVarMonedaP NEQ trim(_monedaLocal)>
											<cfset lVarPtotal = ReciboPago.Ptotal / ReciboPago.Ptipocambio>
										<cfelse>
											<cfset lVarPtotal = ReciboPago.Ptotal>
										</cfif>

                                        <cfif (lVarMonedaP EQ trim(_monedaLocal) and lVarMonedaDocRel NEQ lVarMonedaP) and ReciboPago.MontoPagoDoc lt lVarPtotal and saldoPago gt 0>

                                            <cfif saldoPago gte ( lVarPtotal - ReciboPago.MontoPagoDoc)>
										        <cfset lVarImportePagado = ReciboPago.MontoPagoDoc + (lVarPtotal - ReciboPago.MontoPagoDoc)>
                                                <cfset saldoPago -= lVarPtotal - ReciboPago.MontoPagoDoc>
                                            <cfelse>
										        <cfset lVarImportePagado = ReciboPago.MontoPagoDoc + saldoPago>
                                                <cfset saldoPago = 0>
                                            </cfif>
                                        <cfelse>
										    <cfset lVarImportePagado = ReciboPago.MontoPagoDoc>
                                        </cfif>

                                        <cfset lVarMontoDocRel  = rsDocRel.Dtotal>
										<cfset lVarMetodoDePagoDR = "PPD">
                                        <pago10:DoctoRelacionado IdDocumento = "#ReciboPago.TimbreFiscal#"
                                            <cfif arguments.ReciboPagoCxC EQ 1 OR arguments.ReciboPagoCxC EQ 2>
												<cfif isDefined("rsDocRel.Serie") AND #rsDocRel.Serie# NEQ "NA" AND isDefined("rsDocRel.Folio") AND #rsDocRel.Folio# NEQ "NA">
													Serie ="#rsDocRel.Serie#" Folio="#rsDocRel.Folio#"
												<cfelse>
													<!--- Si no trae una serie y folio, significa que no se pudo obtener la información del XML
													      o no existe. --->
													<cfset lVarLenString = #LEN(ReciboPago.Ddocumento)#>
                                                    Serie ="#MID(ReciboPago.Ddocumento,1,3)#" Folio="#(len(trim(ReciboPago.Ddocumento)) gt 3)?'#MID(ReciboPago.Ddocumento,4,lVarLenString)#':'#ReciboPago.Ddocumento#'#"
												</cfif>
											</cfif>
                                            MonedaDR = "#lVarMonedaDocRel#"
                                             
                                            <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0>
                                                ImpSaldoAnt="#NumberFormat(lVarPtotal,'0.00')#"
                                                <cfif lVarPtotal GT 0>
                                                    <cfset _ImpSaldoInsoluto="#NumberFormat((lVarPtotal - lVarImportePagado),'0.00')#">
                                                <cfelse>
                                                    <cfset _ImpSaldoInsoluto="#NumberFormat((lVarPtotal),'0.00')#">
                                                </cfif>
                                                <cfif _ImpSaldoInsoluto lte 0>
                                                    ImpSaldoInsoluto="0.00"
                                                <cfelse>
                                                    ImpSaldoInsoluto="#_ImpSaldoInsoluto#"
                                                </cfif>
                                            </cfif>
                                            

											<!--- MONEDA DEL PAGO --->
                                            <cfif _ImpSaldoInsoluto lt 0>
                                                <cfset lVarImportePagado = lVarPtotal>
                                            </cfif>
                                           <cfif lVarMonedaP NEQ lVarMonedaDocRel> TipoCambioDR ="1" </cfif>
                                            MetodoDePagoDR="#lVarMetodoDePagoDR#" NumParcialidad ="#ReciboPago.CantPagos#" ImpPagado = "#NumberFormat(lVarImportePagado,'9.00')#"
                                        />
                                    </cfif>
                                </cfloop>
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


    <cffunction  name="getDocRel">
        <cfargument  name="Ddocumento">

        <cfquery name="_rsDocRel" datasource="#session.dsn#">
            SELECT
                d.TimbreFiscal,
                COALESCE(CONVERT(varchar(30), Serie), 'NA') AS Serie,
                COALESCE(CONVERT(varchar(30), Folio), 'NA') AS Folio,
                d.Mcodigo,
                d.Dtipocambio AS OItipoCambio,
                f.codigo_TipoPago,
                d.Dtotal,
                d.Dsaldo,
                COALESCE(f.c_metPago, '06') AS c_metPago
                FROM Documentos d
                INNER JOIN CCTransacciones t
                ON t.Ecodigo = d.Ecodigo
                AND t.CCTcodigo = d.CCTcodigo
                LEFT JOIN FA_CFDI_Emitido e
                ON e.Ecodigo = d.Ecodigo
                AND e.timbre = d.TimbreFiscal
                LEFT JOIN FAEOrdenImpresion f
                ON d.Ecodigo = f.Ecodigo
                AND d.TimbreFiscal = f.TimbreFiscal
                WHERE d.Ecodigo = #session.Ecodigo#
                AND RTRIM(LTRIM(d.Ddocumento)) = '#TRIM(Arguments.Ddocumento)#'
                AND t.CCTtipo = 'D'
        </cfquery>

        <cfreturn _rsDocRel>
    </cffunction>

</cfcomponent>

