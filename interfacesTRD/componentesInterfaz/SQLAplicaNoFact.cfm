<!--- Archivo    :  SQLAplicaNoFact.cfm --->
<cfsetting requesttimeout="600">
<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">
<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfquery datasource="sifinterfaces">
if object_id('##ID10Borrar') is not null
	drop table ##ID10Borrar
</cfquery>

<cfquery datasource="sifinterfaces">
 create table ##ID10Borrar(
 ID int not null,
 Consecutivo int not null
 )
</cfquery>

<!--- Cambio realizado por Luis A. Bolaños 16/01/07 --->
<!--- Cambio para Agregar Neteo de Nofact por Orden Comercial --->
<!--- Se genera el query de encabezados a Agrupar los documentos --->
<cfif ModoA EQ 2>
	<cfquery name="rsNoFactE" datasource="sifinterfaces">
		select distinct Documento,trade_num,acct_num,tipo_transaccion,tipo_modulo,
			min(price_curr_code) as Moneda,min(title_tran_date) as Fecha
		from nofactProdPMI a1
		where MensajeError is null
		and sessionid=#session.monitoreo.sessionid#
		group by sessionid,Documento
	</cfquery>
<cfelse>
	<cfquery name="rsNoFactE" datasource="sifinterfaces">
		select distinct Documento,trade_num,acct_num,tipo_transaccion,tipo_modulo,
			min(price_curr_code) as Moneda,min(title_tran_date) as Fecha
		from nofactProdPMI a1
		where not Exists (Select 1 from nofactProdPMI a2
							 where a1.Documento = a2.Documento
							 and a2.sessionid=a1.sessionid
							 and a2.MensajeError is not null)
		and sessionid=#session.monitoreo.sessionid#
		group by sessionid,Documento
	</cfquery>
