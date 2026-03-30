<cfparam name="url.f" default="">
<cfparam name="url.EMid">
<cfif url.f EQ 'EMlogo'>
	<cfquery datasource="#session.dsn#" name="download_query">
		select EMlogo
		from ISBmedioCia
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EMid#" null="#Len(url.EMid) Is 0#">
	</cfquery>
	<cfcontent variable="#download_query.EMlogo#" reset="yes" type="image/gif">
</cfif>
<cfheader statuscode="404" statustext="Download Not Found (ISBmedioCia)">

