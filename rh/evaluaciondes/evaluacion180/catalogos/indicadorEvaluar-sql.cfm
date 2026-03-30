<cfset params = ''>
<cfif isdefined("form.btnAgregar")>
	<cfquery datasource="#session.DSN#">
		insert into RHIndicadoresAEvaluar(	IAEcodigo, 
											Ecodigo, 
											IAEdescripcion, 
											IAEpesop, 
											IAEtipoconc, 
											IAEpregunta, 
											IAEevaluajefe, 
											IAEevaluasubjefe, 
											BMfechaalta, 
											BMUsucodigo )
		values(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IAEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IAEdescripcion#">,
				<cfif trim(form.IAEtipoconc) eq 'T'><cfqueryparam cfsqltype="cf_sql_integer" value="#form.IAEpesop#"><cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.IAEtipoconc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IAEpregunta#" null="#len(trim(form.IAEpregunta)) eq 0#">,
				<cfif isdefined("form.IAEevaluajefe")>1<cfelse>0</cfif>,
				<cfif isdefined("form.IAEevaluasubjefe")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">	)

	</cfquery>
<cfelseif isdefined("form.btnModificar") >
	<cf_dbtimestamp datasource="#session.dsn#"
			table="RHIndicadoresAEvaluar"
			redirect="indicadorEvalua.cfm"
			timestamp="#form.timestamp#"
			field1="IAEid" 
			type1="numeric" 
			value1="#form.IAEid#">

	<cfquery datasource="#session.DSN#">
		update RHIndicadoresAEvaluar
		set IAEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IAEcodigo#">,
			IAEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IAEdescripcion#">,
			IAEpesop = <cfif trim(form.IAEtipoconc) eq 'T'><cfqueryparam cfsqltype="cf_sql_integer" value="#form.IAEpesop#"><cfelse>0</cfif>,
			IAEtipoconc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.IAEtipoconc#">,
			IAEpregunta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IAEpregunta#" null="#len(trim(form.IAEpregunta)) eq 0#">,
			IAEevaluajefe = <cfif isdefined("form.IAEevaluajefe")>1<cfelse>0</cfif>,
			IAEevaluasubjefe = <cfif isdefined("form.IAEevaluasubjefe")>1<cfelse>0</cfif>
		where IAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IAEid#">
	</cfquery>
	<cfset params = '?IAEid=#form.IAEid#'>

<cfelseif isdefined("form.btnEliminar") >
	<cfquery datasource="#session.DSN#">
		delete from RHIndicadoresAEvaluar
		where IAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IAEid#">
	</cfquery>
</cfif>

<cflocation url="indicadorEvaluar.cfm#params#">