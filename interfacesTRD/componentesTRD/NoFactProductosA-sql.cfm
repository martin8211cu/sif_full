<!--- Archivo    :  NoFactProductosA.cfm
      Creado Por :  Marco Saborío Chaves
	  Descripción:  Consulta, valida y graba los documentos NoFact de compra y venta de productos en la 
					variable de SESSION qproductos, si hay errores los graba en la variable de 
					SESSION qerrores, luego el usuario decide si procesa los registros.
	  --->


<!---
<cfabort showerror="variable: #SESSION.DescripcionICTS# ">
--->

<!--- Se definen objetos a utilizar  --->
<cfobject name="ONoFactProducto" component="interfacesPMI.Componentes.CNoFactProducto">
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcA" component="interfacesPMI.Componentes.CGeneralProcA">

<!--- Se define el query de SESSION para procesar productos, y bandera de error   --->
<cfset SESSION.AA = "">   <!--- Solo para pruebas --->

<cfset SESSION.EmpresaICTS = "">
<cfset SESSION.DescripcionICTS = "">
<cfset SESSION.HayErrores = false>
<cfset SESSION.qproductos = QueryNew("documento, orden, socionegocio, Nsocio, producto, fechatrade, trade_num, 
				order_num, item_num, vouchernum, importe, modulo, tipotransaccion, tipoventa, Ecodigo, EmpresaICTS")>
<cfset qtemp = QueryNew("documento, orden, socionegocio, Nsocio, producto, fechatrade, trade_num, 
				order_num, item_num, vouchernum, importe, modulo, tipotransaccion, tipoventa, Ecodigo, EmpresaICTS")>

<!--- Se define el query de SESSION para procesar errores   --->
<cfset SESSION.qerrores = QueryNew("Ecodigo, FechaProceso, FechaDocumento, TipoDocumento, LineaNegocio,
		UsuarioProceso, MensajeError, Documento, Modulo, Monto, TipoAplicacion, Trade_Num, Order_num, Item_num")>

<!--- Accesar tabla de catálogo de empresas ICTS-SOIN  --->
<cfset SESSION.EmpresaICTS = OGeneral.ConsultaEmpresaICTS(Session.Ecodigo)> 
<cfset SESSION.DescripcionICTS = OGeneral.ConsultaDescripcionICTS(SESSION.EmpresaICTS)>

<cfset vFechaI = form.FechaI>
<cfset vFechaF = form.FechaF>

<!--- Crea query de compras  --->
<cfset queryCompras = ONoFactProducto.ConsultaCompras(vFechaI, vFechaF)>

<!--- procesa los registros de compra  --->	
<cfloop query="queryCompras"> 
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryCompras.acct_num, queryCompras.trade_num,'Trade')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryCompras.acct_num, 
					ToString(queryCompras.trade_num),'Trade', qSNegocios.SNid)>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryCompras.acct_num, queryCompras.trade_num,
						   'Trade', querycompras.cmdty_code)>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesan las tablas cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos)          --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostos(queryCompras.trade_num, queryCompras.order_num,
					 queryCompras.item_num,'C',querycompras.cmdty_code)>
	</cfif>

	<cfif SESSION.HayErrores EQ false> 
		<cfset cContr_Date = queryCompras.title_tran_date>
		<cfset cAcct_Ref_Num = queryCompras.acct_ref_num>
		<cfset cSocio = queryCompras.acct_num>
		<cfset cNSocio = qSNegocios.SNnombre>
		<cfset cTrade_Num = queryCompras.trade_num>
		<cfset cOrder_Num = queryCompras.order_num>
		<cfset cItem_Num = queryCompras.item_num>
		<cfset cProducto = queryCompras.cmdty_code>
		<!--- se procesan los costos agrupados por documento, se valida  --->
		<cfloop query="queryCostos">
			<!--- se inserta el registro en query "qproductos"       --->
			<cfset QueryAddRow(SESSION.qproductos)>
			<cfset QuerySetCell(SESSION.qproductos,"documento","#ctrade_num#,#corder_num#,#citem_num#")>
			<cfset QuerySetCell(SESSION.qproductos,"orden",cAcct_Ref_Num)>
			<cfset QuerySetCell(SESSION.qproductos,"socionegocio",cSocio)>
			<cfset QuerySetCell(SESSION.qproductos,"Nsocio",cNSocio)>
			<cfset QuerySetCell(SESSION.qproductos,"producto",cproducto)>
			<cfset QuerySetCell(SESSION.qproductos,"fechatrade",ccontr_date)>
			<cfset QuerySetCell(SESSION.qproductos,"trade_num", ctrade_num)>
			<cfset QuerySetCell(SESSION.qproductos,"order_num", corder_num)>
			<cfset QuerySetCell(SESSION.qproductos,"item_num", citem_num)>
			<cfset QuerySetCell(SESSION.qproductos,"importe",queryCostos.monto)>  
			<cfset QuerySetCell(SESSION.qproductos,"modulo","CXP")>
			<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",'P')>
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryCompras  ** ** ** ** ** ** **   --->

