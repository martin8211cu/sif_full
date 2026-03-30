
<cfinclude template="registroMasivoAjuste-label.cfm">
<cf_templateheader title="#LB_RegistroMasivoAjustes#">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_RegistroMasivoAjustes#'>
		<table width="98%" align="center" cellpadding="2" cellspacing="0">
			<tr>
				<td width="50%" valign="top"><cf_sifFormatoArchivoImpr EIcodigo = 'VACACIONES'></td>
				<td width="50%" valign="top"><cf_sifimportar EIcodigo="VACACIONES" mode="in" /></td>
			</tr>
		</table>
	 <cf_web_portlet_end>
	<cf_templatefooter>