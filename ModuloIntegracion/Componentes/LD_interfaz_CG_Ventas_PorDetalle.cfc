<cfcomponent extends="Interfaz_Base" output="yes">
	<cffunction name="Ejecuta" access="public" returntype="any" output="yes">
		<cfargument name="Disparo" required="no" type="boolean" default="true"> <!---ABG--->
		<cfsetting requestTimeout="3600" />
		<!--- Tipos de Operacion para Sumatoria
			1  = Ingresos, 2 = IVA, 3 = Pago Efectivo, 4 = Pago Tarjeta, 5 = Pago Vale, 6 = Pago Cheque
			7  = Pago MExtranjera, 8 = Pago Nota, 9 = Pago Monedero, 10 = Pago Puntos, 11 = Pago CoPago,
			12 = Almacen Venta, 13 = Costo Venta, 14 = DescuentoV, 15 = DescuentoE, 16 = Devolucion,
			17 = Efectivo Caja, 18 = PagoBanco, 19 = ComBanco, 20 = Deudores, 21 = PendientesF, 22 = CambioEfec,
			23 = Redondeo
		--->

		<!--- Tipo Venta
			P = Contado
			C = Credito
			D = Devolucion
			S = Servicio Domicilio
			R = Recibo Servicios
		--->
		<!--- VARIABLES --->
		<cfset VentaxIVA = true>
		<cfset varOrigen = 'LDIV'>
		<cfset usarParametros = false>
		<cfif not usarParametros>
			<!--- Obtiene los parametros --->
			<cfset ParOfic 	  = 1>
			<!--- Equivalencia Centro Funcional --->
			<cfset ParCF 	  = 1>
			<!---Cuenta impuesto --->
			<cfset ParImp 	  = 1>
			<!--- Borrar Registro --->
			<cfset ParBorrado = 0>
			<!--- Agrupamiento --->
			<cfset ParAgrupa  = 1>
			<!--- Prorrateo --->
			<cfset ParPrrat   = 0>
			<!--- Cuenta banco --->
			<cfset varCtaBanco= 1>
		</cfif>
		<cfset descIVA = ''>

		<cfset updTimbreFiscal = updateFiscal('P',now())>

		<!--- Extrae Encabezados de Ventas --->
		<cfquery datasource="sifinterfaces" result="Rupdate">
			update ESIFLD_Facturas_Venta
			set Estatus = 11 <!---Marca el estatus 10 =  en Proceso para evitar bloqueos --->
			where
			<cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
				Estatus = 4
				and not exists (select 1 from ESIFLD_Facturas_Venta b where Estatus in (10, 11,94,92,99,100) and ESIFLD_Facturas_Venta.ID_DocumentoV = b.ID_DocumentoV)
			<cfelse>
				Estatus = 100
				and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11) and ESIFLD_Facturas_Venta.ID_DocumentoV = b.ID_DocumentoV)
			</cfif>
		</cfquery>
		<cfquery name="rsIDEVentas" datasource="sifinterfaces">
			select 	ID_DocumentoV, Tipo_Venta
			from 	ESIFLD_Facturas_Venta
			where 	Estatus = 11
			<cfif 	Rupdate.recordcount EQ 0>
				and 1 = 2
			</cfif>
			<!--- and Tipo_Venta in ('P','D','S') Solo toma Ventas de contado, devoluciones y servicios a Domicilio --->
		</cfquery>

		<cfif isdefined("rsIDEVentas") and rsIDEVentas.recordcount GT 0>
 			<cfloop query="rsIDEVentas">

				<cfset varBorraRegistro = false>
				<cfset Maximus = 0>
				<!--- RS ENCABEZADO --->
				<cfif rsIDEVentas.Tipo_Venta EQ "E">
					<!--- VALIDACION PARA LAS DEVOLUCIONES DE CREDITO
					      UNICAMENTE SE DEBERÁ CREAR POLIZA SI LA SUMA DEL
					      COSTO DE VENTA ES MAYOR A 0 --->
					<cfquery name="rsEVentas" datasource="sifinterfaces">
						select 	Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta,
								Fecha_Venta, Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento,
								Impuesto, Total, Redondeo, Vendedor,Sucursal, Dias_Credito, Moneda, Tipo_Cambio,
								Direccion_Fact, Retencion, Observaciones, Tipo_CEDI, Factura_Cambio, TimbreFiscal, IEPS, comisionRecibo
						from 	ESIFLD_Facturas_Venta
						where 	ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEVentas.ID_DocumentoV#">
						AND (SELECT COALESCE(SUM(Costo_Venta), 0)
						     FROM DSIFLD_Facturas_Venta
						     WHERE ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEVentas.ID_DocumentoV#">) > 0
					</cfquery>
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Venta
						set 	Estatus = 92
						where 	ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEVentas.ID_DocumentoV#">
					</cfquery>
				<cfelse>
					<cfquery name="rsEVentas" datasource="sifinterfaces">
						select 	Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta,
								Fecha_Venta, Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento,
								Impuesto, Total, Redondeo, Vendedor,Sucursal, Dias_Credito, Moneda, Tipo_Cambio,
								Direccion_Fact, Retencion, Observaciones, Tipo_CEDI, Factura_Cambio, TimbreFiscal, IEPS, comisionRecibo
						from 	ESIFLD_Facturas_Venta
						where 	ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEVentas.ID_DocumentoV#">
						<!--- and Tipo_Venta in ('P','D','S') Solo toma Ventas de contado, devoluciones y servicios a Domicilio --->
					</cfquery>
				</cfif>


				<cfloop query="rsEVentas">
					<cftry>
						<cfset DocumentoFact = rsEVentas.ID_DocumentoV>
						<!--- ACTUALIZA ORIGEN --->
						<cfif listfind('C,E',rsEVentas.Tipo_Venta)>
							<cfset varOrigen = 'LDVT'>
						<cfelse>
							<cfset varOrigen = 'LDIV'>
						</cfif>

						<!--- Actualiza fecha de proceso --->
						<cfquery datasource="sifinterfaces">
							update  ESIFLD_Facturas_Venta
							set     Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							where   ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">
						</cfquery>

						<!--- Crea tabla temporal para Insersion de Temporales --->
						<cf_dbtemp name="rsColaP" returnvariable="rsColaP" datasource="sifinterfaces">
							<cf_dbtempcol name="ID" type="int">
							<cf_dbtempcol name="Consecutivo" type="int">
							<cf_dbtempcol name="Ecodigo" type="int">
							<cf_dbtempcol name="Interfaz" type="int">
						</cf_dbtemp>

						<!--- Busca equivalencias --->
						<!--- EMPRESAS --->
						<cfset Equiv 		 = ConversionEquivalencia (rsEVentas.Origen, 'CADENA', rsEVentas.Ecodigo, rsEVentas.Ecodigo, 'Cadena')>
						<cfset varEcodigo 	 = Equiv.EQUidSIF>
						<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
						<cfset session.dsn 	 = getConexion(varEcodigo)>
						<cfset varCEcodigo 	 = getCEcodigo(varEcodigo)>
						<!--- Concepto Contable --->
						<cfset varCconcepto  = ConceptoContable(varEcodigo,"#varOrigen#")>

						<!--- Parametros --->
							<!--- Obtiene los parametros --->
							<cfif not isdefined("ParOfic")>
								<cfset ParOfic 	  = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=rsEVentas.Sucursal,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
							<!--- Equivalencia Centro Funcional --->
							<cfif not isdefined("ParCF")>
								<cfset ParCF 	  = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=rsEVentas.Sucursal,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
							<!---Cuenta impuesto --->
							<cfif not isdefined("ParImp")>
								<cfset ParImp 	  = Parametros(Ecodigo=varEcodigo,Pcodigo=3,Sucursal=rsEVentas.Sucursal,Parametro="Equivalencia Impuesto",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
							<!--- Borrar Registro --->
							<cfif not isdefined("ParBorrado")>
								<cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsEVentas.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
							<!--- Agrupamiento --->
							<cfif not isdefined("ParAgrupa")>
								<cfset ParAgrupa  = Parametros(Ecodigo=varEcodigo,Pcodigo=5,Sucursal=rsEVentas.Sucursal,Parametro="Agrupa Pólizas",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
							<!--- Prorrateo --->
							<cfif not isdefined("ParPrrat")>
								<cfset ParPrrat   = Parametros(Ecodigo=varEcodigo,Pcodigo=12,Sucursal=rsEVentas.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
							<!--- Cuenta banco --->
							<cfif not isdefined("varCtaBanco")>
								<cfset varCtaBanco= Parametros(Ecodigo=varEcodigo,Pcodigo=14,Sucursal=rsEVentas.Sucursal,Parametro="Cuenta para Pagos",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
							</cfif>
						<!----- ----->

						<!--- Obtiene el usuario de Interfaz --->
						<cfset Usuario 	  = UInterfaz (getCEcodigo(varEcodigo))>
						<cfset varUlogin  = Usuario.Usulogin>
						<cfset varUcodigo = Usuario.Usucodigo>

						<!--- Oficina --->
						<cfif ParOfic>
							<!---OFICINA --->
							<cfset Equiv = ConversionEquivalencia(rsEVentas.Origen, 'SUCURSAL', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Sucursal')>
							<cfset VarOcodigo = Equiv.EQUidSIF>
							<cfset VarOficina = Equiv.EQUcodigoSIF>
						<cfelse>
							<cfset VarOficina = rsEVentas.Sucursal>
							<cfquery name="rsOFid" datasource="#session.dsn#">
								select 	Ocodigo
								from 	Oficinas
								where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and 	Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficina#">
							</cfquery>
							<cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
								<cfset VarOcodigo = rsOFid.Ocodigo>
							</cfif>
						</cfif>
						<!--- Centro funcional --->
						<cfif ParCF>
							<!--- CENTRO FUNCIONAL--->
							<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CENTRO_FUN', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Centro_Funcional')>
							<cfset varidCF = Equiv.EQUidSIF>
							<cfset varCF = Equiv.EQUcodigoSIF>
						<cfelse>
							<cfset varCF = rsEVentas.Sucursal>
							<cfquery name="rsOFid" datasource="#session.dsn#">
								select CFid
								from CFuncional
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and CFcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">
							 </cfquery>
							 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
								<cfset varidCF = rsOFid.CFid>
							 </cfif>
						</cfif>

						<!--- Cuenta Banco --->
						<cfif isdefined("varCtaBanco") and len(varCtaBanco) GT 0>
							<cfquery name="rsCta_Banco" datasource="#session.dsn#">
								select 	CBid, Bid
								from 	CuentasBancos
								where 	CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCtaBanco#">
								and 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							</cfquery>
							<cfset varCuentaB = rsCta_Banco.CBid>
							<cfset varBanco = rsCta_Banco.Bid>
						<cfelse>
							<cfthrow message="Error Cuenta Bancaria No Existe en la empresa #varEcodigo#">
						</cfif>

						<!--- MONEDA --->
						<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsEVentas.Moneda, 'Moneda')>
						<cfset varMoneda = Equiv.EQUcodigoSIF>

						<!--- Busca Periodo en Minisif --->
						<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
							select Pvalor from Parametros
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							and Pcodigo = 50
						</cfquery>
						<!--- <cfset Periodo = BuscaPeriodo.Pvalor> --->

						<!--- Busca Mes en Minisif --->
						<cfquery name="BuscaMes" datasource="#session.dsn#">
							select Pvalor from Parametros
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							and Pcodigo = 60
						</cfquery>
						<!--- <cfset Mes = BuscaMes.Pvalor> --->

						<!--- Se asigna periodo y mes de la fecha de operacion en LD --->
						<cfset Mes="#month(rsEVentas.Fecha_Venta)#">
						<cfset Periodo="#year(rsEVentas.Fecha_Venta)#">

						<!--- Numero de documento --->
						<cfset NumeroDoc = rsEVentas.Numero_Documento>

						<!--- CLIENTE --->
						<cfset VarCte = ExtraeCliente(rsEVentas.Cliente, varEcodigo)>

						<!--- Para la Descripcion de la Poliza --->
							<cfif rsEVentas.Tipo_Venta EQ "P">
								<cfset DescPoliza = "Venta Contado #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "D" and rsEVentas.Tipo_CEDI EQ "N">
								<cfset DescPoliza = "Venta Contado #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "X" and rsEVentas.Tipo_CEDI EQ "N">
								<cfset DescPoliza = "Venta Contado #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "S">
								<cfset DescPoliza = "Venta Contado #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "R">
								<cfset DescPoliza = "Venta Contado #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "Z">
								<cfset DescPoliza = "Venta Contado #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "C">
								<cfset DescPoliza = "Venta Credito #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "D" and rsEVentas.Tipo_CEDI EQ "S">
								<cfset DescPoliza = "Venta Credito #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "X" and rsEVentas.Tipo_CEDI EQ "S">
								<cfset DescPoliza = "Venta Credito #rsEVentas.Numero_Documento#">
							<cfelseif rsEVentas.Tipo_Venta EQ "E">
								<cfset DescPoliza = "Nota Credito #rsEVentas.Numero_Documento#">
							</cfif>
						<!------>

						<!---Verifica si debe insertar encabezado o no --->
						<cfquery name="rsVerificaE" datasource="sifinterfaces">
							select  ID
							from    SIFLD_IE18
							where   Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							and     Edocbase like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEVentas.Numero_Documento)#">
						</cfquery>
						<!--- INSERTA ENCABEZADO --->
						<cfif rsVerificaE.recordcount EQ 0>
							<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 --->
							<cfset RsMaximo = ExtraeMaximo("IE18","ID")>
							<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
								<cfset Maximus = RsMaximo.Maximo>
							<cfelse>
								<cfset Maximus = 1>
							</cfif>
							<!--- Insercion de Encabezado en IE18 --->
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_IE18
									(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion,
									Edocbase, Ereferencia, Falta, Usuario, CEcodigo, EcodigoSDC,
									Usulogin, Usucodigo, ECIreversible, TimbreFiscal, IEPS)
								values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#VarEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer"  value="#varCconcepto#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_date" 	   value="#rsEVentas.Fecha_Venta#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="Poliza de #DescPoliza#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#NumeroDoc#">,
									 ' ', getdate(),
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#varUlogin#">,
									 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
									 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#varUlogin#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric"  value="#varUcodigo#">,
									 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsEVentas.TimbreFiscal#">,
									 <cfqueryparam cfsqltype ="cf_sql_money"   value="#rsEVentas.IEPS#">
									 )
							</cfquery>
							<cfset IDlinea = 1>
							<cfset varBorraRegistro = false>
						<cfelse>
							<cfset Maximus = rsVerificaE.ID>
							<cfquery name="rsLinea" datasource="sifinterfaces">
								select 	isnull(max(DCIconsecutivo),0) + 1 as Linea
								from 	SIFLD_ID18
								where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsVerificaE.ID#">
							</cfquery>
							<cfset IDlinea = rsLinea.Linea>
							<cfset IDStart = rsLinea.Linea - 1>
						</cfif>

						<!--- RS DETALLE --->
						<cfif ListContains("R,Z",#rsEVentas.Tipo_Venta#) EQ 0>
							<cfquery name="rsDVentas" datasource="sifinterfaces">
								select 	Ecodigo, ID_DocumentoV, Id_Linea, Tipo_Lin, Tipo_Item,
										isnull(Subtotal_Lin,0) as Subtotal,
										isnull(Descuento_Lin,0) as Descuento,
										isnull(Impuesto_Lin, 0) as Impuesto,
										isnull(Total_Lin, 0) as Total,
										Cod_Impuesto, Clas_Item, Cod_Fabricante, Costo_Venta,
										codIEPS,
										isnull(MontoIEPS, 0) as MontoIEPS,
										afectaIVA,
										AfectaDevolucion
								from 	DSIFLD_Facturas_Venta
								where 	ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">
							</cfquery>

						<!--- LISTA DE CUENTAS --->
						<!---
							CuentaLDIV Cta. Ventas doc. Contable
							CuentaLDIP Cta. IVA Acreditable
							CuentaLDAV Cta. Inventario doc. Contable Costo Ventas
							CuentaLDCV Cta. Costo de Ventas doc. Contable
							CuentaLDDD Cta. Deudores Diversos
							CuentaLDCB Cta. Para Gastos Financieros comis.banc.
							CuentaLDCF Cta. Ctes. pendientes por facturar
							CuentaLDVD Cta. Ventas Devolucion
							CuentaLDEF Cta. Devolucion Sobre Venta
						--->

						<!--- DECLARA ARREGLO DE CUENTA CONTABLE PARA PAGOS --->
						<!---
							CuentaLDEF Cta. Efectivo en Caja Doctos Contables
							CuentaLDBC Cta. Bancos Cuentas
							CuentaLDDV Cta. Descuento sobre Ventas
							CuentaLDCB_Pago Cta. Para Gastos Financieros comis.banc.
							CuentaLDDD_Pago Cta. Deudores Diversos
						--->

						<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
							<cfloop query = "rsDVentas">
								<cfif VentaxIVA>
									<cfif rsDVentas.Cod_Impuesto EQ 1>
										<cfset descIVA = '16%'>
									<cfelseif rsDVentas.Cod_Impuesto EQ 2 or rsDVentas.Cod_Impuesto EQ 0>
										<cfset descIVA = '0%'>
									</cfif>
								</cfif>
								<!--- Busca equivalencia de IMPUESTO en SIF --->
								<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'IMPUESTO', rsEVentas.Ecodigo, rsDVentas.Cod_Impuesto, 'Cod_Impuesto')>
								<cfset VarImpuesto = Equiv.EQUcodigoSIF>

								<!--- Obtiene cuenta Contable Parametrizada en el Impuesto --->
								<cfquery name="rsIVA" datasource="#session.dsn#">
									SELECT 	Cformato
									FROM 	CContables c
										INNER JOIN 	Impuestos i
										ON 	c.Ecodigo = i.Ecodigo
										AND c.Ccuenta = i.CcuentaCxCAcred
									WHERE 	i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
									AND 	i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarImpuesto#">
								</cfquery>
								<cfif isdefined ("rsIVA") and rsIVA.recordcount GT 0>
									<cfset varCuentaImp = rsIVA.Cformato>
								<cfelse>
									<cfthrow message="El Impuesto #varImpuesto# No tiene Parametrizadas sus cuentas">
								</cfif>
								<!--- OBTIENE LAS CUENTAS PARA CADA UNO DE LOS MOVIMIENTOS --->
								<!--- INGRESOS Origen debe ser LDIV--->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="#varOrigen#"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="ING"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#VarOcodigo#"
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCtaBanco#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDIV = Cuenta>
								<cfif !ParImp>
									<cfif rsEVentas.Impuesto GT 0>
										<!--- IVA --->
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="IVA"
											LDDepartamento="#rsDVentas.Tipo_Item#"
											LDClasificacion="#rsDVentas.Clas_Item#"
											LDFabricante="#rsDVentas.Cod_Fabricante#"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="#varImpuesto#"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDIP = Cuenta>
									</cfif>
								</cfif>

								<!--- ALMACEN VENTAS --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="#varOrigen#"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="AVT"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#VarOcodigo#"
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCtaBanco#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDAV = Cuenta>

								<!--- COSTO VENTAS --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="#varOrigen#"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="CVT"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#VarOcodigo#"
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCtaBanco#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDCV = Cuenta>

								<cfif rsEVentas.Tipo_Venta EQ "D" OR rsEVentas.Tipo_Venta EQ "E" OR rsEVentas.Tipo_Venta EQ "X">
									<!--- DEVOLUCION DE VENTAS  --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="DVT"
										LDDepartamento="#rsDVentas.Tipo_Item#"
										LDClasificacion="#rsDVentas.Clas_Item#"
										LDFabricante="#rsDVentas.Cod_Fabricante#"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="#varImpuesto#"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset CuentaLDVD = Cuenta>
								</cfif>

								<!--- DVN, Devolucion Sobre Venta  --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="#varOrigen#"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="DVN"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#VarOcodigo#"
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCtaBanco#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDEF = Cuenta>

								<cfif rsEVentas.Tipo_Venta EQ "C" OR rsEVentas.Tipo_Venta EQ "E">
									<!--- PENDIENTES DE FACTURAR Origen debe ser LDIV --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="LDIV"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="PFC"
										LDDepartamento="#rsDVentas.Tipo_Item#"
										LDClasificacion="#rsDVentas.Clas_Item#"
										LDFabricante="#rsDVentas.Cod_Fabricante#"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="#varImpuesto#"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset CuentaLDPF = Cuenta>
								</cfif>

								<cfif rsEVentas.Tipo_Venta NEQ "D" AND rsEVentas.Tipo_Venta NEQ "X" AND rsEVentas.Tipo_Venta NEQ "E">
									<!--- Dependiendo del parametro de Prorrateo se ejecuta esta rutina --->
									<cfif ParPrrat>
										<!--- SELECCION DE REGISTROS DE DETALLE de Tipo de Pago--->
										<cfquery name="rsFPago" datasource="sifinterfaces" timeout="3600">
											select  Ecodigo, ID_DocumentoV, Id_Linea_Pago, Tipo_Pago,
													isnull(Importe,0) as Importe, Moneda, Tipo_Cambio, Especial,
													SocioDocumento, isnull(Comision_Porcentaje,0) as Comision_Porcentaje
											from 	SIFLD_Facturas_Tipo_Pago
											where 	ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">
										</cfquery>
										<cfif isdefined("rsFPago") and rsFPago.recordcount GT 0>
										<cfloop query="rsFPago">
											<!--- MONEDA --->
											<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsFPago.Ecodigo, rsFPago.Moneda, 'Moneda')>
											<cfset varMonedaPag = Equiv.EQUcodigoSIF>

											<!--- Si el Documento tiene IVA, calcula el IVA correspondiente a Este Tipo de Pago --->
											<!---<cfif rsEVentas.Impuesto GT 0>
												<cfset PImpuesto = (rsFPago.Importe/rsEVentas.Total) * rsEVentas.Impuesto>
												<cfset Ingreso = rsFPago.Importe - PImpuesto>
											<cfelse> --->

											<cfset Ingreso = rsFPago.Importe>
											<!---</cfif>--->
											<!--- Calcula y Quita el porcentaje de Comision al Ingreso --->
											<cfset Comision = rsFPago.Importe * rsFPago.Comision_Porcentaje>
											<cfset Ingreso = Ingreso - Comision>
											<!---Calcula el prorrateo del Ingreso para el detalle Procesado--->
											<cfset PIngreso = (rsDVentas.Total/rsEVentas.Total) * Ingreso>
											<!---Descripcion de la Poliza --->
												<cfif rsFPago.Tipo_Pago EQ "E">
													<cfset DescPol = "Efectivo">
												<cfelseif rsFPago.Tipo_Pago EQ "T">
													<cfset DescPol = "Tarjeta">
												<cfelseif rsFPago.Tipo_Pago EQ "V">
													<cfset DescPol = "Cupones">
												<cfelseif rsFPago.Tipo_Pago EQ "H">
													<cfset DescPol = "Cheque">
												<cfelseif rsFPago.Tipo_Pago EQ "X">
													<cfset DescPol = "Moneda Extranjera">
												<cfelseif rsFPago.Tipo_Pago EQ "N">
													<cfset DescPol = "Nota de Credito">
												<cfelseif rsFPago.Tipo_Pago EQ "M">
													<cfset DescPol = "Monedero">
												<cfelseif rsFPago.Tipo_Pago EQ "P">
													<cfset DescPol = "Transferencia">
												<cfelseif rsFPago.Tipo_Pago EQ "C">
													<cfset DescPol = "Co-Pago">
												</cfif>
												<cfif rsFPago.Especial EQ 1>
													<cfset DescPol = "Forma Pago Especial #DescPol#">
												</cfif>
											<!------>

											<!--- Cuentas Por tipo de Pago --->
											<cfif rsFPago.Tipo_Pago EQ "T" OR rsFPago.Tipo_Pago EQ "H" OR rsFPago.Tipo_Pago EQ "C">
												<!--- CUENTA BANCARIA  --->
												<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
													Oorigen="#varOrigen#"
													Ecodigo="#varEcodigo#"
													Conexion="#session.dsn#"
													LDOperacion="CBN"
													LDDepartamento="#rsDVentas.Tipo_Item#"
													LDClasificacion="#rsDVentas.Clas_Item#"
													LDFabricante="#rsDVentas.Cod_Fabricante#"
													LDTipoVenta="#rsEVentas.Tipo_Venta#"
													SNegocios="#varCte.sncodigo#"
													Impuestos="#varImpuesto#"
													Oficinas="#VarOcodigo#"
													LDConceptoRetiroCaja="NOUSAR"
													Almacen="NOUSAR"
													Bancos="#varBanco#"
													LDCuentaBanco="#varCtaBanco#"
													LDMovimientoInventario="NOUSAR"
													LDAlmacen="NOUSAR"
													LDTipoRetiroCaja="NOUSAR"
												>
												</cfinvoke>
												<cfset CuentaLDBC = Cuenta>
												<!---<!--- VALES  --->
												<cfif rsFPago.Tipo_Pago EQ "V">

												</cfif>--->

												<!--- COMISIONES BANCARIAS  --->
												<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
													Oorigen="#varOrigen#"
													Ecodigo="#varEcodigo#"
													Conexion="#session.dsn#"
													LDOperacion="CMB"
													LDDepartamento="#rsDVentas.Tipo_Item#"
													LDClasificacion="#rsDVentas.Clas_Item#"
													LDFabricante="#rsDVentas.Cod_Fabricante#"
													LDTipoVenta="#rsEVentas.Tipo_Venta#"
													SNegocios="#varCte.sncodigo#"
													Impuestos="#varImpuesto#"
													Oficinas="#VarOcodigo#"
													LDConceptoRetiroCaja="NOUSAR"
													Almacen="NOUSAR"
													Bancos="#varBanco#"
													LDCuentaBanco="#varCtaBanco#"
													LDMovimientoInventario="NOUSAR"
													LDAlmacen="NOUSAR"
													LDTipoRetiroCaja="NOUSAR"
												>
												</cfinvoke>
												<cfset CuentaLDCB = Cuenta>
											</cfif>

											<cfif rsFPago.Tipo_Pago EQ "N" OR rsFPago.Tipo_Pago EQ "M" OR rsFPago.Tipo_Pago EQ "P">
												<!--- DESCUENTOS SOBRE VENTAS  --->
												<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
													Oorigen="#varOrigen#"
													Ecodigo="#varEcodigo#"
													Conexion="#session.dsn#"
													LDOperacion="DSV"
													LDDepartamento="#rsDVentas.Tipo_Item#"
													LDClasificacion="#rsDVentas.Clas_Item#"
													LDFabricante="#rsDVentas.Cod_Fabricante#"
													LDTipoVenta="#rsEVentas.Tipo_Venta#"
													SNegocios="#varCte.sncodigo#"
													Impuestos="#varImpuesto#"
													Oficinas="#VarOcodigo#"
													LDConceptoRetiroCaja="NOUSAR"
													Almacen="NOUSAR"
													Bancos="#varBanco#"
													LDCuentaBanco="#varCtaBanco#"
													LDMovimientoInventario="NOUSAR"
													LDAlmacen="NOUSAR"
													LDTipoRetiroCaja="NOUSAR"
												>
												</cfinvoke>
												<cfset CuentaLDDV = Cuenta>
											</cfif>

											<!--- INSERTA EL DETALLE A LA POLIZA PARA LA FORMA DE PAGO --->
											<cfquery datasource="sifinterfaces">
												insert into SIFLD_ID18 (
														ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
														Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
														Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
														Oficodigo, Miso4217, CFcodigo, TipoOperacion)
												values
												(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
												 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
												 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
												 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
												 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
												 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en #DescPol#">,
												 ' ', ' ', 'D', 0, 0, 0, 0,
												 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(PIngreso,'9.99')#">),
												 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(PIngreso * rsFPago.Tipo_Cambio,'9.99')#">),
												 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">,
												 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
												 getdate(), 0,
												 <cfif rsFPago.Especial EQ 1>
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
												 <cfelse>
													 <cfif rsFPago.Tipo_Pago EQ "E">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "T">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "V">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "H">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "X">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "N">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "M">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "P">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
													 <cfelseif rsFPago.Tipo_Pago EQ "C">
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
													 </cfif>
												 </cfif>
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
												 <cfif rsFPago.Especial EQ 1>
													 20
												 <cfelse>
													 <cfif rsFPago.Tipo_Pago EQ "E">
														3
													 <cfelseif rsFPago.Tipo_Pago EQ "T">
														4
													 <cfelseif rsFPago.Tipo_Pago EQ "V">
														5
													 <cfelseif rsFPago.Tipo_Pago EQ "H">
														6
													 <cfelseif rsFPago.Tipo_Pago EQ "X">
														7
													 <cfelseif rsFPago.Tipo_Pago EQ "N">
														8
													 <cfelseif rsFPago.Tipo_Pago EQ "M">
														9
													 <cfelseif rsFPago.Tipo_Pago EQ "P">
														10
													 <cfelseif rsFPago.Tipo_Pago EQ "C">
														11
													 </cfif>
												 </cfif>)
											</cfquery>
											<cfset IDlinea = IDlinea + 1>

											<!--- INSERCION DE COMISION BANCARIA "LDCB" (COMISIONES BANCARIAS) --->
											<cfif rsFPago.Comision_Porcentaje GT 0>
												<cfquery datasource="sifinterfaces">
													insert into SIFLD_ID18
															(
															 ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
															 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
															 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
															 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
													values
													(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
													 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
													 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
													 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="Comision Bancaria">,
													 ' ', ' ', 'D', 0, 0, 0, 0,
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision,'9.99')#">),
													 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision * rsFPago.Tipo_Cambio,'9.99')#">),
													 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">,
													 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
													 getdate(), 0,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCB.CFformato#">,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
													 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
													 19)
												</cfquery>
												<cfset IDlinea = IDlinea + 1>
											</cfif>
										</cfloop> <!---Formas de Pago--->
										</cfif>
									</cfif> <!--- Parametro Prorrateo--->

									<!--- INSERTA MOVIMIENTOS DE POLIZA QUE SON POR DETALLE --->
									<!--- Insercion del Ingreso "LDIV" (Ingresos Ventas) --->
									<cfif rsEVentas.Tipo_Venta NEQ "C"  >
										<cfquery datasource="sifinterfaces">
											insert into SIFLD_ID18
													(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
													 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
													 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
													 Oficodigo, Miso4217, CFcodigo,TipoOperacion)
											values
											(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="Ingresos de Ventas #descIVA#">,
											 ' ', ' ', 'C', 0, 0, 0, 0,
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal * rsEVentas.Tipo_Cambio,'9.99')#">),
											 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
											 getdate(), 0,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
											 1)
										</cfquery>
										<cfset IDlinea = IDlinea + 1>
									</cfif> <!--- Ventas no Devolucion --->
								</cfif>

								<!--- Devolucion de Ventas --->
								<cfif (rsEVentas.Tipo_Venta EQ "D" OR rsEVentas.Tipo_Venta EQ "X") AND rsDVentas.AfectaDevolucion EQ 0>
									<!--- Insercion detalle "LDVD" (Ventas Devolucion) --->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18
											(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Devolucion de Ventas">,
										 ' ', ' ', 'D', 0, 0, 0, 0,
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
										 1,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
										 getdate(), 0,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDVD.CFformato#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
										 16)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
								</cfif>

								<!--- Efectivo en Caja (UNICAMENTE DEVOLUCIONES)--->
								<cfif rsEVentas.Tipo_Venta EQ "D" AND rsDVentas.AfectaDevolucion EQ 0>
									<!--- Insercion detalle "LDEF" (Efectivo en Caja) --->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18
											(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Devolucion Sobre Venta">,
										 ' ', ' ', 'C', 0, 0, 0, 0,
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Total + MontoIEPS,'9.99')#">),
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Total + MontoIEPS,'9.99')#">),
										 1,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
										 getdate(), 0,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
										 17)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
								</cfif> <!--- Devoluciones --->

								 <!--- Ventas de Credito --->

								<!--- COSTO DE VENTAS VS ALMACEN --->
								<!--- Insercion del detalle "LDAV" (Contable Almacen Ventas) --->
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
										(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
										 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
									values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Almacen Ventas #descIVA#">,
									 ' ', ' ',
									 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
									 <cfif rsEVentas.Tipo_Venta NEQ "D" AND rsEVentas.Tipo_Venta NEQ "E">
										'C',
									 <cfelse>
										'D',
									 </cfif>
									 0, 0, 0, 0,
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
									 1,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
									 getdate(), 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAV.CFformato#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
									 12)
								</cfquery>
								<cfset IDlinea = IDlinea + 1>

								<!--- Insercion del detalle en la ID18 con Origen Contable "LDCV" (Costo Ventas) --->
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
										(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
										 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
									values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Costo de Ventas #descIVA#">,
									 ' ', ' ',
									 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
									 <cfif rsEVentas.Tipo_Venta NEQ "D" AND rsEVentas.Tipo_Venta NEQ "E">
										'D',
									 <cfelse>
										'C',
									 </cfif>
									 0, 0, 0, 0,
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
									 1,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
									 getdate(), 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCV.CFformato#">,
									  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
									 13)
								</cfquery>
								<cfset IDlinea = IDlinea + 1>

								<!--- LINEA PARA LOS IMPUESTOS --->
								<cfif rsDVentas.Impuesto GT 0>
									<!--- Busca equivalencia de IMPUESTO en SIF --->
									<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'IMPUESTO', rsEVentas.Ecodigo, rsDVentas.Cod_Impuesto, 'Cod_Impuesto')>
									<cfset varImpuesto = Equiv.EQUcodigoSIF>

									<!--- Insercion del detalle de Impuesto "LDIP" (IVA Acreditable Pagado) --->
									<cfif (rsEVentas.Tipo_Venta EQ 'P') or ((rsEVentas.Tipo_Venta EQ  'D' OR rsEVentas.Tipo_Venta EQ "X") AND rsDVentas.AfectaDevolucion EQ 0)>
										<cfquery datasource="sifinterfaces">
											insert into SIFLD_ID18
												(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
												Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
												Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
												Oficodigo, Miso4217, CFcodigo, TipoOperacion)
											values
												(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
												 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
												 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
												 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
												 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
												 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
												 <cfif rsEVentas.Tipo_Venta EQ 'C'>
													<cfqueryparam cfsqltype="cf_sql_varchar" value="IVA por Trasladar">,
												 <cfelse>
													<cfqueryparam cfsqltype="cf_sql_varchar" value="IVA Trasladado 16%">,
												 </cfif>
												 ' ', ' ',
												 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
												 <cfif rsEVentas.Tipo_Venta NEQ "D" AND rsEVentas.Tipo_Venta NEQ "X">
													'C',
												 <cfelse>
													'D',
												 </cfif>
												 0, 0, 0, 0,
												 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Impuesto,'9.99')#">),
												 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Impuesto * rsEVentas.Tipo_Cambio,'9.99')#">),
												 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
												 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
												 getdate(), 0,
												 <cfif ParImp>
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaImp#">,
												 <cfelse>
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIP.CFformato#">,
												 </cfif>
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
												 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
												 2)
										</cfquery>
										<cfset IDlinea = IDlinea + 1>
									</cfif>
								</cfif>
								<!--- LINEA PARA IEPS --->
								<cfif rsDVentas.MontoIEPS GT 0>
									<!--- BUSCA EQUIVALENCIA DE IEPS EN SIF --->
									<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'IEPS', rsEVentas.Ecodigo, rsDVentas.codIEPS, 'Cod_Impuesto')>
									<cfset VarIEPS = Equiv.EQUcodigoSIF>
									<!--- Obtiene cuenta Contable Parametrizada en el IEPS --->
									<cfquery name="rsIEPS" datasource="#session.dsn#">
										SELECT 	Cformato, Cdescripcion
										FROM 	CContables c
											INNER JOIN 	Impuestos i
											ON 	c.Ecodigo = i.Ecodigo
											AND c.Ccuenta = i.CcuentaCxCAcred
										WHERE 	i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
										AND 	i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarIEPS#">
									</cfquery>
									<cfif isdefined ("rsIEPS") and rsIEPS.recordcount GT 0>
										<cfset varCuentaIEPS = rsIEPS.Cformato>
									<cfelse>
										<cfquery datasource="sifinterfaces">
											insert into SIFLD_Errores
													(Interfaz, Tabla, ID_Documento, MsgError, Ecodigo, Usuario)
											values
													('CG_Ventas',
													 'SIFLD_ID18',
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.ID_DocumentoV#">,
													 'No se ha agregado el impuesto IEPS: '&#VarIEPS#,
													 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Ecodigo#">,
													 null)
										</cfquery>
										<!--- <cfthrow message="El Impuesto #VarIEPS# No tiene Parametrizadas sus cuentas"> --->
									</cfif>
									<!--- Insercion del detalle de Impuesto "LDIP" (IVA Acreditable Pagado) --->
									<cfif isDefined("rsEVentas.Tipo_Venta") and #rsEVentas.Tipo_Venta# NEQ "C">
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18
											(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											Oficodigo, Miso4217, CFcodigo, TipoOperacion)
										values
											(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIEPS.Cdescripcion#">,
											 ' ', ' ',
											 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
											 <cfif rsEVentas.Tipo_Venta NEQ "D" AND rsEVentas.Tipo_Venta NEQ "X">
												'C',
											 <cfelse>
												'D',
											 </cfif>
											 0, 0, 0, 0,
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.MontoIEPS,'9.99')#">),
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.MontoIEPS * rsEVentas.Tipo_Cambio,'9.99')#">),
											 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
											 getdate(), 0,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaIEPS#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
											 2)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
									</cfif>
								</cfif>
								<!--- Descuento en Ventas --->
								<cfif rsDVentas.Descuento GT 0 >
									<!--- DESCUENTOS SOBRE VENTAS  --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="DES"
										LDDepartamento="#rsDVentas.Tipo_Item#"
										LDClasificacion="#rsDVentas.Clas_Item#"
										LDFabricante="#rsDVentas.Cod_Fabricante#"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="#varImpuesto#"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset CuentaLDDE = Cuenta>

									<!--- Insercion del detalle de Impuesto "LDDE" (Descuentos Linea) --->
									<cfif rsEVentas.Tipo_Venta EQ "P" OR rsEVentas.Tipo_Venta EQ "D">
										<cfquery datasource="sifinterfaces">
											insert into SIFLD_ID18
												(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
												Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
												Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
												Oficodigo, Miso4217, CFcodigo, TipoOperacion)
											values
											(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="Descuento Linea">,
											 ' ', ' ',
											 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
											 <!--- <cfif rsEVentas.Tipo_Venta NEQ "D" AND rsEVentas.Tipo_Venta NEQ "X" AND rsEVentas.Tipo_Venta NEQ "E">
												'D',
											 <cfelse>
												'C',
											 </cfif> --->
											 <!--- SOLO DEBITOS --->
											 'D',
											 0, 0, 0, 0,
											 <cfif rsEVentas.Tipo_Venta EQ "D">
												<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento * -1,'9.99')#">,
											    <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDVentas.Descuento * rsEVentas.Tipo_Cambio)*-1,'9.99')#">,
										     <cfelse>
										     	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento,'9.99')#">),
											    abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento * rsEVentas.Tipo_Cambio,'9.99')#">),
											 </cfif>
											 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
											 getdate(), 0,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDE.CFformato#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
											 2)
										</cfquery>
										<cfset IDlinea = IDlinea + 1>
									</cfif>
								</cfif>
							</cfloop>
						</cfif> <!--- Detalle de Ventas --->
						<cfelse>
							<!--- FACTURA / RECIBO SIN DETALLE --->
							<cftry>
							<cfif rsEVentas.Tipo_Venta EQ "R"  >

							<!--- INICIA TRATO PARA  SERVICIOS (PROCONSA) - EGS --->
								<!--- CREDITOS --->
								<!--- SE OBTIENE CUENTA EN EFECTIVO PAGO SERVICIOS EXTERNOS --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="EFS"
										LDDepartamento="NOUSAR"
										LDClasificacion="NOUSAR"
										LDFabricante="NOUSAR"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="NOUSAR"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset ctaEfectivo = Cuenta>

									<!--- SE INSERTA LINEA DEBITO CON EFECTIVO --->
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
											(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											 Oficodigo, Miso4217, CFcodigo,TipoOperacion)
									values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDlinea#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Servicios Externos">,
									 ' ', ' ', 'C', 0, 0, 0, 0,
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Subtotal,'9.99')#">),
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Subtotal * rsEVentas.Tipo_Cambio,'9.99')#">),
									 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
									 getdate(), 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ctaEfectivo.CFformato#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
									 1)
								</cfquery>
								<cfset IDlinea = IDlinea + 1>

								<!--- Comision servicio --->
								<cfif #rsEVentas.comisionRecibo# GT 0>
									<!--- OBTIENE CUENTA COMISION SERVICIOS --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="CMS"
										LDDepartamento="NOUSAR"
										LDClasificacion="NOUSAR"
										LDFabricante="NOUSAR"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="NOUSAR"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset ctaComisionSer = Cuenta>

									<!--- SE INSERTA LINEA DEBITO CON COMISION --->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18
												(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
												 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
												 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
												 Oficodigo, Miso4217, CFcodigo,TipoOperacion)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDlinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Comisi&oacute;n Servicios Externos">,
										 ' ', ' ', 'C', 0, 0, 0, 0,
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.comisionRecibo,'9.99')#">),
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.comisionRecibo,'9.99')#">),
										 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
										 getdate(), 0,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ctaComisionSer.CFformato#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
										 1)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
								</cfif>
							</cfif>
							<!--- TERMINA TRATO PARA  SERVICIOS (PROCONSA) - EGS --->
							<!--- INICIA TRATO PARA  RECIBOS CXC (PROCONSA) - EGS --->
								<cfif rsEVentas.Tipo_Venta EQ "Z">
									<!--- OBTIENE CUENTA RECIBOS CXC --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="REC"
										LDDepartamento="NOUSAR"
										LDClasificacion="NOUSAR"
										LDFabricante="NOUSAR"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="NOUSAR"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset ctaRecibosCxC = Cuenta>

									<!--- SE INSERTA LINEA CREDITO (RECIBOS CXC) --->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18
												(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
												 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
												 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
												 Oficodigo, Miso4217, CFcodigo,TipoOperacion)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDlinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Recibos CxC">,
										 ' ', ' ', 'C', 0, 0, 0, 0,
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Subtotal,'9.99')#">),
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Subtotal * rsEVentas.Tipo_Cambio,'9.99')#">),
										 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
										 getdate(), 0,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ctaRecibosCxC.CFformato#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
										 1)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
								</cfif>
								<!--- TERMINA TRATO PARA  RECIBOS CXC (PROCONSA) - EGS --->
							<cfcatch type="any">
								<cftransaction action="rollback" />
								<cfif isdefined("cfcatch.Message")>
									<cfset Mensaje="#cfcatch.Message#">
								<cfelse>
									<cfset Mensaje="">
								</cfif>
								<cfif isdefined("cfcatch.Detail")>
									<cfset Detalle="#cfcatch.Detail#">
								<cfelse>
									<cfset Detalle="">
								</cfif>
								<cfif isdefined("cfcatch.sql")>
									<cfset SQL="#cfcatch.sql#">
								<cfelse>
									<cfset SQL="">
								</cfif>
								<cfif isdefined("cfcatch.where")>
									<cfset PARAM="#cfcatch.where#">
								<cfelse>
									<cfset PARAM="">
								</cfif>
								<cfif isdefined("cfcatch.StackTrace")>
									<cfset PILA="#cfcatch.StackTrace#">
								<cfelse>
									<cfset PILA="">
								</cfif>

								<cfquery datasource="sifinterfaces">
									insert into SIFLD_Errores
											(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
									values
											('CG_Ventas',
											 'ESIFLD_Facturas_Venta',
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Ecodigo#">,
											 null)
								</cfquery>
							</cfcatch>
							</cftry>

						</cfif>


						<!--- RS TIPO DE PAGO --->
						<cfquery name="rsFPago" datasource="sifinterfaces" timeout="3600">
							select  Ecodigo, ID_DocumentoV, Id_Linea_Pago, Tipo_Pago,
									isnull(Importe,0) as Importe, Moneda, Tipo_Cambio, Especial,
									SocioDocumento, isnull(Comision_Porcentaje,0) as Comision_Porcentaje, Moneda_Origen_LD
							from 	SIFLD_Facturas_Tipo_Pago
							where 	ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">
						</cfquery>

						<cfif isdefined("rsFPago") and rsFPago.recordcount GT 0>
							<cfloop query="rsFPago">

								<!--- MONEDA --->
								<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsFPago.Ecodigo, rsFPago.Moneda, 'Moneda')>
								<cfset varMonedaPag = Equiv.EQUcodigoSIF>

								<!--- Manejo Casos Especiales --->
								<cfif rsFPago.Especial EQ 1>

									<!--- Obtiene cliente --->
									<!--- <cfset VarCteEsp = ExtraeCliente(rsFPago.SocioDocumento, varEcodigo)> --->
									<cfset VarCteEsp = ExtraeCliente(rsEVentas.Cliente, varEcodigo)>
									<!--- La cuenta Deudores Diversos solo se usa para los Casos especiales de Forma de Pago--->
									<!--- Cta. Deudores Diversos  --->
									<!--- DEUDORES DIVERSOS --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="DDV"
										LDDepartamento="NOUSAR"
										LDClasificacion="NOUSAR"
										LDFabricante="NOUSAR"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCteEsp.SNcodigo#"
										Impuestos="NOUSAR"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
										>
									</cfinvoke>
									<cfset CuentaLDDD = Cuenta>

									<!--- Para obtener impuesto con 0% --->
									<cfquery name="rsImpuestoZ" datasource="#session.dsn#">
										select 	min(Icodigo) as Icodigo
										from 	Impuestos
										where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
										and 	Iporcentaje = 0
									</cfquery>
									<cfif rsImpuestoZ.recordcount GT 0>
										<cfset varImpuestoZ = rsImpuestoZ.Icodigo>
									<cfelse>
										<cfset varImpuestoZ = "">
									</cfif>

									<cfset varEspControl = numberformat(right("#Maximus#",2),"00")>
									<cfset varEspControl = varEspControl & numberformat(right("#VarCteEsp.SNcodigo#",2),"00")>
									<!--- Arma Numero Documento --->
									<cfset NumDocEsp = "E"  & varEspControl & "-" & numberformat(rsEVentas.Sucursal,"0000") & "-" & right(rsEVentas.Numero_Documento,9)>

									<!--- Verifica si se debe insertar Encabezado para el documento especial--->
									<cfquery name="rsVerificaEsp" datasource="sifinterfaces">
										select 	ID
										from 	SIFLD_IE10
										where 	Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDocEsp#">
										and 	NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPago.SocioDocumento#">
										and 	Modulo = 'CC'
										and 	CodigoTransacion = 'FC'
									</cfquery>
									<cfif rsVerificaEsp.recordcount EQ 0>
										<cfset RsMaximo = ExtraeMaximo("IE10","ID")>
										<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
											<cfset MaximusEsp = RsMaximo.Maximo>
										<cfelse>
											<cfset MaximusEsp = 1>
										</cfif>

										<!--- Se Inserta un Documento en la Interfaz 10 para el socio indicado y el monto pagado --->
										<cfquery datasource="sifinterfaces">
											insert into SIFLD_IE10
													(ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion,
													 Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento,
													 DiasVencimiento, Facturado, Origen, VoucherNo, CodigoRetencion,
													 CodigoOficina, CuentaFinanciera, CodigoConceptoServicio,
													 CodigoDireccionEnvio, CodigoDireccionFact, BMUsucodigo,
													 ConceptoCobroPago, StatusProceso, Dtipocambio,
													 CEcodigo, Usulogin, Usucodigo)
											values (
												  <cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
												  <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
												  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPago.SocioDocumento#">,
												  'CC',
												  'FC',
												  <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDocEsp#">,
												  null,
												  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
												  <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">,
												  <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">,
												  0,
												  'S',
												  'LDCC',
												  0,
												  null,
												  <cfqueryparam cfsqltype="cf_sql_char" value="#VarOficina#">,
												  null, null, null, null,
												  <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#"><!---VERIFICAR ABG--->,
												  null <!---VERIFICAR--->,
												  10,
												  <cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(rsFPago.Tipo_Cambio,'9.9999')#">,
												  <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
												  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
												  <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">)
										</cfquery>
										<cfset IDlineaEsp = 1>
									<cfelse>
										<cfset MaximusEsp = rsVerificaEsp.ID>
										<cfquery name="rsLineaEsp" datasource="sifinterfaces">
											select 	isnull(max(Consecutivo),0) + 1 as Linea
											from 	SIFLD_ID10
											where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsVerificaEsp.ID#">
										</cfquery>
										<cfset IDlineaEsp = rsLineaEsp.Linea>
									</cfif>
									<!--- inserta Detalle SIFLD_IE10 --->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID10
												(ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraCarga, FechaHoraSalida,
												 PrecioUnitario, CodigoUnidadMedida, CantidadTotal, CantidadNeta, CodEmbarque,
												 NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto,
												 ImporteDescuento, CodigoAlmacen, CodigoDepartamento, CentroFuncional,
												 CuentaFinancieraDet, BMUsucodigo, PrecioTotal)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
										  <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlineaEsp#">,
										  'S',
										  'VENTA',
										  ' ', getdate(), getdate(),
										  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFPago.Importe,"9.99")#">,
										  ' ',
										  1,
										  1,
										  ' ', ' ', getdate(), ' ', ' ',
										  null,
										  null,
										  null,
										  ' ',
										  ' ',
										  <cfqueryparam cfsqltype="cf_sql_char" value="#varCF#">,
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
										  <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">,
										  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFPago.Importe,"9.99")#">)
									</cfquery>

									<!--- Introduce registro en la Cola de Procesos de la interfaz  --->
									<cfquery datasource="sifinterfaces">
										insert #rsColaP# (ID,Consecutivo,Ecodigo,Interfaz)
										values  (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
												 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlineaEsp#">,
												 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
												 10)
									</cfquery>

									<cfquery datasource="sifinterfaces">
										update 	ESIFLD_Facturas_Venta
										set 	ID10 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MaximusEsp#">
										where 	ID_DocumentoV = #DocumentoFact#
									</cfquery>
								</cfif> <!---Casos Especiales--->

								<!--- Si no se Prorratean las formas de pago --->
								<cfif ParPrrat EQ false>
									<!--- Si el Documento tiene IVA, calcula el IVA correspondiente a Este Tipo de Pago --->
									<!---<cfif rsEVentas.Impuesto GT 0>
										<cfset PImpuesto = (rsFPago.Importe/rsEVentas.Total) * rsEVentas.Impuesto>
										<cfset Ingreso = rsFPago.Importe - PImpuesto>
									<cfelse> --->
										<cfset Ingreso = rsFPago.Importe>
									<!---</cfif>--->

									<!--- Calcula y Quita el porcentaje de Comision al Ingreso --->
									<cfset Comision = rsFPago.Importe * rsFPago.Comision_Porcentaje>
									<cfset Ingreso = Ingreso - Comision>
									<cfset PagoMonedaExtranjera = false>

									<!---Descripcion de la Poliza --->
										<cfif rsFPago.Tipo_Pago EQ "E">
											<cfset DescPol = "Efectivo">
											<!--- UNICAMENTE PARA IDENTIFICAR SI ES PAGO EN EFECTIVO CON MONEDA EXTRANJERA --->
											<cfif rsFPago.Moneda_Origen_LD NEQ 1 AND rsFPago.Moneda_Origen_LD NEQ 0>
												<cfset DescPol = "Efectivo (Moneda Extranjera)">
												<cfset PagoMonedaExtranjera = true>
											</cfif>
										<cfelseif rsFPago.Tipo_Pago EQ "T">
											<cfset DescPol = "Tarjeta">
										<cfelseif rsFPago.Tipo_Pago EQ "V">
											<cfset DescPol = "Cupones">
										<cfelseif rsFPago.Tipo_Pago EQ "H">
											<cfset DescPol = "Cheque">
										<cfelseif rsFPago.Tipo_Pago EQ "X">
											<cfset DescPol = "Moneda Extranjera">
										<cfelseif rsFPago.Tipo_Pago EQ "N">
											<cfset DescPol = "Nota de Credito">
										<cfelseif rsFPago.Tipo_Pago EQ "M">
											<cfset DescPol = "Monedero">
										<cfelseif rsFPago.Tipo_Pago EQ "P">
											<cfset DescPol = "Transferencia">
										<cfelseif rsFPago.Tipo_Pago EQ "C">
											<cfset DescPol = "Co-Pago">
										</cfif>
										<cfif rsFPago.Especial EQ 1>
											<cfset DescPol = "Forma Pago Especial #DescPol#">
										</cfif>
									<!------->

									<!--- Cuentas Por tipo de Pago --->
									<!--- Efectivo en moneda local  --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="EFC"
										LDDepartamento="NOUSAR"
										LDClasificacion="NOUSAR"
										LDFabricante="NOUSAR"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="NOUSAR"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset CuentaLDEF = Cuenta>

									<cfif isdefined("PagoMonedaExtranjera") AND #PagoMonedaExtranjera# EQ true>
										<!--- EFECTIVO MONEDA EXT --->
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="EFX"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDEFX = Cuenta>
									</cfif>

									<cfif rsFPago.Tipo_Pago EQ "T" <!--- OR rsFPago.Tipo_Pago EQ "V" ---> OR rsFPago.Tipo_Pago EQ "C">
										<!--- CUENTA BANCARIA  --->
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="CBN"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDBC = Cuenta>

										<!--- COMISIONES BANCARIAS  --->
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="CMB"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDCB = Cuenta>
									</cfif>

									<!--- <cfif rsFPago.Tipo_Pago EQ "N" OR rsFPago.Tipo_Pago EQ "M" OR rsFPago.Tipo_Pago EQ "P"> --->
									<cfif rsFPago.Tipo_Pago EQ "N" OR rsFPago.Tipo_Pago EQ "M">
										<!--- DESCUENTOS SOBRE VENTAS  --->
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="DSV"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDDV = Cuenta>
									</cfif>

									<!--- CUP, Complemento Financiero para pago en cupones --->
									<cfif rsFPago.Tipo_Pago EQ "V">
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="CUP"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDCUP = Cuenta>
									</cfif>

									<!--- CHE, Complemento Financiero para pago con cheques --->
									<cfif rsFPago.Tipo_Pago EQ "H">
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="CHE"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDCHE = Cuenta>
									</cfif>

									<!--- TRA, Complemento Financiero para pago con cheques --->
									<cfif rsFPago.Tipo_Pago EQ "P">
										<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
											Oorigen="#varOrigen#"
											Ecodigo="#varEcodigo#"
											Conexion="#session.dsn#"
											LDOperacion="TRA"
											LDDepartamento="NOUSAR"
											LDClasificacion="NOUSAR"
											LDFabricante="NOUSAR"
											LDTipoVenta="#rsEVentas.Tipo_Venta#"
											SNegocios="#varCte.sncodigo#"
											Impuestos="NOUSAR"
											Oficinas="#VarOcodigo#"
											LDConceptoRetiroCaja="NOUSAR"
											Almacen="NOUSAR"
											Bancos="#varBanco#"
											LDCuentaBanco="#varCtaBanco#"
											LDMovimientoInventario="NOUSAR"
											LDAlmacen="NOUSAR"
											LDTipoRetiroCaja="NOUSAR"
										>
										<cfset CuentaLDTRA = Cuenta>
									</cfif>

									<!---Inserta el detalle a la poliza Para la Forma de Pago--->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18 (
											ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											Oficodigo, Miso4217, CFcodigo,TipoOperacion)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en #DescPol#">,
										 ' ', ' ', 'D', 0, 0, 0, 0,
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Ingreso,'9.99')#">),
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Ingreso * rsFPago.Tipo_Cambio,'9.99')#">),
										 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
										 getdate(), 0,
										 <cfif rsFPago.Especial EQ 1>
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
										 <cfelse>
											 <cfif rsFPago.Tipo_Pago EQ "E">
												<cfif isdefined("PagoMonedaExtranjera") AND #PagoMonedaExtranjera# EQ true>
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEFX.CFformato#">,
												<cfelse>
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
												</cfif>
											 <cfelseif rsFPago.Tipo_Pago EQ "T">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "V">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCUP.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "H">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCHE.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "X">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "N">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "M">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "P">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDTRA.CFformato#">,
											 <cfelseif rsFPago.Tipo_Pago EQ "C">
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
											 </cfif>
										 </cfif>
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
										 <cfif rsFPago.Especial EQ 1>
											 20
										 <cfelse>
											 <cfif rsFPago.Tipo_Pago EQ "E">
												3
											 <cfelseif rsFPago.Tipo_Pago EQ "T">
												4
											 <cfelseif rsFPago.Tipo_Pago EQ "V">
												5
											 <cfelseif rsFPago.Tipo_Pago EQ "H">
												6
											 <cfelseif rsFPago.Tipo_Pago EQ "X">
												7
											 <cfelseif rsFPago.Tipo_Pago EQ "N">
												8
											 <cfelseif rsFPago.Tipo_Pago EQ "M">
												9
											 <cfelseif rsFPago.Tipo_Pago EQ "P">
												10
											 <cfelseif rsFPago.Tipo_Pago EQ "C">
												11
											 </cfif>
										 </cfif>)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>

									<cfif rsFPago.Comision_Porcentaje GT 0>
										<!--- Insercion de Comision Bancaria "LDCB" (Comisiones Bancarias) --->
										<cfquery datasource="sifinterfaces">
											insert into SIFLD_ID18
												(
												 ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
												 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
												 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
												 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
											values
											(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="Comision Bancaria">,
											 ' ', ' ', 'D', 0, 0, 0, 0,
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision,'9.99')#">),
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision * rsFPago.Tipo_Cambio,'9.99')#">),
											 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
											 getdate(), 0,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCB.CFformato#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
											 19)
										</cfquery>
										<cfset IDlinea = IDlinea + 1>
									</cfif>
								</cfif> <!--- Parametro Prorrateo--->
							</cfloop> <!---Formas de Pago--->
						<cfelse>
							<!--- SIN FORMA DE PAGO --->
							<!--- MONEDA --->
								<cfset Equiv = ConversionEquivalencia  (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsEVentas.Moneda, 'Moneda')>
								<cfset varMonedaPag = Equiv.EQUcodigoSIF>
							<cfif rsEVentas.Tipo_Venta EQ "X">
								<!--- SE TRATA DE UNA DEVOLUCION EN EFECTIVO, POR LO TANTO
								SE AGREGA LA LINEA CON MONTO NEGATIVO PARA EFECTIVO --->
								<!--- EFECTIVO PESOS --->
									<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
										Oorigen="#varOrigen#"
										Ecodigo="#varEcodigo#"
										Conexion="#session.dsn#"
										LDOperacion="EFC"
										LDDepartamento="NOUSAR"
										LDClasificacion="NOUSAR"
										LDFabricante="NOUSAR"
										LDTipoVenta="#rsEVentas.Tipo_Venta#"
										SNegocios="#varCte.sncodigo#"
										Impuestos="NOUSAR"
										Oficinas="#VarOcodigo#"
										LDConceptoRetiroCaja="NOUSAR"
										Almacen="NOUSAR"
										Bancos="#varBanco#"
										LDCuentaBanco="#varCtaBanco#"
										LDMovimientoInventario="NOUSAR"
										LDAlmacen="NOUSAR"
										LDTipoRetiroCaja="NOUSAR"
									>
									<cfset CuentaEfectivoDev = Cuenta>

									<!---Inserta el detalle a la poliza Para la Forma de Pago--->
									<cfquery datasource="sifinterfaces">
										insert into SIFLD_ID18 (
											ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											Oficodigo, Miso4217, CFcodigo,TipoOperacion)
										values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Efectivo">,
										 ' ', ' ', 'D', 0, 0, 0, 0,
										 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Total*-1,'9.99')#">,
										 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Total*-1,'9.99')#">,
										 1,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
										 getdate(), 0,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaEfectivoDev.CFformato#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
										 <!--- Pago en efectivo 3 --->
										 3)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
							</cfif>
						</cfif>

						<!--- Manejo de los cambios de Factura --->
						<!--- SI EL CAMPO FACTURA CAMBIO ES MAYOR DE 0 Y NO EXISTE LA FORMA DE PAGO EFECTIVO, SE REALIZA UNA SALIDA DE EFECTIVO EN CAJA, REFLEJANDO EL CAMBIO DADO--->
						<cfif rsEVentas.Factura_Cambio GT 0>
							<cfquery name="rsVerificaEfe" datasource="sifinterfaces">
								SELECT 	count(1) AS Efectivo
								FROM 	SIFLD_Facturas_Tipo_Pago
								WHERE 	ID_DocumentoV = #DocumentoFact#
								AND 	Tipo_Pago LIKE 'E'
							</cfquery>

							<cfif rsVerificaEfe.Efectivo LTE 0>
								<!--- CAMBIO EN EFECTIVO  --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="#varOrigen#"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="CEF"
									LDDepartamento="NOUSAR"
									LDClasificacion="NOUSAR"
									LDFabricante="NOUSAR"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="NOUASR"
									Oficinas="#VarOcodigo#"
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCtaBanco#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDCE = Cuenta>
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
											(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											Oficodigo, Miso4217, CFcodigo, TipoOperacion)
									values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Cambio en Efectivo">,
									 ' ', ' ',  'C', 0, 0, 0, 0,
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Cambio,'9.99')#">),
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Cambio,'9.99')#">),
									 1,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
									 getdate(), 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCE.CFformato#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
									 22)
								</cfquery>
								<cfset IDlinea = IDlinea + 1>
							</cfif>
						</cfif>
						<!--- REDONDEO DE MONEDA --->
						<cfif rsEVentas.Redondeo GT 0>
							<!--- BUSCA CUENTA PARA REDONDEO DE MONEDA PARAMETRO 100 --->
							<cfquery name="rsCuentaRed" datasource="#session.dsn#">
								SELECT 	Cformato
								FROM 	CContables c
									INNER JOIN Parametros p
									ON 	c.Ecodigo = p.Ecodigo
									AND c.Ccuenta = p.Pvalor
								WHERE 	p.Pcodigo = 100
								AND 	p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							</cfquery>
							<cfif isdefined("rsCuentaRed") AND rsCuentaRed.recordcount EQ 1 and len(trim(rsCuentaRed.Cformato)) GT 0>
								<cfset varCuentaRed = rsCuentaRed.Cformato>
							</cfif>
							<cfif isdefined("varCuentaRed") AND len(trim(varCuentaRed)) GT 0>
								<!--- insert SIFLD_ID18 --->
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
											(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
											Oficodigo, Miso4217, CFcodigo, TipoOperacion)
									values
											(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
											 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="Redondeo de Moneda">,
											 ' ', ' ',  'C', 0, 0, 0, 0,
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Redondeo,'9.99')#">),
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Redondeo,'9.99')#">),
											 1,
											 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
											 getdate(), 0,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaRed#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
											 23)
								</cfquery>
							</cfif>
						</cfif>

						<!--- Marca o Borra las Tablas Origen Registro Procesado --->
						<!--- BORRADO DE TABLAS ORIGEN --->
						<cfquery datasource="sifinterfaces">
							<cfif Parborrado>
								delete  DSIFLD_Facturas_Venta where ID_DocumentoV = #DocumentoFact#
								delete  SIFLD_Facturas_Tipo_Pago where ID_DocumentoV = #DocumentoFact#
								delete  ESIFLD_Facturas_Venta where ID_DocumentoV = #DocumentoFact#
							<cfelse>
								update 	ESIFLD_Facturas_Venta
								set 	Estatus = 92,
										ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
										Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										Periodo = #Periodo#,
										Mes = #Mes#
								where 	ID_DocumentoV = #DocumentoFact#
							</cfif>
						</cfquery>
						<cfset varProcesado = true>
					<cfcatch type="any"> <!---Error en Ventas --->
						<cfset varProcesado =  false>
						<!--- Marca El registro con Error--->
						<cfquery datasource="sifinterfaces">
							update 	ESIFLD_Facturas_Venta
							set 	Estatus = 6
							where 	ID_DocumentoV = #DocumentoFact#
						</cfquery>

						<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
						<cfif varBorraRegistro>
							<cfif isdefined("Maximus") and Maximus NEQ 0>
								<cfquery datasource="sifinterfaces">
									delete 	SIFLD_ID18
									where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
								</cfquery>
								<cfquery datasource="sifinterfaces">
									delete 	SIFLD_IE18
									where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
								</cfquery>
							</cfif>
						<cfelse>
							<cfif isdefined("Maximus") and Maximus NEQ 0 and isdefined("IDStart")>
								<cfquery datasource="sifinterfaces">
									delete 	SIFLD_ID18
									where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
									and 	DCIconsecutivo > <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDStart#">
								</cfquery>
						   </cfif>
						</cfif>
						<!--- Delete SIFLD_ID10 --->
						<cfquery datasource="sifinterfaces">
							delete 	SIFLD_ID10
							from 	SIFLD_ID10 a
							where 	exists (select 1 from #rsColaP# b where a.ID = b.ID and a.Consecutivo = b.Consecutivo)
						</cfquery>
						<!--- Delete SIFLD_IE10 --->
						<cfquery datasource="sifinterfaces">
							delete 	SIFLD_IE10
							from 	SIFLD_IE10 a
								inner join 	#rsColaP# b on a.ID = b.ID
							where 	not exists (select 1 from SIFLD_ID10 b where a.ID = b.ID)
						</cfquery>

						<cfif isdefined("cfcatch.Message")>
							<cfset Mensaje="#cfcatch.Message#">
						<cfelse>
							<cfset Mensaje="">
						</cfif>
						<cfif isdefined("cfcatch.Detail")>
							<cfset Detalle="#cfcatch.Detail#">
						<cfelse>
							<cfset Detalle="">
						</cfif>
						<cfif isdefined("cfcatch.sql")>
							<cfset SQL="#cfcatch.sql#">
						<cfelse>
							<cfset SQL="">
						</cfif>
						<cfif isdefined("cfcatch.where")>
							<cfset PARAM="#cfcatch.where#">
						<cfelse>
							<cfset PARAM="">
						</cfif>
						<cfif isdefined("cfcatch.StackTrace")>
							<cfset PILA="#cfcatch.StackTrace#">
						<cfelse>
							<cfset PILA="">
						</cfif>

						<cfquery datasource="sifinterfaces">
							insert into SIFLD_Errores
									(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
							values
									('CG_Ventas',
									 'ESIFLD_Facturas_Venta',
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Ecodigo#">,
									 null)
						</cfquery>
					</cfcatch>
					</cftry>
				</cfloop> <!--- Encabezados Ventas --->
			</cfloop>
			<!--- 	  AJUSTE POR ERROR DE REDONDEO EN LD -- QUITAR CUANDO LD CORRIJA EL REDONDEO --->
			<!--- <cfif varProcesado> --->
				<!--- TRAE REGISTROS INSERTADOS --->
				<cfquery name="rsRegistrosSIFLDIE18" datasource="sifinterfaces">
					SELECT DISTINCT ID FROM SIFLD_IE18
				</cfquery>
				<!--- Verifica Cuadre De Polizas --->
				<cfloop query="rsRegistrosSIFLDIE18">
					<cfquery name="rsVerificaCuadre" datasource="sifinterfaces">
						SELECT 	isnull(
									(select SUM(Dlocal) from SIFLD_ID18 WHERE ID = #rsRegistrosSIFLDIE18.ID# AND Dmovimiento = 'C') -
									(select SUM(Dlocal) from SIFLD_ID18 WHERE ID = #rsRegistrosSIFLDIE18.ID# AND Dmovimiento = 'D'),0
								) as Diferencia
					</cfquery>
					<cfif rsVerificaCuadre.Diferencia NEQ 0>
						<cfquery name="datos" datasource="sifinterfaces">
							SELECT 	Oficodigo, Ecodigo, Miso4217, Eperiodo, Emes, Cconcepto, CFcodigo
							FROM 	SIFLD_ID18
							WHERE 	ID = #rsRegistrosSIFLDIE18.ID#
							GROUP BY Oficodigo, Ecodigo, Miso4217, Eperiodo, Emes, Cconcepto, CFcodigo
						</cfquery>
						<!--- TRAE LINEA A INSERTAR --->
						<cfquery name="rsLineaDetalle" datasource="sifinterfaces">
							SELECT MAX(DCIconsecutivo) as IDLinea
							FROM 	SIFLD_ID18
							WHERE 	ID = #rsRegistrosSIFLDIE18.ID#
						</cfquery>
						<cfset IDLinea = rsLineaDetalle.IDLinea + 1>
						<!--- TRAE CUENTA DE REDONDEO --->
						<cfquery name="rsCuentaRed" datasource="#session.dsn#">
							SELECT 	Cformato
							FROM 	CContables c
								INNER JOIN Parametros p
								ON 	c.Ecodigo = p.Ecodigo
								AND c.Ccuenta = p.Pvalor
							WHERE 	p.Pcodigo = 100
							AND 	p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						</cfquery>
						<cfif isdefined("rsCuentaRed") AND rsCuentaRed.recordcount EQ 1 and len(trim(rsCuentaRed.Cformato)) GT 0>
							<cfset varCuentaRed = rsCuentaRed.Cformato>
						</cfif>
						<cfif isdefined("varCuentaRed") AND len(trim(varCuentaRed)) GT 0>
							<!--- insert SIFLD_ID18 --->
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_ID18
										(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
										Oficodigo, Miso4217, CFcodigo, TipoOperacion)
								values
										(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsRegistrosSIFLDIE18.ID#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Datos.Ecodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, "yyyy/mm/dd")#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Datos.Eperiodo#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#Datos.Emes#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste por Redondeo de Moneda">,
										 ' ', ' ',
										 <cfif rsVerificaCuadre.Diferencia GT 0>
										 	'D'
										 <cfelseif rsVerificaCuadre.Diferencia LT 0>
										 	'C'
										 </cfif>
										 ,
										 0, 0, 0, 0,
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsVerificaCuadre.Diferencia,'9.99')#">),
										 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsVerificaCuadre.Diferencia,'9.99')#">),
										 1,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Cconcepto#">,
										 getdate(), 0,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaRed#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.Oficodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.Miso4217#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.CFcodigo#">,
										 23)
							</cfquery>
						</cfif>
					</cfif>
				</cfloop> <!--- Termina loop rsIDEVentas --->
			<!--- </cfif> --->
			<!--- END AJUSTE POR ERROR DE REDONDEO EN LD -- QUITAR CUANDO LD CORRIJA EL REDONDEO --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select 	count(1) as Registros from ESIFLD_Facturas_Venta
				where 	Estatus in (99,100,10,11)
			</cfquery>

			<cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz de forma Masiva--->
				<cftransaction action="begin">
				<cftry>
					<cfquery datasource="sifinterfaces">
						delete 	SIFLD_ID18B where Interfaz = 'CG_Ventas'
					</cfquery>
					<!---Prepara los registros para ser insertados--->
					<!--- SIFLD_IE18 --->
					<cfquery datasource="sifinterfaces">
						update 	SIFLD_IE18
							set Interfaz = 'CG_Ventas', Estatus = 1
						where 	ID in (select ID18
									 from 	ESIFLD_Facturas_Venta
									 where 	Estatus in (92))
					</cfquery>
					<!--- SIFLD_IE10 --->
					<cfquery datasource="sifinterfaces">
						update 	SIFLD_IE10
							set Interfaz = 'CG_Ventas', Estatus = 1
						where 	ID in (select ID10
									 from 	ESIFLD_Facturas_Venta
									 where 	Estatus in (92))
					</cfquery>

					<!--- Inserta En las Interfaz 18--->
					<cfquery datasource="sifinterfaces">
						insert into IE18
								(ID, Ecodigo, Cconcepto, Eperiodo, Emes,
								 Efecha, Edescripcion, Edocbase, Ereferencia,
								 Falta, Usuario, ECIreversible)
						select
								ID, Ecodigo, Cconcepto, Eperiodo, Emes,
								Efecha, Edescripcion, Edocbase, Ereferencia,
								Falta, Usuario, ECIreversible
						from 	SIFLD_IE18 a
						where 	Interfaz = 'CG_Ventas' and Estatus = 1
					</cfquery>

					<cfif ParAgrupa>
						<!--- inserta SIFLD_ID18B --->
						<cfquery datasource="sifinterfaces">
							insert into SIFLD_ID18B
								   (ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
									Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
									CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
									Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
									Referencia1, Referencia2, Referencia3, CFcodigo, Interfaz,
								 	Consecutivo)
							select 	ID, 0 as Consecutivo, Ecodigo, getdate(), Eperiodo, Emes,
									Ddescripcion, '','', Dmovimiento, null,
									null, null, null, sum(Doriginal), sum(Dlocal), Dtipocambio,
									Cconcepto, getdate(), EcodigoRef, CFformato, Oficodigo, Miso4217,
									null, null, null, CFcodigo, 'CG_Ventas', 0
							from 	SIFLD_ID18 a
							where 	exists (select 1
										  from SIFLD_IE18 b
										  where a.ID = b.ID and b.Interfaz = 'CG_Ventas' and b.Estatus = 1)
							group by ID, Ecodigo, Eperiodo, Emes, EcodigoRef, Oficodigo, Cconcepto,
									 TipoOperacion, Dmovimiento, Ddescripcion, CFformato, Miso4217,
									 Dtipocambio, CFcodigo
							order by ID
						</cfquery>

						<!--- Actualiza Consecutivo --->
						<cfquery datasource="sifinterfaces">
							declare @Consecutivo numeric(18,0)
							select 	@Consecutivo = 0
							update 	SIFLD_ID18B
							set  	Consecutivo  = @Consecutivo,
									@Consecutivo = @Consecutivo + 1
							where 	Interfaz = 'CG_Ventas'
						</cfquery>

						<cfset varConsecutivo = 0>
						<cfset varID = 0>

						<cfquery name="rsConsecutivo" datasource="sifinterfaces">
							select 	ID, Consecutivo
							from 	SIFLD_ID18B
							where 	Interfaz = 'CG_Ventas'
							order by ID, Consecutivo
						</cfquery>

						<cfloop query="rsConsecutivo">
							<cfif rsConsecutivo.ID NEQ varID>
								<cfset varConsecutivo = 1>
								<cfset varID = rsConsecutivo.ID>
							<cfelse>
								<cfset varConsecutivo = varConsecutivo + 1>
							</cfif>
							<!--- Inserta SIFLD_ID18B --->
							<cfquery datasource="sifinterfaces">
								update 	SIFLD_ID18B
								set  	DCIconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varConsecutivo#">
								where 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivo.ID#">
								and 	Consecutivo = <cfqueryparam cfsqltype="cf_sql_inetger" value="#rsConsecutivo.Consecutivo#">
								and 	Interfaz = 'CG_Ventas'
							</cfquery>
						</cfloop>
						<!--- Inserta ID18 --->
						<cfquery datasource="sifinterfaces">
							insert into ID18
								(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
								 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
								 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								 Referencia1, Referencia2, Referencia3, CFcodigo)
							select
								ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
								CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
								Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								Referencia1, Referencia2, Referencia3, CFcodigo
							from SIFLD_ID18B where Interfaz = 'CG_Ventas'
						</cfquery>
					<cfelse>
						<!--- Inserta ID18 --->
						<cfquery datasource="sifinterfaces">
							insert into ID18
								(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
								 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
								 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								 Referencia1, Referencia2, Referencia3, CFcodigo)
							select
								ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, null,
								null, null, null, Doriginal, Dlocal, Dtipocambio,
								Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								Referencia1, Referencia2, Referencia3, CFcodigo
							from SIFLD_ID18 a
							where exists (select 1
										  from SIFLD_IE18 b
										  where a.ID = b.ID and b.Interfaz = 'CG_Ventas' and b.Estatus = 1)
						</cfquery>
					</cfif>
					<!--- Inserta en la Interfaz 10 Casos Especiales --->
					<cfquery datasource="sifinterfaces">
						insert into IE10
							(ID,
							 EcodigoSDC,
							 NumeroSocio,
							 Modulo,
							 CodigoTransacion,
							 Documento,
							 Estado,
							 CodigoMoneda,
							 FechaDocumento,
							 FechaVencimiento,
							 DiasVencimiento,
							 Facturado,
							 Origen,
							 VoucherNo,
							 CodigoRetencion,
							 CodigoOficina,
							 CuentaFinanciera,
							 CodigoConceptoServicio,
							 CodigoDireccionEnvio,
							 CodigoDireccionFact,
							 FechaTipoCambio,
							 Dtipocambio,
							 BMUsucodigo,
							 ConceptoCobroPago,
							 StatusProceso)
						 select a.ID, a.EcodigoSDC, a.NumeroSocio, a.Modulo, a.CodigoTransacion,
							 a.Documento, a.Estado, a.CodigoMoneda, a.FechaDocumento, a.FechaVencimiento,
							 a.DiasVencimiento, a.Facturado, a.Origen, a.VoucherNo, a.CodigoRetencion,
							 a.CodigoOficina, a.CuentaFinanciera, a.CodigoConceptoServicio,
							 a.CodigoDireccionEnvio, a.CodigoDireccionFact,
							 a.FechaTipoCambio, a.Dtipocambio, a.BMUsucodigo, a.ConceptoCobroPago, a.StatusProceso
						 from SIFLD_IE10 a
						 where Interfaz = 'CG_Ventas' and Estatus = 1
					</cfquery>
					<!--- ID10 --->
					<cfquery datasource="sifinterfaces">
						insert into ID10
								(ID,
								 Consecutivo,
								 TipoItem,
								 CodigoItem,
								 NombreBarco,
								 FechaHoraCarga,
								 FechaHoraSalida,
								 PrecioUnitario,
								 CodigoUnidadMedida,
								 CantidadTotal,
								 CantidadNeta,
								 CodEmbarque,
								 NumeroBOL,
								 FechaBOL,
								 TripNo,
								 ContractNo,
								 CodigoImpuesto,
								 ImporteImpuesto,
								 ImporteDescuento,
								 CodigoAlmacen,
								 CodigoDepartamento,
								 CentroFuncional,
								 CuentaFinancieraDet,
								 BMUsucodigo,
								 PrecioTotal,
								 DDdescripcion)
						select a.ID, a.Consecutivo, a.TipoItem, a.CodigoItem, a.NombreBarco,
								 a.FechaHoraCarga, a.FechaHoraSalida, a.PrecioUnitario, a.CodigoUnidadMedida, a.CantidadTotal,
								 a.CantidadNeta, a.CodEmbarque, a.NumeroBOL, a.FechaBOL, a.TripNo,
								 a.ContractNo, a.CodigoImpuesto, a.ImporteImpuesto, a.ImporteDescuento, a.CodigoAlmacen,
								 a.CodigoDepartamento, a.CentroFuncional, a.CuentaFinancieraDet, a.BMUsucodigo,
								 a.PrecioTotal, a.DDdescripcion
						from SIFLD_ID10 a
						where exists (select 1
										  from SIFLD_IE10 b
										  where a.ID = b.ID and b.Interfaz = 'CG_Ventas' and b.Estatus = 1)
					</cfquery>
					<!--- Dispara Interfaz --->
					<cfquery datasource="sifinterfaces">
						insert into InterfazColaProcesos (
							CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
							EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
							FechaInclusion, Cancelar, UsucodigoInclusion, UsuarioBdInclusion)
						select
						  a.CEcodigo,
						  18,
						  ID,
						  0 as SecReproceso,
						  a.EcodigoSDC,
						  'E' as OrigenInterfaz,
						  'A' as TipoProcesamiento,
						  1 as StatusProceso,
						  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
						  0 as Cancelar,
						  a.Usucodigo,
						  a.Usulogin
						from SIFLD_IE18 a
						where Interfaz = 'CG_Ventas' and Estatus = 1
					</cfquery>
					<!--- Inserta en cola --->
					<cfquery datasource="sifinterfaces">
						insert into InterfazColaProcesos (
								CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
								EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
								FechaInclusion, Cancelar, UsucodigoInclusion, UsuarioBdInclusion)
						select
								a.CEcodigo,
								10,
								ID,
								0 as SecReproceso,
								a.EcodigoSDC,
								'E' as OrigenInterfaz,
								'A' as TipoProcesamiento,
								1 as StatusProceso,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
								0 as Cancelar,
								a.Usucodigo,
								a.Usulogin
						from SIFLD_IE10 a
						where Interfaz = 'CG_Ventas' and Estatus = 1
					</cfquery>

					<!--- Marca Factura Venta como procesada --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Venta
							SET Estatus = 2
							where 	Estatus in (92)
							and 	ID18 in (select ID from SIFLD_IE18
									 where Interfaz = 'CG_Ventas' and Estatus = 1)
					</cfquery>
					<cfset updTimbreFiscal = updateFiscal('C')>
					<!---<cfset AgrupaFVC = AgrupaVentasCredito()>	--->
					<cftransaction action="commit" />
				<cfcatch>
					<cftransaction action="rollback" />
					<cfif isdefined("cfcatch.Message")>
						<cfset Mensaje="#cfcatch.Message#">
					<cfelse>
						<cfset Mensaje="">
					</cfif>
					<cfif isdefined("cfcatch.Detail")>
						<cfset Detalle="#cfcatch.Detail#">
					<cfelse>
						<cfset Detalle="">
					</cfif>
					<cfif isdefined("cfcatch.sql")>
						<cfset SQL="#cfcatch.sql#">
					<cfelse>
						<cfset SQL="">
					</cfif>
					<cfif isdefined("cfcatch.where")>
						<cfset PARAM="#cfcatch.where#">
					<cfelse>
						<cfset PARAM="">
					</cfif>
					<cfif isdefined("cfcatch.StackTrace")>
						<cfset PILA="#cfcatch.StackTrace#">
					<cfelse>
						<cfset PILA="">
					</cfif>
					<cfset MensajeError= #Mensaje# & #Detalle#>
					<!--- Bitacora SIFLD_Errores --->
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
						(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
						select 'CG_Ventas', 'ESIFLD_Facturas_Venta',  ID_DocumentoV,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
							Ecodigo,
							null
						from ESIFLD_Facturas_Venta
					</cfquery>
					<!--- Marca Factura Con error --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Venta set Estatus = 6
						where 	Estatus in (92)
						and 	ID18 in (select ID from SIFLD_IE18
									where Interfaz = 'CG_Ventas' and Estatus = 1)
					</cfquery>
				</cfcatch>
				</cftry>
				</cftransaction>
				<!--- Borra SIFLD_ID18 --->
				<cfquery datasource="sifinterfaces">
					delete 	SIFLD_ID18
					where 	ID in (select ID18 from ESIFLD_Facturas_Venta where Estatus in (2,6))
				</cfquery>
				<!--- Borra SIFLD_IE18 --->
				<cfquery datasource="sifinterfaces">
					delete SIFLD_IE18
					where ID in (select ID18 from ESIFLD_Facturas_Venta where Estatus in (2,6))
				</cfquery>
				<!--- Borra SIFLD_ID10 --->
				<cfquery datasource="sifinterfaces">
					delete 	SIFLD_ID10
					<!---where 	ID in (select ID10 from ESIFLD_Facturas_Venta where Estatus in (2,6))--->
				</cfquery>
				<!--- Borra SIFLD_IE10 --->
				<cfquery datasource="sifinterfaces">
					delete 	SIFLD_IE10
					<!---where 	ID in (select ID10 from ESIFLD_Facturas_Venta where Estatus in (2,6))--->
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateFiscal" access="private" output="false">
		<cfargument name="TipoVenta" required="false" default="C"><!--- 'C' credito, 'P' contado --->
		<cfif Arguments.TipoVenta EQ "P">
			<cfquery datasource="sifinterfaces">
				UPDATE	v
				SET		v.TimbreFiscal = t.Fiscal_UUID,
						v.Factura = t.Factura,
				<!--- ---		v.Fecha_Venta =  t.Fiscal_FechaTimbrado     <---- Valor anterior ALG 23/08/2017 --->
						v.Fecha_Venta = (
					case  when  Tipo_Documento = 'NC'	then
						v.Fecha_Operacion
							else
						t.Fiscal_FechaTimbrado end)
				FROM	ESIFLD_Facturas_Venta v
				INNER JOIN SIFLD_Timbres_Fiscales t
					ON	v.Ecodigo = t.Cadena_Id
					AND v.Numero_Documento = t.Numero_Documento
					AND	v.TimbreFiscal != t.Fiscal_UUID
					<!---WHERE 	t.TipoDoc_id != 4	--->
			</cfquery>
		<cfelse>
			<cfquery datasource="sifinterfaces">
				UPDATE	v
				SET		v.TimbreFiscal = t.Fiscal_UUID,
						v.Factura = t.Factura,
						v.Fecha_Venta=t.Fiscal_FechaTimbrado
				FROM	ESIFLD_Facturas_VentaT v
				INNER JOIN SIFLD_Timbres_Fiscales t
					ON	v.Ecodigo = t.Cadena_Id
					AND v.Numero_Documento = t.Numero_Documento
					AND	v.TimbreFiscal != t.Fiscal_UUID
					WHERE 	t.TipoDoc_id = 4
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="AgrupaVentasCredito" access="private" output="false">
		<cfquery name="rsFacturas" datasource="sifinterfaces">
			select  Factura, count(Factura) from ESIFLD_Facturas_VentaT
			where Factura !=''
			and Estatus != 5
			group by Factura
		</cfquery>

		<cfloop query="rsFacturas">
			<cfquery name="rsMaxIDE" DataSource="sifinterfaces">
				select 	isnull(max(ID_DocumentoV),0) + 1 as MaxID
				from 	ESIFLD_Facturas_Venta
			</cfquery>
			<cfquery name="EncFacts" datasource="sifinterfaces">
				select * from ESIFLD_Facturas_VentaT
				where Factura ='#rsFacturas.Factura#'
				and Estatus != 5
			</cfquery>
			<cfquery name="CantidadesFacts"   datasource="sifinterfaces">
				select sum(Subtotal) Subtotal, sum(Descuento) Descuento,sum(Impuesto) Impuesto, sum(Total) Total
				from ESIFLD_Facturas_VentaT
				where Factura ='#EncFacts.Factura#'
				and Estatus != 5
			</cfquery>
			<cfif EncFacts.RecordCount GT 0>
				<cfquery name="DetFacts" datasource="sifinterfaces">
					select Ecodigo,	Tipo_Lin, Tipo_Item, Clas_Item,	Cod_Item, Cod_Fabricante, Cod_Impuesto,	Cantidad,
					sum(Precio_Unitario) Precio_Unitario, sum(Descuento_Lin) Descuento_Lin,	sum(Descuento_Fact) Descuento_Fact,
					sum(Subtotal_Lin) Subtotal_Lin, sum(Impuesto_Lin) Impuesto_Lin, sum(Total_Lin) Total_Lin, sum(Costo_Venta) Costo_Venta,
					codIEPS, sum(MontoIEPS) MontoIEPS,	afectaIVA
					from DSIFLD_Facturas_VentaT
					where ID_DocumentoV in (select ID_DocumentoV from ESIFLD_Facturas_VentaT where Factura ='#EncFacts.Factura#')
					group by Ecodigo, Tipo_Lin, Tipo_Item, Clas_Item, Cod_Item, Cod_Fabricante, Cod_Impuesto, Cantidad,
					codIEPS,afectaIVA
				</cfquery>
				<cfif DetFacts.RecordCount GT 0>
					<cfquery datasource="sifinterfaces">
						insert into ESIFLD_Facturas_Venta (Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta, Fecha_Venta,
						Fecha_Operacion, Numero_Documento, Cliente,  Subtotal, Descuento, Impuesto, Total, Redondeo, Vendedor,
						Sucursal, Dias_Credito, Moneda, Tipo_Cambio,  Retencion, Observaciones, Tipo_CEDI, Estatus, Factura_Cambio,
						Fecha_Inclusion, IEPS, TimbreFiscal, Factura)
						values(
						<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#EncFacts.Ecodigo#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Origen#">,
						<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#rsMaxIDE.MaxID#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Tipo_Documento#">,
						<cfqueryparam 	  cfsqltype="cf_sql_char"      value="#EncFacts.Tipo_Venta#">,
						<cfqueryparam 	  cfsqltype="cf_sql_date" 	   value="#dateformat(EncFacts.Fecha_Venta,"yyyy/mm/dd")#">,
						<cfqueryparam 	  cfsqltype="cf_sql_timestamp" value="#EncFacts.Fecha_Operacion#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Factura#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Cliente#">,
						<cfqueryparam     cfsqltype="cf_sql_money" 	   value="#numberformat(CantidadesFacts.Subtotal,'9.99')#">,
						<cfqueryparam 	  cfsqltype="cf_sql_money" 	   value="#numberformat(CantidadesFacts.Descuento,'9.99')#">,
						<cfqueryparam 	  cfsqltype="cf_sql_money" 	   value="#numberformat(CantidadesFacts.Impuesto,'9.9999')#">,
						<cfqueryparam 	  cfsqltype="cf_sql_money" 	   value="#numberformat(CantidadesFacts.Total,'9.99')#">,
						<cfqueryparam	  cfsqltype="cf_sql_money" 	   value="#numberformat(EncFacts.Redondeo,'9.99')#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Vendedor#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Sucursal#">,
						<cfqueryparam 	  cfsqltype="cf_sql_integer"   value="#EncFacts.Dias_Credito#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Moneda#">,
						<cfqueryparam 	  cfsqltype="cf_sql_money"     value="#EncFacts.Tipo_Cambio#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Retencion#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Observaciones#">,
						<cfqueryparam 	  cfsqltype="cf_sql_char" 	   value="#EncFacts.Tipo_CEDI#">,
						<!---<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Estatus#">,--->
						1,
						<cfqueryparam 	  cfsqltype="cf_sql_money"     value="#EncFacts.Factura_Cambio#">,
						<cfqueryparam 	  cfsqltype="cf_sql_timestamp" value="#EncFacts.Fecha_Inclusion#">,
						<cfqueryparam 	  cfsqltype="cf_sql_money"     value="#EncFacts.IEPS#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.TimbreFiscal#">,
						<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#EncFacts.Factura#">
						)
					</cfquery>
					<cfset linea=1>
					<cfloop query="DetFacts">
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Facturas_Venta(Ecodigo, ID_DocumentoV, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item,
							Cod_Impuesto, Cantidad, Total_Lin, Precio_Unitario, Descuento_Lin, Descuento_Fact, Subtotal_Lin, Impuesto_Lin,
							Costo_Venta, Cod_Fabricante, Cod_Item, codIEPS, MontoIEPS, afectaIVA) values(
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#DetFacts.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Linea#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.Tipo_Lin#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.Tipo_Item#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.Clas_Item#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.Cod_Impuesto#">,
							 <cfqueryparam cfsqltype="cf_sql_float"   value="#DetFacts.Cantidad#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Total_Lin#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Precio_Unitario#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Descuento_Lin#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Descuento_Fact#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Subtotal_Lin#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Impuesto_Lin#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.Costo_Venta#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.Cod_Fabricante#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.Cod_Item#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetFacts.codIEPS#">,
							 <cfqueryparam cfsqltype="cf_sql_money"   value="#DetFacts.MontoIEPS#">,
							 <cfqueryparam cfsqltype="cf_sql_char"    value="#DetFacts.afectaIVA#">
							 )
						</cfquery>
						<cfset linea=linea+1>
					</cfloop>
				</cfif>
			</cfif>
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Facturas_VentaT
				set Estatus = 5
				where Factura ='#rsFacturas.Factura#'
			</cfquery>

		</cfloop><!--- fin RSFacturas--->
	</cffunction>

</cfcomponent>