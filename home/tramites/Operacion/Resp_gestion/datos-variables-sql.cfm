<cfdump var="#form#">

<cfif isdefined("form.Guardar")>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
	<cfset id_instancia = instancia.obtener_instancia(form.id_persona, form.id_tramite) >

	<!--- Estructura para manejo de existencia de instancias de requisito y de expediente --->
	<cfset ins_requisito = structnew() >
	<cfset exp_requisito = structnew() >
	<cfif len(trim(form.id_requisito))>
		<cfloop list="#form.id_requisito#" index="i">
			<cfquery name="instancia_req" datasource="#session.tramites.dsn#">
				select id_instancia, id_expediente
				from TPInstanciaRequisito
				where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_instancia#" >
				  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfif len(trim(instancia_req.id_expediente)) eq 0 >
				<cfset structinsert(ins_requisito, i, instancia_req.id_instancia) >
				<cfset structinsert(exp_requisito, i, instancia_req.id_expediente) >
			</cfif>
		</cfloop>
		
		<!--- Insert/Update de datos --->
		<cfloop list="#form.id_dato#" index="i">
			<cfquery name="existe" datasource="#session.tramites.dsn#">
				select id_dato, id_expediente
				from TPDatoExpediente
				where id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			
			<!--- Ya existe el expediente, solo modificar el dato --->
			<cfif existe.recordcount gt 0>
			<!--- No existe el dato, debe crear el expediente e insertar el dato --->
			<cfelse>
				<cfquery name="expediente" datasource="#session.tramites.dsn#">
					insert into TPExpediente(id_persona, id_requisito, cap_funcionario, cap_ventanilla, cap_fecha, monto_pagado, BMUsucodigo, BMfechamod, revisado)
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['id_requisito_#i#']#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							0 )
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfif>	

<!---
<cfif isdefined("form.Guardar")>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
	<cfset id_instancia = instancia.obtener_instancia(form.id_persona, form.id_tramite) >

	<cfoutput>
	<cfloop list="#form.id_dato#" index="i">
		<cfquery name="instancia_req" datasource="#session.tramites.dsn#">
			select id_expediente 
			from TPInstanciaRequisito
			where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_instancia#" >
			  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['requisito_#i#']#">
		</cfquery>
		
		<cfif len(trim(instancia_req.id_expediente)) eq 0 >
			<cfquery name="expediente" datasource="#session.tramites.dsn#">
				insert TPExpediente(id_persona, id_requisito, cap_funcionario, cap_ventanilla, cap_fecha, monto_pagado, BMUsucodigo, BMfechamod, revisado)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['requisito_#i#']#"> )
			
			
			
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
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
				<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="instancia">
		<cfelse>
			<cfset expediente = instancia_req.id_expediente >
		</cfif>
		
		
	</cfloop>
	</cfoutput>

</cfif>

<!--- <cflocation url="/cfmx/home/menu/portal.cfm?#p#&loc=gestion">--->
--->