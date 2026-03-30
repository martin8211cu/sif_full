<cfset LvarTitulo = "Parámetros para Gastos de Empleado">
<cf_templateheader title="#LvarTitulo#">
	<cfinclude template="../../portlets/pNavegacionAD.cfm">&nbsp;
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LvarTitulo#">
		<cfinclude template="ParametrosGE_form.cfm"></td>
	<cf_web_portlet_end>
<cf_templatefooter>
<hr />
	