<cfsetting requesttimeout="8600">
<cfparam name="formato" default="Flashpaper">
<cfparam name="CPid" default="">
<cfparam name="CFidI" default="">
<cfparam name="nomail" default="0">

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Boleta_Pago"  default="Boleta de Pago" returnvariable="LB_Boleta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
<cfinvoke key="LB_SalarioBruto" default="Salario Bruto" returnvariable="LB_SalarioBruto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
<cfinvoke key="LB_Retroactivos" default="RETROACTIVOS" returnvariable="LB_Retroactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
<cfinvoke key="LB_Renta"        default="ISPT" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
<cfinvoke key="LB_GenerarArchivoTexto" default="Generar archivo de texto" returnvariable="LB_GenerarArchivoTexto" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />
<!--- FIN VARIABLES DE TRADUCCION --->

<!---Obtener cual formato de boleta se esta usando----->
<cfquery name="rsParametro" datasource="#session.DSN#">
    select coalesce(Pvalor,'10') as Pvalor
    from RHParametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Pcodigo = 720
</cfquery>

<!---Componente que trae llena el la tabla temporal con los datos que necesitamos--->
<cfinvoke component="rh.Componentes.RH_BoletaPagoDatos" method="getConceptosPago" returnvariable="TMPConceptos">
    <cfinvokeargument name="CPid" value="#form.CPid#">
    <cfinvokeargument name="DEidList" value="#form.chk#">
    <cfinvokeargument name="Historico" value="yes">
</cfinvoke>

<!---<cf_dumptable var="#TMPConceptos#">--->

<cfquery name="rsEtiquetaPie" datasource="#session.DSN#">
    select Mensaje from MensajeBoleta
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery name="ConceptosPago" datasource="#session.DSN#">
    select *
    from #TMPConceptos#
    <!---where devengado != 0---->

    <!---where (    devengado != 0 or
            deducido != 0 or
            neto != 0
            or montoconcepto != 0)--->

    order by orden,DEid,linea
</cfquery>

<cfset vb_pagebreak = true><!---Indicar que haga corte---->
<cfif isdefined("formato") and formato EQ "FlashPaper">
    <cfset vb_flashpaper = true><!---Indicar que es flashpaper---->
</cfif>
<!--- <cfinclude template="FormatoBoletaPagoDosTercios.cfm"> --->
<!--- <cfdump var="stop"> --->
<!--- <cfoutput>#detalle#</cfoutput> --->

<!--- DESARROLLO ENFOCADO A BOLETA DE PAGO ESTADAR (México) --->
<cfset unHTMLTmp = "">
<cfset arrImgQR = arraynew(1)>
<cfset count = 0>

<!--- OPARRALES 2019-01-28
    - Modificacion para generar gerarquia de carpetas y dar mejor estructura a los archivos de nomina
 --->
<cfquery name="rsCP" datasource="#session.dsn#">
    select CPcodigo
    from
        CalendarioPagos cp
    inner join TiposNomina tn
        on cp.Ecodigo = tn.Ecodigo
        and cp.Tcodigo=tn.Tcodigo
    where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and CPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
</cfquery>
<cfset vsPath_A = "#Left(ExpandPath( GetContextRoot()),2)#">

 <cf_foldersFacturacion name = "ruta">
<!--- Ejemplo Nomina2019 --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<!--- Ejemplo Nomina2019/Nomina-DEMO --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001 --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001/PDF --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/PDF'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001/imgQR --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/imgQR'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001/xmlST --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/xmlST'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001/xmlT --->
<cfset rutaDirTmp = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/xmlT'>
<cfif !directoryExists(rutaDirTmp)>
    <cfset directoryCreate(rutaDirTmp)>
</cfif>

