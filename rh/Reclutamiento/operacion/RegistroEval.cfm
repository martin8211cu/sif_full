<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Registro de Evaluaciones 
	</cf_templatearea>
	
	<cf_templatearea name="body">

	  <cf_web_portlet_start border="true" titulo="Evaluaciones" skin="#Session.Preferences.Skin#">

			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<table width="100%" cellpadding="4" cellspacing="0">
				<tr>
					<td valign="top" nowrap  width="60%" align="center">
						<cfif not isdefined("modo")>
							<cfset modo = "alta">
						</cfif>
						<cfif isdefined("url.RHCconcurso") and LEN(url.RHCconcurso) NEQ 0>
							<cfset Form.RHCconcurso = Url.RHCconcurso>
						</cfif>
						<cfif isDefined("Url.RHPCid") and not isDefined("form.RHPCid")>
							<cfset form.RHPCid = Url.RHPCid>
						</cfif>									

						<cfif isdefined("Form.RHCconcurso") and LEN(Form.RHCconcurso) GT 0>
							<cfinclude template="Evaluaciones.cfm">
						<cfelse>
							<cflocation addtoken="no" url="/cfmx/rh/Reclutamiento/operacion/listaRegistroEval.cfm">
						</cfif>
					</td>
				</tr>
			</table>	  
	  <cf_web_portlet_end>
	</cf_templatearea>
</cf_template>	  
