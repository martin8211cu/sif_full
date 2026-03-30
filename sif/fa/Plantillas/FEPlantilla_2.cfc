<!---
Componenete Desarrollado por Team Soin 
Fecha de ultima modificacion: 23/05/2022
--->
<!--- Layout para factura 1--->

<cfcomponent extends = "FEDatosBase">
    <cffunction name="init" >
        <cfargument name="DSN"            type="string">
        <cfargument name="Ecodigo"        type="string">
        <cfargument name="Ecodigosdc"     type="string">

        <cfset this.DSN =            arguments.DSN>
        <cfset this.Ecodigo =        arguments.Ecodigo>
        <cfset this.Ecodigosdc =     arguments.Ecodigosdc>

        <cfreturn this>
    </cffunction>

    <cffunction  name="generarDocumento" access="public" output="false">
        <cfargument name="DSN" 	      type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo"    type="string" default="#Session.Ecodigo#" >
		<cfargument name="Ecodigosdc" type="string" default="#Session.Ecodigosdc#" >
        <cfargument  name="OImpresionID" type = "numeric" >

        <!--- Validacion y creacion de carpetar para almacenar Facturas --->
         <cf_foldersFacturacion name = "ruta">
         
        <cfset pathDef = "#ruta#">
        <cfset currentPath = #GetDirectoryFromPath(GetCurrentTemplatePath())#>
        <cfset datosFactura = getDatosFactura(arguments.OImpresionID)>
        <cfset datosImpuesto = getDatosImpuestos(arguments.OImpresionID)>
        <cfset dirFiscEmpresa = getDirFiscE()>
        <cfset datosregimenReceptor = getRegFiscalReceptor(arguments.OImpresionID)>
        <cfset datosEmpresa = getDatosEmpresa(dirFiscEmpresa.DirecFisc)>
        <cfset dirFiscCliente = getDirFiscCliente(datosFactura.SNid)>
        <cfset datosCliente = getDomFiscCliente(datosFactura.id_direccion)>
        <cfset documentosRelacionados = getDocumentosRelacionados(datosFactura.timbre)>
        <cfset logoEmpresa = getLogoEmpresa()>
        <cfset tipoComprobante = getTipoComprobante(datosFactura.CCTcodigo)>
        <cfset qrCode = getQRCode(arguments.OImpresionID)>
        <cfset qrImagePath = "file:///#ruta#/ImgQR/#datosFactura.fac#.jpg">
        <cfset logoImage = ImageNew(logoEmpresa.ELogo)>
        <cfimage source="#logoImage#" action="write" destination="logos/logo#logoEmpresa.Ecodigo#.png" 
            overwrite="yes">
        <!---<cfset xmlPath = "C:/Enviar/FE_1_FC_20190212111954T.xml">--->
        <cfset xmlPath = "#ruta#/#datosFactura.fac#T.xml">
        <CFFILE ACTION="read" FILE="#xmlPath#" variable="fXML" charset="utf-8">
        <cfxml variable="xmlData">
            <cfoutput>#fXML#</cfoutput>
        </cfxml>
         <!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
        <cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
        select Pvalor 
        from Parametros
        where Pcodigo = '17200'
            and Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfset version = "#rsPCodigoOBJImp.Pvalor#">
        <!-- Fin Querys AFGM-SPR -->
        <cfquery name="rsRelacionados" datasource="#session.dsn#">
            select  a.TipoRelacion, b.CSATdescripcion as CSATdescripcion
            from FA_CFDI_Relacionado a
			inner join CSATTipoRel b
			on a.TipoRelacion = b.CSATcodigo
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.OImpresionID#">
        </cfquery>
        <cfset tipoRelacion = #rsRelacionados.TipoRelacion# & "-" & #rsRelacionados.CSATdescripcion#>

        <!--- LLENAR DATOS DE LA FACTURA FALTANTES --->
        <cfscript>
            root = XmlSearch(xmlData, "//cfdi:Comprobante");
            //Colocar datos del emisor
            emisor = XmlSearch(xmlData, "//cfdi:Comprobante/cfdi:Emisor");
            emisor[1].XmlAttributes["dirFical"] = dirFiscEmpresa.DirecFisc;
            if(dirFiscEmpresa.DirecFisc EQ 1){
                emisor[1].XmlAttributes["calle"] = datosEmpresa.Calle;
                emisor[1].XmlAttributes["noExterior"] = datosEmpresa.NumExt;
                emisor[1].XmlAttributes["noInterior"] = datosEmpresa.NumInt;
                emisor[1].XmlAttributes["colonia"] = datosEmpresa.Colonia;
                emisor[1].XmlAttributes["delegacion"] = datosEmpresa.Delegacion;
                emisor[1].XmlAttributes["localidad"] = datosEmpresa.Localidad;
            }
            else{
                emisor[1].XmlAttributes["direccion1"] = datosEmpresa.direccion1;
                emisor[1].XmlAttributes["direccion2"] = datosEmpresa.direccion2;
                emisor[1].XmlAttributes["estado"] = UCase(datosEmpresa.Estado);
            }
            emisor[1].XmlAttributes["codigoPostal"] = datosEmpresa.codPostal;
            emisor[1].XmlAttributes["nomRegFiscal"] = datosFactura.nombre_RegFiscal;
            //Colocar datos del receptor
            receptor = XmlSearch(xmlData, "//cfdi:Comprobante/cfdi:Receptor");
            receptor[1].XmlAttributes["dirFical"] = dirFiscCliente.DirecFisc;
            receptor[1].XmlAttributes["RegimenFiscal"] = datosregimenReceptor.CSATdescripcion;
            if(dirFiscCliente.DirecFisc EQ 1){
                receptor[1].XmlAttributes["calle"] = datosCliente.Calle;
                receptor[1].XmlAttributes["noExterior"] = datosCliente.NumExt;
                receptor[1].XmlAttributes["noInterior"] = datosCliente.NumInt;
                receptor[1].XmlAttributes["colonia"] = datosCliente.Colonia;
                receptor[1].XmlAttributes["delegacion"] = datosCliente.Delegacion;
                receptor[1].XmlAttributes["codigoPostal"] = datosCliente.codPostal;
                receptor[1].XmlAttributes["pais"] = datosCliente.Pais;
                receptor[1].XmlAttributes["localidad"] = datosCliente.Localidad;
            }
            else{
                receptor[1].XmlAttributes["snDireccion"] = datosFactura.sndireccion;
                receptor[1].XmlAttributes["snDireccion2"] = datosFactura.sndireccion2;
                receptor[1].XmlAttributes["dir"] = datosFactura.dir;
            }
            //Informacion adicional de la factura
            if(REFindNoCase("^FC", trim(datosFactura.serie)) GT 0){
                root[1].XmlAttributes["tipoDocumentoCodigo"] = "FC";
            }
            else if(REFindNoCase("^NC", trim(datosFactura.serie)) GT 0){
                root[1].XmlAttributes["tipoDocumentoCodigo"] = "NC";
            }
            else{
                root[1].XmlAttributes["tipoDocumentoCodigo"] = "UNKNOW";
            }
            //Documentos relacionados con las Notas de Credito
            /*if(REFindNoCase("^NC", trim(datosFactura.serie)) GT 0){
                docRelacionados = XmlElemNew(root, "documentosRelacionados")
            }*/
            //Otros datos
            complemento = XmlSearch(xmlData, "//cfdi:Complemento");
            selloDigital = root[1].XmlAttributes.sello;
            cadenaOriginal = datosFactura.cadenaSAT;
            //selloSAT = complemento[1].XmlChildren[1].XmlAttributes.selloSAT;
            //Montos
            total =  numberformat(root[1].XmlAttributes.Total, "9.00");
            montosFunction = new sif.Componentes.montoEnLetras();
            MontoLetras = invoke(montosFunction, "fnMontoEnLetras", {Monto = total});
            root[1].XmlAttributes["montoEnLetras"] = MontoLetras & ' ' &  datosFactura.mnombre;
            Descuento = 0;
            for (row in datosFactura) {
                Descuento = Descuento + row.OIDdescuento;
            }
            root[1].XmlAttributes["descuentosFac"] = Descuento;
            root[1].XmlAttributes["observaciones"] = datosFactura.observaciones;
            root[1].XmlAttributes["iepsFac"] = datosFactura.OIieps;
            root[1].XmlAttributes["TotalIVA"] = datosFactura.OIimpuesto;
            root[1].XmlAttributes["retencion"] = datosFactura.OIMRetencion;
            root[1].XmlAttributes["cuentaTipoPagoFac"] = Trim(datosFactura.Cta_tipopago);
            root[1].XmlAttributes["cuentaTipoPagoFacDesc"] = Trim(getUsoCFDI(datosFactura.Cta_tipopago));
            if(version eq '4.0'){
                if(isdefined("rsRelacionados.CSATdescripcion") and rsRelacionados.CSATdescripcion neq ""){
                    CfdiRelacionados = XmlSearch(xmlData, "//cfdi:Comprobante/cfdi:CfdiRelacionados");
                    CfdiRelacionados[1].XmlAttributes["TipoRelacion"] = tipoRelacion;
                }
            }
        </cfscript>

        <cfset xmlParams = Structnew()>
        <cfset xmlParams["imgEmpresa"] = "file:///#currentPath#logos/logo#logoEmpresa.Ecodigo#.png">
        <cfset xmlParams["imgQR"] = #qrImagePath#>
        <cfset xmlParams["SNidentificacion2"] = #datosFactura.SNidentificacion2#>
        <cfset xmlParams["NumOrdenCompra"] = #datosFactura.NumOrdenCompra#>

		<!---Control de versiones si es 3.3 o 4.0--->
        <cfif version eq '3.3'>
			<CFFILE ACTION="read" FILE="#expandPath('/sif/fa/Plantillas/FEPlantilla_2.xslt')#" variable="pXSLT">
        <cfelseif version eq '4.0'>
            <CFFILE ACTION="read" FILE="#expandPath('/sif/fa/Plantillas/FEPlantilla_v4_2.xslt')#" variable="pXSLT">
        </cfif>
        <cfset htmlObj = XmlTransform(xmlData, pXSLT, xmlParams)>
        
        <cfdocument  format="PDF" filename="#pathDef#/#datosFactura.fac#.pdf" mimetype="image/png" 
            overwrite="true" localUrl="yes">
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 5.0 Transitional//EN">
				<cfoutput>
                    #htmlObj#
                    <br/>
                    <!--- SELLOS DIGITALES--->
                    <strong>SELLO DIGITAL</strong>
                    <table>
                        <cfset renglon = 0>
                        <cfset renglon_ini = 1>
                        <cfloop condition="renglon LE #LEN(selloDigital)#">
                        <cfset renglon = #renglon#+100>
                        <tr>                    
                            <td><strong style="font-family: 'Courier New'; font-size:8px;">#Mid(selloDigital,renglon_ini,100)#</strong></td>
                        </tr>
                        <cfset renglon_ini = #renglon#+1>
                        </cfloop>
                    </table>
                    <strong>SELLO DEL SAT</strong>
                    <table>
                        <cfset renglon = 0>
                        <cfset renglon_ini = 1>
                        <cfloop condition="renglon LE #LEN(datosFactura.selloSAT)#">
                        <cfset renglon = #renglon#+100>
                        <tr>                    
                            <td><strong style="font-family: 'Courier New'; font-size:8px;">#Mid(datosFactura.selloSAT,renglon_ini,100)#</strong></td>
                        </tr>
                        <cfset renglon_ini = #renglon#+1>
                        </cfloop>
                    </table>
                    <strong>CADENA ORIGINAL</strong>
                    <table>
                        <cfset renglon = 0>
                        <cfset renglon_ini = 1>
                        <cfloop condition="renglon LE #LEN(cadenaOriginal)#">
                        <cfset renglon = #renglon#+100>
                        <tr>                    
                            <td><strong style="font-family: 'Courier New'; font-size:8px;">#Mid(cadenaOriginal,renglon_ini,100)#</strong></td>
                        </tr>
                        <cfset renglon_ini = #renglon#+1>
                        </cfloop>
                    </table>
                    <!--- PIE DE PAGINA --->
                    <cfif left(datosFactura.serie, 2) EQ 'FC'>
                        <cfset leyenda="Deb(emos) y pagar&eacute;(emos) incondicionalmente a favor de #Trim(rsDatosEmpresa.Enombre)#. La cantidad que ampara la siguiente factura en el domicilio se&ntilde;alado"> 
                        <cfset leyenda1=" en los plazos y condiciones estipuladas en la misma. En caso contrario esta factura causara  __% de inter&eacute;s moratorio a su vencimiento.">                   
                        <cfset leyenda2=" ESTE DOCUMENTO ES UNA REPRESENTACI&Oacute;N IMPRESA DE UN CFDI "> 
                        <cfdocumentitem type="footer">
                            <table style="border:outset"  cellspacing="0" cellpadding="0" class="areaFiltro" width="100%">              
                                <tr>
                                    <td align="left"><font style="font-size:22px">#leyenda#</td>                           
                                </tr>    
                                <tr>
                                    <td align="left"><font style="font-size:22px">#leyenda1#</td>                            
                                </tr>          
                                <tr>
                                    <td align="left"><font style="font-size:22px">#leyenda2# Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</td>
                                </tr>            
                            </table>
                        </cfdocumentitem>
                    <cfelseif left(datosFactura.serie, 2) EQ 'NC'>
                        <cfset leyenda=" ESTE DOCUMENTO ES UNA REPRESENTACION IMPRESA DE UN CFDI "> 
                        <cfdocumentitem type="footer">
                            <p width="100%" style = "text-align:center">#leyenda# Pagina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</p>
                        </cfdocumentitem>
                    </cfif>
                </cfoutput>
		</cfdocument>
    </cffunction>

</cfcomponent>