<!--- <cf_dump var="#form#">--->

<!--- JMRV. 12/08/2014. --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default= "Cancelación de Contratos" XmlFile="cancelacionContratos.xml" returnvariable="LB_titulo"/>


<cf_templateheader title="#LB_titulo#">
	<cf_web_portlet_start titulo="#LB_titulo#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfinclude template="cancelacionContratos-listaForm.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
	
