<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
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
				<cfinclude template="../../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr class="area" style="padding-bottom: 3px;"> 
				  <td nowrap style="padding-left: 10px;">
				  <cfinclude template="../../portlets/pminisitio.cfm">
				  </td>
				  <td valign="top" nowrap> 
			  <!-- InstanceBeginEditable name="MenuJS" -->
	  <cfinclude template="../jsMenuCED.cfm">
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
				  <td width="2%"class="Titulo"><img  src="../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">
				  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Reporte de Progreso por Grupo<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			
		  <cfif isdefined("Form.btnGenerar")>
			<cfset Param = "">
			<cfif isdefined('Form.SPEcodigo')>
				<cfset Param = Param & "SPEcodigo=" & Form.SPEcodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.GRcodigo')>
				<cfset Param = Param & "GRcodigo=" & Form.GRcodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.PEcodigo')>
				<cfset Param = Param & "PEcodigo=" & Form.PEcodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.Ecodigo')>
				<cfset Param = Param & "Ecodigo=" & Form.Ecodigo & "&">
			</cfif>				  
			<cfif isdefined('Form.checkCurso')>
				<cfset Param = Param & "checkCurso=" & Form.checkCurso & "&">
			</cfif>				  
			<cfif isdefined('Form.checkTabla')>
				<cfset Param = Param & "checkTabla=" & Form.checkTabla & "&">
			</cfif>
			<cfif isdefined('Form.firmaEncargado')>
				<cfset Param = Param & "firmaEncargado=1&">
			</cfif>
			<cfif isdefined('Form.firmaAlumno')>
				<cfset Param = Param & "firmaAlumno=1&">
			</cfif>
			<cfif isdefined('Form.firmaProfesor')>
				<cfset Param = Param & "firmaProfesor=1&">
			</cfif>
			<cfif isdefined('Form.firmaDirector')>
				<cfset Param = Param & "firmaDirector=1&">
			</cfif>
			<cfif isdefined('Form.firmaAdicional')>
				<cfset Param = Param & "firmaAdicional=1&">
			</cfif>
			<cfif isdefined('Form.nombreAdicional')>
				<cfset Param = Param & "nombreAdicional=" & Form.nombreAdicional & "&">
			</cfif>
			<cfif isdefined('Form.filtroNota')>
				<cfset Param = Param & "filtroNota=1&">
			</cfif>
			<cfif isdefined('Form.filtroPorcentaje')>
				<cfset Param = Param & "filtroPorcentaje=" & Form.filtroPorcentaje & "&">
			</cfif>
			<cfif isdefined('Form.preguntasText')>
				<cfset Param = Param & "preguntasText=" & URLEncodedFormat(Form.preguntasText) & "&">
			</cfif>
			<cfif isdefined('Form.rdCortes')>
				<cfset Param = Param & "rdCortes=" & Form.rdCortes & "&">
			</cfif>
			<cfif isdefined('Form.FechaRep')>
				<cfset Param = Param & "FechaRep=" & Form.FechaRep & "&">
			</cfif>
			<cfif isdefined("form.TituloRep")>
				<cfset Param = Param  & "&TituloRep=" & #form.TituloRep# & "&">
			</cfif>
			
			<cfset Param = Param & "enPantalla=0"  & "&">
			<cfset Param = Param & "btnGenerar=1">
			
			<cfinvoke 
				component="edu.Componentes.NavegaPrint" 
				method="Navega" 
				returnvariable="pListaNavegable">
			 <cfinvokeargument name="printEn" value="/cfmx/edu/ced/consultas/imprime/ProgressReportGroupImpr.cfm">
			 <cfinvokeargument name="Param" value="#Param#">
			</cfinvoke>
		  <cfelse>
			<cfinclude template="../../portlets/pNavegacionCED.cfm">
		  </cfif>

		  <cfinclude template="formProgressReportGroup.cfm">

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