<cfset enviaCorreo = false>
<cfloop list="#form.chk#" index="unDEid">
    <cfset count++>
    <cfquery name="rsReciboCFDI" datasource="#session.dsn#" >
        select count(*) existe from RH_CFDI_RecibosNomina
        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#unDEid#">
        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.RCNid#">
        <cfif isDefined("form.chkRetimbrar")>
            and stsTimbre = 3
        <cfelse>
            and stsTimbre=1
        </cfif>
    </cfquery>
    <cfif isDefined("form.chkRetimbrar")>
        <cfquery name="rsExiste" datasource="#session.dsn#" >
            select * from RH_CFDI_RecibosNomina
            where
                DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#unDEid#">
            and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
            and stsTimbre = 1
        </cfquery>
    </cfif>
    <cftry>
        <cfif rsReciboCFDI.existe eq 0>
            <!--- Timbrando Boletas de Pago --->
            <cfset enviaCorreo = true>
            <cfinvoke component="rh.Componentes.GeneraCFDIs" method="obtenerCFDI">
                <cfinvokeargument name="DEid" value="#unDEid#">
                <cfinvokeargument name="RCNid" value="#form.CPid#">
                <cfinvokeargument name="Retimbrar" value="#isDefined('form.chkRetimbrar')#">
            </cfinvoke>
        </cfif>
        
        <cfquery name="rsReciboCFDI" datasource="#session.dsn#" >
            select count(*) existe from RH_CFDI_RecibosNomina
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#unDEid#">
            and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
            <cfif isDefined("form.chkRetimbrar") and isDefined("rsExiste") and rsExiste.RecordCount gt 0>
                and stsTimbre = 3
            <cfelse>
                and stsTimbre=1
            </cfif>
        </cfquery>

        <cfif rsReciboCFDI.existe eq 0>
            <cfquery name="rsEmpleado" datasource="#session.dsn#">
                select concat(de.DEidentificacion,' - ',de.DEnombre,de.DEapellido1,DEapellido2) as nombre
                from DatosEmpleado de where DEid = #unDEid#
            </cfquery>
            <cfset enviaCorreo = false>
            <cf_throw message="<br/>Ocurrio un problema al timbrar...<br/> Revise los errores en el XML generado para el empleado:  <br/>#rsEmpleado.nombre#. " errorcode="50720">
        </cfif>
        
        <cfif IsDefined('form.chkReenvioCorreo')>
            <cfset enviaCorreo = true>
        </cfif>
        
        <!--- Pintando PDF --->
        <cfset unHTMLTmp &= PDFxEmpleado(unDEid,form.CPid,enviaCorreo)>
        <cfif listlen(form.chk) gt 1 and count neq listlen(form.chk)>
            <cfset unHTMLTmp &= '<div class="saltopagina"></div>'>
        </cfif>
    <cfcatch type="template">
        <cfabort>
    </cfcatch>
    </cftry>
</cfloop>

<!--- <cfoutput>#unHTMLTmp#</cfoutput>
<cf_dump var="#arrImgQR#"> --->
<!--- <cfloop array="#arrImgQR#" index="unPath">
    <cffile action="delete" file="#unPath#">
</cfloop> --->
<!--- Bloque de PDF concatenados --->
<cfoutput>
    <!---al no poner filename permite visualizar el contenido en el navegador... filename="#vsPath_A#\Enviar\PDF\#miNombre#" --->
    <cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
    <cfif REFind('(cfmx)$',vsPath_R) gt 0> 
        <cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
    <cfelse> 
        <cfset vsPath_R = "#vsPath_R#\">
    </cfif>

    <cfset pathTemp = "#vsPath_R#DocsNomina">
    <cfset CheckDir("#pathTemp#")>
    <cfset varNameTmp   = "#Trim(rsCP.CPcodigo)#.pdf">

    <cfif !directoryExists('#pathTemp#')>
        <cfset directoryCreate('#pathTemp#')>
    </cfif>
    <cfdocument  format="PDF" filename="#pathTemp#\#varNameTmp#" mimetype="image/png" overwrite="true" localurl="false">
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 5.0 Transitional//EN">
            #unHTMLTmp#
    </cfdocument>
    
    <cfheader name="Content-Disposition" value="attachment; filename=#varNameTmp#">
    <cfcontent type="text/html" file="#pathTemp#\#varNameTmp#" deletefile="no" reset="yes">
    <cflocation  url="ImpBoletasPago-filtro.cfm">
    <!---
        <cfdocument  format="PDF" overwrite="true" encryption="128-bit" localurl="false">
            <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 5.0 Transitional//EN">
                #unHTMLTmp#
        </cfdocument>
     --->
</cfoutput>


