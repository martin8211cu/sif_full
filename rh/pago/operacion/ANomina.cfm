<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="AutorizacionNomina"
Default="Autorizaci&oacute;n de N&oacute;ómina"
returnvariable="AutorizacionNomina"/>			 
 
  <cf_web_portlet_start titulo="#AutorizacionNomina#">
		<cfset regresar = "/cfmx/rh/pago/operacion/listaANomina.cfm">
		<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
		<cfinclude template="formANomina.cfm">
  <cf_web_portlet_end>
