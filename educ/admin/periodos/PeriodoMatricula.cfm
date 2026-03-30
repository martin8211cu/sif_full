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
		Definición de Períodos de Matrícula
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
			<cfset titulo = "Periodos de Matricula">
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
							<cfinclude template="PeriodoMatricula_arbol.cfm">
						</td>
					</tr>
					</table>								
				</td>
				<td valign="top">
					<cfif Form.nivel EQ 4 >
						<cfinclude template="PeriodoMatricula_form.cfm">
					<cfelseif Form.nivel EQ 5 >
						<cfinclude template="PeriodoTarifas_list.cfm">
					</cfif>
				</td>
			  </tr>
			</table>		
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->
<p style="color:#FFFFFF; text-indent: -20; margin-left: 20">1.&nbsp;Escoja un "Tipo Ciclo" para listar los "Ciclos Lectivos" existentes.</p>
<p style="color:#FFFFFF; text-indent: -20; margin-left: 20; margin-bottom: 0;">2.&nbsp;Al escoger "Tipo Ciclo" cuyos cursos duran únicamente un período de Evaluación:</p>
<p style="color:#FFFFFF; text-indent: -28; margin-left: 48; margin-top: 0; margin-bottom: 0;">2a.&nbsp;Escoja un "Ciclo" para listar los "Períodos" existentes.</p>
<p style="color:#FFFFFF; text-indent: -28; margin-left: 48; margin-top: 0;">2b.&nbsp;Escoja un "Período" para agregar nuevos 'Períodos de Matrícula'.</p>
<p style="color:#FFFFFF; text-indent: -20; margin-left: 20; margin-bottom: 0;">3.&nbsp;Al escoger "Tipo Ciclo" cuyos cursos duran todo el Ciclo Lectivo:</p>
<p style="color:#FFFFFF; text-indent: -28; margin-left: 48; margin-top: 0;">3a.&nbsp;Escoja un "Ciclo" para agregar nuevos 'Períodos de Matrícula'.</p>
<p style="color:#FFFFFF; text-indent: -20; margin-left: 20">4.&nbsp;Escoja un "Período de Matrícula" para modificar su información.</p>
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->