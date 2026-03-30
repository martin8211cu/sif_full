<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>IN_PosteoLin</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.Ecodigo = 1>
<cfset session.dsn = "minisif">
<cfset session.usucodigo = 27>
<cfset fecinic = Now()>
<cfinvoke 
	component="sif.Componentes.IN_PosteoLin" 
	method="CreaIdKardex"/>
<cfinvoke 
	component="sif.Componentes.IN_PosteoLin" 
	method="IN_PosteoLin" 
	Aid="91"
	Alm_Aid="500000000000042"
	Tipo_Mov="E"
	Cantidad="1000"
	CFid="606"
	Debug = "false"
	RollBack = "false"
	verificaPositivo = "true"
	returnvariable="resultados"/>
	<!--- Costo="5.45556"
	Tipo_ES="E"
	CFid="606"
	TipoCambio="1"
	TipoDoc="FC"
	Documento="DAG#Now()#"
	FechaDoc="#CreateDate(1,1,1)#"
	Referencia="DAG123456"
	ERid="402"
	insertarEnKardex="false"
	Conexion="minisif"
	Ecodigo="1"
	Debug = "true" --->
<cfset fecfin = Now()>
</head>
<body>
<cfoutput>
<p>
Prueba del Componente IN_PosteoLin<br>
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
