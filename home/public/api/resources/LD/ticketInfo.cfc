<cfcomponent extends="taffy.core.resource" taffy_uri="/ticket_info">

	<cfset this.ld = createObject("component", "home.public.api.components.ld")>
	<cfset this.utils = createObject("component","home.public.api.components.utils")>
	<cfset this.db = createObject("component","home.Componentes.datamgr.DataMgr").init("ldcom","MSSQL")>

	<cffunction name="get" access="public" output="false"> 
        <cfargument  name="Emp_Id" required="true" type="string">
        <cfargument  name="Ticket" required="true" type="string">
        <cfargument  name="TipoDoc_Id" required="true" type="string">

		<cfset ticketData = listToArray(arguments.Ticket,"-")>
        
		<cfset result = StructNew()>
		<cfset result["result"] = true>
		<cfset status = 200>
		
        <cftry>
			
			<cfset rsTicket = this.ld.getTicketInfo(
				Emp_Id=arguments.Emp_Id, TipoDoc_Id=arguments.TipoDoc_Id, Suc_Id=ticketData[1], Caja_Id=ticketData[2], Factura_Id=ticketData[3] 
			)>

			<cfset result["data"] = this.ld.queryTicketToStruct(rsTicket)>

			<cfreturn representationOf(result).withStatus(status) />

		<cfcatch>
			<cfset result = structNew()>
			<cfset status = 500>
			<cfset result["result"] = false>
			<cfset result["message"] = #cfcatch.message#> 
			<cfreturn representationOf(result).withStatus(status) />
		</cfcatch>

		</cftry>     
        

    </cffunction>
	
	<cffunction name="post" access="public" output="false"> 
        <cfargument  name="Emp_Id" required="true" type="string">
        <cfargument  name="Ticket" required="true" type="string">
        <cfargument  name="TipoDoc_Id" required="true" type="string">
        <cfargument  name="XmlData" required="false" type="string">
		<cfargument  name="PdfDataB64" required="false" type="string">
		
		<!--- TABLAS --->
		<cfset Factura_Table = "Factura_Fiscal_Encabezado">
		<cfset Factura_Detalle_Table = "Factura_Fiscal_Detalle">
		<cfset Factura_XML = "Factura_Fiscal_XML">
		<cfset Factura_PDF = "Factura_Fiscal_PDF">

        
		<cfset result = StructNew()>
		
		<cfset str = structnew()>
		<cfset result["result"] = true>
		<cfset status = 200>
		
		<cftry>
			
			<cfset ticketData = listToArray(arguments.Ticket,"-")>
			
			<cfset _cfdi = this.utils.CFDIToStruct(arguments.XmlData, str)>
			<cfset _invoice = this.utils.TableToStruct(Factura_Table)>
			<cfset _invoiceDetail = this.utils.TableToStruct(Factura_Detalle_Table)>
			<cfset _ticket = this.ld.queryTicketToStruct( 
								this.ld.getTicketInfo( Emp_Id=arguments.Emp_Id, TipoDoc_Id=arguments.TipoDoc_Id, 
										Suc_Id=ticketData[1], Caja_Id=ticketData[2], 
										Factura_Id=ticketData[3] )
				)>
				
			<!--- Se aginan valores a  --->
			<cfquery name="rsUsoCFDI" datasource="sifcontrol">
				select * from CSATUsoCFDI
				where CSATcodigo = '#_cfdi.Comprobante.Receptor.Atributos.UsoCFDI#'
			</cfquery>
			<cfquery name="rsFormaPago" datasource="sifcontrol">
				select * from CSATFormaPago
				where CSATcodigo = '#_cfdi.Comprobante.Atributos.FormaPago#'
			</cfquery>

			<cfset _moneda = "MXN">
			<cfset _tipoCambio = 1>
			
			<cfif StructKeyExists(_cfdi.Comprobante.Atributos, "Moneda") and ListContains(_cfdi.Comprobante.Atributos.Moneda,"MXN,XXX") neq 0>
				<cfset _moneda = _cfdi.Comprobante.Atributos.Moneda>
			</cfif>
			
			<cfif StructKeyExists(_cfdi.Comprobante.Atributos, "TipoCambio")>
				<cfset _tipoCambio = _cfdi.Comprobante.Atributos.TipoCambio>
			</cfif>

			<cfquery name="rsMoneda" datasource="sifcontrol">
				select * from CSATMoneda
				where CSATcodigo = '#_moneda#'
			</cfquery>
			
			<cfscript>
				_invoice.Emp_Id = arguments.Emp_Id;
				_invoice.Suc_Id = ticketData[1];
				_invoice.Fiscal_NumeroFactura = _cfdi.Comprobante.Atributos.Folio;
				_invoice.Fiscal_Fecha = _cfdi.Comprobante.Atributos.Fecha;
				_invoice.Cliente_Id = _ticket.ClienteId;
				_invoice.Fiscal_Codigo_Postal = _cfdi.Comprobante.Atributos.LugarExpedicion;
				_invoice.ClienteFiscal_Id = _cfdi.Comprobante.Receptor.Atributos.Rfc;
				_invoice.Fiscal_RazonSocial = _cfdi.Comprobante.Receptor.Atributos.Nombre;
				_invoice.Fiscal_Impuesto = _cfdi.Comprobante.Impuestos.Atributos.TotalImpuestosTrasladados;
				_invoice.Fiscal_Direccion = IIf( len(_ticket.ClienteDireccion), _ticket.ClienteDireccion, DE('No TIENE'));
				_invoice.Fiscal_Estado = 'NO';
				if (StructKeyExists(_cfdi.Comprobante.Atributos, "Descuento"))  {
					_invoice.Fiscal_Descuento = _cfdi.Comprobante.Atributos.Descuento;
				} else { _invoice.Fiscal_Descuento = 0; };
				_invoice.Fiscal_Total = _cfdi.Comprobante.Atributos.Total;
				_invoice.Fiscal_Fec_Actualizacion = _cfdi.Comprobante.Atributos.Fecha;
				_invoice.Fiscal_Tipo_Factura = arguments.TipoDoc_Id;
				_invoice.Fiscal_UUID = _cfdi.TimbreFiscalDigital.Atributos.UUID;
				_invoice.Fiscal_FechaTimbrado = _cfdi.Comprobante.Atributos.Fecha;
				_invoice.Fiscal_selloCFD = _cfdi.TimbreFiscalDigital.Atributos.SelloCFD;
				_invoice.Fiscal_selloSAT = _cfdi.TimbreFiscalDigital.Atributos.SelloSAT;
				_invoice.Fiscal_Serie = _cfdi.Comprobante.Atributos.Serie;
				_invoice.Fiscal_Sello = _cfdi.Comprobante.Atributos.Sello;
				_invoice.Fiscal_noCertificado = _cfdi.Comprobante.Atributos.NoCertificado;
				_invoice.Fiscal_IEPS = this.cfdiGetImpuestoByType(_cfdi,"003");
				if (_cfdi.Comprobante.Atributos.TipoDeComprobante == 'I') {
					_invoice.Fiscal_Tipo = 1;
				} else if (_cfdi.Comprobante.Atributos.TipoDeComprobante == 'E') { 
					_invoice.Fiscal_Tipo = 2; 
				} else {
					throw(message="Tipo de Factura Incorrecto");
				};
				_invoice.Fiscal_Metodo_Pago = _cfdi.Comprobante.Atributos.MetodoPago;
				_invoice.Fiscal_Fecha_Pedido = _cfdi.Comprobante.Atributos.Fecha;
				if (_cfdi.Comprobante.Receptor.Atributos.Rfc == "XAXX010101000") {
					_invoice.Fiscal_RFC_Generico = 1;
				};
				_invoice.Fiscal_Forma_Pago = _cfdi.Comprobante.Atributos.FormaPago;
				_invoice.Fiscal_Fecha_Emision = _cfdi.Comprobante.Atributos.Fecha;
				_invoice.Fiscal_noCertificado_Digital = _cfdi.Comprobante.Atributos.NoCertificado;
				_invoice.Fiscal_NoTransaccion = "#lsParseNumber(ticketData[1])#-#lsParseNumber(ticketData[2])#-#lsParseNumber(ticketData[3])#";
				_invoice.Fiscal_Rfc_Emisor = _cfdi.Comprobante.Emisor.Atributos.Rfc;
				if (isDefined("arguments.PdfDataB64") && len(arguments.PdfDataB64)) {
					_invoice.Fiscal_Tiene_PDF = 1;
				};
				_invoice.Fiscal_Fecha_Anulacion = '';
				_invoice.Fiscal_Fecha_Proceso = now();
				_invoice.Uso_Id = 1;
				_invoice.Uso_Clave = _cfdi.Comprobante.Receptor.Atributos.UsoCFDI;
				_invoice.Uso_Descripcion = rsUsoCFDI.CSATdescripcion;
				_invoice.Fiscal_SubTotal = _cfdi.Comprobante.Atributos.SubTotal;
				if (_cfdi.Comprobante.Atributos.TipoDeComprobante == 'I') {
					_invoice.Fiscal_TipoComprobante = 'Ingreso';
				} else if (_cfdi.Comprobante.Atributos.TipoDeComprobante == 'E') { 
					_invoice.Fiscal_TipoComprobante = 'Egreso'; 
				} else {
					throw(message="Tipo de Factura Incorrecto");
				};
				_invoice.Fiscal_RegimenFiscal = _cfdi.Comprobante.Emisor.Atributos.RegimenFiscal;
				_invoice.Fiscal_Forma_Pago_Nombre = rsFormaPago.CSATdescripcion;
				_invoice.Fiscal_Moneda = rsMoneda.CSATdescripcion;
				_invoice.Fiscal_Tipo_Cambio = _tipoCambio;
				
			</cfscript>			
			
			<cftransaction>
				<cftry>
					<cfset _ticketDB = this.db.queryRowToStruct ( 
								this.ld.getTicketDB( Emp_Id=arguments.Emp_Id, TipoDoc_Id=arguments.TipoDoc_Id, 
										Suc_Id=ticketData[1], Caja_Id=ticketData[2], 
										Factura_Id=ticketData[3] )
					)>

					<cfset _ticketDB.Fiscal_NumeroFactura = _invoice.Fiscal_NumeroFactura>
					<cfset this.db.insertRecord( Factura_Table, _invoice )>
					<cfset _facturaFiscal = this.db.queryRowToStruct ( 
						this.db.getRecords( tablename = Factura_Table, 
											filters = [
												{field="Emp_Id",value=arguments.Emp_Id},
												{field="Suc_Id",value=ticketData[1]},
												{field="Fiscal_NumeroFactura",value=_invoice.Fiscal_NumeroFactura}
											] )
					)>
					<cfloop index="index" from="1" to="#ArrayLen(_cfdi.Comprobante.Conceptos)#">
						<cfset concepto = _cfdi.Comprobante.Conceptos[index].Concepto>
						
						<cfscript>
							_invoiceDetail.Emp_Id = arguments.Emp_Id;
							_invoiceDetail.Suc_Id = ticketData[1];
							_invoiceDetail.Fiscal_NumeroFactura = _facturaFiscal.Fiscal_NumeroFactura;
							_invoiceDetail.Detalle_Id = index;
							_invoiceDetail.TipoDoc_id = arguments.TipoDoc_Id;
							_invoiceDetail.Caja_Id = ticketData[2];
							_invoiceDetail.Factura_Id = ticketData[3];
							_invoiceDetail.Articulo_Id = concepto.Atributos.NoIdentificacion;
							_invoiceDetail.Detalle_Articulo_Nombre = 'VENTA';
							_invoiceDetail.Detalle_Cantidad = concepto.Atributos.Cantidad;
							if (StructKeyExists(concepto.Atributos, "Descuento"))  {
								_invoiceDetail.Detalle_Descuento_Monto = concepto.Atributos.Descuento;
							} else { _invoiceDetail.Detalle_Descuento_Monto = 0; };

							_invoiceDetail.Detalle_Impuesto_Porc = 'NO';
							_invoiceDetail.Fiscal_Total = concepto.Atributos.Total;
							_invoiceDetail.Fiscal_Fec_Actualizacion = concepto.Atributos.Fecha;
							_invoiceDetail.Fiscal_Tipo_Factura = arguments.TipoDoc_Id;
							_invoiceDetail.Fiscal_UUID = _cfdi.TimbreFiscalDigital.Atributos.UUID;
							_invoiceDetail.Fiscal_FechaTimbrado = concepto.Atributos.Fecha;
							_invoiceDetail.Fiscal_selloCFD = _cfdi.TimbreFiscalDigital.Atributos.SelloCFD;
							_invoiceDetail.Fiscal_selloSAT = _cfdi.TimbreFiscalDigital.Atributos.SelloSAT;
							_invoiceDetail.Fiscal_Serie = concepto.Atributos.Serie;
							_invoiceDetail.Fiscal_Sello = concepto.Atributos.Sello;
							_invoiceDetail.Fiscal_noCertificado = concepto.Atributos.NoCertificado;
							_invoiceDetail.Fiscal_IEPS = this.cfdiGetImpuestoByType(_cfdi,"003");
							if (concepto.Atributos.TipoDeComprobante == 'I') {
								_invoiceDetail.Fiscal_Tipo = 1;
							} else if (concepto.Atributos.TipoDeComprobante == 'E') { 
								_invoiceDetail.Fiscal_Tipo = 2; 
							} else {
								throw(message="Tipo de Factura Incorrecto");
							};
							_invoiceDetail.Fiscal_Metodo_Pago = concepto.Atributos.MetodoPago;
							_invoiceDetail.Fiscal_Fecha_Pedido = concepto.Atributos.Fecha;
							if (concepto.Receptor.Atributos.Rfc == "XAXX010101000") {
								_invoiceDetail.Fiscal_RFC_Generico = 1;
							};
							_invoiceDetail.Fiscal_Forma_Pago = concepto.Atributos.FormaPago;
							_invoiceDetail.Fiscal_Fecha_Emision = concepto.Atributos.Fecha;
							_invoiceDetail.Fiscal_noCertificado_Digital = concepto.Atributos.NoCertificado;
							_invoiceDetail.Fiscal_NoTransaccion = "#lsParseNumber(ticketData[1])#-#lsParseNumber(ticketData[2])#-#lsParseNumber(ticketData[3])#";
							_invoiceDetail.Fiscal_Rfc_Emisor = concepto.Emisor.Atributos.Rfc;
							if (isDefined("arguments.PdfDataB64") && len(arguments.PdfDataB64)) {
								_invoiceDetail.Fiscal_Tiene_PDF = 1;
							};
							_invoiceDetail.Fiscal_Fecha_Anulacion = '';
							_invoiceDetail.Fiscal_Fecha_Proceso = now();
							_invoiceDetail.Uso_Id = 1;
							_invoiceDetail.Uso_Clave = concepto.Receptor.Atributos.UsoCFDI;
							_invoiceDetail.Uso_Descripcion = rsUsoCFDI.CSATdescripcion;
							_invoiceDetail.Fiscal_SubTotal = concepto.Atributos.SubTotal;
							if (concepto.Atributos.TipoDeComprobante == 'I') {
								_invoiceDetail.Fiscal_TipoComprobante = 'Ingreso';
							} else if (concepto.Atributos.TipoDeComprobante == 'E') { 
								_invoiceDetail.Fiscal_TipoComprobante = 'Egreso'; 
							} else {
								throw(message="Tipo de Factura Incorrecto");
							};
							_invoiceDetail.Fiscal_RegimenFiscal = concepto.Emisor.Atributos.RegimenFiscal;
							_invoiceDetail.Fiscal_Forma_Pago_Nombre = rsFormaPago.CSATdescripcion;
							_invoiceDetail.Fiscal_Moneda = rsMoneda.CSATdescripcion;
							_invoiceDetail.Fiscal_Tipo_Cambio = _tipoCambio;
							
						</cfscript>	
						
						<cfset this.db.insertRecord( Factura_Detalle_Table, _invoiceDetail )>

					</cfloop>
					
					<cftransaction action="rollback">
					<cfreturn representationOf(_invoiceDetail).withStatus(status) />

					<cfset _ticketDBU = this.db.updateRecord( _ticketDB.OrigenTicket, _ticketDB )>

				<cfcatch type="any">
					<cftransaction action="rollback">
					<cfrethrow>
				</cfcatch>
				</cftry>
			</cftransaction>
			
			<cfset rsTicket = this.ld.getTicketInfo(
				Emp_Id=arguments.Emp_Id, TipoDoc_Id=arguments.TipoDoc_Id, Suc_Id=ticketData[1], Caja_Id=ticketData[2], Factura_Id=ticketData[3] 
			)>

			<!--- <cfset result["data"] = this.ld.queryTicketToStruct(rsTicket)> --->
			
			<cfreturn representationOf(result).withStatus(status) />

		<cfcatch type="any">
			<cfset result = structNew()>
			<cfset status = 500>
			<cfset result["result"] = false>
			<cfset result["message"] = #cfcatch.message#> 
			<cfset result["catch"] = #cfcatch#> 
			<cfreturn representationOf(result).withStatus(status) />
		</cfcatch>

		</cftry>     
        

	</cffunction>
	
	<cffunction  name="cfdiGetImpuestoByType" returntype="numeric">
		<cfargument  name="cfdiStruct" type="Struct" required="true">
		<cfargument  name="ImpuestoTipo" type="string" required="true">
		
		<cfset result = 0>

		<cfset arrTraslados = _cfdi.Comprobante.Impuestos.Traslados>

		<cfloop array="#arrTraslados#" item="traslado">
			<cfif traslado.Atributos.Impuesto eq ImpuestoTipo>
				<cfset result += traslado.Atributos.Importe>
			</cfif>
		</cfloop>

		<cfreturn result>
	</cffunction>
	
		
</cfcomponent>
