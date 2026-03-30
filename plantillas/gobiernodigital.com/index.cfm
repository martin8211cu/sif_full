<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<cfparam name="url.errormsg" default="0"> 
<cfparam name="url.uri" default="/cfmx/home/menu/index.cfm">
<cfif IsDefined('session.Usucodigo') and Len(session.Usucodigo) and Session.Usucodigo>
	<cflocation url="/cfmx/home/menu/portal.cfm">
</cfif>
<html>
<head>
<title>Inicio</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="login.js"></script>
<link type="text/css" rel="stylesheet" href="stylesheet.css">
<style type="text/css">
<!--
.border {
	border: 1px solid #000000;
}
-->
</style>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
 
<style type="text/css">
<!--
@import url("stylesheet.css");
-->
</style>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" marginwidth="0" marginheight="0" bottommargin="0">
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="eeeeee">
  <tr>
    <td><table width="955" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
          <td>
<div align="left">
              <table width="100%" border="0" cellpadding="0" cellspacing="0" background="images/temp/01-02.jpg">
<tr>
                  <td><div align="left"><img src="header.jpg" width="980" height="60"></div></td>
                </tr>
              </table>
</div></td>
        </tr>
        <tr> 
          <td background="images/temp/02-01.jpg"> 
<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" background="images/temp/02-01.jpg">
<tr> 
                <td><div align="center"><font size="2"><strong><font color="#666666" face="Arial, Helvetica, sans-serif"><a href="index.html" class="top">Inicio</a></font></strong></font></div></td>
                <td><div align="center"><font size="2"><strong><font color="#666666" face="Arial, Helvetica, sans-serif"><a href="esp/productos.html" class="top">Productos</a></font></strong></font></div></td>
                <td><div align="center"><font size="2"><strong><font color="#666666" face="Arial, Helvetica, sans-serif"><a href="esp/servicios.html" class="top">Servicios</a></font></strong></font></div></td>
                <td><div align="center"><font size="2"><strong><font color="#666666" face="Arial, Helvetica, sans-serif"><a href="esp/socios.html" class="top">Socios</a></font></strong></font></div></td>
                <td><div align="center"><font size="2"><strong><font color="#666666" face="Arial, Helvetica, sans-serif"><a href="esp/eventos.html" class="top">Eventos</a></font></strong></font></div></td>
                <td><div align="center"><font size="2"><strong><font color="#666666" face="Arial, Helvetica, sans-serif"><a href="esp/contacto.html" class="top">Cont&aacute;ctenos</a></font></strong></font></div></td>
                <td><img src="images/pixel.gif" width="1" height="30"></td>
              </tr>
            </table></td>
          <td background="images/temp/02-01.jpg">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="2">
            <table width="779" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="ffffff">
