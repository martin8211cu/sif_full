<cfquery datasource="asp" name="rs" maxrows="1">
	select <cfif isdefined("url.g")>SMNimagenGrande<cfelse>SMNimagenPequena</cfif> as SMNlogo
	from SMenues
	where SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n#">
</cfquery>
<!--- </cfif> --->
<cfif Len(rs.SMNlogo) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.SMNlogo#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfinclude template="../OnRequestEnd.cfm">
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