<cffunction name="PDFxEmpleado" access="public" returntype="String">
    <cfargument name="DEid"  type="numeric" required="true">
    <cfargument name="RCNid" type="numeric" required="true">
    <cfargument name="enviaCorreo" type="boolean" required="true">

    <cfquery name="rsReciboCFDI" datasource="#session.dsn#">
        select *  from RH_CFDI_RecibosNomina
        where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and stsTimbre=1
    </cfquery>

    <cfquery name="getDatosCert" datasource="#session.dsn#">
        select archivoKey from RH_CFDI_Certificados
    </cfquery>
    <cfset vsPath_A = left(#getDatosCert.archivoKey#,2)>


    <cfquery name="rsReporte" datasource="#session.dsn#">
        select
            de.DEid,
            de.DEidentificacion as CLABE,
            de.DEnombre as Nombre,
            de.DEapellido1 as ape1,
            de.DEapellido2 as ape2,
            coalesce(de.DEdireccion,'') as DEdireccion,
            (select CPcodigo from CalendarioPagos a, HRCalculoNomina b,TiposNomina c
            where a.Ecodigo = 1 and b.RCNid = a.CPid and b.Ecodigo = c.Ecodigo and b.Tcodigo = c.Tcodigo
            and a.CPfcalculo is not null and b.RCNid = #Arguments.RCNid#) as CodigoNomina,
            (Select RHRegimendescripcion from RHCFDI_Regimen where RHRegimenid = de.RHRegimenid) as regimenDesc
        FROM
            DatosEmpleado de
        where de.DEid = #Arguments.DEid#
    </cfquery>

    <cfquery name="rsEmp" datasource="#session.dsn#">
        select DEidentificacion + '_'+ DEnombre + ' ' + DEapellido1 +' ' + DEapellido2 as Emp
        from DatosEmpleado
        where DEid = #Arguments.DEid#
    </cfquery>
    <cfquery name="rsNomina" datasource="#session.dsn#">
        select RCDescripcion from HRCalculoNomina
        where RCNid=#Arguments.RCNid#
    </cfquery>

     <cf_foldersFacturacion name = "ruta">
     

    <!--- Se comento para que siempre muestre los PDF generados --->
    <!--- <cfset miNombre = "#vsPath_A#\Enviar\PDF\#trim(rsReporte.CLABE)#_"&"#trim(rsReporte.NOMBRE)#"&"-#trim(rsReporte.APE1)#"&"-#trim(rsReporte.APE2)#"&"_#trim(rsReporte.CODIGONOMINA)#.pdf"> --->
    <cfset miNombre = "#trim(rsReporte.CLABE)#_"&"#trim(rsReporte.NOMBRE)#"&"-#trim(rsReporte.APE1)#"&"-#trim(rsReporte.APE2)#"&"_#trim(rsReporte.CODIGONOMINA)#.pdf">
    <cfset nameXML = "#Arguments.DEid#_#Arguments.RCNid#.xml">

    <cfif FileExists(miNombre)>
        <cffile file="#miNombre#" action="read" variable="unPDF" charset="windows-1252">
    <cfelse>
        <cffile action="read" variable="xml32" file="#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/xmlST/#Arguments.DEid#_#Arguments.RCNid#.xml" charset="utf-8">
        <cffile action="read" variable="xml32Timbrado" file="#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/xmlT/#rsEmp.Emp#_#rsNomina.RCDescripcion#T.xml" charset="utf-8">
        
        <cfset miXml = replace(#xml32#,"="" ","=""","ALL")>
        <cfset miXml = replace(#miXml#,"Descuento="," Descuento=","ALL")>
        <cfset miXml = replace(#miXml#,"Serie="," Serie=","ALL")>
        <cfset miXml = replace(#miXml#,"<cfdi:Comprobante","<Comprobante")>
        <cfset miXml = replace(#miXml#,"</cfdi:Comprobante>","</Comprobante>")>
        <cfset miXml = replace(#miXml#,"<cfdi:Emisor","<Emisor")>
        <cfset miXml = replace(#miXml#,"</cfdi:Emisor>","</Emisor>")>
        <cfset miXml = replace(#miXml#,"<cfdi:RegimenFiscal","<RegimenFiscal")>
        <cfset miXml = replace(#miXml#,"</cfdi:RegimenFiscal","</RegimenFiscal")>
        <cfset miXml = replace(#miXml#,"<cfdi:Receptor","<Receptor")>
        <cfset miXml = replace(#miXml#,"</cfdi:Receptor>","</Receptor>")>
        <cfset miXml = replace(#miXml#,"<cfdi:Conceptos>","<Conceptos>")>
        <cfset miXml = replace(#miXml#,"<cfdi:Concepto ","<Concepto ")>
        <cfset miXml = replace(#miXml#,"</cfdi:Conceptos>","</Conceptos>")>
        <cfset miXml = replace(#miXml#,"<cfdi:Impuestos","<Impuestos")>
        <cfset miXml = replace(#miXml#,"</cfdi:Impuestos>","</Impuestos>")>
        <cfset miXml = replace(#miXml#,"<cfdi:Complemento","<Complemento")>
        <cfset miXml = replace(#miXml#,"</cfdi:Complemento","</Complemento")>
        <cfset miXml = replace(#miXml#,"<nomina12:Emisor ","<Emisor ")>
        <cfset miXml = replace(#miXml#,"</nomina12:Emisor>","</Emisor>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Receptor ","<Receptor ")>
        <cfset miXml = replace(#miXml#,"</nomina12:Receptor>","</Receptor>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Nomina ","<Nomina ")>
        <cfset miXml = replace(#miXml#,"</nomina12:Nomina>","</Nomina>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Percepciones ","<Percepciones ")>
        <cfset miXml = replace(#miXml#,"</nomina12:Percepciones>","</Percepciones>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Percepcion ","<Percepcion ","ALL")>
        <cfset miXml = replace(#miXml#,"</nomina12:Percepcion","</Percepcion","ALL")>
        <cfset miXml = replace(#miXml#,"<nomina12:Deducciones ","<Deducciones ")>
        <cfset miXml = replace(#miXml#,"</nomina12:Deducciones>","</Deducciones>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Deduccion ","<Deduccion ","ALL")>
        <cfset miXml = replace(#miXml#,"</nomina12:Deduccion","</Deduccion","ALL")>
        <cfset miXml = replace(#miXml#,"<nomina12:HorasExtra ","<HorasExtra ","ALL")>
        <cfset miXml = replace(#miXml#,"<nomina12:HorasExtra","<HorasExtra","ALL")>
        <cfset miXml = replace(#miXml#,"<nomina12:Nomina >","<Nomina>")>
        <cfset miXml = replace(#miXml#,"</nomina12:Nomina>","</Nomina>")>
        <cfset miXml = replace(#miXml#,"<nomina12:OtrosPagos>","<OtrosPagos>")>
        <cfset miXml = replace(#miXml#,"</nomina12:OtrosPagos>","</OtrosPagos>")>
        <cfset miXml = replace(#miXml#,"<nomina12:OtroPago ","<OtroPago ")>
        <cfset miXml = replace(#miXml#,"</nomina12:OtroPago>","</OtroPago>")>
        <cfset miXml = replace(#miXml#,"<nomina12:SubsidioAlEmpleado>","<SubsidioAlEmpleado>")>
        <cfset miXml = replace(#miXml#,"</nomina12:SubsidioAlEmpleado>","</SubsidioAlEmpleado>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Incapacidades>","<Incapacidades>")>
        <cfset miXml = replace(#miXml#,"</nomina12:Incapacidades>","</Incapacidades>")>
        <cfset miXml = replace(#miXml#,"</nomina12:Incapacidad>","</Incapacidad>")>
        <cfset miXml = replace(#miXml#,"<nomina12:Incapacidad ","<Incapacidad ")>
        <cfset miXml = replace(#miXml#,"<nomina12:SubsidioAlEmpleo ","<SubsidioAlEmpleo ")>
        <cfset miXml = replace(#miXml#,"<tfd:TimbreFiscalDigital ","<TimbreFiscalDigital ")>
            
        <cfset miXml = replace(miXML,"Serie"," Serie")>
        <cfset miXml = replace(miXML,"Descuento="," Descuento=")>
        <cfset miXml = replace(#miXml#,"SubTotal"," SubTotal")>
        <cfset miXml = replace(#miXml#,"Fecha="," Fecha=","ALL")>

        <CFFILE ACTION="read" FILE="#expandPath('/rh/XSLT/CFDI_PDF.xslt')#" variable="miXSLT">

        <!--- OPARRALES
          --- Parametros extras que no vienen en el XML original
        --->

        <cfquery name="rsOP" datasource="#session.dsn#" >
            select
                coalesce(timbre,'') as timbre,
                coalesce(certificadoSAT,'') as certificadoSAT,
                coalesce(fechaTimbrado,'') as fechaTimbrado,
                codigoQR,
                substring(SelloDigital,(len(SelloDigital)-7), 8) qrfe
            from RH_CFDI_RecibosNomina
            where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.DEid#">
            and RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptosPago.RCNid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>

        <!---
            Obteniendo el Centro Funcional basado en la ultima accion del empleado
            Hasta este punto se da por hecho que el empleado ya tiene un CF asignado.
         --->
        <cfquery name="rsCF" datasource="#session.dsn#">
            select
                top 1 ltrim(rtrim(cf.CFdescripcion)) as CentroFuncional
            from DLaboralesEmpleado dle
            inner join RHTipoAccion ta
            on ta.RHTid = dle.RHTid
            and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            inner join RHPlazas p
            on p.RHPid = dle.RHPid
            inner join CFuncional cf
            on cf.CFid = p.CFid group by dle.DLfechaaplic,cf.CFdescripcion
            ORDER BY dle.DLfechaaplic desc
        </cfquery>

        <cfquery name="rsCodigoNomina" datasource="#session.dsn#">
            select
                CPcodigo as CodigoNomina
            from CalendarioPagos a,
                HRCalculoNomina b,
                TiposNomina c
            where
                a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and b.RCNid = a.CPid
            and b.Ecodigo = c.Ecodigo
            and b.Tcodigo = c.Tcodigo
            and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            and a.CPfcalculo is not null
        </cfquery>

        <cfquery name="rsPuesto" datasource="#session.dsn#">
            select top 1 pu.RHPdescpuesto from DLaboralesEmpleado dle
            inner join RHTipoAccion ta on dle.RHTid = ta.RHTid
            and ta.RHTcomportam = 1
            inner join RHPuestos pu on pu.RHPcodigo = dle.RHPcodigo
            and dle.DEid = #Arguments.DEid#
            order by dle.DLfvigencia desc
        </cfquery>


        <cfset ImgPath = "#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/imgQR/#rsReporte.DEid#_#Arguments.RCNid#.jpg">
        
        <cftry>
            <!--- Instancia la Clase TestQRCode --->
            <cfset sXML = XmlParse(miXML)>
            <cfset sXMLT = XmlParse(xml32Timbrado)>

            <cfset lVarTimbre=sXMLT['cfdi:Comprobante']['cfdi:Complemento']['XmlChildren'][2].XmlAttributes.UUID>
            <cfset lVarRFCemisor=#sXML.Comprobante.Emisor.XmlAttributes.Rfc#>
            <cfset lVarRFCreceptor=#sXML.Comprobante.Receptor.XmlAttributes.Rfc#>
            <cfset lVarTotal = #LSNumberformat(sXML.Comprobante.XmlAttributes.Total,'0000000000.000000')#>
            <cfset lVarQRFE= sXMLT['cfdi:Comprobante']['cfdi:Complemento']['XmlChildren'][2].XmlAttributes.SelloSAT>

			<cfset cadenaQR = "https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?&id=#lVarTimbre#&re=#lVarRFCemisor#&rr=#lVarRFCreceptor#&tt=#lVarTotal#&fe=#right(lVarQRFE,8)#">
            <cfobject type="java" class="generacsd.TestQRCode" name="myTestQRCode">
            <!--- Generar codigo bidimencional --->     
            <cfif FileExists(ImgPath)>
                <cfscript>
                    FileDelete(ImgPath);
                </cfscript> 
            </cfif>

            <cfset image = myTestQRCode.generateQR(ImgPath,cadenaQR,300,300)>
        <cfcatch>
        </cfcatch>
        </cftry>

        <cffile action = "readBinary" file = "#ImgPath#" variable = "contenidoQR">

        <cfset rutaTmp = expandPath('/imgQRTemp/#rsReporte.DEid#_#Arguments.RCNid#.jpg')>
        <cfset rutaDirTmp = expandPath('/imgQRTemp')>
        <cfif !directoryExists(rutaDirTmp)>
            <cfset directoryCreate(rutaDirTmp)>
        </cfif>
        <cfset ArrayAppend(arrImgQR,rutaTmp)>

        <cfset unQRImg = ImageNew(contenidoQR)>
        <cfset Imagewrite(unQRImg,rutaTmp)>

        <cfif !fileexists(rutaTmp)>
            <cfloop condition="true">
                <cfif fileexists(rutaTmp)>
                <cf_dump var="YA EXISTE: #unIt#"><br />
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>

        <!--- <CFFILE ACTION="WRITE" FILE="#rutaTmp#" OUTPUT="#contenidoQR#"> --->

        <cfset noCertificado = sXMLT['cfdi:Comprobante']['cfdi:Complemento']['XmlChildren'][2].XmlAttributes.NoCertificadoSAT>
        <cfset fechaTimbrado = sXMLT['cfdi:Comprobante']['cfdi:Complemento']['XmlChildren'][2].XmlAttributes.FechaTimbrado>
        <cfset selloCFD = sXMLT['cfdi:Comprobante']['cfdi:Complemento']['XmlChildren'][2].XmlAttributes.SelloCFD>

        <cfset copath = expandPath('/rh/Componentes/GeneraCFDIs/cadenaoriginal_3_3.xslt')>
        <cfset co = XmlTransform(xml32, copath)>
        <cfset xmlParams = Structnew()>
        <cfset xmlParams["FolioFiscal"] = lVarTimbre>
        <cfset xmlParams['NumeroCertificado'] = noCertificado>
        <cfset xmlParams['FechaCertificado'] = fechaTimbrado eq '' ? 'Sin Fecha' : replace(fechaTimbrado,'T',' ')>
        <cfset xmlParams['RegimenDesc'] = rsReporte.regimenDesc>
        <cfset xmlParams['CentroFuncional'] = rsCF.CentroFuncional>
        <cfset xmlParams['CodigoNomina'] = rsReporte.CodigoNomina>
        <cfset xmlParams['FechaEmision'] = replace(fechaTimbrado,'T',' ')>
        <cfset xmlParams['ImgQR']       = "file:///#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/imgQR/#Trim(rsReporte.DEid)#_#Trim(Arguments.RCNid)#.jpg">
        <cfset xmlParams['Puesto']      = rsPuesto.RHPdescpuesto>
        <cfset xmlParams['Direccion']   = wrap(rsReporte.DEdireccion,45,true)>
        <cfset xmlParams['selloSAT']    = wrap(lVarQRFE,120,true)>
        <cfset xmlParams['selloCFDI']   = wrap(selloCFD,120,true)>
        <cfset xmlParams['cadenaSAT']   = wrap(co,120,true)>
        <cfset xmlParams['valCero']     = "0.00">
        <!--- Modificación para el logo de Nómina--->
        <cfset path = "#ruta#/">
        <cfset logoEmpresa = getLogoEmpresa()>
        <cfset logoImage = ImageNew(logoEmpresa.ELogo)>
        <cfif NOT FileExists(path&"logoEmpresa.png")>
            <cfimage source="#logoImage#" action="write" destination="#path#logoEmpresa.png" overwrite="yes">
        </cfif>

        <cfset xmlParams['imgEmpresa'] = "file:///#path#logoEmpresa.png">

        <cfset miHTML = XmlTransform(miXML, miXSLT,xmlParams)>

        <cfoutput>
            <cfif !directoryExists('#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/PDF/')>
                <cfset directoryCreate('#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/PDF/')>
            </cfif>

            <!--- Al poner filename guarda el archivo en la ruta especificada con el nombre dado. --->  
            <cfdocument  format="PDF" filename="#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/PDF/#miNombre#" mimetype="image/png" overwrite="true" localurl="false">
                <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 5.0 Transitional//EN">
                    #miHTML#
            </cfdocument>
        </cfoutput>

        <cfquery name="rsEmp" datasource="#session.dsn#">
            select DEidentificacion + '_'+ DEnombre + ' ' + DEapellido1 +' ' + DEapellido2 as Emp
            from DatosEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>

        <cfset archivoXmlT="#rsEmp.Emp#_#rsNomina.RCDescripcion#T.xml">

        <cfif Arguments.enviaCorreo>
            <cfset correoXEmpleado(rsReporte.DEid,miNombre,archivoXmlT,trim(rsReporte.CODIGONOMINA),vsPath_A)>
        </cfif>

        <cfreturn #miHTML#>
    </cfif>

</cffunction>

<!--- OPARRALES 2018-10-31 Modificacion para enviar correo con archivos y quede registrada la accion en BD NOMINA --->
<cffunction name="correoXEmpleado" access="private" returntype="struct">
    <cfargument name="DEid"         type="numeric"  required="true">
    <cfargument name="NamePDF"      type="string"   required="true">
    <cfargument name="NameXML"      type="string"   required="true">
    <cfargument name="CodNomina"    type="string"   required="true">
    <cfargument name="vsPath_A" type="string"   required="true">

    <cfset strResult = Structnew()>
    <cfset strResult["Status"] = "OK">
    <cfset strResult["ErrorDesc"] = "">

     <cf_foldersFacturacion name = "ruta">

    <cfquery name="rsMailEmp" datasource="#session.dsn#">
        select
            coalesce(DEemail,'') as DEemail,
            concat(DEidentificacion,' - ',DEnombre,' ',DEapellido1,' ',DEapellido2) as Nombre
        from
            DatosEmpleado
        where
            DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>

    <cfif rsMailEmp.RecordCount gt 0 and Trim(rsMailEmp.DEemail) eq ''>
        <cfset strResult["Status"] = "Error">
        <cfset strResult["ErrorDesc"] = "El empleado #rsMailEmp.Nombre# no tiene un correo asignado">
        <cfreturn strResult>
    </cfif>

    <cfquery name="rsCorreoApp" datasource="#session.dsn#">
        select valor
        from PGlobal
        where
            parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="correo.cuenta">
    </cfquery>

    <cfset correoSalida = 'facturacion@aph.mx'>

    <cfif rsCorreoApp.RecordCount gt 0 and Trim(rsCorreoApp.VALOR) neq ''>
        <cfset correoSalida = Trim(rsCorreoApp.VALOR)>
    </cfif>

    <cftransaction>
        <!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001/xmlT --->
        <cfquery datasource="#session.dsn#">
            insert INTO SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
            values (<cfqueryparam cfsqltype="cf_sql_varchar" value='#correoSalida#'>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#rsMailEmp.DEemail#'>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="Recibo de Nómina  #Arguments.CodNomina#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="Se envio Recibo de Nómina #Arguments.CodNomina#">, 1)
            <cf_dbidentity1 datasource="#session.dsn#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.dsn#" name="msg" returnvariable="msg_id">

        <!--- Ejemplo Nomina2019/Nomina-DEMO/2019-01-001/PDF --->
        <cfset rutaDirTmpPDF = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/PDF'>

        <cfset SMTPmime1 = "application/pdf">
        <cfquery datasource="#session.dsn#">
            insert into SMTPAttachment(
                    SMTPid
                    , SMTPmime
                    , SMTPlocalURL
                    , SMTPnombre
                ) values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#msg_id#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMTPmime1#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rutaDirTmpPDF#\#Arguments.NamePDF#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NamePDF#">
                )
        </cfquery>

        <cfset rutaDirTmpXML = '#ruta#/Nomina#Year(Now())#/#Trim(rsCP.CPcodigo)#/xmlT'>
        <cfset SMTPmime2 = "application/xml">
        <cfquery datasource="#session.dsn#" name="msg">
            insert into SMTPAttachment(
                    SMTPid
                    , SMTPmime
                    , SMTPlocalURL
                    , SMTPnombre
                ) values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#msg_id#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMTPmime2#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rutaDirTmpXML#\#Arguments.NameXML#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NameXML#">
                )
        </cfquery>
    </cftransaction>
    <cfreturn strResult>
</cffunction>

<cffunction  name="checkDir">
    <cfargument  name="path" required="true">
    <cfif !DirectoryExists("#arguments.path#") >
        <cfset DirectoryCreate("#arguments.path#")>
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