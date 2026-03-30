<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Portal ASP</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/soinasp01/css/base/tabs.css">
<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/soinasp01/css/azul/azul.css">
<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/soinasp01/css/azul/portlet.css">
<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/gobiernodigital.com/portalnew.css">
<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/gobiernodigital.com/stylesheetnew.css">
</head>
<body style="margin:0px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  
  <td>
  <table width="955" border="0" cellpadding="0" cellspacing="0"
		  style="background:url(/cfmx/plantillas/gobiernodigital.com/header.jpg);background-repeat:no-repeat" align="center">
    <tr>
    
    <td width="955" align="right">
    
    <table width="530" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="382" height="33" align="right" valign="middle"><span class="toprightitems">
          <!---
		<a href="/cfmx/home/menu/micuenta/buzon.cfm">Mensajes</a> | --->
          <a href="/cfmx/home/index.cfm">Inicio</a> | <a href="/cfmx/home/menu/micuenta/index.cfm">Mi Cuenta</a> | <a href="/cfmx/home/menu/portlets/indicadores/personalizar.cfm">Personalizar</a> |
          <!---
		<a href="/cfmx/plantillas/portal/observaciones.cfm">Obs</a> | --->
          <a href="/cfmx/home/menu/passch.cfm">Cambiar contrase&ntilde;a</a> | <a href="/cfmx/home/public/logout.cfm">Salir</a> </span></td>
        <td width="10" align="right" valign="bottom">&nbsp;</td>
      </tr>
      <tr>
        <td height="27" align="right"><span class="toprightitems">
          <cfif session.Usucodigo>
            <cfoutput>#session.Usulogin#, #session.CEnombre#</cfoutput>
          </cfif>
          </span></td>
        <td align="right">&nbsp;</td>
      </tr>
    </table>
    <cfinclude template="/home/tramites/public/inst.cfm">
    </td>
    
    </tr>
    
  </table>
  </td>
  
  </tr>
  
  <tr>
    <td><table width="955" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff"  align="center">
        <tr>
          <td align="center"><table width="955" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff" align="center">
              <tr>
                <td align="center"></td>
              </tr>
              <tr>
                <td width="955">$$BODY$$</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td><table width="955" border="0" cellspacing="0" cellpadding="0"  align="center">
        <tr>
          <td width="1" ><img src="/cfmx/plantillas/gobiernodigital.com/images/pixel.gif" width="8" height="34" alt=""></td>
          <td width="954" ><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC" >
              <tr>
                <td align="center"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">[ <a href="/cfmx/home/index.cfm" class="bottom">inicio</a> | <a href="esp/productos.html" class="bottom">productos</a> | <a href="esp/servicios.html" class="bottom">servicios</a> | <a href="esp/socios.html" class="bottom">socios</a> | <a href="esp/eventos.html" class="bottom">eventos</a> | <a href="esp/contacto.html" class="bottom">cont&aacute;ctenos </a>] &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Gobierno Digital.com &trade; </font></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
