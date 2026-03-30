<cfif isdefined("form.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPHorario(id_agenda, dia_semana, hora_desde, hora_hasta, id_requisito, cupo, BMUsucodigo, BMfechamod)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.dia_semana#">,
				 <cfqueryparam cfsqltype="cf_sql_time" value="">,
				 <cfqueryparam cfsqltype="cf_sql_time" value="">,
				 <cfif isdefined("form.id_requisito") and len(trim(form.id_requisito))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#"><cfelse>null</cfif>,
				 <cfif isdefined("form.cupo") and len(trim(form.cupo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#"><cfelse>null</cfif>,
				
		 )

	</cfquery>
<cfelseif isdefined("form.Modificar")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPHorario"
			redirect="agenda.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_horario" 
			type1="numeric" 
			value1="#form.id_horario#" >
	<cfquery datasource="#session.tramites.dsn#">
		update TPHorario
		set codigo_agenda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo_agenda#">,	
			nombre_agenda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_agenda#">,
			ubicacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacion#">
		where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPHorario
		where id_horario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_horario#">
	</cfquery>
</cfif>

<cflocation url="/cfmx/home/tramites/Catalogos/agenda.cfm?id_inst=#form.id_inst#&id_tiposerv=#form.id_tiposerv#">