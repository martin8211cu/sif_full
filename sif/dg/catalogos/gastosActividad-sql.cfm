
<cfset params = '?tab=3&DGGDid=#form.DGGDid#' >
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
		insert INTO DGGastosActividad(	DGAid, 
										DGGDid, 
										Criterio, 
										ValorFactor, 
										DGCid, 
										DGCDid, 
										CEcodigo, 
										BMUsucodigo, 
										BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Criterio#">,
				<cfif listfind('0,10', form.Criterio)><cfif listfind('0,10', form.Criterio)><cfif len(trim(form.ValorFactor)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.ValorFactor,',','','all')#" scale="4"><cfelse>0</cfif><cfelse>null</cfif><cfelse>null</cfif>,
				null,
				null,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
	<cflocation url="gastosDistribuir-tabs.cfm#params#">


<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGGastosActividad
		set ValorFactor = <cfif listfind('0,10', form.Criterio)><cfif len(trim(form.ValorFactor)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.ValorFactor,',','','all')#" scale="4"><cfelse>0</cfif><cfelse>null</cfif>
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">
	</cfquery>

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGGastosActividad
		where DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#">
		  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#">

	</cfquery>

</cfif>




<cfif isdefined("form.Nuevo")>
	<cflocation url="gastosDistribuir-tabs.cfm#params#">
</cfif>

<cflocation url="gastosDistribuir-tabs.cfm#params#">