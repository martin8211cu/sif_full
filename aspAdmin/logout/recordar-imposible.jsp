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
      <td width="1%"><a href="/"><img src="login-migestion.gif" alt="MiGestion" border="0" /></a></td>
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
      <td>Problemas iniciando la sesi&oacute;n</td>
    </tr>
    <tr> 
      <td class="t"><p>Su usuario <strong><c:out value="${param.login}" />
          </strong> tiene problemas para recuperar la contrase&ntilde;a, y es posible 
          que haya sido bloqueado. Por favor cont&aacute;ctenos para desbloquear 
          su usuario y poderle brindar una contrase&ntilde;a v&aacute;lida.</p>
        <p>Lamentamos los inconvenientes que esto le pueda causar.</p></td>
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
