<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Proceso de Vacaciones y Días de Enfermedad</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Proceso de Vacaciones y Días de Enfermedad<br>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>

<cfset registros = 0 >

<cfinclude template="../../rh/vacaciones/calculoVacaciones.cfm">

<cfset finish = Now()>
Registros insertados: <cfoutput>#registros#</cfoutput><br>
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
</body>
</html>