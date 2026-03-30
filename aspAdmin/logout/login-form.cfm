<!---
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Login portlet</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="login.css" rel="stylesheet" type="text/css">
</head>

<body>
--->
<cfparam name="url.uri" default="/cfmx/sif/default.cfm">
<form name="login" onsubmit="validarLogin(this)" action="<cfoutput>#url.uri#</cfoutput>" method="post" >
  <table width="268" cellpadding="0" cellspacing="0" >
    <!--DWLayoutTable-->
    <tr> 
      <td width="1" height="119"></td>
      <td width="249" valign="top" class="g"><table border="0" cellpadding="0" cellspacing="0" align="center" >
          <!--DWLayoutTable-->
          <tr> 
            <td width="115" align="left" valign="top" > <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Usuario</b></font></div></td>
            <td width="2" rowspan="2" align="left" valign="top">&nbsp;</td>
            <td width="120" align="left" valign="top" > <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#00000">&nbsp;<b><font size="2">Contrase&ntilde;a</font></b></font></div></td>
          </tr>
          <tr> 
            <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
              <input type="text" name="j_username" size="14" tabindex="1" onfocus="this.select()" >
              </font></td>
            <td align="center" valign="top"> <font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
              <input type="password" name="j_password" size="14" tabindex="2" onfocus="this.select()" >
              </font> </td>
          </tr>
          <tr> 
            <td align=left valign=top colspan="3"> <div align="center"><font size="1"> 
                <font face="Verdana, Arial, Helvetica, sans-serif"> 
                <input type="checkbox" name="recordar" value="checkbox">
                <font color="#000000">Recordar mi usuario en este computador</font></font></font></div></td>
          </tr>
          <tr> 
            <td height="11"></td>
            <td></td>
            <td></td>
          </tr>
          <tr> 
            <td colspan="3" align="center" valign="top"><input type="submit" name="Submit" value="Conectarse"></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="6"></td>
      <td></td>
    </tr>
    <tr>
      <td height="48"></td>
      <td align="center" valign="top" class="g"><a href="login-ayuda.html">&iquest;Necesita 
        ayuda para ingresar?</a><br> <a href="recordar.jsp">&iexcl;Olvid&eacute; 
        mi contrase&ntilde;a!</a></td>
    </tr>
    <tr>
      <td height="16"></td>
      <td></td>
    </tr>
  </table>
</form>
<!---
</body>
</html>
--->