</cfif>
<cfif rsNoFactE.recordcount GT 0>
<cfloop query="rsNoFactE">
	<cfset LvarID = 0>
	<cfset LvarControlDocto = true>
	<cfset varDocumento = rsNoFactE.Documento>
	<cfset ws_tipo_transaccion = rsNoFactE.tipo_transaccion>
	<cfset ws_tipo_modulo = rsNoFactE.tipo_modulo>
	<cfset ws_Moneda = rsNoFactE.Moneda>
	<cfset ws_Fecha = rsNoFactE.Fecha>
	<cfset ws_trade = rsNoFactE.trade_num>
	<cfset ws_Socio = rsNoFactE.acct_num>
	<cfquery name="rsNoFact" datasource="sifinterfaces">
		select *
		from #session.Dsource#nofactProdPMI a1
		where a1.Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocumento#">
		and a1.sessionid=#session.monitoreo.sessionid#
		and MensajeError is null
		order by a1.acct_ref_num, a1.cmdty_code
	</cfquery>

	<!--- se graban la tabla IE10 y la tabla ID10    --->
	<cftransaction>
	<cfloop query="rsNoFact">
		
		<cfset LvarAlm_trade_num = rsNoFact.ta_trade_num>
		<cfset LvarAlm_order_num = rsNoFact.ta_order_num>
		<cfset LvarAlm_item_num = rsNoFact.ta_item_num>
		<cfset LvarAlm_creation_date = rsNoFact.ta_creation_date>
		<cfset LvarAid = rsNoFact.Aid>

		<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
		<cfset LvarConceptoCompra = "00">
		<cfset LvarCuentaFinanciera = "">
	
		<cfset LvarOCtipoIC = "C">
		<cfset LvarAlmacen = "">
		<cfif rsNoFact.p_s_ind EQ 'P'>
			<cfset LvarTransporte = "#rsNoFact.acct_ref_num#">
		</cfif>
		<cfset LvarSocioAlloc = 0>
		<cfset LvarOrdenAlloc = "">
		<cfset LvarPorcentaje= 100>
	
		<cfif rsNoFact.ta_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = #rsNoFact.ta_acct_num#>
			<cfif rsNofact.p_s_ind EQ 'S'>
				<cfset LvarTransporte = "#rsNofact.ta_acct_ref_num#">
			</cfif>
		</cfif>
		<cfif rsNoFact.ta_order_type_code EQ 'STORAGE'>
			<cfset LvarAlmacen = "#rsNoFact.ta_acct_ref_num#">
			<cfset LvarSocioAlloc = rsNoFact.ta_acct_num>
			<!--- Solo si es Venta pone el Almacen como transporte --->
			<cfif rsNofact.p_s_ind EQ 'S'>
				<cfset LvarTransporte = "#rsNofact.ta_acct_ref_num#">
			</cfif>
		</cfif>
		<cfif rsNoFact.ta_order_type_code EQ 'TRANSPRT'>
			<cfset LvarTransporte = rsNoFact.ta_acct_ref_num>
			<cfif rsNoFact.tt_order_type_code EQ 'PHYSICAL'>
				<cfset LvarOCtipoIC = "C">
				<cfset LvarSocioAlloc = rsNoFact.tt_acct_num>
			</cfif>
			<cfif rsNoFact.tt_order_type_code EQ 'STORAGE'>
				<cfset LvarAlmacen = rsNoFact.tt_acct_ref_num>
				<cfset LvarSocioAlloc = rsNoFact.tt_acct_num>
			</cfif>
		</cfif>

		<cfset LvarOCVid = 0>
		<cfset LvarTipoVenta= "">
		<cfif rsNoFact.p_s_ind EQ 'S'>
			<!--- tipo de venta  --->
			<cfif len(LvarAlmacen) GT 0>
				<cfset LvarOCtipoIC = "V">
				<cfset LvarTipoVenta= "#Lvaralmacen#">    <!--- ES UN ALMACEN  --->
			<cfelse>
				<cfif Len(rsNoFact.AllocSNid) GT 0>
					<cfif len(rsNoFact.SNCDid_3) GT 0>
						<cfset LvarTipoVenta= "002">    <!--- ES INTERCOMPAÑIA  --->
					<cfelse>
						<cfif len(rsNoFact.SNCDid_4) GT 0>
							<cfif len(rsNoFact.SNCDid_5) GT 0>
								<cfset LvarTipoVenta= "004">    <!--- ES TERCERO NACIONAL  --->
							<cfelse>
								<cfif len(rsNoFact.SNCDid_6) GT 0>
									<cfif len(rsNoFact.SNCDid_A) GT 0>
										<cfset LvarTipoVenta= "001">    <!--- ES VENTA AL EXTERIOR  --->
									<cfelse>
										<cfset LvarTipoVenta= "003">    <!--- ES VENTA A TERCEROS  --->
									</cfif>
								</cfif>
							</cfif>
						</cfif>			
					</cfif>
				</cfif>
			</cfif>
			<cfset LvarOCVid = 0>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select OCVid, OCVcodigo, OCVdescripcion
				from OCtipoVenta_view
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTipoVenta#">
			</cfquery>
			<cfif rsVerifica.recordcount GT 0>
				<cfset LvarOCVid = rsVerifica.OCVid>
			</cfif> 
		</cfif>
		<!--- decodifica campo alloc_type_code  --->	
		<cfif rsNoFact.alloc_type_code EQ "W">
			<cfset LvarOCTtipo = "B">
		<cfelseif rsNoFact.alloc_type_code EQ "R">
			<cfset LvarOCTtipo = "F">
		<cfelse>
			<cfset LvarOCTtipo = "T">
		</cfif>

		<cfset ws_c_unidad = rsNoFact.contr_qty_uom_code>
		<cfset ws_f_Importe = rsNoFact.montocosto>
		<cfset ws_f_precio = rsNoFact.avg_price>
		<cfset ws_f_volumen = 0>
		<cfif ws_f_precio NEQ 0>
			<cfset ws_f_volumen = ws_f_Importe / ws_f_precio>
		</cfif>

		<!--- Conversión a unidades del Artículo --->
		<cfif "#Rtrim(rsNoFact.UcodigoArt)#" NEQ "#Rtrim(rsNoFact.contr_qty_uom_code)#">
			<cfif len(rsNoFact.cuafactor) GT 0>
				<cfset ws_f_volumen = rsNoFact.CUAfactor * ws_f_volumen>
				<cfif ws_f_volumen EQ 0>
					<cfset ws_f_volumen = 1>
				</cfif>
				<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
				<cfset ws_c_unidad = rsNoFact.UcodigoArt>
			</cfif>
		</cfif>
	
		<cfif ISNUMERIC(rsNoFact.bl_ticket_num)>
			<cfset Lvarbl_ticket_num=rsNoFact.bl_ticket_num>
		<cfelse>
			<cfset Lvarbl_ticket_num=0>
		</cfif>
	
		<cfif ISDATE(rsNoFact.bl_date)>
			<cfset Lvarbl_date=rsNoFact.bl_date>
		<cfelse>
			<cfset Lvarbl_date=rsNoFact.title_tran_date>
		</cfif>
	
		<cfif ISDATE(rsNoFact.title_tran_date)>
			<cfset LvarTitle_tran_date=rsNoFact.title_tran_date>
		<cfelse>
			<cfset LvarTitle_tran_date=rsNoFact.dt_fecha_recibo>
		</cfif>

		<!--- el Folio ya no se usa se usa el documento de varDocumento
		<!--- se determina el codigo de transaccion y el folio del documento  --->
		<cfset ws_folio = "#rsNoFact.acct_ref_num##rsNoFact.tipoconsulta##rsNoFact.PosNeg##session.FechaFolio#">--->

		<!--- Tipo de transaccion es varTipoTransaccion
		<cfif rsNoFact.PosNeg EQ "N">
			<cfset ws_tipo_transaccion = "DC">
			<cfset ws_f_importe = abs(ws_f_importe)>
		<cfelse>
			<cfset ws_tipo_transaccion = "EC">
		</cfif>--->
		
		<!--- El tipo modulo que manda ahora es ws_tipo_modulo
		<cfif rsNoFact.p_s_ind EQ "P">
			<cfset ws_tipo_modulo = "CP">
			<cfset ws_tipoOD = "O">
		<cfelse>
			<cfset ws_tipo_modulo = "CC">
			<cfset ws_tipoOD = "D">
		</cfif>--->

		<cfif ws_tipo_modulo EQ "CP">
			<cfset ws_tipoOD = "O">
		<cfelse>
			<cfset ws_tipoOD = "D">
		</cfif>

		<!--- Verificar si cambia el folio, generar un nuevo IE10 --->
		<cfif LvarControlDocto>
			<cfset LvarControlDocto = false>
			<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
				select ID
				from IE10
				where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				  and NumeroSocio = '#ws_Socio#'
				  and Modulo = '#ws_tipo_modulo#'
				  and CodigoTransacion = '#ws_tipo_transaccion#'
				  and Documento = '#varDocumento#'
			</cfquery>

			<cfif rsVerificaIE10.recordcount GT 0>
				<cfabort showerror= "Intento de Insetrar Registro Duplicado !!! #rsnofact.Documento#">
				<cfset LvarID = rsVerifica.ID>
			<cfelse>
				<!--- Obtener el siguiente ID para procesar el registro --->
				<cfquery datasource="sifinterfaces">
					update IdProceso
					set Consecutivo = Consecutivo + 1			
				</cfquery>
				<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
					select Consecutivo
					from IdProceso
				</cfquery>
				<cfset LvarID = rsObtieneSigId.consecutivo>
			</cfif>
			<cfset LvarConsecutivoID10 = 0>
			<cfquery datasource="sifinterfaces">
				insert into IE10 (
					ID, EcodigoSDC, NumeroSocio, Modulo, 
					CodigoTransacion, Documento, Estado, 
					CodigoMoneda, 
					FechaDocumento, 
					FechaVencimiento, 
					Facturado, Origen, VoucherNo, CodigoConceptoServicio, 
					CodigoRetencion, CodigoOficina, CuentaFinanciera, 
					BMUsucodigo, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
					FechaTipoCambio, StatusProceso)
				values( 
					#LvarID#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
					'#ws_Socio#', '#ws_tipo_modulo#',
					'#ws_tipo_transaccion#', '#varDocumento#', ' ',
					'#ws_Moneda#', 
					<cfqueryparam cfsqltype="cf_sql_date" value="#ws_Fecha#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#ws_Fecha#">,
					'S', '#ws_tipo_modulo#', '#ws_trade#', null, 
					null, null, null,
					#session.usucodigo#, 0, null, null, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#ws_Fecha#">, 
					1)
			</cfquery>
		</cfif>

		<cfif LvarID GT 0>
			<!--- Verifica si existe un Detalle con el Producto actual --->
			<cfif rsNoFact.PosNeg EQ "N" AND ws_tipo_transaccion EQ "DC">
				<cfset ws_f_importe = abs(ws_f_importe)>
				<cfset ws_f_volumen = abs(ws_f_volumen)>
			</cfif>
			<cfif rsNoFact.PosNeg EQ "P" AND ws_tipo_transaccion EQ "DC">
				<cfset ws_f_importe = - ws_f_importe>
				<cfset ws_f_volumen = - ws_f_volumen>
			</cfif>
			<cfquery name="rsVerificaDetalle" datasource="sifinterfaces">
				select max(Consecutivo) as Consecutivo from ID10
				where ID = #LvarID#
				and CodigoItem = '#rsNoFact.cmdty_code#'
				and OCtransporte = '#LvarTransporte#'
			</cfquery>
			<cfif rsVerificaDetalle.Consecutivo NEQ "">
				<cfset LvarConsecutivoID10A = rsVerificaDetalle.Consecutivo>
				<cfquery name="rsActualiza" datasource="sifinterfaces">
					update ID10 set PrecioTotal = PrecioTotal + #numberformat(ws_f_importe,"9.99")#,
						CantidadTotal = CantidadTotal + <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">,
						CantidadNeta = CantidadNeta + <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">
					where ID = #LvarID#
						and Consecutivo = #LvarConsecutivoID10A#	
						
					update ID10 set PrecioUnitario = 
					case when CantidadTotal != 0 then PrecioTotal / CantidadTotal else 0 end
					where ID = #LvarID#
						and Consecutivo = #LvarConsecutivoID10A#	
				</cfquery>
			<cfelse>	
				<cfset LvarConsecutivoID10 = LvarConsecutivoID10 + 1>
				<cfquery datasource="sifinterfaces">
					insert ID10 (
						ID, Consecutivo, TipoItem, CodigoItem, 
						NombreBarco, FechaHoraCarga, FechaHoraSalida, 
						PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
						CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
						TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
						ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
						BMUsucodigo, PrecioTotal, 
						CentroFuncional, CuentaFinancieraDet, 
						OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
					values(
						#LvarID#, #LvarConsecutivoID10#, 'O', '#rsNoFact.cmdty_code#',
						'#rsNoFact.transportation#',
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.load_compl_date#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.nor_date#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">, 
						'#ws_c_unidad#',
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
						'#rsNoFact.del_term_code#', '#Lvarbl_ticket_num#',
						<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
						null, '#rsNoFact.acct_ref_num#', null, null,
						0.00, <cfif rsNoFact.p_s_ind EQ 'S' AND len(LvarAlmacen) GT 0> '#LvarAlmacen#' <cfelse> null </cfif>, null,
						#session.usucodigo#, #numberformat(ws_f_importe,"9.99")#,
						null, null,
						'#LvarOCTtipo#', '#LvarTransporte#', '#rsNoFact.acct_ref_num#', '#LvarConceptoCompra#'
						)
				</cfquery>
			</cfif>
		</cfif>

		<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
		<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
		<cfset ws_f_importe = abs(ws_f_importe)>
		<cfset ws_f_volumen = abs(ws_f_volumen)>
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select OCid
			from OCordenComercial_view
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNoFact.acct_ref_num#">
		</cfquery>
	
		<cfif rsVerifica.recordcount EQ 0>
			<cfset vOCid = 0>
		<cfelse>
			<cfset vOCid = rsVerifica.OCid>
			<cfif rsNoFact.p_s_ind EQ 'S' and LvarOCVid GT 0>
				<cfquery datasource="sifinterfaces">
					update OCordenComercial_view set
						OCVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOCVid#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNoFact.acct_ref_num#">
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif vOCid EQ 0>
			<cfquery datasource="sifinterfaces">
				insert OCordenComercial_view
					(OCtipoOD, OCtipoIC, Ecodigo,
					 SNid, OCcontrato,
					 OCfecha,
					 Mcodigo,
					 OCVid,
					 OCestado, OCmodulo, OCincoterm, OCtrade_num, OCorder_num,
					 OCfechaAllocationDefault, 
					 OCfechaPropiedadDefault,
					 BMUsucodigo)
				values (
					'#ws_tipoOD#', '#LvarOCtipoIC#', #session.Ecodigo#,
					 #rsNoFact.SNid#, '#rsNoFact.acct_ref_num#',
					 <cfif isdate(rsNoFact.creation_date)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.creation_date#">,
					 <cfelse>
						null,
					 </cfif>
					 #rsNoFact.Mcodigo#,
					 <cfif LvarOCVid GT 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarOCVid#">,
					 <cfelse>
						null,
					 </cfif>
					 'A','#ws_tipo_modulo#',
					 '#rsNoFact.del_term_code#',
					 <cfif isnumeric(rsNoFact.trade_num)>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.trade_num#">,
					 <cfelse>
						null,
					 </cfif>
					 <cfif isnumeric(rsNoFact.order_num)>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.order_num#">,
					 <cfelse>
						null,
					 </cfif>
					 <cfif isdate(rsNoFact.fecha_allocation)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.fecha_allocation#">,
					 <cfelse>
						null,
					 </cfif>
					 <cfif isdate(rsNoFact.title_tran_date)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">,
					 <cfelse>
						null,
					 </cfif>
					#session.usucodigo#
					)
			</cfquery>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select MAX(OCid) as valorID
				from OCordenComercial_view
			</cfquery>
			<cfset vOCid = rsVerifica.valorID>
		</cfif>
	
		<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select *
			from OCordenProducto_view
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="sifinterfaces">
				insert INTO OCordenProducto_view
					(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
					 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">,
				  <cfqueryparam cfsqltype="cf_sql_smallint" value=1>,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#ws_c_unidad#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=0>,
				  null,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfif ws_tipo_transaccion EQ "DC">
				<cfset LvarCantidad = rsVerifica.OCPcantidad - ws_f_volumen>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal - (ws_f_importe)) / abs(LvarCantidad)>
				<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal - ws_f_importe>
			<cfelse>
				<cfset LvarCantidad = rsVerifica.OCPcantidad + ws_f_volumen>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / LvarCantidad>
				<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + ws_f_importe>
			</cfif>
			<cfquery datasource="sifinterfaces">
				update OCordenProducto_view set
					OCPcantidad=#LvarCantidad#,
					OCPprecioUnitario=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioUnitario,"9.99")#">,
					OCPprecioTotal=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">
				where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
			</cfquery>
		</cfif>
		
		<!---  revisa si existe el Transporte en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
		select OCTid
			from OCtransporte_view
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">
		</cfquery>
	
		<cfif rsVerifica.recordcount EQ 0>
			<cfset vOCTid = 0>
		<cfelse>
			<cfset vOCTid = rsVerifica.OCTid>
		</cfif>
	
		<cfif vOCTid EQ 0>
			<cfquery name="query" datasource="sifinterfaces">
				insert INTO OCtransporte_view
					(Ecodigo, OCTtipo, OCTtransporte, OCTestado, OCTfechaPartida, OCTobservaciones,
					 OCTvehiculo, OCTruta, OCTfechaLlegada, OCTPnumeroBOLdefault, OCTPfechaBOLdefault, 
					 BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#LvarOCTtipo#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTransporte#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
				  <cfif isdate(rsNoFact.load_compl_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.load_compl_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  null,
				  null,
				  null,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.nor_date#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select MAX(OCTid) as valorID
				from OCtransporte_view
			</cfquery>
			<cfset vOCTid = rsVerifica.valorID>
		<cfelse>
				<!--- Se agrega este proceso para corregir el error en tipo de transporte cuando este ya existe 
				en la estructurade ordenes comerciales 
				<cfquery name="OCTransTipo" datasource="sifinterfaces">
				 	select MAX(OCTtipo) as OCTtipo
					from OCtransporte_view
					where OCTtransporte = '#LvarTransporte#'
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				</cfquery>
				<cfset VarOCTtipo = OCTransTipo.OCTtipo>
				<cfquery name="OCTransTipo" datasource="sifinterfaces">
				 	update ID10
					set OCtransporteTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOCTtipo#">
					where OCtransporte = '#LvarTransporte#'
					and ID = #LvarID#
				</cfquery> --->
		</cfif>
	
		<!---  revisa si existe el ProductoTransito en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select OCTid
			from OCproductoTransito_view
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="sifinterfaces">
				insert OCproductoTransito_view
					(OCTid, Aid, Ecodigo, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal,
					 OCPTsalidasCantidad, OCPTsalidasCostoTotal, BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
			</cfquery>
		</cfif>
	
		<!---  revisa si existe el TransporteProducto en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select *
			from OCtransporteProducto_view
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
		</cfquery>
	
		<cfif rsVerifica.recordcount EQ 0>
			<cfquery name="query" datasource="sifinterfaces">
				insert INTO OCtransporteProducto_view
					(OCTid, OCid, Aid, Ecodigo, OCPTestado, OCtipoOD, OCTPnumeroBOL, OCTPfechaBOL,
					 OCTPcontrato, OCTPfechaAllocation, OCTPfechaPropiedad, OCTPcantidadTeorica,
					 OCTPprecioUniTeorico, OCTPprecioTotTeorico, OCTPcantidadReal, OCTPprecioReal,
					 BMUsucodigo)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="F">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="#ws_tipoOD#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
				  <cfif isdate(Lvarbl_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">,
				  <cfif isdate(rsNoFact.fecha_allocation)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.fecha_allocation#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  </cfif>
				  <cfif isdate(rsNoFact.title_tran_date)>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.title_tran_date#">,
				  <cfelse>
					  <cfqueryparam cfsqltype="cf_sql_date" value="#rsNoFact.dt_fecha_recibo#">,
				  </cfif>
				  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
				  <cfqueryparam cfsqltype="cf_sql_float" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		<cfelse>
			<cfif ws_tipo_transaccion EQ "DC">
				<cfset LvarCantidad = rsVerifica.OCTPcantidadTeorica - ws_f_volumen>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico - (ws_f_importe)) / abs(LvarCantidad)>
				<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico - ws_f_importe>
			<cfelse>
				<cfset LvarCantidad = (rsVerifica.OCTPprecioTotTeorico + ws_f_volumen)>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico + ws_f_importe) / LvarCantidad>
				<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico + ws_f_importe>
			</cfif>
			<cfquery datasource="sifinterfaces">
				update OCtransporteProducto_view set
					OCTPcantidadTeorica=#LvarCantidad#,
					OCTPprecioUniTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioUnitario,"9.99")#">,
					OCTPprecioTotTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">
				where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
				  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
			</cfquery>
		</cfif>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

		<!---  Si el Origen de la Orden de Compra es un Almacén, se graba una Orden  de Inventario   --->		
		<cfif Len(LvarAlmacen) GT 0 and rsNoFact.p_s_ind EQ 'P'>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select OCid
				from OCordenComercial_view
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAlmacen#">
			</cfquery>
			
			<cfif rsVerifica.recordcount EQ 0>
				<cfset vOCid = 0>
			<cfelse>
				<cfset vOCid = rsVerifica.OCid>
			</cfif>
	
			<cfif vOCid EQ 0>
				<cfquery datasource="sifinterfaces">
					insert OCordenComercial_view
						(OCtipoOD, OCtipoIC, Ecodigo,
						 SNid, OCcontrato,
						 OCfecha,
						 Mcodigo,
						 OCVid,
						 OCestado, OCmodulo, OCincoterm, OCtrade_num, OCorder_num,
						 OCfechaAllocationDefault, 
						 OCfechaPropiedadDefault,
						 BMUsucodigo)
					values (
						'D', 'I', #session.Ecodigo#,
						 #rsNoFact.SNid#, '#LvarAlmacen#',
						 <cfif isdate(LvarAlm_creation_date)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvarAlm_creation_date#">,
						 <cfelse>
							null,
						 </cfif>
						 #rsnofact.Mcodigo#,
						 null,
						 'A','CP',
						 null,
						 <cfif isnumeric(LvarAlm_trade_num)>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_trade_num#">,
						 <cfelse>
							null,
						 </cfif>
						 <cfif isnumeric(LvarAlm_order_num)>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_order_num#">,
						 <cfelse>
							null,
						 </cfif>
							null,
							null,
						#session.usucodigo#
						)
				</cfquery>
				<cfquery name="rsVerifica" datasource="sifinterfaces">
					select MAX(OCid) as valorID
					from OCordenComercial_view
				</cfquery>
				<cfset vOCid = rsVerifica.valorID>
			</cfif>

			<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select * 
				from OCordenProducto_view
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
			
			<cfif rsVerifica.recordcount EQ 0>
				<cfquery name="query" datasource="sifinterfaces">
					insert INTO OCordenProducto_view
						(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
						 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
					values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
					  <cfqueryparam cfsqltype="cf_sql_smallint" value=1>,
					  <cfqueryparam cfsqltype="cf_sql_char" value="#ws_c_unidad#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value=0>,
					  null,
					  null,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
				</cfquery>
			<cfelse>	
				<cfif ws_tipo_transaccion EQ "DC">
					<cfset LvarCantidad = rsVerifica.OCPcantidad - ws_f_volumen>
					<cfif LvarCantidad EQ 0>
						<cfset LvarCantidad = 1>
					</cfif>
					<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal - (ws_f_importe)) / abs(LvarCantidad)>
					<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal - ws_f_importe>
				<cfelse>	
					<cfset LvarCantidad = rsVerifica.OCPcantidad + ws_f_volumen>
					<cfif LvarCantidad EQ 0>
						<cfset LvarCantidad = 1>
					</cfif>
					<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / LvarCantidad>
					<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + ws_f_importe>
				</cfif>
				<cfquery datasource="sifinterfaces">
					update OCordenProducto_view set
						OCPcantidad=#LvarCantidad#,
						OCPprecioUnitario=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioUnitario,"9.99")#">,
						OCPprecioTotal=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">
					where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
					  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>

