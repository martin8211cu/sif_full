
<cfset params = '?tab=3&DGAid=#form.DGAid#' >
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
		delete from DGDepartamentosA
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.idEliminar#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">		  
	</cfquery>
	<cflocation url="actividades-tabs.cfm#params#">
</cfif>

<cfif isdefined("form.ALTA")>
	<cfquery datasource="#session.DSN#">
		insert INTO DGDepartamentosA( DGAid,
									  PCEcatid,
									  PCDcatid,
									  BMUsucodigo, 
									  BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif>

<cflocation url="actividades-tabs.cfm#params#">