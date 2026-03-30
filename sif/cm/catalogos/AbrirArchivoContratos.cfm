<cfquery name="rs" datasource="#session.DSN#">
	select OCextension, OCdato
	from ObjetosContrato
	where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OCid#">
		and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ECid#">
</cfquery>
<cfif Len(rs.OCdato) LTE 1>
	<cf_errorCode	code = "50001" msg = "No exite archivo almacenado en la Base de Datos...">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"archivos")>
	<cffile action="write" file="#tempfile#" output="#rs.OCdato#" >
	<cfheader name="Content-Disposition" value="Attachment;filename=archivo.#rs.OCextension#">
	<!--- Aquí se escoge el tipo de archivo para abrir según sea su extención --->
	<cfswitch expression="#lcase(trim(rs.OCextension))#">
		<cfcase value="txt">
			<cfcontent type="text/plain" file="#tempfile#" deletefile="yes" >
		</cfcase>
		<cfcase value="htm,html">
			<cfcontent type="text/html" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="pdf">
			<cfcontent type="application/pdf" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="doc">
			<cfcontent type="application/msword" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="xls">
			<cfcontent type="application/vnd.ms-excel" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="gif">
			<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfcase value="jpg">
			<cfcontent type="image/jpeg" file="#tempfile#" deletefile="yes">
		</cfcase>
		<cfdefaultcase>
			<cfcontent type="application/octect-stream" file="#tempfile#" deletefile="yes">
		</cfdefaultcase>
	</cfswitch>
</cfif>


