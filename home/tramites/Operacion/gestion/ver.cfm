<cfquery datasource="#session.tramites.dsn#" name="rs">
	select contenido
	from TPRequisitoDoc
	where id_doc = 2
</cfquery>

<!--- </cfif> --->
<cfif not (Len(rs.contenido) EQ 0)>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.contenido#"  >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="application/msword" file="#tempfile#" deletefile="no">
	<!---<cfheader name="Content-Disposition" value="attachment;filename=#tempfile#" >--->
</cfif>