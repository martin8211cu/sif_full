<cf_templateheader title="Importador Traslados de Presupuesto">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr> 
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación Traslados de Prespuesto">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = "TR_PPTO">
							</td>
							<td valign="top" align="center">
								<cf_sifimportar eicodigo="TR_PPTO" mode="in" />
							</td>
							<td valign="top"><cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR"></td>
						</tr>
						<tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='../operacion/traslado-registro-lista.cfm'"></td></tr>
					</table>	
				<cf_web_portlet_end>
			</td>	
	 	</tr>
	</table>	
<cf_templatefooter>