<cfcomponent displayname="Operaciones">

	<cffunction name="startProcess" access="public" returntype="numeric" output="false" >
		<cfargument name="ProcessId"			type="numeric"	required="yes">
		<cfargument name="RequesterId"			type="numeric"	required="yes">
		<cfargument name="SubjectId" 			type="numeric"	required="yes">
		<cfargument name="Description"			type="string"	required="yes">
		<cfargument name="DataItems"			type="struct"	required="yes">
		<cfargument name="TransaccionActiva"	type="boolean"	default="false" required="false">
		<cfargument name="ObtenerUltimaVer"		type="boolean" 	default="false" required="false">
		<cfargument name="CForigenId"			type="numeric"	default="-1" 	required="false">
		<cfargument name="CFdestinoId"			type="numeric"	default="-1" 	required="false">
		
		<!----Obtener la última versión del trámite RELEASED---->
		<cfif Arguments.ObtenerUltimaVer>
			<cfquery name="rsPrc" datasource="#session.DSN#">
				select upper(Name) as upper_name 
				from WfProcess p
				where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and p.ProcessId =  #Arguments.ProcessId#
			</cfquery>
			<cfquery name="rsPrc" datasource="#session.DSN#">
				select max(p.ProcessId) as ProcessId
				  from WfProcess p
					inner join WfPackage pk 
						 on pk.PackageId=p.PackageId 
						and pk.Name like 'TPRES%'				  
				where p.Ecodigo					= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and upper(p.Name)				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPrc.upper_name#">
				  and p.PublicationStatus		= 'RELEASED'
			</cfquery>
			<cfif rsPrc.recordcount GT 0 and len(rsPrc.ProcessId)>
				<cfset Arguments.ProcessId = rsPrc.ProcessId>
			</cfif>
		</cfif>

		<cfif Arguments.TransaccionActiva>
			<cfinvoke method="startProcessl" returnvariable="ProcessInstanceId"
				ProcessId="#Arguments.ProcessId#"
				RequesterId="#Arguments.RequesterId#"
				SubjectId="#Arguments.SubjectId#"
				Description="#Arguments.Description#" 
				DataItems="#Arguments.DataItems#"
				CForigenId="#Arguments.CForigenId#"
				CFdestinoId="#Arguments.CFdestinoId#" >
			</cfinvoke>
		<cfelse>
			<cftransaction>
				<cfinvoke method="startProcessl" returnvariable="ProcessInstanceId"
					ProcessId="#Arguments.ProcessId#"
					RequesterId="#Arguments.RequesterId#"
					SubjectId="#Arguments.SubjectId#"
					Description="#Arguments.Description#" 
					DataItems="#Arguments.DataItems#"
					CForigenId="#Arguments.CForigenId#"
					CFdestinoId="#Arguments.CFdestinoId#" >
				</cfinvoke>
			</cftransaction>
		</cfif>
		
		<cfreturn ProcessInstanceId>
	</cffunction>

	<cffunction name="startProcessl" access="private" returntype="numeric" output="false" >
		<cfargument name="ProcessId"   type="numeric" required="yes">
		<cfargument name="RequesterId" type="numeric" required="yes">
		<cfargument name="SubjectId" type="numeric" required="yes">
		<cfargument name="Description" type="string" required="yes">
		<cfargument name="DataItems"   type="struct" required="yes">
		<cfargument name="CForigenId"	type="numeric"	required="yes">
		<cfargument name="CFdestinoId"	type="numeric"	required="yes">
		
		<cfinvoke component="ProcessMgmt" method="startProcess" returnvariable="ProcessInstanceId">
			<cfinvokeargument name="ProcessId" value="#Arguments.ProcessId#"/>
			<cfinvokeargument name="RequesterId" value="#Arguments.RequesterId#"/>
			<cfinvokeargument name="SubjectId" value="#Arguments.SubjectId#"/>
			<cfinvokeargument name="Description" value="#Arguments.Description#" />
			<cfinvokeargument name="CForigenId" value="#Arguments.CForigenId#" />
			<cfinvokeargument name="CFdestinoId" value="#Arguments.CFdestinoId#" />
		</cfinvoke>

		<cfset DataItemName = StructKeyArray(Arguments.DataItems)>
		<cfloop from="1" to="#ArrayLen(DataItemName)#" index="i">
			<cfset setStringData(ProcessInstanceId, DataItemName[i], Arguments.DataItems[DataItemName[i]])>
		</cfloop>
		<cfinvoke component="Engine" method="forward">
			<cfinvokeargument name="ProcessInstanceId" value="#ProcessInstanceId#">
		</cfinvoke>

		<cfreturn ProcessInstanceId>
	</cffunction>

	<cffunction name="getOpenActivitiesByProcess" access="public" returntype="array">
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">

		<cfquery datasource="#session.dsn#"	name="ret">
			select ActivityInstanceId
			from WfxActivity
			where State != 'COMPLETED'
			  and ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
		</cfquery>
		<cfreturn ListToArray( ValueList ( ret.ActivityInstanceId ))>
	</cffunction>
	
	<cffunction name="queryOpenProcesses_Internal" access="private" returntype="query">
		<cfargument name="where_condition" type="string" required="yes">
		
		<cfquery datasource="#session.dsn#" name="ret">
			select
				<!--- empresa --->
				e.Ecodigo, e.Edescripcion,
				
				<!--- proceso --->
				d.ProcessId, d.DetailURL,
				coalesce (d.Description, d.Name) as ProcessDescription,
				c.ProcessInstanceId,
				c.State as ProcessState,
				c.Description as ProcessInstanceDescription,
				
				<!--- actividad --->
				f.ActivityId, coalesce (f.Description, f.Name) as ActivityDescription,
				b.ActivityInstanceId, b.StartTime, b.State,
				
				<!--- participante --->
				a.ParticipantId, a.Name as ParticipantName,
				a.Description as ParticipantDescription,
				a.Usucodigo as ParticipantUsucodigo
			from WfxActivity b
				left join WfxActivityParticipant a 
					on a.ActivityInstanceId = b.ActivityInstanceId
				join WfxProcess c
					on c.ProcessInstanceId = b.ProcessInstanceId
				join WfProcess d
					on d.ProcessId = c.ProcessId
				join WfActivity f
					on f.ActivityId = b.ActivityId
				join Empresas e
					on e.Ecodigo = c.Ecodigo
					and e.Ecodigo = #session.Ecodigo#
			where c.State != 'COMPLETE'
			  and ( 
			  		b.State != 'COMPLETED' 
				or 	
					(b.State = 'COMPLETED' and f.IsFinish = 0 and not exists (select 1 from WfxTransition t where t.FromActivityInstance = b.ActivityInstanceId))
				  )
				  
 			  #where_condition#
			order by e.Edescripcion, e.Ecodigo, c.ProcessInstanceId, b.ActivityInstanceId, a.Usucodigo
		</cfquery>
		<cfreturn ret>
	</cffunction>
    
	<cffunction name="queryOpenProcesses_InternalGestionAutorizaciones" access="private" returntype="query">
		<cfargument name="where_condition" type="string" required="yes">
       	<cfargument name="Solicitante" 	type="numeric"  required="false" hint="Id del Solicitante">
        
        <cfif NOT ISDEFINED('Arguments.Solicitante') AND ISDEFINED('session.compras.solicitante') AND LEN(TRIM(session.compras.solicitante))>
        	<cfset Arguments.Solicitante = session.compras.solicitante>
        </cfif>
		<cfquery datasource="#session.dsn#" name="ret">	
             select 		
					<!--- empresa --->
            		sc.Ecodigo, sc.ESobservacion AS Edescripcion,
                
            	<!--- proceso --->
				 sc.ESidsolicitud  as ProcessId, '' as DetailURL,
				'solicitud de compra' as ProcessDescription,
				0 as ProcessInstanceId,
				''  as ProcessState,
				'solicitud de compra' as ProcessInstanceDescription,
				
				<!--- actividad --->
				sc.ESnumero as ActivityId, sc.ESobservacion as ActivityDescription,
				sc.ProcessInstanceid  as ActivityInstanceId,sc.ESfecha as StartTime,''  as State,
				
				<!--- participante --->
				sc.NRP  as ParticipantId,''  as ParticipantName,
				''  as ParticipantDescription,
				sc.Usucodigo as ParticipantUsucodigo
		from ESolicitudCompraCM sc
				left outer join CFuncional cf					
                	on cf.CFid = sc.CFid
				left outer join Monedas 							
                	on Monedas.Mcodigo = sc.Mcodigo
				left outer join CMCompradores 				
                	on CMCompradores.CMCid = sc.CMCid
				left outer join CMSolicitantes 				
                	on CMSolicitantes.CMSid = sc.CMSid
				left outer join CMEspecializacionTSCF 
                	on CMEspecializacionTSCF.CMElinea = sc.CMElinea
				left outer join SNegocios 						
                	on SNegocios.Ecodigo = sc.Ecodigo and SNegocios.SNcodigo = sc.SNcodigo
				left outer join CMTiposSolicitud 			
                	on CMTiposSolicitud.Ecodigo = sc.Ecodigo and CMTiposSolicitud.CMTScodigo = sc.CMTScodigo
			where sc.Ecodigo  = #session.Ecodigo#
            and sc.ESestado = -10
            and sc.ESidsolicitud not in (select DOrdenCM.ESidsolicitud from DOrdenCM inner join EOrdenCM on DOrdenCM.EOidorden = EOrdenCM.EOidorden where DOrdenCM.ESidsolicitud = sc.ESidsolicitud and EOrdenCM.EOestado < 60)
			  and sc.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud from CMLineasProceso inner join CMProcesoCompra on CMProcesoCompra.CMPid = CMLineasProceso.CMPid and CMProcesoCompra.CMPestado > 0)
