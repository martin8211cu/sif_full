<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfset Session.CEcodigo = 3>
<cfinvoke 
 component="edu.Componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="Nivel"/>
	<cfinvokeargument name="columnas" value="Ncodigo, Ndescripcion"/>
	<cfinvokeargument name="desplegar" value="Ncodigo, Ndescripcion"/>
	<cfinvokeargument name="etiquetas" value="Ncodigo, Ndescripcion"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="untitled7.cfm"/>
	<cfinvokeargument name="Conexion" value="educativo"/>
	<cfinvokeargument name="botones" value="Nuevo"/>
</cfinvoke>

</body>
</html>
