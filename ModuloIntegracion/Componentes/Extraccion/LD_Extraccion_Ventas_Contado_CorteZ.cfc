<!---
	Se realiza la extracci?n de las ventas de contado de LD, pero ?nicamente consultamos la tabla (Sucursal_Operacion_Corte)
	que se consulta al generar el Corte Z.
	@Autor: Eduardo Gonzalez Sarabia
	@Version: Creaci?n 28/12/2017 12:28 hrs
	 --->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="false">
<cffunction name="getVentasContadoCorteZ" access="public" output="false">
	<cfargument name="rsOperacionID" type="query"  required="True" default="" />
	<cfargument name="DataSource" 	 type="string" required="True" default="" />
	<cfsetting requestTimeout="7500">

	<!--- SE OBTIENE EL NOMBRE DE LA BASE DE DATOS DEL DATASOURCE SIFINTERFACES --->
	<cfset databaseNameInt = getDatabaseName("sifinterfaces")>

	<cfset LABEL = "VENTASCONTADO"> 

	<!--- Inicializaci?n del componente Operaciones --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones" method="init" returnvariable="O" />

	<!--- INICIA LOOP OPERACIONES --->
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
	<cfset Equiv = ConversionEquivalencia ('LD', 'CADENA', rsOperacionID.Cadena_Id, rsOperacionID.Cadena_Id, 'Cadena')>
	<cfset varEcodigo = Equiv.EQUidSIF>

	<cfset lVarPorcentajeIvaGravado = getPorcentajeIVA(rsOperacionID.Emp_Id)>

	<!--- SE OBTIENE EL CLIENTE DE CONTADO DE LOS PARAMETROS --->
	<cfquery name="rsGetCteContado" datasource="sifinterfaces">
		SELECT Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '00003'
		<cfif isDefined("session.ecodigo")>
			AND Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		<cfelse>
  			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
		</cfif>
	</cfquery>
	
	<!--- SE OBTIENE Parametro Para saber si utiliza Plan de Lealtad --->
	<cfquery name="rsGetPlanLealtad" datasource="sifinterfaces">
		SELECT Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '10006'
		<cfif isDefined("session.ecodigo")>
			AND Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		<cfelse>
  			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
		</cfif>
	</cfquery>
	<cfset planLealtad = (rsGetPlanLealtad.RecordCount GT 0 AND rsGetPlanLealtad.Pvalor EQ "1")>
	
	<!--- SE OBTIENE Parametro Para saber si se generan operaciones de refacturacion --->
	<cfquery name="rsGetGenReFact" datasource="sifinterfaces">
		SELECT Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '10007'
		<cfif isDefined("session.ecodigo")>
			AND Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		<cfelse>
  			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
		</cfif>
	</cfquery>
	<cfset genRefact = (rsGetGenReFact.RecordCount GT 0 AND rsGetGenReFact.Pvalor EQ "1")>
	
	<!--- SE OBTIENE Parametro Para saber si se generan operaciones de apartados --->
	<cfquery name="rsGetGenApartado" datasource="sifinterfaces">
		SELECT Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '10008'
		<cfif isDefined("session.ecodigo")>
			AND Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		<cfelse>
  			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
		</cfif>
	</cfquery>
	<cfset genApartado = (rsGetGenApartado.RecordCount GT 0 AND rsGetGenApartado.Pvalor EQ "1")>

	<cfif rsGetCteContado.RecordCount GT 0 AND rsGetCteContado.Pvalor NEQ "">
		<cfset lvarCteContado = #rsGetCteContado.Pvalor#>
	<cfelse>
		<cfquery datasource="sifinterfaces">
			INSERT INTO SIFLD_Errores
									(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, Ecodigo, Usuario)
			VALUES
				  ('CG_Ventas',
                   'SIFLD_Ventas_Contado_CorteZ',
                   0,
				   'No se ha configurado el cliente de contado en los Parametros Generales Interfaz!',
				   'Se debe dar de alta el Pcodigo 00003.',
				   <cfif isDefined("session.ecodigo")>
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfelse>
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
					</cfif>
			       'ldInterfaz')
		</cfquery>
	</cfif>
	
		<cfif isDefined("lvarCteContado")>
			<cfloop query="rsOperacionID">


				<!--- INFO DEL CORTE Z --->
				<cfset rsGetInfoCorteZ = getCorteZ(Arguments.DataSource,
												   rsOperacionID.Emp_Id,
												   rsOperacionID.Suc_Id,
												   rsOperacionID.Operacion_Id,
												   #lVarPorcentajeIvaGravado#,
												   planLealtad,
												   genRefact,
												   genApartado)>

				<!--- MONTOS DE INGRESOS Vales y Tarjeta (FULL) --->
				<cfset getIngresosVlesTjeta = getIngresosValesTjeta(Arguments.DataSource,
															        rsOperacionID.Emp_Id,
															        rsOperacionID.Suc_Id,
												                    rsOperacionID.Operacion_Id)>
	
				<cfset getDevolucionesVlesTjeta = getDevolucionesValesTjeta(Arguments.DataSource,
															        rsOperacionID.Emp_Id,
															        rsOperacionID.Suc_Id,
												                    rsOperacionID.Operacion_Id)>

				<!--- MONTO INGRESOS VALES - TARJETA EXENTOS--->
				<cfset lvarIngresosValTarE = 0>
				<cfif getIngresosVlesTjeta.RecordCount GT 0 AND getIngresosVlesTjeta.ingresosIvaExento GT 0>
					<cfset lvarIngresosValTarE = getIngresosVlesTjeta.ingresosIvaExento>
				</cfif>
				<!--- MONTO INGRESOS VALES - TARJETA GRAVADOS--->
				<cfset lvarIngresosValTarG = 0>
				<cfif getIngresosVlesTjeta.RecordCount GT 0 AND getIngresosVlesTjeta.ingresosIvaGravado GT 0>
					<cfset lvarIngresosValTarG = getIngresosVlesTjeta.ingresosIvaGravado>
				</cfif>
				<!--- MONTO DEVOLUCIONES VALES GRAVADO--->
				<cfset lvarDevolucionesValTarG = 0>
				<cfset lvarDevolucionesValTarE = 0>
				<cfset lvarDevolucionesValIVA16 = 0>
				<cfif getDevolucionesVlesTjeta.RecordCount GT 0 AND getDevolucionesVlesTjeta.Gravado GT 0>
					<cfset lvarDevolucionesValTarG = getDevolucionesVlesTjeta.Gravado>
				</cfif>
				<!--- MONTO DEVOLUCIONES VALES EXENTO--->
				<cfif getDevolucionesVlesTjeta.RecordCount GT 0 AND getDevolucionesVlesTjeta.Excento GT 0>
					<cfset lvarDevolucionesValTarE = getDevolucionesVlesTjeta.Excento>
				</cfif>
				<!--- MONTO IVA16 DEVOLUCIONES VALES --->
				<cfif getDevolucionesVlesTjeta.RecordCount GT 0 AND getDevolucionesVlesTjeta.Impuesto GT 0>
					<cfset lvarDevolucionesValIVA16 = getDevolucionesVlesTjeta.Impuesto>
				</cfif>


				<!--- INFO DE IMPUESTOS Vales y Tarjeta (FULL) --->
				<cfset getRsImpuestos = getImpuestosValesTarjeta(Arguments.DataSource,
																 rsOperacionID.Emp_Id,
																 rsOperacionID.Suc_Id,
												                 rsOperacionID.Operacion_Id)>

				<!--- MONTO IVA VALES - TARJETA --->
				<cfset lvarIvaValTar = 0>
				<cfif getRsImpuestos.RecordCount GT 0 AND getRsImpuestos.montoIvaGravado GT 0>
					<cfset lvarIvaValTar = getRsImpuestos.montoIvaGravado>
				</cfif>
				<!--- MONTO IEPS VALES - TARJETA --->
				<cfset lvarIepsValTar = 0>
				<cfif getRsImpuestos.RecordCount GT 0 AND getRsImpuestos.montoIeps GT 0>
					<cfset lvarIepsValTar = getRsImpuestos.montoIeps>
				</cfif>
				
				<cfif rsGetInfoCorteZ.recordcount GT 0>
					<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Cadena_Id,"00") &
					                 numberformat(rsOperacionID.Suc_Id,"0000") & "-"
					                 & numberformat(rsOperacionID.Operacion_Id,"000000000")>
					<cftransaction>
						<cftry>
							<!--- INSERT DE DATOS --->
							<cfquery datasource="sifinterfaces">
								INSERT INTO SIFLD_Ventas_Contado_CorteZ (
									Ecodigo, NumeroDocumento, FechaVenta, FechaInicioProceso, Estatus,
									Cliente, IngresosIVA0, IngresosIVA16, RecibosCxC, ServiciosExternos,
									ComisionServExt, Ieps3, Ieps8, DevolucionIeps3, DevolucionIeps8,
									IvaTrasladado16C, DescLinea, IvaTrasladado16D,
									Pago_EfectivoLocal, Pago_EfectivoExt, PagoTarjeta, PagoCupon, PagoCheque,
									PagoNC, PagoTransferencia, Pago_ValesDespensa, AlmacenCostoVentas0, AlmacenCostoVentas16,
									AlmacenCostoVentasDev0, AlmacenCostoVentasDev16, DevolucionDeVentas0,
									DevolucionDeVentas16, DevolucionSobreVentas, Empresa, Sucursal, OperacionId
									<!--- LEALTAD --->
									<cfif planLealtad>
										, Monedero_Acumula <!--- Generacion --->
										, Devolucion_Monedero_Acumula <!--- Devolucion --->
										, Operacion_FP_Monedero <!--- Aplicacion --->
										, Operacion_Devolucion_Monedero
									</cfif>
									<!--- Refacturacion --->
									<cfif genRefact>
										, Operacion_Fiscal_Devolucion <!--- Devolucion --->
										, Operacion_Refactura <!--- Refacturacion --->
									</cfif>
									<!--- Apartados --->
									<cfif genApartado>
										, Operacion_Recibos <!--- Devolucion --->
										, Operacion_Recibo_Apartado <!--- Refacturacion --->
										, Operacion_Apartado_Cancela <!--- Refacturacion --->
									</cfif>
								)
								VALUES (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Cadena_id#">,
								        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
								        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">,
								        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								        <cfqueryparam cfsqltype="cf_sql_numeric" value="1">,<!--- 1 - Estatus inicial --->
									    <cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCteContado#">, <!--- DEFAULT, CLIENTE CONTADO --->
								 	    <!--- abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.IngresosIVA0,'9.99')#">),
								 	    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.IngresosIVA16,'9.99')#">), --->
								 	    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.IngresosIVA0 - (lvarIngresosValTarE),'9.99')#">),
								 	    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.IngresosIVA16 - (lvarIngresosValTarG),'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.RecibosCxC,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.ServiciosExternos,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.ComisionServExt,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Ieps3,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Ieps8 - lvarIepsValTar,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.DevolucionIeps3,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.DevolucionIeps8,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.IvaTrasladado16C - lvarIvaValTar,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.DescLinea,'9.99')#">),
									    <!--- abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.IvaTrasladado16D - (lvarDevolucionesValIVA16),'9.99')#">), --->
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(lvarDevolucionesValIVA16,'9.99')#">),
									    <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Pago_EfectivoLocal,'9.99')#">,
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Pago_EfectivoExt,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.PagoTarjeta,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.PagoCupon,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.PagoCheque,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.PagoNC,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.PagoTransferencia,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.PagoValesDespensa,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.AlmacenCostoVentas0,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.AlmacenCostoVentas16,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.AlmacenCostoVentasDev0,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.AlmacenCostoVentasDev16,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.DevolucionDeVentas0 - (lvarDevolucionesValTarE),'9.99')#">),
									    <!--- abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.DevolucionDeVentas16 - (lvarDevolucionesValTarG),'9.99')#">), --->
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(lvarDevolucionesValTarG,'9.99')#">),
									    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.DevolucionSobreVentas,'9.99')#">),
									    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">,
									    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">,
									    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">
										<!--- LEALTAD --->
										<cfif planLealtad>
											, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Monedero_Acumula,'9.99')#">)
									    	, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Devolucion_Monedero_Acumula,'9.99')#">)
									    	, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_FP_Monedero,'9.99')#">)
											, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_Devolucion_Monedero,'9.99')#">)
										</cfif>
										<!--- REFACTURACION --->
										<cfif genRefact>
											, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_Fiscal_Devolucion,'9.99')#">)
									    	, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_Refactura,'9.99')#">)
										</cfif>
										<!--- Apartados --->
										<cfif genApartado>
											, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_Recibos,'9.99')#">)
											, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_Recibo_Apartado,'9.99')#">)
											, abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetInfoCorteZ.Operacion_Apartado_Cancela,'9.99')#">)
										</cfif>
								)
							</cfquery>

							<!--- Inserta Operacion ID a Bitacora --->
							<cfset varArgumentsBP = {Sistema   = "LD",
													 Empresa   = "#rsOperacionID.Cadena_id#",
													 Sucursal  = "#rsOperacionID.Suc_Id#",
													 Operacion = "#rsOperacionID.Operacion_Id#",
													 Proceso   = "#LABEL#",
													 FechaVenta = "#rsOperacionID.Operacion_Fecha_Apertura#",
													 TipoExtraccion = "EXPRESS"}>
							<cfset BitacoraProcesos = O.setBitacoraProcesos(argumentCollection=varArgumentsBP)>

							<cftransaction action="commit" />
							<cfcatch type="any">
								<cftransaction action="rollback" />
								<cflog file="Log_Extraccion_VtasContado_CorteZ"
								       application="no"
								       text="Error al insertar el corte Z: #Num_Doc#, Error: #cfcatch.Message#">
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
										 ErrCaja    = "No aplica",
										 ErrBodega  = "No aplica",
										 ErrFactura = "No aplica",
										 MsgError   = "#cfcatch.Message#",
										 Error_Comp = "#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#",
										 Proceso    = "#LABEL#"}>
								<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
								<!---<cfrethrow>--->
							</cfcatch>
						</cftry>
					</cftransaction>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	<!--- TERMINA LOOP OPERACIONES --->
