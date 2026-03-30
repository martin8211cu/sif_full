<cfset modo = "ALTA">
<cfif isdefined("Form.Alta")>				
	<cftransaction>						
		<!---Inserta encabezado---->
		<cfquery name="insertEncab" datasource="#session.dsn#">
			insert into EncabNoticias(FechaNoticia, Autor, Titulo, 
								FechaDesde, FechaHasta, Ecodigo, 
								CEcodigo, IdCategoria, BMUsucodigo, 
								BMfechaalta, Orden, Activa, Tipo)
			values (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaNoticia)#">,
					<cfif isdefined("form.Autor") and len(trim(form.Autor))>
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Autor#">,
					<cfelse>
						null,	
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Titulo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdCategoria#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,				
					<cfif isdefined("form.Orden") and len(trim(form.Orden))>
						<cfqueryparam  cfsqltype="cf_sql_integer" value="#form.Orden#">,	
					<cfelse>
						 null,
					</cfif>
					<cfif isdefined("form.Activa") and len(trim(form.Activa))>'1',<cfelse>'0',</cfif>
					<cfif isdefined("form.Tipo") and len(trim(form.Tipo))>
						<cfqueryparam  cfsqltype="cf_sql_varchar" value="#form.Tipo#">
					<cfelse>
						 null
					</cfif>
					)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertEncab">
		<!---Inserta Detalle--->
		<cfif isdefined("form.Contenido") and len(trim(form.Contenido))>
			<cfquery datasource="#session.DSN#">
				insert into DetNoticias(IdNoticia, Contenido, RutaImagen, 
										BMUsucodigo, BMfechaalta)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertEncab.identity#">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Contenido#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RutaImagen#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
			</cfquery>
		</cfif>	
	</cftransaction>
<!----Modo BAJA---->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from DetNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
	</cfquery>	
	<cfquery datasource="#session.dsn#">
		delete from DetUsuariosNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from EncabNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
	</cfquery>			
<!----Modo CAMBIO----->
<cfelseif IsDefined("form.Cambio")>	

	<cf_dbtimestamp datasource="#session.dsn#"
		table="EncabNoticias"
		redirect="formNoticiasAutogestion.cfm"
		timestamp="#form.ts_rversion#"
		field1="IdNoticia"
		type1="numeric"
		value1="#form.IdNoticia#">		
	<!---Actualiza encabezado--->
	<cfquery datasource="#session.dsn#">
		update 	EncabNoticias
		set 	FechaNoticia = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaNoticia)#">,
				Autor= <cfif isdefined("form.Autor") and len(trim(form.Autor))>
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Autor#">,
						<cfelse>
							null,	
						</cfif>
				Titulo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Titulo#">,
				FechaDesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">,
				FechaHasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">,
				IdCategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdCategoria#">,
				Orden = 	<cfif isdefined("form.Orden") and len(trim(form.Orden))>
								<cfqueryparam  cfsqltype="cf_sql_integer" value="#form.Orden#">,	
							<cfelse>
								 null,
							</cfif>	
				Activa = <cfif isdefined("form.Activa") and len(trim(form.Activa))>'1',<cfelse>'0',</cfif>
				Tipo = 	<cfif isdefined("form.Tipo") and len(trim(form.Tipo))>
							<cfqueryparam  cfsqltype="cf_sql_varchar" value="#form.Tipo#">
						<cfelse>
							 null
						</cfif>				
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
	</cfquery>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select 1 from DetNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">		
	</cfquery>
	<cfif rsExiste.RecordCount NEQ 0>
		<!---Actualiza detalle--->
		<cfquery datasource="#session.DSN#">
			update DetNoticias
			set	Contenido = <cfif isdefined("form.Contenido") and len(trim(form.Contenido))>
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Contenido#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value=" ">,	
							</cfif>
				RutaImagen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RutaImagen#">
			where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">		
		</cfquery>
	<cfelseif rsExiste.RecordCount EQ 0 and isdefined("form.Contenido") and len(trim(form.Contenido))>
		<cfquery datasource="#session.DSN#">
			insert into DetNoticias(IdNoticia, Contenido, RutaImagen, 
									BMUsucodigo, BMfechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.Contenido#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RutaImagen#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					)
		</cfquery>	
	</cfif>
</cfif>
<cfoutput>
<cfset param = ''>
<cfif isdefined("form.Cambio")>
	<cfset param = param & "?IdNoticia=#form.IdNoticia#">
<cfelseif isdefined("Form.Alta") and isdefined("insertEncab.identity") and len(trim(insertEncab.identity))>
	 <cfset param = param & "?IdNoticia=#insertEncab.identity#">
</cfif>
<cflocation url="TabsNoticiasAutogestion.cfm#param#">
</cfoutput>
