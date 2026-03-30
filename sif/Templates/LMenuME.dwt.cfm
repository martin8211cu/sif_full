<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>ME</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
<cf_templatecss>
<link href="../me/css/me.css" rel="stylesheet" type="text/css">
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
	  <!-- TemplateBeginEditable name="Ubica" --> 
      <cfinclude template="../portlets/pubica.cfm">
      <!-- TemplateEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  	
		  </td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5"> <!-- TemplateBeginEditable name="Titulo" --> 
               <cfoutput>#Request.Translate('SistemaME','Sistema Modelo Entidad','/sif/me/Utiles/Generales.xml')#</cfoutput><!-- TemplateEndEditable --> </font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
		  <!-- TemplateBeginEditable name="MenuJS" -->
			<cfinclude template="../me/jsMenuME.cfm">
		  <!-- TemplateEndEditable -->	
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
	  <!-- TemplateBeginEditable name="Mantenimiento" --> 
	  <cf_web_portlet border="true" titulo="titulo" skin="#Session.Preferences.Skin#">
		<cfinclude template="../me/portlets/pNavegacion.cfm">
		
	  </cf_web_portlet>
      <!-- TemplateEndEditable --> 
	  </td>
  </tr>
</table>
</body>
</html>