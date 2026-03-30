	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_VisualizarAlerta"
	Default="Visualizar Alerta"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_VisualizarAlerta"/>

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
					<cf_web_portlet_start border="true" titulo="#LB_VisualizarAlerta#" skin="#Session.Preferences.Skin#"> 
						
						<cfif isDefined("url.btnFiltrar") or isdefined("url.btnAceptarAll")> 
							<!--- Reporte --->
							<cfif isdefined("Url.RHTid") and not isdefined("form.RHTid")>
								<cfparam name="form.RHTid" default="#url.RHTid#">
							</cfif>
							<cfif isdefined("Url.DEid") and not isdefined("form.DEid")>
								<cfparam name="form.DEid" default="#url.DEid#">
							</cfif>
							<cfif isdefined("Url.fechaH") and not isdefined("form.fechaH")>
								<cfparam name="form.fechaH" default="#url.fechaH#">
							</cfif>
							<cfif isdefined("Url.formato") and not isdefined("form.formato")>
								<cfparam name="form.formato" default="#url.formato#">
							</cfif>
							
							<cfinclude template="VisualizaAlerta-reporte.cfm">
							
						<!--- <cfelseif isDefined("Form.btnFiltrar")> 
							<!--- Consulta --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="VisualizaAlerta-filtro.cfm"> --->
						<cfelse>
							<!--- Filtro --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="VisualizaAlerta-filtro.cfm">
						</cfif>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>