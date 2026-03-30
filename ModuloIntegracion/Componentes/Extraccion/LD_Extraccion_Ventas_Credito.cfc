

<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="false">
<cffunction name="getVentas" access="public" output="false">
	<cfargument name="rsOperacionID" type="query"  required="True" default="" />
	<cfargument name="Excluir" 		 type="string" required="True" default="" />
	<cfargument name="DataSource" 	 type="string" required="True" default="" />
	<cfargument name="ParVentasCxC"  type="string" required="false" default="false" />
	<cfsetting requestTimeout="7500">

	<!--- SE OBTIENE EL NOMBRE DE LA BASE DE DATOS DEL DATASOURCE SIFINTERFACES --->
	<cfset databaseNameInt = getDatabaseName("sifinterfaces")>

	<!--- Variables --->
	<cfset ErrCaja 	  = "">
	<cfset ErrBodega  = "">
	<cfset ErrFactura = "">
	<cfset fechaini   = "">
	<cfset fechafin   = "">
	<cfset LABEL = "VENTASCREDITO">
	<cfset TIPOEXTRACCION = "N/A">

	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
	<cfelse>
		<cfset fechaini = createdate(YEAR(NOW() -1), MONTH(NOW() -1), DAY(NOW() -1))>
		<cfset fechafin = createdatetime(YEAR(NOW()), MONTH(NOW()), DAY(NOW()),23,59,59)>
	</cfif>

	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones" method="init" returnvariable="O" />
	<cfif LABEL EQ "VENTASCONTADO">
		<cfinvoke component = "ModuloIntegracion.Componentes.TimbresFiscales" method="init" returnvariable="TF" />
		<cfset CargaTimbres = TF.setTimbres()>
	</cfif>


	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
	<cfset Equiv = ConversionEquivalencia ('LD', 'CADENA', rsOperacionID.Cadena_Id, rsOperacionID.Cadena_Id, 'Cadena')>
	<cfset varEcodigo = Equiv.EQUidSIF>
	<!--- SE OBTIENE EL CLIENTE DE CONTADO DE LOS PARAMETROS --->
	<cfquery name="rsGetCteContado" datasource="sifinterfaces">
		SELECT Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '00003'
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
	</cfquery>

	<cfif rsGetCteContado.RecordCount GT 0 AND rsGetCteContado.Pvalor NEQ "">
		<cfset lvarCteContado = #rsGetCteContado.Pvalor#>
	<cfelse>
		<cfquery datasource="sifinterfaces">
			INSERT INTO SIFLD_Errores
									(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, Ecodigo, Usuario)
			VALUES
				  ('CG_Ventas',
                   'ESIFLD_Facturas_Venta',
                   0,
				   'No se ha configurado el cliente de contado en los Par�metros Generales Interfaz!',
				   'Se debe dar de alta el Pcodigo 00003.',
				    <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
			       'ldInterfaz')
		</cfquery>
	</cfif>
		<cfif isDefined("lvarCteContado")>
			<cfloop query="rsOperacionID">
				<cftry>
					<!--- Obtiene la Moneda Local --->
					<cfset rsMoneda = O.getMonedaLD(DataSource,Emp_Id)>
					<cfif rsMoneda.recordcount EQ 0>
						<cfthrow message="Error al extraer la moneda Local">
					</cfif>

					<!--- DATOS DE VENTA --->
					<cfset rsEVentas = getEncabezado(Arguments.DataSource,
													 rsOperacionID.Emp_Id,
													 rsOperacionID.Suc_Id,
													 rsOperacionID.Operacion_Id,
													 Arguments.Excluir)>

					<cfif isdefined("rsEVentas") AND rsEVentas.recordcount GT 0>
						<cfset idEnc = 0>
						<cfset cont = 0>
						<cfloop query="rsEVentas">
							<cfset cont = cont + 1>
							<!--- ID para la tabla de Encabezados --->
							<cfset tablaFacturasVenta ="ESIFLD_Facturas_Venta">
							<cfset tablaFacturasVentaD="DSIFLD_Facturas_Venta">

							<!--- Crea el numero de Documento --->
							<cfif (rsEVentas.Tipo_Venta EQ "C" OR rsEVentas.Tipo_Venta EQ "E") and rsEVentas.Tipo_CEDI EQ 0>
								<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Cadena_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") &  numberformat(rsEVentas.Caja_Id,"00") & "-" & numberformat(rsEVentas.Factura_Id,"000000000")>
							<cfelseif rsEVentas.Tipo_Venta EQ "C" and rsEVentas.Tipo_CEDI EQ 1>
								<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Cadena_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") &  numberformat(rsEVentas.Caja_Id,"00") & "-" & numberformat(rsEVentas.Factura_Id,"000000000")>
							<cfelseif rsEVentas.Tipo_Venta EQ "E">
								<cfset Num_Doc = "NC-" & numberformat(rsOperacionID.Cadena_Id,"00") & numberformat(rsOperacionID.Suc_Id,"000") &  numberformat(rsEVentas.Caja_Id,"00") & "-" & numberformat(rsEVentas.Factura_Id,"00000000")>
							<cfelse>
								<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Cadena_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") & "-" & numberformat(rsOperacionID.Operacion_Id,"000000000")>
							</cfif>
							<cfinvoke component = "ModuloIntegracion.Componentes.TimbresFiscales"
								method 			= "getTimbres"
								returnVariable  = "getTimbres"
								Documento 		= "#Num_Doc#"
								Cadena_Id 		= "#rsEVentas.Cadena_Id#"
								Insertado       = "0">

							<cftransaction action="begin">
								<cftry>
									<cfquery name="rsMaxIDEnc" DataSource="sifinterfaces">
										select 	isnull(max(ID_DocumentoV),0) + 1 as MaxID
										from 	ESIFLD_Facturas_Venta
									</cfquery>
									<cfif #rsMaxIDEnc.MaxID# GT #idEnc#>
										<cfset idEnc = #rsMaxIDEnc.MaxID#>
									</cfif>

									<cfquery name="insertEncVtas" DataSource="sifinterfaces">
										INSERT INTO ESIFLD_Facturas_Venta
											(Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta, Fecha_Venta, Fecha_Operacion,
											Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, Impuesto, Total, Redondeo,
											Vendedor, Sucursal, Dias_Credito, Moneda, Tipo_Cambio, Direccion_Fact,
											Retencion, Observaciones, Tipo_CEDI, Estatus, Factura_Cambio, Fecha_Inclusion,
											IEPS, TimbreFiscal,Factura
											<!--- Servicios --->
											<cfif #TipoDoc_Id# EQ 10>
												,comisionRecibo
											</cfif>
											)
										VALUES
										   (<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#Cadena_id#">,
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="LD">,
											<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#idEnc#">,
											CASE
												WHEN <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoDoc_Id#"> in (1,4,8,10,11) THEN 'FC'
												WHEN <cfqueryparam cfsqltype="cf_sql_numeric" value="#TipoDoc_Id#"> in (3,5)   THEN 'NC'
											END,
											<cfqueryparam 	  cfsqltype="cf_sql_char" 	   value="#Tipo_Venta#">,
											<cfqueryparam 	  cfsqltype="cf_sql_date" 	   value="#dateformat(Factura_Fecha,"yyyy/mm/dd")#">,
											<cfqueryparam 	  cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">,
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#Num_Doc#">,
											<!--- <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#Cliente_Id#">, --->
											<!--- SE PARAMETRIZA EL CLIENTE DE CONTADO --->
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#lvarCteContado#">,
											<cfqueryparam 	  cfsqltype="cf_sql_null" 	   value="" null="true">,
											abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(Factura_Subtotal + Factura_Descuento,'9.99')#">),
											abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(Factura_Descuento,'9.99')#">),
											abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(Factura_Impuesto,'9.9999')#">),
											abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(Factura_Total,'9.99')#">),
											abs(<cfqueryparam cfsqltype="cf_sql_money"     value="#numberformat(Factura_Redondeo,'9.99')#">),
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#vendedor_Id#">,
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#Suc_Id#">,
											<cfqueryparam 	  cfsqltype="cf_sql_integer"   value="#dias_credito#">,
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#rsMoneda.Moneda_Id#">,
											<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="1">,
											<cfqueryparam 	  cfsqltype="cf_sql_null" 	   value="" null="true">,
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="">,
											<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="">,
											<cfif Arguments.ParVentasCxC>
												<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="S">,
											<cfelse>
												<cfif rsEVentas.Tipo_Venta EQ "C" OR rsEVentas.Tipo_Venta EQ "E">
													<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="S">,
												<cfelse>
													<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="N">,
												</cfif>
											</cfif>
											16,
											abs(<cfqueryparam cfsqltype="cf_sql_money" 	 value="#numberformat(Factura_Cambio_Efectivo,'9.99')#">),
											<cfqueryparam cfsqltype="cf_sql_timestamp"    value="#now()#">,
											abs(<cfqueryparam cfsqltype="cf_sql_money"   value="#Factura_IEPS#">)
											,
											<cfif Tipo_Venta EQ 'C' OR Tipo_Venta EQ 'E' OR ((Tipo_Venta EQ 'D' OR Tipo_Venta EQ 'X') AND Tipo_CEDI EQ 1)>
												<cfif isdefined('getTimbres.Fiscal_UUID')>
													'#getTimbres.Fiscal_UUID#'
												<cfelse>
													''
												</cfif>
											<cfelse>
												''
											</cfif>	,
												'#getTimbres.Factura#'
												<!--- Servicios --->
											<cfif #TipoDoc_Id# EQ 10>
												,<cfqueryparam cfsqltype="cf_sql_money"   value="#Comision_Tarjeta#">
											</cfif>
											<!--- , <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#LABEL#"> --->
											)
									</cfquery>

									<!--- ACTUALIZACION TIMBRE FISCAL --->
									<cfif isdefined('getTimbres.Fiscal_UUID')>
										<cfquery datasource="sifinterfaces">
											UPDATE 	SIFLD_Timbres_Fiscales
											SET    	Insertado = 1
											WHERE 	Fiscal_UUID = '#getTimbres.Fiscal_UUID#'
										</cfquery>
									</cfif>

									<cftransaction action="commit" />
								<cfcatch type="any">
									<cfset idEnc = 0>
									<cftransaction action="rollback" />
									<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Error al insertar encabezado #idEnc# #LABEL#, Error: #cfcatch.Message#">
									<cfthrow message="Error al insertar encabezado #idEnc# #LABEL#, Error: #cfcatch.Message#">
								</cfcatch>
								</cftry>
							</cftransaction>


							<!--- BUSCA E INSERTA LAS FORMAS DE PAGO PARA EL ENCABEZADO --->
							<!--- 														--->
							<!---	Efectivo = 1				E						--->
							<!---	Tarjeta = 2					T						--->
							<!---	Cupones = 3					V						--->
							<!---	Cheques = 4					H						--->
							<!---	MonedaExtranjera = 5		X						--->
							<!---	NotadeCredito = 6			N						--->
							<!---	Monedero = 7				M						--->
							<!---	Puntos = 8					P						--->
							<!---	Copago = 10					C						--->
							<!--------------------------------------------------------- --->

							<cfset varArgumentsFP = {DataSource  = "#Arguments.DataSource#",
													 Factura_Id  = "#rsEVentas.Factura_Id#",
													 Emp_Id 	 = "#rsEVentas.Emp_Id#",
													 Suc_Id 	 = "#rsEVentas.Suc_Id#",
													 Caja_Id   	 = "#rsEVentas.Caja_Id#",
													 TipoDoc_id  = "#rsEVentas.TipoDoc_id#"}>
							<cfset rsFormaPago = getFormaPago(argumentCollection = varArgumentsFP)>
							<cfset IDlineaFP = 1>

							<cfif isdefined("rsFormaPago") and rsFormaPago.recordcount GT 0>
								<cfloop query="rsFormaPago">
									<cfif rsFormaPago.Tipo_Id EQ 3>
										<cfquery name="rsCupon" datasource="#Arguments.DataSource#">
											SELECT Cupon_Nombre
											  FROM Cupon
											 WHERE Emp_Id 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
											   AND Cupon_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Cupon_Id#">
										</cfquery>
										<cfset varSocioDoc = rsCupon.Cupon_Nombre>
									<cfelse>
										<cfset varSocioDoc = "SOCIONULO">
									</cfif>

									<cftransaction action="begin">
										<cftry>
											<cfquery name="insertFormaPago" DataSource="sifinterfaces">
												INSERT INTO SIFLD_Facturas_Tipo_Pago (Ecodigo, ID_DocumentoV, ID_linea_Pago, Tipo_Pago, Importe, Moneda, Tipo_Cambio, Especial, SocioDocumento, ID_Forma_Pago,
															Comision_Porcentaje, Moneda_Origen_LD)
												VALUES (
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Cadena_id#">,
														<cfqueryparam cfsqltype="cf_sql_integer" value="#idEnc#">,
														<cfqueryparam cfsqltype="cf_sql_integer" value="#IDlineaFP#">,
														<cfif rsFormaPago.Tipo_Id EQ 1>
															'E',
														<cfelseif rsFormaPago.Tipo_Id EQ 2>
															'T',
														<cfelseif rsFormaPago.Tipo_Id EQ 3>
															'V',
														<cfelseif rsFormaPago.Tipo_Id EQ 4>
															'H',
														<cfelseif rsFormaPago.Tipo_Id EQ 5>
															'X',
														<cfelseif rsFormaPago.Tipo_Id EQ 6>
															'N',
														<cfelseif rsFormaPago.Tipo_Id EQ 7>
															'M',
														<cfelseif rsFormaPago.Tipo_Id EQ 8>
															'P',
														<cfelseif rsFormaPago.Tipo_Id EQ 10>
															'C',
														</cfif>
														abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Pago_Total,'9.99')#">),
														<cfqueryparam 	  cfsqltype="cf_sql_varchar" value="#rsMoneda.Moneda_Id#">,
														<cfqueryparam 	  cfsqltype="cf_sql_varchar" value="#rsFormaPago.Pago_Total_Tipo_Cambio#">,
														<cfif (rsFormaPago.Tipo_Id EQ 2 AND rsFormaPago.Tarjeta_Id EQ 3) OR rsFormaPago.Tipo_Id EQ 3>
															0,
														<cfelse>
															0,
														</cfif>
														<cfif varSocioDoc NEQ "SOCIONULO">
															<cfqueryparam cfsqltype="cf_sql_varchar" value="#varSocioDoc#">,
														<cfelse>
															null,
														</cfif>
														<cfif rsFormaPago.Tipo_Id eq 2>
															<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Tarjeta_Id#" null="true">,
														<cfelseif rsFormaPago.Tipo_Id eq 3>
															<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Cupon_Id#" null="true">,
														<cfelse>
															null,
														</cfif>
														abs(isnull(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Tarjeta_Porcentaje,'9.99')#">,0))
														,<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Moneda_Id#">
														)
											</cfquery>

											<cfset IDlineaFP = IDlineaFP + 1>
											<cftransaction action="commit" />
											<cfcatch type="any">
												<cftransaction action="rollback" />
												<cfset idEnc = 0>
												<!--- ELIMINA REGISTRO --->
												<cfquery name="deleteTipoPago" datasource="sifinterfaces">
													DELETE SIFLD_Facturas_Tipo_Pago
													 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
													   AND ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
												</cfquery>
												<cfquery name="deleteDetalle" datasource="sifinterfaces">
													DELETE DSIFLD_Facturas_Venta
													 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
													   AND ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
												</cfquery>
												<cfquery name="deleteEncabezado" datasource="sifinterfaces">
													DELETE ESIFLD_Facturas_Venta
													 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
													   AND ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
												</cfquery>
												<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Error al insertar forma de pago, Encabezado: #idEnc# - #LABEL#, Error: #cfcatch.Message#">
												<cfthrow message="Error al insertar forma de pago, Encabezado: #idEnc# - #LABEL#, Error: #cfcatch.Message#">
											</cfcatch>
										</cftry>
									</cftransaction>
								</cfloop>
							</cfif>

							<!--- Inserta un movimiento Bancario para las Formas de Pago Tarjeta de Credito --->
							<cfif (rsFormaPago.Tipo_Id EQ 2 AND rsFormaPago.Tarjeta_Id NEQ 3) OR rsFormaPago.Tipo_Id EQ 3 OR rsFormaPago.Tipo_Id EQ 10>
								<cfswitch expression="#rsFormaPago.Tipo_Id#">
									<cfcase value="2">
										<cfset varFPago = "Tarjeta">
										<cfset varCPago = "PT">
									</cfcase>
									<cfcase value="3">
										<cfset varFPago = "Cupon">
										<cfset varCPago = "PV">
									</cfcase>
									<cfcase value="4">
										<cfset varFPago = "Co-Pago">
										<cfset varCPago = "PC">
									</cfcase>
										<cfdefaultcase>
											<cfset varFPago = "Desconocido">
											<cfset varCPago = "PO">
										</cfdefaultcase>
									</cfswitch>

									<cftransaction action="begin">
										<cftry>
											<!--- Arma documento para movimiento bancario --->
											<cfset Num_DocB = numberformat(rsOperacionID.Cadena_id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") & "-" & numberformat(rsOperacionID.Operacion_Id,"000000000")>
											<!--- ID para la tabla de Encabezados --->
											<cfquery name="rsMaxIDEB" DataSource="sifinterfaces">
												select isnull(max(ID_MovimientoB),0) + 1 as MaxID
												  from SIFLD_Movimientos_Bancarios
											</cfquery>

											<cfquery name="insertMovBancario" DataSource="sifinterfaces">
												insert into SIFLD_Movimientos_Bancarios
													(Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento,
													 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen,
													 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus, Concepto)
												values (
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">,
													'LD',
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDEB.MaxID#">,
													'PTB',
													'P',
													<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Factura_Fecha,"yyyy/mm/dd")#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_DocB#">,
													'Deposito por Forma de Pago #varFPago#',
													null,
													null,
													null,
													null,
													abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Pago_Total,'9.99')#">),
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">,
													15,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(varCPago)#">)
											</cfquery>

										<cftransaction action="commit" />
										<cfcatch type="any">
											<cftransaction action="rollback" />
											<!--- Borra los registros para el Encabezado que se habia Insertado--->
											<cfquery name="deleteMovBancarios" datasource="sifinterfaces">
												DELETE SIFLD_Movimientos_Bancarios
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												   AND Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_DocB#">
											</cfquery>
											<cfquery name="deleteTipoPago" datasource="sifinterfaces">
												DELETE SIFLD_Facturas_Tipo_Pago
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												   AND ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
											</cfquery>
											<cfquery name="deleteDetalle" datasource="sifinterfaces">
												DELETE DSIFLD_Facturas_Venta
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												   AND ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
											</cfquery>
											<cfquery name="deleteEncabezado" datasource="sifinterfaces">
												DELETE ESIFLD_Facturas_Venta
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												   AND ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
											</cfquery>
											<cfquery name="deleteBitacora" datasource="sifinterfaces">
												DELETE SIFLD_Bitacora_Procesos
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												   AND Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_ID#">
											</cfquery>
											<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Error al insertar movimiento bancario, Encabezado: #idEnc# - #LABEL#, Error: #cfcatch.Message#">
											<cfthrow message="Error al insertar movimiento bancario, Encabezado: #idEnc# - #LABEL#, Error: #cfcatch.Message#">
										</cfcatch>
										</cftry>
									</cftransaction>
							</cfif>

							<!--- Busca e Inserta los Detalles del Encabezado --->
							<cfset varArgumentsD = {DataSource 	= "#Arguments.DataSource#",
													Factura_Id  = "#rsEVentas.Factura_Id#",
													TipoDoc_Id  = "#rsEVentas.TipoDoc_Id#",
													Emp_Id 		= "#rsEVentas.Emp_Id#",
													Suc_Id 		= "#rsEVentas.Suc_Id#",
													Caja_Id		= "#rsEVentas.Caja_Id#"}>
							<!--- PARA TIPO DOC 10 u 11, NO APLICA, ES UN SERVICIO o RECIBO CXC--->
							<cfif #rsEVentas.TipoDoc_Id# NEQ 10 AND #rsEVentas.TipoDoc_Id# NEQ 11>
								<cfset rsDVentas = getDetalle(argumentCollection = varArgumentsD)>
								<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
									<cfset IDlinea = 1>
								<cfloop query="rsDVentas">
									<cftransaction>
										<cftry>
											<cfquery name="insertDetalle" DataSource="sifinterfaces">
												INSERT INTO DSIFLD_Facturas_Venta
													(Ecodigo, ID_DocumentoV, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item,
													 Cod_Impuesto, Cantidad, Total_Lin, Precio_Unitario, Descuento_Lin,
													 Descuento_Fact, Subtotal_Lin, Impuesto_Lin, Costo_Venta, Cod_Fabricante, Cod_Item, codIEPS,
													 MontoIEPS, afectaIVA, AfectaDevolucion)
												values
													(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">,
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">,
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">,
													 'S',
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Depto_Id#">,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Tipo_Articulo_Id#">,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.IVA_Id#">,
													 <cfqueryparam cfsqltype="cf_sql_float"   value="#rsDVentas.Cantidad#">,
													 abs(convert(decimal(19,2),#rsDVentas.Total#)),
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Precio_Unitario,'9.9999')#">),
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento,'9.9999')#">),
													 0,
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.cantidad * rsDVentas.precio_unitario,'9.9999')#">),
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.IVA,'9.9999')#">),
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.costo_unitario,'9.9999')#">),
													 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDVentas.casa_Id#">,
													 'VENTA',
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.IEPS_Id#">,
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#rsDVentas.IEPS#">),
													 1,
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDVentas.tipoLineaDevolucion#">)
											</cfquery>
											<cfset IDlinea = IDlinea + 1>
											<cftransaction action="commit" />
										<cfcatch type="any">
											<cftransaction action="rollback" />
											<!--- Borra los registros para el Encabezado que se habia Insertado--->
											<cfquery name="deleteTipoPago" datasource="sifinterfaces">
												DELETE SIFLD_Facturas_Tipo_Pago
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												 AND ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
											</cfquery>
											<cfquery name="deleteDetalle" datasource="sifinterfaces">
												DELETE DSIFLD_Facturas_Venta
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												 AND ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
											</cfquery>
											<cfquery name="deleteEncabezado" datasource="sifinterfaces">
												DELETE ESIFLD_Facturas_Venta
												 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
												 AND ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idEnc#">
											</cfquery>
											<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Error al insertar el detalle del encabezado: #idEnc# - #LABEL#, Error: #cfcatch.Message#">
											<cfthrow message="Error al insertar el detalle del encabezado: #idEnc# - #LABEL#, Error: #cfcatch.Message#">
										</cfcatch>
										</cftry>
									</cftransaction>
								</cfloop>
							</cfif>
							</cfif>
						</cfloop> <!--- Termina loop Ventas --->
					</cfif>

					<!--- UPDATES --->
					<cfquery name="updateEnc" DataSource="sifinterfaces">
						Update ESIFLD_Facturas_Venta
						set Estatus = 1
						where Estatus = 15
					</cfquery>
					<cfquery name="updateDet" DataSource="sifinterfaces">
						Update ESIFLD_Facturas_Venta
						set Estatus = 4
						where Estatus = 16
					</cfquery>
					<cfquery name="updateMov" DataSource="sifinterfaces">
						update SIFLD_Movimientos_Bancarios
						set Estatus = 1
						where Estatus = 15
					</cfquery>

					<!--- LIMPIA ESTRUCTURA --->
					<cfset varProc = true>
					<cfset rsMoneda = javacast("null","")>
					<cfset rsMaxIDE = javacast("null","")>
					<cfset rsEVentas = javacast("null","")>

					<!--- Inserta Operacion ID a Bitacora --->
					<cfset varArgumentsBP = {Sistema   = "LD",
											 Empresa   = "#rsOperacionID.Cadena_id#",
											 Sucursal  = "#rsOperacionID.Suc_Id#",
											 Operacion = "#rsOperacionID.Operacion_Id#",
											 Proceso   = "#LABEL#",
											 FechaVenta = "#rsOperacionID.Operacion_Fecha_Apertura#",
											 TipoExtraccion = "#TIPOEXTRACCION#"}>
					<cfset BitacoraProcesos = O.setBitacoraProcesos(argumentCollection=varArgumentsBP)>

				<cfcatch type="any">
					<cfset idEnc = 0>
					<cfquery name="deleteTipoPago" datasource="sifinterfaces">
						delete SIFLD_Facturas_Tipo_Pago
						where ID_DocumentoV in
						(select ID_DocumentoV from ESIFLD_Facturas_Venta where Estatus in (15,16))
					</cfquery>
					<cfquery name="deleteDetalleF" datasource="sifinterfaces">
						delete DSIFLD_Facturas_Venta
						where ID_DocumentoV in
						(select ID_DocumentoV from ESIFLD_Facturas_Venta where Estatus in (15,16))
					</cfquery>
					<cfquery name="deleteEncF" datasource="sifinterfaces">
						delete ESIFLD_Facturas_Venta
						where Estatus in (15,16)
					</cfquery>
					<cfquery name="deleteMovBanc" datasource="sifinterfaces">
						delete SIFLD_Movimientos_Bancarios where Estatus = 15
					</cfquery>

					<!--- Busca Errores de SQL y Parametros --->
					<cfif isdefined("cfcatch.sql")>
						<cfset ErrSQL = cfcatch.sql>
					<cfelse>
						<cfset ErrSQL = "">
					</cfif>
					<cfif isdefined("cfcatch.where")>
						<cfset ErrPAR = cfcatch.where>
					<cfelse>
						<cfset ErrPAR = "">
					</cfif>
					<!--- Inserta Log de Error --->
					<cfset varArgumentsLE = {Sistema    = "LD",
							 Empresa    = "#rsOperacionID.Cadena_id#",
							 Sucursal   = "#rsOperacionID.Suc_Id#",
							 Operacion  = "#rsOperacionID.Operacion_Id#",
							 ErrCaja    = "#ErrCaja#",
							 ErrBodega  = "#ErrBodega#",
							 ErrFactura = "#ErrFactura#",
							 MsgError   = "#cfcatch.Message#",
							 Error_Comp = "#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#",
							 Proceso    = "#LABEL#"}>
					<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
					<cfset varProc = false>
					<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Error al procesar ventas - #LABEL#, Error: #cfcatch.Message#">
				</cfcatch>
				</cftry>
			</cfloop> <!--- Termina loop operaciones --->
		</cfif>
	<cfelse>
		<!--- Inserta Log de Error para ventas de contado--->
		<cfif listFind(Excluir,4)>
			<cfset varArgumentsLE = {Sistema    ="LD",
									 MsgError 	="No hay Cierres de Sucursal para el Dia de Hoy",
									 Error_Comp ="No hay Cierres de Sucursal para el Dia de Hoy",
									 Proceso 	="#LABEL#"}>
			<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
		</cfif>
		<cfset varProc = false>
	</cfif>

	<!--- EXTRACCION DE POLIZAS DE NOTA DE CREDITO (DEVOLUCIONES) --->
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfinvoke component = "ModuloIntegracion.Componentes.Extraccion.LD_Extraccion_NotaCreditoContado"
				  method = "getNotasCreditoDevolucion"
				  DataSource = "ldcom"
				  rsOperacionID	= "#rsOperacionID#"
				  Excluir = "2,4" >
	</cfif>

