<html>
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">


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

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;">  
		<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
      <cfinclude template="../../portlets/pubica.cfm">      </td>
  </tr>
  <tr> 
    <td valign="top">      <table width="100%" border="0" cellpadding="0" cellspacing="0">
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
      </table>		</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="84" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top">&nbsp;</td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">Encabezado de Formatos de Impresi&oacute;n</td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">

				<cfif isdefined("url.FMT01COD") and Len(Trim("url.FMT01COD")) gt 0 >
					<cfset form.FMT01COD = url.FMT01COD >
				</cfif>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr><td colspan="2">
						<cfoutput>
						<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
						  <tr align="left"> 
							<td><a href="/sif/index.cfm">SIF</a></td>
							<td>|</td>
							<td nowrap><a href="listaFormatos.cfm">
							Formatos de Impresion
							</a></td>
							<td>|</td>
							<td width="100%"><a href="listaFormatos.cfm">
							Regresar
							</a></td>
						  </tr>
						</table>
						</cfoutput>
					</td></tr>
					<tr>
						<td></td>
						<td><cfinclude template="formEFormatosImpresion.cfm"></td>
					</tr>
			</table></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
