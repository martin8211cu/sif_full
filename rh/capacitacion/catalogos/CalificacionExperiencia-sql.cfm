<cfset modo = "ALTA">
<cfset params="">
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHCalificacionExp(Ecodigo, RHCErequisito, RHCELimiteInf, RHCELimiteSup, BMfechaalta, BMUsucodigo,RHECGid)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCErequisito#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCELimiteInf#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCELimiteSup#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECGid#">
					  )
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHCalificacionExp
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
		</cfquery>  
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHCalificacionExp"
			 			redirect="CalificacionExperiencia.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHCEid" 
						type2="numeric" 
						value2="#form.RHCEid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHCalificacionExp  
			set RHCErequisito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCErequisito#">,
				RHCELimiteInf = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCELimiteInf#">,
				RHCELimiteSup = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCELimiteSup#">,
				RHECGid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECGid#">,
				BMfechaalta   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo   =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and RHCEid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#" >
		</cfquery> 
		<cfset modo="CAMBIO">
		<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "RHCEid=" & RHCEid>	
	</cfif>
	</cftransaction>
</cfif>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "modo=" & modo>	
<cflocation url="CalificacionExperiencia.cfm#params#">