<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset timeinit = Now()>
<cfinvoke 
 component="sif.Componentes.CM_ImportaCotizaciones"
 method="CM_ImportaCotizaciones" returnvariable="cpid_list">
 <cfinvokeargument name="Ecodigo" value="1">
 <cfinvokeargument name="Conexion" value="minisif">
 <cfinvokeargument name="Usucodigo" value="1">
 <cfinvokeargument name="Debug" value="true">
</cfinvoke>
<cfset timefin = Now()>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>EJECUTANDO LA FUNCION CM_ImportaCotizaciones</strong><br>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>
<strong>RETORNA:&nbsp;<cfoutput>##</cfoutput></strong><br>
<strong>TEXTO DEL SP</strong><br>
</body>
</html>