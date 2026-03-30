	<cfquery name="C_WfActivity" datasource="#Session.DSN#">
		
			update WfActivity set
				Name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
				Description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
				<cfif isdefined('form.ckNotifyPartBefore')>NotifyPartBefore=1,<cfelse>NotifyPartBefore=0,</cfif>
				NotifySubjBefore=0,
				NotifyReqBefore=0,
				NotifyPartAfter=0,
				<cfif isdefined('form.ckNotifySubjAfter')>NotifySubjAfter=1,<cfelse>NotifySubjAfter=0,</cfif>
				NotifyReqAfter=0
			where ActivityId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
		
	</cfquery>								
			
	<!--- Aqui va el ALTA DE participantes --->
	<cfset newAct = form.ActivityId>
	<cfinclude template="SQLparticipXActiv.cfm"> 
	
	<!--- Bandera para controlar si la actividad se va a mover a una posicion diferente a la actual --->
	<cfset PosIgual = true>
	
	<cfif isdefined('form.cbActiv') and Len(form.cbActiv)>
		<cfset ActividadParaRegresar = form.cbActiv>
	<cfelse>
		<cfset ActividadParaRegresar = -1>
	</cfif>
	<cfif IsDefined("rsPasoRechaz.ActivityId") And Len(rsPasoRechaz.ActivityId)>
		<cfset ActividadParaRechazar = rsPasoRechaz.ActivityId>
	<cfelse>
		<cfset ActividadParaRechazar = -1>
	</cfif>
	<cfquery name="B_WfTrans_RegreRecha" datasource="#Session.DSN#">
										
			<!--- Borrado de todas las transiciones de la actividad, ya sean rechazos o regresos --->
			delete WfTransition 
			where FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
				<cfif isdefined('form.cbActiv') and form.cbActiv NEQ ''>
					and (Name = 'Regresar' and ToActivity != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbActiv#">
					  or Name = 'Rechazar' and ToActivity != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoRechaz.ActivityId#">)
				<cfelse>
					and Name = 'Rechazar' and ToActivity != <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoRechaz.ActivityId#">
				</cfif>
		
	</cfquery>

	<!--- Combo para definir la posicion de la nueva actividad --->
	<cfif isdefined('form.cbPosicion') and form.cbPosicion NEQ "">
		<cfif form.cbPosicion EQ "P">	<!--- Se desea colocar la actividad seleccionada de primero --->
			<cfquery name="rsPrimeraActiv" datasource="#Session.DSN#">
				select convert(varchar,ActivityId) as ActivityId 
				from WfActivity
				where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
					and IsStart = 1
			</cfquery>
			
			<!--- Si voy a colocar de primera actividad a la actividad que esta de primero NO hago nada --->
			<cfif isdefined('rsPrimeraActiv') and rsPrimeraActiv.recordCount EQ 1 and rsPrimeraActiv.ActivityId NEQ form.ActivityId>
				<cfset PosIgual = false>
			</cfif>
		<cfelse>
			<cfif isdefined('form.cbPosicion') and form.cbPosicion NEQ "">
				<cfquery name="rsMovimiento" datasource="#Session.DSN#">
					select convert(varchar,ToActivity) as ToActivity
					from WfTransition 
					where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
						and FromActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbPosicion#">
						and Name in ('Aceptar','Completar')
				</cfquery>
			</cfif>
			
			<!--- Verifica si el lugar en donde voy a mover la actividad seleccionada es diferente a la posicion actual --->
			<cfif isdefined('rsMovimiento') and rsMovimiento.recordCount EQ 1 and rsMovimiento.ToActivity NEQ form.ActivityId>
				<cfset PosIgual = false>
			</cfif>
		</cfif>
	</cfif>				
		
	<!--- Si realmente la actividad se va a mover a un lugar diferente al actual --->
	<cfif PosIgual EQ false>
		<!--- Combo para definir la posicion de la nueva actividad --->
		<cfif isdefined('form.cbPosicion') and form.cbPosicion NEQ "">
			<!--- Primeramente se saca a la actividad seleccionada de la posicion actual en las transiciones --->
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
			
			<cfquery name="B_WfTrans_Acep" datasource="#Session.DSN#">
					
				
				<!--- Borrado de la trancision que se esta trasladando ('Aceptar') a la siguiente Actividad --->
				delete WfTransition 
				where FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
					and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
					and (Name='Aceptar' or Name='Completar')
					
					
			</cfquery>
	
			<cfif isdefined('rsFromActiv') and rsFromActiv.recordCount EQ 1 and isdefined('rsToActiv') and rsToActiv.recordCount EQ 1>
				<cfquery name="C_WfTrans_Reconecta" datasource="#Session.DSN#">
					
								
					<!--- Realiza la reconexion entre las dos actividades que quedaron desconectadas por el traslado --->
					update WfTransition set									
						ToActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsToActiv.getField(rsToActiv.recordCount,1)#">
						<cfif rsToActiv.getField(rsToActiv.recordCount,2) EQ 'Completar'>
							,Name = 'Completar'
							,Description = 'Completar'
						</cfif>
					where TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFromActiv.getField(rsFromActiv.recordCount,1)#">
					
						
				</cfquery>					
			<cfelse>
				<!--- Quiere decir que la actividad que estamos trasladando es la primera --->
				<cfif isdefined('rsFromActiv') and rsFromActiv.recordCount EQ 0 and isdefined('rsToActiv') and rsToActiv.recordCount EQ 1>
					<!--- Si voy trasladar la actividad uno y no hay mas entonces no actualiza la bandera de IsIstart para evitar un error de constraint " CKT_WFACTIVITY " --->
					<cfif rsToActiv.getField(rsToActiv.recordCount,2) NEQ 'Completar'>
						<cfquery name="C_WfTrans_PrimerActiv" datasource="#Session.DSN#">
							
										
							update WfActivity set									
								IsStart = 1
							where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsToActiv.getField(rsToActiv.recordCount,1)#">
								and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">											
								
							update WfActivity set 
								IsStart = 0
							where ActivityId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">								
								and ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">																		
								
								
						</cfquery>								
					</cfif>
				</cfif>
			</cfif>									
			
			<!--- Reconexion de la actividad que estoy moviendo en el nuevo lugar seleccionado por el combo de posicion --->							
			<cfif form.cbPosicion EQ "P">	<!--- Si la nueva posicion es al inicio --->				
				<cfif isdefined('rsPrimeraActiv') and rsPrimeraActiv.recordCount GT 0>
					<cfquery name="AC_WfTrans_ReconexPrimerLugar" datasource="#Session.DSN#">
						
										
						insert WfTransition 
							(ProcessId, FromActivity, ToActivity, Name, Description,Label)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">, 																				
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
						where ActivityId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">								

							
					</cfquery>						
				</cfif>
			<cfelse>	<!--- Si la nueva posicion es en cualquier otro lado del segundo en adelante --->
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
					<cfquery name="AC_WfTrans_ReconexNuevoLugar" datasource="#Session.DSN#">
										
						
						insert WfTransition 
							(ProcessId, FromActivity, ToActivity, Name, Description,Label)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">, 																				
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransDespuesDe.ToActivity#">,  
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">, 										
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransDespuesDe.Name#">)
								
						update WfTransition set 
							ToActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">,											
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
						
							
					</cfquery>						
				</cfif>			
			</cfif>
		</cfif>
	</cfif>
		
	<!--- Se insertan las nuevas transiciones, en este caso si pudiera rechazar --->											
	<cfif isdefined('form.rdAccion') and form.rdAccion EQ "2" and isdefined('rsPasoRechaz') and rsPasoRechaz.recordCount GT 0>
		<cfquery name="A_WfTrans_Rechaza" datasource="#Session.DSN#">
				
			if not exists (
				select * from WfTransition
				where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
				  and FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				  and Name = 'Rechazar'
				  and ToActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoRechaz.ActivityId#">)
			insert WfTransition 
			(ProcessId, FromActivity, ToActivity, Name, Description,Label)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoRechaz.ActivityId#">, 
					'Rechazar', 
					'Rechazar', 
					'Rechazar')
			
				
		</cfquery>					
	
	<!--- En este caso si pudiera regresarse a actividades anteriores --->
	<cfelseif isdefined('form.rdAccion') and form.rdAccion EQ "3" and isdefined('form.cbActiv') and form.cbActiv NEQ"">
		<cfquery name="A_WfTrans_Regresa" datasource="#Session.DSN#">
				
			
			if not exists (
				select * from WfTransition
				where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
				  and FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
				  and Name = 'Regresar'
				  and ToActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbActiv#">)
			insert WfTransition 
			(ProcessId, FromActivity, ToActivity, Name, Description,Label)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbActiv#">, 
					'Regresar', 
					'Regresar', 
					'Regresar')
					
				
		</cfquery>					
	</cfif>																					
	
	<cfset modo="CAMBIO">
	<cfset vProcessId= form.ProcessId>		