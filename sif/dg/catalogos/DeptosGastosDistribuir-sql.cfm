
<cfset params = '?tab=2&DGGDid=#form.DGGDid#' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGGDcodigo")>
	<cfset params = params & '&filtro_DGGDcodigo=#form.filtro_DGGDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGGDdescripcion")>
	<cfset params = params & '&filtro_DGGDdescripcion=#form.filtro_DGGDdescripcion#' >
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
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGDeptosGastosDistribuir( DGGDid,
											  PCEcatid,
											  PCDcatid,
											  Elimina,
											  Ecodigo,
											  CEcodigo,
											  BMUsucodigo, 
											  BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfif isdefined("form.Elimina")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
	<cflocation url="gastosDistribuir-tabs.cfm#params#">	

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGDeptosGastosDistribuir
		set Elimina = <cfif isdefined("form.Elimina")>1<cfelse>0</cfif>
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	</cfquery>
	
	<cflocation url="gastosDistribuir-tabs.cfm#params#">

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGDeptosGastosDistribuir
		where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	</cfquery>
</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="gastosDistribuir-tabs.cfm#params#">
</cfif>

<cflocation url="gastosDistribuir-tabs.cfm#params#">