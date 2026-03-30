<!---
 * Convierte un XML timbrado a PDF
 *
 * Author:	Ing. Oscar Orlando Parrales Villanueva
 * Fecha:	2018-09-25
 * Descripcion: Especificando el origen del proceso se define la plantilla con la que se hara la transformacion entre XML-XSLT para crear el PDF
 				1.- Recibo de Nomina	(\rh\XSLT\CFDI_PDF.xslt)
				2.- Recibo de pago		(\rh\XSLT\CFDI_RE.xslt)
 --->

<cfcomponent>
	<cffunction name="generaPDF" access="public" output="false">
		<cfargument name="OrigenProceso"	required="true"		type="string">
		<cfargument name="XMLTimbrado"		required="true"		type="string">
		<cfargument name="NombreXML"		required="true"		type="string">
		<cfargument name="ImagenQR"			required="true"		type="binary">

		<cfswitch expression="#Trim(Arguments.OrigenProceso)#">
			<cfcase value="NOMINA">
				<cfset generaPDFNomina(
					XMLTimbrado = Arguments.XMLTimbrado,
					NombreXML	= Arguments.NombreXML,
					ImagenQR	= Arguments.ImagenQR
					)>
			</cfcase>
			<cfcase value="RECIBOPAGO">
				<cfset generaPDFReciboPago(
					XMLTimbrado = Arguments.XMLTimbrado,
					NombreXML	= Arguments.NombreXML,
					ImagenQR	= Arguments.ImagenQR
					)>
			</cfcase>

			<cfdefaultcase>
				<cfthrow message="PROCESO DESCONOCIDO: " detail="El origen recibido(#Arguments.OrigenProceso#) aun no esta definido.">
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="generaPDFNomina" access="private">
		<cfargument name="XMLTimbrado"	required="true" type="string">

		<cfset sinDefinir = 1>

	</cffunction>




	<cffunction name="generaPDFReciboPago" access="private">
		<cfargument name="XMLTimbrado"	required="true" type="string">
		<cfargument name="NombreXML"	required="true" type="string">
		<cfargument name="ImagenQR"		required="true" type="binary">

		 <cf_foldersFacturacion name = "ruta">
		 

		<cfset logoEmpresa = getLogoEmpresa()>
		<cfset sourceImage = ImageNew(logoEmpresa.ELogo)>
		<cfimage action="write" source="#sourceImage#" destination="#expandPath('logoEmpresa.jpg')#" overwrite="true" quality=".2">

		<cfset pathDef = "#ruta#">
		<cfset arrImgQR = arraynew(1)>
		<cfset arrNombreXML = ListToArray(Replace(Arguments.NombreXML,'T.xml','.xml'),".",false,true)>
		<!--- <cfset archivoXmlT=#vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\#Serie##Folio#_#Arguments.ReciboPago#T.xml">---->
		<cfset ImgPath = "#ruta#/imgQR/#Left(arrNombreXML[1],Len(arrNombreXML[1])-1)#.jpg">
		<!--- <cffile action = "readBinary" file = "#ImgPath#" variable = "contenidoQR"> --->
		<cfset contenidoQR = Arguments.ImagenQR>
		<cfset rutaTmp = '#ruta#/imgQR/#arrNombreXML[1]#.jpg'>
		<cfset ArrayAppend(arrImgQR,rutaTmp)>

		<cfset unQRImg = ImageNew(contenidoQR)>
		<cfset Imagewrite(unQRImg,rutaTmp,"1",true)>

		<!--- <cffile action="read" variable="xml32" file="#pathDef#\#Replace(Arguments.XMLTimbrado,'.pdf','T.xml')#" charset="utf-8"> --->
		<cfset xml32 = Arguments.XMLTimbrado>

		<cfset varXMLTimbrado = XmlParse(xml32)>

		<!--- Obtención de la versión --->
		<cfset versionXml = varXMLTimbrado["cfdi:Comprobante"].XmlAttributes.Version>

		<!--- VARIABLES XML --->
		<cfif versionXml eq '3.3'>
			<cfset nodeArray = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"]>
			<cfset pagoAtt = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"].XmlAttributes>
		<cfelseif versionXml eq '4.0'>
			<cfset nodeArray = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"]>
			<cfset pagoAtt = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"].XmlAttributes>
		</cfif>


		<cfset emiAtt = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Emisor"].XmlAttributes>
		<!---cfset pagoAtt = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"].XmlAttributes--->
		<cfset RecAtt = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Receptor"].XmlAttributes>
		<cfset tfdAtt = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["tfd:TimbreFiscalDigital"].XmlAttributes>
		<!--- cfset nodeArray = varXMLTimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"] --->

		 <cfquery name="rsValFiscE" datasource="#session.dsn#">
			SELECT  DirecFisc
			FROM    Empresas
			WHERE   Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<!--- EMPRESA --->
		<cfif rsValFiscE.DirecFisc EQ 1>
			<cfquery name="rsDatosEmpresa" datasource="#session.dsn#">
				SELECT
					e.Enombre, Calle, NumExt, NumInt, Colonia,
					Localidad, Referencia, Delegacion, es.Estado, Pais, es.CodPostal, ciudad
				FROM Empresas es
				inner join Empresa e
				  on es.Ecodigo = e.Ereferencia
				inner join Direcciones d
				  on e.id_direccion = d.id_direccion
				WHERE es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="rsDatosEmpresa" datasource="#session.dsn#">
				select
					a.Enombre, b.direccion1, b.direccion2,
					b.ciudad, b.estado, a.Eidentificacion , b.codPostal,
					a.Etelefono1,a.Efax,a.Eidentificacion,a.Enumlicencia
				from Empresa a
				INNER JOIN Direcciones b
				on a.id_direccion = b.id_direccion
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigosdc#">
			</cfquery>
		</cfif>

		<cfset varDireccionEmp = "">
		<cfif rsValFiscE.DirecFisc EQ 1>
			<cfset varDireccionEmp &= "#rsDatosEmpresa.Calle# #rsDatosEmpresa.NumExt# #rsDatosEmpresa.NumInt#,
				#rsDatosEmpresa.Colonia# - #rsDatosEmpresa.Localidad#,
				#rsDatosEmpresa.Delegacion#,">
			<cfif isDefined('rsDatosEmpresa.Referencia') and len('rsDatosEmpresa.Referencia')>
				<cfset varDireccionEmp &= "#rsDatosEmpresa.Referencia#">
			</cfif>
			<cfset varDireccionEmp &= " C.P. #rsDatosEmpresa.codPostal#, #rsDatosEmpresa.Estado# - #rsDatosEmpresa.Pais#">
		<cfelse>
			<cfset varDireccionEmp &= "C.P #rsDatosEmpresa.direccion1#, #rsDatosEmpresa.direccion2#">
		</cfif>

		<cfquery name="rsRegDesc" datasource="#session.dsn#">
			select nombre_RegFiscal as CSATdescripcion
			from FARegFiscal
			where claveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emiAtt.RegimenFiscal#">
		</cfquery>

		<cfquery name="rsDomFiscCliente" datasource="#session.DSN#">
			SELECT
				case
                  when d.direccion1 <> '' THEN CONCAT(d.direccion1, d.direccion2, ', ', d.ciudad, ', ', d.estado, ', C.P. ', d.codPostal)
                  else s.SNdireccion
                  end as DireccionCompleta
			FROM    DireccionesSIF d
			        INNER JOIN Pais p
			        ON d.Ppais = p.Ppais
			        INNER JOIN SNegocios s
			        ON d.id_direccion = s.id_direccion
			where s.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RecAtt.Rfc#">
			<!--- WHERE d.id_direccion = #rsDatosfac.id_direccion# --->
		</cfquery>
		<cfset varDirSN = "#rsDomFiscCliente.DireccionCompleta#">

		<cfquery name="q_formaPago" datasource="#session.dsn#">
			select Concat('#pagoAtt.FormaDePagoP#',' ',nombre_TipoPago) as nombre_TipoPago
			from FATipoPago
			where TipoPagoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pagoAtt.FormaDePagoP#">
			and ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="rsMoneda" datasource="#session.dsn#">
			select Mnombre
			from Monedas
			where ClaveSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pagoAtt.MonedaP#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="rsCadenaSat" datasource="#session.dsn#">
			select
				cadenaSAT,
				DocPago,
				SelloSAT
			from FA_CFDI_Emitido
			where timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tfdAtt.UUID#">
			order by fechaTimbrado desc
		</cfquery>

		<!---<cfset miXml = replace(#xml32#,"="" ","=""","ALL")>--->
		
		<cfset miXml = replace(#xml32#,"cfdi:Comprobante ","Comprobante ","ALL")>
		<cfset miXml = replace(#miXML#,"cfdi:Comprobante ","Comprobante ","ALL")>
		<cfset miXml = replace(#miXML#,"cfdi:Emisor ","Emisor ","ALL")>
		<cfset miXml = replace(#miXML#,"cfdi:Receptor ","Receptor ","ALL")>
		<cfset miXml = replace(#miXML#,"cfdi:Complemento","Complemento","ALL")>
		<cfset miXml = replace(#miXML#,"cfdi:Conceptos","Conceptos","ALL")>
		<cfset miXml = replace(#miXML#,"cfdi:Concepto ","Concepto ","ALL")>
		<cfset miXml = replace(#miXML#,"pago10:Pagos ","Pagos ","ALL")>
		<cfset miXml = replace(#miXML#,"pago10:Pago ","Pago ","ALL")>
		<cfset miXml = replace(#miXML#,"pago10:DoctoRelacionado","DoctoRelacionado","ALL")>
		<cfset miXml = replace(#miXML#,"pago20:Pagos ","Pagos ","ALL")>
		<cfset miXml = replace(#miXML#,"pago20:Pago ","Pago ","ALL")>
		<cfset miXml = replace(#miXML#,"pago20:DoctoRelacionado","DoctoRelacionado","ALL")>
		<cfset miXml = replace(#miXML#,"tfd:TimbreFiscalDigital ","TimbreFiscalDigital ","ALL")>
		<cfset miXml = replace(#miXML#,'Serie="',' Serie="',"ALL")>
		<cfset miXml = replace(#miXML#,'NoCertificadoSAT="',' NoCertificadoSAT="',"ALL")>
		<cfset miXml = replace(#miXML#,'SelloCFD="',' SelloCFD="',"ALL")>
		<cfset miXml = replace(#miXml#,"Fecha", " Fecha", "All")>
		<cfset miXml = replace(#miXML#,"/cfdi:Comprobante","/Comprobante","ALL")>
		<cfset miXml = replace(#miXML#,"/cfdi:Complemento","/Complemento","ALL")>
		<cfset miXml = replace(#miXML#,"/pago10:Pagos","/Pagos","ALL")>
		<cfset miXml = replace(#miXML#,"/pago10:Pago","/Pago","ALL")>
		<cfset miXml = replace(#miXML#,"/pago10:DoctoRelacionado ","/DoctoRelacionado ","ALL")>
		<cfset miXml = replace(#miXML#,"/pago20:Pagos","/Pagos","ALL")>
		<cfset miXml = replace(#miXML#,"/pago20:Pago","/Pago","ALL")>
		<cfset miXml = replace(#miXML#,"/pago20:DoctoRelacionado ","/DoctoRelacionado ","ALL")>



		<cfset xmlParams = Structnew()>
		<cfset xmlParams["imgEmpresa"] = "file:///#expandPath('logoEmpresa.jpg')#">
		<cfset xmlParams["DireccionEmpresa"] = "#varDireccionEmp#">
		<cfset xmlParams["RegimenDesc"] = "#rsRegDesc.CSATdescripcion#">
		<cfset xmlParams["DireccionComp"] = "#varDirSN#">
		<cfset xmlParams["FormaPago"] = "#q_formaPago.nombre_TipoPago#">
		<cfset xmlParams["Mnombre"] = "#rsMoneda.Mnombre#">
		<cfset xmlParams["OItipoCambio"] = "1.0000">
		<cfset xmlParams["myStyle"] = "border: 1px solid ##999; padding: 3px; text-align:center;">
		<cfset xmlParams["myStyle2"] = "border: 1px solid ##999; padding: 3px;">
		<cfset xmlParams["cadenaSAT"] = wrap(rsCadenaSat.cadenaSAT,80,true)>
		<cfset xmlParams["imgQR"] = "file:///#rutaTmp#">
		<cfset xmlParams["sdSAT"] = wrap(rsCadenaSAT.selloSAT,80,true)>
		<cfset xmlParams["saltoLinea"] = (ArrayLen(nodearray.XmlChildren) gte 10 and ArrayLen(nodearray.XmlChildren) lte 17 ? "1":"0")>
		<CFFILE ACTION="read" FILE="#expandPath('/rh/XSLT/CFDI_RE.xslt')#" variable="miXSLT">
		<cfset miHTML = XmlTransform(miXML, miXSLT,xmlParams)>
		<cfoutput>#miHTML#</cfoutput>
		<cfdocument  format="PDF" filename="#ruta#/#arrNombreXML[1]#Copy.pdf" mimetype="image/png" overwrite="true" localUrl="yes">
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 5.0 Transitional//EN">
				<cfoutput>#miHTML#</cfoutput>
		</cfdocument>

	</cffunction>

	<cffunction  name="getLogoEmpresa">
	    <cfquery name="rsLogo" datasource="#session.DSN#">
			Select  Elogo , Ecodigo
			From  Empresa
			where Ereferencia = #session.Ecodigo#
		</cfquery>
		<cfreturn rsLogo>
	</cffunction>
</cfcomponent>