and (CASE 
	<!---►El Usuario es el Aprobador (más bien me parece un participante aunque no haya aprobado) del Ultimo paso del tramite (El usuario que le Dio el NRP)◄--->
			  			WHEN (select count(1)
								from WfxActivity xa
                               inner join WfxActivityParticipant xap
                                 on xap.ActivityInstanceId = xa.ActivityInstanceId
                               where xa.ProcessInstanceId = sc.ProcessInstanceid
							     and Usucodigo = #session.Usucodigo#) > 0 THEN 1
						<!---►Es el Usuario que diseño la Solicitud de Compra◄--->
                         <cfif NOT ISDEFINED('Arguments.Solicitante') AND ISDEFINED('session.compras.solicitante') AND LEN(TRIM(session.compras.solicitante))> 
                            WHEN sc.CMSid	= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.solicitante#"> THEN 1
                            ELSE 0
                        <cfelse>
                        	WHEN 1= 1 THEN 0
                        </cfif>
					END) = 1
          
		</cfquery>
       
		<cfreturn ret>
	</cffunction>
    
    <cffunction name="getWorkloadGestionAutorizaciones" access="public" returntype="query">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		
		<cfreturn queryOpenProcesses_InternalGestionAutorizaciones(' and a.Usucodigo = ' & Arguments.Usucodigo)>
	</cffunction>
    
	<cffunction name="getWorkload" access="public" returntype="query">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		
		<cfreturn queryOpenProcesses_Internal(' and a.Usucodigo = ' & Arguments.Usucodigo)>
	</cffunction>
	
	<cffunction name="getWorkloadNull" access="public" returntype="query">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		
		<cfreturn queryOpenProcesses_Internal(' and a.Usucodigo is null ')>
	</cffunction>
	
	<cffunction name="getAllOpenProcesses" access="public" returntype="query">
		<cfreturn queryOpenProcesses_Internal('')>
	</cffunction>
	
	<cffunction name="getOpenProcessesByRequester" access="public" returntype="query">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		
		<cfreturn queryOpenProcesses_Internal(' and c.RequesterId = ' & Arguments.Usucodigo)>
	</cffunction>
	
	<cffunction name="getOpenProcessesBySubject" access="public" returntype="query">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		
		<cfreturn queryOpenProcesses_Internal(' and c.SubjectId = ' & Arguments.Usucodigo)>
	</cffunction>
	
	<!--- Lista las transiciones de una Actividad o pasos que puede realizar --->
	<cffunction name="getAllowedTransitions" access="public" returntype="query">
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">

		<cfquery name="rs" datasource="#Session.DSN#">
			select b.TransitionId, b.Name, b.Description, b.Label, b.Type, 
				toA.Name as toName, toA.Description as toDescription, IsFinish
			from WfxActivity a
				join WfTransition b
					on b.FromActivity = a.ActivityId
				join WfActivity toA
					on toA.ActivityId = b.ToActivity
			where a.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
			  and not exists (
			  	select * from WfxTransition xt
				  where xt.FromActivityInstance = a.ActivityInstanceId
				    and xt.FromActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
				    and xt.TransitionId = b.TransitionId)
		</cfquery>
		<cfreturn rs>
	</cffunction>

	<cffunction name="getActivityState" access="public" output="false" >
		<cfargument name="activityInstanceId" type="numeric" required="yes" >

		<cfquery name="rs" datasource="#session.DSN#">
			select State
			from WfxActivity 
			where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#">
		</cfquery>
		<cfset rs.State>
	</cffunction>
	
	<cffunction name="startActivity" access="public" output="true" >
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">
		
		<cftransaction>
			<cfquery name="rs" datasource="#session.DSN#">
				select ProcessInstanceId
				from WfxActivity 
				where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
			</cfquery>
			<cfinvoke component="ActivityMgmt" method="setActivityState">
				<cfinvokeargument name="ActivityInstanceId" value="#Arguments.ActivityInstanceId#">
				<cfinvokeargument name="State" value="ACTIVE">
			</cfinvoke>
			<cfinvoke component="Engine" method="forward">
				<cfinvokeargument name="ProcessInstanceId" value="#rs.ProcessInstanceId#">
			</cfinvoke>
		</cftransaction>
	</cffunction>	

	<cffunction name="suspendActivity" access="public" output="true" >
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">
		
		<cftransaction>
			<cfquery name="rs" datasource="#session.DSN#">
				select ProcessInstanceId
				from WfxActivity 
				where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
			</cfquery>
			<cfinvoke component="ActivityMgmt" method="setActivityState">
				<cfinvokeargument name="ActivityInstanceId" value="#Arguments.ActivityInstanceId#">
				<cfinvokeargument name="State" value="SUSPENDED">
			</cfinvoke>
			<cfinvoke component="Engine" method="forward">
				<cfinvokeargument name="ProcessInstanceId" value="#rs.ProcessInstanceId#">
			</cfinvoke>
		</cftransaction>
	</cffunction>	

	<cffunction name="completeActivity" access="public" output="true" >
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">
		
		<cftransaction>
			<cfquery name="rs" datasource="#session.DSN#">
				select ProcessInstanceId
				from WfxActivity 
				where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityInstanceId#">
			</cfquery>
			<cfinvoke component="ActivityMgmt" method="setActivityState">
				<cfinvokeargument name="ActivityInstanceId" value="#Arguments.ActivityInstanceId#">
				<cfinvokeargument name="State" value="COMPLETED">
			</cfinvoke>
			<cfinvoke component="Engine" method="forward">
				<cfinvokeargument name="ProcessInstanceId" value="#rs.ProcessInstanceId#">
			</cfinvoke>
		</cftransaction>
	</cffunction>	
	
	<cffunction name="doTransition" access="public" output="true" >
		<cfargument name="fromActivityInstance" type="numeric" required="yes" >
		<cfargument name="TransitionId" type="numeric" required="yes" >
		<cfargument name="TransitionComments" type="string" default="" required="yes">
		
		<cftransaction>
			<cfinvoke component="TransitionMgmt" method="doTransition" returnvariable="transitionInstanceId" >
				<cfinvokeargument name="fromActivity" value="#arguments.fromActivityInstance#" >
				<cfinvokeargument name="transitionId" value="#arguments.TransitionId#" >
				<cfinvokeargument name="TransitionComments" value="#arguments.TransitionComments#" >
			</cfinvoke>
			
			<cfquery name="rs" datasource="#session.DSN#">
				select ProcessInstanceId
				from WfxActivity 
				where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.fromActivityInstance#">
			</cfquery>
			<cfinvoke component="Engine" method="forward">
				<cfinvokeargument name="ProcessInstanceId" value="#rs.ProcessInstanceId#">
			</cfinvoke>

		</cftransaction>
	</cffunction>
	
	<cffunction name="setStringData" access="public" output="false" >
		<cfargument name="processInstanceId" type="numeric" required="yes" >
		<cfargument name="name" type="string" required="yes" >
		<cfargument name="stringValue" type="string" required="yes" >
		
		<cfinvoke component="DataMgmt" method="setDataItem" >
			<cfinvokeargument name="ProcessInstanceId" value="#arguments.ProcessInstanceId#"/>
			<cfinvokeargument name="name" value="#arguments.name#"/>
			<cfinvokeargument name="stringValue" value="#arguments.stringValue#"/>
		</cfinvoke>
	</cffunction>
	
	<cffunction name="setTextData" access="public" output="false" >
		<cfargument name="processInstanceId" type="numeric" required="yes" >
		<cfargument name="name" type="string" required="yes" >
		<cfargument name="textValue" type="string" required="yes" >

		<cfinvoke component="DataMgmt" method="setDataItem" >
			<cfinvokeargument name="ProcessInstanceId" value="#arguments.ProcessInstanceId#"/>
			<cfinvokeargument name="name" value="#arguments.name#"/>
			<cfinvokeargument name="textValue" value="#arguments.textValue#"/>
		</cfinvoke>
	</cffunction>
	
	<cffunction name="setBinaryData" access="public" output="false" >
		<cfargument name="processInstanceId" type="numeric" required="yes" >
		<cfargument name="name" type="string" required="yes" >
		<cfargument name="binaryValue" type="binary" required="yes" >
		
		<cfinvoke component="DataMgmt" method="setDataItem" >
			<cfinvokeargument name="ProcessInstanceId" value="#arguments.ProcessInstanceId#"/>
			<cfinvokeargument name="name" value="#arguments.name#"/>
			<cfinvokeargument name="binaryValue" value="#arguments.binaryValue#"/>
		</cfinvoke>
	</cffunction>
	
	<cffunction name="getStringData" access="public" output="false" returntype="string">
		<cfargument name="processInstanceId" type="numeric" required="yes" >
		<cfargument name="name" type="string" required="yes" >
		
		<cfinvoke component="WfxDataItem" method="findByName" returnvariable="ret" >
			<cfinvokeargument name="ProcessInstanceId" value="#arguments.ProcessInstanceId#"/>
			<cfinvokeargument name="name" value="#arguments.name#"/>
		</cfinvoke>
		<cfreturn ret.Value>
	</cffunction>
	
	<cffunction name="getTextData" access="public" output="false" returntype="string">
		<cfargument name="processInstanceId" type="numeric" required="yes" >
		<cfargument name="name" type="string" required="yes" >
		
		<cfinvoke component="WfxDataItem" method="findByName" returnvariable="ret" >
			<cfinvokeargument name="ProcessInstanceId" value="#arguments.ProcessInstanceId#"/>
			<cfinvokeargument name="name" value="#arguments.name#"/>
		</cfinvoke>
		<cfreturn ret.TextValue>
	</cffunction>
	
	<cffunction name="getBinaryData" access="public" output="false" returntype="string">
		<cfargument name="processInstanceId" type="numeric" required="yes" >
		<cfargument name="name" type="string" required="yes" >
		
		<cfinvoke component="WfxDataItem" method="findByName" returnvariable="ret" >
			<cfinvokeargument name="ProcessInstanceId" value="#arguments.ProcessInstanceId#"/>
			<cfinvokeargument name="name" value="#arguments.name#"/>
		</cfinvoke>
		<cfreturn ret.binaryValue>
	</cffunction>
	
	<cffunction name="forward" access="public" returntype="numeric" output="true" >
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">
		
		<cftransaction>
			<cfinvoke component="Engine" method="forward" returnvariable="total">
				<cfinvokeargument name="ProcessInstanceId" value="#Arguments.ProcessInstanceId#">
			</cfinvoke>
		</cftransaction>
		<cfreturn total>
	</cffunction>
	
	<cffunction name="getDoneURL" access="public" returntype="string" output="false">
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">

		<cfquery datasource="#session.dsn#" name="hdr">
			select xp.ProcessInstanceId, p.ProcessId, p.DoneURL
			from WfxProcess xp
				join WfProcess p
					on p.ProcessId = xp.ProcessId
			where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
			  and xp.State = 'COMPLETE'
		</cfquery>
		
		<cfif Len (Trim (hdr.DoneURL))>
			<cfset link = ReplaceURLValues (hdr.DoneURL, hdr.ProcessInstanceId, hdr.ProcessId) >
			<cfreturn link>
		<cfelse>
			<cfreturn ''>
		</cfif>	
	</cffunction>
	
	<cffunction name="getDetailURL" access="public" returntype="string" output="false">
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">

		<cfquery datasource="#session.dsn#" name="hdr">
			select xp.ProcessInstanceId, p.ProcessId, p.DetailURL
			from WfxProcess xp
				join WfProcess p
					on p.ProcessId = xp.ProcessId
			where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
		</cfquery>
		
		<cfif Len (Trim (hdr.DetailURL))>
			<cfset link = ReplaceURLValues (hdr.DetailURL, hdr.ProcessInstanceId, hdr.ProcessId) >
			<cfreturn link>
		<cfelse>
			<cfreturn ''>
		</cfif>	
	</cffunction>
	
	<cffunction name="ReplaceURLValues" access="package" returntype="string" output="false">
		<cfargument name="URL"               type="string" required="yes">
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">
		<cfargument name="ProcessId"         type="numeric" required="yes">
		
		<cfquery datasource="#session.dsn#" name="DataField">
			select b.DataFieldName, b.Description, b.Label, b.InitialValue, b.Prompt, b.Length, b.Datatype,
				xdf.Value
			from WfDataField b
				left join WfxDataField xdf
					on b.DataFieldName = xdf.DataFieldName
			where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">
			  and xdf.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">
			order by b.DataFieldName
		</cfquery>
		
		<cfset link = Trim(Arguments.URL)>
		
		<cfloop query="DataField">
			<cfset link = Replace(link, '###DataField.DataFieldName###', DataField.Value, 'all')>
		</cfloop>
		
		<cfif Left(link, 1) EQ '/' AND Left (link, 5) NEQ '/cfmx'>
			<cfset link='/cfmx' & link>
		</cfif>
		
		<cfreturn link>

	</cffunction>

</cfcomponent>
