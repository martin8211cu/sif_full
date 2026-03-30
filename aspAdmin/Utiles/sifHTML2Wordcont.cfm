<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
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
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">
			<cfquery name="rsModulo" datasource="#Session.DSN#">
				select Mdescripcion from Modulos where Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Modulo#">
			</cfquery>
			<cfoutput>#rsModulo.Mdescripcion#</cfoutput>
			<cftry>
			<cfheader name="Content-Disposition" value="attachment; filename=#rsModulo.Mdescripcion#_#Dateformat(Now(),'YYYYMMDD')#.doc">
			<cfcatch></cfcatch>
			</cftry>
			</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
		  <cftry>
		  	<cfinclude template="/sif/#Session.Modulo#/jsMenu#Session.Modulo#.cfm">
		  <cfcatch></cfcatch>
		  </cftry>
            </td>
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
		<cfif isdefined("url.Titulo")>
			<cfset titulo="#url.Titulo#">
		</cfif>		
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#titulo#">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
		  <cftry>
		  <cfinclude template="/sif/Portlets/pNavegacion#Session.Modulo#.cfm">
  		  <cfcatch></cfcatch>
		  </cftry>

			<cfif isdefined("url.Archivo") and len(trim(url.archivo)) gt 0>
				<cfif Findnocase('#Session.Usucodigo#_#Session.Ulocalizacion#',url.Archivo) GT 0> 
					<cftry>
						<cfcontent type="application/msword" file = "#GetTempDirectory()##url.Archivo#.doc" deletefile = "no">
					<cfcatch>
					<br>
						<blockquote>
						  <h4><font color="#993333">Advertencia:</font> <br><br>
						  &nbsp;&nbsp;El documento solicitado no existe o usted no tiene acceso. Proceso Cancelado!.
						  </h4>
					  </blockquote>
						<div align="center"><br>
						    <input type="button" name="Regresar" value="Regresar" onClick="javascript:history.back();"><br>
					      </div>
						  <br>
					</cfcatch>
					</cftry>
				<cfelse>
				<br>
					<blockquote>
					  <h4><font color="#993333">Advertencia:</font><br><br>
					  &nbsp;&nbsp;El documento solicitado no existe o usted no tiene acceso. Proceso Cancelado!.
					  </h4>
				  </blockquote>
					<div align="center"><br>
					    <input type="button" name="Regresar" value="Regresar" onClick="javascript:history.back();">
				      </div>
					  <br>
				</cfif>
			</cfif>   
            <!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>