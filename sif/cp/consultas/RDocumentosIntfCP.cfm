<cfset regresar = "/cfmx/sif/cp/MenuCP.cfm"> 
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_ConsDoc = t.Translate('Tit_ConsDoc','Consulta de Documentos por Interfaz')>

<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Tit_ConsDoc#">
			<cfinclude template="RDocumentosIntfCP_form.cfm"> 
		<cf_web_portlet_end>
<cf_templatefooter>