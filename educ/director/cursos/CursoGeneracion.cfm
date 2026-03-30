<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->
			<cfinclude template="/home/menu/menu.cfm"> 
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" --> 
              Generación de Cursos
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" --> 
		<cfset Session.MoG="G">
		<cfset titulo = "Generaci&oacute;n de Cursos">
		<cfset navBarItems = ArrayNew(1)>
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarItems[1] = "Cursos">
		<cfset navBarLinks[1] = "/cfmx/educ/director/menuCursos.cfm">
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td valign="top">
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td valign="top">
							<cfinclude template="CursoGeneracion_form.cfm">
						</td>
					</tr>
				</table>
			</td>
		  </tr>
		</table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" --> 
			<cfinclude template="CursoGeneracion_pasos.cfm">
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->