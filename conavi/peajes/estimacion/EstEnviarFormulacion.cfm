<cfif (isdefined('form.COEid') and len(trim(form.COEid)) GT 0) or (isdefined('url.COEid') and len(trim(url.COEid)))>
	<cfset modo = "CAMBIO">
	<cfif not isdefined('form.COEid') or len(trim(form.COEid)) EQ 0>
		<cfset form.COEid = url.COEid>
	</cfif>
</cfif>

<cf_templateheader title="Estimación - Enviar a Presupuesto">
	<cf_web_portlet_start titulo="Estimación a Enviar a Presupuesto">
		
				<cfif (isdefined('form.COEid') and len(trim(form.COEid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.COEid'))>
					<cfinclude  template="EstEnviarFormulacion-form.cfm">
				<cfelseif (isdefined('url.btnConsultar')) OR (isdefined('url.Consultar'))or (isdefined('form.Consultar')) or isdefined ('form.COEPeriodo') and len(trim(form.COEPeriodo))>
					<cfparam name="LvarEstimar" default="TRUE">

					<cfif isdefined ('form.COEPeriodo')>
						<cfparam name="COEPeriodo" default="#form.COEPeriodo#">
					</cfif>
					<cfif isdefined ('form.COEEstado')>
						<cfparam name="COEEstado" default="#form.COEEstado#">
					</cfif>
					<cfparam name="url.LvarEstimar" default="false">
					<cfinclude template="EstIngresosDet.cfm">	
					<cfelseif (isdefined('form.CPPid') and len(trim(form.CPPid)))>	
					<cfparam name="LvarEstimar" default="TRUE">
					<cfinclude template="EstIngresosDet.cfm">	
					<cfelse>
					<cfif isdefined ('form.filtro_Usulogin')>
						<cfparam name="filtro_Usulogin" default="#form.filtro_Usulogin#">
					</cfif>
					<cfif isdefined ('form.filtro_COEPerInicial')>
						<cfparam name="filtro_COEPerInicial" default="#form.filtro_COEPerInicial#">
					</cfif>
					<cfif isdefined ('form.filtros_mes')>
						<cfparam name="filtro_mes" default="#form.filtro_mes#">
					</cfif>
					<cfif isdefined ('form.filtros_mes2')>
						<cfparam name="filtro_mes2" default="#form.filtro_mes2#">
					</cfif>
					<cfif isdefined ('form.filtro_COEPerFinal')>
						<cfparam name="filtro_COEPerFinal" default="#form.filtro_COEPerFinal#">
					</cfif>
					<cfinclude template="EstEnviarFormulacion-lista.cfm">
				</cfif>
				
		<cf_web_portlet_end>
<cf_templatefooter>


