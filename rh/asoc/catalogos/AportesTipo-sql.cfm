<!--- Proceso de Inserción, Modificación y Borrado --->
<cfset params="">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta")>

		<cftransaction>
			<cfquery name="rsInsert" datasource="#Session.DSN#">
				insert into ACAportesTipo (
					Ecodigo, 			DClinea, 			TDid, 
					ACATcodigo, 		ACATdescripcion, 	ACATtipo, 
					ACATtasa, 			ACATorigen, 		ACATpermiteRetiro, 
					BMUsucodigo, 		BMfecha
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
					<cfif isdefined("Form.DClinea") and len(trim(Form.DClinea)) gt 0 and trim(Form.radRep) eq 1>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("Form.TDid") and len(trim(Form.TDid)) gt 0 and trim(Form.radRep) eq 2>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#">,					
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACATcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACATdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACATtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATtasa#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACATorigen#">,
					<cfif isdefined("Form.ACATpermiteRetiro")>1<cfelse>0</cfif>,					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsert">
		</cftransaction>		
		<cfset params = params&"&ACATid="&rsInsert.identity>
		
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDelete" datasource="#Session.DSN#">
			delete from ACAportesTipo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
		</cfquery>		
		
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="rsUpdate" datasource="#Session.DSN#">
			update ACAportesTipo
			set ACATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACATdescripcion#">,
				DClinea = <cfif isdefined("Form.DClinea") and len(trim(Form.DClinea)) gt 0 and trim(Form.radRep) eq 1><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#"><cfelse>null</cfif>,
				TDid = <cfif isdefined("Form.TDid") and len(trim(Form.TDid)) gt 0 and trim(Form.radRep) eq 2><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#"><cfelse>null</cfif>,
				ACATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACATtipo#">,
				ACATtasa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATtasa#">,
				ACATorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ACATorigen#">,
				ACATpermiteRetiro = <cfif isdefined("Form.ACATpermiteRetiro")>1<cfelse>0</cfif>,
			   	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			   	BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
		</cfquery>
		<cfset params = params&"&ACATid="&Form.ACATid>
		
	</cfif>
				
</cfif>

<cflocation url="AportesTipo.cfm?#params#">
