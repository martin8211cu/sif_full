<!--- <cfset Session.Usucodigo = 1> --->
<!--- Consultas --->
<cfquery name="soy_pso" datasource="#Session.DSN#">
	select up.rol
	from UsuarioPermiso up
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	  and up.rol = 'sys.pso'
	  and up.activo = 1
</cfquery>

<cfquery name="soy_agente" datasource="#Session.DSN#">
	select up.rol
	from UsuarioPermiso up
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	  and up.rol = 'sys.agente'
	  and up.activo = 1
</cfquery>

<!--- Guarda quien soy en Session --->
<cfset session.secfw.soy_pso = soy_pso.RecordCount>
<cfset session.secfw.soy_agente = soy_agente.RecordCount>