<!--- BORRADO --->

<cfquery datasource="#demo.DSN#">
	delete RHDEvaluacionDes
	where RHEEid in (
						Select RHEEid
						from RHEEvaluacionDes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
					) 
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHEvaluadoresDes
	where RHEEid in (
						Select RHEEid
						from RHEEvaluacionDes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
					) 
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHNotasEvalDes
	where RHEEid in (
						Select RHEEid
						from RHEEvaluacionDes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
					) 
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHListaEvalDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHEEvaluacionDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>