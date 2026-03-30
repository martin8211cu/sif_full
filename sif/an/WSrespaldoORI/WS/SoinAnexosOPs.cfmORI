<cfsetting enablecfoutputonly="yes" showdebugoutput="no">
<cfapplication name="SIF_ASP" sessionmanagement="yes">
<cfif cgi.SERVER_PORT_SECURE EQ 1>
	<cfset LvarANserver		="https://#session.sitio.host#">
<cfelse>
	<cfset LvarANserver		="http://#session.sitio.host#">
</cfif>
<cfparam name="url.WSkey" default="EOF">
<cfset LvarANwskey = url.WSkey>
<cfset LvarANoperation	= url.XLOP>
<cfif not isdefined("Application.Anexos.#LvarANwskey#")>
	<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<script language="javascript">
	alert ("No tiene autorización para inicializar la comunicación con el Servidor");
	window.close();
</script>
</body>
</html>
	<cfabort>
	</cfoutput>
</cfif>

<cfif url.XLOP eq "UPLOAD">
	<cfquery name="rsAnexo" datasource="#session.DSN#">
		select AnexoDes
		  from Anexo
		 where AnexoId 	= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#url.AnexoId#">
	</cfquery>
	<cfset LvarRows = 4>
	<cfset LvarANdetalle	=
'	<Row>
		<Cell><Data ss:Type="String">#url.AnexoId#</Data></Cell>
		<Cell><Data ss:Type="String">1</Data></Cell>
		<Cell><Data ss:Type="String">N/A</Data></Cell>
		<Cell><Data ss:Type="String">#rsAnexo.AnexoDes#</Data></Cell>
	</Row>'>
	<cfset Application.Anexos[LvarANwskey].IDS = arrayNew(1)>
	<cfset Application.Anexos[LvarANwskey].IDS[1] = url.AnexoId>
<cfelseif url.XLOP eq "CONSULTAR">
	<cfset LvarRows = 4>
	<cfset LvarANdetalle	=
'	<Row>
		<Cell><Data ss:Type="String">#url.AnexoId#</Data></Cell>
		<Cell><Data ss:Type="String">1</Data></Cell>
		<Cell><Data ss:Type="String">N/A</Data></Cell>
		<Cell><Data ss:Type="String">#rsAnexo.AnexoDes#</Data></Cell>
	</Row>'>
	<cfset Application.Anexos[LvarANwskey].IDS = arrayNew(1)>
	<cfset Application.Anexos[LvarANwskey].IDS[1] = url.AnexoId>
<cfelseif url.XLOP eq "CALCULAR">
	<cfset LvarANdetalle	= session.anexos.LvarANdetalle>
	<cfset session.anexos.LvarANdetalle = "">
	<cfset Application.Anexos[LvarANwskey].IDS = session.anexos.LvarIDS>
	<cfset LvarRows = arrayLen(session.anexos.LvarIDS)+3>
</cfif>

<cfheader name="Content-Disposition" value="Attachment;filename=SoinAnexosOPs.xml">
<cfheader name="Expires" value="0">
<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfcontent type="application/vnd.ms-excel">
<cfinclude template="SoinAnexosOPs_XML.cfm">