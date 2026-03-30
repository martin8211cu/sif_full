<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>IN_TransformacionProducto2</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.Ecodigo = 37>
<cfset session.dsn = "sif_pmi_pruebas">
<cfset session.usucodigo = 336>
<cfset fecinic = Now()>
<cfinvoke 
	Component="sif.Componentes.IN_TransformacionProducto2" 
	method="IN_TransformacionProducto2"
	ETid="205"
	Debug = "false"
	RollBack = "true"
	returnvariable="resultados"
/>
<cfset fecfin = Now()>
</head>
<body>
<cfoutput>
	<p>
		Prueba del Componente IN_TransformacionProducto2<br>
		Inicio de la prueba : #fecinic#<br>
		Fin de la prueba : #fecfin#<br>
		Duraci&oacute;n : #fecfin-fecinic#<br>
	</p>
	<h2>
		Resultados
	</h2>
</cfoutput>
<cfdump var="#resultados#">
<a href="/cfmx/sif/iv/operacion/Transforma.cfm">aaa</a>
</body>
</html>