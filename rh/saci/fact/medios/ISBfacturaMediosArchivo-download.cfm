<cfparam name="url.f" default="FMEcontent">
<cfparam name="url.FMEarchivo" type="numeric">
<cfif url.f EQ 'FMEcontent'>
	<cfquery datasource="#session.dsn#" name="download_query">
		select FMEcontent, FMEnombre
		from ISBfacturaMediosArchivo
		where FMEarchivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FMEarchivo#">
	</cfquery>
	<cfheader name="Content-Disposition" value="attachment;filename=# REReplace(download_query.FMEnombre,'[^a-zA-Z0-9._-]', '_', 'all')#">
	<cfcontent variable="#download_query.FMEcontent#" reset="yes" type="application/octet-stream">
</cfif>
<cfheader statuscode="404" statustext="Download Not Found (ISBfacturaMediosArchivo)">

