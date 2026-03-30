<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Beneficios">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfinclude template="beneficios-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>	
