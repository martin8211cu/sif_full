<cfsetting enablecfoutputonly="yes">
<!---

PARAMETROS:
	JASPER_FILE   Ruta relativa a /cfmx del archivo con extension .jasper
	DATASOURCE    Nombre del cache que se utiliza para ejecutar el reporte
	              Este cache se busca en el web application JasperReports (/jr),
				  no en Coldfusion, asi que debe existir en el application server
				  y en el web application.
    OUTPUT_FORMAT pdf,html,xls,csv
	Y todos los parámetros que requiera el reporte se ponen con cf_jasperparam

EJEMPLO:
<CF_JasperReport DATASOURCE="#session.dsn#"
                 OUTPUT_FORMAT="#form.formato#"
                 JASPER_FILE="/sif/cg/consultas/BalComp.jasper">
	<CF_JasperParam name="Ecodigo" value="#session.Ecodigo#">
	<CF_JasperParam name="moneda"  value="#form.Mcodigo#">
	<CF_JasperParam name="periodo" value="#form.periodo#">
	<CF_JasperParam name="mes" value="#form.mes#">
	<CF_JasperParam name="usuario" value="#session.usuario#">
</CF_JasperReport>
--->

<cfif ThisTag.ExecutionMode IS 'Start'>
<cfelseif ThisTag.ExecutionMode IS 'End'>
	<cfparam name="Attributes.JASPER_FILE"   type="string">
	<cfparam name="Attributes.DATASOURCE"    type="string" default="#session.dsn#">
	<cfparam name="Attributes.OUTPUT_FORMAT" type="string" default="pdf">
	<cfparam name="Attributes.debug"         type="boolean" default="no">
	<cfparam Name="ThisTag.parameters" default="#arrayNew(1)#">
	
	<cfif Attributes.debug>
		<cfoutput><table border="1" bordercolor="##000000" cellpadding="2" cellspacing="0">
			<tr><td colspan="2" style="background-color:##006699;color:##FFFFFF;font-weight:bold">CF_JASPERREPORT</td></tr>
			<tr><td><strong>JASPER_FILE</strong></td><td>#Attributes.JASPER_FILE#</td>
			<tr><td><strong>DATASOURCE</strong></td><td>#Attributes.DATASOURCE#</td>
			<tr><td><strong>OUTPUT_FORMAT</strong></td><td>#Attributes.OUTPUT_FORMAT#</td>
			<tr><td><strong>DEBUG</strong></td><td>#Attributes.DEBUG#</td>
			<cfloop from="1" to="#ArrayLen(ThisTag.parameters)#" index="i">
			<tr><td>#HTMLEditFormat( ThisTag.parameters[i].name  )#</td>
				<td>#HTMLEditFormat( ThisTag.parameters[i].value )#</td></tr>
			</cfloop>
			<tr><td colspan="2">Ejecuci&oacute;n cancelada.</td></tr>
			</tr></table>
		</cfoutput>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset args="JASPER_FILE=" & URLEncodedFormat( Attributes.JASPER_FILE ) &
		"&CONTEXT_ROOT=/cfmx" &
		"&DATASOURCE=" & URLEncodedFormat( Attributes.DATASOURCE ) &
		"&OUTPUT_FORMAT=" & URLEncodedFormat( Attributes.OUTPUT_FORMAT )>
	
	<cfloop from="1" to="#ArrayLen(ThisTag.parameters)#" index="i">
		<cfset args = args & 
			 "&" & URLEncodedFormat( ThisTag.parameters[i].name  ) &
			 "=" & URLEncodedFormat( ThisTag.parameters[i].value )>
	</cfloop>
	<cftransaction>
		<cfquery datasource="asp" name="newid">
			insert into ReporteFO(FOxml, FOcreado, FOusuario)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#args#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)
			<cf_dbidentity1 datasource="asp">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="newid">
	</cftransaction>
	
	<cflocation url="/jr/report.jsp?id=#newid.identity#&JASPER_FILE=#URLEncodedFormat(GetFileFromPath( Attributes.JASPER_FILE ))#" addtoken="no">
	<cflocation url="/jr/report.jsp?id=#newid.identity#" addtoken="no">
	<!--- para debug: 
	<cflocation url="/jr/report.jsp?id=#newid.identity#&JASPER_FILE=#URLEncodedFormat(GetFileFromPath( Attributes.JASPER_FILE ))#" addtoken="no">
	--->
	<!---
		NO USAMOS FRAMESET PORQUE EL PRINT / PRINT PREVIEW SALEN MAL 
		EN INTERNET EXPLORER / WIN32 / VERSION 6.0.3790.0
	
	<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
	<html>
	<head>
	<title>MiGestion</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<frame#""#set rows="*" frameborder="NO" border="0" framespacing="0">
	  <frame src="/jr/report.jsp?id=#newid.identity#" name="mainFrame">
	</frameset>
	</html>
	</cfoutput>
	--->
</cfif><!--- ThisTag.ExecutionMode IS 'End' --->