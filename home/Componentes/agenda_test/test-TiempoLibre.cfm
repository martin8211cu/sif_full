<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfparam name="form.fecha" default="#DateFormat(Now(), 'dd/mm/yyyy')#">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Tiempo Libre</strong></th>
    </tr>
    <tr>
      <td align="left">Agenda (s) </td>
      <td align="left"><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td align="left">Fecha (dd/mm/yyyy)</td>
      <td align="left"><input type="text" name="fecha" value="#form.fecha#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Tiempo Libre"></td>
    </tr>
  </table>
</form>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

<cfif isdefined("form.go")>
	<cfset SetLocale( "English (Canadian)" )><!--- dd/mm/yyyy --->
	<strong>Tiempo Libre (#form.agenda#, #LSParseDateTime(form.fecha)#)</strong><br>
	<cfdump var="#agenda.TiempoLibre(form.agenda,LSParseDateTime(form.fecha)).getString()#"><br><br>
</cfif>

</cfoutput>
</body>
</html>
