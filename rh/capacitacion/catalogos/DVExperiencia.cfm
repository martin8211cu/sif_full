<em></em><!--- VARIABLE SDE TRADUCCION --->
<cfinvoke method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" component="sif.Componentes.Translate" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke method="Translate" Key="LB_" Default="Recursos Humanos" component="sif.Componentes.Translate" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke returnvariable="LB_Etiquetas" method="Translate" Key="LB_Etiquetas" component="sif.Componentes.Translate" Default="Etiquetas"/>					
<cfinvoke Default="Datos Variables - Experiencia" VSgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<cf_templateheader title="#nombre_proceso#">
		<cf_templatecss>		
        
	  <cf_web_portlet_start titulo="#nombre_proceso#">
			<cfset regresar = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Capacitaci&oacute;n y Desarrollo">
			<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfinclude template="DVExperiencia-form.cfm"> 
	  <cf_web_portlet_end>
<cf_templatefooter>      
