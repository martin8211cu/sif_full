<!---
	Evitar la validación del usuario.
--->
<cfset Request.Validar = False>
<cfinclude template="/saci/ws/Application.cfm">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>JMS Task</title>
</head>

<body>
<cfoutput>
Procesando...
<a href="isb_jmstask.cfm?stop=1">stop</a> | 
<a href="isb_jmstask.cfm?start=1">start</a> | 
<a href="isb_jmstask.cfm?refresh=1">refresh</a>
#RepeatString(' ', 1024)#<hr />
<cfflush>

<cfif IsDefined('url.stop')>
	<cfset server.stopjms = true>
<cfelse>
	<cflog file="jmsclient" text="inicia tarea">
	<cfsetting requesttimeout="3600"><!--- una hora --->
	<cfset start = GetTickCount()>
	<cfif IsDefined('server.jmsclient_cfc') and IsDefined('url.refresh')>
		<cflog file="jmsclient" text="refresh:server.jmsclient_cfc.disconnect">
		<cfset server.jmsclient_cfc.disconnect()>
		<cfset StructDelete(server, 'jmsclient_cfc')>
	</cfif>
	<cfif (Not IsDefined('url.refresh')) And IsDefined('server.jmsclient_cfc')>
		<cflog file="jmsclient" text="refresh:reuse server.jmsclient_cfc">
		<cfset jmsclient = server.jmsclient_cfc>
	<cfelse>
		<cflog file="jmsclient" text="refresh:create server.jmsclient_cfc">
		<cfset jmsclient = CreateObject('component', 'saci.ws.gateway.jmsclient')>
		<cfset server.jmsclient_cfc = jmsclient>
	</cfif>
	<cfset messageCount = jmsclient.procesar()>
	<cfset millis = GetTickCount() - start>
	Total: #NumberFormat(millis, ',0')# millis<br />
	Messages: #NumberFormat(messageCount, ',0')#<br />
	<cflog file="jmsclient" text="Total: #NumberFormat(millis, ',0')# millis">
	<cflog file="jmsclient" text="Messages: #NumberFormat(messageCount, ',0')#">
	<cfif messageCount>
		Promedio: #NumberFormat(millis / messageCount, ',0')# millis / mensaje<br />
		<cflog file="jmsclient" text="Promedio: #NumberFormat(millis / messageCount, ',0')# millis / mensaje">
	</cfif>
</cfif>
</cfoutput>
</body>
</html>
