<cfset params = '?tab=2&DGCid=#form.DGCid#' >
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
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGCuentasConcepto( DGCid, 
								  	   Cmayor, 
								       BMUsucodigo,
									   BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
	</cfquery>	
	<cflocation url="conceptos-tabs.cfm#params#">

<cfelseif isdefined("url.idEliminar")>
	<cfquery datasource="#session.DSN#">
		delete from DGCuentasConcepto
		where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.idEliminar#">
	</cfquery>
	<cflocation url="conceptos-tabs.cfm#params#">

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="conceptos-tabs.cfm#params#">
</cfif>
<cflocation url="conceptos-tabs.cfm#params#">