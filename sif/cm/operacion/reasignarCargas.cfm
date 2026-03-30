<!--- Valida Comprador. Se asegura que solo hay acceso a esta pantalla si es un comprador --->
<cfif not (isdefined("session.compras.comprador") and len(trim(session.compras.comprador)))>
	<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
</cfif>

<cf_templateheader title="Reasignación de Cargas de Trabajo">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
    <cf_web_portlet_start titulo="Reasignación de Cargas de Trabajo">				
		<cfinclude template="reasignarCargas-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>