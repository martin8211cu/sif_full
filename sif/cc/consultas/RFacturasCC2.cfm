<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar','listaDocsAFavorCC.cfm')>
<cfset LB_Titulo = t.Translate('LB_Titulo','Consulta de Documentos')>
<cf_templateheader title="#LB_TituloH#">
	<cfinclude template="/sif/portlets/pNavegacionCC.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
			<cfinclude template="RFacturasCC2-Form.cfm"> 
		<cf_web_portlet_end>
<cf_templatefooter>