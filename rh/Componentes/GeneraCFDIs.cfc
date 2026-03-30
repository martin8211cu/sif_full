<!---
Componente desarrollado para obtener CFDIs de Recibos de Nómina y  de Facturación Electronica
Reescrito por: Giancarlo Benítez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (2018-02-02) Unicamente se reestructuro Recibo de Pagos y Factura Electronica
--->


<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>
    <cffunction name="obtenerCFDI" access="public" >
        <cfargument name="DEid"            type="numeric"  required="no" default="-1">
        <cfargument name="RCNid"           type="numeric"  required="no" default="-1">
        <cfargument name="DLlinea"         type="numeric"  required="no" default="-1">
        <cfargument name="OImpresionID"    type="numeric"  required="no" default="-1">
        <cfargument name="adenda"          type="string"   required="no" default="-1">
        <cfargument name="ReciboPago"      type="string"   required="no" default="-1">
        <cfargument name="addDetStruct"    type="struct"   required="no" default="#StructNew()#">
        <cfargument name="Retimbrar"       type="boolean"  required="no" default="false">

        <!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
        <cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
            select Pvalor 
            from Parametros
            where Pcodigo = '17200'
                and Ecodigo = #session.Ecodigo#
        </cfquery>

        <cfset value = "#rsPCodigoOBJImp.Pvalor#">
        <!-- Fin Querys AFGM-SPR -->

        <!---Llamamos al componente de Ruta --->
           <cf_foldersFacturacion name = "ruta">
           

        <!--- INICIA - Variables para tipo de flujo y estado de proceso--->
            <cfset reciboNomina=0>
            <cfset facturaElectronica=0>
            <cfset reciboNominaLiqFiniquito=0>
            <cfset reciboPagoCxC = 0>
            <cfparam name="form.adendasel" default="-1">
        <!--- FIN - Variables para tipo de flujo y estado de proceso--->
             <cf_foldersFacturacion>
        <!---INICIA Declaración de rutas para lectura y escritura de archivos --->

			<!--- Logo empresa --->
			<cfset path = "#ruta#">
			<cfset logoEmpresa = getLogoEmpresa()>
			<cfset logoImage = ImageNew(logoEmpresa.ELogo)>

			<cfif NOT FileExists(path&"logoEmpresa.png")>
				<cfimage source="#logoImage#" action="write" destination="#path#logoEmpresa.png" overwrite="yes">
			</cfif>
			<!--- PARA PINTAR
				<img src="file:///#path#logoEmpresa.png" alt="Logo_IMG" style="width: auto; height: 95px;">
			 --->

            <cfset vsPath_A = ruta>

        <!--- FIN - Declaracion de rutas para lectura y escritura de archivos--->

    <!-------------------------------------------------------------------------------------------------------->

        <!--- INICIA - Generacion de XML si es Factura--->

            <cfif Arguments.OImpresionID GT 0>
                <cfset facturaElectronica = 1>

                <cfquery name="tipoDoc" datasource="#session.dsn#">
                    SELECT  CCTcodigo
                    FROM    FAEOrdenImpresion
                    WHERE   Ecodigo = #session.Ecodigo#
                    AND     OImpresionID = #Arguments.OImpresionID#
                </cfquery>

                <cfquery name="numCer" datasource="#session.dsn#">
                    SELECT  NoCertificado
                    FROM    RH_CFDI_Certificados
                    WHERE   Ecodigo = #session.Ecodigo#
                </cfquery>

                <cfquery name="rsFactId" datasource="#session.dsn#">
                    select fe.IDpreFactura,oi.OIdocumento from FAEOrdenImpresion oi
                    inner join FAPreFacturaE fe 
                    on (oi.OIdocumento = fe.DdocumentoREF or oi.OImpresionID = fe.oidocumento)
                    and oi.Ecodigo = fe.Ecodigo
                    where oi.OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.OImpresionID#">
                    and  oi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
                
                <cfset SerieFolio = FoliosCFDI(tipoDoc.CCTcodigo, rsFactId.IDpreFactura)>
                <cfset NoCertificado=numCer.NoCertificado>
                <cfset FolioDoc=SerieFolio.Folio>
                <cfset SerieDoc=SerieFolio.Serie>

                <cfquery name="rsPF" datasource="#session.dsn#">
                    SELECT  IDpreFactura
                    FROM    FAPreFacturaE pf
                        INNER JOIN  FAEOrdenImpresion oi
                            ON  pf.Ecodigo = oi.Ecodigo
                            AND oi.OIdocumento = pf.DdocumentoREF
                    WHERE   oi.OImpresionID = #Arguments.OImpresionID#
                        AND     pf.Ecodigo = #session.Ecodigo#
                </cfquery>

                <cfif value eq '3.3'>

                    <cfset rutaXml = "rh.Componentes.GeneraCFDIs.XML33FacElectronica">
                    <!--GENERA XML33FACELECTRONICA-->      
                <cfelseif value eq '4.0'>

                    <cfset rutaXml = "rh.Componentes.GeneraCFDIs.XML40FacElectronica">
                    <!--GENERA XML33FACELECTRONICA--> 
                </cfif>
                <cfset GeneraXML = createObject('component', '#rutaXml#')>
                <cfif Len(SerieDoc) GT 0>
                    <cfset xml = GeneraXML.XML33FacturaCFDI(Arguments.OimpresionId, FolioDoc,
                        SerieDoc, arguments.adenda, arguments.addDetStruct)>
                <cfelse>
                    <cfset xml = GeneraXML.XML33FacturaCFDI(Arguments.OimpresionId, FolioDoc,
                       '_', arguments.adenda, arguments.addDetStruct)>
                </cfif>
                
                
                <cfset cadenaOriginal = GeneraCadenaOriginal(xml)>                
                <cfset sello = GeneraSelloDigital(cadenaOriginal)>
                
                
                
                <cfset xml = Replace(xml,'Sello="."','Sello="#sello#"')>
                
  
                <cfquery name="insert_FA_CFDI_Emitido" datasource="#session.dsn#">
                    insert into FA_CFDI_Emitido (Ecodigo, OImpresionID, Serie, Folio, SelloDigital, xml32, CadenaOriginal, stsTimbre)
                    values(#session.Ecodigo#,#Arguments.OImpresionID#,'#SerieDoc#',#FolioDoc#,'#sello#' ,'#xml#','#cadenaOriginal#',0)
                </cfquery>
                
                <cfquery name="updPF" datasource="#session.dsn#">
                    update FAPreFacturaE
                    set     cadorifacele='#cadenaOriginal#', foliofacele=#FolioDoc#, seriefacele='#SerieDoc#',
                            numcerfacele='#NoCertificado#', oidocumento=#Arguments.OImpresionID#
                    WHERE   IDpreFactura=#rsPF.idPrefactura#
                        AND Ecodigo = #session.Ecodigo#
                </cfquery> 
                
                <cfif MID(SerieDoc,1,2) EQ 'FC'>
                    <cfset archivoXml=#vsPath_A#&"/xmlST/FE_#session.Ecodigo#_#SerieDoc##FolioDoc#.xml">
                <cfelseif  MID(SerieDoc,1,2) EQ 'NC'>
                    <cfset archivoXml=#vsPath_A#&"/xmlST/NC_#session.Ecodigo#_#SerieDoc##FolioDoc#.xml">
                <cfelse>
                    <cfset archivoXml=#vsPath_A#&"/xmlST/_#session.Ecodigo#_#SerieDoc##FolioDoc#.xml">
                </cfif>
                <cftry>
                    <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
                <cfcatch>
                    <cfquery name="q_revertChanges" datasource="#session.dsn#">
                        update FAPreFacturaE set factura=0, foliofacele=0 where oidocumento = #form.OImpresionID# and Ecodigo=#session.Ecodigo#;
                        delete from FA_CFDI_Emitido  where Ecodigo=#session.Ecodigo# and OImpresionID=#form.OImpresionID#;
                    </cfquery>
                    <cfthrow message="Error al escribir el XML... Verifique la existencia de [#archivoXml#]">
                </cfcatch>
                </cftry>
                    <!--- Timbrado de XML, Extension del componente TimbrarXML--->
                    
                    <cfset xmlTimbrado = TimbraXML(xml,FolioDoc,Arguments.DEid,Arguments.RCNid,Arguments.DLlinea,Arguments.OImpresionID)>
                    
                     
            </cfif>
        <!--- FIN - Generacion de XML si es Factura--->

    <!-------------------------------------------------------------------------------------------------------->

        <!--- INICIO - Generacion de XML si es Recibo de Pago --->
            <cfif ReciboPago NEQ -1>
                <cfquery name="rsTimbraPago" datasource="#session.dsn#">
                    SELECT ep.Ecodigo,
                           ep.CCTcodigo,
                           ltrim(rtrim(ep.Pcodigo)) AS Pcodigo,
                           ep.Ocodigo,
                           ep.Mcodigo AS McodigoP,
                           ep.SNcodigo,
                           ep.Ptipocambio,
                           fd.Dsaldo Ptotal,
                           ep.CBid,
                           dp.DPid,
                           dp.Doc_CCTcodigo,
                           dp.Ddocumento,
                           dp.DPmonto MontoPagoDoc,
                           dp.DPmontodoc,
                           dp.DPtipocambio,
                           dp.DPtotal,
                           CASE
                               WHEN convert(char,ep.Pfecha, 108) = '00:00:00' THEN ltrim(rtrim(SUBSTRING(ltrim(rtrim(convert(char,ep.Pfecha, 120))), 1, 10)+'T12:00:00'))
                               ELSE ltrim(rtrim(SUBSTRING(ltrim(rtrim(convert(char,ep.Pfecha, 120))), 1, 10)+'T'+convert(char,ep.Pfecha, 108)))
                           END AS fechaAplicaPago,
                            ltrim(rtrim(SUBSTRING(ltrim(rtrim(convert(char,GETDATE(),120))),1,10)+'T'+convert(char,GETDATE(),108))) as FechaEnc,
                           hd.TimbreFiscal,
                           fd.Dsaldo,
                           fd.CantPagos + 1 CantPagos,
                           dp.DPTipoCambioME,
                           ep.Pfecha as EFfecha
                    from Pagos ep
                    INNER JOIN DPagos dp ON ep.Ecodigo = dp.Ecodigo
                            and ep.CCTcodigo = dp.CCTcodigo
                            and ep.Pcodigo = dp.Pcodigo
                    INNER JOIN
                      ( SELECT bm.DRdocumento,
                               bm.Ecodigo,
                               bm.SNcodigo,
                               sum(CASE
                                       WHEN cct.CCTcodigo = 'RE' AND bm.CCTRcodigo <> bm.CCTcodigo AND bm.BMCancelado IS NULL THEN 1
                                       ELSE 0
                                   END) CantPagos,
                               sum(CASE
                                       WHEN cct.CCTtipo = 'C' THEN bm.Dtotalref * -1
                                       ELSE bm.Dtotalref
                                   END) Dsaldo
                        from BMovimientos bm
                       INNER JOIN CCTransacciones cct ON bm.CCTcodigo = cct.CCTcodigo
                       AND bm.Ecodigo = cct.Ecodigo
                       <!--- WHERE bm.BMCancelado IS NULL --->
                       GROUP BY bm.DRdocumento,
                                bm.Ecodigo,
                                bm.SNcodigo ) fd ON ep.Ecodigo = fd.Ecodigo
                    AND fd.SNcodigo = ep.SNcodigo
                    AND fd.DRdocumento = dp.Ddocumento
                    LEFT JOIN HDocumentos hd ON ep.Ecodigo = hd.Ecodigo
                    AND dp.Doc_CCTcodigo = hd.CCTcodigo
                    AND hd.SNcodigo = ep.SNcodigo
                    AND hd.Ddocumento = dp.Ddocumento
                    WHERE ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                            and  dp.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReciboPago#">
                </cfquery>

                <cfif isdefined('rsTimbraPago') and rsTimbraPago.RecordCount GT 0>
                    <cfset reciboPagoCxC = 1>
                <cfelse>
                    <cfquery name="rsTimbraPago" datasource="#session.dsn#">
                        SELECT ef.Ecodigo,
                                ef.CCTcodigo,
                                LTRIM(RTRIM(ef.Ddocumento)) AS Pcodigo,
                                ef.Mcodigo AS McodigoP,
                                ef.SNcodigo,
                                ef.EFtipocambio AS Ptipocambio,
                                ISNULL(fd.Dsaldo, df.DFtotal) AS Ptotal,
                                df.CCTRcodigo AS Doc_CCTcodigo,
                                df.DRdocumento AS Ddocumento,
                                df.DFmonto AS MontoPagoDoc,
                                df.DFmontodoc AS DPmontodoc,
                                df.DFtipocambio AS DPtipocambio,
                                df.DFtotal AS DPtotal,
                                CASE
                                    WHEN CONVERT(char, TblMb.Dfecha, 108) = '00:00:00' THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T12:00:00'))
                                    ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T' + CONVERT(char, TblMb.Dfecha, 108)))
                                END AS fechaAplicaPago,
                                LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, GETDATE(), 120))), 1, 10) + 'T' + CONVERT(char, GETDATE(), 108))) AS FechaEnc,
                                ef.CodTipoPago,
                                isnull((select top 1 timbre from CERepositorio r where r.numDocumento = df.DRdocumento and r.origen = 'CCFC' and r.Ecodigo = df.Ecodigo),hd.TimbreFiscal) TimbreFiscal,
                                fd.CantPagos + 1 CantPagos,
                                ef.EFfecha
                            FROM EFavor ef
                            INNER JOIN DFavor df ON ef.Ecodigo = df.Ecodigo
                            AND ef.CCTcodigo = df.CCTcodigo
                            AND ef.Ddocumento = df.Ddocumento
                            INNER JOIN
                            (SELECT b.Dfecha,
                                    b.Ecodigo,
                                    b.DRdocumento
                            FROM BMovimientos b
                            INNER JOIN CCTransacciones t ON t.Ecodigo = b.Ecodigo
                            AND t.CCTcodigo = b.CCTcodigo
                            AND b.CCTcodigo = CCTRcodigo
                            WHERE t.CCTtipo = 'C') TblMb ON TblMb.Ecodigo = ef.Ecodigo
                            AND df.Ddocumento = TblMb.DRdocumento
                            INNER JOIN
                            (SELECT bm.DRdocumento,
                                    bm.Ecodigo,
                                    bm.SNcodigo,
                                    SUM(CASE
                                            WHEN cct.CCTcodigo = 'RE' AND bm.CCTRcodigo <> bm.CCTcodigo AND bm.BMCancelado IS NULL THEN 1
                                            ELSE 0
                                        END) CantPagos,
                                    SUM(CASE
                                            WHEN cct.CCTtipo = 'C' AND bm.CCTRcodigo <> bm.CCTcodigo THEN (bm.Dtotalref * -1)
                                            WHEN cct.CCTtipo = 'D' THEN bm.Dtotalref
                                        END) Dsaldo
                            FROM BMovimientos bm
                            INNER JOIN CCTransacciones cct ON bm.CCTcodigo = cct.CCTcodigo
                            AND bm.Ecodigo = cct.Ecodigo
                            <!--- WHERE bm.BMCancelado IS NULL --->
                            GROUP BY bm.DRdocumento,
                                        bm.Ecodigo,
                                        bm.SNcodigo) fd ON df.Ecodigo = fd.Ecodigo
                            AND fd.SNcodigo = df.SNcodigo
                            AND fd.DRdocumento = df.DRdocumento
                            LEFT JOIN HDocumentos hd ON df.Ecodigo = hd.Ecodigo
                            AND df.CCTRcodigo = hd.CCTcodigo
                            AND hd.SNcodigo = df.SNcodigo
                            AND hd.Ddocumento = df.DRdocumento
                            WHERE ef.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                            AND ef.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReciboPago#">
                    </cfquery>
                    <cfif isdefined('rsTimbraPago') and rsTimbraPago.RecordCount GT 0>
                        <cfset reciboPagoCxC = 2>
                    </cfif>
                </cfif>

                <cfset day = DatePart('d', rsTimbraPago.EFfecha)> 
                <cfset hour = right("00#DatePart('h', rsTimbraPago.EFfecha)#",2) > 
                <cfset minute = right("00#DatePart('n', rsTimbraPago.EFfecha)#",2) > 
                <cfset second = right("00#DatePart('s', rsTimbraPago.EFfecha)#",2) >
                <cfset folio = day&hour&minute&second>
                <!---Preparacion de Seleccion de Version para complemento de Pago--->
                <cfset SerieFolio   = FoliosCFDI(rsTimbraPago.CCTcodigo,folio)>
                <cfset FolioDoc     = SerieFolio.Folio>
                <cfset SerieDoc     = SerieFolio.Serie>
                <cfif value eq '3.3'>
                    <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML33ReciboPago')>
                <cfelseif value eq '4.0'>
                    <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML20ReciboPago')>
                </cfif>

                <cftransaction>
                    <cfif  reciboPagoCxC GT 0>
                        <cfset xml = GeneraXML.XML33ReciboPagoCFDI(rsTimbraPago, FolioDoc, SerieDoc, reciboPagoCxC)>

                        <cfset cadenaOriginal = GeneraCadenaOriginal(xml)>
                        <cfset sello = GeneraSelloDigital(cadenaOriginal)>
                        <cfset xml = Replace(xml,'Sello="."','Sello="#sello#"')>
                        <cfquery datasource="#session.dsn#">
                            insert into FA_CFDI_Emitido (Ecodigo, OImpresionID, Serie, Folio, CadenaOriginal, stsTimbre, DocPago, NombreDoctoGenerado)
                            values(#session.Ecodigo#, 0,'#SerieDoc#',#FolioDoc#,'#cadenaOriginal#',0, '#rsTimbraPago.Pcodigo#', '#SerieDoc##FolioDoc#_#rsTimbraPago.Pcodigo#')
                        </cfquery>
                        <cfset archivoXml = #vsPath_A#&"/xmlST/#SerieDoc##FolioDoc#_#rsTimbraPago.Pcodigo#.xml">
                        <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
                        <cfset xmlTimbrado = TimbraXML(xml,FolioDoc,Arguments.DEid,Arguments.RCNid,Arguments.DLlinea,Arguments.OImpresionID,rsTimbraPago.Pcodigo)>
                    </cfif>
                </cftransaction>
            </cfif>
        <!--- FIN - Generacion de XML si es Recibo de Pago--->
    <!-------------------------------------------------------------------------------------------------------->

        <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>

            <cfif value eq '3.3'>

            <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML33ReciboNomina')>

    
            <cfelseif value eq '4.0'>

            <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML40ReciboNomina')>

            </cfif>

            <!--- INICIA - Cadena Original si es Recibo de Nomina--->
            <cfset reciboNomina = 1>
            <cfquery name="rsReciboCFDI" datasource="#session.dsn#" >
                select * from RH_CFDI_RecibosNomina
                where
                    DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                <cfif Arguments.Retimbrar>
                    and stsTimbre = 3
                </cfif>
            </cfquery>

            <cfquery name="rsEsFisica" datasource="#session.dsn#">
                select f.persona_Fisica from  FARegFiscal f
                where f.id_RegFiscal = (select cast(p.Pvalor as numeric)
                            from RHParametros p
                            where p.Pcodigo = 45
                            and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
            </cfquery>

            <cfif rsEsFisica.persona_Fisica eq 1>
                <cfquery name="curpPFisica" datasource="#session.dsn#">
                    select Pvalor from RHParametros p where p.Pcodigo = 162
                    and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
            </cfif>

            <cfset xml = GeneraXML.XML32ReciboNominaCFDI(Arguments.DEid,Arguments.RCNid, '.',Arguments.Retimbrar)>
            <cfset cadenaOriginal = GeneraCadenaOriginal(xml)>
            <cfset sello = GeneraXML.GeneraSelloDigital(cadenaOriginal)>
            <cfset xml = Replace(xml,'Sello="."','Sello="#sello#"')>
            <!--- FIN - Cadena Original si es Recibo de Nomina--->

            <!--- INICIA - XML si es Recibo de Nomina--->
            <cfif rsReciboCFDI.RecordCount EQ 0>
                <cfquery name="insEmp" datasource="#session.dsn#">
                    insert into RH_CFDI_RecibosNomina (Ecodigo,DEid,RCNid,DLlinea,CadenaOriginal,stsTimbre)
                    values (#session.Ecodigo#,#Arguments.DEid#,#Arguments.RCNid#,#Arguments.DLlinea#,'#CadenaOriginal#',0)
                </cfquery>
            <cfelse>
                <cfquery name="upEmp" datasource="#session.dsn#">
                    update  RH_CFDI_RecibosNomina
                    set     CadenaOriginal='#CadenaOriginal#',stsTimbre=0
                    where   Ecodigo=#session.Ecodigo# and DEid=#Arguments.DEid# and RCNid=#Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                </cfquery>
            </cfif>

            <cfquery name="upSello" datasource="#session.dsn#">
                update RH_CFDI_RecibosNomina
                set
                    SelloDigital='#sello#',
                    xml32 ='#xml#',
                    NombreXML = '#Arguments.DEid#_#Arguments.RCNid#.xml'
                where Ecodigo = #session.Ecodigo#
                and Deid=#Arguments.DEid#
                and RCNid = #Arguments.RCNid#
                and DLlinea=#Arguments.DLlinea#
            </cfquery>

            <!--- OPARRALES 2019-01-28
                - Modificacion para generar gerarquia de carpetas y dar mejor estructura a los archivos de nomina
             --->
            <cfif Arguments.Retimbrar>
                <cfquery name="rsExiste" datasource="#session.dsn#" >
                    select * from RH_CFDI_RecibosNomina
                    where
                        DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    and stsTimbre = 1
                </cfquery>
                <cfset Arguments.Retimbrar = rsExiste.RecordCount gt 0>
            </cfif>
            <cfset rsCP = GeneraXML.GetFechasCalendario(session.Ecodigo,Arguments.RCNid)>
            
            <cfset archivoXml=#vsPath_A#&"/Nomina#Year(rsCP.CPfpago)#/#Trim(rsCP.CPcodigo)#/xmlST/#Arguments.DEid#_#Arguments.RCNid#.xml">

            <CFFILE action="write" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">

            <cfset xmlTimbrado = GeneraXML.TimbraXML(xml,0,Arguments.DEid,Arguments.RCNid,-1,-1,-1,Arguments.Retimbrar)>
            <!--- Asociacion de xml timbrado con poliza correspondiente --->
            <cfif isDefined("xmlTimbrado")>
                <cfset insertRepositorio(Ecodigo=#session.Ecodigo#,DEid=#Arguments.DEid#,RCNid=#Arguments.RCNid#,xml=#xmlTimbrado#)>
            </cfif>
        </cfif>

    <!-------------------------------------------------------------------------------------------------------->

        <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
            <cfif value eq '3.3'>

                <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML33ReciboLiquidacion')>

    
            <cfelseif value eq '4.0'>

                <cfset GeneraXML = createObject('component', 'rh.Componentes.GeneraCFDIs.XML40ReciboLiquidacion')>
            </cfif>



            <!--- INICIA - Cadena Original si es Recibo de Liquidacion--->
            <cfset reciboNominaLiqFiniquito = 1>
            <cfquery name="rsReciboLiqCFDI" datasource="#session.dsn#" >
                select  *
                from    RH_CFDI_RecibosNomina
                where   DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and     DLlinea =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
                    and     Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
            <!--- <cfset cadenaOriginal = GeneraXML.CadenaOriginalFiniquitosLiqCFDI(Arguments.DEid,Arguments.DLlinea)> --->
            <cfset xml = GeneraXML.XML32ReciboLiqFinCFDI(Arguments.DEid,Arguments.DLlinea, '.')>
            <cfset cadenaOriginal = GeneraCadenaOriginal(xml)>
            <cfset sello = GeneraXML.GeneraSelloDigital(cadenaOriginal)>
            <cfset xml = Replace(xml,'Sello="."','Sello="#sello#"')>

            <cfif rsReciboLiqCFDI.RecordCount EQ 0>
                <cfquery name="insEmp" datasource="#session.dsn#">
                    insert into RH_CFDI_RecibosNomina (Ecodigo,DEid,RCNid,DLlinea,CadenaOriginal,stsTimbre)
                    values (#session.Ecodigo#,#Arguments.DEid#,#Arguments.RCNid#,#Arguments.DLlinea#,'#CadenaOriginal#',0)
                </cfquery>
            <cfelse>
                <cfquery name="upEmp" datasource="#session.dsn#">
                    update  RH_CFDI_RecibosNomina
                    set     CadenaOriginal='#CadenaOriginal#',stsTimbre=0
                    where   Ecodigo=#session.Ecodigo# and DEid=#Arguments.DEid# and RCNid=#Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                </cfquery>
            </cfif>

            <!--- INICIA - XML si es Recibo de Liquidacion--->
            <cfif reciboNominaLiqFiniquito EQ 1>
                <!--- <cfset xml = GeneraXML.XML32ReciboLiqFinCFDI(Arguments.DEid,Arguments.DLlinea, sello)> --->
                <cfquery name="upSello" datasource="#session.dsn#">
                    update RH_CFDI_RecibosNomina
                    set SelloDigital='#sello#', xml32 ='#xml#'
                    where Ecodigo = #session.Ecodigo# and Deid=#Arguments.DEid# and RCNid = #Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                </cfquery>
                <!--- OPARRALES 2019-02-18
                    - Modificacion para generar gerarquia de carpetas y dar mejor estructura a los archivos de Liquidacion - Finiquito
                 --->
                <cfquery datasource="#session.dsn#" name="rsEmpFL">
                    select
                        concat(LTRIM(RTRIM(de.DEidentificacion)),'_',LTRIM(RTRIM(de.DEnombre)),'_',LTRIM(RTRIM(de.DEapellido1)),'_',LTRIM(RTRIM(de.DEapellido1))) as Empleado
                    from DatosEmpleado de
                    where
                        DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
                <cfset rsCP = GeneraXML.GetFechasCalendario(Arguments.DLlinea)>
                <cfset archivoXml=#vsPath_A#&"/Liquidacion-Finiquito#Year(Now())#/#Trim(rsEmpFL.Empleado)#/Liq_#Arguments.DEid#_#Arguments.DLlinea#.xml">
                <!--- <cfset archivoXml=#vsPath_A#&"\Enviar\xmlST\Liq_#Arguments.DEid#_#Arguments.DLlinea#.xml"> --->
                <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
                <cfset xmlTimbrado = TimbraXML(xml,0,Arguments.DEid,Arguments.RCNid,Arguments.DLlinea)>
            </cfif>
            <!--- INICIA - XML si es Recibo de Liquidacion--->
        </cfif>


    </cffunction>

	<cffunction  name="getLogoEmpresa">
	   <cfquery name="rsLogo" datasource="#session.dsn#">
			Select  Elogo , Ecodigo
			From  Empresa
			where Ereferencia = #session.Ecodigo#
		</cfquery>
		<cfreturn rsLogo>
	</cffunction>
    <cffunction  name="insertRepositorio" access="private">
        <cfargument name="Ecodigo"         type="numeric"  required="no">
        <cfargument name="DEid"            type="numeric"  required="no">
        <cfargument name="RCNid"           type="numeric"  required="no">
        <cfargument name="xml"             type="string"   required="no">
        <cfset xmlCode = ReplaceNoCase(xml,"''", '"',"all")>
        <cfset archXML = XmlParse(xmlCode)>
        <cfset UUID = archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
        <cfset RFCreceptor = archXML.Comprobante.Receptor.XmlAttributes.rfc>
        <cfset total = archXML.Comprobante.Conceptos.Concepto.XmlAttributes.Importe>
        <cfquery name="rsEContable" datasource="#session.dsn#">
            select IDcontable,Oorigen from EContables where Ereferencia='#Arguments.RCNid#' and Ecodigo=#Arguments.Ecodigo#
            union
            select IDcontable,Oorigen from HEContables where Ereferencia='#Arguments.RCNid#' and Ecodigo=#Arguments.Ecodigo#
        </cfquery>

        <cfif isdefined("rsEContable") and rsEContable.RecordCount GT 0>    
            <cfquery name="rsLinea" datasource="#session.dsn#">
                    select Dlinea Dlinea from DContables 
                    where IDcontable=#rsEContable.IDcontable# and Ddescripcion='BANCO' 
                    and Ocodigo=(select 
                                      top 1 Ocodigo 
	    		                            from DLaboralesEmpleado 
	    		                                where DEid=#Arguments.DEid# and Ecodigo=#Arguments.Ecodigo# order by DLfvigencia desc)
                    union 
                    select Dlinea from HDContables 
                    where IDcontable=#rsEContable.IDcontable# and Ddescripcion='BANCO' 
                    and Ocodigo=(select 
                                      top 1 Ocodigo 
	    		                            from DLaboralesEmpleado 
	    		                                where DEid=#Arguments.DEid# and Ecodigo=#Arguments.Ecodigo# order by DLfvigencia desc)
            </cfquery>
    
            <cfset _linea = (rsLinea.Dlinea neq '') ? rsLinea.Dlinea : 1>
            <cfquery  name="insertCERepo" datasource="#session.dsn#">
                insert into CERepositorio(IdContable,origen,linea,timbre,rfc,total,xmlTimbrado,Ecodigo,BMUsucodigo)
                values(#rsEContable.IDcontable#,
                      '#rsEContable.Oorigen#',
                       #_linea#,
                      '#UUID#',
                      '#RFCreceptor#',
                       #total#,
                       '#Arguments.xml#',
                       #Arguments.Ecodigo#,
                       #session.Usucodigo#)
            </cfquery>
        </cfif>
    </cffunction>
</cfcomponent>