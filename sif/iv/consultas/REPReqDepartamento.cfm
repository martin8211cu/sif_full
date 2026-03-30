<cf_templateheader title="Reporte de Requisiciones por Departamento">
	
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td valign="top">
				<cf_web_portlet_start border="true" titulo="Reporte de Requisiciones por Departamento" skin="#Session.Preferences.Skin#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr><td valign="top">
							<table width="100%"  border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">
										<cfset parametros = "">
										<cfif isdefined("form.depini") and len(trim(form.depini))>
											<cfset parametros = "&depini=#form.depini#">
										</cfif>
										<cfif isdefined("form.depfin") and len(trim(form.depfin))>
											<cfset parametros = parametros & "&depfin=#form.depfin#">
										</cfif>
										<cfinclude template="../../portlets/pNavegacion.cfm">
										<cf_rhimprime datos="/sif/iv/consultas/REPReqDepartamento-form.cfm" paramsuri="#parametros#"> 
										<cfinclude template="REPReqDepartamento-form.cfm">
									</td>	
								</tr>
							</table>	
						</td></tr>
					</table>
				<cf_web_portlet_end>	
			</td></tr>
		</table>	
	<cf_templatefooter>