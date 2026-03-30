<!---
  --- WSGetToken
  --------------
  --- Description WS que devuelve Arreglo de Clientes (SNegocios) y Objeto de Cliente
  --- Author Ing. Oscar Orlando Parrales Villanueva
  --- Date   2018-09-06
 --->
<cfcomponent extends="IntegracionVentas_Base">

	<cfset CompVentaCred = createObject('component', 'Procesar_Venta_Credito')>

	<cffunction name="PreVenta" returntype="WResponse" access="remote">
		<cfargument name="Emp_id"					type="string"	required="true">
		<cfargument name="Suc_id"					type="string"	required="true">
		<cfargument name="Cliente_CodigoExterno"	type="string"	required="true">
		<cfargument name="Ticket"					type="string"	required="true"> <!--- Codigo de la Empresa externa que consume el WS --->
		<cfargument name="Monto" 					type="string" 	required="true">
		<cfargument name="token" 					type="string" 	required="true">

		<cfobject component="WResponse" name="result">

<!---
		<cfinvoke method="getToken" returnvariable="tokenOrig" component="WSGetToken">
			<cfinvokeargument name="usuario" value="SampleUserLD">
			<cfinvokeargument name="password" value="UnPassSample015O1NLD">
		</cfinvoke>

		<cfif tokenOrig neq token>
			<cflog file="WSClientesVentas" text="ValidationException: TOKEN INVALIDO" log="Application" type="information">
			<cfthrow type="ValidationException" message="TOKEN INVALIDO">
		</cfif>
