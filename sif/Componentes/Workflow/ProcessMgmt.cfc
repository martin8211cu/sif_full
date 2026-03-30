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

	<cffunction name="insertProcess" access="package" output="false" returntype="numeric">
		<cfargument name="ProcessId" type="numeric" required="yes">
		<cfargument name="RequesterId" type="numeric" required="yes">
		<cfargument name="SubjectId" type="numeric" required="yes">
		<cfargument name="Description" type="string" required="yes">
		<cfargument name="CForigenId"	type="numeric"	required="yes">
		<cfargument name="CFdestinoId" type="numeric" required="yes">
		<cfset Arguments.Description= replace(Arguments.Description,",",".")> <!--- LZ se quitan las commas al campo String) --->
		<cfset Arguments.Description= mid(trim(Arguments.Description),1, 255)> <!--- LZ en Oracle hay que evitar que el campo sea mas grande que el campo en BD contenedor) --->
        <cfquery name="rs" datasource="#session.DSN#">
			insert INTO WfxProcess(ProcessId, StartTime, RequesterId, SubjectId, Ecodigo, Description, CForigenId, CFdestinoId)
	     	values ( <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RequesterId#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SubjectId#" null="#SubjectId is 0#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Description#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CForigenId#" null="#Arguments.CForigenId EQ -1#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CFdestinoId#" null="#Arguments.CFdestinoId EQ -1#">
					 )
	     	<cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="rs">
		<cfreturn rs.identity>
	</cffunction>
  
	<cffunction name="insertProcessParticipants" access="package" output="false">
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">
		<cfargument name="RequesterId" type="numeric" required="yes">
		
		<cfquery datasource="#session.DSN#">
			insert INTO WfxProcessParticipant ( ParticipantId, ProcessInstanceId, Usucodigo )
			  select distinct a.ParticipantId, 
			  #Arguments.ProcessInstanceId#,
			  case 
			  	when a.ParticipantType = 'HUMAN' and a.Usucodigo is null
					then #Arguments.RequesterId# 
					else a.Usucodigo
			  end
			  from WfParticipant a, WfActivityParticipant b, WfActivity c, WfxProcess d
			  where c.ProcessId = d.ProcessId
				and d.ProcessInstanceId = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
				and b.ActivityId = c.ActivityId
				and a.ParticipantId = b.ParticipantId
		</cfquery>
	</cffunction>
	
	<cffunction name="startProcess" access="package" returntype="numeric" output="false" >
		<cfargument name="ProcessId" type="numeric" required="yes">
		<cfargument name="RequesterId" type="numeric" required="yes">
		<cfargument name="SubjectId" type="numeric" required="yes">
		<cfargument name="Description" type="string" required="yes">
		<cfargument name="CForigenId"	type="numeric"	required="yes">
		<cfargument name="CFdestinoId" type="numeric" required="yes">
		
		<cfset PublishedProcessId = This.getPublishedProcessId(Arguments.ProcessId)>
		
		<cfset processInstanceId = This.insertProcess(PublishedProcessId, Arguments.RequesterId, Arguments.SubjectId, Arguments.Description, Arguments.CForigenId, Arguments.CFdestinoId)>
		<cfset This.insertProcessParticipants(processInstanceId, RequesterId)>
		
		<cfset verCFdestino (processInstanceId, Arguments.CForigenId, Arguments.CFdestinoId, Arguments.RequesterId)>

		<cfinvoke component="ActivityMgmt" method="insertInitialActivities">
			<cfinvokeargument name="ProcessInstanceId" value="#ProcessInstanceId#">
		</cfinvoke>
		
		<cfreturn processInstanceId>
	</cffunction>
	
	<cffunction name="getPublishedProcessId" access="package" returntype="numeric" output="false">
		<cfargument name="ProcessId" type="numeric" required="yes">
		
		<cfquery datasource="#session.dsn#" name="ThisProcess">
			select PackageId, Name, Version, PublicationStatus
			from WfProcess
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">
		</cfquery>
		<cfif ThisProcess.PublicationStatus is 'RELEASED'>
			<cfreturn Arguments.ProcessId>
		</cfif>
		<cfquery datasource="#session.dsn#" name="Published_Version">
			select ProcessId
			from WfProcess
			where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ThisProcess.PackageId#">
			  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ThisProcess.Name#">
			  and PublicationStatus = 'RELEASED'
		</cfquery>
		<cfif Published_Version.RecordCount Is 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_LamentablementeElTramite"
			Default="Lamentablemente el trámite "
			returnvariable="MSG_LamentablementeElTramite"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncuentraDisponibleActualmente"
			Default="no se encuentra disponible actualmente "
			returnvariable="MSG_NoSeEncuentraDisponibleActualmente"/>
			
			<cf_errorCode	code = "50131"
							msg  = "@errorDat_1@ @errorDat_2@ @errorDat_3@"
							errorDat_1="#MSG_LamentablementeElTramite#"
							errorDat_2="#ThisProcess.Name#"
							errorDat_3="#MSG_NoSeEncuentraDisponibleActualmente#"
			>
		</cfif>
		<cfreturn Published_Version.ProcessId>
	</cffunction>

	<cffunction name="verCFdestino" access="public" returntype="void" output="false">
		<cfargument name="ProcessInstanceId"	type="numeric"	required="yes">
		<cfargument name="CForigenId"			type="numeric"	required="yes">
		<cfargument name="CFdestinoId"			type="numeric"	required="yes">
		<cfargument name="RequesterId"			type="numeric"	required="yes">

		<cfquery name="rsPrt" datasource="#session.DSN#">
			select distinct pk.Name, a.ParticipantType, pk.CFdestino
			  from WfxProcess d
				inner join WfProcess p
					 on p.ProcessId = d.ProcessId
				inner join WfPackage pk 
					on pk.PackageId=p.PackageId 
				inner join WfActivity c
					 on c.ProcessId = d.ProcessId
				inner join WfActivityParticipant b
					 on b.ActivityId = c.ActivityId
				inner join WfParticipant a
					 on b.ParticipantId = a.ParticipantId
			  where d.ProcessInstanceId = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
		</cfquery>

		<cfif rsPrt.CFdestino EQ 1 AND Arguments.CFdestinoId EQ -1>
			<cfthrow message="El parámetro Arguments.CFdestinoId es obligatorio para este trámite">
		</cfif>

		<cfloop query="rsPrt">
			<cfif rsPrt.ParticipantType EQ "BOSS1" OR rsPrt.ParticipantType EQ "BOSSES1">
				<cfif Arguments.CForigenId EQ "">
					<cfinvoke 	component	= "utils"
								method		= "CF_usuario"
								usucodigo	= "#Arguments.RequesterId#"
								returnvariable	 = "rsSQL"
					>
					<cfif rsSQL.CFpk EQ "">
						<cfthrow message="Usuario no está asignado a ningún Centro Funcional">
					</cfif>
					<cfset Arguments.CForigenId = rsSQL.CFpk>
					<cfquery name="rsSQL" datasource="#session.DSN#">
						update WfxProcess
						   set CForigenId = #Arguments.CForigenId#
						 where ProcessInstanceId = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
					</cfquery>
				</cfif>
				<cfif rsPrt.ParticipantType EQ "BOSS1">
					<cfinvoke 	component="utils"
								method="jefeAsistentes_cf"
								centro_funcional = "#Arguments.CForigenId#"
								pakage 			 = "#rsPrt.name#"
								returnvariable	 = "rsSQL"
					>
					<cfif rsSQL.Usucodigo EQ "">
						<cfquery name="rsSQL" datasource="#session.DSN#">
							select CFuresponsable, CFcodigo, CFdescripcion
							  from CFuncional cf
							 where CFid = #Arguments.CForigenId#
						</cfquery>
						<cfthrow message="Centro Funcional Origen '#rsSQL.CFcodigo# - #rsSQL.CFdescripcion#' no tiene definido Responsable">
					</cfif>
				<cfelse>
					<cfquery name="rsSQL" datasource="#session.DSN#">
						select o.Oficodigo, o.Ocodigo, o.Odescripcion, o.SScodigo, o.SRcodigo
						  from CFuncional cf
							inner join Oficinas o
								 on o.Ecodigo = cf.Ecodigo
								and o.Ocodigo = cf.Ocodigo
						 where CFid = #Arguments.CForigenId#
					</cfquery>
					<cfif rsSQL.SRcodigo EQ "">
						<cfthrow message="Oficina Origen '#rsSQL.Ocodigo# - #rsSQL.Odescripcion#' no tiene definido Rol de Autorizadores para trámites">
					</cfif>
					<cfquery name="rsSQL1" datasource="#session.dsn#">
						select count(1) as cantidad
						  from UsuarioRol ur
						 where ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.SScodigo#">
						   and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.SRcodigo#">
						   and ur.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
					</cfquery>
					<cfif rsSQL1.cantidad EQ 0>
						<cfthrow message="Oficina Origen '#rsSQL.Ocodigo# - #rsSQL.Odescripcion#' no tiene asignado usuarios a su Rol de Autorizadores para trámites '#trim(rsSQL.SScodigo)#.#trim(rsSQL.SRcodigo)#'">
					</cfif>
				</cfif>
			<cfelseif rsPrt.ParticipantType EQ "BOSS2">
				<cfinvoke 	component="utils"
							method="jefeAsistentes_cf"
							centro_funcional = "#Arguments.CFdestinoId#"
							pakage 			 = "#rsPrt.name#"
							returnvariable	 = "rsSQL"
				>
				<cfif rsSQL.Usucodigo EQ "">
					<cfquery name="rsSQL" datasource="#session.DSN#">
						select CFuresponsable, CFcodigo, CFdescripcion
						  from CFuncional cf
						 where CFid = #Arguments.CFdestinoId#
					</cfquery>
					<cfthrow message="Centro Funcional Destino '#rsSQL.CFcodigo# - #rsSQL.CFdescripcion#' no tiene definido Responsable">
				</cfif>
			<cfelseif rsPrt.ParticipantType EQ "BOSSES2">
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select o.Oficodigo, o.Odescripcion, o.SScodigo, o.SRcodigo
					  from CFuncional cf
						inner join Oficinas o
							 on o.Ecodigo = cf.Ecodigo
							and o.Ocodigo = cf.Ocodigo
					 where CFid = #Arguments.CFdestinoId#
				</cfquery>
				<cfif rsSQL.SRcodigo EQ "">
					<cfthrow message="Oficina Destino '#rsSQL.Oficodigo# - #rsSQL.Odescripcion#' no tiene definido Rol de Autorizadores para trámites">
				</cfif>
				<cfquery name="rsSQL1" datasource="#session.dsn#">
					select count(1) as cantidad
					  from UsuarioRol ur
					 where ur.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.SScodigo#">
					   and ur.SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.SRcodigo#">
					   and ur.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				</cfquery>
				<cfif rsSQL1.cantidad EQ 0>
					<cfthrow message="Oficina Destino '#rsSQL.Ocodigo# - #rsSQL.Odescripcion#' no tiene asignado usuarios a su Rol de Autorizadores para trámites '#trim(rsSQL.SScodigo)#.#trim(rsSQL.SRcodigo)#'">
				</cfif>
			</cfif>
		</cfloop>
		
	</cffunction>
</cfcomponent>

