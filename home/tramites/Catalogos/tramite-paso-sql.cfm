<cfif isdefined("form.eliminar.x")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPTramitePaso	
		where id_paso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_paso#">
	</cfquery>
<cfelseif isdefined("form.id_paso") and len(trim(form.id_paso))>
	<cfquery datasource="#session.tramites.dsn#">
		update TPTramitePaso 
		set numero_paso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.numero_paso#"> ,
			nombre_paso	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_paso#">
		where id_paso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_paso#">
	</cfquery>
<cfelse>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPTramitePaso( id_tramite, numero_paso, BMUsucodigo, BMfechamod,  nombre_paso)	
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.numero_paso#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_paso#"> )
	</cfquery>
</cfif>
<cflocation url="tramites.cfm?id_tramite=#form.id_tramite#&tab=3">