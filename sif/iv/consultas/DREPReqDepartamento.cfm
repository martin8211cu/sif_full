<cf_templateheader title="Detalle de Requisiciones por Departamento">
	
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td valign="top">
				<cf_web_portlet_start border="true" titulo="Detalle de Requisiciones por Departamento" skin="#Session.Preferences.Skin#">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr><td valign="top">
							<table width="100%"  border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">
										<cfset parametros = "">
										<cfif isdefined("url.ERid") and len(trim(url.ERid))>
											<cfset parametros = "&ERid=#url.ERid#">
										</cfif>
										<cfinclude template="../../portlets/pNavegacion.cfm">
										<cf_rhimprime datos="/sif/iv/consultas/DREPReqDepartamento-form.cfm" paramsuri="#parametros#"> 
										<cfinclude template="DREPReqDepartamento-form.cfm">
									</td>	
								</tr>
							</table>	
						</td></tr>
					</table>
				<cf_web_portlet_end>	
			</td></tr>
		</table>	
	<cf_templatefooter>