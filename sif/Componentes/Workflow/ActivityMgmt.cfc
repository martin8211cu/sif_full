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

	<cffunction name="insertActivity" access="package" output="false">
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">
		<cfargument name="ActivityId" type="numeric" required="yes">
		<cfargument name="ProcessId" type="numeric" required="yes">

		<cfquery datasource="#session.dsn#" name="inserted">
			insert INTO WfxActivity( ActivityId, ProcessId, ProcessInstanceId, State, StartTime, UpdateTime )
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">,
				'INACTIVE',
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			<cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="inserted">
		<cfreturn inserted.identity>
	</cffunction>

	<cffunction name="insertInitialActivities" access="package" output="false">
		<cfargument name="processInstanceId" type="numeric">

		<cfquery datasource="#session.DSN#" name="initial_activities">
			select b.ActivityId, a.ProcessId
			from WfxProcess a, WfActivity b
			where a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
			  and a.ProcessId = b.ProcessId
			  and b.IsStart = 1
		</cfquery>
		<cfloop query="initial_activities">
			<cfset new_ActivityInstanceId = This.insertActivity(Arguments.ProcessInstanceId, initial_activities.ActivityId, initial_activities.ProcessId)>
			<cfset This.insertActivityParticipants( new_ActivityInstanceId )>
		</cfloop>
	</cffunction>


	<cffunction name="insertActivityParticipants" access="package" output="false">
		<cfargument name="ActivityInstanceId" type="numeric">

		<cfquery datasource="#session.dsn#" name="participants">
			select
				p.Name as pkName,
				a.ParticipantId, a.Name, a.Description, a.ParticipantType, a.Usucodigo, a.rol, a.CFid as CFunc, a.OrgUnit,
				d.Ecodigo, e.EcodigoSDC,
				d.RequesterId, coalesce(d.SubjectId, 0) as SubjectId,
				d.CForigenId, d.CFdestinoId
			from WfxActivity c
				join WfxProcess d
					on d.ProcessInstanceId = c.ProcessInstanceId
				join Empresas e
					on e.Ecodigo = d.Ecodigo
				join WfActivityParticipant b
					on b.ActivityId = c.ActivityId
				join WfParticipant a
					on a.ParticipantId = b.ParticipantId
				join WfPackage p
					on p.PackageId = a.PackageId
			where c.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
		</cfquery>
		<cf_dbfunction name="op_concat" returnvariable="_Cat" datasource="#session.dsn#">
		<cfloop query="participants">
			<cfset real_users = QueryNew('Usucodigo,Name,Description')><!--- por si no se obtiene nada --->
			<cfswitch expression="#participants.ParticipantType#">

				<!--- HUMAN: buscar al Usuario especificado --->
				<!--- se inhibe si el Usuario es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="HUMAN">
					<cfif participants.Usucodigo EQ participants.SubjectId>
						<cfinvoke component="utils" method="jefeAsistentes_Usuario" returnvariable="real_users">
							<cfinvokeargument name="Usucodigo" value="#participants.Usucodigo#">
							<cfinvokeargument name="pakage" value="#participants.pkName#">
						</cfinvoke>
					<cfelse>
						<cfset real_users = QueryNew('Usucodigo,Name,Description')>
						<cfset QueryAddRow(real_users)>
						<cfset real_users.Usucodigo   = participants.Usucodigo>
						<cfset real_users.Name        = participants.Name>
						<cfset real_users.Description = participants.Description>
					</cfif>
				</cfcase><!--- HUMAN --->

				<!--- ORGUNIT: buscar al jefe/asistentes del Centro Funcional especificado --->
				<!--- se inhibe si el Jefe es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="ORGUNIT">
					<cfinvoke component="utils" method="jefeAsistentes_CF" returnvariable="real_users">
						<cfinvokeargument name="centro_funcional" 	value="#participants.CFunc#">
						<cfinvokeargument name="pakage" 			value="#participants.pkName#">
						<cfinvokeargument name="usucodigo"			value="#participants.SubjectId#">
					</cfinvoke>

					<cflog file="workflow" text="ParticipantType = ORGUNIT. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- ORGUNIT --->

				<!--- ROLE: buscar a los Usuarios asociados al Rol especificado --->
				<!--- se inhibe aquel Usuario del Rol que sea SubjectId = usuario interesado, en cuyo caso se ignora --->
				<cfcase value="ROLE">
					<cfif ListLen(participants.rol,'.') lt 2>
						<cflog file="workflow" text="insertActivityParticipants(#Arguments.ActivityInstanceId#): rol invalido: #participants.rol#. ">
					<cfelse>
						<cfquery datasource="#session.dsn#" name="real_users">
							<!--- query para obtener los agraciados por un ROL --->
							select ur.Usucodigo, dp.Pid as Name, dp.Pnombre #_CAT# ' ' #_CAT# dp.Papellido1 #_CAT# ' ' #_CAT# dp.Papellido2 as Description
							from UsuarioRol ur
								join Usuario u
									on ur.Usucodigo = u.Usucodigo
								join DatosPersonales dp
									on u.datos_personales = dp.datos_personales
							where ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(participants.rol,'.')#">
							  and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListRest(participants.rol,'.')#">
							  and ur.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#participants.EcodigoSDC#">
							  and ur.Usucodigo <> #participants.SubjectId#
							<!--- el siguiente order by se requiere para hacer un cfoutput/group y evitar eventuales duplicados --->
							order by ur.Usucodigo
						</cfquery>
					</cfif>
				</cfcase><!--- ROLE --->

				<!--- BOSS: buscar al jefe/asistentes del Usuario digitador (primer paso) o del usuario aprobador del paso anterior (siguientes pasos) --->
				<!--- se inhibe si el Jefe es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="BOSS">
					<!--- buscar ultima actividad que tuvo aprobador --->
					<cfset CurrentActivityInstanceId = Arguments.ActivityInstanceId>
					<cflog file="workflow" text="ParticipantType = BOSS. Arguments.ActivityInstanceId = #Arguments.ActivityInstanceId# ">
					<cfloop from="1" to="100" index="dummy">
						<cflog file="workflow" text="ParticipantType = BOSS. cfloop.regresar=#dummy#">
						<!---
							Aprobadores de las Actividades inmediatas anteriores:
								Solo hay un aprobador por Actividad
								Puede haber más de una Actividad inmediata anterior
						 --->
						<cfquery datasource="#session.dsn#" name="actividad_anterior">
							select a.Usucodigo, xt.FromActivityInstance
							  from WfxTransition xt
								inner join WfxActivityParticipant a
									on a.ActivityInstanceId = xt.FromActivityInstance
							where xt.ToActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CurrentActivityInstanceId#" list="yes">
							  and a.HasFinished = 1
							  and a.Usucodigo is not null
						</cfquery>
						<cflog file="workflow" text="ParticipantType = BOSS. CurrentActivityInstanceId = #CurrentActivityInstanceId#, actividad_anterior.RecordCount=#actividad_anterior.RecordCount#, actividad_anterior.FromActivityInstance=#actividad_anterior.FromActivityInstance#, actividad_anterior.Usucodigo=#actividad_anterior.Usucodigo# ">
						<cfif actividad_anterior.recordCount NEQ 0>
							<cfbreak>
						</cfif>
						<cfquery datasource="#session.dsn#" name="actividad_anterior">
							select distinct xt.FromActivityInstance
							from WfxTransition xt
							where xt.ToActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CurrentActivityInstanceId#" list="yes">
						</cfquery>
						<cfif actividad_anterior.recordCount EQ 0>
							<cfbreak>
						</cfif>
						<cfset CurrentActivityInstanceId = valueList(actividad_anterior.FromActivityInstance)>
					</cfloop>

					<cfif actividad_anterior.RecordCount>
						<!--- Se incluye el Jefe/Asistentes de los Aprobadores de la primera Actividad Inmediata anterior --->
						<cfloop query="actividad_anterior">
							<cfinvoke component="utils" method="jefeAsistentes_Usuario" returnvariable="real_users">
								<cfinvokeargument name="Usucodigo" value="#actividad_anterior.Usucodigo#">
								<cfinvokeargument name="pakage" value="#participants.pkName#">
							</cfinvoke>
							<cflog file="workflow" text="ParticipantType = BOSS. jefeAsistentes_Usuario actividad_anterior(Usucodigo=#actividad_anterior.Usucodigo#): jefe: {#real_users.Usucodigo#}">
							<cfif real_users.RecordCount><cfbreak></cfif>
						</cfloop>
						<!--- si llego aqui sin real_users, es que no hay jefe de la actividad anterior,
							y se maneja como si no tiene responsables, es decir, transición automática --->
					<cfelseif Len(participants.RequesterId)>
						<!--- Primer paso: se toma el Jefe/Asistentes del RequesterId --->
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ComoNoHuboActividadAnteriorSeBuscaElJefeDeQuienInicioElTramite"
						Default="Como no hubo actividad anterior, se busca el jefe de quien inició el trámite"
						returnvariable="MSG_ComoNoHuboActividadAnteriorSeBuscaElJefeDeQuienInicioElTramite"/>

						<cflog file="workflow" text="ParticipantType = BOSS.  #MSG_ComoNoHuboActividadAnteriorSeBuscaElJefeDeQuienInicioElTramite# (Usucodigo=#participants.RequesterId#)">
						<cfinvoke component="utils" method="jefeAsistentes_Usuario" returnvariable="real_users">
							<cfinvokeargument name="Usucodigo" value="#participants.RequesterId#">
							<cfinvokeargument name="pakage" value="#participants.pkName#">
						</cfinvoke>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_MSGJefe"
							Default="jefe"
							returnvariable="LB_MSGJefe"/>

						<cflog file="workflow" text="ParticipantType = BOSS. jefeAsistentes_Usuario(RequesterId=#participants.RequesterId#): #LB_MSGJefe#: {#real_users.Usucodigo#}">
					<cfelse>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_NoHuboActividadAnteriorNiQuienInicioElTramite"
						Default="No hubo actividad anterior, ni quien inició el trámite"
						returnvariable="MSG_NoHuboActividadAnteriorNiQuienInicioElTramite"/>

						<cflog file="workflow" text="ParticipantType = BOSS. #MSG_NoHuboActividadAnteriorNiQuienInicioElTramite# ">
					</cfif>

					<cfif real_users.Usucodigo EQ participants.SubjectId>
						<cfinvoke component="utils" method="jefeAsistentes_Usuario" returnvariable="real_users">
							<cfinvokeargument name="Usucodigo" 	value="#real_users.Usucodigo#">
							<cfinvokeargument name="pakage" 	value="#participants.pkName#">
						</cfinvoke>
					</cfif>
					<cflog file="workflow" text="ParticipantType = BOSS. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSS --->

				<!--- BOSS1: buscar al Jefe/Asistentes del Centro Funcional Origen --->
				<!--- se inhibe si el Jefe es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="BOSS1">
					<!--- Cuando el SubjectId=RequesterId funciona igual que Jefe del Primer Paso --->
					<cfinvoke component="utils" method="jefeAsistentes_CF" returnvariable="real_users">
						<cfinvokeargument name="centro_funcional"	value="#participants.CForigenId#">
						<cfinvokeargument name="pakage" 			value="#participants.pkName#">
						<cfinvokeargument name="usucodigo"			value="#participants.SubjectId#">
					</cfinvoke>
					<cflog file="workflow" text="ParticipantType = BOSS2. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSS1 --->

				<!--- BOSS2: buscar al Jefe/Asistentes del Centro Funcional Destino --->
				<!--- se inhibe si el Jefe es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="BOSS2">
					<cfinvoke component="utils" method="jefeAsistentes_CF" returnvariable="real_users">
						<cfinvokeargument name="centro_funcional"	value="#participants.CFdestinoId#">
						<cfinvokeargument name="pakage" 			value="#participants.pkName#">
						<cfinvokeargument name="usucodigo"			value="#participants.SubjectId#">
					</cfinvoke>
					<cflog file="workflow" text="ParticipantType = BOSS2. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSS2 --->

				<!--- OPARRALES 11/05/2018
					- Crear case basado en el bloque de arriba...
					- y utilizar el aprobador del centro funcional en vez del responsable
				 --->

				 <!--- BOSS1: buscar al Jefe/Asistentes del Centro Funcional Origen --->
				<!--- se inhibe si el Jefe es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="BOSSAP1">
					<!--- Cuando el SubjectId=RequesterId funciona igual que Jefe del Primer Paso --->
					<cfinvoke component="utils" method="jefeAPROBADOR_cf" returnvariable="real_users">
						<cfinvokeargument name="centro_funcional"	value="#participants.CForigenId#">
						<cfinvokeargument name="pakage" 			value="#participants.pkName#">
						<cfinvokeargument name="usucodigo"			value="#participants.SubjectId#">
					</cfinvoke>
					<cfset processXAprobador = true>
					<cflog file="workflow" text="ParticipantType = BOSSAP1. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSSAP1 --->

				<!--- BOSS2: buscar al Jefe/Asistentes del Centro Funcional Destino --->
				<!--- se inhibe si el Jefe es SubjectId = usuario interesado, en cuyo caso se busca a su Jefe --->
				<cfcase value="BOSSAP2">
					<cfinvoke component="utils" method="jefeAPROBADOR_cf" returnvariable="real_users">
						<cfinvokeargument name="centro_funcional"	value="#participants.CFdestinoId#">
						<cfinvokeargument name="pakage" 			value="#participants.pkName#">
						<cfinvokeargument name="usucodigo"			value="#participants.SubjectId#">
					</cfinvoke>
					<cflog file="workflow" text="ParticipantType = BOSSAP2. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSSAP2 --->

				<!--- OPARRALES FIN --->

				<!--- BOSSES1: buscar al Rol de Autorizadores definido en la Oficina del Centro Funcional ORIGEN --->
				<!--- se inhibe aquel Usuario del Rol que sea SubjectId = usuario interesado, en cuyo caso se ignora --->
				<cfcase value="BOSSES1">
					<!--- buscar Oficina origen --->
					<cfquery datasource="#session.dsn#" name="rsRol">
						select o.SScodigo, o.SRcodigo
						  from CFuncional cf
							inner join Oficinas o
								on o.Ecodigo  = cf.Ecodigo
								and o.Ocodigo = cf.Ocodigo
						 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#participants.CForigenId#" null="#participants.CForigenId EQ ""#">
					</cfquery>

					<!--- query para obtener los agraciados por un ROL --->
					<cfquery datasource="#session.dsn#" name="real_users">
						select distinct ur.Usucodigo, dp.Pid as Name, dp.Pnombre #_CAT# ' ' #_CAT# dp.Papellido1 #_CAT# ' ' #_CAT# dp.Papellido2 as Description
						from UsuarioRol ur
							join Usuario u
								on ur.Usucodigo = u.Usucodigo
							join DatosPersonales dp
								on u.datos_personales = dp.datos_personales
						where ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRol.SScodigo#">
						  and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRol.SRcodigo#">
						  and ur.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#participants.EcodigoSDC#">
						  and ur.Usucodigo <> #participants.SubjectId#
						<!--- el siguiente order by se requiere para hacer un cfoutput/group y evitar eventuales duplicados --->
						order by ur.Usucodigo
					</cfquery>
					<cflog file="workflow" text="ParticipantType = BOSSES1. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSSES1 --->

				<!--- BOSSES2: buscar al Rol de Autorizadores definido en la Oficina del Centro Funcional DESTINO --->
				<!--- se inhibe aquel Usuario del Rol que sea SubjectId = usuario interesado, en cuyo caso se ignora --->
				<cfcase value="BOSSES2">
					<cfquery datasource="#session.dsn#" name="rsRol">
						select o.SScodigo, o.SRcodigo
						  from CFuncional cf
							inner join Oficinas o
								on o.Ecodigo  = cf.Ecodigo
								and o.Ocodigo = cf.Ocodigo
						 where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#participants.CFdestinoId#" null="#participants.CFdestinoId EQ ""#">
					</cfquery>

					<!--- query para obtener los agraciados por el ROL --->
					<cfquery datasource="#session.dsn#" name="real_users">
						select distinct ur.Usucodigo, dp.Pid as Name, dp.Pnombre #_CAT# ' ' #_CAT# dp.Papellido1 #_CAT# ' ' #_CAT# dp.Papellido2 as Description
						from UsuarioRol ur
							join Usuario u
								on ur.Usucodigo = u.Usucodigo
							join DatosPersonales dp
								on u.datos_personales = dp.datos_personales
						where ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRol.SScodigo#">
						  and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRol.SRcodigo#">
						  and ur.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#participants.EcodigoSDC#">
						  and ur.Usucodigo <> #participants.SubjectId#
						<!--- el siguiente order by se requiere para hacer un cfoutput/group y evitar eventuales duplicados --->
						order by ur.Usucodigo
					</cfquery>
					<cflog file="workflow" text="ParticipantType = BOSSES2. RESULTADO_FINAL: RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#, Name=#real_users.Name#, Description=#real_users.Description#">
				</cfcase><!--- BOSSES2 --->

				<cfdefaultcase>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Invalido"
					Default="inválido"
					returnvariable="MSG_Invalido"/>
					<cf_errorCode	code = "51393"
									msg  = "ParticipantType @errorDat_1@: @errorDat_2@"
									errorDat_1="#MSG_Invalido#"
									errorDat_2="#participants.ParticipantType#"
					>
				</cfdefaultcase>
			</cfswitch>

			<cfset Participants_CurrentRow = participants.CurrentRow>
			<cfset participants_ParticipantId = participants.ParticipantId>

			<cfoutput query="real_users" group="Usucodigo">
				<!--- se inhibe un Asistente (y cualquier otro usuario) cuando es SubjectId = usuario interesado, en cuyo caso se ignora --->
				<!--- OPARRALES 2018-05-15 Se agrega bandera para que las acciones aplicadas
					- le lleguen al mismo aprobador cuando sea el quien las solicita, esto permitira
					- que no se afecte la logica de los demas procesos.
				--->
				<cfif IsDefined('processXAprobador') or real_users.Usucodigo NEQ participants.SubjectId>
					<cfquery datasource="#session.dsn#" name="insert_participant">
						insert INTO WfxActivityParticipant
						  (ParticipantId, ActivityInstanceId, Usucodigo, Name, Description, HasStarted)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#participants_ParticipantId#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.activityInstanceId#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#real_users.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#real_users.Name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#real_users.Description#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('session.Usucodigo') and (real_users.Usucodigo EQ session.Usucodigo)#">)
					</cfquery>
				</cfif>
			</cfoutput> <!--- real_users group(unique) by Usucodigo --->
		</cfloop> <!--- participants --->
	</cffunction>

	<cffunction name="setActivityState" access="package" output="false" >
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">
		<cfargument name="State" type="string" required="yes">

		<cfquery name="old_values" datasource="#session.DSN#">
			select State, UpdateTime, ProcessInstanceId
			from WfxActivity
			where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ActivityInstanceId#">
		</cfquery>
		<cfif old_values.RecordCount neq 1>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_LaActividadNoExiste"
			Default="La actividad no existe"
			returnvariable="MSG_LaActividadNoExiste"/>

			<cf_errorCode	code = "51394"
							msg  = "@errorDat_1@ [ActivityInstanceId = @errorDat_2@]"
							errorDat_1="#MSG_LaActividadNoExiste#"
							errorDat_2="#Arguments.ActivityInstanceId#"
			>
		</cfif>

		<cfif old_values.State eq arguments.State or
			old_values.State eq "INACTIVE"  and Arguments.State neq "ACTIVE" or
			old_values.State eq "ACTIVE"    and Arguments.State eq "INACTIVE" or
		    old_values.State eq "SUSPENDED" and Arguments.State neq "ACTIVE" or
			old_values.State eq "COMPLETED" >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_TransicionInvalidaDe"
			Default="Transicion invalida de "
			returnvariable="MSG_TransicionInvalidaDe"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_De"
			Default="de"
			returnvariable="MSG_De"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_A"
			Default="a"
			returnvariable="MSG_A"/>

			<cf_errorCode	code = "51395"
							msg  = "@errorDat_1@ ActivityInstanceId @errorDat_2@ @errorDat_3@ @errorDat_4@ @errorDat_5@ @errorDat_6@"
							errorDat_1="#MSG_TransicionInvalidaDe#"
							errorDat_2="#Arguments.ActivityInstanceId#"
							errorDat_3="#MSG_De#"
							errorDat_4="#old_values.State#"
							errorDat_5="#MSG_A#"
							errorDat_6="#Arguments.State#"
			>
		</cfif>

		<cfset UpdateTime = Now()>
		<cfset OldUpdateTime = old_values.UpdateTime>
		<cfset ElapsedMillis =  (UpdateTime.getTime() - OldUpdateTime.getTime()) / 1000 >
		<!--- Actualizar estado y contabilizar tiempos --->
		<cfquery datasource="#session.DSN#">
			update WfxActivity
		    set State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#">,
			    UpdateTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#UpdateTime#">
			<cfif Arguments.State is 'COMPLETED' and old_values.State neq 'COMPLETED'>
				, FinishTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#UpdateTime#">
			</cfif>
			<cfif old_values.State is 'ACTIVE'>
				, WorkingTime = WorkingTime + <cfqueryparam cfsqltype="cf_sql_numeric" value="#ElapsedMillis#">
			<cfelseif old_values.State is 'INACTIVE' or old_values.State is 'SUSPENDED'>
				, WaitingTime = WaitingTime + <cfqueryparam cfsqltype="cf_sql_numeric" value="#ElapsedMillis#">
			</cfif>
			<cfif IsDefined('session.Usucodigo')>
				, BMUsucodigo = #session.Usucodigo#
			</cfif>
		    where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#" >
		</cfquery>
		<cfif IsDefined('session.Usucodigo')>
			<cfquery datasource="#session.dsn#">
				update WfxActivityParticipant
				set HasFinished = 1
				where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#" >
				  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			</cfquery>
		</cfif>

		<!--- Marcar los procesos como COMPLETED si ya no hay más por hacer, o sea:
		si no hay actividades incompletas, y
		hay alguna actividad final
		--->
		<cfif Arguments.State Is 'COMPLETED'>
			<cfquery name="incomplete_activities" datasource="#session.dsn#">
				select count(1) as hay
				from WfxActivity s
				where s.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#old_values.ProcessInstanceId#">
				and State != 'COMPLETED'
			</cfquery>
			<cfquery name="final_activities" datasource="#session.dsn#">
				select count(1) as hay
				from WfxActivity s, WfActivity a
				where s.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#old_values.ProcessInstanceId#">
				and a.ActivityId = s.ActivityId
				and a.IsFinish = 1
			</cfquery>
			<cfif incomplete_activities.hay is 0 and final_activities.hay gt 0>
				<cfquery datasource="#session.dsn#">
					update WfxProcess
					set State = 'COMPLETE',
					FinishTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#UpdateTime#">
					where WfxProcess.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#old_values.ProcessInstanceId#">
				</cfquery>
			</cfif>
		</cfif><!--- State = 'COMPLETED' --->

		<cfset This.notifyActivityStateChange(Arguments.ActivityInstanceId, old_values.State, Arguments.State)>
	</cffunction>


	<cffunction name="sendMail" access="package" output="false">
		<cfargument name="Usucodigo"			type="numeric">
		<cfargument name="info" type="string">
		<cfargument name="isPart" type="boolean">
		<cfargument name="isAfter" type="boolean">
		<cfargument name="isFinish" type="boolean">
		<cfargument name="origen" type="string">
		<cfargument name="rsHistory" type="query">
		<cfset var asunto = "">
		<cfset destinatario = "">
		<cfif (isPart)>
			<cfif listFirst(origen,'/') eq 'RH'>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_TieneUnTramiteDeAdministracionDePersonalPendiente"
				Default="Notificación de Trámite de Administración de Personal asignado"
				returnvariable="MSG_TieneUnTramiteDeAdministracionDePersonalPendiente"/>
				<cfset asunto = MSG_TieneUnTramiteDeAdministracionDePersonalPendiente>
			<cfelse>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ActividadAsignadaParaRevision"
				Default="Notificación de Trámite asignado"
				returnvariable="MSG_ActividadAsignadaParaRevision"/>
				<cfset asunto = MSG_ActividadAsignadaParaRevision>
			</cfif>
		<cfelseif isFinish>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NotificacionDeActividad"
			Default="Notificación de Estado de Final de Trámite"
			returnvariable="MSG_NotificacionDeEstado"/>
			<cfset asunto = MSG_NotificacionDeEstado>
		<cfelse>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NotificacionDeActividad"
			Default="Notificación de Actividad de Trámite"
			returnvariable="MSG_NotificacionDeActividad"/>
			<cfset asunto = MSG_NotificacionDeActividad>
		</cfif>

		<cfset args = StructNew()>
		<cfquery datasource="#session.dsn#" name="datos_personales">
			select u.datos_personales,
				dp.Pnombre as nombre, dp.Papellido1 as apellido1, dp.Papellido2 as apellido2,
				dp.Pemail1 as email1, dp.Pcelular as celular
			from Usuario u
				join DatosPersonales dp
					on u.datos_personales = dp.datos_personales
			where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfset args.datos_personales = datos_personales>

		<cfset args.info = Arguments.info>
		<cfset args.isPart = Arguments.isPart>
		<cfset args.isAfter = Arguments.isAfter>
		<cfset args.isFinish = Arguments.isFinish>
		<cfset args.rsHistory = Arguments.rsHistory>

		<cfquery name="rsPMail" datasource="#session.dsn#">
			select
				Pvalor
			from RHParametros
			where
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="14600701">
		</cfquery>

		<cfif rsPMail.RecordCount gt 0 and rsPMail.Pvalor neq ''>
			<cfset args.hostname = Trim(rsPMail.Pvalor)>
		<cfelse>
			<cfparam name = "session.sitio.host">
			<cfset args.hostname = session.sitio.host>
		</cfif>


		<cfset args.Usucodigo = Arguments.Usucodigo>
		<cfset args.CEcodigo = session.CEcodigo>
		<cfset request.MailArguments = args>

		<cfsavecontent variable="_mail_body">
			<cfinclude template="/sif/Componentes/Workflow/mail-notifica.cfm">
		</cfsavecontent>
		<cfset destinatario = '"' & datos_personales.nombre & ' ' & datos_personales.apellido1
			& ' ' & datos_personales.apellido2 & '" <' & datos_personales.email1 & '>'>


		<cfquery datasource="#session.dsn#">
			insert INTO SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value='gestion@soin.co.cr'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#destinatario#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#asunto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
		</cfquery>

	</cffunction>

	<cffunction name="sendSMS" access="package" output="false">
		<cfargument name="Usucodigo" type="numeric">
		<cfargument name="info" type="string">
		<cfargument name="isPart" type="boolean">
		<cfargument name="isAfter" type="boolean">
		<cfargument name="isFinish" type="boolean">
		<cfargument name="Ecodigo" type="numeric">

		<cfset var asunto = "">

		<cfquery name="dataSMS" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and Pcodigo = 610
		</cfquery>

		<cfif dataSMS.recordcount gt 0 and trim(dataSMS.Pvalor) eq 1 >
			<!--- <cfset var asunto = ""> --->
			<cfset asunto = "">

			<cfset destinatario = "">
			<cfif (isPart)>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ActividadAsignadaParaRevision"
				Default="Notificación de Trámite asignado"
				returnvariable="MSG_ActividadAsignadaParaRevision"/>

				<cfset asunto = MSG_ActividadAsignadaParaRevision>
			<cfelseif isFinish>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NotificacionDeActividad"
				Default="Notificación de Estado de Final de Trámite"
				returnvariable="MSG_NotificacionDeEstado"/>
				<cfset asunto = MSG_NotificacionDeEstado>
			<cfelse>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NotificacionDeActividad"
				Default="Notificación de Actividad de Trámite"
				returnvariable="MSG_NotificacionDeActividad"/>
				<cfset asunto = MSG_NotificacionDeActividad>
			</cfif>

			<cfif arguments.isPart >
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_LeHaSidoAsignada"
				Default="le ha sido asignada"
				returnvariable="MSG_LeHaSidoAsignada"/>

				<cfset arguments.info = arguments.info & " " & MSG_LeHaSidoAsignada & "." >
			<cfelse>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_Ha"
				Default="ha"
				returnvariable="MSG_Ha"/>
				<cfif arguments.isAfter>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_COMPLETED"
					Default="ha Iniciado"
					returnvariable="MSG_COMPLETED"/>
					<cfset arguments.info = arguments.info & " " & MSG_COMPLETED & "." >
				<cfelse>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_NON_COMPLETED"
					Default="no ha Iniciado"
					returnvariable="MSG_NON_COMPLETED"/>
					<cfset arguments.info = arguments.info & " " &  MSG_NON_COMPLETED & ".">
				</cfif>
			</cfif>

			<cfquery datasource="#session.dsn#" name="datos_personales">
				select u.datos_personales,
					dp.Pnombre as nombre, dp.Papellido1 as apellido1, dp.Papellido2 as apellido2,
					dp.Pemail1 as email1, dp.Pcelular as celular
				from Usuario u
					join DatosPersonales dp
						on u.datos_personales = dp.datos_personales
				where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			</cfquery>

			<cfif len(trim(datos_personales.celular))>
				<cfquery datasource="#session.dsn#" name="newsms">
					insert into SMS ( SScodigo, SMcodigo, asunto, para, texto, fecha_creado, BMfecha, BMUsucodigo )
					values ( 'sys',
							 'home',
							 <cfqueryparam cfsqltype="cf_sql_varchar"   value="sms: #asunto#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#datos_personales.celular#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.info#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.Usucodigo#"> )
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="notifyActivityStateChange" access="package" output="false">
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">
		<cfargument name="old_state" type="string" required="yes">
		<cfargument name="new_state" type="string" required="yes">

		<cfset var after = new_state Is 'COMPLETED'>
		<cfset var subj = false>
		<cfset var part = false>
		<cfset var req  = false>
		<cfset var info = "">
		<cfif Not (Arguments.old_state Is 'INACTIVE' And Arguments.new_state Is 'ACTIVE'
			    Or Arguments.old_state Is 'ACTIVE'   And Arguments.new_state Is 'COMPLETED') >
			<!--- Notificar por email solamente si hay cambio
				  de INACTIVE->ACTIVE O DE ACTIVE->COMPLETED   --->
			<cfreturn>
		</cfif>
		<cfquery datasource="#session.dsn#" name="WfActivity">
			select e.Name as origen ,
				b.NotifySubjBefore, b.NotifyPartBefore, b.NotifyReqBefore, b.NotifyAllBefore,
				b.NotifySubjAfter,  b.NotifyPartAfter,  b.NotifyReqAfter,  b.NotifyAllAfter,
				b.Name as ActivityName, a.ProcessInstanceId, c.RequesterId, c.SubjectId,
				c.Description as ProcessInstanceDescription,
				coalesce (d.Description, d.Name) as ProcessDescription,
				d.Name as ProcessDescriptionSMS, c.Ecodigo,
				b.IsFinish
			from WfxActivity a
				join WfActivity b
					on b.ActivityId = a.ActivityId
				join WfxProcess c
					on c.ProcessInstanceId = a.ProcessInstanceId
				join WfProcess d
					on d.ProcessId = c.ProcessId
				join WfPackage e
					on d.PackageId = e.PackageId

			where a.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
		</cfquery>

		<!--- OPARRALES 2018-05-31 INICIO
			- AGREGANDO COMPLEMENTO DE TEXTO AL CORREO... NOMBRE DE LA ACTIVIDAD, FECHA INICIO Y FECHA FIN
		 --->
		<cfquery name="rsAccionInf" datasource="#session.dsn#">
			SELECT h.Name AS Actividad,
				a.DLffin,
				b.RHTdesc,
				a.DLfvigencia,
				CASE g.State
				    WHEN 'INACTIVE' THEN 'INACTIVO'
				    WHEN 'SUSPENDED' THEN 'SUSPENDIDO'
				    WHEN 'COMPLETED' THEN 'COMPLETO'
				    WHEN 'ACTIVE' THEN 'ACTIVO'
				END AS State,
				isNull(a.RHAvdisf,0) as RHAvdisf
			FROM RHAcciones a
				inner join RHTipoAccion b
					on a.RHTid = b.RHTid
				AND a.Ecodigo = b.Ecodigo
				left join DatosEmpleado c
					on a.Ecodigo = c.Ecodigo
					AND a.DEid = c.DEid
				left join WfxProcess d
					on a.RHAidtramite = d.ProcessInstanceId
				left join WfProcess e
					on d.ProcessId = e.ProcessId
				left join WfPackage f
					on e.PackageId = f.PackageId
				left join WfxActivity g
					on d.ProcessInstanceId = g.ProcessInstanceId
				left join WfActivity h
					on g.ActivityId = h.ActivityId
					AND d.ProcessId = h.ProcessId
					AND h.IsFinish = 0
			WHERE
				<cfif IsDefined('form.RHALINEA')> <!--- CUANDO EL USUARIO ENVIA A APLICAR SU TRAMITE (accion de personal) --->
					a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAlinea#">
				<cfelse><!--- CUANDO ENTRAN EN JUEGO LOS APROBADORES --->
					g.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
				</cfif>
			ORDER BY g.ActivityInstanceId,
			         h.Ordering
		</cfquery>
		<cfset infoExtra = "">
		<cfif rsAccionInf.RecordCount gt 0>

			<cfset fecIni = "N/A">
			<cfif Trim(rsAccionInf.DLfvigencia) neq ''>
				<cfset fecIni = LSDateFormat(rsAccionInf.DLfvigencia,'dd/MM/YYYY')>
			</cfif>

			<cfset fecFin = "N/A">
			<cfif Trim(rsAccionInf.DLffin) neq ''>
				<cfset fecFin = LSDateFormat(rsAccionInf.DLffin,'dd/MM/YYYY')>
			</cfif>

			<cfset infoExtra = "<br /><p>Nombre de Acci&oacute;n: #Trim(rsAccionInf.RHTdesc)#<br />Fecha inicial: #fecIni#<br />Fecha final: #fecFin#<br />Total de dias: #rsAccionInf.RHAvdisf#</p><br />">
		</cfif>

		<cfif infoExtra neq ''>
			<cfset session.infoExtra = infoExtra>
			<cfset session.MyProcess = Arguments.ActivityInstanceId>
		</cfif>
		<!--- OPARRALES 2018-05-31 FIN
			- AGREGANDO COMPLEMENTO DE TEXTO AL CORREO... NOMBRE DE LA ACTIVIDAD, FECHA INICIO Y FECHA FIN
		 --->

		<cfset subj = (IIf(after, 'WfActivity.NotifySubjAfter',	'WfActivity.NotifySubjBefore') EQ 1)>
		<cfset part = (IIf(after, 'WfActivity.NotifyPartAfter',	'WfActivity.NotifyPartBefore') EQ 1)>
		<cfset req  = (IIf(after, 'WfActivity.NotifyReqAfter',	'WfActivity.NotifyReqBefore') EQ 1)>
		<cfset all  = (IIf(after, 'WfActivity.NotifyAllAfter',	'WfActivity.NotifyAllBefore') EQ 1)>

		<cfset finish  = (WfActivity.IsFinish EQ 1)>

		<cfset origen  = WfActivity.origen>

		<cfif Not (subj Or part Or req or all)>
			<cfreturn>
		</cfif>

		<!--- validacion para el ultimo aprobador --->
		<cfif infoExtra eq '' and session.infoExtra neq '' and session.MyProcess eq Arguments.ActivityInstanceId>
			<cfset infoExtra = session.infoExtra>
			<cfset StructDelete('#session#','infoExtra',true)>
			<cfset StructDelete('#session#','MyProcess',true)>
		</cfif>

