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
<cfinclude template="export-function.cfm">

<cfquery name="rsEIEnc" datasource="sifcontrol">
	select
		EIcodigo,
		EIcfexporta
	from
		EImportador
	where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.fmt#">
</cfquery>

<!--- OPARRALES 2018-08-20 Archivo de dispersion a traves de un exportador
	- Validar la forma en como se hace esto para hacerlo dinamico
 --->
<cfif rsEIEnc.RecordCount gt 0 and FindNoCase('BANORTE',rsEIEnc.EIcodigo) GT 0>
	<cfinclude template="#rsEIEnc.EIcfexporta#">
<cfelse>
	<cfset temporaryfilename = exportar(url.fmt, url.html EQ 1, url.encabezar EQ 1, url)>
	<cfif url.html EQ 0>
		<cfheader name="Content-Disposition" value="attachment; filename=exportar.txt">
		<cfcontent type="text/plain" reset="yes" file="#temporaryFileName#" deletefile="yes">
	</cfif>
</cfif>