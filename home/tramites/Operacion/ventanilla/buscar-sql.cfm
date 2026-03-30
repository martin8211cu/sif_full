
<cfset existe = false >
<cfset ir = 'buscar.cfm' >

<cfif isdefined("url.identificacion_persona") and isdefined("url.id_tramite")>
	<cfquery name="persona" datasource="#session.tramites.dsn#">
		select id_persona
		from TPPersona
		where identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.identificacion_persona#">
		and id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
	</cfquery>
	<cfif len(trim(persona.id_persona)) eq 0 >
		<!---<cfset ir = '/cfmx/home/menu/portal.cfm?id_tramite=#HTMLEditFormat(url.id_tramite)#&id_tipoident=#HTMLEditFormat(url.id_tipoident)#&identificacion_persona=#HTMLEditFormat(url.identificacion_persona)#&noexistepersona=1' >--->
		<cflocation url="/cfmx/home/menu/portal.cfm?id_tramite=#HTMLEditFormat(url.id_tramite)#&id_tipoident=#HTMLEditFormat(url.id_tipoident)#&identificacion_persona=#HTMLEditFormat(url.identificacion_persona)#&noexistepersona=1" >
	<cfelse>
		<!--- trae la instancia de tramite--->
		<cfinvoke component="home.tramites.componentes.tramites"
				  method="obtener_instancia"
				  id_persona="#persona.id_persona#"
				  id_tramite="#url.id_tramite#"
				  returnvariable="instancia" />
	
		<cfset ir = 'tramite.cfm?id_instancia=#instancia#&id_persona=#persona.id_persona#' >
	</cfif>
<cfelseif isdefined("url.tramite")>
	<cfquery name="instancia" datasource="#session.tramites.dsn#">
		select id_instancia, id_persona , completo
		from TPInstanciaTramite
		where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tramite#">
	</cfquery>
	<cfif instancia.recordcount gt 0>
		<cfif instancia.completo eq 1 >
			<!---<cfset ir = ir & '?completo=1&tramite=#url.tramite#' >--->
			<cflocation url="/cfmx/home/menu/portal.cfm?completo=1&tramite=#url.tramite#">
		<cfelse>
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
					  and it.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_instancia#">
					  and not exists ( select 1
									   from TPInstanciaRequisito ir
									   where ir.id_instancia = it.id_instancia
										 and ir.id_requisito = rt.id_requisito )
			</cfquery>	  
			<cfset ir = 'tramite.cfm?id_instancia=#instancia.id_instancia#&id_persona=#instancia.id_persona#' >
		</cfif>
	<cfelse>
		<!---<cfset ir = ir&  '?noexiste=1&tramite=#url.tramite#' >--->
		<cflocation url="/cfmx/home/menu/portal.cfm?noexiste=1&tramite=#url.tramite#">
	</cfif>
</cfif>

<cflocation url="/cfmx/home/tramites/Operacion/ventanilla/#ir#">