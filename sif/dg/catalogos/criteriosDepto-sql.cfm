<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGCDcodigo")>
	<cfset params = params & '&filtro_DGCDcodigo=#form.filtro_DGCDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCDvalor")>
	<cfset params = params & '&filtro_PCDvalor=#form.filtro_PCDvalor#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGCriteriosDepto(	DGCDid,
										PCEcatid,
										PCDcatid,
										BMUsucodigo, 
										BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
	<cflocation url="criteriosDepto.cfm#params#">	

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGCriteriosDepto
		where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	</cfquery>
	<cflocation url="criteriosDepto-lista.cfm#params#">
</cfif>


<cfif isdefined("form.Nuevo")>
	<cflocation url="criteriosDepto.cfm#params#">
</cfif>

<cfset params = params & '&DGCDid=#form.DGCDid#&PCEcatid=#form.PCEcatid#&PCDcatid=#form.PCDcatid#' >
<cflocation url="criteriosDepto.cfm#params#">