<cfquery datasource="asp" name="xx" maxrows="10">
	select *
	from UsuarioRol
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RH">
	  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="AUTO">
</cfquery>

<cfdump var="#xx#">
