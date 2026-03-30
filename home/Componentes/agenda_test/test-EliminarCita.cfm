<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfparam name="form.cita" default="">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Eliminar Cita </strong></th>
    </tr>
    <tr>
      <td align="left">Agenda (s) </td>
      <td align="left"><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td align="left">Cita</td>
      <td align="left"><input name="cita" type="text" id="cita" onFocus="this.select()" value="#form.cita#"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Eliminar Cita"></td>
    </tr>
  </table>
</form>

<cfif isdefined("form.go")>
	<cfset SetLocale( "English (Canadian)" )>
	<!--- dd/mm/yyyy --->
	<strong>EliminarCita (#form.agenda#, #form.cita#)</strong><br>
	<code>#agenda.EliminarCita(form.agenda,form.cita)#</code><br><br>
</cfif>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

</cfoutput>
</body>
</html>
