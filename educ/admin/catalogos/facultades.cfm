<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Definici&oacute;n de <cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s
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
		Definici&oacute;n de <cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s		
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfparam name="form.Fcodigo" default="">	
		<cfif form.Fcodigo EQ "">
			<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
				<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
					<cfif Form.nivel EQ 1>
						<cfset titulo = "<cfoutput>#session.parametros.Facultad#</cfoutput>"> 
						<cfset navBarItems = ArrayNew(1)> 
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
						<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
						<cfset navBarItems[2] = "<cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s">
						<cfset navBarLinks[2] = "facultades.cfm">
						<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
						<cfinclude template="facultad_form.cfm">
					<cfelse>
						<cfset titulo = session.parametros.Escuela> 
						<cfset navBarItems = ArrayNew(1)> 
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
						<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
						<cfset navBarItems[2] = "<cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s">
						<cfset navBarLinks[2] = "facultades.cfm">
						<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
						<cfinclude template="escuela_form.cfm">
					</cfif>
				</cfif>
			<cfelse>
				<cfset titulo = "<cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s"> 
				<cfset navBarItems = ArrayNew(1)> 
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
				<cfinclude template="facultades_arbol.cfm">
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
			<cfparam name="form.modo" default="CAMBIO">
			<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
				<cfif Form.nivel EQ 1>
					<cfset titulo = "<cfoutput>#session.parametros.Facultad#</cfoutput>"> 
					<cfset navBarItems = ArrayNew(1)> 
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
					<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
					<cfset navBarItems[2] = "<cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s">
					<cfset navBarLinks[2] = "facultades.cfm">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
					<cfinclude template="facultad_form.cfm">
				<cfelse>
					<cfset titulo = session.parametros.Escuela> 
					<cfset navBarItems = ArrayNew(1)> 
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
					<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
					<cfset navBarItems[2] = "<cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s">
					<cfset navBarLinks[2] = "facultades.cfm">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
					<cfinclude template="escuela_form.cfm">
				</cfif>
			</cfif>
		<cfelse>
			<cfset titulo = "<cfoutput>#session.parametros.Facultad#es y #session.parametros.Escuela#</cfoutput>s"> 
			<cfset navBarItems = ArrayNew(1)> 
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Organizaci&oacute;n Acad&eacute;mica">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuEstructura.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">		
			<cfinclude template="facultades_arbol.cfm">
		</cfif>
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->