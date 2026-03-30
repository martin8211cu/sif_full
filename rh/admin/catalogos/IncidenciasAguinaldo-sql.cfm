<cfif isdefined("form.ALTA")>
	<cfquery datasource="#session.DSN#">
		insert into RHIncidenciasAguinaldo( CIid, RHIAexcluir, RHIAaplicarFactor, RHIAfactor )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
				<cfif isdefined("form.opcion") and form.opcion eq 'E' >1<cfelse>0</cfif>,
				<cfif isdefined("form.opcion") and form.opcion eq 'F' >1<cfelse>0</cfif>,
				<cfif isdefined("form.opcion") and form.opcion eq 'F' ><cfif isdefined("form.RHIAfactor") and len(trim(form.RHIAfactor))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHIAfactor, ',', '', 'all')#"><cfelse>0</cfif><cfelse>null</cfif>
			 )
	</cfquery>
<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update RHIncidenciasAguinaldo
		set CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
			RHIAexcluir = <cfif isdefined("form.opcion") and form.opcion eq 'E' >1<cfelse>0</cfif>,
			RHIAaplicarFactor = <cfif isdefined("form.opcion") and form.opcion eq 'F' >1<cfelse>0</cfif>
			<cfif isdefined("form.opcion") and form.opcion eq 'F' >
				, RHIAfactor = <cfif isdefined("form.RHIAfactor") and len(trim(form.RHIAfactor))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHIAfactor, ',', '', 'all')#"><cfelse>0</cfif>
			<cfelse>
				, RHIAfactor = null
			</cfif>
		where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#">
	</cfquery>
	<cflocation url="IncidenciasAguinaldo.cfm?RHIAid=#form.RHIAid#">
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from RHIncidenciasAguinaldo
		where RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid#">
	</cfquery>
</cfif>

<cflocation url="IncidenciasAguinaldo.cfm">