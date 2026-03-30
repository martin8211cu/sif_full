<cfset flujo_ventanilla = CreateObject('Component', 'home.tramites.componentes.ventanilla') >
<cfset rsAbiertas = flujo_ventanilla.ventanillas_abiertas( session.tramites.id_sucursal ) > 

<!--- select de todos los funcionarios de la misma sucursal --->
<cfquery name="ventanillas" datasource="#session.tramites.dsn#">
	select f.id_funcionario, v.codigo_ventanilla, v.nombre_ventanilla, p.nombre, p.apellido1, p.apellido2 
	from TPFuncionario f
	
	inner join TPRFuncionarioVentanilla fv
	on fv.id_funcionario=f.id_funcionario
	<cfif rsAbiertas.recordcount gt 0>
		and fv.id_ventanilla in ( #valuelist(rsAbiertas.id_ventanilla)# )
	<cfelse>
		and fv.id_ventanilla = 0
	</cfif>
	
	inner join TPVentanilla v
	on v.id_ventanilla=fv.id_ventanilla
	and v.id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_sucursal#">
	
	inner join TPSucursal s
	on s.id_sucursal = v.id_sucursal
	
	inner join TPPersona p
	on p.id_persona=f.id_persona
	
	where f.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	and f.id_funcionario != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
</cfquery>

<cfif ventanillas.recordCount EQ 0>
	<cfset msg_requisito = 'No hay más ventanillas abiertas en esta sucursal.'>
<cfelse>
	<cfset flujo_tramite = CreateObject('Component', 'home.tramites.componentes.tramites') >
	<cfset flujo_lista = '' >
	<cfloop query="ventanillas">
		<cfif flujo_tramite.permisos_obj(ventanillas.id_funcionario, form.id_requisito_flujo, 'R') >
			<cfset flujo_lista = ListAppend(flujo_lista, ventanillas.id_funcionario ) >
		</cfif>
	</cfloop>
	
	<cfif form.modo_flujo eq 1 >
		<!--- asignacion automatica del funcionario ( menor carga de trabajo ) --->
		<cfif len(trim(flujo_lista)) >
			<cfquery name="seleccionado" datasource="#session.tramites.dsn#" maxrows="1">
				select fv.id_funcionario,
					coalesce(( select count(1)
							 from TPListaTrabajo lt2
							 where lt2.id_funcionario=fv.id_funcionario), 0) as carga	
				from TPRFuncionarioVentanilla fv
				
				inner join TPVentanilla v
				on v.id_ventanilla = fv.id_ventanilla
				and v.id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_sucursal#">
				
				where fv.id_funcionario in (#flujo_lista#)
				  and fv.id_funcionario not in ( select id_funcionario
												 from TPListaTrabajo
												 where id_funcionario = fv.id_funcionario
												   and id_requisito=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#">
												   and id_instancia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#"> )
				order by 2
			</cfquery>
			<cfif seleccionado.recordcount gt 0 >
				<cfquery datasource="#session.tramites.dsn#">
					insert into TPListaTrabajo( id_requisito, id_instancia, id_funcionario, id_persona, fecha_asignacion, asignado_por, BMUsucodigo, BMfechamod )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#seleccionado.id_funcionario#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
				</cfquery>
			</cfif>
		<cfelse>
			<cfset msg_requisito = 'No se le puede atender en las ventanillas abiertas.'>
		</cfif>
	<cfelseif form.modo_flujo eq '*' >
		<!--- asigna a todos los funcionarios con permisos de la sucursal --->
		<cfif len(trim(flujo_lista)) >
			<cfquery name="seleccionado" datasource="#session.tramites.dsn#" >
				insert into TPListaTrabajo( id_requisito, id_instancia, id_funcionario, id_persona, fecha_asignacion, asignado_por, BMUsucodigo, BMfechamod )
				select distinct #form.id_requisito_flujo#,
					   #form.id_instancia#, 	
					   fv.id_funcionario,
					   #form.id_persona#,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					   #session.tramites.id_funcionario#,
					   #session.Usucodigo#,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				from TPRFuncionarioVentanilla fv
				
				inner join TPVentanilla v
				on v.id_ventanilla = fv.id_ventanilla
				and v.id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_sucursal#">
				
				where fv.id_funcionario in (#flujo_lista#)
				  and fv.id_funcionario not in ( select id_funcionario
												 from TPListaTrabajo
												 where id_funcionario = fv.id_funcionario
												   and id_requisito=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#">
												   and id_instancia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#"> )
			</cfquery>
		<cfelse>
			<cfset msg_requisito = 'No se le puede atender en las ventanillas abiertas.'>
		</cfif>
	<cfelseif form.modo_flujo eq 'M' >
		<!--- asignación manual del funcionario --->
		<cfif isdefined("form.id_funcionario_flujo") and len(trim(form.id_funcionario_flujo))>
			<cfquery name="existe" datasource="#session.tramites.dsn#">
				select id_funcionario
				from TPListaTrabajo
				where id_requisito=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#">
				  and id_instancia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
				  and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario_flujo#">
			</cfquery>
			<cfif existe.recordcount eq 0 >
				<cfquery datasource="#session.tramites.dsn#">
					insert into TPListaTrabajo( id_requisito, id_instancia, id_funcionario, id_persona, fecha_asignacion, asignado_por, BMUsucodigo, BMfechamod )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito_flujo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario_flujo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
				</cfquery>
			</cfif>
		<cfelse>
			<cfset msg_requisito = 'No seleccionó ningún funcionario para atender el requisito.'>
		</cfif>
	</cfif> <!--- tipo de flujo --->
</cfif>
