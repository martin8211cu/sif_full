<!--- Valida Comprador. Se asegura que solo hay acceso a esta pantalla si es un comprador --->
<cfif not (isdefined("session.compras.comprador") and len(trim(session.compras.comprador)))>
	<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
</cfif>
<cf_templateheader title="Registro Manual de Ordenes de Compra">
	<cf_web_portlet_start titulo="Cambio de la Forma de Pago">		
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="ordenCompraE_cambioFP.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

