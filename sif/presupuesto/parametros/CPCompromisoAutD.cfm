<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Templateheader = t.Translate('LB_Templateheader','Detalle de cuentas con compromiso automático')>

<cf_templateheader title="#LB_Templateheader#">
	  <cf_web_portlet_start titulo="#LB_Templateheader#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="CPCompromisoAutD-form.cfm">
	  <cf_web_portlet_end>
<cf_templatefooter>