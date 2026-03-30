<cfquery datasource="#session.dsn#" name="rs">
	select e.PRJarchivo
	from PRJproyecto e
	where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.PRJarchivo) LE 1>
	<cf_errorCode	code = "50561" msg = "El archivo no esta disponible">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.PRJarchivo#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2002 00:00:00 GMT")>
	<cfcontent type="application/vnd.ms-project " file="#tempfile#" deletefile="yes">
</cfif>


