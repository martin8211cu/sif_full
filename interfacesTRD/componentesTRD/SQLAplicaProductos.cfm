<!--- Archivo    :  FacturasProductosB.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  En el proceso A, se valida la información y el usuario decide si se procesan los 
	                productos, si decide procesar se ejecuta este proceso(B), en este proceso se graba
					la información en las tablas IE10, ID10 y en la Estructura de Ordenes Comerciales.
	  --->

<!--- Se definen objetos a utilizar  --->
<cfobject name="OFacturaProducto" component="interfacesPMI.Componentes.CFacturaProducto">
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcB" component="interfacesPMI.Componentes.CGeneralProcB">

<!--- Variables de Socio de Negocios, Tipo de Venta, Tipo de Contraparte, etc.  --->
<cfset SESSION.HayErrores = false>
<cfset VsocioNegocio = "">
<cfset Cv = "">         <!--- usado como cadena vacía en los "insert"  --->

<!--- procesa los registros de qproductos, primero procesa las compras, campo Modulo='CXP'  --->	
<cfdump var="#session.qproductos#">
<br />
<cfflush interval="20">
<cfloop query="SESSION.qproductos"> 
	<cfdump var="#SESSION.qproductos.Modulo#">
	<br />

	<cfif SESSION.qproductos.Modulo EQ 'CXX'>   <!---  *** compras ***  --->
		<!--- se accesa el registro del Voucher  --->
		<cfset queryVoucher = OGeneral.ConsVoucher(SESSION.qproductos.vouchernum)>

		<!--- se accesa el registro de PmiFolios  --->
		<cfset queryFolio = OGeneralProcB.ConsultaFolio(SESSION.qproductos.vouchernum)>
	
		<!--- se accesa el registro de PmiFoliosDetailP, la suma de montos debe ser igual al voucher  --->
		<cfset queryFolioDetail = OGeneralProcB.ConsultaFolioDetail(queryFolio.i_folio, queryFolio.i_anio)>
		
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcB.ConsultaSocioNegocios(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
		
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcB.ValidaTipoContraparte(qSNegocios.SNid)>
		</cfif>
	
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcB.ConsultaLineaProducto(queryFolio.i_empresa, queryFolio.i_folio,
						   'Folio', queryFolioDetail.c_producto)>
	
		<!--- validar si se puede determinar  SOLO SERVICIOS el tipo de operación  --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento
		<cfset qConceptos = OGeneralProcB.ConsultaTipoOperacion(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
																			 --->
	
		<!--- Obtener código de moneda de tabla Monedas  --->
		<cfset vMoneda = OGeneralProcB.ConsultaMoneda(queryFolio.c_moneda)>

		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher          --->
		<cfset queryCostos = OGeneralProcB.ConsultaCostosFact(queryVoucher.voucher_num, 
		                     queryVoucher.voucher_tot_amt, queryFolio.c_docto_proveedor, 'C')>

		<!--- consulta el trade del producto --->
		<cfquery name="qTrade" datasource="preicts">
		
			select  co.cost_type_code, co.cost_code, co.cost_owner_key6, co.cost_owner_key7,
				   co.cost_owner_key8, a5.alloc_type_code from voucher_cost aa
				inner join cost co
	 				on co.cost_num = aa.cost_num
				       and (co.cost_status='PAID' or co.cost_status='VOUCHED')
				inner join trade_item ti
			  	 	on ti.trade_num = co.cost_owner_key6
			       	and ti.order_num = co.cost_owner_key7
	  		       	and ti.item_num = co.cost_owner_key8
				inner join allocation_item ai
			  	 	on ai.trade_num = ti.trade_num
			       	and ai.order_num = ti.order_num
	  		       	and ai.item_num = ti.item_num
				inner join allocation a5
			  	 	on a5.alloc_num = ai.alloc_num
			where aa.voucher_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.qproductos.vouchernum#">
			order by co.cost_amt desc
		</cfquery>

		<!--- se lee información del trade, trade_order, trade_item   --->
		<cfset queryTrade = OGeneral.ConsultaItem(session.qproductos.trade_num, session.qproductos.order_num,
							 session.qproductos.item_num)>
		<cfset vTrade = session.qproductos.trade_num>
		<cfset vOrder_Num = session.qproductos.order_num>
		<cfset vFechaAllocation = "">
		<cfset vFechaPropiedad = "">
		<cfset vPort_Num = "">
		<cfset vNombreBarco = "">
		<cfset vFechaTrade = "">
		<cfset vFechaHoraCarga = "">
		<cfset vFechaHoraSalida = "">
		<cfset vCodEmbarque = "">
		<cfset vNumeroBOL = "">
		<cfset vFechaBOL = "">
		<cfset vCodigoAlmacen = "">
		<cfset vCuentaFinanciera = "">
		<cfset vTipoTransporte = "">
		<cfset vOCtransporte = "">
		<cfset vOCconceptoCompra = "">
		<cfset vCodigoImpuesto = "">
		
		<cfif queryTrade.recordcount GT 0>		
			<cfset vFechaAllocation = queryTrade.fechaAllocation>
			<cfset vFechaPropiedad = queryTrade.title_tran_date>
			<cfset vPort_Num = queryTrade.real_port_num>
			<cfset vFechaTrade = queryTrade.creation_date>
			<cfset vNombreBarco = queryTrade.transportation>
			<cfset vFechaHoraCarga = queryTrade.load_compl_date>
			<cfset vFechaHoraSalida = queryTrade.nor_date>
			<cfset vCodEmbarque = queryTrade.del_term_code>
			<cfset vNumeroBOL = queryTrade.bl_ticket_num>
			<cfif isdate(queryTrade.bl_date)>
				<cfset vFechaBOL = queryTrade.bl_date>
			<cfelse>
				<cfset vFechaBOL = now()>
			</cfif>
			<cfset vTipoTransporte = "Terrestre">
			<cfif qTrade.alloc_type_code EQ 'W'>
				<cfset vTipoTransporte = "Barco">
			</cfif>
			<cfif qTrade.alloc_type_code EQ 'R'>
				<cfset vTipoTransporte = "Ferrocarril">
			</cfif>
		</cfif>

		


		<!--- OCconceptoCompra     --->
		<cfquery name="qConcepto" datasource="preicts">
			SELECT sb.subconcepto_id, r.rel_subconcepto_detalle_id 
			FROM tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r, tesoreria..subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtrade.cost_code#">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtrade.cost_type_code#">
			  AND s.payable_receivable = 'P' 
			  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
			  AND sb.subconcepto_id = r.subconcepto_id
		</cfquery>
		<cfif qConcepto.recordcount GT 0>
			<cfset vOCconceptoCompra = qConcepto.subconcepto_id>
		</cfif>

		<cfif queryFolio.f_iva >0>
			<cfquery name="qTax" datasource="preicts">
				SELECT sb.subconcepto_id, r.rel_subconcepto_detalle_id 
				FROM tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r, tesoreria..subconceptos_detalle s 
				WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtrade.cost_code#">
				  AND s.tipo_costo = 'TAX'
				  AND s.payable_receivable = 'P' 
				  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
				  AND sb.subconcepto_id = r.subconcepto_id
			</cfquery>
			<cfif qTax.recordcount GT 0>
				<cfquery name="qImpuesto" datasource="#Session.Dsn#">
					select * from Conceptos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#qTax.subconcepto_id#">
				</cfquery>
				<cfif qImpuesto.recordcount GT 0>
					<cfset vCodigoImpuesto = qTax.cuentac>
				</cfif>
			</cfif>
		</cfif>

		<!--- Código de Almacén     --->
		<cfset vStruc = OGeneral.ConsultaAlmacen(session.qproductos.trade_num, session.qproductos.order_num,
						 session.qproductos.item_num, 'S')>
		<cfif Len(vStruc.Transporte)>
			<cfset vOCtransporte = vStruc.Transporte>
		<cfelse>
			<cfset vOCtransporte = session.qproductos.orden>
		</cfif>
		<cfif vStruc.Afecta>
			<cfset vOCtipoIC = "I">
		<cfelse>
			<cfset vOCtipoIC = "C">
		</cfif>

		<!--- Armar Cuenta Financiera     --->
		<cfquery name="qCuenta" datasource="#session.DSN#">
			select Cformato from CContables a4
				inner join Articulos a1
					on a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and a1.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qArticulo.Aid#">
				inner join Clasificaciones a2
					on a2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and a2.Ccodigo = a1.Ccodigo
				inner join IAContables a3
					on a3.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and a3.IACcodigogrupo = a2.Ccodigoclas
			where a4.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a4.Ccuenta = a3.IACtransito
		</cfquery>
		<cfif qCuenta.recordcount GT 0>
			<cfset vCuentaFinanciera = qCuenta.Cformato>
		</cfif>

		<!--- suma detalles de queryFolioDetail     --->
		<cfquery name="qsuma" DBTYPE="query">
			select sum(f_volumen) as f_volumen from queryFolioDetail
		</cfquery>

		<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  
		<cfset queryTransporte = OGeneralProcB.DeterminaTransporte(queryCostos.trade_num,
		queryCostos.order_num, queryCostos.item_num)>   --->

		<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
		<cfset vOCid = OGeneralProcB.ExisteOrdenComercial(session.qproductos.orden,
															 session.qproductos.trade_num)>
		<cfif vOCid GT 0>
			<!---			<cfset GraboOk = OGeneralProcB.ReversionNoFact(session.qproductos.orden,
															 session.qproductos.trade_num)>
			--->
			<cfset solopruebas = "">			
		</cfif>
		<cfif vOCid EQ 0>
			<cfset vOCid = OGeneralProcB.IncluirOrdenComercial('O', vOCtipoIC, SESSION.Ecodigo, qSNegocios.SNid, 
			   session.qproductos.orden, vFechaTrade, vMoneda, 0, 'A', 'CP', vCodEmbarque, 
			   vTrade, vOrder_Num, vFechaAllocation, vFechaPropiedad)>
		</cfif>

		<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteOrdenProducto(vOCid, qArticulo.Aid)>
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ActualizarOrdenProducto(vOCid, qArticulo.Aid)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirOrdenProducto(vOCid, qArticulo.Aid, 1, queryFolioDetail.c_unidad, 
			   SESSION.Ecodigo, queryFolioDetail.f_volumen, queryFolioDetail.f_precio, queryFolioDetail.f_importe,
			   0,vPort_Num, vCuentaFinanciera)>
		</cfif>

		<!---  revisa si existe el Transporte en la estructura de órdenes comerciales --->
		<cfset vOCTid = OGeneralProcB.ExisteTransporte(vOCtransporte)>
		<cfif vOCTid EQ 0>
			<cfset vOCTid = OGeneralProcB.IncluirTransporte(SESSION.Ecodigo, vTipoTransporte, vOCtransporte,  
			   'A', vStruc.FechaPartida, cV, cV, cV, vStruc.FechaLlegada, vStruc.NumeroBOL, vStruc.FechaBOL)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.ActualizarTransporte(vOCTid,vOCtransporte)>
		</cfif>

		<!---  revisa si existe el TransporteProducto en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteTransporteProducto(vOCTid,vOCid,qArticulo.Aid)>
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ActualizarTransporte(vOCTid,vOCtransporte)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirTransporteProducto(vOCTid, vOCid, qArticulo.Aid, SESSION.Ecodigo,
			   'F', 'O', vStruc.NumeroBOL, vStruc.FechaBOL, vOCtransporte, vFechaAllocation, vFechaPropiedad,
			   0,0,0,0,0)>
		</cfif>

		<!---  revisa si existe el ProductoTransito en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteProductoTransito(vOCid,qArticulo.Aid)>
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ActualizarProductoTransito(vOCTid, qArticulo.Aid)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirProductoTransito(vOCTid, qArticulo.Aid, SESSION.Ecodigo,
			   0, qsuma.f_volumen, queryFolio.f_importe_total,0,0)>  
		</cfif>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

		<cfif isdefined("vID")>
			<cfset vID = vID + 1>
		<cfelse>
			<!--- Incluir el Encabezado de la Factura en IE10  --->
			<cfquery name="qID" datasource="sifinterfaces">
				select MAX(ID) as valorID
				from IE10
			</cfquery>
	
			<cfif isnumeric(qID.valorID) and qID.valorId GT 0>
				<cfset vID = qID.valorID + 1>
			<cfelse>
				<cfset vID = 1>			
			</cfif>
		</cfif>

		<cfset cC_Tipo_Folio = queryFolio.c_tipo_folio>
		<cfif cC_tipo_Folio EQ 'FA'>
			<cfset cC_Tipo_Folio = "FC">
		</cfif>

		<!--- suma detalles de queryFolioDetail     --->
		<cfset vdiferencia = 0>
		<cfquery name="qsuma" DBTYPE="query">
			select sum(f_importe) as sumaDetalles from queryFolioDetail
		</cfquery>
		<cfif qsuma.recordcount GT 0>
			<cfset vdiferencia = queryFolio.f_importe_total - qsuma.sumaDetalles>
		</cfif>
		
		<!--- Inicia transacción     --->
		<cftransaction>		

		<cfset GraboOk = OGeneralProcB.Inserta_IE10(vID, SESSION.Ecodigo, qSNegocios.SNcodigo, 'CP', 
		       cC_Tipo_Folio, queryFolio.c_docto_proveedor, Cv, queryFolio.c_moneda,
			   queryFolio.dt_fecha_recibo, queryFolio.dt_fecha_vencimiento, '1', 'ICTS', 
			   queryFolio.i_voucher, Cv, Cv, Cv, Cv, '0', Cv, Cv, queryFolio.dt_fecha_recibo, 10)>


		<!--- Incluir los detalles de la Factura en ID10  --->
		<cfset Conse = 0>
		<cfloop query="queryFolioDetail">
			<cfset Conse = Conse + 1>
			
			<cfif Conse EQ 1>
				<cfset vf_importe = queryFolioDetail.f_importe + vdiferencia> 
			<cfelse>
				<cfset vf_importe = queryFolioDetail.f_importe>
			</cfif>

			<cfset GraboOk = OGeneralProcB.Inserta_ID10(vID, Conse, 'A', queryFolioDetail.c_producto, 
				   vNombreBarco, vFechaHoraCarga, vFechaHoraSalida, queryFolioDetail.f_precio,
				   queryFolioDetail.c_unidad, queryFolioDetail.f_volumen, 0, vCodEmbarque, vNumeroBOL, vFechaBOL,
				   Cv, queryFolio.c_orden, vCodigoImpuesto, queryFolio.f_iva, 0, vCodigoAlmacen, Cv, vf_importe,
				   Cv, vCuentaFinanciera, vTipoTransporte, vOCtransporte, queryFolio.c_orden, vOCconceptoCompra)>    

		</cfloop>    <!--- Cierra loop de queryFolioDetail  --->
		<!---   Finaliza transacción      --->
		</cftransaction>

	</cfif>   <!--- ** ** ** ** ** ** **  Cierra if que procesa compras  ** ** ** ** ** ** **   ---> 
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de qproductos  ** ** ** ** ** ** **   --->


<!--- procesa los registros de qproductos, procesa las ventas, campo Modulo='CXC'  --->	
<cfloop query="SESSION.qproductos"> 
	<cfif SESSION.qproductos.Modulo EQ 'CXC'>
		<!--- se accesa el registro del Voucher  --->    <!---  *** ventas ***  --->
		<cfset queryVoucher = OGeneral.ConsVoucher(SESSION.qproductos.vouchernum)>
	
		<!--- se accesa el registro de PmiInvoice  --->
		<cfset queryInvoice = OGeneralProcB.ConsultaInvoice(queryVoucher.voucher_num)>

		<!--- se accesa el registro de PmiInvoiceDetail, la suma de montos debe ser igual al voucher  --->
		<cfset queryInvoiceDetail = OGeneralProcB.ConsultaInvoiceDetail(session.qproductos.vouchernum,
									queryVoucher.voucher_tot_amt)>
	
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo acct_num  --->
		<!--- de PmiInvoice, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcB.ConsultaSocioNegocios(queryInvoice.acctNum, queryInvoice.invoice,'Factura')>

		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcB.ValidaTipoContraparte(qSNegocios.SNid)>
		</cfif>

		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcB.ConsultaLineaProducto(queryInvoice.acctNum, queryInvoice.invoice,
								'Factura', session.qproductos.producto)>

		<!--- Obtener código de moneda de tabla Monedas  --->
		<cfset vMoneda = OGeneralProcB.ConsultaMoneda(queryInvoiceDetail.c_moneda)>

		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
		<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
		<cfset queryCostos = OGeneralProcB.ConsultaCostosFact(queryVoucher.voucher_num, 
		                     queryVoucher.voucher_tot_amt, queryInvoice.invoice,'V')>

		<!--- consulta el trade del producto --->
		<cfquery name="qTrade" datasource="preicts">
			select  co.cost_type_code, co.cost_code, co.cost_owner_key6, co.cost_owner_key7,
				   co.cost_owner_key8, a5.alloc_type_code from voucher_cost aa
				inner join cost co
	 				on co.cost_num = aa.cost_num
				       and (co.cost_status='PAID' or co.cost_status='VOUCHED')
				inner join trade_item ti
			  	 	on ti.trade_num = co.cost_owner_key6
			       	and ti.order_num = co.cost_owner_key7
	  		       	and ti.item_num = co.cost_owner_key8
				inner join allocation_item ai
			  	 	on ai.trade_num = ti.trade_num
			       	and ai.order_num = ti.order_num
	  		       	and ai.item_num = ti.item_num
				inner join allocation a5
			  	 	on a5.alloc_num = ai.alloc_num
			where aa.voucher_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.qproductos.vouchernum#">
			order by co.cost_amt desc
		</cfquery>

		<!--- se lee información del trade, trade_order, trade_item   --->
		<cfset queryTrade = OGeneral.ConsultaItem(session.qproductos.trade_num, session.qproductos.order_num,
							 session.qproductos.item_num)>
		<cfset vTrade = session.qproductos.trade_num>
		<cfset vOrder_Num = session.qproductos.order_num>
		<cfset vFechaTrade = "">
		<cfset vNombreBarco = "">
		<cfset vFechaHoraCarga = "">
		<cfset vFechaHoraSalida = "">
		<cfset vCodEmbarque = "">
		<cfset vNumeroBOL = "">
		<cfset vFechaBOL = "">
		<cfset vCodigoAlmacen = "">
		<cfset vCuentaFinanciera = "">
		<cfset vTipoTransporte = "">
		<cfset vOCtransporte = "">
		<cfset vOCconceptoCompra = "">
		<cfset vTipoVenta = "">
		<cfset vSocioNegocio = "">
		
		<cfif queryTrade.recordcount GT 0>		
			<cfset vFechaAllocation = queryTrade.fechaAllocation>
			<cfset vFechaPropiedad = queryTrade.title_tran_date>
			<cfset vPort_Num = queryTrade.real_port_num>
			<cfset vFechaTrade = queryTrade.creation_date>
			<cfset vNombreBarco = queryTrade.transportation>
			<cfset vFechaHoraCarga = queryTrade.load_compl_date>
			<cfset vFechaHoraSalida = queryTrade.nor_date>
			<cfset vCodEmbarque = queryTrade.del_term_code>
			<cfset vNumeroBOL = queryTrade.bl_ticket_num>
			<cfif isdate(queryTrade.bl_date)>
				<cfset vFechaBOL = queryTrade.bl_date>
			<cfelse>
				<cfset vFechaBOL = now()>
			</cfif>
			<cfset vTipoTransporte = "Terrestre">
			<cfif qTrade.alloc_type_code EQ 'W'>
				<cfset vTipoTransporte = "Barco">
			</cfif>
			<cfif qTrade.alloc_type_code EQ 'R'>
				<cfset vTipoTransporte = "Ferrocarril">
			</cfif>
		</cfif>

		<!--- OCconceptoCompra     --->
		<cfquery name="qConcepto" datasource="preicts">
			SELECT sb.subconcepto_id, r.rel_subconcepto_detalle_id 
			FROM tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r, tesoreria..subconceptos_detalle s 
			WHERE s.costo_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtrade.cost_code#">
			  AND s.tipo_costo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qtrade.cost_type_code#">
			  AND s.payable_receivable = 'P' 
			  AND r.subconcepto_detalle_id = s.subconcepto_detalle_id 
			  AND sb.subconcepto_id = r.subconcepto_id
		</cfquery>
		<cfif qConcepto.recordcount GT 0>
			<cfset vOCconceptoCompra = qConcepto.subconcepto_id>
		</cfif>

		<!--- Código de Almacén     --->
		<cfset vStruc = OGeneral.ConsultaAlmacen(session.qproductos.trade_num, session.qproductos.order_num,
						 session.qproductos.item_num, 'P')>
		<cfset vSocioNegocio = vStruc.Socio>
		<cfset qSNegociosCompra = OGeneralProcB.ConsultaSocioNegocios(vStruc.Socio, queryInvoice.invoice,'Factura')>

		<cfif Len(vStruc.Transporte)>
			<cfset vOCtransporte = vStruc.Transporte>
		<cfelse>
			<cfset vOCtransporte = session.qproductos.orden>
		</cfif>
		<cfif vStruc.Afecta>
			<cfset vOCtipoIC = "I">
		<cfelse>
			<cfset vOCtipoIC = "C">
		</cfif>
		
		<!--- Armar Cuenta Financiera     --->
		<cfif vstruc.Afecta>
			<cfset vTipoVenta = vStruc.Almacen>
		<cfelse>		
			<cfif qSNegocios.esIntercompany>
				<cfset vTipoVenta = "002">
			<cfelse>
				<cfset vTipoContraparte_compra = OGeneralProcB.ValidaTipoContraparte(vSocioNegocio)>
				<cfif vTipoContraparte_compra EQ "NACIONAL">
					<cfset vTipoVenta="004">
				</cfif>
				<cfif vTipoContraparte_compra EQ "EXTRANJERO">
					<cfif qSNegociosCompra.esIntercompany>
						<cfset vTipoVenta="001">
					<cfelse>				
						<cfset vTipoVenta="003">
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfif len(vTipoVenta)>
			<cfquery name="qTventa" datasource="#session.DSN#">
				SELECT CFmascaraIngreso
				FROM OCtipoVenta
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  AND OCVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vTipoVenta#">
			</cfquery>
			<cfif qTventa.recordcount GT 0>
				<cfset vCuentaFinanciera = qTventa.CFmascaraIngreso>
			</cfif>
		</cfif>
		
		<cfset vCompleSocio = Mid(qSNegocios.CFcomplementoIngreso,1,3) & "-" & Mid(qSNegocios.CFcomplementoIngreso,4,3)>
		<cfset vCompleArticulo = Mid(qarticulo.CFcomplementoIngreso,1,3) & "-" & Mid(qarticulo.CFcomplementoIngreso,4,3)>
		<cfif len(vTipoVenta)>
			<cfset vCuentaFinanciera = Replace(vCuentaFinanciera,"CCC","001")>
			<cfset vCuentaFinanciera = Replace(vCuentaFinanciera,"AAA-AAA", vCompleArticulo)>
			<cfset vCuentaFinanciera = Replace(vCuentaFinanciera,"SSS-SSS", vCompleSocio)>
		</cfif>		

		<!--- suma detalles de queryFolioDetail     --->
		<cfquery name="qsuma" DBTYPE="query">
			select sum(f_vol_nvo) as f_volumen, sum(f_importe) as f_importe from queryInvoiceDetail
		</cfquery>
		<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  --->

		<!---  revisa si existe la Orden en la estructura de órdenes comerciales --->
		<cfset vOCid = OGeneralProcB.ExisteOrdenComercial(session.qproductos.orden,
															 session.qproductos.trade_num)>
		<cfif vOCid GT 0>
			<!---			<cfset GraboOk = OGeneralProcB.ReversionNoFact(session.qproductos.orden,
															 session.qproductos.trade_num)>
			--->
			<cfset solopruebas = "">			
		</cfif>
		<cfif vOCid EQ 0>
			<cfset vOCid = OGeneralProcB.IncluirOrdenComercial('D', vOCtipoIC, SESSION.Ecodigo, qSNegocios.SNid, 
			   session.qproductos.orden, vFechaTrade, vMoneda, 0, 'A', 'CC', vCodEmbarque, 
			   vTrade, vOrder_Num, vFechaAllocation, vFechaPropiedad)>
		</cfif>

		<!---  revisa si existe la OrdenProducto en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteOrdenProducto(vOCid, qArticulo.Aid)>
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ActualizarOrdenProducto(vOCid, qArticulo.Aid)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirOrdenProducto(vOCid, qArticulo.Aid, 1, queryInvoiceDetail.c_unidades, 
			   SESSION.Ecodigo, queryInvoiceDetail.f_vol_nvo, queryInvoiceDetail.f_precio_nvo, queryInvoiceDetail.f_importe,
			   0,vPort_Num, vCuentaFinanciera)>
		</cfif>

		<!---  revisa si existe el Transporte en la estructura de órdenes comerciales --->
		<cfset vOCTid = OGeneralProcB.ExisteTransporte(vOCtransporte)>
		<cfif vOCTid EQ 0>
			<cfset vOCTid = OGeneralProcB.IncluirTransporte(SESSION.Ecodigo, vTipoTransporte, vOCtransporte,  
			   'A', vStruc.FechaPartida, cV, cV, cV, vStruc.FechaLlegada, vStruc.NumeroBOL, vStruc.FechaBOL)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.ActualizarTransporte(vOCTid,vOCtransporte)>
		</cfif>

		<!---  revisa si existe el TransporteProducto en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteTransporteProducto(vOCTid,vOCid,qArticulo.Aid)>
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ActualizarTransporte(vOCTid,vOCtransporte)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirTransporteProducto(vOCTid, vOCid, qArticulo.Aid, SESSION.Ecodigo,
			   'F', 'D', vStruc.NumeroBOL, vStruc.FechaBOL, vOCtransporte, vFechaAllocation, vFechaPropiedad,
			   0,0,0,0,0)>
		</cfif>

		<!---  revisa si existe el ProductoTransito en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteProductoTransito(vOCid,qArticulo.Aid)>
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ActualizarProductoTransito(vOCTid, qArticulo.Aid)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirProductoTransito(vOCTid, qArticulo.Aid, SESSION.Ecodigo,
			   0, qsuma.f_volumen, qsuma.f_importe,0,0)>  
		</cfif>
		<!--- FIN SECCION ORDENES COMERCIALES  --->
		
		<cfif isdefined("vID")>
			<cfset vID = vID + 1>
		<cfelse>
			<!--- Incluir el Encabezado de la Factura en IE10  --->
			<cfquery name="qID" datasource="sifinterfaces">
				select MAX(ID) as valorID
				from IE10
			</cfquery>
	
			<cfif isnumeric(qID.valorID) and qID.valorId GT 0>
				<cfset vID = qID.valorID + 1>
			<cfelse>
				<cfset vID = 1>			
			</cfif>
		</cfif>

		<cfset cC_Tipo_Invoice = queryInvoice.invoiceType>
		<cfif "F,G,K,p,R,W,w" CONTAINS cC_tipo_Invoice>
			<cfset cC_Tipo_Invoice = "FC">
		<cfelse>
			<cfif cC_tipo_Invoice EQ "c">
				<cfset cC_Tipo_Invoice = "NC">
			<cfelse>
				<cfset cC_Tipo_Invoice = "ND">
			</cfif>
		</cfif>

		<!--- suma detalles de queryInvoiceDetail     --->
		<cfset vdiferencia = 0>
		<cfset vnombreQuery = "">
		<cfquery name="qDetFact" datasource="preicts">
			select a1.c_unidades, a1.f_vol_nvo, a1.f_precio_nvo as precio_ant, a2.f_precio_nvo as precio_nvo,
					a1.f_importe as importe_ant, a2.f_importe as importe_nvo
			from PmiInvoiceDetail a1
				inner join PmiInvoiceDetail a2
				    on a2.relatedInvoice = a1.relatedInvoice
				    and a2.i_consecutivo < 0
			where a1.i_consecutivo > 0
		</cfquery>
		<cfif qDetFact.recordcount GT 0>
			<cfset vnombreQuery = "qDetFact">
			<cfset vTotMonDet = 0>
			<cfloop query="qDetFact">
				<cfif qDetFact.precio_ant GT precio_nvo>
					<cfset vTotMonDet = vTotMonDet + (qDetFact.importe_ant - qDetFact.importe_nvo)>
				<cfelse>
					<cfset vTotMonDet = vTotMonDet + (qDetFact.importe_ant + qDetFact.importe_nvo)>
				</cfif>
			</cfloop>
			<cfset vdiferencia = queryVoucher.voucher_tot_amt - vTotMonDet>
		<cfelse>
			<cfset vnombreQuery = "queryInvoiceDetail">
			<cfquery name="qsuma" DBTYPE="query">
				select sum(f_importe) as sumaDetalles from queryInvoiceDetail
			</cfquery>
			
			<cfif qsuma.recordcount GT 0>
				<cfset vdiferencia = queryVoucher.voucher_tot_amt - qsuma.sumaDetalles>
			</cfif>
		</cfif>
		
		<!--- Inicia transacción     --->
		<cftransaction>		

		<cfset GraboOk = OGeneralProcB.Inserta_IE10(vID, SESSION.Ecodigo, qSNegocios.SNcodigo, 'CC', 
		       cC_Tipo_Invoice, queryInvoice.invoice, Cv, queryInvoiceDetail.c_moneda,
			   queryInvoice.invoiceDate, queryInvoice.dueDate, '1', 'ICTS', 
			   queryInvoice.voucherNum, Cv, Cv, Cv, Cv, '0', Cv, Cv, queryInvoice.invoiceDate, 10)>

		<!--- Incluir los detalles de la Factura en ID10  --->
		<cfset Conse = 0>
		<cfloop query="#vnombreQuery#">
			<cfif vnombreQuery EQ 'queryInvoiceDetail'>
				<cfset ws_f_Importe = queryInvoiceDetail.f_importe>
				<cfset ws_f_precio_nvo = queryInvoiceDetail.f_precio_nvo>
				<cfset ws_c_unidades = queryInvoiceDetail.c_unidades>
				<cfset ws_f_vol_nvo = queryInvoiceDetail.f_vol_nvo>
			<cfelse>
				<cfset ws_f_Importe = qDetFact.importe_nvo>
				<cfset ws_f_precio_nvo = qDetFact.precio_nvo>
				<cfset ws_c_unidades = qDetFact.c_unidades>
				<cfset ws_f_vol_nvo = qDetFact.f_vol_nvo>
			</cfif>
		
			<cfset Conse = Conse + 1>
			
			<cfif Conse EQ 1>
				<cfset vf_importe = queryInvoiceDetail.f_importe + vdiferencia> 
			<cfelse>
				<cfset vf_importe = queryInvoiceDetail.f_importe>
			</cfif>

			<cfset GraboOk = OGeneralProcB.Inserta_ID10(vID, Conse, 'A', queryCostos.producto, 
				   vNombreBarco, vFechaHoraCarga, vFechaHoraSalida, ws_f_precio_nvo,
				   ws_c_unidades, ws_f_vol_nvo, 0, vCodEmbarque, vNumeroBOL, vFechaBOL,
				   Cv, queryInvoice.yourRefNum, Cv, 0, 0, vCodigoAlmacen, Cv, vf_importe,
				   Cv, vCuentaFinanciera, vTipoTransporte, vOCtransporte, queryInvoice.yourRefNum, vOCconceptoCompra)>    

		</cfloop>    <!--- Cierra loop de queryInvoiceDetail  --->
		<!---   Finaliza transacción      --->
		</cftransaction>

	</cfif> 	 <!--- ** ** ** ** ** ** **  Cierra if que procesa ventas  ** ** ** ** ** ** **   ---> 
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de qproductos  ** ** ** ** ** ** **   --->


