﻿<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Relaci&oacute;n de C&aacute;lculo de N&oacute;mina"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<cf_web_portlet_start titulo="#nombre_proceso#" >
	<!--- ***** REQUERIDO PARA REUTILIZAR LOS PORTLETS --->
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<cfset form.DEid = url.DEid>
	</cfif>
	<cfif isdefined("url.RCNid") and len(trim(url.RCNid))>
		<cfset form.RCNid = url.RCNid>
	</cfif>
	<cfif isdefined("url.Tcodigo") and len(trim(url.Tcodigo))>
		<cfset form.Tcodigo = url.Tcodigo>
	</cfif>
	<cfinclude template="/rh/portlets/pRelacionCalculo.cfm">
	<cfinclude template="/rh/portlets/pEmpleado.cfm">
	<cfinclude template="ResultadoCalculoCarga-form.cfm">
<cf_web_portlet_end>