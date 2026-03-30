<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaComparativaRelacionDeEvaluacionPuesto"
	Default="Consulta Comparativa Relaci&oacute;n de Evaluaci&oacute;n / Puesto"
	returnvariable="LB_ConsultaComparativaRelacionDeEvaluacionPuesto"/>

<cf_templateheader title="#LB_ConsultaComparativaRelacionDeEvaluacionPuesto#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConsultaComparativaRelacionDeEvaluacionPuesto"
		Default="Consulta Comparativa Relaci&oacute;n de Evaluaci&oacute;n/Puesto"
		returnvariable="LB_ConsultaComparativaRelacionDeEvaluacionPuesto"/>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
		titulo='#LB_ConsultaComparativaRelacionDeEvaluacionPuesto#'>
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfinclude template="habilidades-filtro.cfm">
		
		<cfif isdefined('form.btnFiltrar') and isdefined('form.RHEEid_f') and form.RHEEid_f NEQ ''>
			<cfset param = "">
			<cfif isdefined('form.RHEEid_f') and form.RHEEid_f NEQ ''>
				<cfset param = param & "&RHEEid_f=#form.RHEEid_f#">
			</cfif>
			<cfif isdefined('form.RHPcodigo_f') and form.RHPcodigo_f NEQ ''>
				<cfset param = param & "&RHPcodigo_f=#form.RHPcodigo_f#">
			</cfif>
			<cfif isdefined('form.DEid') and form.DEid NEQ ''>
				<cfset param = param & "&DEid=#form.DEid#">
			</cfif>
		
			<cf_rhimprime datos="/rh/evaluaciondes/consultas/habilidades-form.cfm" paramsuri="#param#">
			<cf_sifHTML2Word>
				<cfinclude template="habilidades-form.cfm">
			</cf_sifHTML2Word>
		</cfif>
	<cf_web_portlet_end>	
<cf_templatefooter>