<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DESARROLLO dump</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
PRUEBAS DIRECTORIO DE SVN "
public/dump.cfm<br>
<cfif isdefined("url.setdebug")>
	<cfset session.debug = url.setdebug is '1'>
</cfif>

<cfif isdefined("url.dsn")>
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
		<cfinvokeargument name="refresh" value="yes">
	</cfinvoke>
</cfif>

<cfif isdefined("url.resetdsn")>
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" refresh="true">
</cfif>

<cfoutput>
OS #server.OS.Name#<cfif isdefined("server.OS.AdditionalInformation") AND trim(server.OS.AdditionalInformation) NEQ "">/#server.OS.AdditionalInformation#</cfif>
Version: #server.OS.Version#
<cfif isdefined("server.OS.Arch") AND trim(server.OS.Arch) NEQ ""> (#server.OS.Arch#)</cfif>
<br>
</cfoutput>

<cfset LvarSystem = CreateObject("java", "java.lang.System")>
<cfoutput>
Java Version: #LvarSystem.getProperty("java.version")#
(#LvarSystem.getProperty("java.vendor")#)
<br>
</cfoutput>

<cftry>
	<cfoutput>
	#server.coldfusion.productname# Version: #server.coldfusion.productversion# 
	<cfif isdefined("server.coldfusion.productlevel") AND trim(server.coldfusion.productlevel) NEQ ""> (#server.coldfusion.productlevel#)</cfif>
	<br>
	</cfoutput>
<cfcatch type="any"></cfcatch>
</cftry>

<cftry>
	<cfset jdbcDriver = CreateObject("java", "macromedia.jdbc.sqlserver.SQLServerDriver")>
	<cfoutput>
	Macromedia Drivers Version: #jdbcDriver.getMajorVersion()#.#jdbcDriver.getMinorVersion()#<br>
	</cfoutput>
<cfcatch type="any"></cfcatch>
</cftry>

<cftry>
	<cfquery name="rsSQL" datasource="asp">
		select <cf_dbfunction name="now"> as hora
		  from dual
	</cfquery>
	<cfset LvarHoraDB = createODBCdatetime(rsSQL.hora)>
<cfcatch type="any">
	<cfset LvarHoraDB = "<font style='color:##FF0000;'>asp: #cfcatch.Message# #cfcatch.Detail#</font>">
</cfcatch>
</cftry>
<cfoutput>
<table>
	<tr>
		<td>Hora Coldfusion:&nbsp;&nbsp;</td>
		<td>#createODBCdatetime(now())#</td>
	</tr>
	<tr>
		<td>Hora #application.dsinfo['asp'].type#:</td>
		<td>#LvarHoraDB#</td>
		<cfif isdate(LvarHoraDB) and abs(datediff("n",now(),LvarHoraDB))>
			<td><font style='color:##FF0000;'>&nbsp;&nbsp;Existen #abs(datediff("n",now(),LvarHoraDB))# minutos de diferencia</font></td>
		</cfif>
	</tr>
</table>
</cfoutput>

<cftry>
	<cfdump var="#session#" label="session">
<cfcatch type="any">
	<cfoutput>
	<cfdump var="#cfcatch.Message#" label="session">
	</cfoutput>
</cfcatch>
</cftry>
<cfdump var="#application#" label="application">
<cfdump var="#cgi#" label="cgi">
<cfdump var="#GetHTTPRequestData().headers#" label="http headers">
<cfdump var="#Server#" label="server">
</body>
</html>
