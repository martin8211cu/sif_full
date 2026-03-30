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
	Oferta Académica	
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
	
	<cfparam name="url.PEScodigo" default="">
	<cfparam name="form.PEScodigo" default="#url.PEScodigo#">
	<cfparam name="url.Fcodigo" default="">
	<cfparam name="form.Fcodigo" default="#url.Fcodigo#">

	<cfif form.Fcodigo EQ "">
		<cfset titulo = "Lista de Facultades"> 
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">	
		<cfinclude template="facultades_list.cfm">	
	<cfelse>
		<cfif form.PEScodigo EQ "">
			<cfset titulo = "Lista Oferta Acad&eacute;mica"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Lista de Facultades">
			<cfset navBarLinks[1] = "/cfmx/educ/publico/oferta/oferta.cfm">
						
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">	
			
			<cfinclude template="oferta_list.cfm">
		<cfelse>
			<cfset titulo = "Plan de Estudio"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Lista de Facultades">
			<cfset navBarLinks[1] = "/cfmx/educ/publico/oferta/oferta.cfm">			
			<cfset navBarItems[2] = "Lista Oferta Acad&eacute;mica">
			<cfset navBarLinks[2] = "/cfmx/educ/publico/oferta/oferta.cfm?Fcodigo=#form.Fcodigo#">	
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">	
		
		  <cfinclude template="oferta_plan.cfm">
		</cfif>
	</cfif>
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->