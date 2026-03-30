<cfif Gconcurso GT 0>
	<cfquery name="rsGconcurso" datasource="#session.dsn#">
		select RHCcodigo, RHCdescripcion
		from RHConcursos 
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gconcurso#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
</cfif>