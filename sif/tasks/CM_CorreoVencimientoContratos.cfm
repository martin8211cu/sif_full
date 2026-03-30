	<cfapplication name="SIF_ASP" 
	sessionmanagement="No"
	clientmanagement="No"
	setclientcookies="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Proceso de Envio de correos de vencimiento de contratos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Proceso de Envio de Correos de Vencimiento de Contratos<br>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>

<cfset registros = 0 >

<cfinclude template="../cm/operacion/EnvioCorreosVencimientoContratos.cfm"> 

<cfset finish = Now()>
Registros insertados: <cfoutput>#registros#</cfoutput><br>
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
</body>
</html>