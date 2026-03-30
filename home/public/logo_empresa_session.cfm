<cfquery name="rsLogo" datasource="#session.DSN#">
	select Elogo,ts_rversion from Empresa where Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfif rsLogo.RecordCount GT 0 and isdefined("rsLogo.Elogo")>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rsLogo.Elogo#" >
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes"> 
</cfif>