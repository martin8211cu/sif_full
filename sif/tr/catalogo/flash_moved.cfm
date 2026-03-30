<cfsetting enablecfoutputonly="yes">
<cfparam name="session.ProcessId" type="numeric" default="1">
<cfparam name="url.ProcessId" type="numeric" default="#session.ProcessId#">
<cfparam name="url.ActivityId" type="numeric">
<cfparam name="url.x" type="numeric">
<cfparam name="url.y" type="numeric">

<cfquery datasource="#session.dsn#" name="check">
	select PublicationStatus
	from WfProcess
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
</cfquery>

<cfif check.PublicationStatus Is 'RELEASED'>
	<cfoutput>error=1&msg=#URLEncodedFormat('No se puede modificar un trámite que está aprobado')#</cfoutput>
	<cfabort>
<cfelseif check.PublicationStatus Is 'RETIRED'>
	<cfoutput>error=1&msg=#URLEncodedFormat('No se puede modificar un trámite que está retirado')#</cfoutput>
	<cfabort>
</cfif>

<cfquery datasource="#session.dsn#">
	update WfActivity
	set SymbolData = 'x=#url.x#,y=#url.y#'
	where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
	  and ProcessId =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
</cfquery>

<cfoutput>error=0</cfoutput>
