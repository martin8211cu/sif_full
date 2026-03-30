<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>ASP_ADMIN</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
<link href="/cfmx/aspAdmin/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/cfmx/aspAdmin/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/aspAdmin/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="portlets/pubica.cfm">
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
            <cfinclude template="/sif/framework/jsMenuFM.cfm" ></td>
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
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/aspAdmin/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Administraci&oacute;n del Framework">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
	  <!--- Consulta UsarCarta --->
	  <cfinclude template="portlets/pUsarCarta.cfm">
      <table width="80%" border="0" align="center" cellpadding="1" cellspacing="2">
        <tr> 
          <td colspan="7">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="7"><img src="imagenes/SeleccioneOpcion.gif" editor="Webstyle3" moduleid="default (project)\SeleccioneOpcion.xws" border="0"></td>
        </tr>
        <tr> 
          <td colspan="7">&nbsp;</td>
        </tr>
        <tr> 
          <td width="1%"><font size="2">&nbsp;</font></td>
          <td colspan="2" align="left" valign="middle"><strong><font color="#666666" size="4">Aplicaci&oacute;n</font></strong></td>
          <td width="2%">&nbsp;</td>
          <td></td>
          <td colspan="2" align="left"><strong><font color="#666666" size="4">Administraci&oacute;n 
            Empresarial </font></strong></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td width="4%" align="right" valign="middle"> <div align="center"><font size="2"><a href="aplicacion/SistemasPrincipal.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td width="41%"><font size="2"><a href="aplicacion/SistemasPrincipal.cfm">Sistemas,
          			Roles y M&oacute;dulos</a></font></td>
          <td>&nbsp;</td>
          <td width="2%"><font size="2">&nbsp;</font></td>
          <td width="3%" align="right" valign="middle"> <div align="center"><font size="2"><a href="cuentas/CuentaPrincipal_tabs.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td width="47%"><font size="2"><a href="cuentas/CuentaPrincipal_tabs.cfm">Cuentas 
            Empresariales</a></font></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="servicio/Servicio.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="servicio/Servicio.cfm"><font size="2">Servicios y Procesos</font></a></td>
          <td>&nbsp;</td>
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"> <div align="center"><font size="2"><a href="empresas/EmpresasPrincipal.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td><font size="2"><a href="empresas/EmpresasPrincipal.cfm">Empresas</a></font></td>
        </tr>
        <tr>
        	<td>&nbsp;</td>
        	<td align="right" valign="middle"><div align="center"><font size="2"><a href="exportar/exportar.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
        	<td nowrap><a href="exportar/exportar.cfm"><font size="2">Exportar</font></a></td>
        	<td>&nbsp;</td>
        	<td></td>
        	<td>
            	<div align="center"><font size="2"><a href="empresas/listaCaches.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
        	<td><font size="2"><a href="empresas/listaCaches.cfm">Cach&eacute;s
        				Empresariales</a></font></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="importar/Import.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="importar/Import.cfm"><font size="2">Importar</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="consultas/servicios.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="consultas/servicios.cfm"><font size="2">Listado</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td colspan="2" align="left" valign="middle">&nbsp;</td>
          <td>&nbsp;</td>
          <td></td>
          <td colspan="2" align="left">&nbsp;</td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td colspan="2" align="left" valign="middle"><strong><font color="#666666" size="4">Usuarios</font></strong></td>
          <td>&nbsp;</td>
          <td></td>
          <td colspan="2" align="left"><strong><font color="#666666" size="4">Afiliaci&oacute;n</font></strong></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="usuarios/listaUsuariosEmpresariales.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="usuarios/listaUsuariosEmpresariales.cfm"><font size="2">Usuarios 
            Empresariales</font></a></td>
          <td>&nbsp;</td>
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="afiliacion/cons_usuario.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="afiliacion/cons_usuario.cfm"><font size="2">Consulta 
            de Usuario</font></a></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="center" valign="middle"><a href="usuarios/listaCuentaPersonal.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></td>
          <td nowrap><a href="usuarios/listaCuentaPersonal.cfm"><font size="2">Cuentas Personales</font></a></td>
          <td>&nbsp;</td>
          <td><font size="2">&nbsp;</font></td>
          <td align="center" valign="middle"><a href="afiliacion/cartas_usuario.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></td>
          <td nowrap><a href="afiliacion/cartas_usuario.cfm"><font size="2"><cfif usarCarta>Imprimir Cartas<cfelse>Afiliar</cfif></font></a></td>
        </tr>
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="center" valign="middle"><a href="roles/RolesInternos.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></td>
          <td nowrap><a href="roles/RolesInternos.cfm"><font size="2">Roles Internos</font></a></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td align="center" valign="middle">
		  <cfif usarCarta>
		  	<a href="afiliacion/recibo/recibo.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a>
		  </cfif>
		  </td>
          <td nowrap>
		  <cfif usarCarta>
		  	<a href="afiliacion/recibo/recibo.cfm"><font size="2">Recibir Cartas</font></a>
		  </cfif>
		  </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td colspan="2" align="left" valign="middle">&nbsp;</td>
          <td>&nbsp;</td>
          <td></td>
          <td colspan="2" align="left">&nbsp;</td>
        </tr>		
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td colspan="2" align="left" valign="middle"><strong><font color="#666666" size="4">Cat&aacute;logos</font></strong></td>
          <td>&nbsp;</td>
          <td></td>
          <td colspan="2" align="left"><strong></strong></td>
        </tr>		
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/tipoIdentificacion.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/tipoIdentificacion.cfm"><font size="2">Tipo
                de Identificaciones</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/tipoFuncionario.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/tipoFuncionario.cfm"><font size="2">Tipo
                de Funcionarios</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/idioma.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/idioma.cfm"><font size="2">Idioma</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/paises.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/paises.cfm"><font size="2">Paises</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>	
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/formaPago.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/formaPago.cfm"><font size="2">Formas de Pago</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/TarifaCalculo.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/TarifaCalculo.cfm"><font size="2">Indicadores 
            Tarifarios</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle"><div align="center"><font size="2"><a href="cata/paquete.cfm"><img src="imagenes/flavour_bullet3.gif" editor="Webstyle3" moduleid="Default (Project)\flavour_bullet2.xws" border="0"></a></font></div></td>
          <td nowrap><a href="cata/paquete.cfm"><font size="2">Paquetes</font></a></td>
          <td>&nbsp;</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>													
        <tr> 
          <td><font size="2">&nbsp;</font></td>
          <td align="right" valign="middle">&nbsp;</td>
          <td nowrap>&nbsp;</td>
          <td>&nbsp;</td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </table>	  
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd -->
</html>