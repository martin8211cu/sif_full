<cf_dump var="#form#">
<cfif isdefined("form.archivo") and form.archivo NEQ "">
		<cfquery datasource="#session.dsn#" name="rsValida">
			select 1 from
			RHImagenEmpleado
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		<cfif rsValida.recordcount eq 0>
			<cfif isdefined("form.archivo") and Len(Trim(form.archivo)) gt 0 >
							<cfinclude template="/rh/Utiles/imagen.cfm">
							 <cfif isdefined("ts")>
								<cfquery name="ABC_empleadosImagen" datasource="#Session.DSN#">
									insert into RHImagenEmpleado(DEid, foto)
									values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
										<cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
									)
								</cfquery>
							</cfif>
		</cfif>	
		<cfelse>	
			<cfif isdefined("form.archivo") and Len(Trim(form.archivo)) gt 0 >
                <cfinclude template="/rh/Utiles/imagen.cfm">
				 <cfif isdefined("ts")>
					<cfquery name="ABC_empleadosImagen" datasource="#Session.DSN#">
						update RHImagenEmpleado
						set foto = <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
						where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					</cfquery> 
				 </cfif>
			</cfif>
		</cfif>
</cfif>