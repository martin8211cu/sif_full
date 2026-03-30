<!---Componente para el trato de las Clasificación de Conceptos de Servicio--->
<cfcomponent>
	<cffunction name="CambioCFcomplemento"  access="public">
		<cfargument name="Conexion" 	type="string"    required="no">
		<cfargument name="Ecodigo" 	type="string"    required="no">
		<cfargument name="BMUsucodigo" 	type="numeric"   required="no">
		<cfargument name="Ccodigo" 		type="numeric"   required="yes">
		<cfargument name="cuentac" 		type="string"    required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = #session.dsn#>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = #session.Usucodigo#>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = #session.Ecodigo#>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			Update Clasificaciones 
			    set cuentac = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.cuentac)#">,
				BMUsucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
			where Ecodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and Ccodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Ccodigo#">
		</cfquery>		 
	</cffunction>
</cfcomponent>