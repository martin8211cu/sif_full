<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 18-8-2005.
		Motivo: Pedido por Marcel De Mezerville. Se agrega la pregunta: si viene form.id_documento lo graba sino graba null.
 --->

<cfparam name="modo" default="ALTA">
<cfparam name="form.comportamiento" default="D">
<cfset tab = '1'>

<cfif not isdefined("Form.Nuevo")>
	<!--- ************************************ ALTA  ******************************* --->
	<cfif isdefined("Form.Alta")>
		<cftransaction>
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">
			insert into TPRequisito ( 	id_tiporeq,
										codigo_requisito, 
										nombre_requisito,
										descripcion_requisito,
										id_tiposerv,
										id_inst,  
										con_tipo,
										con_url,  
										con_usuario,
										con_passwd,
										costo_requisito,
										moneda,
										BMUsucodigo,
									  	BMfechamod,
										es_impedimento,
										es_documental,
										es_cita,
										es_pago,
										es_capturable,
										comportamiento,
										texto_completado,
										vigente_desde,
										vigente_hasta
										 )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_tiporeq#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#UCase(Form.codigo_requisito)#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.nombre_requisito#">, 
					 null,
					 <cfif isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv))> <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_tiposerv#"><cfelse>null</cfif>, 
					 <cfif isdefined("form.id_inst") and len(trim(form.id_inst))> <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_inst#"><cfelse>null</cfif>, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="NONE">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="">, 
					 0,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 0,
					 <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'D'#">,
					 <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'C'#">,
					 <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'P'#">,
					 <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'A'#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.comportamiento#">,
					 <cfif not isdefined("form.texto_completado") OR len(trim(form.texto_completado)) EQ 0>
					 	'El requisito ha sido completado',
					 <cfelse>
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.texto_completado#">,
					 </cfif>
					 <cfif isdefined("form.vigente_desde") and Len(Trim(form.vigente_desde))>
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.vigente_desde)#">,
					 <cfelse>
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(2001, 01, 01)#">,
					 </cfif>
					 <cfif isdefined("form.vigente_hasta") and Len(Trim(form.vigente_hasta))>
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.vigente_hasta)#">
					 <cfelse>
					 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
					 </cfif>
					   )
			<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_Requisito">
		<cfset Form.id_requisito = ABC_Requisito.identity>
		
		<cfif isdefined("Form.tipoiden")>
			<cfset arreglo = listtoarray(form.tipoiden,",")>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">
					insert into TPTipoIdentReq (id_requisito,
												id_tipoident, 
												BMUsucodigo,
												BMfechamod 
					)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arreglo[i]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
				</cfquery>
			</cfloop>
		</cfif>		
		
		<cfinvoke component="home.tramites.componentes.tramites"
			method="dar_permiso"
			tipo_sujeto="F"
			id_sujeto="#session.tramites.id_funcionario#"
			tipo_objeto="R"
			id_objeto="#form.id_requisito#" />
		
		</cftransaction>
		<cfset modo="CAMBIO">
		<cfset tab = '1'>
	<!--- ************************************ BAJA  ******************************* --->
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">			
			delete TPTipoIdentReq 
			where  id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">				  
		</cfquery>				
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">			
			delete TPRequisito 
			where  id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">				  
		</cfquery>
		<cfset modo="ALTA">
		<cfset tab = '1'>
	<!--- ************************************ CONEXION  ******************************* --->
	<cfelseif isdefined("Form.Configurar")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRequisito"
			redirect="Tp_Requisitos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_requisito" 
			type1="numeric" 
			value1="#form.id_requisito#">
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">			
			update TPRequisito 
			set con_tipo 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_tipo#">, 
				con_url 			= <cfif  form.con_tipo neq 'NONE'><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_url#"><cfelse>''</cfif>, 
				con_usuario 		= <cfif  form.con_tipo neq 'NONE'><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_usuario#"><cfelse>''</cfif>, 
				con_passwd 			= <cfif  form.con_tipo neq 'NONE'><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.con_passwd#"><cfelse>''</cfif>, 
				BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
				BMfechamod			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">				
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		</cfquery>
		<cfset modo="CAMBIO">		
		<cfset tab = '2'>
	<!--- ************************************ INFORMACION ADICIONAL  ******************************* --->
	<cfelseif isdefined("Form.Informacion")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRequisito"
			redirect="Tp_Requisitos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_requisito" 
			type1="numeric" 
			value1="#form.id_requisito#">
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">			
			update TPRequisito 
			set descripcion_requisito = <cfif isdefined("form.descripcion_requisito") and len(trim(form.descripcion_requisito))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.descripcion_requisito#"><cfelse>null</cfif>,
				BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
				BMfechamod			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 				
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		</cfquery>
		<cfset modo="CAMBIO">		
		<cfset tab = '3'>
	<!--- ************************************ CAMBIO VERIFICACION Y CUMPLIMIENTO  ******************************* --->
	<cfelseif isdefined("Form.ModificarVC")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRequisito"
			redirect="Tp_Requisitos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_requisito" 
			type1="numeric" 
			value1="#form.id_requisito#">
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">			
			update TPRequisito
			set es_capturable = <cfif isdefined("form.es_capturable")>1<cfelse>0</cfif>,
				es_personal   = <cfif isdefined("form.es_personal")>1<cfelse>0</cfif>,
				<cfif isdefined("form.es_documental")>
				es_documental = 1,
				es_custodia	  = <cfqueryparam cfsqltype="cf_sql_bit" 	value="#form.es_custodia#">,
				<cfelse>
				es_documental = 0,
				</cfif>
				es_conexion   = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_conexion')#">,
				es_autoverificar= <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_autoverificar')#">,
				id_documento  = 
					<cfif isdefined("form.Id_documento") and len(trim(form.Id_documento))>
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Id_documento#">,
					<cfelseif isdefined("form.Id_documento") and len(trim(form.Id_documento)) eq 0>
						null,
					</cfif>
				BMUsucodigo	  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
				BMfechamod	  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				es_vistapopup =  <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_vistapopup')#">,
				id_vistapopup =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vistapopup#" null="#Len(form.id_vistapopup) EQ 0#">
				
				<cfif isdefined("form.es_impedimento")	>
					,es_impedimento      = <cfif form.es_impedimento eq 0>0<cfelse>1</cfif> 				
				</cfif>
				, texto_completado = 
				 <cfif len(trim(form.texto_completado))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.texto_completado#">
				 <cfelse>
					'El requisito ha sido completado'
				 </cfif>
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		</cfquery>
		<cfset modo="CAMBIO">		
		<cfset tab = '2'>
	<!--- ************************************ CAMBIO  ******************************* --->
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPRequisito"
			redirect="Tp_Requisitos.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_requisito" 
			type1="numeric" 
			value1="#form.id_requisito#">
		<cfquery name="ABC_Requisito" datasource="#session.tramites.dsn#">			
			update TPRequisito 
			set codigo_requisito 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Form.codigo_requisito)#">, 
				nombre_requisito 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_requisito#">, 
				id_tiporeq 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tiporeq#">,
				id_tiposerv 		= <cfif isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv))> <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_tiposerv#"><cfelse>null</cfif>, 
				id_inst 			= <cfif isdefined("form.id_inst") and len(trim(form.id_inst))> <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_inst#"><cfelse>null</cfif>, 
				BMUsucodigo			= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
				BMfechamod			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				es_documental       = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'D'#">,
				es_cita             = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'C'#">,
				es_pago             = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'P'#">,
				es_capturable       = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.comportamiento EQ 'A'#">,
				comportamiento      = <cfqueryparam cfsqltype="cf_sql_char" value="#form.comportamiento#">,
			 <cfif isdefined("form.vigente_desde") and Len(Trim(form.vigente_desde))>
				vigente_desde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.vigente_desde)#">,
			 <cfelse>
				vigente_desde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(2001, 01, 01)#">,
			 </cfif>
			 <cfif isdefined("form.vigente_hasta") and Len(Trim(form.vigente_hasta))>
				vigente_hasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.vigente_hasta)#">
			 <cfelse>
				vigente_hasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
			 </cfif>
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		</cfquery>
		<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">			
			delete TPTipoIdentReq 
			where  id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">				  
		</cfquery>				
		<cfif isdefined("Form.tipoiden")>
			<cfset arreglo = listtoarray(form.tipoiden,",")>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfquery name="ABC_tipoiden" datasource="#session.tramites.dsn#">
					insert into TPTipoIdentReq (id_requisito,
												id_tipoident, 
												BMUsucodigo,
												BMfechamod 
					)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arreglo[i]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
				</cfquery>
			</cfloop>
		</cfif>
		<cfset tab = '1'>
		<cfset modo="CAMBIO">				  				  
	</cfif>			
</cfif>
<form action="Tp_Requisitos.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id_requisito" type="hidden" value="<cfif isdefined("Form.id_requisito")><cfoutput>#Form.id_requisito#</cfoutput></cfif>">
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
