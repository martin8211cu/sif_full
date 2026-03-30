<cf_templateheader title="Importación de Cuentas de excepción por socio de Negocio">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación de Cuentas de excepción por socio de Negocio">
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td valign="top" width="60%">
					<cf_sifFormatoArchivoImpr EIcodigo = 'CARGACTSEXP'>
				</td>
				<td align="center" style="padding-left: 15px " valign="top">
					<cf_sifimportar EIcodigo="CARGACTSEXP" mode="in"/>
					<input type="button" name="Regresar" value="Regresar" class="btnAnterior" onclick="javascript:history.back(1)"/>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>