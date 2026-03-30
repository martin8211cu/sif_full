<cfquery datasource="#session.dsn#" name="rs" maxrows="1">
	select e.CDDdocumento
	from ClienteDetallistaDoc e
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
	  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDid#" >		
	  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#" >		
	  and CDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDDid#" >
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.CDDdocumento) LE 1>
	<cflocation url="blank.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.CDDdocumento#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
