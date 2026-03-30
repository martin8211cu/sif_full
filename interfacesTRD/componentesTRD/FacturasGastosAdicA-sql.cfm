<!--- Archivo    :  FacturasGastosAdicA.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  Consulta, valida y graba las facturas de servicios en la 
					variable de SESSION qproductos, si hay errores los graba en la variable de 
					SESSION qerrores, luego el usuario decide si procesa los registros.
	  --->


<!---
<cfabort showerror="variable: #SESSION.DescripcionICTS# ">
--->

<!--- Se definen objetos a utilizar  --->
<cfobject name="OFacturaGastosAdic" component="interfacesPMI.Componentes.CFacturaGastosAdic">
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcA" component="interfacesPMI.Componentes.CGeneralProcA">

<!--- Se define el query de SESSION para procesar los servicios, y bandera de error   --->
<cfset SESSION.AA = "">   <!--- Solo para pruebas --->

<cfset SESSION.EmpresaICTS = "">
<cfset SESSION.DescripcionICTS = "">
<cfset SESSION.HayErrores = false>
<cfset SESSION.qproductos = QueryNew("documento, orden, socionegocio, Nsocio, producto, fechavoucher, 
				vouchernum, importe, modulo, tipotransaccion, tipoventa, tipogasto, Ecodigo, EmpresaICTS")>

<!--- Se define el query de SESSION para procesar errores   --->
<cfset SESSION.qerrores = QueryNew("Ecodigo, FechaProceso, FechaDocumento, TipoDocumento, LineaNegocio,
		UsuarioProceso, MensajeError, Documento, Modulo, Monto, TipoAplicacion, Trade_Num, Order_num, Item_num")>

<!--- Accesar tabla de catálogo de empresas ICTS-SOIN  --->
<cfset SESSION.EmpresaICTS = OGeneral.ConsultaEmpresaICTS(Session.Ecodigo)> 
<cfset SESSION.DescripcionICTS = OGeneral.ConsultaDescripcionICTS(SESSION.EmpresaICTS)>
<cfset vFechaI = form.FechaI>
<cfset vFechaF = form.FechaF>

<!--- Crea query de compras  --->
<cfset queryGastos = OFacturaGastosAdic.ConsultaGastos(vFechaI, vFechaF)>

<!--- procesa los registros de compra  --->	
<cfloop query="queryGastos"> 
	<cfif SESSION.HayErrores EQ false>
		<!--- se accesa el registro de PmiFoliosDetailP, la suma de montos debe ser igual al voucher  --->
		<cfset queryFolioDetail = OGeneralProcA.ConsultaFolioDetail(queryGastos.voucher_num,
		queryGastos.dt_fecha_vencimiento, queryGastos.c_tipo_folio, queryGastos.voucher_tot_amt,
		queryGastos.i_folio, queryGastos.i_anio)>
	</cfif>
	
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryGastos.i_empresa, queryGastos.i_folio,'Folio')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryGastos.i_empresa, 
					ToString(queryGastos.i_folio),'Folio', qSNegocios.SNid)>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryGastos.i_empresa, queryGastos.i_folio,
						   'Folio', queryFolioDetail.c_producto)>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher          --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostosFact(queryGastos.voucher_num, 
		                     queryGastos.voucher_tot_amt, queryGastos.c_docto_proveedor,'C')>
	</cfif>

	<cfif SESSION.HayErrores EQ false> 
		<cfset cVoucher_Creation_Date = queryGastos.voucher_creation_date>
		<cfset cVoucher_Num = queryGastos.voucher_num>
		<cfset cC_Tipo_Folio = queryGastos.c_tipo_folio>
		<cfset cC_Docto_Proveedor = queryGastos.c_docto_proveedor>
		<cfset cOrden = queryGastos.c_orden>
		<cfset cI_Empresa = queryGastos.i_empresa>
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
			<cfset QuerySetCell(SESSION.qproductos,"importe",queryCostos.monto)>  
			<cfset QuerySetCell(SESSION.qproductos,"modulo","CXP")>
			<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",cc_tipo_folio)>
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryGastos  ** ** ** ** ** ** **   --->
