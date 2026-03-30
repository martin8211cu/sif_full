<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales - Ventanilla
</cf_templatearea>

<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ventanilla'>
		<cfinclude template="tramite-tabs.cfm">
	<cf_web_portlet_end>	
</cf_templatearea>
</cf_template>