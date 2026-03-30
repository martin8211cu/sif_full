<cf_templateheader title="Modificación de Solicitudes de Compra Rechazadas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Modificación de Solicitudes de Compra Rechazadas'>
		<cfset Request.OCRechazada.Action = "solicitudesRechazadas-form.cfm">
		<cfset Request.OCRechazada.ModoRechazo = true>
		<cfinclude template="solicitudes-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>