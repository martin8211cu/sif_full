<cfsetting requesttimeout="120">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Borrar Historia</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
* { font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px; }
</style>
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br><br>
<!---
<cfschedule 
	action="update" 
	task="BorrarHistoria"
	url="http://localhost/cfmx/sif/tasks/BorrarHistoria.cfm"
	interval="86400"
	operation="httprequest"
	startdate="08/08/2003"
	starttime="12:00:00 PM">
--->

<cfinvoke component="home.Componentes.BorrarHistoria" method="BorrarHistoria">
</cfinvoke>

<cfset finish = Now()>
<br> 
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
</body>
</html>