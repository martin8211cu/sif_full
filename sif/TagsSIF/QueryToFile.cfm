<!---Para queries muy grandes se debe usar queryName="query" en lugar de query="#query#"--->
<cfsetting enablecfoutputonly="yes" requesttimeout="36000">
<cfset newline = Chr(13)&Chr(10)>
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

<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'QueryToFileXL')>
<cfset logFile = CreateObject('java', 'java.io.File').init(temporaryFileName)>
<cfset fw      = CreateObject('java', 'java.io.FileWriter').init(logFile)>
<cfset bw      = CreateObject('java', 'java.io.BufferedWriter').init(fw, 16383)>

<cfset bw.write('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">' & newline)>
<cfif FindNoCase(".xls",Attributes.filename)>
	<cfset bw.write('<html xmlns:o="urn:schemas-microsoft-com:office:office" ' & 'xmlns:x="urn:schemas-microsoft-com:office:excel" ' & 'xmlns="http://www.w3.org/TR/REC-html40">' & newline)>
	<cfset LvarExcel = true>
<cfelse>
	<cfset bw.write('<html>' & newline)>
	<cfset LvarExcel = false>
</cfif>

<cfset bw.write('<head><title># HTMLEditFormat( Attributes.titulo )#</title></head>' & newline)>
<cfset bw.write('<body>' & newline & '<table align="left">' & newline)>

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
	<cfset bw.write('<tr>')>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#"><!--- Debe ir PEGADO al CFLOOP ---><cfsilent>
		<!--- El CFSILENT evita que coldfusion acumule en memoria el espacio en
		blanco de este CFLOOP el número de iteraciones que encuentre --->
		<cfif LvarFileType[i] EQ "N">
			<cfset bw.write('<td align="right"><b>#LvarCols[i]#</b></td>')>
		<cfelseif LvarFileType[i] EQ "T">
			<cfset bw.write('<td align="center"><b>#LvarCols[i]#</b></td>')>
		<cfelseif LvarFileType[i] EQ "D">
			<cfset bw.write('<td align="center"><b>#LvarCols[i]#</b></td>')>
		<cfelse>
			<cfset bw.write('<td align="left"><b>#LvarCols[i]#</b></td>')>
		</cfif>
	</cfsilent><!--- Debe ir PEGADO al CFLOOP ---></cfloop>
	<cfset bw.write('</tr>#newline#')>
</cfif>

<cfloop query="LvarQuery"><!--- Debe ir PEGADO al CFLOOP ---><cfsilent>
	<!--- El CFSILENT evita que coldfusion acumule en memoria el espacio en
	blanco de este CFLOOP el número de iteraciones que encuentre --->
	<cfset bw.write('<tr>')>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
		<cfif Attributes.jdbc>
			<cfset LvarDato = LvarCols[i]>
		<cfelse>
			<cfset LvarDato = LvarQuery[LvarCols[i]]>
		</cfif>
		<cfif Not IsDefined('LvarDato')>
			<cfset LvarDato = ''>
		</cfif>
		<cfif LvarFileType[i] EQ "N">
			<cfset bw.write('<td align="right" x:num># HTMLEditFormat( Trim(LvarDato) )#</td>')>
		<cfelseif LvarFileType[i] EQ "T" And Len(LvarDato)>
			<cfset bw.write('<td align="center" x:date>#DateFormat(LvarDato,"YYYY-MM-DD")# #TimeFormat(LvarDato,"HH:MM:SS")#</td>')>
		<cfelseif LvarFileType[i] EQ "D" And Len(LvarDato)>
			<cfset bw.write('<td align="center" x:date>#DateFormat(LvarDato,"YYYY-MM-DD")#</td>')>
		<cfelse>
			<cfset bw.write('<td align="left" x:str>#HTMLEditFormat(Trim(LvarDato))#</td>')>
		</cfif>
	</cfloop>
	<cfset bw.write('</tr>' & newline)>
</cfsilent><!--- Debe ir PEGADO al CFLOOP ---></cfloop>
<cfset bw.write('</table></body></html>')>
<cfset res = bw.flush()>
<cfset res = bw.close()>
<cfif Attributes.jdbc>
	<cf_jdbcquery_close>
</cfif>
<cflog file="QueryToFile" text="FIN querytoFile #NOW()#">	
<cfheader name="Content-Disposition"	value="attachment;filename=#Attributes.filename#">
<cfcontent type="application/msexcel" reset="yes" file="#temporaryFileName#" deletefile="yes">