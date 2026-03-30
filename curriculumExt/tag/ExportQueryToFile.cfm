<!--- 
	Creado por GustavoF/MarcelM
		Fecha: 18-5-2006.
		Motivo: Nuevo tag que soporte el parámetro de "separador"
 --->

<cfsetting 	enablecfoutputonly="yes" requesttimeout="1800">
<cfparam name="Attributes.titulo" 		default="Reporte de Pagos a Terceros">
<cfparam name="Attributes.jdbc" type="boolean" default="false">
<cfparam name="Attributes.separador" default="">

<cfset fnExportaDatosQueryToFile()>

<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfheader name="Content-Disposition"	value="attachment;filename=#Attributes.filename#">
<cfif FindNoCase(".xls",Attributes.filename)>
	<cfcontent type="application/msexcel" reset="yes" file="#temporaryFileName#" deletefile="yes">
<cfelseif FindNoCase(".txt",Attributes.filename)>
	<cfcontent type="text/plain" reset="yes" file="#temporaryFileName#" deletefile="yes">
</cfif>	 

<cffunction name="write_to_buffer" output="no">
    <cfargument name="contents" type="string" required="yes">
    <cfargument name="flush" type="boolean" default="no">
    <cfset buffer.append(Arguments.contents)>
    <cfif Arguments.flush Or (buffer.length() GE 16383)>
        <cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no">
        <cfset buffer.setLength(0)>
    </cfif>
</cffunction>

