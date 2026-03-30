<cfif not isdefined("Form.btnNuevo")>
	<cfif isdefined("Form.btnAgregar")>
		<!--- Se valida nuevamente, por si no lo hace correctamente el js--->
		<cfquery datasource="asp" name="rsvalidasgmodulo">
			select SGcodigo from SGModulos where SGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SGcodigo_text#">
		</cfquery>
		<cfif rsvalidasgmodulo.RecordCount GE 1>
			<cflocation url = "GrpModulos.cfm?error=1" addToken = "no">
		<cfelse>
			<!--- Insertamos el nuevo Grpmodulo --->
			<cfquery datasource="asp">
				insert into SGModulos(SGcodigo,SGdescripcion,SScodigo,BMfecha,BMUsuCodigo,SGorden,SMlogo,IconFonts,SGhablada)
				values(
						<cfif len(trim(form.SGcodigo_text)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SGcodigo_text#">
						<cfelse>null</cfif>,
						<cfif len(trim(form.SGdescripcion)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGdescripcion#">
						<cfelse>null</cfif>,
						<cfif len(trim(form.SScodigo)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
						<cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfif len(trim(form.SSorden)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SSorden#">
						<cfelse>null</cfif>,
						<cf_dbupload filefield="logo" accept="image/*" datasource="asp">,
						<cfif len(trim(form.SGicon)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGicon#">
						<cfelse>null</cfif>,
						<cfif len(trim(form.SGhablada)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGhablada#">
						<cfelse>null</cfif>
						)
			</cfquery>
			<cflocation url = "GrpModulos.cfm" addToken = "no">
		</cfif>
	</cfif>
	<cfif isdefined("Form.btnEliminar")>
		<cfif len(trim(form.SGcodigo)) gt 0>
			<cfquery datasource="asp">
					delete SGModulos where SGcodigo = LTRIM(RTRIM(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGcodigo#">))
			</cfquery>
			<cflocation url = "GrpModulos.cfm" addToken = "no">
		</cfif>
	</cfif>
	<cfif isdefined("Form.btnCambiar")>
		<cfif len(trim(form.SGcodigo)) gt 0>
			<cfquery datasource="asp">
					UPDATE SGModulos set
						SGdescripcion= <cfif len(trim(form.SGdescripcion)) gt 0> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGdescripcion#">
							<cfelse>null</cfif>,
						SScodigo= LTRIM(RTRIM(<cfif len(trim(form.SScodigo)) gt 0> <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">))
							<cfelse>null</cfif>,
						SGorden= <cfif len(trim(form.SSorden)) gt 0> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SSorden#">
							<cfelse>null</cfif>,
						SMlogo= <cfif len(trim(form.SSorden)) gt 0> <cf_dbupload filefield="logo" accept="image/*" datasource="asp">
							<cfelse>null</cfif>,
						IconFonts = <cfif len(trim(form.SGicon)) gt 0> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGicon#">
							<cfelse>null</cfif>,
						SGhablada = <cfif len(trim(form.SGhablada)) gt 0> <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SGhablada#">
							<cfelse>null</cfif>
					where SGcodigo = LTRIM(RTRIM(<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SGcodigo#">))
			</cfquery>
			<cflocation url = "GrpModulos.cfm" addToken = "no">
		</cfif>
	</cfif>
</cfif>