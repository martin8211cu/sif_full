<cfquery datasource="asp" name="rs">
	select e.SMlogo
	from SModulos e
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.SMlogo) EQ 0>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.SMlogo#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfinclude template="../OnRequestEnd.cfm">
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
