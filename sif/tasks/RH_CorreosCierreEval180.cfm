<cfapplication name="SIF_ASP" 
	sessionmanagement="No"
	clientmanagement="No"
	setclientcookies="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Proceso de Envío de correos de Cierre de Evaluación del Nuevo Sistema de Evaluación</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Proceso de Envío de correos de Cierre de Evaluación del Nuevo Sistema de Evaluación<br>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>

<cfset registros = 0 >

<cfinclude template="../rh/evaluaciondes/evaluacion180/operacion/EnvioCorreosCierreEval180.cfm"> 

<cfset finish = Now()>
Registros insertados: <cfoutput>#registros#</cfoutput><br>
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
</body>
</html>