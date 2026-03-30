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


        <!---Tabla IVAS--->
        <cf_dbtemp name="rsTablaTotales" returnvariable="rsTablaTotales" datasource="#session.dsn#">

           <cf_dbtempcol name="MontoBaseCalc"      type="money" >
            <!-- informacion de Ivas-->
           <cf_dbtempcol name="TotalIVA"      type="money" >
           <cf_dbtempcol name="CodigoIVA"     type="varchar(25)" >
            <!-- Informacion de IEPS-->
           <cf_dbtempcol name="TotalIEPS"     type="money" >
           <cf_dbtempcol name="CodigoIEPS"    type="varchar(25)" >
            <!--Inormacion de Retenciones-->
           <cf_dbtempcol name="TotalRet"      type="money" >
           <cf_dbtempcol name="CodigoRet"     type="varchar(25)" >

           <!---Codigos para el llenado de XML --->
           <cf_dbtempcol name="ImpuestoDR"    type="varchar(25)" >
           <cf_dbtempcol name="TipoFactorDR"  type="varchar(25)" >
           <cf_dbtempcol name="TasaOCuotaDR"  type="float" >
        </cf_dbtemp>


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
            <!--- Obtener el Campo de Uso CFDI --->
                <cfquery name="rsUsoCFDI" datasource="#session.dsn#">
                    select IdUsoCFDI,CSATcodigo
                    from CSATUsoCFDI
			        where IdUsoCFDI = #rsCliente.IdRegimenFiscal#    
                </cfquery>
            <!---Fin Obtener el Campo de Uso CFDI --->

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
            <cfset lVarTipoCambioP		= "01">
			<cfif isDefined("ReciboPago.DPTipoCambioME")>
                <cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambioME>
			<cfelseif isDefined("ReciboPago.DPTipoCambio")>
				<cfset lVarTCMonDiferentes	= ReciboPago.DPTipoCambio>
			<cfelse>
				<cfset lVarTCMonDiferentes	=  ReciboPago.Ptipocambio>
			</cfif>
            <cfset lVarMonto			= #NumberFormat(rsTotal.Ptotal,'9.00')#>
		    <cfset lVarFormaDePagoP		= "#arguments.ReciboPago.CodTipoPago#"> <!--- se actualiza mas a delante, 03 por default--->
            <cfset lVarRfcEmisorCtaOrd  = "">
            <cfset lVarCtaOrdenante     = "">
            <cfset lVarRfcEmisorCtaBen  = "">
            <cfset lVarCtaBeneficiario  = "">
            <cfset lVarBancoExtranjero  = "">
            <cfset IVarTipoCambio = "1">



        <!---Campos version 2.0 que se añadieron --->
            
            <cfset IVarExportacion= "01">
            <cfset IVarObjetoImpuesto = "01">
            <cfset IvarEquivalenciaDR = "1">
            <cfset lVarObjetoImp ="">
            <cfset lVarRegFiscC         = rsRFisc.CSATcodigo>
            <cfset lVarCodPostalRec   = rsRcodigoPostal.dpostal>

             <!--- VARIABLE DE MONTO TOTAL --->
            <cfset lVarMonto			= #NumberFormat(rsTotal.Ptotal,'9.00')#>
            <cfset lVarMontoTotal		= #NumberFormat(rsTotal.Ptotal * lVarTCMonDiferentes,'9.00')#>
		    <cfset lVarFormaDePagoP		= "#arguments.ReciboPago.CodTipoPago#"> <!--- se actualiza mas a delante, 03 por default--->
            <cfset lVarRfcEmisorCtaOrd  = "">
            <cfset lVarCtaOrdenante     = "">
            <cfset lVarRfcEmisorCtaBen  = "">
            <cfset lVarCtaBeneficiario  = "">
            <cfset lVarBancoExtranjero  = "">
            <cfset IVarTipoCambio = "1">           
        <!---Fin Campos version 2.0 que se añadieron --->

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

        <cfquery dbtype="query" name="rsCalcTotalPagado">
            select sum(MontoPagoDoc) totalPagado
            from ReciboPago
        </cfquery>
        <cfset _totPagado = rsCalcTotalPagado.totalPagado>
        <cfset _totDoc = 0>
        
        <!--Query para Tipo de Moneda de la Factura-->
		<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
			select e.Mcodigo, e.Ecodigo, m.Miso4217
			from Empresa e
			inner join Moneda m
				on e.Mcodigo = m.Mcodigo
			where e.Ereferencia = #session.Ecodigo#
		</cfquery>
        <!--Fin Query para Tipo de Moneda de la Factura-->

        <!--Query para Valor de la Moneda de la Factura-->
        <cfquery name="rsvalormoneda" datasource="#session.dsn#">
            select MS.Mcodigo as McodigoMoneda,* from Monedas MS
            inner join Moneda M
            on M.Miso4217 = MS.Miso4217
            inner join Empresa E
            on E.Ereferencia = MS.Ecodigo
            where E.Ereferencia = #session.Ecodigo# and M.Miso4217 = '#rsMonedaLocal.Miso4217#'
		</cfquery>
        <!--Fin Query para Valor de la Moneda de la Factura-->
        <cfset _monedaLocal = rsMonedaLocal.Miso4217>
        <cfset IvarTipoMoneda = rsvalormoneda.McodigoMoneda>



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
                    Total="0" 
                    TipoDeComprobante="P"
		            LugarExpedicion="#lVarLugarExpedicion#"
                    Exportacion = "#IVarExportacion#">

		            <cfdi:Emisor 
                        Nombre = "#trim(lVarNombreEmisor)#" 
                        Rfc = "#trim(lVarRFCEmisor)#" 
                        RegimenFiscal = "#trim(lVarRegFiscal)#"/>

		            <cfdi:Receptor 
                    <!---Nombre="APLICATION HOSTING"--->
                    Nombre="#trim(lVarNombreCliente)#"
                    Rfc="#trim(lVarRFCCliente)#"
                    DomicilioFiscalReceptor ="#lVarCodPostalRec#" 
                    RegimenFiscalReceptor="#lVarRegFiscC#" 
                    UsoCFDI="#lVarUsoCFDI#"/>

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
                        <pago20:Pagos Version="2.0">
                            <pago20:Totales MontoTotalPagos = "#lVarMontoTotal#"></pago20:Totales>
                            <pago20:Pago
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

                                TipoCambioP="#lVarTCMonDiferentes#"
                                Monto="#lVarMonto#">

                                <cfset saldoPago = _totPagado - _totDoc>

                                <cfloop query="ReciboPago">
                                    <cfquery  datasource="#session.dsn#">
                                        delete from #rsTablaTotales#
                                    </cfquery> 

                                    <cfset rsDocRel = getDocRel( ReciboPago.Ddocumento )>
                               
                                    <cfquery name="rsPruebaIVAS" datasource="#session.dsn#">
                                            insert into #rsTablaTotales# (TotalIVA,CodigoIVA,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc)                                           
                                            select 
                                            	case 
                                                when b.Mcodigo = #IvarTipoMoneda# AND c.MontoCalculado <= 0 
                                            	then 
                                            		round(( (cc.Dmonto / c.TotalFac) * (c.MontoPagado) ) ,2) 
                                                
                                                when c.MontoCalculado <= 0
                                                then
                                                    round( round(( (cc.Dmonto / c.TotalFac) * (c.MontoPagado) ) ,2) / hd.Dtipocambio * b.Dtipocambio,2) 
                                            	
                                                when b.Mcodigo = #IvarTipoMoneda# AND c.MontoCalculado > 0
                                            	then 
                                            		round(( (cc.Dmonto / c.TotalFac) * (c.MontoCalculado) ) ,2)

                                                when c.MontoCalculado > 0
                                                then
                                                    round( round(( (cc.Dmonto / c.TotalFac) * (c.MontoCalculado) ) ,2) / hd.Dtipocambio * b.Dtipocambio,2)                                                 

                                            	end as MontoIVATotal
                                            , i.Icodigo
                                            , i.ClaveSAT
                                            , i.TipoFactor
                                            /*, c.MontoCalculado
                                            , c.MontoPagado*/
                                            , (i.Iporcentaje/ 100) as TasaOCuotaDR
                                            , case when b.Mcodigo = #IvarTipoMoneda#
                                            then 
                                            	round(( (cc.Dmonto / c.TotalFac) * (c.MontoBaseCalc) ) ,2) 
                                            else 
                                            	round( round(( (cc.Dmonto / c.TotalFac) * (c.MontoBaseCalc) ) ,2) / hd.Dtipocambio * b.Dtipocambio,2) 
                                            end as MontoBaseCalc
                                            from Documentos b 
                                            inner join DocCompensacionDCxC cc 
                                            		   ON b.Ecodigo = cc.Ecodigo 
                                            		   and b.CCTcodigo = cc.CCTcodigo 
                                            		   and b.Ddocumento = cc.Ddocumento 
                                            left join Efavor aa 
                                            		   on cc.Ecodigo = aa.Ecodigo 
                                            		   and cc.CCTcodigo = aa.CCTcodigo 
                                            		   and cc.Ddocumento = aa.Ddocumento
                                            inner join HDocumentos hd
                                            		   on cc.Ecodigo=hd.Ecodigo
                                            		   and cc.CCTcodigo = hd.CCTcodigo
                                            		   and cc.Ddocumento = hd.Ddocumento
                                            inner join ImpDocumentosCxC c 
                                            		   on cc.Ecodigo = c.Ecodigo 
                                            		   and cc.CCTcodigo = c.CCTcodigo 
                                            		   and cc.Ddocumento = c.Documento 
                                            inner join CCTransacciones d 
                                            		   on c.Ecodigo = d.Ecodigo 
                                            		   and c.CCTcodigo = d.CCTcodigo 
                                            inner join Impuestos i 
                                            		   on c.Ecodigo = i.Ecodigo 
                                            		   and c.Icodigo = i.Icodigo
                                            where b.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">  
                                                    and b.Mcodigo = #rsDocRel.Mcodigo# 
                                                    and b.Ddocumento = '#trim(ReciboPago.DDocumento)#'
                                                    and b.SNcodigo = #ReciboPago.SNcodigo# 
                                            group by b.Mcodigo,cc.Dmonto,c.TotalFac,i.Iporcentaje,hd.Dtipocambio,b.Dtipocambio
                                            ,i.Icodigo,c.MontoPagado,c.MontoCalculado,i.ClaveSAT,i.TipoFactor,/*c.MontoCalculado,c.MontoPagado,*/c.MontoBaseCalc
                                        </cfquery>

                                        <!---<cfquery name="rsPrueba" datasource="#session.dsn#">
                                            select*from ImpDocumentosCxC
                                            where  Ecodigo    =  #session.ecodigo#
                                            and documento = '#trim(ReciboPago.DDocumento)#'
                                        </cfquery

                                        <cf_dump  var="#rsPrueba#">
                                        <cf_dump  var="#rsPruebaIVAS#">>--->



                                        <cfquery name="rsPruebaIEPS" datasource="#session.dsn#">
                                            insert into #rsTablaTotales# (TotalIEPS,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc)
                                            select 
                                            	case 
                                                when b.Mcodigo = #IvarTipoMoneda# AND c.MontoCalculado <= 0 
                                            	then 
                                            		round(( (cc.Dmonto / c.TotalFac) * (c.MontoPagado) ) ,2) 
                                                
                                                when  c.MontoCalculado <= 0
                                                then
                                                    round( round(( (cc.Dmonto / c.TotalFac) * (c.MontoPagado) ) ,2) / hd.Dtipocambio * b.Dtipocambio,2) 
                                            	
                                                when b.Mcodigo = #IvarTipoMoneda# AND c.MontoCalculado > 0
                                            	then 
                                            		round(( (cc.Dmonto / c.TotalFac) * (c.MontoCalculado) ) ,2)

                                                when c.MontoCalculado > 0
                                                then
                                                    round( round(( (cc.Dmonto / c.TotalFac) * (c.MontoCalculado) ) ,2) / hd.Dtipocambio * b.Dtipocambio,2)                                                 

                                            	end as MontoIEPS
                                            , i.Icodigo
                                            , i.ClaveSAT
                                            , i.TipoFactor
                                            /*, c.MontoCalculado
                                            , c.MontoPagado*/
                                            , i.TasaOCuota as TasaOCuotaDR
                                            , case when b.Mcodigo = #IvarTipoMoneda#
                                            then 
                                            	round(( (cc.Dmonto / c.TotalFac) * (c.MontoBaseCalc) ) ,2) 
                                            else 
                                            	round( round(( (cc.Dmonto / c.TotalFac) * (c.MontoBaseCalc) ) ,2) / hd.Dtipocambio * b.Dtipocambio,2) 
                                            end as MontoBaseCalc
                                            from  Documentos b 
                                            inner join DocCompensacionDCxC cc 
                                            		   ON b.Ecodigo = cc.Ecodigo 
                                            		   and b.CCTcodigo = cc.CCTcodigo 
                                            		   and b.Ddocumento = cc.Ddocumento 
                                            left join Efavor a
                                            		   on cc.Ecodigo = a.Ecodigo 
                                            		   and cc.CCTcodigo = a.CCTcodigo 
                                            		   and cc.Ddocumento = a.Ddocumento
                                            inner join HDocumentos hd
                                            		   on cc.Ecodigo=hd.Ecodigo
                                            		   and cc.CCTcodigo = hd.CCTcodigo
                                            		   and cc.Ddocumento = hd.Ddocumento
                                            inner join ImpIEPSDocumentosCxC c 
                                            		   on cc.Ecodigo = c.Ecodigo 
                                            		   and cc.CCTcodigo = c.CCTcodigo 
                                            		   and cc.Ddocumento = c.Documento 
                                            inner join CCTransacciones d 
                                            		   on c.Ecodigo = d.Ecodigo 
                                            		   and c.CCTcodigo = d.CCTcodigo 
                                            inner join Impuestos i 
                                            		   on c.Ecodigo = i.Ecodigo 
                                            		   and c.codIEPS = i.Icodigo
                                            where b.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
                                                and b.Mcodigo = #rsDocRel.Mcodigo# 
                                                and b.Ddocumento = '#trim(ReciboPago.DDocumento)#'
                                                and b.SNcodigo = #ReciboPago.SNcodigo# 
                                            group by b.Mcodigo,cc.Dmonto,c.TotalFac,i.TasaOCuota,hd.Dtipocambio,b.Dtipocambio
                                            ,i.Icodigo,c.MontoPagado,c.MontoCalculado,i.ClaveSAT,i.TipoFactor,/*c.MontoCalculado,c.MontoPagado,*/c.MontoBaseCalc
                                        </cfquery>

                                        <cfquery name="rsPruebaRetenciones" datasource="#session.dsn#">
                                            insert into #rsTablaTotales# (TotalRet,CodigoRet,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc)
                                            select 
                                            	case when b.Mcodigo = #IvarTipoMoneda# 
                                            	then 
                                            		round( (CAST(cc.Dmonto as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2)
                                            	else 
                                            		round( round((CAST(cc.Dmonto as float) /CAST(c.TotalFac as float)) * ( CAST((sum(bb.DDtotal) *(i.Iporcentaje/100) ) as float) ),2) / hd.Dtipocambio * b.Dtipocambio,2)
                                            	end as MontoRet
                                            , i.Icodigo
                                            , i.ClaveSAT
                                            , i.TipoFactor
                                            , (i.Iporcentaje/ 100) as TasaOCuotaDR
                                            , case when b.Mcodigo = #IvarTipoMoneda#
                                            then
                                            	round( (CAST(cc.Dmonto as float) / CAST(c.TotalFac as float)) * ( CAST( (sum(bb.DDtotal)) as float) ),2)
                                            else 
                                                round( round((CAST(cc.Dmonto as float) /CAST(c.TotalFac as float)) * ( CAST((sum(bb.DDtotal)) as float) ),2) / hd.Dtipocambio * b.Dtipocambio,2)
                                            end as MontoBaseCalc
                                            from  Documentos b 
                                            inner join DocCompensacionDCxC cc 
                                            		   ON b.Ecodigo = cc.Ecodigo 
                                            		   and b.CCTcodigo = cc.CCTcodigo 
                                            		   and b.Ddocumento = cc.Ddocumento 
                                            left join Efavor a
                                            		   on cc.Ecodigo = a.Ecodigo 
                                            		   and cc.CCTcodigo = a.CCTcodigo 
                                            		   and cc.Ddocumento = a.Ddocumento
                                            inner  join DDocumentos bb
                                                       on bb.Ddocumento =b.Ddocumento
                                                       and bb.Ecodigo =b.Ecodigo
                                            inner join HDocumentos hd
                                            		   on cc.Ecodigo=hd.Ecodigo
                                            		   and cc.CCTcodigo = hd.CCTcodigo
                                            		   and cc.Ddocumento = hd.Ddocumento
                                            inner join ImpDocumentosCxC c 
                                            		   on cc.Ecodigo = c.Ecodigo 
                                            		   and cc.CCTcodigo = c.CCTcodigo 
                                            		   and cc.Ddocumento = c.Documento 
                                            inner join Impuestos i 
                                            		   on c.Ecodigo = i.Ecodigo 
                                            		   and c.Icodigo = i.Icodigo
                                            where b.Ecodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                                                    and b.Mcodigo = #rsDocRel.Mcodigo# 
                                                    and b.Ddocumento = '#trim(ReciboPago.DDocumento)#'
                                                    and b.SNcodigo = #ReciboPago.SNcodigo# 
                                            and b.EDMRetencion > 0
                                            group by b.Mcodigo,cc.Dmonto,c.TotalFac,i.Iporcentaje,hd.Dtipocambio,b.Dtipocambio
                                            ,i.Icodigo,c.MontoCalculado,i.ClaveSAT,i.TipoFactor,c.MontoBaseCalc
                                        </cfquery>

                                        <cfquery name="rsTablaTotalesTraslado" datasource="#session.dsn#">
                                            select CodigoIVA, sum(coalesce(TotalIVA,0)) as TotalIVA,
                                                CodigoIEPS,sum(coalesce(TotalIEPS,0)) as TotalIEPS, ImpuestoDR,
                                                TipoFactorDR,TasaOCuotaDR,MontoBaseCalc
                                            from #rsTablaTotales#
                                            where (len(CodigoIVA) > 0 or len(CodigoIEPS) > 0 )
                                            group by CodigoIVA,CodigoIEPS,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc
                                        </cfquery>


                                        <!---<cfquery name="rsPrueba" datasource="#session.dsn#">
                                            select*from #rsTablaTotales#
                                        </cfquery>--->

                                        
                                        <cfquery name="rsTablaTotalesRet" datasource="#session.dsn#">
                                            select CodigoRet,sum(coalesce(TotalRet,0)) as TotalRet, ImpuestoDR,
                                                TipoFactorDR,TasaOCuotaDR,MontoBaseCalc
                                            from #rsTablaTotales#
                                            where len(CodigoRet) > 0 
                                            group by CodigoRet,ImpuestoDR,TipoFactorDR,TasaOCuotaDR,MontoBaseCalc
                                        </cfquery>



                                    <cfif isdefined('rsDocRel') and rsDocRel.RecordCount GT 0>
                                        <cfset lVarMonedaDocRel = getMoneda(rsDocRel.Mcodigo)>                                       
                                        <cfif lVarMonedaP EQ lVarMonedaDocRel>
											<cfset lVarPtotal = ReciboPago.Ptotal>
										<cfelseif lVarMonedaP EQ trim(_monedaLocal) and lVarMonedaDocRel NEQ lVarMonedaP>
											<cfset lVarPtotal = (ReciboPago.Ptotal / lVarTCMonDiferentes)>
										<cfelseif lVarTCMonDiferentes NEQ ''>
											<cfset lVarPtotal = ReciboPago.Ptotal>
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


                                        <pago20:DoctoRelacionado 
                                            IdDocumento = "#ReciboPago.TimbreFiscal#"
                                            <cfif arguments.ReciboPagoCxC EQ 1 OR arguments.ReciboPagoCxC EQ 2>
												<cfif isDefined("rsDocRel.Serie") AND #rsDocRel.Serie# NEQ "NA" AND isDefined("rsDocRel.Folio") AND #rsDocRel.Folio# NEQ "NA">
													Serie ="#rsDocRel.Serie#" 
                                                    Folio="#rsDocRel.Folio#"
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
                                                    <cfset _ImpSaldoInsoluto="#NumberFormat((lVarPtotal - (lVarImportePagado*lVarTCMonDiferentes)),'0.00')#">
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
                                            ImpPagado = "#NumberFormat(lVarImportePagado,'9.00')#"

                                            <cfset IvarObjImp = '01'>
                                            <cfif rsTablaTotalesRet.RecordCount GT 0 or rsTablaTotalesTraslado.RecordCount GT 0>
                                                <cfset IvarObjImp = '02'>
                                            </cfif>
                                            NumParcialidad ="#ReciboPago.CantPagos#" 
                                            ObjetoImpDR = "#IvarObjImp#"
                                            
                                            <!---Validación Temporal, Al timbrar pide el valor 1 cuando es moneda extranjera --->
                                            <cfset ValEquivalenciaDR = "1">
                                            <cfif lVarTCMonDiferentes NEQ ValEquivalenciaDR>
                                                EquivalenciaDR = "#ValEquivalenciaDR#"  
                                            <cfelse>
                                                EquivalenciaDR = "#lVarTCMonDiferentes#"
                                            </cfif>
                                            >
                                        
                                            <cfif IvarObjImp eq 2>
                                                <pago20:ImpuestosDR>
                                                    <cfif rsTablaTotalesRet.TotalRet neq "">
                                                        <pago20:RetencionesDR>
                                                                <cfloop query="#rsTablaTotalesRet#">
                                                                    <cfset base = #rsTablaTotalesRet.MontoBaseCalc# >
                                                                    <cfset impuesto = #rsTablaTotalesRet.ImpuestoDR#>
                                                                    <cfset tipofactor = #rsTablaTotalesRet.TipoFactorDR#>
                                                                    <cfset tasaocuota = #rsTablaTotalesRet.TasaOCuotaDR#>
                                                                    <cfset importe = #rsTablaTotalesRet.TotalRet#>
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
                                                            <cfset base = #rsTablaTotalesTraslado.MontoBaseCalc#>
                                                            <cfset impuesto = #rsTablaTotalesTraslado.ImpuestoDR#>
                                                            <cfset tipofactor = #rsTablaTotalesTraslado.TipoFactorDR#>
                                                            <cfset tasaocuota = #rsTablaTotalesTraslado.TasaOCuotaDR#>
                                                            <cfif len(rsTablaTotalesTraslado.CodigoIVA) GT 0>
                                                                <cfset importe = #rsTablaTotalesTraslado.TotalIVA#>
                                                            <cfelseif len(rsTablaTotalesTraslado.CodigoIEPS) GT 0>
                                                                <cfset importe = #rsTablaTotalesTraslado.TotalIEPS#>
                                                            </cfif>
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

</cfcomponent>

