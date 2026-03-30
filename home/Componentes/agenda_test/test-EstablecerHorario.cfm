<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfparam name="form.horario_habil" default="">
<cfparam name="form.escala" default="">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Establecer Horario </strong></th>
    </tr>
    <tr>
      <td>Agenda</td>
      <td><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Horario h&aacute;bil </td>
      <td><input type="text" name="horario_habil" value="#form.horario_habil#" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Escala</td>
      <td><input type="text" name="escala" value="#form.escala#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Establecer Horario"></td>
    </tr>
  </table>
</form>

<cfif isdefined("form.go")>
	<strong>Modificando horario #form.agenda#</strong><br>
	<code>#agenda.EstablecerHorario(form.agenda,form.horario_habil,form.escala)#</code><br><br>
</cfif>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

</cfoutput>
</body>
</html>
