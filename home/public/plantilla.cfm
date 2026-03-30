<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title><cfif IsDefined('session.sitio.host')><cfoutput>#session.sitio.host#</cfoutput><cfelse>Welcome</cfif></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body,td {
	font-size: 10px;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}
-->
</style>
</head>

<body>
  <cfoutput>
<table width="100%" border="0">
  <tr>
  <td align="left" valign="top"><cfif IsDefined('session.sitio.host')>#session.sitio.host#</cfif><br>
    #DateFormat(Now(),'dddd, dd/mm/yyyy')#</td>
  <td align="right" valign="top">
  	<cfif Not IsDefined('session.usucodigo') Or session.usucodigo is 0
	  	Or Not IsDefined('session.usuario') Or Len(session.usuario) is 0>
	<form name="form1" method="post" action="">
    <table border="0" align="right">
      <tr>
        <td><input name="j_username" type="text" id="j_username" onFocus="this.select()" value="USUARIO" size="15" maxlength="30"></td>
        <td><input name="j_password" type="password" id="j_password" onFocus="this.select()" value="PASSWORD" size="15" maxlength="30"></td>
        <td><input type="submit" name="Submit" value="Log in"></td>
      </tr>
    </table> 
    </form>
	<cfelse>
	<a href="##">#session.usuario#</a> | <a href="/cfmx/home/public/logout.cfm">Salir</a>
	</cfif></td>
</tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
</cfoutput>	
<p>$$BODY$$ </p>
</body>
</html>
