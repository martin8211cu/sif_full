
<cfif isdefined("form.ALTA")>
	<cftransaction>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGDivisiones( CEcodigo, 
								  DGDcodigo, 
								  DGDdescripcion, 
								  BMUsucodigo, 
								  BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGDcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGDdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset form.DGDid = rsInsert.identity >
	</cftransaction>

<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update DGDivisiones
		set DGDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGDcodigo#">,
		    DGDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGDdescripcion#">
		where DGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGDid#">
	</cfquery>

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from DGDivisiones
		where DGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGDid#">
	</cfquery>
	<cflocation url="divisiones-lista.cfm">

<cfelseif isdefined("form.btnAgregar")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select Edescripcion,DGDcodigo, DGDdescripcion
		from DGEmpresasDivision a
		
		inner join DGDivisiones d
		on d.DGDid=a.DGDid

		inner join Empresas e
		on e.Ecodigo=a.Ecodigo

		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">
	</cfquery>

	<cfif rsExiste.recordcount gt 0 >
		<cf_errorCode	code = "50371"
						msg  = "La Empresa @errorDat_1@ ya ha sido agregada para la división @errorDat_2@ - @errorDat_3@."
						errorDat_1="#rsExiste.Edescripcion#"
						errorDat_2="#trim(rsExiste.DGDcodigo)#"
						errorDat_3="#rsExiste.DGDdescripcion#"
		>
	</cfif>

	<cfquery datasource="#session.DSN#">
		insert INTO DGEmpresasDivision(	DGDid, 
										CEcodigo, 
										Ecodigo, 
										BMUsucodigo, 
										BMfechaalta )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGDid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Empresa#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">	)
	</cfquery>

<cfelseif isdefined("form.btnEliminar") and form.btnEliminar eq 1>
	<cfquery datasource="#session.DSN#">
		delete from DGEmpresasDivision
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_borrar#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and DGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGDid#">
	</cfquery>
</cfif>

<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGDcodigo")>
	<cfset params = params & '&filtro_DGDcodigo=#form.filtro_DGDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGDdescripcion")>
	<cfset params = params & '&filtro_DGDdescripcion=#form.filtro_DGDdescripcion#' >
</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="divisiones.cfm#params#">
</cfif>

<cfset params = params & '&DGDid=#form.DGDid#' >
<cflocation url="divisiones.cfm#params#">

