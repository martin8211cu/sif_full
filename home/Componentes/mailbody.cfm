<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Envío de contraseñas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	font-size: 10px;
	font-family: "Times New Roman", Times, serif;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-size: 14;
}
.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
.style8 {font-size: 14}
-->
</style>
</head>

<body>
<!---
<cfdump var="#cgi#">
<cfdump var="#session#">
<cfdump var="#GetHTTPRequestData().headers#">
--->
<cfparam name="hostname" default="localhost">
<cfparam name="_password" default="">
<cfparam name="_incluir_login" type="boolean" default="yes">

<cfoutput>
<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
  <tr bgcolor="##999999">
    <td colspan="2" height="8"></td>
  </tr>
  <tr bgcolor="##003399">
    <td colspan="2" height="24"></td>
  </tr>
  <tr bgcolor="##999999">
    <td colspan="2"> <strong>Información de acceso a http://#hostname#</strong> </td>
  </tr>
  <tr>
    <td width="70">&nbsp;</td>
    <td width="476">&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style2">De</span></td>
    <td><cfoutput><span class="style7"> Administrador de http://#hostname#</span></cfoutput></td>
  </tr>
  <tr>
    <td><span class="style7"><strong>Para</strong></span></td>
    <td>
	  <span class="style7">
	<cfoutput> #_user_datos_personales.nombre# #_user_datos_personales.apellido1# #_user_datos_personales.apellido2#</cfoutput>
	  </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7"> &iexcl; Bienvenido  a la comunidad digital de http://#hostname# !</span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Se ha creado una cuenta de acceso, registrando su correo como referencia. </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Para acceder, ingrese a <a href="http://#hostname#/cfmx/">http://#hostname#/cfmx/</a> utilizando la siguiente información: </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><table border="0">
	<cfif _incluir_login>
		<cfquery datasource="#Arguments.Conexion#" name="obtener_aliaslogin">
			select CEaliaslogin
			from CuentaEmpresarial
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_user_info.CEcodigo#">
		</cfquery>
		<cfif Len(Trim(obtener_aliaslogin.CEaliaslogin))>
        <tr>
          <td class="style7"><strong>Empresa:</strong></td>
          <td class="style7">&nbsp;&nbsp;&nbsp;</td>
          <td class="style7"><code>#LCase( obtener_aliaslogin.CEaliaslogin )#</code></td>
        </tr></cfif>
        <tr>
          <td class="style7"><strong>Usuario:</strong></td>
          <td class="style7">&nbsp;&nbsp;&nbsp;</td>
          <td class="style7"><code>#_user_info.Usulogin#</code></td>
        </tr>
	</cfif>
        <tr>
          <td class="style7"><strong>Contraseña:</strong></td>
          <td class="style7">&nbsp;</td>
          <td class="style7"><code>#_password#</code></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <!--- <tr>
    <td>&nbsp;</td>
    <td><span class="style1">Nota: En  http://#hostname# respetamos su privacidad. <br>
      Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#_user_info.Usucodigo#&amp;b=#_user_info.CEcodigo#&amp;c=#hostname#&amp;#Hash(_user_info.Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span></td>
  </tr> --->
</table>
<br>

<br>
<br>
<br>
</cfoutput>
</body>
</html>
