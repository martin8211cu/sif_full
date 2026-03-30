<cfparam name="modo_Ag" default="ALTA">

<cffunction name="cadenaDias" returntype="string">
	<cfset dias = "">
	<cfset CountVar = 0>	
	
	<cfloop condition = "CountVar LESS THAN OR EQUAL TO 6">
		<cfset CountVar = CountVar + 1>
		
		<cfif isdefined("form.dia_#CountVar#")>
			<cfif dias NEQ ''>
				<cfset dias = dias & ",1">
			<cfelse>
				<cfset dias = dias & "1">
			</cfif>
		<cfelse>
			<cfif dias NEQ ''>
				<cfset dias = dias & ",0">
			<cfelse>
				<cfset dias = dias & "0">
			</cfif>
		</cfif>		
	</cfloop>

	<cfreturn dias>
</cffunction>

<cffunction name="revisaDias" returntype="boolean">
	<cfargument name="query" type="query" required="yes">
	<cfargument name="cadena" type="string" required="yes">	
	
	<cfset coinciden = false>
	<cfset diasNuevos = ListToArray(cadena)>		
	
	<cfloop query="query">
		<cfset CountVar = 0>	
		<cfset diasInsertados = ListToArray(query.dia_semanal)>

		<cfloop condition = "CountVar LESS THAN OR EQUAL TO 6">
			<cfset CountVar = CountVar + 1>
			
			<cfif diasInsertados[CountVar] EQ 1 and diasNuevos[CountVar] EQ 1>
				<cfset coinciden = true>
				<cfbreak>
			</cfif>		
		</cfloop>			
	</cfloop>	
	
	<cfreturn coinciden>
</cffunction>

