<cfif IsDefined('url.PRJPOid') and not isdefined('Form.PRJPOid')>
	<cfset Form.PRJPOid = url.PRJPOid>
</cfif>
<cfif IsDefined('url.PRJPAid') and not isdefined('Form.PRJPAid')>
	<cfset Form.PRJPAid = url.PRJPAid>
</cfif>
<cfif IsDefined('url.PRJPACid') and not isdefined('Form.PRJPACid')>
	<cfset Form.PRJPACid = url.PRJPACid>
</cfif>
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Productos por Actividades
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Administraci&oacute;n de Proyectos">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="0" cellspacing="1">
			<tr><td><cfinclude template="PRJPobraProducto-header.cfm"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><cfinclude template="PRJPobraProducto-form.cfm"></td></tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
