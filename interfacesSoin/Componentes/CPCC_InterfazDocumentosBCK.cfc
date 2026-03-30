<!---
	Interfaz 10
	Interfaz de Intercambio de Información de Documentos de Cuentas por Cobrar / Cuentas por Pagar
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: D.A.G. (dabarca@soin.co.cr)
	Fecha de U. Modificación: 11/7/2005
	Motivo de la Modificación: Se Modificó la Interpretación y Validación de la Información, además se agregaron algunos campos a las Tablas IE1o y ID10
--->
<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion  = Session.Dsn>
	<cfset GvarEcodigo   = Session.Ecodigo>
	<cfset GvarEcodigoSDC= Session.EcodigoSDC>
	<cfset GvarEnombre   = Session.Enombre>
	<cfset GvarUsucodigo = Session.Usucodigo>
	<cfset GvarUsuario   = Session.Usuario>
	<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
	<cfset GvarCuentaManual = true>
	<cfquery name="rsGvarCuentaManual" datasource="#session.DSN#">
		select Pvalor from Parametros where Pcodigo = 2 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsGvarCuentaManual.recordcount and rsGvarCuentaManual.Pvalor EQ "N">
		<cfset GvarCuentaManual = false>
	</cfif>

	<!--- Process: Procesamiento de la información de la Interfaz 10 debe ser llamada de la siguiente manera:
		<cfinvoke component="interfacesSoin.Componentes.CPCC_InterfazDocumentos" method="process" returnvariable="MSG" query="#readInterfaz10#"/>
		Argumentos:
			MSG = Mensaje de Resultados de la operación.
			Query = Consulta de la Interfaz 10 (Encabezado y Detalles).
	 --->
	<cffunction name="process" access="public" returntype="string">
		<!--- Argumentos --->
		<cfargument name="query" required="yes" type="query">
		<!--- Procesamiento de Encabezado de la Interfaz 10  --->
		<cfoutput query="query" group="ID">
			<!--- Variables Validadas de Cuentas por Cobrar y Cuentas por Pagar --->
			<cfset Valid_EcodigoSDC = getValidEcodigoSDC(query.EcodigoSDC)>
			<cfset Valid_Modulo = getValidModulo(query.Modulo)>
			<cfset Valid_SNcodigo = getValidSNcodigo(query.NumeroSocio, query.CodigoDireccionEnvio, query.CodigoDireccionFact)>
			<cfset Valid_Mcodigo = getValidMcodigo(query.CodigoMoneda)>
			<cfset Valid_FechaDocumento = getValidFechaDocumento(query.FechaDocumento)>
			<cfset Valid_FechaVencimiento = getValidFechaVencimiento(query.FechaDocumento,query.FechaVencimiento,query.DiasVencimiento)>
			<cfset Valid_TipoCambio = getValidTipoCambio(Valid_Mcodigo,Valid_FechaDocumento)>
			<cfset Valid_Referencia = getValidReferencia(query.VoucherNo)>		
			<cfset Valid_Rcodigo = getValidRcodigo(query.CodigoRetencion)>
			<cfset Valid_Ocodigo = getValidOcodigo(query.CodigoOficina)>
			<cfset Valid_Ccodigo = getValidCcodigo(query.CodigoConceptoServicio)>
			<cfset Valid_Ccuenta = getValidCcuenta(Valid_Modulo,Valid_SNcodigo.SNcodigo,Valid_Ccodigo,query.CuentaFinanciera)>
			<cfset Valid_Estimacion = (iif(query.Facturado eq "S" or query.Facturado eq "1",DE("N"),DE("S")) EQ "S")>
			<cfif Valid_Estimacion>
				<!--- Estimación CREATE TABLE #INTARC# --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#GvarConexion#" method="CreaIntarc" returnvariable="INTARC"/>
				<!--- Para no repetir código en los asientos --->
				<cf_dbtemp name="INTARCDIFF" returnvariable="INTARCDIFF" datasource="#GvarConexion#">
					<cf_dbtempcol name="INTTIP"   type="char(1)"      mandatory="yes">
					<cf_dbtempcol name="INTDES"   type="varchar(80)"  mandatory="yes">
					<cf_dbtempcol name="Ccuenta"  type="numeric"      mandatory="yes">
				</cf_dbtemp>
				<!--- Obtiene Periodo Mes de Auxiliares --->
				<cfset Valid_Periodo = getValidPeriodoAuxiliares()>
				<cfset Valid_Mes = getValidMesAuxiliares()>
				<cfset Valid_Origen = iif(Valid_Modulo EQ "CC",DE("CCFC"),DE("CPFC"))>
			</cfif>
			<!--Inicia Transacción --->
			<cftransaction>
				<cfif Valid_Modulo EQ "CC">
					<!--- Variables Validadas Exclusivase de Cuentas por Cobrar --->
					<cfset Valid_CCTcodigo = getValidCCTcodigo(query.CodigoTransacion)>
					<cfset Valid_EDdocumento = getValidCCEDdocumento(query.Documento)>
					<cfif Not Valid_Estimacion>
						<!--- Inserta Documento en Cuentas por Cobrar --->
						<cfquery name="rsInsert" datasource="#GvarConexion#">
							insert into EDocumentosCxC( 
								Ecodigo, Ocodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio, Icodigo, Ccuenta, Rcodigo, 
								EDdescuento, EDporcdesc, EDimpuesto, EDtotal, EDfecha, EDtref, EDdocref, EDusuario, EDselect, EDvencimiento, 
								Interfaz, EDreferencia, DEidVendedor, DEidCobrador, id_direccionFact, id_direccionEnvio, CFid, DEdiasVencimiento, 
								DEordenCompra, DEnumReclamo, DEobservacion, DEdiasMoratorio, BMUsucodigo )
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Ocodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">, 
								
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_SNcodigo.SNcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Mcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_TipoCambio#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Ccuenta#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Rcodigo#" null="#len(Valid_Rcodigo) eq 0#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
								<cfqueryparam cfsqltype="cf_sql_float" value="0.00">, 
								
								<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">, 
								
								<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#GvarUsuario#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaVencimiento#">, 
								
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Referencia#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_SNcodigo.id_direccion_fact#" null="#Valid_SNcodigo.id_direccion_fact eq 0#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_SNcodigo.id_direccion_envio#" null="#Valid_SNcodigo.id_direccion_envio eq 0#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#query.DiasVencimiento#" null="#len(query.DiasVencimiento) eq 0#">, 
								
								<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
								
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">
							)
							<cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion="false">
						</cfquery>
						<cf_dbidentity2 datasource="#GvarConexion#" verificar_transaccion="false" name="rsInsert">
					</cfif><!--- <cfif Not Valid_Estimacion> --->
				<cfelse>
					<!--- Variables Validadas Exclusivase de Cuentas por Pagar --->
					<cfset Valid_CPTcodigo = getValidCPTcodigo(query.CodigoTransacion)>
					<cfset Valid_EDdocumento = getValidCPEDdocumento(query.Documento)>
					<cfif Not Valid_Estimacion>
						<!--- Inserta Documento en Cuentas por Pagar --->
						<cfquery name="rsInsert" datasource="#GvarConexion#">
							insert into EDocumentosCxP(	
								Ecodigo, CPTcodigo, EDdocumento, Mcodigo, SNcodigo, Icodigo, Ocodigo, Ccuenta, Rcodigo, CFid, id_direccion, 
								EDtipocambio, EDimpuesto, EDporcdescuento, EDdescuento, EDtotal, EDfecha, EDusuario, EDdocref, EDselect, Interfaz, 
								EDvencimiento, EDfechaarribo, EDreferencia, BMUsucodigo )
							values(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CPTcodigo.CPTcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Mcodigo#">, 
								
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_SNcodigo.SNcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Ocodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Ccuenta#">, 
								
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Rcodigo#" null="#len(Valid_Rcodigo) eq 0#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_SNcodigo.id_direccion_fact#" null="#Valid_SNcodigo.id_direccion_fact eq 0#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_TipoCambio#">, 
								
								<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
								<cfqueryparam cfsqltype="cf_sql_float" value="0.00">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
								
								<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#GvarUsuario#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
								
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaVencimiento#">, 
								<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Referencia#">, 
								
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">
							)
							<cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion="false">
						</cfquery>
						<cf_dbidentity2 datasource="#GvarConexion#" verificar_transaccion="false" name="rsInsert">
					</cfif><!--- <cfif Not Valid_Estimacion> --->
				</cfif>
				<!--- Procesamiento de Detalles de la Interfaz 10 --->
				<!--- NOTA: A PARTIR DE ESTE PUNTO ITERA POR TODOS LOS DETALLES DEL DOCUMENTO --->
				<cfoutput>
					<!--- Variables Validadas de los Detalles de Cuentas por Cobrar y Cuentas por Pagar --->
					<cfset Valid_TipoItem = getValidTipoItem(query.TipoItem)>
					<cfset Valid_Descripcion = "">
					<cfif Valid_TipoItem EQ "A">
						<cfset Valid_Aid = getValidAid(query.CodigoItem)>
						<cfset Valid_Descripcion = Valid_Aid.Adescripcion>
						<cfset Valid_Cid.Cid = "">
						<cfset Valid_AlmAid = getValidAlmAid(query.CodigoAlmacen)>
					<cfelse>
						<cfset Valid_Aid.Aid = "">
						<cfset Valid_AlmAid = "">
						<cfset Valid_Cid = getValidCid(query.CodigoItem)>
						<cfset Valid_Descripcion = Valid_Cid.Cdescripcion>
					</cfif>
					<cfset Valid_CFid = getValidCFid(query.CentroFuncional)>
					<cfset Valid_Dcodigo = getValidDcodigo(query.CodigoDepartamento,Valid_CFid)>
					<!--- Manejo de Montos Impuestos Descuentos --->
					<cfset Valid_ImporteDescuento = 0 >
					<cfif len(trim(query.ImporteDescuento)) gt 0 and query.ImporteDescuento gt 0>
						<cfset Valid_ImporteDescuento = query.ImporteDescuento >
					</cfif>
					<cfset Valid_CantidadTotal = 0 >
					<cfif len(trim(query.CantidadTotal)) gt 0 and query.CantidadTotal gt 0>
						<cfset Valid_CantidadTotal = query.CantidadTotal >
					</cfif>
					<cfset Valid_PrecioUnitario = 0 >
					<cfif len(trim(query.PrecioUnitario)) gt 0 and query.PrecioUnitario gt 0>
						<cfset Valid_PrecioUnitario = query.PrecioUnitario >
					</cfif>
					<cfset Valid_ImporteImpuesto = 0 >
					<cfif len(trim(query.ImporteImpuesto)) gt 0 and query.ImporteImpuesto gt 0>
						<cfset Valid_ImporteImpuesto = query.ImporteImpuesto >
					</cfif>
					<cfset Valid_ImporteTotal = 0>
					<cfif len(trim(query.PrecioTotal)) gt 0 and query.PrecioTotal gt 0>
						<cfset Valid_ImporteTotal = query.PrecioTotal >
					<cfelseif (Valid_CantidadTotal * Valid_PrecioUnitario) GT 0.00>
						<cfset Valid_ImporteTotal = (Valid_CantidadTotal * Valid_PrecioUnitario) - Valid_ImporteDescuento >
					</cfif>
					<cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,Valid_ImporteImpuesto,Valid_ImporteTotal)>
					<cfif len(trim(Valid_Icodigo))>
						<cfquery name="queryImpuesto" datasource="#GvarConexion#">
							select coalesce(Iporcentaje,0) as Iporcentaje
							from Impuestos
							where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Valid_Icodigo)#">
							  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
						</cfquery> 
						<cfset Valid_ImporteImpuesto =  (Valid_ImporteTotal*queryImpuesto.Iporcentaje)/100 >
					</cfif>
					<cfif Valid_ImporteDescuento GT 0>
						<cfset Valid_PorcentajeDescuento = (Valid_ImporteTotal+Valid_ImporteDescuento) / Valid_ImporteDescuento>
					<cfelse>
						<cfset Valid_PorcentajeDescuento = 0>
					</cfif>
					<cfset Valid_Ucodigo = getValidUcodigo(query.CodigoUnidadMedida)>
					<cfif Valid_Modulo EQ "CC">
						<cfif len(trim(query.CuentaFinancieraDet))>
							<cfset Valid_DCcuenta = getValid_DCcuenta(query.CuentaFinancieraDet)>
						<cfelseif GvarCuentaManual or Valid_CFid LT 0>
							<!--- Esta sección aún es específica para PMI --->
							<cfif Valid_TipoItem EQ "A">
								<cfif Valid_CCTcodigo.CCTafectacostoventas EQ 1>
									<cfset Valid_DCcuenta = obtieneCuentaCostoArticulobyModulo( Valid_Aid.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo, Valid_TipoItem) >
								<cfelse>
									<cfset Valid_DCcuenta = obtieneCuentaArticulo( Valid_Aid.Aid, Valid_AlmAid) >
								</cfif>
							<cfelse>
								<cfset Valid_DCcuenta = obtieneCuentaCostoConcepto( Valid_Cid.Cid, Valid_Cid.Ccodigo, Valid_SNcodigo.SNcodigo, Valid_TipoItem) >
							</cfif>
						<cfelse>
							<cfinvoke returnvariable="Valid_DCcuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
							   Oorigen = "CCFC"
							   Ecodigo = "#GvarEcodigo#"
							   Conexion = "#GvarConexion#"
							   SNegocios = "#Valid_SNcodigo.SNcodigo#"
							   Oficinas = "#Valid_Ocodigo#"
							   Monedas =  "#Valid_Mcodigo#"
							   Almacen = "#Valid_AlmAid#"
							   Articulos = "#Valid_Aid.Aid#"
							   Conceptos = "#Valid_Cid.Cid#"
							   CConceptos = "#Valid_Cid.Cid#"
							   Clasificaciones = ""
							   CCTransacciones = "#Valid_CCTcodigo.CCTcodigo#"
							   CFuncional = "#Valid_CFid#"/> 
						</cfif>
						<cfif Not Valid_Estimacion>
							<!--- Insertar Detalle de Documento de Cuentas Por Cobrar --->
							<cfquery datasource="#GvarConexion#">
								insert DDocumentosCxC (EDid, Aid, Cid, Alm_Aid, 
														Ccuenta, Ecodigo, DDdescripcion, DDdescalterna, Dcodigo, 
														DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, 
														DDtipo, Icodigo, CFid, BMUsucodigo)
								values (
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
									<cfif Valid_TipoItem EQ "A">
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">, 
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Cid.Cid#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
									</cfif>
									
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
									
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Dcodigo#" null="#Valid_Dcodigo LT 0#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_CantidadTotal#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PrecioUnitario#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteDescuento#">, 
									
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PorcentajeDescuento#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_TipoItem#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Icodigo#">, 
									
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_CFid#" null="#Valid_CFid LT 0#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">
								)						
							</cfquery>
							<cfquery datasource="#GvarConexion#">
								update EDocumentosCxC
								set EDdescuento = 0.00,
									EDporcdesc = 0.00,
									EDimpuesto = EDimpuesto + <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteImpuesto#">, 
									EDtotal = EDtotal + <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal+Valid_ImporteImpuesto#">
								where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">
								  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
							</cfquery>
						<cfelse>
							<!--- Estimación de CC INSERT INTO #INTARC# --->
							<cfquery datasource="#GvarConexion#">
								DELETE #INTARCDIFF#
							</cfquery>
							<cfquery datasource="#GvarConexion#">
								INSERT #INTARCDIFF# ( INTTIP, INTDES, Ccuenta )
								SELECT <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTtipo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="CxP: de #Valid_Descripcion#.">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Ccuenta#">
								UNION
								SELECT <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTtipoinverso#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="Estimación de #Valid_Descripcion#.">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">
							</cfquery>
							<cfquery datasource="#GvarConexion#">
								INSERT #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
								SELECT	<cfqueryparam cfsqltype="cf_sql_char" value="CPFC">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTcodigo#">, 
										round(<cfqueryparam cfsqltype="cf_sql_money" value="#(Valid_ImporteTotal+Valid_ImporteImpuesto)*Valid_TipoCambio#">,2), 
										INTTIP, 
										INTDES, 
										<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
										round(<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_TipoCambio#">,2), 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Periodo#">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Mes#">, 
										Ccuenta, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Mcodigo#">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Ocodigo#">, 
										round(<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal+Valid_ImporteImpuesto#">,2)
								FROM #INTARCDIFF#
							</cfquery>							
						</cfif><!--- <cfif Not Valid_Estimacion> --->
					<cfelse>
						<cfif len(trim(query.CuentaFinancieraDet))>
							<cfset Valid_DCcuenta = getValid_DCcuenta(query.CuentaFinancieraDet)>
						<cfelseif GvarCuentaManual or Valid_CFid LT 0>
							<cfif Valid_TipoItem EQ "A">
								<cfif Valid_CPTcodigo.CPTafectacostoventas EQ 1>
									<cfset Valid_DCcuenta = obtieneCuentaCostoArticulobyModulo( Valid_Aid.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo, Valid_TipoItem) >
								<cfelse>
									<cfset Valid_DCcuenta = obtieneCuentaArticulo( Valid_Aid.Aid, Valid_AlmAid) >
								</cfif>
							<cfelse>
								<cfset Valid_DCcuenta = obtieneCuentaCostoConcepto( Valid_Cid.Cid, Valid_Cid.Ccodigo, Valid_SNcodigo.SNcodigo, Valid_TipoItem) >
							</cfif>
						<cfelse>
							<cfinvoke returnvariable="Valid_DCcuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
							   Oorigen = "CPFC"
							   Ecodigo = "#GvarEcodigo#"
							   Conexion = "#GvarConexion#"
							   SNegocios = "#Valid_SNcodigo.SNcodigo#"
							   Oficinas = "#Valid_Ocodigo#"
							   Monedas =  "#Valid_Mcodigo#"
							   Almacen = "#Valid_AlmAid#"
							   Articulos = "#Valid_Aid.Aid#"
							   Conceptos = "#Valid_Cid.Cid#"
							   CConceptos = "#Valid_Cid.Cid#"
							   Clasificaciones = ""
							   CCTransacciones = "#Valid_CPTcodigo.CPTcodigo#"
							   CFuncional = "#Valid_CFid#"/>
						</cfif>
						<cfif Not Valid_Estimacion>
							<!--- Insertar Detalle de Documento de Cuentas Por Pagar --->
							<cfquery datasource="#GvarConexion#">
								insert DDocumentosCxP (IDdocumento, Aid, Cid, Alm_Aid, Ccuenta, Ecodigo, DDdescripcion, DDdescalterna, Dcodigo, DDcantidad, 
												DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Icodigo, Ucodigo, CFid, DDobservaciones, BMUsucodigo, 
												DOlinea, DDtransito, DDembarque, DDfembarque)
								values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">, 
								<cfif Valid_TipoItem EQ "A">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">, 
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Cid.Cid#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								</cfif>
								
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
								
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Dcodigo#" null="#Valid_Dcodigo LT 0#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_CantidadTotal#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PrecioUnitario#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteDescuento#">, 
								
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PorcentajeDescuento#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_TipoItem#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Icodigo#">, 
								
								<cfif len(trim(Valid_Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Ucodigo#"><cfelse>null</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_CFid#" null="#Valid_CFid LT 0#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">, 
								 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								<cfif Valid_TipoItem EQ "A" and len(trim(query.CodEmbarque))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="1">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#trim(query.CodEmbarque)#">, 
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#query.FechaBOL#">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="0" null="yes">, 
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" null="yes">
								</cfif>						
								)
							</cfquery>
							<cfquery datasource="#GvarConexion#">
								update EDocumentosCxP
								set EDdescuento = 0.00, 
									EDporcdescuento = 0.00, 
									EDimpuesto = EDimpuesto + <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteImpuesto#">, 
									EDtotal = EDtotal + <cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal+Valid_ImporteImpuesto#"> 
								where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">
								  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
							</cfquery>
						<cfelse>
							<!--- Estimación de CP INSERT INTO #INTARC# --->
							<cfquery datasource="#GvarConexion#">
								DELETE #INTARCDIFF#
							</cfquery>
							<cfquery datasource="#GvarConexion#">
								INSERT #INTARCDIFF# ( INTTIP, INTDES, Ccuenta )
								SELECT <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CPTcodigo.CPTtipo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="Estimación de #Valid_Descripcion#.">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Ccuenta#">
								UNION
								SELECT <cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CPTcodigo.CPTtipoinverso#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="Estimación de #Valid_Descripcion#.">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">
							</cfquery>
							<cfquery datasource="#GvarConexion#">
								INSERT #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
								SELECT	<cfqueryparam cfsqltype="cf_sql_char" value="CPFC">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CPTcodigo.CPTcodigo#">, 
										round(<cfqueryparam cfsqltype="cf_sql_money" value="#(Valid_ImporteTotal+Valid_ImporteImpuesto)*Valid_TipoCambio#">,2), 
										INTTIP, 
										INTDES, 
										<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
										round(<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_TipoCambio#">,2), 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Periodo#">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Mes#">, 
										Ccuenta, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Mcodigo#">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Ocodigo#">, 
										round(<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal+Valid_ImporteImpuesto#">,2)
								FROM #INTARCDIFF#
							</cfquery>
						</cfif><!--- <cfif Not Valid_Estimacion> --->
					</cfif>
				</cfoutput>
				<!--- Actualiza Encabezado 
				<cfset actualizarEncabezado(Valid_Modulo,rsInsert.identity)>--->
				<!--- Estimación GeneraAsiento --->
				<cfif Valid_Estimacion>
					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#GvarConexion#" method="GeneraAsiento" returnvariable="IDcontable" 
							Ecodigo="#GvarEcodigo#" Usuario="#GvarUsucodigo#" Oorigen="#Valid_Origen#" Eperiodo="#Valid_Periodo#" Emes="#Valid_Mes#" 
							Efecha="#CreateDate(Valid_Periodo, Valid_Mes, 1)#" Edescripcion="Estimación de #Left(Valid_Modulo,1)#x#Right(Valid_Modulo,1)#: #Valid_EDdocumento#." 
							Edocbase="#Valid_EDdocumento#"/>
					<cfquery datasource="#GvarConexion#">
						update EContables 
						set ECreversible = 1
						where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
					</cfquery>
				</cfif><!--- <cfif Valid_Estimacion> --->
				<!--- Cierra la Transacción --->
				</cftransaction>
				<!--- Aplicar Documento --->
				<cfif Not Valid_Estimacion>
					<cfset aplicaDocumento(Valid_Modulo,rsInsert.identity)>
				</cfif><!--- <cfif Not Valid_Estimacion> --->
		</cfoutput>
		<cfreturn "OK">
	</cffunction>
	
	<!---
		Metodo: 
			getValidEcodigoSDC
		Resultado:
			Devuelve el codigo asociado al codigo de Empresa del portal dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction name="getValidEcodigoSDC" access="private" returntype="numeric">
		<cfargument name="EcodigoSDC" required="true" type="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select Ecodigo as EcodigoSDC
			from Empresa
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
			  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif not query.recordcount>
			<cfthrow message="Error en Interfaz 10. EcodigoSDC es inválido, El código de Empresa SDC debe coincidir con el código de empresa SDC que invoca la interfaz. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.EcodigoSDC>
	</cffunction>
	
	<!---
		Metodo: 
			getValidModulo
		Resultado:
			Devuelve el codigo asociado al codigo de modulo dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction name="getValidModulo" access="private" returntype="string">
		<cfargument name="Modulo" required="true" type="string">
		<!--- Ya está validado por regla en la BD --->
		<cfreturn Trim(Arguments.Modulo)>
	</cffunction>
	
	<!---
		Metodo: 
			getValidSNcodigo
		Resultado:
			Devuelve el id asociado al codigo de socio de negocios dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	
	<cffunction access="private" name="getValidSNcodigo" output="true" returntype="query">
		<cfargument name="NumeroSocio" required="yes" type="string">
		<cfargument name="CodigoDireccionEnvio" required="yes" type="string">
		<cfargument name="CodigoDireccionFact" required="yes" type="string">
		<cfset var Lvar_SNid = 0>
		<cfset var Lvar_SNcodigo = 0>
		<cfset var Lvar_id_direccion_envio = 0>
		<cfset var Lvar_id_direccion_fact = 0>
		<!--- 	Consulta Dirección de Envío 
				Cuendo Viene la Dirección de Envío, se toma el Socio de la Dirección de Envío como el Socio de Negocios, 
				omitiendo el valor del Argumento NumeroSocio.
		--->
		<cfif len(trim(Arguments.CodigoDireccionEnvio))>
			<!--- Busca la Direccion por SNcodigoext  --->
			<cfquery name="query1" datasource="#GvarConexion#">
				select SNid, SNcodigo, id_direccion
				from SNDirecciones
				where upper(rtrim(SNcodigoext)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionEnvio))#">
				and SNDenvio = 1
			</cfquery>
			<cfif query1.recordcount eq 0>
				<cfquery name="query1" datasource="#GvarConexion#">
					select SNid, SNcodigo, id_direccion
					from SNDirecciones
					where upper(rtrim(SNDcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionEnvio))#">
					and SNDenvio = 1
				</cfquery>
			</cfif>
			<cfif query1.recordcount gt 0>
				<cfset Lvar_SNid = query1.SNid>
				<cfset Lvar_SNcodigo = query1.SNcodigo>
				<cfset Lvar_id_direccion_envio = query1.id_direccion>
			</cfif>
		</cfif>
		<!--- 	Consulta Dirección de Facturación
				Cuendo Viene la Dirección de Facturación, se toma el Socio de la Dirección de Facturación como el Socio de Negocios, 
				omitiendo el valor del Argumento NumeroSocio, SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío.
		--->
		<cfif len(trim(Arguments.CodigoDireccionFact))>
			<!--- Busca la Direccion por SNcodigoext  --->
			<cfquery name="query2" datasource="#GvarConexion#">
				select SNid, SNcodigo, id_direccion
				from SNDirecciones
				where upper(rtrim(SNcodigoext)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionFact))#">
				and SNDfacturacion = 1
			</cfquery>
			<cfif query2.recordcount eq 0>
				<cfquery name="query2" datasource="#GvarConexion#">
					select SNid, SNcodigo, id_direccion
					from SNDirecciones
					where upper(rtrim(SNDcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CodigoDireccionFact))#">
					and SNDfacturacion = 1
				</cfquery>
			</cfif>
			<cfif query2.recordcount gt 0>
				<cfif Lvar_SNid eq 0>
					<cfset Lvar_SNid = query2.SNid>
					<cfset Lvar_SNcodigo = query2.SNcodigo>
				</cfif>
				<cfset Lvar_id_direccion_fact = query2.id_direccion>
			</cfif>
		</cfif>
		<!--- 	Consulta Socio de Negocios 
				SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío, Ni por el de Facturación.
		--->
		<cfif Lvar_SNid eq 0 and len(trim(NumeroSocio)) gt 0>
			<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
				select SNid,SNcodigo,id_direccion
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
			</cfquery>
			<cfif query3.recordcount eq 0>
				<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
					select SNid,SNcodigo,id_direccion
					from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
				</cfquery>
			</cfif>
			<cfif query3.recordcount gt 0>
				<cfset Lvar_SNid = query3.SNid>
				<cfset Lvar_SNcodigo = query3.SNcodigo>
				<!--- Valida que las direcciones existan en SNDirecciones --->
				<cfquery name="query4" datasource="#GvarConexion#">
					select id_direccion
					from SNDirecciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#query3.id_direccion#">
					and SNDenvio = 1
				</cfquery>
				<cfquery name="query5" datasource="#GvarConexion#">
					select id_direccion
					from SNDirecciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#query3.id_direccion#">
					and SNDfacturacion = 1
				</cfquery>
				<cfif query4.recordcount gt 0>
					<cfset Lvar_id_direccion_envio = query4.id_direccion>
				</cfif>
				<cfif query5.recordcount gt 0>
					<cfset Lvar_id_direccion_fact = query5.id_direccion>
				</cfif>
			</cfif>
		</cfif>
		<!--- Valida el Proceso --->
		<cfif Lvar_SNid lte 0 or len(trim(Lvar_SNcodigo)) lte 0>
			<cfthrow message="Error en Interfaz 10. NumeroSocio es inválido, La Dirección de Envío, Dirección de Facturación y El Numero de Socio no corresponden con ningún Socio de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfquery name="Lvar_Query" datasource="#GvarConexion#">
			select #Lvar_SNid# as SNid,
				#Lvar_SNcodigo# as SNcodigo,
				#Lvar_id_direccion_envio# as id_direccion_envio,
				#Lvar_id_direccion_fact# as id_direccion_fact
			from dual
		</cfquery>
		<cfreturn Lvar_Query>
	</cffunction>
		
	<!---
		Metodo: 
			getValidCCTcodigo
		Resultado:
			Devuelve el id asociado al codigo de transaccion de cc dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidCCTcodigo" output="false" returntype="query">
		<cfargument name="CCTvalor" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select CCTcodigo, CCTafectacostoventas, CCTtipo, case CCTtipo when 'C' then 'D' else 'C' end as CCTtipoinverso
			from CCTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(CCTcodigoext) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTvalor)#">
		</cfquery>
		<cfif not query.recordcount>
			<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
				select CCTcodigo, CCTafectacostoventas, CCTtipo, case CCTtipo when 'C' then 'D' else 'C' end as CCTtipoinverso
			from CCTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTvalor)#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0>
			<cfthrow message="Error en Interfaz 10. CodigoTransaccion es inválido, El Código de Transacción no corresponde con ninguna Transacción de la Empresa #GvarEnombre# para el Módulo CC. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>

	<!---
		Metodo: 
			getValidCPTcodigo
		Resultado:
			Devuelve el id asociado al codigo de transaccion de cp dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidCPTcodigo" output="false" returntype="query">
		<cfargument name="CPTvalor" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select CPTcodigo, CPTafectacostoventas, CPTtipo, case CPTtipo when 'C' then 'D' else 'C' end as CPTtipoinverso
			from CPTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(CPTcodigoext) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTvalor)#">
		</cfquery>
		<cfif not query.recordcount>
			<cfquery name="query" datasource="#GvarConexion#">
				select CPTcodigo, CPTafectacostoventas, CPTtipo, case CPTtipo when 'C' then 'D' else 'C' end as CPTtipoinverso
				from CPTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and rtrim(CPTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTvalor)#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0>
			<cfthrow message="Error en Interfaz 10. CodigoTransaccion es inválido, El Código de Transacción no corresponde con ninguna Transacción de la Empresa #GvarEnombre# para el Módulo CP. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>	
	
	
	<!---
		Metodo: 
			getValidCCEDdocumento
		Resultado:
			Devuelve documento dado por la interfaz validado.
			Si se encuentra un registro para el documento aborta el proceso.
	--->
	<cffunction access="private" name="getValidCCEDdocumento" output="false" returntype="string">
		<cfargument name="EDdocumento" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select 1 
			from EDocumentosCxC
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(EDdocumento) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
		</cfquery>
		<cfif query.recordcount GT 0>
			<cfthrow message="Error en Interfaz 10. Documento es inválido, El Documento ya existe en la Empresa #GvarEnombre# en el Módulo CC. Proceso Cancelado!.">
		</cfif>
		<cfreturn Trim(Arguments.EDdocumento)>
	</cffunction>
	
	<!---
		Metodo: 
			getValidCPEDdocumento
		Resultado:
			Devuelve documento dado por la interfaz validado.
			Si se encuentra un registro para el documento aborta el proceso.
	--->
	<cffunction access="private" name="getValidCPEDdocumento" output="false" returntype="string">
		<cfargument name="EDdocumento" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select 1 
			from EDocumentosCxP
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(EDdocumento) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
		</cfquery>
		<cfif query.recordcount GT 0>
			<cfthrow message="Error en Interfaz 10. Documento es inválido, El Documento ya existe en la Empresa #GvarEnombre# en el Módulo CP. Proceso Cancelado!.">
		</cfif>
		<cfreturn Trim(Arguments.EDdocumento)>
	</cffunction>

	<!---
		Metodo: 
			getValidMcodigo
		Resultado:
			Devuelve el id asociado al codigo Miso de la moneda dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidMcodigo" output="false" returntype="numeric">
		<cfargument name="miso" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 10. CodigoMoneda es inválido, El Código de la Moneda no corresponde con ninguna modeda en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.Mcodigo>
	</cffunction>
	
	<!---
		Metodo: 
			getValidFechaDocumento
		Resultado:
			Devuelve una Fecha de Documento Valida
	--->
	<cffunction access="private" name="getValidFechaDocumento" output="false" returntype="date">
		<cfargument name="Fecha" required="yes" type="date">
		<cfif Arguments.Fecha lt GvarMinFecha or Arguments.Fecha gt DateAdd('yyyy',99,GvarMinFecha)>
			<cfthrow message="Error en Interfaz 10. FechaDocumeno es inválido, La Fecha del Documento no es válida en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn Arguments.Fecha>
	</cffunction>
	
	<!---
		Metodo: 
			getValidFechaVencimiento
		Resultado:
			Devuelve una Fecha de Vencimiento Valida
	--->
	<cffunction access="private" name="getValidFechaVencimiento" output="false" returntype="date">
		<cfargument name="FechaDocumento" required="yes" type="date">
		<cfargument name="FechaVencimiento" required="yes" type="string">
		<cfargument name="DiasVencimiento" required="yes" type="numeric">
		<cfset var LvarFechaVencimiento = Arguments.FechaDocumento>
		<cfif Arguments.DiasVencimiento gt 0>
			<cfset LvarFechaVencimiento = DateAdd('d',Arguments.DiasVencimiento,Arguments.FechaDocumento)>
		<cfelseif isDate(Arguments.FechaVencimiento) and Arguments.FechaVencimiento gt Arguments.FechaDocumento>
			<cfset LvarFechaVencimiento = Arguments.FechaVencimiento>
		</cfif>
		<cfif LvarFechaVencimiento lt Arguments.FechaDocumento>
			<cfthrow message="Error en Interfaz 10. FechaVencimiento es inválido, La Fecha del Vencimiento debe ser mayor o igual que la Fecha de Documento. Proceso Cancelado!.">
		</cfif>
		<cfreturn LvarFechaVencimiento>
	</cffunction>
	
	<!---
		Metodo:
			getTipoCambio
		Resultado:
			Obtiene el Tipo de cambio de la moneda indicada en la fecha indicada,
			la moneda esperada es en codigo Miso4217
	--->
	<cffunction access="private" name="getValidTipoCambio" output="false" returntype="numeric">
		<cfargument name="Mcodigo" required="yes" type="numeric">
		<cfargument name="Fecha" required="no" type="string" default="#now()#">
		<cfset var retTC = 1>
		<cfquery name="rsMaxFecha" datasource="#GvarConexion#">
			select max(Hfecha) as maxFecha
			from Htipocambio
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
			and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		</cfquery>
		<cfif isdefined('rsMaxFecha') and rsMaxFecha.recordCount GT 0>
			<cfquery name="rsTC" datasource="#GvarConexion#">
				select TCcompra
				from Htipocambio
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
				and Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#rsMaxFecha.maxFecha#">
			</cfquery>
		</cfif>
		<cfif isdefined('rsTC') and rsTC.recordCount GT 0 and rsTC.TCcompra GT 0>
			<cfset retTC = rsTC.TCcompra>
		</cfif>
		<cfreturn retTC>
	</cffunction>
	
		<!---
		Metodo: 
			getValidReferencia
		Resultado:
			Devuelve una Referencia Valida
	--->
	<cffunction access="private" name="getValidReferencia" output="false" returntype="string">
		<cfargument name="Referencia" required="yes" type="string">
		<cfreturn Mid(Referencia,1,20)>
	</cffunction>
	
	<!---
		Metodo: 
			getValidRCodigo
		Resultado:
			Devuelve true si el id asociado al codigo de Retencion dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="getValidRCodigo" output="false" returntype="string">
		<cfargument name="Rcodigo" required="yes" type="string">
		<cfset var LvarRcodigo = "">
		<cfif len(Arguments.Rcodigo)>
			<cfquery name="query" datasource="#GvarConexion#">
				select Rcodigo
				from Retenciones
				where Rcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
			<cfif query.recordcount gt 0>
				<cfset LvarRcodigo = query.Rcodigo>
			<cfelse>
				<cfthrow message="Error en Interfaz 10. CodigoRetencion es inválido, El Código de Rentención no corresponde con ninguna Retención de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
		</cfif>
		<cfreturn LvarRcodigo>
	</cffunction>

	<!---
		Metodo: 
			getValidOCodigo
		Resultado:
			Devuelve el id asociado al codigo de Oficina dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidOCodigo" output="false" returntype="numeric">
		<cfargument name="Oficodigo" required="yes" type="string">
		<cfif len(Arguments.Oficodigo)>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(Ocodigo) as Ocodigo
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oficodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(Ocodigo) as Ocodigo
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0 or len(trim(query.Ocodigo)) eq 0>
			<cfthrow message="Error en Interfaz 10. CodigoOficina es inválido, El Código de Oficina no corresponde con ninguna Oficina de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.Ocodigo>
	</cffunction>

	<!---
		Metodo: 
			getValidCcodigo
		Resultado:
			Devuelve el Cconcepto Válido
	--->
	<cffunction access="private" name="getValidCcodigo" output="false" returntype="string">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfset var LvarCcodigo = "">
		<cfif len(Arguments.Ccodigo) gt 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select Ccodigo
				from Conceptos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				and upper(rtrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.Ccodigo))#">
			</cfquery>
			<cfif query.recordcount and len(trim(query.Ccodigo))>
				<cfset LvarCcodigo = trim(query.Ccodigo)>
			<cfelse>
				<cfthrow message="Error en Interfaz 10. CodigoConceptoServicio es inválido, El Código de Concepto de Servicio no corresponde con ningún Concepto de Servicio de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
		</cfif>
		<cfreturn LvarCcodigo>
	</cffunction>
	
	<!---
	Metodo:
		getValidCcuenta
	Resultado:
		0.	Se busca la máscara asociada a la cuenta dada en CFinanciera, esta es la máscara del Socio de Negocios.
		1.	Se toma la máscara del Socio de Negocios XXXX-XXXX-XXXX-XXX,
		2.	Si existe asociado al documento un concepto de servicio, y el concepto de servicio tiene complemento de cuenta, continua, si no termina.
		3.	Se sustituye el ultimo nivel con el complemento de cuenta del concepto de servicio, XXXX-XXXX-XXXX-123
	--->
	<cffunction access="private" name="getValidCcuenta" output="false" returntype="numeric">
		<cfargument name="Modulo" required="yes" type="string">
		<cfargument name="SNcodigo" required="yes" type="numeric">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="CFormato" required="yes" type="string">
		<cfset var LvarCcuenta = 0>
		<cfif len(trim(Arguments.CFormato)) gt 0>
			<!--- Lo trata de Obtener validando el formato --->
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_Cmayor" value="#Left(Arguments.CFormato,4)#"/>							
				<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Arguments.CFormato,6,100)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
				<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
			</cfinvoke>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfthrow message="Error en Interfaz 10. Cuenta #Arguments.CFormato#: #LvarERROR#. Proceso Cancelado!">
			</cfif>
			<cfquery name="rsCuenta" datasource="#GvarConexion#">
				select Ccuenta
				from CFinanciera
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CFormato#">
			</cfquery>
			<cfif len(trim(rsCuenta.Ccuenta))>
				<cfset LvarCcuenta = rsCuenta.Ccuenta>
			<cfelse>
				<cfthrow message="Error en Interfaz 10. Cuenta #Arguments.CFormato#: Cuenta Inválida! para la empresa #Enombre#. Proceso Cancelado!">
			</cfif>
		<cfelse>
			<cfquery name="rsCuenta" datasource="#GvarConexion#">
				select SNcuentacxc, SNcuentacxp
				from SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			</cfquery>
			<cfif Arguments.Modulo EQ "CC">
				<cfif len(rsCuenta.SNcuentacxc) and rsCuenta.SNcuentacxc gt 0>
					<cfset LvarCcuenta = rsCuenta.SNcuentacxc>
				<cfelse>
					<cfthrow message="Error en Interfaz 10. El Socio de Negocios no tiene definida correctamente la cuenta de Cuentas por Cobrar. Proceso Cancelado!.">
				</cfif>
			<cfelse>
				<cfif len(rsCuenta.SNcuentacxp) and rsCuenta.SNcuentacxp gt 0>
					<cfset LvarCcuenta = rsCuenta.SNcuentacxp>
				<cfelse>
					<cfthrow message="Error en Interfaz 10. El Socio de Negocios no tiene definida correctamente la cuenta de Cuentas por Pagar. Proceso Cancelado!.">
				</cfif>
			</cfif>
			<cfif len(trim(Arguments.Ccodigo)) gt 0>
				<cfquery name="rsConceptos" datasource="#GvarConexion#">
					select cuentac
					from Conceptos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					and upper(rtrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.Ccodigo))#">
				</cfquery>
				<cfif len(trim(rsConceptos.cuentac))>
					<cfquery name="rsObtieneFormato" datasource="#GvarConexion#">
						select min(CFformato) as CFformato, min(Cmayor) as Cmayor
						from CFinanciera
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
						  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">
					</cfquery>
					<cfif (rsObtieneFormato.Cmayor EQ "1104" or rsObtieneFormato.Cmayor EQ "2103")> 
						<!--- El siguiente código esta fijo y de esta manera porque no se quizo afectar la funcionalidad propia de SIF,
						agregando la posibilidad de agregar comodines al Socio de Negocios, únicamente para utilzar esta funcionalidad
						en la presente interfaz --->
						<cfset LvarFormatoLevels = ListToArray(rsObtieneFormato.CFformato,'-')>
						<cfset LvarFormato = ''>
						<cfloop from="1" to="#ArrayLen(LvarFormatoLevels)-1#" index="i">
							<cfset LvarFormato = LvarFormato & iif(len(LvarFormato),DE('-'),DE('')) & LvarFormatoLevels[i]>
						</cfloop>
						<cfset LvarFormato = LvarFormato & iif(len(LvarFormato),DE('-'),DE('')) & rsConceptos.cuentac>
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
							<cfinvokeargument name="Lprm_Cmayor" value="#Left(LvarFormato,4)#"/>							
							<cfinvokeargument name="Lprm_Cdetalle" value="#mid(LvarFormato,6,100)#"/>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
							<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
							<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
						</cfinvoke>		
						<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
							<cfthrow message="Error en Interfaz 10. Cuenta #LvarFormato#: #LvarERROR#. Proceso Cancelado!">
						</cfif>
						<cfquery name="rsCuenta" datasource="#GvarConexion#">
							select Ccuenta
							from CFinanciera
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
							  and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarFormato#">
						</cfquery>
						<cfif len(trim(rsCuenta.Ccuenta))>
							<cfset LvarCcuenta = rsCuenta.Ccuenta>
						<cfelse>
							<cfthrow message="Error en Interfaz 10. Cuenta #LvarFormato#: Cuenta Inválida! para la empresa #Enombre#. Proceso Cancelado!">
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn LvarCcuenta>
	</cffunction>
	
	<!---
	Metodo:
		getValid_DCcuenta
	Resultado:
		0.	Se valída la máscara enviada por el usuario de la interfaz.
	--->
	<cffunction access="private" name="getValid_DCcuenta" output="false" returntype="query">
		<cfargument name="CFormato" required="yes" type="string">
		<cfset var LvarCcuenta = 0>
		<!--- Lo trata de Obtener validando el formato --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(Arguments.CFormato,4)#"/>							
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Arguments.CFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
			<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Error en Interfaz 10. Cuenta #Arguments.CFormato#: #LvarERROR#. Proceso Cancelado!">
		</cfif>
		<cfquery name="rsCuenta" datasource="#GvarConexion#">
			select CFcuenta, Ccuenta, CPcuenta, CFformato
			from CFinanciera
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CFormato#">
		</cfquery>
		<cfif len(trim(rsCuenta.Ccuenta))>
			<cfset LvarCcuenta = rsCuenta.Ccuenta>
		<cfelse>
			<cfthrow message="Error en Interfaz 10. Cuenta #Arguments.CFormato#: Cuenta Inválida! para la empresa #Enombre#. Proceso Cancelado!">
		</cfif>
		<cfreturn rsCuenta>
	</cffunction>
	<!---
		Metodo: 
			getValid_TipoItem
		Resultado:
			Devuelve el Tipo de Item Válidado, A=Articulo, S=Servicio.
	--->
	<cffunction name="getValidTipoItem" access="private" returntype="string">
		<cfargument name="TipoItem" required="true" type="string">
		<cfif Arguments.TipoItem neq "A" and Arguments.TipoItem neq "S">
			<cfthrow message="Error en Interfaz 10. TipoItem es Inválido, El Tipo de Ítem debe ser A=Articulo, S=Servicio. Proceso Cancelado!.">
		</cfif>
		<cfreturn Trim(Arguments.TipoItem)>
	</cffunction>
	
	<!---
		Metodo: 
			getValidAid
		Resultado:
			Devuelve el id asociado al codigo de articulo dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidAid" output="false" returntype="query">
		<cfargument name="CodigoItem" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Aid, Adescripcion
			from Articulos
			where Acodalterno = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoItem)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select Aid, Adescripcion
				from Articulos
				where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoItem)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount EQ 0>
			<cfthrow message="Error en Interfaz 10. CodigoItem es inválido, El Código de Item no corresponde con ningún Artículo válido en la Empresa #GvarEnombre#. Proceso Cancelado!">
		</cfif>
		<cfreturn query>
	</cffunction>

	<!---
		Metodo: 
			getValidCid
		Resultado:
			Devuelve el Id coresspondiente con el codigo de concepto dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidCid" output="false" returntype="query">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select Cid, Ccodigo, Cdescripcion
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			and upper(rtrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.Ccodigo))#">
		</cfquery>
		<cfif query.recordcount EQ 0>
			<cfthrow message="Error en Interfaz 10. CodigoItem es inválido, El Código de Item no corresponde con ningún Concepto de Servicio válido en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>

	<!---
		Metodo: 
			getValidCFid
		Resultado:
			Devuelve el Id coresspondiente con el código de Centro Funcional dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidCFid" output="false" returntype="numeric">
		<cfargument name="CFcodigo" required="yes" type="string">
		<cfif len(trim(Arguments.CFcodigo)) gt 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select CFid
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				and upper(rtrim(CFcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CFcodigo))#">
			</cfquery>
			<cfif query.recordcount EQ 0>
				<cfthrow message="Error en Interfaz 10. CentroFuncional es inválido, El Código de Centro Funcional no corresponde con ningún Centro Funcional de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			<cfelse>
				<cfset Lvar_ReturnCFid = query.CFid>
			</cfif>
		<cfelse>
			<cfset Lvar_ReturnCFid = -1>
		</cfif>
		<cfreturn Lvar_ReturnCFid>
	</cffunction>

	<!---
		Metodo: 
			getValidUcodigo
		Resultado:
			Devuelve true si el id asociado al codigo de Unidad dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="getValidUcodigo" output="false" returntype="string">
		<cfargument name="Ucodigo" required="yes" type="string">
		<cfset LvarUcodigo = "">
		<cfif len(trim(Arguments.Ucodigo))>
			<cfquery name="query" datasource="#GvarConexion#">
				select Ucodigo
				from Unidades
				where Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
			<cfif query.recordcount GT 0>
				<cfset LvarUcodigo = query.Ucodigo>
			<cfelse>
				<cfthrow message="Error en Interfaz 10. CodigoUnidadMedida es inválido, El Código de Unidad de Medida no corresponde con ninguna Unidad de Medida de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
		</cfif>
		<cfreturn LvarUcodigo>
	</cffunction>
	
	<!---
		Metodo: 
			getValidIcodigo
		Resultado
			1. Busca el Impuesto correspondiente con el Icodigo si este no está vacío.
			2. Si Icodigo está vacío Busca el Impuesto con iporcentaje 0 si MontoImpuesto es 0.
			3. Si MontoImpuesto es mayor que 0 busca el impuesto con el porcentaje correspondiente 
			con el Monto de Impuesto en Relacion con el Monto Total de la Línea.
			4. Si todos los campos están nulos o similar devuelve vacío, si alguno trae un valor válido 
			pero inexistente aborta el proceso.
	--->
	<cffunction access="private" name="getValidIcodigo" output="false" returntype="string">
		<cfargument name="Icodigo" required="yes" type="string">
		<cfargument name="ImporteImpuesto" required="yes" type="numeric">
		<cfargument name="ImporteTotal" required="yes" type="numeric">
		<cfset LvarIcodigo = "">
		<cfif len(trim(Arguments.Icodigo))>
			<cfquery name="query" datasource="#GvarConexion#">
				select Icodigo
				from Impuestos
				where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
			<cfif query.recordcount GT 0>
				<cfset LvarIcodigo = query.Icodigo>
			<cfelse>
				<cfthrow message="Error en Interfaz 10. CodigoImpuesto es inválido, El Código de Impuesto no corresponde con ningún Impuesto de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
		<cfelseif ImporteImpuesto GT 0>
			<cfset PorcentajeImpuesto = ImporteImpuesto / ImporteTotal * 100>
			<cfquery name="query" datasource="#GvarConexion#">
				select Icodigo
				from Impuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and Iporcentaje = <cfqueryparam cfsqltype="cf_sql_money" value="#PorcentajeImpuesto#">
			</cfquery>
			<cfif query.recordcount GT 0>
				<cfset LvarIcodigo = query.Icodigo>
			</cfif>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#">
				select Icodigo
				from Impuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and Iporcentaje = 0.00
			</cfquery>
			<cfif query.recordcount GT 0>
				<cfset LvarIcodigo = query.Icodigo>
			</cfif>
		</cfif>
		<cfreturn LvarIcodigo>
	</cffunction>

	<!---
		Metodo: 
			getValidAlmAid
		Resultado:
			Devuelve el id asociado al codigo de almacen dado por la interfaz.
			Si viene el Almacen lo valida y si no viene devuelve el primer almacen de la Tabla.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidAlmAid" output="false" returntype="numeric">
		<cfargument name="CodigoAlmacen" required="yes" type="string">
		<cfif len(trim(Arguments.CodigoAlmacen))>
			<cfquery name="query" datasource="#GvarConexion#">
				select Aid
				from Almacen
				where Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoAlmacen)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
				select Aid
				from Almacen
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount eq 0>
			<cfthrow message="Error en Interfaz 10. CodigoAlmacen es inválido, El Código de Almacén no corresponde con ningún Almacén de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.Aid>
	</cffunction>

	<!---
		Metodo: 
			getValidDcodigo
		Resultado:
			Devuelve el id asociado al codigo de departamento dado por la interfaz.
			Si viene el Departamento lo valida y si no viene devuelve el primer departamento de la Tabla.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidDcodigo" output="false" returntype="numeric">
		<cfargument name="CodigoDepartamento" required="yes" type="string">
		<cfargument name="CFid" required="yes" type="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select Dcodigo 
			from Departamentos
			where 1 = 2
		</cfquery>
		<cfif len(trim(Arguments.CodigoDepartamento))>
			<cfquery name="query" datasource="#GvarConexion#">
				select Dcodigo
				from Departamentos
				where Deptocodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoDepartamento)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount eq 0 and Arguments.CFid>
			<cfquery name="query" datasource="#GvarConexion#">
				select Dcodigo
				from CFuncional
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount eq 0>
			<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
				select min(Dcodigo) as Dcodigo
				from Departamentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount eq 0>
			<cfthrow message="Error en Interfaz 10. CodigoDepartamento es inválido, El Código de Departamento no corresponde con ningún Departamento de la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.Dcodigo>
	</cffunction>

	<!---
		Metodo: 
			getValidPeriodoAuxiliares
		Resultado:
			Devuelve el Periodo de Auxiliares.
	--->
	<cffunction access="private" name="getValidPeriodoAuxiliares" output="false" returntype="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#GvarConexion#"> as value
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				and Pcodigo = 50
				and Mcodigo = 'GN'
		</cfquery>
		<cfreturn query.value>
	</cffunction>

	<!---
		Metodo: 
			getValidMesAuxiliares
		Resultado:
			Devuelve el Periodo de Auxiliares.
	--->
	<cffunction access="private" name="getValidMesAuxiliares" output="false" returntype="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#GvarConexion#"> as value
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				and Pcodigo = 60
				and Mcodigo = 'GN'
		</cfquery>
		<cfreturn query.value>
	</cffunction>
		
	<!---
		Metodo: 
			actualizarEncabezadoCC
		Resultado:
			Hace calculos adicionales para el encabezado del Documento CxC.
	--->
	<cffunction access="private" name="actualizarEncabezadoCC" output="false" >
		<cfargument name="IDdocumento" 	   required="yes" type="string">
				
		<!--- Total del documento --->
		<cfquery name="queryTotal" datasource="#GvarConexion#">
			select sum(DDcantidad*DDpreciou) as total
			from DDocumentosCxC
			where EDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarTotal = 0 >
		<cfif queryTotal.recordcount gt 0 and len(trim(queryTotal.total))>
			<cfset LvarTotal = queryTotal.total >
		</cfif>

		<!--- Descuento total del documento --->
		<cfquery name="queryDescuento" datasource="#GvarConexion#">
			select sum(DDdesclinea) as descuento
			from DDocumentosCxC
			where EDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarDescuento = 0 >
		<cfif queryDescuento.recordcount gt 0 and len(trim(queryDescuento.descuento))>
			<cfset LvarDescuento = queryDescuento.descuento >
		</cfif>

		<!--- porcentaje de descuento --->
		<cfset LvarPorcentaje = (100*LvarDescuento)/LvarTotal >
		
		<!--- Total del Documento. Se basa en que las lineas ya tienen aplicado descuento e impuestos--->
		<cfquery name="queryTotalCalculado" datasource="#GvarConexion#">
			select sum(DDtotallinea) as total
			from DDocumentosCxC
			where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfset LvarTotalCalculado = 0 >
		<cfif queryTotalCalculado.recordcount gt 0 and len(trim(queryTotalCalculado.total))>
			<cfset LvarTotalCalculado = queryTotalCalculado.total >
		</cfif>
		
		<!--- Modifica el encabezado --->
		<cfquery datasource="#GvarConexion#">
			update EDocumentosCxC
			set EDdescuento = 0 <!---<cfqueryparam cfsqltype="cf_sql_money" value="#LvarDescuento#">--->,
				EDporcdesc = 0 <!---<cfqueryparam cfsqltype="cf_sql_float" value="#LvarPorcentaje#">--->,		
				EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalCalculado#">
			where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezadoCP
		Resultado:
			Hace calculos adicionales para el encabezado del Documento CxP.
	--->
	<cffunction access="private" name="actualizarEncabezadoCP" output="false" >
		<cfargument name="IDdocumento" 	   required="yes" type="string">

		<!--- Total del documento para calculo de descuento --->
		<cfquery name="queryTotal" datasource="#GvarConexion#">
			select sum(DDcantidad*DDpreciou) as total
			from DDocumentosCxP
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarTotal = 0 >
		<cfif queryTotal.recordcount gt 0 and len(trim(queryTotal.total))>
			<cfset LvarTotal = queryTotal.total >
		</cfif>

		<!--- Descuento total del documento --->
		<cfquery name="queryDescuento" datasource="#GvarConexion#">
			select sum(DDdesclinea) as descuento
			from DDocumentosCxP
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
		</cfquery>
		<cfset LvarDescuento = 0 >
		<cfif queryDescuento.recordcount gt 0 and len(trim(queryDescuento.descuento))>
			<cfset LvarDescuento = queryDescuento.descuento >
		</cfif>

		<!--- porcentaje de descuento --->
		<cfset LvarPorcentaje = (100*LvarDescuento)/LvarTotal >

		<!--- Total del Documento. Se basa en que las lineas ya tienen aplicado descuento e impuestos--->
		<cfquery name="queryTotalCalculado" datasource="#GvarConexion#">
			select sum(DDtotallinea) as total
			from DDocumentosCxP
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfset LvarTotalCalculado = 0 >
		<cfif queryTotalCalculado.recordcount gt 0 and len(trim(queryTotalCalculado.total))>
			<cfset LvarTotalCalculado = queryTotalCalculado.total >
		</cfif>

		<!--- Modifica el encabezado --->
		<cfquery datasource="#GvarConexion#">
			update EDocumentosCxP
			set EDdescuento = 0 <!---<cfqueryparam cfsqltype="cf_sql_money" value="#LvarDescuento#">--->,
				EDporcdescuento = 0 <!---<cfqueryparam cfsqltype="cf_sql_float" value="#LvarPorcentaje#">--->,
				EDtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarTotalCalculado#">
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDdocumento#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezado
		Resultado:
			Aplica el documento de Cxc o CxP generado.
	--->
	<cffunction access="public" name="actualizarEncabezado" output="false" >
		<cfargument name="Modulo" 		   required="yes" type="string">
		<cfargument name="IDdocumento" 	   required="yes" type="string">

		<cfif trim(arguments.modulo) eq 'CC'>
			<cfset actualizarEncabezadoCC(arguments.IDdocumento) >
		<cfelse>
			<cfset actualizarEncabezadoCP(arguments.IDdocumento) >
		</cfif>
	</cffunction>


	<!---
		Metodo: 
			aplicaDocumento
		Resultado:
			Aplica el documento de Cxc o CxP generado.
	--->
	<cffunction access="public" name="aplicaDocumento" output="false" >
		<cfargument name="Modulo" 		   required="yes" type="string">
		<cfargument name="IDdocumento" 	   required="yes" type="string">

		<cfif trim(arguments.modulo) eq 'CC'>
			<cfquery datasource="#GvarConexion#">
				exec CC_PosteoDocumentosCxC 
					@EDid = #arguments.IDdocumento#,
					@Ecodigo = #GvarEcodigo#,
					@usuario = '#GvarUsuario#',
					@debug = 'N'
			</cfquery>
		<cfelse>
			<cfquery datasource="#GvarConexion#">
				exec CP_PosteoDocumentosCxP 
					@IDdoc = #arguments.IDdocumento#,
					@Ecodigo = #GvarEcodigo#,
					@usuario = '#GvarUsuario#',
					@debug = 'N'
			</cfquery>
		</cfif>
	</cffunction>
	
	<!--- ************************************************************************************************************************************************
															FUNCIONES ESPECÍFICAS PARA PMI
	************************************************************************************************************************************************* --->
	
	<!---
		Metodo: 
			obtieneCuentaArticulo
		Resultado:
			Devuelve el id de cuenta contable asciado al Articulo/Almacen
	--->
	<cffunction access="private" name="obtieneCuentaArticulo" output="false" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">

		<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
			select c.CFcuenta, c.Ccuenta, c.CPcuenta, c.CFformato 
			from Existencias a 
				inner join IAContables b on a.IACcodigo = b.IACcodigo and a.Ecodigo = b.Ecodigo
				inner join CFinanciera c on b.IACtransito = c.Ccuenta and b.Ecodigo = c.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAid#">
			and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAlm_Aid#">
		</cfquery>
		
		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definida la cuenta contable para el artículo y el almacén. Proceso Cancelado!">
		</cfif>
		<cfreturn query>
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaCostoArticulobyModulo
		Resultado:
			Devuelve el id de cuenta contable de costo del Articulo 
	--->
	<cffunction access="private" name="obtieneCuentaCostoArticulobyModulo" output="false" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfargument name="LparamModulo"   required="yes" type="string">
		<!--- 1. Obtiene el Formato --->
		<cfquery name="query" datasource="#GvarConexion#">
			select <cfif LparamModulo EQ 'CC'>CformatoIngresos<cfelse>CformatoCompras</cfif> as Formato
			from Existencias a inner join IAContables b on a.IACcodigo = b.IACcodigo and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAid#">
			and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAlm_Aid#">
		</cfquery>
		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definida la contra cuenta contable para el artículo y el almacén. Proceso Cancelado!">
		</cfif>
		<!--- 2. Obtiene el complemento del Socio --->
		<cfquery name="rsSocio" datasource="#GvarConexion#">
			select cuentac
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamIDSocio#">
		</cfquery>
		<!--- 3.Aplica Máscara --->
		<cfset LvarFormato = query.Formato>
		<!--- <cfthrow message="Formato:#LvarFormato#, Socio:#rsSocio.cuentac#, AplicarMascara:#CGAplicarMascara(LvarFormato, rsSocio.cuentac)#"> --->
		<cfif len(trim(rsSocio.cuentac))>
			<cfset LvarFormato = CGAplicarMascara(LvarFormato, rsSocio.cuentac)>
		</cfif>
		<cfif Find('?',LvarFormato) GT 0>
			<cfthrow message="Error! No se pudo determinar la contra cuenta contable! Proceso Cancelado!">
		</cfif>
		<!--- 4. Genera Cuenta Financiera --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(LvarFormato,4)#"/>							
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(LvarFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
			<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Cuenta #LvarFormato#: #LvarERROR#">
		</cfif>
		<!--- 5. Obtiene la Cuenta Asociada al Formato de Cuenta Financiera --->
		<cfquery name="rsCuenta" datasource="#GvarConexion#">
			select CFcuenta, Ccuenta, CPcuenta, CFformato
			from CFinanciera 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarFormato#">
		</cfquery>
		<cfif len(trim(rsCuenta.Ccuenta))>
			<cfset LRetCcuenta = rsCuenta.Ccuenta>
		<cfelse>
			<cfthrow message="Cuenta #LvarFormato#: Cuenta Inválida! Proceso Cancelado!">
		</cfif>
		<cfreturn rsCuenta>
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaConcepto
		Resultado:
			Devuelve el id de cuenta contable asciado al Concepto/Servicio
	--->
	<cffunction access="private" name="obtieneCuentaConcepto" output="false" returntype="string">
		<cfargument name="LparamCid"   	   required="yes" type="string">
		<cfargument name="LparamDcodigo"   required="yes" type="string">
		<cfargument name="LparamCodCid"    required="yes" type="string">

		<cfquery name="query" datasource="#GvarConexion#">
			select Ccuenta 
			from CuentasConceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#" >
			  and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.LparamDcodigo#" >
			  and Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.LparamCodCid)#" >
			  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamCid#" >
		</cfquery>

		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definida la cuenta contable para el servicio #arguments.LparamCodCid# y el departamento #arguments.LparamDcodigo#. Proceso Cancelado!">
		</cfif>
		<cfreturn query.Ccuenta>
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaCostoConcepto
		Resultado:
			Devuelve el id de cuenta contable asciado al Concepto/Servicio
	--->
	<cffunction access="private" name="obtieneCuentaCostoConcepto" output="false" returntype="query">
		<cfargument name="LparamCid"   	   required="yes" type="string">
		<cfargument name="LparamCodCid"    required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfargument name="LparamModulo"   required="yes" type="string">
		<!--- 1. Obtiene el Formato --->
		<cfquery name="query" datasource="#GvarConexion#">
			select Cformato as Formato
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamCid#">
			and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.LparamCodCid#">
		</cfquery>
		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definida la contra cuenta contable para el concepto #arguments.LparamCodCid#. Proceso Cancelado!">
		</cfif>
		<!--- 2. Obtiene el complemento del Socio --->
		<cfquery name="rsSocio" datasource="#GvarConexion#">
			select cuentac
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamIDSocio#">
		</cfquery>
		<!--- 3.Aplica Máscara --->
		<cfset LvarFormato = query.Formato>
		<cfif len(trim(rsSocio.cuentac))>
			<cfset LvarFormato = CGAplicarMascara(LvarFormato, rsSocio.cuentac)>
		</cfif>
		<cfif Find('?',LvarFormato) GT 0>
			<cfthrow message="Error! No se pudo determinar la contra cuenta contable! Proceso Cancelado!">
		</cfif>
		<!--- 4. Genera Cuenta Financiera --->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Cmayor" value="#Left(LvarFormato,4)#"/>							
			<cfinvokeargument name="Lprm_Cdetalle" value="#mid(LvarFormato,6,100)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Conexion" value="#GvarConexion#"/>
			<cfinvokeargument name="ecodigo" value="#GvarEcodigo#"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="Cuenta #LvarFormato#: #LvarERROR#">
		</cfif>
		<!--- 5. Obtiene la Cuenta Asociada al Formato de Cuenta Financiera --->
		<cfquery name="rsCuenta" datasource="#GvarConexion#">
			select CFcuenta, Ccuenta, CPcuenta, CFformato
			from CFinanciera 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarFormato#">
		</cfquery>
		<cfif len(trim(rsCuenta.Ccuenta)) eq 0>
			<cfthrow message="Cuenta #LvarFormato#: Cuenta Inválida! Proceso Cancelado!">
		</cfif>
		<cfreturn rsCuenta>
	</cffunction>
	
	<cffunction access="private" name="CGAplicarMascara"  output="false" returntype="string">
		<cfargument name="formato" required="yes" type="string">
		<cfargument name="complemento" required="yes" type="string">
		<cfset contador = 0>
		<cfloop condition="#Find('?',formato)#">
			<cfset contador = contador + 1>
			<cfif len(Mid(complemento,contador,1))>
				<cfset formato = replace(formato,'?',Mid(complemento,contador,1))>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn formato>
	</cffunction>
	
</cfcomponent>