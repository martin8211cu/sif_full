<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales - Ventanilla
</cf_templatearea>

<cf_templatearea name="body">
	<cf_templatecss>
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ventanilla'>
		<cfinclude template="buscar-form.cfm">
	</cf_web_portlet>	
</cf_templatearea>
</cf_template>