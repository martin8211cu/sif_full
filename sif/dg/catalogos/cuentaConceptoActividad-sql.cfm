
<cfset params = '?tab=2&DGAid=#form.DGAid#&DGCid=#form.DGCid#&tab2=2' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGAcodigo")>
	<cfset params = params & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGAdescripcion")>
	<cfset params = params & '&filtro_DGAdescripcion=#form.filtro_DGAdescripcion#' >
</cfif>


<cfif isdefined("url.idEliminar") and len(trim(url.idEliminar))>
	<cfquery datasource="#session.DSN#">
		delete from DGCuentasConceptoActEli
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		  and idCat2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.idEliminar2#">
		  and idCat1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.idEliminar#">
	</cfquery>
	<cflocation url="actividades-tabs.cfm#params#">
</cfif>

<cfquery datasource="#session.DSN#">
	insert INTO DGCuentasConceptoActEli( DGAid, 
										 DGCid, 
										 idCat1, 
										 idCat2, 
										 BMUsucodigo,
										 BMfechaalta )
	values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
</cfquery>

<cflocation url="actividades-tabs.cfm#params#">