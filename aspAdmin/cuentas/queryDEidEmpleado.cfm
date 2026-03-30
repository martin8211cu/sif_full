<cfif isdefined("url.keyRol") and url.keyRol NEQ "">
	<cfoutput>	
		<cfquery name="rs" datasource="#session.DSN#">
			select rol,query_referencia
			from Rol
			where referencia in ('N','I')
				and rol=<cfqueryparam cfsqltype="cf_sql_char" value="rh.usuario">
		</cfquery>

		<cfif isdefined('rs') and rs.recordCount GT 0 and isdefined('url.empresa') and Len(trim(#url.empresa#)) GT 0 and isdefined('url.sistema') and Len(trim(#url.sistema#)) GT 0>
			<cfset varSQL = "">

			<cfquery name="rsEmpresaID" datasource="#session.DSN#">
				Select consecutivo,nombre_cache
				from EmpresaID
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.empresa#">
					and sistema=<cfqueryparam cfsqltype="cf_sql_char" value="#url.sistema#">
			</cfquery>			

			<cfif isdefined('rsEmpresaID') and rsEmpresaID.recordCount GT 0>
				<cfset errorQueryEmpleado = false>			
				<cfset varSQL = Replace(rs.query_referencia, "~empresa~", "#rsEmpresaID.consecutivo#", "one")>
				<cfset varSQL = Replace(varSQL, "~identif~", "'#url.identifEmpleado#'", "one")>
				<cfset errorQryEmpl = "">

				<cfif Len(trim(rsEmpresaID.nombre_cache)) NEQ 0>
					<cftry>
							<cfquery name="rsEmpleado" datasource="#trim(rsEmpresaID.nombre_cache)#">
								#PreserveSingleQuotes(varSQL)#
							</cfquery>
						<cfcatch type="any">
							<cfset errorQueryEmpleado = true>
							<cfset errorQryEmpl = cfcatch.Message>
						</cfcatch>					
					</cftry>
				</cfif>
				
				<cfif errorQueryEmpleado EQ false>
					<cfif isdefined('rsEmpleado') and rsEmpleado.recordCount GT 0>
						<script language="JavaScript">
							parent.#url.form#.num_int_referencia.value='#rsEmpleado.DEid#';
						</script>				
					</cfif>			
				<cfelse>
					<script language="JavaScript">
						alert("Error -- " + <cfoutput>#errorQryEmpl#</cfoutput>);							
					</script>									
				</cfif>
			</cfif>
		</cfif>
		
		<script language="JavaScript">
			parent.valida('#url.valorSel#');
		//	alert("num_int_referencia -- " + parent.#url.form#.num_int_referencia.value);							
		</script>		
	</cfoutput>	
</cfif>