</cffunction>

<!--- FUNCIONES DE CONSULTA --->
<cffunction name="getEncabezado" access="private" output="true">
	<cfargument name="DataSource" 	type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  	type="string" required="true" default="" />
	<cfargument name="Suc_Id"     	type="string" required="true" default="" />
	<cfargument name="Operacion_Id" type="string" required="true" default="" />
	<cfargument name="Excluir"    	type="string" required="true" default="" />

	<cfquery name="rsEncabezado" datasource="#Arguments.DataSource#">
		SELECT s.Cadena_id,
		       fe.Suc_Id,
		       fe.Emp_Id,
		       fe.Factura_Id,
		       fe.Caja_Id,
		       fe.TipoDoc_Id,
		       Factura_Fecha,
		       CASE
		           WHEN fe.Tipodoc_Id IN (1,8) THEN 'P' /*Contado*/
		           WHEN fe.Tipodoc_Id IN (4) THEN 'C' /*Credito*/
		           WHEN fe.Tipodoc_Id IN (3) THEN
				   CASE
					WHEN isnull(fd.TipoDoc_Factura,0) = 4 THEN 'E' /*Devolucion Credito Sucursal*/
					WHEN coalesce(fe.Factura_Devolucion_Efectivo,0) = 1 THEN 'X' /*Devolucion En Efectivo*/
					ELSE 'D' /*Devolucion*/
				   END
		           WHEN fe.Tipodoc_Id IN (5) THEN 'D' /*Devolucion*/
		           WHEN fe.Factura_Origen = 'EX' THEN 'S' /*Servicio a Domicilio*/
		           ELSE 'P'
		       END AS Tipo_Venta,
		       convert(varchar(15),fe.Cliente_Id) AS Cliente_Id,
 			   round(Factura_Subtotal,2) AS Factura_Subtotal,
			   round(Factura_Descuento,2) AS Factura_Descuento,
			   round(Factura_Impuesto,2) AS Factura_Impuesto,
			   round(Factura_IEPS,2) AS Factura_IEPS,
			   round(Factura_Total,2) AS Factura_Total,
			   round (Factura_Redondeo,2) AS Factura_Redondeo,
			   Vendedor_Id,
			   c.Cliente_Plazo AS Dias_Credito,
			   round(Factura_FP_Efectivo,2) AS Factura_FP_Efectivo, /*Monto en Efectivo*/
			   round(Factura_FP_Tarjeta,2) AS Factura_FP_Tarjeta, /*Monto en Tarjeta*/
			   round(Factura_FP_Cheque, 2) AS Factura_FP_Cheque, /*Monto en Cheque*/
			   round(Factura_FP_Monedero,2) AS Factura_FP_Monedero , /*Monto en Monedero*/
			   round(Factura_FP_NotaCredito,2) AS Factura_FP_NotaCredito, /*Monto en Nota de Credito*/
			   round(Factura_FP_Cupon,2) AS Factura_FP_Cupon, /*Monto en Vales*/
			   round(Factura_FP_Puntos, 2) AS Factura_FP_Puntos, /*Monto en Puntos*/
			   round(Factura_FP_Copago,2) AS Factura_FP_Copago, /*Monto CoPago*/
			   s.suc_cedi AS Tipo_CEDI, /*sucursal CEDI (1) normal (0)*/
			   CASE
				  WHEN fe.contacto_id <= 0 THEN NULL
				  ELSE fe.contacto_id
			   END Subcliente_Id,
			   fe.Factura_Cambio_Efectivo, /* Este Valor es para el manejo de los cambios en tipos de pago <> efectivo */
			   0 AS Comision_Tarjeta,
			   fe.Fiscal_NumeroFactura
			   FROM Factura_Encabezado fe
			   INNER JOIN sucursal s ON fe.suc_id = s.suc_id
			   AND s.Emp_Id = fe.Emp_Id
			   LEFT JOIN cliente c ON fe.cliente_id = c.cliente_id
			   AND fe.Emp_Id = c.Emp_Id
			   LEFT JOIN Factura_Devolucion fd ON fe.Emp_Id = fd.Emp_Id
			   AND fe.Suc_Id = fd.Suc_Id
			   AND fe.Caja_Id = fd.Caja_Id
			   AND fe.Factura_Id = fd.Devolucion_Id
			   WHERE 1=1
			      AND fe.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
				  AND fe.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_id#">
				  AND fe.operacion_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Operacion_id#">
				  AND fe.tipodoc_id not in (#Arguments.Excluir#) /* solo ventas de contado, devoluciones y servicios */
		<!--- RECIBOS DE SERVICIOS --->
		<cfif listFind(Arguments.Excluir,4)>
			UNION ALL
			SELECT s.Cadena_Id,
			       r.Suc_Id,
			       r.Emp_Id,
			       r.Recibo_Id AS Factura_Id,
			       r.Caja_Id,
			       10 AS TipoDoc_Id, <!--- EL 10 ES PARA IDENTIFICAR QUE ES UN RECIBO DE SERVICIO AL MOMENTO DE CONSULTAR SU FORMA DE PAGO --->
			       r.Recibo_Fecha AS Factura_Fecha,
			       'R' AS Tipo_Venta, <!--- R ES PARA IDENTIFICAR QUE ES UN RECIBO DE SERVICIO AL MOMENTO DE VALIDAR LA CUENTA --->
			       convert(varchar(15),r.Cliente_Id) AS Cliente_Id,
			       round(r.pMonto,2) AS Factura_Subtotal,
			       round(0.00,2) AS Factura_Descuento,
			       round(0.00,2) AS Factura_Impuesto,
			       round(0.00,2) AS Factura_IEPS,
			       round(r.Recibo_Total,2) AS Factura_Total,
			       round(0.00,2) AS Factura_Redondeo,
			       r.Vendedor_Id,
			       c.Cliente_Plazo AS Dias_Credito,
			       round(r.Recibo_FP_Efectivo,2) AS Factura_FP_Efectivo, /*Monto en Efectivo*/
				   round(r.Recibo_FP_Tarjeta,2) AS Factura_FP_Tarjeta, /*Monto en Tarjeta*/
				   round(r.Recibo_FP_Cheque, 2) AS Factura_FP_Cheque, /*Monto en Cheque*/
				   round(r.Recibo_FP_Monedero,2) AS Factura_FP_Monedero , /*Monto en Monedero*/
				   round(r.Recibo_FP_NotaCredito,2) AS Factura_FP_NotaCredito, /*Monto en Nota de Credito*/
				   round(r.Recibo_FP_Cupon,2) AS Factura_FP_Cupon, /*Monto en Vales*/
				   round(0.00,2) AS Factura_FP_Puntos, /*Monto en Puntos*/
				   round(0.00,2) AS Factura_FP_Copago, /*Monto CoPago*/
				   s.suc_cedi AS Tipo_CEDI, /*sucursal CEDI (1) normal (0)*/
				   NULL AS Subcliente_Id,
				   round(0.00,2) AS Factura_Cambio_Efectivo, /* Este Valor es para el manejo de los cambios en tipos de pago <> efectivo */
				   round(r.Comision,2) AS Comision_Tarjeta, <!--- Se utiliza para extraer la comision cobrada por servicio --->
				   NULL AS Fiscal_NumeroFactura
			FROM Recibo_Servicio r
			INNER JOIN Sucursal s ON r.Suc_Id = s.Suc_Id
			AND s.Emp_Id = r.Emp_Id
			LEFT JOIN Cliente c ON r.Cliente_Id = c.Cliente_Id
			AND r.Emp_Id = c.Emp_Id
			WHERE 1 = 1
			  AND r.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
			  AND r.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_id#">
			  AND r.Operacion_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Operacion_id#">
		</cfif>
		<!--- RECIBOS CXC --->
		<cfif listFind(Arguments.Excluir,4)>
			UNION ALL
			SELECT s.Cadena_id,
			       rc.Suc_Id,
			       rc.Emp_Id,
			       rc.Recibo_id AS Factura_Id,
			       rc.Caja_id,
			       11 AS TipoDoc_Id, /*Recibos CxC*/
				   rc.Recibo_Fecha AS Factura_Fecha,
				   'Z' AS Tipo_Venta,
				   CONVERT(varchar(15), rc.Cliente_Id) AS Cliente_Id,
				   ROUND(rc.Recibo_Monto, 2) AS Factura_Subtotal,
				   0.00 AS Factura_Descuento,
				   0.00 AS Factura_Impuesto,
				   0.00 AS Factura_IEPS,
				   ROUND(rc.Recibo_Monto, 2) AS Factura_Total,
				   0.00 AS Factura_Redondeo,
				   rc.Cobrador_Id AS Vendedor_Id,
				   c.Cliente_Plazo AS Dias_Credito,
				   ROUND(rc.Recibo_FP_Efectivo, 2) AS Factura_FP_Efectivo, /*Monto en Efectivo*/
				   ROUND(rc.Recibo_FP_Tarjeta, 2) AS Factura_FP_Tarjeta, /*Monto en Tarjeta*/
				   ROUND(rc.Recibo_FP_Cheque, 2) AS Factura_FP_Cheque, /*Monto en Cheque*/
				   ROUND(rc.Recibo_FP_Monedero, 2) AS Factura_FP_Monedero, /*Monto en Monedero*/
				   ROUND(rc.Recibo_FP_NotaCredito, 2) AS Factura_FP_NotaCredito, /*Monto en Nota de Credito*/
				   ROUND(rc.Recibo_FP_Cupon, 2) AS Factura_FP_Cupon, /*Monto en Vales*/
				   0.00 AS Factura_FP_Puntos, /*Monto en Puntos*/
				   0.00 AS Factura_FP_Copago, /*Monto CoPago*/
				   s.Suc_Cedi AS Tipo_CEDI, /*sucursal CEDI (1) normal (0)*/
				   NULL AS Subcliente_Id,
				   0.00 AS Factura_Cambio_Efectivo, /* Este Valor es para el manejo de los cambios en tipos de pago <> efectivo */
				   0.00 AS Comision_Tarjeta,
				   NULL AS Fiscal_NumeroFactura
			FROM Cxc_Recibo rc
			INNER JOIN Sucursal s ON s.Suc_Id = rc.Suc_Id
			AND s.Emp_Id = rc.Emp_Id
			LEFT JOIN Cliente c ON rc.Cliente_Id = c.Cliente_Id
			AND rc.Emp_Id = c.Emp_Id
			WHERE rc.Emp_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
			  AND rc.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_id#">
			  AND rc.Operacion_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Operacion_id#">
		</cfif>
			ORDER BY Cadena_id,
			         Suc_Id,
			         Caja_Id,
			         Factura_Id,
			         Tipo_Venta
	</cfquery>
	<cfreturn rsEncabezado>

</cffunction>
<cffunction name="getDetalle" access="private" output="true">
	<cfargument name="DataSource" type="string"  required="True" default="" />
	<cfargument name="Factura_Id" type="string"  required="True" default="" />
	<cfargument name="TipoDoc_Id" type="string"  required="True" default="" />
	<cfargument name="Emp_Id" 	  type="string"  required="True" default="" />
	<cfargument name="Suc_Id"     type="string"  required="True" default="" />
	<cfargument name="Caja_Id" 	  type="string"  required="True" default="" />

	<cfquery name="rsDetalle" datasource="#Arguments.DataSource#">
		SELECT fd.Factura_Id,
		       0 AS Tipo_Articulo_Id,
		       a.Depto_Id,
		       0 AS Casa_Id,
		       1 AS Cantidad,
		       ROUND(ISNULL(SUM(Detalle_Cantidad * Detalle_Impuesto_Monto), 0), 2) AS IVA,
		       ROUND(ISNULL(SUM(Detalle_Cantidad * Detalle_IEPS_Monto), 0), 2) AS IEPS,
		       ROUND(ISNULL(SUM((Detalle_Total * Detalle_Cantidad) - (Detalle_Cantidad * Detalle_IEPS_Monto)), 0), 2) AS Total,
		       CASE
		           WHEN COALESCE(Detalle_Impuesto_Monto, 0) > 0 THEN 1 <!--- 1 - IVA 16% --->
		           ELSE 0 <!--- 0 - IVA 0% --->
		       END AS IVA_Id,
		       CASE
		           WHEN COALESCE(Detalle_IEPS_Monto, 0) > 0 THEN
		                  COALESCE((SELECT COALESCE(fi.Impuesto_Id,0)
		                   FROM Factura_Detalle_Impuestos fi
		                   INNER JOIN Impuesto i ON fi.Emp_Id = i.Emp_Id
		                   AND fi.Impuesto_Id = i.Impuesto_Id
		                   AND i.Impuesto_Tipo = 'IEPS'
		                   AND fi.Emp_Id = fd.Emp_Id
		                   AND fi.Suc_Id = fd.Suc_Id
		                   AND fi.Caja_Id = fd.Caja_Id
		                   AND fd.Factura_Id = fi.Factura_Id
		                   AND fd.Tipodoc_Id = fi.Tipodoc_Id
		                   AND fd.Articulo_Id = fi.Articulo_Id
		                   AND fd.Detalle_Id = fi.Detalle_Id),0)
		           ELSE 0
		       END AS IEPS_Id,
		       ROUND(ISNULL(SUM(Detalle_Precio_Unitario * Detalle_Cantidad), 0), 2) AS Precio_Unitario,
		       ROUND(ISNULL(SUM(Detalle_Descuento_Monto * Detalle_Cantidad), 0), 2) AS Descuento,
		       ROUND(ISNULL(SUM(Detalle_Costo_Unitario * Detalle_Cantidad), 0), 2) AS Costo_Unitario,
				0 AS tipoLineaDevolucion <!--- PARA DISTINGUIRLA EN LAS DEVOLUCIONES --->
		FROM Factura_Detalle fd
		INNER JOIN Articulo a ON fd.Articulo_Id = a.Articulo_Id
		AND a.Emp_Id = fd.Emp_Id
		WHERE fd.Emp_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Emp_Id#">
		  AND fd.Factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Factura_Id#">
		  AND fd.Tipodoc_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoDoc_Id#">
		  AND fd.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
		  AND fd.Caja_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Caja_Id#">
		GROUP BY fd.Factura_Id,
		         a.Depto_Id,
		         fd.Detalle_Impuesto_Monto,
		         fd.Detalle_IEPS_Monto,
		         fd.Emp_Id,
		         fd.Suc_Id,
		         fd.Caja_Id,
		         fd.Tipodoc_Id,
		         fd.Articulo_Id,
		         fd.Detalle_Id
<!--- SELECT DISTINCT fd.Factura_Id, 0 as Tipo_Articulo_Id, a.Depto_Id, 0 as Casa_Id, 1 as Cantidad,
				round(isnull(sum(Detalle_Cantidad * Detalle_Impuesto_Monto),0),2) as IVA,
				round(isnull(sum(Detalle_Cantidad * Detalle_IEPS_Monto),0),2) as IEPS,
				round(isnull(sum((Detalle_Total * Detalle_Cantidad) - (Detalle_Cantidad * Detalle_IEPS_Monto)),0),2) as Total,
				isnull(i.Impuesto_id,0) as IVA_Id,
				isnull(ii.Impuesto_id,0) as IEPS_Id,
				round(isnull(sum(Detalle_Precio_Unitario * Detalle_Cantidad),0),2) as Precio_Unitario,
				round(isnull(sum(Detalle_Descuento_Monto * Detalle_Cantidad),0),2) as Descuento,
				round(isnull(sum(Detalle_Costo_Unitario * Detalle_Cantidad),0),2) as Costo_Unitario,
				0 AS tipoLineaDevolucion <!--- PARA DISTINGUIRLA EN LAS DEVOLUCIONES --->
		FROM Factura_Detalle fd
			INNER JOIN Articulo a
			on fd.Articulo_Id = a.Articulo_Id and a.Emp_Id = fd.Emp_Id
			LEFT JOIN Factura_Detalle_Impuestos i
				INNER JOIN Impuesto iva
				on i.Emp_Id = iva.Emp_Id
				and i.Impuesto_Id = iva.Impuesto_Id
				and iva.Impuesto_Tipo = 'IVA'
			ON i.Emp_Id = fd.Emp_Id and i.Suc_Id = fd.Suc_Id and i.Caja_Id = fd.Caja_Id
				and fd.Factura_Id = i.Factura_Id and fd.Tipodoc_Id = i.Tipodoc_Id
				and fd.Articulo_Id = i.Articulo_Id
				and fd.Detalle_Id = i.Detalle_Id
			LEFT JOIN Factura_Detalle_Impuestos ii
				INNER JOIN Impuesto ieps
				on ii.Emp_Id = ieps.Emp_Id
				and ii.Impuesto_Id = ieps.Impuesto_Id
				and ieps.Impuesto_Tipo = 'IEPS'
			ON ii.Emp_Id = fd.Emp_Id and ii.Suc_Id = fd.Suc_Id and ii.Caja_Id = fd.Caja_Id
			and fd.Factura_Id = ii.Factura_Id and fd.Tipodoc_Id = ii.Tipodoc_Id
			and fd.Articulo_Id = ii.Articulo_Id
			and fd.Detalle_Id = ii.Detalle_Id
		WHERE  1=1
		  and  fd.Emp_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Emp_Id#">
		  and  fd.Factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Factura_Id#">
		  and  fd.Tipodoc_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoDoc_Id#">
		  and  fd.Suc_Id 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
		  and  fd.Caja_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Caja_Id#">
		GROUP BY fd.Emp_Id, fd.Suc_Id, fd.Caja_Id,fd.Factura_Id,a.Depto_Id,i.Impuesto_Id,ii.Impuesto_Id --->
		<!--- SERVICIOS LOCALES (PROCONSA) --->
		UNION ALL
		SELECT fs.Factura_Id,
		       0 AS Tipo_Articulo_Id,
		       0 AS Depto_Id,
		       0 AS Casa_Id,
		       1 AS Cantidad,
		       ROUND(ISNULL(SUM(Detalle_Monto * (i.Impuesto_Porcentaje / 100)), 0), 2) AS IVA,
		       0.00 AS IEPS,
		       ROUND(fs.Detalle_Total, 2) AS Total,
		       i.Impuesto_Id AS IVA_Id,
		       0 AS IEPS_Id,
		       ROUND(fs.Detalle_Monto, 2) AS Precio_Unitario,
		       0.0 AS Descuento,
		       ROUND(fs.Detalle_Monto, 2) AS Costo_Unitario,
		       1 AS tipoLineaDevolucion <!--- PARA DISTINGUIRLA EN LAS DEVOLUCIONES, 1 SE IGNORA --->
		FROM Factura_Detalle_Servicio fs
		INNER JOIN PV_Servicio s ON fs.Servicio_Id = s.Servicio_Id
		AND fs.Emp_Id = s.Emp_Id
		INNER JOIN PV_Servicio_Impuesto psi ON s.Servicio_Id = psi.Servicio_Id
		AND s.Emp_Id = psi.Emp_Id
		INNER JOIN Impuesto i ON psi.Impuesto_Id = i.Impuesto_Id
		AND psi.Emp_Id = i.Emp_Id
		WHERE fs.Emp_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Emp_Id#">
		  AND fs.Factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Factura_Id#">
		  AND fs.Tipodoc_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoDoc_Id#">
		  AND fs.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
		  AND fs.Caja_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Caja_Id#">
		GROUP BY fs.Factura_Id,
		         fs.Detalle_Total,
		         i.Impuesto_Id,
		         fs.Detalle_Monto
	</cfquery>
	<cfreturn rsDetalle>
</cffunction>
<cffunction name="getFormaPago" access="private" output="true">
	<cfargument name="DataSource" type="string"  required="True" default="" />
	<cfargument name="Factura_Id" type="string"  required="True" default="" />
	<cfargument name="Emp_Id" 	  type="string"  required="True" default="" />
	<cfargument name="Suc_Id"     type="string"  required="True" default="" />
	<cfargument name="Caja_Id" 	  type="string"  required="True" default="" />
	<cfargument name="TipoDoc_id" type="string"  required="True" default="" />

	<cfif #TipoDoc_id# EQ 10>
		<!--- SE TRATA DE UN SERVICIO (CFE, SKY, ETC, ETC) --->
		<cfquery name="rsFormaPago" datasource="#Arguments.DataSource#">
			SELECT fr.Tipo_Id,
			       fr.Moneda_Id,
			       fr.Tarjeta_id,
			       fr.Pago_Total,
			       1 as Pago_Total_Tipo_Cambio,
			       t.Tarjeta_Porcentaje,
			       0 AS Cupon_Id
			FROM Recibo_Servicio_Forma_Pago fr
			LEFT JOIN Tarjeta t ON fr.Emp_Id = t.Emp_Id
			AND fr.Tarjeta_Id = t.Tarjeta_Id
			WHERE 1=1
			AND fr.Emp_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Emp_Id#">
				AND fr.Suc_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Suc_id#">
				AND fr.Caja_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Caja_Id#">
				AND fr.Recibo_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Factura_Id#">
		</cfquery>
	<cfelseif #TipoDoc_id# EQ 11>
		<!--- SE TRATA DE RECIBOS CXC --->
		<cfquery name="rsFormaPago" datasource="#Arguments.DataSource#">
			SELECT CASE
			           WHEN Recibo_FP_Efectivo > 0 THEN 1 /*Efectivo*/
			           WHEN Recibo_FP_Tarjeta > 0 THEN 2 /*Tarjeta*/
			           WHEN Recibo_FP_Cupon > 0 THEN 3 /*Cupones*/
			           WHEN Recibo_FP_Cheque > 0 THEN 4 /*Cheque*/
			           WHEN Recibo_FP_NotaCredito > 0 THEN 6 /*Nota de Credito*/
			           WHEN Recibo_FP_Monedero > 0 THEN 7 /*Monedero*/
			           WHEN Recibo_FP_Transferencia > 0 THEN 8 /*Transferencia*/
			       END AS Tipo_Id,
			       rc.Moneda_id,
			       0 AS Tarjeta_Id,
			       CASE
			           WHEN Recibo_FP_Efectivo > 0 THEN Recibo_FP_Efectivo /*Efectivo*/
			           WHEN Recibo_FP_Tarjeta > 0 THEN Recibo_FP_Tarjeta /*Tarjeta*/
			           WHEN Recibo_FP_Cupon > 0 THEN Recibo_FP_Cupon /*Cupones*/
			           WHEN Recibo_FP_Cheque > 0 THEN Recibo_FP_Cheque /*Cheque*/
			           WHEN Recibo_FP_NotaCredito > 0 THEN Recibo_FP_NotaCredito /*Nota de Credito*/
			           WHEN Recibo_FP_Monedero > 0 THEN Recibo_FP_Monedero /*Monedero*/
			           WHEN Recibo_FP_Transferencia > 0 THEN Recibo_FP_Transferencia /*Transferencia*/
			           ELSE Recibo_FP_Efectivo
			       END AS Pago_Total,
			       1 AS Pago_Total_Tipo_Cambio,
			       0 AS Tarjeta_Porcentaje,
			       0 AS Cupon_Id
			FROM Cxc_Recibo rc
			WHERE rc.Emp_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Emp_Id#">
			  AND rc.Suc_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Suc_id#">
			  AND rc.Caja_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Caja_Id#">
			  AND rc.Recibo_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Factura_Id#">
		</cfquery>
	<cfelse>
		<!--- FACTURA NORMAL --->
		<cfquery name="rsFormaPago" datasource="#Arguments.DataSource#">
			SELECT	f.Tipo_Id,
				    f.Moneda_Id,
			        f.Tarjeta_Id,
			        f.Pago_Total,
					1 as Pago_Total_Tipo_Cambio,
					Tarjeta_Porcentaje,
					0 as Cupon_Id
			FROM	Factura_Forma_Pago f
					LEFT JOIN Tarjeta t
						ON f.Emp_Id = t.Emp_Id AND f.Tarjeta_Id = t.Tarjeta_Id
			WHERE	1=1
				AND f.Emp_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Emp_Id#">
				AND f.Suc_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Suc_id#">
				AND f.Caja_Id 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Caja_Id#">
				AND f.Factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Factura_Id#">
				AND f.TipoDoc_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoDoc_id#">
		</cfquery>
	</cfif>


	<cfreturn rsFormaPago>
</cffunction>
</cfcomponent>