<!--- 
	Interfaz 10: Interfaz de Intercambio de Información de Documentos de Cuentas por Cobrar / Cuentas por Pagar
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: D.A.G. (dabarca@soin.co.cr) 20/07/2005
	Modificación (03/03/2006) Se modifica la interpretación del documento, para validar que el documento no exista.
	Modificación (20/02/2006) Se modifica validación de montos negativos, para que los permita.
	Modificación (20/02/2006) Se elimina función init, no se utiliza, no se logró determinar para que se agregó.
	Modificación (22/10/2005) Se agregó función init. (Rodolfo Jiménez Jara)
	Modificación (11/07/2005) Se Modificó la Interpretación y Validación de la Información, además se agregaron algunos campos a las Tablas IE1o y ID10 (DAG)
--->
<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion  = Session.Dsn>
	<cfset GvarEcodigo   = Session.Ecodigo>	
	<cfset GvarUsuario   = Session.Usuario>
	<cfset GvarUsucodigo = Session.Usucodigo>
	<cfset GvarEcodigoSDC= Session.EcodigoSDC>
	<cfset GvarEnombre   = Session.Enombre>
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
		
			<cfset Valid_EcodigoSDC 		= getValidEcodigoSDC(query.EcodigoSDC)>
			<cfset Valid_Modulo 			= getValidModulo(query.Modulo)>
			<cfset Valid_SNcodigo 			= getValidSNcodigo(query.NumeroSocio, query.CodigoDireccionEnvio, query.CodigoDireccionFact)>
			<cfset Valid_Mcodigo 			= getValidMcodigo(query.CodigoMoneda)>
			<cfset Valid_FechaDocumento  	= getValidFechaDocumento(query.FechaDocumento)>
			<cfset Valid_FechaTipoCambio 	= getValidFechaTipoCambio(query.FechaTipoCambio)>
			<cfset Valid_FechaVencimiento 	= getValidFechaVencimiento(query.FechaDocumento,query.FechaVencimiento,query.DiasVencimiento)>
			<cfset Valid_TipoCambioCXC 		= getValidTipoCambio(Valid_Mcodigo,Valid_FechaTipoCambio,'CXC')>
			<cfset Valid_TipoCambioCXP 		= getValidTipoCambio(Valid_Mcodigo,Valid_FechaTipoCambio,'CXP')>
			<cfset Valid_Referencia 		= getValidReferencia(query.VoucherNo)>		
			<cfset Valid_Rcodigo 			= getValidRcodigo(query.CodigoRetencion)>
			<cfset Valid_Ocodigo 			= getValidOcodigo(query.CodigoOficina)>
			<cfset Valid_Ccodigo 			= getValidCcodigo(query.CodigoConceptoServicio)>
			<cfset Valid_Ccuenta 			= getValidCcuenta(Valid_Modulo,Valid_SNcodigo.SNcodigo,Valid_Ccodigo,query.CuentaFinanciera,Valid_SNcodigo.id_direccion_fact)>
			<cfset Valid_Estimacion 		= (query.Facturado NEQ "S" AND query.Facturado NEQ "1")>

			<cfset Valid_TESRPTCid	 		= getValidTESRPTCid (Valid_SNcodigo.SNid)>
			
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
				<cfset Valid_Periodo 	= getValidPeriodoAuxiliares()>
				<cfset Valid_Mes 		= getValidMesAuxiliares()>
				<cfset Valid_Origen 	= iif(Valid_Modulo EQ "CC",DE("CCFC"),DE("CPFC"))>
			</cfif>
			<!--Inicia Transacción --->
			<cftransaction>
				<cfif Valid_Modulo EQ "CC">
					<!--- Variables Validadas Exclusivase de Cuentas por Cobrar --->
					<cfset Valid_CCTcodigo 		= getValidCCTcodigo(query.CodigoTransacion)>
					<cfset Valid_EDdocumento 	= getValidCCEDdocumento(query.Documento,Valid_CCTcodigo.CCTcodigo)>
					<cfif Not Valid_Estimacion>
						<!--- Inserta Documento en Cuentas por Cobrar --->
						<cfquery name="rsInsert" datasource="#GvarConexion#">
							insert into EDocumentosCxC( 
								Ecodigo, 
								Ocodigo, 
								CCTcodigo, 
								EDdocumento, 
								SNcodigo, 
								Mcodigo, 
								EDtipocambio,
								Icodigo,
								Ccuenta,
								Rcodigo, 
								EDdescuento, 
								EDporcdesc, 
								EDimpuesto, 
								EDtotal,
								EDfecha, 
								EDtref, 
								EDdocref, 
								EDusuario, 
								EDselect, 
								EDvencimiento, 
								Interfaz, 
								EDreferencia, 
								DEidVendedor, 
								DEidCobrador, 
								id_direccionFact, 
								id_direccionEnvio, 
								CFid,
								DEdiasVencimiento, 
								DEordenCompra,
								DEnumReclamo, 
								DEobservacion, 
								DEdiasMoratorio, 
								BMUsucodigo)
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Ocodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_SNcodigo.SNcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Mcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_float" value="#Valid_TipoCambioCXC#">, 
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
								<cfqueryparam cfsqltype="cf_sql_char" value="#query.DEordenCompra#" null="#len(query.DEordenCompra) eq 0#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#query.DEnumReclamo#" null="#len(query.DEnumReclamo) eq 0#">,
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
					<cfset Valid_EDdocumento = getValidCPEDdocumento(query.Documento, Valid_CPTcodigo.CPTcodigo, Valid_SNcodigo.SNcodigo)>
					<cfif Not Valid_Estimacion>
						<!--- Inserta Documento en Cuentas por Pagar --->
						<cfquery name="rsInsert" datasource="#GvarConexion#">
							insert into EDocumentosCxP(	
								Ecodigo, CPTcodigo, 
								EDdocumento, Mcodigo, 
								SNcodigo, Icodigo, 
								Ocodigo, Ccuenta, 
								Rcodigo, CFid, 
								id_direccion, EDtipocambio, 
								EDimpuesto, EDporcdescuento, 
								EDdescuento, EDtotal, 
								EDfecha, EDusuario, 
								EDdocref, EDselect, 
								Interfaz, EDvencimiento, 
								EDfechaarribo, EDreferencia, 
								TESRPTCid,
								BMUsucodigo )
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
								<cfqueryparam cfsqltype="cf_sql_float" value="#Valid_TipoCambioCXP#">, 
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
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_TESRPTCid#">, 
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
					<cfset Valid_TipoItem 		= getValidTipoItem(query.TipoItem)>
					<cfset Valid_Descripcion 	= "">
					<!--- Tipo Artículo   --->
					<cfif Valid_TipoItem EQ "A"> 
						<cfset Valid_Aid		 		= getValidAid(query.CodigoItem)>
						<cfset Valid_Cid.Cid 	 		= "">
						<cfset Valid_Descripcion 		= Valid_Aid.Adescripcion>
						<cfset Valid_AlmAid 	 		= getValidAlmAid(query.CodigoAlmacen)>

						<cfif len(trim(query.CodEmbarque))>
							<cfif Valid_Modulo eq 'CC'>
								<cfthrow message="Error en Interfaz 10. No se pueden asignar líneas de tipo transito en cuentas por cobrar. Proceso Cancelado!">
							</cfif>
							<cfset Valid_TipoItem 		= "T">
							<cfset Valid_OCTid			= "">
							<cfset Valid_OCTtipo		= "B">
							<cfset Valid_OCTtransporte	= query.CodEmbarque>
						<cfelse>
							<cfset Valid_OCTid			= "">
							<cfset Valid_OCTtipo		= "">
							<cfset Valid_OCTtransporte	= "">
						</cfif>
						<cfset Valid_OCCid 				= "">
						<cfset Valid_OCIid 				= "">
						<cfset Valid_OCid  				= "">
						
					<!--- Tipo Concepto   --->
					<cfelseif Valid_TipoItem EQ "S"> 
						<cfset Valid_Aid.Aid 			= "">
						<cfset Valid_Cid	     		= getValidCid(query.CodigoItem)>
						<cfset Valid_Descripcion 		= Valid_Cid.Cdescripcion>
						<cfset Valid_AlmAid  			= "">

						<cfset Valid_OCTid		  	    = "">
						<cfset Valid_OCTtipo			= "">
						<cfset Valid_OCTtransporte		= "">
						<cfset Valid_OCCid 				= "">
						<cfset Valid_OCIid 				= "">
						<cfset Valid_OCid  				= "">
						<cfif len(trim(query.CodEmbarque))>
							<cfthrow message="Error en Interfaz 10. No se puede asignar un embarque a una línea de tipo servicio. Proceso Cancelado!">
						</cfif>
				    <!--- Orden comercial transito   --->
					<cfelseif Valid_TipoItem EQ "O"> 
						<cfset Valid_Aid		 		= getValidAid(query.CodigoItem)>
						<cfset Valid_Cid.Cid 	 		= "">
						<cfset Valid_Descripcion 		= Valid_Aid.Adescripcion>
						<cfset Valid_AlmAid  			= "">

						<cfset Valid_OCTid		  	    = getValidTransporte(query.OCtransporte, query.OCtransporteTipo)>
						<cfset Valid_OCTtipo			= query.OCtransporteTipo>
						<cfset Valid_OCTtransporte		= query.OCtransporte>
						<cfif Valid_Modulo EQ "CC">
							<cfset Valid_OCIid 			= getValidConceptoIngreso(query.OCconceptoIngreso)>
						<cfelse>
							<cfset Valid_OCCid 			= getValidConceptoCompra(query.OCconceptoCompra)>
						</cfif>
						
						<cfset rsOC  					= getValidContrato(query.OCcontrato)>
						<cfset Valid_OCid				= rsOC.OCid>

						<cfif Valid_Modulo EQ "CC" AND rsOC.OCtipoOD NEQ "D">
							<cfthrow message="Error en Interfaz 10. Orden Comercial no es Destino. Proceso Cancelado!">
						<cfelseif Valid_Modulo EQ "CP" AND rsOC.OCtipoOD NEQ "O">
							<cfthrow message="Error en Interfaz 10. Orden Comercial no es Origen. Proceso Cancelado!">
						<cfelseif rsOC.OCtipoIC EQ "I">
							<cfthrow message="Error en Interfaz 10. Orden Comercial no es Tipo Comercial. Proceso Cancelado!">
						</cfif>
						
						<cfif rsOC.OCtipoIC EQ "V">
							<cfset Valid_AlmAid 	 		= getValidAlmAid(query.CodigoAlmacen)>
						</cfif>	
					</cfif>
					
					<cfset Valid_CFid = getValidCFid(query.CentroFuncional, Valid_Ocodigo)>
				
					<cfif Valid_CFid EQ 0>
						<cfset Valid_Dcodigo = "">
					<cfelse>
						<cfset Valid_Dcodigo = getValidDcodigo(query.CodigoDepartamento,Valid_CFid)>
					</cfif>
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
					<cfif len(trim(query.PrecioUnitario)) gt 0>
						<cfset Valid_PrecioUnitario = query.PrecioUnitario >
					</cfif>
					<cfset Valid_ImporteImpuesto = 0 >
					
					<cfif len(trim(query.ImporteImpuesto)) gt 0 and query.ImporteImpuesto gt 0>
						<cfset Valid_ImporteImpuesto = query.ImporteImpuesto >
					</cfif>
					<cfset Valid_ImporteTotal = 0>
					
					<cfif len(trim(query.PrecioTotal)) gt 0>
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
					
					<cfif Valid_ImporteTotal EQ 0>
						<cfset Valid_PorcentajeDescuento = 0>
						<cfset Valid_ImporteDescuento = 0>
					<cfelseif Valid_ImporteDescuento eq 0>
						<cfset Valid_PorcentajeDescuento = 0>
					<cfelse>
						<cfset Valid_PorcentajeDescuento = Valid_ImporteDescuento/(Valid_ImporteTotal+Valid_ImporteDescuento)>
					</cfif>
					
					
					<cfset Valid_Ucodigo = getValidUcodigo(query.CodigoUnidadMedida)>
					
					<cfif Valid_Modulo EQ "CC">
					<!--- CxC --->
						<cfif len(trim(query.CuentaFinancieraDet))>
							<cfset Valid_DCcuenta = getValid_DCcuenta(query.CuentaFinancieraDet)>						
						<cfelseif Valid_TipoItem EQ "O">	
							<cfinvoke 	component="sif.oc.Componentes.OC_transito" 
										method="fnOCobtieneCFcuenta" 
										returnvariable="LvarCFcuenta"
							>
								<cfinvokeargument name="tipo"		value="IN"/>
								<cfinvokeargument name="OCid"		value="#Valid_OCid#"/>
								<cfinvokeargument name="Aid"		value="#Valid_Aid.Aid#"/>
								<cfinvokeargument name="SNid"		value="#Valid_SNcodigo.SNid#"/>
								<cfinvokeargument name="OCIid"		value="#Valid_OCIid#"/>
							</cfinvoke>
							<cfset Valid_DCcuenta = getValid_CFcuenta(LvarCFcuenta)>
						<cfelseif GvarCuentaManual>
							<cfif Valid_TipoItem EQ "A">
								<cfif Valid_CCTcodigo.CCTafectacostoventas EQ 1>
									<cfthrow message="CCTafectacostoventas no aplica en CxC">
								</cfif>
								<cfset Valid_DCcuenta = obtieneCuentaArticulo_CformatoIngresos( Valid_Aid.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo) >
							<cfelseif Valid_TipoItem EQ "S">
								<cfset Valid_DCcuenta = obtieneCuentaConceptoServicio_Gasto_Ingreso( Valid_Cid.Cid, Valid_Cid.Ccodigo, Valid_SNcodigo.SNcodigo, Valid_Modulo) >
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
								insert DDocumentosCxC (
									EDid,
									Aid,
									Cid, 
									Alm_Aid, 
									Ccuenta, 
									Ecodigo, 
									DDdescripcion, 
									DDdescalterna, 
									Dcodigo, 
									DDcantidad, 
									DDpreciou, 
									DDdesclinea, 
									DDporcdesclin, 
									DDtotallinea, 
									DDtipo, 
									Icodigo, 
									CFid, 
									OCTid, 
									OCid,            
									OCIid, 
									BMUsucodigo)
								values (
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
									<cfif Valid_TipoItem EQ "A" >
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
										null, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">, 
									<cfelseif Valid_TipoItem EQ "O">
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
										null, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#" null="#Valid_AlmAid EQ ''#">, 
									<cfelseif Valid_TipoItem EQ "S">
										null, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Cid.Cid#">, 
										null, 
									</cfif>

									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
									<cfif len(Valid_Dcodigo) EQ 0>
										null,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Dcodigo#">, 
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_CantidadTotal#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PrecioUnitario#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteDescuento#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PorcentajeDescuento#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_TipoItem#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Icodigo#">, 
									<cfif Valid_CFid eq 0>
										null,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_CFid#">, 
									</cfif>
									<cfif Valid_TipoItem EQ "O">
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_OCTid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_OCid#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_OCIid#">, 
									<cfelse>
										null,
										null,
										null,
									</cfif>
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
								INSERT into #INTARCDIFF# ( INTTIP, INTDES, Ccuenta )
								values (
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTtipo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="CxP: de #Valid_Descripcion#.">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Ccuenta#">
								)
								INSERT into #INTARCDIFF# ( INTTIP, INTDES, Ccuenta )
								values (
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTtipoinverso#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="Estimación de #Valid_Descripcion#.">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">
								)
							</cfquery>

							<cfquery datasource="#GvarConexion#">
								INSERT #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
								SELECT	<cfqueryparam cfsqltype="cf_sql_char" value="CPFC">, 
										<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_EDdocumento#">, 
										<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_CCTcodigo.CCTcodigo#">, 
										round(<cfqueryparam cfsqltype="cf_sql_float" value="#(Valid_ImporteTotal+Valid_ImporteImpuesto)*Valid_TipoCambioCXP#">,2), 
										INTTIP, 
										INTDES, 
										<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
										round(<cfqueryparam cfsqltype="cf_sql_float" value="#Valid_TipoCambioCXP#">,2), 
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
					<!--- CxP --->
						<cfif Valid_TipoItem EQ "O">	
							<cfif len(trim(query.CuentaFinancieraDet))>
								<cfset Valid_DCcuenta = getValid_DCcuenta(query.CuentaFinancieraDet)>						
							<cfelse>
								<cfinvoke 	component="sif.oc.Componentes.OC_transito" 
											method="fnOCobtieneCFcuenta" 
											returnvariable="LvarCFcuenta"
								>
									<cfinvokeargument name="tipo"		value="TR"/>
									<cfinvokeargument name="OCid"		value="#Valid_OCid#"/>
									<cfinvokeargument name="Aid"		value="#Valid_Aid.Aid#"/>
									<cfinvokeargument name="SNid"		value="#Valid_SNcodigo.SNid#"/>
									<cfinvokeargument name="OCCid"		value="#Valid_OCCid#"/>
								</cfinvoke>
								<cfset Valid_DCcuenta = getValid_CFcuenta(LvarCFcuenta)>
							</cfif>
						<cfelseif len(trim(query.CuentaFinancieraDet))>
							<cfset Valid_DCcuenta = getValid_DCcuenta(query.CuentaFinancieraDet)>
						<cfelseif GvarCuentaManual>
							<cfif Valid_TipoItem EQ "A">
								<cfif Valid_CPTcodigo.CPTafectacostoventas EQ 1>
									<cfset Valid_DCcuenta = obtieneCuentaArticulo_CformatoCompras( Valid_Aid.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo) >
								<cfelse>
									<cfset Valid_DCcuenta = obtieneCuentaArticulo_IACinventario( Valid_Aid.Aid, Valid_AlmAid) >
								</cfif>
							<cfelseif Valid_TipoItem EQ "T">
								<cfif Valid_CPTcodigo.CPTafectacostoventas EQ 1>
									<cfset Valid_DCcuenta = obtieneCuentaArticulo_Compras_Ingresos( Valid_Aid.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo, Valid_TipoItem) >
								<cfelse>
									<cfset Valid_DCcuenta = obtieneCuentaArticulo_IACtransito( Valid_Aid.Aid, Valid_AlmAid) >
								</cfif>
							<cfelseif Valid_TipoItem EQ "S">
								<cfset Valid_DCcuenta = obtieneCuentaConceptoServicio_Gasto_Ingreso( Valid_Cid.Cid, Valid_Cid.Ccodigo, Valid_SNcodigo.SNcodigo, Valid_Modulo) >
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
								insert DDocumentosCxP (
								IDdocumento, 
								Aid, 
								Cid, 
								Alm_Aid, 
								Ccuenta, 
								Ecodigo, 
								DDdescripcion, 
								DDdescalterna, 
								Dcodigo, 
								DDcantidad, 
								DDpreciou, 
								DDdesclinea, 
								DDporcdesclin, 
								DDtotallinea,
								DDtipo, 
								Icodigo, 
								Ucodigo, 
								CFid, 
								DDobservaciones, 
								BMUsucodigo, 
								DOlinea, 

								OCTtipo, OCTtransporte,
								OCTfechaPartida, OCTobservaciones,
								OCid, OCCid
								)
								values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">, 
								<cfif Valid_TipoItem EQ "A">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
									null, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">, 
								<cfelseif Valid_TipoItem EQ "S">
									null, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Cid.Cid#">, 
									null, 
								<cfelseif Valid_TipoItem EQ "O">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
									null, 
									null, 
								<cfelseif Valid_TipoItem EQ "T">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid.Aid#">, 
									null, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">, 
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_DCcuenta.Ccuenta#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Descripcion#">, 
								
								<cfif len(Valid_Dcodigo) EQ 0>
									null,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Dcodigo#">, 
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_CantidadTotal#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PrecioUnitario#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteDescuento#">, 
								
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_PorcentajeDescuento#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteTotal#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_TipoItem#">, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Icodigo#">, 
								
								<cfif len(trim(Valid_Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#Valid_Ucodigo#"><cfelse>null</cfif>, 
								<cfif Valid_CFid EQ 0>
									null,
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_CFid#">,
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_char" value="">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarUsucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="0" null="yes">, 
								<cfif Valid_TipoItem EQ "A" or Valid_TipoItem EQ "S">
									null,				<!--- OCTtipo --->
									null,				<!--- OCTtransporte --->
									null,				<!--- OCTfechaPartida --->
									null,				<!--- OCTobservaciones --->
									null,				<!--- OCid --->
									null				<!--- OCCid --->
								<cfelseif Valid_TipoItem EQ "T">
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_OCTtipo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_OCTtransporte#">,	
									<cfqueryparam cfsqltype="cf_sql_date" value="#query.FechaBOL#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="TripNo=#query.TripNo#" null="#query.TripNo EQ ""#">,	
									null,				<!--- OCid --->
									null				<!--- OCCid --->
								<cfelseif Valid_TipoItem EQ "O">
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_OCTtipo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Valid_OCTtransporte#">,	
									<cfqueryparam cfsqltype="cf_sql_date" value="#query.FechaBOL#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="TripNo=#query.TripNo#" null="#query.TripNo EQ ""#">,	
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_OCid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_OCCid#" null="#Valid_Modulo NEQ "CP"#">
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
										round(<cfqueryparam cfsqltype="cf_sql_float" value="#(Valid_ImporteTotal+Valid_ImporteImpuesto)*Valid_TipoCambioCXP#">,2), 
										INTTIP, 
										INTDES, 
										<cfqueryparam cfsqltype="cf_sql_date" value="#Valid_FechaDocumento#">, 
										round(<cfqueryparam cfsqltype="cf_sql_float" value="#Valid_TipoCambioCXP#">,2), 
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
				</cfif>
				<!--- <cfif Not Valid_Estimacion> --->
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
			getValidTESRPTCid
		Resultado:
			Devuelve el Concepto de Pagos a Terceros asociado al socio de negocios o a menor del catalogo.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	
	<cffunction access="private" name="getValidTESRPTCid" output="true" returntype="numeric">
		<cfargument name="SNid" required="yes" type="numeric">

		<cfquery name="rsSQL" datasource="#Session.DSN#" >
			select 	TESRPTCid
			  from 	SNegocios
			 where 	SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
		</cfquery>
		<cfif rsSQL.TESRPTCid NEQ "">
			<cfreturn rsSQL.TESRPTCid>
		</cfif>
		
		<cfquery name="rsSQL" datasource="#Session.DSN#" >
			select 	TESRPTCid
			  from 	TESRPTconcepto 
			 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			   and  TESRPTCcodigo =
			   		(
						select 	min (TESRPTCcodigo)
						  from 	TESRPTconcepto 
						 where 	CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						   and 	TESRPTCdevoluciones = 0
					)
		</cfquery>
		<cfif rsSQL.TESRPTCid NEQ "">
			<cfreturn rsSQL.TESRPTCid>
		</cfif>

		<cfthrow message="Error en Interfaz 10. No existen Conceptos de Pagos a Teceros en Tesorería.">
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
				where SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionEnvio#">
				  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and SNDenvio    = 1
			</cfquery>
			<cfif query1.recordcount eq 0>
				<cfquery name="query1" datasource="#GvarConexion#">
					select SNid, SNcodigo, id_direccion
					from SNDirecciones
					where SNDcodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionEnvio#">
				      and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					and SNDenvio      = 1
				</cfquery>
			</cfif>
			<cfif query1.recordcount gt 0>
				<cfset Lvar_SNid               = query1.SNid>
				<cfset Lvar_SNcodigo           = query1.SNcodigo>
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
				where SNcodigoext    = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionFact#">
				  and Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  <cfif Lvar_SNid NEQ 0>
					and SNid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNcodigo#">
				  </cfif>
				  and SNDfacturacion = 1
			</cfquery>
			<cfif query2.recordcount eq 0>
				<cfquery name="query2" datasource="#GvarConexion#">
					select SNid, SNcodigo, id_direccion
					from SNDirecciones
					where SNDcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoDireccionFact#">
				      and Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					  <cfif Lvar_SNid NEQ 0>
					  	and SNid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
						and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNcodigo#">
					  </cfif>
					  and SNDfacturacion = 1
				</cfquery>
			</cfif>
			<cfif query2.recordcount gt 0>
				<cfif Lvar_SNid eq 0>
					<cfset Lvar_SNid     = query2.SNid>
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

		<cfquery name="rsverificaDireccion1" datasource="#GvarConexion#">
				select SNcodigo, SNid, id_direccion as id_direccion_envio
				from SNDirecciones
				where  Ecodigo       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and  SNcodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_SNcodigo#">
				  and  SNid          = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
				  and  id_direccion  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_id_direccion_envio#">
				  and  SNDenvio = 1
		</cfquery>

		<cfquery name="rsverificaDireccion2" datasource="#GvarConexion#">
				select SNcodigo, SNid, id_direccion as id_direccion_fact
				from SNDirecciones
				where  Ecodigo        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and  SNcodigo       = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_SNcodigo#">
				  and  SNid           = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_SNid#">
				  and  id_direccion   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_id_direccion_fact#">
				  and  SNDfacturacion = 1
		</cfquery>

		<cfif not isdefined("rsverificaDireccion1") or not isdefined("rsverificaDireccion2") or rsverificaDireccion1.recordcount NEQ 1 or rsverificaDireccion2.recordcount NEQ 1>
			<cfset lvarMensajevalidacion = "Error en la Interfaz 10: ">
			<!--- Error en la obtención de los datos --->
			<cfif not isdefined("rsverificaDireccion1") or rsverificaDireccion1.recordcount NEQ 1>
				<cfset LvarMensajevalidacion = LvarMensajeValidacion & " La direccion: #Lvar_id_direccion_envio# no es de envio al socio: #Lvar_SNcodigo#, SNid: #Lvar_SNid#">
			</cfif>
			<cfif not isdefined("rsverificaDireccion2") or rsverificaDireccion2.recordcount NEQ 1>
				<cfset LvarMensajevalidacion = LvarMensajeValidacion & " La direccion: #Lvar_id_direccion_fact# no es de facturacion al socio: #Lvar_SNcodigo#, SNid: #Lvar_SNid#">
			</cfif>
			<cfset LvarMensajevalidacion & " de la Empresa #GvarEnombre#. Proceso Cancelado">
			<cfthrow message="#LvarMensajevalidacion#">
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
		<cfargument name="CCTcodigo" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select 1 
			from EDocumentosCxC
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(ltrim(CCTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
			  and rtrim(ltrim(EDdocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
			union
			select 1 
			from Documentos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(ltrim(CCTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
			  and rtrim(ltrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
			union
			select 1 
			from HDocumentos
			where rtrim(ltrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
			  and rtrim(ltrim(CCTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			union
			select 1 
			from BMovimientos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(ltrim(CCTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
			  and rtrim(ltrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
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
		<cfargument name="CPTcodigo" required="yes" type="string">
		<cfargument name="SNcodigo" required="yes" type="string">
		<cfquery name="query" datasource="#GvarConexion#">
			select 1 
			from EDocumentosCxP
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			  and rtrim(ltrim(CPTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigo)#">
			  and rtrim(ltrim(EDdocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
			  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
			union
			select 1 
			from EDocumentosCP
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
			  and rtrim(ltrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
			  and rtrim(ltrim(CPTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			union
			select 1 
			from HEDocumentosCP
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
			  and rtrim(ltrim(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDdocumento)#">
			  and rtrim(ltrim(CPTcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
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
			getValidTransporte
		Resultado:
			Devuelve el id del transporte .
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidTransporte" output="false" returntype="numeric">
		<cfargument name="OCTtransporte" 	required="yes" type="string">
		<cfargument name="OCTtipo" required="yes" type="string">	

		<cfif trim(Arguments.OCTtransporte) EQ "">
			<cfthrow message="Error en Interfaz 10. Transporte es inválido, El transporte de la orden comercial no puede quedar en blanco. Proceso Cancelado!.">
		</cfif>
		<cfquery name="query" datasource="#GvarConexion#">
			SELECT OCTid, OCTtipo, OCTtransporte, OCTestado
			  from OCtransporte
 			 where Ecodigo   		= <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			   and OCTtipo   		= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.OCTtipo)#">
			   and OCTtransporte	= <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.OCTtransporte)#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 10. Transporte es inválido, El transporte '#trim(Arguments.OCTtipo)# - #trim(Arguments.OCTtransporte)#' de la orden comercial no existe. Proceso Cancelado!.">
		<cfelseif query.OCTestado NEQ "A">
			<cfthrow message="Error en Interfaz 10. Transporte es inválido, El transporte '#trim(Arguments.OCTtipo)# - #trim(Arguments.OCTtransporte)#' de la orden comercial no está Abierto, su estado es '#query.OCTestado#'. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.OCTid>
	</cffunction>	

	<!---
		Metodo: 
			getValidContrato
		Resultado:
			Devuelve el id de la orden comercial .
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidContrato" output="false" returntype="query">
		<cfargument name="OCcontrato" required="yes" type="string">

		<cfif trim(Arguments.OCcontrato) EQ "">
			<cfthrow message="Error en Interfaz 10. Contrato es inválido, El Contrato de la orden comercial no puede quedar en blanco. Proceso Cancelado!.">
		</cfif>
		<cfquery name="query" datasource="#GvarConexion#">
			SELECT OCid, OCtipoOD, OCtipoIC
			  from OCordenComercial
			 where OCcontrato =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.OCcontrato)#">
			   and OCestado = 'A'
			   and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 10. Contrato es inválido, El contrato '#trim(Arguments.OCcontrato)#' de la orden comercial no existe en la  Empresa #GvarEnombre# o se encuentra en estado cerrado. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>	
	
	<!---
		Metodo: 
			getValidConceptoCompra
		Resultado:
			Devuelve el id del concepto de compra.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidConceptoCompra" output="false" returntype="numeric">
		<cfargument name="OCconceptoCompra" required="yes" type="string">

		<cfif trim(Arguments.OCconceptoCompra) EQ "">
			<cfthrow message="Error en Interfaz 10. Concepto de compra es inválido, El Concepto de compra de la orden comercial no puede quedar en blanco. Proceso Cancelado!.">
		</cfif>
		<cfquery name="query" datasource="#GvarConexion#">
			SELECT OCCid from OCconceptoCompra
			where OCCcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.OCconceptoCompra)#">
			and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 10. Concepto de compra es inválido, El Concepto de compra de la orden comercial no existe en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.OCCid>
	</cffunction>		
	
	<!---
		Metodo: 
			getValidConceptoIngreso
		Resultado:
			Devuelve el id del concepto de Ingreso.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidConceptoIngreso" output="false" returntype="numeric">
		<cfargument name="OCconceptoIngreso" required="yes" type="string">

		<cfif trim(Arguments.OCconceptoIngreso) EQ "">
			<cfthrow message="Error en Interfaz 10. Concepto de Ingreso es inválido, El Concepto de Ingreso de la orden comercial no puede quedar en blanco. Proceso Cancelado!.">
		</cfif>
		<cfquery name="query" datasource="#GvarConexion#">
			SELECT OCIid 
			  from OCconceptoIngreso
			 where OCIcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.OCconceptoIngreso)#">
			   and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 10. Concepto de Ingreso es inválido, El Concepto de Ingreso de la orden comercial no existe en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.OCIid>
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
			getValidFechaTipoCambio
		Resultado:
			Devuelve una Fecha Valida
	--->
	<cffunction access="private" name="getValidFechaTipoCambio" output="false" returntype="date">
		<cfargument name="Fecha" required="yes" type="date">
		<cfif Arguments.Fecha lt GvarMinFecha or Arguments.Fecha gt DateAdd('yyyy',99,GvarMinFecha)>
			<cfthrow message="Error en Interfaz 10. Fecha Tipo Cambio es inválido, La Fecha del Documento no es válida en la Empresa #GvarEnombre#. Proceso Cancelado!.">
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
	  <cfargument name="Fecha" required="no" type="date" default="#now()#">
	  <cfargument name="origen" required="no" type="string" default="CXC">
	  <cfset var retTC = 1.00>
	  <cfquery name="rsTC" datasource="#GvarConexion#">
		   select 
		   		coalesce(h.TCcompra,1) as TCcompra,
				coalesce(h.TCventa,1)  as TCventa
		   from Htipocambio h
		   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		     and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		     and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		     and h.Hfecha = (
		     select max(h2.Hfecha)
		     from Htipocambio h2
		     where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		       and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		       and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">)
 
 	 </cfquery>
 	 <cfif isdefined('rsTC') and rsTC.recordCount GT 0>
		<cfif Arguments.origen eq 'CXC'>
			<cfset retTC = rsTC.TCcompra>
	 	<cfelseif Arguments.origen eq 'CXP'>
 		 	<cfset retTC = rsTC.TCventa>
	 	</cfif>
	 </cfif>
 	 <cfreturn retTC>
  </cffunction>

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
		<cfargument name="id_direccionFact" required="yes" type="numeric">
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
			<cfquery name="rsCuentaDir" datasource="#GvarConexion#">
				select SNDCFcuentaCliente, SNDCFcuentaProveedor
				from SNDirecciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
				  and id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_direccionFact#">
			</cfquery>
			<cfquery name="rsCuenta" datasource="#GvarConexion#">
				select SNcuentacxc, SNcuentacxp
				from SNegocios
				where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			</cfquery>
			<cfif Arguments.Modulo EQ "CC">
				<cfif LEN(rsCuentaDir.SNDCFcuentaCliente) and rsCuentaDir.SNDCFcuentaCliente>
					<cfset LvarCcuenta = rsCuentaDir.SNDCFcuentaCliente>
				<cfelseif len(rsCuenta.SNcuentacxc) and rsCuenta.SNcuentacxc gt 0>
					<cfset LvarCcuenta = rsCuenta.SNcuentacxc>
				<cfelse>
					<cfthrow message="Error en Interfaz 10. El Socio de Negocios no tiene definida correctamente la cuenta de Cuentas por Cobrar. Proceso Cancelado!.">
				</cfif>
			<cfelse>
				<cfif LEN(rsCuentaDir.SNDCFcuentaProveedor) and rsCuentaDir.SNDCFcuentaProveedor>
					<cfset LvarCcuenta = rsCuentaDir.SNDCFcuentaProveedor>
				<cfelseif len(rsCuenta.SNcuentacxp) and rsCuenta.SNcuentacxp gt 0>
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
		getValid_CFcuenta
	Resultado:
		0.	Se valída el ID de la cuenta.
	--->
	<cffunction access="private" name="getValid_CFcuenta" output="false" returntype="query">
		<cfargument name="CFcuenta" required="yes" type="string">
		<cfquery name="rsCuenta" datasource="#GvarConexion#">
			select CFcuenta, Ccuenta, CPcuenta, CFformato
			  from CFinanciera
			 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			   and CFcuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">
		</cfquery>
		<cfreturn rsCuenta>
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
			Devuelve el Tipo de Item Válidado, A=Articulo, S=Servicio , O = Transito con orden comercial.
	--->
	<cffunction name="getValidTipoItem" access="private" returntype="string">
		<cfargument name="TipoItem" required="true" type="string">
		<cfif Arguments.TipoItem neq "A" and Arguments.TipoItem neq "S" and Arguments.TipoItem neq "O">
			<cfthrow message="Error en Interfaz 10. TipoItem es Inválido, El Tipo de Ítem debe ser A=Articulo, S=Servicio,  O= Transito con orden comercial. Proceso Cancelado!.">
		</cfif>
		<cfif Arguments.TipoItem neq "O" AND Valid_Estimacion>
			<cfthrow message="Error en Interfaz 10. TipoItem es O= Transito con orden comercial, pero no se puede utilizar en una Estimación. Proceso Cancelado!.">
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
		<cfargument name="Ocodigo" required="yes" type="numeric">
		
		<cfif len(Arguments.CFcodigo) NEQ 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select CFid
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				and upper(rtrim(CFcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.CFcodigo))#">
			</cfquery>
			<cfif query.recordcount EQ 0 or len(trim(query.CFid)) eq 0>
				<cfthrow message="Error en Interfaz 10. CentroFuncional es inválido, El Código de Centro Funcional no corresponde con ningún Centro Funcional de la Empresa #GvarEnombre#. Proceso Cancelado!.">
				<cfabort>
			</cfif>
			<cfreturn query.CFid>
		<cfelse>
			<cfquery name="query" datasource="#GvarConexion#">
				select min(CFid) as CFid
				from CFuncional
				where Ecodigo = #GvarEcodigo#
				  and Ocodigo = #Arguments.Ocodigo#
			</cfquery>
			<cfif query.recordcount EQ 0 or len(trim(query.CFid)) eq 0>
				<cfthrow message="Error en Interfaz 10. No Existe ningún Centro Funcional definido en la Empresa #GvarEnombre#. Proceso Cancelado!.">
				<cfabort>
			</cfif>
			<cfreturn query.CFid>
		</cfif>
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
		<cfif query.recordcount eq 0>
			<cfquery name="query" datasource="#GvarConexion#">
				select Dcodigo
				from CFuncional
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			</cfquery>
		</cfif>
		<cfif query.recordcount eq 0>
			<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
				select Dcodigo
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
			select Pvalor as value
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
			select Pvalor as value
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
			<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
					  method="PosteoDocumento"
						EDid = "#arguments.IDdocumento#"
						Ecodigo = "#GvarEcodigo#"
						usuario = "#GvarUsuario#"
						debug = "N"
			/>
		<cfelse>
			<cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
				method="PosteoDocumento"
				IDdoc = "#arguments.IDdocumento#"
				Ecodigo = "#GvarEcodigo#"
				usuario = "#GvarUsuario#"
				debug = "N"
				/>
		</cfif>
	</cffunction>
	
	<!--- ************************************************************************************************************************************************
															FUNCIONES ESPECÍFICAS PARA PMI
	************************************************************************************************************************************************* --->
	
	<!---
		Metodo: 
			obtieneCuentaArticulo_Inventario_Transito
		Resultado:
			Devuelve el id de cuenta contable asciado al Articulo/Almacen
	--->
	<cffunction access="private" name="obtieneCuentaArticulo_IACinventario" output="false" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">

		<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
			select c.CFcuenta, c.Ccuenta, c.CPcuenta, c.CFformato
			from Existencias a 
				inner join IAContables b 
					on a.IACcodigo = b.IACcodigo 
					and a.Ecodigo = b.Ecodigo
				inner join CFinanciera c 
					on b.IACinventario = c.Ccuenta 
					and b.Ecodigo = c.Ecodigo
					<cfset LvarCtipo = "Inventario">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAid#">
			and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAlm_Aid#">
		</cfquery>
		
		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definido la cuenta contable de #LvarCtipo# para el artículo y el almacén. Proceso Cancelado!">
		</cfif>
		<cfreturn query>
	</cffunction>

	<cffunction access="private" name="obtieneCuentaArticulo_IACtransito" output="false" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">

		<cfquery name="query" datasource="#GvarConexion#" maxrows="1">
			select c.CFcuenta, c.Ccuenta, c.CPcuenta, c.CFformato
			from Existencias a 
				inner join IAContables b 
					on a.IACcodigo = b.IACcodigo 
					and a.Ecodigo = b.Ecodigo
				inner join CFinanciera c 
					on b.IACtransito = c.Ccuenta 
					and b.Ecodigo = c.Ecodigo
					<cfset LvarCtipo = "Transito">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAid#">
			and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamAlm_Aid#">
		</cfquery>
		
		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definido la cuenta contable de #LvarCtipo# para el artículo y el almacén. Proceso Cancelado!">
		</cfif>
		<cfreturn query>
	</cffunction>

	<!---
		Metodo: 
			obtieneCuentaArticulo_Compras_Ingresos
		Resultado:
			Devuelve el id de cuenta contable de costo del Articulo 
	--->
	<cffunction access="private" name="obtieneCuentaArticulo_CformatoIngresos" output="false" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfreturn obtieneCuentaArticulo_Compras_Ingresos (LparamAid, LparamAlm_Aid, LparamIDSocio, "CC")>
	</cffunction>
	
	<cffunction access="private" name="obtieneCuentaArticulo_CformatoCompras" output="false" returntype="query">
		<cfargument name="LparamAid"   	   required="yes" type="string">
		<cfargument name="LparamAlm_Aid"   required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfreturn obtieneCuentaArticulo_Compras_Ingresos (LparamAid, LparamAlm_Aid, LparamIDSocio, "CP")>
	</cffunction>
	
	<cffunction access="private" name="obtieneCuentaArticulo_Compras_Ingresos" output="false" returntype="query">
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
			obtieneCuentaConceptoServicio_Gasto_Ingreso
		Resultado:
			Devuelve el id de cuenta contable asciado al Concepto/Servicio
	--->
	<cffunction access="private" name="obtieneCuentaConceptoServicio_Gasto_Ingreso" output="false" returntype="query">
		<cfargument name="LparamCid"   	   required="yes" type="string">
		<cfargument name="LparamCodCid"    required="yes" type="string">
		<cfargument name="LparamIDSocio"   required="yes" type="string">
		<cfargument name="LparamModulo"   required="yes" type="string">
		<!--- 1. Obtiene el Formato --->
		<cfquery name="query" datasource="#GvarConexion#">
			select Cformato as Formato, Ctipo
			from Conceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LparamCid#">
			and Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.LparamCodCid#">
		</cfquery>
		<cfif query.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 10. No ha sido definida la contra cuenta contable para el concepto #arguments.LparamCodCid#. Proceso Cancelado!">
		<cfelseif LparamModulo EQ "CC" AND query.Ctipo NEQ "I">
			<cfthrow message="Error en Interfaz 10. El concepto #arguments.LparamCodCid# no es tipo Ingreso. Proceso Cancelado!">
		<cfelseif LparamModulo EQ "CP" AND query.Ctipo NEQ "G">
			<cfthrow message="Error en Interfaz 10. El concepto #arguments.LparamCodCid# no es tipo Gasto. Proceso Cancelado!">
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
