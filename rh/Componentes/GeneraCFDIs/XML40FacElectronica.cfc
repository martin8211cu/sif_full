<!---
Componenete Desarrollado por Team Soin 
Fecha de ultima modificacion: 23/05/2022
--->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>  

    <!--- INICIA - Generacion de XML para Factura Electronica --->
            <cffunction name="XML33FacturaCFDI" returntype="string">
                <cfargument name="OImpresionID" type="numeric"  required="yes">
                <cfargument name="Folio"        type="numeric"  required="no">
                <cfargument name="Serie"        type="string"   required="no"   default='_'>
                <cfargument name="Adenda"       type="string"   required="no"   default=-1>
                <cfargument name="addDetStruct"    type="struct"   required="no" default="#StructNew()#">
    
                <!-- Querys AFGM CONTROL DE VERSIONES-->
    
                    <cfquery name="rsNumDecimales" datasource = "#Session.DSN#">
                        select Pvalor
                        from Parametros
                        where Pcodigo = '17300'
                            and Ecodigo = #session.Ecodigo#
                    </cfquery>
                    <cfset valordecimal = "#rsNumDecimales.Pvalor#">
    
                    <cfset numRemplazables = "">
                    <cfset valorValue = "">
    
                    <cfif valordecimal eq 1>
                        <cfset numRemplazables = "_._">
                        <cfset valorValue = "0.0">
                    <cfelseif valordecimal eq 2>
                        <cfset numRemplazables = "_.__">
                        <cfset valorValue = "0.00">
                    <cfelseif valordecimal eq 3>
                        <cfset numRemplazables = "_.___">
                        <cfset valorValue = "0.000">
                    <cfelseif valordecimal eq 4>
                        <cfset numRemplazables = "_.____">
                        <cfset valorValue = "0.0000">
                    <cfelseif valordecimal eq 5>
                        <cfset numRemplazables = "_._____">
                        <cfset valorValue = "0.00000">
                    <cfelseif valordecimal eq 6>
                        <cfset numRemplazables = "_.______">
                        <cfset valorValue = "0.000000">
                    <cfelseif valordecimal eq ''>
                        <cfset numRemplazables = "_.__">
                        <cfset valorValue = "0.00">
                    </cfif>
                <!-- Fin Querys AFGM -->
                
                <!--- Addenadas 2019 --->
                    <cfquery name="rsFEAdd" datasource="#session.dsn#">
                        SELECT  pf.SNcodigo,pf.NumOrdenCompra as NumCompra
                            FROM    FAPreFacturaE pf
                            INNER JOIN  FAEOrdenImpresion oi
                            ON  pf.Ecodigo = oi.Ecodigo
                            AND oi.OIdocumento = pf.DdocumentoREF
                            WHERE   oi.OImpresionID = #Arguments.OImpresionID#
                    </cfquery>
    
    
                    <!--- VAlidamos que exista una addenda para el proveedor --->
                    <cfif isdefined('rsFEAdd') and rsFEAdd.RecordCount GT 0 >
                        <cfquery name="rsSNAdd" datasource="#session.dsn#">
                            select A.ADDNombre,A.ADDid
                                from Addendas A
                                inner join SocioAddenda SA
                                on A.ADDcodigo= SA.ADDcodigo
                                where A.Ecodigo=#session.Ecodigo#
                                and SA.SNcodigo = #rsFEAdd.SNcodigo#
                                and SA.StatusSeleccion = 1
                        </cfquery>
                     </cfif>
                     <cfif isDefined('form.sust') or isDefined('form.anticipo') or form.cctcodigo EQ 'NC'>
                        <cfquery name="rsRelacionados" datasource="#session.dsn#">
                            select
                                IdCFDIRel, OImpresionID, Serie, Folio,
                                Documento, TipoRelacion, DocumentoRelacionado, TimbreDocRel
                            from FA_CFDI_Relacionado
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                            and OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#OImpresionID#">
                        </cfquery>
                     </cfif>
                <!--- Variables Generales--->
                <cfset rsCertificado = GetCertificado()>
                <cfset vNumCertificado = "#rsCertificado.NoCertificado#">
                <cfset vCertificado = "#rsCertificado.certificado#">
                <cfset rsLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>
                <cfset banderaObjImp = ''>
    
                <!--- Direccion Fiscal y Validacion--->
                <cfparam name="rsValFiscE.DirecFisc" default="0">
                <cfparam name="rsValFiscR.DirecFisc" default="0">
                <!---
                <cfquery name="rsValFiscE" datasource="#session.dsn#">
                    SELECT  DirecFisc
                    FROM    Empresas
                    WHERE   Ecodigo = #session.Ecodigo#
                </cfquery>
                <cfquery name="rsValFiscR" datasource="#session.DSN#">
                    SELECT  d.SNDireccionFiscal as DirecFisc
                    FROM  SNegocios s
                        INNER JOIN SNDirecciones d
                        ON s.SNid = d.SNid
                    WHERE   s.SNid = #rsDatosfac.SNid#
                </cfquery>
                <cfset DirFiscE = rsValFiscE.DirecFisc>
                <cfset DirFiscR = rsValFiscR.DirecFisc>
                --->
    
                <!--- EMPRESA --->
                <!--- <cfif DirFiscE EQ 1>
                    <cfquery name="rsEmpresa" datasource="#session.dsn#">
                        SELECT  e.Enombre, Calle, NumExt, NumInt, Colonia, Localidad, Referencia, Delegacion, es.Estado, Pais, es.CodPostal, ciudad
                        FROM    Empresas es
                            inner join Empresa e
                                on es.Ecodigo = e.Ereferencia
                            inner join Direcciones d
                                on e.id_direccion = d.id_direccion
                        WHERE   es.Ecodigo = #session.Ecodigo#
                    </cfquery>
                <cfelse> --->
                    <cfquery name="rsEmpresa" datasource="#session.dsn#">
                        select a.Enombre, b.direccion1, b.direccion2, b.ciudad, b.estado, a.Eidentificacion , b.codPostal,
                                a.Etelefono1,a.Efax,a.Enumlicencia
                        from Empresa a
                            INNER JOIN Direcciones b
                                on a.id_direccion = b.id_direccion
                        where a.Ecodigo = #session.Ecodigosdc#
                    </cfquery>
               <!--- </cfif>--->
    
               <cfquery name="rsExporta" datasource="#session.dsn#">
                        select a.CSATdescripcion, a.CSATcodigo
                        from CSATExportacion a
                        inner join FAPreFacturaE e
                        on a.IdExportacion = e.IdExportacion
                        where e.SNcodigo =  #rsFEAdd.SNcodigo#                                
                    </cfquery>
    
                    <cfquery name="rsRfisc" datasource="#session.dsn#">
                        select c.CSATcodigo
                        from CSATRegFiscal c
                        inner join SNegocios s
                        on c.IdRegFiscal = s.IdRegimenFiscal
                        where s.Ecodigo = #session.Ecodigo# and s.SNcodigo = #rsFEAdd.SNcodigo#           
                    </cfquery>
    
                     <cfquery name="rsRcodigoPostal" datasource="#session.dsn#">
                        select codPostal dpostal 
                        from DireccionesSIF c
                        inner join SNegocios s
                        on s.id_direccion = c.id_direccion
                        where s.Ecodigo = #session.Ecodigo# and s.SNcodigo = #rsFEAdd.SNcodigo#          
                    </cfquery>
    
                     <cfset lVarExportacion      = rsExporta.CSATcodigo>
                    <cfset lVarRegFiscC         = rsRFisc.CSATcodigo>
                    <cfset lVarCodPostalRec   = rsRcodigoPostal.dpostal>
    
    
                <!--- DATOS FACTURA --->
                <cfset rsDatosfac = obtenerDatosFacturaOI(arguments.OImpresionID)>
                <!---<cf_dump var = "#rsDatosfac#">--->
    
                <!--- DOMICILIO FISCAL CLIENTE --->
                <!---<cfif DirFiscR EQ 1>
                    <cfquery name="rsDomFiscCliente" datasource="#session.DSN#">
                        SELECT  Calle, NumExt, NumInt, Colonia, Localidad, Referencia, MunicipioDelegacion as Delegacion, Estado, p.Pnombre as Pais, codPostal
                        FROM    DireccionesSIF d
                            INNER JOIN Pais p
                                ON d.Ppais = p.Ppais
                            INNER JOIN SNegocios s
                                ON d.id_direccion = s.id_direccion
                        WHERE d.id_direccion = #rsDatosfac.id_direccion#
                    </cfquery>
                </cfif>--->
    
    
                <!--- VARIABLES PARA XML--->
                <cfset lVarNombreEmisor     = rsEmpresa.Enombre>
                <cfset lVarRFCEmisor        = rsEmpresa.Eidentificacion>
                <cfset lvarRegFiscal        = rsDatosfac.codigo_RegFiscal>
                <cfset lVarNombreCliente    = #Trim(rsDatosfac.SNnombre)#>
                <cfset lVarNombreClienteFiscal    = #Trim(rsDatosfac.nombreFiscal)#>
                <cfset lVarRFCCliente       = #Trim(Replace(rsDatosfac.SNidentificacion,"-","","ALL"))#>
                <cfset lVarUsoCFDI			= #Trim(rsDatosfac.UsoCFDI)#>
                <cfset lVarDireccionCliente = rsDatosfac.SNdireccion>
                <!---
                <cfparam name="lVarNoInterior" default ="">
                <cfparam name="lVarLocalidad" default ="">
                <cfparam name="lVarReferencia" default ="">
                <cfparam name="lVarNoInteriorR" default ="">
                <cfparam name="lVarLocalidadR" default ="">
                <cfparam name="lVarReferenciaR" default ="">
                <cfif DirFiscE EQ 1>
                    <cfset lVarNombreEmisor     = rsEmpresa.Enombre>
                    <cfset lVarCalle            = rsEmpresa.Calle>
                    <cfset lVarNoExterior       = rsEmpresa.NumExt>
                    <cfif structKeyExists(rsEmpresa,"NumInt") AND len(trim(rsEmpresa.NumInt))>
                        <cfset lVarNoInterior = rsEmpresa.NumInt>
                    <cfelse>
                    </cfif>
                    <cfset lVarColonia          = rsEmpresa.Colonia>
                    <cfif structKeyExists(rsEmpresa,"Localidad") AND len(trim(rsEmpresa.Localidad))>
                        <cfset lVarLocalidad    = rsEmpresa.Localidad>
                    </cfif>
                    <cfif structKeyExists(rsEmpresa,"Referencia") AND len(trim(rsEmpresa.Referencia))>
                        <cfset lVarReferencia   = rsEmpresa.Referencia>
                    </cfif>
                    <cfset lVarMunicipio        = rsEmpresa.Delegacion>
                    <cfset lVarEstado           = rsEmpresa.Estado>
                    <cfset lVarPais             = rsEmpresa.Pais>
                    <cfset lVarCodPostal        = rsEmpresa.CodPostal>
                <cfelse>
                    <cfset lVarNombreEmisor     = rsEmpresa.Enombre>
                </cfif>--->
    
                <!--- DIRECCI�N FISCAL CLIENTE --->
                <!---<cfif DirFiscR EQ 1>
                    <cfset lVarCalleR           = rsDomFiscCliente.Calle>
                    <cfset lVarNoExteriorR      = rsDomFiscCliente.NumExt>
                    <cfif structKeyExists(rsDomFiscCliente,"NumInt") AND len(rsDomFiscCliente.NumInt)>
                        <cfset lVarNoInteriorR       = rsDomFiscCliente.NumInt>
                    </cfif>
                    <cfset lVarColoniaR         = rsDomFiscCliente.Colonia>
                    <cfif structKeyExists(rsDomFiscCliente,"Localidad") AND len(rsDomFiscCliente.Localidad)>
                        <cfset lVarLocalidadR       = rsDomFiscCliente.Localidad>
                    </cfif>
                    <cfif structKeyExists(rsDomFiscCliente,"Referencia") AND len(rsDomFiscCliente.Referencia)>
                        <cfset lVarReferenciaR      = rsDomFiscCliente.Referencia>
                    </cfif>
                    <cfset lVarMunicipioR       = rsDomFiscCliente.Delegacion>
                    <cfset lVarEstadoR          = rsDomFiscCliente.Estado>
                    <cfset lVarPaisR            = rsDomFiscCliente.Pais>
                    <cfset lVarCodPostalR       = rsDomFiscCliente.CodPostal>
                </cfif>--->
                <cfquery name="SubTotalXML" dbtype="query">
                    select sum(SubTotalXML) as SubTotalXML, 
                    sum(((((SubTotalXML+OIDtotalCalc)+OIMontoIEPSLinea)- OIDdescuento)- OIMRetencion)) as TotalXML 
                    from rsDatosfac
                </cfquery>
                <cfset lVarSubTotal = #NumberFormat(SubTotalXML.SubTotalXML,'9.00')#>
                 <cfif valordecimal eq 2>
                    <cfset lVarTotal = #NumberFormat(rsDatosfac.OItotalLetras,'9.00')#>
                <cfelseif valordecimal eq 6>
                    <cfset lVarTotal = #NumberFormat(SubTotalXML.TotalXML,'9.00')#>
                <cfelse>
                    <cfset lVarTotal = #NumberFormat(rsDatosfac.OItotalLetras,'9.00')#>
                </cfif>
                <!---<cfset lVarTotal            = #NumberFormat(SubTotalXML.TotalXML,'9.00')#> Mandaba un total mal, Se adaptó el siguiente para facturas globales--->
               
                <cfset lVarTotalFinal       = #NumberFormat(SubTotalXML.TotalXML,'9.00')#>
                <cfset lVarImpuesto         = #NumberFormat(rsDatosfac.OIimpuesto,'9.00')#>
                <cfset lVarFechaExpedicion  = #Trim(rsDatosfac.fechaFactura)#>
                <cfset lVarTipoCFD          = rsDatosfac.tipoCFD>
                <cfset lVarLugarExpedicion  = GetLugarExpedicion(#session.Ecodigo#)>
                <cfset lVarTipoPagoId       = rsDatosfac.codigo_TipoPago>
                <cfset lVarRegFiscalId      = rsDatosfac.codigo_RegFiscal>
                <cfset lVarMetPago          = rsDatosfac.c_metPago>
               <!--- <cfset lVarCtaPago          = rsDatosfac.Cta_tipoPago>	--->
               <!--- <cfif lVarTipoPagoSAT EQ 98 >
                    <cfset lVarTipoPago     = rsDatosfac.nombre_TipoPago>
                <cfelse>--->
                    <cfset lVarTipoPago     = #numberformat(rsDatosfac.TipoPagoSAT,"00")#>
                <!---</cfif>--->
            
                <cfset lVarPctjeImpuesto    = rsDatosfac.Iporcentaje>
                <cfset lVarTipoFactor		= rsDatosfac.TipoFactor>
                <cfset lVarTasaOCuota		= LSNumberFormat(rsDatosfac.TasaOCuota,'_.______')>
                <cfset lVarTipoCambio       = rsDatosfac.OItipoCambio>
                <cfset lVarMoneda           = rsDatosfac.Miso4217>
                <cfset lVarConceptosFactura = "">
                <cfset lVarIvaDetFactura    = "">
                <cfset lVarIEPSDetFactura   = "">
                <cfset lVarUnidaCveSAT		= "">
                <cfset lVarTotImp           = 0>
                <cfset lVarMTRet  = 0.0>
                <cfset lVarMontoIEPS        = 0>
                <cfset lVarTotIEPS          = 0>
                <cfset lVarDescuento        = #NumberFormat(rsDatosfac.OIDescuento,'9.00')#>
                <cfset lVarPlazocredito    = #rsDatosfac.SNplazocredito#>
                <cfset lVarImpTClaveSAT = rsDatosfac.IClaveSAT>
                <cfloop query="rsDatosfac" >
                    <cfset lVarPctjeImpuesto= rsDatosfac.iporcentaje>
                    <cfset lVarImp = NumberFormat((rsDatosfac.OIDtotal) * (lVarPctjeImpuesto/100),'9.00')>
                    <cfset lVarMontoIEPS = rsDatosfac.OIMontoIEPSLinea>
                    <cfset lVarTotImp = lVarTotImp + LSNumberFormat(lVarImp,'9.00')+lVarMontoIEPS>
                </cfloop>
                
                <!---<cfthrow message="#rsLugarExpedicion.Miso4217# #lVarLugarExpedicion#">--->
                <cfoutput>
    
                <cfset lVarImp=0>
               
    
    
    
                <!--- INICIA - ARMADO XML--->
                <CFXML VARIABLE="xml32">
                    <cfdi:Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/4"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       <!--- <cfif rsDatosfac.usaINE EQ 1>
                            xmlns:ine="http://www.sat.gob.mx/ine" 
                            xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd 
                            http://www.sat.gob.mx/ine http://www.sat.gob.mx/sitio_internet/cfd/ine/ine11.xsd"
                        <cfelse>--->
                            xsi:schemaLocation="http://www.sat.gob.mx/cfd/4 http://www.sat.gob.mx/sitio_internet/cfd/4/cfdv40.xsd"
                        <!--- </cfif>--->
                        Version="4.0" Serie="#Arguments.Serie#" Folio="#Arguments.Folio#" Fecha="#lVarFechaExpedicion#" Sello="." 
                        FormaPago="#lVarTipoPago#" NoCertificado="#vNumCertificado#" Certificado="#vCertificado#"
                        <cfif form.cctcodigo NEQ 'NC' and yesNoFormat(lVarPlazocredito)> CondicionesDePago="#lVarPlazocredito# dias" </cfif>
                        SubTotal="#numberFormat(lVarSubTotal,'9.00')#"
                        <cfif lVarDescuento GT 0> Descuento="#NumberFormat(lVarDescuento,'9.00')#" </cfif>
                        Moneda="#trim(fnSecuenciasEscape(lVarMoneda))#" TipoCambio="#lVarTipoCambio#"  Total="#LSNumberformat(lVarTotal,'_.00')#"
                        TipoDeComprobante="#lVarTipoCFD#" Exportacion="01" MetodoPago="#lVarMetPago#" 
                        LugarExpedicion="#trim(fnSecuenciasEscape(lVarLugarExpedicion.LugarExpedicion))#">
    
                        <cfif isDefined('form.sust') or isDefined('form.anticipo') or form.cctcodigo EQ 'NC'>    
                            <cfif isdefined("rsRelacionados") and rsRelacionados.RecordCount gt 0>
                                <!--- El PAC informó que no es necesario el nodo de documentos relacionados para timbrar (responde con un error de timbrado si existen docs relacionados)--->
                                <cfdi:CfdiRelacionados TipoRelacion="#rsRelacionados.TipoRelacion#">
                                    <cfloop query="rsRelacionados">
                                        <cfdi:CfdiRelacionado UUID="#TimbreDocRel#"/>
                                    </cfloop>
                                </cfdi:CfdiRelacionados>
                            </cfif>  
                        </cfif>

                       <cfdi:Emisor Rfc="#trim(fnSecuenciasEscape(lVarRFCEmisor))#" Nombre="#trim(fnSecuenciasEscape(lVarNombreEmisor))#" 
                           RegimenFiscal="#trim(fnSecuenciasEscape(lVarRegFiscal))#"/>
                         
                       <cfdi:Receptor Rfc="#trim(fnSecuenciasEscape(lVarRFCCliente))#" Nombre="#trim(fnSecuenciasEscape(lVarNombreClienteFiscal,"no"))#"  
                            DomicilioFiscalReceptor ="#lVarCodPostalRec#"  RegimenFiscalReceptor="#trim(fnSecuenciasEscape(lVarRegFiscC))#" UsoCFDI="#trim(fnSecuenciasEscape(lVarUsoCFDI))#"/> 
                      
                    
                    <cfset lVarConRet  = false><!--- JARR retenciones 2020 --->
                        <cfdi:Conceptos>
                            <cfloop  query="rsDatosFac">
                                <!---<cfset lVarConRet  = false>---><!--- JARR retenciones 2020 --->
                                <cfset lVarCantidad  = rsDatosfac.OIDCantidad>
                                <cfset lVarUniMedida = rsDatosfac.Udescripcion>
                                <cfset lVarUnidaCveSAT = rsDatosfac.UMClaveSAT>
                                <cfset lVarDescripcion = rsDatosfac.OIDdescripcion &" " & rsDatosfac.OIDdescnalterna >
                                <cfset lVarPrecioUnitario = #NumberFormat(rsDatosfac.OIDPrecioUni,'#numRemplazables#')#>
                                <cfset lVarTasaOCuotaT = #LSNumberFormat(rsDatosfac.TasaOCuota,'_.______')#>
                                <cfset lVarDescuento = #LSNumberFormat(rsDatosfac.OIDdescuento,'_.______')#>
                                <cfset lVarTipoFactorT = rsDatosfac.TipoFactor>
                                <cfset lVarImporte=rsDatosfac.SubTotalXML>
                                <cfset IvarBaseIeps = rsDatosfac.SubTotalSinIeps>
                                <cfset IvarBaseIva = rsDatosfac.OIDTotal>
                                <cfset lVarImporteF=#NumberFormat(lVarCantidad*lVarPrecioUnitario-lVarDescuento,'9.00')#>
                                <cfset IVarTotalImp = #LSNumberformat((lVarImporteF + rsDatosfac.OIMontoIEPSLinea)*(lVarTasaOCuotaT),'9.00')#>
                                <cfset lVarObjetoImp = rsDatosfac.idObjImpuesto>
                                <cfif len(trim(rsDatosfac.Aid)) gt 0>
                                    <cfquery  name="rsCveSATConcepto" datasource="#session.dsn#">
                                            select ClaveSAT from Articulos
                                            where Ecodigo = #session.Ecodigo#
                                            and Aid = #rsDatosfac.Aid#
                                    </cfquery>
                                <cfelse>
                                    <cfquery  name="rsCveSATConcepto" datasource="#session.dsn#">
                                            select ClaveSAT from Conceptos
                                            where Ecodigo = #session.Ecodigo#
                                            and Cid = #rsDatosfac.Cid#
                                    </cfquery>
                                </cfif>
                                <cfset lVarCveSATConcepto = rsCveSATConcepto.ClaveSAT>
                                <cfdi:Concepto ClaveProdServ="#lVarCveSATConcepto#" Cantidad="#lVarCantidad#" ClaveUnidad ="#lVarUnidaCveSAT#"   Unidad="#lVarUniMedida#"   
                                    Descripcion="#trim(fnSecuenciasEscape(lVarDescripcion,"no"))#" ValorUnitario="#LSNumberformat(lVarPrecioUnitario,'#numRemplazables#')#" Importe="#LSNumberformat(lVarImporte,'_.00')#" 
                                    ObjetoImp = "#lVarObjetoImp#" 
                                    <cfif lVarDescuento NEQ 0>
                                        Descuento="#LSNumberformat(lVarDescuento,'_.00')#"
                                    </cfif>
                                    ><cfif lVarObjetoImp eq '02'>
                                        <cfdi:Impuestos>
                                                <cfdi:Traslados>
                                                        <cfset lVarPctjeImpuesto= rsDatosfac.iporcentaje>
                                                        <cfset lVarImpClaveSAT = rsDatosfac.IClaveSAT>
                                                        <cfset lVarImp=#NumberFormat((lVarCantidad*lVarPrecioUnitario-lVarDescuento) * (lVarPctjeImpuesto/100),'9.00')#>
                                                        <cfset lVarLinea = rsDatosfac.oidetalle>
                                                        <cfdi:Traslado  
                                                            Base="#Numberformat(IvarBaseIva,'9.00')#"
                                                            Impuesto="#lVarImpClaveSAT#"  TipoFactor="#lVarTipoFactorT#" 
                                                            <cfif lVarTipoFactorT neq "Exento">
                                                            TasaOCuota="#LSNumberformat(lVarTasaOCuotaT,'9.000000')#" 
                                                            Importe="#LSNumberformat(IVarTotalImp,'9.00')#" 
                                                            </cfif>
                                                            />
                                                             
                                                        <cfif len(trim(rsDatosfac.ClaveSATIeps)) GT 0>
                                                            <cfset lVarMontoIEPS = rsDatosfac.OIMontoIEPSLinea>
                                                            <cfset lVarCodIEPS = rsDatosfac.codIEPS>
                                                            <cfset lVarTasaIEPS=rsDatosfac.TasaOCuotaIeps>
                                                            <cfset IClaveSATIEPS=rsDatosfac.ClaveSATIeps>
                                                            <cfset ITipoFactorIEPS=rsDatosfac.TipoFactorIeps>
                                                           
                                                            <cfdi:Traslado  
                                                                Base="#LSNumberformat(IvarBaseIeps,'_.00')#" 
                                                                Impuesto="#IClaveSATIEPS#" 
                                                                TipoFactor="#ITipoFactorIEPS#" 
                                                                TasaOCuota="#LSNumberformat(lVarTasaIEPS,'9.000000')#"
                                                                Importe="#LSNumberformat(lVarMontoIEPS,'9.00')#"
                                                                 />  
                                                        </cfif>
                                                </cfdi:Traslados>
                                                <cfif rsDatosfac.Rporcentaje NEQ -1>
                                                    <cfset lVarConRet  = true>  
                                                    <cfset lVarPctjeRet= rsDatosfac.Rporcentaje>
                                                    <cfset lVarTipoFactorR = rsDatosfac.TipoFactorR>
                                                    <cfset lVarRClaveSAT = rsDatosfac.RClaveSAT>
                                                    <cfset lVarRBase=#NumberFormat((rsDatosfac.OIDtotal-lVarMontoIEPS),'9.00')#>
                                                    <cfset lVarMontoReten= #NumberFormat((rsDatosfac.OIDtotal-lVarMontoIEPS) * (lVarPctjeRet/100),'9.00')#>
                                                    <cfset lVarMTRet  =lVarMTRet+lVarMontoReten>
                                                    <cfdi:Retenciones><!--- JARR retenciones 2020 --->
                                                    <cfdi:Retencion Base="#lVarRBase#" Impuesto="#lVarRClaveSAT#" TipoFactor="#lVarTipoFactorR#" 
                                                        TasaOCuota="#LSNumberformat(lVarPctjeRet/100,'9.000000')#" Importe="#lVarMontoReten#"/>
                                                    </cfdi:Retenciones>
                                                </cfif>
                                        </cfdi:Impuestos> 
                               </cfif></cfdi:Concepto>
                            </cfloop>
                        </cfdi:Conceptos>
                            <cfquery name="rsObjImp2" dbtype="query">
                                select idObjImpuesto
                                from rsDatosFac
                                group by idObjImpuesto  
                            </cfquery>
                            <cfloop  query="rsObjImp2">
                                <cfif rsObjImp2.idObjImpuesto eq "02">     
                                     <cfset banderaObjImp = '1'>
                                </cfif>
                            </cfloop>   
                        <!---<cfif banderaObjImp eq '1'>--->
                        <cfif lVarConRet><!--- JARR retenciones 2020 --->
                         <!---<cfif lVarObjetoImp eq '02'>--->
                         
                             <cfdi:Impuestos  TotalImpuestosRetenidos="#LSNumberformat(lVarMTRet,'_.00')#" TotalImpuestosTrasladados="#LSNumberformat(lVarTotImp,'_.00')#">
                                
                                <cfquery name="rsRetenciones" dbtype="query">
                                    select TipoFactorR, Rporcentaje, RClaveSAT, OIMontoIEPSLinea, Retenciones,sum(OIDtotal) as<!--- OIDtotalCalc ---> OIDtotal
                                    from rsDatosFac where Rcodigo is not null
                                    group by TipoFactorR, Rporcentaje, RClaveSAT,OIMontoIEPSLinea,Retenciones
                                </cfquery>
                                
                                <cfloop  query="rsRetenciones">
                                        <cfset lVarTipoFactorTR = rsRetenciones.TipoFactorR>
                                        <cfset lVarPctjeImpuestoR= rsRetenciones.Rporcentaje>
                                        <cfset lVarImpClaveSATR = rsRetenciones.RClaveSAT>
                                        <cfset IVarTotalRetenciones = rsRetenciones.Retenciones>
                                    <cfdi:Retenciones><!--- JARR retenciones 2020 --->
                                      <cfdi:Retencion Impuesto="#lVarImpClaveSATR#" Importe="#LSNumberformat(IVarTotalRetenciones,'_.00')#"/>
                                    </cfdi:Retenciones>
                                </cfloop>
                               
                        <cfelse>
                             <cfdi:Impuestos TotalImpuestosTrasladados="#LSNumberformat(lVarTotImp,'_.00')#">
                        </cfif> 
                            
                            <cfdi:Traslados>
                                <cfquery name="rsImpuestos" dbtype="query">
                                    select TipoFactor, TasaOCuota, iporcentaje, IClaveSAT, sum(OIDtotal) <!--- OIDtotalCalc ---> OIDtotal, idObjImpuesto,sum(OIDtotalCalc2) OIDtotal2
                                    from rsDatosFac
                                    group by TipoFactor, TasaOCuota, iporcentaje, IClaveSAT, idObjImpuesto
                                    union
                                    select TipoFactorIeps, TasaOCuotaIeps, IporcentajeIeps, ClaveSATIeps, sum(SubTotalSinIeps) <!--- OIDtotalCalc ---> OIDtotal, idObjImpuesto,sum(OIMontoIEPSLinea) OIDtotal2
                                    from rsDatosFac 
                                    where ClaveSATIeps != '' and ClaveSATIeps is not null
                                    group by TipoFactorIeps, TasaOCuotaIeps, IporcentajeIeps, ClaveSATIeps, idObjImpuesto
                                </cfquery>
    
    
                                
                                <!---<cf_dump  var="#rsImpuestos#"> <cfabort>--->
                                <cfloop  query="rsImpuestos">
                                    <cfset lVarTasaOCuotaT = #LSNumberFormat(rsImpuestos.TasaOCuota,'_.______')#>
                                    <cfset lVarTipoFactorT = rsImpuestos.TipoFactor>
                                    <cfset lVarPctjeImpuesto= rsImpuestos.iporcentaje>
                                    <cfset lVarImpClaveSAT = rsImpuestos.IClaveSAT>
                                    <cfset lVarTotalImporte = #NumberFormat(rsImpuestos.OIDtotal2,'_.00')#>
    
                                    <!---<cfset lVarRBase = rsImpuestos>
                                    
                                     <cfset lVarImp= LSNumberFormat((rsImpuestos.OIDtotal) * (lVarPctjeImpuesto/100),'9.00')> --->
    
                                    <!---
                                    <cfdi:Traslado Importe="#LSNumberformat(lVarTotImp,'_.00')#" TasaOCuota="#lVarTasaOCuota#" TipoFactor="#lVarTipoFactor#"
                                            Impuesto="#lVarImpTClaveSAT#"/>
                                            --->
                                    <cfset lVarRBase=#NumberFormat(rsImpuestos.OIDtotal,'9.00')#>
                                    
                                    <cfif len(trim(lVarImpClaveSAT)) gt 0>
                                        <cfif rsImpuestos.idObjImpuesto eq '02'>
                                            <cfdi:Traslado Base = "#lVarRBase#" Impuesto="#lVarImpClaveSAT#" TipoFactor="#lVarTipoFactorT#" 
                                                        <cfif lVarTipoFactorT neq "Exento">
                                                            TasaOCuota="#LSNumberformat(lVarTasaOCuotaT,'9.000000')#" 
                                                            Importe="#lVarTotalImporte#"
                                                        </cfif>
                                                        />
                                        </cfif>
                                    </cfif>
                                </cfloop>
                            </cfdi:Traslados>
                        </cfdi:Impuestos>
                        <!---</cfif>--->
                <!--- Complemento INE
                        <cfif rsDatosfac.usaINE EQ 1>
                            <cfset lVarTipoProceso = rsDatosfac.OITipoProcesoINE> <!--- Requerido --->
                            <cfset lVarTipoComite  = rsDatosfac.OIComiteAmbito>
                            <cfset lVarIdContabilidad = rsDatosfac.SNIdContabilidadINE>
                            <cfset lVarEntidad = rsDatosfac.OIEntidad>
                            <cfdi:Complemento>
                                <ine:INE Version="1.1" TipoProceso="#lVarTipoProceso#"
                                    <cfif lVarTipoProceso EQ 'Ordinario' AND lVarEntidad NEQ ''>
                                        TipoComite = "#lVarTipoComite#">
                                            <ine:Entidad ClaveEntidad="#lVarEntidad#"> </ine:Entidad>
                                    <cfelseif lVarTipoProceso EQ 'Ordinario' AND lVarEntidad EQ ''>
                                        TipoComite = "#lVarTipoComite#">
                                    <cfelseif lVarTipoProceso NEQ 'Ordinario'>
                                        > <ine:Entidad ClaveEntidad="#lVarEntidad#" Ambito="#lVarTipoComite#"> </ine:Entidad>
                                    </cfif>
                                </ine:INE>
                            </cfdi:Complemento>
                        </cfif>--->
                        <!---  <cfif Arguments.adenda NEQ -1>  --->
                        <cfif isdefined('rsSNAdd') and rsSNAdd.RecordCount GT 0 >
                            <cfdi:Addenda> </cfdi:Addenda>
                        </cfif>
                    </cfdi:Comprobante>
                </CFXML>
                
            
                <!--- Validacion para obtener el Nodo de Addendas y agregarlo al XML --->
                <cfif isdefined('rsSNAdd') and rsSNAdd.RecordCount GT 0 >
                    <!--- Enviamos el XML --->
                    <!--- Enviamos datos capturados --->
                    <!--- <cfif isdefined("rsFEAdd") and rsFEAdd.NumCompra NEQ ''> --->
                        <cfinvoke component="sif.ad.Componentes.AddendasCC.#rsSNAdd.ADDNombre#" method="fnGeneraXML" returnvariable="LvarXML">
                            <cfinvokeargument name="HXML"   value="#xml32#">
                            <cfinvokeargument name="ADDid"   value="#rsSNAdd.ADDid#">
                            <cfinvokeargument name="addDetStruct"   value="#addDetStruct#">
                            <cfinvokeargument name="ordCompra"   value="1">
                        </cfinvoke>
                    <!--- <cfelse>
                        <cfthrow message="Error al Obtener el campo del N&uacute;mero de Orden">
                        <cfreturn false>
                    </cfif> --->
                    <!--- Agregamos el nodo de la Addenda al XML --->
                    <cfset xmlAdenda = xmlParse(LvarXML)>
                    <cfset arrImportedNodes = XmlImport(xml32,xmlAdenda.XmlRoot) />
                    <cfloop index="i" array=#arrImportedNodes#>
                        <!--- Append to first XML document. --->
                        <cfset ArrayAppend(xml32.XmlRoot.Addenda.XmlChildren,i) />
                    </cfloop>
                </cfif>
                <!--- 
                <cfif arguments.Adenda NEQ -1>
                    <cfquery name="rsXmlAdenda" datasource=#session.dsn#>
                        SELECT  XML_
                        FROM    Addendas
                        WHERE   Ecodigo = #session.Ecodigo#
                            AND ADDcodigo = '#Arguments.Adenda#'
                    </cfquery>
                    <cfset xmlAdenda = xmlParse(rsXmlAdenda.XML_)>
                    <cfset arrImportedNodes = XmlImport(xml32,xmlAdenda.XmlRoot) />
                    <cfloop index="i" array=#arrImportedNodes#>
                        <!--- Append to first XML document. --->
                        <cfset ArrayAppend(xml32.XmlRoot.Addenda.XmlChildren,i) />
                    </cfloop>
                </cfif> --->
            </cfoutput>
    
            <!--- Remover Caracteres especiales --->
            <cfset xml32 = cleanXML(ToString( xml32 ))>
            <cfset xml32 = replace(xml32,"CondicionesDePago", " CondicionesDePago", "All")>
            <cfset xml32 = replace(xml32,"Fecha", " Fecha", "All")>
            <cfset xml32 = replace(xml32,"Exportacion=", " Exportacion=", "All")>
            <!--- Se comenta replace por que se estaba poniendo doble el &amp;
            <cfset xml32 = replace(xml32,"&", "&amp;", "All")> 
            --->
            <!---<cfset xml32 = replace(xml32,"""", "&quot;", "All")>--->
            <!---<cfset xml32 = replace(xml32,"<", "&lt;", "All")>--->
            <!---<cfset xml32 = replace(xml32,">", "&gt;", "All")>--->
            <cfset xml32 = replace(xml32,"'", "&apos;", "All")> 
           
            
            
            <cfreturn xml32>
        </cffunction>
        <!--- FIN - Generacion de XML para Factura Electronica --->
    </cfcomponent>
    
