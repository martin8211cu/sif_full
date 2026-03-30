<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Administración de Recursos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Administración de Proyectos">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfif isdefined("url.PRJRid") and not isdefined("form.PRJRid")><cfset form.PRJRid = url.PRJRid></cfif>
			<cfif isdefined("url.PAGENUM") and not isdefined("form.PAGENUM")><cfset form.PAGENUM = url.PAGENUM></cfif>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="40%" valign="top"><cfinclude template="Recursos-lista.cfm"></td>
					<td width="60%" valign="top"><cfinclude template="Recursos-form.cfm"></td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
