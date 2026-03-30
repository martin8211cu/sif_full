<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfparam name="form.nombre_agenda" default="">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Renombrar</strong></th>
    </tr>
    <tr>
      <td>Agenda</td>
      <td><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Nombre nuevo </td>
      <td><input type="text" name="nombre_agenda" value="#form.nombre_agenda#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Renombrar"></td>
    </tr>
  </table>
</form>

<cfif isdefined("form.go")>
	<strong>Renombrando horario #form.agenda# a #form.nombre_agenda#</strong><br>
	<code>#agenda.Renombrar(form.agenda,form.nombre_agenda)#</code><br><br>
</cfif>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

</cfoutput>
</body>
</html>
