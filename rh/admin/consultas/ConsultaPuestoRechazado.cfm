<!---Variables de traduccion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate" Key="LB_ConsultaDePuestosRechazadas" Default="Consulta de Puestos Rechazados" returnvariable="LB_ConsultaDePuestosRechazadas"/>
<!---Fin Variables de traduccion--->
	
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ConsultaDePuestosRechazadas#'>	
			<cfinclude template="FormPuestoRechazado.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>	
