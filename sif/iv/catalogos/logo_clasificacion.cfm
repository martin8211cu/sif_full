<cfquery datasource="#session.DSN#" name="rs" maxrows="1">
	select e.Cbanner as Elogo
	from Clasificaciones e
	where 2 > 1
	<cfif isdefined("url.Ccodigo")>
	  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ccodigo#">
	</cfif>
  	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.Elogo) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">	
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.Elogo#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
