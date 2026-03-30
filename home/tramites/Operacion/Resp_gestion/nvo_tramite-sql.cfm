<cfif isdefined("form.Iniciar")>
	<cftransaction>
		<cfquery name="instancia" datasource="#session.tramites.dsn#">
			insert INTO TPInstanciaTramite( id_tramite, id_persona, id_funcionario, id_ventanilla,
				fecha_inicio, completo, BMUsucodigo, BMfechamod )
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
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
			insert INTO TPInstanciaRequisito( id_instancia, id_requisito, id_funcionario, id_ventanilla,
				completado, monto_pagado, moneda, forma_pago, BMUsucodigo, BMfechamod)
			select #instancia.identity#, rq.id_requisito, #session.tramites.id_funcionario#, #session.tramites.id_ventanilla#,
				0, 0, rq.moneda, 'E', #session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from TPRReqTramite rt
				join TPRequisito rq
					on rt.id_requisito = rq.id_requisito
			where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
		</cfquery>
	</cftransaction>
</cfif>

<cflocation url="edit_tramite.cfm?id_persona=#form.id_persona#&id_tramite=#form.id_tramite#&id_instancia=#instancia.identity#">