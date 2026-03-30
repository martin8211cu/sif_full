<cfparam name="form.ProcessId" type="numeric">

<cfif IsDefined('form.reopen')>
<!--- chequear si hay que crear una copia de trabajo del WfProcess --->
	<cfinvoke component="sif.Componentes.Workflow.WfProcess" method="findById" returnvariable="proc">
		<cfinvokeargument name="ProcessId" value="#form.ProcessId#">
	</cfinvoke>
	<cfset proc.reopen()>
	<cflocation url="process.cfm?ProcessId=#proc.ProcessId#" addtoken="no">
<cfelseif IsDefined('form.retire')>
<!--- chequear si hay que crear una copia de trabajo del WfProcess --->
	<cfinvoke component="sif.Componentes.Workflow.WfProcess" method="findById" returnvariable="proc">
		<cfinvokeargument name="ProcessId" value="#form.ProcessId#">
	</cfinvoke>
	<cfset proc.retire()>
	<cflocation url="process.cfm?ProcessId=#proc.ProcessId#" addtoken="no">
<cfelseif IsDefined('form.delete')>
	<cfquery datasource="#session.dsn#" name="check">
		select count(1) as cnt from WfxProcess
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
	</cfquery>
	<cfif check.cnt>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSePuedeEliminarLaDefinicionDeEsteTramitePorqueYaEstaEnUso"
			Default="No se puede eliminar la definición de este trámite porque ya está en uso"
			returnvariable="MSG_NoSePuedeEliminarLaDefinicionDeEsteTramitePorqueYaEstaEnUso"/>
	
		<cfthrow message="#MSG_NoSePuedeEliminarLaDefinicionDeEsteTramitePorqueYaEstaEnUso#">
	</cfif>
	<cftransaction>
		<cfset tables = 'WfTransition,WfActualParameter,WfInvocation,WfDataField,WfActivityParticipant,WfActivity,WfProcess'>
		<cfloop list="#tables#" index="table_name">
			<cfquery datasource="#session.dsn#">
				delete from #table_name#
				where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			</cfquery>
		</cfloop>
	</cftransaction>
	<cflocation url="process_list.cfm?rand=#Rand()#">
<cfelse>

	<cfquery datasource="#session.dsn#" name="WfProcess">
		select PublicationStatus
		from WfProcess
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
	</cfquery>
	<cfif WfProcess.PublicationStatus is 'RELEASED'>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoSePuedeModificarUnTramiteQueEstaAprobado"
		Default="No se puede modificar un trámite que está aprobado"
		returnvariable="MSG_NoSePuedeModificarUnTramiteQueEstaAprobado"/>

		<cfthrow message="#MSG_NoSePuedeModificarUnTramiteQueEstaAprobado#">
	<cfelseif WfProcess.PublicationStatus is 'RETIRED' and not IsDefined('form.publish')>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoSePuedeModificarUnTramiteQueEstaRetirado"
		Default="No se puede modificar un trámite que está Retirado"
		returnvariable="MSG_NoSePuedeModificarUnTramiteQueEstaRetirado"/>

		<cfthrow message="#MSG_NoSePuedeModificarUnTramiteQueEstaRetirado#">
	</cfif>
	
	<cfif Len(Trim(form.Description)) Is 0>
		<cfset form.Description = form.Name>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update WfProcess
		set Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">,
		    Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#">,
		    Documentation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documentation#">
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
	</cfquery>
	
	<cfif IsDefined('form.publish')>
		<!--- validar si el proceso esta bien formado, valido, conexo y asignado a participantes --->
		<cfinvoke component="sif.Componentes.Workflow.WfProcess" method="findById" returnvariable="proc">
			<cfinvokeargument name="ProcessId" value="#form.ProcessId#">
		</cfinvoke>
		<cfset msg = proc.validar()>
		<cfif ArrayLen(msg)>
			<cfoutput><html><head><script type="text/javascript">
			alert('#JSStringFormat(ArrayToList(msg,Chr(13)))#');
			location.href='process_detail.cfm?r=#Rand()#&ProcessId=#form.ProcessId#';
			</script></head></html>
			</cfoutput>
			<cfabort>
		<cfelse>
			<cfif proc.PublicationStatus is 'UNDER_TEST'>
				<cfset proc.PublicationStatus = 'RELEASED'>
			<cfelse>
				<cfset proc.PublicationStatus = 'UNDER_TEST'>
				<!--- de una vez, no queremos ver el estado UNDER_TEST en estos tramites
				      porque los trámites son pequeños hasta el momento, y no requieren de
					  pruebas individuales por cada definición que se haga.
				  --->
				<cfset proc.PublicationStatus = 'RELEASED'>
			</cfif>
			<cftransaction>
				<cfset proc.update()>
				<cfquery datasource="#session.dsn#">
					update WfProcess
					set PublicationStatus = 'RETIRED'
					where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#proc.PackageId#">
					  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#">
					  and PublicationStatus = 'RELEASED'
					  <!--- todas las otras versiones quedan retiradas --->
					  and ProcessId != <cfqueryparam cfsqltype="cf_sql_numeric" value="#proc.ProcessId#">
				</cfquery>
			</cftransaction>
		</cfif>
	</cfif>
</cfif>
<cfoutput><html><head><script type="text/javascript">
window.open('process.cfm?r=#Rand()#&ProcessId=#form.ProcessId#','_top');
</script></head></html>
</cfoutput>
<!---
<cflocation url="process.cfm?r=#Rand()#&ProcessId=#form.ProcessId#">
--->

