<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<link href="../../css/sif.css" rel="stylesheet" type="text/css">
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
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><!--- <cfinclude template="../portlets/pEmpresas2.cfm"> ---></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="/aspAdmin/framework/jsMenuFM.cfm" ></td>
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
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Afiliaci&oacute;n de usuarios">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
	<br>
	<table width="90%" align="center" class="ayuda" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>&nbsp;</td>
	</tr>
	<tr>
	<td>
	<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
		<cfif not isdefined("url.err") or url.err eq 0>
		  <tr>
			<td ><b>Operaci&oacute;n completa</b></td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td ><cfoutput>#url.ok#</cfoutput> usuarios afiliados exitosamente.</td>
		  </tr>
		<cfelse>
		  <tr>
			<td ><b>Hubo problemas con la afiliaci&oacute;n.</b></td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td >
				De un total de <cfoutput>#url.ok+url.err#</cfoutput> usuarios, se procesaron
					<cfoutput>#url.ok#</cfoutput>
					exitosamente y
					<cfoutput>#url.err#</cfoutput>
					con error.<br>
				Comun&iacute;quese con soporte t&eacute;cnico para obtener una soluci&oacute;n
				a este problema. Incluya los detalles t&eacute;cnicos especificados a continuaci&oacute;n,
				as&iacute; como la fecha y hora del error.
			</td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td ><b>Detalles t&eacute;cnicos</b></td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>
				El último error fue 
				<cfoutput>#url.etxt#</cfoutput>
				para el usuario n&uacute;m 
				<cfoutput>#url.eloc# - #url.euid#</cfoutput>.
			</td>
		  </tr>
		</cfif>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td nowrap>
			<form action="cartas_usuario.cfm"><input type="submit" value="Regresar"></form>
		</td>
	  </tr>
	</table>
	</td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	</tr>
	</table>
	<br>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>