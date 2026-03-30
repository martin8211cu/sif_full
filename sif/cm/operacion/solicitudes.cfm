<cf_templateheader title="Registro de Solicitudes de Compra">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Solicitudes de Compra'>
		<cfset Session.Compras.ProcesoCompra.CMPid = "">
		<cfinclude template="solicitudes-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
