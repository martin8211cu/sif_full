<cfsetting enablecfoutputonly="yes">

<cftry>
	<cfparam name="session.FMT01COD" default="">
	<cfparam name="url.FMT01COD" default="#session.FMT01COD#">
	
	<cfquery datasource="#session.dsn#" name="enc">
		select FMT01imgfpre
		  from FMT001
		 where FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.FMT01COD#">
	</cfquery>
	
	<cfif Len(enc.FMT01imgfpre) GT 1>
		<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
		<cffile action="write" file="#tempfile#" output="#enc.FMT01imgfpre#" >
		<!--- nunca expira, invocar con ts_rversion como parte del url --->
		<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 1900 00:00:00 GMT")>
		<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
	<cfelse>
		<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 1900 00:00:00 GMT")>
		<cfset tempfile = getDirectoryFromPath(expandPath("*")) & "vacio.jpg">
		<cfcontent type="image/gif" file="#tempfile#">
	</cfif>
<cfcatch type="any">
	<cfoutput>error=1&msg=#URLEncodedFormat(cfcatch.Message & ' - ' & cfcatch.Detail)#</cfoutput>
</cfcatch>
</cftry>
