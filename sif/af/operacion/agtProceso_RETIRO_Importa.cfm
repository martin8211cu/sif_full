
<cf_templateheader title="Activos Fijos">
	  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importar Retiro">
		
			<center>
				<table width="100%">
					<tr>
						
						<td align="right" valign="top" width="60%" >
							<cf_sifFormatoArchivoImpr EIcodigo = 'AFRET'>
						</td>
						<td align="center" valign="top" width="40%" >
							<cf_sifimportar EIcodigo="AFRET" mode="in"/>
						</td>
					</tr>
					<tr>
						<td colspan="2"align="center" valign="top">
							<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: href='agtProceso_listaGrupos.cfm'">
						</td>
					</tr>
				</table>
			</center>
	
		<cf_web_portlet_end>
	<cf_templatefooter>

