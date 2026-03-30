<cfinclude template="../Utiles/fnDateDiff.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Prueba de Cierre de Activos Fijos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>Cierre de Activos Fijos</strong><br>
 <cfset AGTPid = 106>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfinvoke component="sif.Componentes.AF_CierreMes" method="CierreMes">
	<cfinvokeargument name="Ecodigo" value="1"/>
	<cfinvokeargument name="debug" value="false"/>
	<cfinvokeargument name="periodo" value="2003"/>
	<cfinvokeargument name="mes" value="3"/>
	<cfinvokeargument name="conexion" value="minisif"/>
</cfinvoke>		
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>
</body>
</html>
