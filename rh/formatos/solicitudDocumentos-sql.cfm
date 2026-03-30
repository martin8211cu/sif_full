<cfif isdefined("form.btnSolicitar")>
	<cfset Session.Params.ModoDespliegue = 0>
	<cfinclude template="/rh/expediente/consultas/consultas-frame-header.cfm">
	<cfquery name="rsValidaEx" datasource="#session.dsn#">
		select 1
		from CertificacionesEmpleado 
		where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
		and CSEatendida = 0
	</cfquery>
	<cfif rsValidaEx.recordcount>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorYaExisteUnaSolicitudRealizadaDeEsteTipoProcesoCancelado"
			Default="Error, Ya existe una solicitud realizada de este tipo. Proceso Cancelado!"
			returnvariable="MSG_ErrorYaExisteUnaSolicitudRealizadaDeEsteTipoProcesoCancelado"/>

		<cfthrow message="#MSG_ErrorYaExisteUnaSolicitudRealizadaDeEsteTipoProcesoCancelado#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into CertificacionesEmpleado 
		(EFid, DEid, Ecodigo, CSEfrecoge, 
		BMfechaalta, BMUsucodigo)
		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CSEfrecoge)#">, 
		<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelseif isdefined("Url.Baja")>
	<cfquery datasource="#session.dsn#">
		delete CertificacionesEmpleado 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and CSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CSEid#">
	</cfquery>
</cfif>
<cflocation url="solicitudDocumentos.cfm">