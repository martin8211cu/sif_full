<cfif IsDefined('url.PRJid')>
	<cfset form.PRJid = url.PRJid></cfif>
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Administración de Proyectos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Administración de Proyectos">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="Proyectos-form.cfm">
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
