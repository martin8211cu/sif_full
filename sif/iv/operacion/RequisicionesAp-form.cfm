<cf_templateheader title="Requisiciones (Aprobación)">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Requisiciones (Aprobación)'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
		<cfset LvarUsuarioAprobador = true>
		<cfinclude template="Requisiciones-form.cfm">
		<br></td></tr></table>
		<cf_web_portlet_end>
	<cf_templatefooter>

