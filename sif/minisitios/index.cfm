<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuMIN.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
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
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><cfinclude template="../portlets/pEmpresas2.cfm"></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n de Minisitios </font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap><!---<cfinclude template="jsMenuAF.cfm" >---></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->	
	
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="84" align="left" valign="top" nowrap></td> 
    <td width="3" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Administraci&oacute;n de Minisitios">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 

				<cfset ts =  LSDateFormat(Now(), 'ddmmyyyy') & LSTimeFormat(Now(),'hhmmss')>

				<link href="/cfmx/edu/css/edu.css" rel="stylesheet">
				<cfoutput>
				<table width="100%">
					<tr><td height="30px">&nbsp;</td></tr>
					<tr>
						<td class="titulo2" align="center"><a href="catalogos/Categorias.cfm"><img border="0" src="imagenes/categorias.gif" /><br/>Categor&iacute;as</a></td>
						<td class="titulo2" align="center"><a href="catalogos/Menues.cfm"><img border="0" src="imagenes/menu.gif" /><br/>Men&uacute;</a></td>
						<td class="titulo2" align="center"><a href="catalogos/Paginas.cfm"><img border="0" src="imagenes/paginas.gif" /><br/>P&aacute;ginas</a></td>
					</tr>
					
					<tr><td height="60px">&nbsp;</td></tr>
					
					<tr>
						<td class="titulo2" align="center"><a href="catalogos/Contenidos.cfm"><img border="0" src="imagenes/contenido.gif" /><br/>Contenido</a></td>
						<td class="titulo2" align="center"><a href="catalogos/Constructor.cfm"><img border="0" src="imagenes/constructor.gif" /><br/>Constructor del Sitio</a></td>
						<td class="titulo2" align="center"><a href="generacion/generar2.cfm?a=#ts#"><img border="0" src="imagenes/generacion.gif" /><br/>Generaci&oacute;n del sitio</a></td>
					</tr>

					<tr>
						<td class="" align="center"><a href="operacion/Menu.cfm"><br/><b>IR A NUEVA VERSION</b></a></td>
					</tr>

					<tr><td height="30px">&nbsp;</td></tr>					
				</table>
				</cfoutput>
	
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>