<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		<cf_translate key="LB_RHAutogestion">RH - Autogesti&oacute;n</cf_translate>
	</cf_templatearea>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_SolicitudDePlazas"
		Default="Solicitud de Plazas"
		returnvariable="LB_SolicitudDePlazas"/>

	<cf_templatearea name="body">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_SolicitudDePlazas#">
			<cfset modulo = "aut">
			<cfif isdefined("url.RHTMid") and len(trim(url.RHTMid))>
				<cfset form.RHTMid = url.RHTMid >
			</cfif>							
			<cfif isdefined("url.RHSPid") and len(trim(url.RHSPid))>
				<cfset form.RHSPid = url.RHSPid >
			</cfif>							
			<table width="100%" border="0" cellspacing="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfif (isdefined('form.RHSPid') and form.RHSPid NEQ '') or (isdefined('form.btnNuevo') and form.btnNuevo NEQ '')>
						<cfinclude template="/rh/planillap/operacion/solicitudPlazas-form.cfm">
					<cfelse>
						<cfinclude template="listaSolicitudPlazasAUT.cfm">
					</cfif>
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
