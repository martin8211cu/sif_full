<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Pruebas de realname.cfc</title>
</head>
<body><h1>Pruebas de realname.cfc</h1>

<!---<cfset WSDLURL = 'http://' & CGI.HTTP_HOST & '/cfmx/saci/ws/cic/cic.cfc?wsdl'>--->

<cfset WSDLURL = 'http://' & '10.25.10.56:8300' & '/cfmx/saci/ws/cic/cic.cfc?wsdl'>

<cfparam name="form.wsuser" default="wsuser">
<cfparam name="form.wspass" default="">


<cfparam name="form.user" default="test_user">
<cfparam name="form.realName" default="RAUL SEGURA AZOFEIFA">
<cfparam name="form.servicio" default="global">
<cfparam name="form.clave" default="secret">
<cfparam name="form.sobre" default="0">

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
	  <td>Usuario WEBSERVICE </td>
	  <td><input name="wsuser" type="text" id="wsuser" value="#form.wsuser#" size="30" onfocus="this.select()" /></td>
	  </tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Password WEBSERVICE </td>
	  <td><input name="wspass" type="password" id="wspass" value="#form.wspass#" size="30" onfocus="this.select()" /></td>
	  </tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  </tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Núm iteraciones </td>
	  <td><input name="n" type="text" id="n" value="#form.n#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td width="4">&nbsp;</td>
	  <td width="178">Usuario por modificar </td>
	  <td width="319"><input name="user" type="text" id="user" value="#form.user#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Real Name </td>
	  <td><input name="realName" type="text" id="realName" value="#form.realName#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Clave - password</td>
	  <td><input name="clave" type="text" id="pass" value="#form.clave#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Servicio</td>
	  <td><select name="servicio">
	  <cfloop list="global,acceso,correo" index="svc">
	  <option value="#svc#" <cfif svc is form.servicio>selected</cfif>>#svc#</option>
	  </cfloop>
	  </select>	  </td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>Sobre</td>
	  <td><input name="sobre" type="text" id="sobre" value="#form.sobre#" size="30" onfocus="this.select()" /></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td colspan="2"><br />
		<table border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td width="210"><input name="cambioRealNameCFC" type="submit" style="width:210px;text-align:left" id="cambioRealNameCFC" value="&times; Cambio Real Name (cfc)" /></td>
			<td width="171">&nbsp;</td>
		  </tr>
		  <tr>
			<td><input name="cambioRealNameWS" type="submit" style="width:210px;text-align:left" id="cambioRealNameWS" value="&times; Cambio Real Name (ws)" /></td>
		    <td><a href="# HTMLEditFormat( WSDLURL )#">Ver WSDL</a></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>
		  <tr>
            <td><input name="cambioPasswordCFC" type="submit" style="width:210px;text-align:left" id="cambioPasswordCFC" value="× Cambio Password (cfc)" /></td>
		    <td>&nbsp;</td>
		    </tr>
		  <tr>
            <td><input name="cambioPasswordWS" type="submit" style="width:210px;text-align:left" id="cambioPasswordWS" value="× Cambio Password (ws)" /></td>
		    <td><a href="# HTMLEditFormat( WSDLURL )#">Ver WSDL</a></td>
		    </tr>
		  <tr>
		  <tr>
            <td><input name="GetRealNameWS" type="submit" style="width:210px;text-align:left" id="GetRealNameWS" value="× Get Real Name ws)" /></td>
		    <td><a href="# HTMLEditFormat( WSDLURL )#">Ver WSDL</a></td>
		    </tr>
		  <tr>

		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    </tr>
		  <tr>
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
	<cfif form.n GT 1>
		<strong>Iterando #form.n# veces</strong>
		<cfset masterStartTime = GetTickCount()>
	</cfif>
	<cfloop from="1" to="#form.n#" index="i">
		<cfset startTime = GetTickCount()>
		<cftry>
			<cfif IsDefined('form.cambioRealNameCFC')>
				<cfoutput>
				Componente CFC: cambiarRealName(usuario=#nth(form.user, i)#, realName=#nth(form.realName, i)#)...
				<cfinvoke component="saci.ws.cic.cic" method="cambiarRealName"
					usuario="#nth(form.user, i)#" realName="#nth(form.realName, i)#" />
				ok<br /></cfoutput>
			<cfelseif IsDefined('form.cambioRealNameWS')>
				<cfoutput>
				Web Service: cambiarRealName(usuario=#nth(form.user, i)#, realName=#nth(form.realName, i)#)...
				<cfinvoke webservice="#WSDLURL#" method="cambiarRealName"
					username="#form.wsuser#" password="#form.wspass#"
					usuario="#nth(form.user, i)#" realName="#nth(form.realName, i)#" />
				ok<br /></cfoutput>
			<cfelseif IsDefined('form.cambioPasswordCFC')>
				<cfoutput>
				Componente CFC: cambiarPassword(usuario=#nth(form.user, i)#, clave=#form.clave#, servicio=#form.servicio#, sobre=#form.sobre#)...
				<cfinvoke component="saci.ws.cic.cic" method="cambiarPassword"
					usuario="#nth(form.user, i)#" clave="#form.clave#"
					servicio="#form.servicio#" sobre="#form.sobre#"/>
				ok<br /></cfoutput>
			<cfelseif IsDefined('form.cambioPasswordWS')>
				<cfoutput>
				Web Service: cambiarPassword(usuario=#nth(form.user, i)#, clave=#form.clave#, servicio=#form.servicio#, sobre=#form.sobre#)...
				<cfinvoke webservice="#WSDLURL#" method="cambiarPassword"
					username="#form.wsuser#" password="#form.wspass#"
					usuario="#nth(form.user, i)#" clave="#form.clave#"
					servicio="#form.servicio#" sobre="#form.sobre#"/>
				ok<br /></cfoutput>
			<cfelseif IsDefined('form.GetRealNameWS')>
				<cfoutput>
				Web Service: GetRealNameWS (usuario=#nth(form.user, i)#)
				<cfinvoke webservice="#WSDLURL#" method="GetRealName" returnvariable="realname"
					username="#form.wsuser#" password="#form.wspass#"
					usuario="#nth(form.user, i)#"/>
				ok-#realname#<br /></cfoutput>
	
			</cfif>
		<cfcatch type="anyx">#cfcatch.Message# #cfcatch.Detail#</cfcatch>
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
