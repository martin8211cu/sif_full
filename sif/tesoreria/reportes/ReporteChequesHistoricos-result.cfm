<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfif url.Bdescripcion_inicio gt url.Bdescripcion_final  >
	<cfset tmp = url.Bdescripcion_inicio >
	<cfset url.Bdescripcion_inicio = url.Bdescripcion_final >
	<cfset url.Bdescripcion_final = tmp >
</cfif>

<cfif not len(trim(url.socioDesde))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select min(SNnumero) as desde
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset url.socioDesde = rsSocio.desde >
</cfif>
<cfif not len(trim(url.socioHasta))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select max(SNnumero) as hasta
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset url.socioHasta = rsSocio.hasta >
</cfif>

<cfif url.socioDesde gt url.socioHasta  >
	<cfset tmp = url.socioDesde >
	<cfset url.socioDesde = url.socioHasta >
	<cfset url.socioHasta = tmp >
</cfif>

<cfset vInicio = LSParsedateTime(url.inicio) >
<cfset vFinal = LSParsedateTime(url.ffinal) >
<cfif vInicio gt vFinal>
	<cfset tmp = vInicio >
	<cfset vInicio = vFinal >
	<cfset vFinal = tmp >
	<cfset tmp = url.inicio >
	<cfset vInicio = url.ffinal >
	<cfset vFinal = tmp >
</cfif>

<cfif isdefined("url.TipoReporte") and url.TipoReporte eq "Resumido">
	<cfinclude template="ReporteChequesHistoricos-resultResumido.cfm">
<cfelse>
	<cfinclude template="ReporteChequesHistoricos-resultDetallado.cfm">
</cfif>