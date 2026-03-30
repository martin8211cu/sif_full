<cfset LvarTitulo = "Parámetros para Órdenes Comerciales">
<cf_templateheader title="#LvarTitulo#">
	<cfinclude template="../../portlets/pNavegacionAD.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LvarTitulo#">
		<cfinclude template="ParametrosOC_form.cfm"></td>
	<cf_web_portlet_end>
<cf_templatefooter>