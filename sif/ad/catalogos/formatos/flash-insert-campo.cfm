<cfsetting enablecfoutputonly="yes">

<cfparam name="url.FMT01COD">

<cftransaction>

<cfquery datasource="#session.dsn#" name="next_key">
	select coalesce ( max (FMT02LIN), 0) + 1 as next_key
	from FMT002
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into FMT002 ( FMT01COD, FMT02LIN, FMT02DES, FMT02LON, FMT02DEC, FMT02FMT, FMT02TPL, FMT02TAM, 
				FMT02FIL, FMT02COL, FMT02AJU, FMT02POS, FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS, 
				FMT02TIP, FMT02SPC, FMT02SQL, FMT02BOL, FMT02UND, FMT02ITA, FMT02TOT, FMT02PAG, 
				FMT02CLR, FMT07NIV, FMT02CAM 
			  )
	values(
		<cfqueryparam value="#session.FMT01COD#" cfsqltype="cf_sql_char"    >,
		<cfqueryparam value="#next_key.next_key#" cfsqltype="cf_sql_integer" >,
		'Nuevo Campo',	10.0,
		2,	'##0.00',
		'Arial',	9,
		
		8,3,0,'1',
		1,'  ','  ',	0,
		
		1,		0,	    0,	0,
		0,		0,		0,		0,
		'000000',		0,		'Nuevo Campo'
	)
</cfquery>

<cfquery datasource="#session.dsn#" name="fields">
	select * from FMT002
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
	  and FMT02LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#next_key.next_key#">
</cfquery>
</cftransaction>

<cfinclude template="flash-conversion-functions.cfm">

<cfcontent type="text/plain">

		 
<!--- CAMPOS --->
<cfset objeto = StructNew()>
<cfset objeto.linea = fields.FMT02LIN>
<cfset objeto.campo = fields.FMT02CAM>
<cfset objeto.descripcion = fields.FMT02DES>
	<!--- font --->
<cfset objeto.font_family = fields.FMT02TPL>
<cfset objeto.font_size = NumberFormat(fields.FMT02TAM,'0.0')>
<cfset objeto.font_bold = BitToBoolean(fields.FMT02BOL)>
<cfset objeto.font_underline = BitToBoolean(fields.FMT02UND)>
<cfset objeto.font_italic = BitToBoolean(fields.FMT02UND)>
<cfset objeto.color = Trim(fields.FMT02CLR)>
	<!--- posicion : x,y están al revés de lo normal: la posicion X esta en FMT02FIL, y la Y en FMT02COL --->
<cfset objeto.x = NumberFormat(fields.FMT02FIL,'0.00')>
<cfset objeto.y = NumberFormat(fields.FMT02COL,'0.00')>
<cfset objeto.width = NumberFormat(fields.FMT02LON,'0.00')>
<cfset objeto.posicion = fields.FMT02POS ><!--- 1/Encabezado 2/Detalle 3/PostDetalle --->
	<!--- formato --->
<cfset objeto.decimales = fields.FMT02DEC>
<cfset objeto.formato = fields.FMT02FMT>
<cfset objeto.justificar = fields.FMT02JUS > <!--- 1/left 2/center 3/right --->
	
<cfset objeto.ajuste_linea = BitToBoolean(fields.FMT02AJU)><!--- ajustar linea? --->
<cfset objeto.prefijo = Trim(fields.FMT02PRE)><!--- no se usa --->
<cfset objeto.sufijo = Trim(fields.FMT02SUF)><!--- no se usa --->
<cfset objeto.hidden = BitToBoolean(fields.FMT02STS)><!--- 0/visible 1/invisible --->
<cfset objeto.tipo = fields.FMT02TIP><!--- 1/Label 2/Dato 3/Sin definir! --->
<cfset objeto.trim = BitToBoolean(fields.FMT02SPC)><!--- 0/no 1/si --->
<cfset objeto.sql = fields.FMT02SQL><!--- numero de columna --->
<cfset objeto.totalizar = BitToBoolean(fields.FMT02TOT)><!--- no se usa --->
<cfset objeto.page_break = BitToBoolean(fields.FMT02PAG)>
<cfset objeto.nivel = fields.FMT07NIV>

<cfoutput>campo_nuevo=#URLEncodedFormat(StructToURL(objeto))#</cfoutput>
