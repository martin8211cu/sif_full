<!-- InstanceBegin template="/educ/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
<cf_templatecss>
<cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Registro de Directores
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!-- InstanceBeginEditable name="left" -->
		<cfinclude template="/home/menu/menu.cfm"> 
	<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<!-- InstanceBeginEditable name="Encabezado" -->
		Registro de Profesores Gu&iacute;a
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfset Form.TP = "PG">
		<cfparam name="form.PGpersona" default="">	
		<cfif form.PGpersona EQ "">
			<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="personaEdu_form.cfm">
			<cfelse>
				<cfset titulo = "Lista de Profesores Gu&iacute;as">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="personaEdu_lista.cfm">
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
			<cfparam name="form.modo" default="CAMBIO">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfinclude template="personaEdu_form.cfm">
		<cfelse>
			<cfset titulo = "Lista de Profesores Gu&iacute;as">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfinclude template="personaEdu_lista.cfm">
		</cfif>		
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->