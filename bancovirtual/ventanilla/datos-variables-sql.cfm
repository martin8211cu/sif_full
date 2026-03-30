<cfif isdefined("form.Aceptar") or isdefined("form.Rechazar")>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>

	<!--- Estructura para manejo de existencia de instancias de requisito y de expediente --->
	<cfset ids_registro = structnew() >
	<cfif len(trim(form.id_requisito))>
		<cfloop list="#form.id_requisito#" index="i">
			<cfquery name="instancia_req" datasource="tramites_cr">
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
					<cftransaction>
						<cfquery name="nuevo_registro" datasource="tramites_cr">
							insert into DDRegistro (id_persona, id_tipo, BMUsucodigo, BMfechamod)
							values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia_req.id_tipo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
							<cf_dbidentity1 datasource="tramites_cr">
						</cfquery>
						<cf_dbidentity2 datasource="tramites_cr" name="nuevo_registro">
						<cfset id_registro = nuevo_registro.identity >
					
						<cfquery datasource="tramites_cr">
							update TPInstanciaRequisito
							set id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_registro#">
							where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
							and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
						</cfquery>
					</cftransaction>
				</cfif>
			</cfif>
			<cfif len(trim(id_registro))>
				<cfset StructInsert(ids_registro, i, id_registro ) >
			</cfif>

			<!--- rechaza o completa --->
			<cfquery datasource="tramites_cr">
				update TPInstanciaRequisito
				set completado = <cfif isdefined("form.Rechazar")>0<cfelse>1</cfif>,
					rechazado = <cfif isdefined("form.Rechazar")>1<cfelse>0</cfif>,
					id_funcionario = <cfif isdefined("session.tramites.id_funcionario") and len(trim(session.tramites.id_funcionario))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#"><cfelse>null</cfif>,
					id_ventanilla = <cfif isdefined("session.tramites.id_ventanilla") and len(trim(session.tramites.id_ventanilla))><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#"><cfelse>null</cfif>,
					fecha_registro = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
				and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
		</cfloop> <!--- REQUISITOS --->

		<cfloop list="#form.id_requisito#" index="i">
			<!--- =================================================== --->
			<!--- DATOS VARIABLES --->
			<!--- =================================================== --->
			<!--- Insert/Update de datos --->
			<cfloop list="#form.id_campo#" index="j">
				<cfif isdefined("form.id_requisito_#i#_#j#")>
					<cfset requisito = form['id_requisito_#i#_#j#'] >
					<cfquery name="tipo" datasource="tramites_cr">
						select tp.tipo_dato
						from DDTipoCampo cam
							join DDTipo tp
								on tp.id_tipo = cam.id_tipocampo
						where cam.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">
					</cfquery>
					
					<cfif StructKeyExists(ids_registro, i) >
						<cfquery name="existe" datasource="tramites_cr">
							select 1
							from DDCampo
							where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ids_registro['#i#']#">
							  and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">
						</cfquery>
			
						<cfif existe.RecordCount >
							<cfquery datasource="tramites_cr">
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
							<cfquery datasource="tramites_cr">
								insert into DDCampo ( id_registro, id_campo, valor, BMUsucodigo, BMfechamod )
								values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#ids_registro['#i#']#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#j#">,
										<cfif tipo.tipo_dato eq 'B'>
											<cfif isdefined("form.dato_#i#_#j#")>'1'<cfelse>'0'</cfif>,
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['dato_#i#_#j#']#">,
										</cfif>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cfloop> <!--- CAMPOS --->
		</cfloop>	

	</cfif>
</cfif>	

<cfquery name="id" datasource="tramites_cr">
	select identificacion_persona, id_tipoident
	from TPPersona
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>

<cflocation url="/cfmx/home/tramites/Operacion/ventanilla/tramite.cfm?id_persona=#form.id_persona#&id_instancia=#form.id_instancia#&id_requisito=#form.id_requisito#&tab=3">