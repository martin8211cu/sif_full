<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="PTcodigo" type="string" required="yes">
		<cfargument name="PThoraini" type="numeric" required="yes">
		<cfargument name="PThorafin" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfquery datasource="#session.dsn#">
			insert into PTurnos (
				PTcodigo, PThoraini,	PThorafin,	Ecodigo,	BMUsucodigo
			)
   			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PTcodigo#">,
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PThoraini#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PThorafin#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
			)
		</cfquery>
		<cfquery name="rsSelectId" datasource="#session.dsn#">
			select max(Pid)as id from Peaje
		</cfquery>
		<cfreturn #rsSelectId.id#>
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="PTid" type="numeric" required="yes">
		<cfargument name="PTcodigo" type="string" required="yes">
		<cfargument name="PThoraini" type="numeric" required="yes">
		<cfargument name="PThorafin" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfquery datasource="#session.dsn#">
			update PTurnos set 
				PTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PTcodigo#">,
				PThoraini=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PThoraini#">,
				PThorafin=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PThorafin#">,
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MBUsucodigo#">
			where PTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PTid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #arguments.PTid#>
	</cffunction>
	
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="PTid" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfquery datasource="#session.dsn#">
			delete from PTurnos
			where PTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PTid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #arguments.PTid#>
	</cffunction>
</cfcomponent>