<cfset action = "Biblioteca.cfm">
<cfif not isdefined("form.Nuevo") and  not isdefined("form.NuevoDet")>
	
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.ALTA")>
			<cfquery name="rsAlta" datasource="#Session.Edu.DSN#">	
				if not exists ( select 1 from MATipoDocumento a
					where a.id_biblioteca = <cfqueryparam value="#Form.id_biblioteca#" cfsqltype="cf_sql_numeric">
					  and rtrim(ltrim(a.nombre_tipo)) = <cfqueryparam value="#Form.nombre_tipo#" cfsqltype="cf_sql_varchar">
				)
				begin
					insert MATipoDocumento (id_biblioteca, nombre_tipo)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_biblioteca#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipo#">
								)
					select convert(varchar, @@identity) as id
				end
				else
					select 1
			</cfquery>
			
			<cfif not isdefined("rsAlta.id")>
				<cfset Request.Error.Url = "Biblioteca.cfm?Pagina=#form.pagina#& Filtro_nombre_tipo=#Form.Filtro_nombre_tipo#">
				<cfthrow message="Error: Ya existe un tipo de documento con el mismo nombre que digito">	
			</cfif>
		
		<!--- Caso 1.1: Cambia Encabezado --->
		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>		
				<cfquery name="rsCambio" datasource="#Session.Edu.DSN#">
					update MATipoDocumento
					set nombre_tipo = <cfqueryparam value="#form.nombre_tipo#" cfsqltype="cf_sql_varchar">
					where id_tipo = <cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
					  and id_biblioteca=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_biblioteca#">	
				</cfquery>
			</cftransaction>
		
		<!--- Caso 2: Borrar un Encabezado del Tipo de MAAtributo --->
		<cfelseif isdefined("Form.Baja")>			
			<cftransaction>
				<cfquery name="rsBaja" datasource="#Session.Edu.DSN#">
					delete MAAtributo 
						from  MAAtributo a , MATipoDocumento b
						where a.id_tipo=<cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">				
						  and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						  and a.id_tipo = b.id_tipo 
							 
						delete MATipoDocumento
						where id_tipo=<cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cftransaction>
			<cfset action = "listaBiblioteca.cfm">
			
		<!--- Caso 3: Agregar Detalle de MAAtributo y opcionalmente modificar el encabezado --->
		<cfelseif isdefined("Form.AltaDet")>
			<cfquery name="rsAltaD" datasource="#Session.Edu.DSN#">
				if not exists ( select 1 from MAAtributo a
					where a.id_tipo = <cfqueryparam value="#Form.id_tipo#" cfsqltype="cf_sql_numeric">
				  	and a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
				  	and rtrim(ltrim(a.nombre_atributo)) = <cfqueryparam value="#Form.nombre_atributo#" cfsqltype="cf_sql_varchar">
				)
				begin
						declare @cont int
						select @cont = isnull(max(a.orden_atributo),0)+10 
						from MAAtributo a
						where a.id_tipo = <cfqueryparam value="#Form.id_tipo#" cfsqltype="cf_sql_numeric">
						  and a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
						  
						insert MAAtributo 
						(id_tipo, CEcodigo, nombre_atributo, orden_atributo, tipo_atributo)
						values (<cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#form.nombre_atributo#" cfsqltype="cf_sql_varchar">,
								<cfif len(trim(#Form.orden_atributo#)) NEQ 0 >
									<cfqueryparam value="#Form.orden_atributo#" cfsqltype="cf_sql_integer">,
								<cfelse>
									@cont,	
								</cfif>
								<cfqueryparam value="#form.tipo_atributo#" cfsqltype="cf_sql_char">)			
						select convert(varchar, @@identity) as id
						
				end
				else
						select 1
			</cfquery>
			<cfif not isdefined("rsAltaD.id")>
				<cfset Request.Error.Url = "Biblioteca.cfm?id_tipo=#form.id_tipo#&Pagina=#form.pagina#&Pagina2=#form.pagina2#&Filtro_nombre_tipo=#Form.Filtro_nombre_tipo#&Filtro_nombre_atr=#Form.Filtro_nombre_atr#&Filtro_tipoAtr=#Form.Filtro_tipoAtr#">
				<cfthrow message="Error: Ya existe un Atributo con el mismo nombre que digito">	
			</cfif>
		
		<!--- Caso 4: Modificar Detalle de Tabla de Evaluacion y modificar el encabezado --->			
		<cfelseif isdefined("Form.CambioDet")>
			<cftransaction>
			<cfquery name="rsCambioD" datasource="#Session.Edu.DSN#">
				if exists ( select 1 from MAAtributo a
					where a.id_atributo = <cfqueryparam value="#Form.id_atributo#" cfsqltype="cf_sql_numeric">
					  and a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
					)
					begin
						declare @cont int
						select @cont = isnull(max(a.orden_atributo),0)+10 
						from MAAtributo a
						where a.id_atributo = <cfqueryparam value="#Form.id_atributo#" cfsqltype="cf_sql_numeric">
						  and a.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
						  and id_atributo != <cfqueryparam value="#form.id_atributo#" cfsqltype="cf_sql_numeric">
						  
						update MAAtributo
						set	nombre_atributo = <cfqueryparam value="#form.nombre_atributo#" cfsqltype="cf_sql_varchar">,
						
							<cfif len(trim(#Form.orden_atributo#)) NEQ 0 >
								orden_atributo = <cfqueryparam value="#form.orden_atributo#" cfsqltype="cf_sql_integer">,
							<cfelse>
								orden_atributo = @cont,	
							</cfif>
							tipo_atributo  = <cfqueryparam value="#form.tipo_atributo#" cfsqltype="cf_sql_char">
						from MAAtributo a , MATipoDocumento b					
						where a.id_tipo = <cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
						  and id_atributo = <cfqueryparam value="#form.id_atributo#" cfsqltype="cf_sql_numeric">
						  and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						  and a.id_tipo = b.id_tipo 
		
					end
					else
						select 1
			</cfquery>
			</cftransaction>
			
		<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
		<cfelseif isdefined("Form.BajaDet")>
			<cftransaction>
			<cfquery name="rsBajaD" datasource="#Session.Edu.DSN#">
				delete MAAtributo 
				from MAAtributo a , MATipoDocumento b					
				where a.id_tipo = <cfqueryparam value="#form.id_tipo#" cfsqltype="cf_sql_numeric">
				  and id_atributo = <cfqueryparam value="#form.id_atributo#" cfsqltype="cf_sql_numeric">
				  and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  and a.id_tipo = b.id_tipo 
			</cfquery>
			</cftransaction>
		</cfif>
</cfif> 				

<!--- En caso de que se agrague un detalle y encabezado, se asigna a la varible form --->
<cfif isdefined("Form.Alta")>
	<cfset Form.id_tipo = rsAlta.id>
</cfif>
<cfif isdefined("Form.AltaDet")>
	<cfset form.id_atributo = rsAltaD.id>
</cfif>

<!--- Concatena las variables que van a ser enviadas por la URL --->	
<!---ids--->
<cfset paramsId="">
<cfif isdefined("form.id_tipo")>
	<cfset paramsId= "&id_tipo="&Form.id_tipo>
</cfif>
<cfset paramsIdD="">
<cfif isdefined("form.id_atributo")>
	<cfset paramsIdD= "&id_atributo="&Form.id_atributo>
</cfif>
<!---Páginas--->
<cfset paramsPagina="">
<cfif isdefined("form.Pagina")>
	<cfset paramsPagina="&Pagina="&Form.Pagina>
</cfif>
<cfset paramsPaginaD="">
<cfif isdefined("form.Pagina2")>
	<cfset paramsPaginaD="&Pagina2="&Form.Pagina2>
</cfif>
<!---filtros--->
<cfset paramsFiltro = "">
<cfif isdefined("form.Filtro_nombre_tipo") and len(trim(form.Filtro_nombre_tipo))>
	<cfset paramsFiltro="&Filtro_nombre_tipo="&form.Filtro_nombre_tipo>
</cfif>
<cfset paramsFiltroD = "">
<cfif isdefined("form.Filtro_nombre_atr") and len(trim(form.Filtro_nombre_atr))>
	<cfset paramsFiltroD="&Filtro_nombre_atr="&form.Filtro_nombre_atr>
</cfif>
<cfif isdefined("form.Filtro_tipoAtr") and len(trim(form.Filtro_tipoAtr))>
	<cfset paramsFiltroD= paramsFiltroD &"&Filtro_tipoAtr="&form.Filtro_tipoAtr>
</cfif>

<!-----------------Redirecciona la pantalla mandaondo los variables segun sea el caso--------------------->	
<cfif isdefined("Form.Cambio") or isdefined("Form.CambioDet") or  isdefined("Form.AltaDet")>
	<cflocation url="Biblioteca.cfm?#paramsId##paramsIdD##paramsPagina##paramsPaginaD##paramsFiltro##paramsFiltroD#">
<cfelseif  isdefined("form.BajaDet") or isdefined("form.NuevoDet")>
	<cflocation url="Biblioteca.cfm?#paramsId##paramsPagina##paramsPaginaD##paramsFiltro##paramsFiltroD#">
<cfelseif isdefined("Form.Alta")>
	<cflocation url="Biblioteca.cfm?#paramsId##paramsPagina##paramsFiltro#">
<cfelseif isdefined("form.Baja")>
	<cflocation url="listaBiblioteca.cfm?#paramsPagina##paramsFiltro#">
<cfelseif isdefined("form.Nuevo")>
	<cflocation url="Biblioteca.cfm?#paramsPagina##paramsFiltro#">
</cfif>
