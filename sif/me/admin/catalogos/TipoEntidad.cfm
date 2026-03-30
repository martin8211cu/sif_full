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
<link href="../../css/me.css" rel="stylesheet" type="text/css">
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
	  <cfinclude template="../../../Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../../portlets/pubica.cfm">
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
			<cfinclude template="../../jsMenuME.cfm">
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
	  <cf_web_portlet border="true" titulo="Tipos de Entidad" skin="#Session.Preferences.Skin#">
		
		<cfinclude template="../../portlets/pNavegacion.cfm">
		
		<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
		  <tr>
			<td valign="top" width="30%">
				<!--- Filtro de Tipos de Entidad--->
				<cfinclude template="filtroTipoEntidad.cfm">
				<!--- Lista de Tipos de Entidad --->
				<cfinvoke 
					component="sif.me.Componentes.pListas"
					method="pListaME"
					returnvariable="pListaMERet">
					<cfinvokeargument name="tabla" value="METipoEntidad"/>
					<cfinvokeargument name="columnas" value="METEid, METEformato, METEdesc"/>
					<cfinvokeargument name="desplegar" value="METEformato, METEdesc"/>
					<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="filtro" value="#filtro#"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="TipoEntidad.cfm"/>
					<cfinvokeargument name="Conexion" value="#session.DSN#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="METEid"/>
					<cfinvokeargument name="MaxRows" value="15"/>
				</cfinvoke>
			</td>
			<td valign="top" width="70%">
			<cfparam name="Form.TABSEL" default="0" type="numeric">
			<cfinclude template="formTipoEntidad.cfm">
			</td>
		  </tr>
		</table>
		
		<cfif modo neq "ALTA">
		  <script language="javascript1.4" type="text/javascript">
				function TabChange(TabSel) {
					document.formTabSel.TABSEL.value=TabSel;
					document.formTabSel.submit();
				}
			</script>
		  <cfoutput>
			<form action="TipoEntidad.cfm" method="post" name="formTabSel">
				<input name="METEid" type="hidden" value="#Form.METEid#">
				<input name="TABSEL" type="hidden" value="#Form.TABSEL#">
				<input name="MODO" type="hidden" value="#Form.MODO#">
			</form>
			<table border="0" cellspacing="0" cellpadding="5" width="100%">
			<tr>
			  <td class="<cfif Form.TABSEL eq 0>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<a href="javascript:TabChange('0');" tabindex="-1">						
					Características
				</a>
			  </td>
			  <td class="<cfif Form.TABSEL eq 1>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<a href="javascript:TabChange('1')" tabindex="-1">						
					Relaciones Permitidas
				</a>
			  </td>
			  <td class="<cfif Form.TABSEL eq 2>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<a href="javascript:TabChange('2')" tabindex="-1">						
					Servicios Relacionados
				</a>
			  </td>
			  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
			</tr>
			</table>    
		  </cfoutput>
		  <table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			  <td class="tabContent">
				  <cfswitch expression="#Form.TABSEL#">
					<cfcase value="0">
						<cfinclude template="formCaracteristica.cfm">
					</cfcase>
					<cfcase value="1">
						<cfinclude template="formRelacionPermitida.cfm">
					</cfcase>
					<cfcase value="2">
						<cfinclude template="formServicios.cfm">
					</cfcase>
				  </cfswitch>
			  </td>
			</tr>
		  </table>
		</cfif>
		
	  </cf_web_portlet>
      <!-- InstanceEndEditable --> 
	  </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>