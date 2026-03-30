<cfparam name="form.nuevoUsucodigo" default="">
<cfif Len(form.nuevoUsucodigo)>
	<!--- ver si ya hay registro en WfParticipant --->
	<cfquery datasource="#session.dsn#" name="wfParticipant">
		select ParticipantId
		from WfParticipant 
		where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaqueteID.PackageId#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.nuevoUsucodigo#">
	</cfquery>
	<cfif Len(wfParticipant.ParticipantId) is 0>
		<cfquery datasource="#session.dsn#" name="wfParticipant">
			insert into WfParticipant ( PackageId, Name, Description, Usucodigo, ParticipantType)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaqueteID.PackageId#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nuevoNombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nuevoNombre#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.nuevoUsucodigo#">, 'HUMAN')
			insert WfActivityParticipant (ActivityId, ParticipantId)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, @@identity)
		</cfquery>
	<cfelse>
		<!--- ver si ya hay registro en WfActivityParticipant --->
		<cfquery datasource="#session.dsn#" name="wfActivityParticipant">
			select ParticipantId
			from WfActivityParticipant 
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">
			  and ParticipantId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#wfParticipant.ParticipantId#">
		</cfquery>
		<cfif wfActivityParticipant.RecordCount is 0>
			<cfquery name="A_WfActivityParticipant" datasource="#Session.DSN#">
				insert WfActivityParticipant (ActivityId, ParticipantId)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#wfParticipant.ParticipantId#">)
			</cfquery>
		</cfif>
	</cfif>
</cfif>
