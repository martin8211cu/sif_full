<cfset Titulo = "Cat&aacute;logo de Par&aacute;metros Adicionales del Sistema">
<cf_templateheader title="SIF - Administraci&oacute;n del Sistema">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><cfinclude template="../../portlets/pNavegacionAD.cfm"></td>
			</tr>
			<tr>
				<td><cfinclude template="formParametrosAuxiliaresAD.cfm"></td>
			</tr>
		</table>		   
	<cf_web_portlet_end>
<cf_templatefooter>