<cfif IsDefined('url.PRJPOid') and not isdefined('Form.PRJPOid')>
	<cfset Form.PRJPOid = url.PRJPOid>
</cfif>
<cfif IsDefined('url.PRJPAid') and not isdefined('Form.PRJPAid')>
	<cfset Form.PRJPAid = url.PRJPAid>
</cfif>
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Actividades por Area
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Administraci&oacute;n de Proyectos">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="0" cellspacing="1">
			<tr><td><cfinclude template="PRJPobraActividad-header.cfm"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td><cfinclude template="PRJPobraActividad-form.cfm"></td></tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
