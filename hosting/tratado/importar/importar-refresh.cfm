<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>
<cfparam name="session.Importador.Avance" default="0">
<cfif session.Importador.Subtipo EQ "1">
	<cfset LvarAvance = 0>
<cfelseif session.Importador.Subtipo GTE "3">
	<cfset LvarAvance = 100>
<cfelse>
	<cfset LvarAvance = round(session.Importador.Avance*10000)/100>
</cfif>
<body onLoad="setTimeout('window.location.reload()',2*1000);">
<cfoutput>
<script language="javascript">
<cfif session.Importador.Tipo EQ "C">
	window.parent.el9('oper').innerHTML = "Cargando";
	window.parent.el9('pct2').style.color = "##66CCFF";
	<cfset LvarTipo = "Carga">
<cfelse>
	window.parent.el9('oper').innerHTML = "Procesando";
	window.parent.el9('pct1').style.backgroundColor = "##66CCFF";
	window.parent.el9('pct2').style.backgroundColor = "##3300CC";
	<cfset LvarTipo = "Proceso">
</cfif>
	window.parent.jp9(#LvarAvance#);
<cfif session.Importador.SubTipo EQ "1">
	window.parent.el9('paso').innerHTML = "Iniciando #LvarTipo#";
<cfelseif session.Importador.SubTipo EQ "2">
	window.parent.el9('paso').innerHTML = "Ejecutando #LvarTipo#";
<cfelseif session.Importador.SubTipo EQ "3">
	window.parent.el9('paso').innerHTML = "Finalizando #LvarTipo#";
<cfelseif session.Importador.SubTipo EQ "4">
	window.parent.el9('paso').innerHTML = "Completo";
<cfelseif session.Importador.SubTipo EQ "-1">
	<cfset session.Importador.SubTipo = "-2">
	<cfset url.ErrorId = session.Importador.ErrorId>
	<cfset Request.Error.Backs = 1>
	<cfinclude template="/home/public/error/display.cfm">
<cfelseif session.Importador.SubTipo EQ "-2">
	window.parent.el9('paso').innerHTML = "Completo con Error";
<cfelseif session.Importador.SubTipo EQ "-3" OR session.Importador.SubTipo EQ "5">
	window.parent.location.replace ("#session.Importador.location_replace#");
	<cfset session.Importador.location_replace = "">
</cfif>
</script>
</cfoutput>
</body>
</html>
