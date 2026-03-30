<cfsetting enablecfoutputonly="yes">
<!---
	http://websdc/cfmx/sif/ad/catalogos/formatos/flash-params.cfm?read
--->

<cfparam name="url.FMT01COD" >

<cfquery datasource="#session.dsn#" name="enc">
	select FMT01COD, FMT01DES,
		FMT01LAR, FMT01ANC, <!--- largo x ancho del papel --->
		FMT01ORI <!--- 0/landscape/horizontal; 1/portrait/vertical --->
	from FMT001
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfquery datasource="#session.dsn#" name="params">
	select FMT10LIN, FMT10PAR, FMT10TIP, FMT10LON, FMT10DEF
	from FMT010
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfquery datasource="#session.dsn#" name="fields">
	select 
		 FMT02LIN, FMT02CAM, FMT02DES, FMT02LON,
		 FMT02DEC, FMT02FMT, FMT02TPL, FMT02TAM,
		 FMT02FIL, FMT02COL, FMT02AJU, FMT02POS,
		 FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS,
		 FMT02TIP, FMT02SPC, FMT02SQL, FMT02BOL,
		 FMT02UND, FMT02ITA, FMT02TOT, FMT02PAG,
		 FMT02CLR, FMT07NIV
	from FMT002
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<!---
	FMT10TIP:
		0:Texto
		1:Numero
		2:Fecha
--->

<cfscript>
function BitToXMLBoolean(bit_value){
	if (bit_value is 1)
		return 'true';
	else
		return 'false';
}
</cfscript>

<cfcontent type="application/xml" >
<cfoutput><?xml version="1.0" encoding="iso-8859-1" ?>
<data>
	<header>
		<codigo>#XMLFormat(enc.FMT01COD)#</codigo>
		<descripcion>#XMLFormat(enc.FMT01COD)#</descripcion>
		<page>
			<!--- largo x ancho del papel --->
			<width>#XMLFormat(enc.FMT01ANC)#</width>
			<height>#XMLFormat(enc.FMT01LAR)#</height>
			<orient>#XMLFormat(enc.FMT01ORI)#</orient><!--- 0/landscape/horizontal; 1/portrait/vertical --->
		</page>
	</header>
	<params>
	<cfloop query="params">
		<param>
			<lin>#XMLFormat(params.FMT10LIN)#</lin>
			<par>#XMLFormat(params.FMT10PAR)#</par>
			<tip>#ListGetAt('texto,numero,fecha', params.FMT10TIP)#</tip>
			<lon>#XMLFormat(params.FMT10LON)#</lon>
			<def>#XMLFormat(params.FMT10DEF)#</def>
		</param>
	</cfloop>
	</params>
	<campos>
	<cfloop query="fields">
		<campo>
			<linea>#XMLFormat(fields.FMT02LIN)#</linea>
			<campo>#XMLFormat(fields.FMT02CAM)#</campo>
			<descripcion>#XMLFormat(fields.FMT02DES)#</descripcion>
			<!--- font --->
			<font_family>#XMLFormat(fields.FMT02TPL)#</font_family>
			<font_size>#XMLFormat(NumberFormat(fields.FMT02TAM,'0.0'))#</font_size>
			<font_bold>#BitToXMLBoolean(fields.FMT02BOL)#</font_bold><!--- bold --->
			<font_underline>#BitToXMLBoolean(fields.FMT02UND)#</font_underline><!--- underline --->
			<font_italic>#BitToXMLBoolean(fields.FMT02UND)#</font_italic>
			<color>#XMLFormat(Trim(fields.FMT02CLR))#</color>
			<!--- posicion : x,y están al revés de lo normal: la posicion X esta en FMT02FIL, y la Y en FMT02COL --->
			<x>#XMLFormat(NumberFormat(fields.FMT02FIL,'0.00'))#</x>
			<y>#XMLFormat(NumberFormat(fields.FMT02COL,'0.00'))#</y>
			<width>#XMLFormat(NumberFormat(fields.FMT02LON,'0.00'))#</width>
			<posicion>#XMLFormat(fields.FMT02POS)#</posicion><!--- 1/Encabezado 2/Detalle 3/PostDetalle --->
			<!--- formato --->
			<decimales>#XMLFormat(fields.FMT02DEC)#</decimales>
			<formato>#XMLFormat(fields.FMT02FMT)#</formato>
			<justificar>#XMLFormat(fields.FMT02JUS)#</justificar> <!--- 1/left 2/center 3/right --->
			
			<ajuste_linea>#BitToXMLBoolean(fields.FMT02AJU)#</ajuste_linea><!--- ajustar linea? --->
			<prefijo>#XMLFormat(Trim(fields.FMT02PRE))#</prefijo><!--- no se usa --->
			<sufijo>#XMLFormat(Trim(fields.FMT02SUF))#</sufijo><!--- no se usa --->
			<hidden>#BitToXMLBoolean(fields.FMT02STS)#</hidden><!--- 0/visible 1/invisible --->
			<tipo>#XMLFormat(fields.FMT02TIP)#</tipo><!--- 1/Label 2/Dato 3/Sin definir! --->
			<trim>#BitToXMLBoolean(fields.FMT02SPC)#</trim><!--- 0/no 1/si --->
			<sql>#XMLFormat(fields.FMT02SQL)#</sql><!--- numero de columna --->
			<totalizar>#BitToXMLBoolean(fields.FMT02TOT)#</totalizar><!--- no se usa --->
			<page_break>#BitToXMLBoolean(fields.FMT02PAG)#</page_break>
			<nivel>#XMLFormat(fields.FMT07NIV)#</nivel>
		</campo>
	</cfloop>
	</campos>
</data>
</cfoutput>