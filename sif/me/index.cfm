<cfparam name="Session.modulo" default="index">
<cfparam name="Session.Idioma" default="">
<cfif isdefined("Form.Idioma")>
	<cfset Session.Idioma = Form.idioma>
</cfif>
<cfset Session.modulo = 'index'>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuME.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>ME</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<cf_templatecss>
<link href="css/me.css" rel="stylesheet" type="text/css">
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
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top">
		<img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62">
	</td>
    <td valign="top" style="padding-left: 5; padding-bottom: 5;"> 
	  <cfinclude template="../Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  	
		  </td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5"> <!-- InstanceBeginEditable name="Titulo" --> 
              <cfoutput>#Request.Translate('SistemaME','Sistema Modelo Entidad','/sif/me/Utiles/Generales.xml')#</cfoutput><!-- InstanceEndEditable --> </font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
		  <!-- InstanceBeginEditable name="MenuJS" -->
			<cfinclude template="jsMenuME.cfm">
		  <!-- InstanceEndEditable -->	
		  </td>
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
    <td width="84" valign="top" nowrap>
      <cfinclude template="/sif/menu.cfm">
    </td>
    <td width="3" valign="top" nowrap>&nbsp;</td> 
    <td valign="top"> 
	  <!-- InstanceBeginEditable name="Mantenimiento" --> 
	  <!--- Consulta Tipos de Entidad --->
	  <cf_web_portlet border="true" titulo="#Request.Translate('SistemaME','Sistema Modelo Entidad','/sif/me/Utiles/Generales.xml')#" skin="#Session.Preferences.Skin#">
		<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="50%">&nbsp;</td>
          </tr>
        <tr> 
          <td><strong><font size="3"><img src="imagenes/SeleccioneOpcion.gif" editor="Webstyle3" moduleid="default (project)\SeleccioneOpcion.xws" border="0"></font></strong></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          </tr>
        <tr> 
          <td valign="top">
		    <table width="100%"  border="0" align="left" cellpadding="1" cellspacing="1">
			<tr>
              <td colspan="8">
			  	<cf_menutitle text="Catálogos" color="gray" alignText="center" width="100">
			  </td>
            </tr>
            <tr>
              <td width="2%" nowrap><font size="2">&nbsp;</font></td>
              <td width="5%" align="right" valign="middle" nowrap>
                <div align="center"><font size="2"><a href="admin/catalogos/TipoEntidad.cfm"><img src="../imagenes/flavour_bullet2.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
              <td width="93%" nowrap><font size="2"><a href="admin/catalogos/TipoEntidad.cfm">Cat&aacute;logo de Tipos de Entidades</a> </font></td>
              <td width="93%" nowrap>&nbsp;</td>
              <td width="93%" nowrap>&nbsp;</td>
              <td width="93%" nowrap>&nbsp;</td>
              <td width="93%" nowrap>&nbsp;</td>
              <td width="93%" nowrap>&nbsp;</td>
            </tr>
            <tr>
              <td nowrap><font size="2">&nbsp;</font></td>
              <td align="right" valign="middle" nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr>
              <td nowrap>&nbsp;</td>
              <td align="right" valign="middle" nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr>
              <td nowrap>&nbsp;</td>
              <td align="right" valign="middle" nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr>
              <td nowrap>&nbsp;</td>
              <td align="right" valign="middle" nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
              <td nowrap>&nbsp;</td>
            </tr>
          </table>		  </td>
          </tr>
      	</table>
	  </cf_web_portlet>
      <!-- InstanceEndEditable --> 
	  </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>