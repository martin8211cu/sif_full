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
		Definición de Tipos de Aprobación
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" --> 
			<cfset titulo = "Tipos de Aprobación"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			
			<cfparam name="form.TRcodigo" default="">	
			<cfif form.TRcodigo EQ "">
				<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
					<cfinclude template="tablaResultado_form.cfm">
				<cfelse>
					<cfinclude template="tablaResultado_list.cfm">
				</cfif>
			<cfelseif NOT (isdefined("form.modo") AND form.modo EQ "LISTA" OR isdefined("form.btnLista") AND form.btnLista NEQ "")>
				<cfparam name="form.modo" default="CAMBIO">
				<cfinclude template="tablaResultado_form.cfm">
			<cfelse>
				<cfinclude template="tablaResultado_list.cfm">			
			</cfif>		
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->
 
      <!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->