<cfparam name="session.Tesoreria.TESSPestado_F" default="0">
<cfparam name="form.TESSPestado_F" default="#session.Tesoreria.TESSPestado_F#">
<cfset session.Tesoreria.TESSPestado_F = form.TESSPestado_F>

<style type="text/css">
<!--
.pStyle_TESSPmsgRechazo {color: #FF0000}
-->
</style>

<!---<cfset titulo = "">
<cfset titulo = 'Impresi&oacute;n de Solicitudes de Pago'>--->
<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cf_SP_lista FiltarxUsuario="#LvarFiltroPorUsuario#" IrA="imprSolicitPago#LvarSufijoForm#.cfm">
<cf_web_portlet_start _end>
