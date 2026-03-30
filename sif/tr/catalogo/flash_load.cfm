<cfsetting enablecfoutputonly="yes">

<cfparam name="session.ProcessId" type="numeric" default="1">
<cfparam name="url.ProcessId" type="numeric" default="#session.ProcessId#">

<!---
<cfquery datasource="asp">
	waitfor delay '0:0:6'
</cfquery>
--->
<cfquery datasource="#session.dsn#" name="process">
	select PublicationStatus
	from WfProcess a
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
</cfquery>
<cfquery datasource="#session.dsn#" name="activity">
	select ActivityId, Name, SymbolData, ReadOnly,
		case when (select count(1) from WfActivityParticipant ap where ap.ActivityId = a.ActivityId) = 0 then 0 else 1 end
		as Participantes, case when IsStart =1 then 1 else 0 end as IsStart, case when IsFinish = 1 then 1 else 0 end as IsFinish
	from WfActivity a
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
	order by Ordering
</cfquery>
<cfquery datasource="#session.dsn#" name="transition">
	select TransitionId, FromActivity, ToActivity, Name
	from WfTransition
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
	order by FromActivity, ToActivity
</cfquery>
<cfset activ_x = ''><cfset activ_y = ''><cfset activ_readonly = ''>
<cfloop query="activity">
	<cfset data = activity.SymbolData>
	<cfset data_items = ListToArray(data,',')>
	<cfset data_set = StructNew()>
	<cfset data_set.x = -1>
	<cfset data_set.y = -1>
	<cfloop from="1" to="#ArrayLen(data_items)#" index="i">
		<cfset datum_name = ListGetAt(data_items[i], 1, '=')>
		<cfset datum_value = ListGetAt(data_items[i], 2, '=')>
		<cfset StructUpdate(data_set, datum_name, datum_value)>
	</cfloop>
	<cfset activ_x = ListAppend (activ_x, data_set.x)>
	<cfset activ_y = ListAppend (activ_y, data_set.y)>
	<cfset activ_readonly = ListAppend (activ_readonly, IIf(activity.ReadOnly, '1','0'))>
</cfloop>

<cfoutput>PublicationStatus=#URLEncodedFormat(process.PublicationStatus)
	#&activ_id=#URLEncodedFormat(ValueList(activity.ActivityId))
	#&activ_name=#URLEncodedFormat(ValueList(activity.Name))
	#&activ_x=#URLEncodedFormat(activ_x)
	#&activ_y=#URLEncodedFormat(activ_y)
	#&activ_readonly=#URLEncodedFormat(activ_readonly)
	#&activ_particip=#URLEncodedFormat(ValueList(activity.Participantes))
	#&activ_start=#URLEncodedFormat(ValueList(activity.IsStart))
	#&activ_finish=#URLEncodedFormat(ValueList(activity.IsFinish))
	#&trans_from=#URLEncodedFormat(ValueList(transition.FromActivity))
	#&trans_to=#URLEncodedFormat(ValueList(transition.ToActivity))
	#&trans_id=#URLEncodedFormat(ValueList(transition.TransitionId))
	#&trans_name=#URLEncodedFormat(ValueList(transition.Name))
	#</cfoutput>
