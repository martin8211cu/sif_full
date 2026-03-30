<cfif IsDefined('url.PRJid')>
	<cfset form.PRJPOid = url.PRJPOid></cfif>
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Obras a Cotizar
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Administraci&oacute;n de Proyectos">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="PRJPobras-form.cfm">
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
