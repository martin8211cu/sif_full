<cfif isdefined("banmod") and banmod eq 1>

	<cf_dbtimestamp datasource="#session.dsn#"
			table="PARcuentasIntercompania"
			redirect="cuentasInter.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="numeric"
			value1="#Session.Ecodigo#"
	>

	<!--- Se Incluyen los datos en las tablas correspondientes --->
	<!--- **************************************************** --->

	<!--- Actualizacion del Encabezado --->
	<cfquery datasource="#session.dsn#" name="data">
		Update PARcuentasIntercompania
		set CFmascaraCXC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cfmascaracxc)#">,
		    CFmascaraCXP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cfmascaracxp)#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>


	<cfloop list="#lstempresas#" delimiters="," index="ind_empr">

		<cfset n_campo = "complemento_" & ind_empr>
	
		<!--- Inclusion del Detalle --->
		<cfquery datasource="#session.dsn#" name="verifica_comp">
			Select Ecodigo
			from PARcomplementoIntercompania
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and EcodigoComplementar = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ind_empr#">
		</cfquery>
		
		<cfif verifica_comp.recordcount gt 0>
		
			<cfquery datasource="#session.dsn#" name="data">
			Update PARcomplementoIntercompania
			set cuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate(n_campo))#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and EcodigoComplementar = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ind_empr#">			
			</cfquery>
		
		<cfelse>
			
			<cfquery datasource="#session.dsn#" name="data">
			Insert PARcomplementoIntercompania(Ecodigo, EcodigoComplementar, cuentac)
			values(#Session.Ecodigo#, #ind_empr#, '#trim(evaluate(n_campo))#')
			</cfquery>
		
		</cfif>
			
	</cfloop>	

</cfif>
<cflocation url="cuentasInter.cfm">


