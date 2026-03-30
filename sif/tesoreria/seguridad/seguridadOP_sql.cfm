<cfif isdefined("Form.Alta")>
	<cfquery datasource="#Session.DSN#">
		insert into TESusuarioOP
			(TESid, Usucodigo, BMUsucodigo)
		values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Usucodigo#">, 
					#session.Usucodigo#
			)
	</cfquery>
	<cflocation url="seguridadOP.cfm">	
<cfelseif isdefined("url.btnBaja")>
	<cfquery datasource="#Session.DSN#">
		delete from TESusuarioOP
		 where TESid		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#">
		   and Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#url.Usucodigo#">
	</cfquery>
	<cflocation url="seguridadOP.cfm">	
</cfif>
<cflocation url="seguridadOP.cfm">	
