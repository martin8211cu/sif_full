<cfset Titulo = "Par&aacute;metros Cuentas de Eliminaci&oacute;n">
<cf_templateheader title="Parametrizaci&oacute;n de Cuentas de Eliminaci&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><cfinclude template="../../../sif/portlets/pNavegacionAD.cfm"></td>
			</tr>
			<tr>
				<td><cfinclude template="formParametrosCtaEliminacion.cfm"></td>
			</tr>
		</table>		   
	<cf_web_portlet_end>
<cf_templatefooter>