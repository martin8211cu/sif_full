<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=iso-8859-1"
	language="java" import="" errorPage="" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<html>
<head><title>MiGesti&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" >
<link href="login.css" rel="stylesheet" type="text/css">
</head>
<body>
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
    <tr  class="h"> 
      <td>Problemas iniciando la sesi&oacute;n</td>
    </tr>
    <tr> 
      <td class="t"><p>&iquest;Olvid&oacute; su contrase&ntilde;a? Si es as&iacute;, llene 
          este formulario para obtener estos datos nuevamente.<br>
          Deber&aacute; responder a una pregunta personal antes de poder obtener 
          su contrase&ntilde;a, la cual le ser&aacute; enviada por correo electr&oacute;nico.</p>
        </td>
    </tr>
    <tr>
      <td class="err"><c:out value="${param.error}" /></td>
    </tr>
  </table>
  <br />
  <form method="post" name="f" action="recordar-apply.jsp" >
    <table width="585" cellspacing="4" cellpadding="4" border="0" class="g" >
      <!--DWLayoutTable-->
      <tr > 
        <td colspan="2" class="h">&iquest;Olvid&oacute; su contrase&ntilde;a?</td>
      </tr>
      <tr> 
        <td width="189" height="30" valign="top" class="e"> Digite 
          su usuario: </td>
        <td width="366" valign="top" class="e">
		<c:choose>
		<c:when test="${empty param.login}" >
		<input type="text" name="login" value="" size="30" />
          <br />
           Por ejemplo: <b>dmontero</b> o <b>rmata</b> 
		</c:when>
		<c:otherwise>
		<strong><%= request.getParameter("login") %></strong>
		<input type="hidden" name="login" value="<%= request.getParameter("login") %>" size="30" /> 
		</c:otherwise>
		</c:choose>
        </td>
      </tr>
		<c:if test="${not empty param.pregunta}" >
      <tr>
        <td class="e" colspan="2"> Por favor, responda a la siguiente pregunta 
          con la misma respuesta que suministr&oacute; cuando ingres&oacute; al 
          portal por primera vez.</td>
      </tr>
      <tr>
        <td class="e">
		<c:out value="${param.pregunta}"/></td>
        <td valign="top" class="e"> 
          <input type="text" name="respuesta" value="" size="30" />
		  <input type="hidden" name="retry" value="<c:out value='${param.retry}'/>" />
        </td>
      </tr>
		</c:if>
      <tr> 
        <td colspan="2" align="center"><p> 
            <input type="button" value="Cancelar" onClick="self.location.href='.'" />
            <input type="submit" value="Continuar &gt; " />
          </p></td>
      </tr>
    </table>
  </form></center>
		<script type="text/javascript">
		<!--
		<c:choose>
		<c:when test="${empty param.login}" >
				document.f.login.focus();
		</c:when>
		<c:when test="${not empty param.pregunta}" >
				document.f.respuesta.focus();
		</c:when>
		</c:choose>
		//-->
		</script>
</body>
</html>
