<cfset params = '' >
<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rs_insert" datasource="#session.dsn#">
		insert into RHGrupoNivel( Ecodigo, RHGNcodigo, RHGNdescripcion, BMUsucodigo, BMfechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHGNcodigo)#">,	
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHGNdescripcion)#">,	
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			  )
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="rs_insert">
	</cftransaction>
	<cfset params = "?RHGNid=#rs_insert.identity#">

<cfelseif isdefined("form.CAMBIO")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="RHGrupoNivel"
		redirect="grupoNivel.cfm#params#"
		timestamp="#form.ts_rversion#"
		field1="RHGNid,numeric,#form.RHGNid#">						

	<cfquery name="rs_insert" datasource="#session.dsn#">
		update RHGrupoNivel
		set RHGNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHGNcodigo)#">, 
		    RHGNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHGNdescripcion)#">
		where RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
	</cfquery>
	<cfset params = "?RHGNid=#form.RHGNid#">
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from RHGrupoNivel
		where RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
	</cfquery>
</cfif>

<cflocation url="grupoNivel.cfm#params#">