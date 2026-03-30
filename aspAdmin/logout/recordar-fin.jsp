<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=iso-8859-1"
	language="java" import="" errorPage="" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<html >
<head><title>MiGesti&oacute;n</title>
<link href="login.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<body onLoad="document.f.s.focus()">
<center><table border="0" width="585" cellspacing="0" cellpadding="0">
<tr>
      <td width="1%"><a href="/"><img src="login-migestion.gif" alt="MiGestion" width="210" height="130" border="0" /></a></td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="ayuda.jsp">Ayuda</a> 
              - <a href=".">Iniciar 
              sesi&oacute;n </a></td>
          </tr></table>
        <hr size="1" /></td></tr></table>
  <p> </p>
  <table border="0" cellspacing="4" cellpadding="4" width="585" class="g">
    <!--DWLayoutTable-->
    <tr  class="h"> 
      <td>Contrase&ntilde;a enviada</td>
    </tr>
    <tr> 
      <td class="t"><p>Su contrase&ntilde;a le ha sido enviada por correo electr&oacute;nico. 
          Considere que seg&uacute;n su velocidad de conexi&oacute;n al servicio 
          de correo, &eacute;sta podr&iacute;a tardar algunos minutos en llegar.</p>
        <p>Utilice esta contrase&ntilde;a para obtener acceso al portal, y considere 
          cambiarla por otra que sea f&aacute;cil de recordar para usted, pero 
          dif&iacute;cil de adivinar para otras personas.</p>
        </td>
    </tr>
      <tr> 
        <td colspan="2" align="center"><form action="." name="f"> 
            <input type="submit" id="s" value="Iniciar sesi&oacute;n" />
          </form></td>
      </tr>
  </table>
  </center>
</body>
</html>
