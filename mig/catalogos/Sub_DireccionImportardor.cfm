<cf_templateheader title=" Importaci&oacute;n Sub_Direcciones">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n Sub_Direcciones">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td align="center" valign="top" width="55%">
					
					<cf_sifFormatoArchivoImpr EIcodigo = 'INDSUB_DIREC'>
				</td>
				<td align="center" style="padding-left: 15px " valign="top">
					<cf_sifimportar EIcodigo="INDSUB_DIREC" mode="in">
					</cf_sifimportar>
					<cf_botones exclude="Alta,Limpiar" regresar="Sub_Direccion.cfm" tabindex="1">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
