<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGCDcodigo")>
	<cfset params = params & '&filtro_DGCDcodigo=#form.filtro_DGCDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGCDdescripcion")>
	<cfset params = params & '&filtro_DGCDdescripcion=#form.filtro_DGCDdescripcion#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGCriteriosDistribucion( CEcodigo, 
								  DGCDcodigo, 
								  DGCDdescripcion, 
								  BMUsucodigo, 
								  BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCDcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCDdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset form.DGCDid = rsInsert.identity >
	</cftransaction>
	<cflocation url="criterios.cfm#params#">

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGCriteriosDistribucion
		set DGCDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCDcodigo#">,
		    DGCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCDdescripcion#">
		where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
	</cfquery>
	<cflocation url="criterios-lista.cfm#params#">

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGCriteriosDistribucion
		where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
	</cfquery>
	<cflocation url="criterios-lista.cfm#params#">

<cfelseif isdefined("form.btnAgregar")>
	<cfquery datasource="#session.DSN#">
		insert INTO DGEmpresasDivision(	DGCDid, 
										CEcodigo, 
										Ecodigo, 
										BMUsucodigo, 
										BMfechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
	</cfquery>

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="criterios.cfm#params#">
</cfif>

<cfset params = params & '&DGCDid=#form.DGCDid#' >
<cflocation url="criterios.cfm#params#">