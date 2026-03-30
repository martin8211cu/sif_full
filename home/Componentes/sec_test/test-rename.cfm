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
	<strong>Renombrar #form.usucodigo# as #form.username#/#form.password#</strong><br>
	
	
	Renombrando usuario...<br>
	<br>
	Renombrar a #form.username#/#form.password#<br>
	<code>#sec.renombrarUsuario(form.usucodigo, form.username,form.password)#</code><br><br>
	
	Autenticar #form.username#/#form.password#<br>
	<code>#sec.autenticar("",form.username,form.password)#</code><br><br>
</cfif>

<form name="form1" method="post" action="">
  <table border="1">
    <tr align="center">
      <td colspan="2"><strong>Renombrar usuario </strong></td>
    </tr>
    <tr>
      <td>Usucodigo</td>
      <td><input type="text" name="usucodigo" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Login</td>
      <td><input type="text" name="username" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Contrase&ntilde;a</td>
      <td><input type="text" name="password" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Agregar"></td>
    </tr>
  </table>
</form>

<script>
document.form1.username.focus();
</script>

</cfoutput>
</body>
</html>
