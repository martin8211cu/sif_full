<cf_templateheader title="Consulta de Consumo por Art&iacute;culo y Centro Funcional">
	
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td valign="top">
				<cf_web_portlet_start border="true" titulo="Consulta de Consumo por Art&iacute;culo y Centro Funcional" skin="#Session.Preferences.Skin#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr><td valign="top">
							<table width="100%"  border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">
										<cfset parametros = "">
										<cfoutput>
											<cfif isdefined("form.AidIni") and len(trim(form.AidIni))>
												<cfset parametros = "&AidIni=#form.AidIni#">
											</cfif>
											<cfif isdefined("form.AidFin") and len(trim(form.AidFin))>
												<cfset parametros = parametros & "&AidFin=#form.AidFin#">
											</cfif>
											<cfif isdefined("form.FechaDes") and len(trim(form.FechaDes))>
												<cfset parametros = parametros & "&FechaDes=#form.FechaDes#">
											</cfif>
											<cfif isdefined("form.FechaHas") and len(trim(form.FechaHas))>
												<cfset parametros = parametros & "&FechaHas=#form.FechaHas#">
											</cfif>
											<cfif isdefined("form.ERdocumento") and len(trim(form.ERdocumento))>
												<cfset parametros = parametros & "&ERdocumento=#form.ERdocumento#">
											</cfif>
											
											
										</cfoutput>
										<cfinclude template="../../portlets/pNavegacion.cfm">
										<cf_rhimprime datos="/sif/iv/consultas/Consumo_X_Articulo_CF_Form.cfm" paramsuri="#parametros#" regresar="/cfmx/sif/iv/consultas/Consumo_X_Articulo_CF.cfm?1=1#parametros#"> 
										<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
										<cfinclude template="Consumo_X_Articulo_CF_Form.cfm">
									</td>	
								</tr>
							</table>	
						</td></tr>
					</table>
				<cf_web_portlet_end>	
			</td></tr>
		</table>	
	<cf_templatefooter>