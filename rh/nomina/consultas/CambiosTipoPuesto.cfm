<!---
	Creado por: Ana Villavicencio
	Fecha: 03 de enero del 2006
	Motivo: Nuevo reporte de Empleados por Rango de Salarios
<cf_dump var="#url#">--->

 <cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos - Listado de Empleados por Rango de Salarios
	</cf_templatearea> 
	
	<cf_templatearea name="body"> 	
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="Listado de Empleados" skin="#Session.Preferences.Skin#"> 
						
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
							<cfinclude template="CambiosTipoPuesto-reporte.cfm">
						<cfelse>
							<!--- Filtro --->
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="CambiosTipoPuesto-Filtro.cfm">
						</cfif>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	 </cf_templatearea>
</cf_template> 