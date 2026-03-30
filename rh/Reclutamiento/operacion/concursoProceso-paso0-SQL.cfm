<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.btneliminar")> 
		<cfif isdefined("form.chk") and len(trim(form.chk)) gt 0> 
			<cfset arrayKeys = ListToArray(form.chk)>
			<cfloop from="1" to="#ArrayLen(arrayKeys)#" index="i">
				<cfquery name="delRHConcursantesPlaza" datasource="#Session.DSN#">
					delete from RHConcursantes
					where exists (
						select 1 
						from RHPlazasConcurso a
						where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeys[i]#">
					)
				</cfquery>
				<cfquery name="delRHCompetenciasPlaza" datasource="#Session.DSN#">
					delete from RHCompetenciasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeys[i]#">
				</cfquery>
				<cfquery name="delRHPlazasConcurso" datasource="#Session.DSN#">
					delete from RHPlazasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeys[i]#">
				</cfquery>
				 <cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
					delete from RHAreasEvalConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeys[i]#">
				</cfquery>
				<cfquery name="delRHPruebasConcurso" datasource="#session.DSN#">
					delete from RHPruebasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeys[i]#">					
				</cfquery>
				<cfquery name="delRHConcursos" datasource="#Session.DSN#">
					delete from RHConcursos
					where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeys[i]#">
				</cfquery>			
			</cfloop>
		</cfif>
	</cfif>
</cfif>