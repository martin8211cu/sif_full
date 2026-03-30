<cfparam name="url.id_inst" default="0">
<cfquery datasource="#session.tramites.dsn#" name="rs">
	select logo_inst
	from TPInstitucion e
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_inst#">
</cfquery>

<cfif Len(rs.logo_inst) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.logo_inst#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
