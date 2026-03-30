<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
      Recursos Humanos
	</cf_templatearea>

	<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Descalificar Concursante'>
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
			<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td>
					<table align="center" width="99%" cellpadding="10" cellspacing="0">
						<tr><td><cfinclude template="info-concurso.cfm"></td></tr>
						<tr><td>
							<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Descalificar Concursante">
							<cfinclude template="descalificar-form.cfm">
							<cf_web_portlet_end>
						</td></tr>
					</table>
				</td>
			</tr>	
			<tr><td>&nbsp;</td></tr>
		</table>	
	<cf_web_portlet_end>

	</cf_templatearea>
</cf_template>
