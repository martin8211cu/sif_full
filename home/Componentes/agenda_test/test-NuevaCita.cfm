<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfparam name="form.notificar" default="">
<cfparam name="form.confirmar" default="">
<cfparam name="form.fecha" default="#DateFormat(Now(), 'dd/mm/yyyy')#">
<cfparam name="form.hora" default="#TimeFormat(Now(), 'HH:MM')#">
<cfparam name="form.duracion" default="30">
<cfparam name="form.texto" default="">
<cfparam name="form.link" default="">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Nueva Cita </strong></th>
    </tr>
    <tr>
      <td align="left">Agenda (s) </td>
      <td align="left"><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td align="left">Notificar</td>
      <td align="left"><input name="notificar" type="text" id="notificar" onFocus="this.select()" value="#form.notificar#"></td>
    </tr>
    <tr align="center">
      <td align="left">Confirmar</td>
      <td align="left"><input name="confirmar" type="text" id="confirmar" onFocus="this.select()" value="#form.confirmar#"></td>
    </tr>
    <tr align="center">
      <td align="left">Fecha (dd/mm/yyyy)</td>
      <td align="left"><input type="text" name="fecha" value="#form.fecha#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td align="left">Hora</td>
      <td align="left"><input name="hora" type="text" id="hora" onFocus="this.select()" value="#form.hora#"></td>
    </tr>
    <tr align="center">
      <td align="left">Duraci&oacute;n</td>
      <td align="left"><input name="duracion" type="text" id="duracion" onFocus="this.select()" value="#form.duracion#"></td>
    </tr>
    <tr align="center">
      <td align="left">Texto</td>
      <td align="left"><input name="texto" type="text" id="texto" onFocus="this.select()" value="#form.texto#"></td>
    </tr>
    <tr align="center">
      <td align="left">Link (opcional) </td>
      <td align="left"><input name="link" type="text" id="link" onFocus="this.select()" value="#form.link#"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Nueva Cita"></td>
    </tr>
  </table>
</form>

<cfif isdefined("form.go")>
	<cfset SetLocale( "English (Canadian)" )>
	<!--- dd/mm/yyyy --->
	<strong>Nueva Cita (#form.agenda#,#form.notificar#,#form.confirmar#,
		#LSParseDateTime(form.fecha & ' ' & form.hora)#, #form.duracion#,
		#form.texto#, #form.link#)</strong><br>
	<code><cfset cita=agenda.NuevaCita(form.agenda,form.notificar,form.confirmar,
		LSParseDateTime(form.fecha & ' ' & form.hora), form.duracion,
		form.texto, form.link)>#cita#</code><br><br>
	<cfquery datasource="asp" name="NuevaCita">
		select * from ORGCita
		where cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cita#">
	</cfquery>
	<cfdump var="#NuevaCita#">
	<cfquery datasource="asp" name="NuevaCita">
		select * from ORGAgendaCita
		where cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cita#">
	</cfquery>
	<cfdump var="#NuevaCita#">
</cfif>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

</cfoutput>
</body>
</html>
