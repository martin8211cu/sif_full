<cfif isdefined("form.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPAgenda( id_inst, id_tiposerv, codigo_agenda, nombre_agenda, ubicacion, BMUsucodigo, BMfechamod )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(form.codigo_agenda)#">,	
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_agenda#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
	</cfquery>
<cfelseif isdefined("form.Modificar")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPAgenda"
			redirect="agenda.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_agenda" 
			type1="numeric" 
			value1="#form.id_agenda#" >
	<cfquery datasource="#session.tramites.dsn#">
		update TPAgenda
		set codigo_agenda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo_agenda#">,	
			nombre_agenda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_agenda#">,
			ubicacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacion#">
		where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPAgenda
		where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfquery>
</cfif>

<cflocation url="/cfmx/home/tramites/Catalogos/agenda.cfm?id_inst=#form.id_inst#&id_tiposerv=#form.id_tiposerv#">