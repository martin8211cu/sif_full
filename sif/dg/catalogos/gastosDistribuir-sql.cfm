
<cfset params = '?tab=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGGDcodigo")>
	<cfset params = params & '&filtro_DGGDcodigo=#form.filtro_DGGDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGGDdescripcion")>
	<cfset params = params & '&filtro_DGCDdescripcion=#form.filtro_DGCDdescripcion#' >
</cfif>
<cfif isdefined("form.filtro_DGCDcodigo")>
	<cfset params = params & '&filtro_DGCDcodigo=#form.filtro_DGCDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGCDdescripcion")>
	<cfset params = params & '&filtro_DGCDdescripcion=#form.filtro_DGCDdescripcion#' >
</cfif>

<cfif isdefined("form.proceso")>
	<cfset params = params & '&proceso=#form.proceso#' >
</cfif>
<cfif isdefined("form.periodo")>
	<cfset params = params & '&periodo=#form.periodo#' >
</cfif>
<cfif isdefined("form.mes")>
	<cfset params = params & '&mes=#form.mes#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGGastosDistribuir( CEcodigo, 
								  		DGGDcodigo, 
								  		DGGDdescripcion, 
										DGCDid,
										DGCid,
										DGCiddest,
										Criterio,	
								  		BMUsucodigo, 
								  		BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDdescripcion#">,
				<cfif listfind('70', form.tipo2) and isdefined("form.DGCDid") and len(trim(form.DGCDid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#"><cfelse>null</cfif>,
				<cfif listfind('20', form.tipo2) and isdefined("form.DGCid") and len(trim(form.DGCid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#"><cfelse>null</cfif>,
				<cfif isdefined("form.DGCiddest") and len(trim(form.DGCiddest)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCiddest#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Criterio#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset form.DGGDid = rsInsert.identity >
	</cftransaction>
	<cflocation url="gastosDistribuir-tabs.cfm#params#&DGGDid=#form.DGGDid#">

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGGastosDistribuir
		set Criterio = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Criterio#">,
			DGGDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDcodigo#">,
		    DGGDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDdescripcion#">,
			DGCDid = <cfif listfind('70', form.tipo2) and isdefined("form.DGCDid") and len(trim(form.DGCDid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#"><cfelse>null</cfif>,
			DGCid = <cfif listfind('20', form.tipo2) and isdefined("form.DGCid") and len(trim(form.DGCid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#"><cfelse>null</cfif>,
			DGCiddest = <cfif isdefined("form.DGCiddest") and len(trim(form.DGCiddest)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCiddest#"><cfelse>null</cfif>
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGGastosActividad
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from DGDeptosGastosDistribuir
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from DGGastosDistribuir
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>
	<cflocation url="gastosDistribuir-lista.cfm#params#">

</cfif>



<cfif isdefined("form.Nuevo")>
	<cflocation url="gastosDistribuir-tabs.cfm#params#">
</cfif>

<cfset params = params & '&DGGDid=#form.DGGDid#' >
<cflocation url="gastosDistribuir-tabs.cfm#params#">