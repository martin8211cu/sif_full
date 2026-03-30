<cfquery datasource="#session.dsn#" name="rs">
	set rowcount 1
	select img_foto
	from Clasificaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tid#">
	  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	set rowcount 0
</cfquery>
<cfif rs.RecordCount EQ 0 or Len(rs.img_foto) EQ 0>
	<cflocation url="images/blank.gif">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.img_foto#" >
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>