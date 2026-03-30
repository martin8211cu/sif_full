<cfcomponent>
<!---
	GuardarAnexo
	
	Valida el XML del anexo, y guarda la informacion del XML en
	las tablas de XML (Anexoim, AnexoVersion) y de AnexoCel
--->
<cffunction name="GuardarAnexo">
  <cfargument name="AnexoId" required="yes" type="numeric">
  <cfargument name="AnexoEditor" required="yes" type="string">
  
  <cfset This.ValidarXmlAnexo(AnexoId)>
  <cfset This.GuardarRangos(AnexoId)>

  <cfset This.GuardarImagenXML(AnexoId, AnexoEditor)>

</cffunction>

<!---
	Valida que el XML String en Request.excel_xml sea valido
	como anexo.  Realiza redirección en caso de no serlo.
	
	Requiere:  variable Request.excel_xml, con el texto del excel(xml) por analizar y validar
	Produce:   variable Request.xmlDoc, con el documento XML ya parseado
	           variable Request.excel_xml, transformada a ascii
			   
			   excel_xml se guarda en Request porque coldfusion pasa los argumentos
			   de tipo String por valor y no por referencia, por lo que un XML enorme
			   consumiría memoria adicional al estar pasando los valores.
			   xmlDoc se almacena también en Request para manejar ambos valores en 
			   el mismo contexto.

--->
<cffunction name="ValidarXMLAnexo" output="false" access="public">
  <cfargument name="AnexoId" required="yes" type="numeric">
  <cfparam name="Request.excel_xml">
  <cfif Len(Request.excel_xml) GT 6291456>
    <!--- 6MB = 6 x 1024^2 --->
    <cfset next_url = "anexo.cfm?msg=" & URLEncodedFormat("No se permiten archivos de anexos mayores a 6 MB.") >
    <cfif IsDefined("Request.ya_existia") And Request.ya_existia>
      <cfset next_url = next_url & "&AnexoId=#URLEncodedFormat( Arguments.AnexoId )#">
    </cfif>
    <cflocation url="#next_url#">
    <cf_errorCode	code = "50828" msg = "No se permiten archivos de anexos mayores a 6 MB.">
  </cfif>
  <cfif Mid(Request.excel_xml,1,19) NEQ '<?xml version="1.0"'>
    <cf_errorCode	code = "50829" msg = "El archivo debe comenzar con el encabezado XML.">
  </cfif>
  <!--- pasó, validar el XML --->
  <cftry>
    <cfset Request.xmlDoc = XMLParse(Request.excel_xml)>
    <cfset validators = ArrayNew(1)>
    <cfset ArrayAppend(validators, "//ss:Workbook/x:ExcelWorkbook")>
    <cfset ArrayAppend(validators, "//ss:Worksheet/x:WorksheetOptions")>
    <cfset ArrayAppend(validators, "//ss:Cell/ss:NamedCell")>
    <cfloop from="1" to="#ArrayLen(validators)#" index="i">
      <cfset result = XMLSearch(Request.xmlDoc, validators[i])>
      <cfif ArrayLen(result) EQ 0>
        <cf_errorCode	code = "50830"
        				msg  = "El archivo, aunque es un documento XML, no es un documento de Excel con rangos. Validacion No. @errorDat_1@"
        				errorDat_1="#i#"
        >
      </cfif>
    </cfloop>
	
    <!--- XSL identidad, asegura que el encoding sea ascii para que funcione con las tildes, ya que el ToString no acepta un encoding --->
    <cfxml variable="xslIdentity">
    <xsl:stylesheet version="1.0"
					xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
					xmlns="http://www.w3.org/TR/xhtml1/strict">
      <xsl:output encoding="ASCII"/>
      <xsl:template match="node()|@*">
        <xsl:copy>
          <xsl:apply-templates select="@*"/><xsl:apply-templates/></xsl:copy>
      </xsl:template>
    </xsl:stylesheet>
    </cfxml>
    <cfset Request.excel_xml = ToString(XMLTransform(Request.xmlDoc,xslIdentity))>
    <!--- fin de aseguramiento del encoding --->
    <cfcatch type="any">
      <cf_errorCode	code = "50831"
      				msg  = "El archivo debe ser un XML valido"
      				errorDat_1="#cfcatch.Message#"
      				errorDat_2="#cfcatch.Detail#"
      >
    </cfcatch>
  </cftry>
