<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_Neteo = t.Translate('TIT_Neteo','Neteo de Documentos de CXP y CXC')>

<cf_templateheader title="#TIT_Neteo#">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="#TIT_Neteo#">
			<cfset TipoNeteo = 1>
			<cfinclude template="Neteo-Common-Lista.cfm">
		<cf_web_portlet_end> 
	<cf_templatefooter>