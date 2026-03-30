<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfinclude template="/sif/Application.cfm">
	<cfinvoke 
	 component="sif.rh.Componentes.EstructuraSalarial"
	 method="calculaComponente"
	 returnvariable="calculaComponenteRet">
		<cfinvokeargument name="CSid" value="2"/>
		<cfinvokeargument name="DLfvigencia" value="20040101"/>
		<cfinvokeargument name="DLffin" value="20070101"/>
		<cfinvokeargument name="RHTCid" value="144"/>
	</cfinvoke>
	<cfdump var="#calculaComponenteRet#">
</body>
</html>
