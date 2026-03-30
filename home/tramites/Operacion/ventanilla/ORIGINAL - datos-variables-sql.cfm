<cfset aprobacion = createobject('component', 'home.tramites.componentes.criterios' ) >
<cfset usar_criterios = true >

<cftransaction>
<cfif isdefined("form.Aceptar") or isdefined("form.Rechazar") or isdefined("form.Abrir")>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>

	<!--- Estructura para manejo de existencia de instancias de requisito y de expediente --->
	<cfset ids_registro = structnew() >
	<cfif len(trim(form.id_requisito))>
		<cfloop list="#form.id_requisito#" index="i">
			<cfquery name="instancia_req" datasource="#session.tramites.dsn#">
				select ir.id_instancia, reg.id_registro, doc.id_tipo
				from TPInstanciaRequisito ir
					join TPRequisito r
						on r.id_requisito = ir.id_requisito
					join TPDocumento doc
						on doc.id_documento = r.id_documento
					left join DDRegistro reg
						on reg.id_registro = ir.id_registro
				where ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#" >
				  and ir.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>

			<!--- Ya existe el expediente, solo modificar el dato --->
			<cfset id_registro = instancia_req.id_registro >
			<cfif Len(id_registro) EQ 0>
				<cfif len(trim(instancia_req.id_tipo))>
					<!---<cftransaction>--->
					<cfquery name="nuevo_registro" datasource="#session.tramites.dsn#">
						insert into DDRegistro (id_persona, id_tipo, BMUsucodigo, BMfechamod)
						values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia_req.id_tipo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
						<cf_dbidentity1 datasource="#session.tramites.dsn#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.tramites.dsn#" name="nuevo_registro">
					<cfset id_registro = nuevo_registro.identity >
				
					<cfquery datasource="#session.tramites.dsn#">
						update TPInstanciaRequisito
						set id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_registro#">
						where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
						and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
					<!---</cftransaction>--->
				</cfif>
			</cfif>
			<cfif len(trim(id_registro))>
				<cfset StructInsert(ids_registro, i, id_registro ) >
			</cfif>

			<cfif isdefined("form.Abrir")>
				<cfquery datasource="#session.tramites.dsn#">
					update TPInstanciaRequisito
					set completado = 0,
						rechazado  = 0,
						id_funcionario = <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
						id_ventanilla = <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
						fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
					and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
			<cfelseif isdefined("form.Rechazar")>
				<cfquery datasource="#session.tramites.dsn#">
					update TPInstanciaRequisito
					set completado = 0,
						rechazado  = 1,
						id_funcionario = <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
						id_ventanilla = <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
						fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
					and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
			<cfelse>
				<!--- Guardar --->
				<cfif not aprobacion.hay_criterios(i) >
					<cfquery datasource="#session.tramites.dsn#">
						update TPInstanciaRequisito
						set completado = <cfif isdefined("form.completado")>1<cfelse>0</cfif>,
							<cfif isdefined("form.completado")>rechazado = 0,</cfif>
							id_funcionario = <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
							id_ventanilla = <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
							fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
						and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
					<cfset usar_criterios = false >
				</cfif>
				
				<!--- ======================= --->
				<!--- PROCESO DE FLUJO --->
				<!--- ======================= --->
				<cfif isdefined("form.modo_flujo") and trim(form.modo_flujo) neq 0 >
					<cfinclude template="flujo-sql.cfm">
				</cfif>
				<!--- ======================= --->
			</cfif>
		</cfloop> <!--- REQUISITOS --->

		<cfif isdefined("form.Aceptar")>
			<cfloop list="#form.id_requisito#" index="i">
				<!--- =================================================== --->
				<!--- DATOS VARIABLES --->
				<!--- =================================================== --->
				<!--- Insert/Update de datos --->
				
				<!--- lleva el control para saber si aprobo todos los criterios --->
				<cfset es_and = aprobacion.es_criterio_and(i) >
				<cfset aprobar_or = false > 
				<cfset aprobar_and = true > 
				<cfloop list="#form.id_campo#" index="j">
					<cfset rsCriterios = aprobacion.obtener_criterio(i, j) >
				
					<cfif isdefined("form.id_requisito_#i#_#j#")>
						<cfset requisito = form['id_requisito_#i#_#j#'] >
						<cfquery name="tipo" datasource="#session.tramites.dsn#">
							select tp.tipo_dato
							from DDTipoCampo cam
								join DDTipo tp
									on tp.id_tipo = cam.id_tipocampo
							where cam.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">
						</cfquery>
						
						<cfif StructKeyExists(ids_registro, i) >
							<cfquery name="existe" datasource="#session.tramites.dsn#">
								select 1
								from DDCampo
								where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ids_registro['#i#']#">
								  and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">
							</cfquery>
				
							<cfif existe.RecordCount >
								<cfquery datasource="#session.tramites.dsn#">
									update DDCampo
									<cfif tipo.tipo_dato eq 'B'>
										set valor = <cfif isdefined("form.dato_#i#_#j#")>'1'<cfelse>'0'</cfif>
									<cfelse>
										set valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['dato_#i#_#j#']#">
									</cfif>
									where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ids_registro['#i#']#">
									  and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">
								</cfquery>
							<cfelse>
								<cfquery datasource="#session.tramites.dsn#">
									insert into DDCampo ( id_registro, id_campo, valor, BMUsucodigo, BMfechamod )
									values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ids_registro['#i#']#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">,
											<cfif tipo.tipo_dato eq 'B'>
												<cfif isdefined("form.dato_#i#_#j#")>'1'<cfelse>'0'</cfif>,
											<cfelse>
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['dato_#i#_#j#']#">,
											</cfif>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
								</cfquery>
							</cfif> <!--- existe --->
							
							<!--- ============================================================== --->
							<!--- ============================================================== --->
							<cfif usar_criterios  >
								<!--- Creo que es aqui donde debe hacer el brete de validacion --->
								<!---<cfinclude template="criterios-sql.cfm">--->
								<!--- ============================================================= --->
								<cfset registro = ids_registro['#i#'] >
								<cfset aprobo = aprobacion.cumple_criterio(i, j, registro) >
								<!--- ============================================================= --->
								<cfif not es_and and aprobo >
									<cfset aprobar_or = true >
								<cfelseif es_and and not aprobo >
									<cfset aprobar_and = false >
								</cfif>

							</cfif> <!--- usar criterios --->	
							<!--- ============================================================== --->
							<!--- ============================================================== --->
							
						</cfif> <!--- existe la estructura --->
					</cfif> <!--- form.id_requisito_#i#_#j#" --->
				</cfloop> <!--- CAMPOS --->

				<!--- ============================================================== --->
				<!--- ============================================================== --->
				<cfif usar_criterios >
					<cfset aprobar = false >
					<cfif es_and and aprobar_and><cfset aprobar = true ></cfif>
					<cfif not es_and and aprobar_or><cfset aprobar = true ></cfif>
				
					<cfquery datasource="#session.tramites.dsn#">
						update TPInstanciaRequisito
						set completado = <cfif aprobar >1<cfelse>0</cfif>,
							<cfif aprobar >rechazado = 0,</cfif>
							id_funcionario = <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
							id_ventanilla = <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
							fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
						and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
				</cfif>
				<!--- ============================================================== --->
				<!--- ============================================================== --->

			</cfloop>	<!--- requisitos--->
		</cfif>
	</cfif>
</cfif>	

<cfquery name="id" datasource="#session.tramites.dsn#">
	select identificacion_persona, id_tipoident
	from TPPersona
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>
</cftransaction>			

<cflocation url="/cfmx/home/tramites/Operacion/ventanilla/tramite.cfm?id_persona=#form.id_persona#&id_instancia=#form.id_instancia#&id_requisito=#form.id_requisito#&tab=3">