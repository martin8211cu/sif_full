<cfquery datasource="#demo.DSN#">
		delete RHConocimientos
		where Ecodigo= <cfqueryparam value="#demo.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>


