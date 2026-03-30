<cfquery name="A_WfActivity" datasource="#Session.DSN#">
	
		<cfif isdefined('rsActiv') and rsActiv.recordCount EQ 2>	<!--- Primera actividad formal sin contar las de aceptado y rechazado --->
			insert WfActivity (
					ProcessId,
					Name,
					Description, 
					NotifyPartBefore,
					NotifySubjBefore,
					NotifyReqBefore,
					NotifyPartAfter,
					NotifySubjAfter,
					NotifyReqAfter,
					IsStart
				)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ProcessId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
					<cfif isdefined('form.ckNotifyPartBefore')>1,<cfelse>0,</cfif>
					0,
					0,
					0,
					<cfif isdefined('form.ckNotifySubjAfter')>1,<cfelse>0,</cfif>
					0,																																																		
					1
					)
		<cfelseif isdefined('rsActiv') and rsActiv.recordCount GT 2>	<!--- De la segunda actividad en adelante sin contar las de aceptado y rechazado --->
			insert WfActivity (
					ProcessId,
					Name,
					Description,
					NotifyPartBefore,
					NotifySubjBefore,
					NotifyReqBefore,
					NotifyPartAfter,
					NotifySubjAfter,
					NotifyReqAfter
				)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ProcessId#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
					<cfif isdefined('form.ckNotifyPartBefore')>1,<cfelse>0,</cfif>
					0,
					0,
					0,
					<cfif isdefined('form.ckNotifySubjAfter')>1,<cfelse>0,</cfif>
					0										
					)
		</cfif>
				
		select @@identity as newActividad
		
	
</cfquery>

<cfif isdefined('A_WfActivity') and A_WfActivity.recordCount GT 0>
	<cfset newAct = A_WfActivity.newActividad>

	<cfquery name="A_WfTransition" datasource="#Session.DSN#">
							
			<!--- Aqui solo existen las actividades de Completado y Rechazado --->
			<cfif isdefined('rsActiv') and rsActiv.recordCount EQ 2 and isdefined('rsPasoComplet') and rsPasoComplet.recordCount GT 0>	
				insert WfTransition (
					ProcessId, FromActivity, ToActivity, Name, Description,Label)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoComplet.ActivityId#">, 
						'Completar', 
						'Completar', 
						'Completar')
						
				<!--- Puede rechazar --->											
				<cfif isdefined('form.rdAccion') and form.rdAccion EQ "2" and isdefined('rsPasoRechaz') and rsPasoRechaz.recordCount GT 0>
					insert WfTransition (
						ProcessId, FromActivity, ToActivity, Name, Description,Label)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoRechaz.ActivityId#">, 
							'Rechazar', 
							'Rechazar', 
							'Rechazar')
							
				<!--- Puede regresar a actividades anteriores --->																					
				<cfelseif isdefined('form.rdAccion') and form.rdAccion EQ "3" and isdefined('form.cbActiv') and form.cbActiv NEQ "">
					insert WfTransition (
						ProcessId, FromActivity, ToActivity, Name, Description,Label)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbActiv#">, 
							'Regresar', 
							'Regresar', 
							'Regresar')																																			
				</cfif>	
				
			<!--- Todas las siguientes actividades, de la tercera en adelante --->										
			<cfelseif isdefined('rsActiv') and rsActiv.recordCount GT 2>
				<!--- Combo para definir la posicion de la nueva actividad --->
				<cfif isdefined('form.cbPosicion') and form.cbPosicion NEQ "">
					<cfif form.cbPosicion EQ "P">	<!--- La inserta de primero --->
						<cfquery name="rsPrimeraActiv" datasource="#Session.DSN#">
							select convert(varchar,ActivityId) as ActivityId 
							from WfActivity
							where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
								and IsStart = 1
						</cfquery>						
						
						<cfif isdefined('rsPrimeraActiv') and rsPrimeraActiv.recordCount GT 0>
							insert WfTransition (
								ProcessId, FromActivity, ToActivity, Name, Description,Label)
							values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 																				
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPrimeraActiv.ActivityId#">,  
									'Aceptar', 
									'Aceptar', 
									'Aceptar')
									
							<!--- Actualizar la ex-primera actividad con IsStart = 0 --->
							update WfActivity set 
								IsStart = 0
							where ActivityId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPrimeraActiv.ActivityId#">
							
							<!--- y colocar la nueva actividad como la inicial IsStart = 1 --->
							update WfActivity set 
								IsStart = 1
							where ActivityId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">								
						</cfif>
					<cfelse>
						<!--- La inserta en la opcion seleccionada del combo, "Despues de 'actividad X' " --->
						<cfquery name="rsTransDespuesDe" datasource="#Session.DSN#">
							select convert(varchar,TransitionId) as TransitionId,convert(varchar,FromActivity) as FromActivity, convert(varchar,ToActivity) as ToActivity, Name
							from WfTransition 
							where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
								and FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbPosicion#">
								and Name in ('Aceptar','Completar')
							order by FromActivity							
						</cfquery>	
												
						<cfif isdefined('rsTransDespuesDe') and rsTransDespuesDe.recordCount GT 0>
							insert WfTransition 
								(ProcessId, FromActivity, ToActivity, Name, Description,Label)
							values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 																				
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransDespuesDe.ToActivity#">,  
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">, 										
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">)
									
							update WfTransition set 
								ToActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">,											
								<cfif rsTransDespuesDe.Name NEQ 'Completar'>
									Name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">,
									Description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">,
									Label=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">
								<cfelse>
									Name='Aceptar',
									Description='Aceptar',
									Label='Aceptar'
								</cfif>
							where TransitionId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransDespuesDe.TransitionId#">						
						</cfif>
					</cfif>
				</cfif>
				
				<!--- Puede rechazar --->
				<cfif isdefined('form.rdAccion') and form.rdAccion EQ "2" and isdefined('rsPasoRechaz') and rsPasoRechaz.recordCount GT 0>	
					insert WfTransition 
					(ProcessId, FromActivity, ToActivity, Name, Description,Label)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoRechaz.ActivityId#">, 
							'Rechazar', 
							'Rechazar', 
							'Rechazar')
																	
				<!--- Puede regresar a actividades anteriores --->
				<cfelseif isdefined('form.rdAccion') and form.rdAccion EQ "3" and isdefined('form.cbActiv') and form.cbActiv NEQ "">
					insert WfTransition 
					(ProcessId, FromActivity, ToActivity, Name, Description,Label)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#newAct#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbActiv#">, 
							'Regresar', 
							'Regresar', 
							'Regresar')									
				</cfif>									
			</cfif>

			<cfset modo="ALTA">
			<cfset vProcessId= form.ProcessId>							
		
	</cfquery>
	
	<!--- Aqui va el ALTA DE participantes --->															
	<cfinclude template="SQLparticipXActiv.cfm"> 
</cfif>	
