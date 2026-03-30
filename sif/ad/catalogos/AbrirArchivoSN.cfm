<!--- <cfdump var="#form#"> --->
<cfquery name="rs" datasource="#session.DSN#">
	select SNOcontenttype, SNOcontenido, SNOarchivo
	from SNegociosObjetos
	where SNOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNOid#">
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
</cfquery>
<cfif Len(rs.SNOcontenido) LE 1>
	<cf_errorCode	code = "50001" msg = "No exite archivo almacenado en la Base de Datos...">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"archivos")>
	<cffile action="write" file="#tempfile#" output="#rs.SNOcontenido#" >
	<cfset fileName = #rs.SNOarchivo#>
<!--- 	<cf_dump var="#fileName#"> --->
	<cfheader name="Content-Disposition" value="inline; filename=""#rs.SNOarchivo#""">
	<!--- Aquí se escoge el tipo de archivo para abrir según sea su extención --->
	<cfswitch expression="#lcase(trim(rs.SNOcontenttype))#">
		<cfcase value="txt">
			<cfcontent type="text/plain" file="#tempfile#" deletefile="yes" >
		</cfcase>
		<cfcase value="htm,html">
			<cfcontent type="text/html" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="pdf">
			<cfcontent type="application/pdf" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="doc,docx">
			<cfcontent type="application/msword" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="xls,xlsx">
			<cfcontent type="application/vnd.ms-excel" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="gif">
			<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="jpg,png">
			<cfcontent type="image/jpeg" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfdefaultcase>
			<cfcontent type="application/octect-stream" file="#tempfile#" deletefile="yes">
		</cfdefaultcase>
	</cfswitch>
</cfif>


