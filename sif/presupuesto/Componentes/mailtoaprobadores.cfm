<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Correo generado autom&aacute;ticamente por el Sistema de Presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--- Requiere 
	Lvar_nombrefrom, 
	Lvar_CFOrigen, 
	Lvar_CFDestino, 
	Lvar_MontoOrigen, 
	Lvar_ruta --->
<cfparam name="Lvar_nombrefrom" type="string">
<cfparam name="Lvar_CFOrigen" type="string">
<cfparam name="Lvar_CFDestino" type="string">
<cfparam name="Lvar_MontoOrigen" type="numeric">
<cfparam name="Lvar_ruta" type="string" default="http://#session.sitio.host#/cfmx/sif/presupuesto/operacion/traslado-aprobacion-lista.cfm?seleccionar_Ecodigo=#session.Ecodigo#">
</head>
<body>
<cfoutput>
	<p>El Se&ntilde;or(a) #Lvar_nombrefrom#, realiz&oacute; un traslado del 
	Centro Funcional #Lvar_CFOrigen# al Centro Funcional #Lvar_CFDestino#, 
	por un monto de #LSCurrencyFormat(Lvar_MontoOrigen,'none')#, el cual 
	requiere de su autorizaci&oacute;n.</p>
	<p> Favor realizar la correspondiente 


 aprobaci&oacute;n  ingresando a la siguiente ruta #Lvar_ruta#</p>
	<p> Este mensaje es generado autom&aacute;ticamente por el sistema de Presupuesto. Por favor no responda a este mensaje.</p>
</cfoutput>
</body>
</html>
