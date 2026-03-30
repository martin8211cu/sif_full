<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start titulo="Salarios vs Encuestas" width="100%">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfinclude template="comparativo-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>	