<cfcomponent>
<!---
	DESCRIPCION
	  Este componente tiene la implementación del Workflow Engine para los trámites de Recursos Humanos.
	  Ningún método de aquí se debe invocar directamente, sino que deben realizarse a través
	  del componenete "Operations.cfc" en este mismo directorio

	LIMITACIONES
	  Se pasó solamente lo que se utiliza en RH, lo demás se va pasando conforme se requiera.
	  Esto significa las siguientes restricciones:
		- WfApplication.Type: implementado 'PROCEDURE', faltan 'WEBSERVICE','APPLICATION','SUBFLOW'
		- WfParticipant.ParticipantType: implementado HUMAN como un login (Usucodigo),
		  faltan GROUP, ROLE, ORGUNIT y posiblemente una manera de discriminar el tipo de HUMAN (Usucodigo,DEid,etc)
		- No envía emails a los empleados, solamente al responsable y al que inició el trámite
		- Transiciones automáticas (autoTransition), todavía no se ha necesitado por no haber
		  stored procedures intermedios (no al final del proceso), o tareas que solamente envíen el email.
		- Los responsables de una actividad están fijados al momento de iniciar el WfxProcess (Trámite)
		- Solamente maneja Data Items de tipo String, no maneja text,image,integer,date/time
		- Los emails que envía están diseñados (contenido) para Acciones de RH