<cfif NOT after>
	<cfthrow message="No se ha ejecutado el PARCHE de Trámites, el cual modifica y ajusta datos de definición de Trámites">
</cfif>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_la_actividad"
		Default="la actividad"
		returnvariable="MSG_LaActividad"/>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Para_Tramite_Numero"
		Default="para el trámite número"
		returnvariable="MSG_ParaElTramiteNumero"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_y_su_estado_es"
		Default="y su estado es"
		returnvariable="MSG_Y_Su_Estado_Es"/>

		<cfset info = MSG_LaActividad & " " &
					  WfActivity.ActivityName & " " &
					  MSG_ParaElTramiteNumero & " " &
					  WfActivity.ProcessInstanceId & ", " &
					  WfActivity.ProcessDescription & " " &
					  WfActivity.ProcessInstanceDescription >
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DelTramite"
		Default="del trámite"
		returnvariable="MSG_DelTramite"/>

		<cfset info_sms = MSG_LaActividad & " " & WfActivity.ActivityName & " " & MSG_DelTramite & " " & WfActivity.ProcessDescriptionSMS >

		<!--- Arma la historia de Actividades del Trámite --->
		<cfset LvarRequester = "">
		<cfif WfActivity.RequesterId NEQ "" and WfActivity.RequesterId NEQ "0">
			<cfquery datasource="#session.dsn#" name="rsSQL">
				select dp.Pnombre as nombre, dp.Papellido1 as apellido1, dp.Papellido2 as apellido2
				from Usuario u
					join DatosPersonales dp
						on u.datos_personales = dp.datos_personales
				where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfActivity.RequesterId#">
			</cfquery>
			<cfset LvarRequester = rsSQL.nombre & ' ' & rsSQL.apellido1 & ' ' & rsSQL.apellido2>
		</cfif>

		<cfset LvarSubject = "">
		<cfif WfActivity.SubjectId NEQ "" and WfActivity.SubjectId NEQ "0" AND WfActivity.SubjectId NEQ WfActivity.RequesterId>
			<cfquery datasource="#session.dsn#" name="rsSQL">
				select dp.Pnombre as nombre, dp.Papellido1 as apellido1, dp.Papellido2 as apellido2
				from Usuario u
					join DatosPersonales dp
						on u.datos_personales = dp.datos_personales
				where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfActivity.SubjectId#">
			</cfquery>
			<cfset LvarSubject = rsSQL.nombre & ' ' & rsSQL.apellido1 & ' ' & rsSQL.apellido2>
		</cfif>
		<cfquery datasource="#session.dsn#" name="rsHistory">
			select 	xa.ProcessInstanceId, xa.ActivityInstanceId, xt.TransitionInstanceId,TransitionComments,
					case
						when a.IsStart = 1					then 'INICIO DE TRAMITE'
						when a.IsFinish = 1					then 'RESULTADO: '	+ a.Name
															else 'ACTIVIDAD: '	+ a.Name
					end AS ActivityName,
					case
						when a.IsStart = 1							then 'Solicitado por ' + '#LvarRequester#'
																	<cfif trim(LvarSubject) NEQ "">
																		+ '<BR>para: ' + '#LvarSubject#'
																	</cfif>
						when a.IsFinish = 1							then '<strong>FINAL DE TRAMITE</strong>'
						when xt.TransitionInstanceId is not null 	then 'ACCION TOMADA: ' + t.Name   + ' <BR>Por: ' + coalesce((Select Max(Description)
																																 from WfxActivityParticipant xap
																																 where xap.ActivityInstanceId = xa.ActivityInstanceId
																																 and HasTransition = 1), 'ADMINISTRADOR DE TRAMITES')
						when xa.State = 'COMPLETED' 				then '***'
						when xa.State = 'INACTIVE' 					then 'INACTIVO'
						when xa.State = 'SUSPENDED' 				then 'SUSPENDIDO'
						when xa.State = 'ACTIVE' 					then 'NO HA INICIADO'
					end ActionName
			from WfxActivity xa
				inner join WfActivity a
					on xa.ActivityId = a.ActivityId
			  	left join WfxTransition xt
					left join WfTransition t
						on t.TransitionId = xt.TransitionId
			  		on xt.FromActivityInstance = xa.ActivityInstanceId
			where xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfActivity.ProcessInstanceId#">
			order by xa.ProcessInstanceId, xa.ActivityInstanceId, xt.TransitionInstanceId
		</cfquery>

		<cfinvoke 	component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_EstadoTramiteNumero"
					Default="Estado del Trámite número"
					returnvariable="MSG_EstadoTramiteNumero"/>
		<cfset info = MSG_EstadoTramiteNumero & " " &
					  WfActivity.ProcessInstanceId & ", " &
					  WfActivity.ProcessDescription & " " &
					  WfActivity.ProcessInstanceDescription >


		<!--- OPARRALES 2018-05-31 (infoExtra)
			- AGREGANDO COMPLEMENTO DE TEXTO AL CORREO... NOMBRE DE LA ACTIVIDAD, FECHA INICIO Y FECHA FIN
		 --->
		<cfset info &= infoExtra>

		<!--- enviar correo a Participants de la Actividad o Todos los del Tramite --->
		<cfif part OR all>
			<cfif part>
				<cfquery datasource="#session.dsn#" name="WfxActivityParticipant">
					select Usucodigo, 1 as part
					  from WfxActivityParticipant
					 where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.dsn#" name="WfxActivityParticipant">
					select distinct xap.Usucodigo, (select count(1) from WfxActivityParticipant where Usucodigo = xap.Usucodigo and ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">) as part
					from WfxActivityParticipant xap
						join WfxActivity xa
							on xa.ActivityInstanceId = xap.ActivityInstanceId
					where xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfActivity.ProcessInstanceId#">
				</cfquery>
			</cfif>

			<cfloop query="WfxActivityParticipant">
				<cfset part = (WfxActivityParticipant.part NEQ 0)>
				<cfif WfxActivityParticipant.Usucodigo EQ WfActivity.RequesterId>
					<cfset req = false>
				</cfif>
				<cfif WfxActivityParticipant.Usucodigo EQ WfActivity.SubjectId>
					<cfset subj = false>
					<cfset part = false>
				</cfif>

				<cfset sendMail(WfxActivityParticipant.Usucodigo, info, part, after, finish, origen, rsHistory)>
				<cfset sendSMS(WfxActivityParticipant.Usucodigo, info_sms, part, after, finish, WfActivity.Ecodigo)>
			</cfloop>
		</cfif>

		<!--- enviar correo a Requester si no se le envió como Participants --->
		<cfif req AND WfActivity.RequesterId NEQ "">
			<!--- enviar correo a quien inició/solicitó el trámite --->
			<cfset sendMail(WfActivity.RequesterId, info, false, after, finish, origen, rsHistory)>
			<!--- enviar correo a quien inició/solicitó el trámite --->
			<cfset sendSMS(WfActivity.RequesterId, info_sms, false, after, finish, WfActivity.Ecodigo)>


			<!--- OPARRALES 2018-05-23
				- Enviar correos a los usuarios asignados al rol RHNotify Para las Acciones de personal Autorizadas o Rechazadas
			 --->
			<cfif (IsDefined('session.CorreoVacaciones') and session.CorreoVacaciones) or (Trim(WfActivity.Origen) eq 'RH/1' and Ucase(trim(WfActivity.ActivityName)) eq 'RECHAZADO')>
				<cfquery name="rsRH" datasource="#session.dsn#">
					select
						r.SScodigo,r.SRcodigo,r.SRdescripcion,
						ur.Usucodigo,
						u.Usulogin,
						concat(dt.Pnombre,' ',coalesce(dt.Papellido1,''),' ',coalesce(dt.Papellido2,'')) as Nombre,
						coalesce(dt.Pemail1,coalesce(dt.Pemail2,'')) as correo
					from
						<cf_dbdatabase table="SRoles" datasource="asp"> r,
						<cf_dbdatabase table="UsuarioRol" datasource="asp" > ur,
						Usuario u,
						DatosPersonales dt
					where
						r.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RHNotify">
					and ur.SRcodigo = r.SRcodigo
					and ur.Usucodigo = u.Usucodigo
					and u.datos_personales = dt.datos_personales
				</cfquery>

				<cfloop query="rsRH">
					<cfif Trim(rsRH.correo) eq ''>
						<cfcontinue>
					</cfif>
					<cfset sendMail(rsRH.Usucodigo, info, false, after, finish, origen, rsHistory)>
				</cfloop>
				<cfset StructDelete('#session#','CorreoVacaciones',true)>

			</cfif>

		</cfif>

		<!--- enviar correo a Subject si no se le envió como Participants o Requester --->
		<cfif subj and WfActivity.SubjectId NEQ "" AND (WfActivity.SubjectId NEQ WfActivity.RequesterId or not req)>
			<!--- enviar correo a el sujeto (empleado del que trata la acción, en el caso de Acciones de Personal en RH) del trámite --->
			<cfset sendMail(WfActivity.SubjectId, info, false, after, finish, origen, rsHistory)>
			<!--- enviar SMS a el sujeto (empleado del que trata la acción, en el caso de Acciones de Personal en RH) del trámite --->
			<cfset sendSMS(WfActivity.SubjectId, info_sms, false, after, finish, WfActivity.Ecodigo)>
		</cfif>
	</cffunction>
</cfcomponent>

