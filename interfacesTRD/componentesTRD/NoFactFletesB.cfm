<!--- Archivo    :  FacturasProductosB.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  En el proceso A, se valida la información y el usuario decide si se procesan los 
	                productos, si decide procesar se ejecuta este proceso(B), en este proceso se graba
					la información en las tablas IE10, ID10 y en la Estructura de Ordenes Comerciales.
	  --->

<!--- Se define el objeto principal  --->
<cfobject name="OFacturaProducto" component="interfasesPMI.Componentes.CFacturaProducto">

<!--- Se definen otros objetos a utilizar  --->
<cfobject name="OGeneral" component="interfasesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcB" component="interfasesPMI.Componentes.CGeneralProcB">

<!--- Variables de Socio de Negocios, Tipo de Venta, Tipo de Contraparte, etc.  --->
<cfset SESSION.HayErrores = false>
<cfset VsocioNegocio = "">
	
<!--- procesa los registros de qproductos, primero procesa las compras, campo Modulo='CXP'  --->	
<cfloop query="SESSION.qproductos"> 
	<cfif SESSION.qproductos.Modulo = 'CXP'>
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
	
		<!--- se procesan los costos agrupados por orden-producto, se valida  --->
		<cfloop query="queryCostos">
			<!--- se lee el trade, trade_order, trade_item   --->
			<cfset queryItem = OGeneral.ConsultaItem(queryCostos.trade_num,
			queryCostos.order_num, queryCostos.item_num)>
	
			<!--- se inserta el registro en IE10 y en ID10   --->
		
			<!--- se modifica la estructura de órdenes comerciales  --->
	
	
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	
	</cfif>   <!--- ** ** ** ** ** ** **  Cierra if que procesa compras  ** ** ** ** ** ** **   ---> 
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de qproductos  ** ** ** ** ** ** **   --->

<!--- procesa los registros de qproductos, procesa las ventas, campo Modulo='CXC'  --->	
<cfloop query="qproductos"> 
	<cfif SESSION.qproductos.Modulo = 'CXC'>
		<!--- se accesa el registro del Voucher  --->
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

		<!--- se procesan los costos agrupados por orden-producto, se valida  --->
		<cfloop query="queryCostos">
			<!--- se lee el trade, trade_order, trade_item   --->
			<cfset queryItem = OGeneral.ConsultaItem(queryCostos.trade_num,
			queryCostos.order_num, queryCostos.item_num)>
	
	
			<!--- se inserta el registro en IE10 y en ID10   --->
		
			<!--- se modifica la estructura de órdenes comerciales  --->
	
	
	
	
		</cfloop>    <!--- Cierra loop de queryCostos  --->


		<!--- se inserta el registro en IE10 y en ID10   --->
		<cfset Incluido = OGeneralProcB.ConsultaTipoOperacion(queryInvoice.acct_num, queryInvoice.invoice,'Factura')>
	
		<cfset Incluido = OGeneralProcB.ConsultaTipoOperacion(queryInvoice.acct_num, queryInvoice.invoice,'Factura')>
		<!--- se modifica la estructura de órdenes comerciales  --->
		
		
		
		
	</cfif> 	 <!--- ** ** ** ** ** ** **  Cierra if que procesa ventas  ** ** ** ** ** ** **   ---> 
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de qproductos  ** ** ** ** ** ** **   --->

<!--- Asignar el costo a la venta, a la compra no se le asigna costo  --->
	<!--- accesar los costos  --->
	<!--- por cada costo accesar el producto  --->
	<!--- crear cuenta de costo  --->
<!--- Si existe documento "NOFACT"  --->
	<!--- reversar movimiento "NOFACT"  --->
<!--- Incluir nuevo documento "FACT"  --->