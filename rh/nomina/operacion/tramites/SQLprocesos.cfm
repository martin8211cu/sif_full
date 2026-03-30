<cfparam name="modo" default="ALTA">

<cfquery name="rsPaqueteID" datasource="#Session.DSN#">
	select convert(varchar,PackageId) as PackageId
	from WfPackage 
	where Name = 'Recursos Humanos' and Ecodigo=#session.Ecodigo#
</cfquery>
<cfif rsPaqueteID.RecordCount IS 0>
	<cfquery name="rsPaqueteID" datasource="#Session.DSN#">
		insert WfPackage (Name, Description,Ecodigo)
		values ('Recursos Humanos', 'Recursos Humanos',#session.Ecodigo#)
		select @@identity as PackageId
	</cfquery>
</cfif>
<!---
<cfquery name="rsNombreBD" datasource="#Session.DSN#">
	select db_name() as nombreBD
</cfquery>
--->

<cfif isdefined("form.Alta")>
	<cfquery name="rsNameProcess" datasource="#Session.DSN#">
		select count(*) as Cant
		from WfProcess
		where Name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">
			and PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaqueteID.PackageId#">
	</cfquery>
	
	<cfset vBandera=0>
	
	<cfif isdefined('rsNameProcess') and rsNameProcess.recordCount GT 0 and rsNameProcess.Cant GT 0>
		<cfset vBandera=1>
	</cfif>
</cfif>

<cftry>
	<cfquery name="ABC_Procesos" datasource="#Session.DSN#">
		
		<cfif isdefined("form.Alta")>
			<cfif vBandera EQ 0>
				declare @procesoNuevo numeric
	
				insert WfProcess 
				(PackageId, Name, Description, Documentation,Ecodigo)
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPaqueteID.PackageId#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documentation#">	,#session.Ecodigo#					
					)
							
				Select @procesoNuevo = @@identity
			
							
				<!--- Establece la relacion del trámite con la empresa actualmente en session  --->
				insert TramitesEmpresa(Ecodigo,RHTidtramite)	
				values(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					@procesoNuevo
					)
				
				insert WfActivity 
				(ProcessId, Name, Description,IsFinish)
				values (@procesoNuevo,
						'Paso - RECHAZADO',
						'Paso - RECHAZADO',
						1
						)
						
				declare @activFinal numeric	
				
				insert WfActivity 
				(ProcessId, Name, Description,IsFinish)
				values (@procesoNuevo,
						'Paso - COMPLETADO',
						'Paso - COMPLETADO',
						1
						)
						
				Select @activFinal = @@identity
				
				<!--- Incluye los defaults de las tablas de WfApplication, WfInvocation,
						WfFormalParameter, WfActualParameter --->	
				<cfinclude template="SQLinvocaAplicacion.cfm">
				
				<!--- Incluye los campos en WfDataField Default para RH --->
				<cfinclude template="SQLDataFieldDefault.cfm">														 														
			</cfif>

			<cfset modo = 'ALTA'>
		<cfelseif isdefined("form.Cambio")>
			update WfProcess
			set Description  = <cfqueryparam value="#form.Description#" cfsqltype="cf_sql_varchar">,
				Documentation  = <cfqueryparam value="#form.Documentation#" cfsqltype="cf_sql_varchar">
			where ProcessId = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
							  
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cfif isdefined('form.ProcessId') and form.ProcessId NEQ "">
				delete WfApplication 
				where ApplicationId = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
				delete WfActivity 
				where ProcessId = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
				<!--- Eliminacion del tramite asociado al tipo de accion en RH --->
				update RHTipoAccion
					set RHTidtramite = NULL
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHTidtramite =  <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
				<!--- Borrado de la relacion del tramite con la empresa --->
				delete TramitesEmpresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHTidtramite = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
				<!--- esto me parece que es estupido hacerlo, se pierde la historia ?
				El WfxProcess se podria borrar solamente cuando se postee o rechace una accion, o mejor,
				borrar solamente los que tengan un mes de haberse completado --->
				delete WfxProcess
				where ProcessId = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
				delete WfProcess
				where ProcessId = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
				<cfset modo = 'ALTA'>
			</cfif>
		<cfelseif isdefined("form.Baja2")>
			<!--- Borrado solo de la referencia a la tabla de TramiteEmpresa y la informaci[on del proceso
			se deja intacta en las tablas de WfProcess y sus hijas --->
			<cfif isdefined('form.ProcessId') and form.ProcessId NEQ "">
				delete TramitesEmpresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHTidtramite = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">				
			</cfif>		
			
			<cfset modo = 'ALTA'>
		<cfelseif isdefined("form.Desbloquear")>
				declare @procesoNuevo numeric
	
				insert WfProcess 
				(Ecodigo,PackageId, Name, Author, Version, PublicationStatus, Created, Description, Priority, Limit, ValidFrom, ValidTo, DurationUnit, WaitingTimeEstimation, WorkingTimeEstimation, DurationEstimation, Icon, Documentation)
					select Ecodigo, PackageId, 'Copia de: ' + Name, Author, Version, PublicationStatus, Created,  'Copia de: ' + Description, Priority, Limit, ValidFrom, ValidTo, DurationUnit, WaitingTimeEstimation, WorkingTimeEstimation, DurationEstimation, Icon, Documentation
					from WfProcess
					where ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
							
				Select @procesoNuevo = @@identity
							
				<!--- Establece la relacion del trámite con la empresa actualmente en session  --->
				insert TramitesEmpresa(Ecodigo,RHTidtramite)	
				values(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					@procesoNuevo
					)
					
				insert WfProcessResponsible (ProcessId, ParticipantId)
					select @procesoNuevo, ParticipantId
					from WfProcessResponsible
					where ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">

				insert WfDataField (ProcessId, Name, Description, Label, InitialValue, Prompt, Length, Datatype)
					select @procesoNuevo, Name, Description, Label, InitialValue, Prompt, Length, Datatype
					from WfDataField 
					where  ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
					
				insert WfApplication (ProcessId, Name, Description, Type, Location, Command, Username, Password, Pxcodigo, Documentation)
					select @procesoNuevo, Name, Description, Type, Location, Command, Username, Password, Pxcodigo, Documentation
					from WfApplication
					where ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
						and Name <> 'AplicaAccion'
						and Type <> 'PROCEDURE'
						and convert(varchar,Documentation) <> 'rh_AplicaAccion_danim'
					
				insert WfActivity(ProcessId, Name, Description, Limit, StartMode, FinishMode, Priority, Icon, ImplementationType, SplitType, JoinType, Documentation, Cost, Instantiation, WaitingTimeEstimation, WorkingTimeEstimation, DurationEstimation, IsStart, IsFinish, Ordering, NotifySubjBefore, NotifySubjAfter, NotifyPartBefore, NotifyPartAfter, NotifyReqBefore, NotifyReqAfter)
					select @procesoNuevo, Name, Description, Limit, StartMode, FinishMode, Priority, Icon, ImplementationType, SplitType, JoinType, Documentation, Cost, Instantiation, WaitingTimeEstimation, WorkingTimeEstimation, DurationEstimation, IsStart, IsFinish, Ordering, NotifySubjBefore, NotifySubjAfter, NotifyPartBefore, NotifyPartAfter, NotifyReqBefore, NotifyReqAfter
					from WfActivity
					where ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
					
				Insert WfActivityParticipant (ActivityId,ParticipantId)
					select wan.ActivityId,ParticipantId
					from WfActivityParticipant wap
						, WfActivity wan
						, WfActivity wav
					where wav.ProcessId = <cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
						and wan.ProcessId = @procesoNuevo
						and wan.Name=wav.Name
						and wap.ActivityId=wav.ActivityId
						
				declare @activFinal numeric
				
				Select @activFinal = ActivityId from WfActivity
				where ProcessId=@procesoNuevo
					and IsFinish=1
					and Name='Paso - COMPLETADO'
					and Description='Paso - COMPLETADO'					
						
				<!--- Incluye los defaults de las tablas de WfApplication, WfInvocation,
						WfFormalParameter, WfActualParameter --->	
				<cfinclude template="SQLinvocaAplicacion.cfm">
				
				insert WfTransition 
				(ProcessId, FromActivity, ToActivity, Name, Description, Label, Loop, Type, Condition)
					Select @procesoNuevo, n1.ActivityId as FromActivity, n2.ActivityId as ToActivity, t.Name, t.Description, Label, Loop, Type, Condition
					from WfTransition t
						, WfActivity n1
						, WfActivity v1
						, WfActivity n2
						, WfActivity v2
					where t.ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
						and v1.ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
						and v1.ActivityId=t.FromActivity
						and n1.ProcessId=@procesoNuevo
						and n1.Name=v1.Name
						and v2.ProcessId=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
						and v2.ActivityId=t.ToActivity
						and n2.ProcessId=@procesoNuevo
						and n2.Name=v2.Name				
				
				<!--- Actualizacion de los tipos de acciones que estaban relacionadas con el proceso
					al cual se le realizo la copia. Estos tipos de acciones se pondr[an a apuntar
					al nuevo proceso que se creo autom[aticamente, es decir, a la copia del proceso viejo --->
				Update RHTipoAccion set RHTidtramite= @procesoNuevo
				where RHTidtramite=<cfqueryparam value="#form.ProcessId#" cfsqltype="cf_sql_numeric">
				
			<cfset modo = 'ALTA'>				
		</cfif>
						
	</cfquery>	

<cfcatch type="database">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<cfif isdefined("form.Alta") and isdefined('vBandera') and vBandera EQ 1>
	<script language="JavaScript" type="text/javascript">
		alert('Ya existe un trámite con el nombre de <cfoutput>#form.Name#</cfoutput>, favor de digitar un nombre diferente, gracias.')
	</script>
</cfif>

<cfoutput>
<form action="procesos.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="ProcessId"   type="hidden" value="<cfif isdefined("form.Cambio") and isdefined("form.ProcessId") and form.ProcessId NEQ "">#form.ProcessId#</cfif>">	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>