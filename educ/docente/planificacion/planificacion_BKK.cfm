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
		Planificaci&oacute;n de Curso
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset u = sec.getUsuarioByCod(Session.Usucodigo, Session.EcodigoSDC, 'PersonaEducativo')>
		
		<cfif u.recordCount GT 0>
			<cfset titulo = "Planificación de Curso">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				
			<cfinclude template="planificacion-header.cfm">
			<cfif not isdefined("Form.CEVcodigo") and not isdefined("Form.btnNuevo") and not isdefined("Form.Nuevo")>
				<cfinclude template="planificacion-lista.cfm">
			<cfelse>
				<cfinclude template="planificacion-form.cfm">
			</cfif>
		</cfif>
	<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

	<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->