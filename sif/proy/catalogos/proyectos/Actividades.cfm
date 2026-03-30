<cfif IsDefined('form.PRJid')>
	<cfset url.PRJid = form.PRJid></cfif>
<cfif IsDefined('form.PRJAid')>
	<cfset url.PRJAid = form.PRJAid></cfif>

<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Administración de Proyectos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Administración de Proyectos">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="0" cellspacing="1">
			<tr><td><cfinclude template="Actividades-ubicacion.cfm"></td></tr>
			<tr><td><cfinclude template="Actividades-arbol.cfm"></td></tr>
			<tr><td><cfinclude template="Actividades-form.cfm"></td></tr>
			</table> 
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
