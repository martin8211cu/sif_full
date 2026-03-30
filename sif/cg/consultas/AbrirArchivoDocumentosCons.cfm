<cfquery name="rs" datasource="#session.DSN#">
	select ECScontenttype, ECScontenido, ECStexto, ECStipo
	from EContableSoporte
	where IDdocsoporte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdocsoporte#">
		and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDcontable#"> 
</cfquery>

<cfif rs.ECStipo EQ 0>
	<table width="98%" cellpadding="0" cellspacing="0">
		<!---<tr><td><strong>Texto :</strong></td></tr>---->
		<tr><td><cfoutput>#rs.ECStexto#</cfoutput></td></tr>
	</table>
<cfelse>
	<cfif Len(rs.ECScontenido) LE 1><!---rs.DDAdocumento---->
		<cf_errorCode	code = "50001" msg = "No exite archivo almacenado en la Base de Datos...">
	<cfelse>
		<cfset tempfile = GetTempFile(GetTempDirectory(),"archivos")>
		<cffile action="write" file="#tempfile#" output="#rs.ECScontenido#" >
			
		<!--- Aquí se escoge el tipo de archivo para abrir según sea su extención --->
		<cfswitch expression="#lcase(trim(rs.ECScontenttype))#">
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
</cfif>


