<cfcomponent>
	<!--- RESULTADO:
		  Devuelve el id de instancia para un tramite no completado.
		  Crea la instancia si no existe.
	--->
	<cffunction name="obtener_instancia" access="public" returntype="numeric" output="false" >
		<cfargument name="id_persona" type="numeric" required="yes">
		<cfargument name="id_tramite" type="numeric" required="yes">
		
		<cfquery name="tramite" datasource="#session.tramites.dsn#">
			select id_instancia, id_funcionario
			from TPInstanciaTramite
				where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_tramite#">
			and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_persona#">
			and completo = 0
		</cfquery>

		<cfif tramite.recordcount gt 0>
			<cfquery datasource="#session.tramites.dsn#">
				insert into TPInstanciaRequisito( id_instancia, 
												  id_requisito, 
												  id_funcionario, 
												  id_ventanilla, 
												  id_cita,
												  completado, 
												  fecha_registro, 
												  BMfechamod, 
												  BMUsucodigo, 
												  rechazado )
				select it.id_instancia,
				 	   rt.id_requisito, 
					   <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>, 
					   <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
					   null,
					   0,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					   0
				from TPInstanciaTramite it, TPRReqTramite rt
				where it.id_tramite = rt.id_tramite
				  and it.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite.id_instancia#">
				  and not exists ( select 1
								   from TPInstanciaRequisito ir
								   where ir.id_instancia = it.id_instancia
					  				 and ir.id_requisito = rt.id_requisito )
			</cfquery>	  

			<cfreturn tramite.id_instancia >
		<cfelse>
			<cftransaction>
				<cfquery name="instancia" datasource="#session.tramites.dsn#">
					insert INTO TPInstanciaTramite( id_tramite, 
													id_persona, 
													id_funcionario, 
													id_ventanilla,
													fecha_inicio, 
													completo, 
													BMUsucodigo, 
													BMfechamod )
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_tramite#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_persona#">,
							<cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
							<cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="instancia">
				
				<cfquery datasource="#session.tramites.dsn#">
					insert INTO TPInstanciaRequisito( id_instancia, 
													  id_requisito, 
													  id_funcionario, 
													  id_ventanilla,
													  completado, 
													  BMUsucodigo, 
													  BMfechamod )
					select #instancia.identity#, 
						   rq.id_requisito, 
						   null, 
						   null,
						   0, 
						   #session.Usucodigo#, 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					from TPRReqTramite rt
						join TPRequisito rq
							on rt.id_requisito = rq.id_requisito
					where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_tramite#">
				</cfquery>
			</cftransaction>
			<cfreturn instancia.identity >
		</cfif>
	</cffunction>


	<!---
		Obtiene la lista de requisitos y su estado para
		un trámite de una persona, y opcionalmente de
		un requisito.
		Si no se especifica un requisito, regresa todos
		los requisitos
	--->
	<cffunction name="detalle_tramite" access="public" returntype="query" output="false" >
		<cfargument name="id_persona"  type="numeric" required="yes">
		<cfargument name="id_tramite"  type="numeric" required="yes">
		<cfargument name="id_requisito" type="numeric" required="no">
		<cfargument name="id_funcionario"  type="string" required="no">
				
		<cfquery name="tramite_existe" datasource="#session.tramites.dsn#" maxrows="1">
			select id_instancia
			from TPInstanciaTramite
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tramite#">
			  and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
			  and completo = 0
		</cfquery>
		
		<cfquery name="persona" datasource="#session.tramites.dsn#" maxrows="1">
			select id_tipoident
			from TPPersona
			where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
		</cfquery>
		
		<cfif Len(tramite_existe.id_instancia)>
			<!--- buscar el documento existente en el expediente --->
			<cfquery datasource="#session.tramites.dsn#" name="id_reg_encontrados">
				select
					ir.id_requisito, rq.es_impedimento,
					rq.nombre_requisito,
					( select max ( reg.id_registro ) 
						from DDRegistro reg
						where reg.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
						  and reg.id_tipo = dc.id_tipo
					) as id_registro_ult
				from  TPInstanciaRequisito ir
					join TPRequisito rq
						on rq.id_requisito = ir.id_requisito
					join TPDocumento dc
						on dc.id_documento = rq.id_documento
						and dc.id_tipo is not null
				where ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite_existe.id_instancia#">
				<cfif IsDefined ('Arguments.id_requisito') And Len(Arguments.id_requisito)>
				  and ir.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_requisito#">
				</cfif>
				  and ir.id_registro is null
				  and ir.completado = 0
				  and ir.rechazado = 0
				  and rq.es_autoverificar = 1
			</cfquery>
			
			<cfloop query="id_reg_encontrados">
				<cfif Len(id_reg_encontrados.id_registro_ult)>
					<cfquery datasource="#session.tramites.dsn#">
						update TPInstanciaRequisito
						set id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_reg_encontrados.id_registro_ult#">,
						<cfif id_reg_encontrados.es_impedimento EQ 1>
							rechazado = 1
						<cfelse>
							completado = 1
						</cfif>
						where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite_existe.id_instancia#">
						  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_reg_encontrados.id_requisito#">
					</cfquery>
				</cfif>
			</cfloop>
			
			
		</cfif>
		
		<cfquery name="instancia" datasource="#session.tramites.dsn#" >
			select 	#Arguments.id_persona# as id_persona,
					#Arguments.id_tramite# as id_tramite, 
					<cfif tramite_existe.recordcount gt 0>
						it.id_instancia, 
						ir.fecha_registro, 
						ir.completado, 
						ir.rechazado, 
						p.nombre || ' ' || ' ' || apellido1 || '' || apellido2 as nombre_funcionario,
						ir.id_cita,
						ir.id_registro,
					<cfelse>
						null as id_instancia,
						null as fecha_registro,
						0 as completado,
						0 as rechazado,
						null as nombre_funcionario,
						null as id_cita,
						null as id_registro,
					</cfif>
					rt.id_requisito, 
					rt.numero_paso, 
					r.codigo_requisito, 
					r.nombre_requisito,
					r.es_pago,
					r.es_capturable,
					r.es_cita,
					0 as permisos,
					'-' as link, '-' as img, '-' as estado,
					es_documental,
					id_documento,
					r.es_conexion,
					r.es_impedimento,
					coalesce(r.texto_completado,'El requisito ha sido completado') as texto_completado,
					tp.numero_paso as paso_numero,
					tp.nombre_paso
			from TPRReqTramite rt
			
			inner join TPTramitePaso tp
				on tp.id_paso=rt.id_paso
				and tp.id_tramite=rt.id_tramite
			
			inner join TPRequisito r
				on r.id_requisito = rt.id_requisito

			inner join TPTipoIdentReq rtir
				on rtir.id_requisito = rt.id_requisito
				and rtir.id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#persona.id_tipoident#">
			
			<cfif tramite_existe.recordcount gt 0>
				inner join TPInstanciaTramite it
					on it.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite_existe.id_instancia#">
	
					and it.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
					and rt.id_tramite = it.id_tramite
	
				left join TPInstanciaRequisito ir
					on ir.id_requisito = rt.id_requisito
					and ir.id_instancia = it.id_instancia
				
				left join TPFuncionario f
					on f.id_funcionario = ir.id_funcionario
				
				left join TPPersona p
					on p.id_persona = f.id_persona
			</cfif>
			
			where rt.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_tramite#">
			<cfif IsDefined("Arguments.id_requisito") and len(trim(Arguments.id_requisito))>
				and rt.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_requisito#">
			</cfif>
			order by tp.numero_paso, rt.numero_paso
		</cfquery>
		
		<cfif IsDefined('Arguments.id_funcionario') and Len(Arguments.id_funcionario)>
			<cfset requisitos = this.permisos(Arguments.id_funcionario) >
		<cfelse>
			<cfset requisitos = ''>
		</cfif>
		<cfloop query="instancia">
		
			<cfif listfind(requisitos, instancia.id_requisito) >
				<cfset QuerySetCell(instancia, 'permisos',  '1',  instancia.CurrentRow)>
			</cfif>

			<cfif instancia.rechazado eq 1>
				<cfset nw_link = 'req_cumplido.cfm'>
				<cfset nw_img = 'Borrar01_S.gif'>
				<cfset nw_est = 'Requisito Rechazado'>
			<cfelseif instancia.completado eq 1>
				<cfset nw_link = 'req_cumplido.cfm'>
				<cfset nw_img = 'check-verde.gif'>
				<cfset nw_est = 'Requisito Completado'>
			<cfelseif instancia.permisos eq 0>
				<cfset nw_link = 'req_info.cfm'>
				<cfset nw_img = 'candado.gif'>
				<cfset nw_est = 'No tiene Permiso'>
			<cfelseif instancia.es_pago eq 1>
				<cfset nw_link = 'req_pago.cfm'>
				<cfset nw_img = 'plata.gif'>
				<cfset nw_est = 'Requiere Pago'>
			<cfelseif instancia.es_cita eq 1>
				<cfset nw_link = 'req_cita.cfm'>
				<cfset nw_img = 'cita.gif'>
				<cfset nw_est = 'Obtener Cita'>
			<cfelseif instancia.es_capturable eq 1>
				<cfset nw_link = 'req_aprobar.cfm'>
				<cfset nw_img = 'edit.gif'>
				<cfset nw_est = 'Requisito Abierto'>
			<cfelseif len(trim(instancia.id_registro))>
				<cfset nw_link = 'req_requisito.cfm'>
				<cfset nw_img = 'no-esta.gif'>
				<cfset nw_est = 'Requisito en Proceso'>
			<cfelse>
				<cfset nw_link = 'req_requisito.cfm'>
				<cfset nw_img = 'no-esta2.gif'>
				<cfset nw_est = 'Requisito Nuevo'>
			</cfif>
			
			<cfset QuerySetCell(instancia, 'link',    nw_link, instancia.CurrentRow)>
			<cfset QuerySetCell(instancia, 'img',     nw_img,  instancia.CurrentRow)>
			<cfset QuerySetCell(instancia, 'estado',  nw_est,  instancia.CurrentRow)>
		</cfloop>
		<cfreturn instancia>

	</cffunction>
	
	<cffunction name="permisos" returntype="any" access="public">
		<cfargument name="id_funcionario"  type="numeric" required="yes">
		<cfargument name="id_requisito" type="numeric" required="no" default="0">
		
		<cfreturn This.permisos_obj(id_funcionario, id_requisito, 'R')>
		
	</cffunction>
	
	<cffunction name="permisos_obj" returntype="any" access="public">
		<cfargument name="id_funcionario"  type="numeric" required="yes">
		<cfargument name="id_objeto" type="numeric" required="no" default="0">
		<cfargument name="tipo_objeto" type="string" required="no" default="R">
		<!--- revisa que tengan este permiso si se indica --->
		<cfargument name="puede_capturar" type="boolean" required="no">
		<cfargument name="puede_revisar" type="boolean" required="no">
		<cfargument name="puede_modificar" type="boolean" required="no">
		<cfargument name="puede_modo" type="string" required="no" default="or">
		<cfif Arguments.puede_modo NEQ 'and'>
			<cfset Arguments.puede_modo = 'or'>
		</cfif>

		<cfquery name="lista" datasource="#session.tramites.dsn#">
			select id_objeto as id_requisito
			from TPPermiso
			where (tipo_sujeto = 'F'
			  and id_sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#">
			  
			  or  tipo_sujeto = 'G'
			  and id_sujeto in ( 
			  		select fg.id_grupo
			  		from TPFuncionarioGrupo fg
					where fg.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#"> 
					)
					
			  or  tipo_sujeto = 'I'
			  and id_sujeto in (
			  		select f.id_inst
			  		from TPFuncionario f
					where f.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#"> 
					)
			  
			  or  tipo_sujeto = 'T'
			  and id_sujeto in (
			  		select ti.id_tipoinst
			  		from TPFuncionario f
						join TPRTipoInst ti
							on f.id_inst = ti.id_inst
					where f.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#"> 
					)
			  
			  )
			and tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_objeto#">
			<cfif arguments.id_objeto neq 0 >
				and id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_objeto#">
			</cfif>
			<cfset where_modo = ''>
			<cfif IsDefined('Arguments.puede_capturar') OR
			      IsDefined('Arguments.puede_revisar') OR
			      IsDefined('Arguments.puede_modificar') >
			AND (
				<cfif IsDefined('Arguments.puede_capturar')>
					#where_modo# puede_capturar  = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_capturar#">
					<cfset where_modo = #Arguments.puede_modo#>
				</cfif>
				<cfif IsDefined('Arguments.puede_revisar')>
					#where_modo# puede_revisar   = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_revisar#">
					<cfset where_modo = #Arguments.puede_modo#>
				</cfif>
				<cfif IsDefined('Arguments.puede_modificar')>
					#where_modo# puede_modificar = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_modificar#">
					<cfset where_modo = #Arguments.puede_modo#>
				</cfif>
			)
			</cfif>
		</cfquery>
		
		<cfif arguments.id_objeto neq 0 >
			<cfif lista.recordcount gt 0>
				<cfreturn true >
			<cfelse>
				<cfreturn false >
			</cfif>
		<cfelse>
			<cfreturn valuelist(lista.id_requisito) >
		</cfif>	

	</cffunction>
	
	<cffunction name="dar_permiso" access="public">
		<cfargument name="tipo_sujeto" type="string">
		<cfargument name="id_sujeto" type="string">
		<cfargument name="tipo_objeto" type="string">
		<cfargument name="id_objeto" type="numeric">
		<cfargument name="puede_capturar" type="boolean" default="yes">
		<cfargument name="puede_revisar" type="boolean" default="yes">
		<cfargument name="puede_modificar" type="boolean" default="yes">
		<cfargument name="items_ok" type="string" default="*">
		
		<cfif Len(Arguments.id_sujeto) is 0>
			<cfreturn>
		</cfif>
		<cfparam name="Arguments.id_sujeto" type="numeric">
		
		<cfquery datasource="#session.tramites.dsn#" name="hay">
			select 1
			from TPPermiso
			where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_objeto#">
			  and id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_objeto#">
			  and tipo_sujeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_sujeto#">
			  and id_sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_sujeto#">
		</cfquery>
		<cfif hay.RecordCount>
			<cfquery datasource="#session.tramites.dsn#">
				update TPPermiso
				set 
					puede_capturar  = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_capturar#">,
					puede_revisar   = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_revisar#">,
					puede_modificar = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_modificar#">,
					items_ok = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.items_ok#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_objeto#">
				  and id_objeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_objeto#">
				  and tipo_sujeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_sujeto#">
				  and id_sujeto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_sujeto#">
			  </cfquery>
		<cfelse>
			<cfquery datasource="#session.tramites.dsn#">
				insert into TPPermiso (
					tipo_objeto, id_objeto, tipo_sujeto, id_sujeto,
					puede_capturar, puede_revisar, puede_modificar,
					items_ok,
					BMUsucodigo, BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_objeto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_objeto#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tipo_sujeto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_sujeto#">,			

					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_capturar#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_revisar#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.puede_modificar#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.items_ok#">,

					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="completar_requisito" access="public">
		<cfargument name="id_instancia"  type="numeric" required="yes">
		<cfargument name="id_requisito" type="numeric" required="yes" >
		
		<cfquery datasource="#session.tramites.dsn#">
			update TPInstanciaRequisito
			set completado = 1,
				fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_instancia#">
			  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_requisito#">
		</cfquery>
	</cffunction>


</cfcomponent>