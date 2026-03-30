<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Edificios
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
		Definición de Edificios y sus Aulas
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfparam name="form.EDcodigo" default="">	
		<cfif form.EDcodigo EQ "">
			<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
				<cfset titulo = "Mantenimiento de Edificios">
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">				
				<cfset navBarItems[2] = "Lista de Edificios">
				<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/Edificios.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">			
				<cfinclude template="Edificios_form.cfm">
			<cfelse>
				<cfset titulo = "Lista de Edificios">
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="Edificios_lista.cfm">
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
			<cfparam name="form.modo" default="CAMBIO">
			<cfset titulo = "Mantenimiento de Edificios">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">				
			<cfset navBarItems[2] = "Lista de Edificios">
			<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/Edificios.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
			<cfinclude template="Edificios_form.cfm">
		<cfelse>
			<cfset titulo = "Lista de Edificios">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfinclude template="Edificios_lista.cfm">			
		</cfif>	
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->