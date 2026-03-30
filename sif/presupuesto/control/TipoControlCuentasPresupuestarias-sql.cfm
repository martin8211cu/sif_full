<cfif isdefined('btnModificar')>
	<cftransaction>
<!---		<cf_dump var="#form#">--->
		<cfquery datasource="#Session.dsn#">
			update CPCuentaPeriodo
				set  CPCPtipoControl=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoControl#">,
				     CPCPcalculoControl=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CalculoControl#">
			where Ecodigo = #Session.Ecodigo#	
			      and CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPcuenta#">
			      and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">				  
		</cfquery>
	</cftransaction>
	<cflocation url="TipoControlCuentasPresupuestarias.cfm">
</cfif>	
	