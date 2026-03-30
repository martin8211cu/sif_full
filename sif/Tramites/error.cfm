<html><!-- InstanceBegin template="/Templates/Tramites.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<!-- InstanceEndEditable -->
<cf_templatecss>
<cf_templatecss>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<cf_templatecss>
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="middle"><img src="/cfmx/sif/Imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="top" style="padding-left: 5; padding-bottom: 5;">
	
	<cfinclude template="../portlets/pubica.cfm">  
	
	  </td>
  </tr>
  <tr> 
    <td valign="top">
	 
        
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  <!--- [ Empresas iba aqui ] --->
		  </td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Tr&aacute;mite 
              de Pasaporte</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <!-- InstanceBeginEditable name="Menu" --><cfinclude template="jsTramites.cfm" ><!-- InstanceEndEditable --></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      	
	
		</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="84" align="left" valign="top" nowrap>
	  </td>
    <td width="661" height="1" align="left" valign="top">
	   
      </td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap>  
       
	  <cfinclude template="/sif/menu.cfm">
	  </td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="/cfmx/sif/Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Tr&aacute;mite 
            de Pasaporte<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="/cfmx/sif/Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">

<!-- InstanceBeginEditable name="Contenido" -->
<table width="100%" border="0" cellpadding="2">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td style="font:larger"><form action="javascript:history.back()" method="get">
	<p>Ha ocurrido el siguiente error procesando su solicitud:</p>
	<p style="color:red; font:bold">
<cfif NOT isDefined("url.msg")>
	Sin especificar<br>
<cfelseif #url.msg# EQ "tpid-faltante">
  N&uacute;mero de tr&aacute;mite inv&aacute;lido<br>
<cfelseif #url.msg# EQ "tpid-invalido">
  N&uacute;mero de tr&aacute;mite inv&aacute;lido<br>
<cfelseif #url.msg# EQ "sin-cedula">
  El n&uacute;mero de c&eacute;dula es requerido<br>
<cfelseif #url.msg# EQ "accion-invalida">
  La acci&oacute;n solicitada es inv&aacute;lida<br>
<cfelseif #url.msg# EQ "moneda-invalida">
  Error interno: la moneda es inv&aacute;lida<br>
<cfelse>
  <cfoutput>#url.msg#</cfoutput><br>
</cfif></p>
<input type="submit" value="Regresar">
</form></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<!-- InstanceEndEditable -->
</td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
