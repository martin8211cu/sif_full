<cfset modo = "ALTA">
<cfset params="">
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHCalificaEduc(Ecodigo, RHCEDNivel, RHCEDPeso, BMfechaalta, BMUsucodigo)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCEDNivel#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEDPeso#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					  )
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHCalificaEduc
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHCEDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEDid#">
		</cfquery>  
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHCalificaEduc"
			 			redirect="CalificacionEducacion.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHCEDid" 
						type2="numeric" 
						value2="#form.RHCEDid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHCalificaEduc  
			set RHCEDNivel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCEDNivel#">,
				RHCEDPeso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEDPeso#">,
				BMfechaalta =	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and RHCEDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEDid#" >
		</cfquery> 
		<cfset modo="CAMBIO">
		<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "RHCEDid=" & RHCEDid>	
	</cfif>
	</cftransaction>
</cfif>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "modo=" & modo>	
<cflocation url="CalificacionEducacion.cfm#params#">