<!--- ABL: Integracion de Compras PMI --->
<!--- La Integracion de Compra, procesa todas las compras de producto FACT y NOFACT generando los documentos de CxP correspondientes --->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró: Maria de los Angeles Blanco López 26 de Octubre del 2009--->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="no">
		<cfargument name="Disparo" required="no" type="boolean" default="true">
		<cfset varEQUempOrigen = ''>

		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		<cfset ParCF = true>
		<cfset ParPorIVA  = true>

		<!---Actualiza los registros a Estatus en Proceso--->
		<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
			update 	ESIFLD_Facturas_Compra
			set 	Estatus = 10
			where
			<cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
				Estatus = 1
				and RTRIM(LTRIM(Numero_Documento)) NOT IN (select RTRIM(LTRIM(Numero_Documento)) AS Numero_Documento from ESIFLD_Facturas_Compra where Estatus in (10, 11,94,92,99,100)) <!----QUITAR EL 94---->
			<cfelse>
				Estatus = 99
				and RTRIM(LTRIM(Numero_Documento)) NOT IN (select RTRIM(LTRIM(Numero_Documento)) AS Numero_Documento from ESIFLD_Facturas_Compra where Estatus in (10, 11))
			</cfif>
			AND Remision = 0
			and Ecodigo = 1
			AND Total > 0
		</cfquery>

		<!--- toma registros cabecera de las Compras --->
		<cfquery name="rsECompras" datasource="sifinterfaces">
			select 	Ecodigo, Origen, ID_DocumentoC, Tipo_Documento, Fecha_Compra, Fecha_Arribo, Fecha_Vencimiento, Contrato,
									Numero_Documento,  Proveedor, Sucursal, Moneda, Fecha_Tipo_Cambio, Tipo_Cambio,
									Retencion, Almacen, Clas_Compra, Dest_Compra, Usuario
			from 	ESIFLD_Facturas_Compra
			where 	Estatus = 10
			<cfif Rupdate.recordcount EQ 0>
				and 1 = 2
			</cfif>
		</cfquery>

		<cfif isdefined("rsECompras") AND rsECompras.recordcount GT 0>
			<cfloop query="rsECompras">
				<cftry>
					<cfset var DocumentoFact = rsECompras.ID_DocumentoC>
					<!--- Marca fecha de proceso --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Compra
						set 	Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where 	ID_DocumentoC = #DocumentoFact#
					</cfquery>

					<!--- Extrae Maximo+1 de tabla IE10 para insertar nuevo reg, en IE10 --->
					<cfset RsMaximo = ExtraeMaximo("IE10","ID")>
					<cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
						<cfset Maximus = #RsMaximo.Maximo#>
					<cfelse>
						<cfset Maximus = 1>
					</cfif>

					<!--- EMPRESAS --->
					<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'CADENA', rsECompras.Ecodigo, rsECompras.Ecodigo, 'Cadena')>
					<cfset varEcodigo 	 = Equiv.EQUidSIF>
					<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
					<cfset session.dsn 	 = getConexion(varEcodigo)>
					<cfset varCEcodigo 	 = getCEcodigo(varEcodigo)>

					<!--- OBTIENE LOS PARAMETROS --->
					<!--- Oficina --->
					<cfset ParOfic 	  = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=rsECompras.Sucursal,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsECompras.Origen)>
					<!--- Centro Funcional --->
					<cfset ParCF 	  = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=rsECompras.Sucursal,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsECompras.Origen)>
					<!--- Borrar Registro --->
					<cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsECompras.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsECompras.Origen)>

					<!--- Busca Periodo en Minisif --->
					<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
						select Pvalor from Parametros
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						and Pcodigo = 50
					</cfquery>
					<cfset Periodo = BuscaPeriodo.Pvalor>

					<!--- Busca Mes en Minisif --->
					<cfquery name="BuscaMes" datasource="#session.dsn#">
						select Pvalor from Parametros
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
						and Pcodigo = 60
					</cfquery>
					<cfset Mes = BuscaMes.Pvalor>

					<!---BUSCA EQUIVALENCIAS--->
					<!--- Obtiene el usuario de Interfaz --->
					<cfset Usuario 	  = UInterfaz (getCEcodigo(varEcodigo))>
					<cfset varUlogin  = Usuario.Usulogin>
					<cfset varUcodigo = Usuario.Usucodigo>

					<!---OFICINA --->
					<cfif ParOfic>
						<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'SUCURSAL', rsECompras.Ecodigo, rsECompras.Sucursal, 'Sucursal')>
						<cfset VarOcodigo = Equiv.EQUidSIF>
						<cfset VarOficina = Equiv.EQUcodigoSIF>
					<cfelse>
						 <cfset VarOficina = rsECompras.Sucursal>
						 <cfquery name="rsOFid" datasource="#session.dsn#">
							select Ocodigo
							from Oficinas
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
							and Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficina#">
						 </cfquery>
						 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
							<cfset VarOcodigo = rsOFid.Ocodigo>
						 </cfif>
					</cfif>

					<!--- CENTRO FUNCIONAL--->
					<cfif ParCF>
						<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'CENTRO_FUN', rsECompras.Ecodigo, rsECompras.Sucursal, 'Centro_Funcional')>
						<cfset varidCF = Equiv.EQUidSIF>
						<cfset varCF = Equiv.EQUcodigoSIF>
					<cfelse>
						<cfset varCF = rsECompras.Sucursal>
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

					<!--- MONEDA --->
					<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'MONEDA', rsECompras.Ecodigo, rsECompras.Moneda, 'Moneda')>
					<cfset varMoneda = Equiv.EQUcodigoSIF>

					<!---RETENCION--->
					<cfif isdefined("rsECompras.Retencion") and trim(rsECompras.Retencion) NEQ "">
						<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'RETENCION', varEQUempOrigen, rsECompras.Retencion, 'Retencion')>
						<cfset VarRetencion = Equiv.EQUcodigoSIF>
					</cfif>

					<!---'PROVEEDOR', 'ECODIGO' --->
					<cfquery name="rstiposocio" datasource="#session.dsn#">
						select sntipoSocio from SNegocios
						where Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">
						and SNcodigoext = #rsECompras.Proveedor#
						and sntipoSocio in ('P','A')
					</cfquery>
					<cfif rstiposocio.sntipoSocio EQ 'A'>
						<cfset VarPrv = ExtraeCliente(rsECompras.Proveedor, varEcodigo,"A","S")>
					<cfelse>
						<cfset VarPrv = ExtraeCliente(rsECompras.Proveedor, varEcodigo,"P","S")>
					</cfif>
					<!---Tipo de Contraparte --->

					<!--- <cfquery name="rsContraparte" datasource="#session.dsn#">
						select 	sn.SNcodigo, snd.SNCDdescripcion
						from	SNClasificacionSN csn
							inner join 	SNegocios sn	on csn.SNid = sn.SNid
							and 	sn.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">
							and 	sn.SNcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarPrv.SNcodigo#">
							inner join 	SNClasificacionD snd
								inner join 	SNClasificacionE sne
								on 	snd.SNCEid 	 = sne.SNCEid
								and	sne.CEcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varCEcodigo#">
							on csn.SNCDid = snd.SNCDid
					</cfquery>
					<cfif isdefined("rsContraparte") and rsContraparte.recordcount GT 0>
						<cfset varContraParte = rsContraparte.SNCDdescripcion>
					<cfelse>
						<cfthrow message="El Socio de Negocio #rsECompras.Proveedor# no tiene asignado un valor para su contraparte">
					</cfif> --->

					<!--- Busca la Moneda Local para la empresa --->
					<cfquery name="rsMonedaL" datasource="#session.dsn#">
						select 	m.Miso4217
						from 	Monedas m
							inner join Empresas e
							on 	m.Ecodigo = e.Ecodigo
							and m.Mcodigo = e.Mcodigo
							and e.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">
					</cfquery>
					<cfif rsMonedaL.recordcount EQ 1 AND len(rsMonedaL.Miso4217) GT 0>
						<cfset varMonedaL = rsMonedaL.Miso4217>
					<cfelse>
						<cfthrow message="Imposible obtener la moneda local para la empresa">
					</cfif>

					<!--- Ver si existe el tipo de cambio para la fecha indicada --->
					<!--- <cfif varMoneda NEQ varMonedaL>
						<cfset varTipoCambio = ExtraeTipoCambio(varMoneda,varEcodigo,rsECompras.Fecha_Tipo_Cambio)>
					</cfif> --->

					<!--- Insercion de cabecera en IE10 --->
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_IE10
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
							 StatusProceso,
							 CEcodigo,
							 Usulogin,
							 Usucodigo)
						values
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigoSDC#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Proveedor#">,
							 'CP',
							 <cfqueryparam cfsqltype="cf_sql_char" value="#rsECompras.Tipo_Documento#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
							 null,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
							 <cfif isdefined("rsECompras.Fecha_Vencimiento") and trim(rsECompras.Fecha_Vencimiento) NEQ "">
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Vencimiento,'yyyy/mm/dd')#">,
							 <cfelse>
								<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
							 </cfif>
							 0,
							 'S',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Origen#">,
							 '0',
							 <cfif isdefined("rsECompras.Retencion") and trim(rsECompras.Retencion) EQ "" >
								null,
							 <cfelse>
								<cfqueryparam cfsqltype="cf_sql_char" value="#VarRetencion#">,
							 </cfif>
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina#">,
							 null,
							 null,
							 null,
							 null,
							 <cfqueryparam cfsqltype="cf_sql_date" value="#rsECompras.Fecha_Tipo_Cambio#">,
							 <cfif isdefined("rsECompras.Tipo_Cambio") and rsECompras.Tipo_Cambio NEQ	'' >
								 <cfqueryparam cfsqltype="cf_sql_float" value="#rsECompras.Tipo_Cambio#">, <!---checar en produccion--->
							 <cfelse>
								 null,
							 </cfif>
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varUcodigo#">,
							 null, <!--- IETU --->
							 1,
							 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varUcodigo#">)
					</cfquery>

					<!--- Seleccion de Detalles --->
					<cfquery name="rsDCompras" datasource="sifinterfaces">
						select Ecodigo, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item, Cod_Item, Cod_Impuesto, Cod_Fabricante, Cantidad,
							   isnull(Precio_Unitario, 0) as Precio_Unitario, isnull(Descuento_Lin, 0) as Descuento_Lin,
							   isnull (Subtotal_Lin, 0) as Subtotal_Lin, isnull(Impuesto_Lin, 0) as Impuesto_Lin,
							   isnull(Total_Lin,0) as Total_Lin, Clas_Compra_Lin, Dest_Compra_Lin, Contrato_Lin, Clas_Venta_Ref,
							   CFuncional, codIEPS, MontoIEPS
						from 	DSIFLD_Facturas_Compra
						where 	ID_DocumentoC = #DocumentoFact#
					</cfquery>

					<cfset IDlinea = 1>
					<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
						<cfloop query = "rsDCompras">
							<!--- Busca equivalencia de Impuesto en SIF --->
							<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'IMPUESTO', rsECompras.Ecodigo, rsDCompras.Cod_Impuesto, 'Cod_Impuesto')>
							<cfset VarImpuesto = Equiv.EQUcodigoSIF>

							<!--- EQUIVALENCIA CENTRO FUNCIONAL --->
							<cfif ParCF>
								<!--- CENTRO FUNCIONAL--->
								<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'CENTRO_FUN', rsECompras.Ecodigo, rsECompras.Sucursal, 'Centro_Funcional')>
								<cfset varidCF = Equiv.EQUidSIF>
								<cfset varCF = Equiv.EQUcodigoSIF>
							<cfelse>
								<cfset varCF = rsECompras.Sucursal>
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
							<!--- 'CONCEPTO SERVICIO' --->
							<cfset VarConcepto = ExtraeConceptoServicio(rsDCompras.Cod_Item, varEcodigo)>
							<cfset VarCodigoConcepto = VarConcepto.Cid>
							<cfset VarCodigoCConcepto = VarConcepto.CCid>

							<!---  IEPS  --->
							<cfif rsDCompras.codIEPS EQ 0 AND rsDCompras.MontoIEPS GT 0>
								<cfset Equiv = ConversionEquivalencia ('LD', 'IEPS', rsECompras.Ecodigo, rsDCompras.codIEPS, 'CodIEPS')>
								<cfset VarIEPS = Equiv.EQUcodigoSIF>
							<cfelseif rsDCompras.codIEPS GT 0>
								<cfset Equiv = ConversionEquivalencia ('LD', 'IEPS', rsECompras.Ecodigo, rsDCompras.codIEPS, 'CodIEPS')>
								<cfset VarIEPS = Equiv.EQUcodigoSIF>
							<cfelse>
								<cfset VarIEPS = 0>
							</cfif>

							<!---Validar Importes Negativos--->
							<cfif rsDCompras.Precio_Unitario LT 0 or rsDCompras.Subtotal_Lin LT 0 or rsDCompras.Impuesto_Lin LT 0 or rsDCompras.Total_Lin LT 0 or rsDCompras.Descuento_Lin LT 0>
								<cfthrow message="El documento contiene valores negativos, no pueden ser procesados valores negativos">
							</cfif>

							<!--- Cuenta de Resultados --->
							<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
								Oorigen			="LDCM"
								Ecodigo			="#varEcodigo#"
								Conexion		="#session.dsn#"
								LDOperacion		="ALM"
								LDDepartamento	="#rsDCompras.Tipo_Item#"
								LDClasificacion	="#rsDCompras.Clas_Item#"
								LDFabricante	="#rsDCompras.Cod_Fabricante#"
								LDTipoVenta		="NOUSAR"
								SNegocios		="#VarPrv.SNcodigo#"
								Impuestos		="#varImpuesto#"
								Oficinas		="#VarOcodigo#"
								LDConceptoRetiroCaja =""
								Almacen			="NOUSAR"
								Bancos			="NOUSAR"
								LDCuentaBanco	="NOUSAR"
								LDMovimientoInventario ="NOUSAR"
								LDAlmacen		="#rsECompras.Almacen#"
								LDTipoRetiroCaja="NOUSAR"
							>
							<cfset Cuenta = Cuenta>
							<cfset varDdesc = ''>

							<cfif ParPorIVA>
								<cftry>
									<cfif rsDCompras.Impuesto_Lin GT 0>
										<cfset varDdesc = ''>
										<cfquery name="rsDdesCItem" datasource="#session.dsn#">
											SELECT top 1 Cdescripcion
											FROM Conceptos
											WHERE Ccodigo like '#rsDCompras.Cod_Item#'
											and Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">
										</cfquery>
										<cfif isdefined('rsDdesCItem') and rsDdesCItem.Recordcount GT 0>
											<cfset varDdesc = '#rsDdesCItem.Cdescripcion#'>
										</cfif>
									<cfelse>
										<cfset varDdesc = 'ALMACEN TASA 0%'>
									</cfif>
								<cfcatch>
									<cfset varDdesc = 'Compras'>
								</cfcatch>
								</cftry>
							<cfelse>
								<cfset varDdesc = 'Compras'>
							</cfif>
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_ID10
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
									 DDdescripcion,
									 codIEPS,
									 MontoIEPS)
								values
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsDCompras.Tipo_Lin#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsDCompras.Cod_Item#">,
									' ',
									getdate(),
									getdate(),
									<cfif isdefined("rsECompras.Moneda") AND #rsECompras.Moneda# GT 1>
										<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDCompras.Precio_Unitario / rsECompras.Tipo_Cambio),'9.9999')#">,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDCompras.Precio_Unitario),'9.9999')#">,
									</cfif>
									' ',
									round(#rsDCompras.Cantidad#, 5),
									round(#rsDCompras.Cantidad#, 5),
									' ',
									' ',
									getdate(),
									' ',
									' ',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varImpuesto#">,
									<cfif rsDCompras.Impuesto_Lin GT 0>
										<cfif isdefined("rsECompras.Moneda") AND #rsECompras.Moneda# GT 1>
											<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDCompras.Impuesto_Lin / rsECompras.Tipo_Cambio),'9.9999')#">,
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDCompras.Impuesto_Lin),'9.9999')#">,
										</cfif>
									<cfelse>
										null,
									</cfif>
									<cfif isdefined("rsECompras.Moneda") AND #rsECompras.Moneda# GT 1>
										<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDCompras.Descuento_Lin / rsECompras.Tipo_Cambio),'9.9999')#">,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat((rsDCompras.Descuento_Lin),'9.9999')#">,
									</cfif>
									<cfif rsDCompras.Tipo_Lin EQ 'A'>
										<cfqueryparam cfsqltype="cf_sql_varchar" value="rsECompras.Almacen">
									<cfelse>
										null,
									</cfif>
									null,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta.CFformato#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#varUcodigo#">,
									<cfif isdefined("rsECompras.Moneda") AND #rsECompras.Moneda# GT 1>
										<cfqueryparam cfsqltype="cf_sql_money" 	 value="#numberformat((rsDCompras.Subtotal_Lin / rsECompras.Tipo_Cambio),'9.9999')#">,
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_money" 	 value="#numberformat((rsDCompras.Subtotal_Lin),'9.9999')#">,
									</cfif>

									<cfqueryparam cfsqltype="cf_sql_varchar" value="#varDdesc#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#VarIEPS#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsDCompras.MontoIEPS#">
									)
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						</cfloop>
					</cfif> <!--- Detalles Ventas --->

					<!--- Marca o Borra las Tablas Origen Registro Procesado --->
					<!--- BORRADO DE TABLAS ORIGEN --->
					<cfquery datasource="sifinterfaces">
						<cfif Parborrado>
							delete 	DSIFLD_Facturas_Compra where ID_DocumentoC = #DocumentoFact#
							delete	ESIFLD_Facturas_Compra where ID_DocumentoC = #DocumentoFact#
						<cfelse>
							update 	ESIFLD_Facturas_Compra
							set 	Estatus = 92,
									ID10 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
									Fecha_Fin_Proceso 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									Periodo = #Periodo#,
									Mes 	= #Mes#
							where ID_DocumentoC = #DocumentoFact#
						</cfif>
					</cfquery>
				<cfcatch>
					<!--- Marca El registro con Error--->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Compra
						set 	Estatus = 3,
								Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where 	ID_DocumentoC = #ID_DocumentoC#
					</cfquery>
					<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
					<cfif isdefined("Maximus")>
						<cfquery datasource="sifinterfaces">
							delete 	SIFLD_ID10
							where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
						</cfquery>
						<cfquery datasource="sifinterfaces">
							delete 	SIFLD_IE10
							where 	ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
						</cfquery>
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
					<!--- Inserta en bitacora de errores --->
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
							(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
						values
							('CP_Compras',
							 'ESIFLD_Facturas_Compra',
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
							 null)
					</cfquery>
				</cfcatch>
				</cftry>
			</cfloop> <!--- Encabezado de Compras --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
				select 	count(1) as Registros from ESIFLD_Facturas_Compra
				where 	Estatus in (99,10)
			</cfquery>
			<cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz de forma Masiva--->
				<cftransaction action="begin">
				<cftry>
					<!--- inserta en IE10 --->
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
						 where exists (select 1 from ESIFLD_Facturas_Compra b where a.ID = b.ID10 and b.Estatus in (92,94)) <!----QUITAR ESTATUS 94--->
					</cfquery>
					<!--- inserta en ID10 --->
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
								 DDdescripcion,
								 codIEPS,
								 MontoIEPS,
								 afectaIVA)
						select a.ID, a.Consecutivo, a.TipoItem, a.CodigoItem, a.NombreBarco,
								 a.FechaHoraCarga, a.FechaHoraSalida, a.PrecioUnitario, a.CodigoUnidadMedida, a.CantidadTotal,
								 a.CantidadNeta, a.CodEmbarque, a.NumeroBOL, a.FechaBOL, a.TripNo,
								 a.ContractNo, a.CodigoImpuesto, a.ImporteImpuesto, a.ImporteDescuento, a.CodigoAlmacen,
								 a.CodigoDepartamento, a.CentroFuncional, a.CuentaFinancieraDet, a.BMUsucodigo,
								 a.PrecioTotal, a.DDdescripcion, a.codIEPS, a.MontoIEPS, a.afectaIVA
						from SIFLD_ID10 a
						where exists (select 1 from ESIFLD_Facturas_Compra b where a.ID = b.ID10 and b.Estatus in (92,94))
						<!--- QUITAR ESTATUS 94--->
					</cfquery>
					<!--- Inserta en Cola de Procesos --->
					<cfquery datasource="sifinterfaces">
						insert into InterfazColaProcesos (
								CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
								EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
								FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion, Cancelar)
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
								Usucodigo,
								Usulogin,
								0 as Cancelar
						from 	SIFLD_IE10 a
						where 	exists (select 1 from ESIFLD_Facturas_Compra b where a.ID = b.ID10 and b.Estatus in (92,94))
						<!--- QUITAR ESTATUS 94--->
					</cfquery>
					<!--- Marca registro como procesado --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Compra
						set 	Estatus = case when Estatus = 94 then 4 else 2 end
						where 	Estatus in (94,92) <!--- QUITAR ESTATUS 94--->
						and 	ID10 in (select ID from SIFLD_IE10)
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
					<!--- Inserta en bitacora de errores --->
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Errores
							(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
						select 'CP_Compras', 'ESIFLD_Facturas_Compra', ID_DocumentoC,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
							Ecodigo,
							Usuario
						from ESIFLD_Facturas_Compra
					</cfquery>
					<!--- Marca registro con error --->
					<cfquery datasource="sifinterfaces">
						update 	ESIFLD_Facturas_Compra set Estatus = 3
						where 	Estatus in (94,92) <!---Quitar estatus 94--->
						and 	ID10 in (select ID from SIFLD_IE10)
					</cfquery>
				</cfcatch>
				</cftry>
				</cftransaction>
				<!--- Borra tabla SIFLD_ID10 --->
				<cfquery datasource="sifinterfaces">
					delete 	SIFLD_ID10
					where 	ID in (select ID10 from ESIFLD_Facturas_Compra where Estatus in (2,4,3))  <!----quitar estatus 4--->
				</cfquery>
				<!--- Borra tabla SIFLD_IE10 --->
				<cfquery datasource="sifinterfaces">
					delete 	SIFLD_IE10
					where 	ID in (select ID10 from ESIFLD_Facturas_Compra where Estatus in (2,4,3)) <!----quitar estatus 4--->
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>