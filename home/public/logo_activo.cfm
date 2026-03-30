<cfquery datasource="#session.dsn#" name="rs" maxrows="1">
	select AFimagen as logo
	from AFImagenes e
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
	and AFAlinea = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AFAlinea#">
</cfquery>

<cfif Len(rs.logo) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.logo#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfinclude template="../OnRequestEnd.cfm">
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>