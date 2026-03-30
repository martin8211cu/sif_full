<!---
Componente desarrollado para brindar soporte a GeneraCFDIs
Escrito por: Giancarlo Benítez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (YYYY-MM-DD) Descripcion
--->

<cfcomponent>

    <cffunction name="TimbraXML" returntype="string">
    	<cfargument name="xml32" 					type="string" 	required="yes">
		<cfargument name="FolioDoc"				    type="numeric"	required="yes">
        <cfargument name="DEid" 					type="numeric" 	required="no" default="-1">
        <cfargument name="RCNid" 					type="numeric" 	required="no" default="-1">
        <cfargument name="DLlinea" 					type="numeric" 	required="no" default="-1">
        <cfargument name="OImpresionID" 			type="numeric" 	required="no" default="-1">
		<cfargument name="ReciboPago"				type="string"	required="no" default="-1">
		<cfargument name="Retimbrar"				type="boolean"	required="no" default="false">
        <cfargument name="destino"				    type="string"	required="no" default="">
        <cfargument name="destinoQR"				    type="string"	required="no" default="">

         <cf_foldersFacturacion name = "ruta">

        
        <cfset p = createObject("component", "sif.Componentes.Parametros")>
        <cfset useFactus = p.Get(Pcodigo = "4410")>

         <!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
        <cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
        select Pvalor 
        from Parametros
        where Pcodigo = '17200'
        and Ecodigo = #Session.Ecodigo#
        </cfquery>
        <cfset value = "#rsPCodigoOBJImp.Pvalor#">
        <!-- Fin Querys AFGM-SPR -->

        <cfquery name="rsEmpresa" datasource="#session.dsn#">
                    select  a.Eidentificacion 
                    from Empresa a
                        INNER JOIN Direcciones b
                            on a.id_direccion = b.id_direccion
                    where a.Ecodigo = #session.Ecodigosdc#
                </cfquery>
        
        <cfset rfcEmisor = rsEmpresa.Eidentificacion>
      
        

         <!--- INICIA - path fijo--->
        <cfquery name="getDatosCert" datasource="#session.dsn#">
            select archivoKey from RH_CFDI_Certificados where Ecodigo=#session.Ecodigo#
        </cfquery>
        <cfset vsPath = #getDatosCert.archivoKey#>
        <cfset vsPath_A = left(vsPath,2)>
        <!--- FIN - path fijo--->


        <cfif useFactus eq "FACTUS">
            <cfset _url = p.Get(Pcodigo = "4411")>
            <cfset _appkey = p.Get(Pcodigo = "4412")>
            
            <cfhttp url="#_url#/cfdiTimbre/cfdi/xml" method="post" result="httpResp" timeout="3600">
                <!--- <cfhttpparam type="header" name="Content-Type" value="application/json" /> --->
                <cfhttpparam type="header" name="appkey" value="#_appkey#" />
                <cfhttpparam type="Formfield" name="xml" value="#arguments.xml32#"/>
            </cfhttp>
            
            <cftry>
                <cfset _response = deserializeJSON(httpResp.Filecontent ) />
            <cfcatch type="any">
               <cfset _response.message = httpResp.Filecontent>
            </cfcatch>
            </cftry>

            <cfif Find("200",httpResp.StatusCode) and _response.ok>
                <cfset xmlTimbrado = _response.xml>
            <cfelse>
                <cfthrow message="No se ha creado el XML #_response.message#">
            </cfif>
        <cfelse>
            <!--- INICIA - Obtencion de parametros para Timbrado con PAC --->
            <cfquery name="getUrl" datasource="#session.dsn#">
                select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 440
            </cfquery>
            <cfquery name="getToken" datasource="#session.dsn#">
                select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 445
            </cfquery>
            <cfquery name="getUsr" datasource="#session.dsn#">
                select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 443
            </cfquery>
            <cfquery name="getPwd" datasource="#session.dsn#">
                select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 444
            </cfquery>
            <cfquery name="getCta" datasource="#session.dsn#">
                select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 442
            </cfquery>
            <!--- FIN - Obtencion de parametros para Timbrado con PAC --->
    
           
            <!--- INICIA - Credenciales para autenticacion con el PAC--->
            <cfset LvarToken="#getToken.Pvalor#" >
            <cfset LvarUsuario="#getUsr.Pvalor#" >
            <cfset LvarPassword="#getPwd.Pvalor#" >
            <cfset LvarCuenta="#getCta.Pvalor#" >
            <cfset LvarUrl = "#getUrl.Pvalor#">

            

