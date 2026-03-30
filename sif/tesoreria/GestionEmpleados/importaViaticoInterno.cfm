<cf_templateheader title=" Importaci&oacute;n de Viatico Interno">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Viatico Interno">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td colspan="3" align="center">&nbsp;</td>
			</tr>
			<tr>
				<td align="center" style="padding-left: 15px " valign="top">
				<cf_sifFormatoArchivoImpr EIcodigo = 'IMPVIATICOI'>
			  <td align="center" style="padding-left: 15px " valign="top">
					<cf_sifimportar EIcodigo="IMPVIATICOI" mode="in">				
					</cf_sifimportar>
					<cfoutput>
						<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='catalogoPlantillaViaticos.cfm'" />
					</cfoutput>
					</td>
				<cfif isdefined('url.Pagina')>
				<td valign="top"></td>
				</cfif>
			</tr>
			<tr><td colspan="3" align="center">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>