<!-- InstanceBegin template="/educ/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
<cf_templatecss>
<cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Matricula
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!-- InstanceBeginEditable name="left" -->
		##N/A##
		<cfinclude template="/home/menu/menu.cfm"> 
	<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<!-- InstanceBeginEditable name="Encabezado" -->
		Matricula
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfset titulo = "Matricula"> 
		<cfinclude template="../portlets/pNavegacionAdmin.cfm">		
		<cfinclude template="matricula_form.cfm">		
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->