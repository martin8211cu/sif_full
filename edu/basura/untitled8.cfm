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
<link href="../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../css/edu.css" rel="stylesheet" type="text/css">
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
<script language="JavaScript" src="../js/DHTMLMenu/stm31.js"></script>
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
    <td width="154" rowspan="2" align="center" valign="top"><img src="../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      
		<table class="area" width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="25%" style="padding-left: 5px;">
					<a href="/jsp/sdc/org/agenda/">
						<img alt="Ir a agenda personal" src="/cfmx/edu/Imagenes/agenda.gif" width="32" height="25" align="ABSMIDDLE" border="0" />
					</a>
					<a href="/jsp/sdc/org/agenda/">
					06 de Agosto de 2003
					
					</a>
				</td>
				<td class="tituloAlterno" width="50%">
					
							<a href="/jsp/sdc/cfg/cfg/usuario.jsp">Marielena Guardia  </a>
							<a href="/jsp/sdc/cfg/cfg/usuario.jsp"><img alt="Ir a configuraci&oacute;n personal" src="/cfmx/edu/Imagenes/yo.gif" width="32" height="25" align="ABSMIDDLE" border="0" /></a>
					
				</td>
				<td align="right" width="25%" style="padding-right: 5px;">
					<a href="/jsp/sdc/org/buzon/">Tiene 1 mensaje</a>
					<a href="/jsp/sdc/org/buzon/"><img alt="ir al buz&oacute;n" src="/cfmx/edu/Imagenes/buzon.gif" width="34" height="23" align="ABSMIDDLE" border="0" /></a> 
				</td>
			</tr>
		</table>
	
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
			<cfinclude template="../portlets/pEmpresas2.cfm">
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
				
	<form name="doForm" action="#GetFileFromPath(GetTemplatePath())#" method="post" style="margin: 0">
		<table border="0" cellspacing="0" cellpadding="2" align="right">
		  <tr align="center">
		  
			<td style="padding-right: 20px;"><img src="../Imagenes/email/totrash.gif" width="25" height="26"></td>
		  </tr>
		  <tr align="center">
		  
			<td style="padding-right: 20px;"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>Eliminar</strong></font></td>
		  </tr>
		</table>
	</form>

      		  <!-- InstanceEndEditable -->	
				  </td>
				</tr>
			  </table>
		  </td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../portlets/pminisitio.cfm">
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
    <table border="0" cellspacing="0" cellpadding="5" width="100%">
      <tr>
        <td class="tabSelected" nowrap> <a href="mensajes.cfm?o=1" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"> Buz&oacute;n
            de Entrada </a> </td>
        <td class="tabNormal" nowrap> <a href="mensajes.cfm?o=2" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"> Nuevo
            Mensaje </a> </td>
        <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
      </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="tabContent">
          <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td> <b>Usted tiene 1 mensaje(s)</b> </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>
                <script type="text/javascript" language="JavaScript" src="/cfmx/edu/js/pLista1.js"></script>
                <link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
                <script type="text/javascript" language="JavaScript">
			function funcChkAll(c) {
				if (document.lista.chk.value) {
					if (!document.lista.chk.disabled) document.lista.chk.checked = c.checked;
				} else {
					for (var counter = 0; counter < document.lista.chk.length; counter++) {
						if (!document.lista.chk[counter].disabled) document.lista.chk[counter].checked = c.checked;
					}
				}
			}
		</script>
                <form style="margin: 0" action="mensajes.cfm" method="post" name="lista" id="lista" >
                  <input type="hidden" name="modo" value="ALTA">
                  <input name="columnas" type="hidden" value="BCODIGO,BESTADO,BFECHA,BMENSAJE,BORIGEN,BTITULO">
                  <input name="CEcodigo2" type="hidden" value="5">
                  <input name="BCODIGO" type="hidden" value="">
                  <input name="BESTADO" type="hidden" value="">
                  <input name="BFECHA" type="hidden" value="">
                  <input name="BMENSAJE" type="hidden" value="">
                  <input name="BORIGEN" type="hidden" value="">
                  <input name="BTITULO" type="hidden" value="">
                  <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                      <td class="tituloListas" align="left" width="18" height="17" nowrap></td>
                      <td class="tituloListas" align="center" width="1%"><input class="tituloListas" type="checkbox" name="chkAllItems" value="1" onClick="javascript: funcChkAll(this);">
                      </td>
                      <td class="tituloListas" align="left"><strong>Origen</strong></td>
                      <td class="tituloListas" align="left"><strong>Asunto</strong></td>
                      <td class="tituloListas" align="left"><strong>Fecha</strong></td>
                    </tr>
                    <tr class="listaNon" onMouseOver="style.backgroundColor='#E4E8F3';" onMouseOut="style.backgroundColor='#FFFFFF';">
                      <td align="left" width="18" height="18" nowrap onClick="javascript: Procesar('1','6','lista');"> </td>
                      <td class="listaNon" align="center" width="1%">
                        <input type="checkbox" name="chk" value="13000000000008980" >
                      </td>
                      <td align="left" nowrap onClick="javascript: Procesar('1','6','lista');"> <a href="javascript:Procesar('1','6','lista');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1"> Marielena
                          Guardia (Alumno) </a> </td>
                      <td align="left" nowrap onClick="javascript: Procesar('1','6','lista');"> <a href="javascript:Procesar('1','6','lista');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1"> Mensjae
                          de Prueba </a> </td>
                      <td align="left" nowrap onClick="javascript: Procesar('1','6','lista');"> <a href="javascript:Procesar('1','6','lista');" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;" tabindex="-1"> 29/07/2003 </a> </td>
                    </tr>
                    <tr>
                      <td colspan="5"><input name="BCODIGO_1" type="hidden" value="13000000000008980">
                          <input name="BESTADO_1" type="hidden" value="0">
                          <input name="BFECHA_1" type="hidden" value="29/07/2003">
                          <input name="BMENSAJE_1" type="hidden" value="Hola">
                          <input name="BORIGEN_1" type="hidden" value="Marielena Guardia   (Alumno)">
                          <input name="BTITULO_1" type="hidden" value="Mensjae de Prueba">
                      </td>
                    </tr>
                    <tr>
                      <td align="center" colspan="5">&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="center" colspan="5"> </td>
                    </tr>
                    <tr>
                      <td align="center" colspan="5">&nbsp;</td>
                    </tr>
                  </table>
                  <input type="hidden" name="StartRow" value="1">
                  <input type="hidden" name="PageNum" value="1">
                </form>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
	<cfscript>
		a = ListToArray('25/10/2003','/');
		b = CreateDate(a[3], a[2], a[1]);
	</cfscript>
	<cfoutput>#b#</cfoutput>
    <!-- InstanceEndEditable -->
	 </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
