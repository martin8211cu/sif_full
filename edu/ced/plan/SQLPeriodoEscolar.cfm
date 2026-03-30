<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de febrero del 2006
	Motivo: Actualizacin de fuentes de educacin a nuevos estndares de Pantallas y Componente de Listas.
 ---> 

<cfset pagina = "1">
<cfset params="">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="rsConsultaPE" datasource="#session.Edu.DSN#">
				select PEcodigo
				from PeriodoEscolar a, Nivel b
					where a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
					  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					  and rtrim(ltrim(a.PEdescripcion)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.PEdescripcion)#">
					  and a.Ncodigo = b.Ncodigo
			</cfquery>
			<cfif isdefined('rsConsultaPE') and rsConsultaPE.RecordCount EQ 0>
				<cfquery name="rsMaxOrden" datasource="#session.Edu.DSN#">
					select coalesce(max(a.PEorden),0) + 10 as PEorden
					from PeriodoEscolar a, Nivel b
					where a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
					  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					  and a.Ncodigo = b.Ncodigo
				</cfquery>
				<cfquery name="rsInsertPE" datasource="#session.Edu.DSN#">
					insert into PeriodoEscolar ( Ncodigo, PEdescripcion, PEorden )
						values
							(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PEdescripcion#">,
								<cfif LEN(TRIM(Form.PEorden)) NEQ 0 >
									<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.PEorden#">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsMaxOrden.PEorden#">
								</cfif>
							)
					<cf_dbidentity1 datasource="#session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.Edu.DSN#" name="rsInsertPE">
				<cfset form.PEcodigo = rsInsertPE.identity>
			<cfelse>
				<cfthrow message="Error, La Descripcion del Tipo de Curso Lectivo ya existe, Proceso Cancelado"/>
				<cfabort>
			</cfif>
		</cftransaction>
		<cfquery name="rsPagina" datasource="#session.Edu.DSN#">
			select PEcodigo
			from PeriodoEscolar a, Nivel b
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.Ncodigo = b.Ncodigo
			  <cfif isdefined('form.Filtro_PEdescripcion') and LEN(TRIM(form.Filtro_PEdescripcion))>
			  and PEdescripcion like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Filtro_PEdescripcion#%">
			  </cfif>
			  <cfif isdefined('form.Filtro_PEorden') and form.Filtro_PEorden GT 0>
			  and PEorden =  <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_PEorden#">
			  </cfif>
			  order by b.Norden, a.PEorden
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.PEcodigo EQ form.PEcodigo>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset pagina = Ceiling(row / form.MaxRows)>
		<cfset params=params&"PEcodigo="&rsInsertPE.identity&"&Ncodigo="&form.Ncodigo>
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="rsConsultaPE" datasource="#session.Edu.DSN#">
			select a.PEcodigo
			from PeriodoEscolar a, SubPeriodoEscolar b
			where a.PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			  and a.PEcodigo = b.PEcodigo
		</cfquery>
		<cfquery name="rsMaxOrden" datasource="#session.Edu.DSN#">
			select coalesce(max(a.PEorden),0)+10 as PEorden
			from PeriodoEscolar a, SubPeriodoEscolar b
			where a.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
			  and a.PEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			  and a.PEcodigo = b.PEcodigo
		</cfquery>
		<cfquery name="rsUpdatePE" datasource="#session.Edu.DSN#">
			update PeriodoEscolar 
			set	PEdescripcion = <cfqueryparam value="#Form.PEdescripcion#" cfsqltype="cf_sql_varchar">,
			<cfif isdefined('rsConsultaPE') and rsConsultaPE.RecordCount EQ 0>
				Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">,
			</cfif>
			<cfif LEN(TRIM(Form.PEorden))>
				PEorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.PEorden#">
			<cfelse>
				PEorden = <cfqueryparam cfsqltype="cf_sql_smallint" value="#rsMaxOrden.PEorden#">
			</cfif>
			where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			  and Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form._Ncodigo#">
		</cfquery>
		<cfquery name="rsPagina" datasource="#session.Edu.DSN#">
			select PEcodigo
			from PeriodoEscolar a, Nivel b
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.Ncodigo = b.Ncodigo
			  <cfif isdefined('form.Filtro_PEdescripcion') and LEN(TRIM(form.Filtro_PEdescripcion))>
			  and PEdescripcion like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Filtro_PEdescripcion#%">
			  </cfif>
			  <cfif isdefined('form.Filtro_PEorden') and form.Filtro_PEorden GT 0>
			  and PEorden =  <cfqueryparam cfsqltype="cf_sql_smallint" value="#form.Filtro_PEorden#">
			  </cfif>
			  order by b.Norden, a.PEorden
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.PEcodigo EQ form.PEcodigo>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset pagina = Ceiling(row / form.MaxRows)>
		<cfset params=params&"PEcodigo="&form.PEcodigo&"&Ncodigo="&form.Ncodigo>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDeletePE" datasource="#Session.Edu.DSN#">
			delete PeriodoEscolar
			where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			  and Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form._Ncodigo#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="PeriodoEscolar.cfm?Pagina=#pagina#&Filtro_PEdescripcion=#form.Filtro_PEdescripcion#&Filtro_PEorden=#form.Filtro_PEorden#&HFiltro_PEdescripcion=#form.Filtro_PEdescripcion#&HFiltro_PEorden=#form.Filtro_PEorden#&#params#">

