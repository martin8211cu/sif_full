<cf_templateheader title="Orden Trabajo">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Orden Trabajo">
		<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="100%" valign="top">
					<cfinclude template="OrdenTrab-listaform.cfm"></td>
				</td>	
			</tr>
	 	</table>
	 <cf_web_portlet_end>	
<cf_templatefooter>