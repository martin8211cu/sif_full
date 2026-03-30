<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
			Administracion
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
		Definición de Conceptos de Evaluación
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
			<cfparam name="form.CEcodigo" default="">
			<cfif form.CEcodigo EQ "">
				<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
					<cfset titulo = "Concepto Evaluación"> 
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
					<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
					<cfset navBarItems[2] = "Lista de Conceptos">
					<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/conceptoEvaluac.cfm">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
					<cfinclude template="conceptoEvaluac_form.cfm">
				<cfelse>
					<cfset titulo = "Conceptos Evaluaci&oacute;n"> 
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
					<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
					<cfinclude template="conceptoEvaluac_list.cfm"> 
				</cfif>
			<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
				<cfparam name="form.modo" default="CAMBIO">
				<cfset titulo = "Concepto Evaluación"> 
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
				<cfset navBarItems[2] = "Lista de Conceptos">
				<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/conceptoEvaluac.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="conceptoEvaluac_form.cfm">
			<cfelse>
				<cfset titulo = "Conceptos Evaluaci&oacute;n"> 
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="conceptoEvaluac_list.cfm"> 
			</cfif>
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->
Los <em>'Conceptos de Evaluación'</em> establecen los grandes criterios estándares de calificación para el Centro Educativo, a ser evaluados en cada Curso.  Estos Conceptos no se califican directamente, sino que se componen de <em>'Evaluaciones</em>', las cuales son las que califica el profesor.
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->