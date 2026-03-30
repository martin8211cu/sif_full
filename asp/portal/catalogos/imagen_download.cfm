<cfquery datasource="asp" name="rs">
	set rowcount 1
	select CElogo as logo
	from CuentaEmpresarial
	where CEcodigo=15
	  and datalength (CElogo) > 1
	set rowcount 0
</cfquery>

<!--- </cfif> --->
<cfif rs.RecordCount EQ 0>
	<cflocation url="../images/not_avail.gif">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.logo#" >
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
