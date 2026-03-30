<!---
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Login portlet</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="login.css" rel="stylesheet" type="text/css">
</head>

<body>
--->
<cfparam name="url.uri" default="/cfmx/sif/default.cfm">
<cfparam name="url.errormsg" default="0">
<form name="login" onsubmit="return validarLogin(this);" action="<cfoutput>#url.uri#</cfoutput>" method="post" >
  <table width="95%" align="center" cellpadding="0" cellspacing="0" >
    <!--DWLayoutTable-->
    <tr> 
      <td width="100%" valign="top" class="g">
<table border="0" cellpadding="0" cellspacing="0" align="center" >
          <!--DWLayoutTable-->
          <cfif url.errormsg neq 0>
            <tr> 
              <td align="left" valign="top" ><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#FF0000"><b>Usuario 
                o contrase&ntilde;a incorrectos. </b></font></div></td>
            </tr>
            <tr> 
              <td align="left" valign="top" ><p>&nbsp;</p></td>
            </tr>
          </cfif>
          <cfif Len(session.sitio.CEcodigo) EQ 0>
            <tr> 
              <td width="115" align="left" valign="top" > 
                <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Empresa</b></font> 
              </td>
            </tr>
            <tr> 
              <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
                <input type="text" name="j_empresa" size="14" tabindex="1" onfocus="this.select()" >
                </font></td>
            </tr>
          </cfif>
          <tr> 
            <td width="115" align="left" valign="top" > <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Usuario</b></font></td>
          </tr>
          <tr> 
            <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
              <input type="text" name="j_username" size="14" tabindex="2" onfocus="this.select()" >
              </font></td>
          </tr>
          <tr> 
            <td align="left" valign="top" > <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#00000">&nbsp;<b><font size="2">Contrase&ntilde;a</font></b></font> 
            </td>
          </tr>
          <tr> 
            <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
              <input type="password" name="j_password" size="14" tabindex="3" onfocus="this.select()" >
              </font> </td>
          </tr>
          <tr> 
            <td align=left valign=top> <div align="center"><font size="1"> <font face="Verdana, Arial, Helvetica, sans-serif"> 
                <input type="checkbox" id="recordar" name="recordar" value="checkbox" tabindex="4">
                <font color="#000000"> 
                <label for="recordar">Recordar mi usuario en este computador</label>
                </font></font></font></div></td>
          </tr>
          <tr> 
            <td height="11"></td>
          </tr>
          <tr> 
            <td align="center" valign="top"><input type="submit" name="Submit" value="Conectarse" tabindex="5"></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td></td>
    </tr>
    <tr>
      <td align="center" valign="top" class="g"><a href="/cfmx/home/public/login-ayuda.html">&iquest;Necesita 
        ayuda para ingresar?</a><br> <a href="/cfmx/home/public/recordar.cfm">&iexcl;Olvid&eacute; 
        mi contrase&ntilde;a!</a></td>
    </tr>
    <tr>
      <td></td>
    </tr>
  </table>
</form>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
<!---
</body>
</html>
--->