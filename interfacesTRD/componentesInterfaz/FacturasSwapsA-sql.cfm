<!--- Archivo    :  FacturasSwapsA.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  Consulta, valida y graba las facturas de Swaps en la 
					variable de SESSION qproductos, si hay errores los graba en la variable de 
					SESSION qerrores, luego el usuario decide si procesa los registros.
	  --->


<!---
<cfabort showerror="variable: #SESSION.DescripcionICTS# ">
--->

<!--- Se definen objetos a utilizar  --->
<cfobject name="OFacturaSwap" component="interfacesPMI.Componentes.CFacturaSwap">
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcA" component="interfacesPMI.Componentes.CGeneralProcA">

<!--- Se define el query de SESSION para procesar productos, y bandera de error   --->
<cfset SESSION.AA = "">   <!--- Solo para pruebas --->

<cfset SESSION.EmpresaICTS = "">
<cfset SESSION.DescripcionICTS = "">
<cfset SESSION.HayErrores = false>
<cfset SESSION.qproductos = QueryNew("documento, orden, socionegocio, Nsocio, producto, fechavoucher, 
				vouchernum, importe, modulo, tipotransaccion, tipoventa, Ecodigo, EmpresaICTS, moneda, iva")>

<!--- Se define el query de SESSION para procesar errores   --->
<cfset SESSION.qerrores = QueryNew("Ecodigo, FechaProceso, FechaDocumento, TipoDocumento, LineaNegocio,
		UsuarioProceso, MensajeError, Documento, Modulo, Monto, TipoAplicacion, Trade_Num, Order_num, Item_num")>

<!--- Accesar tabla de catálogo de empresas ICTS-SOIN  --->
<cfset SESSION.EmpresaICTS = OGeneral.ConsultaEmpresaICTS(Session.Ecodigo)> 
<cfset SESSION.DescripcionICTS = OGeneral.ConsultaDescripcionICTS(SESSION.EmpresaICTS)>

<cfset vFechaI = form.FechaI>
<cfset vFechaF = form.FechaF>
<!--- Crea query de compras  --->
<cfset queryCompras = OFacturaSwap.ConsultaCompras(vFechaI, vFechaF)>

<!--- procesa los registros de compra  --->	
<cfloop query="queryCompras"> 
	<!--- valida que el monto del voucher sea igual al monto de la factura  --->	
	<cfif queryCompras.c_tipo_folio EQ "FA"  or queryCompras.c_tipo_folio EQ "ND">
		<cfset vDiff = abs(queryCompras.voucher_tot_amt - (queryCompras.f_importe_total + queryCompras.f_iva))>
	<cfelse>
		<cfset vDiff = abs(queryCompras.voucher_tot_amt + (queryCompras.f_importe_total + queryCompras.f_iva))>
	</cfif>
	<cfif vDiff GT 2> 
		<!--- Graba error por haber diferencia de monto   --->
		<cfset QueryAddRow(SESSION.qerrores)>
		<cfset QuerySetCell(SESSION.qerrores,"Ecodigo",SESSION.Ecodigo)>
		<cfset QuerySetCell(SESSION.qerrores,"FechaProceso",Now())>
		<cfset QuerySetCell(SESSION.qerrores,"FechaDocumento",Now())>
		<cfset QuerySetCell(SESSION.qerrores,"TipoDocumento","Voucher-Folio")>
		<cfset QuerySetCell(SESSION.qerrores,"LineaNegocio","")>
		<cfset QuerySetCell(SESSION.qerrores,"UsuarioProceso",SESSION.Usucodigo)>
		<cfset QuerySetCell(SESSION.qerrores,"MensajeError","Diferencia de montos entre el voucher y la factura.")>
		<cfset QuerySetCell(SESSION.qerrores,"Documento","#queryCompras.voucher_num# - #queryCompras.i_folio#")>
		<cfset QuerySetCell(SESSION.qerrores,"Modulo","CXP")>
		<cfset QuerySetCell(SESSION.qerrores,"Monto",0.00)>
		<cfset QuerySetCell(SESSION.qerrores,"TipoAplicacion","")>
		<cfset QuerySetCell(SESSION.qerrores,"Trade_Num",0)>
		<cfset QuerySetCell(SESSION.qerrores,"Order_Num",0)>
		<cfset QuerySetCell(SESSION.qerrores,"Item_Num",0)>
		<cfset SESSION.HayErrores = true>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesa el registro de PmiFoliosDetailP, la suma de montos debe ser igual al voucher  --->
		<cfset queryFolioDetail = OGeneralProcA.ConsultaFolioProductos(queryCompras.voucher_num,
		queryCompras.dt_fecha_vencimiento, queryCompras.c_tipo_folio, queryCompras.voucher_tot_amt,
		queryCompras.i_folio, queryCompras.i_anio)>
	</cfif>
	
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryCompras.i_empresa, queryCompras.i_folio,'Folio')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryCompras.i_empresa, 
					ToString(queryCompras.i_folio),'Folio', qSNegocios.SNid)>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryCompras.i_empresa, queryCompras.i_folio,
						   'Folio', queryFolioDetail.c_producto)>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher          --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostosFact(queryCompras.voucher_num, 
		                     queryCompras.voucher_tot_amt, queryCompras.c_docto_proveedor,'C')>
	</cfif>

	<cfif SESSION.HayErrores EQ false> 
		<cfset cVoucher_Creation_Date = queryCompras.voucher_creation_date>
		<cfset cMoneda = queryCompras.c_moneda>
		<cfset cIva = queryCompras.f_iva>
		<cfset cMonto = queryCompras.voucher_tot_amt>
		<cfset cVoucher_Num = queryCompras.voucher_num>
		<cfset cC_Tipo_Folio = queryCompras.c_tipo_folio>
		<cfset cC_Docto_Proveedor = queryCompras.c_docto_proveedor>
		<cfset cOrden = queryCompras.c_orden>
		<cfset cI_Empresa = queryCompras.i_empresa>
		<cfset cNSocio = qSNegocios.SNnombre>
		
		<!--- determinar el codigo de transacción  
		<cfset vAfectaAlm = OGeneral.AfectaAlmacen(queryCompras.voucher_num, queryCostos.producto)>
		
		SELECT sb.subconcepto_id, r.rel_subconcepto_detalle_id 
        FROM tesoreria..subconceptos sb, tesoreria..rel_subconceptos_detalles r, tesoreria..subconceptos_detalle s 
        WHERE s.costo_id = qcostos.cost_code AND 
                s.tipo_costo = qcostos.cost_type AND 
                s.payable_receivable = 'P' AND
                r.subconcepto_detalle_id = s.subconcepto_detalle_id AND
                sb.subconcepto_id = r.subconcepto_id

		1. si es producto sería FC no afecta almacen
		                        FP si afecta almacen
								
								
		cuando es servicio
		 
		 1. seria FS


	     seleccionar Conceptos para ver si existe el codigo devuelto por la consulta de subconceptos.
		 select * from Conceptos  where Ecodigo=8 and ccodigo = sb.subconcepto_id 
		 si no lo encuentra generar error
		 
		 si lo encuentra lo mueve al codigoConceptoServicio de la tabla IE10, esto en el proceso B de grabación
		 de tablas.

		en tipo de transacción mover como aqui estamos en producto y lo que viene es "FA" "NC"  "ND"
		
		sería para "FA"   "FC" no afecta almacen    "FP" afecta almacen
		seria para "NC"   "NC" no afecta almacen    "NP" afecta almacen
        seria para "ND"   "ND"

			<cfset queryTipos = OGeneral.TipoV_Almacen(queryCostos.key6, queryCostos.key7,
								 queryCostos.key8,'C')>

		
		Determinar si afecta almacen, afecta al almacen si en la compra se alloca con un almacen,
		en en la venta se usa el mismo criterio.	
																	
