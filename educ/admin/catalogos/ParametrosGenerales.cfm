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
		Definición de Parámetros Generales
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
			<cfset titulo = "Parámetros Generales"> 
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Par&aacute;metros Acad&eacute;micos">
			<cfset navBarLinks[1] = "/cfmx/educ/admin/menuParamAcadem.cfm">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<cfinclude template="ParametrosGenerales_list.cfm"> 
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->
	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->