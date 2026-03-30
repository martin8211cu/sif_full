<!-- InstanceBegin template="/Templates/LMenuGEN.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../Utiles/general.cfm">
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
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
		  </tr>
		  <tr> 
			<td valign="top" nowrap>
				<cfinclude template="/sif/menu.cfm">
			</td>
			<td valign="top" width="100%">
			  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
			  <td width="2%"class="Titulo"><img  src="../Imagenes/sp.gif" width="15" height="15" border="0"></td>
			  <td width="3%" class="Titulo" >&nbsp;</td>
			  <td width="94%" class="Titulo">Resultado de Env&iacute;o de Mensaje</td>
			  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../Imagenes/rt.gif"></td>
			</tr>
			<tr> 
			  <td colspan="3" class="contenido-lbborder">
				<form action="index.cfm" method="post" name="form1" id="form1">
				  <input type="hidden" id="o" name="o" value="">
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
					  <td>&nbsp;</td>
					</tr>
					<tr>
					  <td align="center" class="area">
						<cfif isdefined("Form.NoEnviados") and Len(Trim(Form.NoEnviados)) NEQ 0>
								El mensaje no fue enviado a algunos de los usuarios que todava no est n activos o no tienen ning&uacute;n correo electr&oacute;nico asignado
						<cfelse>
								El mensaje fue enviado en forma exitosa
						</cfif>
					  </td>
					</tr>
					<tr>
					  <td>&nbsp;</td>
					</tr>
					<tr>
					  <td align="center">
						<input name="btnBuzon" type="button" id="btnBuzon" value="Ir al Buz&oacute;n" onClick="javascript: this.form.o.value='1'; this.form.submit();">
						<input name="btnNuevo" type="button" id="btnNuevo" value="Nuevo Mensaje" onClick="javascript: this.form.o.value='2'; this.form.submit();">
					  </td>
					</tr>
					<tr>
					  <td align="center">&nbsp;</td>
					</tr>
				  </table>
				</form>
			  </td>
			  <td class="contenido-brborder">&nbsp;</td>
			</tr>
		</table>
		<!-- InstanceEndEditable -->
			 </td>
		  </tr>
		</table>
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->