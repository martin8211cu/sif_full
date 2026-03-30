<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
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
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --> <!-- InstanceEndEditable --></td>
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
				  <!-- InstanceBeginEditable name="TituloPortlet" -->
		  	Administraci n de Minisitios
		  <!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
				<cfset ts =  LSDateFormat(Now(), 'ddmmyyyy') & LSTimeFormat(Now(),'hhmmss')>


				<link href="/cfmx/edu/css/edu.css" rel="stylesheet">
				<cfoutput>
				<table width="100%">
					<tr><td height="30px">&nbsp;</td></tr>
					<tr>
						<td class="titulo2" align="center"><a href="catalogos/Categorias.cfm"><img border="0" src="imagenes/categorias.gif" /><br/>Categor&iacute;as</a></td>
						<td class="titulo2" align="center"><a href="catalogos/Menues.cfm"><img border="0" src="imagenes/menu.gif" /><br/>Men&uacute;</a></td>
						<td class="titulo2" align="center"><a href="catalogos/Paginas.cfm"><img border="0" src="imagenes/paginas.gif" /><br/>P&aacute;ginas</a></td>
					</tr>
					
					<tr><td height="60px">&nbsp;</td></tr>
					
					<tr>
						<td class="titulo2" align="center"><a href="catalogos/Contenidos.cfm"><img border="0" src="imagenes/contenido.gif" /><br/>Contenido</a></td>
						<td class="titulo2" align="center"><a href="catalogos/Constructor.cfm"><img border="0" src="imagenes/constructor.gif" /><br/>Constructor del Sitio</a></td>
						<td class="titulo2" align="center"><a href="generacion/generar2.cfm?a=#ts#"><img border="0" src="imagenes/generacion.gif" /><br/>Generaci&oacute;n del sitio</a></td>
					</tr>

					<tr><td height="30px">&nbsp;</td></tr>					
				</table>
				</cfoutput>
		  
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