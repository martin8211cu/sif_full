<!--- 
	Archivo       : CFacturaProcB.cfc
	Creado por    : Marco Saborío Chaves
	Descripción   : Contiene métodos a utilizar en el Proceso B de Compra-Venta
	                de producto.
--->
<cfcomponent>
	<!--- Se define el objeto de Costos a utilizar  --->
	<cfobject name="OCostosPMI" component="interfacesPMI.Componentes.CCostosPMI">
	<cfobject name="OCostosFact" component="interfacesPMI.Componentes.CCostosFact">


	<!--- //// consulta PmiFolios  --->
	<cffunction name="ConsultaFolio" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select i_folio, i_anio, i_voucher, i_empresa, i_empresa_prop, dt_fecha_vencimiento,
			       dt_fecha_recibo, c_tipo_folio, c_orden, c_docto_proveedor, c_moneda, f_iva,
				   f_importe_total
			from PmiFolios
			where i_voucher = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Voucher#">
			  and i_empresa_prop = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EmpresaICTS#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el registro en PmiFolios, No. de voucher: #Arguments.Voucher#">
		</cfif>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta PmiFoliosDetail   --->
	<cffunction name="ConsultaFolioDetail" returntype="query">
		<cfargument name="Folio" required="Yes" type="numeric">
		<cfargument name="Anio" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var TotalDetalles = 0.00>

		<cfquery name="query" datasource="preicts">
			select i_folio, i_anio, c_producto, f_volumen, c_unidad, f_precio, f_importe
			from PmiFoliosDetailP
			where i_folio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.folio)#">
			  and i_anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.anio)#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el registro en PmiFoliosDetailP, No. de voucher: #Arguments.Voucher#">
		</cfif>

		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta tabla cost  --->
	<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por orden-producto, y se  --->
	<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
	<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
	<cffunction name="ConsultaCostos" returntype="query">
		<cfargument name="trade_num" required="Yes" type="numeric">
		<cfargument name="order_num" required="Yes" type="numeric">
		<cfargument name="item_num" required="Yes" type="numeric">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfargument name="producto" required="Yes" type="string">
		<cfset var qCostos = "">

		<cfquery name="qCostos" datasource="preicts">
			select cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_pay_rec_ind,
				   cost_code, sum(cost_amt) as tcosto
			from cost
			where cost_owner_key6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.trade_num#">
			  and cost_owner_key7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.order_num#">
			  and cost_owner_key8 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.item_num#">
     		  and cost_status = 'OPEN'
			  and (cost_owner_code <> 'TI')
			  and cost_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.producto#">
			group by cost_owner_key6, cost_owner_key7, cost_owner_key8, cost_pay_rec_ind, cost_code
		</cfquery>
		
		<cfloop query="qCostos">
			<cfset OCostosPMI.IncluirCosto(qcostos.cost_owner_key6,qcostos.cost_owner_key7,
				   qcostos.cost_owner_key8, qcostos.cost_code, qcostos.tcosto, qcostos.cost_pay_rec_ind,
				   Arguments.TipoFactura)>
		</cfloop>
		
		<!--- Consulta los costos agrupados  --->
		<cfset qCostos = OCostosPMI.ListaCostos()>
		<cfset OCostosPMI.LimpiarArreglo()>		
		<cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta tabla cost  --->
	<!--- se accesan las tablas voucher_cost y cost se agrupan los costos por No. de Documento, y se  --->
	<!--- suman (hay cargos y abonos) para verificar que corresponden al monto del voucher,  --->
	<!--- para determinar el producto se utiliza el trade_item relacionado a cada costo, se valida  --->
	<cffunction name="ConsultaCostosFact" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="TotalVoucher" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoFactura" required="Yes" type="string">
		<cfset var qCostos = "">
		<cfset var qItem = "">
		<cfset var pri_Trade = "">
		<cfset var pri_Order= "">
		<cfset var pri_Item = "">
		<cfset var TotalCostos = 0>

		<cfquery name="qCostos" datasource="preicts">
			select ab.cost_pay_rec_ind, ab.cost_code, sum(ab.cost_amt) as tcosto
			from cost ab
			inner join voucher_cost aa
			   on aa.voucher_num= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.voucher#">
			   and aa.cost_num = ab.cost_num 
			where ab.cost_status='PAID' or ab.cost_status = 'VOUCHED'
			group by ab.cost_pay_rec_ind, ab.cost_code
			order by tcosto desc
		</cfquery>

		<cfloop query="qCostos">
			<cfset OCostosFact.IncluirCosto(arguments.documento, qcostos.cost_code, 
				   qcostos.tcosto, qcostos.cost_pay_rec_ind, Arguments.TipoFactura)>
		</cfloop>
		
		<!--- Consulta los costos agrupados  --->
		<cfset qCostos = OCostosFact.ListaCostos()>
		<cfset OCostosFact.LimpiarArreglo()>		
		<cfreturn qCostos>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta de PmiInvoice  --->
	<cffunction name="ConsultaInvoice" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="preicts">
			select invoice, voucherNum, acctNum, bookingCo, invoiceDate,
			       invoiceType, tradeNum, yourRefNum, dueDate
			from PmiInvoice
			where voucherNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Voucher#">
			  and bookingCo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.descripcionICTS#">
			  and paginaFact = 1
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el registro en PmiInvoice, No. de voucher: #Arguments.Voucher#">
		</cfif>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta de PmiInvoiceDetail  --->
	<cffunction name="ConsultaInvoiceDetail" returntype="query">
		<cfargument name="Voucher" required="Yes" type="numeric">
		<cfargument name="MontoVoucher" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var TotalDetalles = 0.00>

		<cfquery name="query" datasource="preicts">
			select voucherNum, paginaFact, f_vol_nvo, c_unidades, f_precio_nvo, f_importe, c_moneda
			from PmiInvoiceDetail
			where voucherNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(Arguments.Voucher)#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el registro en PmiInvoiceDetail, No. de voucher: #Arguments.Voucher#">
		</cfif>

		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Socio de Negocios  --->
	<cffunction name="ConsultaSocioNegocios" returntype="query">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
		<cfset var qSNegocios = "">

		<!--- se accesa el socio de negocios de la tabla SNegocios, usando el campo Empresa  --->
		<cfquery name="qSNegocios" datasource="#Session.Dsn#">
			select a1.Ecodigo, a1.SNcodigo, a1.SNid, a1.SNcodigoext, a1.esIntercompany, a1.cuentac,
			       a1.SNnombre, a2.CFcomplementoCostoVenta, a2.CFcomplementoIngreso
			from SNegocios a1
				inner join OCcomplementoSNegocio a2
					on a2.SNid = a1.SNid
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a1.SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Empresa#">
		</cfquery>
		
		<cfif qSNegocios.recordcount EQ 0 >
			<cfthrow message="No encontró el registro en SNegocios, No. de #Arguments.TipoDocumento#: #Arguments.Documento#">
		</cfif>
		
		<cfreturn qSNegocios>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Tipo de Contraparte   --->
	<cffunction name="ValidaTipoContraparte" returntype="string">
	    <cfargument name="SocioId" required="Yes" type="numeric">
		<cfset var query = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select aa.SNCDdescripcion
			from SNClasificacionD aa, SNClasificacionSN ab
			where ab.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SocioId#">
			  and aa.SNCDid = ab.SNCDid
			  and (aa.SNCDdescripcion='NACIONAL' or aa.SNCDdescripcion='EXTRANJERO')
		</cfquery>

		<cfreturn query.SNCDdescripcion>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Línea de Negocio y Producto  --->
	<cffunction name="ConsultaLineaProducto" returntype="query">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">
		<cfset var query = "">
		<cfset var queryArticulo = "">

		<!--- se lee la tabla Articulos, usando el campo Producto  --->
		<cfquery name="queryArticulo" datasource="#Session.Dsn#">
			select a1.Aid, a2.CFcomplementoCostoVenta, a2.CFcomplementoIngreso
			from Articulos a1
					inner join OCcomplementoArticulo a2
						on a2.Aid = a1.Aid
			where a1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a1.Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Producto#">
		</cfquery>
		<cfreturn queryArticulo>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta Tipo de Operación solo para Servicios --->
	<cffunction name="ConsultaTipoOperacion" returntype="query">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Documento" required="Yes" type="string">
		<cfargument name="TipoDocumento" required="Yes" type="string">
		<cfargument name="Producto" required="Yes" type="string">
		<cfset var query = "">
		<cfset var queryConceptos = "">

		<!--- se lee la tabla OCconceptoCompra, usando el campo Producto  --->
		<cfquery name="queryConceptos" datasource="#Session.Dsn#">
			select *
			from OCconceptoCompra
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfif queryConceptos.recordcount EQ 0 >
			<cfthrow message="No encontró registro en OCconceptoCompra, No. #Arguments.TipoDocumento#: #Arguments.Documento#">
		</cfif>
		
		<cfreturn query>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta el código de Moneda de la tabla Monedas  --->
	<cffunction name="ConsultaMoneda" returntype="string">
		<cfargument name="Moneda" required="Yes" type="string">
		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			select Mcodigo, Ecodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Moneda#">
		</cfquery>
		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el código de moneda, Moneda: #Arguments.Moneda#">
		</cfif>
		
		<cfreturn "#query.Mcodigo#">
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta el código de Articulo de la tabla Articulos  --->
	<cffunction name="ConsultaArticulo" returntype="string">
		<cfargument name="Empresa" required="Yes" type="numeric">
		<cfargument name="Producto" required="Yes" type="string">
		<cfset var query = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select Aid
			from Articulos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Empresa#">
			  and Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Producto#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfthrow message="No se encontró el código de moneda, Moneda: #Arguments.Moneda#">
		</cfif>
		
		<cfreturn "#query.Aid#">
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de Encabezado de Factura IE10  --->
	<cffunction name="Inserta_IE10" returntype="boolean">
		<cfargument name="ID" type="numeric" required="true">
		<cfargument name="EcodigoSDC" type="numeric" required="true">
		<cfargument name="NumeroSocio" type="string" required="true">
		<cfargument name="Modulo" type="string" required="true">
		<cfargument name="CodigoTransacion" type="string" required="true">
		<cfargument name="Documento" type="string" required="true">
		<cfargument name="Estado" type="string" required="true">
		<cfargument name="CodigoMoneda" type="string" required="true">
		<cfargument name="FechaDocumento" type="string" required="true">
		<cfargument name="FechaVencimiento" type="string" required="true">
		<cfargument name="Facturado" type="string" required="true">
		<cfargument name="Origen" type="string" required="true">
		<cfargument name="VoucherNo" type="string" required="true">
		<cfargument name="CodigoConceptoServicio" type="string" required="true">
		<cfargument name="CodigoRetencion" type="string" required="true">
		<cfargument name="CodigoOficina" type="string" required="true">
		<cfargument name="CuentaFinanciera" type="string" required="true">
		<cfargument name="DiasVencimiento" type="numeric" required="true">
		<cfargument name="CodigoDireccionEnvio" type="string" required="true">
		<cfargument name="CodigoDireccionFact" type="string" required="true">
		<cfargument name="FechaTipoCambio" type="string" required="true">
		<cfargument name="StatusProceso" type="numeric" required="true">

		<cfset var query = "">
		
		<cfquery name="query" datasource="sifinterfaces">
			insert INTO IE10 
				(ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, Documento, Estado, CodigoMoneda,
				 FechaDocumento, FechaVencimiento, Facturado, Origen, VoucherNo, CodigoConceptoServicio,
				 CodigoRetencion, CodigoOficina, CuentaFinanciera, BMUsucodigo, DiasVencimiento,
				 CodigoDireccionEnvio, CodigoDireccionFact, FechaTipoCambio, StatusProceso)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumeroSocio#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Modulo#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoTransacion#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Estado#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoMoneda#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDocumento#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaVencimiento#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Facturado#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Origen#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.VoucherNo#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoConceptoServicio#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoRetencion#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoOficina#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CuentaFinanciera#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DiasVencimiento#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionEnvio#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionFact#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaTipoCambio#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StatusProceso#">)
		</cfquery>

		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de Detalle de Factura ID10  --->
	<cffunction name="Inserta_ID10" returntype="boolean">
		<cfargument name="ID" type="numeric" required="true">
		<cfargument name="Consecutivo" type="numeric" required="true">
		<cfargument name="TipoItem" type="string" required="true">
		<cfargument name="CodigoItem" type="string" required="true">
		<cfargument name="NombreBarco" type="string" required="true">
		<cfargument name="FechaHoraCarga" type="string" required="true">
		<cfargument name="FechaHoraSalida" type="string" required="true">
		<cfargument name="PrecioUnitario" type="numeric" scale="5" required="true">
		<cfargument name="CodigoUnidadMedida" type="string" required="true">
		<cfargument name="CantidadTotal" type="numeric" scale="5" required="true">
		<cfargument name="CantidadNeta" type="numeric" scale="5" required="true">
		<cfargument name="CodigoEmbarque" type="string" required="true">
		<cfargument name="NumeroBOL" type="string" required="true">
		<cfargument name="FechaBOL" type="string" required="true">
		<cfargument name="TripNo" type="string" required="true">
		<cfargument name="ContractNo" type="string" required="true">
		<cfargument name="CodigoImpuesto" type="string" required="true">
		<cfargument name="ImporteImpuesto" type="numeric" scale="5" required="true">
		<cfargument name="ImporteDescuento" type="numeric" required="true">
		<cfargument name="CodigoAlmacen" type="string" required="true">
		<cfargument name="CodigoDepartamento" type="string" required="true">
		<cfargument name="PrecioTotal" type="numeric" required="true">
		<cfargument name="CentroFuncional" type="string" required="true">
		<cfargument name="CuentaFinancieraDet" type="string" required="true">
		<cfargument name="OCtransporteTipo" type="string" required="true">
		<cfargument name="OCtransporte" type="string" required="true">
		<cfargument name="OCcontrato" type="string" required="true">
		<cfargument name="OCconceptoCompra" type="string" required="true">

		<cfset var query = "">

		<cfquery name="query" datasource="sifinterfaces">
			insert INTO ID10 
				(ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraCarga, FechaHoraSalida, 
				 PrecioUnitario, CodigoUnidadMedida, CantidadTotal, CantidadNeta, CodEmbarque, NumeroBOL, 
				 FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, 
				 CodigoAlmacen, CodigoDepartamento, BMUsucodigo, PrecioTotal, CentroFuncional,
				 CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Consecutivo#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TipoItem#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoItem#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NombreBarco#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHoraCarga#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHoraSalida#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.PrecioUnitario#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoUnidadMedida#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" scale="5" value="#Arguments.CantidadTotal#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric"  scale="5" value="#Arguments.CantidadNeta#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoEmbarque#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumeroBOL#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaBOL#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TripNo#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ContractNo#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoImpuesto#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ImporteImpuesto#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ImporteDescuento#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoAlmacen#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CodigoDepartamento#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.PrecioTotal#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CentroFuncional#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CuentaFinancieraDet#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCtransporteTipo#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCtransporte#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCcontrato#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCconceptoCompra#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de OCordenComercial  Ordenes Comerciales  --->
	<cffunction name="IncluirOrdenComercial" returntype="numeric">
		<cfargument name="OCtipoOD" type="string" required="true">
		<cfargument name="OCtipoIC" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="SNid" type="numeric" required="true">
		<cfargument name="OCcontrato" type="string" required="true">
		<cfargument name="OCfecha" type="string" required="true">
		<cfargument name="Mcodigo" type="numeric" required="true">
		<cfargument name="OCVid" type="numeric" required="true">
		<cfargument name="OCestado" type="string" required="true">
		<cfargument name="OCmodulo" type="string" required="true">
		<cfargument name="OCincoterm" type="string" required="true">
		<cfargument name="OCtrade_num" type="numeric" required="true">
		<cfargument name="OCorder_num" type="numeric" required="true">
		<cfargument name="OCfechaAllocationDefault" type="string" required="true">
		<cfargument name="OCfechaPropiedadDefault" type="string" required="true">

		<cfset var query = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCordenComercial
				(OCtipoOD, OCtipoIC, Ecodigo, SNid, OCcontrato, OCfecha, Mcodigo, OCVid, OCestado,
				 OCmodulo, OCincoterm, OCtrade_num, OCorder_num, OCfechaAllocationDefault, 
				 OCfechaPropiedadDefault, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCTipoOD#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCtipoIC#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCcontrato#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCfecha#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">,
			  <cfif Arguments.OCVid GT 0>
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCVid#">,
			  <cfelse>
			  	  null,
			  </cfif>
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCestado#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCmodulo#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCincoterm#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCtrade_num#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCorder_num#">,
			  <cfif isdate(Arguments.OCfechaAllocationDefault)>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCfechaAllocationDefault#">,
			  <cfelse>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  </cfif>
			  <cfif isdate(Arguments.OCfechaPropiedadDefault)>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCfechaPropiedadDefault#">,
			  <cfelse>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  </cfif>
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		<cfquery name="query" datasource="#Session.Dsn#">
			select MAX(OCid) as valorID
			from OCordenComercial
		</cfquery>
		
		<cfreturn "#query.valorID#">
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de OCordenProducto  Ordenes Comerciales  --->
	<cffunction name="IncluirOrdenProducto" returntype="boolean">
		<cfargument name="OCid" type="numeric" required="true">
		<cfargument name="Aid" type="numeric" required="true">
		<cfargument name="OCPlinea" type="numeric" required="true">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCPcantidad" type="numeric" required="true">
		<cfargument name="OCPprecioUnitario" type="numeric" required="true">
		<cfargument name="OCPprecioTotal" type="numeric" required="true">
		<cfargument name="OCitem_num" type="numeric" required="true">
		<cfargument name="OCport_num" type="numeric" required="true">
		<cfargument name="CFformato" type="string" required="true">

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCordenProducto
				(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
				 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">,
			  <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.OCPlinea#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCPcantidad#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioUnitario#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioTotal#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCitem_num#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCport_num#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFformato#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de OCtransporte  Ordenes Comerciales  --->
	<cffunction name="IncluirTransporte" returntype="numeric">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCTtipo" type="string" required="true">
		<cfargument name="OCTtransporte" type="string" required="true">
		<cfargument name="OCTestado" type="string" required="true">
		<cfargument name="OCTfechaPartida" type="string" required="true">
		<cfargument name="OCTobservaciones" type="string" required="true">
		<cfargument name="OCTvehiculo" type="string" required="true">
		<cfargument name="OCTruta" type="string" required="true">
		<cfargument name="OCTfechaLlegada" type="string" required="true">
		<cfargument name="OCTPnumeroBOLdefault" type="string" required="true">
		<cfargument name="OCTPfechaBOLdefault" type="string" required="true">

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCtransporte
				(Ecodigo, OCTtipo, OCTtransporte, OCTestado, OCTfechaPartida, OCTobservaciones,
				 OCTvehiculo, OCTruta, OCTfechaLlegada, OCTPnumeroBOLdefault, OCTPfechaBOLdefault, 
				 BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCTtipo#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCTtransporte#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCTestado#">,
			  <cfif isdate(Arguments.OCTfechaPartida)>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCTfechaPartida#">,
			  <cfelse>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  </cfif>
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCTobservaciones#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCTvehiculo#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCTruta#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCTfechaLlegada#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCTPnumeroBOLdefault#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCTPfechaBOLdefault#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>

		<cfquery name="query" datasource="#Session.Dsn#">
			select MAX(OCTid) as valorID
			from OCtransporte
		</cfquery>
		
		<cfreturn "#query.valorID#">
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de OCtransporteProducto  Ordenes Comerciales  --->
	<cffunction name="IncluirTransporteProducto" returntype="boolean">
		<cfargument name="OCTid" type="numeric" required="true">
		<cfargument name="OCid" type="numeric" required="true">
		<cfargument name="Aid" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCPTestado" type="string" required="true">
		<cfargument name="OCtipoOD" type="string" required="true">
		<cfargument name="OCTPnumeroBOL" type="string" required="true">
		<cfargument name="OCTPfechaBOL" type="string" required="true">
		<cfargument name="OCTPcontrato" type="string" required="true">
		<cfargument name="OCTPfechaAllocation" type="string" required="true">
		<cfargument name="OCTPfechaPropiedad" type="string" required="true">
		<cfargument name="OCTPcantidadTeorica" type="numeric" required="true">
		<cfargument name="OCTPprecioUniTeorico" type="numeric" required="true">
		<cfargument name="OCTPprecioTotTeorico" type="numeric" required="true">
		<cfargument name="OCTPcantidadReal" type="numeric" required="true">
		<cfargument name="OCTPprecioReal" type="numeric" required="true">

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCtransporteProducto
				(OCTid, OCid, Aid, Ecodigo, OCPTestado, OCtipoOD, OCTPnumeroBOL, OCTPfechaBOL,
				 OCTPcontrato, OCTPfechaAllocation, OCTPfechaPropiedad, OCTPcantidadTeorica,
				 OCTPprecioUniTeorico, OCTPprecioTotTeorico, OCTPcantidadReal, OCTPprecioReal,
				 BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCTid#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCPTestado#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCtipoOD#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCTPnumeroBOL#">,
			  <cfif isdate(Arguments.OCTPfechaBOL)>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCTPfechaBOL#">,
			  <cfelse>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  </cfif>
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCTPcontrato#">,
			  <cfif isdate(Arguments.OCTPfechaAllocation)>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCTPfechaAllocation#">,
			  <cfelse>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  </cfif>
			  <cfif isdate(Arguments.OCTPfechaPropiedad)>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCTPfechaPropiedad#">,
			  <cfelse>
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  </cfif>
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCTPcantidadTeorica#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPprecioUniTeorico#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPprecioTotTeorico#">,
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCTPcantidadReal#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPprecioReal#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Inclusión de OCproductoTransito  Ordenes Comerciales  --->
	<cffunction name="IncluirProductoTransito" returntype="boolean">
		<cfargument name="OCTid" type="numeric" required="true">
		<cfargument name="Aid" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCPTtransformado" type="string" required="true">
		<cfargument name="OCPTentradasCantidad" type="numeric" required="true">
		<cfargument name="OCPTentradasCostoTotal" type="numeric" required="true">
		<cfargument name="OCPTsalidasCantidad" type="numeric" required="true">
		<cfargument name="OCPTsalidasCostoTotal" type="numeric" required="true">

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCproductoTransito
				(OCTid, Aid, Ecodigo, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal,
				 OCPTsalidasCantidad, OCPTsalidasCostoTotal, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCTid#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.OCPTtransformado#">,
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCPTentradasCantidad#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPTentradasCostoTotal#">,
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCPTsalidasCantidad#">,
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPTsalidasCostoTotal#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** ---> 

	<!--- //// consulta si existe La Orden Comercial  --->
	<cffunction name="ExisteOrdenComercial" returntype="numeric">
		<cfargument name="Orden" required="Yes" type="string">
		<cfargument name="Trade" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var vResul = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select OCid
			from OCordenComercial
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Orden#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfset vResul = 0>
		<cfelse>
			<cfset vResul = query.OCid>
		</cfif>
		
		<cfreturn vResul>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta si existe la OrdenProducto  --->
	<cffunction name="ExisteOrdenProducto" returntype="boolean">
		<cfargument name="OrdenId" required="Yes" type="numeric">
		<cfargument name="Articulo" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var vResul = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select OCid
			from OCordenProducto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OrdenId#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Articulo#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfset vResul = false>
		<cfelse>
			<cfset vResul = true>
		</cfif>
		
		<cfreturn vResul>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta si existe el Transporte  --->
	<cffunction name="ExisteTransporte" returntype="numeric">
		<cfargument name="Transporte" required="Yes" type="string">
		<cfset var query = "">
		<cfset var vResul = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select OCTid
			from OCtransporte
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Transporte#">
		</cfquery>

		<cfif query.recordcount EQ 0>
			<cfset vResul = 0>
		<cfelse>
			<cfset vResul = query.OCTid>
		</cfif>
		
		<cfreturn vResul>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta si existe el TransporteProducto  --->
	<cffunction name="ExisteTransporteProducto" returntype="boolean">
		<cfargument name="TransporteId" required="Yes" type="numeric">
		<cfargument name="OrdenId" required="Yes" type="numeric">
		<cfargument name="Articulo" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var vResul = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select OCTid
			from OCtransporteProducto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TransporteId#">
			  and OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OrdenId#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Articulo#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfset vResul = false>
		<cfelse>
			<cfset vResul = true>
		</cfif>
		
		<cfreturn vResul>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// consulta si existe la OrdenProducto  --->
	<cffunction name="ExisteProductoTransito" returntype="boolean">
		<cfargument name="OrdenId" required="Yes" type="numeric">
		<cfargument name="Articulo" required="Yes" type="numeric">
		<cfset var query = "">
		<cfset var vResul = "">

		<cfquery name="query" datasource="#Session.Dsn#">
			select OCTid
			from OCproductoTransito
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OrdenId#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Articulo#">
		</cfquery>
		
		<cfif query.recordcount EQ 0>
			<cfset vResul = false>
		<cfelse>
			<cfset vResul = true>
		</cfif>
		
		<cfreturn vResul>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Reversion de documento NoFact  --->
	<cffunction name="ReversionNoFact" returntype="boolean">
		<cfargument name="OCTid" type="numeric" required="true">
		<cfargument name="Aid" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCTPtransformado" type="string" required="true">
		<cfargument name="OCTPentradasCantidad" type="numeric" required="true">
		<cfargument name="OCTPentradasCostoTotal" type="numeric" required="true">
		<cfargument name="OCTPsalidasCantidad" type="numeric" required="true">
		<cfargument name="OCTPsalidasCostoTotal" type="numeric" required="true">

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCproductoTransito
				(OCTid, Aid, Ecodigo, OCTPtranformado, OCTPentradasCantidad, OCTPentradasCostoTotal,
				 OCTPsalidasCantidad, OCTPsalidasCostoTotal, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCTid#">
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			  <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.OCTPtransformado#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCTPentradasCantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPentradasCostoTotal#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCTPsalidasCantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPsalidasCostoTotal#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** ---> 

	<!--- //// Actualizar OCordenComercial  Ordenes Comerciales  --->
	<cffunction name="ActualizarOrdenComercial" returntype="boolean">
		<cfargument name="OCtipoOD" type="string" required="true">
		<cfargument name="OCtipoIC" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="SNid" type="numeric" required="true">
		<cfargument name="OCcontrato" type="string" required="true">
		<cfargument name="OCfecha" type="string" required="true">
		<cfargument name="Mcodigo" type="numeric" required="true">
		<cfargument name="OCVid" type="numeric" required="true">
		<cfargument name="OCestado" type="string" required="true">
		<cfargument name="OCmodulo" type="string" required="true">
		<cfargument name="OCincoterm" type="string" required="true">
		<cfargument name="OCtrade_num" type="numeric" required="true">
		<cfargument name="OCorder_num" type="numeric" required="true">
		<cfargument name="OCfechaAllocationDefault" type="date" required="true">
		<cfargument name="OCfechaPropiedadDefault" type="date" required="true">

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCordenComercial
				(OCid, OCtipoOD, OCtipoIC, Ecodigo, SNid, OCcontrato, OCfecha, Mcodigo, OCVid, OCestado,
				 OCmodulo, OCincoterm, OCtrade_num, OCorder_num, OCFechaAllocationDefault, 
				 OCfechaPropiedadDefault, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCTipoOD#">
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCtipoIC#">
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCcontrato#">
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCfecha#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCVid#">
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OCestado#">
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCmodulo#">
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OCincoterm#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCtrade_num#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCorder_num#">
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCfechaAllocationDefault#">
			  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.OCfechaPropiedadDefault#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Actualizar OCordenProducto  Ordenes Comerciales  --->
	<cffunction name="ActualizarOrdenProducto" returntype="boolean">
		<cfargument name="OCid" type="numeric" required="true">
		<cfargument name="Aid" type="numeric" required="true">
<!---		<cfargument name="OCPlinea" type="numeric" required="true">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCPcantidad" type="numeric" required="true">
		<cfargument name="OCPprecioUnitario" type="numeric" required="true">
		<cfargument name="OCPprecioTotal" type="numeric" required="true">
		<cfargument name="OCitem_num" type="numeric" required="true">
		<cfargument name="OCport_num" type="numeric" required="true">
		<cfargument name="CFformato" type="string" required="true">    --->

		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			update OCordenProducto
				(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
				 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			  <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.OCPlinea#">
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCPcantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioUnitario#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioTotal#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCitem_num#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCport_num#">
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFformato#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Actualizar Transporte  Ordenes Comerciales  --->
	<cffunction name="ActualizarTransporte" returntype="boolean">
		<cfargument name="OCTid" type="numeric" required="true">
		<cfargument name="Transporte" type="string" required="true">
<!---		<cfargument name="OCPlinea" type="numeric" required="true">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCPcantidad" type="numeric" required="true">
		<cfargument name="OCPprecioUnitario" type="numeric" required="true">
		<cfargument name="OCPprecioTotal" type="numeric" required="true">
		<cfargument name="OCitem_num" type="numeric" required="true">
		<cfargument name="OCport_num" type="numeric" required="true">
		<cfargument name="CFformato" type="string" required="true">    --->

		<cfset var query = "">
<!---		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCordenProducto
				(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
				 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			  <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.OCPlinea#">
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCPcantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioUnitario#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioTotal#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCitem_num#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCport_num#">
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFformato#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>   --->
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Actualizar TransporteProducto  Ordenes Comerciales  --->
	<cffunction name="ActualizarTransporteProducto" returntype="boolean">
		<cfargument name="OCTid" type="numeric" required="true">
		<cfargument name="Transporte" type="string" required="true">
<!---		<cfargument name="OCPlinea" type="numeric" required="true">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="OCPcantidad" type="numeric" required="true">
		<cfargument name="OCPprecioUnitario" type="numeric" required="true">
		<cfargument name="OCPprecioTotal" type="numeric" required="true">
		<cfargument name="OCitem_num" type="numeric" required="true">
		<cfargument name="OCport_num" type="numeric" required="true">
		<cfargument name="CFformato" type="string" required="true">    --->

		<cfset var query = "">
<!---		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCordenProducto
				(OCid, Aid, OCPlinea, Ucodigo, Ecodigo, OCPcantidad, OCPprecioUnitario,
				 OCPprecioTotal, OCitem_num, OCport_num, CFformato, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			  <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.OCPlinea#">
			  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCPcantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioUnitario#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCPprecioTotal#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCitem_num#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCport_num#">
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFformato#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>   --->
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** --->

	<!--- //// Actualizar Producto Transito  Ordenes Comerciales  --->
	<cffunction name="ActualizarProductoTransito" returntype="boolean">
		<cfargument name="OCTid" type="numeric" required="true">
		<cfargument name="Aid" type="numeric" required="true">

<!---		<cfset var query = "">
		<cfquery name="query" datasource="#Session.Dsn#">
			insert INTO OCproductoTransito
				(OCTid, Aid, Ecodigo, OCTPtranformado, OCTPentradasCantidad, OCTPentradasCostoTotal,
				 OCTPsalidasCantidad, OCTPsalidasCostoTotal, BMUsucodigo)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OCTid#">
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			  <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.OCTPtransformado#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCTPentradasCantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPentradasCostoTotal#">
			  <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.OCTPsalidasCantidad#">
			  <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.OCTPsalidasCostoTotal#">
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.Usucodigo#">)
		</cfquery>    --->
		
		<cfreturn true>
	</cffunction>  <!--- **** Fin de la Función **** ---> 

</cfcomponent>