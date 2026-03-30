<!--- <cfdump var="#url#"> --->
<cfif isdefined("url.Ccuenta") and len(trim(url.Ccuenta)) and isdefined("url.op") and url.op eq 'I'>
	<cfquery datasource="#session.DSN#">
		insert into CCCuentasConciliacionUsr 
			(Usucodigo, 
			 Ccuenta, 
			 Ecodigo)
		values 
			(
			#session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ccuenta#">,
			#session.Ecodigo#
			)
	</cfquery>
<cfelseif isdefined("url.Ccuenta") and len(trim(url.Ccuenta)) and isdefined("url.op") and url.op eq 'D'>
	<cfquery datasource="#session.DSN#">
		delete from CCCuentasConciliacionUsr
		where Usucodigo = #session.Usucodigo#
		and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ccuenta#">
	</cfquery>
</cfif>