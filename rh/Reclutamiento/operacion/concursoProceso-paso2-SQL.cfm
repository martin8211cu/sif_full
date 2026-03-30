<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Cambio") or isdefined("Form.SIGUIENTE") and Form.pasoante EQ 2><!--- or isdefined("Form.SIGUIENTE") ---> 
			 <!--- Borra todas las plazas de un concurso y las vuelve a insertar --->
			 
			<cfquery name="delRHPlazasConcurso" datasource="#session.DSN#">
					delete from RHPlazasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			</cfquery>			
			 <cfif isdefined("form.RHPidList") and len(trim(form.RHPidList)) gt 0>
				<cfset arrayKeysid = ListToArray(form.RHPidList)>
				<cfloop from="1" to="#ArrayLen(arrayKeysid)#" index="i">
					<cfquery name="rsRHPlazasConcursoInsert" datasource="#session.DSN#">
						insert into RHPlazasConcurso
						(Ecodigo, RHCconcurso, RHPid, RHCPidsel, Usucodigo, RHPCpesoareas, RHPCpesocomp, BMUsucodigo)
						values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#arrayKeysid[i]#">,
								0,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								0,
								0,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
								)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="rsRHPlazasConcursoInsert">
				</cfloop>
			 </cfif> 
			
			<cfif isdefined("Form.SIGUIENTE") and Form.pasoante EQ 2>
				<cfset form.paso = 3>
			</cfif>

			<cfset modo="CAMBIO">
		</cfif>
	</cfif>
</cftransaction>