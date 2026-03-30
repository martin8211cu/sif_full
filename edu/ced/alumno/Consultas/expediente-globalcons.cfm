<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
		<!-- InstanceBeginEditable name="head" --> 
<!-- InstanceEndEditable -->
		<link href="../../../css/portlets.css" rel="stylesheet" type="text/css">
		<link href="../../../css/edu.css" rel="stylesheet" type="text/css">
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
				<cfinclude template="../../../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../../../portlets/pminisitio.cfm">
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
			<td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->Titulo1<!-- InstanceEndEditable --></td>
		  </tr>
		  <tr> 
			<td valign="top" nowrap>
				<cfinclude template="/sif/menu.cfm">
			</td>
			<td valign="top" width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td width="2%"class="Titulo"><img  src="../../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">
				  <!-- InstanceBeginEditable name="TituloPortlet" -->
		  	TituloPortlet
		  <!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
	  <script language="JavaScript" type="text/javascript">
	  		function switchPages() {
				var DataPage = document.getElementById("TRDatosEmp");
				var ListPage = document.getElementById("TRBuscarEmp");
				if (DataPage.style.display == "") {
					DataPage.style.display = "none";
					ListPage.style.display = "";
				} else {
					DataPage.style.display = "";
					ListPage.style.display = "none";
				}
			}
	  </script>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">

	  <!--- Cuando ya se ha seleccionado un empleado --->
	  <cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	  	  <tr>
		  	<td>
			  <form name="reqEmpl" action="expediente-globalcons.cfm" method="post">
			  	 <input type="hidden" name="o" value="">
			  	 <input type="hidden" name="DEid" value="">
			  </form>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="right" valign="middle">
						<a href="javascript: switchPages();">
							Seleccionar Empleado: <img src="../../Imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0">
						</a>
					</td>
				  </tr>
			  </table>
			</td>
		  </tr>
		  <tr id="TRDatosEmp">
	  	  <td>
		  <cfinclude template="frame-header.cfm">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="tabContent">
				<cfif isDefined("Form.DEid") and isDefined("Form.Regresar")>
					<cfoutput>
					<form name="Regresar" method="post" action="#Form.Regresar#">
						<input type="hidden" name="DEid" value="#Form.DEid#">
						<cfif isdefined("Form.o")>
						<input type="hidden" name="o" value="#Form.o#">
						<cfelse>
						<input type="hidden" name="o" value="1">
						</cfif>
					</form>
					</cfoutput>
					<cfset regresar = "javascript: document.Regresar.submit();">
				</cfif>
				<cfinclude template="../../../portlets/pNavegacionCED.cfm">
				</td>
			</tr>
			<tr>
			  <td class="tabContent">
					<cfif tabChoice eq 1>
						<cfif isdefined("Form.DLlinea")>
							<cfinclude template="file:///H|/rh/expediente/consultas/expediente-detalleAccion.cfm">
						</cfif>
					<cfelseif tabChoice eq 2>
						<cfinclude template="file:///H|/rh/expediente/consultas/expediente-general.cfm">
					<cfelseif tabChoice eq 3>
						<cfinclude template="file:///H|/rh/expediente/consultas/expediente-familiar.cfm">
					<cfelseif tabChoice eq 4>
						<cfif isdefined("Form.DLlinea")>
							<cfinclude template="file:///H|/rh/expediente/consultas/expediente-detalleAccion.cfm">
						<cfelse>
							<cfinclude template="file:///H|/rh/expediente/consultas/expediente-laboral.cfm">
						</cfif>
					<cfelseif tabChoice eq 5>
						<cfinclude template="file:///H|/rh/expediente/consultas/expediente-anotaciones.cfm">
					<cfelse>
						<div align="center">
						<b>Este m&oacute;dulo no est&aacute; disponible</b>
						</div>
					</cfif>
			  </td>
			</tr>
		  </table>
		  </td>
		  </tr>
			<tr id="TRBuscarEmp" style="display: none">
			  <td>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr> 
					  <td width="2%"class="Titulo"><img src="/cfmx/edu/Imagenes/sp.gif" width="15" height="15" border="0"></td>
					  <td width="3%" class="Titulo" >&nbsp;</td>
					  <td width="94%" class="Titulo">Consulta de Expediente Laboral</td>
					  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="/cfmx/edu/Imagenes/rt.gif"></td>
					</tr>
					<tr> 
					  <td colspan="3" class="contenido-lbborder">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr valign="top">
								<td><cfinclude template="file:///H|/rh/portlets/pNavegacion.cfm"></td>
							</tr>
						  <tr valign="top"> 
							<td>&nbsp;</td>
						  </tr>
						  <tr valign="top"> 
							<td align="center">
							  <cfinclude template="file:///H|/rh/expediente/consultas/frame-Empleados.cfm">
							</td>
						  </tr>
						  <tr valign="top"> 
							<td>&nbsp;</td>
						  </tr>
						</table>
					  </td>
					  <td class="contenido-brborder">&nbsp;</td>
					</tr>
				  </table>
			  </td>
			</tr>
		  <!--- Cuando todava no se ha seleccionado un empleado --->
		  <cfelse>
		  <tr>
	  	  <td>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td width="2%"class="Titulo"><img src="/cfmx/edu/Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">Consulta de Expediente Laboral</td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="/cfmx/edu/Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td><cfinclude template="file:///H|/rh/portlets/pNavegacion.cfm"></td>
						</tr>
					  <tr valign="top"> 
						<td>&nbsp;</td>
					  </tr>
					  <tr valign="top"> 
						<td align="center">
						  <p class="tituloAlterno">Debe seleccionar un empleado</p>
						  <cfinclude template="file:///H|/rh/expediente/consultas/frame-Empleados.cfm">
						</td>
					  </tr>
					  <tr valign="top"> 
						<td>&nbsp;</td>
					  </tr>
					</table>
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
		  </td>
		  </tr>
		  </cfif>
	  </table>
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