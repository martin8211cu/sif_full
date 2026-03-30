<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Facturaci&oacute;n - Revisi&oacute;n de Cr&eacute;dito
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Revisi&oacute;n de Cr&eacute;dito'>
			<cfinclude template="revisionCredito-form.cfm">
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>