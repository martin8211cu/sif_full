<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		Registro de Encuestas Salariales
	</cf_templatearea>	
	<cf_templatearea name="body">
	  <cf_web_portlet_start border="true" titulo="Habilidades" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="4" cellspacing="0">
				<tr>
					<td valign="top" nowrap  width="60%" align="center">
						<cfif isdefined("url.Eid") and not isdefined('Form.Eid')>
							<cfset Form.Eid = Url.Eid>
						</cfif>
						
						<cfif isdefined('form.btnNueva') or isdefined("Form.Eid")>						
							<cfinclude template="Encuesta-form.cfm">
						<cfelse>
							<cfinclude template="listaDatosEncuestas.cfm">
						</cfif>
					</td>
				</tr>
			</table>	  
	  <cf_web_portlet_end>
	</cf_templatearea>
</cf_template>	  
