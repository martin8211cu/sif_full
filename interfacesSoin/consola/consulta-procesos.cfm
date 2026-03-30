<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Consulta de Procesos de Interfaz
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet_start titulo="Consulta de Procesos de Interfaz">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfset LvarSoloConsultar = true>
			<cfinclude template="../parametros/motor.cfm">
			<cfinclude template="consola-procesos-form.cfm">
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