--->


	<!--- Esta funcion puede recibir el ProcessInstanceId en nulo para procesar todos,
	      para este caso en lugar de null se manda un -1. Esto porque no se que pasa cuando no se manda
		  el argumento por ejemplo, si asume null o que
	--->
	<cffunction name="autoStart" access="package" returntype="numeric" output="true" >
		<cfargument name="ProcessInstanceId" type="numeric" required="no">

		<cfquery name="AutoStartActivities" datasource="#session.DSN#">
			select a.ActivityInstanceId, a.ActivityId, a.ProcessInstanceId, a.State,
				a.StartTime, a.FinishTime, a.WaitingTime, a.WorkingTime, a.UpdateTime
			from WfxActivity a
				join WfActivity b
					on a.ActivityId = b.ActivityId
			where a.State = 'INACTIVE'
			  and b.StartMode = 'AUTOMATIC'
			  <cfif Arguments.ProcessInstanceId>
			  and a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ProcessInstanceId#">
			  </cfif>
		</cfquery>

		<cfloop query="AutoStartActivities">
			<cfinvoke component="ActivityMgmt" method="setActivityState">
				<cfinvokeargument name="ActivityInstanceId" value="#AutoStartActivities.ActivityInstanceId#"/>
				<cfinvokeargument name="State" value="ACTIVE"/>
			</cfinvoke>
		</cfloop>

		<cfset return_value = AutoStartActivities.RecordCount >

		<cfreturn return_value>
	</cffunction>

	<!--- Realiza las invocaciones a SP / CFC requeridas (WfInvocation->WfxInvocation)
		  Esta funcion puede recibir el ProcessInstanceId en nulo para procesar todos,
	      para este caso en lugar de null se manda un -1. Esto porque no se que pasa cuando no se manda
		  el argumento por ejemplo, si asume null o que
		  --->
	<cffunction name="autoExec" access="package" returntype="numeric" output="true" >
		<cfargument name="ProcessInstanceId" type="numeric" required="no">

		<cfquery name="autoExecQuery" datasource="#session.DSN#">
			select  xa.ProcessInstanceId, xa.ActivityInstanceId, i.ApplicationName, xa.ProcessInstanceId
			from WfxActivity xa
				join WfActivity a
					on a.ActivityId = xa.ActivityId
				join WfInvocation i
					on i.ActivityId = xa.ActivityId
			where not exists ( select * from WfxInvocation m
							   where m.ActivityInstanceId = xa.ActivityInstanceId
								 and m.ApplicationName = i.ApplicationName
								 and m.FinishTime is not null )
			  <cfif Arguments.ProcessInstanceId>
			  and xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ProcessInstanceId#">
			  </cfif>
		</cfquery>

		<cfset return_value = -1 >
		<cfloop query="autoExecQuery">
			<cfinvoke component="InvocationMgmt" method="wfinvoke">
				<cfinvokeargument name="ProcessInstanceId" value="#autoExecQuery.ProcessInstanceId#">
				<cfinvokeargument name="ActivityInstanceId" value="#autoExecQuery.ActivityInstanceId#">
				<cfinvokeargument name="ApplicationName" value="#autoExecQuery.ApplicationName#">
			</cfinvoke>
		</cfloop>

		<cfreturn autoExecQuery.RecordCount>
	</cffunction>

	<cffunction name="autoComplete" access="package" returntype="numeric" output="true" >
		<cfargument name="ProcessInstanceId" type="numeric" required="yes" >

		<cfquery name="AutoCompleteActivities" datasource="#session.DSN#">
			select ActivityInstanceId, a.ActivityId, ProcessInstanceId, State, StartTime, FinishTime, WaitingTime, WorkingTime, UpdateTime
			from WfxActivity a
				join WfActivity b
					on a.ActivityId = b.ActivityId
			where State = 'ACTIVE'
			  and FinishMode = 'AUTOMATIC'
			  <cfif Arguments.ProcessInstanceId>
			  and a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ProcessInstanceId#">
			  </cfif>
			  <!--- verificar si tiene aplicaciones pendientes de ejecutar --->
			  and not exists ( select *
			  				   from WfInvocation i
							   where i.ActivityId = b.ActivityId
							     and not exists ( select *
								 				  from WfxInvocation xi
												  where xi.ApplicationName = i.ApplicationName
													and xi.ActivityInstanceId = a.ActivityInstanceId
													and xi.FinishTime is not null
												)
							 )
		</cfquery>

		<!--- <cfdump var="#AutoCompleteActivities#" label="AutoCompleteActivities"> --->
		<cfloop query="AutoCompleteActivities">
			<cfinvoke component="ActivityMgmt" method="setActivityState">
				<cfinvokeargument name="ActivityInstanceId" value="#AutoCompleteActivities.ActivityInstanceId#"/>
				<cfinvokeargument name="State" value="COMPLETED"/>
			</cfinvoke>
		</cfloop>

		<cfreturn AutoCompleteActivities.RecordCount >
	</cffunction>

	<cffunction name="autoTransition" access="package" returntype="numeric" output="false" >
		<cfargument name="ProcessInstanceId" type="numeric" required="yes" >
		<!---
			Realiza las transiciones marcadas como 'MANUAL'
			que no tengan participantes en su actividad de origen
			Las 'CONDITION' y 'OTHERWISE' se ignoran por ahora
		 --->
		<cfquery datasource="#session.dsn#" name="AutoTransition">
			select xa.ActivityInstanceId, t.TransitionId
			from WfxActivity xa
				join WfActivity a
					on xa.ActivityId = a.ActivityId
				join WfTransition t
					on t.FromActivity = a.ActivityId
			where xa.State = 'COMPLETED'
			  and not exists (select 1 from WfxTransition xt1 where xt1.FromActivityInstance = xa.ActivityInstanceId)
			  and a.IsFinish = 0
			  and not exists (select 1 from WfActivityParticipant ap where ap.ActivityId = a.ActivityId)
			  and not exists (select 1 from WfxActivityParticipant xap where xap.ActivityInstanceId = xa.ActivityInstanceId)
			  and t.Type = 'MANUAL'
			  <cfif Arguments.ProcessInstanceId>
			  and xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ProcessInstanceId#">
			  </cfif>
		</cfquery>
		<cfloop query="AutoTransition">
			<cfinvoke component="TransitionMgmt" method="doTransition">
				<cfinvokeargument name="FromActivity" value="#AutoTransition.ActivityInstanceId#"/>
				<cfinvokeargument name="TransitionId" value="#AutoTransition.TransitionId#"/>
			</cfinvoke>
		</cfloop>

		<cfreturn AutoTransition.RecordCount >
	</cffunction>

	<cffunction name="forward" access="package" returntype="numeric" output="true" >
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">
		<cfset total = 0 >
		<cfloop from="1" index="restriccion" to="10">
			<cfoutput>ciclo forward para ProcessInstanceId #Arguments.ProcessInstanceId#: #restriccion#<br></cfoutput>
			<cfset current = 0>
			<cfset current = current + This.autoStart(arguments.ProcessInstanceId)>
			<cfset current = current + This.autoExec(arguments.ProcessInstanceId)>
			<cfset current = current + This.autoComplete(arguments.ProcessInstanceId)>
			<cfset current = current + This.autoTransition(arguments.ProcessInstanceId)>
			<cfif current eq 0>
				<cfbreak>
			</cfif>
			<cfset total = total + current>
		</cfloop>
		<cfreturn total>
	</cffunction>

</cfcomponent>