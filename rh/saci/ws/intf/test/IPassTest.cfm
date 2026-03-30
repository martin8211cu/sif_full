<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Pruebas de IPassService.cfc</title>
</head>
<body><h1>Pruebas de IPassService.cfc</h1>
<div>Otros: <a href="CiscoTest.cfm">Cisco</a> | <a href="IPassTest.cfm">iPass</a> | <a href="IPlanetTest.cfm">iPlanet</a></div>
<cfparam name="form.user" default="test_user">
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
	  <td><input name="n" type="text" id="n" value="#form.n#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td width="4">&nbsp;</td>
	  <td width="178">Usuario </td>
	  <td width="319"><input name="user" type="text" id="user" value="#form.user#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td colspan="2"><br />
		<table border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td><input name="agregarLoginIpass" type="submit" style="width:260px;text-align:left" id="agregarLoginIpass" value="+ Agregar a IPass (bloquear)" /></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td><input name="borrarLoginIpass" type="submit" style="width:260px;text-align:left" id="borrarLoginIpass" value="+ Eliminar de IPass (desbloquear)" /></td>
		    <td>&nbsp;</td>
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
	<cfset comp = CreateObject("component", "saci.ws.intf.IPassService")>
	<cfif form.n GT 1>
		<strong>Iterando #form.n# veces</strong>
		<cfset masterStartTime = GetTickCount()>
	</cfif>
	<cfloop from="1" to="#form.n#" index="i">
		<cfset startTime = GetTickCount()>
		<cftry>
			<cfif IsDefined('form.agregarLoginIpass')>
				<cfset comp.agregarLoginIpass(nth(form.user, i))>
				<cfset comp.dump('agregarLoginIpass(user=#nth(form.user, i)#)')>
			<cfelseif IsDefined('form.borrarLoginIpass')>
				<cfset comp.borrarLoginIpass(nth(form.user, i))>
				<cfset comp.dump('borrarLoginIpass(user=#nth(form.user, i)#)')>
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
</body>
</html>
