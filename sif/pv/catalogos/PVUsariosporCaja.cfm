<cf_templateheader title="Recursos Humanos">


	<cf_web_portlet_start border="true" titulo="Usuarios por caja" skin="#Session.Preferences.Skin#">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td valign="top" width="50%">
				<cfinclude template="PVListaCajas.cfm">
			</td>
			<td valign="top">			
				<cfinclude template="PVSeleccionUsuarios.cfm">
			</td>
		  </tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>