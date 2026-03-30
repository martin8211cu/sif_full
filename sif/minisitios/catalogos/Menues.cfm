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
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><cfinclude template="../portlets/pEmpresas2.cfm"></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Menues</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <!---<cfinclude template="jsMenuAF.cfm" >---></td>
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
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->&nbsp;<!-- InstanceEndEditable --></td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menues">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
	
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td colspan="2"><cfinclude template="../portlets/pNavegacionMIN.cfm"></td></tr>
					<tr>
						<td valign="top" width="40%">
							<cfinvoke 
							 component="edu.Componentes.pListas"
							 method="pListaEdu"
							 returnvariable="pListaEduRet">
								<cfinvokeargument name="Conexion" value="sdc"/>
								<cfinvokeargument name="tabla" value="MSMenu"/>
								<cfinvokeargument name="columnas" value="convert(varchar,MSMmenu) as MSMmenu, replicate('&nbsp;', MSMprofundidad * 3) + MSMtexto as MSMtexto, MSPcodigo"/>
								<cfinvokeargument name="desplegar" value="MSMtexto"/>
								<cfinvokeargument name="etiquetas" value="Menú"/>
								<cfinvokeargument name="formatos" value="V"/>
								<cfinvokeargument name="filtro" value="Scodigo = #session.Scodigo# order by MSMpath"/>
								<cfinvokeargument name="align" value="S"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value=""/>
								<cfinvokeargument name="keys" value="MSMmenu"/>
							</cfinvoke>
						</td>
						<td valign="top" width="60%"><cfinclude template="formMenues.cfm"></td>
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