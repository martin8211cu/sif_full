<cfif isdefined("form.btnAceptar") or isdefined("Aceptar") >
	<cfquery datasource="#Session.DSN#" name="rsUPD_RHIC">
		update RHConcursos set
			RHCestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCestado#">,
			RHCjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCjustificacion#">
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>
