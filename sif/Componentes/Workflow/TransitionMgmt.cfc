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


	<cffunction name="doTransition" access="package" returntype="numeric" output="true" >
		<cfargument name="fromActivity" type="numeric" required="yes">
		<cfargument name="transitionId" type="numeric" required="yes">
		<cfargument name="TransitionComments" type="string" default="" required="yes">

		<cfset return_value = -1 >
		
		<cfquery name="rs" datasource="#session.DSN#">
			select ProcessInstanceId, State, ActivityId
			from WfxActivity 
			where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.fromActivity#">
		</cfquery>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_MSGActCompletada1"
		Default="La actividad"
		returnvariable="LB_MSGActCompletada1"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_MSGActCompletada2"
		Default="no ha sido completada"
		returnvariable="LB_MSGActCompletada2"/>

		<cfif not ( len(trim(rs.State)) gt 0 and trim(rs.State) eq "COMPLETED" )>
			<cf_errorCode	code = "51407"
							msg  = "@errorDat_1@ @errorDat_2@-@errorDat_3@ @errorDat_4@"
							errorDat_1="#LB_MSGActCompletada1#"
							errorDat_2="#rs.ProcessInstanceId#"
							errorDat_3="#Arguments.FromActivity#"
							errorDat_4="#LB_MSGActCompletada2#"
			>
		</cfif>
		
		<cfquery name="transition_info" datasource="#session.DSN#">
			select b.ToActivity, a.ProcessInstanceId, b.NotifyEveryone, b.NotifyRequester, b.ProcessId, b.Name,c.Name as ActivityName,
			d.Description as ProcessInstanceDescription,coalesce (e.Description, e.Name) as ProcessDescription,
			coalesce(c2.IsFinish, 0) as IsFinish
			from WfTransition b 
				inner join WfxActivity a 	on a.ActivityId = b.FromActivity
				left  join WfActivity c2	on c2.ActivityId = b.ToActivity
				inner join WfActivity c		on c.ActivityId = a.ActivityId
				inner join WfxProcess d		on d.ProcessInstanceId = a.ProcessInstanceId
				inner join WfProcess e		on e.ProcessId = d.ProcessId
			where a.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#">
			  and b.TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.transitionId#"> 
		</cfquery>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_LaActividad"
		Default="La actividad"
		returnvariable="MSG_LaActividad"/>
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DelTramiteNumero"
		Default="del trámite número"
		returnvariable="MSG_DelTramiteNumero"/>		
		
		<cfset info = MSG_LaActividad & " " & transition_info.ActivityName & " " & MSG_DelTramiteNumero & " " &
		transition_info.ProcessInstanceId & ", " &
		transition_info.ProcessDescription & " " &
		transition_info.ProcessInstanceDescription>		

		<cfif transition_info.RecordCount Is 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_MSGTransicion"
			Default="La transicion "
			returnvariable="LB_MSGTransicion"/>
	
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_MSGNoAplica"
			Default="no aplica para"
			returnvariable="LB_MSGNoAplica"/>

			<cf_errorCode	code = "51408"
							msg  = "@errorDat_1@ TransitionId=@errorDat_2@ @errorDat_3@ ActivityInstanceId=@errorDat_4@"
							errorDat_1="#LB_MSGTransicion#"
							errorDat_2="#Arguments.TransitionId#"
							errorDat_3="#LB_MSGNoAplica#"
							errorDat_4="#Arguments.fromActivity#"
			>
		</cfif>
		
		<cfquery name="existing_transition" datasource="#session.dsn#">
			select 1 as X
			from WfxTransition
			where FromActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#">
			  and TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.transitionId#">
		</cfquery>
		<cfif existing_transition.RecordCount>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_MSGNoAplicaDosVeces"
			Default="No se puede ejecutar dos veces la misma transición desde la misma instancia de actividad"
			returnvariable="LB_MSGNoAplicaDosVeces"/>

			<cfthrow message="#LB_MSGNoAplicaDosVeces#">
		</cfif>
		
		<cfinvoke component="ActivityMgmt" method="insertActivity" returnvariable="toActivityInstance"
			ProcessInstanceId="#transition_info.ProcessInstanceId#"
			ActivityId="#transition_info.ToActivity#"
			ProcessId="#transition_info.ProcessId#">
		</cfinvoke>
		<!--- esto se hace antes de meter los participantes, de modo que en ese momento ya se conozca cual fue el paso anterior --->
		<cfquery name="rs_INSERTWfxTransition" datasource="#session.dsn#">
			select TransitionId as TransitionId , 
					a.ActivityInstanceId as ActivityInstanceId, 
					#toActivityInstance# as toActivityInstance, 
					a.ProcessInstanceId as ProcessInstanceId
	       from WfxActivity a, WfTransition b
	       where a.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#">
	          and b.TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#transitionId#"> 
		</cfquery>
		
		
		<cfif rs_INSERTWfxTransition.recordcount gt 0>
			<cfquery name="rsInsertWfxTransition" datasource="#session.DSN#">
				insert INTO WfxTransition
				(
					TransitionId, 
					FromActivityInstance, 
					ToActivityInstance, 
					ProcessInstanceId, 
					TransitionComments
				)
				values
				(
					#rs_INSERTWfxTransition.TransitionId#,
					#rs_INSERTWfxTransition.ActivityInstanceId#,
					#rs_INSERTWfxTransition.toActivityInstance#,
					#rs_INSERTWfxTransition.ProcessInstanceId#,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.TransitionComments#" null="#Len(Arguments.TransitionComments) Is 0#">
				)
				<cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="rsInsertWfxTransition">
		</cfif>
		<cfinvoke component="ActivityMgmt" method="insertActivityParticipants">
			<cfinvokeargument name="ActivityInstanceId" value="#toActivityInstance#">
		</cfinvoke>
		
		<cf_dbfunction name="op_concat" returnvariable="_Cat" datasource="#session.dsn#">
		<cfif IsDefined('session.Usucodigo')>
			<!--- Si no es el primer paso y el usuario no es participante se incluye como participante para dejar registro --->
			<cfquery datasource="#session.dsn#" name="actividad_anterior">
				select count(1) as cantidad
				  from WfxTransition xt
				where xt.ToActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#" >
			</cfquery>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				select count(1) as cantidad
				  from WfxActivityParticipant
				where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#" >
				  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			</cfquery>

			<cfif actividad_anterior.cantidad GT 0 AND rsSQL.cantidad EQ 0>
				<cfquery datasource="#session.dsn#" name="rsSQL">
					select dp.Pid,
						ltrim(rtrim(dp.Pnombre)) #_CAT# ' ' #_CAT# rtrim(dp.Papellido1) #_CAT# ' ' #_CAT# rtrim(dp.Papellido2) as nombre
					from Usuario u
						join DatosPersonales dp
							on dp.datos_personales = u.datos_personales
					where u.Usucodigo = #session.usucodigo#
				</cfquery>
				<cfquery datasource="#session.dsn#" name="insert_participant">
					select d.PackageId
					  from WfxProcess c
						join WfProcess d
							on d.ProcessId = c.ProcessId
					 where c.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_INSERTWfxTransition.ProcessInstanceId#">
				</cfquery>
				<cfset LvarPackageId = insert_participant.PackageId>
				<cfquery datasource="#session.dsn#" name="insert_participant">
					select ParticipantId
					  from WfParticipant
					 where PackageId = #insert_participant.PackageId#
					   and Name = '#trim(rsSQL.Pid)#'  <!--- 2012-04-13. Se le hace un Trim al Pid, porque en algunos casos la identificación almacena en BD caracteres especiales --->
				</cfquery>
				<cfset LvarParticipantId = insert_participant.ParticipantId>
				<cfif LvarParticipantId EQ "">
					<cfquery datasource="#session.dsn#" name="insert_participant">
						insert into WfParticipant (PackageId, Name, Description, ParticipantType, Usucodigo)
						values (#LvarPackageId#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSQL.Pid)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSQL.Nombre)#">,
								'ADMIN',
								#session.Usucodigo#
						)
						<cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
					</cfquery>
					<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="insert_participant">
					<cfset LvarParticipantId = insert_participant.identity>
				</cfif>                                                              
	
				<cfquery datasource="#session.dsn#" name="insert_participant">
					insert INTO WfxActivityParticipant
					  (ParticipantId, ActivityInstanceId, Usucodigo, Name, Description, HasTransition)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarParticipantId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Pid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Nombre#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">
					)
				</cfquery>
			<cfelse>		
				<cfquery datasource="#session.dsn#">
					update WfxActivityParticipant
					set HasTransition = 1
					where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.fromActivity#" >
					  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				</cfquery>
			</cfif>
		</cfif>		
		
		<cfif transition_info.NotifyEveryone or transition_info.NotifyRequester>
			<!---  mailear  si esto ocurre a todos los participantes anteriores, incluyendo al propio maje --->
			<cfif transition_info.NotifyEveryone>
				<cfquery datasource="#session.dsn#" name="participantes_usucodigo">
					select distinct xap.Usucodigo
					from WfxActivityParticipant xap
						join WfxActivity xa
							on xa.ActivityInstanceId = xap.ActivityInstanceId
					where xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#transition_info.ProcessInstanceId#">
				</cfquery>
			</cfif>
			<cfquery datasource="#session.dsn#" name="get_requester">
				<!---
					se ejecuta independientemente de si transition_info.NotifyRequester,
					ya que get_requester.SubjectId se ocupa cuando transition_info.NotifyEveryone
					- danim, 22/03/2005
				--->
				select RequesterId, SubjectId
				from WfxProcess
				where ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#transition_info.ProcessInstanceId#">
			</cfquery>
            
			<cfquery datasource="#session.dsn#" name="participantes">
				select distinct u.Usucodigo,
					dp.Pnombre #_CAT# ' ' #_CAT# dp.Papellido1 #_CAT# ' ' #_CAT# dp.Papellido2 as Description,
					dp.Pemail1, dp.Pcelular
				from Usuario u
					join DatosPersonales dp
						on dp.datos_personales = u.datos_personales
				where u.Usucodigo in (	<cfif transition_info.NotifyEveryone and participantes_usucodigo.RecordCount >
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(participantes_usucodigo.Usucodigo)#" list="yes">,
											<cfif Len(get_requester.SubjectId)>
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#get_requester.SubjectId#">,
											</cfif>
										</cfif>
										<cfif transition_info.NotifyRequester And Len(get_requester.RequesterId)>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#get_requester.RequesterId#">,
										</cfif>
										0 )
			</cfquery>

			<cfloop query="participantes">
				<!--- enviar correo a participantes.Usucodigo y tambien a session.Usucodigo --->
				<cfset destinatario = '"' & participantes.Description & '" <' & participantes.Pemail1 & '>'>

				<cfset vsAccion = ''>
				<cfif transition_info.Name EQ 'ACEPTAR'>
					<cfset vsAccion = 'Autorizado'>				
				<cfelseif transition_info.Name EQ 'RECHAZAR'>
					<cfset vsAccion = 'Rechazado'>
				<cfelse>
					<cfset vsAccion = #transition_info.Name#>
				</cfif>

				<cfset asunto = 'Trámite #vsAccion#'>
				
				<!--- <cfset asunto = info> --->
				<cfset asunto_sms = 'Trámite #vsAccion#'>
				
				<cfsavecontent variable="_mail_body">
					
					<cfset args = StructNew()>
					<cfset args.datos_personales = participantes.Description>
					<cfoutput>
						<cfset args.info = '#info# fue #vsAccion# por #session.usuario#.'>
					</cfoutput> 
					<cfset args.isLink = false>
					<cfset args.isFinish = transition_info.IsFinish>
					<cfparam name = "session.sitio.host">
					<cfset args.hostname = session.sitio.host>
					<cfset args.Usucodigo = session.Usucodigo>
					<cfset args.CEcodigo = session.CEcodigo>
					<cfset request.MailArguments = args>
					<cfset args.Transition = true>
					<cfinclude template="/sif/Componentes/Workflow/mail-notifica.cfm">
				</cfsavecontent>
				
				<!--- <cfset _mail_body = 'El trámite número {#transition_info.ProcessInstanceId#} fue <cfoutput>#vsAccion#</cfoutput> por {{#session.usuario#}}.'> --->
				<cfquery datasource="#session.dsn#">
					insert INTO SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values ('gestion@soin.co.cr',
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#destinatario#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#asunto#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
				</cfquery>
				<!---
				<cfif len(trim(participantes.Pcelular))>
					<cfquery datasource="#session.dsn#" >
						insert into SMS ( SScodigo, SMcodigo, asunto, para, texto, fecha_creado, BMfecha, BMUsucodigo )
						values ( 'sys', 
								 'home',
								 <cfqueryparam cfsqltype="cf_sql_varchar"   value="sms: #asunto_sms#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#participantes.Pcelular#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#_mail_body#">,
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Usucodigo#"> )
					</cfquery>
				</cfif>
				--->
			</cfloop>
			
		</cfif>
		
		<cfif Len(rsInsertWfxTransition.identity)>
			<cfset transitionInstanceId = rsInsertWfxTransition.identity >
			<cfset return_value = transitionInstanceId >
		<cfelse>
			<cfset return_value = -1 >
		</cfif>
		
		<cfreturn return_value>
	</cffunction>	
</cfcomponent>


