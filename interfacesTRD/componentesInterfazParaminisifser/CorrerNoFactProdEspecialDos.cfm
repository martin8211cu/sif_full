<!--- Archivo    :  SQLAplicaNoFact.cfm --->
<cfobject name="OGeneralProcA" component="interfacesTRD.Componentes.CGeneralProcA">

<cfset LvarControlDocto = "">
<cfset LvarControlTipo = "">
<cfset LvarControlTipoTransaccion = "">

<cfquery name="rsNoFact" datasource="sifinterfaces">
	select *
	from #session.Dsource#nofactProdPMI a1
	where not Exists (Select a2.Trade_Num from #session.Dsource#ErroresPMI a2
						 where a1.trade_num = a2.Trade_Num and a1.order_num = a2.Order_Num
						   and a1.item_num = a2.Item_Num
						   and sessionid=#session.monitoreo.sessionid#)
	  and sessionid=#session.monitoreo.sessionid#
    order by a1.p_s_ind, a1.acct_ref_num, a1.tipoconsulta, a1.PosNeg
</cfquery>

<!--- se graban la tabla IE10 y la tabla ID10    --->
<cftransaction>
<cfset LvarID = 0>
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
	<cfset LvarTransporte = "#rsNoFact.acct_ref_num#">
	<cfset LvarSocioAlloc = 0>
	<cfset LvarOrdenAlloc = "">
	<cfset LvarPorcentaje= 100>
	
	<cfif rsNoFact.ta_order_type_code EQ 'PHYSICAL'>
		<cfset LvarOCtipoIC = "C">
		<cfset LvarSocioAlloc = #rsNoFact.ta_acct_num#>
	</cfif>
	<cfif rsNoFact.ta_order_type_code EQ 'STORAGE'>
		<cfset LvarAlmacen = "#rsNoFact.ta_acct_ref_num#">
		<cfset LvarSocioAlloc = rsNoFact.ta_acct_num>
	</cfif>
	<cfif rsNoFact.ta_order_type_code EQ 'TRANSPRT'>
		<cfset LvarTransporte = rsNoFact.ta_acct_ref_num>
		<cfif rsNoFact.tt_order_type_code EQ 'PHYSICAL'>
			<cfset LvarOCtipoIC = "C">
			<cfset LvarSocioAlloc = rsNoFact.tt_acct_num>
		</cfif>
		<cfif rsNoFact.tt_order_type_code EQ 'STORAGE'>
			<cfset LvarAlmacen = rsNoFact.tt_cct_ref_num>
			<cfset LvarSocioAlloc = rsNoFact.tt_acct_num>
		</cfif>
	</cfif>

	<cfset LvarOCVid = 0>
	<cfset LvarTipoVenta= "">
	<cfif rsNoFact.p_s_ind EQ 'S'>
		<!--- tipo de venta  --->
		<cfif len(LvarAlmacen)>
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
		<cfset ws_f_volumen = abs(ws_f_Importe / ws_f_precio)>
	</cfif>

	<!--- Conversión a unidades del Artículo --->
	<cfif "#Rtrim(rsNoFact.UcodigoArt)#" NEQ "#Rtrim(contr_qty_uom_code)#">
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

	<!--- se determina el codigo de transaccion y el folio del documento  --->
	<cfset ws_folio = "#rsNoFact.acct_ref_num##rsNoFact.tipoconsulta##rsNoFact.PosNeg##session.FechaFolio#">

	<cfif rsNoFact.PosNeg EQ "N">
		<cfset ws_tipo_transaccion = "DC">
		<cfset ws_f_importe = abs(ws_f_importe)>
	<cfelse>
		<cfset ws_tipo_transaccion = "EC">
	</cfif>
	
	<cfif rsNoFact.p_s_ind EQ "P">
		<cfset ws_tipo_modulo = "CP">
		<cfset ws_tipoOD = "O">
	<cfelse>
		<cfset ws_tipo_modulo = "CC">
		<cfset ws_tipoOD = "D">
	</cfif>

	<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->
	<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
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
	</cfif>
	
	<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select *
		from OCordenProducto_view
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
		  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
	</cfquery>
	
	<cfif rsVerifica.recordcount GT 0>
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
	
	<!---  revisa si existe el TransporteProducto en la estructura de órdenes comerciales --->
	<cfquery name="rsVerifica" datasource="sifinterfaces">
		select *
		from OCtransporteProducto_view
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCTid#">
		  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
		  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNoFact.Aid#">
	</cfquery>
	
	<cfif rsVerifica.recordcount GT 0>
		<cfif ws_tipo_transaccion EQ "DC">
			<cfset LvarCantidad = rsVerifica.OCTPcantidadTeorica - ws_f_volumen>
			<cfif LvarCantidad EQ 0>
				<cfset LvarCantidad = 1>
			</cfif>
			<cfset LvarPrecioUnitario = (rsVerifica.OCTPprecioTotTeorico - (ws_f_importe)) / abs(LvarCantidad)>
			<cfset LvarPrecioTotal = rsVerifica.OCPprecioTotal - ws_f_importe>
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

		<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
		<cfquery name="rsVerifica" datasource="sifinterfaces">
			select * 
			from OCordenProducto_view
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vOCid#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
		</cfquery>
		
		<cfif rsVerifica.recordcount GT 0>
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
</cftransaction>