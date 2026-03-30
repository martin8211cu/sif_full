<cfif IsDefined("session.Ecodigo") and Len(session.Ecodigo) NEQ 0 and session.Ecodigo NEQ 0>
	<cfquery datasource="#session.dsn#" name="VerificarMEServicioEmpresa">
		select METSid, MESid from MEServicioEmpresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif Len(VerificarMEServicioEmpresa.METSid) EQ 0>
		<cfquery name="insertEmpresa" datasource="#session.dsn#">
			insert MEServicioEmpresa 
				(METSid, Ecodigo, MESid)
			select a.METSid, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, max(MESid) as MESid
			from MEServicio a
			where not exists (select * from MEServicioEmpresa c
			  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				 and a.METSid = c.METSid)
			group by a.METSid
		</cfquery>
	</cfif>
</cfif>