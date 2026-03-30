<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<cfparam name="form.wsurl" default="http://localhost:8300/cfmx/saci/ws/intf/ping.cfc?wsdl">
<cfparam name="form.wsuser" default="ws">
<cfparam name="form.wspass" default="sup3rman">
<cfoutput>
<form method="post" action="">
<table border="1" cellspacing="0" cellpadding="2">
  <tr>
    <td colspan="2">Invocación del Web Service con seguridad </td>
    <td width="4">&nbsp;</td>
  </tr>
  <tr>
    <td width="117">URL</td>
    <td width="360"><input type="text" name="wsurl" value="# HTMLEditFormat( form.wsurl )#" size="60"/></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Usuario</td>
    <td><input type="text" name="wsuser" value="# HTMLEditFormat( form.wsuser )#" /></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Contraseña</td>
    <td><input type="password" name="wspass" value="# HTMLEditFormat( form.wspass )#" /></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="enviar" /></td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
<cfif IsDefined('form.enviar')>
invocando #HTMLEditFormat(wsurl)# ...<br />

<cfinvoke webservice="#wsurl#"
	method="ping" s="test" returnvariable="ret" username="#form.wsuser#" password="#form.wspass#"/>
resultado: {#ret#}<br />
</cfif>
</cfoutput>
</body>
</html>
