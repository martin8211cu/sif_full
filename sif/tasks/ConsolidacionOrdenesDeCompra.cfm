<cfapplication name="SIF_ASP"
	sessionmanagement="No"
	clientmanagement="No"
	setclientcookies="No">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Proceso de Consolidación de Ordenes de Compra</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	</head>
	<body>
		<cfset start = Now()>

		Proceso de Consolidación de Ordenes de Compra<br>
		Iniciando proceso <cfoutput>#TimeFormat(start, "HH:MM:SS")#</cfoutput><br>

		<cfset registros = 0>
		<cfset resultado = ''>

		<cfinclude template="../cm/operacion/ProcesoConsolidacionOrdenesDeCompra.cfm">

		<cfset finish = Now()>

		Registros insertados: <cfoutput>#registros#</cfoutput><br>

		Proceso terminado <cfoutput>#TimeFormat(finish, "HH:MM:SS")#</cfoutput><br>
	</body>
</html>
