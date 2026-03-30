<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>    
		<cf_web_portlet_start titulo="<cfoutput>#LB_RecursosHumanos#</cfoutput>">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfinclude template="evaluacion-config.cfm">
			<cfinclude template="evaluacion-header.cfm">
			<cfinclude template="evaluacion-#formname#.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>