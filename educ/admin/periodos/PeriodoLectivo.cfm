<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
			Ciclos Lectivos y Per&iacute;odos de Evaluaci&oacute;n
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
		Definición de Ciclos Lectivos y Per&iacute;odos de Evaluaci&oacute;n
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfset titulo = "Ciclos Lectivos y Periodos de Evaluación"> 
		<cfset navBarItems = ArrayNew(1)> 
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarItems[1] = "Per&iacute;odos Acad&eacute;micos">
		<cfset navBarLinks[1] = "/cfmx/educ/admin/MenuPeriodos.cfm">
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">

		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td valign="top">
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
				
				<tr>
					<td valign="top" colspan="2">
						<cfinclude template="PeriodoLectivo_arbol.cfm">
					</td>
				</tr>
				</table>								
			</td>
			<td valign="top">
				<cfif Form.nivel GT 1>
					<cfinclude template="PeriodoLectivoNivel_form.cfm">
				</cfif>
			</td>
		  </tr>
		</table>		
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->
1. Escoja un "Tipo Ciclo" para agregar nuevos "Ciclos Lectivos".<BR><BR>
2. Escoja un "Ciclo" o un "Período" para modificar su información.
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->