<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Tipos de Movimiento">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<!--- <cfinclude template="beneficios-form.cfm"> --->

		<cf_web_portlet_end>
	</cf_templatearea>
	
</cf_template>
