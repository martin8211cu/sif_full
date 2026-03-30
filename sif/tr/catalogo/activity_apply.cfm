<cfparam name="session.ProcessId" type="numeric">

<!--- chequear si hay que crear una copia de trabajo del WfProcess --->

<cfquery datasource="#session.dsn#" name="check">
	select a.IsFinish, a.ReadOnly, p.PackageId, a.Name, p.PublicationStatus
	from WfActivity a
		join WfProcess p
			on a.ProcessId = p.ProcessId
	where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	  and p.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	  and a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
</cfquery>

<cfquery datasource="#session.dsn#" name="particip_antes">
	select count(1) as hay
	from WfActivityParticipant a
	where a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
</cfquery>

<cfif check.IsFinish and isdefined("form.btnMails")>
	<cfquery datasource="#session.dsn#">
		update WfActivity
		set NotifyPartAfter	= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifyPartAfter')#">,
			NotifyReqAfter		= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifyReqAfter')#">,
			NotifyAllAfter		= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifyAllAfter')#">,
			NotifySubjAfter		= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifySubjAfter')#">
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		  and ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
	</cfquery>
	<cflocation url="activity_detail.cfm?reloadflash=0&ActivityId=#form.ActivityId#">
</cfif>

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
	
<cfif IsDefined('form.delete')>
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		delete WfTransition
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		  and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#"> in (FromActivity, ToActivity)
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete WfActivityParticipant
		where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete WfActivity
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		  and ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
	</cfquery>
	</cftransaction>
	<cflocation url="process_detail.cfm?rand=#Rand()#&reloadflash=1">
<cfelse>
	<cftransaction>
	<cfquery datasource="#session.dsn#">
		update WfActivity
		set Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
		    Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
		    Documentation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documentation#">,
			NotifyPartAfter	= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifyPartAfter')#">,
			NotifyReqAfter		= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifyReqAfter')#">,
			NotifyAllAfter		= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifyAllAfter')#">,
			NotifySubjAfter		= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.ckNotifySubjAfter')#">
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		  and ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
	</cfquery>
	
	<cfif Len(form.ParticABorrar)>
		<cfquery datasource="#session.dsn#">
			delete from WfActivityParticipant
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
			  and ParticipantId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ParticABorrar#">
		</cfquery>
	</cfif>
		
	<cfparam name="form.PartType" default="">
	<cfif Len(form.PartType)>
		<!--- ver si ya hay registro en WfParticipant --->
		<cfif Len(form.Part_PartId) is 0>
			<cfquery datasource="#session.dsn#" name="wfParticipant">
				select ParticipantId, ParticipantType
				from WfParticipant 
				where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#check.PackageId#">
				  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PartName#">
				  <cfif form.PartType EQ "HUMAN">
				  and ParticipantType in ('HUMAN','ADMIN')
				  <cfelse>
				  and ParticipantType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PartType#">
				  </cfif>
			</cfquery>
			<cfset form.Part_PartId = wfParticipant.ParticipantId>
			<cfif wfParticipant.ParticipantType EQ 'ADMIN'>
				<cfquery datasource="#session.dsn#" name="wfActivityParticipant">
					update WfParticipant 
					   set ParticipantType = 'HUMAN'
					where ParticipantId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Part_PartId#">
				</cfquery>
			</cfif>
		</cfif>
		<cfif Len(form.Part_PartId) is 0>
			<cfquery datasource="#session.dsn#" name="insert_wfparticipant">
				insert into WfParticipant ( PackageId, Name, Description, ParticipantType, rol, Usucodigo, CFid )
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#check.PackageId#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PartName)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PartDescription)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PartType)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Part_rol)#" null="#Len(form.Part_rol) is 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Part_Usucodigo)#" null="#Len(form.Part_Usucodigo) is 0 #">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Part_CFid)#" null="#Len(form.Part_CFid) is 0#">)
				<cf_dbidentity1 datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="insert_wfparticipant">
			<cfquery datasource="#session.dsn#">
				insert into WfActivityParticipant (ActivityId, ProcessId, ParticipantId)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_wfparticipant.identity#">)
			</cfquery>
		<cfelse>
			<!--- ver si ya hay registro en WfActivityParticipant --->
			<cfquery datasource="#session.dsn#" name="wfActivityParticipant">
				select ParticipantId
				from WfActivityParticipant 
				where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				  and ParticipantId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Part_PartId#">
			</cfquery>
			<cfif wfActivityParticipant.RecordCount is 0>
				<cfquery datasource="#Session.DSN#">
					insert into WfActivityParticipant (ActivityId, ProcessId, ParticipantId)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Part_PartId#">)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	</cftransaction>
</cfif>


<cfquery datasource="#session.dsn#" name="particip_despues">
	select count(1) as hay
	from WfActivityParticipant a
	where a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
</cfquery>

<cfif (form.Name neq check.Name) or (Sgn(particip_despues.hay) neq Sgn(particip_antes.hay))>
	<cfset reloadflash = 1>
<cfelse>
	<cfset reloadflash = 0>
</cfif>

<cflocation url="activity_detail.cfm?reloadflash=#reloadflash#&ActivityId=#form.ActivityId#">


