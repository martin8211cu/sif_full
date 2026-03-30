<!--- Valida Comprador. Se asegura que solo hay acceso a esta pantalla si es un comprador --->
<cfif not (isdefined("session.compras.comprador") and len(trim(session.compras.comprador)))>
	<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
</cfif>
<cf_templateheader title="Modificación Ordenes de Compra Rechazadas">
	<cf_web_portlet_start titulo="Modificación Ordenes de Compra Rechazadas">		
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfset Request.OCRechazada.Action = "ordenCompraRechazada-form.cfm">
		<cfset Request.OCRechazada.ModoRechazo = true>
		<cfinclude template="ordenCompraE.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

