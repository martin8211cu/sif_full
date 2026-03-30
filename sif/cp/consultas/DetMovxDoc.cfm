<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_ConsDoc 	= t.Translate('TIT_ConsDoc','Consulta de Documento')>

<cfset regresar = "/cfmx/sif/cp/MenuCP.cfm">
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta de Documento">
			<cfinclude template="DetMovxDoc-Form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>
