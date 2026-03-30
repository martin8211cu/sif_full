<cfsetting requesttimeout="120">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Borrar Historia</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
* { font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px; }
</style>
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br><br>

<cfinvoke component="home.Componentes.Repositorio" method="administracioArchivos">
</cfinvoke>

<cfset finish = Now()>
<br>
Proceso terminado <cfoutput>#TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>
</body>
</html>