<!---
           <cfdump  var="#LvarToken#">
           <cfdump  var="#LvarUsuario#">
           <cfdump  var="#LvarPassword#">
           <cfdump  var="#LvarCuenta#">
           <cfdump  var="#LvarUrl#">
           
           
           <cfabort>
           --->
            <!--- FIN - Credenciales para autenticacion con el PAC--->
            <cfif value eq '3.3'>
                <!--- INICIA - Realiza la conexion al PAC para el timbrado --->
                <cfinvoke webservice="#LvarUrl#" method="get" returnvariable="xmlTimbrado">
                    <cfinvokeargument name="cad" value = #xml32#/>
                    <cfinvokeargument name="tk" value = #Lvartoken#/>
                    <cfinvokeargument name="user" value = #LvarUsuario#/>
                    <cfinvokeargument name="pass" value = #LvarPassword#/>
                    <cfinvokeargument name="cuenta" value = #LvarCuenta#/>
                </cfinvoke>
                <cfset match = REMatch("<ERROR codError='\d+'>.*?<\/ERROR>",xmlTimbrado)>
                <cfif ArrayIsEmpty(match) eq false>
                    <cfset match2 = REMatch("codError='\d+'",xmlTimbrado)>
                    <cfthrow message="No se ha creado el XML [#match2[1]#] #match[1]#">
                </cfif>
            <cfelseif value eq '4.0'>
            
                <cfset xml32 = toBase64(#xml32#)>
                
                
                
                <cfscript>
                    prueba ={   
                        
                             "credentials" = {
                                "usuario" = "#LvarUsuario#", 
                                "token" = "#LvarToken#",
                                "password" = "#LvarPassword#",
                                "cuenta" = "#LvarCuenta#"
                                },
                                "issuer" = {
                                    "rfc" = "#rfcEmisor#",
                                    "business" = ""
                                },
                                "document" = {
                                    "format" = "xml",
                                    "type" = "cfdiv4",
                                    "operation" = "stamping",
                                    "content" = "#xml32#"
                                }                        
                            };
                   
                </cfscript>
             
                
                
            <!---Mandamos el JSON con todos los datos requeridos --->
           
                <cfset serializedStr = serializeJSON(prueba)>
                
                <cfhttp url="#LvarUrl#" method="post" result="xmlTimbradoJ">
                <cfhttpparam type="header" name="Content-Type" value="application/json"/>
                <cfhttpparam type="body" value="#serializedStr#">
                </cfhttp>
                
                <cfset preXmlTimbrado = "">
                <cftry>
                <!---Cacha los posibles errores--->
                <cfset preXmlTimbrado =  deserializeJSON(xmlTimbradoJ.filecontent) >
                 <cfcatch type="any">
                    <cfthrow message="#xmlTimbradoJ.errordetail#"> <cfabort>
                </cfcatch>
                </cftry>
                <cfif preXmlTimbrado.result neq 'VALID'>
                    <cfset sub = preXmlTimbrado.error_details >
                    <cfset sub = serializeJSON(preXmlTimbrado.error_details) >
                    <cfset falla = fallaFactura(Arguments.OImpresionID)>
                    <cfthrow message="#sub#"> <cfabort>
                </cfif>
                

                
            <cfset xmlTimbrado64 = preXmlTimbrado.content>
            <!---Pasamos de base 64 a formato String los valores --->
            <cfset xmlTimbrado = ToString( ToBinary( xmlTimbrado64 ) ) />
           

          
           
           
            
             <!---FIN - Realiza la conexion al PAC para el timbrado --->
            <!--- INICIA - Deteccion de error del PAC--->
            <cfset match = REMatch("<ERROR codError='\d+'>.*?<\/ERROR>",xmlTimbradoJ.statuscode)>
            <cfif ArrayIsEmpty(match) eq false>
                <cfset match2 = REMatch("codError='\d+'",xmlTimbradoJ.errordetail)>
                <cfthrow message="No se ha creado el XML [#match2[1]#] #match[1]#">
            </cfif>
            </cfif>
            
            

           
        </cfif>


        <!--- FIN - Deteccion de error del PAC--->
		<!--- OPARRALES Variable por default --->
		<cfset archivoXmlT = ''>
        <!--- INICIA - Ruta XML si es Factura--->
        <cfif Arguments.OImpresionID GT 0>
            <cfquery name="SerieFolioXml" datasource="#session.dsn#">
                select Serie, Folio from FA_CFDI_Emitido where Ecodigo=#session.Ecodigo# and OImpresionID = #Arguments.OImpresionID#
                and Folio=#arguments.FolioDoc#
            </cfquery>
            <cfset archivoXmlT = "#ruta#/FE_#session.Ecodigo#_#SerieFolioXml.Serie##SerieFolioXml.Folio#T.xml">
            <cfset Serie = SerieFolioXml.Serie>
            <cfset Folio = SerieFolioXml.Folio>
            <cfif MID(Serie,1,2) EQ 'FC'>
                <cfset archivoXmlT="#ruta#/FE_#session.Ecodigo#_#Serie##Folio#T.xml">
            <cfelseif MID(Serie,1,2) EQ 'NC'>
                <cfset archivoXmlT="#ruta#/NC_#session.Ecodigo#_#Serie##Folio#T.xml">
            <cfelse>
                <cfset archivoXmlT="#ruta#/#left(Serie,2)#_#session.Ecodigo#_#Serie##TRIM(Folio)#T.xml">
            </cfif>
        </cfif>
        <!--- FIN - Ruta XML si es Factura--->

        <!--- INICIA - Ruta XML si es Recibo de Pago--->
        <cfif Arguments.ReciboPago NEQ -1>
            <cfquery name="SerieFolioXml" datasource="#session.dsn#">
                select Serie, Folio from FA_CFDI_Emitido
                where Ecodigo=#session.Ecodigo# and OImpresionID = 0
                and Folio=#arguments.FolioDoc# and DocPago ='#Arguments.ReciboPago#'
            </cfquery>
            <cfset Serie=SerieFolioXml.Serie>
            <cfset Folio=SerieFolioXml.Folio>
            <cfset archivoXmlT="#ruta#/#Serie##Folio#_#TRIM(Arguments.ReciboPago)#T.xml">
        </cfif>
        <!--- FIN - Ruta XML si es Recibo de Pago--->

        <!--- INICIA - Ruta XML si es Recibo de Nomina --->
        <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
            <cfquery name="rsEmp" datasource="#session.dsn#">
                select DEidentificacion + '_'+ DEnombre + ' ' + DEapellido1 +' ' + DEapellido2 as Emp
                from DatosEmpleado
                where DEid = #Arguments.DEid#
            </cfquery>
            <cfquery name="rsNomina" datasource="#session.dsn#">
                select RCDescripcion from HRCalculoNomina
                where RCNid=#Arguments.RCNid#
            </cfquery>

			<cfquery name="rsCP" datasource="#session.dsn#">
				select CPcodigo, CPfpago
			    from
					CalendarioPagos cp
			    inner join TiposNomina tn
			    	on cp.Ecodigo = tn.Ecodigo
					and cp.Tcodigo = tn.Tcodigo
			    where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>
            <cfset rsEmp.Emp = replace("#rsEmp.Emp#","/","-","All")>
            <cfset rsNomina.RCDescripcion = replace("#rsNomina.RCDescripcion#","/","-","All")>
            <cfset archivoXmlT="#ruta#/Nomina#Year(rsCP.CPfpago)#/#Trim(rsCP.CPcodigo)#/xmlT/#rsEmp.Emp#_#rsNomina.RCDescripcion#T.xml">

        </cfif>
        <!--- FIN - Ruta XML si es Recibo de Nomina --->

        <!--- INICIA - Ruta XML si es Recibo de Liquidacion --->
        <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
            <cfquery name="rsBaja" datasource="#session.dsn#">
                select
					concat(LTRIM(RTRIM(de.DEidentificacion)),'_',LTRIM(RTRIM(de.DEnombre)),'_',LTRIM(RTRIM(de.DEapellido1)),'_',LTRIM(RTRIM(de.DEapellido1))) as Emp,
	                dateadd(dd, -1, c.DLfvigencia) as FechaBaja,
	                g.RHTdesc MotivoBaja
                from RHLiquidacionPersonal a
                inner join DatosEmpleado de
					on a.DEid = de.DEid
                inner join DLaboralesEmpleado c
					on a.DLlinea = c.DLlinea
                inner join RHTipoAccion g
					on c.RHTid = g.RHTid
                where
					a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
            </cfquery>
            <cfset archivoXmlT="#ruta#/Liquidacion-Finiquito#Year(Now())#/#rsBaja.Emp#/#rsBaja.Emp#_#rsBaja.MotivoBaja##DateFormat(rsBaja.FechaBaja,'yyyymmdd')#T.xml">
        </cfif>
        <!--- FIN - Ruta XML si es Recibo de Liquidacion 
        <cfif value eq '3.3'>   --->
        <!---ERBG Cambio para la Ñ charset="utf-8"--->
<cftry>
<cfif isDefined('Arguments.destino') and len(Arguments.destino) gt 0>
    <cfset archivoXmlT = Arguments.destino>
</cfif>

 <CFFILE ACTION="WRITE" FILE="#archivoXmlT#" OUTPUT="#ToString(xmlTimbrado)#" charset="utf-8">
<cfcatch>
<cf_dump var='#cfcatch#'>
</cfcatch>
</cftry>

           
                    <!--- parseando el xml --->
            <cfset MyXMLDoc = xmlParse(archivoXmlT)>
            
            <!--- cargando variables --->
            

            <cfset lVarXmlTimbrado = replace("#xmlTimbrado#","""","\""","All")>
            <cfset lVarXmlTimbrado = replace("#xmlTimbrado#","'","''","All")>
            
        <!---<cfelseif value eq '4.0'>
            <CFFILE ACTION="WRITE" FILE="#archivoXmlT#" OUTPUT="#ToString(xmlTimbrado.filecontent)#" charset="utf-8">
            
          
                    <!--- parseando el xml --->
            <cfset MyXMLDoc = xmlParse(archivoXmlT)>
            <!--- cargando variables --->
            

            <cfset lVarXmlTimbrado = replace("#xmlTimbrado.filecontent#","""","\""","All")>
            <cfset lVarXmlTimbrado = replace("#xmlTimbrado.filecontent#","'","''","All")>
      </cfif>--->
        


        <!--- INICIA - Actualizacion de Timbrado--->
		<cftry>
			<cfset lVarTotal=MyXMLDoc.Comprobante.XmlAttributes.total>
			<cfset lVarRFCemisor=MyXMLDoc.Comprobante.Emisor.XmlAttributes.rfc>
			<cfset lVarRFCreceptor=MyXMLDoc.Comprobante.Receptor.XmlAttributes.rfc>
			<cfset lVarTimbre = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
			<cfset lVarCertificadoSAT = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.noCertificadoSAT>
			<cfset lVarSelloCFD = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.selloCFD>
			<cfset lVarSelloSAT = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.selloSAT>
			<cfset lVarFechaTimbrado = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.FechaTimbrado>
			<cfset lVarVersion = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.version>
			<cfset lVarCadenaSAT = "||#lVarVersion#|#lVarTimbre#|#lVarFechaTimbrado#|#lVarSelloCFD#|#lVarCertificadoSAT#||">
			<cfset lvarEstado = 1>
            

            <!--- INICIA - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Recibo de Nomina --->
			<cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
				<cfquery name="updReciboCFDI" datasource="#session.dsn#">
					UPDATE RH_CFDI_RecibosNomina
					SET xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
					    timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
					    certificadoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCertificadoSAT#">,
					    cadenaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCadenaSAT#">,
					    selloSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloSAT#">,
					    fechaTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarFechaTimbrado#">,
                        <cfif Arguments.Retimbrar>
                            stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="3">
                        <cfelse>
                            stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">
                        </cfif>
					    <cfif IsDefined('archivoXml')>
					            ,NombreXML = <cfqueryparam cfsqltype="cf_sql_varchar" value="#archivoXml#">
					    </cfif>
				    WHERE Ecodigo = #session.Ecodigo#
				    AND DEid = #Arguments.DEid#
                    AND RCNid = #Arguments.RCNid#
                    and stsTimbre = 0
				</cfquery>
				<cfquery name="rsQRFE" datasource="#session.dsn#">
					select  substring(SelloDigital,(len(SelloDigital)-7), 8) qrfe
					from RH_CFDI_RecibosNomina
					WHERE Ecodigo = #session.Ecodigo#
				    AND DEid = #Arguments.DEid#
				    AND RCNid = #Arguments.RCNid#
				</cfquery>
				<cfquery name="rsCP" datasource="#session.dsn#">
					select CPcodigo, CPfpago
				    from
						CalendarioPagos cp
				    inner join TiposNomina tn
				    	on cp.Ecodigo = tn.Ecodigo
						and cp.Tcodigo = tn.Tcodigo
				    where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				</cfquery>
			    <cfset lVarQRFE= rsQRFE.qrfe>

				<!--- OPARRALES 2018-07-30 Se complementa para que genere Imagen QR INICIO--->
				<cfset MyXMLDoc = xmlParse(lVarXmlTimbrado)>
                <cfset imgQR = "#ruta#/Nomina#Year(rsCP.CPfpago)#/#Trim(rsCP.CPcodigo)#/imgQR/#DEid#_#RCNid#.jpg">
				<cfset lVarTotal = #LSNumberformat(lVarTotal,'0000000000.000000')#>
				<cfset cadenaQR = "https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?&id=#lVarTimbre#&re=#lVarRFCemisor#&rr=#lVarRFCreceptor#&tt=#lVarTotal#&fe=#lVarQRFE#">
				<!--- para instanciar la Clase TestQRCode --->
				<cfobject type="java" class="generacsd.TestQRCode" name="myTestQRCode">
				<!--- generar codigo bidimencional --->
				<cfset image = myTestQRCode.generateQR(imgQR,cadenaQR,300,300)>
				<cfquery name="upCodigoQR" datasource="#session.dsn#">
					UPDATE RH_CFDI_RecibosNomina
					SET codigoQR ='#imgQR#'
					WHERE Ecodigo = #session.Ecodigo#
					AND DEid = #Arguments.DEid#
					AND RCNid = #Arguments.RCNid#
					AND DLlinea =#Arguments.DLlinea#
				</cfquery>
				<!--- OPARRALES 2018-07-30 Se complementa para que genere Imagen QR FIN --->
			</cfif>
            <!--- FIN - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Recibo de Nomina --->

            <!--- INICIA - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Recibo de Liquidacion --->
            <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
                <cfquery name="updLiqFinCFDI" datasource="#session.dsn#">
                    UPDATE RH_CFDI_RecibosNomina
                    SET xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
                        timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
                        certificadoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCertificadoSAT#">,
                        cadenaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCadenaSAT#">,
                        selloSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloSAT#">,
                        fechaTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarFechaTimbrado#">,
                        stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">
                        <cfif IsDefined('archivoXml')>
                                ,NombreXML = <cfqueryparam cfsqltype="cf_sql_varchar" value="#archivoXml#">
                        </cfif>
                        WHERE Ecodigo = #session.Ecodigo#
                        AND DEid = #Arguments.DEid#
                        AND RCNid = #Arguments.RCNid#
                        AND DLlinea = #Arguments.DLlinea#
                </cfquery>
                <cfquery name="rsQRFE" datasource="#session.dsn#">
                    select  substring(SelloDigital,(len(SelloDigital)-7), 8) qrfe
                    from RH_CFDI_RecibosNomina
                    WHERE Ecodigo = #session.Ecodigo#
                        AND DEid = #Arguments.DEid#
                        AND RCNid = #Arguments.RCNid#
                        AND DLlinea = #Arguments.DLlinea#
                </cfquery>
                <cfset lVarQRFE= rsQRFE.qrfe>
            </cfif>
            <!--- FIN - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Recibo de Liquidacion --->

            <!--- INICIA - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Recibo de Pago--->
                <cfif Arguments.ReciboPago NEQ -1>
                    <cfquery name="updFACFDI" datasource="#session.dsn#">
                        UPDATE FA_CFDI_Emitido
                        SET xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
                            timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
                            certificadoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCertificadoSAT#">,
                            cadenaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCadenaSAT#">,
                            selloSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloSAT#">,
                            fechaTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarFechaTimbrado#">,
                            stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                            SelloDigital = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloCFD#">
                        WHERE Ecodigo = #session.Ecodigo#
                            AND OImpresionID =0
                            AND Folio = #Folio#
                            AND Serie = '#Serie#'
                            AND DocPago ='#Arguments.ReciboPago#'
                    </cfquery>
                    <cfquery name="rsQRFE" datasource="#session.dsn#">
                        select  substring(SelloDigital,(len(SelloDigital)-7), 8) qrfe
                        from FA_CFDI_Emitido
                        where Ecodigo = #session.Ecodigo#
                            and OImpresionID = 0
                            and Folio = #Folio#
                            AND Serie = '#Serie#'
                            AND DocPago ='#Arguments.ReciboPago#'
                    </cfquery>
                    <cfset lVarQRFE= rsQRFE.qrfe>
                </cfif>
            <!--- FIN - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Recibo de Pago--->

            <!--- INICIA - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Factura Electronica--->
                <cfif Arguments.OImpresionID GT 0>
                    <cfquery  datasource="#session.dsn#">
                        UPDATE FA_CFDI_Emitido
                        SET xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
                            timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
                            certificadoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCertificadoSAT#">,
                            cadenaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCadenaSAT#">,
                            selloSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloSAT#">,
                            fechaTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarFechaTimbrado#">,
                            stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">
                        WHERE Ecodigo = #session.Ecodigo#
                            AND OImpresionID = #Arguments.OImpresionID#
                            AND Folio = #Folio#
                            <cfif Serie NEQ ''>
                                AND Serie = '#Serie#'
                            </cfif>
                    </cfquery>
                    <cfquery datasource="#session.dsn#">
                        UPDATE FAEOrdenImpresion
                        set TimbreFiscal=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">
                        WHERE Ecodigo = #session.Ecodigo#
                            AND OImpresionID = #Arguments.OImpresionID#
                    </cfquery>
                    <cfquery name="rsQRFE" datasource="#session.dsn#">
                        select  substring(SelloDigital,(len(SelloDigital)-7), 8) qrfe
                        from FA_CFDI_Emitido
                        where  Ecodigo = #session.Ecodigo#
                            and OImpresionID = #Arguments.OImpresionID#
                            and Folio = #Folio#
                            <cfif Serie NEQ ''>
                                and Serie = '#Serie#'
                            </cfif>
                    </cfquery>
                    <cfset lVarQRFE= rsQRFE.qrfe>
                    

                    <cfquery name="upRelacionado" datasource="#session.dsn#">
                        update FA_CFDI_Relacionado
                        set Folio = #Folio#,
                            <cfif Serie NEQ ''> Serie = '#Serie#', </cfif>
                            Documento = 'NE-#Folio#'
                        where OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OImpresionID#">
                    </cfquery>
                </cfif>
            <!--- FIN - Actualiza FA_CFDI_Emitido con los datos de timbrado si es Factura Electronica--->

        <cfcatch type="any">
            <cftry>
                <cfset lVarError = MyXMLDoc.ERROR>
                <cfset lVarErrorCode = MyXMLDoc.ERROR.XmlAttributes.codError>
                <cfset lvarEstado = 2>

                <!--- INICIA - Manejo de Error si es Recibo de Nomina --->
                <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
                    <cfquery name="updReciboCFDI" datasource="#session.dsn#">
                        UPDATE RH_CFDI_RecibosNomina
                           SET stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                                xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">
                        WHERE Ecodigo = #session.Ecodigo#
                               AND DEid = #Arguments.DEid#
                               AND RCNid = #Arguments.RCNid#
                    </cfquery>
                </cfif>
                <!--- FIN - Manejo de Error si es Recibo de Nomina --->

                <!--- INICIA - Manejo de Error si es Recibo de Liquidacion --->
                <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
                    <cfquery name="updReciboCFDI" datasource="#session.dsn#">
                        UPDATE RH_CFDI_RecibosNomina
                           SET stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                                xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">
                        WHERE Ecodigo = #session.Ecodigo#
                               AND DEid = #Arguments.DEid#
                               AND RCNid = #Arguments.RCNid#
                               AND DLlinea = #Arguments.DLlinea#
                    </cfquery>
                </cfif>
                <!--- FIN - Manejo de Error si es Recibo de Liquidacion --->

                <!--- INICIA - Manejo de Error si es Factura--->
                    <cfif Arguments.OImpresionID GT 0>
                    
                        <cfquery name="updFACFDI" datasource="#session.dsn#">
                            UPDATE FA_CFDI_Emitido <!--- aqui  el  update a la db_FacturaEmitida con error--->
                            SET stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                                xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">
                            WHERE Ecodigo = #session.Ecodigo#
                            AND OImpresionID = #Arguments.OImpresionID#
                            AND Folio = #Folio#
                            <cfif Serie NEQ ''>
                                AND Serie = '#Serie#'
                            </cfif>
                        </cfquery>
                         
                        <!--- Elimina relacion de Nota de credito con la Factura. --->
                        <cfquery datasource="#session.dsn#">
                            delete from FA_CFDI_Relacionado
                            where OImpresionID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OImpresion#">
                        </cfquery>
                        <cfset falla = fallaFactura(Arguments.OImpresionID)>
                        <cfthrow message="Error #lvarEstado# al Timbrar la factura...#lVarXmlTimbrado#">
                    </cfif>
                    
                <!--- FIN - Manejo de Error si es Factura--->

                <!--- INICIA - Manejo de Error si es Recibo de Pago--->
                    <cfif Arguments.ReciboPago NEQ -1>
                        <cfquery  datasource="#session.dsn#">
                            UPDATE FA_CFDI_Emitido <!--- aqui  el  update a la db_FacturaEmitida con error--->
                            SET stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                                xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">
                            where Ecodigo = #session.Ecodigo#
                                and OImpresionID = 0
                                and Folio = #Folio#
                                AND Serie = '#Serie#'
                                AND DocPago ='#Arguments.ReciboPago#'
                                AND  stsTimbre <> 1
                        </cfquery>
				    </cfif>
                <!--- FIN - Manejo de Error si es Recibo de Pago--->

            <cfcatch type="any">
            	  <!---<cfthrow type="Invalid_XML" message="XML incorrecto #rsEmp.Emp#">--->
            </cfcatch>
            </cftry>
        </cfcatch>
        </cftry>
        <!--- FIN - Actualizacion de Timbrado--->

		<!--- INICIA - Path para imagen QR--->
            <cfset vsPath_R = #ruta#>
            
            <cfif REFind('(cfmx)$',vsPath_R) gt 0>
                <!--- CF v2016---> <cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#">
            <cfelse>
                <!--- CF v2011---> <cfset vsPath_R = "#vsPath_R#\">
            </cfif>
          
            <!--- Path si es Recibo de Nomina --->
            <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
				<cfif !IsDefined('rsCP')>
					<cfquery name="rsCP" datasource="#session.dsn#">
						select CPcodigo, CPfpago
					    from
							CalendarioPagos cp
					    inner join TiposNomina tn
					    	on cp.Ecodigo = tn.Ecodigo
							and cp.Tcodigo = tn.Tcodigo
					    where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					</cfquery>
				</cfif>
                <cfset imgQR = "#ruta#/Nomina#Year(rsCP.CPfpago)#/#Trim(rsCP.CPcodigo)#/imgQR/#DEid#_#RCNid#.jpg">
            </cfif>
            <!--- Path si es Recibo de Liquidacion --->
            <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
                <cfset imgQR = "#ruta#/Liquidacion-Finiquito#Year(Now())#/#rsBaja.Emp#/Liq_#DEid#_#DLlinea#.jpg">
            </cfif>
            <!--- Path si es Factura Electronica --->
                <cfif Arguments.OImpresionID GT 0>
                    <cfif left(Serie,2) EQ 'FC'>
                        <cfset imgQR = "#ruta#/imgQR/FE_#session.Ecodigo#_#Serie##Folio#.jpg">
                    <cfelseif left(Serie,2) EQ 'NC'>
                        <cfset imgQR = "#ruta#/imgQR/NC_#session.Ecodigo#_#Serie##Folio#.jpg">
                    <cfelse>
                        <cfset imgQR = "#ruta#/imgQR/#left(Serie,2)#_#session.Ecodigo#_#Serie##Folio#.jpg">
                    </cfif>
                </cfif>
                
             <!--- Path si es Recibo de Pago --->
                <cfif Arguments.ReciboPago NEQ -1>
                    <cfset imgQR = "#ruta#/imgQR/#Serie##Folio#_#Arguments.ReciboPago#.jpg">
                </cfif>
                <cfif isDefined('Arguments.destinoQR') and len(Arguments.destinoQR) gt 0>
                    <cfset imgQR = Arguments.destinoQR>
                </cfif>
		<!--- FIN - Path para imagen QR--->

        <cfif lvarEstado EQ 1>
        <cfquery name="rsQRFE" datasource="#session.dsn#">
					select  substring(SelloDigital,(len(SelloDigital)-7), 8) qrfe
					from RH_CFDI_RecibosNomina
					WHERE Ecodigo = #session.Ecodigo#
				    AND DEid = #Arguments.DEid#
				    AND RCNid = #Arguments.RCNid#
				</cfquery>
                <cfset lVarQRFE= rsQRFE.qrfe>
               
        	<cfset lVarTotal = #LSNumberformat(lVarTotal,'0000000000.000000')#>

            <cfif Not isDefined('lVarQRFE') or len(lVarQRFE) eq 0>
                <cfset lVarQRFE = Right(lVarSelloCFD, 8)>
            </cfif>
            
			<cfset cadenaQR = "https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?&id=#lVarTimbre#&re=#lVarRFCemisor#&rr=#lVarRFCreceptor#&tt=#lVarTotal#&fe=#lVarQRFE#">
            
            <cftry>
                <!--- Instancia la Clase TestQRCode --->
                <cfobject type="java" class="generacsd.TestQRCode" name="myTestQRCode">
                <!--- Generar codigo bidimencional --->     
                <cfif FileExists(imgQR)>
                    <cfscript>
                        FileDelete(imgQR);
                    </cfscript> 
                </cfif>
                <cfset image = myTestQRCode.generateQR(imgQR,cadenaQR,300,300)>
            <cfcatch>
            </cfcatch>
            </cftry>
        <cfelseif lvarEstado EQ 2>
            <cfset falla = fallaFactura(Arguments.OImpresionID)>
            <cfset match = REMatch("<ERROR codError='\d+'.*?<\/ERROR>",xmlTimbrado)>
            <cfif ArrayIsEmpty(match) eq false>
                <cfset match2 = REMatch("codError='\d+'",xmlTimbrado)>
                <cfthrow message="[#match2[1]#] #lVarXmlTimbrado#">
            <cfelse>
				<!--- 2019-01-30 Validacion para mostrar Empleado que tiene error al timbrar nomina --->
				<cfset varTextoExtra = "">
				<cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
		            <cfquery name="rsEmp" datasource="#session.dsn#">
		                select DEidentificacion + '_'+ DEnombre + ' ' + DEapellido1 +' ' + DEapellido2 as Emp
		                from DatosEmpleado
		                where DEid = #Arguments.DEid#
		            </cfquery>
		            <cfset varTextoExtra = "Para el Empleado: #rsEmp.Emp#">
				</cfif>
                <cfthrow message="#lvarEstado# #lVarXmlTimbrado# #varTextoExtra#">
            </cfif>
        </cfif>
        <cfreturn xmlTimbrado>
    </cffunction>

    <cffunction name="fallaFactura" returntype="string">
		<cfargument name="OImpresionID"				    type="numeric"	required="yes">
        <!--- INICIO - Resetea Factura --->
            <cfif Arguments.OImpresionID GT 0>
                <cfquery name="q_revertChanges" datasource="#session.dsn#">
                    update FAPreFacturaE set factura=0, foliofacele=0 where oidocumento = #Arguments.OImpresionID# and Ecodigo=#session.Ecodigo#;
                    delete from FA_CFDI_Emitido  where Ecodigo=#session.Ecodigo# and OImpresionID=#Arguments.OImpresionID#;
                </cfquery>
            </cfif>
        <!--- FIN - Resetea Factura --->
        <cfreturn '0'>
    </cffunction>


</cfcomponent>