--->
		
		
		<!--- se procesan los costos agrupados por documento, se valida  --->
		<cfloop query="queryCostos">
			<!--- determinar si afecta almacén  y el tipo de venta (solo para la venta)  

			<cfset vAfectaAlm = OGeneral.AfectaAlmacen(cvoucher_num, queryCostos.producto)>  
			
			<cfif vAfectaAlm>
				<cfif cc_tipo_folio EQ 'FA'>
					<cfset cc_tipo_folio = 'FP'>
				</cfif>
				<cfif cc_tipo_folio EQ 'NC'>
					<cfset cc_tipo_folio = 'NP'>
				</cfif>
			<cfelse>
				<cfif cc_tipo_folio EQ 'FA'>
					<cfset cc_tipo_folio = 'FC'>
				</cfif>
				<cfif cc_tipo_folio EQ 'NC'>
					<cfset cc_tipo_folio = 'NC'>
				</cfif>
			</cfif>         --->   
					
			<!--- se inserta el registro en query "qproductos"       --->
			<cfset QueryAddRow(SESSION.qproductos)>
			<cfset QuerySetCell(SESSION.qproductos,"documento",cc_docto_proveedor)>
			<cfset QuerySetCell(SESSION.qproductos,"orden",corden)>
			<cfset QuerySetCell(SESSION.qproductos,"socionegocio",ci_empresa)>
			<cfset QuerySetCell(SESSION.qproductos,"Nsocio",cNSocio)>
			<cfset QuerySetCell(SESSION.qproductos,"producto",queryCostos.producto)>
			<cfset QuerySetCell(SESSION.qproductos,"fechavoucher",cvoucher_creation_date)>
			<cfset QuerySetCell(SESSION.qproductos,"vouchernum",cvoucher_num)>
			<cfset QuerySetCell(SESSION.qproductos,"importe",cmonto)>  
			<cfset QuerySetCell(SESSION.qproductos,"modulo","CXP")>
			<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",cc_tipo_folio)>
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>
			<cfset QuerySetCell(SESSION.qproductos,"moneda",cmoneda)>  
			<cfset QuerySetCell(SESSION.qproductos,"iva",civa)>  
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryCompras  ** ** ** ** ** ** **   --->


