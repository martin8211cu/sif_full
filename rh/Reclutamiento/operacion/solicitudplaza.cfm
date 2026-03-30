	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Solicitud_de_Plazas"
		Default="Solicitud de Plazas"
		returnvariable="LB_Solicitud_de_Plazas"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Solicitud de Plazas">
			<cfset modulo = "rs">
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
						<cfinclude template="listasolicitudplazars.cfm">
					</cfif>
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>	