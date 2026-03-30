	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Consulta_de_Incapacidad_de_Empleados"
		Default="Consulta de Incapacidades por Empleado"
		returnvariable="LB_Titulo"/>

	<cfoutput>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="#Session.Preferences.Skin#"> 
						<table width="100%">
							<tr><td><cfinclude template="incapacidadEmpleado-form.cfm"></td></tr>
						</table>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>
	</cfoutput>