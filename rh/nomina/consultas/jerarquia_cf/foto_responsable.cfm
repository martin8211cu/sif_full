<cfquery datasource="#session.DSN#" name="rs">
	select e.foto
	from RHImagenEmpleado e
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.s#">
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.foto) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.foto#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<!---<cfinclude template="../OnRequestEnd.cfm">--->
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
