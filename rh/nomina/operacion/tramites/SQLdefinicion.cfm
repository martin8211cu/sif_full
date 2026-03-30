<cfset modo="ALTA">
<cfset vProcessId= "-1">

<cfquery name="rsPaqueteID" datasource="#Session.DSN#">
	select convert(varchar,PackageId) as PackageId
	from WfPackage 
	where Name = 'Recursos Humanos' and Ecodigo=#session.Ecodigo#
</cfquery>

<cfif isdefined('form.ProcessId') and form.ProcessId NEQ "">
	<cfquery name="rsActiv" datasource="#Session.DSN#">
		select convert(varchar,ActivityId) as ActivityId,Name
		from WfActivity 
		where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
		order by ActivityId
	</cfquery>
	
	<cfquery name="rsPasoComplet" dbtype="query">
		select ActivityId
		from rsActiv 
		where Name = 'Paso - COMPLETADO'
	</cfquery>
	
	<cfquery name="rsPasoRechaz" dbtype="query">
		select ActivityId
		from rsActiv 
		where Name = 'Paso - RECHAZADO'
	</cfquery>

 	<cfquery name="rsTransit" datasource="#Session.DSN#">
		select convert(varchar,isnull(max(TransitionId),0)) as TransitionId
		from WfTransition
		where ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
		and ToActivity=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPasoComplet.ActivityId#">
	</cfquery>			

	<cfset vProcessId= form.ProcessId>
</cfif>

<cfset vUltActiv= "-1"> 
	<cfif not isdefined("Form.Nuevo") and not isdefined("Form.revisar")>
		<!--- <cfif isdefined("Form.Aceptar") or isdefined("Form.Cambiar")>
			<!--- Carga de los participantes en un arreglo de Recordsets ('arrayPartic') 
			en donde cada registro es un participante, y este arreglo se utiliza
			en el include "SQLparticipXActiv.cfm"		--->	
			<cfinclude template="cargaParticipantes.cfm">
		</cfif>--->	
	
		<cftransaction>
			<cfif isdefined("Form.Aceptar")>
				<!--- ALTA --->	
				<cfinclude template="SQLAltaTramites.cfm">
			<cfelseif isdefined("Form.Cambiar") and isdefined('form.ActivityId') and form.ActivityId NEQ "" and isdefined('form.ProcessId') and form.ProcessId NEQ "">
				<!--- CAMBIO --->
				<cfinclude template="SQLCambioTramites.cfm">
			<cfelseif isdefined("Form.Borrar") and isdefined('form.ActivityId') and form.ActivityId NEQ "" and isdefined('form.ProcessId') and form.ProcessId NEQ "">
				<!--- BAJA --->	
				<cfinclude template="SQL_BajaTramites.cfm">
			<cfelseif isdefined("Form.ParticABorrar") and form.ParticABorrar NEQ "" and isdefined('form.ActivityId') and form.ActivityId NEQ "">					
				<!--- BAJA Participantes --->
				<cfquery name="B_WfActivityParticipant" datasource="#Session.DSN#">
					delete WfActivityParticipant 
					where ActivityId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActivityId#">
						and ParticipantId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ParticABorrar#">
				</cfquery>
				
				<cfset modo="CAMBIO">					
			</cfif>
		</cftransaction>
	</cfif>

	<form action="definicion.cfm" method="post" name="sql">
		<input name="ProcessId" type="hidden" value="<cfif isdefined("vProcessId")><cfoutput>#vProcessId#</cfoutput></cfif>">
		<input name="ActivityId" type="hidden" value="<cfif modo EQ "CAMBIO" and isdefined("form.ActivityId") and form.ActivityId NEQ ""><cfoutput>#form.ActivityId#</cfoutput></cfif>">		
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">		
	</form>	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>