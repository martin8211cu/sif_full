<cfif action is 'svc.inc'>
	<cfquery datasource="#session.dsn#">
		update ISBtasarConfig
		set procesos = procesos + 1
		where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hostname#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="config">
		select httpHost, httpPort
		from ISBtasarConfig
		where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hostname#">
	</cfquery>
	<cfset task_url = "http://#config.httpHost#:#config.httpPort#/cfmx/saci/tasks/tasacion.cfm">
	<cfoutput>URL:#task_url#</cfoutput>
	<cfhttp url="#task_url#" timeout="1" throwonerror="no"/>
<cfelseif action is 'svc.dec'>
	<cfquery datasource="#session.dsn#">
		update ISBtasarConfig
		set procesos = procesos - 1
		where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hostname#">
		  and procesos > 0
	</cfquery>
<cfelseif action is 'run'>
	<cfinvoke component="saci.comp.tasacion" method="start"
		datasource="#session.dsn#"
		servicio="#url.servicio#"/>
	<cfinvoke component="saci.comp.tasacion" method="run"
		datasource="#session.dsn#"
		servicio="#url.servicio#"/>
	<cflocation url="index.cfm?servicio=#URLEncodedFormat(url.servicio)#">
<cfelseif action is 'stop'>
	<cfinvoke component="saci.comp.tasacion" method="stop"
		datasource="#session.dsn#"
		servicio="#url.servicio#"/>
<cfelseif action is 'inserthost'>
	<cfinvoke component="saci.comp.ISBtasarConfig"
		method="Alta"  >
		<cfinvokeargument name="hostname" value="#form.hostname#">
		<cfinvokeargument name="procesos" value="#form.procesos#">
		<cfinvokeargument name="maxFilas" value="#form.maxFilas#">
		<cfinvokeargument name="httpHost" value="#form.httpHost#">
		<cfinvokeargument name="httpPort" value="#form.httpPort#">
	</cfinvoke>
<cfelseif action is 'updatehost'>
	<cfinvoke component="saci.comp.ISBtasarConfig"
		method="Cambio" >
		<cfinvokeargument name="hostname" value="#form.hostname#">
		<cfinvokeargument name="procesos" value="#form.procesos#">
		<cfinvokeargument name="maxFilas" value="#form.maxFilas#">
		<cfinvokeargument name="httpHost" value="#form.httpHost#">
		<cfinvokeargument name="httpPort" value="#form.httpPort#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
	<cfset included=1>
	<cfset url.hostname=form.hostname>
		<html><head></head><body>
		<cfinclude template="config-page-list.cfm">
		<cfinclude template="config-form-host.cfm">
		<script type="text/javascript">
			window.parent.cp(window.parent.o(document, 'contenedor'));
			window.parent.cp(window.parent.o(document, 'contenedor_lista'), 'contenedor_lista');
		</script>
		</body></html>
	<cfabort>
<cfelseif action is 'borrarhost'>
	<cfinvoke component="saci.comp.ISBtasarConfig"
		method="Baja" >
		<cfinvokeargument name="hostname" value="#form.hostname#">
	</cfinvoke>
</cfif>

<cfset url.lista = 'yes'>
<cfinclude template="config-page-list.cfm">
