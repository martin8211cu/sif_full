<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
					
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ConceptosPorTipoDeExpediente"
			Default="Conceptos por Tipo de Expediente"
			returnvariable="LB_ConceptosPorTipoDeExpediente"/>
					
	  <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ConceptosPorTipoDeExpediente#">
	  	<cfif isdefined("url.TEid") and len(Trim(url.TEid))>
			<cfset Form.TEid = url.TEid>
		</cfif>
		<cfset navBarItems = ArrayNew(1)>
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarStatusText = ArrayNew(1)>			 
		<cfset navBarItems[1] = "Estructura Organizacional">
		<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
		<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">						
		<cfset Regresar = "/cfmx/rh/admin/catalogos/TiposExpediente.cfm?TEid=#Form.TEid#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfinclude template="ConceptosExp-listaForm.cfm">
	  <cf_web_portlet_end>
<cf_templatefooter>