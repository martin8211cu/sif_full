<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Pruebas de IPlanetService.cfc</title>
</head>
<body><h1>Pruebas de IPlanetService.cfc</h1>
<div>Otros: <a href="CiscoTest.cfm">Cisco</a> | <a href="IPassTest.cfm">iPass</a> | <a href="IPlanetTest.cfm">iPlanet</a></div>
<cfparam name="form.user" default="test_user">
<cfparam name="form.pass" default="test_pass">
<cfparam name="form.fname" default="Test">
<cfparam name="form.lname" default="User">
<cfparam name="form.quota" default="100">
<cfparam name="form.mailf" default="testuser@gmail.co.cr">

<cfparam name="form.test_nonce" default="">
<cfparam name="form.n" default="1">
<cfparam name="Cookie.test_nonce" default="?">
<cfscript>
	function nth(s, i){
		if (form.n is 1) return s;
		return s & NumberFormat (i, RepeatString('0', Int(Log10(form.n)) + 1 ));
	}
</cfscript>
<cfset NoResend = form.test_nonce is Cookie.test_nonce>
<cfset new_nonce = Int(Rand() * 999999)>
<cfcookie name="test_nonce" value="#new_nonce#">
<cfflush interval="256">
<cfoutput>

<form id="form1" name="form1" method="post" action="">
<input type="hidden" name="test_nonce" value="#new_nonce#" />
  <table border="0" cellspacing="0" cellpadding="2" style="background-color:##CCCCCC; border:1px solid black">
	<tr>
	  <td width="139">Núm iteraciones </td>
	  <td width="392"><input name="n" type="text" id="n" value="#form.n#" size="30" onfocus="this.select()" /></td>
	</tr>
  <tr>
    <td width="139">Usuario/login</td>
    <td width="392"><cfoutput>
      <input name="user" type="text" id="user" value="#form.user#" size="30" onfocus="this.select()" />
    </cfoutput></td>
    </tr>
  <tr>
    <td>Passwd</td>
    <td><cfoutput>
      <input name="pass" type="text" id="pass" value="#form.pass#" size="30" onfocus="this.select()" />
    </cfoutput></td>
    </tr>
  <tr>
    <td>Nombre</td>
    <td><cfoutput>
      <input name="fname" type="text" id="fname" value="#form.fname#" size="30" onfocus="this.select()" />
    </cfoutput></td>
    </tr>
  <tr>
    <td>Apellido</td>
    <td><cfoutput>
      <input name="lname" type="text" id="lname" value="#form.lname#" size="30" onfocus="this.select()" />
    </cfoutput></td>
    </tr>
  <tr>
    <td>Cuota</td>
    <td><cfoutput>
      <input name="quota" type="text" id="quota" value="#form.quota#" size="30" onfocus="this.select()" />
    </cfoutput></td>
    </tr>
  <tr>
    <td>Mail forward</td>
    <td><cfoutput>
      <input name="mailf" type="text" id="mailf" value="#form.mailf#" size="30" onfocus="this.select()" />
    </cfoutput></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><table border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td>&nbsp;</td>
        <td><input name="dump" type="submit" style="width:160px;text-align:left" id="add2" value="? Consultar Usuario" /></td>
        <td><input name="updatePassword" type="submit" style="width:160px;text-align:left" id="updatePassword" value="&raquo; Actualizar Password" /></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><input name="add" type="submit" style="width:160px;text-align:left" id="add" value="+ Crear Usuario" /></td>
        <td><input name="delete" type="submit" style="width:160px;text-align:left" id="delete" value="- Eliminar Usuario" /></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><input name="addMailForward" type="submit" style="width:160px;text-align:left" id="addMailForward" value="+ Mail Forward" /></td>
        <td><input name="deleteMailForward" type="submit" style="width:160px;text-align:left" id="deleteMailForward" value="- Mail Forward" /></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><input name="lock" type="submit" style="width:160px;text-align:left" id="lock" value="&laquo; Bloquear" /></td>
        <td><input name="unlock" type="submit" style="width:160px;text-align:left" id="unlock" value="&raquo; Desbloquear" /></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><input name="update" type="submit" style="width:160px;text-align:left" id="update" value="&times; Actualizar" /></td>
        <td><input name="testPassword" type="submit" style="width:160px;text-align:left" id="testPassword" value="? Probar Password" /></td>
      </tr>
    </table></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
</table>
</form>

<cfif NoResend>
	<cfset comp = CreateObject("component", "saci.ws.intf.IPlanetService")>
	<cfif form.n GT 1>
		<strong>Iterando #form.n# veces</strong>
		<cfset masterStartTime = GetTickCount()>
	</cfif>
	<cfloop from="1" to="#form.n#" index="i">
		<cfset startTime = GetTickCount()>
		<cfset comp.dump(nth(form.user,i), 'Antes')>
		Ejecutando...
		<cfset op = ''>
		<cftry>
			<cfif IsDefined('form.add')>
				<cfset comp.add(nth(form.user,i), form.quota, nth(form.user,i), form.fname, form.lname, form.pass)>
				<cfset op = 'add'>
			<cfelseif IsDefined('form.updatePassword')>
				<cfset comp.updatePassword(nth(form.user,i), form.pass)>
				<cfset op = 'updatePassword'>
			<cfelseif IsDefined('form.testPassword')>
				<cfset isValid = comp.testPassword(nth(form.user,i), form.pass)>
				<cfoutput>Password válido: #isValid#</cfoutput>
				<cfset op = 'testPassword'>
			<cfelseif IsDefined('form.delete')>
				<cfset comp.delete(nth(form.user,i))>
				<cfset op = 'delete'>
			<cfelseif IsDefined('form.addMailForward')>
				<cfset comp.addMailForward(nth(form.user,i), form.mailf)>
				<cfset op = 'addMailForward'>
			<cfelseif IsDefined('form.deleteMailForward')>
				<cfset comp.deleteMailForward(nth(form.user,i), form.mailf)>
				<cfset op = 'deleteMailForward'>
			<cfelseif IsDefined('form.update')>
				<cfset comp.update(nth(form.user,i), form.quota, nth(form.user,i), form.fname, form.lname, form.pass)>
				<cfset op = 'update'>
			<cfelseif IsDefined('form.lock')>
				<cfset comp.lock(nth(form.user,i))>
				<cfset op = 'lock'>
			<cfelseif IsDefined('form.unlock')>
				<cfset comp.unlock(nth(form.user,i))>
				<cfset op = 'unlock'>
			</cfif>
		<cfcatch type="any">#cfcatch.Message# #cfcatch.Detail#</cfcatch>
		</cftry>
		<cfset comp.dump(nth(form.user,i), 'Después de ' & op)>
		#NumberFormat( GetTickCount() - startTime)# ms<br />
	</cfloop>
	<cfif form.n GT 1>
		<cfset duracion = GetTickCount() - masterStartTime>
		<strong>Duracion total: #NumberFormat( duracion )# ms, 
			promedio #NumberFormat( duracion / form.n )# ms</strong>
	</cfif>
<cfelseif Len(form.test_nonce)>(Ignorando reenvío de la misma petición)
</cfif>
</cfoutput>
</body>
</html>
