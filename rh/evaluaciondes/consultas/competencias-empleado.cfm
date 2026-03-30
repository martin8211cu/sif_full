<cfif not len(trim(form.DEid))><cflocation url="competencias-empleado-filtro.cfm"></cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDeCompetenciasPorColaborador"
	Default="Consulta de Competencias por Colaborador"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ConsultaDeCompetenciasPorColaborador"/>
<cf_templateheader title="#LB_ConsultaDeCompetenciasPorColaborador#">

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CompetenciasPorColaborador"
		Default="Competencias por Colaborador"
		returnvariable="LB_CompetenciasPorColaborador"/>
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_CompetenciasPorColaborador#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td ><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr><td>
				<cfset param = "">
				<cfset param = param & "&DEid=#form.DEid#">
				<cfif isdefined('form.plansucesion') and form.plansucesion NEQ ''>
					<cfset param = param & "&plansucesion=#form.plansucesion#">
				</cfif>

				<cf_rhimprime datos="/rh/evaluaciondes/consultas/competencias-empleado-form.cfm" paramsuri="#param#">
				<cfinclude template="competencias-empleado-form.cfm">
			</td></tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>