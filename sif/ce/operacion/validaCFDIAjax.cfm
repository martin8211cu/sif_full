<!--- <cfdump var="#form#"> --->
<!--- <cfabort> --->
<!--- VALIDACION DE PARAMETRO VALIDA XML PROVEEDORES --->
<cfquery name="rsValidaXML"  datasource="#session.dsn#">
	SELECT * FROM Parametros WHERE Pcodigo = 200085 AND Mcodigo = 'CE' AND Pvalor = 'S' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- OBTENCION DE RFC DE LA EMPRESA --->
<cfquery name="rsRfc" datasource="#Session.DSN#">
	SELECT Eidentificacion
	FROM Empresa
	WHERE Ereferencia = #Session.Ecodigo#
</cfquery>


<cfset listErrores = "">
<cfset resultCodigoEstado = "">
<cfset resultEstado = "">
<cfif #rsValidaXML.RecordCount#  neq 0>
	<cfset varUrlFile = "">
	<cfset rfcEmisor = "">
	<cfset rfcReceptor = "">
	<cfset varMontoTotal = "">
	<cfset varIdSocioNegocio = "">
	<cfset varTimbreFiscal = "">
	<cfset archXML = "">
	<cfset expresionImpresa = "">

	<!--- OBTENCION DEL XML COMPLETO POR FILE--->
	<cfif isDefined("form.file")>
		<cfset varUrlFile = "#form.file#">
	<cfelse>
		<cfif isDefined("form.AFimagen")>
			<cfset varUrlFile = "#form.AFimagen#">
		</cfif>
	</cfif>
	<cfif FileExists(varUrlFile)>
			<CFFILE ACTION="READ" FILE="#varUrlFile#" VARIABLE="xmlCode">
			<cfset archXML = XmlParse(xmlCode)>
			<!--- ASIGNACION DEL RFC DEL EMISOR EN CASO DE ESTAR EN EL XML--->
			<cfset rfcEmisor = "#Trim(archXML.Comprobante.Emisor.XmlAttributes.rfc)#">
			<cfset rfcReceptor = "#Trim(archXML.Comprobante.Receptor.XmlAttributes.rfc)#">
			<cfset varMontoTotal = "#Trim(archXML.Comprobante.XmlAttributes.Total)#">
	<cfelse>
		<!--- RECUPERACION DEL MONTO TOTAL --->
		<cfif isDefined("form.MONTOTOTAL")>
			<cfset varMontoTotal = "#form.MONTOTOTAL#">
		<cfelse>
			<!--- Recuperacion del monto viene con otra variable --->
			<cfif isDefined("form.montoT")>
				<cfset varMontoTotal = "#form.montoT#">
			</cfif>
		</cfif>
	</cfif>

	<!--- OBTENCION DEL XML COMPLETO POR CADENA DE XML--->
	<cfif isDefined("form.rfcEmisor")  and form.rfcEmisor neq "">
		<cfset rfcEmisor = "#form.rfcEmisor#">
	</cfif>

	<!--- OBTENCION DEL XML COMPLETO POR CADENA DE XML--->
	<cfif isDefined("form.xmlTimbrado") and form.xmlTimbrado neq "">
		<cfset archXML = XmlParse("#form.xmlTimbrado#")>
		<!--- ASIGNACION DEL RFC DEL EMISOR EN CASO DE ESTAR EN EL XML--->
		<cfif isDefined("archXML.Comprobante.Emisor.XmlAttributes.rfc") AND LEN(TRIM(archXML.Comprobante.Emisor.XmlAttributes.rfc))>
			<cfset rfcEmisor = "#Trim(archXML.Comprobante.Emisor.XmlAttributes.rfc)#">
		</cfif>
		<cfif isDefined("archXML.Comprobante.Receptor.XmlAttributes.rfc") AND LEN(TRIM(archXML.Comprobante.Receptor.XmlAttributes.rfc))>
			<cfset rfcReceptor = "#Trim(archXML.Comprobante.Receptor.XmlAttributes.rfc)#">
		</cfif>
	</cfif>

	<!--- RECUPERACION DEL ID SOCIO DE NEGOCIO --->
	<cfif isDefined("form.SOCIONEGOCIOID")>
		<cfset varIdSocioNegocio = "#form.SOCIONEGOCIOID#">
	</cfif>

	<!--- RECUPERACION DEL TIMBRE FISCAL --->
	<cfif isDefined("form.TIMBREFISCAL")>
		<cfset varTimbreFiscal = "#form.TIMBREFISCAL#">
	</cfif>


	<!--- EN CASO DE NO ENCONTRAR EL RFC DEL EMISOR EN EL XML, SE OBTIENE DE LA BD POR MEDIO DEL ID DEL SOCIO DE NEGOCIO --->
	<cfif rfcEmisor EQ "" AND varIdSocioNegocio NEQ "">
		<cfquery name="rsGetRFCEmisor"  datasource="#session.dsn#">
			SELECT SNidentificacion
			FROM SNegocios
			WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varIdSocioNegocio#">
		</cfquery>
		<cfset rfcEmisor = Trim(#rsGetRFCEmisor.SNidentificacion#)>
	</cfif>


	<!--- OBTENCION DE URL DE WSDL --->
	<cfquery name="rsGetUrlWsdl"  datasource="#session.dsn#">
		SELECT top 1 Pvalor
		FROM Parametros
		WHERE Pcodigo = 200086
		and Ecodigo = #Session.ecodigo#
		AND Mcodigo = 'CE'
	</cfquery>

	<cfif rsGetUrlWsdl.RecordCount NEQ 0>
		<cfset varUrlWsdl = "#rsGetUrlWsdl.Pvalor#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "<br>* La url no esta definida.")><!--- Error --->
	</cfif>
	<!---Errores  --->
	<cfif rsRfc.RecordCount EQ 0>
		<cfset listErrores = ListAppend(listErrores, "<br>* El RFC del receptor.")>
	</cfif>

	<cfif rfcEmisor EQ "">
		<cfset listErrores = ListAppend(listErrores, "<br>* El RFC del emisor.")>
	</cfif>

	<cfif varMontoTotal EQ "">
		<cfset listErrores = ListAppend(listErrores, "<br>* El Monto total.")>
	</cfif>

	<cfif varTimbreFiscal EQ "">
		<cfset listErrores = ListAppend(listErrores, "<br>* Timbre Fiscal UUID.")>
	</cfif>

	<cfif listLen(listErrores) EQ 0>
		<cfset expresionImpresa = "?re=#rfcEmisor#&rr=#rsRfc.Eidentificacion#&tt=#Trim(numberFormat(varMontoTotal,'0.00'))#&id=#varTimbreFiscal#">
		
		<cfset resp = ValidaCFDI(
			url = varUrlWsdl,
			emisor = (form.origen eq 'CPFC') ? rfcEmisor : rsRfc.Eidentificacion,
			receptor = (form.origen eq 'CPFC') ? rsRfc.Eidentificacion : rfcReceptor,
			total = Trim(numberFormat(varMontoTotal,'0.00')),
			uuid = varTimbreFiscal
		)>

		<cfif resp.result>
			<cfset resultEstado = resp["data"]["estado"]._text>
			<cfset resultCodigoEstado = resp["data"]["estado"]._text>
		<cfelse>
			<cfset resultCodigoEstado = resp["message"]>
		</cfif>
		<cfelse>
			<br><br>
			<table width="70%" border="0" align="center" cellpadding="0" cellspacing="2">
				<tr><td><strong>Los siguientes datos son requeridos para la validaci&oacute;n:</strong><cfoutput>#listErrores#</cfoutput></td></tr>
			</table>
			<br><br>
	</cfif>
</cfif>
<cfoutput>
	<input type="hidden" name="resCodigoEstado" id="resCodigoEstado" value="#resultCodigoEstado#">
	<input type="hidden" name="resEstado" id="resEstado" value="#resultEstado#">
</cfoutput>

<cffunction name="ValidaCFDI" access="private">
	<cfargument name="url" type="string" required="true"/>
    <cfargument name="emisor" type="string" required="true"/>
    <cfargument name="receptor" type="string" required="true"/>
    <cfargument name="total" type="string" required="true"/>
    <cfargument name="uuid" type="string" required="true"/>
	
	<cftry>
		<cfhttp result="result" method="POST" charset="utf-8" url="#arguments.url#">
			<cfhttpparam name="emisor" type="Formfield" value=#arguments.emisor#>		
			<cfhttpparam name="receptor" type="Formfield" value=#arguments.receptor#>		
			<cfhttpparam name="total" type="Formfield" value=#arguments.total#>		
			<cfhttpparam name="uuid" type="Formfield" value=#arguments.uuid#>		
		</cfhttp>

		<cfset response = deserializeJson(result.filecontent)>
		<cfreturn response />
	<cfcatch type="any">
		<cfreturn {
			result = false,
			message = cfcatch.message
		}>
		</cfcatch>
	</cftry>
</cffunction>

<script language="javascript" type="text/javascript">
		parent.msgws(); <!--- Ejecutamos metodo --->
</script>