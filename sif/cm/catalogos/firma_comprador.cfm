<cfquery datasource="#session.DSN#" name="rs" maxrows="1">
	select CMFfirma
	from CMFirmaComprador
	where 2 > 1
	<cfif isdefined("url.CMCid")>
	  and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMCid#">
	</cfif>
</cfquery>

<!--- </cfif> --->
<cfif Len(rs.CMFfirma) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.CMFfirma#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
