<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		 Importaci&oacute;n de Montos de Escalas Salariales
	</cf_templatearea>
	<cf_templatearea name="body">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Montos de Escalas Salariales">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
					<td align="center" width="2%">&nbsp;</td>
					<td align="center" valign="top" width="55%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'I_RH_CATEG'>
					</td>
					
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="I_RH_CATEG" mode="in" />
					</td>
				</tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
			</table>

		<cf_web_portlet_end>

	</cf_templatearea>
</cf_template>
