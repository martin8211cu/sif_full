<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Materias
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
			<cfif isdefined("Url.T") and not isdefined("Form.T")>
				<cfparam name="Form.T" default="#Url.T#">
			</cfif>	
				
			Definici&oacute;n de Materias
				<cfif isdefined('form.T') and form.T EQ 'M'>
					Regulares
				<cfelse>
					Electivas
				</cfif>
<!--- 				<cfif isdefined('url.T') and url.T EQ "M">
					Regulares
				<cfelse>
					Electivas
				</cfif> --->		
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
			<cfif isdefined("Url.T") and not isdefined("Form.T")>
				<cfparam name="Form.T" default="#Url.T#">
			</cfif>
			
			<cfparam name="form.Mcodigo" default="">	
			<cfif form.Mcodigo EQ "">
				<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
					<cfset titulo = "Materias">
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Planes Acad&eacute;micos">
					<cfset navBarLinks[1] = "/cfmx/educ/director/menuPlanAcadem.cfm">
					<cfset navBarItems[2] = "Lista de Materias">
					<cfif isdefined('form.T') and form.T EQ 'M'>
						<cfset navBarLinks[2] = "/cfmx/educ/director/planAcademico/materia.cfm?T=M">
					<cfelse>
						<cfset navBarLinks[2] = "/cfmx/educ/director/planAcademico/materia.cfm?T=E">					
					</cfif>
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">				
					
					<cfinclude template="materia_tabs.cfm">
				<cfelse>
					<cfset titulo = "Lista de Materias">
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Planes Acad&eacute;micos">
					<cfset navBarLinks[1] = "/cfmx/educ/director/menuPlanAcadem.cfm">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
					<cfinclude template="materia_lista.cfm">
				</cfif>
			<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
				<cfparam name="form.modo" default="CAMBIO">
				<cfset titulo = "Materias">
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Planes Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/director/menuPlanAcadem.cfm">
				<cfset navBarItems[2] = "Lista de Materias">
				<cfif isdefined('form.T') and form.T EQ 'M'>
					<cfset navBarLinks[2] = "/cfmx/educ/director/planAcademico/materia.cfm?T=M">
				<cfelse>
					<cfset navBarLinks[2] = "/cfmx/educ/director/planAcademico/materia.cfm?T=E">					
				</cfif>
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">				
				<cfinclude template="materia_tabs.cfm">
			<cfelse>
				<cfset titulo = "Lista de Materias">
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Planes Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/director/menuPlanAcadem.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="materia_lista.cfm">			
			</cfif>		
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->