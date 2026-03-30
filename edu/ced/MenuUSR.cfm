<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" -->
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
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

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top">
				<cfset RolActual = 4>
				<cfset Session.RolActual = 4>
				<cfinclude template="../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" --> 
			<cfinclude template="jsMenuUSR.cfm">
      <!-- InstanceEndEditable -->	
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
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td width="2%"class="Titulo"><img  src="../Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">
				  <!-- InstanceBeginEditable name="TituloPortlet" -->Men&uacute; Principal<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
            <table width="80%" border="0" align="center" cellpadding="1" cellspacing="0">
                  <tr> 
                    <td width="4%" align="right" valign="middle"><a href="seleccion.cfm"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="seleccion.cfm">Preparar cartas de afiliaci&oacute;n</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="seleccion.cfm?buscar=4"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="seleccion.cfm?buscar=4">Reimpresi&oacute;n de cartas</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="seleccion.cfm?buscar=5"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="seleccion.cfm?buscar=5">Verificaci&oacute;n de usuarios</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="seleccion.cfm?buscar=8"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="seleccion.cfm?buscar=8">Reenv&iacute;o de contrase&ntilde;as</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle"><a href="seleccion.cfm?buscar=3"><img src="../Imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                    <td nowrap><font size="2"><a href="seleccion.cfm?buscar=3">Consulta de usuarios</a></font></td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle">&nbsp;</td>
                    <td nowrap>&nbsp;</td>
                  </tr>
                  <tr> 
                    <td align="right" valign="middle">&nbsp;</td>
                    <td nowrap>&nbsp;</td>
                  </tr>
            </table>
            <div align="center"></div>
            <div align="center"></div>
            <!-- InstanceEndEditable -->
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
			 </td>
		  </tr>
		</table>

	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->