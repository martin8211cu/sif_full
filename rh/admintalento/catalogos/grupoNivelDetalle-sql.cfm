<cfset params = '' >
<cfif isdefined("form.ALTADET")>
	<cfquery datasource="#session.dsn#">
		insert into RHDGrupoNivel( RHGNid, Ecodigo, RHDGNcodigo, RHDGNdescripcion, RHDGNpeso, BMUsucodigo, BMfechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHDGNcodigo)#">,	
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHDGNdescripcion)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#replace(form.RHDGNpeso, ',', '', 'all')#">,	
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			  )
	</cfquery>
	<cfset params = "?RHGNid=#form.RHGNid#">

<cfelseif isdefined("form.CAMBIODET")>
	<!---
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="RHDGrupoNivel"
		redirect="grupoNivel.cfm#params#"
		timestamp="#form.ts_rversion#"
		field1="RHDGNid,numeric,#form.RHDGNid#">						
		--->

	<cfquery name="rs_insert" datasource="#session.dsn#">
		update RHDGrupoNivel
		set RHDGNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.RHDGNcodigo)#">, 
		    RHDGNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHDGNdescripcion)#">,
			RHDGNpeso = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#replace(form.RHDGNpeso, ',', '', 'all')#">
		where RHDGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDGNid#">
	</cfquery>
	<cfset params = "?RHGNid=#form.RHGNid#">
<cfelseif isdefined("form.BAJADET")>
	<cfquery datasource="#session.DSN#">
		delete from RHDGrupoNivel
		where RHDGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDGNid#">
	</cfquery>
	<cfset params = "?RHGNid=#form.RHGNid#">	
</cfif>

<cflocation url="grupoNivel.cfm#params#">