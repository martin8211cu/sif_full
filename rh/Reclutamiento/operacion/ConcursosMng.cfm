<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_AdministracionDeConcursos"
Default="Administraci&oacute;n De Concursos"
returnvariable="LB_AdministracionDeConcursos"/> 	

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		
		<cf_web_portlet_start border="true" titulo="#LB_AdministracionDeConcursos#" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfinclude template="ConcursosMng-form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>