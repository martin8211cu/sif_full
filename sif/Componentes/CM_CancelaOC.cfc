<cfcomponent>
	<cffunction name="CM_CancelaOC" access="public" returntype="numeric" output="true">
    	<cfargument name="EOidorden" 			type="string" required="true">
        <cfargument name="EOjustificacion" 		type="string" required="true">
        <cfargument name="TransaccionActiva"	type="boolean" default="false">
        <cfargument name="Ecodigo"				type="numeric" default="#session.Ecodigo#">

        <cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
        <cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>

        <cfif Arguments.TransaccionActiva>
        	<cfreturn CM_CancelaOC_private (Arguments.EOidorden, Arguments.EOjustificacion, Arguments.Ecodigo)>
        <cfelse>
        	<cftransaction>
            <cfreturn CM_CancelaOC_private (Arguments.EOidorden, Arguments.EOjustificacion, Arguments.Ecodigo)>
            </cftransaction>
            </cfif>
     </cffunction>

	 <cffunction name="CM_CancelaOC_private" access="private" returntype="numeric" output="true">
		<cfargument name="EOidorden" 		type="string" required="true">
		<cfargument name="EOjustificacion" 	type="string" required="true">
       	<cfargument name="Ecodigo"			type="numeric" default="#session.Ecodigo#">
		<!----<cfargument name="Comprador" 		type="numeric" required="false" default="#session.compras.comprador#">---->

		<cfquery name="data" datasource="#session.dsn#">
			select EOidorden, EOnumero, EOfecha, CMTOcodigo, NAP, EOestado
			from EOrdenCM
			where EOidorden=#Arguments.EOidorden#
		</cfquery>

		<cfif data.EOestado NEQ 10>
			<cf_errorCode	code = "51100"
							msg  = "La Orden de Compra @errorDat_1@ con fecha @errorDat_2@ no se puede cancelar porque no está en estado aplicado."
							errorDat_1="#data.EOnumero#"
							errorDat_2="#dateformat(data.EOfecha, 'DD/MM/YYYY')#"
			>
		</cfif>
 		<!--- 22/10/2014 ERBG Cambio para evitar la cancelación de orden relacionada a un documento de CXP Inicia---> 
        <cfquery name="rsdata" datasource="#session.dsn#">
            select top 1  do.DOlinea,dc.Ecodigo,do.EOidorden,do.EOnumero,do.DOdescripcion,dc.IDdocumento,EOfecha
            from DOrdenCM do
            inner join EOrdenCM eo on eo.EOidorden = do.EOidorden and do.Ecodigo=eo.Ecodigo
            inner join DDocumentosCxP dc on do.DOlinea=dc.DOlinea and do.Ecodigo=dc.Ecodigo            
            where do.EOidorden = #Arguments.EOidorden#
                and do.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsdata.recordcount gt 0>
			<cf_errorCode	code = "51804"
							msg  = "La Orden de Compra @errorDat_1@ con fecha @errorDat_2@ no se puede cancelar porque está ligada a un documento."
							errorDat_1="#rsdata.EOnumero#"
							errorDat_2="#dateformat(rsdata.EOfecha, 'DD/MM/YYYY')#">
		</cfif>
        <cfquery name="rsdata" datasource="#session.dsn#">
            select top 1  do.DOlinea,dc.Ecodigo,do.EOidorden,do.EOnumero,do.DOdescripcion,dc.IDdocumento,EOfecha
            from DOrdenCM do
            inner join EOrdenCM eo on eo.EOidorden = do.EOidorden and do.Ecodigo=eo.Ecodigo
            inner join HDDocumentosCP dc on do.DOlinea=dc.DOlinea and do.Ecodigo=dc.Ecodigo            
            where do.EOidorden = #Arguments.EOidorden#
                and do.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsdata.recordcount gt 0>
			<cf_errorCode	code = "51804"
							msg  = "La Orden de Compra @errorDat_1@ con fecha @errorDat_2@ no se puede cancelar porque está ligada a un documento aplicado."
							errorDat_1="#rsdata.EOnumero#"
							errorDat_2="#dateformat(rsdata.EOfecha, 'DD/MM/YYYY')#">
		</cfif>
		<!--- 22/10/2014 FIN--->
		<cfquery datasource="#session.dsn#">
			update EOrdenCM
			set EOjustificacion = '#Arguments.EOjustificacion#'
			where EOidorden=#Arguments.EOidorden#
		</cfquery>
		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			and Pcodigo   = 60
		</cfquery>

		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.Ecodigo#
			and Pcodigo= 50
		</cfquery>

	  	<cfquery datasource="#session.dsn#" name="MonedaLocal">
			select Mcodigo
			from Empresas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<cfset GvarMcodigoLocal = MonedaLocal.Mcodigo>

		<cfquery name="rsTotalLineasSurtidas" datasource="#session.DSN#">
			select count(1) as Total
			from DOrdenCM
			where Ecodigo = #Arguments.Ecodigo#
				and EOidorden = #Arguments.EOidorden#
				and (DOcantsurtida > 0 or DOmontoSurtido > 0)
		</cfquery>
		<cfif rsTotalLineasSurtidas.Total EQ 0>
			<cfset LvarCancelacion = "TOTAL">
		<cfelse>
			<cfset LvarCancelacion = "PARCIAL DE TODO LO NO SURTIDO">
		</cfif>

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
				where a.Ecodigo=#Arguments.Ecodigo#
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

					where cmoc.Ecodigo = #Arguments.Ecodigo#
						and cmoc.DOlinea = #rsOrden.DOlinea#
						and cmoc.EOidorden = #rsOrden.EOidorden#
						and cmoc.SNcodigo = #rsOrden.SNcodigo#
				</cfquery>
				<cfif rsContratos.RecordCount NEQ 0><!---Si la línea esta en un contrato actualiza la cantidad surtida del contrato---->
					<cfquery datasource="#session.DSN#">
						update DContratosCM
						set DCcantsurtida = <cfqueryparam cfsqltype="cf_sql_float" value="#rsContratos.DCcantsurtida#"> - <cfqueryparam cfsqltype="cf_sql_float" value="#rsOrden.DOcantidad#">
						where Ecodigo = #Arguments.Ecodigo#
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
								#Arguments.Ecodigo#,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsContratos.SNcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratos.ECid#">,
								- (<cfqueryparam cfsqltype="cf_sql_float" value="#rsOrden.DOcantidad#">),
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								)
					</cfquery>
				</cfif>
			</cfloop>
	<!---SML 04/07/2014. Inicio Modificacion para al cancelar la Orden de Compra se elimine el compromiso cuando no se tiene distribuicion de monto--->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
                select 'CMOC',
						<cf_dbfunction name="to_char" args="b.EOnumero" >,
	   					'CANCELACION',
	   					c.EOfecha,
	  					#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
	   					f.CPNAPDlinea,
	   					f.CFcuenta,
	   					d.Ocodigo,
	   					e.Oficodigo,
	   					c.Mcodigo,
	   					-f.CPNAPDmontoOri as MtoOrigen,
                       	c.EOtc,
	   					-f.CPNAPDmonto as MtoLocal,
	   					'CC',
	   					c.NAP,
	   					f.CPNAPDlinea,
	   					b.PCGDid,
	   					-b.DOcantidad
				from DOrdenCM b
					INNER JOIN EOrdenCM c on b.EOidorden = c.EOidorden
					inner JOIN CFuncional d on b.CFid = d.CFid
						and b.Ecodigo = d.Ecodigo
					inner join Oficinas e on e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo
					inner join CPNAPdetalle f on f.CPNAPnum = c.NAP
                    and b.DOconsecutivo = f.CPNAPDlinea
			    where b.EOidorden = #Arguments.EOidorden#
	  				  and b.Ecodigo = #Arguments.Ecodigo#
                      and f.CPNAPDtipoMov = 'CC'
                      and (b.CPDCid is null or b.CPDCid = 0)

			</cfquery>
    <!---SML 04/07/2014. Final Modificacion para al cancelar la Orden de Compra se elimine el compromiso cuando no se tiene distribuicion de monto--->

    <!---SML 04/07/2014. Modificacion para al cancelar la Orden de Compra se elimine el compromiso cuando se hace una distribuicion de monto--->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
                 select 'CMOC',
						b.EOnumero,
	   					'CANCELACION',
	   					c.EOfecha,
	  					#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
	   					a.CPNAPDlinea,
	   					a.CFcuenta,
	   					d.Ocodigo,
	   					e.Oficodigo,
	   					c.Mcodigo,
	   					-f.CPNAPDmontoOri as MtoOrigen,
                         f.CPNAPDtipoCambio,
	   					-f.CPNAPDmonto as MtoLocal,
	   					'CC',
	   					c.NAP,
	   					a.CPNAPDlinea,
	   					b.PCGDid,
	   					-b.DOcantidad
				from DistribucionOC a
					inner JOIN DOrdenCM b on a.CPDCid = b.CPDCid
						and a.EOidorden = b.EOidorden and a.Ecodigo = b.Ecodigo
					INNER JOIN EOrdenCM c on a.Ecodigo = b.Ecodigo
						and b.EOidorden = c.EOidorden
					inner JOIN CFuncional d on a.CFid = d.CFid
						and a.Ecodigo = d.Ecodigo
					inner join Oficinas e on e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo
					inner join CPNAPdetalle f on f.CPNAPnum = c.NAP
						and f.CPNAPDlinea = a.CPNAPDlinea
			    where a.EOidorden = #Arguments.EOidorden#
	  				  and a.Ecodigo = #Arguments.Ecodigo#
                      and b.CPDCid is not null
					  and b.CPDCid <> 0
            </cfquery>
            
            <!---SML 24/09/2014. Devolución de la DesReserva Solicitud Compra cuando se hace una distribuicion de monto --->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
                 select 'CMOC',
						b.EOnumero,
	   					'CANCELACION',
	   					c.EOfecha,
	  					#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
	   					-a.CPNAPDlinea,
	   					a.CFcuenta,
	   					d.Ocodigo,
	   					e.Oficodigo,
	   					c.Mcodigo,
	   					f.CPNAPDmontoOri as MtoOrigen,
                        f.CPNAPDtipoCambio,
	   					f.CPNAPDmonto as MtoLocal,
	   					'RC',
	   					c.NAP,
	   					-a.CPNAPDlinea,
	   					b.PCGDid,
	   					b.DOcantidad
				from DistribucionOC a
					inner JOIN DOrdenCM b on a.CPDCid = b.CPDCid
						and a.EOidorden = b.EOidorden and a.Ecodigo = b.Ecodigo
					INNER JOIN EOrdenCM c on a.Ecodigo = b.Ecodigo
						and b.EOidorden = c.EOidorden
					inner JOIN CFuncional d on a.CFid = d.CFid
						and a.Ecodigo = d.Ecodigo
					inner join Oficinas e on e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo
					inner join CPNAPdetalle f on f.CPNAPnum = c.NAP
						and f.CPNAPDlinea = a.CPNAPDlinea
			    where a.EOidorden = #Arguments.EOidorden#
	  				  and a.Ecodigo = #Arguments.Ecodigo#
                      and b.CPDCid is not null
					  and b.CPDCid <> 0
            </cfquery>
        <!---SML 24/09/2014. Devolución de la DesReserva Solicitud Compra cuando se hace una distribuicion de monto --->

			<!--- Devolución de la DesReserva Solicitud Compra --->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
				select  'CMOC',																						<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.EOnumero" >,											<!--- NumeroDocumento --->
						'CANCELACION',																				<!--- NumeroReferencia --->
						b.EOfecha,																					<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																	<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																		<!--- MesDocumento --->
						-(a.DOconsecutivo),		<!---Para quitar la reversa quite  el  signo - --->					<!--- NumeroLinea  --->
						<!--- Proporción no surtida OC con respecto a la cantidad SC original, maximo cantidad reservada original: --->
							 <!--- Prop. Cant. no surtida: CANTIDAD_NO_SURTIDA / CANTIDAD_ORIGINAL --->
							 <!--- CANTIDAD_NO_SURTIDA  =  (a.DOcantidad-a.DOcantsurtida) --->
							 <!--- CANTIDAD_ORIGINAL =      g.DScantidadNAP --->
							 <!--- Prop. Cant. no surtida: (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP --->
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
							when DOcontrolCantidad = 0 then
								<!--- Cuando no se controla cantidad en PCG
										Si la cancelación es Total   se reReserva el 100%
										Si la cancelación es Parcial no se reReserva nada (La SC no se reactiva y el presupuesto se libera)
								 --->
								<cfif LvarCancelacion EQ "TOTAL">
									napSC.CPNAPDmontoOri
								<cfelse>
									0
								</cfif>
							<!--- Se pregunta en moneda local (CPNAPDmonto) porque CPNAPDutilizado sólo está en moneda local --->
							when napSC.CPNAPDutilizado < napSC.CPNAPDmonto * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP then
								round(napSC.CPNAPDutilizado / napSC.CPNAPDtipoCambio,2)
							else
								round( napSC.CPNAPDmontoOri * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP ,2)
						end,																						<!--- MontoOrigen --->
						napSC.CPNAPDtipoCambio,																				<!--- TipoCambio --->

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						round(
							case
								when DOcontrolCantidad = 0 then
									<cfif LvarCancelacion EQ "TOTAL">
										napSC.CPNAPDmontoOri
									<cfelse>
										0
									</cfif>
								when napSC.CPNAPDutilizado < napSC.CPNAPDmonto * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP then
									round(napSC.CPNAPDutilizado / napSC.CPNAPDtipoCambio,2)
								else
									round( napSC.CPNAPDmontoOri * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP ,2)
							end
						*napSC.CPNAPDtipoCambio, 2),

						<!---'CC',--->'RC',																						<!--- TipoMovimiento --->
						b.NAP, 																						<!--- NAPreferencia --->
						-(a.DOconsecutivo),		<!---Para quitar la reversa quite  el  signo - --->					<!--- LINreferencia --->
						a.PCGDid,
						a.DOcantidad
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
				 where a.Ecodigo=#Arguments.Ecodigo#
				   and b.EOidorden=#Arguments.EOidorden#
			</cfquery>

			<!--- Devolución de la DesReserva de la PROVISION de Suficiencia --->
			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#(
														ModuloOrigen,
														NumeroDocumento,
														NumeroReferencia,
														FechaDocumento,
														AnoDocumento,
														MesDocumento,
														NumeroLinea,
														CPcuenta,
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
				select  'CMSC',																						<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.EOnumero" >,											<!--- NumeroDocumento --->
						'CANCELACION',																				<!--- NumeroReferencia --->
						b.EOfecha,																					<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																	<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																		<!--- MesDocumento --->
						-(a.DOconsecutivo),		<!---Para quitar la reversa quite  el  signo - --->					<!--- NumeroLinea  --->
						<!--- Proporción no surtida OC con respecto a la cantidad SC original, maximo cantidad reservada original: --->
							 <!--- Prop. Cant. no surtida: CANTIDAD_NO_SURTIDA / CANTIDAD_ORIGINAL --->
							 <!--- CANTIDAD_NO_SURTIDA  =  (a.DOcantidad-a.DOcantsurtida) --->
							 <!--- CANTIDAD_ORIGINAL =      g.DScantidadNAP --->
							 <!--- Prop. Cant. no surtida: (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP --->
							 <!---
									Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto)
									porque en algunos lugares se recalculaMontos:
										DStotallinest = round(DScant * DSmontoest,2)
									El máximo a Devolver es el monto Sí Utilizado de la Reserva
						--->
						<!--- La suficiencia se hace a nivel de Cuenta de Presupuesto --->
						napSC.CPcuenta,																					<!--- CFuenta --->
						napSC.Ocodigo,																					<!--- Oficina --->
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,																				<!--- CodigoOficina --->

						<!--- Se devuelve el mismo monto de la Orden --->
						b.Mcodigo,
						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						-	case
								when DOcontrolCantidad = 0 then
									<!--- Monto no surtido OC más impuestos correspondientes:	(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido) * (1 + TasaImpuesto) --->
									- round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
								else
									<!--- Proporción no surtida OC con respecto a DOcantidad:  		(a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
									-round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
							end as MtoOrigen,															<!--- Monto --->

						b.EOtc,																			<!--- TipoCambio --->

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						-round(
							case
								when DOcontrolCantidad = 0 then
									<!--- Monto no surtido OC más impuestos correspondientes:	(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido) * (1 + TasaImpuesto) --->
									- round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
								else
									<!--- Proporción no surtida OC con respecto a DOcantidad:  		(a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
									-round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
							end
						 * b.EOtc ,2) as MtoLocal,				 																	<!--- Monto --->

						'RP',																						<!--- TipoMovimiento --->
						b.NAP, 																						<!--- NAPreferencia --->
						-(a.DOconsecutivo),	<!---Para quitar la reversa quite  el  signo - --->						<!--- LINreferencia --->
						a.PCGDid,
						a.DOcantidad
					from DOrdenCM a
						inner join EOrdenCM b
						 on b.EOidorden = a.EOidorden

						inner join CPDocumentoD g
						 on g.CPDDid = a.CPDDid

						inner join CPDocumentoE f
						 on f.CPDEid = g.CPDEid

						inner join CPNAPdetalle napSC
						 on napSC.Ecodigo		= f.Ecodigo
						and napSC.CPNAPnum		= f.NAP
						and napSC.CPNAPDlinea	= g.CPDDlinea
				 where a.Ecodigo=#Arguments.Ecodigo#
				   and b.EOidorden=#Arguments.EOidorden#
			</cfquery>
<!---<cf_dumpTable var = "#request.intPresupuesto#">--->

			<cfquery name="rs" datasource="#session.DSN#">
				select count(*) as cantidad
                  from #request.intPresupuesto#
            </cfquery>            
            
			<cfif rs.cantidad GT 0>

				<cfset LvarNAP = LobjControl.ControlPresupuestario(	"CMOC",
																data.EOnumero,
																"CANCELACION",
																data.EOfecha,
																rsPeriodoAuxiliar.Pvalor,
																rsMesAuxiliar.Pvalor,
																Session.DSN,
																Arguments.Ecodigo,0,
																data.NAP)>
			</cfif>
       </cfif>

			<cfquery name="rsConContrato" datasource="#session.dsn#">
            	select do.*
                from EOrdenCM eo
                	inner join DOrdenCM do
                    	on do.EOidorden = eo.EOidorden
                        and do.Ecodigo = eo.Ecodigo
                where eo.Ecodigo = #Arguments.Ecodigo#
                	and eo.EOidorden = #Arguments.EOidorden#
                    and do.CTDContid is not null
            </cfquery>
            
            
            
		<cfif LvarNAP GTE 0 or rsConContrato.recordcount GT 0>
        	<!--- Seleccion de las lineas y cantidades para actualizar la cantidad canceladas --->
			<cfquery name="rsLineasCantCancel" datasource="#session.dsn#">
            	select do.DOlinea, (do.DOcantidad - coalesce(do.DOcantsurtida,0)) as cantCancel
                from EOrdenCM eo
                	inner join DOrdenCM do
                    	on do.EOidorden = eo.EOidorden
                        and do.Ecodigo = eo.Ecodigo
                where eo.Ecodigo = #Arguments.Ecodigo#
                	and eo.EOidorden = #Arguments.EOidorden#
            </cfquery>
        	<!--- Actualiza las Cantidades del detalle de la Orden de Compra
			        DOcantcancel = coalesce(DOcantcancel,0) + DOcantcancel--->
             <cfloop query="rsLineasCantCancel">
                <cfquery name="updateMontos" datasource="#session.dsn#">
                    update DOrdenCM
                    set DOcantcancel = coalesce(DOcantcancel,0) + <cfqueryparam cfsqltype="cf_sql_float" value="#cantCancel#">
                    where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
                        and DOrdenCM.DOlinea = #DOlinea#
                        and DOrdenCM.EOidorden = #Arguments.EOidorden#
                </cfquery>
            </cfloop>
            
            <cfif rsConContrato.recordcount EQ 0>

				<!--- Actualiza la Suficiencia --->
                <cfquery datasource="#Session.DSN#">
                    update CPDocumentoD
                       set CPDDsaldo = CPDDsaldo +
                                (
                                 select sum(
                                            round(
                                                case
                                                    when DOcontrolCantidad = 0 then
                                                        <!--- Monto no surtido OC más impuestos correspondientes:	(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido) * (1 + TasaImpuesto) --->
                                                        round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
                                                    else
                                                        <!--- Proporción no surtida OC con respecto a DOcantidad:  		(a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
                                                        round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
                                                end
                                             * b.EOtc ,2)
                                            )
                                   from DOrdenCM a, EOrdenCM b
                                  where a.EOidorden = #Arguments.EOidorden#
                                    and a.CPDDid = CPDocumentoD.CPDDid
                                    and b.EOidorden = a.EOidorden
                                )
                     where Ecodigo = #Arguments.Ecodigo#
                       and (
                             select count(1)
                               from DOrdenCM
                              where EOidorden = #Arguments.EOidorden#
                                and CPDDid = CPDocumentoD.CPDDid
                            ) > 0
                </cfquery>
           <cfelseif rsConContrato.recordcount GT 0>
             
           
           		     <cfquery datasource="#Session.DSN#">
                    update CTDetContrato
                       set CTDCmontoConsumido = CTDCmontoConsumido -
                                (
                                 select sum(
                                            round(
                                                case
                                                    when DOcontrolCantidad = 0 then
                                                        round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
                                                    else
                                                        round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
                                                end
                                             * b.EOtc ,2)
                                            )
                                   from DOrdenCM a, EOrdenCM b
                                  where a.EOidorden = #Arguments.EOidorden#
                                    and a.CTDContid = CTDetContrato.CTDCont
                                    and b.EOidorden = a.EOidorden
                                )
                     where Ecodigo = #Arguments.Ecodigo#
                       and (
                             select count(1)
                               from DOrdenCM
                              where EOidorden = #Arguments.EOidorden#
                                and CTDContid = CTDetContrato.CTDCont
                            ) > 0
                </cfquery>  	
             
             
             
            
          </cfif>  

			<!--- Detalles de la Orden de Compra que se va a Cancelar --->
			<cfquery name="ActDetSolicitud" datasource="#session.dsn#">
				select ESidsolicitud, Ecodigo, DSlinea, coalesce(sum(DOcantidad - DOcantsurtida), 0) as Cantidad
				from DOrdenCM
				where DOrdenCM.EOidorden = #Arguments.EOidorden#
				  and DSlinea is not null
				  and ESidsolicitud is not null
				group by ESidsolicitud, Ecodigo, DSlinea
			</cfquery>

            <!--- Inserta datos en la bitácora de Ordenes Canceladas --->
            <cfquery name="insertOCCancelada" datasource="#session.dsn#">
                insert into CMOrdenesCanceladas(	EOidorden,
                                                                    DOlinea,
                                                                    Ecodigo,
                                                                    cantCancel,
																	DOmontoCancelado,
                                                                    Justificacion,
                                                                    NAPAsociado,
                                                                    BMUsucodigo,
                                                                    fechaalta)
                   select
                            eo.EOidorden
                            ,do.DOlinea
                            ,eo.Ecodigo
                            ,(do.DOcantidad- coalesce(do.DOcantsurtida,0))
							,(do.DOtotal-coalesce(do.DOmontoSurtido,0))
                            ,'#Arguments.EOjustificacion#'
                            ,#LvarNAP#
                            ,#session.Usucodigo#
                            ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                 from EOrdenCM eo
                    inner join DOrdenCM do
                        on eo.EOidorden = do.EOidorden
                 where eo.EOidorden 		=  #Arguments.EOidorden#
                            and eo.Ecodigo 	= #Arguments.Ecodigo#
            </cfquery>

			<cfloop query="ActDetSolicitud">
				<cfquery datasource="#session.DSN#">
					update DSolicitudCompraCM
						set  DScantsurt	=
								case
								   when DScontrolCantidad = 0 then
										<!--- Cuando no se controla cantidad en PCG
												Si la cancelación es Total   se desSurte el 100%
												Si la cancelación es Parcial no se desSurte nada (La SC no se reactiva y el presupuesto se libera)
										 --->
										<cfif LvarCancelacion EQ "TOTAL">
											0
										<cfelse>
											1
										</cfif>
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
				where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
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
				where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
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
										and DOrdenCM.Ecodigo = #Arguments.Ecodigo#
							)
			</cfquery>

			<cfquery name="update" datasource="#session.DSN#">
				update EOrdenCM
				set EOestado = <cfif LvarCancelacion EQ "TOTAL">60<cfelse>55</cfif>,
					NAPcancel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">,
					EOjustificacion = '#Arguments.EOjustificacion#'
				where EOidorden = #Arguments.EOidorden#
				and Ecodigo = #Arguments.Ecodigo#
				<!----and CMCid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comprador#">----->
			</cfquery>

         <!--- Envio de los correos respectivos --->
         <cfset Correos =  EnvioCorreos(#Arguments.EOidorden#,#Arguments.Ecodigo#)>
		</cfif> <!--- LVarNAP GTE 0 --->
		<cfreturn LvarNAP>
	</cffunction>

    <cffunction name="CM_CancelaOC_Lineas" access="public" returntype="numeric" output="true">
		<cfargument name="EOidorden" 			type="string" required="true">
		<cfargument name="EOjustificacion" 		type="string" required="true">
		<cfargument name="TransaccionActiva"	type="boolean" default="false">
        <cfargument name="Ecodigo"				type="numeric" default="#session.Ecodigo#">
		<cfargument name="DOlinea" 				type="string" 	required="true"><!---Cancelacion por linea--->
		<cfargument name="DOcantcancel" 		type="string" 	required="true"> <!---cantidad que se quiere cancelar--->
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="false" default="#session.Usucodigo#">
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>

		<cfif Arguments.TransaccionActiva>
			<cfreturn CM_CancelaOC_Lineas_private (Arguments.EOidorden, Arguments.EOjustificacion, Arguments.Ecodigo, Arguments.DOlinea, Arguments.DOcantcancel,Arguments.BMUsucodigo)>
		<cfelse>
			<cftransaction>
			<cfreturn CM_CancelaOC_Lineas_private (Arguments.EOidorden, Arguments.EOjustificacion, Arguments.Ecodigo, Arguments.DOlinea, Arguments.DOcantcancel,Arguments.BMUsucodigo)>
			</cftransaction>
		</cfif>
	</cffunction>

    <cffunction name="CM_CancelaOC_Lineas_private" access="private" returntype="numeric" output="true">
		<cfargument name="EOidorden" 		type="string" required="true">
		<cfargument name="EOjustificacion" 	type="string" required="true">
       	<cfargument name="Ecodigo"			type="numeric" default="#session.Ecodigo#">
		<cfargument name="DOlinea" 			type="string" 	required="true">
		<cfargument name="DOcantcancel" 	type="string" 	required="true">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="false" default="#session.Usucodigo#">
		<!----<cfargument name="Comprador" 		type="numeric" required="false" default="#session.compras.comprador#">---->

        <cfquery name="data" datasource="#session.dsn#">
			select EOidorden, EOnumero, EOfecha, CMTOcodigo, NAP, EOestado
			from EOrdenCM
			where EOidorden=#Arguments.EOidorden#
		</cfquery>
		
		<!--- Validacion de las cantidades a cancelar --->
		<cfquery name="validaCantidades" datasource="#session.dsn#">
			select EOnumero, DOconsecutivo, ROUND((DOcantidad - DOcantsurtida), 2) as DOcantNoSurt
			  from DOrdenCM
			 where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
			   and DOrdenCM.DOlinea = #Arguments.DOlinea#
			   and DOrdenCM.EOidorden = #Arguments.EOidorden#
		</cfquery>

		<cfif Arguments.DOcantcancel LT 0>
			<cfthrow message="Orden #validaCantidades.EOnumero# línea #validaCantidades.DOconsecutivo#: no se permite cancelar una cantidad negativa">
		<cfelseif NumberFormat(Arguments.DOcantcancel, "0.0000") GT NumberFormat(validaCantidades.DOcantNoSurt, "0.0000")>
			<cfthrow message="Orden #validaCantidades.EOnumero# línea #validaCantidades.DOconsecutivo#: no se permite cancelar una cantidad mayor que la cantidad no surtida">
		</cfif>

 		<!--- 22/10/2014 ERBG Cambio para evitar la cancelación de orden relacionada a un documento de CXP Inicia---> 
        <cfquery name="rsdata" datasource="#session.dsn#">
            select top 1  do.DOlinea,dc.Ecodigo,do.EOidorden,do.EOnumero,do.DOdescripcion,dc.IDdocumento,EOfecha
            from DOrdenCM do
            inner join EOrdenCM eo on eo.EOidorden = do.EOidorden and do.Ecodigo=eo.Ecodigo
            inner join DDocumentosCxP dc on do.DOlinea=dc.DOlinea and do.Ecodigo=dc.Ecodigo            
            where do.EOidorden = #Arguments.EOidorden#
            	and do.DOlinea = #Arguments.DOlinea#
                and do.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsdata.recordcount gt 0>
			<cf_errorCode	code = "51804"
							msg  = "La Orden de Compra @errorDat_1@ con línea @errorDat_2@ no se puede cancelar porque está ligada a un documento."
							errorDat_1="#rsdata.EOnumero#"
							errorDat_2="#dateformat(rsdata.DOlinea, 'DD/MM/YYYY')#"
			>
		</cfif>
        <cfquery name="rsdata" datasource="#session.dsn#">
            select top 1  do.DOlinea,dc.Ecodigo,do.EOidorden,do.EOnumero,do.DOdescripcion,dc.IDdocumento,EOfecha
            from DOrdenCM do
            inner join EOrdenCM eo on eo.EOidorden = do.EOidorden and do.Ecodigo=eo.Ecodigo
            inner join HDDocumentosCP dc on do.DOlinea=dc.DOlinea and do.Ecodigo=dc.Ecodigo            
            where do.EOidorden = #Arguments.EOidorden#
                and do.DOlinea = #Arguments.DOlinea#
                and do.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsdata.recordcount gt 0>
			<cf_errorCode	code = "51804"
							msg  = "La Orden de Compra @errorDat_1@ con línea @errorDat_2@ no se puede cancelar porque está ligada a un documento aplicado."
							errorDat_1="#rsdata.EOnumero#"
							errorDat_2="#dateformat(rsdata.DOlinea, 'DD/MM/YYYY')#">
		</cfif>
		<!--- 22/10/2014 FIN--->

		<!--- Se actualiza la justificacion en el encabezado de la OC --->
		<cfquery datasource="#session.dsn#">
			update EOrdenCM
			set EOjustificacion = '#Arguments.EOjustificacion#'
			where EOidorden=#Arguments.EOidorden#
		</cfquery>

		<!--- Mes Auxiliar --->
		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			and Pcodigo   = 60
		</cfquery>
		<!--- Periodo Auxiliar --->
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.Ecodigo#
			and Pcodigo= 50
		</cfquery>
		<!--- Moneda Local --->
	 	<cfquery datasource="#session.dsn#" name="MonedaLocal">
			select Mcodigo
			from Empresas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<cfset GvarMcodigoLocal = MonedaLocal.Mcodigo>

		<cfset LvarReferencia = "CANCELACION">
		<!---1. Seleccionar el numero de OC cancelada (REFERENCIA)--->
		<cfif Arguments.DOcantcancel GT 0 AND data.RecordCount and len(data.NAP) and data.NAP >
			<!--- Se obtiene un numero que sirve para consecutivo de la solicitud para el NAP --->
			<cfquery name="rsOrdenesCanceladas" datasource="#session.DSN#">
				select count(1) as cantidad
				from CMOrdenesCanceladas
				where EOidorden = #Arguments.EOidorden#
					and Ecodigo = #Arguments.Ecodigo#
			</cfquery>

			<cfif rsOrdenesCanceladas.cantidad EQ "">
				<cfset LvarReferencia = "CANCELACION 1">
			<cfelse>
				<cfset LvarReferencia = "CANCELACION #rsOrdenesCanceladas.cantidad + 1#">
			</cfif>
         <cfelse>
         	<cfset LvarReferencia   =  "CANCELACION 1">
		</cfif>
		<!---2. Tipo de Cancelacion--->
		<cfquery name="rsTotalLineasSurtidas" datasource="#session.DSN#">
			select count(1) as Total
			from DOrdenCM
			where Ecodigo = #Arguments.Ecodigo#
				and EOidorden = #Arguments.EOidorden#
				and (DOcantsurtida > 0 or DOmontoSurtido > 0)
		</cfquery>
		<cfif rsTotalLineasSurtidas.Total EQ 0>
			<cfset LvarCancelacion = "TOTAL">
		<cfelse>
			<cfset LvarCancelacion = "PARCIAL DE TODO LO NO SURTIDO">
		</cfif>

		<cfset LvarNAP = 0>
		<cfif trim(data.NAP) NEQ "" AND data.NAP GTE 0>
			<!---///////////////////////////// ACTUALIZAR LA CANTIDAD SURTIDA DEL CONTRATO //////////////////////////---->
            <!---3.verificacion de la OC si se encuentra en Contrato--->
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
				where a.Ecodigo= #Arguments.Ecodigo#
					and a.DOlinea = #Arguments.DOlinea#
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

					where cmoc.Ecodigo = #Arguments.Ecodigo#
						and cmoc.DOlinea = #rsOrden.DOlinea#
						and cmoc.EOidorden = #rsOrden.EOidorden#
						and cmoc.SNcodigo = #rsOrden.SNcodigo#
				</cfquery>
                <!---Si la línea esta en un contrato actualiza la cantidad surtida del contrato---->
				<cfif rsContratos.RecordCount NEQ 0>
					<cfquery datasource="#session.DSN#">
						update DContratosCM
						set DCcantsurtida = <cfqueryparam cfsqltype="cf_sql_float" value="#rsContratos.DCcantsurtida#"> - <cfqueryparam cfsqltype="cf_sql_float" value="#rsOrden.DOcantidad#">
						where Ecodigo = #Arguments.Ecodigo#
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
                                    #Arguments.Ecodigo#,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsContratos.SNcodigo#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContratos.ECid#">,
                                    -(<cfqueryparam cfsqltype="cf_sql_float" value="#rsOrden.DOcantidad#">),
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								)
					</cfquery>
				</cfif>
			</cfloop>

        	<!--- Actualiza las Cantidades del detalle de la Orden de Compra y el monto de cancelacion en el saldo
			        DOcantcancel = coalesce(DOcantcancel,0) + DOcantcancel
					DOmontoCancelado = Total de la linea - lo surtido (saldo de la linea)
					--->
			<cfquery name="updateMontos" datasource="#session.dsn#">
				update DOrdenCM
				set DOcantcancel = coalesce(DOcantcancel,0) + <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.DOcantcancel#">
				,DOmontoCancelado = DOtotal-coalesce(DOmontoSurtido,0)
				where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
					and DOrdenCM.DOlinea = #Arguments.DOlinea#
					and DOrdenCM.EOidorden = #Arguments.EOidorden#
			</cfquery>

            <!---SML. 03/07/2014 Inicio. Modificacion para eliminar el compromiso sin distribucion de monto--->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
                select 'CMOC',
						<cf_dbfunction name="to_char" args="b.EOnumero" >,
	   					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#LvarReferencia#">,
	   					c.EOfecha,
	  					#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
	   					f.CPNAPDlinea,
	   					f.CFcuenta,
	   					d.Ocodigo,
	   					e.Oficodigo,
	   					c.Mcodigo,
	   					-f.CPNAPDmontoOri as MtoOrigen,
                        c.EOtc,
	   					-f.CPNAPDmonto as MtoLocal,
	   					'CC',
	   					c.NAP,
	   					f.CPNAPDlinea,
	   					b.PCGDid,
	   					-b.DOcantidad
				from DOrdenCM b
					INNER JOIN EOrdenCM c on b.EOidorden = c.EOidorden
					inner JOIN CFuncional d on b.CFid = d.CFid
						and b.Ecodigo = d.Ecodigo
					inner join Oficinas e on e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo
					inner join CPNAPdetalle f on f.CPNAPnum = c.NAP
						and f.CPNAPDlinea = b.DOconsecutivo
			    where b.EOidorden = #Arguments.EOidorden#
	  				  and b.Ecodigo = #Arguments.Ecodigo#
                      and b.DOlinea = #Arguments.DOlinea#
                      and f.CPNAPDtipoMov = 'CC'
                      and (b.CPDCid is null or b.CPDCid = 0)
			</cfquery>
            <!---SML. 03/07/2014 Final. Modificacion para eliminar el compromiso sin distribucion de monto--->

            <!---SML. 03/07/2014 Inicio. Modificacion para eliminar el compromiso con distribucion de monto--->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
                 select 'CMOC',
						b.EOnumero,
	   					'CANCELACION',
	   					c.EOfecha,
	  					#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
	   					a.CPNAPDlinea,
	   					a.CFcuenta,
	   					d.Ocodigo,
	   					e.Oficodigo,
	   					c.Mcodigo,
	   					-f.CPNAPDmontoOri as MtoOrigen,
                        f.CPNAPDtipoCambio,
	   					-f.CPNAPDmonto as MtoLocal,
	   					'CC',
	   					c.NAP,
	   					a.CPNAPDlinea,
	   					b.PCGDid,
	   					-b.DOcantidad
				from DistribucionOC a
					inner JOIN DOrdenCM b on a.CPDCid = b.CPDCid
						and a.EOidorden = b.EOidorden and a.Ecodigo = b.Ecodigo
                        and a.DOconsecutivo = b.DOconsecutivo
					INNER JOIN EOrdenCM c on a.Ecodigo = b.Ecodigo
						and b.EOidorden = c.EOidorden
					inner JOIN CFuncional d on a.CFid = d.CFid
						and a.Ecodigo = d.Ecodigo
					inner join Oficinas e on e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo
					inner join CPNAPdetalle f on f.CPNAPnum = c.NAP
						and f.CPNAPDlinea = a.CPNAPDlinea
			    where a.EOidorden = #Arguments.EOidorden#
	  				  and a.Ecodigo = #Arguments.Ecodigo#
                      and b.DOlinea = #Arguments.DOlinea#
                      and b.CPDCid is not null
					  and b.CPDCid <> 0
            </cfquery>
			<!---SML. 03/07/2014 Final. Modificacion para eliminar el compromiso con distribucion de monto--->
            
             <!---SML. 24/09/2014 Inicio. Devolución de la DesReserva Solicitud Compra con distribucion de monto--->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
                 select 'CMOC',
						b.EOnumero,
	   					'CANCELACION',
	   					c.EOfecha,
	  					#rsPeriodoAuxiliar.Pvalor#,
						#rsMesAuxiliar.Pvalor#,
	   					-a.CPNAPDlinea,
	   					a.CFcuenta,
	   					d.Ocodigo,
	   					e.Oficodigo,
	   					c.Mcodigo,
	   					f.CPNAPDmontoOri as MtoOrigen,
                        f.CPNAPDtipoCambio,
	   					f.CPNAPDmonto as MtoLocal,
	   					'RC',
	   					c.NAP,
	   					-a.CPNAPDlinea,
	   					b.PCGDid,
	   					b.DOcantidad
				from DistribucionOC a
					inner JOIN DOrdenCM b on a.CPDCid = b.CPDCid
						and a.EOidorden = b.EOidorden and a.Ecodigo = b.Ecodigo
                        and a.DOconsecutivo = b.DOconsecutivo
					INNER JOIN EOrdenCM c on a.Ecodigo = b.Ecodigo
						and b.EOidorden = c.EOidorden
					inner JOIN CFuncional d on a.CFid = d.CFid
						and a.Ecodigo = d.Ecodigo
					inner join Oficinas e on e.Ocodigo = d.Ocodigo
						and e.Ecodigo = d.Ecodigo
					inner join CPNAPdetalle f on f.CPNAPnum = c.NAP
						and f.CPNAPDlinea = a.CPNAPDlinea
			    where a.EOidorden = #Arguments.EOidorden#
	  				  and a.Ecodigo = #Arguments.Ecodigo#
                      and b.DOlinea = #Arguments.DOlinea#
                      and b.CPDCid is not null
					  and b.CPDCid <> 0
            </cfquery>
			<!---SML. 24/09/2014 Final. Devolución de la DesReserva Solicitud Compra con distribucion de monto--->
            

			<!--- Devolución de la DesReserva Solicitud Compra --->
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
														LINreferencia,
														PCGDid, PCGDcantidad)
				select  'CMOC',																						<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.EOnumero" >,											<!--- NumeroDocumento --->
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#LvarReferencia#">,																				<!--- NumeroReferencia --->
						b.EOfecha,																					<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																	<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																		<!--- MesDocumento --->
						-(a.DOconsecutivo),																			<!--- NumeroLinea  --->
						<!--- Proporción no surtida OC con respecto a la cantidad SC original, maximo cantidad reservada original: --->
							 <!--- Prop. Cant. no surtida: CANTIDAD_NO_SURTIDA / CANTIDAD_ORIGINAL --->
							 <!--- CANTIDAD_NO_SURTIDA  =  (a.DOcantidad-a.DOcantsurtida) --->
							 <!--- CANTIDAD_ORIGINAL =      g.DScantidadNAP --->
							 <!--- Prop. Cant. no surtida: (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP --->
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
							when DOcontrolCantidad = 0 then
								<!--- Cuando no se controla cantidad en PCG
										Si la cancelación es Total   se reReserva el 100%
										Si la cancelación es Parcial no se reReserva nada (La SC no se reactiva y el presupuesto se libera)
								 --->
								<cfif LvarCancelacion EQ "TOTAL">
									napSC.CPNAPDmontoOri
								<cfelse>
									0
								</cfif>
							<!--- Se pregunta en moneda local (CPNAPDmonto) porque CPNAPDutilizado sólo está en moneda local --->
							when napSC.CPNAPDutilizado < napSC.CPNAPDmonto * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP then
								round(napSC.CPNAPDutilizado / napSC.CPNAPDtipoCambio,2)
							else
								round( napSC.CPNAPDmontoOri * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP ,2)
						end,																						<!--- MontoOrigen --->
						napSC.CPNAPDtipoCambio,																				<!--- TipoCambio --->

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						round(
							case
								when DOcontrolCantidad = 0 then
									<cfif LvarCancelacion EQ "TOTAL">
										napSC.CPNAPDmontoOri
									<cfelse>
										0
									</cfif>
								when napSC.CPNAPDutilizado < napSC.CPNAPDmonto * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP then
									round(napSC.CPNAPDutilizado / napSC.CPNAPDtipoCambio,2)
								else
									round( napSC.CPNAPDmontoOri * (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP ,2)
							end
						*napSC.CPNAPDtipoCambio, 2),

						<!---'CC',--->'RC',																				<!--- TipoMovimiento --->
						b.NAP, 																						<!--- NAPreferencia --->
						-(a.DOconsecutivo),																			<!--- LINreferencia --->
						a.PCGDid,
						a.DOcantidad
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
				 where a.Ecodigo=#Arguments.Ecodigo#
				   and b.EOidorden=#Arguments.EOidorden#
				   and a.DOlinea = #Arguments.DOlinea#
			</cfquery>

			<!--- Devolución de la DesReserva de la PROVISION de Suficiencia --->
			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#(
														ModuloOrigen,
														NumeroDocumento,
														NumeroReferencia,
														FechaDocumento,
														AnoDocumento,
														MesDocumento,
														NumeroLinea,
														CPcuenta,
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
				select  'CMOC',																						<!--- ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.EOnumero" >,											<!--- NumeroDocumento --->
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#LvarReferencia#">,																				<!--- NumeroReferencia --->
						b.EOfecha,																					<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor#,																	<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor#,																		<!--- MesDocumento --->
						-(a.DOconsecutivo),																			<!--- NumeroLinea  --->
						<!--- Proporción no surtida OC con respecto a la cantidad SC original, maximo cantidad reservada original: --->
							 <!--- Prop. Cant. no surtida: CANTIDAD_NO_SURTIDA / CANTIDAD_ORIGINAL --->
							 <!--- CANTIDAD_NO_SURTIDA  =  (a.DOcantidad-a.DOcantsurtida) --->
							 <!--- CANTIDAD_ORIGINAL =      g.DScantidadNAP --->
							 <!--- Prop. Cant. no surtida: (a.DOcantidad-a.DOcantsurtida) / g.DScantidadNAP --->
							 <!---
									Se usa napSC.CPNAPmontoOri en lugar de (DStotallinest+DSimpuestoCosto)
									porque en algunos lugares se recalculaMontos:
										DStotallinest = round(DScant * DSmontoest,2)
									El máximo a Devolver es el monto Sí Utilizado de la Reserva
						--->
						<!--- La suficiencia se hace a nivel de Cuenta de Presupuesto --->
						napSC.CPcuenta,																					<!--- CFuenta --->
						napSC.Ocodigo,																					<!--- Oficina --->
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,																				<!--- CodigoOficina --->

						<!--- Se devuelve el mismo monto de la Orden --->
						b.Mcodigo,
						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						-	case
								when DOcontrolCantidad = 0 then
									<!--- Monto no surtido OC más impuestos correspondientes:	(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido) * (1 + TasaImpuesto) --->
									- round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
								else
									<!--- Proporción no surtida OC con respecto a DOcantidad:  		(a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
									-round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
							end as MtoOrigen,															<!--- Monto --->

						b.EOtc,																			<!--- TipoCambio --->

						<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
						-round(
							case
								when DOcontrolCantidad = 0 then
									<!--- Monto no surtido OC más impuestos correspondientes:	(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido) * (1 + TasaImpuesto) --->
									- round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
								else
									<!--- Proporción no surtida OC con respecto a DOcantidad:  		(a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
									-round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
							end
						 * b.EOtc ,2) as MtoLocal,				 																	<!--- Monto --->

						'RP',																						<!--- TipoMovimiento --->
						b.NAP, 																						<!--- NAPreferencia --->
						-(a.DOconsecutivo),																			<!--- LINreferencia --->
						a.PCGDid,
						a.DOcantidad
					from DOrdenCM a
						inner join EOrdenCM b
						 on b.EOidorden = a.EOidorden

						inner join CPDocumentoD g
						 on g.CPDDid = a.CPDDid

						inner join CPDocumentoE f
						 on f.CPDEid = g.CPDEid

						inner join CPNAPdetalle napSC
						 on napSC.Ecodigo		= f.Ecodigo
						and napSC.CPNAPnum		= f.NAP
						and napSC.CPNAPDlinea	= g.CPDDlinea
				 where a.Ecodigo=#Arguments.Ecodigo#
				   and b.EOidorden=#Arguments.EOidorden#
				   and a.DOlinea = #Arguments.DOlinea#
			</cfquery>

			<cfset LvarNAP = LobjControl.ControlPresupuestario(	"CMOC",
																data.EOnumero,
																'#LvarReferencia#',
																data.EOfecha,
																rsPeriodoAuxiliar.Pvalor,
																rsMesAuxiliar.Pvalor,
																Session.DSN,
																Arguments.Ecodigo,
																data.NAP)>
		</cfif>

		<cfif LvarNAP GTE 0>
			<!---Actualiza el Encabezado y montos de las lineas respecto a los cambios con las cantidades, considerando
				las que fueron canceladas, solo en los casos en los que la linea tenga control de cantidad = 1 --->
			<cfquery name="rsControlCantidad" datasource="#session.dsn#">
				select DOcontrolCantidad
				from DOrdenCM
				where Ecodigo = #Arguments.Ecodigo#
					and EOidorden = #Arguments.EOidorden#
					and DOlinea =#Arguments.DOlinea#
			</cfquery>
			

			<!--- Actualiza la Suficiencia --->
			<cfquery datasource="#Session.DSN#">
				update CPDocumentoD
				   set CPDDsaldo = CPDDsaldo +
							(
							 select sum(
										round(
											case
												when DOcontrolCantidad = 0 then
													<!--- Monto no surtido OC más impuestos correspondientes:	(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido) * (1 + TasaImpuesto) --->
													round(	round(a.DOtotal-a.DOmontodesc-a.DOmontoSurtido,2) * (1.0 + (1.0*a.DOimpuestoCosto)/(a.DOtotal-a.DOmontodesc))	,2)
												else
													<!--- Proporción no surtida OC con respecto a DOcantidad:  		(a.DOcantidad-a.DOcantsurtida)/a.DOcantidad --->
													round( round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) * (a.DOcantidad - a.DOcantsurtida) / a.DOcantidad, 2)
											end
										 * b.EOtc ,2)
										)
							   from DOrdenCM a, EOrdenCM b
							  where a.EOidorden = #Arguments.EOidorden#
								and a.DOlinea = #Arguments.DOlinea#
								and a.CPDDid = CPDocumentoD.CPDDid
                                and b.EOidorden = a.EOidorden
							)
				 where Ecodigo = #Arguments.Ecodigo#
                 	and CPDDid =(
						 select CPDDid
						   from DOrdenCM
						  where EOidorden = #Arguments.EOidorden#
							and DOlinea = #Arguments.DOlinea#
						) 
				  <!--- and (
						 select count(1)
						   from DOrdenCM
						  where EOidorden = #Arguments.EOidorden#
							and DOlinea = #Arguments.DOlinea#
							and CPDDid = CPDocumentoD.CPDDid
						) > 0--->
			</cfquery>

			<cfif rsControlCantidad.DOcontrolCantidad eq 1 >
				<cfset calculaTotalesEOrdenCM (#Arguments.EOidorden#, session.Ecodigo)>
			</cfif>
            
			<!--- Detalles de la Orden de Compra que se va a Cancelar --->
			<cfquery name="ActDetSolicitud" datasource="#session.dsn#">
				select ESidsolicitud, Ecodigo, DSlinea, coalesce(sum(DOcantidad - DOcantsurtida), 0) as Cantidad
				from DOrdenCM
				where DOrdenCM.EOidorden = #Arguments.EOidorden#
				  and DOrdenCM.DOlinea = #Arguments.DOlinea#
				  and DSlinea is not null
				  and ESidsolicitud is not null
				group by ESidsolicitud, Ecodigo, DSlinea
			</cfquery>

			<cfloop query="ActDetSolicitud">
				<cfquery datasource="#session.DSN#">
					update DSolicitudCompraCM
						set  DScantsurt	=
								case
								   when DScontrolCantidad = 0 then
										<!--- Cuando no se controla cantidad en PCG
												Si la cancelación es Total   se desSurte el 100%
												Si la cancelación es Parcial no se desSurte nada (La SC no se reactiva y el presupuesto se libera)
										 --->
										<cfif LvarCancelacion EQ "TOTAL">
											0
										<cfelse>
											1
										</cfif>
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
				where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
					and DOrdenCM.DOlinea = #Arguments.DOlinea#
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
				where DOrdenCM.Ecodigo = #Arguments.Ecodigo#
					and DOrdenCM.DOlinea = #Arguments.DOlinea#
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
										and DOrdenCM.DOlinea = #Arguments.DOlinea#
										and DOrdenCM.Ecodigo = #Arguments.Ecodigo#
							)
			</cfquery>

            <!--- Actualizar el estado de la OC a 55 o 60 unicamente si ya no existen lineas que surtir --->
			<cfquery name="update" datasource="#session.DSN#">
				update EOrdenCM
				set EOestado = <cfif LvarCancelacion EQ "TOTAL">60<cfelse>55</cfif>,
					NAPcancel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">,
					EOjustificacion = '#Arguments.EOjustificacion#'
				where EOidorden = #Arguments.EOidorden#
				and Ecodigo = #Arguments.Ecodigo#
                and not exists(
                                        select 1
                                        from DOrdenCM
                                        where (DOrdenCM.DOcantsurtida + coalesce(DOrdenCM.DOcantcancel,0)) <> DOrdenCM.DOcantidad
                                            and DOrdenCM.EOidorden = EOrdenCM.EOidorden)
			</cfquery>

          <!--- Inserta datos al tabla de bitácora de Ordenes Canceladas --->
			<cfquery name="insertOCCancelada" datasource="#session.dsn#">
				insert into CMOrdenesCanceladas(	EOidorden,
                                                                    DOlinea,
                                                                    Ecodigo,
                                                                    cantCancel,
																	DOmontoCancelado,
                                                                    Justificacion,
                                                                    NAPAsociado,
                                                                    BMUsucodigo,
                                                                    fechaalta)
					select 	EOidorden,
								DOlinea,
								Ecodigo,
								DOcantcancel,
								DOmontoCancelado,
								'#Arguments.EOjustificacion#',
								#LvarNAP#,
								#Arguments.BMUsucodigo#,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					from  DOrdenCM
					where DOlinea = #Arguments.DOlinea#
						and EOidorden = #Arguments.EOidorden#
						and Ecodigo = #Arguments.Ecodigo#
			</cfquery>

         <cfset Correos =  EnvioCorreos(#Arguments.EOidorden#, #Arguments.Ecodigo#, #Arguments.DOlinea#)>

		</cfif> <!--- LVarNAP GTE 0 --->
		<cfreturn LvarNAP>
	</cffunction>

    <!--- Funcion de envio de los correos --->
    <cffunction name="EnvioCorreos" access="private">
            <cfargument name="EOidorden" 		type="string" required="true">
            <cfargument name="Ecodigo"			type="numeric" default="#session.Ecodigo#">
            <cfargument name="DOlinea" 			type="string" default="-1">
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
                and a.Ecodigo = #Arguments.Ecodigo#
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
            where b.Ecodigo = #Arguments.Ecodigo#
                and b.EOidorden = #Arguments.EOidorden#
                <cfif Arguments.DOlinea neq -1>
                    and b.DOlinea = #Arguments.DOlinea#
                </cfif>

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
    </cffunction>

	<!---
		Funcion para recalcular los montos del total de las lineas del detalle de la OC
		y actualizar el encabezado de la Orden según las cantidades canceladas
	--->
	<cffunction name="calculaTotalesEOrdenCM" access="public" output="no">
		<cfargument name="EOidorden" 			required="yes" 	type="numeric">
		<cfargument name="Ecodigo" 				required="no" 	type="numeric" default="#session.Ecodigo#">
		<cfargument name="CalcularSinImpuestos" required="no" 	type="boolean" default="false">
        
        

		<!---??Valida si existen lineas de detalle en la Orden de Compra??--->
        <cfquery datasource="#session.DSN#" name="Lineas">
			select count(1) cantidad
            	from DOrdenCM
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
             	
		</cfquery>
        <!---??Si NO existen lineas en la OC, se Actualiza el total, el impuesto y descuento del encabezado en cero??--->
        <cfif NOT Lineas.cantidad>
        	 <cfquery name="updateMonto" datasource="#Session.DSN#">
                    update EOrdenCM set
                     	EOtotal	 = 0,
                        Impuesto = 0,
                        EOdesc	 = 0
                    where EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			</cfquery>
        <!---??Si existen lineas en la OC, se Actualiza el total, el impuesto y descuento del encabezado con el calculo correspondiente??--->
       <cfelse>
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOmontodesc = 0
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			   and DOmontodesc IS NULL
               
		</cfquery>

		<!---
			Actualiza el Total de la Linea, con respecto a la cantidad real sin las cantidades canceladas
		--->
        
		<cfquery name="rsActualizaTotal" datasource="#session.DSN#">
				update DOrdenCM
				   set DOtotal = DOpreciou*(DOcantidad-coalesce(DOcantcancel,0))
				   where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
                   		
		</cfquery>
		<!---
			Si se ha mandado DOtotal con Impuesto Incluido, se recalcula sin impuestos
		--->
		<cfif Arguments.CalcularSinImpuestos>
			<cfquery datasource="#session.DSN#">
				update DOrdenCM
				   set DOtotal = DOtotal / (1-DOporcdesc/100) /
				   				( 1 +
										coalesce((
											select i.Iporcentaje/100
											  from Impuestos i
											 where i.Ecodigo = DOrdenCM.Ecodigo
											   and i.Icodigo = DOrdenCM.Icodigo
											   and i.Icompuesto = 0
											   and i.Icreditofiscal = 0
										),0)
										+
										coalesce((
											select di.DIporcentaje/100
											  from DOrdenCM d
												inner join Impuestos i
												 on i.Ecodigo = d.Ecodigo
												and i.Icodigo = d.Icodigo
												inner join DImpuestos di
												 on di.Ecodigo	= i.Ecodigo
												and di.Icodigo	= i.Icodigo
											 where d.Ecodigo	= DOrdenCM.Ecodigo
											   and d.EOidorden	= DOrdenCM.EOidorden
											   and i.Icompuesto	= 1
											   and di.DIcreditofiscal	= 0
										),0)
								)
				 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
                 	and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DOlinea#"> 
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update DOrdenCM
				   set DOpreciou	= DOtotal / (DOcantidad-coalesce(DOcantcancel,0)
				   	 , DOmontodesc 	= round(DOtotal * DOporcdesc/100,2)
				 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
                 	
			</cfquery>
		</cfif>

		<!---
			Calcula y separa los impuestos asignados al Costo y los de Credito Fiscal
		--->
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOimpuestoCosto =
				coalesce((
					select round( round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * i.Iporcentaje/100,2)
					  from Impuestos i
					 where i.Ecodigo = DOrdenCM.Ecodigo
					   and i.Icodigo = DOrdenCM.Icodigo
					   and i.Icompuesto = 0
					   and i.Icreditofiscal = 0
				),0)
				+
				coalesce((
					select sum(round( round(d.DOtotal-d.DOmontodesc,2) * di.DIporcentaje/100,2))
					  from DOrdenCM d
						inner join Impuestos i
						 on i.Ecodigo = d.Ecodigo
						and i.Icodigo = d.Icodigo
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
					 where d.Ecodigo	= DOrdenCM.Ecodigo
					   and d.EOidorden	= DOrdenCM.EOidorden
					   and i.Icompuesto	= 1
					   and di.DIcreditofiscal	= 0
				),0)
				 , DOimpuestoCF =
				coalesce((
					select round( round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) * i.Iporcentaje/100,2)
					  from Impuestos i
					 where i.Ecodigo = DOrdenCM.Ecodigo
					   and i.Icodigo = DOrdenCM.Icodigo
					   and i.Icompuesto = 0
					   and i.Icreditofiscal = 1
				),0)
				+
				coalesce((
					select sum(round( round(d.DOtotal-d.DOmontodesc,2) * di.DIporcentaje/100,2))
					  from DOrdenCM d
						inner join Impuestos i
						 on i.Ecodigo = d.Ecodigo
						and i.Icodigo = d.Icodigo
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
					 where d.Ecodigo	= DOrdenCM.Ecodigo
					   and d.EOidorden	= DOrdenCM.EOidorden
					   and i.Icompuesto	= 1
					   and di.DIcreditofiscal	= 1
				),0)
			 where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
             
		</cfquery>

		<!---
			Ajusta Impuesto por redondeo
		--->
		<cfquery name="rsRedondeoOC" datasource="#session.DSN#">
			select 	round(sum(DOrdenCM.DOimpuestoCosto),2)	as DOimpuestoCosto,
					sum(round(DOrdenCM.DOimpuestoCosto,2))	as DOimpuestoCosto2,

					round(sum(DOrdenCM.DOimpuestoCF),2)		as DOimpuestoCF,
					sum(round(DOrdenCM.DOimpuestoCF,2))		as DOimpuestoCF2,

					max(coalesce(DOrdenCM.DOimpuestoCosto,0)+coalesce(DOrdenCM.DOimpuestoCF,0))	as MaxImpuesto
			 from DOrdenCM
			where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
            	
		</cfquery>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select coalesce(min(DOlinea),0) as DOlinea
			  from DOrdenCM
			 where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			   and coalesce(DOrdenCM.DOimpuestoCosto,0)+coalesce(DOrdenCM.DOimpuestoCF,0) = #rsRedondeoOC.MaxImpuesto#
               
		</cfquery>
		<cfset LvarAjusteICosto = round((rsRedondeoOC.DOimpuestoCosto - rsRedondeoOC.DOimpuestoCosto2)*100)/100>
		<cfset LvarAjusteICF = round((rsRedondeoOC.DOimpuestoCF - rsRedondeoOC.DOimpuestoCF2)*100)/100>
		<cfquery datasource="#session.DSN#">
			update DOrdenCM
			   set DOimpuestoCosto =
						round(DOimpuestoCosto,2)
					<cfif LvarAjusteICosto NEQ 0>
						+ case when DOlinea = #rsSQL.DOlinea# then
							#LvarAjusteICosto#
							else 0
						  end
					</cfif>
					,DOimpuestoCF =
						round(DOimpuestoCF,2)
					<cfif LvarAjusteICF NEQ 0>
						+ case when DOlinea = #rsSQL.DOlinea# then
							#LvarAjusteICF#
							else 0
						  end
					</cfif>
			 where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
             	
		</cfquery>


		<!---
			Se calcula los Totales de la orden
		--->
		<cfquery name="rsTotalesOC" datasource="#session.DSN#">
			select 	coalesce(sum( round(DOrdenCM.DOtotal-DOrdenCM.DOmontodesc,2) ),0)	as TotalLineas,
					coalesce(sum(DOrdenCM.DOimpuestoCosto + DOrdenCM.DOimpuestoCF),0)	as TotalImpuestos,
					coalesce(sum(coalesce(DOmontodesc,0)),0) 							as TotalDescuentos
			 from DOrdenCM
			where DOrdenCM.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>
		<cfquery name="updateMonto" datasource="#Session.DSN#">
			update EOrdenCM
			   set EOtotal	= #rsTotalesOC.TotalLineas# + #rsTotalesOC.TotalImpuestos#,
				   Impuesto	= #rsTotalesOC.TotalImpuestos#,
				   EOdesc	= #rsTotalesOC.TotalDescuentos#
			where EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
		</cfquery>
     </cfif>
	</cffunction>

	<cffunction name="CM_getOCACancelar" access="public" returntype="query" output="true">
		<cfargument name="Comprador"  type="string" required="false" default="#session.compras.comprador#">
		<cfargument name="Ecodigo"  	type="numeric" required="false" default="#session.Ecodigo#"><!---type="numeric"--->
        <cfargument name="CancelacionP"  	type="numeric" required="false" default="1"><!--- bit de Cancelacion por Linea --->
		<cfquery name="data" datasource="#session.dsn#">
			select
				a.EOidorden, a.Ecodigo, a.EOnumero, a.SNcodigo,
				a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo,
				a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot,
				a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo,
				a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo,
				a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado,
				b.Mnombre, c.CMCnombre, d.Rdescripcion, e.SNnombre, f.CMTOdescripcion
                <cfif Arguments.CancelacionP eq 2>
                    ,do.DOconsecutivo, case CMtipo 	when 'A' then ltrim(rtrim(Acodigo))
                                                                        when 'S' then ltrim(rtrim(n.Ccodigo))
                                                                        when 'F' then ' ' end as codigo,
                   do.DOdescripcion, do.DOcantidad, coalesce(do.DOcantcancel,0) as DOcantcancel, do.DOcantsurtida,
                   Round((do.DOcantidad - do.DOcantsurtida),2) as SaldoLinea,
                   do.DOlinea, do.DOtotal, do.DOobservaciones, do.DOconsecutivo, do.DOalterna
               </cfif>
			from EOrdenCM a
                <!--- Lista de  con detalles --->
                <cfif Arguments.CancelacionP eq 2>
                    inner join DOrdenCM do on do.EOidorden = a.EOidorden and do.Ecodigo = a.Ecodigo
                    <!---Articulos--->
                    left outer join Articulos m on do.Aid=m.Aid and m.Ecodigo = do.Ecodigo
                    <!---Conceptos--->
                    left outer join Conceptos n on do.Cid=n.Cid and n.Ecodigo = do.Ecodigo
                    <!---Activos--->
                    left outer join ACategoria o on do.ACcodigo=o.ACcodigo and do.Ecodigo=o.Ecodigo
                </cfif>
                <!------------------------------->
				left outer join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
				left outer join CMCompradores c on a.Ecodigo = c.Ecodigo and a.CMCid = c.CMCid
				left outer join Retenciones d on a.Ecodigo = d.Ecodigo and a.Rcodigo = d.Rcodigo
				left outer join SNegocios e on a.Ecodigo = e.Ecodigo and a.SNcodigo = e.SNcodigo
				left outer join CMTipoOrden f on a.Ecodigo =f.Ecodigo and a.CMTOcodigo = f.CMTOcodigo
			where a.Ecodigo = #Arguments.Ecodigo#
				<!----Modificado en 2P el 22 de setiembre del 2005 (Para que los usuarios autorizados por un comprador
						autorizador de OC de contratos pueda cancelar OC's que le pertenecen a el autorizador
				and a.CMCid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comprador#">
				----->
				and a.CMCid in (#arguments.comprador#)
				and a.EOestado = 10
                <cfif Arguments.CancelacionP eq 2 and isdefined("Arguments.Filtro_EOidorden1") and len(trim(Arguments.Filtro_EOidorden1))>
            		and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOidorden1#">
                    and (do.DOcantsurtida + coalesce(do.DOcantcancel,0)) <> do.DOcantidad
                 <cfelse>
                 	and exists (
                                        select 1
                                        from DOrdenCM docm
                                        where docm.EOidorden = a.EOidorden
                                            and docm.Ecodigo = a.Ecodigo
                                            and docm.DOcantsurtida < docm.DOcantidad
										)
                 </cfif>

			<cfif isdefined("Arguments.Filtro_EOnumero") and len(trim(Arguments.Filtro_EOnumero)) and isdefined("Arguments.Filtro_EOnumero2") and len(trim(Arguments.Filtro_EOnumero2))>
				and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero2#">
			<cfelseif isdefined("Arguments.Filtro_EOnumero") and len(trim(Arguments.Filtro_EOnumero))>
				and a.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero#">
			<cfelseif isdefined("Arguments.Filtro_EOnumero2") and len(trim(Arguments.Filtro_EOnumero2))>
				and a.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero2#">
			</cfif>

			<cfif isdefined("Arguments.Filtro_Observaciones") and len(trim(Arguments.Filtro_Observaciones)) >
				and upper(Observaciones) like  upper('%#Arguments.Filtro_Observaciones#%')
			</cfif>
			<cfif isdefined("Arguments.Filtro_SNcodigo") and len(trim(Arguments.Filtro_SNcodigo)) >
				and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_SNcodigo#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_EOfecha") and len(trim(Arguments.Filtro_EOfecha))>
				and EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Filtro_EOfecha)#">
			</cfif>
            <!--- 22/10/2014 ERBG Cambio para evitar la cancelación de orden relacionada a un documento de CXP Inicia--->
            <cfif Arguments.CancelacionP eq 2>
                and not exists (
                            select 1 from DDocumentosCxP dc 
                            where dc.DOlinea=do.DOlinea and dc.Ecodigo=do.Ecodigo
                            )			
         	<cfelse>
                and not exists (
                            select 1
                            from DOrdenCM do
                            inner join DDocumentosCxP dc on do.DOlinea=dc.DOlinea and do.Ecodigo=dc.Ecodigo
                            where do.EOidorden = a.EOidorden
                                and do.Ecodigo = a.Ecodigo
                            )
            </cfif>
            <!--- 22/10/2014 FIN--->
			order by CMTOdescripcion, EOnumero
		</cfquery>
		<cfreturn data>
	</cffunction>

	<cffunction name="CM_getOCRechazadas" access="public" returntype="query" output="true">
		<cfargument name="Comprador" type="numeric" required="false" default="#session.compras.comprador#">
        <cfargument name="Ecodigo" type="numeric" required="false" default="#session.Ecodigo#">

        <cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery name="data" datasource="#session.dsn#">
			select
				a.EOidorden, a.Ecodigo, a.EOnumero, a.SNcodigo,
				a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo,
				a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot,
				a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo,
				a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo,
				a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado,
				b.Mnombre, c.CMCnombre, d.Rdescripcion, e.SNnombre, f.CMTOdescripcion, -a.EOidorden as inactivecol
				, '<a href=''##'' onclick=''javascript:document.lista.nosubmit=true;location.href=&quot;/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?NRP='#_Cat#<cf_dbfunction name='to_char' args='a.NRP'>#_Cat#'&quot;''><img src=''/cfmx/sif/imagenes/findsmall.gif'' border=''0''></a>' as findimg
				, 'ordenCompraRechazada.cfm' as action
			from EOrdenCM a
				left outer join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
				left outer join CMCompradores c on a.Ecodigo = c.Ecodigo and a.CMCid = c.CMCid
				left outer join Retenciones d on a.Ecodigo = d.Ecodigo and a.Rcodigo = d.Rcodigo
				left outer join SNegocios e on a.Ecodigo = e.Ecodigo and a.SNcodigo = e.SNcodigo
				left outer join CMTipoOrden f on a.Ecodigo =f.Ecodigo and a.CMTOcodigo = f.CMTOcodigo
			where a.Ecodigo = #Arguments.Ecodigo#
				and a.CMCid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comprador#">
				and a.EOestado = -10

			<cfif isdefined("Arguments.Filtro_EOnumero") and len(trim(Arguments.Filtro_EOnumero)) and isdefined("Arguments.Filtro_EOnumero2") and len(trim(Arguments.Filtro_EOnumero2))>
				and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero2#">
			<cfelseif isdefined("Arguments.Filtro_EOnumero") and len(trim(Arguments.Filtro_EOnumero))>
				and a.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero#">
			<cfelseif isdefined("Arguments.Filtro_EOnumero2") and len(trim(Arguments.Filtro_EOnumero2))>
				and a.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_EOnumero2#">
			</cfif>

			<cfif isdefined("Arguments.Filtro_Observaciones") and len(trim(Arguments.Filtro_Observaciones)) >
				and upper(Observaciones) like  upper('%#Arguments.Filtro_Observaciones#%')
			</cfif>
			<cfif isdefined("Arguments.Filtro_SNcodigo") and len(trim(Arguments.Filtro_SNcodigo)) >
				and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Filtro_SNcodigo#">
			</cfif>
			<cfif isdefined("Arguments.Filtro_EOfecha") and len(trim(Arguments.Filtro_EOfecha))>
				and EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.Filtro_EOfecha)#">
			</cfif>

			order by CMTOdescripcion, EOnumero
		</cfquery>
		<cfreturn data>
	</cffunction>
	</cfcomponent>

