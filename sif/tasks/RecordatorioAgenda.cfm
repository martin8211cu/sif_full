<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Env&iacute;o automatizado de recodatorios</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<!---
<cfschedule 
	action="update" 
	task="RecordatorioAgenda"
	url="http://localhost/cfmx/sif/tasks/RecordatorioAgenda.cfm"
	interval="120"
	operation="httprequest"
	startdate="08/08/2003"
	starttime="12:00:00 PM">
--->

<cfinvoke component="home.Componentes.Agenda" method="NotificarEmail" returnvariable="cant">
 
<cfoutput>
Se enviaron #cant# recordatorios
</cfoutput> 
</body>
</html>
