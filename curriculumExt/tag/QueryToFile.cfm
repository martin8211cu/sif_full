<!--- 
	Para queries muy grandes se debe usar queryName="query" en lugar de query="#query#"
--->
<cfsetting 	enablecfoutputonly="yes"
			requesttimeout="36000">
<cfset newline = Chr(13) & Chr(10)>
<cfparam name="Attributes.titulo" 		type="string" 	default="Exporta Consulta a Excel">
<cfparam name="Attributes.jdbc"			type="boolean"	default="false">
<cfparam name="Attributes.query"		type="any" 		default="#QueryNew('X')#">
<cfparam name="Attributes.queryName" 	type="string" 	default="">
<cfparam name="Attributes.encabezados" 	type="boolean" 	default="true">
<cfif Attributes.queryName NEQ "">
	<cfset LvarQuery = caller["#Attributes.queryName#"]>
<cfelse>
	<cfset LvarQuery = Attributes.query>
</cfif>

<cfset buffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 32768 ))>
<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'QueryToFileXL')>
<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
<cfset write_to_buffer('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">' & newline)>
<cfif FindNoCase(".xls",Attributes.filename)>
	<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" ' & 
		'xmlns:x="urn:schemas-microsoft-com:office:excel" ' &
		'xmlns="http://www.w3.org/TR/REC-html40">' & newline)>
	<cfset LvarExcel = true>
<cfelse>
	<cfset write_to_buffer('<html>' & newline)>
	<cfset LvarExcel = false>
</cfif>

<cfset write_to_buffer('<head><title># HTMLEditFormat( Attributes.titulo )#</title></head>' & newline)>
<cfset write_to_buffer('<body>' & newline & '<table align="left">' & newline)>

<cfif Attributes.jdbc>
	<cfset LvarCols = ArrayNew(1)>
	<cfloop from="1" to="#LvarQuery.getMetaData().getColumnCount()#" index="i">
		<cfset LvarCols[i] = LvarQuery.getMetaData().getColumnLabel( JavaCast("int", i))>
	</cfloop>
<cfelse>
	<cfset LvarCols = LvarQuery.getColumnNames()>
</cfif>
<cfset LvarFileType = arrayNew(1)>
<cfloop index="i" from="1" to="#arrayLen(LvarCols)#"><!--- Debe ir PEGADO al CFLOOP ---><cfsilent>
	<!--- El CFSILENT evita que coldfusion acumule en memoria el espacio en
	blanco de este CFLOOP el número de iteraciones que encuentre --->
	<cfif Attributes.jdbc>
		<cfset LvarJavaType = LvarQuery.getMetaData().getColumnClassName(JavaCast("int", i))>
	<cfelse>
		<cfset LvarJavaType = evaluate("LvarQuery.#LvarCols[i]#").getClass().getName()>
	</cfif>
	<cfif findNoCase("Integer",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "N">
	<cfelseif findNoCase("BigDecimal",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "N">
	<cfelseif findNoCase("Double",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "N">
	<cfelseif findNoCase("Float",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "N">
	<cfelseif findNoCase("Time",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "T">
	<cfelseif findNoCase("Date",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "D">
	<cfelseif findNoCase("[B",LvarJavaType) GT 0>
		<cfset LvarFileType[i] = "B">
	<cfelse>
		<cfset LvarFileType[i] = "S">
	</cfif>
</cfsilent><!--- Debe ir PEGADO al CFLOOP ---></cfloop>

<cfif Attributes.encabezados>
	<cfset write_to_buffer('<tr>')>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#"><!--- Debe ir PEGADO al CFLOOP ---><cfsilent>
		<!--- El CFSILENT evita que coldfusion acumule en memoria el espacio en
		blanco de este CFLOOP el número de iteraciones que encuentre --->
		<cfif LvarFileType[i] EQ "N">
			<cfset write_to_buffer('<td align="right"><b>#LvarCols[i]#</b></td>')>
		<cfelseif LvarFileType[i] EQ "T">
			<cfset write_to_buffer('<td align="center"><b>#LvarCols[i]#</b></td>')>
		<cfelseif LvarFileType[i] EQ "D">
			<cfset write_to_buffer('<td align="center"><b>#LvarCols[i]#</b></td>')>
		<cfelse>
			<cfset write_to_buffer('<td align="left"><b>#LvarCols[i]#</b></td>')>
		</cfif>
	</cfsilent><!--- Debe ir PEGADO al CFLOOP ---></cfloop>
	<cfset write_to_buffer('</tr>#newline#')>
</cfif>

<cfloop query="LvarQuery"><!--- Debe ir PEGADO al CFLOOP ---><cfsilent>
	<!--- El CFSILENT evita que coldfusion acumule en memoria el espacio en
	blanco de este CFLOOP el número de iteraciones que encuentre --->
	<cfset write_to_buffer('<tr>')>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
		<cfif Attributes.jdbc>
			<cfset LvarDato = evaluate("#LvarCols[i]#")>
		<cfelse>
			<cfset LvarDato = evaluate("LvarQuery.#LvarCols[i]#")>
		</cfif>
		<cfif Not IsDefined('LvarDato')>
			<cfset LvarDato = ''>
		</cfif>
		<cfif LvarFileType[i] EQ "N">
			<cfset write_to_buffer('<td align="right" x:num># HTMLEditFormat( Trim(LvarDato) )#</td>')>
		<cfelseif LvarFileType[i] EQ "T" And Len(LvarDato)>
			<cfset write_to_buffer('<td align="center" x:date>#DateFormat(LvarDato,"YYYY-MM-DD")# #TimeFormat(LvarDato,"HH:MM:SS")#</td>')>
		<cfelseif LvarFileType[i] EQ "D" And Len(LvarDato)>
			<cfset write_to_buffer('<td align="center" x:date>#DateFormat(LvarDato,"YYYY-MM-DD")#</td>')>
		<cfelse>
			<cfset write_to_buffer('<td align="left" x:str>#HTMLEditFormat(Trim(LvarDato))#</td>')>
		</cfif>
	</cfloop>
	<cfset write_to_buffer('</tr>' & newline)>
</cfsilent><!--- Debe ir PEGADO al CFLOOP ---></cfloop>
<cfset write_to_buffer('</table></body></html>', true)>

<cfif Attributes.jdbc>
	<cf_jdbcqueryEXT_close>
</cfif>

<cffunction name="write_to_buffer" output="false">
	<cfargument name="contents" type="string" required="yes">
	<cfargument name="flush" type="boolean" default="no">
	<cfset buffer.append(Arguments.contents)>
	<cfif Arguments.flush Or (buffer.length() GE 16383)>
		<cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no">
		<cfset buffer.setLength(0)>
	</cfif>
</cffunction>

<cfheader name="Content-Disposition"	value="attachment;filename=#Attributes.filename#">
<cfcontent type="application/msexcel" reset="yes" file="#temporaryFileName#" deletefile="yes">
