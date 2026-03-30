<cfset params = '?tab=2&DGAid=#form.DGAid#' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGAcodigo")>
	<cfset params = params & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGAdescripcion")>
	<cfset params = params & '&filtro_DGAdescripcion=#form.filtro_DGAdescripcion#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGConceptosActividadDepto( DGAid,
											   DGCid,
											   PCEcatid,
											   PCDcatid,
											   Ecodigo,
											   CEcodigo,
											   BMUsucodigo, 
											   BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">,
				null,
				null,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	</cftransaction>
	<cflocation url="actividades-tabs.cfm#params#&DGCid=#form.DGCid#">

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGConceptosActividadDepto
		set DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		where DGCADid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCADid#">
	</cfquery>
	<cflocation url="actividades-tabs.cfm#params#">

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGConceptosActividadDepto
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
	</cfquery>
	<cflocation url="actividades-tabs.cfm#params#">

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="actividades-tabs.cfm#params#">
</cfif>

<cflocation url="actividades-tabs.cfm#params#">