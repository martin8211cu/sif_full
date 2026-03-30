<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_ref"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="5"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="referencias" value="2"/>
	<cfinvokeargument name="roles" value="edu.asistente"/>
	<cfinvokeargument name="addCols" value="pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail"/>
	<cfinvokeargument name="addTables" value="educativo..Asistente ast, educativo..PersonaEducativo pe"/>
	<cfinvokeargument name="addWhere" value="ast.Acodigo = a.num_referencia and ast.persona = pe.persona"/>
</cfinvoke>

<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_ref"
 returnvariable="usr2">
	<cfinvokeargument name="consecutivo" value="12"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="referencias" value="ast.EEcodigo"/>
	<cfinvokeargument name="roles" value="edu.encargado"/>
	<cfinvokeargument name="addCols" value="pe.Pnombre+' '+pe.Papellido1+' '+pe.Papellido2 as NombreDestino, pe.Pemail1 as eMail"/>
	<cfinvokeargument name="addTables" value="educativo..Encargado ast, educativo..PersonaEducativo pe"/>
	<cfinvokeargument name="addWhere" value="ast.EEcodigo = 422 and ast.persona = pe.persona"/>
</cfinvoke>


<cfdump var="#usr#">
<cfdump var="#usr2#">

<cfquery dbtype="query" name="temp">
	select Usucodigo from usr
	union
	select Usucodigo from usr2
</cfquery>

<cfdump var="#temp#">

</body>
</html>
