<!---
	Creado por: Ana Villavicencio
	Fecha: 21 de noviembre del 2005
	Motivo: Nuevo reporte de Vacaciones por empleado
--->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_RecursosHumanosReporteVacacionesPorEmpleado"
	default="Recursos Humanos - Reporte Vacaciones por Empleado"
	returnvariable="LB_RecursosHumanosReporteVacacionesPorEmpleado"/>

    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_ListadoDeEmpleados"
	default="Listado de Empleados"
	returnvariable="LB_ListadoDeEmpleados"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_RecursosHumanos"
		default="Recursos Humanos"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="#LB_ListadoDeEmpleados#" skin="#Session.Preferences.Skin#"> 
						<cfif isDefined("url.btnFiltrar")> 
							<!--- Reporte --->
							<cfif isdefined("Url.CFcodigoI") and not isdefined("form.CFcodigoI")>
								<cfparam name="form.CFcodigoI" default="#url.CFcodigoI#">
							</cfif>
							<cfif isdefined("Url.CFcodigoF") and not isdefined("form.CFcodigoF")>
								<cfparam name="form.CFcodigoF" default="#url.CFcodigoF#">
							</cfif>
							<cfif isdefined("Url.formato") and not isdefined("form.formato")>
								<cfparam name="form.formato" default="#url.formato#">
							</cfif>
							
							<cfinclude template="VacacionesEmp-reporte.cfm">
							
						<!--- <cfelseif isDefined("Form.btnFiltrar")> 
							<!--- Consulta --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="EmpleadosCF-filtro.cfm"> --->
						<cfelse>
							<!--- Filtro --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="VacacionesEmp-Filtro.cfm">
						</cfif>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>