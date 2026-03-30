<cfsetting enablecfoutputonly="yes">

<cfparam name="session.ProcessId" type="numeric" default="1">
<cfparam name="url.ProcessId" type="numeric" default="#session.ProcessId#">
<cfparam name="url.x" type="numeric">
<cfparam name="url.y" type="numeric">

<cfquery datasource="#session.dsn#" name="check">
	select PublicationStatus
	from WfProcess
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
</cfquery>

<cfif check.PublicationStatus Is 'RELEASED'>
	<cfoutput>ActivityId=0&msg=#URLEncodedFormat('No se puede modificar un trámite que está aprobado')#</cfoutput>
	<cfabort>
<cfelseif check.PublicationStatus Is 'RETIRED'>
	<cfoutput>ActivityId=0&msg=#URLEncodedFormat('No se puede modificar un trámite que está retirado')#</cfoutput>
	<cfabort>
</cfif>

<cftry>
	<cftransaction>
		<cfset NewName = 'Num '>
		<cfquery datasource="#session.dsn#" name="NameSearch">
			select Name
			from WfActivity
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
			  and Name like '#NewName#%'
		</cfquery>
		<cfset MaxNumber = 0>
		<cfloop query="NameSearch">
			<cfset ThisNumber = Mid(NameSearch.Name, Len(NewName)+1, 5)>
			<cfif IsNumeric(ThisNumber) And (ThisNumber + 0) GT MaxNumber >
				<cfset MaxNumber = ThisNumber>
			</cfif>
		</cfloop>
		<cfset NewName = NewName & ( MaxNumber + 1 ) >
		<cfquery datasource="#session.dsn#" name="newid">
			insert into WfActivity ( ProcessId, Name, Description, SymbolData )
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewName#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewName#">,
			  'x=#url.x#,y=#url.y#' )
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="newid">
	</cftransaction>
	
	<cfoutput>ActivityId=#newid.identity#&Name=#URLEncodedFormat(NewName)#</cfoutput>
<cfcatch type="any">
	<cfoutput>ActivityId=0&msg=#URLEncodedFormat(cfcatch.Message & ":" & cfcatch.Detail)#</cfoutput>
</cfcatch>

</cftry>