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

<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGActividades( CEcodigo, 
								  DGAcodigo, 
								  DGAdescripcion, 
								  BMUsucodigo, 
								  BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset form.DGAid = rsInsert.identity >
	</cftransaction>
	<cflocation url="actividades-tabs.cfm#params#&DGAid=#form.DGAid#">

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGActividades
		set DGAcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAcodigo#">,
		    DGAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAdescripcion#">
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>
	<cflocation url="actividades-lista.cfm#params#">

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGCuentasConceptoActEli
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from DGConceptosActividadDepto
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from DGCtasConceptoActividad
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		delete from DGActividades
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
	</cfquery>
	<cflocation url="actividades-lista.cfm#params#">

</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="actividades-tabs.cfm#params#">
</cfif>

<cflocation url="actividades-tabs.cfm#params#">