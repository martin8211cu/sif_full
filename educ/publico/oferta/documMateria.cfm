<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Documentaci&oacute;n de Materia
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
		Documentaci&oacute;n de Materia		
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfoutput>
			<cfset titulo = "Documentaci&oacute;n de Materia"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Lista de Facultades">
			<cfset navBarLinks[1] = "/cfmx/educ/publico/oferta/oferta.cfm">			
			<cfset navBarItems[2] = "Lista Oferta Acad&eacute;mica">
			<cfset navBarLinks[2] = "/cfmx/educ/publico/oferta/oferta.cfm?Fcodigo=#form.Fcodigo#">	
			<cfset navBarItems[3] = "Plan de Estudio">
			<cfset navBarLinks[3] = "/cfmx/educ/publico/oferta/oferta.cfm?Fcodigo=#form.Fcodigo#&PEScodigo=#form.PEScodigo#">
		</cfoutput>
		
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			
		<cfinclude template="documMateria_form.cfm">
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->