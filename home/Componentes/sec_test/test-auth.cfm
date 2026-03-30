<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.username" default="">
<cfparam name="form.empresa" default="">
<cfparam name="form.password" default="">
<cfoutput>

<cfif isdefined("form.go")>
	<strong>Autenticar #form.username# @ #form.empresa# </strong><br>
	<code>#sec.autenticar(form.empresa,form.username,form.password)#</code><br><br>
</cfif>
<cfquery datasource="asp" name="empresa">
	select CEcodigo, CEnombre from CuentaEmpresarial
</cfquery>
<form name="form1" method="post" action="">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Autenticar usuario </strong></th>
    </tr>
    <tr>
      <td>Login</td>
      <td><input type="text" name="username" value="#form.username#" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Contrase&ntilde;a</td>
      <td><input type="password" name="password" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Empresa</td>
      <td><select name="empresa" id="empresa">
	  <cfloop query="empresa">
	  <option value="#CEcodigo#" <cfif CEcodigo is form.empresa>selected</cfif>>#CEnombre#</option>
	  </cfloop>
	  </select></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Validar"></td>
    </tr>
  </table>
</form>

<script>
document.form1.username.focus();
</script>

</cfoutput>
</body>
</html>
