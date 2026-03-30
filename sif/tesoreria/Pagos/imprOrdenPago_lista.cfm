<cfparam name="session.Tesoreria.TESSPestado_F" default="0">
<cfparam name="form.TESSPestado_F" default="#session.Tesoreria.TESSPestado_F#">
<cfset session.Tesoreria.TESSPestado_F = form.TESSPestado_F>

<style type="text/css">
<!--
.pStyle_TESSPmsgRechazo {color: #FF0000}
-->
</style>
<cfinvoke key="LB_Titulo" default="Impresi&oacute;n de Órdenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="imprOrdenPago_lista.xml"/>
<cfset titulo = "">
<cfset titulo = '#LB_Titulo#'>
<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cf_listaOPs IrA="imprOrdenPago.cfm">
<cf_web_portlet_start _end>
