<cfcomponent>
	<cfproperty name="ProcessId"             type="numeric" displayname="ProcessId"             hint="">
	<cfproperty name="PackageId"             type="numeric" displayname="PackageId"             hint="">
	<cfproperty name="Name"                  type="string"  displayname="Name"                  hint="">
	<cfproperty name="Author"                type="string"  displayname="Author"                hint="">
	<cfproperty name="Version"               type="string"  displayname="Version"               hint="">
	<cfproperty name="PublicationStatus"     type="string"  displayname="PublicationStatus"     hint="">
	<cfproperty name="Created"               type="date"    displayname="Created"               hint="">
	<cfproperty name="Description"           type="string"  displayname="Description"           hint="">
	<cfproperty name="Priority"              type="numeric" displayname="Priority"              hint="">
	<cfproperty name="Limit"                 type="numeric" displayname="Limit"                 hint="">
	<cfproperty name="ValidFrom"             type="date"    displayname="ValidFrom"             hint="">
	<cfproperty name="ValidTo"               type="date"    displayname="ValidTo"               hint="">
	<cfproperty name="DurationUnit"          type="string"  displayname="DurationUnit"          hint="">
	<cfproperty name="WaitingTimeEstimation" type="numeric" displayname="WaitingTimeEstimation" hint="">
	<cfproperty name="WorkingTimeEstimation" type="numeric" displayname="WorkingTimeEstimation" hint="">
	<cfproperty name="DurationEstimation"    type="numeric" displayname="DurationEstimation"    hint="">
	<cfproperty name="Icon"                  type="string"  displayname="Icon"                  hint="">
	<cfproperty name="Documentation"         type="string"  displayname="Documentation"         hint="">
	<cfproperty name="Ecodigo"               type="numeric" displayname="Ecodigo"               hint="">
	<cfproperty name="DetailURL"             type="string"  displayname="DetailURL"             hint="">
	<cfproperty name="DoneURL"               type="string"  displayname="DoneURL"               hint="">

 	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfProcess">
		<cfset This.ProcessId = 0>
		<cfset This.PackageId = 0>
		<cfset This.Name = ''>
		<cfset This.Author = session.usuario>
		<cfset This.Version = '1.0.0'>
		<cfset This.PublicationStatus = 'UNDER_REVISION'>
		<cfset This.Created = Now()>
		<cfset This.Description = ''>
		<cfset This.Priority  = 3>
		<cfset This.Limit = ''>
		<cfset This.ValidFrom = ''>
		<cfset This.ValidTo = ''>
		<cfset This.DurationUnit = 'h'>
		<cfset This.WaitingTimeEstimation = 0>
		<cfset This.WorkingTimeEstimation = 0>
		<cfset This.DurationEstimation = 0>
		<cfset This.Icon = ''>
		<cfset This.Documentation = ''>
		<cfset This.Ecodigo = session.Ecodigo>
		<cfset This.DetailURL = ''>
		<cfset This.DoneURL = ''>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="findByName" output="true" returntype="WfProcess" access="public">
		<cfargument name="PackageId" type="numeric" required="yes">
		<cfargument name="Name" type="string" required="yes">
		<cfargument name="Version" type="string" required="no">
	
		<cfquery datasource="#session.dsn#" name="data" maxrows="1">
			select *
			from WfProcess
			where PackageId = <cfqueryparam cfsqltype="cf_sql_numerid" value="#Arguments.PackageId#">
			  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Name#">
			<cfif IsDefined('Arguments.Version')>
			  and Version = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Version#">
			<cfelse>
			order by Version desc
			</cfif>
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfProcess" access="public">
		<cfargument name="ProcessId" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfProcess
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="new_name" returntype="string">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Tramite"
			Default="Trámite "
			returnvariable="LB_Tramite"/>

		<cfset NewName = LB_Tramite>
		<cfquery datasource="#session.dsn#" name="NameSearch">
			select Name
			from WfProcess
			where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.PackageId#">
			  and Name like '#NewName#%'
		</cfquery>
		<cfset MaxNumber = 0>
		<cfloop query="NameSearch">
			<cfset ThisNumber = Mid(NameSearch.Name, Len(NewName)+1, 5)>
			<cfif IsNumeric(ThisNumber) And (ThisNumber + 0) GT MaxNumber >
				<cfset MaxNumber = ThisNumber>
			</cfif>
		</cfloop>
		<cfset NewName = NewName & ( MaxNumber + 1 ) >
		<cfreturn NewName>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfif This.ProcessId>
			<cfquery datasource="#session.dsn#">
				UPDATE WfProcess
				   SET PackageId = <cfqueryparam value='#This.PackageId#' cfsqlType='cf_sql_numeric'>
					 , Name = <cfqueryparam value='#This.Name#' cfsqlType='cf_sql_varchar'>
					 , Author = <cfqueryparam value='#This.Author#' cfsqlType='cf_sql_varchar'>
					 , Version = <cfqueryparam value='#utils.version_formato(This.Version)#' cfsqlType='cf_sql_varchar'>
					 , PublicationStatus = <cfqueryparam value='#This.PublicationStatus#' cfsqlType='cf_sql_varchar'>
					 , Created = <cfqueryparam value='#This.Created#' cfsqlType='cf_sql_timestamp'>
					 , Description = <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
					 , Priority = <cfqueryparam value='#This.Priority#' cfsqlType='cf_sql_tinyint'>
					 , Limit = <cfqueryparam value='#This.Limit#' cfsqlType='cf_sql_decimal' scale='4' null='#Len(Trim(This.Limit)) IS 0#'>
					 , ValidFrom = <cfqueryparam value='#This.ValidFrom#' cfsqlType='cf_sql_timestamp' null='#Len(Trim(This.ValidFrom)) IS 0#'>
					 , ValidTo = <cfqueryparam value='#This.ValidTo#' cfsqlType='cf_sql_timestamp' null='#Len(Trim(This.ValidTo)) IS 0#'>
					 , DurationUnit = <cfqueryparam value='#This.DurationUnit#' cfsqlType='cf_sql_char'>
					 , WaitingTimeEstimation = <cfqueryparam value='#This.WaitingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
					 , WorkingTimeEstimation = <cfqueryparam value='#This.WorkingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
					 , DurationEstimation = <cfqueryparam value='#This.DurationEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
					 , Icon = <cfqueryparam value='#This.Icon#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Icon)) IS 0#'>
					 , Documentation = <cfqueryparam value='#This.Documentation#' cfsqlType='cf_sql_text' null='#Len(Trim(This.Documentation)) IS 0#'>
				     , Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#This.Ecodigo#">
					 , DetailURL = <cfqueryparam value='#This.DetailURL#' cfsqlType='cf_sql_text' null='#Len(Trim(This.DetailURL)) IS 0#'>
					 , DoneURL = <cfqueryparam value='#This.DoneURL#' cfsqlType='cf_sql_text' null='#Len(Trim(This.DoneURL)) IS 0#'>
				 WHERE WfProcess.ProcessId = <cfqueryparam value='#ProcessId#' cfsqlType='cf_sql_numeric'>

			</cfquery>
		<cfelse>
			<cfif Len(This.Name) Is 0>
				<cfset This.Name = This.new_name()>
			</cfif>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfProcess
			   ( PackageId
			   , Name
			   , Author
			   , Version
			   , PublicationStatus
			   , Created
			   , Description
			   , Priority
			   , Limit
			   , ValidFrom
			   , ValidTo
			   , DurationUnit
			   , WaitingTimeEstimation
			   , WorkingTimeEstimation
			   , DurationEstimation
			   , Icon
			   , Documentation
			   , Ecodigo
			   , DetailURL
			   , DoneURL
			   )
		VALUES ( <cfqueryparam value='#This.PackageId#' cfsqlType='cf_sql_numeric'>
			   , <cfqueryparam value='#This.Name#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Author#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#utils.version_formato(This.Version)#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.PublicationStatus#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Created#' cfsqlType='cf_sql_timestamp'>
			   , <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Priority#' cfsqlType='cf_sql_tinyint'>
			   , <cfqueryparam value='#This.Limit#' cfsqlType='cf_sql_decimal' scale='4' null='#Len(Trim(This.Limit)) IS 0#'>
			   , <cfqueryparam value='#This.ValidFrom#' cfsqlType='cf_sql_timestamp' null='#Len(Trim(This.ValidFrom)) IS 0#'>
			   , <cfqueryparam value='#This.ValidTo#' cfsqlType='cf_sql_timestamp' null='#Len(Trim(This.ValidTo)) IS 0#'>
			   , <cfqueryparam value='#This.DurationUnit#' cfsqlType='cf_sql_char'>
			   , <cfqueryparam value='#This.WaitingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
			   , <cfqueryparam value='#This.WorkingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
			   , <cfqueryparam value='#This.DurationEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
			   , <cfqueryparam value='#This.Icon#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Icon)) IS 0#'>
			   , <cfqueryparam value='#This.Documentation#' cfsqlType='cf_sql_text' null='#Len(Trim(This.Documentation)) IS 0#'>
			   , <cfqueryparam cfsqltype="cf_sql_integer" value="#This.Ecodigo#">
			   , <cfqueryparam value='#This.DetailURL#' cfsqlType='cf_sql_text' null='#Len(Trim(This.DetailURL)) IS 0#'>
			   , <cfqueryparam value='#This.DoneURL#' cfsqlType='cf_sql_text' null='#Len(Trim(This.DoneURL)) IS 0#'>
			   )
			  <cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="inserted">
			<cfset This.ProcessId = inserted.identity>
		</cfif>
	</cffunction>
	
	<cffunction name="validar" returntype="array">
		<!---
			Debe validar:
			a) Que las actividades estén conectadas
			b) Que las actividades de inicio no tengan transiciones entrantes
			c) Que las actividades de fin no tengan transiciones salientes
			d) Que las actividades de no inicio ni fin tengan transiciones entrantes y salientes
			e) Que las actividades tengan usuarios que las puedan iniciar, por ejemplo,
			   que los usuarios responsables de una tarea tengan acceso al portal.
			otras opciones (para después, version 1.01)
				- que no haya más de una transición con el mismo (origen,destino)
				- que no haya más de una transición con el mismo (origen,condicion)
				y otras
		--->
		<cfset msg = ArrayNew(1)>
		
		<!--- a) Que las actividades estén conectadas --->
		<cfquery datasource="#session.dsn#" name="act_start">
			select ActivityId
			from WfActivity
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and IsStart = 1
		</cfquery>
		<cfquery datasource="#session.dsn#" name="act_finish">
			select ActivityId
			from WfActivity
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and IsFinish = 1
		</cfquery>
		<cfif act_start.RecordCount is 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElProcesoNoTieneNingunaActividadDeInicio"
			Default="El proceso no tiene ninguna actividad de inicio "
			returnvariable="MSG_ElProcesoNoTieneNingunaActividadDeInicio"/>

			<cfset ArrayAppend( msg , " #MSG_ElProcesoNoTieneNingunaActividadDeInicio#" )>
		</cfif>
		<cfif act_finish.RecordCount is 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElProcesoNoTieneActividadFinal"
			Default="El proceso no tiene actividad final "
			returnvariable="MSG_ElProcesoNoTieneActividadFinal"/>
			<cfset ArrayAppend( msg , " #MSG_ElProcesoNoTieneActividadFinal#" )>
		</cfif>
		<cfset Actividades_Alcanzables = ValueList(act_start.ActivityId)>
		<cfif Len(Actividades_Alcanzables)>
			<cfset has_finish = false>
			<cfloop from="0" to="99" index="dummy">
				<cfif dummy is 99>
					<cf_errorCode	code = "51410" msg = "Me enlupé!">
				</cfif>
				<cfquery datasource="#session.dsn#" name="next_level">
					select a.ToActivity, b.IsFinish
					from WfTransition a
						join WfActivity b
							on a.ToActivity = b.ActivityId
					where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
					  and a.FromActivity in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Actividades_Alcanzables#" list="yes">)
					  and a.ToActivity not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Actividades_Alcanzables#" list="yes">)
				</cfquery>
				<cfif next_level.RecordCount is 0><cfbreak></cfif>
				<cfif ListFind(ValueList(next_level.IsFinish), '1') Or  ListFind(ValueList(next_level.IsFinish), 'true')>
					<cfset has_finish = true>
				</cfif>
				<cfset Actividades_Alcanzables = Actividades_Alcanzables & ',' & ValueList(next_level.ToActivity)>
			</cfloop>
			<cfquery datasource="#session.dsn#" name="con_error">
				select ActivityId, Name
				from WfActivity a
				where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
				  and a.ActivityId not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Actividades_Alcanzables#" list="yes">)
				  <cfif has_finish>
				  <!--- se permiten actividades sueltas si el tramite tiene por donde
				  		terminar, y además, estas actividades sueltas son finales
					--->
				  and a.IsFinish = 0
				  </cfif>
				order by upper(a.Name)
			</cfquery>
			<cfif con_error.RecordCount>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ActividadesInalcanzables"
				Default="Actividades inalcanzables "
				returnvariable="MSG_ActividadesInalcanzables"/>
				<cfset ArrayAppend( msg , " #MSG_ActividadesInalcanzables#: #ValueList(con_error.Name)#" )>
			</cfif>
		</cfif>
		<!--- b) Que las actividades de inicio no tengan tr	ansiciones entrantes --->
		<cfquery datasource="#session.dsn#" name="con_error">
			select a.Name
			from WfActivity a, WfTransition b
			where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and a.IsFinish = 1
			  and b.FromActivity = a.ActivityId
			order by a.Name
		</cfquery>
		<cfif con_error.RecordCount>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EstasActividadesFinalesNoDebenTenerOtraActividadDespuesDeEllas"
			Default="Estas actividades finales no deben tener otra actividad después de ellas "
			returnvariable="MSG_EstasActividadesFinalesNoDebenTenerOtraActividadDespuesDeEllas"/>
			<cfset ArrayAppend( msg , " #MSG_EstasActividadesFinalesNoDebenTenerOtraActividadDespuesDeEllas#: #ValueList(con_error.Name)#" )>
		</cfif>
		
		<!--- c) Que las actividades de fin no tengan transiciones salientes --->
		<cfquery datasource="#session.dsn#" name="con_error">
			select a.Name
			from WfActivity a, WfTransition b
			where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and a.IsStart = 1
			  and b.ToActivity = a.ActivityId
			order by upper(a.Name)
		</cfquery>
		<cfif con_error.RecordCount>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EstasActividadesIncialesNoDebenTenerOtraActividadAntesDeEllas"
			Default="Estas actividades iniciales no deben tener otra actividad antes de ellas "
			returnvariable="MSG_EstasActividadesIncialesNoDebenTenerOtraActividadAntesDeEllas"/>
			<cfset ArrayAppend( msg , " #MSG_EstasActividadesIncialesNoDebenTenerOtraActividadAntesDeEllas#: #ValueList(con_error.Name)#" )>
		</cfif>
		
		<!--- d) Que las actividades de no inicio ni fin tengan transiciones entrantes y salientes
				-- esto no es necesario validaro, porque ya nos aseguramos de que el grafo sea conexo (punto a)
		--->
		
		<!--- e) Que las actividades tengan usuarios que las puedan iniciar, por ejemplo,
			   que los usuarios responsables de una tarea tengan acceso al portal. --->
		<cfquery datasource="#session.dsn#" name="con_error">
			select distinct a.Name
			from WfActivity a
				join WfTransition t
					on t.FromActivity = a.ActivityId
			where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and t.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and t.Type = 'MANUAL'
			  and a.ReadOnly = 0  <!--- no incluir las actividades no modificables --->
			  and not exists (
			  		select *
			  		from WfActivityParticipant ap
					where ap.ActivityId = a.ActivityId)
			order by a.Name
		</cfquery>
		<cfif con_error.RecordCount>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EstasActividadesNoTienenParticipantes"
			Default="Estas actividades no tienen participantes "
			returnvariable="MSG_EstasActividadesNoTienenParticipantes"/>

			<cfset ArrayAppend( msg , " #MSG_EstasActividadesNoTienenParticipantes#: #ValueList(con_error.Name)#" )>
		</cfif>
		
		<cfreturn msg>
	</cffunction>
	
	<cffunction name="reopen" access="public">
		<cftransaction>
			<cfset orig_ProcessId = This.ProcessId>
			<cfset This.ProcessId = 0>
			<cfquery datasource="#session.dsn#" name="max_version">
				select Version
				from WfProcess
				where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.PackageId#">
				  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Name#">
			</cfquery>
			<cfset This.Version = utils.version_incrementa(max_version)>
			<cfset This.PublicationStatus = 'UNDER_REVISION'>
			<cfset This.update()>
			
			<cfquery datasource="#session.dsn#">
				insert into WfDataField (ProcessId, DataFieldName, Description, Label, InitialValue, Prompt, Length, Datatype)
				select #This.ProcessId#, DataFieldName, Description, Label, InitialValue, Prompt, Length, Datatype
				from WfDataField
				where ProcessId = #orig_ProcessId#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into WfActivity (
					    ProcessId, 			Name, Description, Limit, StartMode, FinishMode, Priority, Icon, ImplementationType, SplitType, JoinType, Documentation, Cost, Instantiation, WaitingTimeEstimation, WorkingTimeEstimation, DurationEstimation, IsStart, IsFinish, Ordering, NotifySubjBefore, NotifySubjAfter, NotifyPartBefore, NotifyPartAfter, NotifyReqBefore, NotifyReqAfter, NotifyAllBefore, NotifyAllAfter, SymbolData, ReadOnly
				)
				select #This.ProcessId#, 	Name, Description, Limit, StartMode, FinishMode, Priority, Icon, ImplementationType, SplitType, JoinType, Documentation, Cost, Instantiation, WaitingTimeEstimation, WorkingTimeEstimation, DurationEstimation, IsStart, IsFinish, Ordering, NotifySubjBefore, NotifySubjAfter, NotifyPartBefore, NotifyPartAfter, NotifyReqBefore, NotifyReqAfter, NotifyAllBefore, NotifyAllAfter, SymbolData, ReadOnly
				from WfActivity
				where ProcessId = #orig_ProcessId#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into WfTransition (ProcessId, FromActivity, ToActivity, Name, Description, Label, Loop, Type, Condition, SymbolData, ReadOnly, NotifyEveryone, AskForComments, NotifyRequester)
				select #This.ProcessId#, new_from.ActivityId new_from, new_to.ActivityId new_to, t.Name, t.Description, t.Label, t.Loop, t.Type, t.Condition, t.SymbolData, t.ReadOnly, t.NotifyEveryone, t.AskForComments, t.NotifyRequester
				from WfTransition t
					join WfActivity old_from on old_from.ProcessId = #orig_ProcessId# and t.FromActivity = old_from.ActivityId 
					join WfActivity old_to   on old_to  .ProcessId = #orig_ProcessId# and t.ToActivity   = old_to.ActivityId
					join WfActivity new_from on new_from.ProcessId = #This.ProcessId# and new_from.Name = old_from.Name 
					join WfActivity new_to   on new_to  .ProcessId = #This.ProcessId# and new_to  .Name = old_to  .Name
				where t.ProcessId = #orig_ProcessId#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into WfActivityParticipant (ActivityId, ProcessId, ParticipantId)
				select a_new.ActivityId, #This.ProcessId#, ap.ParticipantId
				from WfActivityParticipant ap
					join WfActivity a_old on a_old.ProcessId = #orig_ProcessId# and a_old.ActivityId = ap.ActivityId
					join WfActivity a_new on a_new.ProcessId = #This.ProcessId# and a_new.Name       = a_old.Name
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into WfInvocation (ActivityId, ProcessId, ApplicationName, Execution)
				select act_new.ActivityId, #This.ProcessId#, inv_old.ApplicationName, inv_old.Execution
				from WfInvocation inv_old
					join WfActivity act_old on act_old.ProcessId = #orig_ProcessId# and act_old.ActivityId = inv_old.ActivityId
					join WfActivity act_new on act_new.ProcessId = #This.ProcessId# and act_new.Name = act_old.Name
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into WfActualParameter (ActivityId, ProcessId, ApplicationName, ParameterName, Value, DataFieldName, Datatype)
				select act_new.ActivityId, #This.ProcessId#, apar_old.ApplicationName, apar_old.ParameterName, apar_old.Value, apar_old.DataFieldName, apar_old.Datatype
				from WfActualParameter apar_old
					join WfActivity act_old on act_old.ProcessId = #orig_ProcessId# and act_old.ActivityId = apar_old.ActivityId
					join WfActivity act_new on act_new.ProcessId = #This.ProcessId# and act_new.Name = act_old.Name
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction name="retire" access="public">
		<cfset This.PublicationStatus = 'RETIRED'>
		<cfset This.update()>
	</cffunction>
</cfcomponent>

