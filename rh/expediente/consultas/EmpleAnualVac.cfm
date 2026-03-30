	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDeEmpleadosInactivos"
	Default="Consulta de Empleados Inactivos"
	returnvariable="LB_ConsultaDeEmpleadosInactivos"/> 
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ConsultaDeEmpleadosInactivos#">
			<cfset modulo = "pp">
								
			<table width="100%" border="0" cellspacing="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfinclude template="EmpleAnualVac-form.cfm">
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>