--->

		<cftry>

			<cfset _ecodigo = getEquivalencia(ValorOrigen = arguments.Emp_id)>
			<cfset _dsn = getConexion(val(_ecodigo))>
			<cfset lVarClienteActualizado = #Arguments.Cliente_CodigoExterno#>

			<cfif isdefined("Arguments.Cliente_CodigoExterno") AND #Arguments.Cliente_CodigoExterno# EQ "CteVale">
				<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
				<cfset paramCteVales = crcParametros.GetParametro(codigo='30200101',conexion=#_dsn#,ecodigo=#_ecodigo#)>

				<cfquery name="rsGetInfoSN" datasource="#_dsn#">
					SELECT COALESCE(SNcodigoext, SNcodigo) AS SNcodigoext
					FROM SNegocios
					WHERE SNid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramCteVales#">
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ecodigo#">
				</cfquery>

				<cfset lVarClienteActualizado = #rsGetInfoSN.SNcodigoext#>
			<cfelseif isdefined("Arguments.Cliente_CodigoExterno") AND #Arguments.Cliente_CodigoExterno# EQ "CteTarjeta">
				<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
				<cfset paramCteTarjeta = crcParametros.GetParametro(codigo='30200102',conexion=#_dsn#,ecodigo=#_ecodigo#)>
				<cfquery name="rsGetInfoSN" datasource="#_dsn#">
					SELECT COALESCE(SNcodigoext, SNcodigo) AS SNcodigoext
					FROM SNegocios
					WHERE SNid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramCteTarjeta#">
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ecodigo#">
				</cfquery>
				<cfset lVarClienteActualizado = #rsGetInfoSN.SNcodigoext#>
			</cfif>

			<!--- Se obtienen los dtos del Cliente --->
			<cfquery name="rsCliente" datasource="#_dsn#">
				select
					SNid,
					SNcodigo,
					SNtipo,
					SNnombre,
					SNidentificacion,
					SNcodigoext,
					SNdireccion,
					coalesce(SNemail,'') SNemail,
					coalesce(SNtelefono,'') SNtelefono,
					SNnumero,
					isnull(SNmontoLimiteCC,0) SNmontoLimiteCC,
					Ecodigo EcodigoSIF,
					SNtiposocio,
					SNcuentacxp,
					SNplazocredito,
					Mcodigo,
					isnull(saldoCliente,0) saldoCliente
				from SNegocios
				where Ecodigo = #_ecodigo#
					and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(lVarClienteActualizado)#">
			</cfquery>

			<cfif rsCliente.recordCount eq 0>
				<cfthrow message="No se encontro informacion del Cliente con Codigo Externo: #Arguments.Cliente_CodigoExterno# ">
			</cfif>

			<!--- Se valida que haya disponible --->
			<cfset _disponible = rsCliente.SNmontoLimiteCC - rsCliente.saldoCliente>

			<cfif _disponible gt 0 and arguments.Monto gt _disponible>
				<cfthrow message="Disponible insuficiente para el cliente con codigo externo: #Arguments.Cliente_CodigoExterno#">
			</cfif>
			<cftransaction>
			<!--- <cfargument name="Emp_id"					type="string"	required="true">
		<cfargument name="Suc_id"					type="string"	required="true">
		<cfargument name="Cliente_CodigoExterno"	type="string"	required="true">
		<cfargument name="Ticket"					type="string"	required="true"> --->
				<cfquery datasource="#_dsn#" name="rsValida">
					SELECT COALESCE(Monto,0) AS Monto, RTRIM(LTRIM(Numero_Documento)) AS Numero_Documento, id
					FROM BTransito_CC
					WHERE Emp_id = #arguments.Emp_id#
					  AND Suc_id = #arguments.Suc_id#
					  AND SNcodigoExt = '#lVarClienteActualizado#'
					  AND Ticket = '#arguments.Ticket#'
					  AND Ecodigo = #_ecodigo#
				</cfquery>
				<cfif isdefined("rsValida") AND #rsValida.RecordCount# GT 0>
					<cfif #LEN(rsValida.Numero_Documento)# GT 0>
						<cfset result.codigo = 0>
						<cfset result.resultado = false>
						<cfset result.mensaje = 'La preventa ya fue procesada, Documento en SIF: #rsValida.Numero_Documento#'>
					<cfelse>
						<cfquery datasource="#_dsn#" name="myResult">
							UPDATE BTransito_CC
							SET Monto = #arguments.Monto#
							WHERE Emp_id = #arguments.Emp_id#
							  AND Suc_id = #arguments.Suc_id#
							  AND SNcodigoExt = '#lVarClienteActualizado#'
							  AND Ticket = '#arguments.Ticket#'
							  AND Ecodigo = #_ecodigo#
						</cfquery>
						<cfset result.codigo = #rsValida.id#>
						<cfset result.resultado = true>
						<cfset result.mensaje = 'Preventa actualizada correctamente!'>
					</cfif>
				<cfelse>
					<cfquery datasource="#_dsn#" result="myResult">
						INSERT INTO BTransito_CC
							(Emp_id
							,Suc_id
							,SNcodigoExt
							,Ticket
							,Monto
							,Ecodigo
							,createdat)
						VALUES
							(#arguments.Emp_id#
							,#arguments.Suc_id#
							,'#lVarClienteActualizado#'
							,'#arguments.Ticket#'
							,#arguments.Monto#
							,#_ecodigo#
							,getdate())
					</cfquery>
					<cfset _codigo = myResult.generatedkey>
					<cfset result.codigo = _codigo>
					<cfset result.resultado = true>
					<cfset result.mensaje = 'Operacion Exitosa'>
				</cfif>

				<cftransaction action="commit">
			</cftransaction>
		<cfcatch type="database">
			<cfset result.resultado = false>
			<cfset result.codigo = 0>
			<cfset result.mensaje = cfcatch.message>
			<cfset result.detalle = cfcatch.sql>
		</cfcatch>
		<cfcatch type="any">
			<cfset result.resultado = false>
			<cfset result.codigo = 0>
			<cfset result.mensaje = cfcatch.message>
		</cfcatch>
		<cffinally>
			<cfreturn result>
		</cffinally>
		</cftry>

	</cffunction>

	<cffunction name="CancelaPreVenta" returntype="WResponse" access="remote">
		<cfargument name="Emp_id"					type="string"	required="true">
		<cfargument name="Transaccion_id" 	type="numeric" 	required="true">
		<cfargument name="token" 			type="string" 	required="true">

		<cfobject component="WResponse" name="result">

<!---
		<cfinvoke method="getToken" returnvariable="tokenOrig" component="WSGetToken">
			<cfinvokeargument name="usuario" value="SampleUserLD">
			<cfinvokeargument name="password" value="UnPassSample015O1NLD">
		</cfinvoke>

		<cfif tokenOrig neq token>
			<cflog file="WSClientesVentas" text="ValidationException: TOKEN INVALIDO" log="Application" type="information">
			<cfthrow type="ValidationException" message="TOKEN INVALIDO">
		</cfif>
--->

		<cftry>

			<cfset _ecodigo = getEquivalencia(ValorOrigen = arguments.Emp_id)>
			<cfset _dsn = getConexion(val(_ecodigo))>

			<cftransaction>
				<cfquery datasource="#_dsn#" >
					delete from  BTransito_CC
					where id = #arguments.Transaccion_id#
				</cfquery>

				<cfset result.codigo = arguments.Transaccion_id>
				<cfset result.resultado = true>
				<cfset result.mensaje = 'Operacion Exitosa'>
				<cftransaction action="commit">
			</cftransaction>
		<cfcatch type="database">
			<cfset result.resultado = false>
			<cfset result.codigo = 0>
			<cfset result.mensaje = cfcatch.message>
			<cfset result.detalle = cfcatch.sql>
		</cfcatch>
		<cfcatch type="any">
			<cfset result.resultado = false>
			<cfset result.codigo = 0>
			<cfset result.mensaje = cfcatch.message>
			<cfset result.detalle = cfcatch.Type>
		</cfcatch>
		<cffinally>
			<cfreturn result>
		</cffinally>
		</cftry>

	</cffunction>

	<cffunction name="RecibeVenta" returntype="WResponse" access="remote">
		<cfargument name="Emp_id"					type="string"	required="true">
		<cfargument name="Suc_id"					type="string"	required="true">
		<cfargument name="Cliente_CodigoExterno"	type="string"	required="true">
		<cfargument name="Ticket"					type="string"	required="true">
		<!--- XML --->
		<cfargument name="Fiscal_NumeroFactura" 	type="string" 	required="false">
		<cfargument name="Fiscal_Serie" 			type="string" 	required="false">
		<cfargument name="Fiscal_FechaTimbrado" 	type="date" 	required="false">
		<cfargument name="Fiscal_Fecha" 			type="date" 	required="false">
		<cfargument name="Fiscal_UUID" 				type="string" 	required="false">
		<cfargument name="Fiscal_Tipo_Factura" 		type="numeric" 	required="false" default="1">
		<cfargument name="Fiscal_Tipo" 				type="numeric" 	required="false">
		<cfargument name="SubTotal" 			    type="numeric" 	required="false">
		<cfargument name="Fiscal_Total" 			type="numeric" 	required="false">
		<cfargument name="Fiscal_Impuesto" 			type="numeric" 	required="false">
		<cfargument name="Fiscal_Descuento" 		type="numeric" 	required="false">
		<cfargument name="Fiscal_IEPS" 				type="numeric" 	required="false">
		<cfargument name="Cliente_Plazo"	 		type="numeric" 	required="false">
		<cfargument name="Xml"			 			type="string" 	required="true">
		<cfargument name="Impuestos"	 			type="WImpuesto[]" 	required="false">
		<cfargument name="token" 					type="string" 	required="true">
		<cfargument name="Anulacion" 				type="string" 	required="false" default="false">

		<cfset _ecodigo = getEquivalencia(ValorOrigen = arguments.Emp_id)>
		<cfset _dsn = getConexion(val(_ecodigo))>
		<cfset lFlag = false>

		<cfif isdefined("Arguments.Cliente_CodigoExterno") AND #Arguments.Cliente_CodigoExterno# EQ "CteVale">
			<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
			<cfset paramCteVales = crcParametros.GetParametro(codigo='30200101',conexion=#_dsn#,ecodigo=#_ecodigo#)>
			<cfset lFlag = true>

			<cfquery name="rsGetInfoSN" datasource="#_dsn#">
				SELECT COALESCE(SNcodigoext, SNcodigo) AS SNcodigoext
				FROM SNegocios
				WHERE SNid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramCteVales#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ecodigo#">
			</cfquery>
			<cfset Arguments.Cliente_CodigoExterno = #rsGetInfoSN.SNcodigoext#>
		<cfelseif isdefined("Arguments.Cliente_CodigoExterno") AND #Arguments.Cliente_CodigoExterno# EQ "CteTarjeta">
			<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
			<cfset paramCteTarjeta = crcParametros.GetParametro(codigo='30200102',conexion=#_dsn#,ecodigo=#_ecodigo#)>
			<cfquery name="rsGetInfoSN" datasource="#_dsn#">
				SELECT COALESCE(SNcodigoext, SNcodigo) AS SNcodigoext
				FROM SNegocios
				WHERE SNid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramCteTarjeta#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ecodigo#">
			</cfquery>
			<cfset Arguments.Cliente_CodigoExterno = #rsGetInfoSN.SNcodigoext#>
		</cfif>

		<cfif NOT isdefined("arguments.Cliente_Plazo")>
			<!--- En caso de no traer el plazo, se obtiene de la tabla socios de negocio --->
			<cfquery name="rsInfoSN" datasource="minisif">
				SELECT COALESCE(SNplazocredito, 0) AS SNplazocredito
				FROM SNegocios
				WHERE SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.Cliente_CodigoExterno#'>
			</cfquery>

			<cfif rsInfoSN.RecordCount GT 0>
				<cfset Arguments.Cliente_Plazo = rsInfoSN.SNplazocredito>
			</cfif>
		</cfif>

		<cfobject component="WResponse" name="result">

		<!--- Validacion para ver si existe el XML, si existe, se toman los datos de el. --->
		<cfif isDefined("Arguments.Xml") AND #Arguments.Xml# NEQ "">
			<cftry>
				<!--- Parseado de XML --->
				<cfset xmltimbrado = XmlParse(Arguments.Xml)>

				<!--- Encabezado --->
				<cfset headAtt = xmltimbrado["cfdi:Comprobante"].XmlAttributes>

				<!--- Complemento --->
				<cfset complem = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["tfd:TimbreFiscalDigital"].XmlAttributes>

				<!--- Conceptos --->
				<cfset ConceptosArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Conceptos"].XmlChildren>
				<!--- Impuestos --->
				<cfset ImpuestosArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Impuestos"].XmlChildren>

				<!--- Sobreescritura de Argumentos --->
				<cfif isDefined("Arguments.Anulacion") AND #Arguments.Anulacion# NEQ "true">
				<cfset Arguments.Fiscal_NumeroFactura = headAtt.Folio>
				<cfset Arguments.Fiscal_Serie = headAtt.Serie>
				</cfif>
				<cfset Arguments.Fiscal_FechaTimbrado = ReplaceNoCase(complem.FechaTimbrado, 'T', ' ')>
				<cfset Arguments.Fiscal_Fecha = ReplaceNoCase(headAtt.Fecha, 'T', ' ')>
				<cfset Arguments.Fiscal_UUID = complem.UUID>
				<cfset Arguments.SubTotal = headAtt.SubTotal>
				<cfset Arguments.Fiscal_Total = headAtt.Total>

				<cfif isDefined("Arguments.Anulacion") AND #Arguments.Anulacion# EQ "true">
					<cfset Arguments.Fiscal_Tipo = 2>
				<cfelse>
				<cfif UCASE(headAtt.TipoDeComprobante) EQ 'I'>
					<!--- INGRESOS FC --->
					<cfset Arguments.Fiscal_Tipo = 1>
				<cfelseif  UCASE(headAtt.TipoDeComprobante) EQ 'E'>
					<!--- EGRESO NC --->
					<cfset Arguments.Fiscal_Tipo = 2>
					</cfif>
				</cfif>

				<!--- Impuestos 002 - IVA Y  003 - IEPS --->
				<cfset lVar002_0 = 0>
				<cfset lVar002_8 = 0>
				<cfset lVar002_16 = 0>
				<cfset lVar003_3 = 0>
				<cfset lVar003_6 = 0>
				<cfset lVar003_8 = 0>

				<!--- Objeto Impuesto --->
				<cfobject component="WImpuesto" name="IVA0">
				<!--- 2 IVA0 EN LDCOM --->
				<cfset IVA0.Codigo = 2>
				<cfset IVA0.Porcentaje = 0>
				<cfset IVA0.MontoBase = 0>
				<cfset IVA0.Monto = 0>
				<cfset IVA0.Descuento = 0>
				<cfset IVA0.CodigoIEPS = 0>
				<cfset IVA0.MontoIEPS = 0>
				<!--- Retencion 0, porque no esta en xml --->
				<cfset IVA0.Retencion = 0>

				<cfobject component="WImpuesto" name="IVA16">
				<!--- 1 IVA16 EN LDCOM --->
				<cfset IVA16.Codigo = 1>
				<cfset IVA16.Porcentaje = 16>
				<cfset IVA16.MontoBase = 0>
				<cfset IVA16.Monto = 0>
				<cfset IVA16.Descuento = 0>
				<cfset IVA16.CodigoIEPS = 0>
				<cfset IVA16.MontoIEPS = 0>
				<!--- Retencion 0, porque no esta en xml --->
				<cfset IVA16.Retencion = 0>

				<!--- IVA 8 --->
				<cfobject component="WImpuesto" name="IVA8">
				<!--- 1 IVA16 EN LDCOM --->
				<cfset IVA8.Codigo = 1>
				<cfset IVA8.Porcentaje = 8>
				<cfset IVA8.MontoBase = 0>
				<cfset IVA8.Monto = 0>
				<cfset IVA8.Descuento = 0>
				<cfset IVA8.CodigoIEPS = 0>
				<cfset IVA8.MontoIEPS = 0>
				<!--- Retencion 0, porque no esta en xml --->
				<cfset IVA8.Retencion = 0>


				<cfset lVarTotalIva16 = 0>
				<cfset lVarTotalIva8 = 0>
				<cfset lVarTotalIva0 = 0>

				<cfloop array="#ConceptosArray#" index="conObj">
				<!--- <cfset conObjString = ToString(conObj)>
					<cfif isDefined("conObj.XmlAttributes.Descuento")>
						<cfset lVarDescuento = #conObj.XmlAttributes.Descuento#>
					<cfelse>
						<cfset lVarDescuento = 0>
					</cfif>
					<cfif FindNoCase("Impuesto=""002""",conObjString) GT 0 AND FindNoCase("TasaOCuota=""0.00",conObjString) GT 0>
					<cfset lVarTieneIva = 0>
					<cfset IVA0.Descuento = IVA0.Descuento + lVarDescuento>
						<cfset IVA0.MontoBase = IVA0.MontoBase + (conObj.XmlAttributes.Importe - lVarDescuento) >
					<cfelseif FindNoCase("Impuesto=""002""",conObjString) GT 0 AND FindNoCase("TasaOCuota=""0.16",conObjString) GT 0>
					<cfset lVarTieneIva = 16>
					<cfset IVA16.Descuento = IVA16.Descuento + lVarDescuento>
						<cfset IVA16.MontoBase = IVA16.MontoBase + (conObj.XmlAttributes.Importe - lVarDescuento) >
				<cfelse>
					<cfset lVarTieneIva = -1>
				</cfif> --->
					<cfset trasladosArray = conObj.Impuestos.Traslados.XmlChildren>
					<cfloop array="#trasladosArray#" index="trasObj">
						<cfset lVarTraslado = trasObj.XmlAttributes>
						<cfif isdefined("lVarTraslado.Impuesto") AND #lVarTraslado.Impuesto# EQ "002">
							<!--- SE TRATA DE IVA --->
							<cfif isdefined("lVarTraslado.TasaOCuota") AND FindNoCase("0.16",#lVarTraslado.TasaOCuota#) GT 0 >
								<!--- IVA 16 --->
								<cfset lVarTieneIva = 16>
								<cfset IVA16.MontoBase = IVA16.MontoBase + #lVarTraslado.Base#>
								<cfset lVarTotalIva16 = lVarTotalIva16 + #lVarTraslado.Importe#>
							<cfelseif isdefined("lVarTraslado.TasaOCuota") AND FindNoCase("0.08",#lVarTraslado.TasaOCuota#) GT 0 >
								<!--- IVA 8 --->
								<cfset lVarTieneIva = 8>
								<cfset IVA8.MontoBase = IVA8.MontoBase + #lVarTraslado.Base#>
								<cfset lVarTotalIva8 = lVarTotalIva8 + #lVarTraslado.Importe#>
							<cfelseif isdefined("lVarTraslado.TasaOCuota") AND FindNoCase("0.00",#lVarTraslado.TasaOCuota#) GT 0 >
								<!--- IVA 0 --->
								<cfset lVarTieneIva = 0>
								<cfset IVA0.MontoBase = IVA0.MontoBase + #lVarTraslado.Base#>
								<cfset lVarTotalIva0 = lVarTotalIva0 + #lVarTraslado.Importe#>
							<cfelse>
								<cfset lVarTieneIva = -1>
							</cfif>
						</cfif>

						<cfswitch expression = "#lVarTraslado.Impuesto#">
							<!--- IVA --->
							<!--- <cfcase value="002">
								<cfswitch expression = "#lVarTraslado.TasaOCuota#">
									<!--- IVA 0 --->
									<cfcase value="0.000000">
										<cfset lVar002_0 = lVar002_0 + lVarTraslado.Importe>
									</cfcase>
									<!--- IVA 16 --->
									<cfcase value="0.160000">
										<cfset lVar002_16 = lVar002_16 + lVarTraslado.Importe>
									</cfcase>
									<cfdefaultcase>
										<!--- SIN PORCENTAJE CONSIDERADO --->
									</cfdefaultcase>
								</cfswitch>
							</cfcase> --->
							<!--- IEPS --->
							<cfcase value="003">
								<cfswitch expression = "#lVarTraslado.TasaOCuota#">
									<!--- IEPS 3 --->
									<cfcase value="0.030000">
										<cfset lVar003_3 = lVar003_3 + lVarTraslado.Importe>
										<cfset lvarCodigoIEPS = 3>
									</cfcase>
									<!--- IEPS 6 --->
									<cfcase value="0.060000">
										<cfset lVar003_6 = lVar003_6 + lVarTraslado.Importe>
										<!--- CODIGO IEPS LDCOM --->
										<cfset lvarCodigoIEPS = 6>
									</cfcase>
									<!--- IEPS 8 --->
									<cfcase value="0.080000">
										<cfset lVar003_8 = lVar003_8 + lVarTraslado.Importe>
										<!--- CODIGO IEPS LDCOM --->
										<cfset lvarCodigoIEPS = 8>
									</cfcase>
									<cfdefaultcase>
										<cfset lvarCodigoIEPS = 0>
										<!--- SIN PORCENTAJE CONSIDERADO --->
									</cfdefaultcase>
								</cfswitch>
								<!--- AGREGA IEPS AL ARREGLO --->
								<cfif lVarTieneIva EQ 0>
									<cfset IVA0.CodigoIEPS = lvarCodigoIEPS>
									<cfset IVA0.MontoIEPS = lVar003_3 + lVar003_6 + lVar003_8>
								<cfelseif lVarTieneIva EQ 8>
									<cfset IVA8.CodigoIEPS = lvarCodigoIEPS>
									<cfset IVA8.MontoIEPS = lVar003_3 + lVar003_6 + lVar003_8>
								<cfelseif lVarTieneIva EQ 16>
									<cfset IVA16.CodigoIEPS = lvarCodigoIEPS>
									<cfset IVA16.MontoIEPS = lVar003_3 + lVar003_6 + lVar003_8>
								</cfif>
							</cfcase>
							<cfdefaultcase>
								<!--- SIN IMPUESTO CONSIDERADO --->
							</cfdefaultcase>
						</cfswitch>
					</cfloop>
				</cfloop>



				<!--- Argumentos --->
				<cfset Arguments.Fiscal_Impuesto = lVarTotalIva16 + lVarTotalIva0>
				<cfif isDefined("headAtt.Descuento")>
					<cfset Arguments.Fiscal_Descuento = headAtt.Descuento>
				<cfelse>
					<cfset Arguments.Fiscal_Descuento = 0>
				</cfif>
				<cfset Arguments.Fiscal_IEPS = (lVar003_3 + lVar003_6 + lVar003_8)>

				<!--- Impuestos --->
				<cfset ArrImpuestos = ArrayNew(1)>
				<cfif IVA0.MontoBase GT 0>
					<!--- Se sobreescriben impuestos --->
					<cfif isdefined("lVarTotalIva0")>
						<cfset IVA0.Monto = #lVarTotalIva0#>
					</cfif>
					<cfset ArrayAppend(ArrImpuestos,IVA0)>
				</cfif>
				<cfif IVA8.MontoBase GT 0>
					<!--- Se sobreescriben impuestos --->
					<cfif isdefined("lVarTotalIva8")>
						<cfset IVA8.Monto = #lVarTotalIva8#>
					</cfif>
					<cfset ArrayAppend(ArrImpuestos,IVA8)>
				</cfif>
				<cfif IVA16.MontoBase GT 0>
					<!--- Se sobreescriben impuestos --->
					<cfif isdefined("lVarTotalIva16")>
						<cfset IVA16.Monto = #lVarTotalIva16#>
					</cfif>
					<cfset ArrayAppend(ArrImpuestos,IVA16)>
				</cfif>

				<!--- <cfif Arguments.Fiscal_NumeroFactura eq "158">
					<cf_dump var="#ArrImpuestos#">
				</cfif> --->

				<cfset Arguments.Impuestos = ArrImpuestos>

				<!--- <cfdump var="#IVA16#" label="---------------    16        ----------" output="c:\IVA.txt">
				<cfdump var="#IVA0#" label="---------------    0        ----------" output="c:\IVA.txt"> --->
				<!--- <cfdump var="#Arguments#" label="---------------    Arguments        ----------" output="c:\Arguments.txt"> --->
			<cfcatch type="any">
				<cfset result.resultado = false>
				<cfset result.codigo = 0>
				<cfset result.mensaje = cfcatch.message>
			</cfcatch>
			</cftry>
		</cfif>

<!---
		<cfinvoke method="getToken" returnvariable="tokenOrig" component="WSGetToken">
			<cfinvokeargument name="usuario" value="SampleUserLD">
			<cfinvokeargument name="password" value="UnPassSample015O1NLD">
		</cfinvoke>

		<cfif tokenOrig neq token>
			<cflog file="WSClientesVentas" text="ValidationException: TOKEN INVALIDO" log="Application" type="information">
			<cfthrow type="ValidationException" message="TOKEN INVALIDO">
		</cfif>
--->

		<cftry>
			<cfset _ecodigo = getEquivalencia(ValorOrigen = arguments.Emp_id)>
			<cfset _dsn = getConexion(val(_ecodigo))>

			<!--- <cftransaction> --->
			<cfif isdefined("arguments.Ticket") AND #arguments.Ticket# NEQ "interface">
				<cfquery name="rsTansito" datasource="#_dsn#">
					select top 1 id, Monto from BTransito_CC
					where Emp_id = #arguments.Emp_id#
						and Suc_id = #arguments.Suc_id#
						and SNcodigoExt = '#arguments.Cliente_CodigoExterno#'
						and Ticket = '#arguments.Ticket#'
						and Ecodigo = #_ecodigo#
				</cfquery>

				<cfif rsTansito.recordCount eq 0 AND #Arguments.Fiscal_Tipo# EQ 1>
					<cfset result.resultado = false>
					<cfset result.codigo = 0>
					<cfset result.mensaje = "No se encontro Movimiento en Transito">
				<cfelse>
					<cfset result.codigo = rsTansito.id>
					<cfset result.resultado = true>
					<cfset result.mensaje = 'Operacion Exitosa'>
				</cfif>
			<!--- </cftransaction> --->

				<!--- INICIA VALIDACIONES PREVIAS --->
				<cfif #Arguments.Fiscal_Total# GT #rsTansito.Monto# AND #Arguments.Fiscal_Tipo# EQ 1>
						<cfset result.resultado = false>
						<cfset result.codigo = 0>
						<cfset result.mensaje = "El monto de la factura (#numberformat(Arguments.Fiscal_Total,'9.99')#) excede del monto de la preventa (#numberformat(rsTansito.Monto,'9.99')#).">
					<cfreturn result>
				</cfif>
			<cfelse>
				<cfset result.resultado = true>
			</cfif>

			<!--- FINALIZA VALIDACIONES PREVIAS --->

			<cfif result.resultado>
				<!--- SE INSERTA VENTA --->

				<cfif #Arguments.Fiscal_Tipo# EQ 1>
					<cfif isdefined("arguments.Ticket") AND #arguments.Ticket# NEQ "interface">
						<cfset lVarFC_CxC = CompVentaCred.insertarVenta(#Arguments#, #rsTansito.id#)>
					<cfelse>
						<cfset lVarFC_CxC = CompVentaCred.insertarVenta(#Arguments#, 0)>
					</cfif>
				<cfelse>
					<cfset lVarFC_CxC = CompVentaCred.insertarVenta(#Arguments#, 0)>
				</cfif>
				<cfset result.codigo = lVarFC_CxC.Id>
				<cfif lVarFC_CxC.Id GT 0>
					<cfset result.resultado = true>
					<cfif #Arguments.Fiscal_Tipo# EQ 1>
						<cfif isdefined("arguments.Ticket") AND #arguments.Ticket# NEQ "interface">
							<cfquery name="updateTransito" datasource="#_dsn#">
								UPDATE BTransito_CC
								SET Numero_Documento = <cfqueryparam cfsqltype="cf_sql_Varchar" value="#lVarFC_CxC.Numero_Documento#">
								WHERE id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTansito.id#">
							</cfquery>
						</cfif>
					</cfif>
					<!--- SI EL RESULTADO ES SATISFACCTORIO, SE MANDA A PROCESAR --->
					<cfif #Arguments.Fiscal_Tipo# EQ 1>
						<cfif isdefined("arguments.Ticket") AND #arguments.Ticket# NEQ "interface">
							<cfset lVarProcesar = CompVentaCred.procesarVenta(#Arguments#, #rsTansito.id#)>
						<cfelse>
							<cfset lVarProcesar = CompVentaCred.procesarVenta(#Arguments#, 0)>
						</cfif>
					<cfelse>
						<cfset lVarProcesar = CompVentaCred.procesarVenta(#Arguments#, 0)>
					</cfif>
				<cfelse>
					<cfset result.resultado = false>
				</cfif>
				<cfset result.mensaje = lVarFC_CxC.Msg>



			</cfif>

		<cfcatch type="database">
			<cfset result.resultado = false>
			<cfset result.codigo = 0>
			<cfset result.mensaje = cfcatch.message>
			<cfset result.detalle = cfcatch.sql>
		</cfcatch>
		<cfcatch type="any">
			<cfset result.resultado = false>
			<cfset result.codigo = 0>
			<cfset result.mensaje = cfcatch.message>
			<cfset result.detalle = cfcatch.Type>
		</cfcatch>
		<cffinally>
			<cfreturn result>
		</cffinally>
		</cftry>

	</cffunction>

</cfcomponent>