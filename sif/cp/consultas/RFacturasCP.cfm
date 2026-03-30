<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_ConsHistxDoc 	= t.Translate('TIT_ConsHistxDoc','Consulta de Histórico por Documento')>
<cfset regresar = "/cfmx/sif/cp/MenuCP.cfm"> 
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#TIT_ConsHistxDoc#">
			<cfinclude template="RFacturasCP-form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>