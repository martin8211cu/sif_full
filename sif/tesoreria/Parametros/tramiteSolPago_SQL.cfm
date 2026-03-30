<!---NUEVO Trámite--->
	<cfif IsDefined("form.Nuevo")>
		<cflocation url="tramiteSolPago.cfm?Nuevo">
	</cfif>

	<cfif isdefined("Form.Alta")>
		<cfquery name="rsConsulta" datasource="#session.DSN#">
			select 
				count(1) as cantidad
			from TESTramiteSolPago
			where Ecodigo = #session.Ecodigo#
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
			and ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tramite#">
		</cfquery>

		<cfif rsConsulta.cantidad LTE 0>
			<cfquery name="rsValidaExistenciaCF" datasource="#session.DSN#">
				select 
					count(1) as cantidad
				from TESTramiteSolPago
				where Ecodigo = #session.Ecodigo#
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">	
			</cfquery>
		
				<cfif rsValidaExistenciaCF.cantidad LTE 0>
					<cfquery name="rsConsultaSolicitud" datasource="#session.DSN#">
						select count(1) as cantidad 
						from TESsolicitudPago sp 
						inner join CFuncional cf 
							on cf.CFid = sp.CFid  
						where sp.TESSPestado = 1 
						and cf.Ecodigo = #session.Ecodigo# 
						and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
					</cfquery>

						<cfif rsConsultaSolicitud.cantidad LTE 0>
							<cftransaction>
								<cfquery name="insertTramiteSP" datasource="#session.dsn#">
									insert into TESTramiteSolPago (ProcessId, CFid, Ecodigo, BMFecha, BMUsucodigo)
										values(
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
											)
									<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
								</cfquery>
								<cf_dbidentity2 datasource="#Session.DSN#" name="insertTramiteSP" verificar_transaccion="false" returnvariable="TESTPid">
							</cftransaction>
						<cfelse>
							<cfthrow message="Existen Solicitudes de Pago sin Aprobar asociadas al Centro Funcional: (#form.CFdescripcion#). Acción Cancelada!">
						</cfif>
					<cfelse>
						<cfthrow message="El Centro Funcional:(#form.CFdescripcion#) Está Asociado a un Trámite">
					</cfif>
				<cfelse>
					<cf_errorCode	code = "50160" msg = "El Registro que desea insertar ya existe.">
				</cfif>
		<cflocation url="tramiteSolPago.cfm?TESTPid=#TESTPid#" addtoken="no">
	<cfelseif isdefined("Form.Baja") or isdefined ("btnEliminar")>
		<cfquery name="rsRegistro" datasource="#session.dsn#">
			select cf.CFdescripcion as centroF, p.Name as tramite
			 from TESsolicitudPago sp 
				  inner join CFuncional cf 
						on cf.CFid = sp.CFid
					inner join TESTramiteSolPago t
						on t.CFid = sp.CFid 
					inner join WfProcess p on p.ProcessId = sp.ProcessId
			 where sp.TESSPestado not in (2,3) 
			  and t.Ecodigo = #session.Ecodigo#
			  and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			  and sp.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
			  and t.TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">				
		</cfquery>
		
			<cfif #rsRegistro.recordcount# GT 0>
				<cfthrow message="Existen Solicitudes de pago sin aprobar asociados al Centro Funcional:(#rsRegistro.centroF#) y al Trámite:(#rsRegistro.tramite#). Acción Cancelada!">
			<cfelse>
				<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
					<cfquery name="rsDelete" datasource="#session.DSN#">
						delete from TESTramiteSolPago
						where Ecodigo = #session.Ecodigo#
						  and TESTPid in (#form.chk#)
					</cfquery>	
				 <cfelseif isdefined("form.TESTPid") and len(trim(form.TESTPid)) GT 0>
					<cfquery name="rsDelete" datasource="#session.DSN#">
						delete from TESTramiteSolPago
						where Ecodigo = #session.Ecodigo#
						and TESTPid  = #form.TESTPid#
					</cfquery>	
				</cfif>
			</cfif>
		<cflocation url="tramiteSolPago.cfm" addtoken="no">	
		
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="rsRegistro" datasource="#session.dsn#">
			select cf.CFdescripcion as centroF, p.Name as tramite
			from TESsolicitudPago sp 
				inner join CFuncional cf 
					on cf.CFid = sp.CFid
				inner join TESTramiteSolPago t 
					on t.CFid = sp.CFid 
				inner join WfProcess p 
					on p.ProcessId = t.ProcessId
			where sp.TESSPestado not in (2,3) 
			and cf.Ecodigo = #session.Ecodigo#
			and t.TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">				
			and sp.ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
		</cfquery>
				
			<cfif #rsRegistro.recordcount# GT 0>
				<cfthrow message="Existen Solicitudes de Pago asociadas al Centro Funcional:(#rsRegistro.centroF#) y al Trámite:(#rsRegistro.tramite#). Acción Cancelada!">
			<cfelse>
				<cfquery name="rsVerificaSiExiste" datasource="#session.dsn#">
					select count(1) as cantidad 
					from TESsolicitudPago sp 
					inner join CFuncional cf 
						on cf.CFid = sp.CFid  
					where sp.TESSPestado =1 
					and cf.Ecodigo = #session.Ecodigo# 
					and sp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
				</cfquery>
							
					<cfif rsVerificaSiExiste.cantidad LTE 0>
						 <cfquery name="rsUpdate" datasource="#session.DSN#">
							update TESTramiteSolPago
								set 
								ProcessId 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
								CFid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
								BMFecha =     <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
								BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and TESTPid 	= #form.TESTPid#
						</cfquery>
				  <cfelse>
					<cfthrow message="Existen solicitudes de Pago asociadas al Centro Funcional: (#form.CFdescripcion#).">
				 </cfif>
			</cfif>
		<cflocation url="tramiteSolPago.cfm?TESTPid=#form.TESTPid#&pagenum3=#form.Pagina3#" addtoken="no">
	</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="tramiteSolPago.cfm?TESTPid=#form.TESTPid#" addtoken="no">


