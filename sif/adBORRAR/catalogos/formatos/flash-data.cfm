<cfsetting enablecfoutputonly="yes">

<cftry>

<!---
	http://websdc/cfmx/sif/ad/catalogos/formatos/flash-params.cfm?read
--->

<cfparam name="url.FMT01COD" default="#session.FMT01COD#">
<cfset url.FMT01COD = session.FMT01COD >

<cfquery datasource="#session.dsn#" name="enc">
	select FMT01COD, FMT01DES, FMT01TIP,
		FMT01LAR, FMT01ANC, <!--- largo x ancho del papel --->
		FMT01ORI <!--- 0/landscape/horizontal; 1/portrait/vertical --->,
		FMT01GRD <!--- Grid size --->
	from FMT001
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfquery datasource="#session.dsn#" name="params">
	select FMT10LIN, FMT10PAR, FMT10TIP, FMT10LON, FMT10DEF
	from FMT010
	where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#enc.FMT01TIP#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rsSQL">
	select count(1) as cantidad
	from FMT002 a
	where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfif rsSQL.cantidad EQ 0>
	<cfquery datasource="#session.dsn#">
		insert into FMT002
				(
				 FMT01COD, 
				 FMT02LIN, FMT02DES, FMT02CAM, 
				 FMT02LON, FMT02DEC, FMT02FMT, FMT02TPL, FMT02TAM,
				 FMT02FIL, FMT02COL, FMT02AJU, FMT02POS,
				 FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS,
				 FMT02TIP, FMT02SPC, FMT02SQL, FMT02BOL,
				 FMT02UND, FMT02ITA, FMT02TOT, FMT02PAG,
				 FMT02CLR, FMT07NIV
				)
		values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">,
				1, 'PRIMER CAMPO', 'ETIQUETA', 
				10.0, 2,  '-1', 'Arial', 9, 0, 0, 0, '1', 1, 
				null,null,0, 1, 0, 1, 0, 0, 0, 1, 0,'000000', 0
		)
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="fields">
	select 
		 a.FMT02LIN, c.FMT11NOM, a.FMT02DES, case when a.FMT02LON < 0.5 then 0.5 else a.FMT02LON end as FMT02LON,
		 a.FMT02DEC, a.FMT02FMT, a.FMT02TPL, a.FMT02TAM,
		 a.FMT02FIL, a.FMT02COL, a.FMT02AJU, a.FMT02POS,
		 a.FMT02JUS, a.FMT02PRE, a.FMT02SUF, a.FMT02STS,
		 a.FMT02TIP, a.FMT02SPC, a.FMT02SQL, a.FMT02BOL,
		 a.FMT02UND, a.FMT02ITA, a.FMT02TOT, a.FMT02PAG,
		 a.FMT02CLR, a.FMT07NIV
	from FMT002 a
		join FMT001 b
			on a.FMT01COD = b.FMT01COD
		left join FMT011 c
			on b.FMT01TIP = c.FMT00COD
			and a.FMT02SQL = c.FMT02SQL
	where a.FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfquery datasource="#session.dsn#" name="rects">
	select 
		 FMT09LIN, FMT09COL, FMT09FIL, FMT09CLR,
		 FMT09HEI, FMT09WID, FMT09GRS, FMT09CFN
	from FMT009
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<cfquery datasource="#session.dsn#" name="images">
	select 
		 FMT03LIN, FMT03FIL, FMT03COL, FMT03ALT,
		 FMT03ANC, FMT03BOR, FMT03CFN, FMT03CBR,
		 FMT03EMP
	from FMT003
	where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
</cfquery>

<!---
	FMT10TIP:
		0:Texto
		1:Numero
		2:Fecha
--->

<cfinclude template="flash-conversion-functions.cfm">

<cfcontent type="text/plain">

<!--- encabezado --->
<cfoutput>codigo=#URLEncodedFormat(Trim(enc.FMT01COD))#&</cfoutput>
<cfoutput>page_width=#URLEncodedFormat(Trim(enc.FMT01ANC))#&</cfoutput>
<cfoutput>page_height=#URLEncodedFormat(Trim(enc.FMT01LAR))#&</cfoutput>
<cfoutput>page_orientation=#URLEncodedFormat(Trim(enc.FMT01ORI))#&</cfoutput>
<cfoutput>grid_size=#URLEncodedFormat(NumberFormat(enc.FMT01GRD,'0'))#&</cfoutput>

<!--- parametros --->
<!---
<cfset el_array = ArrayNew(1)>
<cfloop query="params">
	<cfset objeto = StructNew()>
	<cfset objeto.linea = params.FMT10LIN>
	<cfset objeto.nombre=params.FMT10PAR>
	<cfset objeto.tipo= ListGetAt('texto,numero,fecha', params.FMT10TIP)>
	<cfset objeto.longitud=params.FMT10LON >
	<cfset objeto.default=params.FMT10DEF >
	<cfset ArrayAppend(el_array, URLEncodedFormat(StructToURL(objeto)))>
</cfloop>
<cfoutput>parametros=#ArrayToList(el_array)#&</cfoutput>
--->
<!--- rectangulos --->

