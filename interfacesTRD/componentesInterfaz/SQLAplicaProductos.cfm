<!---ABG: Se realiza Cambio a Interfaz para que muestra pantalla intermedia de resultados Ene/2008 --->
<!--- Se declaran variables de acceso a DataSource--->
<cfsetting requesttimeout="1800">
<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfquery name="queryComprasE" datasource="sifinterfaces">
	select distinct c_docto_proveedor, i_empresa, c_tipo_folio,sessionid
	from facturasProdPMI fp
	where not exists (select 1 from facturasProdPMI
						where c_docto_proveedor = fp.c_docto_proveedor
							and i_empresa = fp.i_empresa
							and c_tipo_folio = fp.c_tipo_folio
							and sessionid= fp.sessionid
							and mensajeerror is not null)
		and fp.sessionid = #session.monitoreo.sessionid#
	order by voucher_num
</cfquery>

<cfif queryComprasE.recordcount GT 0>
<cfset LvarCuentaFinanciera = "">
<cfloop query="queryComprasE">
	<cfset LvarID = 0>
	<cfset varControlDocumento = true>
	<cfquery name="queryCompras" datasource="sifinterfaces">
		select *
		from facturasProdPMI 
		where c_docto_proveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryComprasE.c_docto_proveedor#">
		and i_empresa = <cfqueryparam cfsqltype="cf_sql_integer" value="#queryComprasE.i_empresa#">
		and c_tipo_folio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#queryComprasE.c_tipo_folio#">
		and mensajeerror is null
		and sessionid = #session.monitoreo.sessionid#
		order by voucher_num
	</cfquery>
	<cfif queryCompras.recordcount GT 0>
	<cftransaction>
	<cfloop query="queryCompras">
 
 		<!--- valida que el monto del voucher sea igual al monto de la factura  --->	
		<cfset vDiff = queryCompras.voucher_tot_amt - (queryCompras.f_monto_Enca + queryCompras.f_iva)>

		<!--- Existencia del Articulo  --->
		<cfif Len(queryCompras.Aid) EQ 0>
			<cfset LvarAid = 0>
		<cfelse>
			<cfset LvarAid = queryCompras.Aid>
		</cfif>

		<!--- Moneda es Valida  --->
		<cfif Len(queryCompras.Mcodigo) EQ 0>
			<cfset LvarMcodigo = 0>
		<cfelse>
			<cfset LvarMcodigo = queryCompras.Mcodigo>
		</cfif> 

		<!--- Unidad es Valida  --->
		<cfif Len(queryCompras.Ucodigo) EQ 0>
			<cfset LvarUcodigo="0">		
		<cfelse>
			<cfset LvarUcodigo = queryCompras.Ucodigo>
		</cfif>

		<cfset LvarConceptoCompra = "00">
	
		<!--- decodifica campo alloc_type_code  --->	
		<cfif queryCompras.alloc_type_code EQ "W">
			<cfset LvarOCTtipo = "B">
		<cfelseif queryCompras.alloc_type_code EQ "R">
			<cfset LvarOCTtipo = "F">
		<cfelse>
			<cfset LvarOCTtipo = "T">
		</cfif>

		<!--- obtiene el valor de OCtipoIC  Comercial o Inventario  --->
		<cfset LvarOCtipoIC = "C">
		<cfset LvarAlmacen = "">
		<cfset LvarTransporte = "#queryCompras.c_orden#">
		<cfset LvarSocioAlloc = 0>
		<cfset LvarOrdenAlloc = "">
		<cfset LvarPorcentaje= 100>
	
		<cfset LvarAlm_trade_num = queryCompras.ta_trade_num>
		<cfset LvarAlm_order_num = queryCompras.ta_order_num>
		<cfset LvarAlm_item_num = queryCompras.ta_item_num>
		<cfset LvarAlm_creation_date = queryCompras.ta_creation_date>
		<cfif queryCompras.ta_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = #querycompras.ta_acct_num#>
		</cfif>
		<cfif queryCompras.ta_order_type_code EQ 'STORAGE'>
			<cfset LvarAlmacen = "#querycompras.ta_acct_ref_num#">
			<cfset LvarSocioAlloc = querycompras.ta_acct_num>
		</cfif>
		<cfif queryCompras.ta_order_type_code EQ 'TRANSPRT'>
			<cfset LvarTransporte = queryCompras.ta_acct_ref_num>
			<cfif queryCompras.tt_order_type_code EQ 'PHYSICAL'>
				<cfset LvarOCtipoIC = "C">
				<cfset LvarSocioAlloc = queryCompras.tt_acct_num>
			</cfif>
		
			<cfif queryCompras.tt_order_type_code EQ 'STORAGE'>
				<cfset LvarAlmacen = queryCompras.tt_cct_ref_num>
				<cfset LvarSocioAlloc = queryCompras.tt_acct_num>
			</cfif>
		</cfif>

		<cfset ws_f_Importe = queryCompras.f_importe>
		<cfset ws_f_precio = queryCompras.f_precio>
		<cfset ws_c_unidad = queryCompras.c_unidad>
		<cfset ws_f_volumen = queryCompras.f_volumen>

		<!--- Conversión a unidades del Artículo --->
		<cfif "#Rtrim(queryCompras.UcodigoArt)#" NEQ "#Rtrim(queryCompras.c_unidad)#">
			<cfif len(queryCompras.cuafactor) GT 0>
				<cfset ws_f_volumen = queryCompras.cuafactor * ws_f_volumen>
				<cfif ws_f_volumen EQ 0>
					<cfset ws_f_volumen = 1>
				</cfif>
				<cfset ws_f_precio = ws_f_Importe/ws_f_volumen>
				<cfset ws_c_unidad = queryCompras.UcodigoArt>
			</cfif>
		</cfif>

	<!--- Esta rutina de IVA tendria que agregarse para manejar el IVA en Facturas de Producto Compras --->
	<!--- Esta rutina supone que el IVA se tendra que indicar en el campo f_iva de PmiFolios ver liena 237 --->
		<!--- Valida código impuesto del IVA --->
		<cfset LvarCodigoImpuesto = "">
		<cfif queryCompras.f_iva GT 0>
			<cfif Len(queryCompras.CodigoImpuesto) GT 0>
				<cfset LvarCodigoImpuesto = queryCompras.CodigoImpuesto>
			</cfif>
		</cfif> 

		<cfif ISNUMERIC(queryCompras.bl_ticket_num)>
			<cfset Lvarbl_ticket_num=queryCompras.bl_ticket_num>
		<cfelse>
			<cfset Lvarbl_ticket_num=0>
		</cfif>
	
		<cfif ISDATE(queryCompras.bl_date)>
			<cfset Lvarbl_date=queryCompras.bl_date>
		<cfelse>
			<cfset Lvarbl_date=querycompras.dt_fecha_recibo>
		</cfif>
	
		<cfif ISDATE(queryCompras.title_tran_date)>
			<cfset LvarTitle_tran_date=queryCompras.title_tran_date>
		<cfelse>
			<cfset LvarTitle_tran_date=querycompras.dt_fecha_recibo>
		</cfif>

		<cfset ws_f_volumen = abs(ws_f_volumen)>
		<!---Verifica que no se genere una linea de detalle con importe 0--->
		<cfif ws_f_importe NEQ 0>
			<cfset ws_f_importe = abs(ws_f_importe)>
		</cfif>
	
		<!--- Verificar si si se genera un nuevo registro de IE10 --->
		<cfif varControlDocumento>
			<cfset varControlDocumento = false>
			<cfquery name="rsVerificaIE10" datasource="sifinterfaces">
				select count(1) as Cantidad
				from IE10
				where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				  and NumeroSocio = '#queryCompras.i_empresa#'
				  and Modulo = 'CP'
				  and CodigoTransacion = '#queryCompras.c_tipo_folio#'
				  and Documento = '#queryCompras.c_docto_proveedor#'
			</cfquery>
			<cfif rsVerificaIE10.Cantidad GT 0>
				<cfabort showerror="Intento de Insertar Registro duplicado en la IE10">
			<cfelse>
				<cfset LvarConsecutivoID10 = 0>
				<cfset varInsertaControl = 1>
				<!--- Corrección en el cálculo de la diferencia, se aplica ahora solo a la primer linea y se valida monto 0  --->
				<!--- calcula diferencia entre el encabezado y los detalles de la factura y se lo aplica a la primer linea   --->
				<!--- en el campo f_iva se debe de indicar el impuesto y no debe haber un costo para el impuesto en la tabla --->
				<!--- cost ni en la tabla PmiFoliosDetailP --->
				<cfquery name="rsVerifica" datasource="sifinterfaces">
					select sum(f_importe) as totaldetalles from #session.Dsource#facturasProdPMI
					where voucher_num = #queryCompras.voucher_num#
					and sessionid = #session.monitoreo.sessionid#
				</cfquery>
				<cfset ws_Total = queryCompras.f_monto_Enca <!---+ queryCompras.f_iva--->>
				<cfset vDiffFactura = ws_Total - rsVerifica.totaldetalles >
				<cfset ws_f_Importe = queryCompras.f_importe + vDiffFactura>			
				<cfif rsVerifica.totaldetalles EQ (ws_f_importe * (-1)) OR vDiffFactura EQ (ws_f_importe * (-1))	
					OR ws_f_importe EQ 0>
					<cfset varInsertaControl = 0>
					<cfset LvarID = 0>
				</cfif>
				<!--- Con la variable InsertaControl se contrla que no se inserten Documentos--->
				<!--- con Importes = 0 o monto total de documento = 0 --->
				<cfif varInsertaControl EQ 1>
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
					<cfquery datasource="sifinterfaces">
						insert into IE10 (
							ID, EcodigoSDC, NumeroSocio, Modulo, 
							CodigoTransacion, Documento, Estado, 
							CodigoMoneda, 
							FechaDocumento, 
							FechaVencimiento, 
							Facturado, Origen, VoucherNo, CodigoConceptoServicio, 
							CodigoRetencion, CodigoOficina, CuentaFinanciera, 
							BMUsucodigo,DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, 
							FechaTipoCambio, StatusProceso)
						values( 
							#LvarID#, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
							'#queryCompras.i_empresa#', 'CP',
							'#queryCompras.c_tipo_folio#', '#queryCompras.c_docto_proveedor#', ' ',
							'#queryCompras.voucher_curr_code#', 
							<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_recibo#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.dt_fecha_vencimiento#">,
							'S', 'CP', '#queryCompras.voucher_num#', null, 
							null, null, null,
							#session.usucodigo#,0, null, null, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.title_tran_date#">, 
							1)
					</cfquery>
				</cfif>
			</cfif>
			<cfset LvarControlSocio = queryCompras.i_empresa>
			<cfset LvarControlTipo = queryCompras.c_tipo_folio>
			<cfset LvarControlDocto = queryCompras.c_docto_proveedor>
		</cfif>
		<!---Validación para evitar inconcistencia en montos de los documentos entre SOIN y ICTS--->
		<cfif ws_f_importe EQ 0>
			<cfabort showerror="Error de Datos Grave. Se detiene la Interfaz para evitar Errores en Documento. f_importe = 0">
		</cfif>
		<cfif LvarID GT 0>
			<cfset LvarConsecutivoID10 = LvarConsecutivoID10 + 1>
			<cfquery datasource="sifinterfaces">
				insert ID10 (
					ID, Consecutivo, TipoItem, CodigoItem, 
					NombreBarco, FechaHoraCarga, FechaHoraSalida, 
					PrecioUnitario, CodigoUnidadMedida, CantidadTotal, 
					CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, 
					TripNo, ContractNo, CodigoImpuesto,ImporteImpuesto,
					ImporteDescuento, CodigoAlmacen, CodigoDepartamento, 
					BMUsucodigo,PrecioTotal, 
					CentroFuncional, CuentaFinancieraDet, 
					OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
				values(
					#LvarID#, #LvarConsecutivoID10#, 'O', '#queryCompras.c_producto#',
					'#queryCompras.transportation#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.load_compl_date#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.nor_date#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
					'#ws_c_unidad#',
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#ws_f_volumen#">, 
  					'#queryCompras.del_term_code#', '#Lvarbl_ticket_num#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
					null, '#queryCompras.c_orden#', 
					<!--- Si se utiliza rutina para el IVA se inserta esta variable en lugar del CodigoImpuesto --->
					<!--- '#LvarCodigoImpuesto#' Si NO se utiliza rutina para el IVA se inserta --->
					<!--- '#queryCompras.CodigoImpuesto#' --->
					'#LvarCodigoImpuesto#',
					null,
					0.00, null, null,
					#session.usucodigo#,#numberformat(ws_f_importe,"9.99")#,
					null, '#LvarCuentaFinanciera#',
					'#LvarOCTtipo#', '#LvarTransporte#', '#queryCompras.c_orden#', '#LvarConceptoCompra#'
					)
			</cfquery>
		</cfif>

		<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
		<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
		<cfif LvarID GT 0>
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select OCid
				from OCordenComercial_view
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#querycompras.c_orden#">
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
						'O', '#LvarOCtipoIC#', #session.Ecodigo#,
						 #queryCompras.SNid#, '#querycompras.c_orden#',
					     <cfif isdate(queryCompras.creation_date)>
						    <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.creation_date#">,
				    	 <cfelse>
						    null,
					     </cfif>
						 #LvarMcodigo#,
						 null,
						 'A','CP',
						 '#queryCompras.del_term_code#',
 				    	 <cfif isnumeric(queryCompras.trade_num)>
						    <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryCompras.trade_num#">,
					     <cfelse>
						    null,
					     </cfif>
				    	 <cfif isnumeric(queryCompras.order_num)>
						    <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryCompras.order_num#">,
					     <cfelse>
						    null,
					     </cfif>
					     <cfif isdate(queryCompras.fecha_allocation)>
						    <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.fecha_allocation#">,
				    	 <cfelse>
						    null,
					     </cfif>
					     <cfif isdate(queryCompras.title_tran_date)>
						    <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.title_tran_date#">,
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
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
				</cfquery>
			<cfelse>
				<cfset LvarCantidad = (rsVerifica.OCPcantidad + ws_f_volumen)>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / LvarCantidad>
				<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + ws_f_importe>
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
					  <cfif isdate(queryCompras.load_compl_date)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.load_compl_date#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					  </cfif>
					  null,
					  null,
					  null,
					  <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.nor_date#">,
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
				</cfquery>
			--->
			</cfif>

			<!---  revisa si existe el ProductoTransito en la estructura de órdenes comerciales --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select OCTid
				from OCproductoTransito_view
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
			</cfquery>
	
			<cfif rsVerifica.recordcount EQ 0>
				<cfquery name="query" datasource="sifinterfaces">
					insert OCproductoTransito_view
						(OCTid, Aid, Ecodigo, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal,
						 OCPTsalidasCantidad, OCPTsalidasCostoTotal, BMUsucodigo)
					values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
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
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
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
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					  <cfqueryparam cfsqltype="cf_sql_char" value="F">,
					  <cfqueryparam cfsqltype="cf_sql_char" value="O">,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvarbl_ticket_num#">,
					  <cfif isdate(Lvarbl_date)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvarbl_date#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					  </cfif>
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTransporte#">,
					  <cfif isdate(queryCompras.fecha_allocation)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.fecha_allocation#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					  </cfif>
					  <cfif isdate(queryCompras.title_tran_date)>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#queryCompras.title_tran_date#">,
					  <cfelse>
						  <cfqueryparam cfsqltype="cf_sql_date" value="#querycompras.dt_fecha_recibo#">,
					  </cfif>
					  <cfqueryparam cfsqltype="cf_sql_float" value="#ws_f_volumen#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_precio,"9.99")#">,
					  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(ws_f_importe,"9.99")#">,
					  <cfqueryparam cfsqltype="cf_sql_float" value=0.00>,
					  <cfqueryparam cfsqltype="cf_sql_money" value=0.00>,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				</cfquery>
			<cfelse>
				<cfset LvarCantidad = (rsVerifica.OCTPcantidadTeorica + ws_f_volumen)>
				<cfif LvarCantidad EQ 0>
					<cfset LvarCantidad = 1>
				</cfif>
				<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico + ws_f_importe) / LvarCantidad>
				<cfset LvarPrecioTotal = rsVerifica.OCTPprecioTotTeorico + ws_f_importe>
				<cfquery datasource="sifinterfaces">
					update OCtransporteProducto_view set
					OCTPcantidadTeorica=#LvarCantidad#,
					OCTPprecioUniTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioUnitario,"9.99")#">,
					OCTPprecioTotTeorico=<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(LvarPrecioTotal,"9.99")#">
	  			    where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
					  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
					  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
				</cfquery>
			</cfif>
		</cfif>
	
		<!---  Si el Destino de la Orden de Compra es un Almacén, se graba una Orden  de Inventario   --->		
		<cfif LvarID GT 0>
			<cfif Len(LvarAlmacen) GT 0>
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
							 #queryCompras.SNid#, '#LvarAlmacen#',
							 <cfif isdate(LvarAlm_creation_date)>
								<cfqueryparam cfsqltype="cf_sql_date" value="#LvarAlm_creation_date#">,
							 <cfelse>
								null,
							 </cfif>
							 #LvarMcodigo#,
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
						  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCuentaFinanciera#">,
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
					</cfquery>
				<cfelse>
					<cfset LvarCantidad = (rsVerifica.OCPcantidad + ws_f_volumen)>
					<cfif LvarCantidad EQ 0>
						<cfset LvarCantidad = 1>
					</cfif>
					<cfset LvarPrecioUnitario = (rsVerifica.OCPprecioTotal + ws_f_importe) / LvarCantidad>
					<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal + ws_f_importe>
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
		</cfif>
		<!--- FIN SECCION ORDENES COMERCIALES  --->
	</cfloop>
	<!--- Eliminacion de Complementos FACT 07/07/2008 ABG --->
	<!--- hasta linea 1113
		<!--- Cambio para realizar el Complemento de los NoFact 12/02/08 realizado por ABG --->
		<!---Una vez que termina se agrega esta rutina para verificar si es necesario --->
		<!---Dividir los detalles del NoFact entre tipo O y tipo S
		Todos los documentos de NOFACT se reversan por Balance Siempre--->
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
					select distinct Modulo, CodigoTransacion 
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
						<cfset varTipoTransaccion = "NC">
					<cfelse>
						<cfset varTipoTransaccion = "FC">
					</cfif>
				<cfelse>
					<cfquery name="rsVerifica" datasource="sifinterfaces">
						select CPTtipo 
						from #minisifdb#..CPTransacciones 
						where CPTcodigoext = '#trim(rsModulo.CodigoTransacion)#'
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cfif trim(rsVerifica.CPTtipo) EQ "C">
						<cfset varTipoTransaccion = "FC">
					<cfelse>
						<cfset varTipoTransaccion = "NC">
					</cfif>
				</cfif>
				
				<!---Verifica signo de Total Costo y Volumen --->
				<cfif varTipoTransaccion EQ "NC">
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
				
				<!--- Si existen Documentos   se verificara si el monto y el volumen --->
				<!--- cambió para este NoFact, en caso de cambio se procede --->
				<cfif rsDocumentos.recordcount GT 0> 
					<!--- Obtiene el Aid del Producto --->
					<cfquery name="rsAidProd" datasource="sifinterfaces">
						select Aid 
						from #minisifdb#..Articulos 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Acodigo = '#rsComplementoID10.CodigoItem#'
					</cfquery>
					<cfset varAid = rsAidProd.Aid>
					<!--- Obtiene Suma de Costos y de Volumenes para el producto por Transporte--->
					<cfif trim(rsModulo.Modulo) EQ 'CC'>
						<cfquery name="rsCostoVolumen" datasource="sifinterfaces">
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
							and HDid > 0
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
					<cfset varTCosto = rsCostoVolumen.TCosto>
					<cfset varTVolumen = rsCostoVolumen.TVolumen>
				<cfelse>
					<cfset varTCosto = 0>
					<cfset varTVolumen = 0>
				</cfif>
				<!---Busca Si hay que sumar Montos Reversados --->
				<cfquery name="rsCostoVolumen" datasource="sifinterfaces">
					<!--- se deben de buscar el ultimo monto reversado para esa OCid --->
					select distinct a.OCid,a.Mcodigo,a.Modulo,a.Producto,a.OriCosto, a.OriVolumen 
					from DocumentoReversion a 
					where a.OCid = #MvarOCid#
					and a.TipoReversa = 'B'
					and a.Modulo = '#trim(rsModulo.Modulo)#'
					and a.Procesado = 'S'
					and a.Producto = '#rsComplementoID10.CodigoItem#'
					and a.Mcodigo = #varCodigoMoneda#
					and IDREV = (select max(IDREV) from DocumentoReversion 
									where OCid = #MvarOCid#
									and TipoReversa = 'B'
									and Modulo = '#trim(rsModulo.Modulo)#'
									and Procesado = 'S' 
									and Producto = '#rsComplementoID10.CodigoItem#'
									and Mcodigo = #varCodigoMoneda#
									group by OCid,Mcodigo)
				</cfquery>
					
				<!--- Busca si hay que restar Montos Reversados --->
				<cfquery name="rsCostoVolumenM" datasource="sifinterfaces">
					<!--- se deben de buscar el ultimo monto reversado para esa OCid --->
					select distinct a.OCid,a.Mcodigo,a.Modulo,a.Producto,sum(a.DifCosto) as DifCosto, sum(a.DifVolumen) as DifVolumen
					from DocumentoReversion a 
					where a.OCid = #MvarOCid#
					and a.TipoReversa = 'B'
					and a.Modulo = '#trim(rsModulo.Modulo)#'
					and sessionid = #session.monitoreo.sessionid# 
					and a.Procesado = 'N'
					and a.Producto = '#rsComplementoID10.CodigoItem#'
					and a.Mcodigo = #varCodigoMoneda#
					and a.TipoMovimiento not in ('F3','F6')
					group by Modulo,OCid,Producto,Mcodigo
				</cfquery>	
				
				<cfif rsCostoVolumen.recordcount GT 0 and rsCostoVolumen.Producto EQ rsComplementoID10.CodigoItem>
					<cfset varRCosto = rsCostoVolumen.OriCosto>
					<cfset varRVolumen = rsCostoVolumen.OriVolumen>
				<cfelse>
					<cfset varRCosto = 0>
					<cfset varRVolumen = 0>
				</cfif>
				<cfif rsCostoVolumenM.recordcount GT 0 and rsCostoVolumenM.Producto EQ rsComplementoID10.CodigoItem>
					<cfset varMCosto = rsCostoVolumenM.DifCosto>
					<cfset varMVolumen = rsCostoVolumenM.DifVolumen>
				<cfelse>
					<cfset varMCosto = 0>
					<cfset varMVolumen = 0>
				</cfif>
				<cfset varRCosto = varRCosto - varMCosto>
				<cfset varRVolumen = varRVolumen - varMVolumen>
				
				<!--- Verifica si hay saldo o si se ha reversado algo por balance --->
				<!--- Si no hay saldo ni reversiones por balance no se procede al complemento --->
				<cfif varTCosto + varRCosto NEQ 0 OR varTVolumen + varRVolumen NEQ 0>
					<!--- Se verifica el monto del FACT contra el monto del NoFACT --->
					<cfif rsModulo.CodigoTransacion EQ "NC" AND (varTCosto + varRCosto) LT 0 AND (varTCosto + varRCosto) LT -.009>
						<cfif (varPrecioTotal - (varTCosto + varRCosto)) GT -.01  AND (varCantidadTotal - (varTVolumen + varRVolumen)) GT -.01>
							<cfset varComplemento = false>
							<cfset varItemServicio = true>
							<cfset varDifCosto = varPrecioTotal>
							<cfset varDifVolumen = varCantidadTotal>
							<cfset varOriCosto = (varTCosto + varRCosto) - varPrecioTotal>
							<cfset varOriVolumen = (varTVolumen + varRVolumen) - varCantidadTotal>
							<cfset varCompCosto = 0>
							<cfset varCompVolumen = 0>
							<cfset varTipoM = "F1">
						<cfelse>
							<cfset varComplemento = true>
							<cfset varItemServicio = true>
							<cfset varTipoM = "F2">
							<cfif (varPrecioTotal - (varTCosto + varRCosto)) GT -.01>
								<cfset varDifCosto = varPrecioTotal>
								<cfset varOriCosto = (varTCosto + varRCosto) - varPrecioTotal>
								<cfset varCompCosto = 0>
							<cfelse>
								<cfset varDifCosto = (varTCosto + varRCosto)>
								<cfset varOriCosto = 0>
								<cfset varCompCosto = varPrecioTotal - (varTCosto + varRCosto)>
							</cfif>
							<cfif (varCantidadTotal - (varTVolumen + varRVolumen)) GT -.01>
								<cfset varDifVolumen = varCantidadTotal>
								<cfset varOriVolumen = (varTVolumen + varRVolumen) - varCantidadTotal>
								<cfset varCompVolumen = 0>
							<cfelse>
								<cfset varDifVolumen = (varTVolumen + varRVolumen)>
								<cfset varOriVolumen = 0>
								<cfset varCompVolumen = varCantidadTotal - (varTVolumen + varRVolumen)>
							</cfif>
						</cfif>
					<cfelseif rsModulo.CodigoTransacion EQ "NC" and (varTCosto + varRCosto) GT -.009>
						<cfset varTipoM = "F3">
						<cfset varComplemento = false>
						<cfset varItemServicio = false>
						<cfset varDifCosto = varPrecioTotal>
						<cfset varDifVolumen = varCantidadTotal>
						<cfset varOriCosto = (varTCosto + varRCosto)>
						<cfset varOriVolumen = (varTVolumen + varRVolumen)>
						<cfset varCompCosto = 0>
						<cfset varCompVolumen = 0>
					<cfelseif rsModulo.CodigoTransacion NEQ "NC" and (varTCosto + varRCosto) GT 0 AND (varTCosto + varRCosto) GT .009>
						<cfif (varPrecioTotal - (varTCosto + varRCosto)) LT .01  AND (varCantidadTotal - (varTVolumen + varRVolumen)) LT .01>
							<cfset varTipoM = "F4">
							<cfset varComplemento = false>
							<cfset varItemServicio = true>
							<cfset varDifCosto = varPrecioTotal>
							<cfset varDifVolumen = varCantidadTotal>
							<cfset varOriCosto = (varTCosto + varRCosto) - varPrecioTotal>
							<cfset varOriVolumen = (varTVolumen + varRVolumen) - varCantidadTotal>
							<cfset varCompCosto = 0>
							<cfset varCompVolumen = 0>
						<cfelse>
							<cfset varTipoM = "F5">
							<cfset varComplemento = true>
							<cfset varItemServicio = true>
							<cfif (varPrecioTotal - (varTCosto + varRCosto)) LT .01>
								<cfset varDifCosto = varPrecioTotal>
								<cfset varOriCosto = (varTCosto + varRCosto) - varPrecioTotal>
								<cfset varCompCosto = 0>
							<cfelse>
								<cfset varDifCosto = (varTCosto + varRCosto)>
								<cfset varOriCosto = 0>
								<cfset varCompCosto = varPrecioTotal - (varTCosto + varRCosto)>
							</cfif>
							<cfif (varCantidadTotal - (varTVolumen + varRVolumen)) LT .01>
								<cfset varDifVolumen = varCantidadTotal>
								<cfset varOriVolumen = (varTVolumen + varRVolumen) - varCantidadTotal>
								<cfset varCompVolumen = 0>
							<cfelse>
								<cfset varDifVolumen = (varTVolumen + varRVolumen)>
								<cfset varOriVolumen = 0>
								<cfset varCompVolumen = varCantidadTotal - (varTVolumen + varRVolumen)>
							</cfif>
						</cfif>
					<cfelseif rsModulo.CodigoTransacion NEQ "NC" and (varTCosto + varRCosto) LT .009>
						<cfset varTipoM = "F6">
						<cfset varComplemento = false>
						<cfset varItemServicio = false>
						<cfset varDifCosto = varPrecioTotal>
						<cfset varDifVolumen = varCantidadTotal>
						<cfset varOriCosto = (varTCosto + varRCosto)>
						<cfset varOriVolumen = (varTVolumen + varRVolumen)>
						<cfset varCompCosto = 0>
						<cfset varCompVolumen = 0>
					</cfif>
					
					<cfset varModulo = trim(rsModulo.Modulo)>
					<cfset varRProducto = rsComplementoID10.CodigoItem>
					<cfif rsDocumentos.recordcount GT 0>
					<cfset varBalance = true>
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
								#rsDocumentos.IDDoc#,#session.Ecodigo#,#numberformat(varOriCosto,"9.99")#,#numberformat(varOriVolumen,"9.99999")#,#numberformat(varDifCosto,"9.99")#,
								#numberformat(varDifVolumen,"9.99999")#,#varCodigoMoneda#,'B', 'N', #MvarOCid#, #MvarOCTid#,
								'#varTipoM#',#numberformat(varCompCosto,"9.99")#,#numberformat(varCompVolumen,"9.99999")#)
						</cfquery>
					</cfloop>
					<cfelse>
						<!--- Si no hay ningun Documento que reversar se inserta un registro --->
						<!--- Se insertan registros en DocumentosReversión F7--->
						<cfquery datasource="sifinterfaces">
							insert DocumentoReversion (fecharegistro,sessionid,
								IDIE10,Modulo,Documento,CodigoTransaccion,SNcodigo,Producto,
								IDdocumento,Ecodigo,OriCosto,OriVolumen,DifCosto,
								DifVolumen,Mcodigo,TipoReversa, Procesado,OCid,OCTid,
								TipoMovimiento, ComplementoCosto, ComplementoVolumen)
							values (getdate(), #session.monitoreo.sessionid#,
								#LvarID#,'#varModulo#','#rsComplementoID10.OCcontrato#','#varModulo#', 0,'#varRProducto#', 
								0,#session.Ecodigo#,#numberformat(varOriCosto,"9.99")#,#numberformat(varOriVolumen,"9.99999")#,#numberformat(varDifCosto,"9.99")#,
								#numberformat(varDifVolumen,"9.99999")#,#varCodigoMoneda#,'B', 'S', #MvarOCid#,#MvarOCTid#,
								'#varTipoM#',#numberformat(varCompCosto,"9.99")#,#numberformat(varCompVolumen,"9.99999")#)
						</cfquery>
					</cfif>
					
					<!--- Si la transaccion es NC cambia la variable de signo --->
					<cfif varTipoTransaccion EQ "NC">
						<cfset varDifCosto = varDifCosto * (-1)>
						<cfset varDifVolumen = varDifVolumen * (-1)>
					</cfif>
						
					<!--- Verifica si se realiza Complemento --->
					<cfif varComplemento>
						<!--- Cambia los montos del detalle tipo O por el complemento --->
						<cfquery datasource="sifinterfaces">
							update ID10 
							set CantidadTotal = CantidadTotal - <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#varDifVolumen#">,
							CantidadNeta = CantidadNeta - <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#varDifVolumen#">,
							PrecioTotal = PrecioTotal - <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varDifCosto,"9.99")#">
							where ID = #LvarID#
							and Consecutivo = #rsComplementoID10.Consecutivo#
							and CodigoItem = '#rsComplementoID10.CodigoItem#'
								
							update ID10 
							set	PrecioUnitario = case 
										when CantidadTotal = 0 then 0
										else PrecioTotal/CantidadTotal end
							where ID = #LvarID#
							and Consecutivo = #rsComplementoID10.Consecutivo#
							and CodigoItem = '#rsComplementoID10.CodigoItem#'
						</cfquery>
					</cfif>
					
					<cfif varItemServicio>
						<!--- Si no hay Complemento Elimina el Detalle Tipo O --->
						<cfif varComplemento EQ false>
							<cfquery datasource="sifinterfaces">
								delete ID10 
								where ID = #LvarID#
								and Consecutivo = #rsComplementoID10.Consecutivo#
							</cfquery>
						</cfif>
						
						<!--- Encuentra el Consecutivo con que se agregara el detalle --->
						<cfquery name="rsConsecutivo" datasource="sifinterfaces">
							select max(Consecutivo) as MaxConsecutivo
							from ID10 
							where ID = #LvarID# 
						</cfquery>
						<cfif rsConsecutivo.MaxConsecutivo EQ "">
							<cfset varConsecutivo = 1>
						<cfelse>
							<cfset varConsecutivo = rsConsecutivo.MaxConsecutivo + 1>
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
								OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
							values(
								#LvarID#, #varConsecutivo#, 'S', 'CV-002',
								null,null,null,
								#numberformat(varDifCosto,"9.99")#, '',
								1,1,null,'#rsComplementoID10.NumeroBOL#',
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsComplementoID10.FechaBOL#">,
								null, '#rsComplementoID10.ContractNo#','#rsComplementoID10.CodigoImpuesto#', null,	0.00, null, null,
								#rsComplementoID10.BMUsucodigo#, #numberformat(varDifCosto,"9.99")#,
								null, null,null, null, null, null)
						</cfquery>
					</cfif>
				<cfelse>
					<!--- No existen Documentos con Saldo ni Reversiones Por Balance --->
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
		</cfif>
		--->
	</cftransaction>
	</cfif>
</cfloop>

	<!--- Inclusión de movimiento en cola de proceso --->

	<cfquery name="rsIE10" datasource="sifinterfaces">
		select ID, EcodigoSDC
		from IE10
		where EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC=
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#"> and NumeroInterfaz=10) 
		  and ID not in(select IdProceso from InterfazColaProcesos where EcodigoSDC=
		  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#"> and NumeroInterfaz=10)
	</cfquery>

	<cftransaction>
	<cfloop query="rsIE10"> 
		<cfquery name="rsColaProcesos" datasource="sifinterfaces">
			insert InterfazColaProcesos
				(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
				 StatusProceso, FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion, Cancelar)
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


<cflocation url="ProcFactProd.cfm?botonsel=btnTerminado">
