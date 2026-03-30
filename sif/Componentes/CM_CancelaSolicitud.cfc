<cfcomponent>
	<!--- Método para cancelar la solicitud CM_CancelaSolicitud --->
	<cffunction name="CM_CancelaSolicitud" access="public" returntype="numeric" output="true">
		<cfargument name="ESidsolicitud" 	type="string" 	required="true">
		<cfargument name="ESjustificacion" 	type="string" 	required="true">
		<cfargument name="Solicitante" 		type="numeric" 	required="false" default="#session.compras.solicitante#">
		<cfargument name="Conexion" 		type="string" 	required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="false" default="#session.ecodigo#">

		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto(Arguments.Conexion,false,false,true)>

        <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
            select count(1) as parciales
              from DSolicitudCompraCM
             where Ecodigo			= #Arguments.Ecodigo#
               and ESidsolicitud	= #Arguments.ESidsolicitud#
               and DScantsurt	<>  0
        </cfquery>
        <cfif rsSQL.parciales GT 0>
        	<cf_errorCode	code = "51101" msg = "Este proceso no puede cancelar parcialmente una solicitud de compra">
        </cfif>

		<cftransaction>
			<cfquery name="data" datasource="#Arguments.Conexion#">
				select ESidsolicitud, ESnumero, ESfecha, NAP
				from ESolicitudCompraCM
				where Ecodigo=#Arguments.Ecodigo#
				and ESidsolicitud= #Arguments.ESidsolicitud#
				and CMSid= #arguments.solicitante#
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

			<cfif data.RecordCount and len(data.NAP) and data.NAP>
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
															LINreferencia,
															PCGDid, PCGDcantidad)

					select  'CMSC',																		<!--- ModuloOrigen --->
							<cf_dbfunction name="to_char" args="b.ESnumero" >,							<!--- NumeroDocumento --->
							'CANCELACION',																<!--- NumeroReferencia --->
							b.ESfecha,																	<!--- FechaDocumento --->
							#rsPeriodoAuxiliar.Pvalor#,													<!--- AnoDocumento --->
							#rsMesAuxiliar.Pvalor#,														<!--- MesDocumento --->
							a.DSconsecutivo,															<!--- NumeroLinea  --->
							a.CFcuenta,																	<!--- CFuenta --->
							c.Ocodigo,																	<!--- Oficina --->
							d.Oficodigo,																<!--- CodigoOficina --->
							b.Mcodigo,     																<!--- Mcodigo --->
							<!--- TODO EL MONTO PORQUE NO HAY CANTIDAD SURTIDA --->
							-napSC.CPNAPDmontoOri,														<!--- MontoOrigen --->
							b.EStipocambio,																<!--- TipoCambio --->
							-napSC.CPNAPDmonto,															<!--- Monto Local --->
							'RC',																		<!--- TipoMovimiento --->
							b.NAP,																		<!--- NAPreferencia --->
							a.DSconsecutivo,                                                            <!--- LINreferencia --->
							a.PCGDid,
							-a.DScant

					from ESolicitudCompraCM b
						inner join DSolicitudCompraCM a
							inner join CFuncional c
								inner join Oficinas d
									 on d.Ocodigo = c.Ocodigo
									and d.Ecodigo = c.Ecodigo
							on c.CFid = a.CFid
						inner join Impuestos e
							on e.Icodigo = a.Icodigo
							and e.Ecodigo = a.Ecodigo
						inner join CPNAPdetalle napSC
							 on napSC.Ecodigo		= b.Ecodigo
							and napSC.CPNAPnum		= b.NAP
							and napSC.CPNAPDlinea	= a.DSconsecutivo
						on a.ESidsolicitud = b.ESidsolicitud
					where b.ESidsolicitud	= #Arguments.ESidsolicitud#
					  and coalesce(a.DSnoPresupuesto,0) = 0
				</cfquery>

				<!--- aprobacion o rechazo de presupuesto --->
				<cfset LvarNAP = LobjControl.ControlPresupuestario(	"CMSC",
																	-data.ESnumero,
																	data.ESidsolicitud,
																	data.ESfecha,
																	rsPeriodoAuxiliar.Pvalor,
																	rsMesAuxiliar.Pvalor,
																	Arguments.Conexion,
																	Arguments.Ecodigo,
																	data.NAP)>
			</cfif>

			<!--- presupuestop ok --->
			<cfif LvarNAP GTE 0>
				<!--- Quitado por DAG el 01/09/2004. Pero debe ponerse un chequeo en la publicación de la publicación de Procesos de Compra.
				<cfquery name="update" datasource="#Arguments.Conexion#">
					update DSolicitudCompraCM
					set DScant = DScantsurt,
						DStotallinest = round(DStotallinest/DScant*DScantsurt,2),
						DSimpuestoCosto = DSimpuestoCosto / DStotallinest * round(DStotallinest/DScant*DScantsurt,2)
					where ESidsolicitud = #Arguments.ESidsolicitud#
					and Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				--->
				<cfquery name="update" datasource="#Arguments.Conexion#">
					update ESolicitudCompraCM
					set ESestado = 60,
						NAPcancel = #LvarNAP#,
						ESjustificacion = '#Arguments.ESjustificacion#'
					where ESidsolicitud = #Arguments.ESidsolicitud#
					and Ecodigo = #Arguments.Ecodigo#
					and CMSid=#arguments.solicitante#
				</cfquery>
				<cfquery name="update" datasource="#Arguments.Conexion#">
					delete from DRequisicion
					 where  (
					 			select count(1)
								  from DSolicitudCompraCM d
								 where ESidsolicitud = #Arguments.ESidsolicitud#
								   and d.DSlinea = DRequisicion.DSlinea
					 		) > 0
				</cfquery>
			</cfif><!--- LVarNAP GTE 0 --->
		</cftransaction>
		<cfreturn LvarNAP>
	</cffunction>

	<!--- Método para cancelar las lineas de la solicitud marcadas CM_CancelaSolicitud --->
	<cffunction name="CM_CancelaLineasSolicitud" access="public" returntype="numeric" output="true">
		<cfargument name="DSlinea" 				type="string" 	required="true">
		<cfargument name="DScantcancel" 		type="string" 	required="true">
		<cfargument name="ESidsolicitud" 		type="string" 	required="true">
		<cfargument name="ESjustificacion" 		type="string" 	required="true">
		<cfargument name="Solicitante" 			type="numeric" 	required="false" default="#session.compras.solicitante#">
		<cfargument name="Conexion" 			type="string" 	required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 				type="numeric" 	required="false" default="#session.ecodigo#">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="false" default="#session.Usucodigo#">
		<cfargument name="TransaccionActiva"	type="boolean" 	default="false">

		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto(Arguments.Conexion,false,false,true)>

		<cfif Arguments.TransaccionActiva>
			<cfreturn CM_CancelaLineasSolicitud_private (Arguments.DSlinea,Arguments.DScantcancel,Arguments.ESidsolicitud,Arguments.ESjustificacion,Arguments.Solicitante,Arguments.Conexion,Arguments.Ecodigo,Arguments.BMUsucodigo)>
		<cfelse>
			<cftransaction>
				<cfreturn CM_CancelaLineasSolicitud_private (Arguments.DSlinea,Arguments.DScantcancel,Arguments.ESidsolicitud,Arguments.ESjustificacion,Arguments.Solicitante,Arguments.Conexion,Arguments.Ecodigo,Arguments.BMUsucodigo)>
			</cftransaction>
		</cfif>
	</cffunction>

	<cffunction name="CM_CancelaLineasSolicitud_private" access="private" returntype="numeric" output="true">
		<cfargument name="DSlinea" 			type="string" 	required="true">
		<cfargument name="DScantcancel" 	type="string" 	required="true">
		<cfargument name="ESidsolicitud" 	type="string" 	required="true">
		<cfargument name="ESjustificacion" 	type="string" 	required="true">
		<cfargument name="Solicitante" 		type="numeric" 	required="false" default="#session.compras.solicitante#">
		<cfargument name="Conexion" 		type="string" 	required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="false" default="#session.ecodigo#">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="false" default="#session.Usucodigo#">

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select ESnumero, DSconsecutivo, DScant - DScantsurt as DScantNoSurt, CPDCid, DStipo
			  from DSolicitudCompraCM
			 where DSolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
			   and DSolicitudCompraCM.DSlinea = #Arguments.DSlinea#
			   and DSolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
		</cfquery>
		<cfif Arguments.DScantcancel LT 0>
			<cfthrow message="Solicitud #rsSQL.ESnumero# línea #rsSQL.DSconsecutivo#: no se permite cancelar una cantidad negativa">
		<cfelseif NumberFormat(Arguments.DScantcancel, "0.0000") GT NumberFormat(rsSQL.DScantNoSurt, "0.0000")>
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



		<!--- JMRV Inicio. 03/07/2014 --->

			<!--- Cuando la linea a eliminar es un art�culo con distribuci�n --->
			<cfif isdefined("rsSQL.DStipo") and  rsSQL.DStipo eq "A"
					and isdefined("rsSQL.CPDCid") and rsSQL.CPDCid neq 0 and rsSQL.CPDCid neq "">

				<!--- Trae los datos de la linea de detalle --->
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select  'CMSC' as ModuloOrigen,																													<!--- ModuloOrigen --->
							<cf_dbfunction name="to_char" args="b.ESnumero" > as NumeroDocumento,																						<!--- NumeroDocumento --->
							'#LvarReferencia#' as NumeroReferencia,																														<!--- NumeroReferencia --->
							b.ESfecha as FechaDocumento,																																<!--- FechaDocumento --->
							#rsPeriodoAuxiliar.Pvalor# as AnoDocumento,																												<!--- AnoDocumento --->
							#rsMesAuxiliar.Pvalor# as MesDocumento,																													<!--- MesDocumento --->
							a.DSconsecutivo as DSconsecutivo,																														<!--- NumeroLinea  --->
							<CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as CodigoOficina,																																	<!--- CodigoOficina --->
							a.DStotallinest * (#Arguments.DScantcancel# / a.DScant) as MontoOrigen,																																	<!--- MontoOrigen --->
							b.EStipocambio as TipoCambio,																													<!--- TipoCambio --->
							round(round(a.DStotallinest * (#Arguments.DScantcancel# / a.DScant),2)* b.EStipocambio, 2) as Monto,
							'RC' as TipoMovimiento,																																	<!--- TipoMovimiento --->
							b.NAP as NAPreferencia,																																	<!--- NAPreferencia --->
							a.PCGDid as PCGDid,
							-a.DScant as PCGDcantidad,
							a.Aid as Aid,
							a.DScant as DScant,
							a.CFid,
							a.Cid,
							a.DScantsurt as DScantsurt																											<!--- LINreferencia --->

					from DSolicitudCompraCM a
						inner join ESolicitudCompraCM b
							on b.ESidsolicitud = a.ESidsolicitud

					where a.DSlinea = #Arguments.DSlinea#
					  and a.ESidsolicitud = #Arguments.ESidsolicitud#
					  and a.Ecodigo = #Arguments.Ecodigo#
					  and coalesce(a.DSnoPresupuesto,0) = 0
				</cfquery>

				<!--- Genera la distribucion --->
				<cfinvoke  component="sif.Componentes.PRES_Distribucion"
				   method="GenerarDistribucion"
				   returnVariable="rsDistribucion"
				   CFid="#rs.CFid#"
				   Cid="#rs.Cid#"
				   Aid = "#rs.Aid#"
				   CPDCid="#rsSQL.CPDCid#"
				   Cantidad="#Arguments.DScantcancel#"
				   Aplica = "1"
				   Tipo = "#rsSQL.DStipo#"
				   Monto="#rs.Monto#">

				<!--- Obtiene la distribucion --->
				<!--- <cfinvoke component="sif.Componentes.PRES_Distribucion"
					method="ObtenerDistribucion"
					MontoOrigen="#rs.MontoOrigen#"
					Monto="#rs.Monto#"
					cantidad="#Arguments.DScantcancel#"
					LineaDeDescuento="0"
					CPDCid="#rsSQL.CPDCid#"
					Tipoitem="#rsSQL.DStipo#"
					Aid="#rs.Aid#"
					tipoCambio="#rs.TipoCambio#"
					returnVariable="rsDistribucion"> --->


				<!--- Para cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

					<!--- Obtiene los datos de NAP --->
					<cfquery name="DatosNAP" datasource="#session.DSN#">
						select Ocodigo, Mcodigo, CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto
						from CPNAPdetalle
						where CPNAPnum	= #rs.NAPreferencia#
						and CPNAPDlinea	= (#rs.DSconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#
					</cfquery>

					<!--- Inserta la linea de la distribucion --->
					<cfquery name="rsInserta" datasource="#session.DSN#">
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
							LINreferencia,
							PCGDid,
							PCGDcantidad)

					values 	(	'#rs.ModuloOrigen#',
							    '#rs.NumeroDocumento#',
								'#rs.NumeroReferencia#',
								'#rs.FechaDocumento#',
								#rs.AnoDocumento#,
								#rs.MesDocumento#,
								- ((#rs.DSconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#),
								(select CFcuenta from CFinanciera
	   							 where CFformato = '#rsDistribucion.cuenta#'),
								#DatosNAP.Ocodigo#,
								'#rs.CodigoOficina#',
								#DatosNAP.Mcodigo#,
								case
									when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) - #rsDistribucion.Monto# < 0
										 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									when #rs.DScantsurt# + #rsDistribucion.cantidad# = #rs.DScant# and #rs.DScantsurt# <> 0
										 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									else - #rsDistribucion.Monto#
								end,
								1,
								case
									when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) - #rsDistribucion.Monto# < 0
										 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									when #rs.DScantsurt# + #rsDistribucion.cantidad# = #rs.DScant# and #rs.DScantsurt# <> 0
										 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									else - #rsDistribucion.Monto#
								end,
								'#rs.TipoMovimiento#',
								#rs.NAPreferencia#, 			<!---NAPreferencia--->
								#DatosNAP.CPNAPDlinea#,    		<!---LINreferencia--->
								<cfif rs.PCGDid eq "">
									null,
								<cfelse>
									#rs.PCGDid#,
								</cfif>
								- #rsDistribucion.cantidad#
							)
					</cfquery>

				</cfloop> <!--- rsDistribucion --->



			<!--- Cuando la linea a eliminar no es un art�culo o es un art�culo sin distribuci�n --->
			<cfelse>

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
															LINreferencia,
															PCGDid, PCGDcantidad)

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
								 <!--- CANTIDAD_ORIGINAL =      a.DScantidadNAP --->
								 <!--- CANTIDAD_SURTIDA  =      a.DScantsurt --->
								 <!--- CANTIDAD_CANCELADA =     coalesce(a.DScantcancel,0) --->
								 <!--- Prop. Cant. no surtida:  (a.DScant + coalesce(a.DScantcancel,0) - coalesce(a.DScantcancel,0) - a.DScantsurt ) / a.DScantidadNAP --->
								 <!--- Prop. Cant. no surtida:  (a.DScant - a.DScantsurt ) / a.DScantidadNAP --->
								 <!---
										Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto)
										porque en algunos lugares se recalculaMontos:
											DStotallinest = round(DScant * DSmontoest,2)
										Máximo a DesReservar es el monto de la Reserva pero no se verifica porque
											DScantsurt no puede ser negativa
								--->
							napSC.CFcuenta,																															<!--- CFuenta --->
							napSC.Ocodigo,									  																						<!--- Oficina --->
							<CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> ,																																	<!--- CodigoOficina --->
							napSC.Mcodigo,																															<!--- Mcodigo --->
							-round(
								napSC.CPNAPDmontoOri * (#Arguments.DScantcancel#) / a.DScantidadNAP
							  ,2),																																	<!--- MontoOrigen --->

							napSC.CPNAPDtipoCambio,																													<!--- TipoCambio --->

							<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
							round(
								-round(
									napSC.CPNAPDmontoOri * (#Arguments.DScantcancel#) / a.DScantidadNAP
								  ,2)
							*napSC.CPNAPDtipoCambio, 2),

							'RC',																																	<!--- TipoMovimiento --->
							b.NAP,																																	<!--- NAPreferencia --->
							a.DSconsecutivo,
							a.PCGDid,
							-a.DScant																															<!--- LINreferencia --->

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

			</cfif><!--- Casos de solicitudes con distribucion --->

		<!--- JMRV Fin. 03/07/2014 --->

			<!--- Aprobacion o rechazo de presupuesto --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad from #request.intPresupuesto#
			</cfquery>
			<cfif rsSQL.cantidad gt 0>
				<cfset LvarNAP = LobjControl.ControlPresupuestario(	"CMSC",data.ESnumero,'#LvarReferencia#',data.ESfecha,rsPeriodoAuxiliar.Pvalor,
																	rsMesAuxiliar.Pvalor,Arguments.Conexion,Arguments.Ecodigo,data.NAP)>
			</cfif>
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
			<cfquery name="update" datasource="#Arguments.Conexion#">
				delete from DRequisicion
				 where  (
							select count(1)
							  from DSolicitudCompraCM
							 where DSolicitudCompraCM.Ecodigo 		= #Arguments.Ecodigo#
							   and DSolicitudCompraCM.DSlinea 		= #Arguments.DSlinea#
							   and DSolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
							   and DSolicitudCompraCM.DSlinea 		= DRequisicion.DSlinea
							   and DScant - DScantsurt <= 0
						) > 0
			</cfquery>
			<cfquery name="update" datasource="#Arguments.Conexion#">
				update DRequisicion
				   set DRcantidad =
				 		(
							select DScant - DScantsurt
							  from DSolicitudCompraCM
							 where DSolicitudCompraCM.Ecodigo 		= #Arguments.Ecodigo#
							   and DSolicitudCompraCM.DSlinea 		= #Arguments.DSlinea#
							   and DSolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
							   and DSolicitudCompraCM.DSlinea 		= DRequisicion.DSlinea
							   and (DScant - DScantsurt) > 0
						)
				 where  (
							select count(1)
							  from DSolicitudCompraCM
							 where DSolicitudCompraCM.Ecodigo 		= #Arguments.Ecodigo#
							   and DSolicitudCompraCM.DSlinea 		= #Arguments.DSlinea#
							   and DSolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
							   and DSolicitudCompraCM.DSlinea 		= DRequisicion.DSlinea
							   and (DScant - DScantsurt) > 0
						) > 0
			</cfquery>

			<!---
				Actualiza el estado de la solicitud a 50: Totalmente surtida
					Unicamente cuando ya no haya cantidad por surtir
					Pero se surtió alguna línea (existe cantidad surtida, otras pudieron ser canceladas)
			--->
			<cfquery name="updateEstado50" datasource="#Arguments.Conexion#">
				update ESolicitudCompraCM
				set ESestado = 50
				where ESolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
					and ESolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
					<!---
					<cfif IsDefined("session.compras.solicitante") and Len(Trim(session.compras.solicitante))>
					-- and ESolicitudCompraCM.CMSid = #arguments.solicitante#
					</cfif>
					--->
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

			<!---
				Actualiza el estado de la solicitud a 60: Totalmente Cancelada
					Unicamente cuando ya no haya cantidad por surtir
					Y no se surtió alguna línea (todas las líneas se cancelaron)
			--->
			<cfquery name="updateEstado60" datasource="#Arguments.Conexion#">
				update ESolicitudCompraCM
				set ESestado = 60
				where ESolicitudCompraCM.Ecodigo = #Arguments.Ecodigo#
					and ESolicitudCompraCM.ESidsolicitud = #Arguments.ESidsolicitud#
					<!---
					<cfif IsDefined("session.compras.solicitante") and Len(Trim(session.compras.solicitante))>
					-- and ESolicitudCompraCM.CMSid = #arguments.solicitante#
					</cfif>
					--->
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
							#LvarNAP#,
							#Arguments.BMUsucodigo#,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
			</cfquery>
		</cfif>		<!--- LVarNAP GTE 0 --->

		<cfreturn LvarNAP>
	</cffunction>

	<!--- Método que obtiene los datos del Encabezado de una solicitud compra para cancelar --->
	<cffunction name="CM_getSolicitudesACancelar" access="public" returntype="query" output="true">
		<cfargument name="Solicitante" 	type="numeric" 	required="false" default="#session.compras.solicitante#"><!--- 0 = Todos los solicitantes --->
		<cfargument name="Conexion" 	type="string" 	required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 		type="numeric" 	required="false" default="#session.ecodigo#">
        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery name="data" datasource="#Arguments.Conexion#">
			select ESolicitudCompraCM.ESidsolicitud, ESolicitudCompraCM.Ecodigo, ESolicitudCompraCM.ESnumero, ESolicitudCompraCM.CFid,
				ESolicitudCompraCM.CMSid, ESolicitudCompraCM.CMTScodigo, ESolicitudCompraCM.SNcodigo, ESolicitudCompraCM.Mcodigo,
				ESolicitudCompraCM.CMCid, ESolicitudCompraCM.CMElinea, ESolicitudCompraCM.EStipocambio, ESolicitudCompraCM.ESfecha,
				ESolicitudCompraCM.ESobservacion, ESolicitudCompraCM.NAP, ESolicitudCompraCM.NRP, ESolicitudCompraCM.NAPcancel,
				ESolicitudCompraCM.EStotalest, ESolicitudCompraCM.ESestado, ESolicitudCompraCM.Usucodigo, ESolicitudCompraCM.ESfalta,
				ESolicitudCompraCM.Usucodigomod, ESolicitudCompraCM.fechamod, ESolicitudCompraCM.ESreabastecimiento
				, CFuncional.CFdescripcion
				, Monedas.Mnombre
				, CMCompradores.CMCnombre
				, CMSolicitantes.CMSnombre
				, CMEspecializacionTSCF.ACcodigo, CMEspecializacionTSCF.ACid, CMEspecializacionTSCF.Aid, CMEspecializacionTSCF.Cid
				, CMEspecializacionTSCF.Ccodigo, CMEspecializacionTSCF.CCid
				, SNegocios.SNnombre
				, CMTiposSolicitud.CMTScodigo, CMTiposSolicitud.CMTSdescripcion
				, rtrim(CFuncional.CFcodigo) #_Cat# ' - ' #_Cat# CFuncional.CFdescripcion as CentroFunc
			from ESolicitudCompraCM
				left outer join CFuncional 						on CFuncional.CFid = ESolicitudCompraCM.CFid
				left outer join Monedas 							on Monedas.Mcodigo = ESolicitudCompraCM.Mcodigo
				left outer join CMCompradores 				on CMCompradores.CMCid = ESolicitudCompraCM.CMCid
				left outer join CMSolicitantes 				on CMSolicitantes.CMSid = ESolicitudCompraCM.CMSid
				left outer join CMEspecializacionTSCF on CMEspecializacionTSCF.CMElinea = ESolicitudCompraCM.CMElinea
				left outer join SNegocios 						on SNegocios.Ecodigo = ESolicitudCompraCM.Ecodigo
																							and SNegocios.SNcodigo = ESolicitudCompraCM.SNcodigo
				left outer join CMTiposSolicitud 			on CMTiposSolicitud.Ecodigo = ESolicitudCompraCM.Ecodigo
																							and CMTiposSolicitud.CMTScodigo = ESolicitudCompraCM.CMTScodigo
			where ESolicitudCompraCM.Ecodigo=#Arguments.Ecodigo#
			<cfif len(trim(arguments.solicitante)) GT 0 and arguments.solicitante GT 0>
				and ESolicitudCompraCM.CMSid=#arguments.solicitante#
			</cfif>
			and ESolicitudCompraCM.ESestado in (20,25,40)
			and ESolicitudCompraCM.ESidsolicitud not in (select DOrdenCM.ESidsolicitud from DOrdenCM inner join EOrdenCM on DOrdenCM.EOidorden = EOrdenCM.EOidorden where DOrdenCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud and EOrdenCM.EOestado < 60)
			and ESolicitudCompraCM.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud from CMLineasProceso inner join CMProcesoCompra on CMProcesoCompra.CMPid = CMLineasProceso.CMPid and CMProcesoCompra.CMPestado > 0)
			<cfif isdefined("Arguments.Filtro_ESobservacion") and len(trim(Arguments.Filtro_ESobservacion)) >
				and upper(ESobservacion) like  upper('%#Arguments.Filtro_ESobservacion#%')
			</cfif>
			<!---
			<cfif isdefined("Arguments.Filtro_CFdescripcion") and len(trim(Arguments.Filtro_CFdescripcion)) >
				and upper(CFdescripcion) like  upper('%#Arguments.Filtro_CFdescripcion#%')
			</cfif>
			--->
			<cfif isdefined("Arguments.Filtro_CFid") and len(trim(Arguments.Filtro_CFid)) >
				and ESolicitudCompraCM.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Arguments.Filtro_CFid)#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_ESfecha") and len(trim(Arguments.Filtro_ESfecha)) >
				and ESfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Filtro_ESfecha)#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_ESnumero") and len(trim(Arguments.Filtro_ESnumero)) and (isdefined("Arguments.Filtro_ESnumeroH") and len(trim(Arguments.Filtro_ESnumeroH)))>
				<cfif Arguments.Filtro_ESnumero GT Arguments.Filtro_ESnumeroH>
					and ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
				<cfelseif Arguments.Filtro_ESnumero EQ Arguments.Filtro_ESnumeroH>
					and ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
				<cfelse>
					and ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
				</cfif>
			<cfelseif isdefined("Arguments.Filtro_ESnumero") and len(trim(Arguments.Filtro_ESnumero))>
					and ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
			<cfelseif isdefined("Arguments.Filtro_ESnumeroH") and len(trim(Arguments.Filtro_ESnumeroH))>
					and ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_CMTScodigo") and len(trim(Arguments.Filtro_CMTScodigo)) >
				and ESolicitudCompraCM.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Filtro_CMTScodigo#">
			</cfif>

			order by ESnumero
		</cfquery>
		<cfreturn data>
	</cffunction>

	<!--- Método que obtiene los datos del Encabezado y Detalle de una solicitud compra para cancelar --->
	<cffunction name="CM_getDetalleSolicitudesACancelar" access="public" returntype="query" output="true">
		<cfargument name="Solicitante" type="numeric" required="false" default="#session.compras.solicitante#"><!--- 0 = Todos los solicitantes --->
		<cfargument name="Conexion" type="string" required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" type="numeric" required="false" default="#session.ecodigo#">
		<cfquery name="data" datasource="#Arguments.Conexion#">
			select 	ESolicitudCompraCM.ESidsolicitud, ESolicitudCompraCM.Ecodigo, ESolicitudCompraCM.ESnumero, ESolicitudCompraCM.CFid,
					ESolicitudCompraCM.CMSid, ESolicitudCompraCM.CMTScodigo, ESolicitudCompraCM.SNcodigo, ESolicitudCompraCM.Mcodigo,
					ESolicitudCompraCM.CMCid, ESolicitudCompraCM.CMElinea, ESolicitudCompraCM.EStipocambio, ESolicitudCompraCM.ESfecha,
					ESolicitudCompraCM.ESobservacion, ESolicitudCompraCM.NAP, ESolicitudCompraCM.NRP, ESolicitudCompraCM.NAPcancel,
					ESolicitudCompraCM.EStotalest, ESolicitudCompraCM.ESestado, ESolicitudCompraCM.Usucodigo, ESolicitudCompraCM.ESfalta,
					ESolicitudCompraCM.Usucodigomod, ESolicitudCompraCM.fechamod, ESolicitudCompraCM.ESreabastecimiento,
					<cf_dbfunction name="to_char" args="ESolicitudCompraCM.ESnumero"> #_Cat# ' - ' #_Cat# ESolicitudCompraCM.ESobservacion as Solicitud,
					DSolicitudCompraCM.DSdescripcion,DSolicitudCompraCM.DScant, DSolicitudCompraCM.DScantsurt, DSolicitudCompraCM.DStotallinest,
					DSolicitudCompraCM.DSlinea, DSolicitudCompraCM.DSobservacion, DSolicitudCompraCM.DSconsecutivo,	DSolicitudCompraCM.DSdescalterna,
					CFuncional.CFdescripcion,
					Monedas.Mnombre,
					CMCompradores.CMCnombre,
					CMSolicitantes.CMSnombre,
					CMEspecializacionTSCF.ACcodigo, CMEspecializacionTSCF.ACid, CMEspecializacionTSCF.Aid, CMEspecializacionTSCF.Cid,
					CMEspecializacionTSCF.Ccodigo, CMEspecializacionTSCF.CCid,
					SNegocios.SNnombre,
					CMTiposSolicitud.CMTScodigo, CMTiposSolicitud.CMTSdescripcion,
					rtrim(CFuncional.CFcodigo) #_Cat# ' - ' #_Cat# CFuncional.CFdescripcion as CentroFunc,
					case DStipo when 'A' then ltrim(rtrim(Articulos.Acodigo))
				   				when 'S' then ltrim(rtrim(Conceptos.Ccodigo))
				   				when 'F' then '' end as codigo,
					case DStipo when 'A' then Articulos.Adescripcion
				   				when 'S' then Conceptos.Cdescripcion
				   				when 'F' then AClasificacion.ACdescripcion end as Item,
					Unidades.Ucodigo,
					CFuncional.CFcodigo,
					rtrim(Almacen.Almcodigo) as Almcodigo,
					Impuestos.Icodigo #_Cat# '(' #_Cat#	<cf_dbfunction name="to_char" args="Impuestos.Iporcentaje">#_Cat#'%)' as Impuesto

			from ESolicitudCompraCM
				inner join DSolicitudCompraCM
					on DSolicitudCompraCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud
					and DSolicitudCompraCM.Ecodigo = ESolicitudCompraCM.Ecodigo
				left outer join CFuncional
					on CFuncional.CFid = ESolicitudCompraCM.CFid
				left outer join Monedas
					on Monedas.Mcodigo = ESolicitudCompraCM.Mcodigo
				left outer join CMCompradores
					on CMCompradores.CMCid = ESolicitudCompraCM.CMCid
				left outer join CMSolicitantes
					on CMSolicitantes.CMSid = ESolicitudCompraCM.CMSid
				left outer join CMEspecializacionTSCF
					on CMEspecializacionTSCF.CMElinea = ESolicitudCompraCM.CMElinea
				left outer join SNegocios
					on SNegocios.Ecodigo = ESolicitudCompraCM.Ecodigo
					and SNegocios.SNcodigo = ESolicitudCompraCM.SNcodigo
				left outer join CMTiposSolicitud
					on CMTiposSolicitud.Ecodigo = ESolicitudCompraCM.Ecodigo
					and CMTiposSolicitud.CMTScodigo = ESolicitudCompraCM.CMTScodigo
				left outer join Conceptos
					on DSolicitudCompraCM.Cid = Conceptos.Cid
				left outer join AClasificacion
					on DSolicitudCompraCM.ACcodigo = AClasificacion.ACcodigo
					and DSolicitudCompraCM.ACid = AClasificacion.ACid
					and DSolicitudCompraCM.Ecodigo = AClasificacion.Ecodigo
				left outer join Articulos
					on DSolicitudCompraCM.Aid = Articulos.Aid
				inner join Unidades
					on DSolicitudCompraCM.Ucodigo  = Unidades.Ucodigo
					and DSolicitudCompraCM.Ecodigo = Unidades.Ecodigo
				left outer join Almacen
					on DSolicitudCompraCM.Alm_Aid = Almacen.Aid
				inner join Impuestos
					on Impuestos.Icodigo = DSolicitudCompraCM.Icodigo
					and Impuestos.Ecodigo = DSolicitudCompraCM.Ecodigo
				left outer join CMLineasProceso
					on DSolicitudCompraCM.DSlinea = CMLineasProceso.DSlinea
					and ESolicitudCompraCM.ESidsolicitud = CMLineasProceso.ESidsolicitud
				left outer join CMProcesoCompra
					on CMLineasProceso.CMPid = CMProcesoCompra.CMPid
					and CMPestado < 10

			where ESolicitudCompraCM.Ecodigo=#Arguments.Ecodigo#
			<cfif len(trim(arguments.solicitante)) GT 0 and arguments.solicitante GT 0>
				and ESolicitudCompraCM.CMSid=#arguments.solicitante#
			</cfif>
			and ESolicitudCompraCM.ESestado in (20,25,40)
			and ESolicitudCompraCM.ESidsolicitud not in (select DOrdenCM.ESidsolicitud from DOrdenCM inner join EOrdenCM on DOrdenCM.EOidorden = EOrdenCM.EOidorden where DOrdenCM.ESidsolicitud = ESolicitudCompraCM.ESidsolicitud and EOrdenCM.EOestado < 60)
			and ESolicitudCompraCM.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud from CMLineasProceso inner join CMProcesoCompra on CMProcesoCompra.CMPid = CMLineasProceso.CMPid and CMProcesoCompra.CMPestado > 0)
			<cfif isdefined("Arguments.Filtro_ESobservacion") and len(trim(Arguments.Filtro_ESobservacion)) >
				and upper(ESobservacion) like  upper('%#Arguments.Filtro_ESobservacion#%')
			</cfif>
			<!---
			<cfif isdefined("Arguments.Filtro_CFdescripcion") and len(trim(Arguments.Filtro_CFdescripcion)) >
				and upper(CFdescripcion) like  upper('%#Arguments.Filtro_CFdescripcion#%')
			</cfif>
			--->
			<cfif isdefined("Arguments.Filtro_CFid") and len(trim(Arguments.Filtro_CFid)) >
				and ESolicitudCompraCM.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Arguments.Filtro_CFid)#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_ESfecha") and len(trim(Arguments.Filtro_ESfecha)) >
				and ESfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Filtro_ESfecha)#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_ESnumero") and len(trim(Arguments.Filtro_ESnumero)) and (isdefined("Arguments.Filtro_ESnumeroH") and len(trim(Arguments.Filtro_ESnumeroH)))>
				<cfif Arguments.Filtro_ESnumero GT Arguments.Filtro_ESnumeroH>
					and ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
				<cfelseif Arguments.Filtro_ESnumero EQ Arguments.Filtro_ESnumeroH>
					and ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
				<cfelse>
					and ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
				</cfif>
			<cfelseif isdefined("Arguments.Filtro_ESnumero") and len(trim(Arguments.Filtro_ESnumero))>
					and ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
			<cfelseif isdefined("Arguments.Filtro_ESnumeroH") and len(trim(Arguments.Filtro_ESnumeroH))>
					and ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_CMTScodigo") and len(trim(Arguments.Filtro_CMTScodigo)) >
				and ESolicitudCompraCM.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Filtro_CMTScodigo#">
			</cfif>

			order by ESnumero
		</cfquery>
		<cfreturn data>
	</cffunction>

	<!--- Método que obtiene los datos del Encabezado y Detalle de una solicitud compra para cancelar --->
	<cffunction name="CM_getCancelacionSolicitudes" access="public" returntype="query" output="true">
		<cfargument name="Solicitante" type="numeric" required="false" default="#session.compras.solicitante#"><!--- 0 = Todos los solicitantes --->
		<cfargument name="Conexion" type="string" required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" type="numeric" required="false" default="#session.ecodigo#">

        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery name="data" datasource="#Arguments.Conexion#">
			select  ECM.ESidsolicitud,
					ECM.Ecodigo,
					ECM.ESnumero,
					ECM.CFid,
					ECM.CMSid,
					ECM.CMTScodigo,
					ECM.SNcodigo,
					ECM.Mcodigo,
					ECM.CMCid,
					ECM.CMElinea,
					ECM.EStipocambio,
					ECM.ESfecha,
					ECM.ESobservacion,
					ECM.NAP,
					ECM.NRP,
					ECM.NAPcancel,
					ECM.EStotalest,
					ECM.ESestado,
					ECM.Usucodigo,
					ECM.ESfalta,
					ECM.Usucodigomod,
					ECM.fechamod,
					ECM.ESreabastecimiento,
					<cf_dbfunction name="to_char" args="ECM.ESnumero"> #_Cat# ' - ' #_Cat# ECM.ESobservacion as Solicitud,

					DSolicitudCompraCM.DSlinea,
					DSolicitudCompraCM.DSdescripcion,
					DSolicitudCompraCM.DScant,
					DSolicitudCompraCM.DScantsurt,
					DSolicitudCompraCM.DStotallinest,
					DSolicitudCompraCM.DSobservacion,
					DSolicitudCompraCM.DSconsecutivo,
					DSolicitudCompraCM.DSdescalterna,
					(DSolicitudCompraCM.DScant - DSolicitudCompraCM.DScantsurt) SaldoLinea,

					CFuncional.CFdescripcion,
					Monedas.Mnombre,
					CMCompradores.CMCnombre,
					CMSolicitantes.CMSnombre,
					CMEspecializacionTSCF.ACcodigo,
					CMEspecializacionTSCF.ACid,
					CMEspecializacionTSCF.Aid,
					CMEspecializacionTSCF.Cid,
					CMEspecializacionTSCF.Ccodigo,
					CMEspecializacionTSCF.CCid,
					SNegocios.SNnombre,
					CMTiposSolicitud.CMTScodigo,
					CMTiposSolicitud.CMTSdescripcion,
					rtrim(CFuncional.CFcodigo) #_Cat# ' - ' #_Cat# CFuncional.CFdescripcion as CentroFunc,
					case DStipo when 'A' then ltrim(rtrim(Articulos.Acodigo))
								when 'S' then ltrim(rtrim(Conceptos.Ccodigo))
								when 'F' then '' end as codigo,
					case DStipo when 'A' then Articulos.Adescripcion
								when 'S' then Conceptos.Cdescripcion
								when 'F' then AClasificacion.ACdescripcion end as Item,
					Unidades.Ucodigo,
					CFuncional.CFcodigo,
					rtrim(Almacen.Almcodigo) as Almcodigo,
					Impuestos.Icodigo #_Cat# '(' #_Cat#	<cf_dbfunction name="to_char" args="Impuestos.Iporcentaje">#_Cat#'%)' as Impuesto

			from ESolicitudCompraCM ECM
				inner join DSolicitudCompraCM
					on DSolicitudCompraCM.ESidsolicitud = ECM.ESidsolicitud
					and DSolicitudCompraCM.Ecodigo = ECM.Ecodigo
				left outer join CFuncional
					on CFuncional.CFid = ECM.CFid
				left outer join Monedas
					on Monedas.Mcodigo = ECM.Mcodigo
				left outer join CMCompradores
					on CMCompradores.CMCid = ECM.CMCid
				left outer join CMSolicitantes
					on CMSolicitantes.CMSid = ECM.CMSid
				left outer join CMEspecializacionTSCF
					on CMEspecializacionTSCF.CMElinea = ECM.CMElinea
				left outer join SNegocios
					on SNegocios.Ecodigo = ECM.Ecodigo
					and SNegocios.SNcodigo = ECM.SNcodigo
				left outer join CMTiposSolicitud
					on CMTiposSolicitud.Ecodigo = ECM.Ecodigo
					and CMTiposSolicitud.CMTScodigo = ECM.CMTScodigo
				left outer join Conceptos
					on DSolicitudCompraCM.Cid = Conceptos.Cid
				left outer join AClasificacion
					on DSolicitudCompraCM.ACcodigo = AClasificacion.ACcodigo
					and DSolicitudCompraCM.ACid = AClasificacion.ACid
					and DSolicitudCompraCM.Ecodigo = AClasificacion.Ecodigo
				left outer join Articulos
					on DSolicitudCompraCM.Aid = Articulos.Aid
				inner join Unidades
					on DSolicitudCompraCM.Ucodigo  = Unidades.Ucodigo
					and DSolicitudCompraCM.Ecodigo = Unidades.Ecodigo
				left outer join Almacen
					on DSolicitudCompraCM.Alm_Aid = Almacen.Aid
				inner join Impuestos
					on Impuestos.Icodigo = DSolicitudCompraCM.Icodigo
					and Impuestos.Ecodigo = DSolicitudCompraCM.Ecodigo

			where ECM.Ecodigo = #Arguments.Ecodigo#
				and ECM.ESestado in (20,25,40)
				and ECM.ESidsolicitud not in (select DOrdenCM.ESidsolicitud
											from DOrdenCM
												inner join EOrdenCM
												on DOrdenCM.EOidorden = EOrdenCM.EOidorden
											where DOrdenCM.ESidsolicitud = ECM.ESidsolicitud
												and EOrdenCM.EOestado < 10)
				and ECM.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud
											from CMLineasProceso
												inner join CMProcesoCompra
												on CMProcesoCompra.CMPid = CMLineasProceso.CMPid
												and CMProcesoCompra.CMPestado < 10)
				and (DSolicitudCompraCM.DScant - DSolicitudCompraCM.DScantsurt) > 0
				and ECM.ESnumero =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">

			order by ECM.ESnumero, DSlinea
		</cfquery>
		<cfreturn data>
	</cffunction>

	<!---►►Método que obtiene los datos de las solicitudes de compra rechazadas Encabezado◄◄--->
	<cffunction name="CM_getSolicitudesRechazadas" access="public" returntype="query" output="true" hint="Método que obtiene los datos de las solicitudes de compra rechazadas Encabezado">
		<cfargument name="Solicitante" 	type="numeric"  required="false" hint="Id del Solicitante">
		<cfargument name="Conexion" 	type="string" 	required="false" hint="Nombre del DataSource">
		<cfargument name="Ecodigo" 		type="numeric"  required="false" hint="Codigo de la empresa">

        <cfif NOT ISDEFINED('Arguments.Solicitante') AND ISDEFINED('session.compras.solicitante') AND LEN(TRIM(session.compras.solicitante))>
        	<cfset Arguments.Solicitante = session.compras.solicitante>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>

        <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
        <cfparam name="Arguments.solicitante" default="-1">

		<cfquery name="data" datasource="#Arguments.Conexion#">
			select sc.ESidsolicitud, sc.Ecodigo,    sc.ESnumero, 	 sc.CFid,
				   sc.CMSid, 		 sc.CMTScodigo, sc.SNcodigo, 	 sc.Mcodigo,
				   sc.CMCid, 		 sc.CMElinea, 	sc.EStipocambio, sc.ESfecha,
				   sc.ESobservacion, sc.NAP, 		sc.NRP, 		 sc.NAPcancel,
				   sc.EStotalest, 	 sc.ESestado,   sc.Usucodigo,    sc.ESfalta,
				   sc.Usucodigomod,  sc.fechamod,   sc.ESreabastecimiento,
                   cf.CFdescripcion
				, Monedas.Mnombre
				, CMCompradores.CMCnombre
				, CMSolicitantes.CMSnombre
				, CMEspecializacionTSCF.ACcodigo, CMEspecializacionTSCF.ACid, CMEspecializacionTSCF.Aid, CMEspecializacionTSCF.Cid
				, CMEspecializacionTSCF.Ccodigo, CMEspecializacionTSCF.CCid
				, SNegocios.SNnombre
				, CMTiposSolicitud.CMTScodigo, CMTiposSolicitud.CMTSdescripcion, CMTiposSolicitud.CMTScompradirecta, - sc.ESidsolicitud as inactivecol
				, '<a href=''##'' onclick=''javascript:document.lista.nosubmit=true;location.href=&quot;/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?NRP='#_Cat#<cf_dbfunction name='to_char' args='sc.NRP'>#_Cat#'&quot;''><img src=''/cfmx/sif/imagenes/findsmall.gif'' border=''0''></a>' as findimg
				, 'solicitudesRechazadas.cfm' as action
				, rtrim(cf.CFcodigo) #_Cat# ' - ' #_Cat# cf.CFdescripcion as CentroFunc
			from ESolicitudCompraCM sc
				left outer join CFuncional cf
                	on cf.CFid = sc.CFid
				left outer join Monedas
                	on Monedas.Mcodigo = sc.Mcodigo
				left outer join CMCompradores
                	on CMCompradores.CMCid = sc.CMCid
				left outer join CMSolicitantes
                	on CMSolicitantes.CMSid = sc.CMSid
				left outer join CMEspecializacionTSCF
                	on CMEspecializacionTSCF.CMElinea = sc.CMElinea
				left outer join SNegocios
                	on SNegocios.Ecodigo = sc.Ecodigo and SNegocios.SNcodigo = sc.SNcodigo
				left outer join CMTiposSolicitud
                	on CMTiposSolicitud.Ecodigo = sc.Ecodigo and CMTiposSolicitud.CMTScodigo = sc.CMTScodigo
			where sc.Ecodigo  = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              <!---►No es Solicitante, pero es el aprobador del Ultimo paso del tramite(El usuario que le Dio el NRP)◄--->
              and (CASE WHEN (select Usucodigo
                             from WfxActivity xa
                               inner join WfxActivityParticipant xap
                                 on xap.ActivityInstanceId = xa.ActivityInstanceId
                               where xa.ProcessInstanceId = sc.ProcessInstanceid) IS NOT NULL
                          THEN (CASE WHEN (select Usucodigo
                                             from WfxActivity xa
                                               inner join WfxActivityParticipant xap
                                                 on xap.ActivityInstanceId = xa.ActivityInstanceId
                                               where xa.ProcessInstanceId = sc.ProcessInstanceid) = #session.Usucodigo# THEN 1 ELSE 0 END)
              <!---►Es el Usuario que diseño la Solicitud de Compra◄--->
                      WHEN sc.CMSid	= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.solicitante#"> THEN 1
              <!---►Ninguno de los anteriores, siempre se presentara la lista vacia◄--->
                      ELSE 0 END) = 1
		 	  and sc.ESestado = -10
		 	  and sc.ESidsolicitud not in (select DOrdenCM.ESidsolicitud from DOrdenCM inner join EOrdenCM on DOrdenCM.EOidorden = EOrdenCM.EOidorden where DOrdenCM.ESidsolicitud = sc.ESidsolicitud and EOrdenCM.EOestado < 60)
			  and sc.ESidsolicitud not in (select CMLineasProceso.ESidsolicitud from CMLineasProceso inner join CMProcesoCompra on CMProcesoCompra.CMPid = CMLineasProceso.CMPid and CMProcesoCompra.CMPestado > 0)
			<cfif isdefined("Arguments.Filtro_ESobservacion") and len(trim(Arguments.Filtro_ESobservacion)) >
				and upper(ESobservacion) like  upper('%#Arguments.Filtro_ESobservacion#%')
			</cfif>
			<cfif isdefined("Arguments.Filtro_CFid") and len(trim(Arguments.Filtro_CFid)) >
				and sc.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Arguments.Filtro_CFid)#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_ESfecha") and len(trim(Arguments.Filtro_ESfecha)) >
				and ESfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Filtro_ESfecha)#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_ESnumero") and len(trim(Arguments.Filtro_ESnumero)) and (isdefined("Arguments.Filtro_ESnumeroH") and len(trim(Arguments.Filtro_ESnumeroH))) >
				<cfif Arguments.Filtro_ESnumero  GT Arguments.Filtro_ESnumeroH>
					and ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
				<cfelseif Arguments.Filtro_ESnumero EQ Arguments.Filtro_ESnumeroH>
					and ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
				<cfelse>
					and ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
				</cfif>
			<cfelseif isdefined("Arguments.Filtro_ESnumero") and len(trim(Arguments.Filtro_ESnumero))>
					and ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumero#">
			<cfelseif isdefined("Arguments.Filtro_ESnumeroH") and len(trim(Arguments.Filtro_ESnumeroH))>
					and ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_ESnumeroH#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_CMTScodigo") and len(trim(Arguments.Filtro_CMTScodigo)) >
				and sc.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Filtro_CMTScodigo#">
			</cfif>
			order by ESnumero
		</cfquery>
		<cfreturn data>
	</cffunction>

</cfcomponent>