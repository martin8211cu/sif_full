

<cfparam name="modo" default="ALTA">
<cfset tab = '1'>

<cfif not isdefined("Form.Nuevo")>
	<!--- ************************************ ALTA  ******************************* --->
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="Insert_DDTipo" datasource="#session.tramites.dsn#">
				insert into DDTipo(nombre_tipo,
										descripcion_tipo,
										clase_tipo,
										tipo_dato,
										mascara,
										formato,
										valor_minimo,
										valor_maximo,
										longitud,
										escala,
										nombre_tabla,
										BMfechamod,
										BMUsucodigo,
										es_documento)
				 values( <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_documento#">, 
						 	'',
							'C',
							'S',
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							<cfqueryparam cfsqltype ="cf_sql_timestamp" value ="#Now()#">,
							<cfqueryparam cfsqltype ="cf_sql_numeric" 	value ="#session.usucodigo#">,
							1)
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="Insert_DDTipo">

			
			
			<cfquery name="ABC_Documento" datasource="#session.tramites.dsn#">
				insert into TPDocumento ( 	
											id_tipo,
											id_tipodoc,
											codigo_documento, 
											nombre_documento,
											descripcion_documento,
											id_inst,
											con_url,  
											con_usuario,
											con_passwd,										             
											BMUsucodigo,
											vigente_desde,
											vigente_hasta,
											BMfechamod)
				values ( 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Insert_DDTipo.identity#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipodoc#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_documento)#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_documento#">, 
						 null,
					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				  )
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_Documento">
			<cfset Form.id_documento = ABC_Documento.identity>
			
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset tab = '1'>
	<!--- ************************************ BAJA  ******************************* --->
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Documento" datasource="#session.tramites.dsn#">			
				delete TPDocumento
				where  id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">				  
			</cfquery>
			<cfset modo="ALTA">
			<cfset tab = '1'>
	<!--- ************************************ CONEXION  ******************************* --->
		<cfelseif isdefined("Form.Configurar")>
			<cf_dbtimestamp datasource="#session.tramites.dsn#"
				table="TPDocumento"
				redirect="Tp_Documentos.cfm"
				timestamp="#form.ts_rversion#"
				field1="id_documento" 
				type1="numeric" 
				value1="#form.id_documento#">
			<cfquery name="ABC_Documento" datasource="#session.tramites.dsn#">			
				update TPDocumento 
				set con_url 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_url#">, 
					con_usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_usuario#">, 
					con_passwd 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_passwd#">, 
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
					BMfechamod	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 				
				where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
			</cfquery>
			<cfset modo="CAMBIO">		
			<cfset tab = '2'>
	<!--- ************************************ INFORMACION ADICIONAL  ******************************* --->
		<cfelseif isdefined("Form.Informacion")>
			<cf_dbtimestamp datasource="#session.tramites.dsn#"
				table="TPDocumento"
				redirect="Tp_Documentos.cfm"
				timestamp="#form.ts_rversion#"
				field1="id_documento" 
				type1="numeric" 
				value1="#form.id_documento#">
			
			<cfquery name="ABC_Documento" datasource="#session.tramites.dsn#">			
				update TPDocumento 
				set descripcion_documento = <cfif isdefined("form.descripcion_documento") and len(trim(form.descripcion_documento))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.descripcion_documento#"><cfelse>null</cfif>,
					BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
					BMfechamod			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 				
				where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
			</cfquery>
									
			<cfset modo="CAMBIO">		
			<cfset tab = '3'>
	<!--- ************************************ CAMBIO  ******************************* --->
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPDocumento"
			redirect="Tp_Documentos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_documento" 
			type1="numeric" 
			value1="#form.id_documento#">
		<cfquery name="ABC_Documentos" datasource="#session.tramites.dsn#">			
			update TPDocumento 
			set codigo_documento 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_documento)#">, 
				nombre_documento 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_documento#">, 
				id_tipodoc 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipodoc#">,
				id_inst 			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_inst#">, 
				<cfif isdefined("form.es_pago")>
				es_pago				= 1,
				id_campo_pago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_campo_pago#">,
				moneda_pago			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.moneda_pago#">,
				<cfelse>
				es_pago				= 0,
				id_campo_pago		= null,
				moneda_pago			= null,
				</cfif>
				BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
				vigente_desde		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.vigente_desde)#">, 
				vigente_hasta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.vigente_hasta)#">, 
				BMfechamod			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where id_documento		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
		</cfquery>
								
		<cfset tab = '1'>
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>
<form action="Tp_Documentos.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id_documento" type="hidden" value="<cfif isdefined("Form.id_documento")><cfoutput>#Form.id_documento#</cfoutput></cfif>">
	</cfif>
	<input type="hidden" name="tab" value="<cfoutput>#tab#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
