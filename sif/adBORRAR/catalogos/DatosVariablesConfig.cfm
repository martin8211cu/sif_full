<cf_templateheader title="Configuración de Datos Variables">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Configuración de Datos Variables y Eventos">
			<cfparam name="URL.TipoConfig" default="DatoVariable">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td width="32%" valign="top">
						<cfinclude  template="DatosVariablesConfig-arbol.cfm">
				  </td>
					<td width="68%" valign="top">
						<cfinclude  template="DatosVariablesConfig-form.cfm">
				  </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>