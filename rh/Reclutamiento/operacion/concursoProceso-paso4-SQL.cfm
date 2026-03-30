
 <cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Publicar")>
			 <cf_dbtimestamp
				datasource="#session.DSN#"
				table="RHConcursos"
				redirect="ConcursoProceso-paso0.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
				field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#"> 
			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHConcursos set 
					RHCestado 	 = 50,
					BMUsucodigo	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			</cfquery>
			<cfset Form.paso = 0>
		</cfif>		
		<cfset modo="ALTA">
</cfif>


