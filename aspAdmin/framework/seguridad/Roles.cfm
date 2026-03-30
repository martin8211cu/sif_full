<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
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
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
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

		<script src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript1.2" type="text/javascript">
		
			/* ====== QForms ====== */
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
			//Funciones que utilizan el objeto Qform.
		
			//definicion del color de los campos con errores de validación para cualquier instancia de qforms
			qFormAPI.errorColor = "#FFFFCC";
			/* ====== QForms ====== */
		</script>

		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Roles">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 

			<cfif isdefined("url.sistema") and not isdefined("form.sistema")>
				<cfset form.sistema = url.sistema >
			</cfif>

			<cfset navegacion = "&sistema=#form.sistema#" >
			
			<cfif isdefined("form.CAMBIO")>
				<cfset modo = "CAMBIO">
			<cfelse>
				<cfif isdefined("url.modo") and not isdefined("form.modo")>
					<cfset modo="CAMBIO">
				<cfelseif not isdefined("form.modo")>
					<cfset modo="ALTA">
				<cfelseif form.modo EQ "CAMBIO">
					<cfset modo="CAMBIO">
				<cfelse>
					<cfset modo="ALTA">
				</cfif>
			</cfif>

			<table width="100%" cellpadding="0" cellspacing="0" >
				<tr>
					<td colspan="2">
						<cfset regresar = "javascript:regresar();" >
						<cfinclude template="../portlets/pNavegacion.cfm">
					</td>
				</tr>

				<tr>
					<td width="50%" valign="top">
						<cfset columnas = "convert(varchar, Rolcod) as Rolcod, sistema, rol, nombre, descripcion, Rolinfo, '#form.modulo#' as modulo" >
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pLista"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="Rol"/>
							<cfinvokeargument name="columnas" value="#columnas#"/>
							<cfinvokeargument name="desplegar" value="rol,nombre"/>
							<cfinvokeargument name="etiquetas" value="Rol,Nombre"/>
							<cfinvokeargument name="formatos" value="V,V"/>
							<cfinvokeargument name="filtro" value="sistema='#form.sistema#' and activo=1 order by rol"/>
							<cfinvokeargument name="align" value="left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>				
							<cfinvokeargument name="irA" value="Roles.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="formName" value="listaRol"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="keys" value="rol"/>
						</cfinvoke>
					</td>
					
					<td width="50%" valign="top">
						<cfinclude template="formRoles.cfm">
					</td>
					
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
<!-- InstanceEnd --></html>