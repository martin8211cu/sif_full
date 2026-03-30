<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		
		<cfquery name="moneda" datasource="#session.DSN#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHPlazaPresupuestaria(Ecodigo, RHMPPid, RHPPcodigo, RHPPdescripcion, Complemento, Mcodigo, BMfecha, BMUsucodigo)
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfif isdefined("Form.RHMPPid") and len(trim(Form.RHMPPid))><cfqueryparam value="#Form.RHMPPid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						 <cfqueryparam value="#Form.RHPPcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.RHPPdescripcion#" cfsqltype="cf_sql_varchar">,						 
						 <cfqueryparam value="#Form.Complemento#" cfsqltype="cf_sql_varchar" null="#len(trim(Form.Complemento)) is 0#">,
						 <cfqueryparam value="#moneda.Mcodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric"> )
		</cfquery>
		<cfset modo="ALTA">
		<cflocation url="RHPlazaPres-lista.cfm">
	
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete RHPlazaPresupuestaria
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPPid = <cfqueryparam value="#Form.RHPPid#" cfsqltype="cf_sql_numeric">			  
			</cfquery>  
		</cftransaction>
		<cfset modo="ALTA">
		<cflocation url="RHPlazaPres-lista.cfm">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHPlazaPresupuestaria"
			 			redirect="RHPlazaPres.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHPPid" 
						type2="numeric" 
						value2="#form.RHPPid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHPlazaPresupuestaria 
			set RHPPcodigo = <cfqueryparam value="#form.RHPPcodigo#" cfsqltype="cf_sql_char">,
				RHPPdescripcion = <cfqueryparam value="#Form.RHPPdescripcion#" cfsqltype="cf_sql_varchar">,
				RHMPPid = <cfif isdefined("Form.RHMPPid") and len(trim(Form.RHMPPid))><cfqueryparam value="#Form.RHMPPid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				Complemento = <cfqueryparam value="#Form.Complemento#" cfsqltype="cf_sql_varchar" null="#len(trim(Form.Complemento)) is 0#">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   	  and RHPPid = <cfqueryparam value="#Form.RHPPid#" cfsqltype="cf_sql_numeric">	
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
	<cflocation url="RHPlazaPres.cfm?RHPPid=#form.RHPPid#">
<cfelseif isdefined("form.Nuevo")>
	<cflocation url="RHPlazaPres.cfm">
</cfif>