</cffunction>

<!--- OBTIENE DATOS CORTE Z --->
<cffunction name="getCorteZ" access="private" output="true">
	<cfargument name="DataSource" 	type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  	type="string" required="true" default="" />
	<cfargument name="Suc_Id"     	type="string" required="true" default="" />
	<cfargument name="Operacion_Id" type="string" required="true" default="" />
	<cfargument name="PorcentajeIva" type="string" required="true" default="16" />
	<cfargument name="planLealtad" type="boolean" required="false" default="false" />
	<cfargument name="genRefact" type="boolean" required="false" default="false" />
	<cfargument name="genApartado" type="boolean" required="false" default="false" />

	<cfquery name ="rsCuentaDocumentos" datasource="sifinterfaces">
		SELECT COUNT(e.NumeroDocumento) CuentaDocumentos
				    	 FROM #databaseNameInt#..SIFLD_Ventas_Contado_CorteZ e
						 WHERE (e.NumeroDocumento LIKE 'V-%'
				    	 AND e.NumeroDocumento LIKE CONCAT('%0', #Arguments.Operacion_Id#)
				    	 AND e.NumeroDocumento LIKE CONCAT('%0', #Arguments.Suc_Id#, '-%'))
	</cfquery>

	<cfquery name="getRsGetCorteZ" datasource="#Arguments.DataSource#">
		SELECT (Operacion_Contado_Exento + Operacion_Express_Exento + Operacion_Servicio_Exento) AS IngresosIVA0,
		       (Operacion_Contado_Gravado + Operacion_Express_Gravado + (ABS(Operacion_Servicio - (Operacion_Servicio / (#PorcentajeIva * 100 + 1#))))) AS IngresosIVA16,
		       Operacion_Recibos_CxC AS RecibosCxC,
		       <!--- COALESCE((Operacion_FP_Vale_Credito + Operacion_FP_Tarjeta_Departamental),0) AS montoValesTarjeta, --->
		       Operacion_Servicio_Externo AS ServiciosExternos,
		       Operacion_Recibos_Comision AS ComisionServExt,
		       0 AS Ieps3,
		       Operacion_Contado_IEPS AS Ieps8,
			   0 AS DevolucionIeps3,
			   ABS(Operacion_Devolucion_Contado_IEPS) DevolucionIeps8,
		       (Operacion_Contado_Impuesto + Operacion_Express_Impuesto + (Operacion_Servicio / (#PorcentajeIva * 100 + 1#))) AS IvaTrasladado16C,
		       (ABS(Operacion_Contado_Descuento) + ABS(Operacion_Express_Descuento) + ABS(Operacion_Servicio_Descuento)) AS DescLinea,
		       (ABS(Operacion_Devolucion_Express_Impuesto) + ABS(Operacion_Devolucion_Contado_Impuesto)) AS IvaTrasladado16D,
		       Operacion_FP_Efectivo AS Pago_EfectivoLocal,
		       Operacion_FP_Extranjera AS Pago_EfectivoExt,
		       Operacion_FP_Tarjeta AS PagoTarjeta,
		       Operacion_FP_Cupon + Operacion_Devolucion_Cupon AS PagoCupon,
		       Operacion_FP_Cheque AS PagoCheque,
		       Operacion_FP_NotaCredito AS PagoNC,
		       Operacion_FP_Transferencia AS PagoTransferencia,
		       Operacion_FP_Vale AS PagoValesDespensa,
		       (Operacion_Contado_Costo_Exento + Operacion_Express_Costo_Exento + Operacion_Contado_Costo_Servicio_Exento) AS AlmacenCostoVentas0,
		       (Operacion_Contado_Costo_Gravado + Operacion_Express_Costo_Gravado + Operacion_Contado_Costo_Servicio_Gravado) AS AlmacenCostoVentas16,
		       (ABS(Operacion_Devolucion_Costo_Contado_Exento) + ABS(Operacion_Devolucion_Costo_Express_Exento) + ABS(Operacion_Devolucion_Costo_Servicio_Exento)) AS AlmacenCostoVentasDev0,
		       <!---(ABS(Operacion_Devolucion_Costo_Gravado) --->
			   (ABS(Operacion_Devolucion_Costo_Contado_Gravado) + ABS(Operacion_Devolucion_Costo_Express_Gravado) + ABS(Operacion_Devolucion_Costo_Servicio_Gravado)) AS AlmacenCostoVentasDev16,
		       (ABS(Operacion_Devolucion_Contado_Exento) + ABS(Operacion_Devolucion_Express_Exento) + ABS(Operacion_Devolucion_Servicio_Exento)) AS DevolucionDeVentas0,
		       (ABS(Operacion_Devolucion_Contado_Gravado) + ABS(Operacion_Devolucion_Express_Gravado) + ABS(Operacion_Devolucion_Servicio_Gravado)) AS DevolucionDeVentas16,
		       COALESCE((ABS(Operacion_Devolucion_Contado_NC) + ABS(Operacion_Devolucion_Express_NC)),0) AS DevolucionSobreVentas
			   <!--- LEALTAD --->
			   	<cfif arguments.planLealtad>
			   	    , COALESCE(Monedero_Acumula,0) as Monedero_Acumula <!--- Generacion --->
					, COALESCE(Devolucion_Monedero_Acumula,0) as Devolucion_Monedero_Acumula <!--- Devolucion --->
					, COALESCE(Operacion_FP_Monedero,0) as Operacion_FP_Monedero <!--- Aplicacion --->
					, COALESCE(Operacion_Devolucion_Monedero,0) as  Operacion_Devolucion_Monedero<!--- Devolucion Plan de Lealtad--->
				</cfif>
			   <!--- Refacturacion --->
			   	<cfif arguments.genRefact>
			   	    , Operacion_Fiscal_Devolucion 
					, Operacion_Refactura
				</cfif>
				<cfif arguments.genApartado>
					, Operacion_Recibos
					, operacion_fp_apartado Operacion_Recibo_Apartado
					, Operacion_Apartado_Cancela
				</cfif>
		FROM Sucursal_Operacion_Corte
		WHERE Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
		  AND Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
		  AND Operacion_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Operacion_Id#">
		  AND #rsCuentaDocumentos.CuentaDocumentos# = 0
	</cfquery>
	<cfreturn getRsGetCorteZ>
</cffunction>

<!--- Obtiene los los ingresos sin impuestos correspondientes a tipo de pago
      Vale y Tarjeta departamental --->
<cffunction name="getIngresosValesTjeta" access="private" output="true">
	<cfargument name="DataSource" 	type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  	type="string" required="true" default="" />
	<cfargument name="Suc_Id"     	type="string" required="true" default="" />
	<cfargument name="Operacion_Id" type="string" required="true" default="" />

	<cftry>
		<cfquery name="getIngresosVlesTjeta" datasource="#Arguments.DataSource#">
			SELECT
			  COALESCE(SUM(ingresosIvaExento),0) AS ingresosIvaExento,
			  COALESCE(SUM(ingresosIvaGravado),0) AS ingresosIvaGravado
			FROM (SELECT
			  CASE
			    WHEN UPPER(COALESCE(i.Impuesto_Tipo, '')) LIKE '%IVA%' AND
			      i.Impuesto_Porcentaje = 0 THEN SUM(fp.Impuesto_SubTotal)
			    ELSE 0
			  END AS ingresosIvaExento,
			  CASE
			    WHEN UPPER(COALESCE(i.Impuesto_Tipo, '')) LIKE '%IVA%' AND
			      i.Impuesto_Porcentaje > 0 THEN SUM(fp.Impuesto_SubTotal)
			    ELSE 0
			  END AS ingresosIvaGravado
			FROM Sucursal_Operacion_Impuesto_Forma_Pago fp
			INNER JOIN Impuesto i
			  ON fp.Emp_Id = i.Emp_Id
			  AND fp.Impuesto_Id = i.Impuesto_Id
			WHERE UPPER(COALESCE(i.Impuesto_Tipo, '')) LIKE '%IVA%'
			AND fp.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
			AND fp.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
			AND fp.Operacion_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Operacion_Id#">
			AND fp.Forma_Id IN (13, 14)
			GROUP BY fp.Impuesto_Id,
			         i.Impuesto_Tipo,
			         i.Impuesto_Porcentaje) Tbl
		</cfquery>
		<cfcatch type="any">
			<!--- Se crea Query vac?a, porque en algunos clientes no existe
			     la tabla Sucursal_Operacion_Impuesto_Forma_Pago en LDCOM--->
			<cfset getIngresosVlesTjeta = queryNew("ingresosIvaExento,ingresosIvaGravado", "Double,Double")>
			<cfset queryAddRow(getIngresosVlesTjeta)>
		</cfcatch>
	</cftry>
	<cfreturn getIngresosVlesTjeta>
</cffunction>

<!--- Obtiene los impuestos correspondientes a tipo de pago Vale y Tarjeta departamental --->
<cffunction name="getImpuestosValesTarjeta" access="private" output="true">
	<cfargument name="DataSource" 	type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  	type="string" required="true" default="" />
	<cfargument name="Suc_Id"     	type="string" required="true" default="" />
	<cfargument name="Operacion_Id" type="string" required="true" default="" />

	<cftry>
		<cfquery name="getRsImpuestos" datasource="#Arguments.DataSource#">
			SELECT COALESCE(SUM(IvaExento), 0) AS montoIvaExento,
			       COALESCE(SUM(IvaGravado), 0) AS montoIvaGravado,
			       COALESCE(SUM(montoIeps), 0) AS montoIeps
			FROM
			  (SELECT CASE
			              WHEN UPPER(COALESCE(i.Impuesto_Tipo, '')) LIKE '%IVA%'
			                   AND i.Impuesto_Porcentaje = 0 THEN SUM(fp.Impuesto_Monto)
			              ELSE 0
			          END AS IvaExento,
			          CASE
			              WHEN UPPER(COALESCE(i.Impuesto_Tipo, '')) LIKE '%IVA%'
			                   AND i.Impuesto_Porcentaje > 0 THEN SUM(fp.Impuesto_Monto)
			              ELSE 0
			          END AS IvaGravado,
			          CASE
			              WHEN UPPER(COALESCE(i.Impuesto_Tipo, '')) LIKE '%IEPS%'
			                   AND i.Impuesto_Porcentaje > 0 THEN SUM(fp.Impuesto_Monto)
			              ELSE 0
			          END AS montoIeps
			   FROM Sucursal_Operacion_Impuesto_Forma_Pago fp
			   INNER JOIN Impuesto i ON fp.Emp_Id = i.Emp_Id
			   AND fp.Impuesto_Id = i.Impuesto_Id
			   WHERE fp.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
			     AND fp.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
			     AND fp.Operacion_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Operacion_Id#">
			     AND fp.Forma_Id IN (13, 14) <!--- 13 - Vale Credito y 14 - Tarjeta Departamental (Imp. Cat. LDCOM))--->
			   GROUP BY fp.Impuesto_Id,
			            i.Impuesto_Tipo,
			            i.Impuesto_Porcentaje) Tbl
		</cfquery>
		<cfcatch type="any">
			<!--- Se crea Query vac?a, porque en algunos clientes no existe
			     la tabla Sucursal_Operacion_Impuesto_Forma_Pago en LDCOM--->
			<cfset getRsImpuestos = queryNew("montoIvaExento,montoIvaGravado,montoIeps", "Double,Double,Double")>
			<cfset queryAddRow(getRsImpuestos)>
		</cfcatch>
	</cftry>
	<cfreturn getRsImpuestos>
</cffunction>

<cffunction name="getDevolucionesValesTjeta" access="private" output="true">
	<cfargument name="DataSource" 	type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  	type="string" required="true" default="" />
	<cfargument name="Suc_Id"     	type="string" required="true" default="" />
	<cfargument name="Operacion_Id" type="string" required="true" default="" />

	<cftry>
		<cfquery name="getDevolucionesVlesTjeta" datasource="#Arguments.DataSource#">
			<!---
			select 
			abs(Sum(Factura_Exento_Bruto)) Excento, 
			abs(Sum(Factura_Gravado_Bruto)) Gravado,
			abs(Sum(Factura_Impuesto)) Impuesto,	
			abs(Sum(Factura_FP_Vale_Credito+Factura_FP_Efectivo)) TotalDev
			from Factura_Encabezado  
			where Emp_id = #Arguments.Emp_Id#
				and Suc_Id = #Arguments.Suc_Id# 
				and TipoDoc_id = 3  
				and Operacion_Id = #Arguments.Operacion_Id#
				And (Factura_FP_Vale_Credito + Factura_FP_Tarjeta_Departamental)>0
				--->
			Select	0 Excento,
					<cfif planLealtad>
						(abs(Operacion_Devolucion_Contado_Efectivo) + abs(Operacion_Devolucion_Contado_NC) + abs(Operacion_Devolucion_Monedero) + abs(Operacion_Devolucion_Cupon)) / 1.16 Gravado,
						((abs(Operacion_Devolucion_Contado_Efectivo) + abs(Operacion_Devolucion_Contado_NC) + abs(Operacion_Devolucion_Monedero) + abs(Operacion_Devolucion_Cupon)) / 1.16) * 0.16 Impuesto
					<cfelse>
						(abs(Operacion_Devolucion_Contado_Efectivo) + abs(Operacion_Devolucion_Contado_NC) + abs(Operacion_Devolucion_Cupon)) / 1.16 Gravado,
						((abs(Operacion_Devolucion_Contado_Efectivo) + abs(Operacion_Devolucion_Contado_NC) + abs(Operacion_Devolucion_Cupon)) / 1.16) * 0.16 Impuesto
					</cfif>
			From Sucursal_Operacion_Corte
			where Emp_id = #Arguments.Emp_Id#
							and Suc_Id = #Arguments.Suc_Id# 
							and Operacion_Id = #Arguments.Operacion_Id#

		</cfquery>
		<cfcatch type="any">
			<!--- Se crea Query vac?a, porque en algunos clientes no existe
			     la tabla Sucursal_Operacion_Impuesto_Forma_Pago en LDCOM--->
			<cfset getDevolucionesVlesTjeta = queryNew("Excento,Gravado,Impuesto", "Double,Double,Double")>
			<cfset queryAddRow(getDevolucionesVlesTjeta)>
		</cfcatch>
	</cftry>
	<cfreturn getDevolucionesVlesTjeta>
</cffunction>

</cfcomponent>