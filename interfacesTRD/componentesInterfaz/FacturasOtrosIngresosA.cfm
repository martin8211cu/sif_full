<!--- Archivo    :  FacturasProductosA.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  Consulta, valida y graba las facturas de compra y venta de productos en la 
					variable de SESSION qproductos, si hay errores los graba en la variable de 
					SESSION qerrores, luego el usuario decide si procesa los registros.
	  --->

<!--- Se define el query de SESSION para procesar productos, y bandera de error   --->
<cfset SESSION.EmpresaICTS = "">
<cfset SESSION.DescripcionICTS = "">
<cfset SESSION.HayErrores = false>
<cfset SESSION.qproductos = QueryNew("orden, trade_num, order_num, item_num, socionegocio, producto,
		fechavoucher, vouchernum, importe, modulo, tipotransaccion, tipoventa, Ecodigo, EmpresaICTS")>
		
<!--- Se define el query de SESSION para procesar errores   --->
<cfset SESSION.qerrores = QueryNew("Ecodigo, FechaProceso, FechaDocumento, TipoDocumento, LineaNegocio,
		UsuarioProceso, MensajeError, Documento, Modulo, Monto, TipoAplicacion, Trade_Num, Order_num, Item_num")>

<!--- Accesar tabla de catálogo de empresas ICTS-SOIN  --->
<cfset SESSION.EmpresaICTS = OGeneralProcA.ConsultaEmpresaICTS(Session.Ecodigo)>
<cfset SESSION.DescripcionICTS = OGeneral.ConsultaDescripcionICTS(Session.EmpresaICTS)>

<!--- Se define el objeto principal  --->
<cfobject name="OFacturaProducto" component="interfasesPMI.Componentes.CFacturaProducto">

<!--- Se definen otros objetos a utilizar  --->
<cfobject name="OGeneral" component="interfasesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcA" component="interfasesPMI.Componentes.CGeneralProcA">

<!--- Accesar tabla de Vouchers  --->
<cfset queryVoucher = OGeneral.ConsultaVouchers(EmpresaICTS)>
	
<!--- ** ** ** ** ** ** **   Crea el query de Compras  ** ** ** ** ** ** **     --->
<cfset queryCompras = OFacturaProducto.VouchersDeCompras(queryVoucher)>

<!--- procesa los registros de compra  --->	
<cfloop query="queryCompras"> 
	<!--- se accesa el registro de PmiFolios  --->
	<cfset queryFolio = OGeneralProcA.ConsultaFolio(queryCompras.voucher_num)>

	<cfif SESSION.HayErrores = false>
		<!--- se accesa el registro de PmiFoliosDetailP, la suma de montos debe ser igual al voucher  --->
		<cfset queryFolioDetail = OGeneralProcA.ConsultaFolioDetail(queryCompras.voucher_num,
		queryFolio.dt_fecha_vencimiento, queryFolio.c_tipo_folio, queryCompras.voucher_tot_amt,
		queryFolio.i_folio)>
	</cfif>
	
	<cfif SESSION.HayErrores = false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la zona geográfica, si es "México" es Nacional, de lo contrario es Extranjero --->
		<cfset OGeneralProcA.ValidaTipoContraparte(queryFolio.i_empresa, queryFolio.i_folio,
		                    'Folio',qSNegocios.intercompania)>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar el tipo de operación  --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qConceptos = OGeneralProcA.ConsultaTipoOperacion(queryFolio.i_empresa, queryFolio.i_folio,'Folio')>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar el tipo de contraparte y el socio de negocio  --->
		<!--- consultar el campo ccuenta de la tabla SNegocios y revisar que contenga los  --->
		<!--- campos correspondientes a Tipo de Contraparte y Socio de Negocios --->
		<cfif Len(qSNegocios.ccuenta) < 6>
			<!--- se inserta el registro en query "qerrores"   --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Folio")>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio",queryFolio.i_empresa)>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No existe el complemento de Tipo Contraparte y S.N.")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",queryFolio.i_folio)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","CXP")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = false>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
		<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostos(queryCompras.voucher_num)>
	</cfif>

	<cfif SESSION.HayErrores = false> 
		<!--- se procesan los costos agrupados por orden-producto, se valida  --->
		<cfloop query="queryCostos">
			<!--- se lee el trade, trade_order, trade_item   --->
			<cfset queryItem = OGeneral.ConsultaItem(queryCostos.trade_num,
			queryCostos.order_num, queryCostos.item_num)>

			<!--- se inserta el registro en query "qproductos"   --->}
			<cfset QueryAddRow(SESSION.qproductos)>
			<cfset QuerySetCell(SESSION.qproductos,"orden",queryItem.acct_ref_num)>
			<cfset QuerySetCell(SESSION.qproductos,"trade_num",queryItem.trade_num)>
			<cfset QuerySetCell(SESSION.qproductos,"order_num",queryItem.order_num)>
			<cfset QuerySetCell(SESSION.qproductos,"item_num",queryItem.item_num)>
			<cfset QuerySetCell(SESSION.qproductos,"socionegocio",queryFolio.i_empresa)>
			<cfset QuerySetCell(SESSION.qproductos,"producto",queryItem.cmdty_code)>
			<cfset QuerySetCell(SESSION.qproductos,"fechavoucher",queryCompras.voucher_creation_date)>
			<cfset QuerySetCell(SESSION.qproductos,"vouchernum",queryCompras.voucher_num)>
			<cfset QuerySetCell(SESSION.qproductos,"importe",queryCostos.cost_amt)>
			<cfset QuerySetCell(SESSION.qproductos,"modulo","CXP")>
			<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",queryFolio.c_tipo_folio)>
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", EmpresaICTS)>

		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryCompras  ** ** ** ** ** ** **   --->

