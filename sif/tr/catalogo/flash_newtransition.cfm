<cfsetting enablecfoutputonly="yes">
<cfparam name="session.ProcessId" type="numeric">

<cfparam name="url.ProcessId" type="numeric" default="#session.ProcessId#">
<cfparam name="url.FromActivity" type="numeric">
<cfparam name="url.ToActivity" type="numeric">

<cfquery datasource="#session.dsn#" name="check">
	select PublicationStatus
	from WfProcess
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
</cfquery>

<cfif check.PublicationStatus Is 'RELEASED'>
	<cfoutput>TransitionId=0&msg=#URLEncodedFormat('No se puede modificar un trámite que está aprobado')#</cfoutput>
	<cfabort>
<cfelseif check.PublicationStatus Is 'RETIRED'>
	<cfoutput>TransitionId=0&msg=#URLEncodedFormat('No se puede modificar un trámite que está retirado')#</cfoutput>
	<cfabort>
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select Name
	  from WfActivity
	 where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
	   and ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ToActivity#">
</cfquery>

<cfset new_name = 'Pasar a #url.ToActivity#'>

<cfif findNoCase("ACEPTA",rsSQL.Name)
   OR findNoCase("APROB",rsSQL.Name)
   OR findNoCase("APRUEB",rsSQL.Name)
   OR findNoCase("APLICA",rsSQL.Name)
   OR findNoCase("AUTORI",rsSQL.Name)
   OR findNoCase("RATIFIC",rsSQL.Name)
   OR findNoCase("CONCEN",rsSQL.Name)
   OR findNoCase("POSITIV",rsSQL.Name)
   OR findNoCase("CONFIRM",rsSQL.Name)
   OR rsSQL.Name EQ "OK"
   OR findNoCase("ACCEPT",rsSQL.Name)
   OR findNoCase("APPROV",rsSQL.Name)
   OR findNoCase("AGREE",rsSQL.Name)
   OR findNoCase("PASS",rsSQL.Name)
>
	<cfset new_name = 'Aprobar #url.ToActivity#'>
<cfelseif findNoCase("RECHAZ",rsSQL.Name)
   OR findNoCase("CANCEL",rsSQL.Name)
   OR findNoCase("ANULA",rsSQL.Name)
   OR findNoCase("CLOSE",rsSQL.Name)
   OR findNoCase("STOP",rsSQL.Name)
   OR findNoCase("DISALLOW",rsSQL.Name)
   OR findNoCase("REJECT",rsSQL.Name)
>
	<cfset new_name = 'Rechazar #url.ToActivity#'>
</cfif>

<cftry>
	<cftransaction>
		
		<cfquery datasource="#session.dsn#" name="newid">
			insert into WfTransition (
				ProcessId, FromActivity, ToActivity, Name, Description, Label
			)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FromActivity#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ToActivity#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_name#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_name#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_name#">
			)
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="newid">
	</cftransaction>
	
	<cfoutput>TransitionId=#newid.identity#&Name=#URLEncodedFormat(new_name)#</cfoutput>

<cfcatch type="any">
	<cfoutput>TransitionId=0&msg=#URLEncodedFormat(cfcatch.Message & ":" & cfcatch.Detail)#</cfoutput>
</cfcatch>

</cftry>