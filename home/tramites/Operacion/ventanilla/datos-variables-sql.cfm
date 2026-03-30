<cfset msg_requisito = ''>
<cfset aprobacion = createobject('component', 'home.tramites.componentes.criterios' ) >
<cfset bitacora = createobject('component', 'home.tramites.componentes.bitacora') >
<cfset usar_criterios = true >

<cftransaction>
<cfif isdefined("form.Aceptar") or isdefined("form.Rechazar") or isdefined("form.Abrir")>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>

	<!--- Estructura para manejo de existencia de instancias de requisito y de expediente --->
	<cfset ids_registro = structnew() >
	<cfif len(trim(form.id_requisito))>
		<cfloop list="#form.id_requisito#" index="i">
			<cfquery name="instancia_req" datasource="#session.tramites.dsn#">
				select ir.id_instancia, reg.id_registro, doc.id_tipo, r.es_impedimento
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

			<cfset id_registro = instancia_req.id_registro >

			<!--- omitir la inclusión de un registro para los requisitos de impedimento --->
			<cfif instancia_req.es_impedimento NEQ True>
				<cfif Len(id_registro) EQ 0>
					<cfif len(trim(instancia_req.id_tipo))>
						<cfinvoke component="home.tramites.componentes.vistas" method="insRegistro" returnvariable="id_registro">
							<cfinvokeargument name="id_tipo" value="#instancia_req.id_tipo#">
							<cfinvokeargument name="id_persona" value="#form.id_persona#">
							<cfloop list="#form.id_campo#" index="j">
								<cfif isdefined("form.dato_#i#_#j#")>
									<cfinvokeargument name="C_#j#" value="#form['dato_#i#_#j#']#">
								</cfif>
							</cfloop>
						</cfinvoke>
					</cfif>
				<cfelse>
					<cfinvoke component="home.tramites.componentes.vistas" method="updRegistro" >
						<cfinvokeargument name="id_registro" value="#instancia_req.id_registro#">
						<cfloop list="#form.id_campo#" index="j">
							<cfif isdefined("form.dato_#i#_#j#")>
								<cfinvokeargument name="C_#j#" value="#form['dato_#i#_#j#']#">
							</cfif>
						</cfloop>
					</cfinvoke>
					<cfset id_registro = instancia_req.id_registro >
				</cfif>
			</cfif>

			<cfif len(id_registro)>
				<cfquery datasource="#session.tramites.dsn#">
					update TPInstanciaRequisito
					set id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_registro#">
					where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
					and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				</cfquery>
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
				<cfset bitacora.registrar(form.id_tramite, i, session.tramites.id_persona, 'Rechazar', 'Rechazar requisito de forma manual tramite no: #form.id_instancia#, requisito no: #i#') >
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
					<cfset bitacora.registrar(form.id_tramite, i, session.tramites.id_persona, 'Aprobar', 'Aprobar requisito de forma manual tramite no: #form.id_instancia#, requisito no: #i#') >					
				</cfif>
				
				<!--- ======================= --->
				<!--- PROCESO DE FLUJO --->
				<!--- ======================= --->
				<cfif isdefined("form.modo_flujo") and trim(form.modo_flujo) neq 0 >
					<cfinclude template="flujo-sql.cfm">
				</cfif>
				<!--- ======================= --->
				
				<!--- ======================= --->
				<!--- Criterios de Aprobacion --->
				<!--- ======================= --->
				<!--- lleva el control para saber si aprobo todos los criterios --->
				<cfif usar_criterios  >

					<cfset aprobar = aprobacion.cumple_criterio(i, id_registro, form.id_persona) >
				
					<cfquery datasource="#session.tramites.dsn#">
						update TPInstanciaRequisito
						set completado = <cfif aprobar >1<cfelse>0</cfif>,
							rechazado = <cfif aprobar >0<cfelse>1</cfif>,
							id_funcionario = <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
							id_ventanilla = <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
							fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
						and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					</cfquery>
					
					<cfif aprobar >
						<cfset bitacora.registrar(form.id_tramite, i, session.tramites.id_persona, 'Aprobar', 'Aprobar requisito por criterios. Trámite no: #form.id_instancia#, requisito no: #i#') >					
					<cfelse>
						<cfset bitacora.registrar(form.id_tramite, i, session.tramites.id_persona, 'Rechazar', 'Rechazar requisito por criterios. Trámite no: #form.id_instancia#, requisito no: #i#') >					
					</cfif>
				</cfif>	
			</cfif>
		</cfloop> <!--- REQUISITOS --->
	</cfif>
</cfif>	
</cftransaction>			

<cfquery name="id" datasource="#session.tramites.dsn#">
	select identificacion_persona, id_tipoident
	from TPPersona
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>
<cflocation url="/cfmx/home/tramites/Operacion/ventanilla/tramite.cfm?id_persona=#form.id_persona#&id_instancia=#form.id_instancia#&id_requisito=#form.id_requisito#&tab=3&msg_requisito=#URLEncodedFormat(msg_requisito)#">