<!---
	Realiza la exportacion
	Parámetros:
		form.fmt	( requerido ) Número de formato, EImportador.EIid
	Se limita el procesamiento a 5 minutos (300 segundos)
--->


<cfsetting requesttimeout="300">
<cfsetting enablecfoutputonly="yes">

<cfparam name="url.fmt" type="numeric" default="0">
<cfparam name="url.html" type="numeric" default="0">
<cfparam name="url.encabezar" type="numeric" default="0">
<cfparam name="url.codigo" type="string" default="">
<cfparam name="url.Tcodigo" type="string" default="">
<cfparam name="url.CPdesde" type="string" default="">

<cfinclude template="export-function.cfm">

<cfset filename= trim(url.codigo) & '-' & trim(url.Tcodigo) & '-' & trim(url.CPdesde)>

<cfset temporaryfilename = exportar(url.fmt, url.html EQ 1, url.encabezar EQ 1, url)>

<cfif url.html EQ 0>
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.txt">
	<cfcontent type="text/plain" reset="yes" file="#temporaryFileName#" deletefile="yes">
</cfif>
