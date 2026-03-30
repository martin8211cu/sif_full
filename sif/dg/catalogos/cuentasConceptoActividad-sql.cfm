
<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGAcodigo")>
	<cfset params = params & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGAdescripcion")>
	<cfset params = params & '&filtro_DGAdescripcion=#form.filtro_DGAdescripcion#' >
</cfif>
<cfif isdefined("form.filtro_DGCcodigo")>
	<cfset params = params & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGdescripcion")>
	<cfset params = params & '&filtro_DGdescripcion=#form.filtro_DGdescripcion#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGCtasConceptoActividad(	DGAid, 
												DGCid, 
												Ecodigo,
												Cmayor,
												CEcodigo, 
												BMUsucodigo, 
												BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>	
	<cflocation url="cuentasConceptoActividad.cfm#params#">

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGCtasConceptoActividad
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
		  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">

	</cfquery>
	<cflocation url="cuentasConceptoActividad-lista.cfm#params#">

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="cuentasConceptoActividad.cfm#params#">
</cfif>

<cfset params = params & '&DGAid=#form.DGAid#&DGCid=#form.DGCid#&Empresa=#form.Empresa#&Cmayor=#form.Cmayor#' >
<cflocation url="cuentasConceptoActividad.cfm#params#">