<!--- ** ** ** ** ** ** **   Crea el query de Ventas  ** ** ** ** ** ** **     --->
<cfset queryVentas = OFacturaSwap.ConsultaVentas(vFechaI, vFechaF)>
<!--- procesa los registros de venta --->	
<cfloop query="queryVentas"> 

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesa el registro de PmiInvoiceDetail, la suma de montos debe ser igual al voucher  --->
		<cfset queryInvoiceDetail = OGeneralProcA.ConsultaInvoiceDetail(queryVentas.voucher_num,
		queryVentas.invoiceDate, queryVentas.invoiceType, queryVentas.voucher_tot_amt,
		queryVentas.invoice)>
	</cfif>
	
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo acct_num  --->
		<!--- de PmiInvoice, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryVentas.acct_num, queryVentas.invoice,'Factura')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">

		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryVentas.acct_num, 
					queryVentas.invoice,'Factura', qSNegocios.SNid)>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher          --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostosFact(queryVentas.voucher_num, 
		                     queryVentas.voucher_tot_amt, queryVentas.invoice,'V')>
	</cfif>

	<cfif SESSION.HayErrores EQ false> 
		<cfset cVoucher_Creation_Date = queryVentas.voucher_creation_date>
		<cfset cMonto = queryVentas.voucher_tot_amt>
		<cfset cMoneda = queryInvoiceDetail.c_moneda>
		<cfset cVoucher_Num = queryVentas.voucher_num>
		<cfset cInvoiceType = queryVentas.invoiceType>
		<cfset cInvoice = queryVentas.invoice>
		<cfset cYour_Ref_Num = queryVentas.yourRefNum>
		<cfset cAcct_Num = queryVentas.acct_num>
		<cfset cNSocio = qSNegocios.SNnombre>
		<!--- se procesan los costos agrupados por documento, se valida  --->
		<cfloop query="queryCostos">
			<cfif SESSION.HayErrores EQ false>
				<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
				<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
				<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
				<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryVentas.acct_num, queryVentas.invoice,
									'Factura', queryCostos.producto)>
			</cfif>

			<cfif SESSION.HayErrores EQ false>
				<!--- se inserta el registro en query "qproductos"       --->
				<cfset QueryAddRow(SESSION.qproductos)>
				<cfset QuerySetCell(SESSION.qproductos,"documento",cInvoice)>
				<cfset QuerySetCell(SESSION.qproductos,"orden",cYour_Ref_Num)>
				<cfset QuerySetCell(SESSION.qproductos,"socionegocio",cacct_num)>
				<cfset QuerySetCell(SESSION.qproductos,"Nsocio",cNSocio)>
				<cfset QuerySetCell(SESSION.qproductos,"producto",queryCostos.producto)>
				<cfset QuerySetCell(SESSION.qproductos,"fechavoucher",cvoucher_creation_date)>
				<cfset QuerySetCell(SESSION.qproductos,"vouchernum",cvoucher_num)>
				<cfset QuerySetCell(SESSION.qproductos,"importe",cmonto)>  
				<cfset QuerySetCell(SESSION.qproductos,"modulo","CXC")>
				<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",cinvoicetype)>
				<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
				<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
				<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>
				<cfset QuerySetCell(SESSION.qproductos,"moneda",cmoneda)>  
				<cfset QuerySetCell(SESSION.qproductos,"iva",0)>  
			</cfif>
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores EQ false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryVentas  ** ** ** ** ** ** **   --->

