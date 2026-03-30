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
	<cffunction name="process" access="public" returntype="string" output="no">
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
		<cfif len(query.Dtipocambio) eq 0> 
			<cfset Valid_TipoCambioCXC 		= getValidTipoCambio(Valid_Mcodigo,Valid_FechaTipoCambio,'CXC')>	
			<cfset Valid_TipoCambioCXP 		= getValidTipoCambio(Valid_Mcodigo,Valid_FechaTipoCambio,'CXP')>
	    <cfelse>
			<cfset Valid_TipoCambioCXC  	= query.Dtipocambio	>
			<cfset Valid_TipoCambioCXP 		= query.Dtipocambio	>
		</cfif>
			
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
								<cfqueryparam cfsqltype="cf_sql_char" value="#query.DEobservacion#" null="#len(query.DEobservacion) eq 0#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
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
					<cfset Valid_Descripcion 	= #query.DDdescripcion#>
					<!--- Tipo Artículo   --->
					<cfif Valid_TipoItem EQ "A" > 
						<cfset Valid_Aid_struct		 		= getValidAid(query.CodigoItem)>
						<cfset Valid_Cid_struct.Cid 	 		= "">
						<cfset Valid_Cid_struct.Ccodigo 		= "">
					  <cfif len(Valid_Descripcion) eq 0>
						<cfset Valid_Descripcion 		= Valid_Aid_struct.Adescripcion>
					  </cfif>
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
					<cfelseif Valid_TipoItem EQ "S" > 
						<cfset Valid_Aid_struct.Aid 	= "">
						<cfset Valid_Cid_struct	     	= getValidCid(query.CodigoItem)>
					  <cfif len(Valid_Descripcion) eq 0>
						<cfset Valid_Descripcion 		= Valid_Cid_struct.Cdescripcion>
					  </cfif>
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
						<cfset Valid_Aid_struct		 		= getValidAid(query.CodigoItem)>
						<cfset Valid_Cid_struct.Cid 	 		= "">
						<cfset Valid_Cid_struct.Ccodigo 		= "">
					  <cfif len(Valid_Descripcion) eq 0>
						<cfset Valid_Descripcion 		= Valid_Aid_struct.Adescripcion>
					  </cfif>
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

					<cfset Valid_ImporteTotal = 0>
					
					<cfif len(trim(query.PrecioTotal)) gt 0>
						<cfset Valid_ImporteTotal = query.PrecioTotal >
					<cfelseif (Valid_CantidadTotal * Valid_PrecioUnitario) GT 0.00>
						<cfset Valid_ImporteTotal = (Valid_CantidadTotal * Valid_PrecioUnitario) - Valid_ImporteDescuento >
					</cfif>
					
					<!--- Calcula impuesto --->
                    <cfset Valid_ImporteImpuesto = 0>
                    <cfset LvarCalcularImpuesto = query.ImporteImpuesto EQ "">
					<cfif LvarCalcularImpuesto>
						<cfif query.CodigoImpuesto EQ "">
							<cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,0,Valid_ImporteTotal)>
						<cfelse>
							<cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,-1,Valid_ImporteTotal)>
						</cfif>
						<cfif len(trim(Valid_Icodigo))>
							<cfquery name="queryImpuesto" datasource="#GvarConexion#">
								select coalesce(Iporcentaje,0) as Iporcentaje
								from Impuestos
								where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Valid_Icodigo)#">
								  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
							</cfquery> 
							<cfset Valid_ImporteImpuesto =  (Valid_ImporteTotal*queryImpuesto.Iporcentaje)/100 >
						</cfif>
					<cfelse>
						<cfset Valid_ImporteImpuesto = query.ImporteImpuesto>
						<cfset Valid_Icodigo = getValidIcodigo(query.CodigoImpuesto,Valid_ImporteImpuesto,Valid_ImporteTotal)>
					</cfif>
					
					<cfif Valid_ImporteTotal EQ 0>
						<cfset Valid_PorcentajeDescuento = 0>
						<cfset Valid_ImporteDescuento = 0>
					<cfelseif Valid_ImporteDescuento eq 0>
						<cfset Valid_PorcentajeDescuento = 0>
					<cfelse>
						<cfset Valid_PorcentajeDescuento = Valid_ImporteDescuento/(Valid_ImporteTotal+Valid_ImporteDescuento)>
					</cfif>
					
					
					<cfset Valid_Ucodigo = getValidUcodigo(query.CodigoUnidadMedida, Valid_Aid_struct.Aid)>
					
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
								<cfinvokeargument name="Aid"		value="#Valid_Aid_struct.Aid#"/>
								<cfinvokeargument name="SNid"		value="#Valid_SNcodigo.SNid#"/>
								<cfinvokeargument name="OCIid"		value="#Valid_OCIid#"/>
							</cfinvoke>
							<cfset Valid_DCcuenta = getValid_CFcuenta(LvarCFcuenta)>
						<cfelseif GvarCuentaManual>
							<cfif Valid_TipoItem EQ "A">
								<cfif Valid_CCTcodigo.CCTafectacostoventas EQ 1>
									<cfthrow message="CCTafectacostoventas no aplica en CxC">
								</cfif>
								<cfset Valid_DCcuenta = obtieneCuentaArticulo_CformatoIngresos( Valid_Aid_struct.Aid, Valid_AlmAid, Valid_SNcodigo.SNcodigo) >
							<cfelseif Valid_TipoItem EQ "S">
								<cfset Valid_DCcuenta = obtieneCuentaConceptoServicio_Gasto_Ingreso( Valid_Cid_struct.Cid, Valid_Cid_struct.Ccodigo, Valid_SNcodigo.SNcodigo, Valid_Modulo) >
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
							   Articulos = "#Valid_Aid_struct.Aid#"
							   Conceptos = "#Valid_Cid_struct.Cid#"
							   CConceptos = "#Valid_Cid_struct.Cid#"
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
									ContractNo,
                                    DDimpuestoInterfaz,
									BMUsucodigo)
								values (
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
									<cfif Valid_TipoItem EQ "A" >
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid_struct.Aid#">, 
										null, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#">, 
									<cfelseif Valid_TipoItem EQ "O">
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Aid_struct.Aid#">, 
										null, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_AlmAid#" null="#Valid_AlmAid EQ ''#">, 
									<cfelseif Valid_TipoItem EQ "S">
										null, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Cid_struct.Cid#">, 
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
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#query.ContractNo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#Valid_ImporteImpuesto#" null="#LvarCalcularImpuesto#">, 
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
				<cfif NOT isdefined("request.PMI") AND Not Valid_Estimacion>
					<cfset aplicaDocumento(Valid_Modulo,rsInsert.identity)>
				</cfif>
				<!--- <cfif Not Valid_Estimacion> --->
		</cfoutput>
		<cfreturn "OK">
	</cffunction>
    
    
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------->	
	<!---
		Metodo: 
			getValidEcodigoSDC
		Resultado:
			Devuelve el codigo asociado al codigo de Empresa del portal dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction name="getValidEcodigoSDC" access="private" returntype="numeric" output="no">
	</cffunction>
	
	<!---
		Metodo: 
			getValidModulo
		Resultado:
			Devuelve el codigo asociado al codigo de modulo dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction name="getValidModulo" access="private" returntype="string" output="no">
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
	
	<cffunction access="private" name="getValidTESRPTCid" output="no" returntype="numeric">
	</cffunction>

	<!---
		Metodo: 
			getValidSNcodigo
		Resultado:
			Devuelve el id asociado al codigo de socio de negocios dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	
	<cffunction access="private" name="getValidSNcodigo" output="no" returntype="query">
	</cffunction>
		
	<!---
		Metodo: 
			getValidCCTcodigo
		Resultado:
			Devuelve el id asociado al codigo de transaccion de cc dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidCCTcodigo" output="no" returntype="query">
	</cffunction>

	<!---
		Metodo: 
			getValidCPTcodigo
		Resultado:
			Devuelve el id asociado al codigo de transaccion de cp dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidCPTcodigo" output="no" returntype="query">
	</cffunction>	
	
	
	<!---
		Metodo: 
			getValidCCEDdocumento
		Resultado:
			Devuelve documento dado por la interfaz validado.
			Si se encuentra un registro para el documento aborta el proceso.
	--->
	<cffunction access="private" name="getValidCCEDdocumento" output="no" returntype="string">
	</cffunction>
	
	<!---
		Metodo: 
			getValidCPEDdocumento
		Resultado:
			Devuelve documento dado por la interfaz validado.
			Si se encuentra un registro para el documento aborta el proceso.
	--->
	<cffunction access="private" name="getValidCPEDdocumento" output="no" returntype="string">
	</cffunction>

	<!---
		Metodo: 
			getValidMcodigo
		Resultado:
			Devuelve el id asociado al codigo Miso de la moneda dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidMcodigo" output="no" returntype="numeric">
	</cffunction>
	
	<!---
		Metodo: 
			getValidTransporte
		Resultado:
			Devuelve el id del transporte .
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidTransporte" output="no" returntype="numeric">
	</cffunction>	

	<!---f
		Metodo: 
			getValidContrato
		Resultado:
			Devuelve el id de la orden comercial .
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidContrato" output="no" returntype="query">
	</cffunction>	
	
	<!---
		Metodo: 
			getValidConceptoCompra
		Resultado:
			Devuelve el id del concepto de compra.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidConceptoCompra" output="no" returntype="numeric">
	</cffunction>		
	
	<!---
		Metodo: 
			getValidConceptoIngreso
		Resultado:
			Devuelve el id del concepto de Ingreso.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidConceptoIngreso" output="no" returntype="numeric">
	</cffunction>		
	
	<!---
		Metodo: 
			getValidFechaDocumento
		Resultado:
			Devuelve una Fecha de Documento Valida
	--->
	<cffunction access="private" name="getValidFechaDocumento" output="no" returntype="date">
	</cffunction>
	
	
	<!---
		Metodo: 
			getValidFechaTipoCambio
		Resultado:
			Devuelve una Fecha Valida
	--->
	<cffunction access="private" name="getValidFechaTipoCambio" output="no" returntype="date">
	</cffunction>	
	
	
	<!---
		Metodo: 
			getValidFechaVencimiento
		Resultado:
			Devuelve una Fecha de Vencimiento Valida
	--->
	<cffunction access="private" name="getValidFechaVencimiento" output="no" returntype="date">
	</cffunction>
	
	<!---
		Metodo:
			getTipoCambio
		Resultado:
			Obtiene el Tipo de cambio de la moneda indicada en la fecha indicada,
			la moneda esperada es en codigo Miso4217
	--->
	<cffunction access="private" name="getValidTipoCambio" output="no" returntype="numeric"> 
  </cffunction>

	<cffunction access="private" name="getValidReferencia" output="no" returntype="string">
	</cffunction>
	
	<!---
		Metodo: 
			getValidRCodigo
		Resultado:
			Devuelve true si el id asociado al codigo de Retencion dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="getValidRCodigo" output="no" returntype="string">
	</cffunction>

	<!---
		Metodo: 
			getValidOCodigo
		Resultado:
			Devuelve el id asociado al codigo de Oficina dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction access="private" name="getValidOCodigo" output="no" returntype="numeric">
	</cffunction>

	<!---
		Metodo: 
			getValidCcodigo
		Resultado:
			Devuelve el Cconcepto Válido
	--->
	<cffunction access="private" name="getValidCcodigo" output="no" returntype="string">
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
	<cffunction access="private" name="getValidCcuenta" output="no" returntype="numeric">
	</cffunction>
	
	<!---
	Metodo:
		getValid_CFcuenta
	Resultado:
		0.	Se valída el ID de la cuenta.
	--->
	<cffunction access="private" name="getValid_CFcuenta" output="no" returntype="query">
	</cffunction>

	<!---
	Metodo:
		getValid_DCcuenta
	Resultado:
		0.	Se valída la máscara enviada por el usuario de la interfaz.
	--->
	<cffunction access="private" name="getValid_DCcuenta" output="no" returntype="query">
	</cffunction>
	<!---
		Metodo: 
			getValid_TipoItem
		Resultado:
			Devuelve el Tipo de Item Válidado, A=Articulo, S=Servicio , O = Transito con orden comercial.
	--->
	<cffunction name="getValidTipoItem" access="private" returntype="string" output="no">
	</cffunction>
	
	<!---
		Metodo: 
			getValidAid
		Resultado:
			Devuelve el id asociado al codigo de articulo dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidAid" output="no" returntype="query">
	</cffunction>

	<!---
		Metodo: 
			getValidCid
		Resultado:
			Devuelve el Id coresspondiente con el codigo de concepto dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidCid" output="no" returntype="query">
	</cffunction>

	<!---
		Metodo: 
			getValidCFid
		Resultado:
			Devuelve el Id coresspondiente con el código de Centro Funcional dado por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidCFid" output="no" returntype="numeric">
	</cffunction>

	<!---
		Metodo: 
			getValidUcodigo
		Resultado:
			Devuelve true si el id asociado al codigo de Unidad dado por la interfaz existe.
			Devuelve false en el caso contrario. 
	--->
	<cffunction access="private" name="getValidUcodigo" output="no" returntype="string">
	</cffunction>
	
	<!---
		Metodo: 
			getValidIcodigo
		Resultado
			1. Busca el Impuesto correspondiente con el Icodigo si este no está vacío.
			2. Si Icodigo está vacío busca el impuesto con el porcentaje correspondiente 
			con el Monto de Impuesto en Relacion con el Monto Total de la Línea (incluyendo CERO = EXENTO).
			
			Si el monto del impuesto está vacío, busca un impuesto excento
	--->
	<cffunction access="private" name="getValidIcodigo" output="no" returntype="string">
	</cffunction>

	<!---
		Metodo: 
			getValidAlmAid
		Resultado:
			Devuelve el id asociado al codigo de almacen dado por la interfaz.
			Si viene el Almacen lo valida y si no viene devuelve el primer almacen de la Tabla.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidAlmAid" output="no" returntype="numeric">
	</cffunction>

	<!---
		Metodo: 
			getValidDcodigo
		Resultado:
			Devuelve el id asociado al codigo de departamento dado por la interfaz.
			Si viene el Departamento lo valida y si no viene devuelve el primer departamento de la Tabla.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidDcodigo" output="no" returntype="numeric">
	</cffunction>

	<!---
		Metodo: 
			getValidPeriodoAuxiliares
		Resultado:
			Devuelve el Periodo de Auxiliares.
	--->
	<cffunction access="private" name="getValidPeriodoAuxiliares" output="no" returntype="numeric">
	</cffunction>

	<!---
		Metodo: 
			getValidMesAuxiliares
		Resultado:
			Devuelve el Periodo de Auxiliares.
	--->
	<cffunction access="private" name="getValidMesAuxiliares" output="no" returntype="numeric">
	</cffunction>
		
	<!---
		Metodo: 
			actualizarEncabezadoCC
		Resultado:
			Hace calculos adicionales para el encabezado del Documento CxC.
	--->
	<cffunction access="private" name="actualizarEncabezadoCC" output="no" >
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezadoCP
		Resultado:
			Hace calculos adicionales para el encabezado del Documento CxP.
	--->
	<cffunction access="private" name="actualizarEncabezadoCP" output="no" >
	</cffunction>

	<!---
		Metodo: 
			actualizarEncabezado
		Resultado:
			Aplica el documento de Cxc o CxP generado.
	--->
	<cffunction access="public" name="actualizarEncabezado" output="no" >
	</cffunction>

	<!---
		Metodo: 
			aplicaDocumento
		Resultado:
			Aplica el documento de Cxc o CxP generado.
	--->
		
	<cffunction access="public" name="aplicaDocumento" output="no" >
	</cffunction>
	
</cfcomponent>
