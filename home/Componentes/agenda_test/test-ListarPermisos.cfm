<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>ListarPermisos</strong></th>
    </tr>
    <tr>
      <td>Agenda</td>
      <td><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Listar Permisos"></td>
    </tr>
  </table>
</form>

<cfif isdefined("form.go")>
	<strong>Listar Permisos #form.agenda#</strong><br>
	<cfdump var="#agenda.ListarPermisos(form.agenda)#"><br><br>
</cfif>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

</cfoutput>
</body>
</html>
