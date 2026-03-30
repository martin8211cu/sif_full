<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>IN_PosteoRequis</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.Ecodigo = 1>
<cfset session.dsn = "minisif">
<cfset session.usucodigo = 27>
<cfset fecinic = Now()>
<cfinvoke Component="sif.Componentes.IN_PosteoRequis"
	method="IN_PosteoRequis"
	ERid="460"
	Conexion="minisif"
	Ecodigo="1"
	Debug = "true"
	RollBack = "true"
	returnvariable="resultados"/>
<cfset fecfin = Now()>
</head>
<body>
<cfoutput>
<p>
Prueba del Componente IN_PosteoRequis<br>
Inicio de la prueba : #fecinic#<br>
Fin de la prueba : #fecfin#<br>
Duraci&oacute;n : #fecfin-fecinic#<br>
</p>
<h2>Resultados</h2>
<cfdump var="#resultados#">
<cfquery name="rsKardex" datasource="#session.dsn#">
	select * from #request.idkardex#	
</cfquery>
<cfdump var="#rsKardex#">
</cfoutput>
</body>
</html>
