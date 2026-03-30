<cfif isdefined("url.Ecodigo") and len(trim(url.Ecodigo)) and isdefined("url.consulta")>
	<cfset form.Ecodigo = url.Ecodigo>
<cfelse>
	<cfset form.Ecodigo = session.Ecodigo>
</cfif>

<cfif isdefined("url.consulta") and len(trim(url.consulta))>
	<cfset form.consulta = url.consulta>
</cfif>

<cfif not isdefined("form.consulta")>
	<cfset form.consulta = 'N'>
</cfif>

<cfif isdefined("url.tab") and len(trim(url.tab))>
	<cfset form.tab = url.tab>
</cfif>
<cfif isdefined("url.aid") and len(trim(url.aid))>
	<cfset form.aid = url.aid>
</cfif>

<cfif form.consulta eq 'N'>
	<cfset titulo = "Cat&aacute;logo de Activos Fijos">
<cfelse>
	<cfset titulo = "Consulta de Activos Fijos">
</cfif>

<cfparam name="form.Aid">
<cf_templateheader title="Activos Fijos">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">		        
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<cfparam name="form.tab" default="1">
								<cf_web_portlet_start titulo="#titulo#">
										<cf_tabs width="100%">
											<cf_tab text="Informaci&oacute;n General" selected="#form.tab eq 1#">
												<cfif form.tab eq 1>
													<cfinclude template="Activos_frameInformacion.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Anotaciones" selected="#form.tab eq 2#">
												<cfif form.tab eq 2>
													<cfinclude template="Activos_frameAnotacion.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Depreciaci&oacute;nes" selected="#form.tab eq 3#">
												<cfif form.tab eq 3>
													<cfinclude template="Activos_frameDepreciacion.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Revaluaci&oacute;nes" selected="#form.tab eq 4#">
												<cfif form.tab eq 4>
													<cfinclude template="Activos_frameRevaluacion.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Mejoras" selected="#form.tab eq 5#">
												<cfif form.tab eq 5>
													<cfinclude template="Activos_frameMejora.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Retiros" selected="#form.tab eq 6#">
												<cfif form.tab eq 6>
													<cfinclude template="Activos_frameRetiro.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Traslados" selected="#form.tab eq 7#">
												<cfif form.tab eq 7>
													<cfinclude template="Activos_frameTraslados.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Otros Datos" selected="#form.tab eq 8#">
												<cfif form.tab eq 8>
													<cfinclude template="Activos_frameOtrosDatos.cfm">
												</cfif>
											</cf_tab>
										</cf_tabs>
										<script language="javascript1.2" type="text/javascript">
											function tab_set_current(n) {
												location.href = "Activos.cfm?Aid=<cfoutput>#Form.Aid#</cfoutput>&consulta=<cfoutput>#Form.consulta#</cfoutput>&Ecodigo=<cfoutput>#Form.Ecodigo#</cfoutput>&tab="+n;
											}
										</script>
								<cf_web_portlet_end>
							</td>
						</tr>
					</table>
				</td> 
			</tr>
		</table>
	<cf_templatefooter>