<html><!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="portlets.css" rel="stylesheet" type="text/css">
<link href="portlets.css" rel="stylesheet" type="text/css">
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
<link href="sif.css" rel="stylesheet" type="text/css">
<link href="sif.css" rel="stylesheet" type="text/css">

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
		<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"></td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n del Sistema</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="../jsMenuAD.cfm" ></td>
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
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->&nbsp;<!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->L&iacute;neas en Formatos<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" -->
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="2">
							<cfoutput>
							<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
							  <tr align="left"> 
								<td><a href="/sif/index.cfm">SIF</a></td>
								<td>|</td>
								<td nowrap><a href="/sif/ad/MenuAD.cfm">
								#Request.Translate('ModuloFI','Formatos de Impresion','/sif/Utiles/Generales.xml')#	
								</a></td>
								<td>|</td>
								<td width="100%"><a href="EFormatosImpresion.cfm?FMT01COD=#form.FMT01COD#">
								#Request.Translate('Regresar','Regresar','/sif/Utiles/Generales.xml')#
								</a></td>
							  </tr>
							</table>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td valign="top">
<style type="text/css">
	.cuadro2{
		border: 1px solid #FFFFFF;
	}
</style>

							<cfset tabla = "FMT09CLR + '<table align=''center'' bgcolor=''##' + FMT09CLR + ''' width=''50%'' heigth=''100%'' class=''cuadro2'' ><tr><td></td></tr></table>'"  >
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="FMT009"/>
								<cfinvokeargument name="columnas" value="FMT01COD, FMT09LIN, FMT09COL, FMT09FIL, FMT09CLR, FMT09HEI, FMT09HEI, FMT09GRS, #tabla# as tabla"/>
								<cfinvokeargument name="desplegar" value="FMT09COL, FMT09FIL, tabla"/>
								<cfinvokeargument name="etiquetas" value="Columna, Fila, Color L&iacute;nea"/>
								<cfinvokeargument name="formatos" value="V, V, V"/>
								<cfinvokeargument name="filtro" value="FMT01COD='#form.FMT01COD#'" />
								<cfinvokeargument name="align" value="left, left, center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="Nuevo" value=""/>
								<cfinvokeargument name="irA" value="FMTLineas.cfm"/>
								<cfinvokeargument name="Conexion" value="emperador"/>
								<cfinvokeargument name="MaxRows" value="50"/>
							</cfinvoke>

						</td>
						<td valign="top"><cfinclude template="formFMTLineas.cfm"></td>
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
