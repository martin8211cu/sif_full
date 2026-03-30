<cfquery datasource="#session.dsn#" name="rsDes">
	select AnexoDes
	from Anexo
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rs">
	select e.ACxml
		<cfif isdefined("url.xls")>
			,e.ACxls
		</cfif>
	from AnexoCalculo e
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	  and ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACid#">
	  and ACstatus = 'T'<!--- T = Terminado (P=Programado,C=Calculado) --->
	  and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, -1)
</cfquery>

<cfset filename = REReplace(rsDes.AnexoDes, '[^A-Za-z0-9]', '_', 'all')>
<cfheader name="Content-Disposition" value="Attachment; filename=#filename#.xls">

<cfif Len(rs.ACxml) LE 1>
	<cfcontent file="empty.xml" deletefile="no" type="application/vnd.ms-msexcel">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cfif isdefined("url.xls") and len(rs.ACxls) GT 0>
		<cffile action="write" file="#tempfile#" output="#rs.ACxls#" >
	<cfelse>
		<cffile action="write" file="#tempfile#" output="#rs.ACxml#" >
	</cfif>
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfcontent type="application/vnd.ms-excel" file="#tempfile#" deletefile="yes">
</cfif>
