<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="Pcodigo" type="string" required="yes">
		<cfargument name="CFid" type="numeric" required="yes">
		<cfargument name="Pcarriles" type="numeric" required="no" default="0">
		<cfargument name="cuentac" type="string" required="no" default="">
		<cfargument name="Pdescripcion" type="string" required="no" default="">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
    	<cfargument name="FPAEid" type="numeric" required="yes" default="">
    	<cfargument name="CFComplemento" type="string" required="yes" default="">
			
		<cfquery datasource="#session.dsn#" name="rsPeaje">
			insert into Peaje (
				Pcodigo,					CFid,				Pcarriles,		
				cuentac,					Pdescripcion,		Ecodigo,
				BMUsucodigo,                FPAEid,             CFComplemento
			)
   			values(
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Pcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Pcarriles#">,        
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cuentac#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Pdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPAEid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFComplemento#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsPeaje">
		<cfreturn #rsPeaje.identity#>
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="Pid" type="numeric" required="yes">
		<cfargument name="Pcodigo" type="string" required="no">
		<cfargument name="CFid" type="numeric" required="no">
		<cfargument name="Pcarriles" type="numeric" required="no" default="0">
		<cfargument name="cuentac" type="string" required="no" default="">
		<cfargument name="Pdescripcion" type="string" required="no" default="">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="FPAEid" type="numeric" required="no" default="-1">
		<cfargument name="CFComplemento" type="string" required="no" default="">		
		<cfquery datasource="#session.dsn#">
			update Peaje set 
				Pcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Pcodigo#">,
				CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">,
				Pcarriles=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Pcarriles#">,	
				cuentac=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cuentac#">,
				Pdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Pdescripcion#">,
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
				<cfif isdefined('arguments.FPAEid') and #arguments.FPAEid# neq -1>
				 ,FPAEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPAEid#">
				 ,CFComplemento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFComplemento#">
				</cfif>
			where Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Pid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #arguments.Pid#>
	</cffunction>
	
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="Pid" type="numeric" required="yes">
		<cfargument name="Pcodigo" type="string" required="no">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfquery datasource="#session.dsn#">
			delete from Peaje
			where Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Pid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #arguments.Pid#>
	</cffunction>
	
	<cffunction name="OBTENER_Peaje" access="public" returntype="query">
		<cfargument name="Pid" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery name="DatosPeaje" datasource="#arguments.Conexion#">
			select  Pcodigo, CFid, Pcarriles, cuentac, Pdescripcion, BMUsucodigo
			from Peaje
			where Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Pid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #DatosPeaje#>
	</cffunction>
</cfcomponent>