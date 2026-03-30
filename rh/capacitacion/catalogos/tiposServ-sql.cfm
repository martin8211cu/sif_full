<cfif isdefined ('Alta')>
	<cfquery name="rsVal" datasource="#session.dsn#">
		select count(1) as cantidad from RHTiposServ where RHTScodigo=<cfqueryparam value="#form.cod#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif rsVal.cantidad gt 0>
		<cf_errorCode	code="51867" msg="Error! Ese código ya fue registrado.">
	</cfif>
	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into RHTiposServ (RHTScodigo,RHTSdescripcion,Ecodigo,Usucodigo,fecha)
		values(<cfqueryparam value="#form.cod#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#form.des#" cfsqltype="cf_sql_varchar">,
		#session.Ecodigo#,
		#session.Usucodigo#,
		#now()#)
	<cf_dbidentity1 datasource="#session.DSN#" name="rsIns">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsIns" returnvariable="LvarRHTSid">
	<cflocation url="tiposServ.cfm?RHTSid=#LvarRHTSid#">
</cfif>

<cfif isdefined ('Nuevo')>
	<cflocation url="tiposServ.cfm">
</cfif>

<cfif isdefined ('Cambio')>
	<cfquery name="rsIns" datasource="#session.dsn#">
		update RHTiposServ 
		set RHTScodigo=<cfqueryparam value="#form.cod#" cfsqltype="cf_sql_varchar">
		,RHTSdescripcion=<cfqueryparam value="#form.des#" cfsqltype="cf_sql_varchar">
		where RHTSid=#form.RHTSid#
	</cfquery>
	<cflocation url="tiposServ.cfm?RHMid=#form.RHTSid#">
</cfif>

<cfif isdefined ('Baja')>
	<cfquery name="rsIns" datasource="#session.dsn#">
		delete from RHTiposServ 
		where RHTSid=#form.RHTSid#
	</cfquery>
	<cflocation url="tiposServ.cfm">
</cfif>
