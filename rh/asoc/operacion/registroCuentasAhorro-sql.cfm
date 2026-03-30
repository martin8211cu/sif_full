<!--- <cf_dump var="#form#"> --->

<cfset params = "">
<cfparam name="Form.ACAAtipo" default="0">
<cfparam name="Form.ACAAporcentaje" default="0.00">
<cfparam name="Form.ACAAmonto" default="0.00">
<cfparam name="Form.Did" default="0">
<cfparam name="Form.DClinea" default="0">
<cfif isdefined("ALTA")>
	<cfinvoke component="rh.asoc.Componentes.ACAportesAsociado" method="Alta" returnvariable="ACAAid"
    	acaid="#Form.ACAid#" acatid="#Form.ACATid#" acaatipo="#Form.ACAAtipo#" acaaporcentaje="#Form.ACAAporcentaje#" 
        acaamonto="#Replace(Form.ACAAmonto,',','')#" acaafechainicio="#Form.ACAAfechaInicio#" did="#Form.Did#" dclinea="#Form.DClinea#"/>
	<cfset params = "&ACAAid=#ACAAid#">
<cfelseif isdefined("CAMBIO")>
	<cf_dbtimestamp
		datasource="#Session.DSN#"
		table="ACAportesAsociado" 
		redirect="registroCuentasAhorro.cfm"
		timestamp="#form.ts_rversion#"
		field1="ACAAid,numeric,#Form.ACAAid#">
    <cfinvoke component="rh.asoc.Componentes.ACAportesAsociado" method="Cambio" acaaid="#Form.ACAAid#"
    	acaid="#Form.ACAid#" acatid="#Form.ACATid#" acaatipo="#Form.ACAAtipo#" acaaporcentaje="#Form.ACAAporcentaje#" 
        acaamonto="#Replace(Form.ACAAmonto,',','')#" acaafechainicio="#Form.ACAAfechaInicio#" did="#Form.Did#" dclinea="#Form.DClinea#"/>
	<cfset params = "&ACAAid=#Form.ACAAid#">
<cfelseif isdefined("BAJA")>
	<cfinvoke component="rh.asoc.Componentes.ACAportesAsociado" method="Baja" acaaid="#Form.ACAAid#" />
</cfif>
<cflocation url="registroCuentasAhorro.cfm?ACAid=#Form.ACAid##params#">