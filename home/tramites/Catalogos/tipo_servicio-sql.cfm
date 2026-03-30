<cfif isdefined("url.Agregar")>
	<cfquery datasource="#session.tramites.dsn#">
		insert into TPTipoServicio( id_inst, codigo_tiposerv, nombre_tiposerv, descripcion_tiposerv, BMUsucodigo, BMfechamod, id_tiposervg )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_inst#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.codigo_tiposerv)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.nombre_tiposerv#">,
				<cfif len(trim(url.descripcion_tiposerv))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#url.descripcion_tiposerv#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfif isdefined("url.id_tiposervg") and len(trim(url.id_tiposervg)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposervg#"><cfelse>null</cfif>	 )
	</cfquery>

<cfelseif isdefined("url.Modificar")>
	<cfquery datasource="#session.tramites.dsn#">
		update TPTipoServicio
		set codigo_tiposerv=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(url.codigo_tiposerv)#">,
			nombre_tiposerv=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.nombre_tiposerv#">,
			descripcion_tiposerv=<cfif len(trim(url.descripcion_tiposerv))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#url.descripcion_tiposerv#"><cfelse>null</cfif>,
			id_tiposervg = <cfif isdefined("url.id_tiposervg") and len(trim(url.id_tiposervg)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposervg#"><cfelse>null</cfif>
		where id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposerv#">
	</cfquery>

<cfelseif isdefined("url.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPTipoServicio
		where id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposerv#">
	</cfquery>
	<cflocation url="instituciones.cfm?id_inst=#url.id_inst#&tab=5&tabserv=serv1">	
</cfif>

<cfset p = "?id_inst=#url.id_inst#&tab=5&tabserv=serv1">
<cfif not isdefined("url.Nuevo") and isdefined("url.id_tiposerv") and len(trim(url.id_tiposerv))>
	<cfset p = p & "&id_tiposerv=#url.id_tiposerv#">
</cfif> 

<cflocation url="instituciones.cfm#p#">