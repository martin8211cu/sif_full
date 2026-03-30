 <cfif IsDefined("form.Cambio")>
 
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAP000"
				redirect="Parametros.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="numeric"
				value1="#session.Ecodigo#">
				
					
	<cfquery name="update" datasource="#session.DSN#">
	
		update FAP000 
		set			
			<cfif isdefined("Form.FAPIMPSU") and Form.FAPIMPSU NEQ "">
				FAPIMPSU = <cfqueryparam value="#Form.FAPIMPSU#" cfsqltype="cf_sql_money">,
			<cfelse>
				FAPIMPSU =null,
			 </cfif>
			<cfif isdefined("Form.FAPCLF") and Form.FAPCLF NEQ "">
				FAPCLF = <cfqueryparam value="#Form.FAPCLF#" cfsqltype="cf_sql_integer">,
			<cfelse>
				FAPCLF =null,
			 </cfif>
			<cfif isdefined("Form.FAPVICOT") and Form.FAPVICOT NEQ "">
				FAPVICOT = <cfqueryparam value="#Form.FAPVICOT#" cfsqltype="cf_sql_integer">,
			<cfelse>
				FAPVICOT =null,
			 </cfif>
			 <cfif isdefined("Form.FAPVIAPA") and Form.FAPVIAPA NEQ "">
				FAPVIAPA = <cfqueryparam value="#Form.FAPVIAPA#" cfsqltype="cf_sql_integer">,
			<cfelse>
				FAPVIAPA =null,
			 </cfif>
			 <cfif isdefined("Form.FAPVINC") and Form.FAPVINC NEQ "">
				FAPVINC = <cfqueryparam value="#Form.FAPVINC#" cfsqltype="cf_sql_integer">,
			<cfelse>
				FAPVINC =null,
			 </cfif>
			 <cfif isdefined("Form.FAPVICR") and Form.FAPVICR NEQ "">
				FAPVICR = <cfqueryparam value="#Form.FAPVINC#" cfsqltype="cf_sql_integer">,
			<cfelse>
				FAPVICR =null,
			 </cfif>
			<cfif isdefined("Form.CFcuenta") and Form.CFcuenta NEQ "">
				CFcuenta = <cfqueryparam value="#Form.CFcuenta#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				CFcuenta =null,
			 </cfif>
			 <cfif isdefined("Form.CFcuenta1") and Form.CFcuenta1 NEQ "">
				CFcuenta1 = <cfqueryparam value="#Form.CFcuenta1#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				CFcuenta1 =null,
			 </cfif>
			 <cfif isdefined("Form.CFcuenta2") and Form.CFcuenta2 NEQ "">
				CFcuenta2 = <cfqueryparam value="#Form.CFcuenta2#" cfsqltype="cf_sql_numeric">
			<cfelse>
				CFcuenta2 =null
			 </cfif>
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	</cfquery> 

	<cflocation url="Parametros.cfm?o=4">

</cfif>