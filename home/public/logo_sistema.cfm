<cfquery datasource="asp" name="rs">
	select e.SSlogo
	from SSistemas e
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.SSlogo) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.SSlogo#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
