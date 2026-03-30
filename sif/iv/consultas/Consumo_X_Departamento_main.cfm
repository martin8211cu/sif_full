<cf_templateheader title="Consulta de Consumo por Departamento">
	
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td valign="top">
				<cf_web_portlet_start border="true" titulo="Consulta de Consumo por Departamento" skin="#Session.Preferences.Skin#">
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
										<cf_rhimprime datos="/sif/iv/consultas/Consumo_X_Departamento_Form.cfm" paramsuri="#parametros#" regresar="/cfmx/sif/iv/consultas/Consumo_X_Departamento.cfm?1=1#parametros#"> 
										<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
										
										<cf_htmlReportsHeaders 
										irA="/sif/iv/consultas/Consumo_X_Departamento_Form.cfm"
										FileName="Consumo_Por_Departamento.xls"	
										title="Reporte Tags"
										preview="no"
										Print ="no"
										Back ="no">

										<cfinclude template="Consumo_X_Departamento_Form.cfm">
									</td>	
								</tr>
							</table>	
						</td></tr>
					</table>
				<cf_web_portlet_end>	
			</td></tr>
		</table>	
	<cf_templatefooter>