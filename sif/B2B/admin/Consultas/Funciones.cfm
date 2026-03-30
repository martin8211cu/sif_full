<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="">
	<cfquery datasource="#Session.DSN#" name="rsget_val">
		select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
	</cfquery>
	<cfreturn #rsget_val#>
</cffunction>

<cffunction name="get_moneda" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Código de la Moneda --->">
	<cfquery datasource="#Session.DSN#" name="rsget_moneda">
		select Mnombre from Monedas
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">
	</cfquery>
	<cfreturn #rsget_moneda#>
</cffunction>