<cfif not isdefined("Form.Nuevo_Ag")>
	<cfset cadenaDias = cadenaDias()>

	<cfif isdefined("Form.Alta_Ag") or isdefined("Form.Cambio_Ag")>
		<cfset HoraDesde = form.hora_desde & ":" & form.min_desde & ":00">
		<cfset HoraHasta = "00:00:00">
		<cfif (isdefined('form.hora_hasta') and form.hora_hasta NEQ '') and (isdefined('form.min_hasta') and form.min_hasta NEQ '')>
			<cfset HoraHasta = form.hora_hasta & ":" & form.min_hasta & ":00">
		</cfif>	
		<cfquery name="validaAgenda" datasource="#session.tramites.dsn#">
			Select dia_semanal
			from TPAgenda
			where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				and  id_recurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_recurso#">
				and 	((
					 ((		<cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#">
					 			between hora_desde and hora_hasta) or (
							<cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#">
								between hora_desde and hora_hasta))
						and ((	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">
									between vigente_desde and vigente_hasta) or (
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">
								 	between vigente_desde and vigente_hasta))
					)or(
						((	<cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#"> < hora_desde and 
							<cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#"> < hora_hasta) or (
							<cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#"> > hora_desde and 
							<cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#"> > hora_hasta))
						and 
						(( 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">
								< vigente_desde ) and (
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">
								< vigente_hasta))
						and 
						(( <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">
								> vigente_desde ) and (
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">
								> vigente_hasta))
					))
				<cfif isdefined("Form.Cambio_Ag")>
					and id_agenda not in (#form.id_agenda#)
				</cfif>			
		</cfquery>

		<cfif isdefined('validaAgenda') and validaAgenda.recordCount GT 0>
			<cfset coincidenDias = false>
			<cfset coincidenDias = revisaDias(validaAgenda,cadenaDias)>
			<cfif coincidenDias>
				<cfthrow message="Error, el recurso ya se encuentra reservado para el rango de horas y fechas seleccionadas.">
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isdefined("Form.Alta_Ag")>
		<cftransaction>
			<cfquery name="ABC_ins" datasource="#session.tramites.dsn#" >
				insert into TPAgenda 
					(id_tiposerv, id_recurso, id_direccion, id_inst, id_sucursal, id_responsable, dia_semana, hora_desde, hora_hasta
						, id_requisito, cupo, BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta,dia_semanal)
				values (
					<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ '' and form.id_tiposerv NEQ '-1'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
					<cfelse>
						null	
					</cfif>
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_recurso#">
					<cfif isdefined('form.id_direccion') and form.id_direccion NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
					<cfelse>
						, null	
					</cfif>	
					<cfif isdefined('form.id_inst') and form.id_inst NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
					<cfelse>
						, null	
					</cfif>										
					<cfif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
					<cfelse>
						, null	
					</cfif>					
					<cfif isdefined('form.id_funcionario') and form.id_funcionario NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
					<cfelse>
						, null	
					</cfif>								
					, 1
					, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#">									
					, <cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#">						
					<cfif isdefined('form.id_requisito') and form.id_requisito NEQ '' and form.id_requisito NEQ '*'>
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
					<cfelse>
						, null	
					</cfif>
					<cfif isdefined('form.cupo') and form.cupo NEQ ''>
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
					<cfelse>
						, null	
					</cfif>							
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#cadenaDias#">)
					
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="ABC_ins">
		</cftransaction>
		
		<cfset modo_Ag="CAMBIO_Ag">
		<cfset Form.id_agenda = ABC_ins.identity>
		
	<cfelseif isdefined("Form.Baja_Ag")>
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			delete TPAgenda 
			where  id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_agenda#">				  
		</cfquery>
		
		<cfset modo_Ag="ALTA">
		
		<cfset p = "?tab=2&tabreq=req2&tabsuc=suc3&id_inst=#form.id_inst#&id_sucursal=#form.id_sucursal#&id_recurso=#form.id_recurso#">
		<cflocation url="../instituciones.cfm#p#">		
	<cfelseif isdefined("Form.Cambio_Ag")>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPAgenda"
			redirect="instituciones.cfm"
			timestamp="#form.ts_rversion#"
			field1="id_agenda" 
			type1="numeric" 
			value1="#form.id_agenda#">
		<cfquery name="ABC_ins" datasource="#session.tramites.dsn#">			
			update TPAgenda set 
				<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ '' and form.id_tiposerv NEQ '-1'>
					id_tiposerv			=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
				<cfelse>
					id_tiposerv			=  null	
				</cfif>			
				<cfif isdefined('form.id_funcionario') and form.id_funcionario NEQ ''>
					, id_responsable	=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
				<cfelse>
					, id_responsable	=  null	
				</cfif>						
				, hora_desde		= <cfqueryparam cfsqltype="cf_sql_time" value="#HoraDesde#">	
				, hora_hasta		= <cfqueryparam cfsqltype="cf_sql_time" value="#HoraHasta#">	
				<cfif isdefined('form.id_requisito') and form.id_requisito NEQ '' and form.id_requisito NEQ '*'>
					, id_requisito		=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
				<cfelse>
					, id_requisito		=  null	
				</cfif>				
				<cfif isdefined('form.cupo') and form.cupo NEQ ''>
					, cupo				=  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cupo#">
				<cfelse>
					, cupo				=  null	
				</cfif>							
				, BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				, BMfechamod		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				, vigente_desde		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_desde)#">
				, vigente_hasta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.vigente_hasta)#">
				, dia_semanal 		= <cfqueryparam cfsqltype="cf_sql_char" value="#cadenaDias#">
			where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_agenda#">
		</cfquery>
		<cfset modo_Ag="CAMBIO">
	</cfif>			
</cfif>
<cfoutput>
	<cfif isdefined('form.btnLista_AG')>
		<cfset p = "?tab=2&tabsuc=suc3&id_inst=#form.id_inst#&id_sucursal=#form.id_sucursal#">
	<cfelse>
		<cfset p = "?tab=2&tabreq=req2&tabsuc=suc3&id_inst=#form.id_inst#&id_sucursal=#form.id_sucursal#&id_recurso=#form.id_recurso#">
	</cfif>
	<cfif not isdefined('form.btnLista_AG') and not isdefined("form.Nuevo_Ag") and isdefined("form.id_agenda") and len(trim(form.id_agenda))>
		<cfset p = p & "&id_agenda=#form.id_agenda#">
	<cfelseif isdefined("form.Cambio_Ag")>		
		<cfset p = p & "&id_agenda=#Form.id_agenda#">
	</cfif>
	
	<cflocation url="../instituciones.cfm#p#">
</cfoutput>