</cffunction>
<!---
	GuardarRangos
	
	Obtiene la lista de rangos y los inserta en AnexoCel.
	recibe un XML Document (no como string, sino documento)
	En lugar de recibirlo como parametro, utiliza el Request.xmlDoc
	1- Borra de AnexoCel las celdas con concepto nulo (y por lo tanto sin cuentas)
	2- Establece todas las filas y columnas de AnexoCel a cero
	3- Busca los NamedRange en el XML
	4- Guarda cada uno de estos NamedRange en AnexoCel
  --->
<cffunction name="GuardarRangos" returntype="void" access="public">
  <cfargument name="AnexoId" required="yes" type="numeric">
  
  <cfif Not IsXMLDoc(Request.xmlDoc)>
    <cf_errorCode	code = "50832" msg = "Se requiere un documento XML">
  </cfif>

  <cfset This.LimpiarAnexoCel(Arguments.AnexoId)>
  <cfset xmlNamedRanges = XMLSearch(Request.xmldoc, "//ss:Names/ss:NamedRange")>

  <cfloop from="1" to="#ArrayLen(xmlNamedRanges)#" index="i">
    <cfset RangeName = xmlNamedRanges[i].XmlAttributes['ss:Name']>
    <cfset RefersTo  = xmlNamedRanges[i].XmlAttributes['ss:RefersTo']>
    <cfset SheetName = Replace ( Replace ( ListFirst ( RefersTo, "!" ), '=', '' ), "'", '', 'all' ) >
    <cfset Rango     = ListFirst ( ListRest ( RefersTo, "!" ),':')>
    <cfif FindNoCase("C", rango) GTE 1>
      <cfset rangoCol = mid(rango, findnocase("C", rango) + 1, 255) >
      <cfset rangoRow = mid(rango, 2, findnocase("C", rango) - 2) >
      <cfelse>
      <cfset rangoCol = 0 >
      <cfset rangoRow = 0 >
    </cfif>
	<cfif RangeName neq 'Print_Titles'>
		<cfset This.GuardarAnexoCel(Arguments.AnexoId, SheetName, RangeName, rangoRow, rangoCol)>
	</cfif>
  </cfloop>
 
</cffunction>
<!---
	LimpiarAnexoCel
	
	Prepara AnexoCel para la actualizacion de todos los Rangos
	1- Borra de AnexoCel las celdas con concepto nulo (y por lo tanto sin cuentas)
	2- Establece todas las filas y columnas de AnexoCel a cero
--->
<cffunction name="LimpiarAnexoCel">
	<cfargument name="AnexoId" required="yes" type="numeric">
	<!---
	Borra todo lo que hay en AnexoCel para ese Anexo que no tenga un concepto
	definido (Solo existia en Base de Datos)
	--->
	<!---
	<cfquery datasource="#session.DSN#">
		DELETE 
		FROM AnexoCel
		WHERE AnexoId = #Arguments.AnexoId#
		  and AnexoCon is null
 		  and not exists 
			(select 1 
				from AnexoCalculoRango cr 
				where cr.AnexoCelId = AnexoCel.AnexoCelId )
	</cfquery>
	--->
	<!---
	Actualiza todas las celdas del Anexo, en la fila y columna a cero, 
	para que al final solamente queden las filas y columnas de los rangos
	definidos en el excel
	--->
	<cfquery datasource="#session.DSN#">
		UPDATE AnexoCel 
		SET AnexoFila = 0,
			AnexoColumna = 0
		WHERE AnexoId = #Arguments.AnexoId#
	</cfquery>
</cffunction>

