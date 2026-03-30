<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Pruebas de CiscoService.cfc</title>
</head>
<body><h1>Pruebas de CiscoService.cfc</h1>
<div>Otros: <a href="CiscoTest.cfm">Cisco</a> | <a href="IPassTest.cfm">iPass</a> | <a href="IPlanetTest.cfm">iPlanet</a></div>
<cfparam name="form.user" default="test_user">
<cfparam name="form.user2" default="test_login">
<cfparam name="form.pass" default="secret">
<cfparam name="form.group" default="PAC_25">
<cfparam name="form.tel" default="">
<cfparam name="form.newTimeout" default="">
<cfparam name="form.maxsess" default="">
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
	  <td>&nbsp;</td>
	  <td>Núm iteraciones </td>
	  <td><input name="n" type="text" id="n" value="#HTMLEditFormat(form.n)#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td width="4">&nbsp;</td>
	  <td width="178">Usuario </td>
	  <td width="319"><input name="user" type="text" id="user" value="# HTMLEditFormat(form.user)#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Clave</td>
	  <td><input name="pass" type="text" id="pass" value="#HTMLEditFormat(form.pass)#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Paquete</td>
	  <td><input name="group" type="text" id="group" value="#HTMLEditFormat(form.group)#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Teléfono</td>
	  <td><input name="tel" type="text" id="tel" value="#HTMLEditFormat(form.tel)#" size="30" onfocus="this.select()" /> 
		(hogar) </td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Timeout (minutos) </td>
	  <td><input name="newTimeout" type="text" id="newTimeout" value="#HTMLEditFormat(form.newTimeout)#" size="30" onfocus="this.select()" /> 
		(prepago) </td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Max Sessions </td>
	  <td><input name="maxsess" type="text" id="maxsess" value="#HTMLEditFormat(form.maxsess)#" size="30" onfocus="this.select()" /> 
		(vpn) </td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td colspan="2"><br />
		<table border="0" cellspacing="0" cellpadding="2">
		  <tr>
            <td><input name="getUserInfo" type="submit" style="width:160px;text-align:left" id="getUserInfo" value="? View Profile" /></td>
		    <td><input name="renameUser" type="submit" style="width:160px;text-align:left" id="renameUser" value="Æ Renombrar Usuario:" /></td>
		    <td><input name="user2" type="text" id="user2" value="#form.user2#" size="20" onfocus="this.select()" /></td>
		    </tr>
		  
		  <tr>
			<td><input name="createUser" type="submit" style="width:160px;text-align:left" id="createUser" value="+ Crear Usuario" /></td>
			<td><input name="deleteUser" type="submit" style="width:160px;text-align:left" id="deleteUser" value="- Eliminar Usuario" /></td>
			<td><input name="updatePassword" type="submit" style="width:160px;text-align:left" id="updatePassword" value="* Cambiar contraseña" /></td>
		  </tr>
		  <tr>
			<td><input name="changeUserParent" type="submit" style="width:160px;text-align:left" id="changeUserParent" value="&times; Cambiar de Grupo" /></td>
			<td><input name="updateTimeout" type="submit" style="width:160px;text-align:left" id="updateTimeout" value="&raquo; Update Timeout" /></td>
			<td><input name="updateTelefono" type="submit" style="width:160px;text-align:left" id="updateTelefono" value="&sup3; Update Teléfono" /></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>
		  <tr>
			<td><input name="createPackage" type="submit" style="width:160px;text-align:left" id="createPackage" value="++ Crear paquete" /></td>
			<td><input name="deletePackage" type="submit" style="width:160px;text-align:left" id="deletePackage" value="-- Eliminar paquete" /></td>
			<td>&nbsp;</td>
		  </tr>
		</table></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td colspan="2">&nbsp;</td>
	</tr>
  </table>
</form>
  
<cfif NoResend>
	<cfset comp = CreateObject("component", "saci.ws.intf.CiscoService")>
	<cfif form.n GT 1>
		<strong>Iterando #form.n# veces</strong>
		<cfset masterStartTime = GetTickCount()>
	</cfif>
	<cfloop from="1" to="#form.n#" index="i">
		<cfset startTime = GetTickCount()>
		<cftry>
			<cfif IsDefined('form.createPackage')>
				<cfset comp.createPackage(nth(form.group, i), form.pass)>
				<cfset comp.dump('createPackage(group=#nth(form.group, i)#, pass=#form.pass#)')>
			<cfelseif IsDefined('form.deletePackage')>
				<cfset comp.deletePackage(nth(form.group, i))>
				<cfset comp.dump('deletePackage(group=#nth(form.group, i)#)')>
			<cfelseif IsDefined('form.createUser')>
				<cfset comp.createUser(nth(form.user, i), form.pass, form.group, form.tel, form.maxsess, form.newTimeout)>
				<cfif len(form.maxsess)><cfset style = '{vpn}'>
					<cfelseif len(form.tel)><cfset style = '{hogar}'>
					<cfelseif len(form.newTimeout)><cfset style = '{prepago}'>
					<cfelse><cfset style = '{normal}'></cfif>
				<cfset comp.dump(style & ' createUser(user=#nth(form.user, i)#, pass=#form.pass#, group=#form.group#, tel=#form.tel#, maxsess=#form.maxsess#, newTimeout=#form.newTimeout#)')>
			<cfelseif IsDefined('form.changeUserParent')>
				<cfset comp.changeUserParent(nth(form.user, i), form.group)>
				<cfset comp.dump('changeUserParent(user=#nth(form.user, i)#, group=#form.group#)')>
			<cfelseif IsDefined('form.updateTimeout')>
				<cfset comp.updateTimeout(nth(form.user, i), form.newTimeout)>
				<cfset comp.dump('updateTimeout(user=#nth(form.user, i)#, newTimeout=#form.newTimeout#)')>
			<cfelseif IsDefined('form.getUserInfo')>
				<cfset comp.getUserInfo(nth(form.user, i))>
				<cfset comp.dump('getUserInfo(user=#nth(form.user, i)#)')>
			<cfelseif IsDefined('form.deleteUser')>
				<cfset comp.deleteUser(nth(form.user, i))>
				<cfset comp.dump('deleteUser(user=#nth(form.user, i)#)')>
			<cfelseif IsDefined('form.updatePassword')>
				<cfset comp.updatePassword(nth(form.user, i), form.pass)>
				<cfset comp.dump('updatePassword(user=#nth(form.user, i)#,pass=#form.pass#)')>
			<cfelseif IsDefined('form.updateTelefono')>
				<cfset comp.updateTelefono(nth(form.user, i), form.tel)>
				<cfset comp.dump('updateTelefono(user=#nth(form.user, i)#,pass=#form.tel#)')>
			<cfelseif IsDefined('form.renameUser')>
				<cfset comp.renameUser(nth(form.user, i), nth(form.user2, i))>
				<cfset comp.dump('renameUser (user=#nth(form.user, i)#,pass=#nth(form.user2, i)#)')>
			</cfif>
		<cfcatch type="any">#cfcatch.Message# #cfcatch.Detail#</cfcatch>
		</cftry>
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


</p>
</body>
</html>
