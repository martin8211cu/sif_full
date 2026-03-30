<cfif isdefined("form.Alta")>
	<cftransaction>
		<cfquery name="rsInserta" datasource="#session.tramites.dsn#">
			insert TPTipoRecurso 
			(Codigo_Recurso, Nombre_Recurso, BMUsucodigo, BMfechamod)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Codigo_Recurso#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Recurso#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="rsInserta">
	</cftransaction>
	
	<cfset LvarId= rsInserta.identity>
	<cflocation addtoken="no" url="tipoRecurso.cfm?id_tiporecurso=#LvarId#">

<cfelseif isdefined("form.Cambio")>
	<cftransaction>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTipoRecurso"
			redirect="tipoRecurso.cfm"
			timestamp="#form.ts_rversion#"				
			field1="id_tiporecurso" 
			type1="numeric"
			value1="#form.id_tiporecurso#">

		<cfquery name="rsUpdate" datasource="#session.tramites.dsn#">
			update TPTipoRecurso set
				Codigo_Recurso = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Codigo_Recurso#">,
				Nombre_Recurso = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Nombre_Recurso#">
			where id_tiporecurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
		</cfquery>
	</cftransaction>
	
	<cflocation addtoken="no" url="/cfmx/home/tramites/Catalogos/tipoRecurso/tipoRecurso.cfm?id_tiporecurso=#form.id_tiporecurso#">	
	
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPTipoRecurso
		where id_tiporecurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
	</cfquery>
<cfelseif isdefined("form.Nuevo")>	
	<cflocation addtoken="no" url="/cfmx/home/tramites/Catalogos/tipoRecurso/tipoRecurso.cfm">	
</cfif>

<cflocation addtoken="no" url="/cfmx/home/tramites/Catalogos/tipoRecurso/tipoRecurso.cfm">