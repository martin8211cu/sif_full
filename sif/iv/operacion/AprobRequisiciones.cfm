<cf_templateheader title="Requisiciones">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aprobación de Requisiciones de Inventario'>
		<cfinclude template="AprobRequisiciones-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>