<!--- Se elimina el manejo de Complemento en NOFACT por cambio de diseño 04/04/08 realizado por:ABG --->
<!---
		<!--- Cambio para realizar el Complemento de los NoFact 12/02/08 realizado por ABG --->
		<!---Una vez que termina se agrega esta rutina para verificar si es necesario --->
		<!---Dividir los detalles del NoFact entre tipo O y tipo S --->
		<cfif LvarID GT 0>
			<cfquery name="rsComplementoID10" datasource="sifinterfaces">
				select * from ID10 
				where ID = #LvarID#
			</cfquery>
			<cfif rsComplementoID10.recordcount GT 0>
			<cfloop query="rsComplementoID10">
				
				<!--- Obtiene el valor de OCid --->
				<cfquery name="rsOCid" datasource="sifinterfaces">
					select OCid 
					from #minisifdb#..OCordenComercial 
					where OCcontrato = '#rsComplementoID10.OCcontrato#'
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset MvarOCid = rsOCid.OCid>
				
				<!--- Obtiene el valor de OCTid --->
				<cfquery name="rsOCTid" datasource="sifinterfaces">
					select OCTid 
					from #minisifdb#..OCtransporte
					where OCTtransporte = '#rsComplementoID10.OCtransporte#'
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset MvarOCTid = rsOCTid.OCTid>
				
				<!---Verifica de que modulo es el Documento --->
				<cfquery name="rsModulo" datasource="sifinterfaces">
					select Modulo, CodigoTransacion 
					from IE10 
					where ID = #LvarID#
				</cfquery>
				
				<!--- Obtiene el Mcodigo --->
				<cfquery name="rsMoneda" datasource="sifinterfaces">
					select distinct Mcodigo
					from #minisifdb#..Monedas m inner join IE10 e on m.Miso4217 = e.CodigoMoneda
					where e.ID = #LvarID#
					and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset varCodigoMoneda = rsMoneda.Mcodigo>
				
				<!--- Verifica si la transaccion es Positiva o Negativa --->
				<cfif trim(rsModulo.Modulo) EQ 'CC'>
					<cfquery name="rsVerifica" datasource="sifinterfaces">
						select CCTtipo 
						from #minisifdb#..CCTransacciones 
						where CCTcodigo = '#trim(rsModulo.CodigoTransacion)#'
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cfif trim(rsVerifica.CCTtipo) EQ "C">
						<cfset varTipoTransaccion = "DC">
					<cfelse>
						<cfset varTipoTransaccion = "EC">
					</cfif>
				<cfelse>
					<cfquery name="rsVerifica" datasource="sifinterfaces">
						select CPTtipo 
						from #minisifdb#..CPTransacciones 
						where CPTcodigoext = '#trim(rsModulo.CodigoTransacion)#'
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cfif trim(rsVerifica.CPTtipo) EQ "C">
						<cfset varTipoTransaccion = "EC">
					<cfelse>
						<cfset varTipoTransaccion = "DC">
					</cfif>
				</cfif>
				
				<!---Verifica signo de Total Costo y Volumen (Verificar si no es mejor hacerlo con Tcosto)--->
				<cfif varTipoTransaccion EQ "DC">
					<cfset varPrecioTotal = - rsComplementoID10.PrecioTotal>
					<cfset varCantidadTotal = - rsComplementoID10.CantidadTotal>
				<cfelse>
					<cfset varPrecioTotal = rsComplementoID10.PrecioTotal>
					<cfset varCantidadTotal = rsComplementoID10.CantidadTotal>
				</cfif>
				
				<!--- Verifica si existen documentos con Saldo --->								
				<cfif trim(rsModulo.Modulo) EQ 'CC'>
					<cfquery name="rsDocumentos" datasource="sifinterfaces">
						select distinct e.Ddocumento, e.CCTcodigo as CodigoTran, e.SNcodigo, 
								e.Dtotal, d.OCid,0 as IDDoc
						from #minisifdb#..Documentos e inner join #minisifdb#..HDDocumentos d 
								on d.OCid = #MvarOCid# and e.CCTcodigo = d.CCTcodigo 
								and e.Ddocumento = d.Ddocumento
								and e.CCTcodigo in ('EC','DC') 
								and e.Ecodigo = d.Ecodigo
								and e.Dsaldo > 0
								and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and e.Mcodigo = #varCodigoMoneda#
					</cfquery>
				<cfelse>
					<cfquery name="rsDocumentos" datasource="sifinterfaces">
						select distinct e.Ddocumento, e.CPTcodigo as CodigoTran, e.SNcodigo, 
								e.Dtotal, d.OCid,e.IDdocumento as IDDoc
						from #minisifdb#..EDocumentosCP e inner join #minisifdb#..HDDocumentosCP d 
								on d.OCid = #MvarOCid# and e.CPTcodigo = d.CPTcodigo 
								and e.Ddocumento = d.Ddocumento and e.SNcodigo = d.SNcodigo
								and e.CPTcodigo in ('EC','DC')
								and e.Ecodigo = d.Ecodigo
								and e.EDsaldo > 0
								and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and e.Mcodigo = #varCodigoMoneda#
					</cfquery>
				</cfif>
				<!--- Si existen Documentos se verificara si el monto y el volumen --->
				<!--- cambio para este NoFact, en caso de cambio se procede --->
				<cfif rsDocumentos.recordcount GT 0>
					<!--- Obtiene el Aid del Producto --->
					<cfquery name="rsAidProd" datasource="sifinterfaces">
						select Aid 
						from #minisifdb#..Articulos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Acodigo = '#rsComplementoID10.CodigoItem#'
					</cfquery>
					<cfset varAid = rsAidProd.Aid>
					<!--- Obtiene Suma de Costos y de Volumenes para el producto --->
					<!--- La suma se agrupa por producto-transporte--->
					<cfif trim(rsModulo.Modulo) EQ 'CC'>
						<cfquery name="rsCostoVolumen" datasource="sifinterfaces">
							select 
							sum(case when CCTcodigo = 'EC' then DDtotal else -DDtotal end) 
							as TCosto, 
							sum(case when CCTcodigo = 'EC' then DDcantidad else -DDcantidad end) 
							as TVolumen
							from #minisifdb#..HDDocumentos hd
							where OCid = #MvarOCid#
							and OCTid = #MvarOCTid#
							and exists (select 1 from #minisifdb#..Documentos
										where Ddocumento = hd.Ddocumento
										and CCTcodigo = hd.CCTcodigo
										and Ecodigo = hd.Ecodigo
										and Dsaldo > 0
										and Mcodigo = #varCodigoMoneda#)
							and DDcodartcon = #varAid#
							and CCTcodigo in ('EC','DC')
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and hd.DDtipo = 'O'
						</cfquery>
					<cfelse>
						<cfquery name="rsCostoVolumen" datasource="sifinterfaces">
							select 
							sum(case when CPTcodigo = 'EC' then DDtotallin else -DDtotallin end) 
							as TCosto, 
							sum(case when CPTcodigo = 'EC' then DDcantidad else -DDcantidad end) 
							as TVolumen
							from #minisifdb#..HDDocumentosCP hd 
							where OCid = #MvarOCid#
							and OCTid = #MvarOCTid#
							and exists (select 1 from #minisifdb#..EDocumentosCP
										where Ddocumento = hd.Ddocumento
										and CPTcodigo = hd.CPTcodigo
										and SNcodigo = hd.SNcodigo
										and Ecodigo = hd.Ecodigo
										and EDsaldo > 0
										and Mcodigo = #varCodigoMoneda#)
							and DDcoditem = #varAid#
							and CPTcodigo in ('EC','DC')
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and hd.DDtipo = 'O'
							and IDdocumento > 0
						</cfquery>
					</cfif>
					<cfif rsCostoVolumen.TCosto NEQ "">
						<cfset varTCosto = rsCostoVolumen.TCosto>
					<cfelse>
						<cfset varTCosto = 0>
					</cfif>
					<cfif rsCostoVolumen.TVolumen NEQ "">
						<cfset varTVolumen = rsCostoVolumen.TVolumen>
					<cfelse>
						<cfset varTVolumen = 0>
					</cfif>
					<!---Busca Si hay que sumar Montos Reversados --->
					<cfquery name="rsCostoVolumen" datasource="sifinterfaces">
						select distinct a.OCid,a.OCTid,a.Modulo,a.Producto,a.DifCosto, a.DifVolumen 
						from DocumentoReversion a 
						where a.OCid = #MvarOCid#
						and a.OCTid = #MvarOCTid#
						and a.TipoReversa = 'B'
						and a.Modulo = '#trim(rsModulo.Modulo)#'
						and a.Procesado = 'S'
						and a.Producto = '#rsComplementoID10.CodigoItem#'
						and a.Mcodigo = #varCodigoMoneda#
						and a.TipoMovimiento like 'NF%'
						and IDREV = (select max(IDREV) from DocumentoReversion 
										where OCid = #MvarOCid#
										and OCTid = #MvarOCTid#
										and TipoReversa = 'B'
										and Modulo = '#trim(rsModulo.Modulo)#'
										and Procesado = 'S' 
										and a.Producto = '#rsComplementoID10.CodigoItem#'
										and Mcodigo = #varCodigoMoneda#
										and TipoMovimiento like 'NF%'
										group by OCid,OCTid,Mcodigo)
						and not exists (select 1 from DocumentoReversion
										where OCid = #MvarOCid#
										and Modulo = '#trim(rsModulo.Modulo)#'
										and Procesado = 'S'
										and TipoMovimiento not like 'NF%' 
										and IDREV > a.IDREV) 
					</cfquery>	
					<cfif rsCostoVolumen.recordcount GT 0 and rsCostoVolumen.Producto EQ rsComplementoID10.CodigoItem>
						<cfset varRCosto = rsCostoVolumen.DifCosto>
						<cfset varRVolumen = rsCostoVolumen.DifVolumen>
					<cfelse>
						<cfset varRCosto = 0>
						<cfset varRVolumen = 0>
					</cfif>
					
					<!--- Se verifica si se encuentran diferencias con el NoFact Actual --->
					<cfif abs((varTCosto + varRCosto) - varPrecioTotal) GT .009 OR abs((varTVolumen + varRVolumen) - varCantidadTotal) GT .009>
						<cfset varComCosto = varPrecioTotal - (varTCosto + varRCosto)>
						<cfset varComVolumen = varCantidadTotal - (varTVolumen + varRVolumen)>
						<cfif abs(varComCosto) LT .01>
							<cfset varComCosto = 0>
						</cfif>
						<cfif abs(varComVolumen) LT .01>
							<cfset varComVolumen = 0>
						</cfif>
						<cfset varModulo = trim(rsModulo.Modulo)>
						<cfif varModulo EQ 'CC'>
							<cfset varConceptoS = "CV-001">
						<cfelse>
							<cfset varConceptoS = "CV-002">
						</cfif>
						<cfset varRProducto = rsComplementoID10.CodigoItem>
						<!---Busca el Monto Total para la OCid Producto --->
						<cfif trim(rsModulo.Modulo) EQ 'CC'>
							<cfquery name="rsOriCostoVolumen" datasource="sifinterfaces">
								select 
								sum(case when CCTcodigo = 'EC' then DDtotal else -DDtotal end) 
								as TCosto, 
								sum(case when CCTcodigo = 'EC' then DDcantidad else -DDcantidad end) 
								as TVolumen
								from #minisifdb#..HDDocumentos hd
								where OCid = #MvarOCid#
								and exists (select 1 from #minisifdb#..Documentos
											where Ddocumento = hd.Ddocumento
											and CCTcodigo = hd.CCTcodigo
											and Ecodigo = hd.Ecodigo
											and Dsaldo > 0
											and Mcodigo = #varCodigoMoneda#)
								and DDcodartcon = #varAid#
								and CCTcodigo in ('EC','DC')
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and hd.DDtipo = 'O'
							</cfquery>
						<cfelse>
							<cfquery name="rsOriCostoVolumen" datasource="sifinterfaces">
								select 
								sum(case when CPTcodigo = 'EC' then DDtotallin else -DDtotallin end) 
								as TCosto, 
								sum(case when CPTcodigo = 'EC' then DDcantidad else -DDcantidad end) 
								as TVolumen
								from #minisifdb#..HDDocumentosCP hd 
								where OCid = #MvarOCid#
								and exists (select 1 from #minisifdb#..EDocumentosCP
											where Ddocumento = hd.Ddocumento
											and CPTcodigo = hd.CPTcodigo
											and SNcodigo = hd.SNcodigo
											and Ecodigo = hd.Ecodigo
											and EDsaldo > 0
											and Mcodigo = #varCodigoMoneda#)
								and DDcoditem = #varAid#
								and CPTcodigo in ('EC','DC')
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and hd.DDtipo = 'O'
								and IDdocumento > 0
							</cfquery>
						</cfif>
						<cfset varOriCosto = rsOriCostoVolumen.TCosto>
						<cfset varOriVolumen = rsOriCostoVolumen.TVolumen>
						
						<!---Busca Si hay que sumar Montos Reversados Para este OCid--->
						<cfquery name="rsCostoVolumen" datasource="sifinterfaces">
							select distinct a.OCid,a.OCTid,a.Modulo,a.Producto,a.OriCosto, a.OriVolumen 
							from DocumentoReversion a 
							where a.OCid = #MvarOCid#
							and a.TipoReversa = 'B'
							and a.Modulo = '#trim(rsModulo.Modulo)#'
							and a.Procesado = 'S'
							and a.Producto = '#rsComplementoID10.CodigoItem#'
							and a.Mcodigo = #varCodigoMoneda#
							and a.TipoMovimiento like 'NF%'
							and IDREV = (select max(IDREV) from DocumentoReversion 
											where OCid = #MvarOCid#
											and TipoReversa = 'B'
											and Modulo = '#rsModulo.Modulo#'
											and Procesado = 'S' 
											and a.Producto = '#rsComplementoID10.CodigoItem#'
											and Mcodigo = #varCodigoMoneda#
											and TipoMovimiento like 'NF%'
											group by OCid,OCTid,Mcodigo)
							and not exists (select 1 from DocumentoReversion
											where OCid = #MvarOCid#
											and Modulo = '#trim(rsModulo.Modulo)#'
											and Procesado = 'S' 
											and TipoMovimiento not like 'NF%'
											and IDREV > a.IDREV)
						</cfquery>
						<cfif rsCostoVolumen.recordcount GT 0 and rsCostoVolumen.Producto EQ rsComplementoID10.CodigoItem>
							<cfset varOriCosto = varOriCosto + rsCostoVolumen.OriCosto>
							<cfset varOriVolumen = varOriVolumen + rsCostoVolumen.OriVolumen>
						</cfif>
						
						<cfset varReversa = true>
						<!--- Verifica que el NOFACT actual no sea de naturaleza Contraria al nuevo --->
						<cfif ((varTCosto + varRCosto) LT 0 AND rsModulo.CodigoTransacion EQ "EC") OR ((varTCosto + varRCosto) GT 0 AND rsModulo.CodigoTransacion EQ "DC")>
							<cfset varTipoMovimiento = 'NF2'>
							<!--- Pone a 0 todos los montos por que se trata de un nuevo NOFACT --->
							<cfset varTCosto = 0>
							<cfset varTVolumen = 0>
							<cfset varComCosto = 0>
							<cfset varComVolumen = 0>
							<cfset varReversa = false>
						<cfelse>
							<cfset varTipoMovimiento = 'NF1'>
						</cfif>
						
						<!---Verifica signo de Complemento (Verificar si no es mejor hacerlo con Tcosto)--->
						<cfif varTipoTransaccion EQ "DC">
							<cfset varComCosto = varComCosto * (-1)>
							<cfset varComVolumen = varComVolumen * (-1)>
						</cfif>
						<cfif varComCosto LT 0 OR varComVolumen LT 0>
							<cfset varTipoMovimiento = 'NF3'>
						</cfif>
						<cfloop query="rsDocumentos">
							<!--- Se elimina la logica para comprobar si se reversa por balanco u Origen
							ahora todo se reversa por balance 12/03/08 --->
							

							<!--- Se insertan registros en DocumentosReversión --->
							<cfquery datasource="sifinterfaces">
								insert DocumentoReversion (fecharegistro,sessionid,
									IDIE10,Modulo,Documento,CodigoTransaccion,SNcodigo,Producto,
									IDdocumento,Ecodigo,OriCosto,OriVolumen,DifCosto,
									DifVolumen,Mcodigo,TipoReversa, Procesado,OCid,OCTid,
									TipoMovimiento, ComplementoCosto, ComplementoVolumen)								
								values (getdate(), #session.monitoreo.sessionid#,
									#LvarID#,'#varModulo#','#rsDocumentos.Ddocumento#','#rsDocumentos.CodigoTran#', #rsDocumentos.SNcodigo#,'#varRProducto#', 
									#rsDocumentos.IDDoc#,#session.Ecodigo#,#numberformat(varOriCosto,"9.99")#,#numberformat(varOriVolumen,"9.99999")#,#numberformat(varTCosto,"9.99")#,
									#numberformat(varTVolumen,"9.99999")#,#varCodigoMoneda#, 'B', 'N', #MvarOCid#, #MvarOCTid#,
									'#varTipoMovimiento#',#numberformat(varComCosto,"9.99")#,#numberformat(varComVolumen,"9.99999")#)
							</cfquery>
						</cfloop>
						
						<!---Verifica signo de Complemento (Verificar si no es mejor hacerlo con Tcosto)--->
						<cfif varTipoTransaccion EQ "DC" AND varTCosto LT 0 AND varTVolumen LT 0>
							<cfset varTCosto = varTCosto * (-1)>
							<cfset varTVolumen = varTVolumen * (-1)>
						</cfif>
						
						<!---Si la reversion es por Balance Genera Complemento de Costo--->
						<cfif varReversa EQ true AND (varComCosto NEQ 0 OR varComVolumen NEQ 0)>
							<!--- Si se realiza un Complemento Negativo se Aplica un Documento con Transaccion Contraria --->
							<cfif varComCosto LT 0>
								<!--- El complemento se iguala al Monto Total para que el detalle tipo O se vuelva 0--->
								<cfset varComCostoNeg = abs(varComCosto)>
								<cfset varComCosto = 0>
							<cfelse>
								<cfset varComCostoNeg = 0>
							</cfif>
							<cfif varComVolumen LT 0>
								<!--- El complemento se iguala al Monto Total para que el detalle tipo O se vuelva 0--->
								<cfset varComVolumenNeg = abs(varComVolumen)>
								<cfset varComCosto = 0>
							<cfelse>
								<cfset varComVolumenNeg = 0>
							</cfif>
							<!--- Si se encontro algun complemento Negativo se genera el Documento con TRansaccion contraria--->
							<!--- Se toman los valores del Documento Actual para generar el Documento de CN--->
							<cfif varComCostoNeg GT 0 OR varComVolumenNeg GT 0>
								<cfquery name="rsVerifica" datasource="sifinterfaces">
									select * 
									from IE10 
									where ID = #LvarID# 
								</cfquery>
								<!--- Se encuentra La transaccion Contraria --->
								<cfquery name="rsCodigoRef" datasource="sifinterfaces">
									select CCTCodigoRef 
									from #minisifdb#..CCTransacciones 
									where Ecodigo = #session.Ecodigo#
									and CCTcodigo = '#rsVerifica.CodigoTransacion#'
								</cfquery>
								<cfif rsCodigoRef.recordcount EQ 1>
									<cfset varCodigoRef = rsCodigoRef.CCTCodigoRef>
								</cfif>
								<!---Se genera el Nombre del Documento Complemento --->
								<cfset varDocumentoN = replace(rsVerifica.Documento,"P","C","All")>
								<!--- Busca si existe ya el Complemento Neg, sino lo crea --->
								<cfquery name="rsVerComplemento" datasource="sifinterfaces">
									select * 
									from IE10
									where Documento = '#varDocumentoN#'
									and NumeroSocio = '#rsVerifica.NumeroSocio#'
									and CodigoTransacion = '#varCodigoRef#'
									and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">
								</cfquery>
								<cfif rsVerComplemento.recordcount EQ 1>
									<cfset LvarIDN = rsVerComplemento.ID>
									<!--- Busca el consecutivo --->
									<cfquery name="rsVerComplementoD" datasource="sifinterfaces">
										select max(Consecutivo) as Consecutivo
										from ID10
										where ID = #LvarIDN#
									</cfquery>
									<cfset varConsCom = rsVerComplementoD.Consecutivo + 1>
								<cfelse>
									<!--- Obtener el siguiente ID para procesar el registro --->
									<cfquery datasource="sifinterfaces">
										update IdProceso
										set Consecutivo = Consecutivo + 1			
									</cfquery>
									<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
										select Consecutivo
										from IdProceso
									</cfquery>
									<cfset LvarIDN = rsObtieneSigId.consecutivo>
									<cfset varConsCom = 1>
									<cfquery datasource="sifinterfaces">
										insert into IE10 (
											ID, EcodigoSDC, NumeroSocio, Modulo, 
											CodigoTransacion, Documento, Estado, 
											CodigoMoneda, 
											FechaDocumento, 
											FechaVencimiento, 
											Facturado, Origen, VoucherNo, CodigoConceptoServicio, 
											CodigoRetencion, CodigoOficina, CuentaFinanciera, 
											BMUsucodigo, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
											FechaTipoCambio, StatusProceso)
										values( 
											#LvarIDN#,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDCSoin#">,
											'#rsVerifica.NumeroSocio#', '#rsVerifica.Modulo#',
											'#varCodigoRef#', '#varDocumentoN#', ' ',
											'#rsVerifica.CodigoMoneda#', 
											<cfqueryparam cfsqltype="cf_sql_date" value="#rsVerifica.FechaDocumento#">, 
											<cfqueryparam cfsqltype="cf_sql_date" value="#rsVerifica.FechaVencimiento#">,
											'S', '#rsVerifica.Origen#', '#rsVerifica.VoucherNo#', null, 
											null, null, null,
											#session.usucodigo#, 0, null, null, 
											<cfqueryparam cfsqltype="cf_sql_date" value="#rsVerifica.FechaTipoCambio#">, 
											1)
									</cfquery>
								</cfif>
								<!---Se calcula PU --->
								<cfif varComVolumenNeg EQ 0 OR varComCostoNeg EQ 0>
									<cfset varPUnitario = 0>
								<cfelse>
									<cfset varPUnitario = varComCostoNeg/varComVolumenNeg>
								</cfif>
								<!--- Inserta los detalles con el Complemento Negativo --->
								<cfquery datasource="sifinterfaces">
									insert ID10 (ID, Consecutivo, TipoItem, CodigoItem, 
										NombreBarco, FechaHoraCarga, FechaHoraSalida, 
										PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
										CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
										TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
										ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
										PrecioTotal, CentroFuncional, CuentaFinancieraDet, 
										OCtransporteTipo, OCtransporte, OCcontrato, 
										OCconceptoCompra, OCconceptoIngreso,
										BMUsucodigo)
									values (#LvarIDN#, #varConsCom#, '#rsComplementoID10.TipoItem#', '#rsComplementoID10.CodigoItem#', 
										'#rsComplementoID10.NombreBarco#', 
										<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaHoraCarga#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaHoraSalida#">, 
										#numberformat(varPUnitario,9.99)#, '#rsComplementoID10.CodigoUnidadMedida#', #numberformat(varComVolumenNeg,"9.99999")#, 
										 #numberformat(varComVolumenNeg,"9.99999")#, '#rsComplementoID10.CodEmbarque#', '#rsComplementoID10.NumeroBOL#', 
										<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaBOL#">, 
										'#rsComplementoID10.TripNo#', '#rsComplementoID10.ContractNo#', '#rsComplementoID10.CodigoImpuesto#', null, 
										0, '#rsComplementoID10.CodigoAlmacen#', '#rsComplementoID10.CodigoDepartamento#', 
										#varComCostoNeg#, null, null, 
										'#rsComplementoID10.OCtransporteTipo#', '#rsComplementoID10.OCtransporte#', '#rsComplementoID10.OCcontrato#',
										'#rsComplementoID10.OCconceptoCompra#', '#rsComplementoID10.OCconceptoIngreso#',
										#session.usucodigo#)
								</cfquery>
							</cfif>
								
							<!--- Encuentra el Consecutivo con que se agregara el detalle --->
							<cfquery name="rsConsecutivo" datasource="sifinterfaces">
								select max(Consecutivo) as MaxConsecutivo
								from ID10 
								where ID = #LvarID# 
							</cfquery>
							<cfset varConsecutivo = rsConsecutivo.MaxConsecutivo + 1>
							
							<cfif varComCostoNeg EQ 0 OR varComVolumenNeg EQ 0>
								<!---Se calcula PU --->
								<cfif varComVolumen EQ 0 OR varComCosto EQ 0>
									<cfset varPUnitario = 0>
								<cfelse>
									<cfset varPUnitario = varComCosto/varComVolumen>
								</cfif>
								<!--- Cambia los montos del detalle tipo O por el complemento --->
								<cfquery datasource="sifinterfaces">
									update ID10 
									set CantidadTotal = <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#varComVolumen#">,
									CantidadNeta = <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#varComVolumen#">,
									PrecioTotal = <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varComCosto,"9.99")#">,
									PrecioUnitario = <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((varPUnitario),"9.99")#">
									where ID = #LvarID#
									and Consecutivo = #rsComplementoID10.Consecutivo#
									and CodigoItem = '#rsComplementoID10.CodigoItem#'
								</cfquery>
							<cfelse>
								<!--- Si no encuentra Complemento Positivo elimina el Detalle O --->
								<cfquery datasource="sifinterfaces">
									delete ID10
									where ID = #LvarID#
									and Consecutivo = #rsComplementoID10.Consecutivo#
								</cfquery>
							</cfif>
							<!--- Inserta el Detalle Tipo S con el Importe Actual--->
							<cfquery datasource="sifinterfaces">
								insert ID10 (
									ID, Consecutivo, TipoItem, CodigoItem, 
									NombreBarco, FechaHoraCarga, FechaHoraSalida, 
									PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
									CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
									TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
									ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
									BMUsucodigo, PrecioTotal, 
									CentroFuncional, CuentaFinancieraDet, 
									OCtransporteTipo, OCtransporte, OCcontrato,
									OCconceptoCompra, OCconceptoIngreso)
								values(
									#LvarID#, #varConsecutivo#, 'S', '#varConceptoS#',
									null,null,null,
									#numberformat(varTCosto,"9.99")#, '',1,
									1,null,'#rsComplementoID10.NumeroBOL#',
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaBOL#">,
									null, '#rsComplementoID10.ContractNo#', null, null,
									0.00, null, null,
									#rsComplementoID10.BMUsucodigo#, #numberformat(varTCosto,"9.99")#,
									null, null,
									null, null, null, 
									null, null
									)
							</cfquery>
						</cfif>
					<cfelse>
						<!--- Verifica si si existe algun detalle con otro producto, en caso afirmativo --->
						<!--- guarda el registro en PMICOMP_ID10 --->
						<cfquery name="rsVerifica" datasource="sifinterfaces">
							select count (1) as CuentaID10
							from ID10
							where ID = #LvarID#
							and Consecutivo != #rsComplementoID10.Consecutivo#
						</cfquery>
						<cfif rsVerifica.CuentaID10 GT 0>
							<cfquery datasource="sifinterfaces">
								insert PMICOMP_ID10 (sessionid,FechaRegistro,
									ID, Consecutivo, TipoItem, CodigoItem, 
									NombreBarco, FechaHoraCarga, FechaHoraSalida, 
									PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
									CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
									TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
									ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
									PrecioTotal, CentroFuncional, CuentaFinancieraDet, 
									OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
								values(#session.monitoreo.sessionid#,getdate(),
									#LvarID#, #rsComplementoID10.Consecutivo#, '#rsComplementoID10.TipoItem#', '#rsComplementoID10.CodigoItem#',
									'#rsComplementoID10.NombreBarco#',
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaHoraCarga#">, 
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaHoraSalida#">,
									#rsComplementoID10.PrecioUnitario#, '#rsComplementoID10.CodigoUnidadMedida#',
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#rsComplementoID10.CantidadTotal#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#rsComplementoID10.CantidadNeta#">,
									'#rsComplementoID10.CodEmbarque#','#rsComplementoID10.NumeroBOL#',
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaBOL#">,
									null, '#rsComplementoID10.ContractNo#', null, null,	0.00, null, null,
									#numberformat(varTCosto,"9.99")#,
									null, null,'#rsComplementoID10.OCtransporteTipo#', '#rsComplementoID10.OCtransporte#', 
									'#rsComplementoID10.OCcontrato#', '#rsComplementoID10.OCconceptoCompra#'
									)
							</cfquery>
						</cfif>
													
						<!--- Se elimina el detalle ya que no hay diferencia --->
						<cfquery datasource="sifinterfaces">
							delete ID10 
							where ID = #LvarID#
							and Consecutivo = #rsComplementoID10.Consecutivo#
						</cfquery>
					</cfif>
				<cfelse>
					<!--- Al no haber Documentos con Saldo no hace nada --->
				</cfif>
			</cfloop>
			<!--- Reforma los Consecutivos para Este ID --->
			<cfquery datasource="sifinterfaces">
				declare @i int
				select @i= 0
				
				update ID10 
				set Consecutivo = @i+1, @i = @i + 1 
				where ID = #LvarID#
			</cfquery>
			<cfelse>
				<!--- Esta linea se comenta no hace nada pero nunca deberia de llegarse aqui --->
				<cfabort showerror="ID no valido encontrado!!!!">
			</cfif> 
			<!---Finaliza Cambio de Complemento de Producto ---> 
		</cfif> --->
	</cftransaction>
</cfloop>
<!--- Se elimina el manejo de Complementos en NOFACT por cambio de Diseño ABG --->
<!---	
	<!--- Verifica si existen Documentos en PMICOMP_ID10 que se deban Aplicar--->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select * 
		from PMICOMP_ID10 a 
		where a.sessionid = #session.monitoreo.sessionid#
		and exists (select 1 
					from DocumentoReversion b 
					where a.ID = b.IDIE10 
					and a.sessionid = b.sessionid
					and b.Procesado = 'N')
	</cfquery>
	<cfif rsVerifica.recordcount GT 0>
	<cfloop query="rsVerifica">
		<!--- Encuentra el Tipo de Reversion, el Modulo y los Montos Origen --->
		<cfquery name="rsReversa" datasource="sifinterfaces">
			select distinct TipoReversa, Modulo, OriCosto, OriVolumen
			from DocumentoReversion 
			where IDIE10 = #rsVerifica.ID#
			and Procesado = 'N'
			and sessionid = #rsVerifica.sessionid#
		</cfquery>
		<cfset varTipoRev = rsReversa.TipoReversa>
		<cfif trim(rsReversa.Modulo) EQ 'CC'>
			<cfset varConceptoS = "CV-001">
		<cfelse>
			<cfset varConceptoS = "CV-002">
		</cfif>
		<!--- Encuentra el Consecutivo con que se agregara el detalle --->
		<cfquery name="rsConsecutivo" datasource="sifinterfaces">
			select max(Consecutivo) as MaxConsecutivo
			from ID10 
			where ID = #rsVerifica.ID# 
		</cfquery>
		<cfif rsConsecutivo.MaxConsecutivo EQ "">
			<cfset varConsecutivo = 1>
		<cfelse>
			<cfset varConsecutivo = rsConsecutivo.MaxConsecutivo + 1>
		</cfif>
		<cfif varTipoRev EQ "B">
			<cfquery datasource="sifinterfaces">
				insert ID10 (ID, Consecutivo, TipoItem, CodigoItem, 
					NombreBarco, FechaHoraCarga, FechaHoraSalida, 
					PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
					TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
					ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
					PrecioTotal, CentroFuncional, CuentaFinancieraDet, 
					OCtransporteTipo, OCtransporte, OCcontrato, 
					OCconceptoCompra, OCconceptoIngreso,
					BMUsucodigo)
				values (#rsVerifica.ID#, #varConsecutivo#, 'S', '#varConceptoS#', 
					null,null,null
					#rsVerifica.PrecioTotal#, "", 1, 
					1, null, '#rsVerifica.NumeroBOL#', #rsVerifica.FechaBOL#, 
					null, '#rsVerifica.ContractNo#', '#rsVerifica.CodigoImpuesto#', null, 
					0, null, '#rsVerifica.CodigoDepartamento#', 
					#rsVerifica.PrecioTotal#, null, null, 
					null, null, null, 
					null, null,
					#session.usucodigo#)
			</cfquery>
		<cfelseif varTipoRev EQ "O">
			<cfquery datasource="sifinterfaces">
				insert ID10 (ID, Consecutivo, TipoItem, CodigoItem, 
					NombreBarco, FechaHoraCarga, FechaHoraSalida, 
					PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
					TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
					ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
					PrecioTotal, CentroFuncional, CuentaFinancieraDet, 
					OCtransporteTipo, OCtransporte, OCcontrato, 
					OCconceptoCompra, OCconceptoIngreso,
					BMUsucodigo)
				values (#rsVerifica.ID#, #varConsecutivo#, '#rsVerifica.TipoItem#', '#rsVerifica.CodigoItem#', 
					'#rsVerifica.NombreBarco#', 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaHoraCarga#">
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaHoraSalida#">, 
					#rsVerifica.PrecioInitario#, '#rsVerifica.CodigoUnidadMedida#', #rsVerifica.CantidadTotal#, 
					#rsVerifica.CantidadNeta#, '#rsVerifica.CodEmbarque#', '#rsVerifica.NumeroBOL#', 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaBOL#">, 
					'#rsVerifica.TripNo#', '#rsVerifica.ContractNo#', '#rsVerifica.CodigoImpuesto#', null, 
					0, '#rsVerifica.CodigoAlmacen#', '#rsVerifica.CodigoDepartamento#', 
					#rsVerifica.PrecioTotal#, null, null, 
					'#rsVerifica.OCtransporteTipo#', '#rsVerifica.OCtransporte#', '#rsVerifica.OCcontrato#',
					'#rsVerifica.OCconceptoCompra#', '#rsVerifica.OCconceptoIngreso#',
					#session.usucodigo#)
			</cfquery>
		</cfif>
		<!--- Obtiene el valor de OCid --->
		<cfquery name="rsOCid" datasource="sifinterfaces">
			select OCid 
			from #minisifdb#..OCordenComercial 
			where OCcontrato = '#rsVerifica.OCcontrato#'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!--- Obtiene el valor de OCTid --->
		<cfquery name="rsOCTid" datasource="sifinterfaces">
			select OCTid 
			from #minisifdb#..OCtransporte
			where OCTtransporte = '#rsVerifica.OCtransporte#'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!--- Obtiene La Transaccion, Moneda y Socio --->
		<cfquery name="rsDTMS" datasource="sifinterfaces">
			select Documento,CodigoTransacion, CodigoMoneda, NumeroSocio 
			from IE10 
			where ID = #rsVerifica.ID#
		</cfquery>
		<!---Inserta un Registro en DocumentosReversion --->
		<cfquery datasource="sifinterfaces">
			insert DocumentoReversion (fecharegistro,sessionid,
				IDIE10,Modulo,Documento,CodigoTransaccion,SNcodigo,Producto,
				IDdocumento,Ecodigo,OriCosto,OriVolumen,DifCosto,
				DifVolumen,Mcodigo,TipoReversa, Procesado,OCid,OCTid,
				TipoMovimiento, ComplementoCosto, ComplementoVolumen)
			values (getdate(), #session.monitoreo.sessionid#,
					#LvarID#,'#trim(rsReversa.Modulo)#','#rsVerifica.OCcontrato#','NF', '#rsDTMS.NumeroSocio#','#rsVerifica.CodigoItem#', 
					0,#session.Ecodigo#,#numberformat(rsReversa.OriCosto,"9.99")#,#numberformat(rsReversa.OriVolumen,"9.99999")#,#rsVerifica.PrecioTotal#,
					#rsVerifica.CantidadTotal#,'#rsCodigoMoneda#','#varTipoRev#', 'S', #rsOCid.OCid#,#rsOCTid.OCTid#,
					'NF',0,0)
		</cfquery>
	</cfloop>
	</cfif>	
	<!--- Borra los Registros que ya se aplicaron --->
	<cfquery datasource="sifinterfaces">
		delete PMICOMP_ID10
		where sessionid = #session.monitoreo.sessionid#
	</cfquery>

	<!---Elimina Los Documentos de la IE10 que no tienen detalles --->
	<cfquery datasource="sifinterfaces">
		delete IE10
		from IE10 e
		where not exists (select 1 from ID10 
							where ID = e.ID)
	</cfquery>
--->

	<!--- Inclusión de movimiento en cola de proceso --->
	<cfquery name="rsIE10" datasource="sifinterfaces">
		select ID, EcodigoSDC
		from IE10
		where EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and ID not in (select IdProceso from InterfazBitacoraProcesos
	   				 where EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  				 and NumeroInterfaz=10) 
		  and ID not in(select IdProceso from InterfazColaProcesos
	  				 where EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  				 and NumeroInterfaz=10)
	</cfquery>
	
	<cftransaction>
	<cfloop query="rsIE10"> 
		<cfquery name="rsColaProcesos" datasource="sifinterfaces">
			insert InterfazColaProcesos
				(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
				 StatusProceso, FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion,Cancelar)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
			  <cfqueryparam cfsqltype="cf_sql_integer" value=10>,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE10.ID#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE10.EcodigoSDC#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
			  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
		</cfquery>
	</cfloop>
	</cftransaction>

</cfif>

<cflocation url="ProcNoFactProd.cfm?botonsel=btnTerminado">