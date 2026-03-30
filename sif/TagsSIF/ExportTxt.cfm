<cfsetting 	enablecfoutputonly="yes" requesttimeout="1800">
<cfparam name="Attributes.titulo" 		default="Reporte a Terceros">
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
        <cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#" addnewline="no" charset="utf-8">
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
	<cfset LvarCols = Attributes.query.getColumnNames()>
	<cfset LvarFileType = arrayNew(1)>
	<cfset write_to_buffer('#newline#')>
		
	<cfloop query="Attributes.query">
		<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
			<cfset LvarDato = evaluate("Attributes.query.#LvarCols[i]#")>
			<cfif #arrayLen(LvarCols)# EQ #i#>	
				<cfset write_to_buffer('#HTMLEditFormat(Trim(LvarDato))#')>
			<cfelse>
				<cfset write_to_buffer('#HTMLEditFormat(Trim(LvarDato))#'&#Attributes.separador#)>
			</cfif>			
		</cfloop>
		<cfset write_to_buffer(newline)>
	</cfloop>
		<cfset write_to_buffer('', true)>
	<cfif Attributes.jdbc>
		<cf_jdbcquery_close>
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