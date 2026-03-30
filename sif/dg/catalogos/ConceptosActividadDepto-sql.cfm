
<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGAcodigo")>
	<cfset params = params & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGCcodigo")>
	<cfset params = params & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCDvalor")>
	<cfset params = params & '&filtro_PCDvalor=#form.filtro_PCDvalor#' >
</cfif>

<cfif isdefined("form.ALTA")>
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
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>	
	<cflocation url="ConceptosActividadDepto.cfm#params#">

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGConceptosActividadDepto
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">
	</cfquery>
	<cflocation url="ConceptosActividadDepto-lista.cfm#params#">

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="ConceptosActividadDepto.cfm#params#">
</cfif>

<cfset params = params & '&DGAid=#form.DGAid#&DGCid=#form.DGCid#&PCEcatid=#form.PCEcatid#&PCDcatid=#form.PCDcatid#&Empresa=#form.Empresa#' >
<cflocation url="ConceptosActividadDepto.cfm#params#">