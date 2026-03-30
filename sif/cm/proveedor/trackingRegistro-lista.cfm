<cf_templateheader title="Lista de Embarques">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Embarques'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfset paginaSQL = "trackingRegistro-sql.cfm">
			<cfinclude template="frame-lista-tracking.cfm">

		<cf_web_portlet_end>
	<cf_templatefooter>
