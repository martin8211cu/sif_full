<cfcomponent>
<cffunction name="registrar" access="public" returntype="void" output="false">
  <cfargument name="id_tramite" type="numeric" default="0">
  <cfargument name="id_requisito" type="numeric" default="0">
  <cfargument name="id_persona" type="numeric" default="0">
  <cfargument name="accion" type="string" default="">
  <cfargument name="texto" type="string" default="">
  
  <cfquery datasource="#session.tramites.dsn#">
		
	insert into TPBitacoraFuncionario 
	  ( id_funcionario, id_ventanilla, id_tramite, id_requisito,
	    id_persona, accion, texto,
		BMUsucodigo, BMfechamod)
	values (
	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#" null="#Len(session.tramites.id_funcionario) IS 0#">,
	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#" null="#Len(session.tramites.id_ventanilla) IS 0#">,
	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tramite#" null="#(Arguments.id_tramite) IS 0#">,
	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_requisito#" null="#(Arguments.id_requisito) IS 0#">,

	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#" null="#(Arguments.id_persona) IS 0#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.accion#" null="#Len(Arguments.accion) IS 0#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.texto#" null="#Len(Arguments.texto) IS 0#">,
	  
	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
	  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
    )
	</cfquery>
</cffunction>
</cfcomponent>
