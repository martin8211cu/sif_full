<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->
		##N/A##
	<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" -->
		Registro de Calificaciones
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfset titulo = "Calificaciones"> 
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
		<cfinclude template="calificarEvaluaciones_Form.cfm">
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->