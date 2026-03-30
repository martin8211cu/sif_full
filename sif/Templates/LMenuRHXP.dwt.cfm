
<cf_template template="/sif/rh/plantilla/plantilla.cfm">
	<cf_templatearea name="title">
		<!-- TemplateBeginEditable name="titulo" -->
			TITULO
		<!-- TemplateEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="left">
		<!-- TemplateBeginEditable name="menu" -->
			<cfinclude template="/sif/menu.cfm">
		<!-- TemplateEndEditable -->
	</cf_templatearea>

	<cf_templatearea name="header">
		<!-- TemplateBeginEditable name="encabezado" -->
		<!-- TemplateEndEditable -->
	</cf_templatearea>

	<cf_templatearea name="body">
		
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- TemplateBeginEditable name="mantenimiento" -->
						<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='titulo'>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2">
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