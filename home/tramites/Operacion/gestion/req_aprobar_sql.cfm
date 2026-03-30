<cfquery datasource="#session.tramites.dsn#" name="tipo">
	select  id_tipoident from TPPersona 	
	where  id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="update">
	update TPInstanciaRequisito set
	completado 		=	1,
	fecha_registro  = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	BMUsucodigo   	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
	and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
</cfquery>	

<cflocation url="/cfmx/home/tramites/Operacion/gestion/gestion-form.cfm?identificacion_persona=#
	form.id_persona#&id_tipoident=#tipo.id_tipoident#&id_tramite=#form.id_tramite#&loc=gestion">
