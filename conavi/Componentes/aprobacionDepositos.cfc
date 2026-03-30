<cfcomponent>
	<cffunction name="AprobarDeposito" access="public" returntype="string">
		<cfargument name="PDTDid" type="numeric" required="yes">
		<cfargument name="fechaAprobacion" type="String" required="no" default="#DateFormat(now(),'DD/MM/YYYY')#">
		<cfargument name="fechaReal" type="String" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery name="rsSelectDatosDepositos" datasource="#arguments.Conexion#">
			update PDTDeposito set 
				PDTDestado = 3,
				PDTDdeposito = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fechaReal)#">,
				PDTDaprobacion = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(arguments.fechaAprobacion)#">
			where PDTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PDTDid#">
	</cfquery>
	</cffunction>
</cfcomponent>