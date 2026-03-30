<cfinclude template="../../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>educ</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="<cfoutput>#session.rutaCSS#</cfoutput>portlets.css" rel="stylesheet" type="text/css">
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
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<link href="<cfoutput>#session.rutaCSS#</cfoutput>sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="<cfoutput>#session.rutajs#</cfoutput>DHTMLMenu3.5/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="middle"><img src="/cfmx/educ/Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="top" style="padding-left: 5; padding-bottom: 5;"><!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
<cfinclude template="../../portlets/pEmpresas2.cfm"></td>
          <td width="50%" nowrap> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n del Centro de Estudio</font></span></div></td>
        </tr>
        <tr class="area"> 
	          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="../jsMenuCED.cfm">
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top"><!-- InstanceBeginEditable name="Ubica" -->
	<cfinclude template="../../portlets/pubica.cfm">
	<!-- InstanceEndEditable --></td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="84" align="left" valign="top" nowrap><!-- InstanceBeginEditable name="Menu0" -->Menu0&nbsp;<!-- InstanceEndEditable --></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->Titulo1<!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap> <!-- InstanceBeginEditable name="Menu1" -->Menu1&nbsp;<!-- InstanceEndEditable --></td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="/cfmx/educ/Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Tablas de Evaluaci&oacute;n<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="/cfmx/educ/Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" -->
		  
			<table width="100%" border="0" cellpadding="2" cellspacing="2">
		  		<tr><td >
					<cfoutput>
					<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
					  <tr align="left"> 
						<td><a href="##">Educaci&oacute;n</a></td>
						<td>|</td>
						<td nowrap><a href="#session.rutaAD#MenuAD.cfm">Administración</a></td>
						<td>|</td>
						<td width="100%"><a href="#session.rutaAD#catalogos/listaEvaluacionPlan.cfm">Regresar</a></td>
					  </tr>
					</table>
					</cfoutput>
				</td></tr>		
				<tr>
					<td valign="top"><cfinclude template="formTEvaluacionMateria.cfm"></td>
				</tr>
		  	</table>
		   
            <!-- InstanceEndEditable --></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
