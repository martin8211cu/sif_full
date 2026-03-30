<cfparam name="modo" default="ALTA">

<cfif isdefined("Form.Nuevo")>
	<cflocation url="tipo-identificacion-tabs.cfm">
<cfelse>
	<cfif isdefined("Form.Alta")>
	
		<cftransaction>
			<!--- insertar tipo de datos compuesto para usar en documento y en tipo identificacion --->
		
			<cfquery name="insert_DDTipo" datasource="#session.tramites.dsn#">
				insert into DDTipo(nombre_tipo, descripcion_tipo,
									clase_tipo, tipo_dato,
									mascara, formato,
									valor_minimo, valor_maximo,
									longitud, escala, nombre_tabla, es_documento, es_persona,
									BMfechamod, BMUsucodigo)
				 values( <cfqueryparam cfsqltype="cf_sql_varchar" value="Identificación: #Form.nombre_tipoident#">, 
						 	'', 'C','S',
							null, null,
							null, null,
							null, null, null, 1, 1,
							<cfqueryparam cfsqltype ="cf_sql_timestamp" value ="#Now()#">,
							<cfqueryparam cfsqltype ="cf_sql_numeric" 	value ="#session.usucodigo#">
							)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="insert_DDTipo">
			
			<cfquery datasource="#session.tramites.dsn#" name="tipodoc">
				select min(id_tipodoc) as id_tipodoc from TPTipoDocumento
			</cfquery>
			
			
			<cfquery name="insertDDVista" datasource="#session.tramites.dsn#">     
				insert into DDVista(id_tipo, nombre_vista, titulo_vista,
					 BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta, 
					 es_masivo, es_individual, es_interna)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_DDTipo.identity#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipoident#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipoident#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100,1,1)#">,
						0,1,1
					)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>			
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="insertDDVista">
			<cfquery name="insertDDVistaGrupo" datasource="#session.tramites.dsn#">
				insert into DDVistaGrupo 
					(id_vista, etiqueta, columna, orden, borde, BMfechamod, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertDDVista.identity#" >,
					'General', 1, 1, 0, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >
					)
			</cfquery>
			
			
			<!--- insertar tipo de datos compuesto para usar en documento y en tipo identificacion --->
			<cfquery name="insert_TPDocumento" datasource="#session.tramites.dsn#">
				insert into TPDocumento ( 	
							id_tipo,
							id_tipodoc,
							codigo_documento, 
							nombre_documento,
							
							es_tipoident,
							
							id_inst,
							BMUsucodigo,
							vigente_desde,
							vigente_hasta,
							BMfechamod)
				values ( 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_DDTipo.identity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#tipodoc.id_tipodoc#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_tipoident)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Identificación: #Form.nombre_tipoident#">, 
						1,
					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				  )
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="insert_TPDocumento">
			
			<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">
				insert into TPTipoIdent (codigo_tipoident ,
					nombre_tipoident,id_tipo, BMUsucodigo,BMfechamod, es_fisica, mascara,
					id_documento, id_vista_ventanilla)
				values (
					<cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_tipoident)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipoident#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_DDTipo.identity#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_fisica')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert_TPDocumento.identity#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertDDVista.identity#">
				)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_TpoIden">
			
			<cfset form.id_tipoident = ABC_TpoIden.identity>
		
		</cftransaction>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery name="hdr" datasource="#session.tramites.dsn#">			
				select id_tipo, id_documento, id_vista_ventanilla
				from TPTipoIdent
				where  id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoident#">
			</cfquery>
			<cfquery name="ABC_TpoIden" datasource="#session.tramites.dsn#">			
				delete TPTipoIdent 
				where  id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoident#">				  
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">			
				delete from TPDocumento
				where  id_documento  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_documento#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">			
				delete from DDTipoCampo
				where  id_tipo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_tipo#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">			
				delete from DDVistaGrupo
				where  id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_vista_ventanilla#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">			
				delete from DDVista 
				where  id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_vista_ventanilla#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">			
				delete from DDTipo 
				where  id_tipo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_tipo#">
			</cfquery>
		</cftransaction>
		<cfset form.id_tipoident = ''>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTipoIdent"
			redirect="tipo-identificacion.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_tipoident" 
			type1="numeric" 
			value1="#form.id_tipoident#">
			
		<cfquery datasource="#session.tramites.dsn#">			
			update TPTipoIdent set 
				codigo_tipoident = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_tipoident)#">, 
				nombre_tipoident = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tipoident#">, 
				BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
				BMfechamod  	 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				mascara          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">, 
				es_fisica        = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_fisica')#">
			where  id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoident#">
		</cfquery>
		
		<cfquery name="hdr" datasource="#session.tramites.dsn#">			
			select id_tipo,id_documento
			from TPTipoIdent
			where  id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoident#">
		</cfquery>
		<cfif len(hdr.id_tipo)>
			<cfquery datasource="#session.tramites.dsn#">			
				update DDTipo set 
					nombre_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="Identificación: #Form.nombre_tipoident#">, 
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
					BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where  id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_tipo#">
			</cfquery>
		</cfif>
		<cfif len(hdr.id_documento)>
			<cfquery datasource="#session.tramites.dsn#">			
				update TPDocumento set 
					codigo_documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_tipoident)#">, 
					nombre_documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="Identificación: #Form.nombre_tipoident#">,
					id_inst         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_inst#">, 
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
					BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where  id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.id_documento#">
			</cfquery>
		</cfif>
		
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>

<cflocation url="tipo-identificacion-tabs.cfm?id_tipoident=#form.id_tipoident#">
