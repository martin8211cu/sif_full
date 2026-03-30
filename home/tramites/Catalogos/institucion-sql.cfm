<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cf_tr_direccion action="readform" name="direccion">
		<cf_tr_direccion action="insert" data="#direccion#" name="direccion">
		<cftransaction>
			<cfquery name="ABC_ins" datasource="#session.tramites.dsn#" >
				insert into TPInstitucion (
				codigo_inst,
				nombre_inst,
				id_direccion, 
				logo_inst,
				BMUsucodigo,
				BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_inst)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_inst#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,
					<cf_dbupload datasource="#session.tramites.dsn#" accept="image/*" filefield="logo_inst">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
				
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_ins">
			<cfset form.id_inst = ABC_ins.identity >
			
			<cfinvoke component="home.tramites.componentes.tramites"
				method="dar_permiso"
				tipo_sujeto="F"
				id_sujeto="#session.tramites.id_funcionario#"
				tipo_objeto="I"
				id_objeto="#form.id_inst#" />
			
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset Form.id_inst = ABC_ins.identity>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			delete TPInstitucion 
			where  id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">				  
		</cfquery>
		<cfset modo="ALTA">
		<cflocation url="instituciones-lista.cfm">
		
	<cfelseif isdefined("Form.Cambio")>
		<cf_tr_direccion action="readform" name="direccion">
		<cf_tr_direccion action="update" data="#direccion#" name="direccion">

		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPInstitucion"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_inst" 
			type1="numeric" 
			value1="#form.id_inst#">
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			update TPInstitucion set 
			codigo_inst  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_inst)#">, 
			nombre_inst  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_inst#">, 
			id_direccion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,

			<cfif Len(form.logo_inst)>
			logo_inst = <cf_dbupload datasource="#session.tramites.dsn#" accept="image/*" filefield="logo_inst">,
			</cfif>

			BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
			BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where  id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		</cfquery>
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>


<cfif isdefined("Form.Alta") or isdefined("Form.Cambio") >
	<cfquery datasource="#session.tramites.dsn#">
		delete TPRTipoInst
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
	</cfquery>

	<cfif isdefined("form.tipos")>
		<cfloop list="#form.tipos#" index="i">
			<cfquery datasource="#session.tramites.dsn#">
				insert into TPRTipoInst( id_inst, id_tipoinst, BMUsucodigo, BMfechamod )
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>

<cflocation url="instituciones.cfm?id_inst=#form.id_inst#">