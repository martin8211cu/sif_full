<cfif isdefined('NUEVO')>
	<cflocation url="CancelacionMasiva.cfm?BTNNUEVO">
<cfelseif isdefined('ALTA')>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	insert into CMcancelacionMasiva (Ecodigo,CMCMdescripcion,CMCMfecha,CMCMejecutado,BMUsucodigo) 
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CMCMdescripcion#" len="40">,
			<cf_dbfunction name="now">,
			0,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
        )
		<cf_dbidentity1 name="rsInsert" datasource="#session.DSN#" returnVariable="LvarCMCMid">
    </cfquery>
	<cf_dbidentity2 name="rsInsert" datasource="#session.DSN#" returnVariable="LvarCMCMid">
	<cflocation url="CancelacionMasiva.cfm?CMCMid=#LvarCMCMid#">
<cfelseif isdefined('CAMBIO')>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	update CMcancelacionMasiva 
		   set CMCMdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CMCMdescripcion#" len="80">
		 where Ecodigo	= #session.Ecodigo#
		   and CMCMid	= #form.CMCMid#
    </cfquery>
	<cflocation url="CancelacionMasiva.cfm?CMCMid=#form.CMCMid#">
<cfelseif isdefined('BAJA')>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	delete from CMcancelacionMasiva 
		 where Ecodigo	= #session.Ecodigo#
		   and CMCMid	= #form.CMCMid#
    </cfquery>
	<cflocation url="CancelacionMasiva.cfm">
<cfelseif isdefined('Reabrir')>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	update CMcancelacionMasivaDet
		   set CMCMDresultado = null
		 where Ecodigo	= #session.Ecodigo#
		   and CMCMid	= #form.CMCMid#
		   and CMCMDresultado not like 'OK%'
    </cfquery>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	update CMcancelacionMasiva
		   set CMCMejecutado = 0
		 where Ecodigo	= #session.Ecodigo#
		   and CMCMid	= #form.CMCMid#
    </cfquery>
	<cflocation url="CancelacionMasiva.cfm?CMCMid=#form.CMCMid#">
<cfelseif isdefined('Reimportar')>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	delete from CMcancelacionMasivaDet
		 where Ecodigo	= #session.Ecodigo#
		   and CMCMid	= #form.CMCMid#
    </cfquery>
	<cflocation url="CancelacionMasiva.cfm?CMCMid=#form.CMCMid#">
