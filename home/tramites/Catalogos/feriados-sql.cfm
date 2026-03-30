<cfif isdefined("form.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPFeriados(fecha,descripcion,BMUsucodigo,BMfechamod)
		values(	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
	</cfquery>
<cfelseif isdefined("form.Modificar")>
	<cfquery datasource="#session.tramites.dsn#">
		update TPFeriados
		set descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">
		where fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecha#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPFeriados
		where fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecha#">
	</cfquery>
</cfif>

<cflocation url="/cfmx/home/tramites/Catalogos/feriados.cfm">