<!--- Archivo    :  SQLAplicaNoFact.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  En el proceso A, se valida la información y el usuario decide si se procesan los 
	                productos NoFact, si decide procesar se ejecuta este proceso(B), en este proceso se graba
					la información en las tablas IE10, ID10 y en la Estructura de Ordenes Comerciales.
	  --->

<!--- Se define el objeto principal  --->
<cfobject name="OFacturaProducto" component="interfasesPMI.Componentes.CFacturaProducto">

<!--- Se definen otros objetos a utilizar  --->
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcB" component="interfasesPMI.Componentes.CGeneralProcB">

<!--- Variables de Socio de Negocios, Tipo de Venta, Tipo de Contraparte, etc.  --->
<cfset SESSION.HayErrores = false>
<cfset VsocioNegocio = "">
<cfset Cv = "">         <!--- usado como cadena vacía en los "insert"  --->
	
<!--- procesa los registros de qproductos, primero procesa las compras, campo Modulo='CXP'  --->	
<cfloop query="SESSION.qproductos"> 
	<cfif SESSION.qproductos.Modulo EQ 'CXP'>   <!---  *** compras ***  --->
		<!--- se accesa el registro del Voucher  --->
		<cfset queryVoucher = OGeneral.ConsVoucher(SESSION.qproductos.voucher_num)>

		<!--- se accesa el registro de PmiFolios  --->
		<cfset queryFolio = OGeneralProcB.ConsultaFolio(SESSION.qproductos.voucher_num)>
	
		<!--- se accesa el registro de PmiFoliosDetailP, la suma de montos debe ser igual al voucher  --->
		<cfset queryFolioDetail = OGeneralProcB.ConsultaFolioDetail(SESSION.qproductos.voucher_num,
		queryVoucher.voucher_tot_amt)>
		
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcB.ConsultaSocioNegocios(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
	
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la zona geográfica, si es "México" es Nacional, de lo contrario es Extranjero --->
		<cfset OGeneralProcB.ValidaTipoContraparte(queryFolio.i_empresa, queryFolio.i_folio,
							'Folio',qSNegocios.intercompania)>
	
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcB.ConsultaLineaProducto(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
	
		<!--- validar si se puede determinar el tipo de operación  --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qConceptos = OGeneralProcB.ConsultaTipoOperacion(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
	
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
		<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
		<cfset queryCostos = OGeneralProcB.ConsultaCostos(queryCompras.voucher_num)>

		<!--- Obtener código de moneda de tabla Monedas  --->
		<cfset vMoneda = OGeneralProcB.ConsultaMoneda(SESSION.Ecodigo, queryFolio.c_moneda)>
		<!--- Obtener el precio promedio de PmiFoliosDetailP y la unidad  --->
		<cfset vStru_Precio = OGeneralProcB.PrecioPromedio(queryFolio)>
		<!--- Determinar transporte del producto, si no hay debe crearse  --->
		<cfset queryTransporte = OGeneralProcB.DeterminaTransporte(queryCostos.trade_num,
		queryCostos.order_num, queryCostos.item_num)>

		<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  
		<cfset queryTransporte = OGeneralProcB.DeterminaTransporte(queryCostos.trade_num,
		queryCostos.order_num, queryCostos.item_num)>   --->

		<!---  revisa si existe el NoFact en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteNoFact(queryCostos.trade_num, queryCostos.order_num)>
		
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ReversionNoFact(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActulizarOrden(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActulizarOrdenProducto(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActualizarProductoTransito(queryCostos.trade_num, queryCostos.order_num)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirOrden(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirOrdenProducto(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirTransporte(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirTransporteProducto(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirProductoTransito(queryCostos.trade_num, queryCostos.order_num)>
		</cfif>
					
		<!---  Actualizar la Estructura de Ordenes Comerciales  --->
		<!--- Incluir la orden comercial  --->
		<cfset vOCid = OGeneral.Inserta_OCordenComercial('O', 'C', SESSION.Ecodigo, qSNegocios.SNcodigo, 
			   queryFolio.c_orden, vFechaTrade, vMoneda, 0, 'F', 'CP', queryAllocItem.del_term_code, 
			   vTrade, vOrder_Num, vFechaAllocation, vFechaPropiedad)>
		<!--- incluir la OrdenProducto solo si no existe --->
		<cfset GraboOk = OGeneral.Inserta_OCordenProducto(vOCid, vArticulo, Conse, queryFolioDetail.c_unidad, 
			   SESSION.Ecodigo, queryFolioDetail.f_volumen, queryFolioDetail.f_precio, 
			   queryFolioDetail.f_importe)>

		<!--- Incluir OCtransporte  --->
		<cfset GraboOk = OGeneral.Inserta_OCtransporte(SESSION.Ecodigo, vTipoTransporte, v_Acct_Ref_Num, 
			   cV, vFechaLlegada)>
		<!--- incluir OCtrasporteProducto  --->
		<cfset GraboOk = OGeneral.Inserta_OCtrasporteProducto()>
		<!--- incluir OcproductoTransito  --->
		<cfset GraboOk = OGeneral.Inserta_OCproductoTransito()>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

		<!--- Incluir el Encabezado de la Factura en IE10  --->
		<cfquery name="qID" datasource="sifinterfaces">
			select MAX(ID) as valorID
			from IE10
			where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif qID.recordcount GT 0>
			<cfset vID = qID.valorID>
		<cfelse>
			<cfset vID = 1>			
		</cfif>
		
		<cfset GraboOk = OGeneralProcB.Inserta_IE10(vID, SESSION.Ecodigo, qSNegocios.SNcodigo, 'CP', 
		       queryFolio.c_tipo_folio, queryFolio.c_docto_proveedor, Cv, queryFolio.c_moneda,
			   queryFolio.dt_fecha_recibo, queryFolio.dt_fecha_vencimiento, '1', 'ICTS', 
			   queryFolio.i_voucher, Cv, Cv, Cv, Cv, '0', Cv, Cv, Cv, '10')>
		
		<!--- Incluir los detalles de la Factura en ID10  --->
		<cfset Conse = 0>
		<cfloop query="queryFolioDetail">
			<cfset Conse = Conse + 1>
			<!--- se lee información del trade, trade_order, trade_item   --->
			<cfset vStru_Trade = OGeneral.ConsultaItem(queryCostos.trade_num,
			queryCostos.order_num, queryCostos.item_num)>

			<cfset GraboOk = OGeneralProcB.Inserta_ID10(vID, Conse, 'P', queryFolioDetail.c_producto, 
				   vNombreBarco, vFechaHoraCarga, vFechaHoraSalida, queryFolioDetail.f_precio,
				   queryFolioDetail.c_unidad, queryFolioDetail.f_importe, 0, Cv, vNumeroBOL, vFechaBOL,
				   Cv, queryFolio.c_orden, Cv, 0, 0, Cv, Cv, queryFolioDetail.f_importe, Cv, Cv,
				   vTipoTransporte, Cv, queryFolio.c_orden, Cv)>
			
		</cfloop>    <!--- Cierra loop de queryFolioDetail  --->

	
	</cfif>   <!--- ** ** ** ** ** ** **  Cierra if que procesa compras  ** ** ** ** ** ** **   ---> 
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de qproductos  ** ** ** ** ** ** **   --->

<!--- procesa los registros de qproductos, procesa las ventas, campo Modulo='CXC'  --->	
<cfloop query="qproductos"> 
	<cfif SESSION.qproductos.Modulo EQ 'CXC'>
		<!--- se accesa el registro del Voucher  --->    <!---  *** ventas ***  --->
		<cfset queryVoucher = OGeneral.ConsVoucher(SESSION.qproductos.voucher_num)>
	
		<!--- se accesa el registro de PmiInvoice  --->
		<cfset queryInvoice = OGeneralProcB.ConsultaInvoice(queryVentas.voucher_num)>

		<!--- se accesa el registro de PmiInvoiceDetail, la suma de montos debe ser igual al voucher  --->
		<cfset queryInvoiceDetail = OGeneralProcB.ConsultaInvoiceDetail(queryVentas.voucher_num,
		queryInvoice.invoiceDate, queryInvoice.invoiceType, queryVentas.voucher_tot_amt,
		queryInvoice.invoice)>
	
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo acct_num  --->
		<!--- de PmiInvoice, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcB.ConsultaSocioNegocios(queryInvoice.acct_num, queryInvoice.factura,'Factura')>

		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la zona geográfica, si es "México" es Nacional, de lo contrario es Extranjero --->
		<cfset OGeneralProcB.ValidaTipoContraparte(queryInvoice.acct_num, queryInvoice.factura,
		                    'Factura',qSNegocios.intercompania)>

		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcB.ConsultaLineaProducto(queryInvoice.acct_num, queryInvoice.invoice,'Factura')>

		<!--- validar si se puede determinar el tipo de operación  --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qConceptos = OGeneralProcB.ConsultaTipoOperacion(queryInvoice.acct_num, queryInvoice.invoice,'Factura')>

		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
		<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
		<cfset queryCostos = OGeneralProcB.ConsultaCostos(queryVentas.voucher_num)>


		<!--- Obtener código de moneda de tabla Monedas  --->
		<cfset vMoneda = OGeneralProcB.ConsultaMoneda(SESSION.Ecodigo, queryFolio.c_moneda)>
		<!--- Obtener el precio promedio de PmiFoliosDetailP y la unidad  --->
		<cfset vStru_Precio = OGeneralProcB.PrecioPromedio(queryFolio)>
		<!--- Determinar transporte del producto, si no hay debe crearse  --->
		<cfset queryTransporte = OGeneralProcB.DeterminaTransporte(queryCostos.trade_num,
		queryCostos.order_num, queryCostos.item_num)>

		<!---  Seccion de ORDENES COMERCIALES Determinar transporte del producto, si no hay debe crearse  
		<cfset queryTransporte = OGeneralProcB.DeterminaTransporte(queryCostos.trade_num,
		queryCostos.order_num, queryCostos.item_num)>   --->

		<!---  revisa si existe el NoFact en la estructura de órdenes comerciales --->
		<cfset YaExiste = OGeneralProcB.ExisteNoFact(queryCostos.trade_num, queryCostos.order_num)>
		
		<cfif YaExiste>
			<cfset GraboOk = OGeneralProcB.ReversionNoFact(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActulizarOrden(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActulizarOrdenProducto(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActualizarProductoTransito(queryCostos.trade_num, queryCostos.order_num)>
		<cfelse>
			<cfset GraboOk = OGeneralProcB.IncluirOrden(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirOrdenProducto(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirTransporte(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.IncluirTransporteProducto(queryCostos.trade_num, queryCostos.order_num)>
			<cfset GraboOk = OGeneralProcB.ActualizarProductoTransito(queryCostos.trade_num, queryCostos.order_num)>
		</cfif>
					
		<!---  Actualizar la Estructura de Ordenes Comerciales  --->
		<!--- Incluir la orden comercial  --->
		<cfset vOCid = OGeneral.Inserta_OCordenComercial('O', 'C', SESSION.Ecodigo, qSNegocios.SNcodigo, 
			   queryFolio.c_orden, vFechaTrade, vMoneda, 0, 'F', 'CP', queryAllocItem.del_term_code, 
			   vTrade, vOrder_Num, vFechaAllocation, vFechaPropiedad)>
		<!--- incluir la OrdenProducto solo si no existe --->
		<cfset GraboOk = OGeneral.Inserta_OCordenProducto(vOCid, vArticulo, Conse, queryFolioDetail.c_unidad, 
			   SESSION.Ecodigo, queryFolioDetail.f_volumen, queryFolioDetail.f_precio, 
			   queryFolioDetail.f_importe)>

		<!--- Incluir OCtransporte  --->
		<cfset GraboOk = OGeneral.Inserta_OCtransporte(SESSION.Ecodigo, vTipoTransporte, v_Acct_Ref_Num, 
			   cV, vFechaLlegada)>
		<!--- incluir OCtrasporteProducto  --->
		<cfset GraboOk = OGeneral.Inserta_OCtrasporteProducto()>
		<!--- incluir OcproductoTransito  --->
		<cfset GraboOk = OGeneral.Inserta_OCproductoTransito()>
		<!--- FIN SECCION ORDENES COMERCIALES  --->

		<!--- Incluir el Encabezado de la Factura en IE10  --->
		<cfquery name="qID" datasource="sifinterfaces">
			select MAX(ID) as valorID
			from IE10
			where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif qID.recordcount GT 0>
			<cfset vID = qID.valorID>
		<cfelse>
			<cfset vID = 1>			
		</cfif>
		
		<cfset GraboOk = OGeneral.Inserta_IE10(vID, SESSION.Ecodigo, qSNegocios.SNcodigo, 'CP', 
		       queryFolio.c_tipo_folio, queryFolio.c_docto_proveedor, Cv, queryFolio.c_moneda,
			   queryFolio.dt_fecha_recibo, queryFolio.dt_fecha_vencimiento, '1', 'ICTS', 
			   queryFolio.i_voucher, Cv, Cv, Cv, Cv, '0', Cv, Cv, Cv, '10')>
		
		<!--- Incluir los detalles de la Factura en ID10  --->
		<cfset Conse = 0>
		<cfloop query="queryFolioDetail">
			<cfset Conse = Conse + 1>
			<!--- se lee información del trade, trade_order, trade_item   --->
			<cfset vStru_Trade = OGeneral.ConsultaItem(queryCostos.trade_num,
			queryCostos.order_num, queryCostos.item_num)>

			<cfset GraboOk = OGeneral.Inserta_ID10(vID, Conse, 'P', queryFolioDetail.c_producto, 
				   vNombreBarco, vFechaHoraCarga, vFechaHoraSalida, queryFolioDetail.f_precio,
				   queryFolioDetail.c_unidad, queryFolioDetail.f_importe, 0, Cv, vNumeroBOL, vFechaBOL,
				   Cv, queryFolio.c_orden, Cv, 0, 0, Cv, Cv, queryFolioDetail.f_importe, Cv, Cv,
				   vTipoTransporte, Cv, queryFolio.c_orden, Cv)>
			
		</cfloop>    <!--- Cierra loop de queryFolioDetail  --->
		
	</cfif> 	 <!--- ** ** ** ** ** ** **  Cierra if que procesa ventas  ** ** ** ** ** ** **   ---> 
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de qproductos  ** ** ** ** ** ** **   --->
