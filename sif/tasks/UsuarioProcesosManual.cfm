<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Actualizar Permisos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS.lll")#</cfoutput><br>
<!---
<cfschedule
	action="update"
	task="UsuarioProcesos"
	url="http://localhost/cfmx/sif/tasks/UsuarioProcesos.cfm"
	interval="86400"
	operation="httprequest"
	startdate="01/01/2004"
	starttime="1:00:00 AM">
--->

<!---
	Esta tarea debe verificar que no se invoque de manera
	muy frecuente, porque si se hace podría afectar de
	manera negativa el rendimiento del servidor o causar
	deadlocks
--->

<cfparam name="url.u" default="">

<cfquery datasource="asp" name="count1">
	select count(1) as registros from vUsuarioProcesos
</cfquery>
<cfflush interval="512">
Registros antes: <cfoutput>#count1.registros#</cfoutput><br><cfflush>
<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesosManual"
	method="actualizar">
	<!--- sin parametros actualiza todo --->
	<cfif Len(url.u)>
	<cfinvokeargument name="Usucodigo" value="#url.u#">
	</cfif>
</cfinvoke>
<cfset finish = Now()>

<cfquery datasource="asp" name="count2">
	select count(1) as registros from vUsuarioProcesos
</cfquery>

Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS.lll")#</cfoutput><br>
Duraci&oacute;n: <cfoutput>#DateDiff("s", start, finish)#</cfoutput>s<br>

Registros despu&eacute;s: <cfoutput>#count2.registros#</cfoutput><br>


</body>
</html>