<cfset el_array = ArrayNew(1)>
<cfloop query="rects">
	<cfset objeto = StructNew()>
	<cfset objeto.linea = rects.FMT09LIN>
	<cfset objeto.x = NumberFormat(rects.FMT09FIL,'0.00')>
	<cfset objeto.y = NumberFormat(rects.FMT09COL,'0.00')>
	<cfset objeto.width = NumberFormat(rects.FMT09WID,'0.00')>
	<cfset objeto.height = NumberFormat(rects.FMT09HEI,'0.00')>
	<cfset objeto.color = rects.FMT09CLR>
	<cfset objeto.bgcolor = rects.FMT09CFN>
	<cfset objeto.grosor = rects.FMT09GRS>
	<cfset ArrayAppend(el_array, URLEncodedFormat(StructToURL(objeto)))>
</cfloop>
<cfoutput>rects=#ArrayToList(el_array)#&</cfoutput>

<!--- imagenes --->
 FMT03BOR, FMT03CFN, FMT03CBR,
		 FMT03EMP
<cfset el_array = ArrayNew(1)>
<cfloop query="images">
	<cfset objeto = StructNew()>
	<cfset objeto.linea = images.FMT03LIN>
	<cfset objeto.x = NumberFormat(images.FMT03FIL,'0.00')>
	<cfset objeto.y = NumberFormat(images.FMT03COL,'0.00')>
	<cfset objeto.width = NumberFormat(images.FMT03ANC,'0.00')>
	<cfset objeto.height = NumberFormat(images.FMT03ALT,'0.00')>
	<cfset objeto.border = BitToBoolean(images.FMT03BOR)>
	<cfset objeto.bordercolor = images.FMT03CBR>
	<cfset objeto.bgcolor = images.FMT03CFN>
	<cfset objeto.logo_empresa = BitToBoolean(images.FMT03EMP)>
	<cfset ArrayAppend(el_array, URLEncodedFormat(StructToURL(objeto)))>
</cfloop>
<cfoutput>images=#ArrayToList(el_array)#&</cfoutput>

		 
<!--- CAMPOS --->
<cfset el_array = ArrayNew(1)>
<cfloop query="fields">
	<cfset objeto = StructNew()>
	<cfset objeto.linea = fields.FMT02LIN>
	<cfset objeto.campo = "##" & fields.FMT11NOM & "##">
	<cfset objeto.tipo = fields.FMT02TIP><!--- 1/Label 2/Dato 3/Sin definir! --->
	<cfset objeto.descripcion = fields.FMT02DES>
		<!--- font --->
	<cfset objeto.font_bold = BitToBoolean(fields.FMT02BOL)>
	<cfset objeto.font_underline = BitToBoolean(fields.FMT02UND)>
	<cfset objeto.font_italic = BitToBoolean(fields.FMT02ITA)>
	<cfset objeto.font_family = fields.FMT02TPL>
	<cfset objeto.font_size = NumberFormat(fields.FMT02TAM,'0.0')>
	<cfset objeto.color = Trim(fields.FMT02CLR)>
		<!--- posicion : x,y están al revés de lo normal: la posicion X esta en FMT02FIL, y la Y en FMT02COL --->
	<cfset objeto.x = NumberFormat(fields.FMT02FIL,'0.00')>
	<cfset objeto.y = NumberFormat(fields.FMT02COL,'0.00')>
	<cfset objeto.width = NumberFormat(fields.FMT02LON,'0.00')>
	<cfset objeto.posicion = fields.FMT02POS ><!--- 1/Encabezado 2/Detalle 3/PostDetalle --->
		<!--- formato --->
	<cfset objeto.justificar = ListGetAt('left,center,right',fields.FMT02JUS) > <!--- 1/left 2/center 3/right --->
		<!---
	<cfset objeto.decimales = fields.FMT02DEC>
	<cfset objeto.formato = fields.FMT02FMT>
		
	<cfset objeto.ajuste_linea = BitToBoolean(fields.FMT02AJU)><!--- ajustar linea? --->
	<cfset objeto.prefijo = Trim(fields.FMT02PRE)><!--- no se usa --->
	<cfset objeto.sufijo = Trim(fields.FMT02SUF)><!--- no se usa --->
	<cfset objeto.hidden = BitToBoolean(fields.FMT02STS)><!--- 0/visible 1/invisible --->
	<cfset objeto.trim = BitToBoolean(fields.FMT02SPC)><!--- 0/no 1/si --->
	<cfset objeto.sql = fields.FMT02SQL><!--- numero de columna --->
	<cfset objeto.totalizar = BitToBoolean(fields.FMT02TOT)><!--- no se usa --->
	<cfset objeto.page_break = BitToBoolean(fields.FMT02PAG)>
	<cfset objeto.nivel = fields.FMT07NIV>
	--->
	<cfset ArrayAppend(el_array, URLEncodedFormat(StructToURL(objeto)))>
</cfloop>
<cfoutput>campos=#ArrayToList(el_array)#&</cfoutput>

<cfoutput>error=0&msg=ok</cfoutput>
<cfcatch type="any">

	<cfoutput>error=1&msg=#URLEncodedFormat(cfcatch.Message & ' - ' & cfcatch.Detail)#</cfoutput>
</cfcatch>

</cftry>