<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Tipos de Ciclos Lectivos
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
		Definición de Tipos de Ciclo Lectivo
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
			<cfparam name="form.CILcodigo" default="">	
			<cfif form.CILcodigo EQ "">
				<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
					<cfset titulo = "Tipo de Ciclo Lectivo"> 
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
					<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
					<cfset navBarItems[2] = "Lista de Tipos de Ciclos Lectivos">
					<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/CicloLectivo.cfm">			
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
					<cfinclude template="CicloLectivo_form.cfm">
				<cfelse>
					<cfset titulo = "Lista de Tipos de Ciclos Lectivos">
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
					<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
					<cfinclude template="CicloLectivo_lista.cfm">
				</cfif>
			<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
				<cfparam name="form.modo" default="CAMBIO">
				<cfset titulo = "Tipo de Ciclo Lectivo"> 
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
				<cfset navBarItems[2] = "Lista de Tipos de Ciclos Lectivos">
				<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/CicloLectivo.cfm">			
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="CicloLectivo_form.cfm">
			<cfelse>
				<cfset titulo = "Lista de Tipos de Ciclos Lectivos">
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="CicloLectivo_lista.cfm">			
			</cfif>
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->