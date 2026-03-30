<cfif isdefined("form.ALTA")>
	<cfquery datasource="#session.DSN#">
		insert into RHIndicadores(RHIcodigo, RHIdescripcion, RHIvalor)
		values( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIvalor#"> )
	</cfquery>
<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update RHIndicadores
		set RHIdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIdescripcion#">,
			RHIvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHIvalor#">
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">
	</cfquery>
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from RHIndicadoresDetalle
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from RHIndicadores
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">
	</cfquery>
</cfif>
<cflocation url="parametros.cfm">