<cfinclude template="../../Application.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Prueba de Componente de Revalución de Cuentas</title>
</head>

<body>
<cfinvoke 
	component="sif.Componentes.CG_RevaluaCuentas" 
	method="RevaluaCuentas" 
	returnvariable="ResultadoRC"
	periodo="2004"
	mes="2"
	aplica="#true#"
	debug="#true#"
	>
</body>
</html>
