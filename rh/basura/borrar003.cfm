<cfquery name="qryUsuarios" datasource="asp">
	select u.Usucodigo, dp.Pnombre, dp.Papellido1, dp.Papellido2
	from Usuario u, DatosPersonales dp
	where u.datos_personales = dp.datos_personales
	and u.CEcodigo = 15
	and Usucodigo < 100
</cfquery>
<cfset stUsuario = structNew()>
<cfset stUsuarios = structNew()>
<cfloop query="qryUsuarios">
	<!--- Crea un usuario --->
	<cfset stUsuario["codigo"] = Usucodigo>
	<cfset stUsuario["nombre"] = Pnombre>
	<cfset stUsuario["apellido1"] = Papellido1>
	<cfset stUsuario["apellido2"] = Papellido2>
	<!--- Lo agrega en la lista --->
	<cfset stUsuarios[Usucodigo] = duplicate(stUsuario)>
</cfloop>
<cfscript>
	StructSort(stUsuarios, "numeric", "asc", "codigo");
</cfscript>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Structures</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfdump var="#stUsuarios#">
</body>
</html>
