<cfif isdefined("form.accion")>
	<cfif form.accion EQ 2>
		<cfquery name="rs" datasource="asp">
			insert INTO CECaches (CEcodigo, Cid, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
	<cfelseif form.accion EQ 3>
		<cfquery name="rs" datasource="asp">
			delete from CECaches
			where CEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEClineaDel#">
		</cfquery>
	</cfif>
</cfif>	

<cfif isdefined("form.accion")>
	<cfif form.accion eq 1>
		<cflocation url="/cfmx/asp/catalogos/Empresas.cfm">
	<cfelseif form.accion EQ 2 or form.accion EQ 3>
		<cflocation url="/cfmx/asp/catalogos/Caches.cfm">
	</cfif>
</cfif>