<!---
	GuardarAnexoCel
	
	Genera los registros necesarios en AnexoCel, tomando como base el documento xml dado.
	3- Actualiza en AnexoCel la fila y columna de los rangos encontrados en el xml, 
	   o si no existe lo inserta con concepto nulo.	
 --->
<cffunction name="GuardarAnexoCel">
  <cfargument name="AnexoId" required="yes" type="numeric">
  
  <cfargument name="SheetName" required="yes" type="string">
  <cfargument name="RangeName" required="yes" type="string">
  <cfargument name="Row" required="yes" type="string">
  <cfargument name="Col" required="yes" type="string">
  <cfargument name="Formula" required="no" type="string" default="*">
  
	<cfquery name="existe" datasource="#session.DSN#">
		SELECT AnexoCelId
		FROM AnexoCel
		WHERE AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		  AND AnexoHoja = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SheetName#">
		  AND AnexoRan = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RangeName#">
	</cfquery>

	<cfif existe.recordcount GT 0>

	  <cfquery datasource="#session.DSN#">
		UPDATE AnexoCel
		SET AnexoFila 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Row#">,
			AnexoColumna 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Col#">,
			AnexoFor		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Formula#" null="#Arguments.Formula EQ '*'#">
		WHERE AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		  AND AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existe.AnexoCelId#">
	  </cfquery>

	<cfelse>

	  <cfquery datasource="#session.DSN#">
		INSERT INTO AnexoCel(
			AnexoId,     AnexoHoja, AnexoRan, AnexoCon, Ecodigo, AVid,     
			AnexoES,     AnexoRel,  AnexoMes, AnexoPer, Ocodigo, AnexoNeg, 
			BMUsucodigo, AnexoFila, AnexoColumna,
			AnexoFor)
		VALUES (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SheetName#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RangeName#">, 
				null, <!--- el concepto nulo indica que no se ha especificado el concepto de la celda --->
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 					 
				null,
				'E', 		  
				1, 	 0,      0,     null,   0, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Row#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Col#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Formula#" null="#Arguments.Formula EQ '*'#">
			 )
		</cfquery>
	</cfif>
</cffunction>
<!---
	GuardarAnexoXML
	
	Guarda el XML del Anexo así como su historia.
--->
<cffunction name="GuardarImagenXML">
  <cfargument name="AnexoId" required="yes" type="numeric">
  <cfargument name="AnexoEditor" required="yes" type="string">
  <cfquery datasource="#session.dsn#" name="existe">
		select AnexoDef, AnexoXLS from Anexoim
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
	</cfquery>
  <cfif existe.RecordCount>
	<cfif existe.AnexoDef NEQ "" and len(existe.AnexoXLS) GT 0>
		<cfquery datasource="#session.dsn#">
			insert into AnexoVersion (
				AnexoId, AnexoVersion, Ecodigo,
				AnexoDef, AnexoXLS,
				AnexoDes, AnexoEditor,
				BMfecha, BMUsucodigo)
			select
				<!---a.AnexoId, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, a.Ecodigo,--->
				a.AnexoId, <cf_dbfunction name="now">, a.Ecodigo,
				<cfif len(existe.AnexoXLS) EQ 0>i.AnexoDef<cfelse>null</cfif>,i.AnexoXLS, 
				a.AnexoDes, i.AnexoEditor,
				a.AnexoFec, coalesce (a.BMUsucodigo, 0) as BMUsucodigo
			from Anexo a
				join Anexoim i
					on a.AnexoId = i.AnexoId
			where a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		</cfquery>
	</cfif>
    <cfquery name="rsInsUp" datasource="#Session.DSN#">
			update Anexoim set 
				AnexoDef = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Request.excel_xml#">,
				AnexoEditor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AnexoEditor#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		</cfquery>
    <cfelse>
    <cfquery name="rsInsUp" datasource="#Session.DSN#">
			insert into Anexoim (Ecodigo, AnexoId, AnexoDef, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Request.excel_xml#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
  </cfif>
</cffunction>
</cfcomponent>


