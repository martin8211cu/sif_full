<cfif isdefined("form.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPTipoTramite(codigo_tipotramite, nombre_tipotramite, BMUsucodigo, BMfechamod)
		values(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.codigo_tipotramite)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipotramite#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
	</cfquery>
<cfelseif isdefined("form.Modificar")>
	<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTipoTramite"
			redirect="tipo_tramite.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tipotramite" 
			type1="numeric" 
			value1="#form.id_tipotramite#" >

	<cfquery datasource="#session.tramites.dsn#">
		update TPTipoTramite
		set codigo_tipotramite=<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.codigo_tipotramite)#">, 
		    nombre_tipotramite=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipotramite#">
		where id_tipotramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tipotramite#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPTipoTramite
		where id_tipotramite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_tipotramite#">
	</cfquery>
</cfif>

<cflocation url="tipo_tramites.cfm">