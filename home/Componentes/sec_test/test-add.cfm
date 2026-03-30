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
	<strong>Crear #form.username#/#form.password#</strong><br>
	
	
	Creando usuario...<br>
	<cf_datospersonales action="new" name="pers">
	<cfset pers.nombre = form.email>
	<cfset pers.email1 = form.email>
	<cf_datospersonales action="insert" name="pers" data="#pers#">

	<cf_direccion action="new" name="direc">
	<cfset direc.atencion = "Pruebas">
	<cfset direc.direccion1 = "Forum TorreG Piso 2">
	<cf_direccion action="insert" name="direc" data="#direc#">

<cfdump var="#form#">
	<cfset newuser = sec.crearUsuario(form.empresa, direc.id_direccion, pers.datos_personales, 
		'', ParseDateTime('1/1/2010'), form.username, Len(form.password) EQ 0)>
	Nuevo usucodigo: #newuser#
	<br>
	Renombrar a #form.username#/#form.password#<br>
	<code>#sec.renombrarUsuario(newuser, form.username,form.password)#</code><br><br>
	<br>
	Enviando correo<br>
	<code>#sec.enviarPassword(newuser, form.password)#</code><br><br>

</cfif>

<form name="form1" method="post" action="">
  <table border="1">
    <tr align="center">
      <td colspan="2"><strong>Agregar nuevo usuario </strong></td>
    </tr>
    <tr>
      <td>email</td>
      <td><input type="text" name="email" onFocus="this.select()" value="danim@soin.co.cr"></td>
    </tr>
    <tr>
      <td>Login</td>
      <td><input type="text" name="username" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Contrase&ntilde;a</td>
      <td><input type="text" name="password" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>Empresa</td>
      <td>
	  
	  <cfquery datasource="asp" name="emp">
	  	select CEcodigo, CEnombre
		from CuentaEmpresarial
		order by case when CEcodigo = 1 then 0 else 1 end , upper(CEnombre)
	  </cfquery>
	  <select name="empresa" id="empresa">
	  	<cfloop query="emp">
			<option value="#emp.CEcodigo#">#CEnombre#</option>
		</cfloop>
	  </select>
	  </td>
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
