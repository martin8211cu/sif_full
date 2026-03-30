<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/tAdmin.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Sistema de Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="../../css/educ.css" rel="stylesheet" type="text/css">
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
<script  language="JavaScript" src="../../js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top">
		<img src="../../imagenes/logo2.gif" width="154" height="62">
	</td>
    <td valign="top" style="padding-left: 5; padding-bottom: 5;"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="/sif/portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  	<cfinclude template="/sif/portlets/pEmpresas2.cfm">
		  </td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5"> <!-- InstanceBeginEditable name="Titulo" --> 
				Administraci&oacute;n del Sistema
            <!-- InstanceEndEditable --> </font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
		  <!-- InstanceBeginEditable name="MenuJS" --> 
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
      <cfinclude template="../../abcdefg.cfm">
    </td>
    <td width="3" valign="top" nowrap>&nbsp;</td> 
    <td valign="top"> 
	  <!-- InstanceBeginEditable name="Mantenimiento" -->
		<cf_web_portlet skin="#Session.Preferences.Skin#" titulo="Organización de Unidades Acad&eacute;micas">
		    <!--- variables para el portlet de navegación --->
			
			<cfset titulo = "Organización de Unidades Académicas">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Unidades Acad&eacute;micas">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" width="60%" style="padding-left: 10px;">
						<cfinclude template="estructOrgaz_arbol.cfm">
					</td>
					<td width="40%" valign="top" align="center">
						<cfinclude template="estructOrgaz_form.cfm">
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
			</cf_web_portlet>
		<!-- InstanceEndEditable --> 
	  </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
