<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Definici&oacute;n de Sedes
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
		Definici&oacute;n de Sedes
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfset titulo = "Mantenimiento de Sedes">
		<cfset navBarItems = ArrayNew(1)> 
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
		<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
		<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		

		<cfparam name="form.Scodigo" default="">	
		<cfif form.Scodigo EQ "">
			<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
				<cfinclude template="sede_form.cfm">
			<cfelse>
				<cfinclude template="sede_lista.cfm">
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
			<cfparam name="form.modo" default="CAMBIO">
			 <cfinclude template="sede_form.cfm">
		<cfelse>
			<cfinclude template="sede_lista.cfm">			
		</cfif>
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->