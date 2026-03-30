<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfoutput>

<cfif isdefined("form.go")>
	<strong>Generar login aleatorio</strong><br>
	Generando... <br>
	<code>#sec.random_login()#</code><br><br>

</cfif>

<form name="form1" method="post" action="">
  <table border="1">
    <tr align="center">
      <td colspan="2"><strong>Generar login aleatorio</strong></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Generar"></td>
    </tr>
  </table>
</form>

<script>
document.form1.go.focus();
</script>

</cfoutput>
</body>
</html>
