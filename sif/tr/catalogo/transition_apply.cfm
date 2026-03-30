<cfparam name="session.ProcessId" type="numeric">

<!--- chequear si hay que crear una copia de trabajo del WfProcess --->

<cfquery datasource="#session.dsn#" name="check">
	select t.ReadOnly,  p.PublicationStatus, t.Name as TransitionName
	from WfTransition t
		join WfProcess p
			on p.ProcessId = t.ProcessId
	where t.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	  and p.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	  and t.TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TransitionId#">
</cfquery>

<cfif check.ReadOnly>
	<cf_errorCode	code = "50799"
					msg  = "Activitidad ReadOnly: @errorDat_1@"
					errorDat_1="#form.ActivityId#"
	>
</cfif>
<cfif check.PublicationStatus is 'RELEASED'>
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_MSGNoModifTramAprob"
			Default="No se puede modificar un trámite que está aprobado"
			returnvariable="LB_MSGNoModifTramAprob"/>
	<cfthrow message="#LB_MSGNoModifTramAprob#">
<cfelseif check.PublicationStatus is 'RETIRED'>
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_MSGNoModifTramRet"
			Default="No se puede modificar un trámite que está retirado"
			returnvariable="LB_MSGNoModifTramRet"/>

	<cfthrow message="#LB_MSGNoModifTramRet#">
</cfif>

<cfset reloadflash = 1>
<cfif IsDefined('form.delete')>
	<cfquery datasource="#session.dsn#">
		delete from WfTransition
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		  and TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TransitionId#">
	</cfquery>
	<cflocation url="process_detail.cfm?rand=#Rand()#&reloadflash=1">
<cfelse>
	<cfif check.TransitionName is form.Name>
		<cfset reloadflash = 0>
	</cfif>
	<cfquery datasource="#session.dsn#">
		update WfTransition
		set Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
		    Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
			NotifyRequester = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.NotifyRequester')#">,
			NotifyEveryone = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.NotifyEveryone')#">,
			AskForComments = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.AskForComments')#">
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		  and TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TransitionId#">
	</cfquery>
</cfif>
<!---
<cfoutput>reloadflash:#reloadflash#, check.TransitionName:#check.TransitionName#,form.Name:#form.Name#</cfoutput>
<cfdump var="#form#"><cfabort>--->
<cflocation url="transition_detail.cfm?reloadflash=#reloadflash#&TransitionId=#form.TransitionId#">


