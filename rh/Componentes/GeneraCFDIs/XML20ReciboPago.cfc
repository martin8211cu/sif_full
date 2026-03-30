<!---
Componente desarrollado para Generar el XML correspondiente para Recibo de Pago
Escrito por: Giancarlo Benítez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (YYYY-MM-DD) Descripcion
--->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>

<!--- INICIA - Generacion de XML para Recibo de Pago --->
    <cffunction name="XML33ReciboPagoCFDI" returntype="string">
		<cfargument name="ReciboPago"       type="query"    required="yes">
        <cfargument name="Folio"            type="numeric"  required="yes">
        <cfargument name="Serie"            type="string"   required="yes">
        <cfargument name="ReciboPagoCxC"    type="numeric"   required="yes">

		<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
			select e.Mcodigo, e.Ecodigo, m.Miso4217
			from Empresa e
			inner join Moneda m
				on e.Mcodigo = m.Mcodigo
			where e.Ereferencia = #session.Ecodigo#
		</cfquery>
		<cfset _monedaLocal = rsMonedaLocal.Miso4217>


        <!---Tabla IVAS--->
        <cf_dbtemp name="rsTablaTotales" returnvariable="rsTablaTotales" datasource="#session.dsn#">
           
           <cf_dbtempcol name="MontoBaseCalcOri" type="money" >
           <cf_dbtempcol name="MontoBaseCalc"    type="money" >
           <!--- informacion de Ivas--->
           <cf_dbtempcol name="TotalIVAOri"      type="money" >
           <cf_dbtempcol name="TotalIVA"         type="money" >
           <cf_dbtempcol name="CodigoIVA"        type="varchar(25)" >
            <!--- Informacion de IEPS--->
           <cf_dbtempcol name="TotalIEPSOri"     type="money" >
           <cf_dbtempcol name="TotalIEPS"        type="money" >
           <cf_dbtempcol name="CodigoIEPS"       type="varchar(25)" >
            <!---Inormacion de Retenciones--->
           <cf_dbtempcol name="TotalRetOri"      type="money" >
           <cf_dbtempcol name="TotalRet"         type="money" >
           <cf_dbtempcol name="CodigoRet"        type="varchar(25)" >

           <!--- Campo para saber la moneda para los acumulados --->
           <cf_dbtempcol name="CodigoMonedaFact" type="varchar(25)">

           <!---Codigos para el llenado de XML --->
           <cf_dbtempcol name="ImpuestoDR"       type="varchar(25)" >
           <cf_dbtempcol name="TipoFactorDR"     type="varchar(25)" >
           <cf_dbtempcol name="TasaOCuotaDR"     type="float" >
        </cf_dbtemp>
        <!---Fin Tabla IVAS--->

        <!--- Datos de Emisor y receptor--->
		<cfset datosEmisor = GetLugarExpedicion(#session.Ecodigo#)>
		<cfquery name="rsRegFiscal" datasource="#session.dsn#">
			select ltrim(rtrim(ClaveSAT)) ClaveSAT from FARegFiscal where Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsCliente" datasource="#session.dsn#">
			select ltrim(rtrim(SNnombreFiscal)) SNnombre, ltrim(rtrim(SNidentificacion)) SNidentificacion,IdRegimenFiscal,SNcodigo,
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

        <!--- Obtener el Campo de Exportacion --->
        <cfquery name="rsExporta" datasource="#session.dsn#">
            select a.CSATdescripcion, a.CSATcodigo
            from CSATExportacion a
            inner join FAPreFacturaE e
            on a.IdExportacion = e.IdExportacion
            where e.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">                                
        </cfquery> 
        <!---Fin Obtener el Campo de Impuesto --->

        <!--- Obtener el Campo de regimenfiscal --->
        <cfquery name="rsRfisc" datasource="#session.dsn#">
            select c.CSATcodigo
            from CSATRegFiscal c
            inner join SNegocios s
            on c.IdRegFiscal = s.IdRegimenFiscal
            where s.SNcodigo =  #rsCliente.SNcodigo#          
            and s.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">       
        </cfquery>
        <!---Fin Obtener el Campo de regimenfiscal --->

        <!--- Obtener el Campo de codigo postal --->
        <cfquery name="rsRcodigoPostal" datasource="#session.dsn#">
            select codPostal dpostal 
            from DireccionesSIF c
            inner join SNegocios s
            on s.id_direccion = c.id_direccion
            where s.SNcodigo = #rsCliente.SNcodigo#        
            and s.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
        </cfquery>
        <!---Fin Obtener el Campo de postal --->


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
            <cfset lVarUsoCFDI			= "CP01">
            <cfset lVarPais				= rsCliente.Ppais>
            <cfset lVarNumRegIdTrib		= rsCliente.IdFisc>
            <cfset lVarConceptoPago		= "84111506|1|ACT|Pago|0|0">
            <cfset lVarComplementoPago	= "2.0">
            <cfset lVarFechaPago		= ReciboPago.fechaAplicaPago>
            <cfset lVarMonedaP			= getMoneda(ReciboPago.McodigoP)>
            <cfset lVarTipoCambioP		= ReciboPago.Ptipocambio>

            <!---Campos version 2.0 que se añadieron --->
            <cfset IVarExportacion= "01">
            <cfset IVarObjetoImpuesto = "01">
            <cfset IvarEquivalenciaDR = "1">
            <cfset lVarObjetoImp ="">
            <cfset lVarRegFiscC         = rsRFisc.CSATcodigo>
            <cfset lVarCodPostalRec   = rsRcodigoPostal.dpostal>           
            <!---Fin Campos version 2.0 que se añadieron --->
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
		    <CFXML VARIABLE="xml20">
                <cfdi:Comprobante 
                xmlns:cfdi="http://www.sat.gob.mx/cfd/4"   
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		            xmlns:pago20="http://www.sat.gob.mx/Pagos20"
		            xsi:schemaLocation="http://www.sat.gob.mx/cfd/4 http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsd
		                http://www.sat.gob.mx/Pagos20 http://www.sat.gob.mx/sitio_internet/cfd/Pagos/Pagos20.xsd"
		            Version="4.0"  
                    Folio="#Arguments.Folio#" 
                    Sello="." 
                    Serie="#Arguments.Serie#" 
                    SubTotal="0" 
                    NoCertificado="#lVarNoCertificado#"
		            Certificado="#lVarCertificado#" 
                    Fecha="#ReciboPago.FechaEnc#" 
                    Moneda="XXX" 
                    Total = "0" 
                    TipoDeComprobante="P"
		            LugarExpedicion="#lVarLugarExpedicion#"
                    Exportacion = "#IVarExportacion#">

		            <cfdi:Emisor Nombre = "#trim(lVarNombreEmisor)#" Rfc = "#trim(lVarRFCEmisor)#" RegimenFiscal = "#trim(lVarRegFiscal)#"/>

		            <cfdi:Receptor Rfc="#trim(fnSecuenciasEscape(lVarRFCCliente))#" Nombre="#trim(fnSecuenciasEscape(lVarNombreCliente,"no"))#" DomicilioFiscalReceptor ="#lVarCodPostalRec#"  RegimenFiscalReceptor="#lVarRegFiscC#"  UsoCFDI="#lVarUsoCFDI#"/>

                    <cfdi:Conceptos>
                        <cfdi:Concepto 
                        ClaveProdServ="84111506" 
                        Cantidad="1" 
                        ClaveUnidad ="ACT" 
                        Descripcion="Pago" 
                        ValorUnitario="0" 
                        Importe="0"
                        ObjetoImp = "#IVarObjetoImpuesto#"/>
                    </cfdi:Conceptos>

                    <cfdi:Complemento>
                        <!--- Manejador de Atributos Pagos --->
                        <pago20:Pagos 
                         Version="2.0">
                            <!---  Iniciamos el tratamiento de los atributos de pago20:Totales.  --->
                            <pago20:Totales
                                <!--- Obtiene los montos totales de los impuestos--->
                                <cfloop query="ReciboPago">
                                    <cfset rsDocRel = getDocRel( ReciboPago.Ddocumento )>
                                    <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>

                                    <!--- Se llama a la funcion para que se inserte los Impuestos --->
                                    <cfif ReciboPagoCxC eq 1>
                                        <cfset setTotalesImpuestosCobros(ReciboPago.DDocumento,rsDocRel.Mcodigo,ReciboPago.SNcodigo,lVarMonedaDocRel,lVarMonedaP)>
                                    <cfelse>
                                        <cfset setTotalesImpuestos(ReciboPago.DDocumento,rsDocRel.Mcodigo,ReciboPago.SNcodigo,lVarMonedaDocRel,lVarMonedaP)>
                                    </cfif>
                                    

                                </cfloop>
                               
                                <cfquery name="rsTablaTotalesTraslado" datasource="#session.dsn#">
                                    select CodigoIVA, sum(coalesce(TotalIVA,0)) as TotalIVA,
                                        CodigoIEPS,sum(coalesce(TotalIEPS,0)) as TotalIEPS, ImpuestoDR,
                                        TipoFactorDR,TasaOCuotaDR,sum(MontoBaseCalc) as MontoBaseCalc,
                                        sum(MontoBaseCalcOri) as MontoBaseCalcOri
                                    from #rsTablaTotales#
                                    where len(CodigoIVA) > 0
                                    group by CodigoIVA,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR
                                </cfquery>

                                <cfloop query = "rsTablaTotalesTraslado">
                                    <cfset lvarTrasladoBase = #NumberFormat(rsTablaTotalesTraslado.MontoBaseCalc,'9.00')#>
                                    <cfset lvarTrasladoImpuesto = #NumberFormat(rsTablaTotalesTraslado.TOTALIVA,'9.00')#>
                                    <cfset lvarPorcentaje = #rsTablaTotalesTraslado.TasaOCuotaDR#*100>

                                    TotalTrasladosBaseIVA#lvarPorcentaje# = "#NumberFormat(lvarTrasladoBase * lVarTipoCambioP,'9.00')#"
                                    <cfif lVarMonedaP neq _monedaLocal>
                                    
                                    TotalTrasladosImpuestoIVA#lvarPorcentaje# = "#NumberFormat(lvarTrasladoImpuesto * lVarTipoCambioP,'9.00')#"
                                    <cfelse>
                                    
                                    TotalTrasladosImpuestoIVA#lvarPorcentaje# = "#NumberFormat(rsTablaTotalesTraslado.TOTALIVA,'9.00')#"
                                    </cfif>
                                </cfloop>

                              

                                <cfquery name="rsMontoTotalPagos" datasource="#session.dsn#">
                                    select #lVarMonto# as Monto, #lVarTipoCambioP# as TC, round(#lVarMonto# * #lVarTipoCambioP#,2) as lVarMontoTotalPagos
                                    from dual
                                </cfquery>

                                <cfset lVarMontoTotalPagos  = #rsMontoTotalPagos.lVarMontoTotalPagos#>

                                MontoTotalPagos = "#NumberFormat(lVarMontoTotalPagos,'9.09')#"
                            ></pago20:Totales>

                            <pago20:Pago
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

                                TipoCambioP="#lVarTipoCambioP#"
                                Monto="#lVarMonto#">
                                
                                <cfquery dbtype="query" name="rsCalcTotalPagado">
                                    select sum(MontoPagoDoc) totalPagado
                                    from ReciboPago
                                </cfquery>
                                <cfset _totPagado = rsCalcTotalPagado.totalPagado>
                                <cfset _totDoc = 0>

                                <!---<cfloop query="ReciboPago">
                                    <cfset _lVarPtotal = 0>
                                    <cfif isDefined("ReciboPago.DPTipoCambioME")>
                                        <cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambioME>
                                    <cfelseif isDefined("ReciboPago.DPTipoCambio")>
                                        <cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambio>
                                    <cfelse>
                                        <cfset lVarTCMonDiferentes	=  ReciboPago.Ptipocambio>
                                    </cfif>
                                    
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
                                </cfloop>--->

                                <cfset saldoPago = 0>

                                <cfloop query="ReciboPago">
                                    <cfset lVarPtotal = 0>
                                    <cfif isDefined("ReciboPago.DPTipoCambioME")>
                                        <cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambioME>
                                    <cfelseif isDefined("ReciboPago.DPTipoCambio")>
                                        <cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambio>
                                    <cfelse>
                                        <cfset lVarTCMonDiferentes	=  ReciboPago.Ptipocambio>
                                    </cfif>

                                    <cfquery  datasource="#session.dsn#">
                                        delete from #rsTablaTotales#
                                    </cfquery> 

                                    <cfset rsDocRel = getDocRel( ReciboPago.Ddocumento )>
                                        <!--- Se llama a la funcion para que se inserte los Impuestos --->
                                        <cfif ReciboPagoCxC eq 1>
                                            <cfset setTotalesImpuestosCobros(ReciboPago.DDocumento,rsDocRel.Mcodigo,ReciboPago.SNcodigo)>
                                        <cfelse>
                                            <cfset setTotalesImpuestos(ReciboPago.DDocumento,rsDocRel.Mcodigo,ReciboPago.SNcodigo)>
                                        </cfif>
                                        

                                        <cfquery name="rsTablaTotalesTraslado" datasource="#session.dsn#">
                                            select CodigoIVA, sum(coalesce(TotalIVAOri,0)) as TotalIVAOri,
                                                sum(coalesce(TotalIVA,0)) as TotalIVA,
                                                CodigoIEPS,sum(coalesce(TotalIEPSOri,0)) as TotalIEPSOri, 
                                                sum(coalesce(TotalIEPS,0)) as TotalIEPS,ImpuestoDR,
                                                TipoFactorDR,TasaOCuotaDR,MontoBaseCalc,MontoBaseCalcOri
                                            from #rsTablaTotales#
                                            where (len(CodigoIVA) > 0 or len(CodigoIEPS) > 0 )
                                            group by CodigoIVA,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc,MontoBaseCalcOri
                                        </cfquery>

                                        
                                        <cfquery name="rsTablaTotalesRet" datasource="#session.dsn#">
                                            select CodigoRet,sum(coalesce(TotalRetOri,0)) as TotalRetOri, 
                                                sum(coalesce(TotalRetOri,0)) as TotalRet,
                                                ImpuestoDR,
                                                TipoFactorDR,TasaOCuotaDR,MontoBaseCalc,MontoBaseCalcOri
                                            from #rsTablaTotales#
                                            where len(CodigoRet) > 0 
                                            group by CodigoRet,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc,MontoBaseCalcOri
                                        </cfquery>								
                                    

                                    <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0>
                                        <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>
                                        
                                        <cfif lVarMonedaP EQ lVarMonedaDocRel>
											<cfset lVarPtotal = ReciboPago.Ptotal>
                                            <cfset _lVarPtotal = ReciboPago.DPmontodoc>
										<cfelseif lVarMonedaP EQ trim(_monedaLocal) and lVarMonedaDocRel NEQ lVarMonedaP>
											<cfset lVarPtotal = (ReciboPago.Ptotal / lVarTCMonDiferentes)>
                                            <cfset _lVarPtotal = (ReciboPago.DPmontodoc / lVarTCMonDiferentes)>
                                        <cfelseif lVarMonedaP NEQ trim(_monedaLocal)>
											<cfset lVarPtotal = ReciboPago.Ptotal / ReciboPago.Ptipocambio>
                                            <cfset _lVarPtotal = ReciboPago.Ptotal / ReciboPago.Ptipocambio>
										<cfelse>
											<cfset lVarPtotal = ReciboPago.Ptotal>
                                            <cfset _lVarPtotal = ReciboPago.Ptotal>
										</cfif>

                                        <cfif ReciboPago.MontoPagoDoc lte _lVarPtotal>
                                            <cfset _totDoc += _lVarPtotal>
                                        </cfif>
                                        <cfif (lVarMonedaP EQ trim(_monedaLocal) and lVarMonedaDocRel NEQ lVarMonedaP) and ReciboPago.MontoPagoDoc lt lVarPtotal and saldoPago gt 0>
                                            
                                            <cfif saldoPago gte ( lVarPtotal - ReciboPago.MontoPagoDoc)>
												
										        <!---<cfset lVarImportePagado = ReciboPago.MontoPagoDoc + (lVarPtotal - ReciboPago.MontoPagoDoc)>--->
												<cfif lVarMonedaDocRel NEQ lVarMonedaP>
													<cfset lVarImportePagado = ReciboPago.MontoPagoDoc * lVarTCMonDiferentes>
												<cfelse>
													<cfset lVarImportePagado = ReciboPago.MontoPagoDoc>
												</cfif>
                                                <cfset saldoPago -= lVarPtotal - ReciboPago.MontoPagoDoc>
                                            <cfelse>
                                                <cfif lVarMonedaDocRel NEQ lVarMonedaP>
													<cfset lVarImportePagado = ReciboPago.MontoPagoDoc * lVarTCMonDiferentes>
                                                <cfelse>
                                                    <cfset lVarImportePagado = ReciboPago.MontoPagoDoc>
                                                </cfif>
                                                <cfset saldoPago = 0>
                                            </cfif>
                                        <cfelse>
                                            <cfif lVarMonedaDocRel NEQ lVarMonedaP>
                                                <cfset lVarImportePagado = ReciboPago.MontoPagoDoc * lVarTCMonDiferentes>
                                               
                                            <cfelse>

										        <cfset lVarImportePagado = ReciboPago.MontoPagoDoc>
                                            </cfif>
                                        </cfif>
                                            
                                        <cfset lVarMontoDocRel  = rsDocRel.Dtotal>
										<cfset lVarMetodoDePagoDR = "PPD">
                                        <pago20:DoctoRelacionado IdDocumento = "#ReciboPago.TimbreFiscal#"
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

                                                <cfif lVarMonedaDocRel NEQ lVarMonedaP>
                                                    ImpSaldoAnt="#NumberFormat((lVarPtotal*lVarTCMonDiferentes),'0.00')#"
                                                <cfelse>
                                                    ImpSaldoAnt="#NumberFormat(lVarPtotal,'0.00')#"
                                                </cfif>
 
                                                <cfif lVarPtotal GT 0>
													<cfif lVarMonedaDocRel NEQ lVarMonedaP>
														<cfset _ImpSaldoInsoluto="#NumberFormat(((lVarPtotal*lVarTCMonDiferentes) - (lVarImportePagado)),'0.00')#">
													<cfelse>
                                                        <cfif lVarTCMonDiferentes neq ''>
														    <cfset _ImpSaldoInsoluto="#NumberFormat((lVarPtotal - (lVarImportePagado/lVarTCMonDiferentes)),'0.00')#">
                                                        <cfelse>
                                                            <cfset _ImpSaldoInsoluto="#NumberFormat((lVarPtotal - (lVarImportePagado)),'0.00')#">
                                                        </cfif> 
                                                    </cfif>
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

                                           

                                            NumParcialidad ="#ReciboPago.CantPagos#" 
                                            ImpPagado = "#NumberFormat(lVarImportePagado,'9.00')#"

                                            <cfset IvarObjImp = '01'>
                                            <cfif rsTablaTotalesRet.RecordCount GT 0 or rsTablaTotalesTraslado.RecordCount GT 0>
                                                <cfset IvarObjImp = '02'>
                                            </cfif>

                                            ObjetoImpDR = "#IvarObjImp#"      

                                            <cfif lVarMonedaDocRel NEQ trim(lVarMonedaP)>       
                                            EquivalenciaDR = "#NumberFormat(lVarTCMonDiferentes,'9.0000000000')#"
                                            <cfelse>
                                            EquivalenciaDR = "1"
                                            </cfif>
                                            >
                                            <cfif IvarObjImp eq 2>
                                            
                                                <pago20:ImpuestosDR>
                                                <cfif rsTablaTotalesRet.TotalRetOri neq "">
                                                            <pago20:RetencionesDR>
                                                                <cfloop query="#rsTablaTotalesRet#">
                                                                    <cfset base = #rsTablaTotalesRet.MontoBaseCalcOri# >
                                                                    <cfset impuesto = #rsTablaTotalesRet.ImpuestoDR#>
                                                                    <cfset tipofactor = #rsTablaTotalesRet.TipoFactorDR#>
                                                                    <cfset tasaocuota = #rsTablaTotalesRet.TasaOCuotaDR#>
                                                                    <cfset importe = #rsTablaTotalesRet.TotalRetOri#>
                                                                    <pago20:RetencionDR
                                                                        BaseDR="#LSNumberformat(base,'_.00')#"
                                                                        ImpuestoDR="#impuesto#"
                                                                        TipoFactorDR="#tipofactor#"
                                                                        TasaOCuotaDR="#LSNumberformat(tasaocuota,'9.000000')#"
                                                                        ImporteDR="#LSNumberformat(importe,'9.00')#"
                                                                        />
                                                                </cfloop>
                                                            </pago20:RetencionesDR>
                                                            </cfif>
                                                    <pago20:TrasladosDR>
                                                
                                                        <cfloop query="#rsTablaTotalesTraslado#">
                                                            <cfset base = #rsTablaTotalesTraslado.MontoBaseCalcOri#>
                                                            <cfset impuesto = #rsTablaTotalesTraslado.ImpuestoDR#>
                                                            <cfset tipofactor = #rsTablaTotalesTraslado.TipoFactorDR#>
                                                            <cfset tasaocuota = #rsTablaTotalesTraslado.TasaOCuotaDR#>
                                                            <cfif len(rsTablaTotalesTraslado.CodigoIVA) GT 0>
                                                                <cfset importe = #rsTablaTotalesTraslado.TotalIVAOri#>
                                                            <cfelseif len(rsTablaTotalesTraslado.CodigoIEPS) GT 0>
                                                                <cfset importe = #rsTablaTotalesTraslado.TotalIEPSOri#>
                                                            </cfif>

                                                            <!---<cfdump var="#rsTablaTotalesTraslado#" abort>--->

                                                            <pago20:TrasladoDR
                                                                BaseDR="#LSNumberformat(base,'_.00')#"
                                                                ImpuestoDR="#impuesto#"
                                                                TipoFactorDR="#tipofactor#"
                                                                TasaOCuotaDR="#LSNumberformat(tasaocuota,'9.000000')#"
                                                                ImporteDR="#LSNumberformat(importe,'9.00')#"
                                                                />
                                                        </cfloop>
                                                    </pago20:TrasladosDR>
                                                </pago20:ImpuestosDR>
                                            </cfif>
                                        </pago20:DoctoRelacionado>
                                    </cfif>
                                </cfloop>

                                <cfquery  datasource="#session.dsn#">
                                    delete from #rsTablaTotales#
                                </cfquery>
                                
                                <cfloop query="ReciboPago">
                                    <cfset rsDocRel = getDocRel( ReciboPago.Ddocumento )>
                                    <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>

                                    <!--- Se llama a la funcion para que se inserte los Impuestos --->
                                    <cfif ReciboPagoCxC eq 1>
                                        <cfset setTotalesImpuestosCobros(ReciboPago.DDocumento,rsDocRel.Mcodigo,ReciboPago.SNcodigo,lVarMonedaDocRel,lVarMonedaP)>
                                    <cfelse>
                                        <cfset setTotalesImpuestos(ReciboPago.DDocumento,rsDocRel.Mcodigo,ReciboPago.SNcodigo,lVarMonedaDocRel,lVarMonedaP)>
                                    </cfif>
                                    
                                </cfloop>
                                
                                <cfquery name="rsTablaTotalesTraslado" datasource="#session.dsn#">
                                    select CodigoIVA, sum(coalesce(TotalIVA,0)) as TotalIVA, sum(coalesce(TotalIVAOri,0)) as TotalIVAOri,
                                        CodigoIEPS,sum(coalesce(TotalIEPS,0)) as TotalIEPS, sum(coalesce(TotalIEPSOri,0)) as TotalIEPSOri, ImpuestoDR,
                                        TipoFactorDR,TasaOCuotaDR,sum(MontoBaseCalc) as MontoBaseCalc,sum(MontoBaseCalcOri) as MontoBaseCalcOri
                                    from #rsTablaTotales#
                                    where (len(CodigoIVA) > 0 or len(CodigoIEPS) > 0 )
                                    group by CodigoIVA,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR
                                </cfquery>
                                <!---<cf_dumptable var="#rsTablaTotales#" >---->
                                <cfif IvarObjImp eq 2>
                                    <pago20:ImpuestosP>
                                        <pago20:TrasladosP>

                                            <cfloop query="#rsTablaTotalesTraslado#">
                                                <cfset baseP = #rsTablaTotalesTraslado.MontoBaseCalc#>
                                                <cfset impuestoP = #rsTablaTotalesTraslado.ImpuestoDR#>
                                                <cfset tipofactorP = #rsTablaTotalesTraslado.TipoFactorDR#>
                                                <cfset tasaocuotaP = #rsTablaTotalesTraslado.TasaOCuotaDR#>
                                                <cfif len(rsTablaTotalesTraslado.CodigoIVA) GT 0>
                                                    <cfset importeP = #rsTablaTotalesTraslado.TotalIVA#>
                                                <cfelseif len(rsTablaTotalesTraslado.CodigoIEPS) GT 0>
                                                    <cfset importeP = #rsTablaTotalesTraslado.TotalIEPS#>
                                                </cfif>

                                                

                                                <pago20:TrasladoP 
                                                    BaseP="#LSNumberformat(baseP,'_.00')#" 
                                                    ImpuestoP="#impuestoP#" 
                                                    TipoFactorP="#tipofactorP#" 
                                                    TasaOCuotaP="#LSNumberformat(tasaocuotaP,'9.000000')#" 
                                                    ImporteP="#LSNumberformat(importeP,'9.00')#"/>
                                            </cfloop>
                                        </pago20:TrasladosP>
                                    </pago20:ImpuestosP>
                                </cfif>
                            </pago20:Pago>
                        </pago20:Pagos>
                    </cfdi:Complemento>
		        </cfdi:Comprobante>
		    </CFXML>
		</cfoutput>
        <!--- FIN - Construccion de XML--->
    
        <!--- Remover Caracteres especiales --->
        <cfset xml20 = cleanXML(xml20)>

		<cfset xml20 = replace(xml20,"Fecha", " Fecha", "All")>

		<cfreturn xml20>
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

    <cffunction  name="setTotalesImpuestos">
        <cfargument name="Documento"	  type="string"	 required = "yes"> <!--- Nombre de la Factura Relacionada  --->
        <cfargument name="McodigoDoc"     type="numeric" required = "yes"> <!--- Mcodigo de la Factura Relacionada  --->
        <cfargument name="SNcodigo"       type="numeric" required = "yes"> <!--- SNcodigo de la Factura Relacionada  --->
        <cfargument name="MonedaRel" 	  type="string"  required="false" default="-1"> <!--- Siglas de la Moneda de la Factura Relacionada --->
        <cfargument name="MonedaPago" 	  type="string"  required="false" default="-1"> <!--- Siglas de la Moneda del Pago --->
        <cfargument name="Ecodigo" 		  type="numeric" required="false" default="#Session.Ecodigo#"><!--- Mcodigo de la Factura Relacionada  --->
        <cfargument name="Conexion" 	  type="string"  required="false" default="#Session.dsn#">

        <cfquery name="rsPruebaIVAS" datasource="#Arguments.Conexion#">
            insert into #rsTablaTotales# (TotalIVAOri,TotalIVA,CodigoIVA,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalcOri,MontoBaseCalc)
            select
                    round(((cast(Det.DFmontodoc as float)/ cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float)*(c.Iporcentaje/100) )) ,2) as TotalIVAOri,
               
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        <cfif _monedaLocal EQ Arguments.MonedaPago>
                            (round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))),2) / round(Det.DFtipocambio,10) * a.EFtipocambio/#lVarTipoCambioP#) as TotalIVA,
                        <cfelse>
                            (round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))),2) / round(Det.DFtipocambio,10) * a.EFtipocambio/#lVarTipoCambioP#) as TotalIVA,
                        </cfif>
                    <cfelse>
                        round(((cast(Det.DFmontodoc as float)/ cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float)*(c.Iporcentaje/100) )) ,2) as TotalIVA,
                    </cfif>
                    i.Icodigo,
                    i.ClaveSAT,
                    i.TipoFactor,
                    (i.Iporcentaje/ 100) as TasaOCuotaDR,
                    round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalcOri,
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        <cfif _monedaLocal EQ Arguments.MonedaPago>
                            ((round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))),2) / round(Det.DFtipocambio,10) * a.EFtipocambio)/#lVarTipoCambioP#) as MontoBaseCalc
                        <cfelse>
                            ((round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))),2) / round(Det.DFtipocambio,10) * a.EFtipocambio)/#lVarTipoCambioP#) as MontoBaseCalc
                        </cfif>
                    <cfelse>
                         round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalc
                    </cfif>
                from EFavor  a
                    inner join  DFavor Det
                        ON Det.Ecodigo = a.Ecodigo
                        and a.CCTcodigo = Det.CCTcodigo
                        and a.Ddocumento = Det.Ddocumento
                    inner join  Documentos b
                        on Det.Ecodigo = b.Ecodigo
                        and Det.CCTRcodigo = b.CCTcodigo
                        and Det.DRdocumento = b.Ddocumento
                    inner join ImpDocumentosCxC c
                        on Det.Ecodigo = c.Ecodigo
                        and Det.CCTRcodigo  = c.CCTcodigo
                        and Det.DRdocumento  =  c.Documento
                    inner join CCTransacciones d
                        on c.Ecodigo = d.Ecodigo
                        and c.CCTcodigo = d.CCTcodigo
                    inner join Impuestos i
                        on c.Ecodigo = i.Ecodigo
                        and c.Icodigo = i.Icodigo
                where a.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">  
                        and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.McodigoDoc#">  
                        and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">  
                        and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
                group by b.Mcodigo,Det.DFmontodoc,c.TotalFac,i.Iporcentaje,Det.DFtipocambio,a.EFtipocambio,i.Icodigo,c.MontoCalculado,i.ClaveSAT,
                    i.TipoFactor,c.MontoBaseCalc,c.SubTotalFac, c.Iporcentaje
        </cfquery>
    
        <cfquery name="rsPruebaIEPS" datasource="#Arguments.Conexion#">
            insert into #rsTablaTotales# (TotalIEPSOri,TotalIEPS,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalcOri,MontoBaseCalc)
            select     
                round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))) ,2) as TotalIEPSOri,
                <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                    <cfif _monedaLocal EQ Arguments.MonedaPago>
                        round((round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))),2) / round(Det.DFtipocambio,10) * a.EFtipocambio/#lVarTipoCambioP#),2) as TotalIEPS,
                    <cfelse>
                        round((((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))) / round(Det.DFtipocambio,10) * a.EFtipocambio/#lVarTipoCambioP#),2) as TotalIEPS,
                    </cfif>
                <cfelse>
                    round(((cast(Det.DFmontodoc as float)/ cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))) ,2) as TotalIVA,
                </cfif>
                i.Icodigo,
                i.ClaveSAT,
                i.TipoFactor,
                i.TasaOCuota as TasaOCuotaDR,
                round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalcOri,
                <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                    <cfif _monedaLocal EQ Arguments.MonedaPago>
                        round((round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))),2) / round(Det.DFtipocambio,10) * a.EFtipocambio)/#lVarTipoCambioP#,2) as MontoBaseCalc
                    <cfelse>
                        round((((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) / round(Det.DFtipocambio,10) * a.EFtipocambio)/#lVarTipoCambioP#,2) as MontoBaseCalc
                    </cfif>
                <cfelse>
                        round(((cast(Det.DFmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalc
                </cfif>
            from EFavor a 
            inner join DFavor Det 
                ON Det.Ecodigo = a.Ecodigo and a.CCTcodigo = Det.CCTcodigo and a.Ddocumento = Det.Ddocumento 
            inner join Documentos b 
                on Det.Ecodigo = b.Ecodigo and Det.CCTRcodigo = b.CCTcodigo and Det.DRdocumento = b.Ddocumento 
            <!---inner  join DDocumentos bb
                    on bb.Ddocumento =b.Ddocumento
                    and bb.Ecodigo =b.Ecodigo--->
            inner join ImpIEPSDocumentosCxC c on Det.Ecodigo = c.Ecodigo 
                and b.CCTcodigo = c.CCTcodigo 
                and b.Ddocumento = c.Documento 
            inner join CCTransacciones d on c.Ecodigo = d.Ecodigo and c.CCTcodigo = d.CCTcodigo 
            inner join Impuestos i on c.Ecodigo = i.Ecodigo and c.codIEPS = i.Icodigo
            where a.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">  
                and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.McodigoDoc#"> 
                and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#"> 
                and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
                group by b.Mcodigo,Det.DFmontodoc,c.TotalFac,i.TasaOCuota,Det.DFtipocambio,a.EFtipocambio,i.Icodigo,c.MontoCalculado,i.ClaveSAT,
                i.TipoFactor,c.MontoBaseCalc
        </cfquery>


        <cfquery name="rsPruebaRetenciones" datasource="#Arguments.Conexion#">
            insert into #rsTablaTotales# (TotalRetOri,TotalRet,CodigoRet,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalcOri,MontoBaseCalc)
            select  
                    round( (CAST(Det.DFmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) as TotalRetOri,
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        round((round((CAST(Det.DFmontodoc as float) /CAST(c.TotalFac as float)) * ( CAST((sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) / ROUND(Det.DFtipocambio,6) * a.EFtipocambio/#lVarTipoCambioP#),2) as TotalRet,
                    <cfelse>
                        round( (CAST(Det.DFmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) as TotalRet,
                    </cfif>
                    i.Icodigo,
                    i.ClaveSAT,
                    i.TipoFactor,
                    (i.Iporcentaje/ 100) as TasaOCuotaDR,
                    round( (CAST(Det.DFmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal)) as float) ),2) as MontoBaseCalcOri,
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        round((round((CAST(Det.DFmontodoc as float) /CAST(c.TotalFac as float)) * ( CAST((sum(bb.DDtotal)) as float) ),2) / ROUND(Det.DFtipocambio,6) * a.EFtipocambio/#lVarTipoCambioP#),2) as MontoBaseCalc
                    <cfelse>
                        round( (CAST(Det.DFmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal)) as float) ),2) as MontoBaseCalc
                    </cfif>
            FROM EFavor a
                INNER JOIN DFavor Det ON a.Ecodigo = Det.Ecodigo
                    AND a.CCTcodigo = Det.CCTcodigo
                    AND a.Ddocumento = Det.Ddocumento
                INNER JOIN Documentos b ON Det.Ecodigo = b.Ecodigo
                    AND Det.CCTRcodigo = b.CCTcodigo
                    AND Det.DRdocumento = b.Ddocumento
                inner  join DDocumentos bb
                    on bb.Ddocumento =b.Ddocumento
                    and bb.Ecodigo =b.Ecodigo
                INNER JOIN ImpDocumentosCxC c ON Det.Ecodigo = c.Ecodigo
                    AND Det.CCTRcodigo = c.CCTcodigo
                    AND Det.DRdocumento = c.Documento
                INNER JOIN Impuestos i 
                    ON bb.Ecodigo = i.Ecodigo
                    AND bb.Rcodigo = i.Icodigo
            where a.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
                    and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.McodigoDoc#"> 
                    and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#"> 
                    and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
            and b.EDMRetencion > 0
            group by b.Mcodigo,Det.DFmontodoc,c.TotalFac,i.Iporcentaje,Det.DFtipocambio,a.EFtipocambio,i.Icodigo,c.MontoCalculado,i.ClaveSAT,
                i.TipoFactor,i.Iporcentaje,MontoBaseCalc
        </cfquery>
    </cffunction>



   <cffunction  name="setTotalesImpuestosCobros">
        <cfargument name="Documento"	  type="string"	 required = "yes"> <!--- Nombre de la Factura Relacionada  --->
        <cfargument name="McodigoDoc"     type="numeric" required = "yes"> <!--- Mcodigo de la Factura Relacionada  --->
        <cfargument name="SNcodigo"       type="numeric" required = "yes"> <!--- SNcodigo de la Factura Relacionada  --->
        <cfargument name="MonedaRel" 	  type="string"  required="false" default="-1"> <!--- Siglas de la Moneda de la Factura Relacionada --->
        <cfargument name="MonedaPago" 	  type="string"  required="false" default="-1"> <!--- Siglas de la Moneda del Pago --->
        <cfargument name="Ecodigo" 		  type="numeric" required="false" default="#Session.Ecodigo#"><!--- Mcodigo de la Factura Relacionada  --->
        <cfargument name="Conexion" 	  type="string"  required="false" default="#Session.dsn#">

        <cfquery name="rsPruebaIVAS" datasource="#Arguments.Conexion#">
            insert into #rsTablaTotales# (TotalIVAOri,TotalIVA,CodigoIVA,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalcOri,MontoBaseCalc)
            select
                    round(((cast(Det.DPmontodoc as float)/ cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float)*(c.Iporcentaje/100) )) ,2) as TotalIVAOri,
               
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        <cfif _monedaLocal EQ Arguments.MonedaPago>
                            (round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))),2) / round(Det.DPtipocambio,10) * a.Ptipocambio/#lVarTipoCambioP#) as TotalIVA,
                        <cfelse>
                            (round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))),2) / round(Det.DPtipocambio,10) * a.Ptipocambio/#lVarTipoCambioP#) as TotalIVA,
                        </cfif>
                    <cfelse>
                        round(((cast(Det.DPmontodoc as float)/ cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float)*(c.Iporcentaje/100) )) ,2) as TotalIVA,
                    </cfif>
                    i.Icodigo,
                    i.ClaveSAT,
                    i.TipoFactor,
                    (i.Iporcentaje/ 100) as TasaOCuotaDR,
                    round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalcOri,
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        <cfif _monedaLocal EQ Arguments.MonedaPago>
                            ((round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))),2) / round(Det.DPtipocambio,10) * a.Ptipocambio)/#lVarTipoCambioP#) as MontoBaseCalc
                        <cfelse>
                            ((round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))),2) / round(Det.DPtipocambio,10) * a.Ptipocambio)/#lVarTipoCambioP#) as MontoBaseCalc
                        </cfif>
                    <cfelse>
                         round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalc
                    </cfif>
                from Pagos  a
                    inner join  Dpagos Det
                        ON Det.Ecodigo = a.Ecodigo 
                        AND a.CCTcodigo = Det.CCTcodigo
                        AND a.Pcodigo = Det.Pcodigo
                    inner join  Documentos b
                        on Det.Ecodigo = b.Ecodigo 
                        AND Det.Doc_CCTcodigo = b.CCTcodigo
                        AND Det.Ddocumento = b.Ddocumento 
                    inner join ImpDocumentosCxC c
                        on Det.Ecodigo = c.Ecodigo
                        and b.CCTcodigo = c.CCTcodigo 
                        and b.Ddocumento = c.Documento 
                    inner join CCTransacciones d
                        on c.Ecodigo = d.Ecodigo
                        and c.CCTcodigo = d.CCTcodigo
                    inner join Impuestos i
                        on c.Ecodigo = i.Ecodigo
                        and c.Icodigo = i.Icodigo
                where a.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">  
                        and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.McodigoDoc#">  
                        and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">  
                        and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
                group by b.Mcodigo,Det.DPmontodoc,c.TotalFac,i.Iporcentaje,Det.DPtipocambio,a.Ptipocambio,i.Icodigo,c.MontoCalculado,i.ClaveSAT,
                    i.TipoFactor,c.MontoBaseCalc,c.SubTotalFac, c.Iporcentaje
        </cfquery>
    
        <cfquery name="rsPruebaIEPS" datasource="#Arguments.Conexion#">
            insert into #rsTablaTotales# (TotalIEPSOri,TotalIEPS,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalcOri,MontoBaseCalc)
            select     
                round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))) ,2) as TotalIEPSOri,
                <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                    <cfif _monedaLocal EQ Arguments.MonedaPago>
                        round((round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))),2) / round(Det.DPtipocambio,10) * a.Ptipocambio/#lVarTipoCambioP#),2) as TotalIEPS,
                    <cfelse>
                        round((((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))) / round(Det.DPtipocambio,10) * a.Ptipocambio/#lVarTipoCambioP#),2) as TotalIEPS,
                    </cfif>
                <cfelse>
                    round(((cast(Det.DPmontodoc as float)/ cast(c.TotalFac as float)) * (cast(c.MontoCalculado as float))) ,2) as TotalIVA,
                </cfif>
                i.Icodigo,
                i.ClaveSAT,
                i.TipoFactor,
                i.TasaOCuota as TasaOCuotaDR,
                round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalcOri,
                <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                    <cfif _monedaLocal EQ Arguments.MonedaPago>
                        round((round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))),2) / round(Det.DPtipocambio,10) * a.Ptipocambio)/#lVarTipoCambioP#,2) as MontoBaseCalc
                    <cfelse>
                        round((((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) / round(Det.DPtipocambio,10) * a.Ptipocambio)/#lVarTipoCambioP#,2) as MontoBaseCalc
                    </cfif>
                <cfelse>
                        round(((cast(Det.DPmontodoc as float) / cast(c.TotalFac as float)) * (cast(c.MontoBaseCalc as float))) ,2) as MontoBaseCalc
                </cfif>
            from Pagos a 
            inner join Dpagos Det 
                ON Det.Ecodigo = a.Ecodigo 
                AND a.CCTcodigo = Det.CCTcodigo
                AND a.Pcodigo = Det.Pcodigo
            inner join Documentos b 
                on Det.Ecodigo = b.Ecodigo 
                AND Det.Doc_CCTcodigo = b.CCTcodigo
                AND Det.Ddocumento = b.Ddocumento 
            inner join ImpIEPSDocumentosCxC c on Det.Ecodigo = c.Ecodigo 
                and b.CCTcodigo = c.CCTcodigo 
                and b.Ddocumento = c.Documento 
            inner join CCTransacciones d 
            on c.Ecodigo = d.Ecodigo 
            and c.CCTcodigo = d.CCTcodigo 
            inner join Impuestos i on c.Ecodigo = i.Ecodigo and c.codIEPS = i.Icodigo
            where a.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">  
                and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.McodigoDoc#"> 
                and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#"> 
                and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
                group by b.Mcodigo,Det.DPmontodoc,c.TotalFac,i.TasaOCuota,Det.DPtipocambio,a.Ptipocambio,i.Icodigo,c.MontoCalculado,i.ClaveSAT,
                i.TipoFactor,c.MontoBaseCalc
        </cfquery>


        <cfquery name="rsPruebaRetenciones" datasource="#Arguments.Conexion#">
            insert into #rsTablaTotales# (TotalRetOri,TotalRet,CodigoRet,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalcOri,MontoBaseCalc)
            select  
                    round( (CAST(Det.DPmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) as TotalRetOri,
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        round((round((CAST(Det.DPmontodoc as float) /CAST(c.TotalFac as float)) * ( CAST((sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) / ROUND(Det.DPtipocambio,6) * a.Ptipocambio/#lVarTipoCambioP#),2) as TotalRet,
                    <cfelse>
                        round( (CAST(Det.DPmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) as TotalRet,
                    </cfif>
                    i.Icodigo,
                    i.ClaveSAT,
                    i.TipoFactor,
                    (i.Iporcentaje/ 100) as TasaOCuotaDR,
                    round( (CAST(Det.DPmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal)) as float) ),2) as MontoBaseCalcOri,
                    <cfif Arguments.MonedaPago NEQ Arguments.MonedaRel>
                        round((round((CAST(Det.DPmontodoc as float) /CAST(c.TotalFac as float)) * ( CAST((sum(bb.DDtotal)) as float) ),2) / ROUND(Det.DPtipocambio,6) * a.Ptipocambio/#lVarTipoCambioP#),2) as MontoBaseCalc
                    <cfelse>
                        round( (CAST(Det.DPmontodoc as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal)) as float) ),2) as MontoBaseCalc
                    </cfif>
            FROM Pagos a
                INNER JOIN DPagos Det ON a.Ecodigo = Det.Ecodigo
                    AND a.CCTcodigo = Det.CCTcodigo
                    AND a.Pcodigo = Det.Pcodigo
                INNER JOIN Documentos b ON Det.Ecodigo = b.Ecodigo
                    AND Det.Doc_CCTcodigo = b.CCTcodigo
                    AND Det.Ddocumento = b.Ddocumento
                inner  join DDocumentos bb
                    on bb.Ddocumento =b.Ddocumento
                    and bb.Ecodigo =b.Ecodigo
                INNER JOIN ImpDocumentosCxC c ON Det.Ecodigo = c.Ecodigo
                    AND Det.Doc_CCTcodigo = c.CCTcodigo
                    AND Det.Ddocumento = c.Documento
                INNER JOIN Impuestos i 
                    ON bb.Ecodigo = i.Ecodigo
                    AND bb.Rcodigo = i.Icodigo
            where a.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
                    and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.McodigoDoc#"> 
                    and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#"> 
                    and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
            and b.EDMRetencion > 0
            group by b.Mcodigo,Det.DPmontodoc,c.TotalFac,i.Iporcentaje,Det.DPtipocambio,a.Ptipocambio,i.Icodigo,c.MontoCalculado,i.ClaveSAT,
                i.TipoFactor,i.Iporcentaje,MontoBaseCalc
        </cfquery>

    </cffunction>

</cfcomponent>

