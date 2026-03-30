<cfif isdefined('url.importa') and url.importa EQ 'true'>
	<cf_templateheader title=" Importaci&oacute;n de Centros Funcionales">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n De Centros Funcionales">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td align="center" valign="top" width="55%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'CFIMPORTADOR'>
					</td>
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="CFIMPORTADOR" mode="in">
						</cf_sifimportar>
						<cf_botones exclude="Alta,Limpiar" regresar="CFuncional.cfm" tabindex="1">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
	<cfabort>
<cfelse>
	<cfinclude template="/rh/admin/catalogos/CFuncional-lista.cfm">
</cfif>
