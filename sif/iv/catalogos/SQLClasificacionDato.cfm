
<cfset parametros = "&Ccodigo=#form.Ccodigo#">
<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
		<cftransaction>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into ClasificacionesDato(Ecodigo, Ccodigo, CDdescripcion)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CDdescripcion#"> )
			<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="insert">	
		</cftransaction>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select CDcodigo
			from ClasificacionesDato 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
			order by CDdescripcion
		</cfquery>
		<cfset parametros = parametros &"&CDcodigo=#insert.identity#">
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.CDcodigo EQ insert.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.pagina = Ceiling(row / form.MaxRows)>
	<cfelseif isdefined("form.Cambio")>
		<cfquery name="update"  datasource="#session.DSN#">
			update ClasificacionesDato
			set CDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CDdescripcion#">
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CDcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
		</cfquery>
		<cfset parametros = parametros & "&CDcodigo=#form.CDcodigo#">
	<cfelseif isdefined("form.Baja")>
	
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select CDcodigo
			from ClasificacionesDato 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
			order by CDdescripcion
		</cfquery>
		<cfif  Ceiling(rsPagina.RecordCount/form.MaxRows) lt form.Pagina>
			<cfset form.Pagina  = rsPagina.RecordCount/form.MaxRows>
		</cfif>
		<cfquery name="update"  datasource="#session.DSN#">
			delete from ClasificacionesDato
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CDcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
		</cfquery>
	</cfif>

	<cfif isdefined("form.AgregarD")>
		<cftransaction>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into ClasificacionesValor(CDcodigo, CVvalor)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVvalor#"> )
			<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="insert">	
		</cftransaction>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select CVcodigo
			from ClasificacionesValor 
			where CDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
			order by CVvalor
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.CVcodigo EQ insert.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.Pagina2 = Ceiling(row / form.MaxRows2)>
		<cfset parametros = parametros & "&CDcodigo=#form.CDcodigo#">
	<cfelseif isdefined("form.CambioD")>
		<cfquery name="update" datasource="#session.DSN#">
			update ClasificacionesValor
			set CVvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CVvalor#">
			where  CDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
			   and CVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVcodigo#">
		</cfquery>
	<cfset parametros = parametros & "&CDcodigo=#form.CDcodigo#">
	<cfelseif isdefined("form.accion") and trim(form.accion) eq 3>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select CVcodigo
			from ClasificacionesValor 
			where CDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
			order by CVvalor
		</cfquery>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from ClasificacionesValor
			where  CDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
			  and  CVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVcodigo#">
		</cfquery>
		<cfif  Ceiling(rsPagina.RecordCount/form.MaxRows2) lt form.Pagina2>
			<cfset form.Pagina2  = rsPagina.RecordCount/form.MaxRows2>
		</cfif>
		<cfset parametros = parametros & "&CDcodigo=#form.CDcodigo#">
	</cfif>		
	<cfif isdefined('form.Pagina2')>
	<cfset parametros = parametros&"&Pagina2=#form.Pagina2#">
	</cfif>
</cfif>

<cfoutput>


<cflocation url="ClasificacionesDato.cfm?Pagina=#form.Pagina##parametros#">
</cfoutput>