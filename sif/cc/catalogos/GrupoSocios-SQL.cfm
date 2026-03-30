<!--- <cf_dump var="#form#"> --->
<cfset params = "">
<cftransaction>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("form.ALTA")>
		<cfquery name="InsGrupoSocios" datasource="#session.DSN#">
			insert INTO GrupoSNegocios
				(Ecodigo, GSNcodigo, GSNdescripcion, BMUsucodigo)
			values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.GSNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GSNdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				   )
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="InsGrupoSocios">	
		<cfquery name="rsPagina" datasource="#session.DSN#">
			 select GSNid
			 from GrupoSNegocios 
			 where 1=1 
			   <cfif isdefined('form.filtro_GSNcodigo') and LEN(TRIM(form.filtro_GSNcodigo))>
			   and upper(GSNcodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(form.filtro_GSNcodigo)#">
			   </cfif>
			   <cfif isdefined('form.filtro_GSNdescripcion') and LEN(TRIM(form.filtro_GSNdescripcion))>
			   and upper(GSNdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(form.filtro_GSNdescripcion)#">
			   </cfif>
			   and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by GSNcodigo
		</cfquery>
		<cfset params=params&"&GSNid="&InsGrupoSocios.identity>	
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.GSNid EQ InsGrupoSocios.identity>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.pagina = Ceiling(row / form.MaxRows)>
	<cfelseif isdefined("Form.CAMBIO")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="GrupoSNegocios"
						redirect="GrupoSocios.cfm"
						timestamp="#form.ts_rversion#"
						field1="GSNid" type1="numeric" value1="#form.GSNid#">
		<cfquery name="UpdGrupoSocios" datasource="#session.DSN#">
			update GrupoSNegocios
			set GSNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GSNcodigo#">,
				GSNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GSNdescripcion#">
			where GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
		</cfquery>
		<cfset params=params&"&GSNid="&form.GSNid>	
	<cfelseif isdefined("Form.BAJA")>
		<cfquery name="DelGrupoSocios" datasource="#session.DSN#">
			delete from GrupoSNegocios
			where GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
		</cfquery>
		<cfset form.pagina = 1> 
	</cfif>
</cfif>
</cftransaction>
<cflocation url="GrupoSocios.cfm?Pagina=#Form.Pagina#&filtro_GSNcodigo=#form.filtro_GSNcodigo#&filtro_GSNdescripcion=#form.filtro_GSNdescripcion#&hfiltro_GSNcodigo=#form.filtro_GSNcodigo#&hfiltro_GSNdescripcion=#form.filtro_GSNdescripcion##params#">
