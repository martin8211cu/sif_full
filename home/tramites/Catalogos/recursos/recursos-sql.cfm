<cfparam name="modo" default="ALTA_REC">
<cfif not isdefined("Form.Nuevo_REC")>
	<cfif isdefined("Form.Alta_REC")>
		<cf_tr_direccion action="readform" name="direccion">
		<cf_tr_direccion action="insert" data="#direccion#" name="direccion">
		<cftransaction>
			<cfquery name="ABC_ins" datasource="#session.tramites.dsn#" >
				insert TPRecurso 
					(id_sucursal, id_direccion, id_tiporecurso, codigo_recurso, nombre_recurso, BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
					, <cfqueryparam cfsqltype="cf_sql_char"    value="#UCase(Form.codigo_recurso)#">
					, <cfqueryparam cfsqltype="cf_sql_varchar"    value="#Form.nombre_recurso#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					, getDate()
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_ins">
		</cftransaction>
		
		<cfset modo="CAMBIO_REC">
		<cfset Form.id_recurso = ABC_ins.identity>
	<cfelseif isdefined("Form.Baja_REC")>
 		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			delete TPRecurso 
			where  id_recurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_recurso#">				  
		</cfquery>
		<cfset modo="ALTA">
		
		<cfset p = "?tab=8&id_inst=#form.id_inst#">
		<cflocation url="../instituciones.cfm#p#">		
	<cfelseif isdefined("Form.Cambio_REC")>
		<cf_tr_direccion action="readform" name="direccion">
		<cf_tr_direccion action="update" key="#form.id_direccion#" data="#direccion#" name="direccion">

		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRecurso"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_recurso" 
			type1="numeric" 
			value1="#form.id_recurso#">
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			update TPRecurso set 
				codigo_recurso  	= <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Form.codigo_recurso)#">, 
				nombre_recurso  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_recurso#">, 
				id_direccion 	    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,  
				BMfechamod  	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				id_sucursal 	    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">,
				id_tiporecurso 	    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">,
				vigente_desde 	    = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">,
				vigente_hasta 	    = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">
				
			where id_recurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_recurso#">
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>			
</cfif>
<cfoutput>	
	<cfset p = "?tab=8&id_inst=#form.id_inst#">
	<cfif  not isdefined('form.btnLista_REC') and not isdefined("form.Nuevo_REC") and isdefined("form.id_recurso") and len(trim(form.id_recurso))>
		<cfset p = p & "&id_recurso=#form.id_recurso#">
	<cfelseif isdefined("form.Nuevo_REC")>	
		<cfset p = p & "&btnNuevo=btnNuevo">
	<cfelseif isdefined("form.Cambio_REC")>		
		<cfset p = p & "&id_recurso=#Form.id_recurso#">
	</cfif>
	<cflocation url="../instituciones.cfm#p#">
</cfoutput>