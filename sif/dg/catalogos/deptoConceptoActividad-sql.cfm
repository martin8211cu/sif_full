
<cfset params = '?tab=2&DGAid=#form.DGAid#&DGCid=#form.DGCid#&tab2=1' >
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
		delete from DGConceptosActividadDepto
		where DGCADid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.idEliminar#">
	</cfquery>
	<cflocation url="actividades-tabs.cfm#params#">
</cfif>

<cfquery name="rsExiste" datasource="#session.DSN#" >
	select min(a.DGCADid) as DGCADid
	from DGConceptosActividadDepto a
	where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	  and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	  and a.PCDcatid is null	
</cfquery>

<cfif len(trim(rsExiste.DGCADid))>
	<cfquery datasource="#session.DSN#">
		update DGConceptosActividadDepto
		set PCDcatid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
			PCEcatid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
			DGCid2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid2#">
		where DGCADid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExiste.DGCADid#">
	</cfquery>
<cfelse>
	<cfquery datasource="#session.DSN#">
		insert INTO DGConceptosActividadDepto( DGAid,
											   DGCid,
											   PCEcatid,
											   PCDcatid,
											   DGCid2,	
											   Ecodigo,
											   CEcodigo,
											   BMUsucodigo, 
											   BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid2#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif>

<cflocation url="actividades-tabs.cfm#params#">