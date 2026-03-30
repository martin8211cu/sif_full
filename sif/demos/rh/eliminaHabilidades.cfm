<cfquery datasource="#demo.DSN#">
		delete RHHabilidades
		where Ecodigo= <cfqueryparam value="#demo.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

