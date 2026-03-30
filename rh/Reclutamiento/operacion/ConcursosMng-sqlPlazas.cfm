<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Cambio")>
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
						insert into RHPlazasConcurso (Ecodigo, RHCconcurso, RHPid, RHCPidsel, Usucodigo, RHPCpesoareas, RHPCpesocomp, BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
<!---							<cfqueryparam cfsqltype="cf_sql_char" value="#arrayKeysid[i]#">,
	ljimenez se reemlazo de la funcion cf_sql_char por cf_sql_numeric ya que el valor enviado es el de RHPid que es numerico 		
--->					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayKeysid[i]#">,
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
			 
			 <!--- Actualiza el campo de Cantidad de Plazas en el Concurso --->
			 <cfquery name="updPlazas" datasource="#Session.DSN#">
			 	update RHConcursos set 
					RHCcantplazas = (
						select count(1)
						from RHPlazasConcurso x
						where x.RHCconcurso = RHConcursos.RHCconcurso
					)
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			 </cfquery>
		</cfif>
	</cfif>
</cftransaction>
