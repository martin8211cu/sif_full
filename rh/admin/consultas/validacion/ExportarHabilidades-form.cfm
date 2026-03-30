<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos"
XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeCompetenciasPorPuesto" Default="Reporte de Competencias por Puesto" returnvariable="LB_ReporteDeCompetenciasPorPuesto"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="#LB_ReporteDeCompetenciasPorPuesto#" skin="#Session.Preferences.Skin#"> 
					<table width="100%">
						<tr>
							<td>
								<cfparam name="url.CFid" default="">
								<cfparam name="url.dependencias" default="">									
								<cfparam name="url.RHPcodigo" default="">									
								<cfparam name="url.tipocompetencia" default="0">	
								<cfif isdefined("form.CFid") and len(trim(form.CFid))>
									<cfset url.CFid = form.CFid>
								</cfif>
								<cfif isdefined("form.dependencias")>
									<cfset url.dependencias = form.dependencias>
								</cfif>
								<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
									<cfset url.RHPcodigo = form.RHPcodigo>
								</cfif>
								<cfif isdefined("form.tipocompetencia") and len(trim(form.tipocompetencia))>
									<cfset url.tipocompetencia = form.tipocompetencia>
								</cfif>															
								<cfinclude template="ExportarHabilidades-rep.cfm">
							</td>
						</tr>
					</table>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
<cf_templatefooter>
