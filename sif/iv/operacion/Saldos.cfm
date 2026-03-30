<cf_templateheader title="Inventarios">
		<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Liquidación de Salos de Documentos de CXP y CXC">
		<cfset TipoNeteo = 2>
		<cfinclude template="Neteo-form.cfm">
		<cf_web_portlet_end> 
	<cf_templatefooter>