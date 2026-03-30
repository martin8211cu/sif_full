<link href="/cfmx/aspAdmin/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/aspAdmin/css/web_portlet.css" rel="stylesheet" type="text/css">
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Iglesia Adventista de Moravias
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="/aspAdmin/menu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Administración de Cuentas Empresariales" width="10">
				<cfinclude template="CuentaPrincipal.cfm">
</cf_web_portlet>
</cf_templatearea>
</cf_template>