<tr> 
                <td width="779">            <table width="779" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="ffffff">
                <tr>
                  <td width="779"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
                                  <td width="67%" valign="top">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
  <tr>
                                    <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="512" height="239">
  <param name="movie" value="images/flash/flash01.swf">
                                        <param name="quality" value="high">
                                        <embed src="images/flash/flash01.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="512" height="239"></embed></object></td>
                                  </tr>
                                </table></td>
                                  <td width="33%" valign="top"> 
                                    <form name="login" onsubmit="this.j_empresa.value='*';return validarLogin(this);" action="<cfoutput>#url.uri#</cfoutput>" method="post" >
                                      <table width="98%" height="239" border="0" cellpadding="4" cellspacing="0" class="border">
                                        <tr>
                                    <td height="33" colspan="2"> 
  <div align="center">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr>
                                            <td><div align="center"><font color="2B3C6E" size="3" face="Arial, Helvetica, sans-serif"><strong>Login</strong></font></div></td>
                                          </tr>
                                        </table>
                                      </div></td>
                                  </tr>
                                  <tr>
                                    <td width="34%" height="30"><font color="2B3C6E" size="2" face="Arial, Helvetica, sans-serif">&nbsp;Email:</font></td>
                                    <td width="66%"> 
                            <input type="hidden" name="j_empresa" value="*" readonly="readonly" autocomplete="off">
	                            <input type="text" name="j_username" size="14" tabindex="2" onfocus="this.select()" ></td>
                                  </tr>
                                  <tr>
                                    <td height="30"><font color="2B3C6E" size="2" face="Arial, Helvetica, sans-serif">&nbsp;Contrase&ntilde;a:</font></td>
                                    <td><input type="password" name="j_password" size="14" tabindex="3" onfocus="this.select()" ></td>
                                  </tr>
                                  <tr>
                                    <td height="27" colspan="2"> 
  <div align="center">&nbsp;&nbsp;<font size="1" face="Arial, Helvetica, sans-serif">&nbsp;</font>
                                        <input type="checkbox" id="recordar" name="recordar" value="checkbox" tabindex="4">
                                        <font size="1" face="Arial, Helvetica, sans-serif"><label for="recordar">&nbsp;Recordar
                                        mi usuario en este computador</label></font></div></td>
                                  </tr>
                                  <tr> 
                                    <td height="32" colspan="2"> 
  <div align="center">
                                        <input name="conectarse" type="submit" id="conectarse" value="Conectarse">
                                      </div></td>
                                  </tr>
                                  <tr>
                                    <td height="40" colspan="2"> 
  <div align="center"><font color="2B3C6E" size="2" face="Arial, Helvetica, sans-serif"><strong><a href="#" class="conte">&iquest;Necesita 
                                        ayuda para ingresar?</a><br>
                                        <a href="#" class="conte">&iexcl;Olvide 
                                        mi contrase&ntilde;a!</a></strong></font></div></td>
                                  </tr>
                                  <tr>
                                    <td height="39" colspan="2"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
                                                <td width="38%"><div align="center"><a href="esp/demos.html" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','images/boton01_b.jpg',1)"><img src="images/boton01_a.jpg" name="Image5" width="117" height="29" border="0"></a></div></td>
                                                <td width="62%"><div align="center"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','images/boton02_b.jpg',1)"><img src="images/boton02_a.jpg" name="Image6" width="116" height="29" border="0"></a></div></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table></form></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr>
                        <td><table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
                                  <td width="32%" valign="top"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="border">
                                  <tr> 
                                        <td width="100%" background="images/tabla02_b.jpg"><font color="2B3C6E" size="3" face="Arial, Helvetica, sans-serif"><strong>&nbsp;&nbsp;Recursos 
                                          Humanos </strong></font></td>
                                    <td width="0%" background="images/tabla02_b.jpg"> 
                                      <div align="right"><img src="images/tabla02.jpg" width="4" height="24"></div></td>
                                  </tr>
                                  <tr> 
                                    <td height="113" colspan="2"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
                                          <td valign="top"><p align="center"><a href="esp/humanos.html"><img src="images/logoRH.jpg" width="180" height="59" border="0"></a></p>
                                                <p><img src="images/rechumano.jpg" width="115" height="115" hspace="4" vspace="0" align="left"><font size="2" face="Arial, Helvetica, sans-serif">Los 
                                                    Recursos Humanos es una de las 
                                                  &aacute;reas que demandan mayor 
                                                    atenci&oacute;n en las organizaciones. 
                                                  <strong><font color="#FF0000"><a href="esp/humanos.html" class="conte2">Ver 
                                                  m&aacute;s...</a></font></strong></font></p>
                                            </td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table></td>
                                  <td width="35%" valign="top"> 
                                    <table width="100%" height="143" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
  <tr> 
                                        <td width="100%" background="images/tabla02_b.jpg"><font color="2B3C6E" size="3" face="Arial, Helvetica, sans-serif"><strong>&nbsp;&nbsp;Financiero</strong></font></td>
                                    <td width="0%" background="images/tabla02_b.jpg"> 
                                      <div align="right"><img src="images/tabla02.jpg" width="4" height="24"></div></td>
                                  </tr>
                                  <tr valign="top"> 
                                    <td height="119" colspan="2"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
                                          <td><p align="center"><a href="esp/sif.html"><img src="images/logofinanciero.jpg" width="150" height="70" border="0"></a></p>
                                                <p><font size="2" face="Arial, Helvetica, sans-serif"><img src="images/financiero.jpg" width="98" height="105" hspace="4" align="left">El 
                                                    SIF es una soluci&oacute;n ERP 
                                                    que incluye todos los medios 
                                                    tecnol&oacute;gicos para planificar 
                                                    su eficiente administraci&oacute;n.</font> 
                                                  <strong> <font color="#FF0000" size="2" face="Arial, Helvetica, sans-serif"><a href="esp/sif.html" class="conte2"><br>
                                                Ver m&aacute;s...</a></font></strong></p>
                                            </td>
                                        </tr>
                                      </table>
                                      
                                  </td>
                                  </tr>
                                </table></td>
                                  <td width="33%" valign="top"> 
                                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="border">
  <tr> 
                                        <td width="96%" background="images/tabla02_b.jpg"><font color="2B3C6E" size="3" face="Arial, Helvetica, sans-serif"><strong>&nbsp;&nbsp;Educaci&oacute;n</strong></font></td>
                                        <td width="4%" background="images/tabla02_b.jpg"> 
                                          <div align="right"><img src="images/tabla02.jpg" width="4" height="24"></div></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr>
                                          <td><p align="center"><a href="esp/abc.html"><img src="images/logoeducacion.jpg" width="150" height="63" border="0"></a></p>
                                                <p><img src="images/educacion.jpg" width="77" height="108" hspace="4" align="left"><font size="2" face="Arial, Helvetica, sans-serif">Con 
                                                    esta aplicaci&oacute;n usted 
                                                    obtendr&aacute; una plataforma 
                                                    que le permitir&aacute; administrar 
                                                    los procesos operativos y educativos 
                                                    del Centro de Estudio. <strong><font color="#FF0000"><a href="esp/abc.html" class="conte2">Ver 
                                                    m&aacute;s...</a></font></strong> 
                                                  </font></p></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
            </table>
            <script type="text/javascript">
<!--
llenarLogin(document.login);
-->
            </script>            </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr background="images/temp/03-01.jpg"> 
<td colspan="2"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> 
                <td width="1%" background="images/temp/03-01.jpg"><img src="images/pixel.gif" width="8" height="34"></td>
                <td width="99%" background="images/temp/03-01.jpg"> 
                  <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" background="images/temp/03-01.jpg">
<tr> 
                      <td><div align="center"><font color="#FFFFFF" size="1" face="Arial, Helvetica, sans-serif">| 
                          <a href="index.html" class="bottom">inicio</a> | 
                          <a href="esp/productos.html" class="bottom">productos</a> 
                          | <a href="esp/servicios.html" class="bottom">servicios</a> 
                          | <a href="esp/socios.html" class="bottom">socios</a> 
                          | <a href="esp/eventos.html" class="bottom">eventos</a> 
                          | <a href="esp/contacto.html" class="bottom">cont&aacute;ctenos 
                          </a>| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MiGestion.com 
                          </font></div></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
          </td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
