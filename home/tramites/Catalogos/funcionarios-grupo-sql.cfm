<cfif isdefined("form.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPFuncionarioGrupo( id_funcionario, id_grupo, BMUsucodigo, BMfechamod )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">,
		 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPFuncionarioGrupo
		where id_funcionario =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.eliminar#">
		and id_grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
	</cfquery>
</cfif>

<cflocation url="/cfmx/home/tramites/Catalogos/instituciones.cfm?id_inst=#form.id_inst#&id_grupo=#form.id_grupo#&tab=4">