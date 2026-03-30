<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Planificación de Jornadas"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cfif isdefined("Url.CFid") and not isdefined("Form.CFid")>
							<cfset Form.CFid = Url.CFid>
						</cfif>
						<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
							<cfset Form.DEid = Url.DEid>
						</cfif>							
						<cfif isdefined("Url.opcion") and not isdefined("Form.opcion")>
							<cfset Form.opcion = Url.opcion>
						</cfif>
											
						<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) and not isdefined("form.opcion")>
							<cfinclude template="PlanificaJornadas-empleado.cfm">
						  <cfelseif isdefined("Form.CFid") and Len(Trim(Form.CFid)) and isdefined("form.opcion") and form.opcion EQ 'VE'>
							<cfinclude template="PlanificaJornadas-cfempleado.cfm">
						  <cfelse>
							<cfinclude template="PlanificaJornadas-cfuncional.cfm">
						</cfif>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
</cf_templatearea>
</cf_template>