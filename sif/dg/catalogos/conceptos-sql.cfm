<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGCcodigo")>
	<cfset params = params & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGdescripcion")>
	<cfset params = params & '&filtro_DGdescripcion=#form.filtro_DGdescripcion#' >
</cfif>
<cfif isdefined("form.filtro_DGtipo")>
	<cfset params = params & '&filtro_DGtipo=#form.filtro_DGtipo#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGConceptosER( CEcodigo, 
								  DGCcodigo, 
								  DGdescripcion,
								  DGtipo,
								  Comportamiento,
								  referencia,	 
								  BMUsucodigo, 
								  BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.DGtipo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Comportamiento#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.referencia#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset form.DGCid = rsInsert.identity >
	</cftransaction>
	<cflocation url="conceptos-tabs.cfm#params#&DGCid=#form.DGCid#">

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGConceptosER
		set DGCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCcodigo#">,
		    DGdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGdescripcion#">,
			DGtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DGtipo#">,
			Comportamiento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Comportamiento#">,
			referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.referencia#">
		where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
	</cfquery>

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGConceptosER
		where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
	</cfquery>
	<cflocation url="conceptos-lista.cfm#params#">

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="conceptos-tabs.cfm#params#">
</cfif>

<cfset params = params & '&DGCid=#form.DGCid#' >
<cflocation url="conceptos-tabs.cfm#params#">