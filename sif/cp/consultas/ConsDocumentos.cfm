<cfset regresar = "/cfmx/sif/cp/MenuCP.cfm"> 
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_ConsMEC 	= t.Translate('','Consulta de Multas, Embargos y Cesiones')>
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Tit_ConsMEC#">
			<cfinclude template="ConsDocumentos-Form.cfm"> 
		<cf_web_portlet_end>
<cf_templatefooter>