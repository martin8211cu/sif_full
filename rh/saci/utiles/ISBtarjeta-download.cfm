<cfparam name="url.f" default="">
<cfparam name="url.MTid">

<cfif url.f EQ 'MTlogo'>
	<cfquery datasource="#session.dsn#" name="download_query">
		select MTlogo
		from ISBtarjeta
		where MTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.MTid#" null="#Len(url.MTid) Is 0#">
	</cfquery>
	<cfcontent variable="#download_query.MTlogo#" reset="yes" type="image/gif">
</cfif>

<cfheader statuscode="404" statustext="Download Not Found (ISBtarjeta)">
