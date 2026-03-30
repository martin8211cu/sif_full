<cfset tempfile=''>
<cfparam name="url.ts" default="0">

<cfif isdefined("url.id")>
	<cfquery datasource="asp" name="rs" maxrows="1">
		select e.Ecodigo
		from Empresa e
		where  Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#"> 
	</cfquery>	
	<cfset url.EcodigoSDC=rs.Ecodigo>
</cfif>

<cfset tempfile=GetTempDirectory()&'imgEmp'&url.EcodigoSDC&url.ts&'.tmp'>

<cfif !fileExists(tempfile)>
	<cfquery datasource="asp" name="rs" maxrows="1">
		select e.Elogo
		from Empresa e
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EcodigoSDC#">
	</cfquery> 
	<cfif Len(rs.Elogo) LE 1>
		<cflocation url="not_avail.gif" addtoken="no">
	<cfelse> 
		<cffile action="write" file="#tempfile#" output="#rs.Elogo#" >
	</cfif>	
</cfif>
<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfcontent type="image/gif" file="#tempfile#">  


