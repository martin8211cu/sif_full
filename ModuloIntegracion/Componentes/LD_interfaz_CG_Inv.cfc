<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<cfargument name="Disparo" required="no" type="boolean" default="true">
		<cfset Parborrado = false>
		<cfset ParAgrupa = false>
		<cfset ParOfic = true>
		<cfset ParCF = true>
		<cfset varBorraRegistro = false>
		<cfset ParCuentaxIVA = true>
		<!--- Tipos de Operacion para Sumatoria
			1 = Salida Almacen, 2 = Entrada Almacen, 3 = Salida Transito, 4 = Entrada Transito, 5 = Ajuste
		--->
		<!--- Marca Registros a Procesar --->
		<cfquery datasource="sifinterfaces" result="Rupdate">
			UPDATE  a
			SET 	a.Estatus = 10
			FROM ESIFLD_Movimientos_Inventario a
			WHERE
			<cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
				a.Estatus = 1
				AND NOT EXISTS (SELECT 1 FROM ESIFLD_Movimientos_Inventario WHERE Estatus IN (10, 11,94,92,99,100))
			<cfelse>
				a.Estatus = 99
				AND NOT EXISTS (SELECT 1 FROM ESIFLD_Movimientos_Inventario WHERE Estatus IN (10, 11))
			</cfif>
			/*
				MEGS  16-05-2018, A PETICI�N DE MARCOS D�AZ
				DE MOMENTO SOLO SER� TIPO_AJUSTE 'ES', YA QUE EXISTEN ENTRADAS SIN SALIDA O VICEVERSA
			*/
			  AND (
				(RTRIM(LTRIM(Tipo_Movimiento)) = 'TR'  AND Tipo_Ajuste IN ('ES','S','E'))
				OR (CASE
						WHEN a.Tipo_Ajuste = 'E'
							AND a.Tipo_Movimiento IN ('RC', 'DC') THEN
								(SELECT COUNT(1) AS total
								FROM ESIFLD_Movimientos_Inventario
								WHERE Documento = a.Documento
									AND Tipo_Ajuste = 'S')
						ELSE 0
					END > 0
					OR CASE
							WHEN a.Tipo_Ajuste = 'S'
								AND a.Tipo_Movimiento IN ('RC', 'DC') THEN
									(SELECT COUNT(1) AS total
									FROM ESIFLD_Movimientos_Inventario
									WHERE Documento = a.Documento
										AND Tipo_Ajuste = 'E')
							ELSE 0
						END > 0) 
			     OR SUBSTRING(RTRIM(LTRIM(Documento)),1,2) IN ('AJ', 'DC', 'RC')
			     )
		</cfquery>
		<!--- Obtiene registros a Procesar --->
		<cfquery name="rsIDEMovInventario" datasource="sifinterfaces">
			select e.ID_Movimiento
			from ESIFLD_Movimientos_Inventario e
			where e.Estatus = 10
			<cfif Rupdate.recordcount EQ 0>
				and 1 = 2
			</cfif>
		</cfquery>
		<!--- Proceso --->
		<cfif isdefined("rsIDEMovInventario") and rsIDEMovInventario.recordcount GT 0>
			<cfloop query="rsIDEMovInventario">
				<cftry>
					<cfset varBorraRegistro = false>
					<cfset Maximus = 0>
					<!--- Encabezado --->
					<cfquery name="rsEMovInventario" datasource="sifinterfaces">
						select 	Ecodigo, Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento,
								Documento, Descripcion, Almacen_Origen, Almacen_Destino, Sucursal_Origen,
								Tipo_Ajuste, Sucursal_Destino
						from 	ESIFLD_Movimientos_Inventario
						where 	ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEMovInventario.ID_Movimiento#">
					</cfquery>

					<cfset TipoAjuste = trim(rsEMovInventario.Tipo_Ajuste)>
					<!--- Descripción de las Polizas--->
					<cfif TipoAjuste EQ "E">
						<cfset DescAjuste = "Entrada">
					<cfelseif TipoAjuste EQ "S">
						<cfset DescAjuste = "Salida">
					<cfelseif TipoAjuste EQ "ES">
						<cfset DescAjuste = "Entrada/Salida">
					</cfif>

					<cfset Movimiento = rsEMovInventario.ID_Movimiento>
					<cfset TipoMov 	  = rsEMovInventario.Tipo_Movimiento>
					<!--- Marca fecha de registro --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Movimientos_Inventario
						set 	Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where 	ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Movimiento#">
					</cfquery>

					<!--- Busca equivalencias --->
					<!--- EMPRESAS --->
					<cfset Equiv 		 = ConversionEquivalencia (rsEMovInventario.Origen, 'CADENA', rsEMovInventario.Ecodigo, rsEMovInventario.Ecodigo, 'Cadena')>
					<cfset varEcodigo 	 = Equiv.EQUidSIF>
					<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
					<cfset session.dsn 	 = getConexion(varEcodigo)>
					<cfset varCEcodigo 	 = getCEcodigo(varEcodigo)>
					<cfset varCconcepto  = ConceptoContable(varEcodigo,"LDMI")>

					<!--- Parametros --->
						<!--- Obtiene los parametros --->
						<!--- <cfset ParOfic = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=1,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsEMovInventario.Origen)> --->

						<!--- Equivalencia Centro Funcional --->
						<!--- <cfset ParCF = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=1,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsEMovInventario.Origen)> --->

						<!--- Borrar Registro --->
						<!--- <cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Sucursal=1,Pcodigo=4,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsEMovInventario.Origen)> --->

						 <!--- Agrupamiento --->
						<!--- <cfset ParAgrupa = Parametros(Ecodigo=varEcodigo,Sucursal=1,Pcodigo=7,Parametro="Agrupa Pólizas",ExtBusqueda=true, Sistema = rsEMovInventario.Origen)> --->

						<!--- Obtiene el usuario de Interfaz --->
						<cfset Usuario = UInterfaz (getCEcodigo(varEcodigo))>
						<cfset varUlogin = Usuario.Usulogin>
						<cfset varUcodigo = Usuario.Usucodigo>
					<!--- Parametros --->

					<!---OFICINA --->
					<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
						<cfif ParOfic>
							<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'SUCURSAL', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Origen, 'Sucursal')>
							<cfset VarOcodigoO = Equiv.EQUidSIF>
							<cfset VarOficinaO = Equiv.EQUcodigoSIF>
						<cfelse>
							 <cfset VarOficinaO = rsEMovInventario.Sucursal_Origen>
							 <cfquery 	name="rsOFid" datasource="#session.dsn#">
								select 	Ocodigo
								from 	Oficinas
								where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and 	Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficinaO#">
							 </cfquery>
							 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
								<cfset VarOcodigoO = rsOFid.Ocodigo>
							 </cfif>
						</cfif>
					</cfif>
					<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
						<cfif ParOfic>
							<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'SUCURSAL', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Destino, 'Sucursal')>
							<cfset VarOcodigoD = Equiv.EQUidSIF>
							<cfset VarOficinaD = Equiv.EQUcodigoSIF>
						<cfelse>
							 <cfset VarOficinaD = rsEMovInventario.Sucursal_Destino>
							 <cfquery name="rsOFid" datasource="#session.dsn#">
								select 	Ocodigo
								from 	Oficinas
								where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and 	Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficinaD#">
							 </cfquery>
							 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
								<cfset VarOcodigoD = rsOFid.Ocodigo>
							 </cfif>
						</cfif>
					</cfif>

					<!--- CENTRO FUNCIONAL--->
					<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
						<cfif ParCF>
							<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'CENTRO_FUN', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Origen, 'Centro_Funcional')>
							<cfset varidCFO = Equiv.EQUidSIF>
							<cfset varCFO = Equiv.EQUcodigoSIF>
						<cfelse>
							<cfset varCFO = rsEMovInventario.Sucursal_Origen>
							<cfquery name="rsOFid" datasource="#session.dsn#">
								select 	CFid
								from 	CFuncional
								where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and 	CFcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO#">
							 </cfquery>
							 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
								<cfset varidCFO = rsOFid.CFid>
							 </cfif>
						</cfif>
					</cfif>
					<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
						<cfif ParCF>
							<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'CENTRO_FUN', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Destino, 'Centro_Funcional')>
							<cfset varidCFD = Equiv.EQUidSIF>
							<cfset varCFD = Equiv.EQUcodigoSIF>
						<cfelse>
							<cfset varCFD = rsEMovInventario.Sucursal_Destino>
							<cfquery name="rsOFid" datasource="#session.dsn#">
								select 	CFid
								from 	CFuncional
								where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
								and 	CFcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD#">
							 </cfquery>
							 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
								<cfset varidCFD = rsOFid.CFid>
							 </cfif>
						</cfif>
					</cfif>

					<!--- Busca Periodo en Minisif --->
					<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
						select 	Pvalor from Parametros
						where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						and 	Pcodigo = 50
					</cfquery>
					<cfset Periodo = BuscaPeriodo.Pvalor>

					<!--- Busca Mes en Minisif --->
					<cfquery name="BuscaMes" datasource="#session.dsn#">
						select 	Pvalor from Parametros
						where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						and 	Pcodigo = 60
					</cfquery>
					<cfset Mes = BuscaMes.Pvalor>

					<!--- Busca Moneda Local SIF --->
					<cfquery name="rsMoneda" datasource="#session.dsn#">
						select 	e.Ecodigo, e.Edescripcion,m.Miso4217
						from 	Monedas m
							inner join Empresas e
							on 	m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
						where 	e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
					</cfquery>
					<cfif isdefined("rsMoneda") and rsMoneda.recordcount EQ 1>
						<cfset varMoneda = rsMoneda.Miso4217>
					<cfelse>
						<cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsMoneda.Enombre#">
					</cfif>

					<!---Verifica si debe insertar encabezado o no --->
					<cfquery name="rsVerificaE" datasource="sifinterfaces">
						select 	ID
						from 	SIFLD_IE18
						where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						and 	Edocbase like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEMovInventario.Documento)#">
					</cfquery>
					<cfif rsVerificaE.recordcount EQ 0>
						<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 --->
						<cfset RsMaximo = ExtraeMaximo("IE18","ID")>
						<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
							<cfset Maximus = RsMaximo.Maximo>
						<cfelse>
							<cfset Maximus = 1>
						</cfif>

						<cfquery datasource="sifinterfaces">
							insert into SIFLD_IE18
								(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase,
								 Ereferencia, Falta, Usuario, CEcodigo, EcodigoSDC,
								 Usulogin, Usucodigo, ECIreversible)
							values
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
							 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento,"yyyy/mm/dd")#">,
							 left(<cfqueryparam cfsqltype="cf_sql_varchar" value="Movs. Inventario #DescAjuste# #rsEMovInventario.Descripcion# #rsEMovInventario.Documento#">,100),
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMovInventario.Documento#">,
							 '', getdate(),
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
							 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
							 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">,
							 0)
						</cfquery>

						<cfset IDlinea = 1>
						<cfset varBorraRegistro = true>
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

					<!--- Selecciona Detalles de Movimiento--->
					<cfquery name="rsDMovInventario" datasource="sifinterfaces">
						select  Ecodigo, ID_Movimiento, Id_Linea, Clas_Item, Cod_Item, Cantidad,
							Costo, Cod_Fabricante, Tipo_Item, Impuesto_Id
						from DSIFLD_Movimientos_Inventario
						where ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Movimiento#">
					</cfquery>

					<cfif isdefined("rsDMovInventario") and rsDMovInventario.recordcount GT 0>
					<cfloop query = "rsDMovInventario">
						<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
							<!--- ALMACEN SALIDAS --->
							<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
								Oorigen="LDMI"
								Ecodigo="#varEcodigo#"
								Conexion="#session.dsn#"
								LDOperacion="ALM"
								LDDepartamento="#Impuesto_Id#"
								LDClasificacion="#rsDMovInventario.Clas_Item#"
								LDFabricante="#rsDMovInventario.Cod_Fabricante#"
								LDTipoVenta="NOUSAR"
								SNegocios="NOUSAR"
								Impuestos="#rsDMovInventario.Impuesto_Id#"
								Oficinas="#VarOcodigoO#"
								LDConceptoRetiroCaja="NOUSAR"
								Bancos="NOUSAR"
								LDCuentaBanco="NOUSAR"
								LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
								LDAlmacen="#rsEMovInventario.Almacen_Origen#"
								LDTipoRetiroCaja="NOUSAR"
							>
							<cfset CuentaLDCA_S = Cuenta>

							<!--- AJUSTE SALIDAS --->
							<cfif rsEMovInventario.Tipo_Movimiento NEQ "DC" and  rsEMovInventario.Tipo_Movimiento NEQ "RC" and  rsEMovInventario.Tipo_Movimiento NEQ "TR">
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="LDMI"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="#rsEMovInventario.Tipo_Movimiento#"
									LDDepartamento="#rsDMovInventario.Tipo_Item#"
									LDClasificacion="#rsDMovInventario.Clas_Item#"
									LDFabricante="#rsDMovInventario.Cod_Fabricante#"
									LDTipoVenta="NOUSAR"
									SNegocios="NOUSAR"
									Impuestos="#rsDMovInventario.Impuesto_Id#"
									Oficinas="#VarOcodigoO#"
									LDConceptoRetiroCaja="NOUSAR"
									Bancos="NOUSAR"
									LDCuentaBanco="NOUSAR"
									LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
									LDAlmacen="AJ#rsEMovInventario.Almacen_Origen#"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDAJ_S = Cuenta>
							</cfif>
						</cfif>

						<!--- ALMACEN VENTAS ENTRADAS --->
						<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
							<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
								Oorigen="LDMI"
								Ecodigo="#varEcodigo#"
								Conexion="#session.dsn#"
								LDOperacion="ALM"
								LDDepartamento="#rsDMovInventario.Tipo_Item#"
								LDClasificacion="#rsDMovInventario.Clas_Item#"
								LDFabricante="#rsDMovInventario.Cod_Fabricante#"
								LDTipoVenta="NOUSAR"
								SNegocios="NOUSAR"
								Impuestos="#rsDMovInventario.Impuesto_Id#"
								Oficinas="#VarOcodigoD#"
								LDConceptoRetiroCaja="NOUSAR"
								Bancos="NOUSAR"
								LDCuentaBanco="NOUSAR"
								LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
								LDAlmacen="#rsEMovInventario.Almacen_Destino#"
								LDTipoRetiroCaja="NOUSAR"
							>
							<cfset CuentaLDCA_E = Cuenta>

							<!--- AJUSTE ENTRADAS --->
							<cfif rsEMovInventario.Tipo_Movimiento NEQ "DC" and  rsEMovInventario.Tipo_Movimiento NEQ "RC" and  rsEMovInventario.Tipo_Movimiento NEQ "TR">
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="LDMI"
									Ecodigo="#varEcodigo#"
									Conexion="#session.dsn#"
									LDOperacion="#rsEMovInventario.Tipo_Movimiento#"
									LDDepartamento="#rsDMovInventario.Tipo_Item#"
									LDClasificacion="#rsDMovInventario.Clas_Item#"
									LDFabricante="#rsDMovInventario.Cod_Fabricante#"
									LDTipoVenta="NOUSAR"
									SNegocios="NOUSAR"
									Impuestos="#rsDMovInventario.Impuesto_Id#"
									Oficinas="#VarOcodigoD#"
									LDConceptoRetiroCaja=""
									Bancos="NOUSAR"
									LDCuentaBanco="NOUSAR"
									LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
									LDAlmacen="AJ#rsEMovInventario.Almacen_Destino#"
									LDTipoRetiroCaja="NOUSAR"
								>
								<cfset CuentaLDAJ_E = Cuenta>
							</cfif>
						</cfif>

						<!--- TRANSITO (No Importa el Almacen) --->
						<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
							<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
								Oorigen="LDMI"
								Ecodigo="#varEcodigo#"
								Conexion="#session.dsn#"
								LDOperacion="TRN"
								LDDepartamento="#rsDMovInventario.Tipo_Item#"
								LDClasificacion="#rsDMovInventario.Clas_Item#"
								LDFabricante="#rsDMovInventario.Cod_Fabricante#"
								LDTipoVenta="NOUSAR"
								SNegocios="NOUSAR"
								Impuestos="NOUSAR"
								Oficinas="#VarOcodigoO#"
								LDConceptoRetiroCaja=""
								Bancos="NOUSAR"
								LDCuentaBanco="NOUSAR"
								LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
								LDAlmacen="TRN"
								LDTipoRetiroCaja="NOUSAR"
							>
							<cfset CuentaLDITO = Cuenta>
						</cfif>
						<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
							<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
								Oorigen="LDMI"
								Ecodigo="#varEcodigo#"
								Conexion="#session.dsn#"
								LDOperacion="TRN"
								LDDepartamento="#rsDMovInventario.Tipo_Item#"
								LDClasificacion="#rsDMovInventario.Clas_Item#"
								LDFabricante="#rsDMovInventario.Cod_Fabricante#"
								LDTipoVenta="NOUSAR"
								SNegocios="NOUSAR"
								Impuestos="NOUSAR"
								Oficinas="#VarOcodigoD#"
								LDConceptoRetiroCaja=""
								Bancos="NOUSAR"
								LDCuentaBanco="NOUSAR"
								LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
								LDAlmacen="TRN"
								LDTipoRetiroCaja="NOUSAR"
							>
							<cfset CuentaLDITD = Cuenta>
						</cfif>

						<cfset MontoLin = rsDMovInventario.Cantidad * rsDMovInventario.Costo>

						<!--- Inserta los asientos de la Poliza --->
						<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
							<!--- Salida de Almacen --->
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_ID18
									(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
									 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
								values
								(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, "yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								 <cfif ParCuentaxIVA>
								 	<cfif rsDMovInventario.Impuesto_Id EQ 1>
								 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Salida de Almacen 16%">,
								 	<cfelse>
								 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Salida de Almacen 0%">,
								 	</cfif>
								 <cfelse>
								 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Salida de Almacen">,
								 </cfif>
								 '', '', 'C',
								 0, 0, 0, 0,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
								 1,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								 getdate(), 0,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_S.CFformato#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficinaO#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO#">,
								 1)
							</cfquery>
							<cfset IDlinea = IDlinea + 1>

							<!--- Entrada a Transito --->
							<cfif rsEMovInventario.Tipo_Movimiento EQ "DC" OR  rsEMovInventario.Tipo_Movimiento EQ "RC" OR  (rsEMovInventario.Tipo_Movimiento EQ "TR" AND (TipoAjuste NEQ "ES" OR (TipoAjuste EQ "ES" AND varOficinaO NEQ varOficinaD)))>
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
										(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
										 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
									values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, "yyyy/mm/dd")#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Entrada a Transito">,
									 '', '', 'D',
									 0, 0, 0, 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
									 1,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
									 getdate(), 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDITO.CFformato#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficinaO#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO#">,
									 4)
								</cfquery>
								<cfset IDlinea = IDlinea + 1>
							</cfif>
						</cfif>

						<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
							<!--- Entrada de Almacen --->
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_ID18
									(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
									 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
								values
								(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, "yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								 <cfif ParCuentaxIVA>
								 	<cfif rsDMovInventario.Impuesto_Id EQ 1>
								 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Entrada de Almacen 16%">,
								 	<cfelse>
								 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Entrada de Almacen 0%">,
								 	</cfif>
								 <cfelse>
								 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Entrada de Almacen">,
								 </cfif>
								 '', '', 'D',
								 0, 0, 0, 0,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
								 1,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								 getdate(), 0,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_E.CFformato#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficinaD#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD#">,
								 2)
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
							<!--- Salida de Transito --->
							<cfif rsEMovInventario.Tipo_Movimiento EQ "DC" OR  rsEMovInventario.Tipo_Movimiento EQ "RC" OR  (rsEMovInventario.Tipo_Movimiento EQ "TR" AND (TipoAjuste NEQ "ES" OR (TipoAjuste EQ "ES" AND varOficinaO NEQ varOficinaD)))>
								<cfquery datasource="sifinterfaces">
									insert into SIFLD_ID18
										(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
										 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
									values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
									 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, "yyyy/mm/dd")#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Salida de Transito">,
									 '', '', 'C',
									 0, 0, 0, 0,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
									 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
									 1,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
									 getdate(), 0,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDITD.CFformato#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficinaD#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD#">,
									 3)
								</cfquery>
								<cfset IDlinea = IDlinea + 1>
							</cfif>
						</cfif>

						<!--- Movimiento de Ajuste--->
						<cfif rsEMovInventario.Tipo_Movimiento NEQ "DC" and  rsEMovInventario.Tipo_Movimiento NEQ "RC" and  rsEMovInventario.Tipo_Movimiento NEQ "TR">
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_ID18
									(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato,
									 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
								values
								(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, "yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
								 <cfif TipoAjuste EQ "E">
									 <cfif ParCuentaxIVA>
									 	<cfif rsDMovInventario.Impuesto_Id EQ 1>
									 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Entrada 16%">,
									 	<cfelse>
									 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Entrada 0%">,
									 	</cfif>
									 <cfelse>
									 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Entrada">,
									 </cfif>
								 <cfelseif TipoAjuste EQ "S">
								 	<cfif ParCuentaxIVA>
									 	<cfif rsDMovInventario.Impuesto_Id EQ 1>
									 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Salida 16%">,
									 	<cfelse>
									 		<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Salida 0%">,
									 	</cfif>
									 <cfelse>
									 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Salida">,
									 </cfif>
								 </cfif>
								 '', '',
								 <cfif TipoAjuste EQ "E">
									'C',
								 <cfelseif TipoAjuste EQ "S">
									'D',
								 </cfif>
								 0, 0, 0, 0,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
								 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
								 1,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
								 getdate(), 0,
								 <cfif TipoAjuste EQ "E">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAJ_E.CFformato#">,
								 <cfelseif TipoAjuste EQ "S">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAJ_S.CFformato#">,
								 </cfif>
								 <cfif TipoAjuste EQ "E">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficinaD#">,
								 <cfelseif TipoAjuste EQ "S">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficinaO#">,
								 </cfif>
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
								 <cfif TipoAjuste EQ "E">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD#">,
								 <cfelseif TipoAjuste EQ "S">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO#">,
								 </cfif>
								 5)
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						</cfif>
					</cfloop> <!---Detalle de Ventas --->
					</cfif>

					<!--- Marca o Borra las Tablas Origen Registro Procesado --->
					<!--- BORRADO DE TABLAS ORIGEN --->
					<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces">
						<cfif Parborrado>
							delete 	DSIFLD_Movimientos_Inventario where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
							delete	ESIFLD_Movimientos_Inventario where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
						<cfelse>
							update 	ESIFLD_Movimientos_Inventario
							set 	Estatus = 92,
									ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
									Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									Periodo = #Periodo#,
									Mes = #Mes#
							where 	ID_Movimiento = #rsEMovInventario.ID_Movimiento#
						</cfif>
					</cfquery>

				<cfcatch type="any"> <!---Error en Inventarios --->
					<!--- Marca El registro con Error--->
					<cfquery datasource="sifinterfaces">
						update ESIFLD_Movimientos_Inventario
						set Estatus = 3,
						Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
					</cfquery>
					<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
					<cfif varBorraRegistro>
						<cfif isdefined("Maximus") and Maximus NEQ 0>
							<cfquery datasource="sifinterfaces">
								delete SIFLD_ID18
								where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
							</cfquery>
							<cfquery datasource="sifinterfaces">
								delete from SIFLD_IE18
								where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
							</cfquery>
						</cfif>
					<cfelse>
						<cfif isdefined("Maximus") and Maximus NEQ 0 and isdefined("IDStart")>
							<cfquery datasource="sifinterfaces">
								delete SIFLD_ID18
								where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
								and DCIconsecutivo > <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDStart#">
							</cfquery>
					   </cfif>
					</cfif>

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
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
						(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam,MsgErrorPila, Ecodigo, Usuario)
						values
						('CG_Inventarios',
						 'ESIFLD_Movimientos_Inventario',
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEMovInventario.ID_Movimiento#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEMovInventario.Ecodigo#">,
						 null)
					</cfquery>
				</cfcatch>
				</cftry>
			</cfloop> <!--- Encabezados Inventarios --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select count(1) as Registros from ESIFLD_Movimientos_Inventario
				where Estatus in (99,10)
			</cfquery>
			<cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz de forma Masiva--->
				<cftransaction action="begin">
				<cftry>
					<cfquery datasource="sifinterfaces">
						delete SIFLD_ID18B where Interfaz = 'CG_Inventarios'
					</cfquery>
					<!---Prepara los registros para ser insertados--->
					<cfquery datasource="sifinterfaces">
						update SIFLD_IE18
							set Interfaz = 'CG_Inventarios', Estatus = 1
						where ID in (select ID18
									 from ESIFLD_Movimientos_Inventario
									 where Estatus in (92))
					</cfquery>

					<!--- Inserta En las Interfaces --->
					<cfquery datasource="sifinterfaces">
						insert into IE18
							(ID, Ecodigo, Cconcepto, Eperiodo, Emes,
							 Efecha, Edescripcion, Edocbase, Ereferencia,
							 Falta, Usuario, ECIreversible)
						select
							ID, Ecodigo, Cconcepto, Eperiodo, Emes,
							Efecha, Edescripcion, Edocbase, Ereferencia,
							Falta, Usuario, ECIreversible
						from SIFLD_IE18 a
						where Interfaz = 'CG_Inventarios' and Estatus = 1
					</cfquery>
					<cfif ParAgrupa>
						<cfquery datasource="sifinterfaces">
							insert into SIFLD_ID18B
								(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
								 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
								 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								 Referencia1, Referencia2, Referencia3, CFcodigo, Interfaz)
							select ID, 0 as Consecutivo, Ecodigo, getdate(), Eperiodo, Emes,
								Ddescripcion, '','', Dmovimiento, null,
								null, null, null, sum(Doriginal), sum(Dlocal), Dtipocambio,
								Cconcepto, getdate(), EcodigoRef, CFformato, Oficodigo, Miso4217,
								null, null, null, CFcodigo, 'CG_Inventarios'
							from SIFLD_ID18 a
							where exists (select 1
										  from SIFLD_IE18 b
										  where a.ID = b.ID and b.Interfaz = 'CG_Inventarios' and b.Estatus = 1)
							group by ID, Ecodigo, Eperiodo, Emes, EcodigoRef, Oficodigo, Cconcepto,
									TipoOperacion, Dmovimiento, Ddescripcion, CFformato, Miso4217,
									Dtipocambio, CFcodigo
							order by ID
						</cfquery>

						<!--- Actualiza Consecutivo --->
						<cfquery datasource="sifinterfaces">
							declare @Consecutivo numeric(18,0)

							select @Consecutivo = 0

							update SIFLD_ID18B
							set  Consecutivo = @Consecutivo,
							@Consecutivo = @Consecutivo + 1
							where Interfaz = 'CG_Inventarios'
						</cfquery>

						<cfset varConsecutivo = 0>
						<cfset varID = 0>

						<cfquery name="rsConsecutivo" datasource="sifinterfaces">
							select ID, Consecutivo
							from SIFLD_ID18B
							where Interfaz = 'CG_Inventarios'
							order by ID, Consecutivo
						</cfquery>

						<cfloop query="rsConsecutivo">
							<cfif rsConsecutivo.ID NEQ varID>
								<cfset varConsecutivo = 1>
								<cfset varID = rsConsecutivo.ID>
							<cfelse>
								<cfset varConsecutivo = varConsecutivo + 1>
							</cfif>

							<cfquery datasource="sifinterfaces">
								update SIFLD_ID18B
								set  DCIconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varConsecutivo#">
								where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivo.ID#">
								and Consecutivo = <cfqueryparam cfsqltype="cf_sql_inetger" value="#rsConsecutivo.Consecutivo#">
								and Interfaz = 'CG_Inventarios'
							</cfquery>
						</cfloop>

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
							from SIFLD_ID18B where Interfaz = 'CG_Inventarios'
						</cfquery>
					<cfelse>
						<cfquery name="rsID18V" datasource="sifinterfaces">
							insert into ID18
								(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
								 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
								 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								 Referencia1, Referencia2, Referencia3, CFcodigo)
							select
								ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
								Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, null,
								null, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
								Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
								Referencia1, Referencia2, Referencia3, CFcodigo
							from SIFLD_ID18 a
							where exists (select 1
										  from SIFLD_IE18 b
										  where a.ID = b.ID and b.Interfaz = 'CG_Inventarios' and b.Estatus = 1)
						</cfquery>
					</cfif>

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
						where Interfaz = 'CG_Inventarios' and Estatus = 1
					</cfquery>

					<cfquery datasource="sifinterfaces">
						update ESIFLD_Movimientos_Inventario
							set Estatus = 2
						where Estatus in (92)
						and ID18 in (select ID from SIFLD_IE18 where Interfaz = 'CG_Inventarios' and Estatus = 1)
					</cfquery>

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
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
						(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
						select 'CG_Inventarios', 'ESIFLD_Movimientos_Inventario', ID_Movimiento,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
							Ecodigo,
							null
						from ESIFLD_Movimientos_Inventario
						where Estatus in (92)
						and ID18 in (select ID from SIFLD_IE18 where Interfaz = 'CG_Inventarios' and Estatus = 1)
					</cfquery>
					<cfquery datasource="sifinterfaces">
						update ESIFLD_Movimientos_Inventario set Estatus = 3
						where Estatus in (92)
						and ID18 in (select ID from SIFLD_IE18 where Interfaz = 'CG_Inventarios' and Estatus = 1)
					</cfquery>
				</cfcatch>
				</cftry>
				</cftransaction>

				<cfquery datasource="sifinterfaces">
					delete SIFLD_ID18
					where ID in (select ID18 from ESIFLD_Movimientos_Inventario where Estatus in (2,4,3))
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete SIFLD_IE18
					where ID in (select ID18 from ESIFLD_Movimientos_Inventario where Estatus in (2,4,3))
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>