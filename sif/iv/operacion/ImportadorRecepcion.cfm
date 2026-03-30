<cf_templateheader title="Inventarios">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación de Recepción de Productos">
					<cfinclude template="/sif/portlets/pNavegacion.cfm"> 
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
					  <tr>
						<td colspan="2" valign="top">
							<cf_sifFormatoArchivoImpr EIcodigo = 'RECEPPROD'>
						</td>
						<td colspan="2" valign="top"><cf_sifimportar eicodigo="RECEPPROD" mode="in" /></td>
					  </tr>
					  </table>
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>