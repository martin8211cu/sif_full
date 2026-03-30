<cfcomponent>
	<cffunction name="CambioCFcomplemento"  access="public">
		<cfargument name="Conexion" 	type="string"    required="no">
		<cfargument name="BMUsucodigo" 	type="numeric"   required="no">
		<cfargument name="ACatId" 		type="numeric"   required="yes">
		<cfargument name="cuentac" 		type="string"    required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = #session.dsn#>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = #session.Usucodigo#>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			update ACategoria 
				set cuentac = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.cuentac)#">,
				BMUsucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
			where ACatId    = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.ACatId#">
		</cfquery>
	</cffunction>
</cfcomponent>