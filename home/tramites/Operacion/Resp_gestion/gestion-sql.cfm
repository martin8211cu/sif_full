
<cfquery name="tramite" datasource="#session.tramites.dsn#">
	select id_instancia, id_funcionario
	from TPInstanciaTramite
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
	and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	and completo = 0
</cfquery>

<cfset p = "?id_persona=#url.id_persona#&id_tramite=#url.id_tramite#&identificacion_persona=#url.identificacion_persona#&id_requisito=#url.id_requisito#" >
<cfif tramite.recordcount gt 0>
	<cfif tramite.id_funcionario neq session.tramites.id_funcionario>
		<cfthrow message="El tr&acute;mite se encuentra en proceso, pero esta siendo atendido por otro funcionario.">
	</cfif>	
	<cfset p = p & "&id_instancia=#tramite.id_instancia#" >
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
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">,
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
											  monto_pagado, 
											  moneda, 
											  forma_pago, 
											  BMUsucodigo, 
											  BMfechamod )
			select #instancia.identity#, 
				   rq.id_requisito, 
				   #session.tramites.id_funcionario#, 
				   #session.tramites.id_ventanilla#,
				   0, 
				   0, 
				   rq.moneda, 
				   'E', 
				   #session.Usucodigo#, 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from TPRReqTramite rt
				join TPRequisito rq
					on rt.id_requisito = rq.id_requisito
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		</cfquery>
	</cftransaction>
	<cfset p = p & "&id_instancia=#instancia.identity#" >
</cfif>

<cfif isdefined("url.LOC")>
	<cfif url.loc eq 'pago'>
		<cflocation url="/cfmx/home/menu/portal.cfm#p#&loc=pago">
	</cfif>
</cfif>

<cflocation url="/cfmx/home/menu/portal.cfm?#p#&loc=gestion">