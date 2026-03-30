<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Prueba del Componente de Estructura Salarial</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfinclude template="/sif/Application.cfm">
	<cfinvoke 
	 component="rh.Componentes.EstructuraSalarial"
	 method="calculaComponente"
	 returnvariable="calculaComponenteRet">
		<cfinvokeargument name="CSid" value="1"/>
		<cfinvokeargument name="DLfvigencia" value="#LSParseDateTime('01/02/2004')#"/>
		<cfinvokeargument name="DLffin" value="#LSParseDateTime('01/02/2005')#"/>
		<cfinvokeargument name="RHTCid" value="500000000000345"/>
		<cfinvokeargument name="Unidades" value="15"/>
		<cfinvokeargument name="MontoBase" value="0"/>
		<cfinvokeargument name="Monto" value="0"/>		
	</cfinvoke>
	<cfdump var="#calculaComponenteRet#">
</body>
</html>
