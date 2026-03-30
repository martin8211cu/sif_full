<cfinclude template="../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- TemplateBeginEditable name="head" -->
		<!-- TemplateEndEditable -->
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
			// Funciones para el Manejo de Botones
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
			<td valign="top">
				<cfset RolActual = 0>
				<cfinclude template="../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area"> 
				  <td valign="bottom" nowrap> 
			  <!-- TemplateBeginEditable name="MenuJS" --> 
			  <!-- TemplateEndEditable -->	
				  </td>
				</tr>
				<tr> 
				  <td></td>
				  <td></td>
				</tr>
			  </table>
			<cfif isdefined("Session.Edu.CEcodigo")>
				<cfoutput>
				<table class="area" width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td><hr></td>
					</tr>
					<tr>
						<td align="right"><font color="##009900" size="2"><strong><a href="/minisitio/#Session.Edu.CEcodigo#/f#Session.Edu.CEcodigo#.html">Ir a P&aacute;gina Web de #rsPagWebCollege.CEnombre#</a></strong></font></td>
					</tr>
				</table>
				</cfoutput>
			</cfif>
			</td>
		  </tr>
		</table>
		  
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td align="left" valign="top" nowrap></td>
			<td width="100%" height="1" align="left" valign="top"><!-- TemplateBeginEditable name="Titulo2" -->Titulo1<!-- TemplateEndEditable --></td>
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
				  <!-- TemplateBeginEditable name="TituloPortlet" -->
					TituloPortlet
				  <!-- TemplateEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- TemplateBeginEditable name="Mantenimiento2" -->
				  <!-- TemplateEndEditable -->
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
			 </td>
		  </tr>
		</table>
	</cf_templatearea>
</cf_template>
