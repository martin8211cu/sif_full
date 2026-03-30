<cfparam name="url.LFlote" type="numeric">

<cfquery datasource="#session.dsn#" name="ISBfacturaMedios">
	select LFnumero
	from ISBfacturaMedios
	where LFlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LFlote#">
</cfquery>



<cfheader name="Content-Disposition" value="attachment; filename=DTETRA900#ISBfacturaMedios.LFnumero#.txt">
<cfsetting enablecfoutputonly="yes">
<cfcontent type="text/plain" reset="yes">

<cfinvoke component="saci.comp.facturaMedios" method="generarArchivoTrafico"
	dsn="#session.dsn#"
	LFlote="#url.LFlote#"
	generarVariable="false" />