<cfelseif isdefined('CANCELACION_MASIVA')>
	<!---- CANCELACION MASIVA DE ORDENES DE COMPRA --->
	<cfquery name="rsOCs" datasource="#session.DSN#">
		select CMCMDtipo, CMCMDnumero, EOidorden, EOestado
				,coalesce((select CPPid from CPNAP where Ecodigo = oc.Ecodigo and CPNAPnum = oc.NAP),0) as CPPid
		  from CMcancelacionMasivaDet d
			left join EOrdenCM oc 
				on oc.Ecodigo = d.Ecodigo and oc.EOnumero = d.CMCMDnumero
		 where d.Ecodigo	= #session.Ecodigo#
		   and d.CMCMid		= #form.CMCMid#
		   and d.CMCMDtipo	= 'OC'
		   and d.CMCMDresultado is null
	</cfquery>
	<cfloop query="rsOCs">
		<cftransaction>
			<cfif rsOCs.EOidorden EQ "">
				<cfset LvarResultado = "OC #rsOCs.CMCMDnumero# no existe">
			<cfelseif rsOCs.EOestado NEQ 10>
				<cfset LvarResultado = "OC #rsOCs.CMCMDnumero# en estado #rsOCs.EOestado#">
			<cfelse>
				<!--- Incluye las SCs referenciadas con DSlinea y sumatoria de DScantCancelar --->
				<cfquery name="rsNewSCs" datasource="#session.DSN#">
					select 	sc.ESnumero, sc.ESestado, 
							ds.DSlinea, d.CMCMid, d.DSlinea as DSlinea2, 
							sum(do.DOcantidad - do.DOcantsurtida) 	as DOcantCancelar,
							min(ds.DScantsurt) 						as DScantSurtida,
							min(coalesce(d.DScantCancelar, 0))  	as DScantCancelar
					  from DOrdenCM do
						inner join DSolicitudCompraCM ds
							on ds.DSlinea = do.DSlinea
						inner join ESolicitudCompraCM sc
							on sc.ESidsolicitud = do.ESidsolicitud
							and sc.Ecodigo = do.Ecodigo
						left join CMcancelacionMasivaDet d
							 on d.CMCMid = #form.CMCMid#
							and d.CMCMDnumero	= sc.ESnumero
							and (d.DSlinea		= ds.DSlinea OR d.DSlinea = 0)
					 where do.Ecodigo	= #session.Ecodigo#
					   and do.EOnumero	= #rsOCs.CMCMDnumero#
					group by sc.ESnumero, sc.ESestado, 
							 ds.DSlinea, d.CMCMid, d.DSlinea
					order by ESnumero
				</cfquery>

				<cfloop query="rsNewSCs">
					<cfif rsNewSCs.DSlinea2 NEQ 0>
						<cfset LvarResultado = "">
						<cfif rsNewSCs.DScantSurtida LT rsNewSCs.DOcantCancelar + rsNewSCs.DScantCancelar>
							<cfset LvarDScantCancelar = rsNewSCs.DScantSurtida>
						<cfelse>
							<cfset LvarDScantCancelar = rsNewSCs.DOcantCancelar + rsNewSCs.DScantCancelar>
						</cfif>
					
						<cfif rsNewSCs.CMCMid EQ "">
							<cfquery datasource="#session.DSN#">
								insert into CMcancelacionMasivaDet 
									(CMCMid, Ecodigo, CMCMDtipo, CMCMDnumero, 
										DSlinea, DScantCancelar,
										CMCMDresultado,
										BMUsucodigo)
								values (#form.CMCMid#, #session.Ecodigo#, 'SC', #rsNewSCs.ESnumero#, 
										#rsNewSCs.DSlinea#, #LvarDScantCancelar#, 
										<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarResultado#" null="#LvarResultado EQ ""#">,
										#session.Usucodigo#
								)
							</cfquery>
						<cfelse>			
							<cfquery datasource="#session.DSN#">
								update CMcancelacionMasivaDet
								   set DScantCancelar = #LvarDScantCancelar#
								 where CMCMid 		= #form.CMCMid#
								   and CMCMDtipo	= 'SC'
								   and CMCMDnumero	= #rsNewSCs.ESnumero#
								   and DSlinea		= #rsNewSCs.DSlinea#
							</cfquery>
						</cfif>
					</cfif>
				</cfloop>
		
				<cftry>
					<cfinvoke  
								method			= "CM_CancelaOC"
								returnVariable	= "LvarNAP"

								CPPid			= "#rsOCs.CPPid#"
								EOidorden		= "#rsOCs.EOidorden#"
								EOjustificacion	= "#form.CMCMmotivo#"
					>
					<cfif LvarNAP GTE 0>
						<cfset LvarResultado = "OK">
					<cfelse>
						<cfset LvarResultado = "NRP = #-LvarNAP#">
					</cfif>
				<cfcatch type="any">
					<cfset LvarResultado = getError(cfcatch)>
					<cftransaction action="rollback" />
				</cfcatch>
				</cftry>
			</cfif>
		</cftransaction>
		<cfquery datasource="#session.DSN#">
			update CMcancelacionMasivaDet
			   set CMCMDresultado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarResultado#">
			 where Ecodigo		= #session.Ecodigo#
			   and CMCMid		= #form.CMCMid#
			   and CMCMDtipo	= 'OC'
			   and CMCMDnumero	= #rsOCs.CMCMDnumero#
		</cfquery>
	</cfloop>

	<!---- CANCELACION MASIVA DE SOLICITUDES DE COMPRA --->
	<cfquery name="rsSCs" datasource="#session.DSN#">
		select d.CMCMDtipo, d.CMCMDnumero, sc.ESidsolicitud, sc.ESestado, d.DSlinea, d.DScantCancelar, sc.CMSid
				,coalesce((select CPPid from CPNAP where Ecodigo = sc.Ecodigo and CPNAPnum = sc.NAP),0) as CPPid
		  from CMcancelacionMasivaDet d
			left join ESolicitudCompraCM sc 
				on sc.Ecodigo = d.Ecodigo and sc.ESnumero = d.CMCMDnumero
		 where d.Ecodigo	= #session.Ecodigo#
		   and d.CMCMid		= #form.CMCMid#
		   and d.CMCMDtipo	= 'SC'
		   and d.CMCMDresultado is null
	</cfquery>
	<cfloop query="rsSCs">
		<cfset LvarDSlinea = rsSCs.DSlinea>
		<cftransaction>
			<cfif rsSCs.ESidsolicitud EQ "">
				<cfset LvarResultado = "SC #rsSCs.CMCMDnumero# no existe">
			<cfelseif not listFind ("20,25,40",rsSCs.ESestado)>
				<cfset LvarResultado = "SC #rsSCs.CMCMDnumero# en estado #rsSCs.ESestado#">
			<cfelse>
				<cftry>
					<cfset LvarNRPs = "">
					<cfif LvarDSlinea EQ "0">
						<cfinvoke	
									method			= "CM_getCancelacionSolicitudes"
									returnVariable	= "rsSC_det"

									Filtro_ESnumero = "#rsSCs.CMCMDnumero#"
						>
						<cfset LvarSCnum = rsSCs.CMCMDnumero>
						<cfset LvarCPPid = rsSCs.CPPid>
						<cfset LvarNAP = "*">
						<cfloop query="rsSC_det">
							<cfinvoke	
										method			= "CM_CancelaLineasSolicitud"
										returnVariable	= "LvarNAP"

										CPPid			= "#LvarCPPid#"
										DSlinea			= "#rsSC_det.DSlinea#"
										DScantcancel	= "#rsSC_det.SaldoLinea#"
										ESidsolicitud	= "#rsSC_det.ESidsolicitud#"
										ESjustificacion	= "#form.CMCMmotivo#"
										Solicitante		= "#rsSC_det.CMSid#"
							>
							<cfif LvarNAP GT 0>
								<cfquery datasource="#session.DSN#">
									insert into CMcancelacionMasivaDet 
										(CMCMid, Ecodigo, CMCMDtipo, CMCMDnumero, 
											DSlinea, DScantCancelar,
											CMCMDresultado,
											BMUsucodigo)
									values (#form.CMCMid#, #session.Ecodigo#, 'SC', 
											#LvarSCnum#, 
											#rsSC_det.DSlinea#, 
											#rsSC_det.SaldoLinea#, 
											'OK',
											#session.Usucodigo#
									)
								</cfquery>
							<cfelse>
								<cfset LvarNRPs = ListAppend(LvarNRPs,-LvarNAP)>
							</cfif>
						</cfloop>
						<cfif LvarNRPs NEQ "">
							<cfset LvarResultado = "NRPs = #LvarNRPs#">
						<cfelseif LvarNAP EQ "*">
							<cfset LvarResultado = "No hay lineas para cancelar">
						<cfelse>
							<cfset LvarResultado = "OK">
							<cfquery datasource="#session.DSN#">
								delete from CMcancelacionMasivaDet
								 where Ecodigo		= #session.Ecodigo#
								   and CMCMid		= #form.CMCMid#
								   and CMCMDtipo	= 'SC'
								   and CMCMDnumero	= #rsSCs.CMCMDnumero#
								   and DSlinea		= 0
							</cfquery>
						</cfif>
					<cfelse>
						<cfif rsSCs.DScantCancelar EQ 0>
							<cfset LvarResultado = "OK = No hay cantidad para cancelar">
						<cfelse>
							<cfinvoke	
										method			= "CM_CancelaLineasSolicitud"
										returnVariable	= "LvarNAP"
										
										CPPid			= "#rsSCs.CPPid#"
										DSlinea			= "#LvarDSlinea#"
										DScantcancel	= "#rsSCs.DScantCancelar#"
										ESidsolicitud	= "#rsSCs.ESidsolicitud#"
										ESjustificacion	= "#form.CMCMmotivo#"
										Solicitante		= "#rsSCs.CMSid#"
							>
							<cfif LvarNAP GTE 0>
								<cfset LvarResultado = "OK">
							<cfelse>
								<cfset LvarResultado = "NRP = #-LvarNAP#">
							</cfif>
						</cfif>
					</cfif>
				<cfcatch type="any">
					<cfset LvarResultado = getError(cfcatch)>
					<cftransaction action="rollback" />
				</cfcatch>
				</cftry>
			</cfif>
		</cftransaction>		
		<cfquery datasource="#session.DSN#">
			update CMcancelacionMasivaDet
			   set CMCMDresultado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarResultado#">
			 where Ecodigo		= #session.Ecodigo#
			   and CMCMid		= #form.CMCMid#
			   and CMCMDtipo	= 'SC'
			   and CMCMDnumero	= #rsSCs.CMCMDnumero#
			   and DSlinea		= #LvarDSlinea#
		</cfquery>
	</cfloop>

	<cfquery datasource="#session.DSN#">
    	update CMcancelacionMasiva 
		   set CMCMdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CMCMdescripcion#: #form.CMCMmotivo#" len="160">
		   	 , CMCMejecutado = 1
		 where Ecodigo	= #session.Ecodigo#
		   and CMCMid	= #form.CMCMid#
    </cfquery>
	<cflocation url="CancelacionMasiva.cfm?CMCMid=#form.CMCMid#">
</cfif>
<cflocation url="CancelacionMasiva.cfm">

