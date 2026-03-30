<!---
Componente desarrollado para brindar soporte a GeneraCFDIs
Escrito por: Giancarlo Benítez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (YYYY-MM-DD) Descripcion
Ultima Modificacion por Team Soin 
29/06/2022
--->


<cfcomponent extends='rh.Componentes.GeneraCFDIs.TimbrarXML'>

    <!--- INICIA - Funciones de Soporte--->

        <cffunction  name="ClassGeneraCSD"> <!--- Obtener clase GeneraCSD de Sello Digital .jar--->
            <cfobject type="java" class="generacsd.GeneraCSD" name="myGeneraCSD">
            <cfreturn myGeneraCSD>
        </cffunction>

        <cffunction  name="TimbradoXML">
            <cfargument name="xml" 					type="string" 	required="yes">
            <cfargument name="FolioDoc"				    type="numeric"	required="yes">
            <cfargument name="DEid" 					type="numeric" 	required="no" default="-1">
            <cfargument name="RCNid" 					type="numeric" 	required="no" default="-1">
            <cfargument name="DLlinea" 					type="numeric" 	required="no" default="-1">
            <cfargument name="OImpresionID" 			type="numeric" 	required="no" default="-1">
            <cfargument name="ReciboPago"				type="string"	required="no" default="-1">
            <cfset xmlTimbrado = TimbraXML(Arguments.xml,Arguments.FolioDoc,Arguments.DEid,Arguments.RCNid,Arguments.DLlinea,Arguments.OImpresionID,arguments.ReciboPago)>
            <cfreturn xmlTimbrado>
        </cffunction>
        <!--- Querys AFGM-SPR CONTROL DE VERSIONES--->
        <cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
        select Pvalor 
        from Parametros
        where Pcodigo = '17200'
            and Ecodigo = #session.Ecodigo#
        </cfquery>

        <cfset version = "#rsPCodigoOBJImp.Pvalor#">
        <!--- Fin Querys AFGM-SPR --->

        <!---Llamamos al componente de Zona Horaria --->
        <cfset ZonaHoraria = createObject("component","rh.Componentes.GeneraCFDIs.ZonaHoraria")>
        <cfset DiferenciaHorasTimbrado = ZonaHoraria.DiferenciaHorasTimbrado()>
        <cfif DiferenciaHorasTimbrado eq "">
            <cfset DiferenciaHorasTimbrado = 0>
        </cfif>
        <!---  --->

        <cffunction  name="FoliosCFDI" returntype="query"> <!--- Obtener el folio consecutivo--->
            <cfargument name="Serie"         type="string" 	    required="yes">
             <cfargument name="Folio"        type="string" 	    required="yes">

            <cfset todayDate = Now()> 
            <cfset _year = #DatePart("yyyy", todayDate)#> 
            <cfset _month = right("00#DatePart('m', todayDate)#",2) > 
         
          
            <cfquery name="SerieFolio" datasource="#session.dsn#">
                SELECT  '#arguments.Serie##_year##_month#_' as Serie, 
                    cast('#arguments.Folio#' as integer) AS Folio
                FROM    FA_FoliosCFDI
                WHERE   Ecodigo = #session.Ecodigo#
                AND     Serie='#arguments.Serie#_#_year##_month#'
            </cfquery>
            <cfif SerieFolio.recordCount eq 0>
                <cfquery datasource="#session.dsn#">
                    insert into FA_FoliosCFDI (Ecodigo,Serie,Folio) values (#session.Ecodigo#,'#arguments.Serie#_#_year##_month#',0)
                </cfquery>
                <cfquery name="SerieFolio" datasource="#session.dsn#">
                    SELECT  '#arguments.Serie#_#_year##_month#' as Serie, 
                        cast('#arguments.Folio#' as integer) AS Folio
                    FROM    FA_FoliosCFDI
                    WHERE   Ecodigo = #session.Ecodigo#
                    AND     Serie='#arguments.Serie#_#_year##_month#'
                </cfquery>
            </cfif>
            <cfquery name="updateFolio" datasource="#session.dsn#">
                update  FA_FoliosCFDI
                    set     Folio = #SerieFolio.Folio#
                where   Ecodigo=#session.Ecodigo#
                    AND     Serie = '#arguments.Serie#'
            </cfquery>
            <cfreturn SerieFolio>
        </cffunction>

        <cffunction name="GeneraSelloDigital" returntype="string"> <!--- Sellar la cadenaOriginal--->
            <cfargument name="cadenaOriginal"       type="string" 	required="yes">
            <cfquery name="datosSello" datasource="#session.dsn#">
                select archivoKey, clave from RH_CFDI_Certificados
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
            
            
            <cfset GeneraCSD = ClassGeneraCSD()>     
             
            <cfset selloDigital = GeneraCSD.getSelloDigital(cadenaOriginal,datosSello.archivoKey,datosSello.clave)>
                
            <cfreturn selloDigital>
        </cffunction>



        <cfif version eq '4.0'>
            <cfset direccion = "\GeneraCFDIs\CadenaCFDIv4.0\cadenaoriginal_4_0.xslt" > 
        <cfelseif version eq '3.3'>
            <cfset direccion = "\GeneraCFDIs\cadenaoriginal_3_3.xslt" > 
        </cfif>
        <cffunction name="GeneraCadenaOriginal" returntype="string"> <!--- obtener la cadenaOriginal--->
            <cfargument name="xmlString"       type="string" 	required="yes">     
            <cfargument name="xsltPath"       type="string" 	default="#GetDirectoryFromPath(GetCurrentTemplatePath())##direccion#">
            <cfset arguments.xsltPath = Replace(arguments.xsltPath,'\\','\','ALL')>
            <cfset arguments.xsltPath = Replace(arguments.xsltPath,'\','/','ALL')>
            <cfset GeneraCSD = ClassGeneraCSD()>
             
            <cfset cadenaOriginal = GeneraCSD.stringToCadenaOriginal('#arguments.xmlString#','#arguments.xsltPath#')>
           
            <cfreturn cadenaOriginal>
        </cffunction>
         

        <cffunction name="GetCertificado" access="public" returntype="query"><!--- Obtener el certificado para XML--->
            <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
            <cfif not isdefined('Arguments.Ecodigo')>
                <cfset Arguments.Ecodigo = "#session.Ecodigo#">
            </cfif>
            <cfquery name="rsCertificado" datasource="#session.dsn#">
                select coalesce(NoCertificado,'NA') as NoCertificado, coalesce(Certificado,'NA') as certificado, coalesce(archivoKey,'NA') as llave
                from RH_CFDI_Certificados
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
           
            <cfreturn rsCertificado>
        </cffunction>

        <cffunction name="cleanXML" returntype="string"> <!--- Limpiar el XML--->
            <cfargument name="xmlString"       type="string" 	required="yes">
            <cfset xmlClean = arguments.xmlString>
                <cfset xmlClean = replace(#xmlClean#,"á","a","ALL")>
                <cfset xmlClean = replace(#xmlClean#,"é","e","ALL")>
                <cfset xmlClean = replace(#xmlClean#,"í","i","ALL")>
                <cfset xmlClean = replace(#xmlClean#,"ó","o","ALL")>
                <cfset xmlClean = replace(#xmlClean#,"ú","u","ALL")>
                <cfset xmlClean = replace(#xmlClean#,"ü","u","ALL")>
                <cfset xmlClean = REreplace(#xmlClean#,'\s+',' ',"ALL")>
                <cfset xmlSP = reMatch('(\w|\d)=" (\w|\d)', xmlClean)>
                <cfloop array="#xmlSP#" index="i">
                    <cfset xmlClean = replace(xmlClean,i,Replace(i,' ','','all'))>
                </cfloop>
                <cfset xmlClean = REreplace(#xmlClean#,'\s',' ',"ALL")>
           <cfreturn xmlClean>
        </cffunction>

        <cffunction name="GetLugarExpedicion" returntype="query"> <!--- Obtener datos de Dirección del emisor de la factura--->
            <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
            <cfif not isdefined('Arguments.Ecodigo')>
                <cfset Arguments.Ecodigo = "#session.Ecodigo#">
            </cfif>
            <cfquery name="rsRegSel" datasource="#session.dsn#">
                select coalesce(Pvalor,'0') as Pvalor
                from RHParametros
                where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
                and Pcodigo = 45
            </cfquery>
            <cfquery name="rsDatosLugarExpedicion" datasource="#session.DSN#">
                select distinct
                    coalesce(ltrim(rtrim(e.Enombre)),'') as Enombre,
                    coalesce(replace(ltrim(rtrim(e.Eidentificacion)),'-',''),'') as Eidentificacion,
                    <!--- coalesce(d.ciudad,'')+', '+coalesce(d.estado,'') as LugarExpedicion, --->
                    coalesce(d.CSATcodigo,'') as LugarExpedicion,
                    ms.Mcodigo,
                    ms.ClaveSAT,<!--- moneda --->
                    <!--- r.codigo_RegFiscal, --->
                    r.ClaveSAT as codigo_RegFiscal,
					m.Miso4217,
                coalesce(d.Ppais,'') as Pais
                from Empresa e
                    inner join Empresas es
                        on e.Ecodigo=es.EcodigoSDC
                    inner join Direcciones d
                        on e.id_direccion = d.id_direccion
                    inner join Moneda m
                        on e.Mcodigo = m.Mcodigo
                    inner join Monedas ms
                        on ms.Miso4217 = m.Miso4217
                    inner join FARegFiscal r
                        on r.Ecodigo=es.Ecodigo
                        <cfif isdefined('rsRegSel') and rsRegSel.Pvalor GT 0>
                            and r.id_RegFiscal = cast(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRegSel.Pvalor#"> as numeric) <!---Revisar--->
                        </cfif>
                where es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
        <cfreturn rsDatosLugarExpedicion>
    </cffunction>

    <cffunction name="fnSecuenciasEscape" returntype="string"> <!--- Escapar caracteres especiales --->
        <cfargument name="Texto" type="string" required="yes">
        <cfargument name="dash" type="boolean" default="YES">
        <cfif Arguments.dash EQ "YES">
            <cfset LvarCuentaC = replace(Texto,"-","","ALL")>
        <cfelse>
            <cfset LvarCuentaC = Arguments.Texto>
        </cfif>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"&","&amp;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"""","&quot;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"&quot;", "","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"<","&lt;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,">","&gt;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"'","&apos;","ALL")>

        <cfset LvarCuentaC = Rtrim(Ltrim("#LvarCuentaC#"))>
        <cfreturn #LvarCuentaC#>
    </cffunction>

    <!--- FIN - Funciones de Soporte--->

    <!--- INICIA - Obtener Datos de Factura --->
        <cffunction name="obtenerDatosFacturaOI" returntype="query">
            <cfargument name="OImpresionID" type="numeric">
            <cfquery name="rsDatosfac" datasource="#session.DSN#">
                SELECT distinct c.id_direccion, c.SNid, SNnombre,
                        case    when substring(SNidentificacion,1,9)  = 'EXT010101' then 'XEXX010101000'
                                when right(RTRIM(SNidentificacion),3) = 'EXT' then 'XEXX010101000'
                                else SNidentificacion end as SNidentificacion,
                        d.direccion1 as SNdireccion,
                        d.direccion2 as SNdireccion2,Round(OItotal,2) as OItotal, Round(OItotal,2)  + Round(a.OIdescuento,2) as OItotalLetras,
                        Round(OIimpuesto,2) as OIimpuesto, Round(OIdescuento,2) as OIdescuento,
                        Round(OItotal,2) + Round(OIdescuento,2) - Round(OIimpuesto,2) - Round(OIieps,2) + isnull(Round(OIMRetencion,2),0) as OIsubtotal,
                        OIfecha, LTRIM(RTRIM(OIDdescripcion)) as OIDdescripcion, LTRIM(RTRIM(OIDdescnalterna)) as OIDdescnalterna,
                        OIDCantidad,Round(OIDtotal,2) as OIDtotal,Round(isnull(OIMRetencion,0),2) as OIMRetencion,OIDPrecioUni, OIObservacion,
                        Round(OIDdescuento,2) as OIDdescuento, a.OIdiasvencimiento,Mnombre, round(OIDtotal * i.TasaOCuota,2) as OIDtotalCalc,
                        Round(round(OIDtotal,2) * i.TasaOCuota,2) as OIDtotalCalc2,
                        OIvencimiento,ciudad+','+estado as LugarExpedicion,
                        a.OImpresionID as NUMERODOC  ,a.Ecodigo, a.c_metPago,
                        <!---case a.CCTcodigo
                                when  'FC' then 'ingreso'
                                when  'FA' then 'ingreso'
                                else  'egreso'
                            end as tipoCFD, --->
                        cct.ClaveSAT as tipoCFD,
                        datepart(dd,OIfecha),datepart(mm,OIfecha),datepart(yyyy,OIfecha),
                        datepart(hh,OIfecha),OIDetalle,
                        case 
                            when datediff(day,OIfecha,getdate()) >= 3 then
                                SUBSTRING(ltrim(rtrim(convert(char,Dateadd(HH,#DiferenciaHorasTimbrado#,getdate()),120))),1,10)+'T'+convert(char,Dateadd(HH,#DiferenciaHorasTimbrado#,getdate()),108)
                            else SUBSTRING(ltrim(rtrim(convert(char,Dateadd(HH,#DiferenciaHorasTimbrado#,OIfecha),120))),1,10)+'T'+convert(char,Dateadd(HH,#DiferenciaHorasTimbrado#,OIfecha),108) 
                        end as fechaFactura,
                        i.Iporcentaje,OItipoCambio,m.ClaveSAT as Miso4217,
                        a.codigo_TipoPago, a.codigo_RegFiscal, a.Cta_tipoPago as UsoCFDI, TP.nombre_TipoPago, TP.TipoPagoSAT,
                        RF.nombre_RegFiscal, Udescripcion, coalesce(OIieps,0) OIieps ,b.codIEPS,coalesce(i.ValorCalculo,0) tasaIEPS,
                        Round(coalesce(b.OIMontoIEPSLinea,0),2) as OIMontoIEPSLinea, c.usaINE, c.SNIdContabilidadINE, c.SNTipoPoliticoINE, a.OITipoProcesoINE,
                        a.OIComiteAmbito, a.OIEntidad, a.OIIdContabilidadINE, i.TipoFactor, i.ClaveSAT as IClaveSAT, i.TasaOCuota,
                        ieps.TipoFactor as TipoFactorIeps, ieps.ClaveSAT as ClaveSATIeps, ieps.TasaOCuota as TasaOCuotaIeps, ieps.Iporcentaje as IporcentajeIeps, OIDTotal - Round(coalesce(b.OIMontoIEPSLinea,0),2) as SubTotalSinIeps,
                        OIDTotal + OIDdescuento - Round(coalesce(b.OIMontoIEPSLinea,0),4) as SubTotalXML,
                        u.ClaveSAT as UMClaveSAT, b.ItemCodigo,
						con.Aid,con.Cid,
						ROUND((ROUND(OIDtotal,2) * (i.Iporcentaje / 100)),2) as ImpuestoD,
                        isnull(c.SNplazocredito,0) SNplazocredito,
coalesce(r.Iporcentaje, -1) as Rporcentaje,r.ClaveSAT as RClaveSAT,r.TipoFactor as TipoFactorR,
                        r.Icodigo as Rcodigo
                        ,CSATcodigo as idObjImpuesto, c.SNnombreFiscal as nombreFiscal, b.OIDtotal as totaltotal,
                        a.OItotal as TotalFinal,f.MRetencion as Retenciones, f.Total as TotalSubTotal, f.Impuesto as ImpuestosTotal, f.FAieps as IepsTotal,
                        Round(OItotal,2) + Round(OIdescuento,2) - Round(OIimpuesto,2) - Round(OIieps,2) + isnull(Round(OIMRetencion,2),0) as Totalsub
                FROM   FAEOrdenImpresion a
                        INNER JOIN FADOrdenImpresion b
                                on a.OImpresionID = b.OImpresionID
                                and a.Ecodigo = b.Ecodigo
                        INNER JOIN SNegocios c
                                on a.SNcodigo = c.SNcodigo
                                and a.Ecodigo = c.Ecodigo
                        LEFT JOIN  DireccionesSIF d
                                on a.id_direccionFact = d.id_direccion
                        LEFT JOIN  Monedas m
                                on a.Mcodigo = m.Mcodigo
                        INNER JOIN FAPreFacturaE f
                                on a.OIdocumento = f.DdocumentoREF and a.Ecodigo = f.Ecodigo
                        INNER JOIN FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo
                                and f.IDpreFactura=pfd.IDpreFactura and pfd.Linea = b.OIDetalle
                        INNER JOIN (
                            select Aid,null as Cid,Ucodigo,Ecodigo
                            from Articulos
                            where Ecodigo = #Session.Ecodigo#
                            union
                            select null as Aid, Cid,Ucodigo,Ecodigo
                            from Conceptos
                            where Ecodigo = #Session.Ecodigo#
                        ) con ON pfd.Ecodigo =con.Ecodigo AND (con.Cid=pfd.Cid or con.Aid = pfd.Aid)
                        INNER JOIN Unidades u on u.Ecodigo=con.Ecodigo
                                and con.Ucodigo= u.Ucodigo
                        INNER JOIN Impuestos i
                                on b.Icodigo = i.Icodigo
                                and b.Ecodigo = i.Ecodigo
                        left JOIN Impuestos ieps
                                on b.codIEPS = ieps.Icodigo
                                and b.Ecodigo = ieps.Ecodigo
                        INNER JOIN CCTransacciones cct
                                on  a.Ecodigo = cct.Ecodigo
                                and a.CCTcodigo = cct.CCTcodigo
                        LEFT JOIN FATipoPago TP
                                on TP.Ecodigo = a.Ecodigo and TP.codigo_TipoPago = a.codigo_TipoPago AND TP.Ecodigo = a.Ecodigo
                        LEFT JOIN FARegFiscal RF
                                on RF.Ecodigo = a.Ecodigo and RF.ClaveSAT = a.codigo_RegFiscal
                        left join Impuestos r
                                on r.Icodigo = b.Rcodigo
                                and r.Ecodigo = b.Ecodigo
                                and r.IRetencion=1
                        left JOIN CSATObjImpuesto AS obj
                                on obj.IdObjImp = pfd.IdImpuesto
                WHERE  a.OImpresionID =  #arguments.OImpresionID#
                                and a.Ecodigo = #session.Ecodigo#
                        ORDER BY OIDetalle
            </cfquery>




            <cfset F_OITotal = 0>
            <cfset Acum_Impuesto = 0>
            <cfset Acum_Descuento = 0>
            <cfset Acum_IEPS = 0>
            <cfset Acum_Subtotal = 0>
            <cfset Acum_SubtotalSinIeps = 0>
            <cfset Acum_Retenciones = 0>
            <cfloop query="#rsDatosFac#">
                <cfset F_OITotal = NumberFormat(OItotal,"9.00")>
                <cfset Acum_Impuesto += NumberFormat(OIDtotal * TASAOCUOTA,"9.00")>
                <cfset Acum_Descuento += NumberFormat(OIDDESCUENTO,"9.00")>
                <cfset Acum_IEPS += NumberFormat(OIDtotal * TASAIEPS,"9.00")>
                <cfset Acum_Subtotal += NumberFormat(OIDtotal,"9.00")>
                <cfset Acum_SubtotalSinIeps += NumberFormat(SubTotalSinIeps,"9.00")>
                <cfset Acum_Retenciones += NumberFormat(OIMRetencion,"9.00")>
            </cfloop>
            <cfset diff = NumberFormat(F_OITotal - (Acum_Subtotal + Acum_IEPS + Acum_Impuesto - Acum_Descuento - Acum_Retenciones),"0.00")>
            <cfif diff eq 0>
                <!--- FACTURA IS OK --->
            <cfelseif diff lt 0.012 or diff gt -0.12>
                <cfloop query="#rsDatosFac#">
                    <cfset rsDatosFac.OItotal = NumberFormat(rsDatosFac.OItotal - diff,"9.00")>
                    <cfset rsDatosFac.OITOTALLETRAS = NumberFormat(rsDatosFac.OITOTALLETRAS - diff,"9.00")>
                    <cfset rsDatosFac.OIimpuesto = NumberFormat(Acum_Impuesto,"9.00")>
                    <cfset rsDatosFac.OIDESCUENTO = NumberFormat(Acum_Descuento,"9.00")>
                    <cfset rsDatosFac.OIIEPS = NumberFormat(Acum_IEPS,"9.00")>
                    <cfset rsDatosFac.OIsubtotal = NumberFormat(Acum_SubtotalSinIeps,"9.00")>
                </cfloop>
            <cfelse>
                <cfthrow message="[rsDatosFac] El total de la factura no coincide con (Subtotal + Impuestos + IEPS - Descuentos)">
            </cfif>
            <cfreturn rsDatosfac>
        </cffunction>
        
    <!--- FIN - Obtener Datos de Factura --->
 <cffunction name="XmlImport" access="public" returntype="any" output="false" hint="Import the given XML data into the given XML document so that it can inserted into the node tree.">

    <!--- Define arguments. --->
    <cfargument name="ParentDocument" type="xml" required="true" hint="Parent XML document into which the given nodes will be imported." />
    <cfargument name="Nodes" type="any" required="true" hint="XML tree or array of XML nodes to be imported." />

    <!--- Define the local scope. --->
    <cfset var LOCAL = {} />

    <cfif IsArray( ARGUMENTS.Nodes )>
        <!--- Create a new array to return imported nodes. --->
        <cfset LOCAL.ImportedNodes = [] />

        <!--- Loop over each node and import it. --->
        <cfloop index="LOCAL.Node" array="#ARGUMENTS.Nodes#">
            <!--- Import and append to return array. --->
            <cfset ArrayAppend(LOCAL.ImportedNodes,XmlImport(ARGUMENTS.ParentDocument,LOCAL.Node)) />
        </cfloop>
        <!--- Return imported nodes array. --->
        <cfreturn LOCAL.ImportedNodes />
    <cfelse>
        <cfset LOCAL.NewNode = XmlElemNew(ARGUMENTS.ParentDocument,ARGUMENTS.Nodes.XmlName) />
        <!--- Append the XML attributes. --->
        <cfset StructAppend(LOCAL.NewNode.XmlAttributes,ARGUMENTS.Nodes.XmlAttributes) />
        <!---
        <cfset LOCAL.NewNode.XmlNsPrefix = ARGUMENTS.Nodes.XmlNsPrefix />
        <cfset LOCAL.NewNode.XmlNsUri = ARGUMENTS.Nodes.XmlNsUri />
        --->
        <cfset LOCAL.NewNode.XmlText = ARGUMENTS.Nodes.XmlText />
        <!--- <cfset LOCAL.NewNode.XmlComment = ARGUMENTS.Nodes.XmlComment /> --->

        <!---
        Loop over the child nodes and import them as well
        and then append them to the new node.
        --->
        <cfloop index="LOCAL.ChildNode" array="#ARGUMENTS.Nodes.XmlChildren#">
            <!--- Import and append. --->
            <cfset ArrayAppend(LOCAL.NewNode.XmlChildren,XmlImport(ARGUMENTS.ParentDocument,LOCAL.ChildNode)) />
        </cfloop>

        <!--- Return the new, imported node. --->
        <cfreturn LOCAL.NewNode />
    </cfif>
</cffunction>

</cfcomponent>