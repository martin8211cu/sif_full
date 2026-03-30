<cfquery datasource="#session.DSN#" name="rs" maxrows="1">
	select imagen
	from sa_imagenpersona
	where 2 > 1
	<cfif isdefined("url.id_persona")>
	  and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	</cfif>
</cfquery>

<cfif Len(rs.imagen) LE 0>
	<cflocation url="no_disponible.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.imagen#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
