<cfinclude template="../Application.cfm">
<cfinclude template="../Utiles/fnDateDiff.cfm">

	<cfif isdefined("form.btnArticulos")>
		<cfinvoke component="sif.Componentes.CM_InterfazArticulos" method="init" conexion="minisif" ecodigo="1" usucodigo="27"/>
		<cfinvoke component="sif.Componentes.CM_InterfazArticulos" method="run" returnvariable="resultado"/>
	<cfelseif isdefined("form.btnClasArticulos")>
		<cfinvoke component="sif.Componentes.CM_InterfazClasifArticulos" method="init" conexion="minisif" ecodigo="1" usucodigo="27"/>
		<cfinvoke component="sif.Componentes.CM_InterfazClasifArticulos" method="run" returnvariable="resultado"/>	
	<cfelseif isdefined("form.btnCatActFijos")>
		<cfinvoke component="sif.Componentes.CM_InterfazCatActivos" method="init" conexion="minisif" ecodigo="1" usucodigo="27"/>
		<cfinvoke component="sif.Componentes.CM_InterfazCatActivos" method="run" returnvariable="resultado"/>		
	<cfelseif isdefined("form.btnClasActFijos")>
	
	</cfif>

<cfoutput>
	<form action="pruebaCompoPorras.cfm" method="post" name="sql">
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

