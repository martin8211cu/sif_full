<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nombre_proceso" Default="Boleta de Liquidaci&oacute;n Laboral" returnvariable="nombre_proceso"/>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfquery name="rsEmpresaPanama" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'PA'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfquery name="rsEmpresaMexico" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'MX'
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

	<cf_web_portlet_start titulo='#nombre_proceso#'>
		<cfoutput>#pNavegacion#</cfoutput>

		<cfif isdefined("form.DLlinea") and Len(Trim(form.DLlinea))>
			<cfif rsEmpresa.RecordCount NEQ 0><!---========= PARA GUATEMALA =========---->
				<cfset params = ''>
				<cfif isdefined('form.DEidentificacion') and LEN(TRIM(form.DEidentificacion))>
					<cfset params = params & '&DEidentificacion=' & form.DEidentificacion>
				</cfif>
				<cfif isdefined('form.DEidentificacion_h') and LEN(TRIM(form.DEidentificacion_h))>
					<cfset params = params & '&DEidentificacion_h=' & form.DEidentificacion_h>
				</cfif>
				<cfif isdefined('form.ACDDEPERIODO') and LEN(TRIM(form.ACDDEPERIODO))>
					<cfset params = params & '&ACDDEPERIODO=' & form.ACDDEPERIODO>
				</cfif>
				<cf_rhimprime datos="/rh/nomina/liquidacion/liquidacionBoletaGT-form.cfm" paramsuri="&DLlinea=#Form.DLlinea#">
				<cfinclude template="/rh/nomina/liquidacion/liquidacionBoletaGT-form.cfm">
			<cfelseif rsEmpresaPanama.RecordCount NEQ 0><!----========= PARA PANAMA =========---->
				<cfset params = '?DLlinea=#form.DLlinea#'>
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					<cfset params = params & '&DEid=#form.DEid#'>
				</cfif>
				<cf_rhimprime datos="/rh/nomina/liquidacion/liquidacionBoletaPA-form.cfm" paramsuri="#params#">
				<cfinclude template="/rh/nomina/liquidacion/liquidacionBoletaPA-form.cfm">
			<cfelseif rsEmpresaMexico.RecordCount NEQ 0><!----========= PARA Mexico =========---->
				<cfset params = '?DLlinea=#form.DLlinea#'>
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					<cfset params = params & '&DEid=#form.DEid#'>
				</cfif>
				<cf_rhimprime datos="/rh/nomina/liquidacion/liquidacionBoletaMX-form.cfm" paramsuri="#params#">
				<cfinclude template="/rh/nomina/liquidacion/liquidacionBoletaMX-form.cfm">
			<cfelse><!----========= TODAS LAS OTRAS =========---->
				<cf_rhimprime datos="/rh/nomina/liquidacion/liquidacionBoleta-form.cfm" paramsuri="&DLlinea=#Form.DLlinea#"><!---  --->
				<cfinclude template="/rh/nomina/liquidacion/liquidacionBoleta-form.cfm">
			</cfif>
		<cfelse>
			<cfinclude template="liquidacionBoleta-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