<cffunction name="fnExportaDatosQueryToFile" access="private" output="no" returntype="any">
	<cfset newline = Chr(13) & Chr(10)>
	<cfset nada = ''>
	
	<cfset buffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 32768 ))>
	<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'QueryToFileXL')>
	<cffile action="write" file="#temporaryFileName#" output="" addnewline="no">
	<cfif not len(Attributes.separador)>
		<cfset write_to_buffer('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">' & newline)>
	</cfif>
	<cfif FindNoCase(".xls",Attributes.filename)>
		<cfset write_to_buffer('<html xmlns:o="urn:schemas-microsoft-com:office:office" ' & 
			'xmlns:x="urn:schemas-microsoft-com:office:excel" ' &
			'xmlns="http://www.w3.org/TR/REC-html40">' & newline)>
		<cfset LvarExcel = true>
	<cfelseif not len(Attributes.separador)>
		<cfset write_to_buffer('<html>' & newline)>
		<cfset LvarExcel = false>
	</cfif>
	
	<cfif not len(Attributes.separador)>
		<cfset write_to_buffer('<head><title># HTMLEditFormat( Attributes.titulo )#</title></head>' & newline)>
		<cfset write_to_buffer('<body>' & newline & '<table align="left">' & newline)>
	</cfif>
	
	<cfif Attributes.jdbc>
		<cfset LvarCols = ArrayNew(1)>
		<cfloop from="1" to="#Attributes.query.getMetaData().getColumnCount()#" index="i">
			<cfset LvarCols[i] = Attributes.query.getMetaData().getColumnLabel( JavaCast("int", i))>
		</cfloop>
	<cfelse>
		<cfset LvarCols = Attributes.query.getColumnNames()>
	</cfif>
	<cfset LvarFileType = arrayNew(1)>
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
		<cfif Attributes.jdbc>
			<cfset LvarJavaType = Attributes.query.getMetaData().getColumnClassName(JavaCast("int", i))>
		<cfelse>
			<cfset LvarJavaType = evaluate("Attributes.query.#LvarCols[i]#").getClass().getName()>
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
	</cfloop>
	
	<cfif not len(Attributes.separador)>
		<cfset write_to_buffer('<tr>')>
	</cfif>
	
	<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
		<cfif not len(Attributes.separador)>
			<cfif LvarFileType[i] EQ "N">
				<cfset write_to_buffer('<td align="right"><b>#LvarCols[i]#</b></td>')>
			<cfelseif LvarFileType[i] EQ "T">
				<cfset write_to_buffer('<td align="center"><b>#LvarCols[i]#</b></td>')>
			<cfelseif LvarFileType[i] EQ "D">
				<cfset write_to_buffer('<td align="center"><b>#LvarCols[i]#</b></td>')>
			<cfelse>
				<cfset write_to_buffer('<td align="left"><b>#LvarCols[i]#</b></td>')>
			</cfif>
		<cfelse>	
			<cfset write_to_buffer('#Htmleditformat(LvarCols[i])#'&#Attributes.separador#)>
			<!--- <cfset write_to_buffer('#Htmleditformat(LvarCols[i])##Attributes.separador#')> --->
		</cfif>
	</cfloop>
	<cfif not len(Attributes.separador)>
		<cfset write_to_buffer('</tr>#newline#')>
	<cfelse>
		<cfset write_to_buffer('#newline#')>
	</cfif>	
		
	<cfloop query="Attributes.query">
		<cfif not len(Attributes.separador)>
			<cfset write_to_buffer('<tr>')>
		</cfif>
		<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
			<cfif Attributes.jdbc>
				<cfset LvarDato = evaluate("#LvarCols[i]#")>
			<cfelse>
				<cfset LvarDato = evaluate("Attributes.query.#LvarCols[i]#")>
			</cfif>
			<cfif Not IsDefined('LvarDato')>
				<cfset LvarDato = ''>
			</cfif>
			<cfif LvarFileType[i] EQ "N">
				<cfif not len(Attributes.separador)>
					<cfset write_to_buffer('<td align="right" x:num># HTMLEditFormat( Trim(LvarDato) )#</td>')>
				<cfelse>
					<cfset write_to_buffer('#HTMLEditFormat(Trim(LvarDato))#'&#Attributes.separador#)>
				</cfif>
			<cfelseif LvarFileType[i] EQ "T" And Len(LvarDato)>
				<cfif not len(Attributes.separador)>
					<cfset write_to_buffer('<td align="center" x:date>#DateFormat(LvarDato,"YYYY-MM-DD")# #TimeFormat(LvarDato,"HH:MM:SS")#</td>')>
				<cfelse>
					<cfset write_to_buffer('#DateFormat(LvarDato,"YYYY-MM-DD")# #TimeFormat(LvarDato,"HH:MM:SS")#'&#Attributes.separador#)>
				</cfif>
			<cfelseif LvarFileType[i] EQ "D" And Len(LvarDato)>
				<cfif not len(Attributes.separador)>
					<cfset write_to_buffer('<td align="center" x:date>#DateFormat(LvarDato,"YYYY-MM-DD")#</td>')>
				<cfelse>
					<cfset write_to_buffer('#DateFormat(LvarDato,"YYYY-MM-DD")#'&#Attributes.separador#)>
				</cfif>
			<cfelse>
				<cfif not len(Attributes.separador)>
					<cfset write_to_buffer('<td align="left" x:str>#HTMLEditFormat(Trim(LvarDato))#</td>')>
				<cfelse>
					<cfset write_to_buffer('#HTMLEditFormat(Trim(LvarDato))#'&#Attributes.separador#)>
				</cfif>
			</cfif>
		</cfloop>
		<cfif not len(Attributes.separador)>
			<cfset write_to_buffer('</tr>' & newline)>
		<cfelse>
			<cfset write_to_buffer(newline)>
		</cfif>
	</cfloop>
	 <cfif not len(Attributes.separador)>
		<cfset write_to_buffer('</table></body></html>', true)>
	<cfelse>
		<cfset write_to_buffer('', true)>
	</cfif>
	
	<cfif Attributes.jdbc>
		<cf_jdbcqueryEXT_close>
	</cfif>
	
	<!--- Ninguno de estos caracteres puede ser usado en un nombre de archivo--->
	<cfset Attributes.filename = replace(Attributes.filename,":","_","all")>
	<cfset Attributes.filename = replace(Attributes.filename,"|","_","all")>
	<cfset Attributes.filename = replace(Attributes.filename,'"','_','all')>
	<cfset Attributes.filename = replace(Attributes.filename,"?","_","all")>
	<cfset Attributes.filename = replace(Attributes.filename,"¿","_","all")>
	<cfset Attributes.filename = replace(Attributes.filename,"\","_","all")>
	<cfset Attributes.filename = replace(Attributes.filename,"/","_","all")>
	<cfset Attributes.filename = replace(Attributes.filename,"*","_","all")>
</cffunction>