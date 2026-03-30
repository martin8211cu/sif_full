
<cfcomponent>
	<cffunction name="AltaCacheCuentaE" access="public" returntype="string" hint="Agregar un nuevo cache a la cuenta Empresarial">
		<cfargument name="CEcodigo" 	type="numeric" 	required="yes">
        <cfargument name="Cid" 			type="string" 	required="yes">
        <cfargument name="BMUsucodigo" 	type="string"	required="yes">
        <cfargument name="Conexion" 	type="string"	required="no" default="asp">
        
        
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert INTO CECaches (CEcodigo, Cid, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
			)
		</cfquery>
	</cffunction>
    
    <cffunction name="BajaCacheCuentaE" access="public" returntype="string" hint="Elimina un Cache a la cuenta Empresarial">
		<cfargument name="CEClinea" type="numeric" required="yes">
        <cfargument name="Conexion" 	type="string"	required="no" default="asp">
		 <cfquery name="rs" datasource="#Arguments.Conexion#">
			delete from CECaches
			where CEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEClinea#">
		</cfquery>
	</cffunction>
</cfcomponent>







