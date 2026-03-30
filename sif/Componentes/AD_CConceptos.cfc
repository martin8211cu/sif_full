<!---Componente para el trato de las Clasificación de Conceptos de Servicio--->
<cfcomponent>
	<cffunction name="CambioCFcomplemento"  access="public">
		<cfargument name="Conexion" 	type="string"    required="no">
		<cfargument name="BMUsucodigo" 	type="numeric"   required="no">
		<cfargument name="CCid" 		type="numeric"   required="yes">
		<cfargument name="cuentac" 		type="string"    required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = #session.dsn#>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = #session.Usucodigo#>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			Update CConceptos 
			    set cuentac = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.cuentac)#">,
				BMUsucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
			where CCid      = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CCid#">
		</cfquery>		 
	</cffunction>
</cfcomponent>