<!--- ** ** ** ** ** ** **   Crea el query de Ventas  ** ** ** ** ** ** **     --->
<cfset queryVentas = ONoFactProducto.ConsultaVentas(vFechaI, vFechaF)>
<!--- procesa los registros de venta --->	
<cfloop query="queryVentas"> 
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryVentas.acct_num, queryVentas.trade_num,'Trade')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryVentas.acct_num, 
					ToString(queryVentas.trade_num),'Trade', qSNegocios.SNid)>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryVentas.acct_num, queryVentas.trade_num,
						   'Trade', queryVentas.cmdty_code)>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- se accesan las tablas cost se agrupan los costos por orden-producto, y se  --->
		<!--- suman (hay cargos y abonos)          --->
		<cfset queryCostos = OGeneralProcA.ConsultaCostos(queryVentas.trade_num, 
		                     queryVentas.order_num, queryVentas.item_num,'V',queryVentas.cmdty_code)>
	</cfif>

	<cfif SESSION.HayErrores EQ false> 
		<cfset cContr_Date = queryVentas.title_tran_date>
		<cfset cAcct_Ref_Num = queryVentas.acct_ref_num>
		<cfset cSocio = queryVentas.acct_num>
		<cfset cNSocio = qSNegocios.SNnombre>
		<cfset cTrade_Num = queryVentas.trade_num>
		<cfset cOrder_Num = queryVentas.order_num>
		<cfset cItem_Num = queryVentas.item_num>
		<cfset cProducto = queryVentas.cmdty_code>
		<!--- se procesan los costos agrupados por documento, se valida  --->
		<cfloop query="queryCostos">
			<!--- se inserta el registro en query "qproductos"       --->
			<cfset QueryAddRow(SESSION.qproductos)>
			<cfset QuerySetCell(SESSION.qproductos,"documento","#ctrade_num#,#corder_num#,#citem_num#")>
			<cfset QuerySetCell(SESSION.qproductos,"orden",cAcct_Ref_Num)>
			<cfset QuerySetCell(SESSION.qproductos,"socionegocio",cSocio)>
			<cfset QuerySetCell(SESSION.qproductos,"Nsocio",cNSocio)>
			<cfset QuerySetCell(SESSION.qproductos,"producto",cproducto)>
			<cfset QuerySetCell(SESSION.qproductos,"fechatrade",ccontr_date)>
			<cfset QuerySetCell(SESSION.qproductos,"trade_num", ctrade_num)>
			<cfset QuerySetCell(SESSION.qproductos,"order_num", corder_num)>
			<cfset QuerySetCell(SESSION.qproductos,"item_num", citem_num)>
			<cfset QuerySetCell(SESSION.qproductos,"importe",queryCostos.monto)>  
			<cfset QuerySetCell(SESSION.qproductos,"modulo","CXC")>
			<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",'S')>
			<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
			<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
			<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>
		</cfloop>    <!--- Cierra loop de queryCostos  --->
	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryVentas  ** ** ** ** ** ** **   --->
