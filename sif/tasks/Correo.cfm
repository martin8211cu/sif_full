<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Enviar Correos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>
<!---
<cfschedule 
	action="update" 
	task="Correo"
	url="http://localhost/cfmx/sif/tasks/Correo.cfm"
	interval="120"
	operation="httprequest"
	startdate="08/08/2003"
	starttime="12:00:00 PM">
--->

<cfinvoke component="asp.admin.correo.SMTPQueue" method="lote" returnvariable="msgs">
<cfinvokeargument name="maxmsgs" value="50">
</cfinvoke>

<cfset finish = Now()>
Correos enviados: <cfoutput>#msgs#</cfoutput><br>
<cfquery datasource="asp" name="pend">
	select count(*) as p from SMTPQueue
</cfquery>
<cfquery datasource="asp" name="errs">
	select count(*) as p from SMTPQueue where SMTPintentos != 0
</cfquery>
Correos con error: <cfoutput>#errs.p#</cfoutput><br>
Correos pendientes: <cfoutput>#pend.p#</cfoutput><br>
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
<cfif msgs neq 0>
Promedio por mensaje: <cfoutput>#DateDiff("s", start, Now()) / msgs#</cfoutput> s<br>
</cfif>
</body>
</html>