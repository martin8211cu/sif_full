<cf_templateheader title=" Importaci&oacute;n de Retiro de Activos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Retiro de Activos">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td colspan="3" align="center">&nbsp;</td></tr>
			<tr>
			<td align="center" width="2%">&nbsp;</td>
			<td align="center" valign="top" width="55%">
			<cf_sifFormatoArchivoImpr EIcodigo = 'AFDEPMAN' tabindex="1">
			</td>
		
			<td align="center" style="padding-left: 15px " valign="top">
	
			<cf_sifimportar EIcodigo="AFDEPMAN" mode="in"  tabindex="1" >
			<cf_sifimportarparam name="AGTPid" value="#url.AGTPid#">
			</cf_sifimportar>
			</td>
			</tr>
			<tr><td colspan="3" align="center">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
