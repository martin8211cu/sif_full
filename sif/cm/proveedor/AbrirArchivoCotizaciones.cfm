
<cfquery name="rs" datasource="#url.cncache#">
	select DDAextension, DDAdocumento
	from DDocumentosAdjuntos
	where DDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DDAid#">
		and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DSlinea1#">		
</cfquery>

<cfif Len(rs.DDAdocumento) LE 1>
	<cf_errorCode	code = "50001" msg = "No exite archivo almacenado en la Base de Datos...">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"archivos")>
	<cffile action="write" file="#tempfile#" output="#rs.DDAdocumento#" >
		
	<!--- Aquí se escoge el tipo de archivo para abrir según sea su extención --->
	<cfswitch expression="#lcase(trim(rs.DDAextension))#">
		<cfcase value="txt">
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
			<cfcontent type="text/html" file="#tempfile#" deletefile="yes">
		</cfdefaultcase>
	</cfswitch>
</cfif>


