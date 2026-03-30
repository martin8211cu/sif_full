<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = ''>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = ''>
</cfif>

<cfset IDtrans = 13>
<cfif isdefined("form.AGTPid")>
	<cfquery name="rsDepManual" datasource="#session.dsn#">
		select coalesce(AGTPmanual,0) as AGTPmanual
		from AGTProceso 
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
	</cfquery>
	<cfset manual = 0>
	<cfif rsDepManual.recordcount gt 0>
		<cfset manual = rsDepManual.AGTPmanual>
	</cfif>
</cfif>

<cfinclude template="agtProceso_listaTransac_PTU#LvarPar#.cfm">