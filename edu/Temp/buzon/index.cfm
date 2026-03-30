<cfinclude template="../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenuGEN.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
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
<script language="JavaScript" src="../../js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
			<cfinclude template="../../portlets/pEmpresas2.cfm">
		  </td>
          <td rowspan="2" valign="top" nowrap> 
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td>
					<div align="center"><span class="superTitulo">
					<font size="5">
			  <!-- InstanceBeginEditable name="Titulo" --> 
	  			Buz&oacute;n de Mensajes
      		  <!-- InstanceEndEditable -->	
				  </font></span></div>
				  </td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
				<cfinclude template="consultas-frame-header.cfm">
			  	<cfinclude template="iconOptions.cfm">
      		  <!-- InstanceEndEditable -->	
				  </td>
				</tr>
			  </table>
		  </td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../../portlets/pminisitio.cfm">
		  </td>
        </tr>
      </table>
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="left" valign="top" nowrap></td>
    <td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td valign="top" nowrap>
		<cfinclude template="/sif/menu.cfm">
	</td>
    <td valign="top" width="100%">
	  <!-- InstanceBeginEditable name="Mantenimiento2" -->
	  	  <cfinclude template="frame-header.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tabContent">
				<cfif tabChoice eq 1>
					<cfinclude template="frame-listaMensajes.cfm">
				<cfelseif tabChoice eq 2>
					<cfinclude template="frame-nuevoMensaje.cfm">
				<cfelseif tabChoice eq 3>
					<cfinclude template="frame-verMensaje.cfm">
				<cfelseif tabChoice eq 4>
					<cfinclude template="frame-responderMensaje.cfm">
				<cfelse>
					<br>
					<div align="center">
					<b>Este m&oacute;dulo no est&aacute; disponible</b>
					</div>
					<br>
				</cfif>
			</td>
		  </tr>
		</table>
      <!-- InstanceEndEditable -->
	 </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
