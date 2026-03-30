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
<cfobject name="ONoFactFletes" component="interfacesPMI.Componentes.CNoFactFletes">
<cfobject name="OGeneral" component="interfacesPMI.Componentes.CGeneral">
<cfobject name="OGeneralProcA" component="interfacesPMI.Componentes.CGeneralProcA">

<!--- Se define el query de SESSION para procesar productos, y bandera de error   --->
<cfset SESSION.AA = "">   <!--- Solo para pruebas --->

<cfset SESSION.EmpresaICTS = "">
<cfset SESSION.DescripcionICTS = "">
<cfset SESSION.HayErrores = false>
<cfset SESSION.qproductos = QueryNew("documento, orden, socionegocio, Nsocio, producto, fechatrade, trade_num, 
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
<cfset queryFletes = ONoFactFletes.ConsultaFletes(vFechaI, vFechaF)>
<!--- procesa los registros de compra  --->	
<cfloop query="queryFletes"> 
	<cfif SESSION.HayErrores EQ false>
		<!--- se lee el socio de negocios de la tabla SNegocios, usando el campo i_empresa  --->
		<!--- de PmiFolios, si no existe genera un error  --->
		<cfset qSNegocios = OGeneralProcA.ConsultaSocioNegocios(queryFletes.acct_num, queryFletes.trade_num,'Trade')>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar el tipo de Socio Negocio, se utiliza el query qSNegocios --->
		<!--- si no es intercompañía, se debe determinar si es nacional o extranjero, para esto se  --->
		<!--- utiliza la tabla SNClasificacionSn, y la tabla SNClasificacionD que tiene la descripción --->
		<cfif qSNegocios.esIntercompany>
			<cfset vTipoContraparte="INTERCOMPANIA">
		<cfelse>
			<cfset vTipoContraparte = OGeneralProcA.ValidaTipoContraparte(queryFletes.acct_num, 
					ToString(queryFletes.trade_num),'Trade', qSNegocios.SNid)>
		</cfif>
	</cfif>

	<cfif SESSION.HayErrores EQ false>
		<!--- validar si se puede determinar la línea de negocio, se lee la tabla Articulos de SoinSif --->
		<!--- correspondiente a Acodalterno=productoICTS, mediante Aid se lee OCComplementoArticulo,  --->
		<!--- donde se encuentra la Línea de Negocio y el Producto en los campos de complemento --->
		<cfset qArticulo = OGeneralProcA.ConsultaLineaProducto(queryFletes.acct_num, queryFletes.trade_num,
						   'Trade', queryFletes.cmdty_code)>
	</cfif>


	<cfif SESSION.HayErrores EQ false> 
		<cfset cContr_Date = queryFletes.contr_date>
		<cfset cAcct_Ref_Num = queryFletes.acct_ref_num>
		<cfset cSocio = queryFletes.acct_num>
		<cfset cNSocio = qSNegocios.SNnombre>
		<cfset cTrade_Num = queryFletes.trade_num>
		<cfset cOrder_Num = queryFletes.order_num>
		<cfset cItem_Num = queryFletes.item_num>
		<cfset cProducto = queryFletes.cmdty_code>

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
		<cfset QuerySetCell(SESSION.qproductos,"importe",queryFletes.cost_amt)>  
		<cfset QuerySetCell(SESSION.qproductos,"modulo","CXP")>
		<cfset QuerySetCell(SESSION.qproductos,"tipotransaccion",'P')>
		<cfset QuerySetCell(SESSION.qproductos,"tipoventa","")>
		<cfset QuerySetCell(SESSION.qproductos,"Ecodigo", SESSION.Ecodigo)>
		<cfset QuerySetCell(SESSION.qproductos,"EmpresaICTS", session.EmpresaICTS)>

	</cfif>    <!--- Cierra if de HayErrores  --->

	<cfset SESSION.HayErrores = false>
</cfloop>   <!--- ** ** ** ** ** ** **  Cierra loop de queryFletes  ** ** ** ** ** ** **   --->
