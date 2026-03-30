<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">
<cfset session.debug = true>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Prueba de Cálculo y Contabilización de la Depreciación</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<!--- <strong>Cálculo de la Depreciación</strong><br>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
<cfloop from="4" to="4" index="mes">
	<cfinvoke component="sif.Componentes.AF_DepreciacionActivos" method="AF_DepreciacionActivos" returnvariable="AGTPid">
		<cfinvokeargument name="Periodo" value="2003">
		<cfinvokeargument name="Mes" value="#mes#">
		<cfinvokeargument name="debug" value="false">
	</cfinvoke>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>
</cfloop>
 ---><strong>Contabilización de la Depreciación</strong><br>
<cfset AGTPid = 109>
<cfset timeinit = Now()>
Tiempo de Inicio:&nbsp; <cfoutput>#LSTimeFormat(timeinit,"hh:mm:ss:l")#</cfoutput><br>
	<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacion" method="AF_ContabilizarDepreciacion">
		<cfinvokeargument name="AGTPid" value="#AGTPid#">
		<cfinvokeargument name="debug" value="true">
	</cfinvoke>
<cfset timefin = Now()>
Tiempo de Finalización:&nbsp; <cfoutput>#LSTimeFormat(timefin,"hh:mm:ss:l")#</cfoutput><br>
Tiempo de ejecución en milisegundos:&nbsp; <cfoutput>#fnDateDiff('l',timeinit,timefin)#</cfoutput><br>
</body>
</html>
