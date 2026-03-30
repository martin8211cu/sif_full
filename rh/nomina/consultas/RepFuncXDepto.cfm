 
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>
 
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ListadoDeEmpleados"
Default="Listado de Empleados"
returnvariable="LB_ListadoDeEmpleados"/> 
 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="#LB_ListadoDeEmpleados#" skin="#Session.Preferences.Skin#"> 						
							<!--- Filtro --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="RepFuncXDepto-filtro.cfm">			
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>