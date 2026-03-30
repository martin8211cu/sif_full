<cfcomponent extends="Interfaz_Base" output="yes">
	<!--- Ejecuta procesamiento de ventas por Corte Z --->
	<cffunction name="Ejecuta" access="public" returntype="any" output="yes">
		<cfargument name="Disparo" required="no" type="boolean" default="true">
		<cfsetting requestTimeout="3600" />
		<!--- VARIABLES --->
		<cfset varOrigen = 'LDIV'>
		<cfset varTipoCambio = 1>
		<cfset varLdMoneda = 1>
		<cfset varLdIEPS8 = 4>
		<cfset varLdOrigen = 'LD'>

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


		<!--- Cambia a Estatus 2 (En proceso) --->
		<cftransaction>
			<cftry>
				<cfquery name="updateEstatusEnProceso" datasource="sifinterfaces">
					UPDATE SIFLD_Ventas_Contado_CorteZ SET Estatus = 2 <!--- En proceso --->
					WHERE Estatus = 1
				</cfquery>
				<cftransaction action="commit" />
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cflog file="Log_Proceso_VtasContado_CorteZ"
				       application="no"
				       text="Error al actualizar Estatus (En proceso), Error: #cfcatch.Message#">
			</cfcatch>
			</cftry>
		</cftransaction>
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

		<!--- Obtiene los cortes Z listos para procesar --->
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

		<cfquery name="rsGetVentasCorteZ" datasource="sifinterfaces">
			SELECT IdCorte, Ecodigo, NumeroDocumento, FechaVenta,
	               Cliente, IngresosIVA0, IngresosIVA16, RecibosCxC, ServiciosExternos,
	               ComisionServExt, Ieps3, Ieps8, (Ieps3 + Ieps8) AS TotalIeps, DevolucionIeps8,
	               IvaTrasladado16C, DescLinea, IvaTrasladado16D,
	               Pago_EfectivoLocal, Pago_EfectivoExt, PagoTarjeta, PagoCupon, PagoCheque,
				   PagoNC, PagoTransferencia, Pago_ValesDespensa, AlmacenCostoVentas0, AlmacenCostoVentas16,
	               AlmacenCostoVentasDev0, AlmacenCostoVentasDev16, DevolucionDeVentas16, DevolucionDeVentas0,
	               DevolucionSobreVentas, Empresa, Sucursal, OperacionId
					<cfif genApartado>
						, Operacion_Recibos 
						, Operacion_Recibo_Apartado 
						, Operacion_Apartado_Cancela 
					</cfif>
			FROM SIFLD_Ventas_Contado_CorteZ
			WHERE Estatus = 2
		</cfquery>

		<!--- INICIA PROCESAMIENTO --->
		<cfif isdefined("rsGetVentasCorteZ") and rsGetVentasCorteZ.recordcount GT 0>
			<cfloop query="rsGetVentasCorteZ"><!--- INICIA LOOP VENTAS --->
				<!--- Busca equivalencias --->
				<!--- EMPRESAS --->
				<cfset Equiv 		 = ConversionEquivalencia (#varLdOrigen#, 'CADENA', rsGetVentasCorteZ.Ecodigo, rsGetVentasCorteZ.Ecodigo, 'Cadena')>
				<cfset varEcodigo 	 = Equiv.EQUidSIF>
				<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
				<cfset session.dsn 	 = getConexion(varEcodigo)>
				<cfset varCEcodigo 	 = getCEcodigo(varEcodigo)>

				<!--- Porcentaje del IVA usado --->
				<cfset lVarPorcentajeIvaGravado = getPorcentajeIVA(Equiv.EQUcodigoOrigen)>

				<!--- CLIENTE --->
				<cfset VarCte = ExtraeCliente(rsGetVentasCorteZ.Cliente, varEcodigo)>
				<!--- Concepto Contable --->
				<cfset varCconcepto  = ConceptoContable(varEcodigo,"#varOrigen#")>

				<cfif not isdefined("ParBorrado")>
					<cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsGetVentasCorteZ.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = varOrigen)>
				</cfif>
				<!--- Obtiene el usuario de Interfaz --->
				<cfset Usuario 	  = UInterfaz (getCEcodigo(varEcodigo))>
				<cfset varUlogin  = Usuario.Usulogin>
				<cfset varUcodigo = Usuario.Usucodigo>

				<cfset varIDCorte = #rsGetVentasCorteZ.IdCorte#>
				<cfset varNumeroDocumento = #rsGetVentasCorteZ.NumeroDocumento#>
				<!--- Fecha de venta --->
				<cfset varFechaVenta = #rsGetVentasCorteZ.FechaVenta#>

				<!--- Descripcion de la poliza --->
				<cfset DescPoliza = "Poliza de Venta Contado #varNumeroDocumento#">

				<!--- Extrae ID Max --->
				<cfset RsMaximo = ExtraeMaximo("IE18","ID")>
				<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
					<cfset Maximus = RsMaximo.Maximo>
				<cfelse>
					<cfset Maximus = 1>
				</cfif>

				<!--- Se asigna periodo y mes de la fecha de operacion en LD --->
				<cfset Mes = "#month(rsGetVentasCorteZ.FechaVenta)#">
				<cfset Periodo = "#year(rsGetVentasCorteZ.FechaVenta)#">

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
						 <cfqueryparam cfsqltype="cf_sql_date" 	   value="#varFechaVenta#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#DescPoliza#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#varNumeroDocumento#">,
						 ' ', getdate(),
						 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#varUlogin#">,
						 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
						 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#varUlogin#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric"  value="#varUcodigo#">,
						 0,
						 <cfqueryparam cfsqltype="cf_sql_varchar"  value="">,
						 <cfqueryparam cfsqltype ="cf_sql_money"   value="#rsGetVentasCorteZ.TotalIeps#">
						 )
				</cfquery>
				<cfset IDlinea = 1>

				<!--- INICIA INSERCION DE DETALLE --->
				<!--- VARIABLES POR DETALLE --->
				<!---OFICINA --->
				<cfset Equiv = ConversionEquivalencia(#varLdOrigen#, 'SUCURSAL', rsGetVentasCorteZ.Ecodigo, rsGetVentasCorteZ.Sucursal, 'Sucursal')>
				<cfset VarOcodigo = Equiv.EQUidSIF>
			    <cfset VarOficina = Equiv.EQUcodigoSIF>
			    <!--- MONEDA --->
				<cfset Equiv = ConversionEquivalencia (#varLdOrigen#, 'MONEDA', rsGetVentasCorteZ.Ecodigo, #varLdMoneda#, 'Moneda')>
				<cfset varMoneda = Equiv.EQUcodigoSIF>
				<!--- CENTRO FUNCIONAL--->
				<cfset Equiv = ConversionEquivalencia (#varLdOrigen#, 'CENTRO_FUN', rsGetVentasCorteZ.Ecodigo, rsGetVentasCorteZ.Sucursal, 'Centro_Funcional')>
				<cfset varidCF = Equiv.EQUidSIF>
				<cfset varCF = Equiv.EQUcodigoSIF>
				<!--- EQUIVALENCIA IMPUESTO 0 --->
				<cfset Equiv = ConversionEquivalencia (#varLdOrigen#, 'IMPUESTO', rsGetVentasCorteZ.Ecodigo, 0, 'Cod_Impuesto')>
				<cfset VarImpuesto0 = Equiv.EQUcodigoSIF>
				<!--- EQUIVALENCIA IMPUESTO 16 --->
				<cfset Equiv = ConversionEquivalencia (#varLdOrigen#, 'IMPUESTO', rsGetVentasCorteZ.Ecodigo, lVarPorcentajeIvaGravado, 'Cod_Impuesto')>
				<cfset VarImpuesto16 = Equiv.EQUcodigoSIF>
				<!--- Cuenta banco --->
				<!--- SE OBTIENE DE PAR?METROS GENERALES --->
				<cfquery name="rsGetParam05" datasource="sifinterfaces">
					SELECT RTRIM(LTRIM(Pvalor)) AS Pvalor
					FROM SIFLD_ParametrosAdicionales
					WHERE Pcodigo = '00005'
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
				</cfquery>
				<!--- <cfif not isdefined("varCtaBanco")>
					<cfset varCtaBanco= Parametros(Ecodigo=varEcodigo,Pcodigo=14,Sucursal=rsGetVentasCorteZ.Sucursal,Parametro="Cuenta para Pagos",ExtBusqueda=true, Sistema = varLdOrigen)>
				</cfif> --->
				<!--- Cuenta Banco --->
				<cfif isdefined("rsGetParam05") and len(rsGetParam05.Pvalor) GT 0>
					<cfquery name="rsCta_Banco" datasource="#session.dsn#">
						select 	CBid, Bid
						from 	CuentasBancos
						where 	CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetParam05.Pvalor#">
						and 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
					</cfquery>

					<cfif rsCta_Banco.RecordCount GT 0>
						<cfset varCtaBanco = rsCta_Banco.CBid>
						<cfset varBanco = rsCta_Banco.Bid>
					<cfelse>
						<cfthrow message="La cuenta configurada dentro de parametros generales es incorrecta! [#rsGetParam05.Pvalor#]">
					</cfif>
				<cfelse>
					<cfthrow message="No se encuentra configurada la cuenta bancaria para pagos en los parametros generales!">
				</cfif>

				<cfset varClas_Item = 0>
				<cfset varTipo_Item = 1>
				<cfset varCod_Fabricante = 0>
				<cfset varTipo_Venta = 'P'>

				<!--- ************************************** INGRESOS 0% ************************************** --->
				<cfif #rsGetVentasCorteZ.IngresosIVA0# GT 0>
					<!--- INGRESOS Origen debe ser LDIV--->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="ING"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#VarImpuesto0#"
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
					<!--- INSERTA DETALLE --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Ingresos de Ventas 0%">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IngresosIVA0,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IngresosIVA0,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 1)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** INGRESOS 16% ************************************** --->
				<cfif #rsGetVentasCorteZ.IngresosIVA16# GT 0>
					<!--- INGRESOS Origen debe ser LDIV--->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="ING"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#VarImpuesto16#"
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
					<!--- INSERTA DETALLE --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Ingresos de Ventas #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IngresosIVA16,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IngresosIVA16,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 1)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>


				<!--- ************************************** SERVICIOS EXTERNOS ************************************** --->
				<cfif #rsGetVentasCorteZ.ServiciosExternos# GT 0>
					<!--- Obtencion de la cuenta (EFS) --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="EFS"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Servicios Externos">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.ServiciosExternos,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.ServiciosExternos,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ctaEfectivo.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 1)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>


				<!--- ************************************** COMISI?N SERVICIOS EXTERNOS ************************************** --->
				<cfif #rsGetVentasCorteZ.ComisionServExt# GT 0>
					<!--- OBTIENE CUENTA COMISION SERVICIOS (CMS) --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="CMS"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Comisi&oacute;n Servicios Externos">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.ComisionServExt,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.ComisionServExt,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
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

				<!--- ************************************** RECIBOS CXC ************************************** --->
				<cfif #rsGetVentasCorteZ.RecibosCxC# GT 0>
					<!--- OBTIENE CUENTA RECIBOS CXC --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="REC"
						LDDepartamento="NOUSAR"
					 	LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Recibos CxC">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.RecibosCxC,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.RecibosCxC,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
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

				<!--- ************************************** IEPS 8% ************************************** --->
				<cfif #rsGetVentasCorteZ.Ieps8# GT 0>
					<!--- BUSCA EQUIVALENCIA DE IEPS EN SIF --->
					<cfset Equiv = ConversionEquivalencia (#varLdOrigen#, 'IEPS', rsGetVentasCorteZ.Ecodigo, varLdIEPS8, 'Cod_Impuesto')>
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
						<!--- INSERCI?N DE LINEA IEPS 8 --->
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
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIEPS.Cdescripcion#">,
								 ' ', ' ',
								 'C',
								 0, 0, 0, 0,
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Ieps8,'9.99')#">),
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Ieps8,'9.99')#">),
								 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								 getdate(), 0,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaIEPS#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								 2)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					<cfelse>
						<cfquery datasource="sifinterfaces">
							insert into SIFLD_Errores
									(Interfaz, Tabla, ID_Documento, MsgError, Ecodigo, Usuario)
							values
								('CG_Ventas',
								 'SIFLD_ID18',
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Maximus#">,
								 'No se ha agregado el impuesto IEPS 8: #rsGetVentasCorteZ.NumeroDocumento#',
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetVentasCorteZ.Ecodigo#">,
								 null)
						</cfquery>
					</cfif>
				</cfif>



				<!--- ************************************** DEV IEPS 8% ************************************** --->
				<cfif #rsGetVentasCorteZ.DevolucionIeps8# GT 0>
					<!--- BUSCA EQUIVALENCIA DE IEPS EN SIF --->
					<cfset Equiv = ConversionEquivalencia (#varLdOrigen#, 'IEPS', rsGetVentasCorteZ.Ecodigo, varLdIEPS8, 'Cod_Impuesto')>
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
						<!--- INSERCI?N DE LINEA IEPS 8 --->
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
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIEPS.Cdescripcion#">,
								 ' ', ' ',
								 'D',
								 0, 0, 0, 0,
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionIeps8,'9.99')#">),
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionIeps8,'9.99')#">),
								 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								 getdate(), 0,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaIEPS#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								 2)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					<cfelse>
						<cfquery datasource="sifinterfaces">
							insert into SIFLD_Errores
									(Interfaz, Tabla, ID_Documento, MsgError, Ecodigo, Usuario)
							values
								('CG_Ventas',
								 'SIFLD_ID18',
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Maximus#">,
								 'No se ha agregado el impuesto IEPS 8 #rsGetVentasCorteZ.NumeroDocumento#',
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetVentasCorteZ.Ecodigo#">,
								 null)
						</cfquery>
					</cfif>
				</cfif>



				<!--- ************************************** IVA TRASLADADO 16 (C)************************************** --->
				<cfif #rsGetVentasCorteZ.IvaTrasladado16C# GT 0>
					<!--- Obtiene cuenta Contable Parametrizada en el Impuesto --->
					<cfquery name="rsIVA" datasource="#session.dsn#">
						SELECT 	Cformato
						FROM 	CContables c
							INNER JOIN 	Impuestos i
							ON 	c.Ecodigo = i.Ecodigo
							AND c.Ccuenta = i.CcuentaCxCAcred
						WHERE 	i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						AND 	i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarImpuesto16#">
					</cfquery>
					<cfif isdefined ("rsIVA") and rsIVA.recordcount GT 0>
						<cfset varCuentaImp = rsIVA.Cformato>
					<cfelse>
						<cfthrow message="El Impuesto #VarImpuesto16# No tiene Parametrizadas sus cuentas">
					</cfif>

					<!--- INSERCI?N DETALLE --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA Trasladado #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ',
							 'C',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IvaTrasladado16C,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IvaTrasladado16C,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
						  	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaImp#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 2)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** DESCUENTO LINEA************************************** --->
				<cfif #rsGetVentasCorteZ.DescLinea# GT 0>
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="DES"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#VarImpuesto16#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Descuento Linea">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DescLinea,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DescLinea,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
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

				<!--- ************************************** IVA TRASLADADO 16 (D) ************************************** --->
				<cfif #rsGetVentasCorteZ.IvaTrasladado16D# GT 0>
					<!--- Obtiene cuenta Contable Parametrizada en el Impuesto --->
					<cfquery name="rsIVA" datasource="#session.dsn#">
						SELECT 	Cformato
						FROM 	CContables c
							INNER JOIN 	Impuestos i
							ON 	c.Ecodigo = i.Ecodigo
							AND c.Ccuenta = i.CcuentaCxCAcred
						WHERE 	i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						AND 	i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarImpuesto16#">
					</cfquery>
					<cfif isdefined ("rsIVA") and rsIVA.recordcount GT 0>
						<cfset varCuentaImp = rsIVA.Cformato>
					<cfelse>
						<cfthrow message="El Impuesto #VarImpuesto16# No tiene Parametrizadas sus cuentas">
					</cfif>

					<!--- INSERCI?N DETALLE --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA Trasladado #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IvaTrasladado16D,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.IvaTrasladado16D,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
						  	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaImp#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 2)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>


				<!--- INICIA FORMAS DE PAGO --->
				<!--- ************************************** PAGO EFECTIVO (LOCAL) ************************************** --->
				<cfif #rsGetVentasCorteZ.Pago_EfectivoLocal# GT 0>
					<!--- Efectivo en moneda local  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="EFC"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Efectivo">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_EfectivoLocal,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_EfectivoLocal,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 3)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				<cfelse> <!---sml 23092021 agrega en creditos cuando el monto es negativo--->
					<!--- Efectivo en moneda local  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="EFC"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Efectivo">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_EfectivoLocal,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_EfectivoLocal,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 3)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>

				</cfif>

				<!--- ************************************** PAGO EFECTIVO (EXTRANJERA) ************************************** --->
				<cfif #rsGetVentasCorteZ.Pago_EfectivoExt# GT 0>
					<!--- EFECTIVO MONEDA EXT --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="EFX"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Efectivo (Moneda Extranjera)">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_EfectivoExt,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_EfectivoExt,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEFX.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 3)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** PAGO TARJETA ************************************** --->
				<cfif #rsGetVentasCorteZ.PagoTarjeta# GT 0>
					<!--- CUENTA BANCARIA  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="CBN"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Tarjeta">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoTarjeta,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoTarjeta,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 4)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** PAGO CUPONES ************************************** --->
				<cfif #rsGetVentasCorteZ.PagoCupon# GT 0>
					<!--- SML 23112021 Obtener IVA de los cupones --->
					<cfset varCupon = rsGetVentasCorteZ.PagoCupon / 1.16>
					<cfset varCuponLocal = varCupon * varTipoCambio>
					<cfset varCuponIVA = rsGetVentasCorteZ.PagoCupon - varCupon>
					<cfset varCuponIVALocal = varCuponIVA * varTipoCambio>
					
					<!--- Obtiene cuenta Contable Parametrizada en el Impuesto --->
					<cfquery name="rsIVA" datasource="#session.dsn#">
						SELECT 	Cformato
						FROM 	CContables c
							INNER JOIN 	Impuestos i
							ON 	c.Ecodigo = i.Ecodigo
							AND c.Ccuenta = i.CcuentaCxCAcred
						WHERE 	i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						AND 	i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarImpuesto16#">
					</cfquery>
					<cfif isdefined ("rsIVA") and rsIVA.recordcount GT 0>
						<cfset varCuentaImp = rsIVA.Cformato>
					<cfelse>
						<cfthrow message="El Impuesto #VarImpuesto16# No tiene Parametrizadas sus cuentas">
					</cfif>
					
					<!--- INSERCION DETALLE --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA #lVarPorcentajeIvaGravado#% CUPONES ">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varCuponIVA,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varCuponIVALocal,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
						  	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaImp#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 2)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>


					<!--- PAGO EN CUPONES --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="CUP"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Cupones">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varCupon,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varCuponLocal,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCUP.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 5)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** PAGO CHEQUE ************************************** --->
				<cfif #rsGetVentasCorteZ.PagoCheque# GT 0>
					<!--- PAGO EN CHEQUE --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="CHE"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Cheque">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoCheque,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoCheque,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCHE.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 6)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>


				<!--- ************************************** PAGO NOTA DE CREDITO ************************************** --->
				<cfif #rsGetVentasCorteZ.PagoNC# GT 0>
					<!--- PAGO EN NC --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="DSV"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
					<cfset CuentaLDNC = Cuenta>

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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Nota de Credito">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoNC,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoNC,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDNC.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 8)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>


				<!--- ************************************** PAGO TRANSFERENCIA ************************************** --->
				<cfif #rsGetVentasCorteZ.PagoTransferencia# GT 0>
					<!--- PAGO EN TRANSFERENCIA --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="TRA"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Transferencia">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoTransferencia,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.PagoTransferencia,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDTRA.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 10)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** PAGO VALES DESPENSA ************************************** --->
				<cfif #rsGetVentasCorteZ.Pago_ValesDespensa# GT 0>
					<!--- PAGO EN VALES DESPENSA --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="VD"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#varTipo_Venta#"
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
					<cfset CuentaLDVD = Cuenta>

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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en Vales de despensa">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_ValesDespensa,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Pago_ValesDespensa,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDVD.CFformato#">,
		 					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 10)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>
				<!--- FINALIZA FORMAS DE PAGO --->

				<!--- ************************************** ALMACEN/COSTO 0% (C) ************************************** --->
				<cfif #rsGetVentasCorteZ.AlmacenCostoVentas0# GT 0>
					<!--- ALMACEN VENTAS --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="AVT"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
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
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
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

					<!--- Insercion del detalle "LDAV" (Contable Almacen Ventas 0%) --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Almacen Ventas 0%">,
							 ' ', ' ',
							 'C',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas0,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas0,'9.99')#">),
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Costo de Ventas 0%">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas0,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas0,'9.99')#">),
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
				</cfif>

				<!--- ************************************** ALMACEN/COSTO 16% (C) ************************************** --->
				<cfif #rsGetVentasCorteZ.AlmacenCostoVentas16# GT 0>
					<!--- ALMACEN VENTAS --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="AVT"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto16#"
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
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto16#"
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

					<!--- Insercion del detalle "LDAV" (Contable Almacen Ventas 0%) --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Almacen Ventas #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ',
							 'C',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas16,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas16,'9.99')#">),
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Costo de Ventas #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas16,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentas16,'9.99')#">),
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
				</cfif>



				<!--- ************************************** ALMACEN/COSTO 0% (D) ************************************** --->
				<cfif #rsGetVentasCorteZ.AlmacenCostoVentasDev0# GT 0>
					<!--- ALMACEN VENTAS --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="AVT"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
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
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
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

					<!--- Insercion del detalle "LDAV" (Contable Almacen Ventas 0%) --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Almacen Ventas 0%">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev0,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev0,'9.99')#">),
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Costo de Ventas 0%">,
							 ' ', ' ',
							 'C',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev0,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev0,'9.99')#">),
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
				</cfif>



				<!--- ************************************** ALMACEN/COSTO 16% (D) ************************************** --->
				<cfif #rsGetVentasCorteZ.AlmacenCostoVentasDev16# GT 0>
					<!--- ALMACEN VENTAS --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="AVT"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto16#"
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
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto16#"
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

					<!--- Insercion del detalle "LDAV" (Contable Almacen Ventas 0%) --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Almacen Ventas #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ',
							 'D',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev16,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev16,'9.99')#">),
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Costo de Ventas #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ',
							 'C',
							 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev16,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.AlmacenCostoVentasDev16,'9.99')#">),
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
				</cfif>

				<cfif planLealtad>
					<cfquery name="rsGetVentasCorteZPL" datasource="sifinterfaces">
						SELECT 
						Monedero_Acumula <!--- Generacion --->
						, Devolucion_Monedero_Acumula <!--- Devolucion --->
						, Operacion_FP_Monedero <!--- Aplicacion --->
						, Operacion_Devolucion_Monedero <!--- Devolucion Plan de Lealtal --->
						FROM SIFLD_Ventas_Contado_CorteZ
						WHERE IdCorte = #varIDCorte#
					</cfquery>

					<!--- ************************************** GENERACION ************************************** --->
					<cfif #rsGetVentasCorteZPL.Monedero_Acumula# GT 0>
						<!--- PLH, Provision Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLH"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLH = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Provision Plan de Lealtad">,
								' ', ' ', 'C', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Monedero_Acumula,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Monedero_Acumula,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLH.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
						<!--- PLD, Descuentos Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLD"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLD = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Descuentos Plan de Lealtad">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Monedero_Acumula,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Monedero_Acumula,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLD.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<!--- ************************************** DEVOLUCION ************************************** --->
					<cfif #rsGetVentasCorteZPL.Devolucion_Monedero_Acumula# GT 0>
						<!--- PLH, Provision Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLH"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLH = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Provision Plan de Lealtad">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Devolucion_Monedero_Acumula,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Devolucion_Monedero_Acumula,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLH.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
						<!--- PLD, Descuentos Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLD"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLD = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Descuentos Plan de Lealtad">,
								' ', ' ', 'C', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Devolucion_Monedero_Acumula,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Devolucion_Monedero_Acumula,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLD.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<!--- ************************************** APLICACION ************************************** --->
					<cfif #rsGetVentasCorteZPL.Operacion_FP_Monedero# GT 0>
						<!--- PLH, Provision Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLH"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLH = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Provision Plan de Lealtad">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_FP_Monedero,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_FP_Monedero,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLH.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
						<!--- PLD, Descuentos Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLD"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLD = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Descuentos Plan de Lealtad">,
								' ', ' ', 'C', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_FP_Monedero,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_FP_Monedero,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLD.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>

					
					<!--- ************************************** DEVOLUCION DE VENTAS (OTROS) ************************************** --->
					<cfif #rsGetVentasCorteZPL.Operacion_Devolucion_Monedero# GT 0>
						<!--- PLH, Provision Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLH"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLH = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Provision Plan de Lealtad">,
								' ', ' ', 'C', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_Devolucion_Monedero,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_Devolucion_Monedero,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLH.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
						<!--- PLD, Descuentos Plan de Lealtad  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="PLD"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto0#"
							Oficinas="#VarOcodigo#"
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCtaBanco#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						<cfset CuentaPLD = Cuenta>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Descuentos Plan de Lealtad">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_Devolucion_Monedero,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZPL.Operacion_Devolucion_Monedero,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLD.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
				
					<!--- ************************************** PAGOS CON PLAN DE LEALTAD************************************** --->
					<cfif #rsGetVentasCorteZPL.Operacion_FP_Monedero# GT 0 or rsGetVentasCorteZPL.Operacion_Devolucion_Monedero GT 0>
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="CUP"
							LDDepartamento="NOUSAR"
							LDClasificacion="NOUSAR"
							LDFabricante="NOUSAR"
							LDTipoVenta="#varTipo_Venta#"
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

						<cfset CuentaPLH = Cuenta>

						<cfset varPagoconLealtad = 0>
						<cfif #rsGetVentasCorteZPL.Operacion_FP_Monedero# GT 0>
							<cfset varPagoconLealtad = (rsGetVentasCorteZPL.Operacion_FP_Monedero - rsGetVentasCorteZPL.Operacion_Devolucion_Monedero)/1.16>
						<cfelse>
							<cfset varPagoconLealtad = rsGetVentasCorteZPL.Operacion_Devolucion_Monedero /1.16>
						</cfif>

						<!--- Insercion detalle Generacion de Puntos --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Pago con Plan de Lealtad">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varPagoconLealtad,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varPagoconLealtad,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLH.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
						<!--- Obtiene cuenta Contable Parametrizada en el Impuesto --->
						<cfquery name="rsIVA" datasource="#session.dsn#">
							SELECT 	Cformato
							FROM 	CContables c
								INNER JOIN 	Impuestos i
								ON 	c.Ecodigo = i.Ecodigo
								AND c.Ccuenta = i.CcuentaCxCAcred
							WHERE 	i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							AND 	i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarImpuesto16#">
						</cfquery>

						<cfif isdefined ("rsIVA") and rsIVA.recordcount GT 0>
							<cfset varCuentaImp = rsIVA.Cformato>
						<cfelse>
							<cfthrow message="El Impuesto #VarImpuesto16# No tiene Parametrizadas sus cuentas">
						</cfif>

						<cfset varIVAPagoconLealtad = #varPagoconLealtad# * 0.16>

						<!--- Insercion del IVA 16% Pago con Plan de Lealtad --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="IVA #lVarPorcentajeIvaGravado#% Plan de Lealtad">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varIVAPagoconLealtad,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(varIVAPagoconLealtad,'9.99')#">),
								1,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaImp#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								17)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>

				</cfif>

				<!--- ************************************** DEVOLUCION DE VENTAS 0% ************************************** --->
				<cfif #rsGetVentasCorteZ.DevolucionDeVentas0# GT 0>
					<!--- DEVOLUCION DE VENTAS  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="DVT"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Devolucion de Ventas 0%">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionDeVentas0,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionDeVentas0,'9.99')#">),
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


				<!--- ************************************** DEVOLUCION DE VENTAS 16% ************************************** --->
				<cfif #rsGetVentasCorteZ.DevolucionDeVentas16# GT 0>
					<!--- DEVOLUCION DE VENTAS  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="DVT"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto16#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Devolucion de Ventas #lVarPorcentajeIvaGravado#%">,
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionDeVentas16,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionDeVentas16,'9.99')#">),
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


				<!--- ************************************** DEVOLUCION SOBRE VENTAS ************************************** --->
				<cfif #rsGetVentasCorteZ.DevolucionSobreVentas# GT 0>
					<!--- DVN, Devolucion Sobre Venta  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="DVN"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
						Oficinas="#VarOcodigo#"
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCtaBanco#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					<cfset CuentaLDDVN = Cuenta>

					<!--- Insercion detalle Devolucion Sobre Venta --->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Devolucion Sobre Venta">,
							 ' ', ' ', 'C', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionSobreVentas,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.DevolucionSobreVentas,'9.99')#">),
							 1,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 getdate(), 0,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDVN.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 17)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>

				<!--- ************************************** APARTADOS ************************************** --->
				
				<cfif genApartado>
					<cfif #rsGetVentasCorteZ.Operacion_Recibos# GT 0>
						<!--- INGRESOS Origen debe ser LDIV--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="APT"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#VarImpuesto16#"
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
						<!--- INSERTA DETALLE --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Pagos de apartados">,
								' ', ' ', 'C', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Operacion_Recibos,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Operacion_Recibos,'9.99')#">),
								<cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								1)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
					</cfif>
					
					<cfif #rsGetVentasCorteZ.Operacion_Recibo_Apartado# GT 0>
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="APT"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#VarImpuesto16#"
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
						<!--- INSERTA DETALLE --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Apartados Liquidados">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Operacion_Recibo_Apartado,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Operacion_Recibo_Apartado,'9.99')#">),
								<cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								1)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						
					</cfif>
					
					<cfif #rsGetVentasCorteZ.Operacion_Apartado_Cancela# GT 0>
						<!--- INGRESOS Origen debe ser LDIV--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="#varOrigen#"
							Ecodigo="#varEcodigo#"
							Conexion="#session.dsn#"
							LDOperacion="APT"
							LDDepartamento="#varTipo_Item#"
							LDClasificacion="#varClas_Item#"
							LDFabricante="#varCod_Fabricante#"
							LDTipoVenta="#varTipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#VarImpuesto16#"
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
						<!--- INSERTA DETALLE --->
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
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Apartados Anulados">,
								' ', ' ', 'D', 0, 0, 0, 0,
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Operacion_Apartado_Cancela,'9.99')#">),
								abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsGetVentasCorteZ.Operacion_Apartado_Cancela,'9.99')#">),
								<cfqueryparam cfsqltype="cf_sql_float" value="#varTipoCambio#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								getdate(), 0,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								1)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
				</cfif>

				<!--- VALIDA CUADRE DE POLIZA, SINO SE AJUSTA --->
				<cfquery name="rsVerificaCuadre" datasource="sifinterfaces">
					SELECT ISNULL(
	                (SELECT SUM(Dlocal)
	                 FROM SIFLD_ID18
	                 WHERE ID = #Maximus#
	                   AND Dmovimiento = 'C') -
	                (SELECT SUM(Dlocal)
	                 FROM SIFLD_ID18
	                 WHERE ID = #Maximus#
	                   AND Dmovimiento = 'D') , 0 ) AS Diferencia
				</cfquery>

				<cfif rsVerificaCuadre.Diferencia NEQ 0>
					<!--- Poliza descuadrada --->
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
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
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
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								 getdate(), 0,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaRed#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								 23)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
				</cfif>

				<!--- FINALIZA INSERCION DE DETALLE --->

				<!--- VALIDA POLIZA VACIA, SI LA ENCUENTRA. LA MARCA EN SU ESTATUS --->
				<cfquery name="rsValidaPolizaVacia" datasource="sifinterfaces">
					SELECT COUNT(1) AS numRegistros
					FROM SIFLD_ID18
					WHERE ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>

				<cfif rsValidaPolizaVacia.RecordCount GT 0 AND rsValidaPolizaVacia.numRegistros EQ 0>
					<!--- Poliza Vacia --->
					<!--- ACTUALIZA FECHA PROCESO, Estatus Terminado e ID18 --->
					<cfquery datasource="sifinterfaces">
						UPDATE  SIFLD_Ventas_Contado_CorteZ
						SET     FechaFinProceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								Estatus = 14, <!--- 15 (Sin detalle en Poliza, El corte Z NO TIENE INFO PARA EL) --->
								ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">
						WHERE   IdCorte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDCorte#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						DELETE SIFLD_IE18 WHERE ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
					</cfquery>
				<cfelse>
					<!--- ACTUALIZA FECHA PROCESO, Estatus Terminado e ID18 --->
					<cfquery datasource="sifinterfaces">
						UPDATE  SIFLD_Ventas_Contado_CorteZ
						SET     FechaFinProceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								Estatus = 15, <!--- 15 (Terminado) --->
								ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">
						WHERE   IdCorte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDCorte#">
					</cfquery>
				</cfif>
			</cfloop><!--- FINALIZA LOOP VENTAS --->

			<cfif planLealtad>
				<!----RDF 170322 --->
				<!--- ************************************** CANCELACION ************************************** --->
				<cfset Maximus2 = Maximus + 1>					
				<!--- Insercion de Encabezado en IE18 --->
				<cfquery datasource="sifinterfaces">
					insert into SIFLD_IE18
						(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion,
						Edocbase, Ereferencia, Falta, Usuario, CEcodigo, EcodigoSDC,
							Usulogin, Usucodigo, ECIreversible, TimbreFiscal, IEPS)
					values
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus2#">,
						<cfqueryparam cfsqltype ="cf_sql_numeric" value="#VarEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer"  value="#varCconcepto#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#Periodo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#Mes#">,
						<cfqueryparam cfsqltype="cf_sql_date" 	   value="#varFechaVenta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="Cancelacion por Vigencia">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="Cancelacion por Vigencia">,
						' ', getdate(),
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#varUlogin#">,
						<cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
						<cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#varUlogin#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#varUcodigo#">,
						0,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="">,
						<cfqueryparam cfsqltype ="cf_sql_money"   value="0">
						)
				</cfquery>
				<cfset IDlinea2 = 1>				
			
				<cfquery name="rsSumMonedero_Reinicio_Tarjeta_Encabezado" datasource="ldcom_lealtad">
					select sum(Monedero_Saldo_Reinicio) Monedero_Saldo_Reinicio
					from Monedero_Reinicio_Tarjeta_Encabezado
					where Estado = 1
				</cfquery>

			
				<cfif rsSumMonedero_Reinicio_Tarjeta_Encabezado.Monedero_Saldo_Reinicio GT 0>
					<!--- PLH, Provision Plan de Lealtad  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="PLH"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
						Oficinas="#VarOcodigo#"
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCtaBanco#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					<cfset CuentaPLH = Cuenta>

					<!--- Insercion detalle Generacion de Puntos --->
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
									(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
									Oficodigo, Miso4217, CFcodigo, TipoOperacion)
						values
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus2#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea2#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Provision Plan de Lealtad">,
							' ', ' ', 'D', 0, 0, 0, 0,
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsSumMonedero_Reinicio_Tarjeta_Encabezado.Monedero_Saldo_Reinicio,'9.99')#">),
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsSumMonedero_Reinicio_Tarjeta_Encabezado.Monedero_Saldo_Reinicio,'9.99')#">),
							1,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							getdate(), 0,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLH.CFformato#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							17)
					</cfquery>
					<cfset IDlinea2 = IDlinea2 + 1>
				
					<!--- PLD, Descuentos Plan de Lealtad  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="#varOrigen#"
						Ecodigo="#varEcodigo#"
						Conexion="#session.dsn#"
						LDOperacion="PLD"
						LDDepartamento="#varTipo_Item#"
						LDClasificacion="#varClas_Item#"
						LDFabricante="#varCod_Fabricante#"
						LDTipoVenta="#varTipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto0#"
						Oficinas="#VarOcodigo#"
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCtaBanco#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					<cfset CuentaPLD = Cuenta>

					<!--- Insercion detalle Generacion de Puntos --->
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
									(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
									Oficodigo, Miso4217, CFcodigo, TipoOperacion)
						values
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus2#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea2#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(varFechaVenta, "yyyy/mm/dd")#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Descuentos Plan de Lealtad">,
							' ', ' ', 'C', 0, 0, 0, 0,
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsSumMonedero_Reinicio_Tarjeta_Encabezado.Monedero_Saldo_Reinicio,'9.99')#">),
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsSumMonedero_Reinicio_Tarjeta_Encabezado.Monedero_Saldo_Reinicio,'9.99')#">),
							1,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							getdate(), 0,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPLD.CFformato#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							17)
					</cfquery>
					<cfset IDlinea2 = IDlinea2 + 1>

					<cfquery name="rsMonedero_Reinicio_Tarjeta_Encabezado" datasource="ldcom_lealtad">
						update Monedero_Reinicio_Tarjeta_Encabezado
						set Estado = 2
						where Estado = 1
					</cfquery>

					<cfquery datasource="sifinterfaces">
						update	SIFLD_IE18
							set Interfaz = 'CG_Ventas', Estatus = 1
						where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus2#">
					</cfquery>
				</cfif>
				<!----RDF 170322--->
			</cfif>
			<!---Prepara los registros para ser insertados--->
			<!--- SIFLD_IE18 --->
			<cfquery datasource="sifinterfaces">
				update 	SIFLD_IE18
					set Interfaz = 'CG_Ventas', Estatus = 1
				where 	ID in (select ID18
							 from 	SIFLD_Ventas_Contado_CorteZ
							 where 	Estatus in (15))
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

			<!--- Borra SIFLD_ID18 --->
			<cfquery datasource="sifinterfaces">
				delete 	SIFLD_ID18
				where 	ID in (select ID18 from SIFLD_Ventas_Contado_CorteZ where Estatus in (15))
				or ID = #Maximus2#
			</cfquery>
			<!--- Borra SIFLD_IE18 --->
			<cfquery datasource="sifinterfaces">
				delete SIFLD_IE18
				where ID in (select ID18 from SIFLD_Ventas_Contado_CorteZ where Estatus in (15)) 
				or ID = #Maximus2#
			</cfquery>
		</cfif><!--- FINALIZA PROCESAMIENTO --->
	</cffunction>
</cfcomponent>