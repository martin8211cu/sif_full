<cfquery datasource="#session.DSN#" name="rs">
	<cfif isDefined("url.DEid")>
		select e.foto
		from RHImagenEmpleado e
		where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	<cfelse>	
		select e.foto
		from RHImagenOferente e
		where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHOid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfif>
</cfquery>


<cfif Len(rs.foto) gt 1>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cfset tempfile = tempfile & '.jpg'>
	<cffile action="write" file="#tempfile#" output="#rs.foto#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<!--- <cf_dump var="#tempfile#"> --->
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