<!--- OJO estas funciones son especiales para solucionar problema de Liquidación incorrecta --->
	<!--- Método para cancelar las lineas de la solicitud marcadas CM_CancelaSolicitud --->
	<cffunction name="CM_CancelaLineasSolicitud" access="private" returntype="numeric" output="true">
		<cfargument name="CPPid" 			type="numeric" 	required="true">
		<cfargument name="DSlinea" 			type="string" 	required="true">
		<cfargument name="DScantcancel" 	type="string" 	required="true">
		<cfargument name="ESidsolicitud" 	type="string" 	required="true">
		<cfargument name="ESjustificacion" 	type="string" 	required="true">
		<cfargument name="Solicitante" 		type="numeric" 	required="false" default="#session.compras.solicitante#">
		<cfargument name="Conexion" 		type="string" 	required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="false" default="#session.ecodigo#">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="false" default="#session.Usucodigo#">

		<cfif Arguments.CPPid GTE 182>
			<cfinvoke	component		= "sif.Componentes.CM_CancelaSolicitud"
							method			= "CM_CancelaLineasSolicitud"
							returnVariable	= "LvarNAP"

							CPPid			= "#Arguments.CPPid#"
							DSlinea			= "#Arguments.DSlinea#"
							DScantcancel	= "#Arguments.DScantcancel#"
							ESidsolicitud	= "#Arguments.ESidsolicitud#"
							ESjustificacion	= "#Arguments.ESjustificacion#"
							Solicitante		= "#Arguments.Solicitante#"
							TransaccionActiva = "yes"
			/>
			<cfreturn LvarNAP>
		</cfif>
		
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto(Arguments.Conexion,false,false,true)>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select ESnumero, DSconsecutivo, DScant - DScantsurt as DScantNoSurt
			  from DSolicitudCompraCM
			 where DSolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
			   and DSolicitudCompraCM.DSlinea = #Arguments.DSlinea#
			   and DSolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
		</cfquery>

		<cfif Arguments.DScantcancel LT 0>
			<cfthrow message="Solicitud #rsSQL.ESnumero# línea #rsSQL.DSconsecutivo#: no se permite cancelar una cantidad negativa">
		<cfelseif Arguments.DScantcancel GT rsSQL.DScantNoSurt>
			<cfthrow message="Solicitud #rsSQL.ESnumero# línea #rsSQL.DSconsecutivo#: no se permite cancelar una cantidad mayor que la cantidad no surtida">
		</cfif>

		<cfquery name="data" datasource="#Arguments.Conexion#">
			select ESidsolicitud, ESnumero, ESfecha, NAP
			from ESolicitudCompraCM
			where Ecodigo = #Arguments.Ecodigo#
				and ESidsolicitud = #Arguments.ESidsolicitud#
				and ESestado in (20,25,40)
		</cfquery>
		
		<cfquery name="rsMesAuxiliar" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.Ecodigo#
				and Pcodigo=60
		</cfquery>
	
		<cfquery name="rsPeriodoAuxiliar" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.Ecodigo#
				and Pcodigo=50
		</cfquery>
		
		<cfset LvarNAP = 0>
		
		<cfif Arguments.DScantcancel GT 0 AND data.RecordCount and len(data.NAP) and data.NAP >
			<!--- Se obtiene un numero que sirve para consecutivo de la solicitud para el NAP --->
			<cfquery name="rsSolicitudCancelada" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				from CMSolicCanceladas
				where ESidsolicitud = #Arguments.ESidsolicitud#
					and Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			
			<cfif rsSolicitudCancelada.cantidad EQ "">
				<cfset LvarReferencia = "CANCELACION 1">
			<cfelse>
				<cfset LvarReferencia = "CANCELACION #rsSolicitudCancelada.cantidad + 1#">
			</cfif>

			<!--- inserta la tabla temporal --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#(
														ModuloOrigen,
														NumeroDocumento,
														NumeroReferencia,
														FechaDocumento,
														AnoDocumento,
														MesDocumento,
														NumeroLinea, 
														CFcuenta,
														Ocodigo,
														CodigoOficina,
														Mcodigo,
														MontoOrigen,
														TipoCambio,
														Monto,
														TipoMovimiento,
														NAPreferencia,
														LINreferencia)

				select  'CMSC',																																	<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.ESnumero" >,																						<!--- NumeroDocumento --->
						'#LvarReferencia#',																														<!--- NumeroReferencia --->
						b.ESfecha,																																<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																												<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																													<!--- MesDocumento --->
						a.DSconsecutivo,																														<!--- NumeroLinea  --->
						<!--- Proporción no surtida SC con respecto a la cantidad SC original: --->
							 <!--- Prop. Cant. no surtida:  (CANTIDAD_NO_SURTIDA) / CANTIDAD_ORIGINAL --->
							 <!--- CANTIDAD_NO_SURTIDA =    (CANTIDAD_ORIGINAL - CANTIDAD_SURTIDA - CANTIDAD_CANCELADA) --->
							 <!--- CANTIDAD_ORIGINAL =      (a.DScant+coalesce(a.DScantcancel,0) --->
							 <!--- CANTIDAD_SURTIDA  =      a.DScantsurt --->
							 <!--- CANTIDAD_CANCELADA =     coalesce(a.DScantcancel,0) --->
							 <!--- Prop. Cant. no surtida:  (a.DScant + coalesce(a.DScantcancel,0) - coalesce(a.DScantcancel,0) - a.DScantsurt ) / (a.DScant+coalesce(a.DScantcancel,0)) --->
							 <!--- Prop. Cant. no surtida:  (a.DScant - a.DScantsurt ) / (a.DScant+coalesce(a.DScantcancel,0)) --->
							 <!--- 
									Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto) 
									porque en algunos lugares se recalculaMontos: 
										DStotallinest = round(DScant * DSmontoest,2) 
									Máximo a DesReservar es el monto de la Reserva pero no se verifica porque
										DScantsurt no puede ser negativa
							--->
						napSC.CFcuenta,																																<!--- CFuenta --->
						napSC.Ocodigo,									  																							<!--- Oficina --->
						null,																															<!--- CodigoOficina --->
						napSC.Mcodigo,																																<!--- Mcodigo --->
						-round(
							napSC.CPNAPDmontoOri * (#Arguments.DScantcancel#) / (a.DScant+coalesce(a.DScantcancel,0))
						  ,2),																																<!--- MontoOrigen --->

						napSC.CPNAPDtipoCambio,																															<!--- TipoCambio --->

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						round(
							-round(
								napSC.CPNAPDmontoOri * (#Arguments.DScantcancel#) / (a.DScant+coalesce(a.DScantcancel,0))
							  ,2)
						* napSC.CPNAPDtipoCambio, 2),
						'RC',																																	<!--- TipoMovimiento --->
						b.NAP,																																	<!--- NAPreferencia --->
						a.DSconsecutivo																															<!--- LINreferencia --->

				from DSolicitudCompraCM a
					inner join ESolicitudCompraCM b
						on b.ESidsolicitud = a.ESidsolicitud

					inner join CPNAPdetalle napSC
						 on napSC.Ecodigo		= b.Ecodigo
						and napSC.CPNAPnum		= b.NAP
						and napSC.CPNAPDlinea	= a.DSconsecutivo
				where a.DSlinea = #Arguments.DSlinea#
				  and a.ESidsolicitud = #Arguments.ESidsolicitud#
				  and a.Ecodigo = #Arguments.Ecodigo#
				  and coalesce(a.DSnoPresupuesto,0) = 0
			</cfquery>
				
			<!--- Aprobacion o rechazo de presupuesto --->
			<cfset LvarNAP = AjustePresupuestario(
									"CMSC",
									data.ESnumero,
									'#LvarReferencia#',
									data.ESfecha,
									rsPeriodoAuxiliar.Pvalor,
									rsMesAuxiliar.Pvalor
			)>
		</cfif>
		
		<!--- Presupuestop Ok --->
		<cfif LvarNAP GTE 0 >
			<!--- Actualiza Montos en el Detalle de la Solicitud --->
			<cfquery name="updateMontos" datasource="#Arguments.Conexion#">
				update DSolicitudCompraCM
				set DScantcancel = coalesce(DScantcancel,0) + <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.DScantcancel#">, 
					DScant = DScant - <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.DScantcancel#">
				where DSolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
					and DSolicitudCompraCM.DSlinea = #Arguments.DSlinea#
					and DSolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
			</cfquery>
			
			<!--- Actualiza el estado de la solicitud a 50 --->	
			<cfquery name="updateEstado50" datasource="#Arguments.Conexion#">
				update ESolicitudCompraCM
				set ESestado = 50
				where ESolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
					and ESolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
					and not exists(
						select 1
						from DSolicitudCompraCM
						where (DSolicitudCompraCM.DScant - DSolicitudCompraCM.DScantsurt) <> 0
							and DSolicitudCompraCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud
					)
					and exists(
						select 1
						from DSolicitudCompraCM
						where DSolicitudCompraCM.DScantsurt <>  0
							and DSolicitudCompraCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud
					)
			</cfquery>
			
			<!--- Actualiza el estado de la solicitud a 60 --->
			<cfquery name="updateEstado60" datasource="#Arguments.Conexion#">
				update ESolicitudCompraCM
				set ESestado = 60
				where ESolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
					and ESolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
					and not exists(
						select 1
						from DSolicitudCompraCM
						where (DSolicitudCompraCM.DScant - DSolicitudCompraCM.DScantsurt) <> 0
							and DSolicitudCompraCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud
					)
					and not exists(
						select 1
						from DSolicitudCompraCM
						where DSolicitudCompraCM.DScantsurt <>  0
							and DSolicitudCompraCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud
					)					
			</cfquery>
			
			<!--- Inserta datos al tabla de bitácora de Solictudes Canceladas --->
			<cfquery name="insertSolicitudCancelada" datasource="#Arguments.Conexion#">
				insert into CMSolicCanceladas(	ESidsolicitud,
												DSlinea,
												Ecodigo,
												cantcancel,
												Justificacion,
												NAPasociado,
												BMUsucodigo,
												fechaalta)
					values(	#Arguments.ESidsolicitud#,
							#Arguments.DSlinea#,
							#Arguments.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.DScantcancel#">,
							'#Arguments.ESjustificacion#',
							-#LvarNAP#,
							#Arguments.BMUsucodigo#,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
			</cfquery>
		</cfif>
		<!--- LVarNAP GTE 0 --->

		<cfreturn LvarNAP>
	</cffunction>

	<cffunction name="CM_CancelaOC" access="private" returntype="numeric" output="true">
		<cfargument name="CPPid" 			type="numeric" 	required="true">
		<cfargument name="EOidorden" 		type="string" required="true">
		<cfargument name="EOjustificacion" 	type="string" required="true">

		<cfif Arguments.CPPid GTE 182>
			<cfinvoke	component		= "sif.Componentes.CM_CancelaOC"
						method			= "CM_CancelaOC"
						returnVariable	= "LvarNAP"

						CPPid			= "#Arguments.CPPid#"
						EOidorden		= "#Arguments.EOidorden#"
						EOjustificacion	= "#Arguments.EOjustificacion#"
						TransaccionActiva = "yes"
			/>
			<cfreturn LvarNAP>
		</cfif>

		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>

		<cfquery name="rsVerificaOCEstado" datasource="#session.dsn#">
			select EOidorden, EOnumero, EOfecha, CMTOcodigo, NAP, EOestado
			from EOrdenCM
			where EOidorden=#Arguments.EOidorden#
		</cfquery>

		<cfif rsVerificaOCEstado.EOestado NEQ 10>
			<cfthrow message="La Orden de Compra #rsVerificaOCEstado.EOnumero# con fecha #dateformat(rsVerificaOCEstado.EOfecha, 'DD/MM/YYYY')# no se encuentra en estado Aplicado">
		</cfif>

		<cfquery datasource="#session.dsn#">
			update EOrdenCM
			set EOjustificacion = '#Arguments.EOjustificacion#'
			where EOidorden=#Arguments.EOidorden#
		</cfquery>

		<cfquery name="data" datasource="#session.DSN#">
			select EOidorden, EOnumero, EOfecha, CMTOcodigo, NAP
			from EOrdenCM
			where EOidorden=#Arguments.EOidorden#
			and EOestado = 10
		</cfquery>
		
		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			and Pcodigo   = 60
		</cfquery>
	
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#session.Ecodigo#
			and Pcodigo= 50
		</cfquery>

		<cfset LvarNAP = 0>
		
		<cfif trim(data.NAP) NEQ "" AND data.NAP GTE 0>
			<!---///////////////////////////// ACTUALIZAR LA CANTIDAD SURTIDA DEL CONTRATO //////////////////////////---->
			<cfquery name="rsOrden" datasource="#session.DSN#">
				select 	(coalesce(a.DOcantidad,0) - coalesce(a.DOcantsurtida,0)) as DOcantidad, 
						b.EOestado,
						b.EOfecha,
						a.ACid,
						a.Aid,
						a.Cid,
						a.EOidorden, 	
						a.DOlinea,
						b.SNcodigo
				from DOrdenCM a
					inner join EOrdenCM b
						on a.EOidorden = b.EOidorden
						and a.Ecodigo = b.Ecodigo
				where a.Ecodigo=#session.Ecodigo#
					and a.EOidorden=#Arguments.EOidorden#
			</cfquery>

			<!----<cfif rsOrden.EOestado EQ 8><!---Si la orden de compra fue generada por un contrato---->----->
			<cfloop query="rsOrden"	>
				<cfquery name="rsContratos" datasource="#session.DSN#"><!---Verificar para c/bien de la linea de la orden si esta en un contrato---->
					select 	dc.DClinea, dc.ECid, dc.Aid, dc.Cid, dc.ACid, ec.SNcodigo,
							coalesce(dc.DCcantsurtida,0) as DCcantsurtida,
							coalesce(dc.DCcantcontrato,0) as DCcantcontrato

					from CMOCContrato cmoc
						inner join DContratosCM dc
							on dc.ECid = cmoc.ECid
							and dc.Ecodigo = cmoc.Ecodigo
							<cfif len(trim(rsOrden.Aid))>
								and dc.Aid = #rsOrden.Aid#
							<cfelseif len(trim(rsOrden.Cid))>
								and dc.Cid = #rsOrden.Cid#
							<cfelse>
								and dc.ACid = #rsOrden.ACid#
							</cfif>
						inner join EContratosCM ec
							on ec.ECid = cmoc.ECid
							and ec.Ecodigo = cmoc.Ecodigo
							and ec.SNcodigo = cmoc.SNcodigo

					where cmoc.Ecodigo = #session.Ecodigo#
						and cmoc.DOlinea = #rsOrden.DOlinea#
						and cmoc.EOidorden = #rsOrden.EOidorden#
						and cmoc.SNcodigo = #rsOrden.SNcodigo#
				</cfquery>

				<cfif rsContratos.RecordCount NEQ 0><!---Si la línea esta en un contrato actualiza la cantidad surtida del contrato---->							
					<cfquery datasource="#session.DSN#">
						update DContratosCM
						set DCcantsurtida = <cfqueryparam cfsqltype="cf_sql_float" value="#rsContratos.DCcantsurtida#"> - <cfqueryparam cfsqltype="cf_sql_float" value="#rsOrden.DOcantidad#">
						where Ecodigo = #session.Ecodigo#
							and ECid = #rsContratos.ECid#
							and DClinea = #rsContratos.DClinea#
					</cfquery>

					<!----Inserta en CMOCContrato---->
					<cfquery datasource="#session.DSN#">
						insert into CMOCContrato (DOlinea,
												EOidorden,
												Ecodigo,
												SNcodigo,
												ECid,
												CMOCCcantidad,
												BMUsucodigo,
												fechaalta)	
						values (#rsOrden.DOlinea#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.EOidorden#">,
								#session.Ecodigo#,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsContratos.SNcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratos.ECid#">,
								- (<cfqueryparam cfsqltype="cf_sql_float" value="#rsOrden.DOcantidad#">),
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								)
					</cfquery>
				</cfif>
			</cfloop>
			<!---</cfif>---->
			<!---////////////////////////////////////////////////////////////////---->

			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#( 	
														ModuloOrigen,
														NumeroDocumento,
														NumeroReferencia,
														FechaDocumento,
														AnoDocumento,
														MesDocumento,
														NumeroLinea, 
														CFcuenta,
														Ocodigo,
														CodigoOficina,
														Mcodigo,
														MontoOrigen,
														TipoCambio,
														Monto,
														TipoMovimiento,
														NAPreferencia,
														LINreferencia)

				select  'CMOC',																							<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.EOnumero" >,												<!--- NumeroDocumento --->
						'CANCELACION',																					<!--- NumeroReferencia --->
						b.EOfecha,																						<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																		<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																			<!--- MesDocumento --->
						a.DOconsecutivo,																				<!--- NumeroLinea  --->
						a.CFcuenta,																						<!--- CFuenta --->
						c.Ocodigo,																						<!--- Oficina --->
						d.Oficodigo,																					<!--- CodigoOficina --->
						b.Mcodigo,																						<!--- Mcodigo --->
						<!--- Proporción no surtida OC con respecto a DOcantidad:  (a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
							-round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
						as MtoOrigen,																					<!--- Monto Origen --->

						b.EOtc,
						
						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						round(
							-round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
						 * b.EOtc, 2) as MtoLocal,				 																	<!--- Monto --->
						
						'CC', 																							<!--- TipoMovimiento --->
						b.NAP, 																							<!--- NAPreferencia --->
						a.DOconsecutivo																					<!--- LINreferencia --->
				from DOrdenCM a
					inner join EOrdenCM b
						on b.EOidorden = a.EOidorden
						and b.Ecodigo = a.Ecodigo
					inner join CFuncional c
						on c.CFid = a.CFid
						and c.Ecodigo = a.Ecodigo
					inner join Oficinas d
						on d.Ocodigo = c.Ocodigo
						and d.Ecodigo = c.Ecodigo
				where a.Ecodigo=#session.Ecodigo#
					and b.EOidorden=#Arguments.EOidorden#
				
				union

				<!--- Devolución de la DesReserva --->					
				select  'CMOC',																						<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.EOnumero" >,											<!--- NumeroDocumento --->
						'CANCELACION',																				<!--- NumeroReferencia --->
						b.EOfecha,																					<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																	<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																		<!--- MesDocumento --->
						-(a.DOconsecutivo),																			<!--- NumeroLinea  --->
						<!--- Proporción no surtida OC con respecto a la cantidad SC original, maximo cantidad reservada original: --->
							 <!--- Prop. Cant. no surtida: CANTIDAD_NO_SURTIDA / CANTIDAD_ORIGINAL --->
							 <!--- CANTIDAD_NO_SURTIDA  =  (a.DOcantidad-a.DOcantsurtida) --->
							 <!--- CANTIDAD_ORIGINAL =     (g.DScant+coalesce(g.DScantcancel,0) --->
							 <!--- Prop. Cant. no surtida: (a.DOcantidad-a.DOcantsurtida) / (g.DScant+coalesce(g.DScantcancel,0) --->
							 <!--- 
									Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto) 
									porque en algunos lugares se recalculaMontos: 
										DStotallinest = round(DScant * DSmontoest,2) 
									El máximo a Devolver es el monto Sí Utilizado de la Reserva
						--->
						napSC.CFcuenta,																					<!--- CFuenta --->
						napSC.Ocodigo,																					<!--- Oficina --->
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,																				<!--- CodigoOficina --->
						napSC.Mcodigo,																					<!--- Mcodigo --->
						case 
							<!--- Se pregunta en moneda local (CPNAPDmonto) porque CPNAPDutilizado sólo está en moneda local --->
							when napSC.CPNAPDutilizado < napSC.CPNAPDmonto * (a.DOcantidad-a.DOcantsurtida) / (g.DScant+coalesce(g.DScantcancel,0)) then
								round(napSC.CPNAPDutilizado / napSC.CPNAPDtipoCambio,2)
							else
								round( napSC.CPNAPDmontoOri * (a.DOcantidad-a.DOcantsurtida) / (g.DScant+coalesce(g.DScantcancel,0)) ,2)
						end,																						<!--- MontoOrigen --->

						napSC.CPNAPDtipoCambio,																				<!--- TipoCambio --->

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						round(
							case 
								<!--- Se pregunta en moneda local (CPNAPDmonto) porque CPNAPDutilizado sólo está en moneda local --->
								when napSC.CPNAPDutilizado < napSC.CPNAPDmonto * (a.DOcantidad-a.DOcantsurtida) / (g.DScant+coalesce(g.DScantcancel,0)) then
									round(napSC.CPNAPDutilizado / napSC.CPNAPDtipoCambio,2)
								else
									round( napSC.CPNAPDmontoOri * (a.DOcantidad-a.DOcantsurtida) / (g.DScant+coalesce(g.DScantcancel,0)) ,2)
							end
						* napSC.CPNAPDtipoCambio, 2),

						'RC',																						<!--- TipoMovimiento --->
						b.NAP, 																						<!--- NAPreferencia --->
						-(a.DOconsecutivo)																			<!--- LINreferencia --->
				  from DOrdenCM a
					inner join EOrdenCM b
						 on b.EOidorden = a.EOidorden
						and b.Ecodigo = a.Ecodigo
					inner join ESolicitudCompraCM f
						 on f.ESidsolicitud = a.ESidsolicitud
						<!---and coalesce(f.NAP,0) > 0 ControlPresupuestario ignora estas líneas pero es preferible dejarla para efectos de legibilidad.--->
					inner join DSolicitudCompraCM g
						 on g.ESidsolicitud = a.ESidsolicitud
						and g.DSlinea = a.DSlinea

					inner join CPNAPdetalle napSC
						 on napSC.Ecodigo		= f.Ecodigo
						and napSC.CPNAPnum		= f.NAP
						and napSC.CPNAPDlinea	= g.DSconsecutivo
				 where a.Ecodigo=#session.Ecodigo#
				   and b.EOidorden=#Arguments.EOidorden#
			</cfquery>

			<cfset LvarNAP = AjustePresupuestario(
									"CMOC", 
									data.EOnumero, 
									"CANCELACION",
									data.EOfecha,
									rsPeriodoAuxiliar.Pvalor,
									rsMesAuxiliar.Pvalor,
									Session.DSN,
									Session.Ecodigo,
									data.NAP
			)>
		</cfif>
		
		<cfif LvarNAP GTE 0>
			<!--- Detalles de la Orden de Compra que se va a Cancelar --->
			<cfquery name="ActDetSolicitud" datasource="#session.dsn#">
				select ESidsolicitud, Ecodigo, DSlinea, coalesce(sum(DOcantidad - DOcantsurtida), 0) as Cantidad
				from DOrdenCM
				where DOrdenCM.EOidorden = #Arguments.EOidorden#
				  and DSlinea is not null
				  and ESidsolicitud is not null
				group by ESidsolicitud, Ecodigo, DSlinea
			</cfquery>
			
			<cfloop query="ActDetSolicitud">
				<cfquery datasource="#session.DSN#">
					update DSolicitudCompraCM
						set DScantsurt   =  
								case 
									when DScantsurt >= #ActDetSolicitud.Cantidad# then
										DScantsurt  -  #ActDetSolicitud.Cantidad#
									else
										0
								end
					where DSolicitudCompraCM.DSlinea       = #ActDetSolicitud.DSlinea#
					  and DSolicitudCompraCM.ESidsolicitud = #ActDetSolicitud.ESidsolicitud#
					  and DSolicitudCompraCM.Ecodigo       = #ActDetSolicitud.Ecodigo#
				</cfquery>
			</cfloop>
			
			<cfquery name="qry_CompraDirecta" datasource="#Session.DSN#">
				select distinct CMTScompradirecta as CompraDirecta
				from DOrdenCM 
					inner join DSolicitudCompraCM
						on DOrdenCM.ESidsolicitud = DSolicitudCompraCM.ESidsolicitud					 
						and DOrdenCM.Ecodigo = DSolicitudCompraCM.Ecodigo
						and DOrdenCM.DSlinea = DSolicitudCompraCM.DSlinea
					inner join ESolicitudCompraCM
						on ESolicitudCompraCM.ESidsolicitud = DSolicitudCompraCM.ESidsolicitud
						and ESolicitudCompraCM.Ecodigo = DSolicitudCompraCM.Ecodigo
					inner join CMTiposSolicitud
						on ESolicitudCompraCM.CMTScodigo = CMTiposSolicitud.CMTScodigo
						and ESolicitudCompraCM.Ecodigo = CMTiposSolicitud.Ecodigo  
				where DOrdenCM.Ecodigo = #session.Ecodigo#
					and DOrdenCM.EOidorden = #Arguments.EOidorden#
			</cfquery>
			
			<cfquery name="qry_countdets" datasource="#Session.DSN#">
				select count(1) as surtidos
				from DOrdenCM 
				inner join DSolicitudCompraCM
					on DOrdenCM.ESidsolicitud = DSolicitudCompraCM.ESidsolicitud
					and DOrdenCM.Ecodigo = DSolicitudCompraCM.Ecodigo
					and DOrdenCM.DSlinea = DSolicitudCompraCM.DSlinea
					and DSolicitudCompraCM.DScantsurt > 0
				where DOrdenCM.Ecodigo = #session.Ecodigo#
					and DOrdenCM.EOidorden = #Arguments.EOidorden#
			</cfquery>

			<cfquery name="update" datasource="#session.DSN#">
				update ESolicitudCompraCM
				<cfif isdefined("qry_CompraDirecta") and trim(qry_CompraDirecta.CompraDirecta) NEQ 1>
					set ESestado = <cfif qry_countdets.surtidos>40<cfelse>20</cfif>
				<cfelse>
					set ESestado = 25
				</cfif>
				where exists (
								select 1
								from DOrdenCM 
								where DOrdenCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud
										and DOrdenCM.Ecodigo = ESolicitudCompraCM.Ecodigo
										and DOrdenCM.EOidorden = #Arguments.EOidorden#
										and DOrdenCM.Ecodigo = #session.Ecodigo#
							)	
			</cfquery>
			
			<cfquery name="rsTotalLineasSurtidas" datasource="#session.DSN#">
				select count(1) as Total
				from DOrdenCM
				where Ecodigo = #session.Ecodigo#
					and EOidorden = #Arguments.EOidorden#
					and DOcantsurtida > 0
			</cfquery>
		
			<cfquery name="update" datasource="#session.DSN#">
				update EOrdenCM
				set EOestado = <cfif rsTotalLineasSurtidas.Total gt 0>55<cfelse>60</cfif>,
					NAPcancel = #-LvarNAP#,
					EOjustificacion = '#Arguments.EOjustificacion#'
				where EOidorden = #Arguments.EOidorden#
				and Ecodigo = #session.Ecodigo#
				<!----and CMCid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comprador#">----->
			</cfquery>
			
			<!--- Envío de Aviso a Solicitantes --->
			<cfquery name="solicitantes" datasource="#session.DSN#">
				select distinct coalesce(Pemail1,Pemail2) email_solicitante
						<!---, DSlinea as linea_solicitud, ESnumero as numero_solicitud--->
				from DOrdenCM a
				inner join ESolicitudCompraCM a2
					on a2.ESidsolicitud = a.ESidsolicitud
				inner join UsuarioReferencia b 
					on <cf_dbfunction name="to_number" datasource="#session.DSN#" args="b.llave"> = a2.CMSid
					and b.STabla = 'CMSolicitantes'
				inner join Usuario c 
					on c.Usucodigo = b.Usucodigo
				inner join DatosPersonales d
					on d.datos_personales = c.datos_personales
				where EOidorden = #Arguments.EOidorden#
					and a.Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfquery name="comprador" datasource="#session.DSN#">
				select coalesce(Pemail1,Pemail2) email_comprador, CMCnombre as nombre_comprador, coalesce(Poficina,Pcelular) telefono_comprador
				from EOrdenCM a
				inner join UsuarioReferencia b 
					on <cf_dbfunction name="to_number" datasource="#session.DSN#" args="b.llave"> = a.CMCid
					and b.STabla = 'CMCompradores'
				inner join CMCompradores cmc 
					on cmc.CMCid = a.CMCid
				inner join Usuario c 
					on c.Usucodigo = b.Usucodigo
				inner join DatosPersonales d
					on d.datos_personales = c.datos_personales
				where a.EOidorden = #Arguments.EOidorden#
			</cfquery>
			<cfquery name="proveedor" datasource="#session.DSN#">
				select coalesce(Pemail1,Pemail2) email_proveedor
				from EOrdenCM a
				inner join UsuarioReferencia b 
					on <cf_dbfunction name="to_number" datasource="#session.DSN#" args="b.llave"> = a.SNcodigo
					and b.STabla = 'SNegocios'
				inner join Usuario c 
					on c.Usucodigo = b.Usucodigo
				inner join DatosPersonales d
					on d.datos_personales = c.datos_personales
				where EOidorden = #Arguments.EOidorden#
			</cfquery>
			<cfquery name="rsDatosOrden" datasource="#session.DSN#"><!---Query con los datos de la orden de compra--->
				select b.DOconsecutivo as linea_solicitud, b.DOcantidad, b.DOdescripcion, c.CFdescripcion
				from DOrdenCM b
					inner join EOrdenCM a
						on a.EOidorden = b.EOidorden
						and a.Ecodigo = b.Ecodigo
					inner join CFuncional c
						on b.CFid = c.CFid
						and b.Ecodigo = c.Ecodigo
				where b.Ecodigo = #session.Ecodigo#
					and b.EOidorden = #Arguments.EOidorden#
			</cfquery>
			<!--- Se arma el cuerpo del mail ---->
			<cfsavecontent variable="email_body">
				<html>
					<head>
						<style type="text/css">
							.tituloIndicacion {
								font-size: 10pt;
								font-variant: small-caps;
								background-color: ##CCCCCC;
							}
							.tituloListas {
								font-weight: bolder;
								vertical-align: middle;
								padding: 2px;
								background-color: ##F5F5F5;
							}
							.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
							.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
							body,td {
								font-size: 12px;
								background-color: ##f8f8f8;
								font-family: Verdana, Arial, Helvetica, sans-serif;
							}
						</style>
					</head>
					<body>
						<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td colspan="7">
									<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
										<tr>
											<td nowrap width="6%"><strong>De:</strong></td>										
											<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
										</tr>											
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td>Cancelaci&oacute;n de orden de compra</td>	
										</tr>																			
									</table>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="2%">&nbsp;</td>
								<td colspan="6">										
									La orden de compra <cfoutput>#data.EOnumero#</cfoutput> ha sido cancelada.  
									Para cualquier consulta por favor comunicarse con el departamento de compras al tel&eacute;fono <cfoutput>#comprador.telefono_comprador#</cfoutput>.<br><br>
									A continuaci&oacute;n se detallan las l&iacute;neas contenidas en la orden de compra cancelada.
								</td>
							</tr>	
							<tr><td colspan="7">&nbsp;</td></tr>								
							<tr>
								<td width="2%">&nbsp;</td>
								<td colspan="6">
									<table border="1" with="100%" cellspacing="0" cellpadding="0" width="99%" align="center">
										<tr>
											<td width="13%"><strong>Línea</strong></td>
											<td width="40%"><strong>Artículo</strong></td>
											<td width="10%"><strong>Cantidad</strong></td>
											<td width="35%"><strong>Centro Funcional</strong></td>										
										</tr>
										<cfoutput query="rsDatosOrden">
											<tr>
												<td width="13%">#rsDatosOrden.linea_solicitud#</td>
												<td width="40%">#rsDatosOrden.DOdescripcion#</td>
												<td width="10%" align="center">#rsDatosOrden.DOcantidad#</td>
												<td width="35%">#rsDatosOrden.CFdescripcion#</td>
											</tr>
										</cfoutput>										
									</table>
								</td>
							</tr>															
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr><td colspan="7">&nbsp;</td></tr>
						</table>
					</body>
				</html>
			</cfsavecontent>

			<cfset email_subject = "Cancelación de orden de compra"><!---Variable con el asunto del mail--->
			
			<cfif isdefined("comprador.email_comprador") and len(comprador.email_comprador)>
				<cfloop query="solicitantes">
					<cfif isdefined("solicitantes.email_solicitante") and len(solicitantes.email_solicitante)>
						<cfquery datasource="#session.dsn#">
							insert INTO SMTPQueue 
								(SMTPremitente, SMTPdestinatario, SMTPasunto,
								SMTPtexto, SMTPhtml)
								values(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(comprador.email_comprador)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(solicitantes.email_solicitante)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)										
						</cfquery>							
					</cfif><!--- si esta definido el email del solicitante --->
				</cfloop>
				<!--- Envío de Aviso a Proveedor --->
				<cfif isdefined("proveedor.email_proveedor") and len(proveedor.email_proveedor)>
					<cfquery datasource="#session.dsn#">
						insert INTO SMTPQueue 
							(SMTPremitente, SMTPdestinatario, SMTPasunto,
							SMTPtexto, SMTPhtml)
							values(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(comprador.email_comprador)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(proveedor.email_proveedor)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)										
					</cfquery>						
				</cfif><!--- si esta definido el email del prveedor --->
			</cfif><!--- si esta definido el email del comprador --->
		</cfif><!--- LVarNAP GTE 0 --->

		<cfreturn LvarNAP>
	</cffunction>

	<cffunction name="AjustePresupuestario" access="private" returntype="numeric" output="true">
		<cfargument name='ModuloOrigen' 	type="string" 	required='true'>		
		<cfargument name='NumeroDocumento' 	type='string' 	required='true'>
		<cfargument name='NumeroReferencia' type='string' 	required='true'>
		<cfargument name='FechaDocumento' 	type='date'   	required='true'>
		<cfargument name='AnoDocumento'	 	type='numeric' 	required='true'>
		<cfargument name='MesDocumento'	 	type='numeric' 	required='true'>
		<cfargument name="Conexion" 		type="string" 	required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="string" 	required="false" default="#session.Ecodigo#">

		<cfquery name="rsNAP" datasource="#Arguments.Conexion#">
			select NAPreferencia, LINreferencia, sum(round(Monto,2)) as Monto
			  from #request.intPresupuesto#
			 where NAPreferencia is not null
			group by NAPreferencia, LINreferencia
		</cfquery>
		<cfloop query="rsNAP">
			<cfif rsNAP.Monto NEQ "" AND rsNAP.Monto NEQ "0">
				<cfset LvarNAPori = #rsNAP.NAPreferencia#>
				<cfset LvarLINori = #rsNAP.LINreferencia#>
				<cfset LvarNAPreferencia = #rsNAP.NAPreferencia#>
				<cfset LvarLINreferencia = #rsNAP.LINreferencia#>
				<cfset LvarMonto = #rsNAP.Monto#>
				<cfloop condition="true">
					<cfquery name="rsREF" datasource="#Arguments.Conexion#">
						select CPNAPnumRef as NAPreferencia, CPNAPDlineaRef as LINreferencia
						  from CPNAPdetalle
						 where Ecodigo		= #Arguments.Ecodigo#
						   and CPNAPnum		= #LvarNAPreferencia#
						   and CPNAPDlinea	= #LvarLINreferencia#
					</cfquery>
					<cfif rsREF.NAPreferencia EQ "">
						<cfbreak>
					</cfif>
					<cfset LvarNAPreferencia = #rsREF.NAPreferencia#>
					<cfset LvarLINreferencia = #rsREF.LINreferencia#>
				</cfloop>

				<cfquery datasource="#Arguments.Conexion#">
					update CPNAPdetalle
					   set CPNAPDutilizado = round(CPNAPDutilizado, 2) - #LvarMonto#
					     , CPNAPDreferenciado = 1
					 where Ecodigo		= #Arguments.Ecodigo#
					   and CPNAPnum		= #LvarNAPreferencia#
					   and CPNAPDlinea	= #LvarLINreferencia#
				</cfquery>
				<cfif LvarNAPori NEQ LvarNAPreferencia>
					<cfquery datasource="#Arguments.Conexion#">
						update #request.intPresupuesto#
						   set 	NAPreferencia = #LvarNAPreferencia#, 
						   		LINreferencia = #LvarLINreferencia#
						 where NAPreferencia = #LvarNAPori#
						   and LINreferencia = #LvarLINori#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>

		<cfinvoke 
			 component		= "sif.Componentes.PRES_Presupuesto"
			 method			= "rsCPresupuestoPeriodo"
			 returnvariable = "rsSQL"
		>
				<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#"/>
				<cfinvokeargument name="ModuloOrigen" 		value="#Arguments.ModuloOrigen#"/>
				<cfinvokeargument name="FechaDocumento" 	value="#Arguments.FechaDocumento#"/>
				<cfinvokeargument name="AnoDocumento" 		value="#Arguments.AnoDocumento#"/>
				<cfinvokeargument name="MesDocumento" 		value="#Arguments.MesDocumento#"/>
		</cfinvoke>

		<cfquery datasource="#Arguments.Conexion#">
			update #request.intPresupuesto#
			   set CPcuenta = 
					(
						select CPcuenta
						  from CFinanciera
						 where CFcuenta = #Request.intPresupuesto#.CFcuenta
					)
					, CPPid = #rsSQL.CPPid#
					, CPCano = #Arguments.AnoDocumento#
					, CPCmes = #Arguments.MesDocumento#
					, CPCanoMes = #Arguments.AnoDocumento*100 + Arguments.MesDocumento#
					, SignoMovimiento = -1
					, TipoControl = 1
					, CalculoControl = 1
					, DisponibleAnterior = 0
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			delete from #request.intPresupuesto# where CPcuenta IS NULL
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			insert into CPresupuestoControl
			(Ecodigo, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes)
			select distinct #session.Ecodigo#, CPPid, CPCano, CPCmes, CPcuenta, Ocodigo, CPCanoMes
			from #request.intPresupuesto# n
			where (
				select count(1)
				  from CPresupuestoControl s
				 where s.Ecodigo 	= #session.Ecodigo#
				   and s.CPPid		= n.CPPid
				   and s.CPCano		= n.CPCano
				   and s.CPCmes		= n.CPCmes
				   and s.CPcuenta	= n.CPcuenta
				   and s.Ocodigo	= n.Ocodigo
				  ) = 0
		</cfquery>
		<cfinvoke 
			 component		= "sif.Componentes.PRES_Presupuesto"
			 method			= "fnGeneraNAP"
			 returnvariable = "LvarNAP">
				<cfinvokeargument name="EcodigoOrigen" 		value="#session.Ecodigo#"/>
				<cfinvokeargument name="ModuloOrigen" 		value="#Arguments.ModuloOrigen#"/>
				<cfinvokeargument name="NumeroDocumento" 	value="#Arguments.NumeroDocumento#"/>
				<cfinvokeargument name="NumeroReferencia" 	value="#Arguments.NumeroReferencia#"/>
				<cfinvokeargument name="FechaDocumento" 	value="#Arguments.FechaDocumento#"/>
				<cfinvokeargument name="AnoDocumento" 		value="#Arguments.AnoDocumento#"/>
				<cfinvokeargument name="MesDocumento" 		value="#Arguments.MesDocumento#"/>
				<cfinvokeargument name="NAPreversado" 		value="0"/>
				<cfinvokeargument name="Conexion" 			value="#session.dsn#"/>
				<cfinvokeargument name="Ecodigo"	 		value="#session.Ecodigo#"/>
				<cfinvokeargument name="LvarCPPid"		 	value="#rsSQL.CPPid#"/>
		</cfinvoke>

		<cfreturn LvarNAP>
	</cffunction>
	<cffunction name="CM_getCancelacionSolicitudes" access="public" returntype="query" output="true">
		<cfargument name="Filtro_ESnumero" type="numeric">
		<cfargument name="Conexion" type="string" required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" type="numeric" required="false" default="#session.ecodigo#">

		<cfquery name="data" datasource="#Arguments.Conexion#">
			select  ECM.ESidsolicitud, 
					ECM.CMSid, 
					DSolicitudCompraCM.DSlinea,
					(DSolicitudCompraCM.DScant - DSolicitudCompraCM.DScantsurt) SaldoLinea
			from ESolicitudCompraCM ECM
				inner join DSolicitudCompraCM
					on DSolicitudCompraCM.ESidsolicitud = ECM.ESidsolicitud
					and DSolicitudCompraCM.Ecodigo = ECM.Ecodigo
			where ECM.Ecodigo = #Arguments.Ecodigo#
				and ECM.ESestado in (20,25,40)
				and ECM.ESidsolicitud not in (select DOrdenCM.ESidsolicitud 
											from DOrdenCM 
												inner join EOrdenCM 
												on DOrdenCM.EOidorden = EOrdenCM.EOidorden 
											where DOrdenCM.ESidsolicitud = ECM.ESidsolicitud 
												and EOrdenCM.EOestado >= 0
												and EOrdenCM.EOestado < 10
												)
				and ECM.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud 
											from CMLineasProceso 
												inner join CMProcesoCompra 
												on CMProcesoCompra.CMPid = CMLineasProceso.CMPid 
												and CMProcesoCompra.CMPestado < 10)
				and (DSolicitudCompraCM.DScant - DSolicitudCompraCM.DScantsurt) > 0
				and ECM.ESnumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
					
			order by ECM.ESnumero, DSolicitudCompraCM.DSlinea
		</cfquery>

		<cfreturn data>
	</cffunction>

	<cffunction name="getError" returntype="string">
		<cfargument name="cfcatch" type="any">
		<cfset var LvarError = "">
		<cfif  trim(cfcatch.Detail) NEQ "" AND isdefined("arguments.cfcatch.TagContext")>
			<cfset LvarError = cfcatch.TagContext[1].Template & ": " & cfcatch.TagContext[1].Line>
			<cfif find(expandPath("/"),LvarError)>
				<cfset LvarError = mid(LvarError,find(expandPath("/"),LvarError),1000)>
				<cfset LvarError = Replace(LvarError,expandPath("/"),"CFMX/")>
				<cfset LvarError = REReplace(LvarError,"[/\\]","/","ALL")>
			</cfif>
			<cfset LvarError = cfcatch.Message & " " & trim(cfcatch.Detail) & " " & LvarError>
		<cfelse>
			<cfset LvarError = cfcatch.Message>
		</cfif>
		<cfreturn LvarError>
	</cffunction>
