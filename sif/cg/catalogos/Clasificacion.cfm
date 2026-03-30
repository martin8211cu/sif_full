

	<cf_templateheader title="Contabilidad General">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>			
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Clasificaci&oacute;n de Cat&aacute;logo">
						<cfinclude template="../../portlets/pNavegacionCG.cfm">
						<table width="100%" align="center">
							<tr>
								<td width="100%" valign="top">
									<cfinclude template="Clasificacion-form.cfm">
								</td>
							</tr>
						</table>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>