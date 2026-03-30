<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.debug = true>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<strong>EJECUTANDO LA FUNCION CMCancelaSolicitud</strong><br>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfinvoke 
 component="sif.Componentes.CM_CancelaSolicitud"
 method="CM_getSolicitudesACancelar"
 returnvariable="qry"/>
<cfdump var="#qry#">
<cfinvoke 
 component="sif.Componentes.CM_CancelaSolicitud"
 method="CM_CancelaSolicitud"
 returnvariable="NAPcancel">
 <cfinvokeargument name="ESidsolicitud" value="56">
</cfinvoke>
<!--- --->
<cfinvoke 
 component="sif.Componentes.CM_CancelaSolicitud"
 method="CM_getSolicitudesACancelar"
 returnvariable="qry"/>
<cfdump var="#qry#">
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>
<strong>RETORNA:&nbsp;<cfoutput></cfoutput></strong><br>
</body>
</html>
