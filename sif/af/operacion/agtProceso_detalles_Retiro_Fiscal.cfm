<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = ''>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = ''>
</cfif>

<cfset IDtrans = 14>
<cfif isdefined("form.AGTPid")>
	<cfquery name="rsDepManual" datasource="#session.dsn#">
		select coalesce(AGTPmanual,0) as AGTPmanual
		from AGTProceso 
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and IDtrans IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">)
	</cfquery>
	<cfset manual = 0>
	<cfif rsDepManual.recordcount gt 0>
		<cfset manual = rsDepManual.AGTPmanual>
	</cfif>
</cfif>
<cfif isdefined("manual") and manual eq 1>
	<!--- Muestra el detalle de la transaccion manual --->
	<cfset params = "AGTPid=#form.AGTPid#">
	<cflocation url="agtProceso_genera_DepManual#LvarPar#.cfm?#params#" addtoken="no">
<cfelseif isdefined("manual") and manual eq 2>
	<!--- Muestra el detalle de la depreciacion por Actividad --->
	<cfset params = "AGTPid=#form.AGTPid#">
	<cflocation url="agtProceso_genera_DepPorActidad#LvarPar#.cfm?#params#" addtoken="no">
<cfelse>
	<cfinclude template="agtProceso_listaTransac_Retiro_Fiscal#LvarPar#.cfm">
</cfif>
