<cfset params = "?DEid=#form.DEid#">

<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rs_insert" datasource="#session.dsn#">
		insert into DVacacionesAcum (DEid, Ecodigo, BMUsucodigo, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha)
			values(		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVAperiodo#">,
						<cfif isdefined("form.DVAsaldodias") and len(trim(form.DVAsaldodias))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DVAsaldodias#">,
						<cfelse >
						0.00,
						</cfif>
						<cfif isdefined("form.DVASalarioProm") and len(trim(form.DVASalarioProm))>
							<cfqueryparam cfsqltype="cf_sql_money"   value="#REReplace(form.DVASalarioProm,',','','all')#">,
						<cfelse>
						0.00,
						</cfif>
						<cfif isdefined("form.DVASalarioPdiario") and len(trim(form.DVASalarioPdiario)) >
						<cfqueryparam cfsqltype="cf_sql_money"   value="#REReplace(form.DVASalarioPdiario,',','','all')#">,
						<cfelse>
						0.00,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_date"    value="#LSParseDateTime(form.DVAfecha)#">
					  )
	</cfquery>
	</cftransaction>
	<cfset params = params & "&DVAperiodo=#form.DVAperiodo#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="DVacacionesAcum"
		redirect="ControlVacaciones.cfm"
		timestamp="#form.ts_rversion#"
		field1="DEid,numeric,#form.DEid#"
		field2="DVAperiodo,integer,#form.DVAperiodo#">						

	<cfquery name="rs_insert" datasource="#session.dsn#">
		update DVacacionesAcum
		set DVAsaldodias = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DVAsaldodias#">, 
		    DVASalarioProm = <cfqueryparam cfsqltype="cf_sql_integer" value="#REReplace(form.DVASalarioProm,',','','all')#">,
			DVAfecha =<cfqueryparam cfsqltype="cf_sql_date" value="#form.DVAfecha#">,
			DVASalarioPdiario = <cfqueryparam cfsqltype="cf_sql_money" value="#REReplace(form.DVASalarioPdiario,',','','all')#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and DVAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVAperiodo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and DVAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVAid#">
	</cfquery>
	<cfset params = params & "&DVAperiodo=#form.DVAperiodo#&DVAid=#form.DVAid#">
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete DVacacionesAcum
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and DVAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVAperiodo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and DVAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVAid#">
	</cfquery>	
</cfif>

<cflocation url="ControlVacaciones.cfm#params#">