<cfsetting enablecfoutputonly="yes">
<cftry>
	<cfparam name="url.Ecodigo" default="0">
	<cfparam name="url.EcodigoSDC" default="0">
	
    <cfquery datasource="asp" name="rs" maxrows="1">
        select e.Elogo
        from Empresa e
        where 2 > 1
        and Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ecodigo#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EcodigoSDC#">
    </cfquery>
    
    <cfif Len(rs.Elogo) LE 1>
        <cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 1900 00:00:00 GMT")>
		<cfset tempfile = getDirectoryFromPath(expandPath("*")) & "vacio.jpg">
		<cfcontent type="image/gif" file="#tempfile#">
    <cfelse>
        <!---<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
		<cffile action="write" file="#tempfile#" output="#rs.Elogo#" >
		<!--- nunca expira, invocar con ts_rversion como parte del url --->
		<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 1900 00:00:00 GMT")>
		<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">--->
        <cfcontent reset="yes" type="image/gif" variable="#rs.Elogo#">
    </cfif>
<cfcatch type="any">
	<cfoutput>error=1&msg=#URLEncodedFormat(cfcatch.Message & ' - ' & cfcatch.Detail)#</cfoutput>
</cfcatch>
</cftry>
