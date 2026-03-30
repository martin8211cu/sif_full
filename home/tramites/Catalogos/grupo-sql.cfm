<cfif isdefined("form.Agregar")>
	<cftransaction>	
	<cfquery name="grupo" datasource="#session.tramites.dsn#">
		insert into TPGrupo( id_inst, codigo_grupo, nombre_grupo, BMUsucodigo, BMfechamod )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(form.codigo_grupo)#">,	
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_grupo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
			<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="grupo">
	</cftransaction>
	<cfset form.id_grupo = grupo.identity >
<cfelseif isdefined("form.Modificar")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPGrupo"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_grupo" 
			type1="numeric" 
			value1="#form.id_grupo#" >
	<cfquery datasource="#session.tramites.dsn#">
		update TPGrupo
		set codigo_grupo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo_grupo#">,	
			nombre_grupo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_grupo#">
		where id_grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPGrupo
		where id_grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
	</cfquery>
	<cflocation url="/cfmx/home/tramites/Catalogos/instituciones.cfm?id_inst=#form.id_inst#&tab=3">
</cfif>

<cflocation url="/cfmx/home/tramites/Catalogos/instituciones.cfm?id_inst=#form.id_inst#&tab=3&id_grupo=#form.id_grupo#">