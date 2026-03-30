<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- TemplateBeginEditable name="titulo" -->
			TITULO
		<!-- TemplateEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- TemplateBeginEditable name="mantenimiento" -->
						<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='titulo'>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="3">
										portlet navegacion SIF
									</td>
								</tr>
					
								<tr> 
									<td valign="top"> 
										lista
									</td>
									<td valign="top">
									mantenimiento
									</td>
								</tr>
							</table>
						</cf_web_portlet>	
					<!-- TemplateEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>