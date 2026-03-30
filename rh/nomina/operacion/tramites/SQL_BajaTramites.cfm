	<cfquery name="B_WfTransition" datasource="#Session.DSN#">
		
			<!--- Borrado de todas las trancisiones de la actividad, ya sean rechazos o regresos --->
			delete WfTransition 
			where FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
				and (Name = 'Regresar' or Name='Rechazar')						
				
			<!--- Borra todas las trancisiones que regresen al paso que actualmente se esta borrando --->
			delete WfTransition 
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
				and ToActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				and Name='Regresar'

			<cfquery name="rsFromActiv" datasource="#Session.DSN#">
				select convert(varchar,TransitionId) as TransitionId
				from WfTransition 
				where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
					and ToActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
					and Name='Aceptar'
			</cfquery>
			
			<cfquery name="rsToActiv" datasource="#Session.DSN#">
				select convert(varchar,ToActivity) as ToActivity,Name
				from WfTransition 
				where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
					and FromActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
					and (Name='Aceptar' or Name='Completar')
			</cfquery>

			<cfif isdefined('rsFromActiv') and rsFromActiv.recordCount EQ 1 and isdefined('rsToActiv') and rsToActiv.recordCount EQ 1>
				<!--- Realiza la reconexion entre las dos actividades que quedaron desconectadas por el borrado --->
				update WfTransition set									
					ToActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsToActiv.getField(rsToActiv.recordCount,1)#">
					<cfif rsToActiv.getField(rsToActiv.recordCount,2) EQ 'Completar'>
						,Name = 'Completar'
						,Description = 'Completar'
					</cfif>
				where TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFromActiv.getField(rsFromActiv.recordCount,1)#">
			<cfelse>
				<!--- Quiere decir que la actividad que estamos borrando es la primera --->
				<cfif isdefined('rsFromActiv') and rsFromActiv.recordCount EQ 0 and isdefined('rsToActiv') and rsToActiv.recordCount EQ 1>
					<!--- Si voy aborrar la actividad uno y no hay mas entonces no actualiza la bandera de IsIstart para evitar un error de constraint " CKT_WFACTIVITY " --->
					<cfif rsToActiv.getField(rsToActiv.recordCount,2) NEQ 'Completar'>
						update WfActivity set									
							IsStart = 1
						where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsToActiv.getField(rsToActiv.recordCount,1)#">
							and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">											
					</cfif>
				</cfif>
			</cfif>

			<!--- Completado del borrado de la actividad --->							
			delete WfTransition
			where FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
				
			delete WfActivity
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">							
				 
		
	</cfquery>
