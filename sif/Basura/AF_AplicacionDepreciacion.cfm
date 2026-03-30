<cfinclude template="../Application.cfm">
<cfset session.dsn = "minisif">
<cfset session.ecodigo = 1>
<cfset session.usucodigo = 27>
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.debug = true>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Prueba de Aplicación de la Depreciación</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>EJECUTANDO Aplicación de la Depreciacion</strong><br>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacion" method="AF_ContabilizarDepreciacion">
<cfinvokeargument name="AGTPid" value="59">
<cfinvokeargument name="debug" value="true">
</cfinvoke>
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>
</body>
</html>
