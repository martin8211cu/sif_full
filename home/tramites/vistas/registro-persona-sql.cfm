<cfset vistas_cfc = CreateObject("component", "home.tramites.componentes.vistas")>
<cftransaction>
  <cfset nuevo = true >
	<cfquery datasource="#session.tramites.dsn#" name="rsTPTipoIdent">
		select id_tipo, id_vista_ventanilla as id_vista, nombre_tipoident, es_fisica
		from TPTipoIdent
		where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipoident#">
	</cfquery>

  <cfquery name="persona" datasource="#session.tramites.dsn#">
		insert into TPPersona( id_tipoident, identificacion_persona, nombre, apellido1, apellido2, email1, extranjero, BMUsucodigo, BMfechamod )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipoident#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identificacion_persona#">,
				<cfif rsTPTipoIdent.es_fisica>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apellido2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email1#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.identificacion_persona#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.identificacion_persona#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.identificacion_persona#">,
					null,
				</cfif>
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
		<cf_dbidentity1 datasource="#session.tramites.dsn#">
	</cfquery>
  <cf_dbidentity2 datasource="#session.tramites.dsn#" name="persona">
  <cfset form.id_persona = persona.identity >
  <cfinvoke component="#vistas_cfc#" argumentcollection="#form#"
		method="insRegistro"></cfinvoke>
</cftransaction>
<cflocation url="../Operacion/ventanilla/buscar-sql.cfm?id_tipoident=#URLEncodedFormat(form.id_tipoident)
	#&identificacion_persona=#URLEncodedFormat(form.identificacion_persona)
	#&id_tramite=#URLEncodedFormat(form.id_tramite)#">
