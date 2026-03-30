<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="refresh" content="60;" >
<title>Cerrar Ventanillas Inactivas</title>
</head>

<body>

<cfoutput>#now()#</cfoutput>
<cfset ventanilla = createobject('component', 'home.tramites.componentes.ventanilla') >

<cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario)) and isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))>
	<cfset ventanilla.ping(session.tramites.id_funcionario, session.tramites.id_ventanilla) >
</cfif>
 
</body>
</html>
