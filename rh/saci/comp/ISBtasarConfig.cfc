<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBtasarConfig">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="hostname" type="string" required="Yes"  displayname="Servidor (hostname)">
  <cfargument name="procesos" type="numeric" required="Yes"  displayname="Número de procesos">
  <cfargument name="maxFilas" type="numeric" required="Yes"  displayname="Tamaño del bloque">
  <cfargument name="httpHost" type="string" required="Yes"  displayname="Host HTTP">
  <cfargument name="httpPort" type="numeric" required="Yes"  displayname="Puerto HTTP">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBtasarConfig"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="hostname"
				type1="char"
				value1="#Arguments.hostname#">
	<cfquery datasource="#session.dsn#">
		update ISBtasarConfig
		set procesos = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.procesos#" null="#Len(Arguments.procesos) Is 0#">
		, maxFilas = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.maxFilas#" null="#Len(Arguments.maxFilas) Is 0#">
		, httpHost = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.httpHost#" null="#Len(Arguments.httpHost) Is 0#">
		
		, httpPort = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.httpPort#" null="#Len(Arguments.httpPort) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where hostname = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.hostname#" null="#Len(Arguments.hostname) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="hostname" type="string" required="Yes"  displayname="Servidor (hostname)">

	<cfquery datasource="#session.dsn#">
		delete ISBtasarConfig
		where hostname = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.hostname#" null="#Len(Arguments.hostname) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="hostname" type="string" required="Yes"  displayname="Servidor (hostname)">
  <cfargument name="procesos" type="numeric" required="Yes"  displayname="Número de procesos">
  <cfargument name="maxFilas" type="numeric" required="Yes"  displayname="Tamaño del bloque">
  <cfargument name="httpHost" type="string" required="Yes"  displayname="Host HTTP">
  <cfargument name="httpPort" type="numeric" required="Yes"  displayname="Puerto HTTP">

	<cfquery datasource="#session.dsn#">
		insert into ISBtasarConfig (
			
			hostname,
			procesos,
			maxFilas,
			httpHost,
			
			httpPort,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.hostname#" null="#Len(Arguments.hostname) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.procesos#" null="#Len(Arguments.procesos) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.maxFilas#" null="#Len(Arguments.maxFilas) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.httpHost#" null="#Len(Arguments.httpHost) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.httpPort#" null="#Len(Arguments.httpPort) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

