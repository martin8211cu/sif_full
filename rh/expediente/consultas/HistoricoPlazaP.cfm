<!--- 
	Creado por: Ana Villavicencio
	Fecha: 26 de enero del 2006
	Motivo: Nuevo reporte de histórico de una plaza presupuestaria. 
 --->
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
						
						<cfif isDefined("url.Consultar")> 
							<!--- Reporte --->
							<cfif isdefined("Url.CFcodigoI") and not isdefined("form.CFcodigoI")>
								<cfparam name="form.CFcodigoI" default="#url.CFcodigoI#">
							</cfif>
							<cfif isdefined("Url.CFcodigoF") and not isdefined("form.CFcodigoF")>
								<cfparam name="form.CFcodigoF" default="#url.CFcodigoF#">
							</cfif>
							<cfif isdefined("Url.FechaCorte") and not isdefined("form.FechaCorte")>
								<cfparam name="form.FechaCorte" default="#url.FechaCorte#">
							</cfif>
							<cfif isdefined("Url.formato") and not isdefined("form.formato")>
								<cfparam name="form.formato" default="#url.formato#">
							</cfif>
							
							<cfinclude template="HistoricoPlazaP-reporte.cfm">
						<cfelse>
							<!--- Filtro --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="HistoricoPlazaP-filtro.cfm">
						</cfif>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>