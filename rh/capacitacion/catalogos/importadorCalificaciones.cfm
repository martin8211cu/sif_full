<cf_templateheader title="Importador de Calificaciones">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr> 
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Calificaciones">
					<!---<cfinclude template="/sif/portlets/pNavegacion.cfm">--->
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = 'RHCALIF'>
							</td>
							<td valign="top" align="center">
								<cf_sifimportar eicodigo="RHCALIF" mode="in">
								<cf_sifimportarparam name="RHCid" value= "#form.RHCid#">
								</cf_sifimportar>
							</td>
							<td valign="top"><cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR"></td>
						</tr>
					</table>	
				<cf_web_portlet_end>
			</td>	
	 	</tr>
	</table>
<cf_templatefooter>