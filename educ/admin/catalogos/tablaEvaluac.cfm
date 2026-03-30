<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Tablas de Evaluaci&oacute;n
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" -->
		Definición de Tablas de Evaluación
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top"><cfinclude template="/home/menu/menu.cfm"></td>
				<td valign="top">
			
		<cfparam name="form.TEcodigo" default="">
		<cfif form.TEcodigo EQ "">
			<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
				<cfset titulo = "Tablas de Evaluaci&oacute;n"> 
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
				<cfset navBarItems[2] = "Lista de Tablas de Evaluaci&oacute;n">
				<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/TablaEvaluac.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="TablaEvaluac_form.cfm">
			<cfelse>
				<cfset titulo = "Lista de Tablas de Evaluaci&oacute;n"> 
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
				<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
				<cfset Session.RegresarURL = "TablaEvaluac_lista.cfm">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfinclude template="TablaEvaluac_lista.cfm">
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
			<cfparam name="form.modo" default="CAMBIO">
			<cfset titulo = "Tablas de Evaluaci&oacute;n"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
			<cfset navBarItems[2] = "Lista de Tablas de Evaluaci&oacute;n">
			<cfset navBarLinks[2] = "/cfmx/educ/admin/catalogos/TablaEvaluac.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfinclude template="TablaEvaluac_form.cfm">
		<cfelse>
			<cfset titulo = "Lista de Tablas de Evaluaci&oacute;n"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
			<cfset Session.RegresarURL = "TablaEvaluac_lista.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfinclude template="TablaEvaluac_lista.cfm">			
		</cfif>
</td>
			</tr>
		</table>
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->