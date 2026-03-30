<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>		
        
        <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Etiquetas"
		Default="Etiquetas"
		returnvariable="LB_Etiquetas"/>					
	  <cf_web_portlet_start titulo="#LB_Etiquetas#">
			<cfset regresar = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
			<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfinclude template="empresa-etiqueta-form.cfm"> 
	  <cf_web_portlet_end>
<cf_templatefooter>      
