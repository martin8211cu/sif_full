<!--- Archivo    :  FacturasFletesA.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  Consulta, valida y graba las facturas de fletes en la 
					variable de SESSION qproductos, si hay errores los graba en la variable de 
					SESSION qerrores, luego el usuario decide si procesa los registros.
	  --->


<!---
<cfabort showerror="variable: #SESSION.DescripcionICTS# ">
--->

<!--- Se definen objetos a utilizar  --->
<cfobject name="OFacturaFletes" component="interfacesPMI.Componentes.CFacturaFletes">
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcA" component="interfacesPMI.Componentes.CGeneralProcA">

<!--- Se define el query de SESSION para procesar fletes, y bandera de error   --->
<cfset SESSION.AA = "">   <!--- Solo para pruebas --->

<cfset SESSION.EmpresaICTS = "">
<cfset SESSION.DescripcionICTS = "">
<cfset SESSION.HayErrores = false>
<cfset SESSION.qproductos = QueryNew("documento, orden, socionegocio, Nsocio, producto, fechavoucher, 
				vouchernum, importe, modulo, tipotransaccion, tipoventa, Ecodigo, EmpresaICTS, moneda,
				iva, trade_num, order_num, item_num")>

<!--- Se define el query de SESSION para procesar errores   --->
<cfset SESSION.qerrores = QueryNew("Ecodigo, FechaProceso, FechaDocumento, TipoDocumento, LineaNegocio,
		UsuarioProceso, MensajeError, Documento, Modulo, Monto, TipoAplicacion, Trade_Num, Order_num, Item_num")>

<!--- Accesar tabla de catálogo de empresas ICTS-SOIN  --->
<cfset SESSION.EmpresaICTS = OGeneral.ConsultaEmpresaICTS(Session.Ecodigo)> 
<cfset SESSION.DescripcionICTS = OGeneral.ConsultaDescripcionICTS(SESSION.EmpresaICTS)>

<cfset vFechaI = form.FechaI>
<cfset vFechaF = form.FechaF>

<!--- Crea query de fletes  --->
<cfset queryFletes = OFacturaFletes.ConsultaFletes(vFechaI, vFechaF)>

<!--- procesa los registros de compra  --->	
<cfloop query="queryFletes"> 
	<cfif SESSION.HayErrores EQ false>
		<!--- se accesa el registro de PmiFoliosDetailS, la suma de montos debe ser igual al voucher  --->
		<cfset queryFolioDetail = OGeneralProcA.ConsultaFolioServicios(queryFletes.voucher_num,
		queryFletes.dt_fecha_vencimiento, queryFletes.c_tipo_folio, queryFletes.voucher_tot_amt,
		queryFletes.i_folio, queryFletes.i_anio)>
	</cfif>
	
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryFletes.i_empresa, queryFletes.i_folio,'Folio')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryFletes.i_empresa, 
					ToString(queryFletes.i_folio),'Folio', qSNegocios.SNid)>
		</cfif>
	</cfif>

<!---
	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryFletes.i_empresa, queryFletes.i_folio,
						   'Folio', queryFolioDetail.c_concepto)>
	</cfif>

		<!--- determinar el codigo de transacción  y en los casos de Servicios el concepto de servicio 
		
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

--->

		<!--- Obtener código de moneda de tabla Monedas  --->
	<cfif SESSION.HayErrores EQ false>
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher          --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostosFact(queryFletes.voucher_num, 
		                     queryFletes.voucher_tot_amt, queryFletes.c_docto_proveedor,'C')>
	</cfif>


	<cfif SESSION.HayErrores EQ false> 
		<cfset cVoucher_Creation_Date = queryFletes.voucher_creation_date>
		<cfset cVoucher_Num = queryFletes.voucher_num>
		<cfset cMoneda = queryFletes.c_moneda>
		<cfset cMonto = queryFletes.voucher_tot_amt>
		<cfset cC_Tipo_Folio = queryFletes.c_tipo_folio>
		<cfset cC_Docto_Proveedor = queryFletes.c_docto_proveedor>
		<cfset cOrden = queryFolioDetail.c_orden>
		<cfset cI_Empresa = queryFletes.i_empresa>
		<cfset cNSocio = qSNegocios.SNnombre>
		<!--- se procesan los costos agrupados por documento, se valida  --->
		<cfloop query="queryCostos">
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
			<cfset QuerySetCell(SESSION.qproductos,"moneda",cmoneda)>  
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryFletes  ** ** ** ** ** ** **   --->