<!--- ** ** ** ** ** ** **   Crea el query de Ventas  ** ** ** ** ** ** **     --->
<cfset queryVentas = OFacturaProducto.VouchersDeVentas(queryVoucher)>

<!--- procesa los registros de Venta  --->	
<cfloop query="queryVentas"> 
	<!--- se accesa el registro de PmiInvoice  --->
	<cfset queryInvoice = OGeneralProcA.ConsultaInvoice(queryVentas.voucher_num)>

	<cfif SESSION.HayErrores = false>
		<!--- se accesa el registro de PmiInvoiceDetail, la suma de montos debe ser igual al voucher  --->
		<cfset queryInvoiceDetail = OGeneralProcA.ConsultaInvoiceDetail(queryVentas.voucher_num,
		queryInvoice.invoiceDate, queryInvoice.invoiceType, queryVentas.voucher_tot_amt,
		queryInvoice.invoice)>
	</cfif>
	
	<cfif SESSION.HayErrores = false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo acct_num  --->
		<!--- de PmiInvoice, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryInvoice.acct_num, queryInvoice.factura,'Factura')>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la zona geográfica, si es "México" es Nacional, de lo contrario es Extranjero --->
		<cfset OGeneralProcA.ValidaTipoContraparte(queryInvoice.acct_num, queryInvoice.factura,
		                    'Factura',qSNegocios.intercompania)>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryInvoice.acct_num, queryInvoice.invoice,'Factura')>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar el tipo de operación  --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qConceptos = OGeneralProcA.ConsultaTipoOperacion(queryInvoice.acct_num, queryInvoice.invoice,'Factura')>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- validar si se puede determinar el tipo de contraparte y el socio de negocio  --->
		<!--- consultar el campo ccuenta de la tabla SNegocios y revisar que contenga los  --->
		<!--- campos correspondientes a Tipo de Contraparte y Socio de Negocios --->
		<cfif Len(qSNegocios.ccuenta) < 6>
			<!--- se inserta el registro en query "qerrores"   --->
			<cfset QueryAddRow(SESSION.qerrores)>
			<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
			<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento","")>
			<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Factura")>
			<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio",queryInvoice.acct_num)>
			<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
			<cfset QuerySetCell(SESSION.qerrores,"MensajeError","No existe el complemento de Tipo Contraparte y S.N.")>
			<cfset QuerySetCell(SESSION.qerrores,"Documento",queryInvoice.invoice)>
			<cfset QuerySetCell(SESSION.qerrores,"Modulo","CXC")>
			<cfset QuerySetCell(SESSION.qerrores,"Monto",0)>
			<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
			<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
			<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
			<cfset SESSION.HayErrores = false>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores = false>
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
		<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostos(queryVentas.voucher_num)>
	</cfif>

	<cfif SESSION.HayErrores = false> 
		<!--- se procesan los costos agrupados por orden-producto, se valida  --->
		<cfloop query="queryCostos">
			<!--- se lee el trade, trade_order, trade_item   --->
			<cfset queryItem = OGeneral.ConsultaItem(queryCostos.trade_num,
			queryCostos.order_num, queryCostos.item_num)>

			<!--- se inserta el registro en query "qproductos"   --->}
			<cfset QueryAddRow(SESSION.qproductos)>
			<cfset QuerySetCell(SESSION.qproductos,"orden",queryItem.acct_ref_num)>
			<cfset QuerySetCell(SESSION.qproductos,"trade_num",queryItem.trade_num)>
			<cfset QuerySetCell(SESSION.qproductos,"order_num",queryItem.order_num)>
			<cfset QuerySetCell(SESSION.qproductos,"item_num",queryItem.item_num)>
			<cfset QuerySetCell(SESSION.qproductos,"socionegocio",queryInvoice.acct_num)>
			<cfset QuerySetCell(SESSION.qproductos,"producto",queryItem.cmdty_code)>
			<cfset QuerySetCell(SESSION.qproductos,"fechavoucher",queryVentas.voucher_creation_date)>
			<cfset QuerySetCell(SESSION.qproductos,"vouchernum",queryVentas.voucher_num)>
			<cfset QuerySetCell(SESSION.qproductos,"importe",queryCostos.cost_amt)>
			<cfset QuerySetCell(SESSION.qproductos,"modulo","CXP")>
			<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",queryInvoice.invoiceType)>
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", EmpresaICTS)>

		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryVentas  ** ** ** ** ** ** **   --->

<!--- Se despliega mensaje de error si no se encontraron registros para el proceso  --->
<cfif queryVentas.recordcount = 0 and queryVentas.recordcount = 0>
	<cfthrow message="No se encontraron registros para el proceso">
</cfif>
