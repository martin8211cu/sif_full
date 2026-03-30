<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->
<style type="text/css">
<!--
.pStyle_TESSPmsgRechazo {color: #FF0000}
-->
</style>

<cfset titulo = 'Cambio de Tesoreria a Solicitudes de Pago aprobadas'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfset Attributes.irA="solicitudesPasar.cfm">
	<cfset Attributes.PasarSP="yes">
	<cfinclude template="../Solicitudes/SP_lista.cfm">
<cf_web_portlet_end>
