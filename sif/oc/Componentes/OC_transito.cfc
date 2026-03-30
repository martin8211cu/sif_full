<!--- 
	**********************************************
	MOVIMIENTOS DE ORDENES COMERCIALES EN TRANSITO
	**********************************************
	
+Transito (Movimiento origen)
-Transito (Movimiento destino)

+Transito (Movimiento origen)
-Transito (Transformación Producto origen / Mezclado)
+Transito (Transformación Producto destino / Transformado)
-Transito (Movimiento destino producto Transformado)


Movimientos Origenes sin Movimientos Destinos ni Transformacion		
	Registrar en Transito del Producto el Movimiento Origen
	DEBITO al Transito (entrada) del Producto MO.OCPTMcostoValuacion			
Movimientos Origenes con Movimientos Destinos con Costo Calculado o con Movimientos de Transformación
	Registrar en Transito del Producto el Movimiento Origen
	Ajustar por cambio de cantidad todos los Movimientos Origenes y los Movimientos Destinos con Costo Calculado:
		Producto No Transformado:
			Ajustar Transito de cada movimiento origen del Producto y el Costo de cada Movimiento Destino del Producto
			Ajustar Transito de cada movimiento origen del Producto Mezclado y el Transito del Producto Transformado
		Producto Transformado:
			Ajustar Transito de cada movimiento origen del Producto Transformado y el Costo de cada Movimiento Destino del Producto Transformado

	Distribuir el Movimiento Origen entre los Destinos con Costo Calculado:
		Producto No Transformado:
			Pasar de Transito Producto al Costo de cada Movimiento Destino del Producto
			Pasar de Transito Producto Mezclado al Transito del Producto Transformado
		Producto Transformado:
			Pasar de Transito Producto Transformado al Costo de cada Movimiento Destino del Producto Transformado

	DEBITO al Transito (entrada) del Producto MO.OCPTMcostoValuacion			
	Si ya existen Movimientos Destino con Costo calculado o transformacion			
		1) Si hay cambio de cantidad: Ajustar el costo de todos los movimientos origenes del mismo Transporte+Articulo entre todos los movimientos destinos		
			Como el metodo de valuacion de Inventario en Transito es por Acumulación de Costos Entrados,	
			todos los calculos de costos se hacen con base en la CantidadEntrada, como factor de calculo Unitario.	
			Si este factor cambia, significa que hay que ajustar todos los movimientos anteriores donde se calcularon costos.	
			Para cada movimiento origen del mismo Transporte+Articulo excepto el movimiento Actual, se ajusta el COSTO de cada Movimiento Destino con Costo calculado:	
				COSTO = COSTO NUEVO - COSTO VIEJO = MONTO_ORI/TotalCantidadEntradas_NUEVA - MONTO_ORI/CANTIDA_VIEJA = MONTO_ORI * (1/TotalCantidadEntradas_NUEVA - 1/TotalCantidadEntradas_VIEJA)
				Si la TotalCantidadEntradas_NUEVA > TotalCantidadEntradas_VIEJA el costo unitario disminuye y por tanto el ajuste es negativo
				MD.CostoAsignadoMO = CostoMovimientoOri/(1/TotalCantidadEntradas_NUEVA - 1/TotalCantidadEntradas_VIEJA) * CantidadMovimientoDst
				FACTOR_UNITARIO = (1/TotalCantidadEntradas_NUEVA - 1/TotalCantidadEntradas_VIEJA)

		2) Distribuir el costo de movimiento actual entre todos los movimientos destinos		
				MD.CostoAsignadoMO = CostoMovimientoOri/TotalCantidadEntradas * CantidadMovimientoDst	
				FACTOR_UNITARIO = TotalCantidadEntradas

		Los siguientes movimientos se generan 2 veces: 
			1) Ajuste Cantidad: con todos los movimientos origenes del mismo Transporte+Articulo del movimiento actual
				FACTOR_UNITARIO = (1/TotalCantidadEntradas_NUEVA - 1/TotalCantidadEntradas_VIEJA)
			2) Distribución del Costo Origen: con el movimiento actual
				FACTOR_UNITARIO = TotalCantidadEntradas
			
		Por cada Movimiento Origen y Destino (no transformación con Costo Calculado). Pasar de Transito al Costo del Producto		
			MD.CostoAsignadoMO = CostoMovimientoOri / (FACTOR_UNITARIO) * CantidadMovimientoDst	
			CREDITO al Transito (salida) del Producto de cada Movimiento Origen MD.CostoAsignadoMO	
			DEBITO al Costo (Costo de Venta o Costo de Inventario) del Producto por cada Movimiento Origen MD.CostoAsignadoMO	

		Por cada Transformación donde el producto sea origen: Por cada Movimiento Origen pasar de Transito del Producto Mezclado al Transito del Producto Transformado.	
			TTO.CostoMezclado = MO.OCPTMcostoValuacion / (FACTOR_UNITARIO) * TTO.OCTTDcantidad
			TTO.CostoTransformado = PD.ProporcionDst * MO.OCPTMcostoValuacion / (FACTOR_UNITARIO) * TTO.OCTTDcantidad

			CREDITO al Transito (salida) del Producto Mezclado (Artículo Origen, Movimiento Destino Transformacion DT) por cada Movimiento Origen TTO.CostoMezclado
			DEBITO al Transito (entrada) de cada Producto Transformado (Artículo Destino, Movimiento Origen Transformacion OT) por cada Movimiento Origen TTD.CostoTransformado


		Por cada Transformación donde el producto sea origen y existan movimientos destino con costo calculado: Por cada Movimiento Origen pasar del Transito del Producto Transformado al Costo del Producto Transformado.	
			PO.CostoMezclado      = MO.CostoMovOrigenUnitario * PO.cantidadMezclada
			PO.CostoMezclado      = MO.CostoMovOrigen / (FACTOR_UNITARIO) * PO.cantidadMezclada
			PD.CostoTransformado  = PO.CostoMezclado * PD.ProporcionDst
			MD.CostoAsignadoMO_PO = PD.CostoTransformadoUnitario	
										* MD.cantidadMovDestino
			MD.CostoAsignadoMO_PO = PD.CostoTransformado / PTD.TotEntradasCantidad
										* MD.cantidadMovDestino
			MD.CostoAsignadoMO_PO = PO.CostoMezclado * PD.ProporcionDst / PTD.TotEntradasCantidad
										* MD.cantidadMovDestino
			MD.CostoAsignadoMO_PO = MO.CostoMovOrigen 
										/ (FACTOR_UNITARIO) 									-- CostoMezcladoUnitario
										* PO.cantidadMezclada									-- CostoMezclado
										* PD.ProporcionDst 										-- CostoTransformado
										/ PTD.TotEntradasCantidad								-- CostoTransformadoUnitario
										* MD.cantidadMovDestino									-- CostoMovDestino
		
			MD.CostoAsignadoMO_PO = MO.OCPTMcostoValuacion										-- CostoMovOrigen
										/ (FACTOR_UNITARIO)										-- CostoMovOrigenUnitario
										* PO.OCTTDcantidad										-- CostoMovOrigenMezclado
										* PD.ProporcionDst 										-- CostoMovOrigenTransformado
										/ PTD.OCPTentradasCantidad								-- CostoMovOrigenTransformadoUnitario
										* MD.OCPTMcantidad										-- CostoMovOrigenAsignadoAlMovDestino
		
			CREDITO al Transito (salida) del Producto Mezclado (Artículo Origen, Movimiento Destino Transformacion DT) por cada Movimiento Origen TTO.CostoMezclado
			DEBITO al Transito (entrada) de cada Producto Transformado (Artículo Destino, Movimiento Origen Transformacion OT) por cada Movimiento Origen TTD.CostoTransformado


Movimientos Transformación				
	Pasar del Transito del Producto Mezclado (Producto Origen) al Transito del Producto Transformado (Producto Destino)
	TTD.ProporcionDst = TTD.OCTTDcantidad / sum(TTD.OCTTDcantidad)			
	TTO.CostoMezclado = PTO.OCPTentradasCostoTotal / PTO.OCPTentradasCantidad * TTO.OCTTDcantidad
	TTD.CostoTransformado = sum(TTO.CostoMezclado) * TTDProporcionDst

	CREDITO al Transito (salida) de cada Producto Mezclado (Artículo Origen, Movimiento Destino Transformacion DT) TTO.CostoMezclado
	DEBITO al Transito (entrada) de cada Producto Transformado (Artículo Destino, Movimiento Origen Transformacion OT)  TTD.CostoTransformado

Movimientos de Venta CxC
	Registrar el Ingreso
	
Costo de Ventas Directas de Almacen
	Pasar el Costo de Almacen al Costo de Ventas

Movimientos Destino Producto no transformado
	Pasar de Transito al Costo DC DI del movimiento Destino del Producto	
	MD.CostoAsignadoMO = MD.OCPTMcantidad * (MO.OCPTMcosto / PTO.OCPTentradasCantidad)

	CREDITO al Transito (salida) del Producto por cada Movimiento Origen MD.CostoAsignadoMO
	DEBITO al Costo (Costo de Venta o Costo de Inventario) del Producto por cada Movimiento Origen MD.CostoAsignadoMO

Movimientos Destino Producto Transformado
	Pasar de Transito al Costo DC DI del movimiento Destino del Producto Transformado
	Todos los movimientos que involucren Transformación se toman del movimiento origen del producto origen/Mezclado, porque se requiere el concepto de compra.
	Cada costo de un movimiento origen de un Articulo mezclado (Articulo origen en una transformación)
		corresponde a una parte del costo del Producto Transformado (Articulo destino en una transformación)
		CostoTransformado = parte de un movimiento origen de un producto Mezclado, asignado al Costo de un producto Transformado
			La proporción mezclada del producto origen (CostoMovOrigen / TotEntradasCantidad * cantidadMezclada) por la proporción de mezcla (ProporcionDst) es el costo asignado al producto transformado
		CostoMovDestino   = parte de un movimiento origen de un producto Mezclado asignado a un producto Transformado, que le corresponde a un movimiento Destino de ese producto Transformado
			La proporción vendida del producto transformado (cantidadMovDestino * CostoTransformado / TotEntradasCantidad) es el costo asignado a la venta
	
	PO.CostoMezclado      = MO.CostoMovOrigenUnitario * PO.cantidadMezclada
	PO.CostoMezclado      = MO.CostoMovOrigen / PTO.TotEntradasCantidad * PO.cantidadMezclada
	PD.CostoTransformado  = PO.CostoMezclado * PD.ProporcionDst
	MD.CostoAsignadoMO_PO = PD.CostoTransformadoUnitario	
								* MD.cantidadMovDestino
	MD.CostoAsignadoMO_PO = PD.CostoTransformado / PTD.TotEntradasCantidad
								* MD.cantidadMovDestino
	MD.CostoAsignadoMO_PO = PO.CostoMezclado * PD.ProporcionDst / PTD.TotEntradasCantidad
								* MD.cantidadMovDestino
	MD.CostoAsignadoMO_PO = MO.CostoMovOrigen 
								/ PTO.TotEntradasCantidad * PO.cantidadMezclada			-- CostoMezclado
								* PD.ProporcionDst / PTD.TotEntradasCantidad			-- CostoTransformadoUnitario
								* MD.cantidadMovDestino									-- CostoMovDestino

	MD.CostoAsignadoMO_PO = MO.OCPTMcostoValuacion										-- CostoMovOrigen
								/ PTO.OCPTentradasCantidad 								-- CostoMovOrigenUnitario
								* PO.OCTTDcantidad										-- CostoMovOrigenMezclado
								* PD.ProporcionDst 										-- CostoMovOrigenTransformado
								/ PTD.TotEntradasCantidad								-- CostoMovOrigenTransformadoUnitario
								* MD.cantidadMovDestino									-- CostoMovOrigenAsignadoAlMovDestino

	CREDITO al Transito (salida) del Producto Transformado por cada Movimiento Origen de cada producto Origen MD.CostoAsignadoMO_PO			
	DEBITO al Costo (Costo de Venta o Costo de Inventario) del Producto Transformado del Movimiento Destino por cada Movimiento Origen de cada Producto Origen MD.CostoAsignadoMO_PO			


Movimientos de Cierre:
	Todos los sobrantes y faltantes en Transito deben pasar al Costo de cada movimiento destino, prorratedo por cantidad vendida/salida.
		Sobrantes = las existencias de Transito pasan al costo.  Existe un porcentaje máximo permitido que puede quedar como sobrante, y que va a ser distribuido durante el cierre.  
					Si el sobrante es mayor a este porcentaje, significa que faltan movimientos destino.
		Faltantes = existe un porcentaje de holgura permitido (por default 1%), donde se puede vender o sacar de tránstio máximo ese porcentaje mayor a lo entrado.  En ese caso, durante el Cierre se devuelve del costo al tránsito ese faltante.

		costoAjusteMovOrigen = CostoMovOrigen / TotEntradasCantidad * (TotEntradasCantidad - TotSalidasCantidad)
		costoAjusteMovDestino = costoAjusteMovOrigen / TotSalidasCantidad * cantidadMovDestino

		1) Producto No Transformado 
			Pasar de Transito de cada Movimiento Origen al Costo de cada Movimiento Destino de Producto No Transformado:
				la proporción del saldo en Transito de cada Movimiento Origen del Producto No Transformado ([TotalEntradas - TotalSalidas]/TotalEntradas),
				al costo de cada Movimiento Destino proporcional por cantidadSalida del Producto No Transformado (CantidadMovSalida/TotalSalidas)

				MontoMovEntrada
				 / TotalEntradas * (TotalEntradas - TotalSalidas) 
					 / TotalSalidas * CantidadMovSalida

		2) Producto Mezclado 
			Pasar de Transito de cada Movimiento Origen del Producto Mezclado al Costo de cada Movimiento Destino de cada Producto Transformado
				la proporción del saldo en Transito de cada Movimiento Origen del Producto Mezclado ([TotalEntradas - TotalSalidas]/TotalEntradas),
				proporcional por cantidadMezclada (cantidadMezclada / TotalSalidas)
				proporcional a cada Producto Transformado (ProporcionDst)
				al costo de cada Movimiento Destino proporcional por cantidadSalida del Producto Transformado (CantidadMovSalida/TotalSalidas)

				MontoMovEntrada 
				 / TotalEntradas * (TotalEntradas - TotalSalidas) 
				 / TotalSalidas * CantidadMezclada
				 * ProporcionDst
					 / TotalSalidas * CantidadMovSalida

		3) Producto Transformado
			Pasar de Transito del Producto Transformado, el monto de cada Movimiento Origen de cada Producto Mezclado 
			al Costo de cada Movimiento Destino del Producto Transformado
				la proporción del saldo en Transito del Producto Transformado ([TotalEntradas - TotalSalidas]/TotEntradasCantidad),
				al costo de cada Movimiento Destino proporcional por cantidadSalida del Producto Transformado (CantidadMovSalida/TotalSalidas)
				(CostoProductoTransformado = MontoMovEntrada / TotalEntradas * PO.cantidadMezclada * PD.ProporcionDst)

				MontoMovEntrada 
				 / TotalEntradas * CantidadMezclada
				 * ProporcionDst
				 / TotalEntradas * (TotalEntradas - TotalSalidas)
					 / TotalSalidas * CantidadMovSalida
		
			
		CREDITO al Transito (salida) de cada Producto (costoAjusteMovOrigen)
		DEBITO al Costo Movimiento Destino del Producto (costoAjusteMovDestino)
--->

<cfcomponent>
	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
	<cffunction name="fnLeeParametro" returntype="string">
		<cfargument name="Pcodigo"		type="numeric"	required="true">	
		<cfargument name="Pdescripcion"	type="string"	required="true">	
		<cfargument name="Pdefault"		type="string"	required="false">	
		<cfset var rsSQL = "">
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
			   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>
		<cfif rsSQL.Pvalor NEQ "">
			<cfreturn rsSQL.Pvalor>
		<cfelseif isdefined("Arguments.Pdefault")>
			<cfreturn Arguments.Pdefault>
		<cfelse>
			<cf_errorCode	code = "50436"
							msg  = "No se ha definido el Parámetro @errorDat_1@ - @errorDat_2@"
							errorDat_1="#Pcodigo#"
							errorDat_2="#Pdescripcion#"
			>
		</cfif>
	</cffunction>

	<cffunction name="fnOCobtieneCFcuenta" returntype="numeric" access="public">
		<cfargument name="tipo"		type="string"	required="yes">
		<cfargument name="OCid"		type="numeric"	required="yes">
		<cfargument name="Aid"		type="numeric"	required="yes">
		<cfargument name="SNid"		type="numeric"	required="yes">
			<!--- Arguments.SNid = -2 Se usa exclusivamente en Costo de Ventas para Ordenes Destino de Ventas Directas de Almacen --->
		<cfargument name="OCCid"	type="numeric"	required="no" default="-1">
			<!--- Arguments.OCCid = 0 Indica buscar 00=PRODUCTO --->
		<cfargument name="OCIid"	type="numeric"	required="no" default="-1">
			<!--- Arguments.OCIid = 0 Indica buscar 00=PRODUCTO --->


		<cfif Arguments.OCCid EQ 00>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	OCCid
				  from OCconceptoCompra
				 where Ecodigo	 = #session.Ecodigo#
				   and OCCcodigo = '00'
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51428" msg = "No se ha definido el Concepto de Compra '00=PRODUCTO EN TRANSITO'">
			</cfif>
			<cfset Arguments.OCCid = rsSQL.OCCid>
		</cfif>

		<cfif Arguments.OCIid EQ 00>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	OCIid
				  from OCconceptoCompra
				 where Ecodigo	 = #session.Ecodigo#
				   and OCCcodigo = '00'
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cf_errorCode	code = "51428" msg = "No se ha definido el Concepto de Compra '00=PRODUCTO EN TRANSITO'">
			</cfif>
			<cfset Arguments.OCIid = rsSQL.OCIid>
		</cfif>

		<cfif Arguments.tipo EQ "TR">
			<!--- OCid Compra, Aid Compra, SNid Compra, OCCid Compra --->
			<cfset LvarCFcomplemento="CFcomplementoTransito">
			<cfset LvarCFmascara	="CFmascaraTransito">
			<cfset LvarCFtipo		="Producto en Tránsito">
			<cfif Arguments.OCCid EQ -1>
				<cf_errorCode	code = "51429" msg = "Se requiere un Concepto de Compra (OCCid) para obtener el Tipo de Cuenta de TR=Tránsito">
			</cfif>
			<cfif Arguments.OCIid NEQ -1>
				<cf_errorCode	code = "51430" msg = "No se permite enviar un Concepto de Ingreso (OCIid) para obtener el Tipo de Cuenta de TR=Tránsito">
			</cfif>
		<cfelseif Arguments.tipo EQ "CV">
			<!--- OCid Venta, Aid Compra, SNid Compra, OCCid Compra --->
			<cfset LvarCFcomplemento="CFcomplementoCostoVenta">
			<cfset LvarCFmascara	="CFmascaraCostoVenta">
			<cfset LvarCFtipo		="Costo de Ventas">
			<cfif Arguments.OCCid EQ -1>
				<cf_errorCode	code = "51431" msg = "Se requiere un Concepto de Compra (OCCid) para obtener el Tipo de Cuenta de CV=Costo de Ventas">
			</cfif>
			<cfif Arguments.OCIid NEQ -1>
				<cf_errorCode	code = "51432" msg = "No se permite enviar un Concepto de Ingreso (OCIid) para obtener el Tipo de Cuenta de CV=Costo de Ventas">
			</cfif>
		<cfelseif Arguments.tipo EQ "IN">
			<!--- OCid Venta, Aid Venta, SNid Venta, OCCid -1 --->
			<cfset LvarCFcomplemento="CFcomplementoIngreso">
			<cfset LvarCFmascara	="CFmascaraIngreso">
			<cfset LvarCFtipo		="Ingresos">
			<cfif Arguments.OCCid NEQ -1>
				<cf_errorCode	code = "51433" msg = "No se permite enviar un Concepto de Compra (OCCid) para obtener el Tipo de Cuenta de IN=Ingresos">
			</cfif>
			<cfif Arguments.OCIid EQ -1>
				<cf_errorCode	code = "51434" msg = "Se requiere un Concepto de Ingreso (OCIid) para obtener el Tipo de Cuenta de IN=Ingresos">
			</cfif>
		<cfelse>
			<cf_errorCode	code = "51435" msg = "Tipo de Cuenta solo puede ser: TR,CV,IN">
		</cfif>
		
		<!--- Obtiene la Mascara Financiera Correspondiente --->
		<cfif Arguments.tipo EQ "TR">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	OCCid, OCCcodigo, OCCdescripcion, #LvarCFmascara# as CFmascara
				  from OCconceptoCompra
				 where Ecodigo	= #session.Ecodigo#
				   and OCCid	= #Arguments.OCCid#
			</cfquery>
			<cfif rsSQL.OCCid EQ "">
				<cf_errorCode	code = "51436"
								msg  = "No existe Concepto de Compra ID=[@errorDat_1@]"
								errorDat_1="#Arguments.OCCid#"
				>
			<cfelseif rsSQL.CFmascara EQ "">
				<cf_errorCode	code = "51437"
								msg  = "El Concepto de Compra '@errorDat_1@ - @errorDat_2@' no tiene definido su Mascara Financiera de Producto en Tránsito"
								errorDat_1="#rsSQL.OCCcodigo#"
								errorDat_2="#rsSQL.OCCdescripcion#"
				>
			</cfif>
			<cfset LvarCFmascara = rsSQL.CFmascara>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	oc.OCcontrato, oc.OCtipoOD, 
						tv.OCVid, tv.OCVcodigo, OCVdescripcion, #LvarCFmascara# as CFmascara
				  from OCordenComercial oc
				  	left join OCtipoVenta tv
						on tv.OCVid = oc.OCVid
				 where oc.Ecodigo	= #session.Ecodigo#
				   and oc.OCid		= #Arguments.OCid#
			</cfquery>
			<cfif rsSQL.OCtipoOD NEQ "D">
				<cf_errorCode	code = "51438"
								msg  = "La Orden Comercial '@errorDat_1@' no es de Venta o Destino"
								errorDat_1="#rsSQL.OCcontrato#"
				>
			<cfelseif rsSQL.OCVid EQ "">
				<cf_errorCode	code = "51439"
								msg  = "La Orden Comercial '@errorDat_1@' no tiene definido el Tipo de Venta"
								errorDat_1="#rsSQL.OCcontrato#"
				>
			<cfelseif rsSQL.CFmascara EQ "">
				<cf_errorCode	code = "51440"
								msg  = "El Tipo de Venta '@errorDat_1@ - @errorDat_2@' no tiene definido su Mascara Financiera para Órdenes Comereciales en Tránsito"
								errorDat_1="#rsSQL.OCVcodigo#"
								errorDat_2="#rsSQL.OCVdescripcion#"
				>
			</cfif>
			<cfset LvarCFmascara = rsSQL.CFmascara>
		</cfif>

		<cfset LvarFormato	= LvarCFmascara>

		<!--- Complemento SNegocios --->
		<cfif find("S",LvarCFmascara)>
			<cfif Arguments.SNid EQ "-2">
				<cf_errorCode	code = "51441" msg = "El Complemento Financiero tipo 'S=Socio de Negocios' no se puede usar en la Máscara Financiera de 'CV=Costo de Ventas' para un tipo de Venta Directa de Almacen">
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select sn.SNid, SNcodigo, SNnombre, coalesce(#LvarCFcomplemento#, CFcomplementoTransito, cuentac) as CFcomplemento
				  from SNegocios sn
					left join OCcomplementoSNegocio csn
						on csn.SNid = sn.SNid
				 where sn.Ecodigo	= #session.Ecodigo#
				   and sn.SNid		= #Arguments.SNid#
			</cfquery>
			<cfif rsSQL.SNid EQ "">
				<cf_errorCode	code = "51442"
								msg  = "No existe Socio Negocio ID=[@errorDat_1@]"
								errorDat_1="#Arguments.SNid#"
				>
			<cfelseif trim(rsSQL.CFcomplemento) EQ "">
				<cf_errorCode	code = "51443"
								msg  = "El Socio de Negocios '@errorDat_1@ - @errorDat_2@' no tiene definido su Complemento Financiero de @errorDat_3@ para Órdenes Comerciales en transito"
								errorDat_1="#rsSQL.SNcodigo#"
								errorDat_2="#rsSQL.SNnombre#"
								errorDat_3="#LvarCFtipo#"
				>
			</cfif>
			<cfset LvarCFcomplementoSocio = rsSQL.CFcomplemento>

			<cfset LvarFormato	= OCAplicarMascara(LvarFormato, "S", LvarCFcomplementoSocio)>
		</cfif>

		<!--- Complemento Articulo --->
		<cfif find("A",LvarCFmascara)>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	coalesce(#LvarCFcomplemento#, CFcomplementoTransito) as CFcomplemento,
						a.Aid, Acodigo, Adescripcion
				  from Articulos a
					left join OCcomplementoArticulo ca
						on ca.Aid = a.Aid
				 where a.Ecodigo	= #session.Ecodigo#
				   and a.Aid		= #Arguments.Aid#
			</cfquery>
			<cfif rsSQL.Aid EQ "">
				<cf_errorCode	code = "51444"
								msg  = "No existe Articulo ID=[@errorDat_1@]"
								errorDat_1="#Arguments.Aid#"
				>
			<cfelseif rsSQL.CFcomplemento EQ "">
				<cf_errorCode	code = "51445"
								msg  = "El Articulo '@errorDat_1@ - @errorDat_2@' no tiene definido su Complemento Financiero de @errorDat_3@ para Órdenes Comerciales en transito"
								errorDat_1="#rsSQL.Acodigo#"
								errorDat_2="#rsSQL.Adescripcion#"
								errorDat_3="#LvarCFtipo#"
				>
			</cfif>
			<cfset LvarCFcomplementoArticulo = rsSQL.CFcomplemento>

			<cfset LvarFormato	= OCAplicarMascara(LvarFormato,   "A", LvarCFcomplementoArticulo)>
		</cfif>

		<!--- Complemento Concepto Compra --->
		<cfif find("C",LvarCFmascara)>
			<cfif Arguments.tipo EQ "CV">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select OCCid, OCCcodigo, OCCdescripcion, CFcomplementoCostoVenta
					  from OCconceptoCompra
					 where Ecodigo	= #session.Ecodigo#
					   and OCCid	= #Arguments.OCCid#
				</cfquery>
				<cfif rsSQL.OCCid EQ "">
					<cf_errorCode	code = "51436"
									msg  = "No existe Concepto de Compra ID=[@errorDat_1@]"
									errorDat_1="#Arguments.OCCid#"
					>
				<cfelseif rsSQL.CFcomplementoCostoVenta EQ "">
					<cf_errorCode	code = "51446"
									msg  = "El Concepto de Compra '@errorDat_1@ - @errorDat_2@' no tiene definido su Complemento Financiero de @errorDat_3@ para Órdenes Comerciales en transito"
									errorDat_1="#rsSQL.OCCcodigo#"
									errorDat_2="#rsSQL.OCCdescripcion#"
									errorDat_3="#LvarCFtipo#"
					>
				</cfif>
				<cfset LvarCFcomplementoCompra = rsSQL.CFcomplementoCostoVenta>
	
				<cfset LvarFormato	= OCAplicarMascara(LvarFormato, "C", LvarCFcomplementoCompra)>
			<cfelse>
				<cf_errorCode	code = "51447"
								msg  = "El Complemento Financiero tipo 'C=Concepto de Compras' sólo se puede usar en la Máscara Financiera de CV=Costo de Ventas y se está utilizando en la Máscara de @errorDat_1@=@errorDat_2@: '@errorDat_3@'"
								errorDat_1="#Arguments.tipo#"
								errorDat_2="#LvarCFtipo#"
								errorDat_3="#LvarFormato#"
				>
			</cfif>
		</cfif>
				
		<!--- Complemento Ingreso --->
		<cfif find("I",LvarCFmascara)>
			<cfif Arguments.tipo EQ "IN">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select OCIid, OCIcodigo, OCIdescripcion, CFcomplementoIngreso
					  from OCconceptoIngreso
					 where Ecodigo	= #session.Ecodigo#
					   and OCIid	= #Arguments.OCIid#
				</cfquery>
				<cfif rsSQL.OCIid EQ "">
					<cf_errorCode	code = "51436"
									msg  = "No existe Concepto de Compra ID=[@errorDat_1@]"
									errorDat_1="#Arguments.OCIid#"
					>
				<cfelseif rsSQL.CFcomplementoIngreso EQ "">
					<cf_errorCode	code = "51449"
									msg  = "El Concepto de Ingreso '@errorDat_1@ - @errorDat_2@' no tiene definido su Complemento Financiero de @errorDat_3@ para Órdenes Comerciales en transito"
									errorDat_1="#rsSQL.OCIcodigo#"
									errorDat_2="#rsSQL.OCIdescripcion#"
									errorDat_3="#LvarCFtipo#"
					>
				</cfif>
				<cfset LvarCFcomplementoIngreso = rsSQL.CFcomplementoIngreso>
	
				<cfset LvarFormato	= OCAplicarMascara(LvarFormato, "I", LvarCFcomplementoIngreso)>
			<cfelse>
				<cf_errorCode	code = "51450"
								msg  = "El Complemento Financiero tipo 'I=Ingreso' sólo se puede usar en la Máscara Financiera de IN=Ingreso y se está utilizando en la Máscara de @errorDat_1@=@errorDat_2@: '@errorDat_3@'"
								errorDat_1="#Arguments.tipo#"
								errorDat_2="#LvarCFtipo#"
								errorDat_3="#LvarFormato#"
				>
			</cfif>
		</cfif>
				
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#LvarFormato#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="false"/>
			<cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfthrow message="#LvarERROR#">
		</cfif>

		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnObtieneCFcuenta" returnvariable="rsCFinanciera">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#LvarFormato#"/>
		</cfinvoke>		

		<cfreturn rsCFinanciera.CFcuenta>
	</cffunction>

	<cffunction access="private" name="OCAplicarMascara"  output="false" returntype="string">
		<cfargument name="mascara" 		required="yes" type="string">
		<cfargument name="comodin" 		required="yes" type="string">
		<cfargument name="complemento" 	required="yes" type="string">

		<cfif NOT listFind("S,A,C,I",comodin)>
			<cf_errorCode	code = "51451" msg = "Las Máscaras Financieras de Órdenes de Comerciales de Tránsito sólo pueden tener de comodín: S,A,C">
		</cfif>

		<cfset LvarFormato = trim(mascara)>
		<cfset complemento = trim(complemento)>
		<cfset LvarContador = 0>
		<cfloop condition="#Find(comodin,LvarFormato)#">
			<cfset LvarContador = LvarContador + 1>
			<cfif len(Mid(complemento,LvarContador,1))>
				<cfset LvarFormato = replace(LvarFormato,comodin,Mid(complemento,LvarContador,1))>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif Find(comodin,LvarFormato)>
			<cf_errorCode	code = "51452"
							msg  = "El complemento '@errorDat_1@' tipo='@errorDat_2@' no es suficiente para completar la Máscara Financiera: @errorDat_3@"
							errorDat_1="#complemento#"
							errorDat_2="#comodin#"
							errorDat_3="#mascara#"
			>
		<cfelseif LvarContador GT 0 AND LvarContador LT len(complemento)>
			<cf_errorCode	code = "51453"
							msg  = "El complemento '@errorDat_1@' tipo='@errorDat_2@' es mayor para la Máscara Financiera: @errorDat_3@"
							errorDat_1="#complemento#"
							errorDat_2="#comodin#"
							errorDat_3="#mascara#"
			>
		</cfif>
		<cfreturn LvarFormato>
	</cffunction>
	
	<cffunction name="fn_rsOCC_Producto" returntype="query" access="public">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	OCCid,
					OCCcodigo,
					OCCdescripcion,
					CFcomplementoCostoVenta,
					CFmascaraTransito
			  from OCconceptoCompra
			 where Ecodigo		= #session.Ecodigo#
			   and OCCcodigo	= '00'
		</cfquery>
		
		<cfif rsSQL.OCCid EQ "">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert into OCconceptoCompra
					( Ecodigo, OCCcodigo, OCCdescripcion )
				values(#session.Ecodigo#,'00','PRODUCTO')
			</cfquery>
			
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	OCCid,
						OCCcodigo,
						OCCdescripcion,
						CFcomplementoCostoVenta,
						CFmascaraTransito
				  from OCconceptoCompra
				 where Ecodigo		= #session.Ecodigo#
				   and OCCcodigo	= '00'
			</cfquery>
		</cfif>
		
		<cfreturn rsSQL>
	</cffunction>

	<cffunction name="OC_CreaTablas" access="public">
		<cfargument name="conexion"		type="string" default="">

		<cfif Arguments.conexion EQ "">
			<cfset Arguments.conexion = #session.dsn#>
		</cfif>
		
		<!--- No cambiar name="OC_Detalle" mientras se use store procedure de CxP --->
		<cf_dbtemp name="OC_Det_V1" returnvariable="OC_Detalle" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="id"						type="numeric"      mandatory="yes" identity="yes">
			<cf_dbtempcol name="OCPTMid"				type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Tipo"					type="varchar(2)"   mandatory="yes">
			<cf_dbtempcol name="OCTid"					type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Aid"					type="numeric"      mandatory="yes">
			<cf_dbtempcol name="OCid"					type="numeric"      mandatory="no">
			<cf_dbtempcol name="SNid"					type="numeric"      mandatory="yes">
			<cf_dbtempcol name="OCCid"					type="numeric"      mandatory="yes">
			<cf_dbtempcol name="OCIid"					type="numeric"      mandatory="no">
			<cf_dbtempcol name="OCPTDmontoLocal"		type="money"		mandatory="yes">
			<cf_dbtempcol name="OCPTDmontoValuacion"	type="money"		mandatory="yes">

			<cf_dbtempcol name="OCid_O"					type="numeric"      mandatory="no">
			<cf_dbtempcol name="OCTTid"					type="numeric"      mandatory="no">
			<cf_dbtempcol name="OCid_D"					type="numeric"      mandatory="no">
			<cf_dbtempcol name="OCcontratos"			type="varchar(100)"  mandatory="no">

			<cf_dbtempcol name="CFcuenta"				type="numeric"     	mandatory="no">
			<cf_dbtempcol name="Ocodigo"				type="numeric"     	mandatory="no">
			<cf_dbtempcol name="Alm_Aid"				type="numeric"      mandatory="no">

			<cf_dbtempcol name="INTTIP"					type="char(1)"  	mandatory="no">
			<cf_dbtempcol name="OCPTDtipoMov"			type="char(1)"  	mandatory="no">
		</cf_dbtemp>
		
		<cf_dbtemp name="OC_IDs" returnvariable="OC_OCPTMids" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="OCPTMid"				type="numeric"      mandatory="yes">
		</cf_dbtemp>

		<cfset request.OC_DETALLE = OC_DETALLE>

		<cfreturn request.OC_DETALLE>
	</cffunction>

	<cffunction name="OC_Aplica_CxP" access="public">
		<cfargument name="Ecodigo"		type="numeric" required="yes">
		<cfargument name="IDdocumento"	type="numeric" required="yes">
		<cfargument name="Periodo"		type="numeric"	required="yes">
		<cfargument name="Mes"			type="numeric"	required="yes">

		<cfargument name="conexion"		type="string" 	required="yes">

		<cfif Arguments.conexion EQ "">
			<cfset Arguments.conexion = #session.dsn#>
		</cfif>
		
		<cfset OC_DETALLE 		= request.OC_DETALLE>
		<cfset CP_calculoLin	= request.CP_calculoLin>

		<cfquery datasource="#Arguments.Conexion#">
			delete from #OC_Detalle#
		</cfquery>
	
		<cfquery name="rsOC_Compras" datasource="#Arguments.Conexion#">
			select 	e.CPTcodigo, e.EDdocumento as Ddocumento, d.Linea as DDid,
					oct.OCTid, oct.OCTestado, d.Aid, octp.Aid as OC_Aid, d.OCid, sn.SNid, d.OCCid, cc.OCCcodigo, 
					oc.SNid as OC_SNid, oc.OCtipoOD, oc.OCtipoIC,

					t.CPTtipo,
					e.Ocodigo,
					
					e.EDfecha as OCPTMfecha, coalesce(e.EDtipocambioFecha, e.EDfecha) as OCPTMfechaTC,
					d.Ecodigo, 

					rtrim(a.Acodigo)						as Acodigo,
					rtrim(coalesce(d.Ucodigo,a.Ucodigo))	as Ucodigo_Mov,
					rtrim(a.Ucodigo) 						as Ucodigo, 

					d.DDcantidad as OCPTMcantidad,
					e.Mcodigo as McodigoOrigen, 

					c.costoLinea										as OCPTMmontoOrigen,
					c.costoLinea * e.EDtipocambio						as OCPTMmontoLocal, 
					c.costoLinea * e.EDtipocambio / e.EDtipocambioVal	as OCPTMmontoValuacion
			from DDocumentosCxP d
            	inner join #CP_calculoLin# c
                	on c.iddocumento 	= d.IDdocumento
                    and c.linea			= d.Linea
				inner join EDocumentosCxP e
					inner join SNegocios sn
						on sn.Ecodigo = e.Ecodigo
						and sn.SNcodigo = e.SNcodigo
					inner join CPTransacciones t
						 on t.Ecodigo	= e.Ecodigo
						and t.CPTcodigo	= e.CPTcodigo
					 on e.Ecodigo		= d.Ecodigo
					and e.IDdocumento	= d.IDdocumento
				left join Articulos a
					 on a.Aid = d.Aid
				left join OCordenComercial oc
					 on oc.OCid 			= d.OCid
				left join OCtransporte oct
					 on oct.OCTtipo			= d.OCTtipo
					and oct.OCTtransporte	= d.OCTtransporte
				left join OCtransporteProducto octp
					 on octp.OCTid			= oct.OCTid
					and octp.OCid			= d.OCid
					and octp.Aid			= d.Aid
				left join OCconceptoCompra cc
					 on cc.OCCid 			= d.OCCid
			where d.IDdocumento	= #Arguments.IDdocumento#
			  and d.Ecodigo		= #Arguments.Ecodigo#
			  and d.DDtipo		= 'O'
		</cfquery>

		<cfif rsOC_Compras.recordCount EQ 0>
			<cfreturn>
		</cfif>

		<cfloop query="rsOC_Compras">
			<cfif rsOC_Compras.Aid EQ "">
				<cf_errorCode	code = "51454" msg = "CxP de Producto en Orden Comercial de Transito: Se debe indicar Articulo">
			<cfelseif rsOC_Compras.OCTid EQ "">
				<cf_errorCode	code = "51455" msg = "CxP de Producto en Orden Comercial de Transito: Se debe indicar Transporte">
			<cfelseif rsOC_Compras.OCTestado NEQ "A">
				<cf_errorCode	code = "51456" msg = "CxP de Producto en Orden Comercial de Transito: Transporte indicado no es de Órdenes Comerciales o está cerrado">
			<cfelseif rsOC_Compras.OCid EQ "">
				<cf_errorCode	code = "51457" msg = "CxP de Producto en Orden Comercial de Transito: Se debe indicar Órden Comercial">
			<cfelseif rsOC_Compras.OCtipoOD NEQ "O" OR rsOC_Compras.OCtipoIC NEQ "C">
				<cf_errorCode	code = "51458" msg = "CxP de Producto en Orden Comercial de Transito: La Órden Comercial debe ser tipo Comercial Origen (Compra)">
			<cfelseif rsOC_Compras.OCCid EQ "">
				<cf_errorCode	code = "51459" msg = "CxP de Producto en Orden Comercial de Transito: Se debe indicar Concepto de Compra">
			<cfelseif rsOC_Compras.OC_Aid EQ "">
				<cf_errorCode	code = "51460" msg = "CxP de Producto en Orden Comercial de Transito: No se ha registrado el Producto en el Transporte">
			<cfelseif rsOC_Compras.OCCcodigo NEQ "00" AND rsOC_Compras.OCPTMcantidad NEQ 0>
				<cf_errorCode	code = "51461" msg = "CxP de Producto en Orden Comercial de Transito: Sólo se puede indicar Cantidad si Concepto de Compra es '00=Producto'">
			<cfelseif rsOC_Compras.OCCcodigo EQ "00" AND rsOC_Compras.SNid NEQ rsOC_Compras.OC_SNid>
				<cf_errorCode	code = "51462" msg = "CxP de Producto en Orden Comercial de Transito: La Órden Comercial debe ser del mismo proveedor del documento CxP cuando el Concepto de Compra es '00=Producto'">
			<cfelseif rsOC_Compras.OCCcodigo NEQ "00" AND rsOC_Compras.Ucodigo NEQ rsOC_Compras.Ucodigo_Mov>
				<cf_errorCode	code = "51463"
								msg  = "CxP de Producto en Orden Comercial de Transito: El movimiento está utilizando una Unidad de Medida '@errorDat_1@' que no corresponde al Articulo '@errorDat_2@', debe ser '@errorDat_3@'"
								errorDat_1="#rsOC_Compras.Ucodigo_Mov#"
								errorDat_2="#rsOC_Compras.Acodigo#"
								errorDat_3="#rsOC_Compras.Ucodigo#"
				>
			</cfif>
			
			<!--- Crédito a CxP = Compra = Entrada de Producto en Transito --->
			<cfif rsOC_Compras.CPTtipo EQ "C">
				<cfset OCPTMtipoES				= "E">
				<cfset LvarOCPTMcantidad		= rsOC_Compras.OCPTMcantidad>
				<cfset LvarOCPTMmontoOrigen		= rsOC_Compras.OCPTMmontoOrigen>
				<cfset LvarOCPTMmontoLocal		= rsOC_Compras.OCPTMmontoLocal>
				<cfset LvarOCPTMmontoValuacion	= rsOC_Compras.OCPTMmontoValuacion>
			<cfelse>
				<cfset OCPTMtipoES				= "S">
				<cfset LvarOCPTMcantidad		= -rsOC_Compras.OCPTMcantidad>
				<cfset LvarOCPTMmontoOrigen		= -rsOC_Compras.OCPTMmontoOrigen>
				<cfset LvarOCPTMmontoLocal		= -rsOC_Compras.OCPTMmontoLocal>
				<cfset LvarOCPTMmontoValuacion	= -rsOC_Compras.OCPTMmontoValuacion>
			</cfif>

			<!--- Verifica OCtransporteProducto --->
			<cfquery name="rsTP" datasource="#Arguments.Conexion#">
				select Aid, OCtipoOD
				  from OCtransporteProducto
				 where OCTid 	= #rsOC_Compras.OCTid#
				   and Aid	 	= #rsOC_Compras.Aid#
				   and OCtipoOD = 'O'
			</cfquery>
			<cfif rsTP.Aid EQ "">
				<cfquery name="rsTP" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_Compras.OCTid#
					   and Aid	 	= #rsOC_Compras.Aid#
				</cfquery>
				<cfif rsTP.Aid EQ "">
					<cf_errorCode	code = "51464" msg = "CxP de Producto en Orden Comercial de Transito: El Articulo no se ha registrado en el Transporte">
				</cfif>

				<cf_errorCode	code = "51465" msg = "CxP de Producto en Orden Comercial de Transito: El Articulo no está registrado como Origen en el Transporte">
			</cfif>

			<!--- 1. Actualiza Saldos: OCproductoTransito --->
			<cfquery name="rsPT" datasource="#Arguments.Conexion#">
				select OCTid, Aid, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal, OCPTsalidasCantidad, OCPTsalidasCostoTotal
				  from OCproductoTransito
				 where OCTid = #rsOC_Compras.OCTid#
				   and Aid	 = #rsOC_Compras.Aid#
			</cfquery>

			<cfif rsPT.OCTid EQ "">
				<cf_errorCode	code = "51466" msg = "CxP de Producto en Orden Comercial de Transito: No se ha registrado ninguna Entrada para el Articulo">
			</cfif>

			<cfset LvarOCPTentradasCantidadAnt	= rsPT.OCPTentradasCantidad>
			<cfset LvarOCPTentradasCantidad		= rsPT.OCPTentradasCantidad		+ LvarOCPTMcantidad>
			<cfset LvarOCPTentradasCostoTotal	= rsPT.OCPTentradasCostoTotal	+ LvarOCPTMmontoValuacion>
			<cfset LvarEntradaInicial			= (rsPT.OCPTentradasCantidad EQ 0)>
			<cfset LvarCambioCantidad			= (LvarOCPTMcantidad NEQ 0)>

			<cfif rsPT.OCPTtransformado EQ 1>
				<cf_errorCode	code = "51467" msg = "CxP de Producto en Orden Comercial de Transito: No se puede registrar Compras de un Producto Transformado">
			<cfelseif LvarOCPTMcantidad EQ 0 AND LvarEntradaInicial>
				<cfif rsOC_Compras.OCCcodigo EQ "00">
					<cf_errorCode	code = "51468" msg = "CxP de Producto en Orden Comercial de Transito: No se ha registrado ninguna Entrada para el Articulo, debe indicar cantidad para el Concepto de Compra '00=Producto'">
				<cfelse>
				<!---
					<cf_errorCode	code = "51469" msg = "CxP de Producto en Orden Comercial de Transito: No se ha registrado ninguna Entrada para el Articulo, la primera compra debe ser Concepto de Compra '00=Producto'">
				--->
				</cfif>
			</cfif>

			<cfquery datasource="#Arguments.Conexion#">
				update OCproductoTransito
				   set OCPTentradasCantidad 	= #LvarOCPTentradasCantidad#, 
					   OCPTentradasCostoTotal 	= #LvarOCPTentradasCostoTotal#
				 where OCTid = #rsOC_Compras.OCTid#
				   and Aid	 = #rsOC_Compras.Aid#
			</cfquery>

			<!--- Registra Movimiento: OCPTmovimientos de Compras --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into OCPTmovimientos
					(
						OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
						OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES, 
						Ocodigo, Alm_Aid,
						Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
						OCPTMfecha, OCPTMfechaTC,
						Ecodigo, Ucodigo, OCPTMcantidad,
						McodigoOrigen, OCPTMmontoOrigen, OCPTMmontoLocal, OCPTMmontoValuacion,
						BMUsucodigo
					)
				values (
						#rsOC_Compras.OCTid#, #rsOC_Compras.Aid#, #rsOC_Compras.OCid#, #rsOC_Compras.SNid#, #rsOC_Compras.OCCid#, null, null,
						'O', 'C',	<!--- Origen + Comercial = Compras --->
						'#OCPTMtipoES#',
						#rsOC_Compras.Ocodigo#, null,
						'CPFC', '#rsOC_Compras.Ddocumento#', '#rsOC_Compras.CPTcodigo#', #rsOC_Compras.DDid#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_Compras.OCPTMfecha#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_Compras.OCPTMfechaTC#">,
						#rsOC_Compras.Ecodigo#, '#rsOC_Compras.Ucodigo#', #LvarOCPTMcantidad#,
						#rsOC_Compras.McodigoOrigen#, #LvarOCPTMmontoOrigen#, #LvarOCPTMmontoLocal#, #LvarOCPTMmontoValuacion#,
						#session.Usucodigo#
					)
				<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">

			<!--- GENERA DETALLES CONTABLES DEL MOVIMIENTO --->
			<cfif LvarCambioCantidad>
				<cfset sbAjusta_OrigenesAnteriores (LvarOCPTMid, rsOC_Compras.OCTid, rsOC_Compras.Aid, Arguments.conexion)>
			</cfif>

			<cfset sbDistribuyeOrigenesEnDestinos (false, "MOVs_ORI.OCPTMid = #LvarOCPTMid#", LvarOCPTentradasCantidad, 0, Arguments.Conexion)>
		</cfloop>

		<!--- Moneda de Valuación --->
		<cfset LvarMcodigoValuacion = fnLeeParametro(441,"Moneda de Valuacion de Inventarios")>

		<!--- OC Destino Entradas a Inventario: Ajusta Costo Almacen con cantidad = 0 --->
		<cfset OCDI_PosteoLin (Arguments.Ecodigo, rsOC_Compras.Ddocumento, "CxP-OCDI", rsOC_Compras.OCPTMfechaTC, 0, 0, LvarMcodigoValuacion, Arguments.conexion)>

		<!--- 5. Generar detalles --->
		<cfset sbGenerarDetalles(Arguments.Periodo, Arguments.Mes, Arguments.conexion)>
	</cffunction>

	<!--- Origen Salida de Inventarios --->
	<cffunction name="OC_Aplica_OCOI" access="public">
		
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="OCIid"			type="numeric"	required="yes">
		<cfargument name="VerAsiento"		type="boolean"	required="yes">

		<cfargument name="conexion"			type="string" 	required="yes">

		<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")>
		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
	
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(Arguments.Conexion)>
		<cfset OC_DETALLE 	= OC_CreaTablas(Arguments.Conexion)>

		<!--- Socio de negocio default interno, representa a la propia empresa --->
		<cfset LvarSNidDefault = fnLeeParametro(444,"Socio de Negocios default (propia Empresa) para Movs Origenes diferentes a CxP")>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	SNid
			  from OCcomplementoSNegocio 
			 where SNid = #LvarSNidDefault#
		</cfquery>
		<cfif rsSQL.SNid EQ "">
			<cf_errorCode	code = "51470" msg = "No se ha definido los complementos Financieros para el Socio de Negocio Default definido en parámetros">
		</cfif>

		<!--- Concepto de Costo 00 = Producto --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	OCCid
			  from OCconceptoCompra
			 where Ecodigo	 = #Arguments.Ecodigo#
			   and OCCcodigo = '00'
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cf_errorCode	code = "51428" msg = "No se ha definido el Concepto de Compra '00=PRODUCTO EN TRANSITO'">
		</cfif>
		<cfset LvarOCCid_00 = rsSQL.OCCid>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			delete from OCinventarioProducto
			 where OCIid	= #Arguments.OCIid#
			   and OCIcantidad = 0
		</cfquery>

		<cftransaction>
			<!--- Período de Auxiliares --->
			<cfset LvarAnoAux = fnLeeParametro(50,"Período de Auxiliares")>
			<cfset LvarMesAux = fnLeeParametro(60,"Mes de Auxiliares")>
	
			<cfquery name="rsOC_OI" datasource="#Arguments.Conexion#">
				select 	e.Ecodigo, e.OCIid, e.OCid, e.OCInumero, e.OCIfecha,
						e.OCItipoOD, e.Alm_Aid, alm.Almcodigo, alm.Ocodigo, alm.Dcodigo, 
						oc.OCcontrato, oc.OCtipoOD, oc.OCtipoIC
				  from OCinventario e
					inner join Almacen alm
						 on alm.Aid = e.Alm_Aid
					left join OCordenComercial oc
						 on oc.OCid = e.OCid
				  where e.Ecodigo 	= #Arguments.Ecodigo#
					and e.OCIid		= #Arguments.OCIid#
			</cfquery>
			<cfif rsOC_OI.OCIid EQ "">
				<cf_errorCode	code = "51471"
								msg  = "OC_OI Salidas de Inventario: Documento ID=@errorDat_1@ no existe"
								errorDat_1="#Arguments.OCIid#"
				>
			<cfelseif rsOC_OI.OCItipoOD NEQ "O">
				<cf_errorCode	code = "51472"
								msg  = "OC_OI Salidas de Inventario: Documento @errorDat_1@ no es tipo Origen Salida de Inventario"
								errorDat_1="#rsOC_OI.OCInumero#"
				>
			<cfelseif rsOC_OI.Alm_Aid EQ "">
				<cf_errorCode	code = "51473"
								msg  = "OC_OI Salidas de Inventario: Documento @errorDat_1@ no tiene Almacén de Salida"
								errorDat_1="#rsOC_OI.OCInumero#"
				>
			<cfelseif rsOC_OI.OCcontrato EQ "">
				<cf_errorCode	code = "51474"
								msg  = "OC_OI Salidas de Inventario: Documento @errorDat_1@ no tiene Orden Comercial Origen"
								errorDat_1="#rsOC_OI.OCInumero#"
				>
			<cfelseif rsOC_OI.OCtipoOD NEQ "O" OR rsOC_OI.OCtipoIC NEQ "I">
				<cf_errorCode	code = "51475"
								msg  = "OC_OI Salidas de Inventario: Documento @errorDat_1@ tiene la Orden Comercial @errorDat_2@ que no es tipo Origen Inventario"
								errorDat_1="#rsOC_OI.OCInumero#"
								errorDat_2="#rsOC_OI.OCcontrato#"
				>
			</cfif>
			
			<cfset LvarOCid = rsOC_OI.OCid>
	
			<!--- Moneda de Valuación --->
			<cfinvoke 
				component		= "sif.Componentes.IN_PosteoLin" 
				method			= "IN_MonedaValuacion"  
				returnvariable	= "LvarCOSTOS"
	
				Ecodigo			= "#Arguments.Ecodigo#"
				tcFecha			= "#rsOC_OI.OCIfecha#"
	
				Conexion		= "#Arguments.Conexion#"
			/>
	
			<cfset LvarMcodigoValuacion		= LvarCostos.VALUACION.Mcodigo>
			<cfset LvarTipoCambioValuacion	= LvarCostos.VALUACION.TC>
	
			<cfquery name="rsOC_ORI" datasource="#Arguments.Conexion#">
				select 	
						e.OCid, e.OCInumero, 
						e.Ecodigo, 
						d.OCTid, d.Aid, d.OCIcantidad, 
						a.Acodigo, a.Adescripcion, a.Ucodigo,
						t.OCTtipo, t.OCTtransporte, t.OCTestado, 
						e.Alm_Aid, alm.Almcodigo, alm.Ocodigo
					from OCinventario e
						inner join OCinventarioProducto d
							 on d.OCIid=e.OCIid
						inner join OCtransporte t
							 on t.OCTid = d.OCTid
						inner join Articulos a
							 on a.Aid = d.Aid
						inner join Almacen alm
							 on alm.Aid = e.Alm_Aid
				  where e.OCIid	= #Arguments.OCIid#
			</cfquery>
	
			<cfloop query="rsOC_ORI">
				<!--- Verifica OCtransporteProducto --->
				<cfquery name="rsTP" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_ORI.OCTid#
					   and Aid	 	= #rsOC_ORI.Aid#
					   and OCtipoOD = 'O'
				</cfquery>
				<cfif rsTP.Aid EQ "">
					<cfquery name="rsTP" datasource="#Arguments.Conexion#">
						select Aid, OCtipoOD
						  from OCtransporteProducto
						 where OCTid 	= #rsOC_ORI.OCTid#
						   and Aid	 	= #rsOC_ORI.Aid#
					</cfquery>
					<cfif rsTP.Aid EQ "">
						<cf_errorCode	code = "51476"
										msg  = "OC_OI Salidas de Inventario: Articulo @errorDat_1@ no se ha registrado en el Transporte @errorDat_2@-@errorDat_3@"
										errorDat_1="#rsOC_ORI.Acodigo#"
										errorDat_2="#rsOC_ORI.OCTtipo#"
										errorDat_3="#rsOC_ORI.OCTtransporte#"
						>
					</cfif>
	
					<cf_errorCode	code = "51477"
									msg  = "OC_OI Salidas de Inventario: Articulo @errorDat_1@ no está registrado como Origen en el Transporte @errorDat_2@-@errorDat_3@"
									errorDat_1="#rsOC_ORI.Acodigo#"
									errorDat_2="#rsOC_ORI.OCTtipo#"
									errorDat_3="#rsOC_ORI.OCTtransporte#"
					>
				</cfif>
	
				<!--- Existencias Aid en Alm_Aid --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select 	Eexistencia,
							case 
								when Eexistencia = 0 
									then coalesce(Ecostou, 0.00) 
									else coalesce(Ecostototal / Eexistencia,0) 
							end CostoUnitario
					  from Existencias 
					 where Aid		= #rsOC_ORI.Aid#
					   and Alm_Aid	= #rsOC_ORI.Alm_Aid#
					   and Ecodigo	= #Arguments.Ecodigo#
				</cfquery>

				<!--- Actualiza Saldos: OCproductoTransito --->
				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select OCTid, Aid, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal, OCPTsalidasCantidad, OCPTsalidasCostoTotal
					  from OCproductoTransito
					 where OCTid = #rsOC_ORI.OCTid#
					   and Aid	 = #rsOC_ORI.Aid#
				</cfquery>
				
				<cfif rsOC_ORI.OCTestado NEQ "A">
					<cf_errorCode	code = "51478"
									msg  = "OC_OI Salidas de Inventario: No se permiten movimientos al Transporte @errorDat_1@-@errorDat_2@ porque no está Abierto"
									errorDat_1="#rsOC_ORI.OCTtipo#"
									errorDat_2="#rsOC_ORI.OCTtransporte#"
					>
				<cfelseif rsOC_ORI.OCIcantidad LT 0>
					<cf_errorCode	code = "51479" msg = "OC_OI Salidas de Inventario: No se permite una Salida de Inventario negativa">
				<cfelseif rsOC_ORI.OCIcantidad LT 0>
					<cf_errorCode	code = "51480" msg = "OC_OI Salidas de Inventario: No se permite una Salida de Inventario sin cantidad">
				<cfelseif rsPT.OCPTtransformado EQ 1>
					<cf_errorCode	code = "51481"
									msg  = "OC_OI Salidas de Inventario: No se puede registrar Origen Inventario de un Producto Transformado @errorDat_1@"
									errorDat_1="#rsOC_ORI.Acodigo#"
					>
				<cfelseif rsSQL.recordCount EQ 0>
					<cf_errorCode	code = "51482"
									msg  = "OC_OI Salidas de Inventario: El Articulo @errorDat_1@ no está Registrado en el Almacén @errorDat_2@"
									errorDat_1="#rsOC_ORI.Acodigo#"
									errorDat_2="#rsOC_ORI.Almcodigo#"
					>
				<cfelseif rsSQL.Eexistencia EQ 0>
					<cf_errorCode	code = "51483"
									msg  = "OC_OI Salidas de Inventario: Articulo @errorDat_1@ no tiene Existencias en el Almacén @errorDat_2@"
									errorDat_1="#rsOC_ORI.Acodigo#"
									errorDat_2="#rsOC_ORI.Almcodigo#"
					>
				<cfelseif rsOC_ORI.OCIcantidad GT rsSQL.Eexistencia>
					<cf_errorCode	code = "51484" msg = "OC_OI Salidas de Inventario: No se permite sacar de Inventario más cantidad que la existente en el Almacén">
				</cfif>
	
				<cfset LvarOCPTMtipoES			= "E">
				<cfset LvarOCPTMcantidad		= rsOC_ORI.OCIcantidad>
				<cfset LvarOCPTcostoUnitario	= rsSQL.CostoUnitario>

				<cfset LvarOCPTMmontoValuacion	= LvarOCPTMcantidad*LvarOCPTcostoUnitario>
				<cfset LvarOCPTMmontoOrigen		= LvarOCPTMmontoValuacion>
				<cfset LvarOCPTMmontoLocal		= LvarOCPTMmontoValuacion * LvarTipoCambioValuacion>

				<cfset LvarOCPTentradasCantidadAnt	= rsPT.OCPTentradasCantidad>
				<cfset LvarOCPTentradasCantidad		= rsPT.OCPTentradasCantidad		+ LvarOCPTMcantidad>
				<cfset LvarOCPTentradasCostoTotal	= rsPT.OCPTentradasCostoTotal	+ LvarOCPTMmontoValuacion>
				<cfset LvarEntradaInicial			= (rsPT.OCPTentradasCantidad EQ 0)>
				<cfset LvarCambioCantidad			= (LvarOCPTMcantidad NEQ 0)>
	
				<cfquery datasource="#Arguments.Conexion#">
					update OCproductoTransito
					   set OCPTentradasCantidad 	= #LvarOCPTentradasCantidad#, 
						   OCPTentradasCostoTotal 	= #LvarOCPTentradasCostoTotal#
					 where OCTid = #rsOC_ORI.OCTid#
					   and Aid	 = #rsOC_ORI.Aid#
				</cfquery>
	
				<!--- Costo en OCinventarioProducto --->
				<cfquery datasource="#Arguments.Conexion#">
					update OCinventarioProducto
					   set OCIcostoValuacion = #abs(LvarOCPTMmontoValuacion)#
					 where OCIid = #Arguments.OCIid#
					   and OCTid = #rsOC_ORI.OCTid#
					   and Aid	 = #rsOC_ORI.Aid#
				</cfquery>
	
				<!--- Registra Movimiento: OCPTmovimientos de Origen Salida de Inventarios --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into OCPTmovimientos
						(
							OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
							OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES, 
							Ocodigo, Alm_Aid,
							Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
							OCPTMfecha, OCPTMfechaTC,
							Ecodigo, Ucodigo, OCPTMcantidad,
							McodigoOrigen, OCPTMmontoOrigen, OCPTMmontoLocal, OCPTMmontoValuacion,
							BMUsucodigo
						)
					values (
							#rsOC_ORI.OCTid#, #rsOC_ORI.Aid#, #rsOC_ORI.OCid#, #LvarSNidDefault#, #LvarOCCid_00#, null, null,
							'O', 'I',	<!--- Origen + Inventarios = Transporte de Almacen --->
							'E',
							#rsOC_ORI.Ocodigo#, #rsOC_ORI.Alm_Aid#,		<!--- Almacen Origen --->
							'OCOI', '#rsOC_ORI.OCInumero#', null, #rsOC_OI.recordCount#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_OI.OCIfecha#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_OI.OCIfecha#">,
							#rsOC_OI.Ecodigo#, '#rsOC_ORI.Ucodigo#', #LvarOCPTMcantidad#,
							#LvarMcodigoValuacion#, #LvarOCPTMmontoOrigen#, #LvarOCPTMmontoLocal#, #LvarOCPTMmontoValuacion#, 
							#session.Usucodigo#
						)
					<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">
	
				<!--- Actualiza Inventarios --->
				<cfset LvarObtenerCosto	= true>
				<cfset LvarCostoOrigen	= 0>
				<cfset LvarCostoLocal	= 0>

				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Dcodigo, Ocodigo
					  from Almacen
					 where Aid = #rsOC_ORI.Alm_Aid#
				</cfquery>
				
				<cfinvoke 
					component		="sif.Componentes.IN_PosteoLin" 
					method			="IN_PosteoLin"  
					returnvariable	="LvarCOSTOS"

					Aid				= "#rsOC_ORI.Aid#"
					Alm_Aid			= "#rsOC_ORI.Alm_Aid#"
					Tipo_Mov		= "S"

					Tipo_ES			= "S"
					Cantidad		= "#abs(LvarOCPTMcantidad)#"

					ObtenerCosto	= "#LvarObtenerCosto#"
					CostoOrigen		= "#LvarCostoOrigen#"
					CostoLocal		= "#LvarCostoLocal#"

					tcValuacion		= "#LvarTipoCambioValuacion#"
					
					Dcodigo			= "#rsSQL.Dcodigo#"
					Ocodigo			= "#rsSQL.Ocodigo#"
					Documento		= "#rsOC_ORI.OCInumero#"
					Referencia		= ""
					FechaDoc		= "#rsOC_OI.OCIfecha#"
					Conexion		= "#Arguments.Conexion#"
					Ecodigo			= "#Arguments.Ecodigo#"
					transaccionactiva="true"
				/>

				<cfset LvarOCPTMmontoValuacion		= -abs(LvarCOSTOS.VALUACION.Costo)>
				<cfset LvarOCPTMmontoOrigen			= -abs(LvarCOSTOS.VALUACION.Costo)>
				<cfset LvarOCPTMmontoLocal			= -abs(LvarCOSTOS.LOCAL.Costo)>

				<!--- Cuenta de Inventario --->
				<cfset rsExistencias = fn_rsExistencias(Arguments.Ecodigo, rsOC_ORI.Aid, rsOC_ORI.Alm_Aid, Arguments.Conexion)>

				<!--- GENERA DETALLES CONTABLES DEL MOVIMIENTO --->

				<!--- Crédito Cuenta Inventario: credito * -(-abs(LvarCOSTOS.VALUACION.Costo)) es normal positivo ---> 
				<!--- No se guarda en el detalle porque no se toma en cuenta para ningun ajuste --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #request.INTARC# ( 
							INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, 
							Ccuenta, CFcuenta, Ocodigo,
							Mcodigo, INTMOE, INTCAM, INTMON
						)
					values (
							'OCOI',	1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="OCOI:#rsOC_ORI.OCInumero#">,
							'OC:#rsOC_OI.OCcontrato#',

							'C',
							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="OC-D.#rsOC_OI.OCcontrato#,INVENTARIO ALMACEN #rsExistencias.Almcodigo#,ART.#rsExistencias.Acodigo#: #rsExistencias.Adescripcion#">,
							'#dateFormat(rsOC_OI.OCIfecha,"YYYYMMDD")#',
							#LvarAnoAux#,
							#LvarMesAux#,

							0,
							#rsExistencias.CFcuenta#,
							#rsExistencias.Ocodigo#,
			
							#LvarMcodigoValuacion#,
							#-LvarOCPTMmontoValuacion#,
							#LvarCOSTOS.VALUACION.TC#,
							#-LvarOCPTMmontoLocal#
						)
				</cfquery>

				<cfif LvarCambioCantidad>
					<cfset sbAjusta_OrigenesAnteriores (LvarOCPTMid, rsOC_ORI.OCTid, rsOC_ORI.Aid, Arguments.conexion)>
				</cfif>
	
				<cfset sbDistribuyeOrigenesEnDestinos (false, "MOVs_ORI.OCPTMid = #LvarOCPTMid#", LvarOCPTentradasCantidad, 0, Arguments.Conexion)>
			</cfloop>
	
			<!--- OC Destino Entradas a Inventario: Ajusta Costo Almacen con cantidad = 0 --->
			<cfset OCDI_PosteoLin (Arguments.Ecodigo, rsOC_ORI.OCInumero, "OCOI-OCDI", rsOC_OI.OCIfecha, 0, 0, LvarMcodigoValuacion, Arguments.conexion)>
	
			<!--- Generar detalles --->
			<cfset sbGenerarDetalles(LvarAnoAux, LvarMesAux, Arguments.conexion)>
			<cfset sbGenerarINTARC('OCOI', rsOC_OI.OCInumero, "OCOI", LvarAnoAux, LvarMesAux, Arguments.Conexion, rsOC_OI.Almcodigo)>

			<!--- Genera el Asiento Contable --->
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "BalanceoMonedaOficina"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion"		value="#Arguments.conexion#"/>
			</cfinvoke>
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "GeneraAsiento" 
						returnvariable	= "LvarIDcontable"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
				<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
				<cfinvokeargument name="Efecha"			value="#rsOC_OI.OCIfecha#"/>
				<cfinvokeargument name="Oorigen"		value="OCOI"/>
				<cfinvokeargument name="Edocbase"		value="#rsOC_OI.OCInumero#"/>
				<cfinvokeargument name="Ereferencia"	value=""/>						
				<cfinvokeargument name="Edescripcion"	value="Ordenes Comerciales Destino Inventario: Recepcion de Tránsito"/>
				<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
			</cfinvoke>

			<!--- Actualizar el IDcontable del Kardex --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update Kardex 
				   set IDcontable = #LvarIDcontable#
				where Kid IN
					(
						select Kid
						   from #IDKARDEX#
					)
			</cfquery>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				update OCinventario
				   set OCIfechaAplicacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				     , UsucodigoAplicacion = #session.Usucodigo#
				where OCIid		= #Arguments.OCIid#
			</cfquery>
		</cftransaction>
	</cffunction>

	<!--- Origen Otros Costos --->
	<cffunction name="OC_Aplica_OCOO" access="public">
		
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="OCOid"			type="numeric"	required="yes">
		<cfargument name="VerAsiento"		type="boolean"	required="yes">

		<cfargument name="conexion"			type="string" 	required="yes">

		<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")>
		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
	
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(Arguments.Conexion)>
		<cfset OC_DETALLE 	= OC_CreaTablas(Arguments.Conexion)>

		<!--- Socio de negocio default interno, representa a la propia empresa --->
		<cfset LvarSNidDefault = fnLeeParametro(444,"Socio de Negocios default (propia Empresa) para Movs Origenes diferentes a CxP")>

		<cftransaction>
			<!--- Período de Auxiliares --->
			<cfset LvarAnoAux = fnLeeParametro(50,"Período de Auxiliares")>
			<cfset LvarMesAux = fnLeeParametro(60,"Mes de Auxiliares")>
	
			<cfquery name="rsOC_OO" datasource="#Arguments.Conexion#">
				select 	e.Ecodigo, e.OCOid, e.OCOnumero, e.OCOfecha,
						e.OCOtipoOD, 
						'OC.Otros Costos ' +  OCOobservaciones as OCOobservaciones,
						e.CFcuenta,
						e.SNid,
						e.Mcodigo, (select Miso4217 from Monedas where Mcodigo = e.Mcodigo) as Moneda,
						e.Ocodigo,
						OCOtotalOrigen, OCOtipoCambio, OCOtipoCambioVal,
						(select round(sum(OCODmontoOrigen),2) from OCotrosDetalle where OCOid = e.OCOid) as OCOtotalLineas
				  from OCotros e
				  where e.Ecodigo 	= #Arguments.Ecodigo#
					and e.OCOid		= #Arguments.OCOid#
			</cfquery>
			<cfif rsOC_OO.OCOid EQ "">
				<cf_errorCode	code = "51485"
								msg  = "OC_OO Origen Otros Costos: Documento ID=@errorDat_1@ no existe"
								errorDat_1="#Arguments.OCOid#"
				>
			<cfelseif rsOC_OO.OCOtipoOD NEQ "O">
				<cf_errorCode	code = "51486"
								msg  = "OC_OO Origen Otros Costos: Documento @errorDat_1@ no es tipo Origen Otros Costos"
								errorDat_1="#rsOC_OO.OCOnumero#"
				>
			<cfelseif rsOC_OO.OCOtotalOrigen NEQ rsOC_OO.OCOtotalLineas>
				<cf_errorCode	code = "51487"
								msg  = "OC_OO Origen Otros Costos: El total del Documento @errorDat_1@ @errorDat_2@ @errorDat_3@ no corresponde al Total de las Líneas @errorDat_4@ @errorDat_5@"
								errorDat_1="#rsOC_OO.OCOnumero#"
								errorDat_2="#rsOC_OO.Moneda#"
								errorDat_3="#numberFormat(rsOC_OO.OCOtotalOrigen,",9.99")#"
								errorDat_4="#rsOC_OO.Moneda#"
								errorDat_5="#numberFormat(rsOC_OO.OCOtotalLineas,",9.99")#"
				>
			</cfif>
			
			<!--- Moneda de Valuación --->
			<cfinvoke 
				component		= "sif.Componentes.IN_PosteoLin" 
				method			= "IN_MonedaValuacion"  
				returnvariable	= "LvarCOSTOS"
	
				Ecodigo			= "#Arguments.Ecodigo#"
				tcFecha			= "#rsOC_OO.OCOfecha#"
	
				Conexion		= "#Arguments.Conexion#"
			/>
	
			<cfset LvarMcodigoValuacion		= LvarCostos.VALUACION.Mcodigo>
			<cfset LvarTipoCambioValuacion	= LvarCostos.VALUACION.TC>

			<cfquery name="rsOC_ORI" datasource="#Arguments.Conexion#">
				select 	
						e.OCOnumero, 
						e.Ecodigo, 
						d.OCTid,	t.OCTtipo, t.OCTtransporte, t.OCTestado,
						d.Aid,		a.Acodigo, a.Adescripcion, a.Ucodigo,
						e.SNid,
						d.OCCid_O,	occ.OCCcodigo,
						d.OCODmontoOrigen, e.OCOtipoCambio
					from OCotros e
						inner join OCotrosDetalle d
							 on d.OCOid=e.OCOid
						inner join OCtransporte t
							 on t.OCTid = d.OCTid
						inner join Articulos a
							 on a.Aid = d.Aid
						inner join OCconceptoCompra occ
							 on occ.OCCid = d.OCCid_O
				  where e.OCOid		= #Arguments.OCOid#
			</cfquery>
	
			<!--- Crédito Cuenta a Acreditar: credito * -(-abs(LvarCOSTOS.VALUACION.Costo)) es normal positivo ---> 
			<!--- No se guarda en el detalle porque no se toma en cuenta para ningun ajuste --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.INTARC# ( 
						INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, 
						Ccuenta, CFcuenta, Ocodigo,
						Mcodigo, INTMOE, INTCAM, INTMON
					)
				values (
						'OCOO',	1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOC_OO.OCOnumero#">,
						'OCOO',

						'C',
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(rsOC_OO.OCOobservaciones, 1, 40)#">,
						'#dateFormat(rsOC_OO.OCOfecha,"YYYYMMDD")#',
						#LvarAnoAux#,
						#LvarMesAux#,

						0,
						#rsOC_OO.CFcuenta#,
						#rsOC_OO.Ocodigo#,
		
						#rsOC_OO.Mcodigo#,
						#rsOC_OO.OCOtotalOrigen#,
						#rsOC_OO.OCOtipoCambio#,
						#rsOC_OO.OCOtotalOrigen*rsOC_OO.OCOtipoCambio#
					)
			</cfquery>

			<cfloop query="rsOC_ORI">
				<!--- Verifica OCtransporteProducto --->
				<cfquery name="rsTP" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_ORI.OCTid#
					   and Aid	 	= #rsOC_ORI.Aid#
					   and OCtipoOD = 'O'
				</cfquery>
				<cfif rsTP.Aid EQ "">
					<cfquery name="rsTP" datasource="#Arguments.Conexion#">
						select Aid, OCtipoOD
						  from OCtransporteProducto
						 where OCTid 	= #rsOC_ORI.OCTid#
						   and Aid	 	= #rsOC_ORI.Aid#
					</cfquery>
					<cfif rsTP.Aid EQ "">
						<cf_errorCode	code = "51488"
										msg  = "OC_OO Origen Otros Costos: Articulo @errorDat_1@ no se ha registrado en el Transporte @errorDat_2@-@errorDat_3@"
										errorDat_1="#rsOC_ORI.Acodigo#"
										errorDat_2="#rsOC_ORI.OCTtipo#"
										errorDat_3="#rsOC_ORI.OCTtransporte#"
						>
					</cfif>
	
					<cf_errorCode	code = "51489"
									msg  = "OC_OO Origen Otros Costos: Articulo @errorDat_1@ no está registrado como Origen en el Transporte @errorDat_2@-@errorDat_3@"
									errorDat_1="#rsOC_ORI.Acodigo#"
									errorDat_2="#rsOC_ORI.OCTtipo#"
									errorDat_3="#rsOC_ORI.OCTtransporte#"
					>
				</cfif>
	
				<!--- Actualiza Saldos: OCproductoTransito --->
				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select OCTid, Aid, OCPTtransformado, OCPTentradasCantidad, OCPTentradasCostoTotal, OCPTsalidasCantidad, OCPTsalidasCostoTotal
					  from OCproductoTransito
					 where OCTid = #rsOC_ORI.OCTid#
					   and Aid	 = #rsOC_ORI.Aid#
				</cfquery>
	
				<cfif rsOC_ORI.OCTestado NEQ "A">
					<cf_errorCode	code = "51490"
									msg  = "OC_OO Origen Otros Costos: No se permiten movimientos al Transporte @errorDat_1@-@errorDat_2@ porque no está Abierto"
									errorDat_1="#rsOC_ORI.OCTtipo#"
									errorDat_2="#rsOC_ORI.OCTtransporte#"
					>
				<cfelseif rsOC_ORI.OCODmontoOrigen LT 0>
					<cf_errorCode	code = "51491" msg = "OC_OO Origen Otros Costos: No se permite Otros Costos negativo">
				<cfelseif rsOC_ORI.OCODmontoOrigen LT 0>
					<cf_errorCode	code = "51492" msg = "OC_OO Origen Otros Costos: No se permite Otros Costos sin monto">
				<cfelseif rsPT.OCPTtransformado EQ 1>
					<cf_errorCode	code = "51493"
									msg  = "OC_OO Origen Otros Costos: No se permite registrar Otros Costos de un Producto Transformado @errorDat_1@"
									errorDat_1="#rsOC_ORI.Acodigo#"
					>
				<cfelseif rsOC_ORI.OCCcodigo EQ "00">
					<cf_errorCode	code = "51494" msg = "OC_OO Origen Otros Costos: No se permite registrar Otros Costos para el Concepto 00=Producto">
				</cfif>
	
				<cfset LvarOCPTMtipoES			= "E">
				<cfset LvarOCPTMcantidad		= 0>

				<cfset LvarOCPTMmontoOrigen		= rsOC_ORI.OCODmontoOrigen>
				<cfset LvarOCPTMmontoLocal		= rsOC_ORI.OCODmontoOrigen * rsOC_ORI.OCOtipoCambio>
				<cfset LvarOCPTMmontoValuacion	= LvarOCPTMmontoLocal * LvarTipoCambioValuacion>

				<cfset LvarOCPTentradasCostoTotal	= rsPT.OCPTentradasCostoTotal	+ LvarOCPTMmontoValuacion>
	
				<cfquery datasource="#Arguments.Conexion#">
					update OCproductoTransito
					   set OCPTentradasCostoTotal 	= #LvarOCPTentradasCostoTotal#
					 where OCTid = #rsOC_ORI.OCTid#
					   and Aid	 = #rsOC_ORI.Aid#
				</cfquery>
	
				<!--- Registra Movimiento: OCPTmovimientos de Otros Costos --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into OCPTmovimientos
						(
							OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
							OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES, 
							Ocodigo, Alm_Aid,
							Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
							OCPTMfecha, OCPTMfechaTC,
							Ecodigo, Ucodigo, OCPTMcantidad,
							McodigoOrigen, OCPTMmontoOrigen, OCPTMmontoLocal, 
							OCPTMmontoValuacion, OCPTMtipoCambioVal,
							BMUsucodigo
						)
					values (
							#rsOC_ORI.OCTid#, #rsOC_ORI.Aid#, null, #rsOC_ORI.SNid#, #rsOC_ORI.OCCid_O#, null, null,
							'O', 'O',	<!--- Origen + Otros = Otros Costos --->
							'E',
							#rsOC_OO.Ocodigo#, null,		
							'OCOO', '#rsOC_ORI.OCOnumero#', null, #rsOC_OO.recordCount#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_OO.OCOfecha#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_OO.OCOfecha#">,
							#rsOC_OO.Ecodigo#, '#rsOC_ORI.Ucodigo#', 0,
							#rsOC_OO.Mcodigo#, #LvarOCPTMmontoOrigen#, #LvarOCPTMmontoLocal#, 
							#LvarOCPTMmontoValuacion#, #LvarTipoCambioValuacion#,
							#session.Usucodigo#
						)
					<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">
	
				<!--- GENERA DETALLES CONTABLES DEL MOVIMIENTO --->

				<!--- No hay ajuste a Movimientos anteriores porque cantidad = 0 --->
				<cfset sbDistribuyeOrigenesEnDestinos (false, "MOVs_ORI.OCPTMid = #LvarOCPTMid#", 0, 0, Arguments.Conexion)>
			</cfloop>
	
			<!--- OC Destino Entradas a Inventario: Ajusta Costo Almacen con cantidad = 0 --->
			<cfset OCDI_PosteoLin (Arguments.Ecodigo, rsOC_ORI.OCOnumero, "OCOO-OCDI", rsOC_OO.OCOfecha, 0, 0, LvarMcodigoValuacion, Arguments.conexion)>
	
			<!--- Generar detalles --->
			<cfset sbGenerarDetalles(LvarAnoAux, LvarMesAux, Arguments.conexion)>
			<cfset sbGenerarINTARC('OCOO', rsOC_OO.OCOnumero, "OCOO", LvarAnoAux, LvarMesAux, Arguments.Conexion)>

			<!--- Genera el Asiento Contable --->
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "BalanceoMonedaOficina"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion"		value="#Arguments.conexion#"/>
			</cfinvoke>
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "GeneraAsiento" 
						returnvariable	= "LvarIDcontable"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
				<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
				<cfinvokeargument name="Efecha"			value="#rsOC_OO.OCOfecha#"/>
				<cfinvokeargument name="Oorigen"		value="OCOO"/>
				<cfinvokeargument name="Edocbase"		value="#rsOC_OO.OCOnumero#"/>
				<cfinvokeargument name="Ereferencia"	value=""/>						
				<cfinvokeargument name="Edescripcion"	value="Ordenes Comerciales Origen Otros: Otros Costos"/>
				<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
			</cfinvoke>

			<!--- Actualizar el IDcontable del Kardex --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update Kardex 
				   set IDcontable = #LvarIDcontable#
				where Kid IN
					(
						select Kid
						   from #IDKARDEX#
					)
			</cfquery>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				update OCotros
				   set OCOfechaAplicacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				     , UsucodigoAplicacion = #session.Usucodigo#
				where OCOid		= #Arguments.OCOid#
			</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="sbAjusta_OrigenesAnteriores" access="private">
		<cfargument name="OCPTMid"				type="numeric" required="yes">
		<cfargument name="OCTid"				type="numeric" required="yes">
		<cfargument name="Aid"					type="numeric" required="yes">

		<cfargument name="conexion"				type="string" 	required="yes">
		<!--- 
			Cambio de Cantidad Entrada con Costo de Venta Calculado:
				Como el metodo de valuacion de Inventario en Transito es por Acumulación de Costos Entrados,
				todos los calculos de costos se hacen con base en la TotalCantidadEntrada, como factor de calculo Unitario.
				Si este factor cambia, significa que hay que ajustar todos los movimientos anteriores donde se calcularon costos.
				Monto del Ajuste:
					COSTO NUEVO - COSTO VIEJO = MONTO_ORI/TotalCantidadEntradas_NUEVA - MONTO_ORI/CANTIDA_VIEJA = MONTO_ORI * (1/TotalCantidadEntradas_NUEVA - 1/TotalCantidadEntradas_VIEJA)
					Si la TotalCantidadEntradas_NUEVA > TotalCantidadEntradas_VIEJA el costo unitario disminuye y por tanto el ajuste es negativo
					
				Se deben ajustar todas las entradas del mismo TRANSPORTE+ARTICULO
				Se deben ajustar todos los detalles generados excepto el primero que es el registro de la Entrada por el 100% del costo

					Costos Ventas, Destinos Inventarios, 
					Transformacion de Producto,  
					Costos Ventas del Producto Transformado, Destinos Inventarios del Producto Transformado
		--->
		
		<!--- Obtiene todos los Movimientos Origenes que se deben Ajustar: TRANSPORTE + ARTICULO --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select OCPTMid
			  from OCPTmovimientos MOVs_ORI
			 where MOVs_ORI.OCTid 		= #Arguments.OCTid#
			   and MOVs_ORI.Aid			= #Arguments.Aid#
			   and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')	<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
			   and MOVs_ORI.OCPTMid 	<>#LvarOCPTMid#										<!--- No se debe ajustar el Movimiento Actual --->
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<!--- 
			<cf_whereInList Column = "MOVs_ORI.OCPTMid" ValueList="#ValueList(rsSQL.OCPTMid)#" returnVariable="LvarORI_IDs">
			--->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				delete from #OC_OCPTMids#
			</cfquery>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into #OC_OCPTMids# 
					(
						OCPTMid
					)
				select OCPTMid
				  from OCPTmovimientos MOVs_ORI
				 where MOVs_ORI.OCTid 		= #Arguments.OCTid#
				   and MOVs_ORI.Aid			= #Arguments.Aid#
				   and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
				   and MOVs_ORI.OCPTMid 	<>#LvarOCPTMid#
			</cfquery>
			<cfset LvarORI_IDs = "MOVs_ORI.OCPTMid IN (select OCPTMid from #OC_OCPTMids#)">
			<cfset sbDistribuyeOrigenesEnDestinos (true, "#LvarORI_IDs#", LvarOCPTentradasCantidad, LvarOCPTentradasCantidadAnt, Arguments.Conexion)>
		</cfif>
	</cffunction>
	
	<cffunction name="sbDistribuyeOrigenesEnDestinos" access="private">
		<cfargument name="esAjusteOrigenesAnteriores"	type="boolean"	required="yes">
		<cfargument name="MOVs_ORI_IDs"					type="string" 	required="yes">
		<cfargument name="CantidadUnitaria1"			type="numeric" 	required="yes">
		<cfargument name="CantidadUnitaria2"			type="numeric" 	required="yes">

		<cfargument name="conexion"						type="string" 	required="yes">

		<!--- GENERA DETALLES CONTABLES --->
		<!---
			1. EN EL MOVIMIENTO DE ENTRADA OC y OI: Entra todo a Transito
				TR CostoOri 100%
					OC_CxP	o OI_INV
					
			2. POR CADA MOVIMIENTO DESTINO DC y DI: Pasar de Transito al DC_CV o DI_INV
				DC_CV CostoOri/EntradasTotal*CantidadDC
				DI_INV CostoOri/EntradasTotal*CantidadDC
					TR	CostoOri/EntradasTotal*CantidadDC_DI
				
			3. POR CADA TRANSFORMACION TO: Pasar de Transito a TO_TR
				TO_TR CostoOri/EntradasTotal*Cantidad_TO * proporcionDst
					TR CostoOri/EntradasTotal*Cantidad_TO * proporcionDst
				
			4. POR CADA MOVIMIENTO DESTINO TD_DC y TD_DI: Pasar del Transito TO_TR al TD_DC_CV o TD_DI_INV (proporciones de transformacion)
				DC_CV CostoOri/EntradasTotal*Cantidad_TD_DC * (cantidad_TO * proporcionDst / OCTTDcantidad_TD)
				DI_INV CostoOri/EntradasTotal*Cantidad_TD_DI * (cantidad_TO * proporcionDst / OCTTDcantidad_TD)
					TR	CostoOri/EntradasTotal*Cantidad_TD_DC_DI * (cantidad_TO * proporcionDst / OCTTDcantidad_TD)
				
		--->

		<!--- 
			1. DETALLE DEL MOVIMIENTO DE ENTRADA OC y OI: Entra todo a Transito
				(Se registra en el movimiento original y no se incluye en un ajuste por cambio de Cantidad porque el costo entrado no se modifica)
				TR CostoOri 100%
					OC_CxP	o OI_INV
		--->
		<cfif Arguments.esAjusteOrigenesAnteriores>
			<!--- 
				Cuando es Ajuste de Origenes Anteriores por Cambio de Cantidad:
					se van a procesar TODOS los movimientos origenes del Transporte + Producto
					excepto el movimiento actual que no se ha incluido
					
					El costoUnitario es el costo de ajuste de cada movimiento
			--->
			<cfif Arguments.CantidadUnitaria1 EQ 0>
				<!--- Si hay Movimientos Destinos con Costo Calculado no puede volver CantidadEntradas a CERO --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select 	min(MOVs_DST.OCPTMtipoICTV) as OCPTMtipoICTV, count(1) as cantidad
					  from OCPTmovimientos MOVs_ORI
						inner join OCPTmovimientos MOVs_DST
							 on MOVs_DST.OCTid			= MOVs_ORI.OCTid
							and MOVs_DST.Aid			= MOVs_ORI.Aid
							and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I', 'T')
							and MOVs_DST.OCPTMfechaCV is not null
					 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#
					 order by MOVs_DST.OCPTMtipoICTV
				</cfquery>
				<cfif rsSQL.OCPTMtipoICTV EQ "C">
					<cf_errorCode	code = "51495" msg = "Se está cambiando la cantidad de entradas del producto a CERO, pero ya tiene Costos de Ventas calculados">
				<cfelseif rsSQL.OCPTMtipoICTV EQ "I">
					<cf_errorCode	code = "51496" msg = "Se está cambiando la cantidad de entradas del producto a CERO, pero ya tiene Entradas a Inventario">
				<cfelseif rsSQL.OCPTMtipoICTV EQ "T">
					<cf_errorCode	code = "51497" msg = "Se está cambiando la cantidad de entradas del producto a CERO, pero ya pertenece a una Transformacion">
				</cfif>

				<!--- 
					Cantidad Unitaria Nueva = 0 significa que sólo hay origenes sin cantidad o se está devolviendo todo, pero no hay destinos qué distribuir
						En origenes: Se verifica que si hay destinos no pueda volver CantidadEntradas a CERO
						En destinos: Se verifica que la CantidadEntradas sea mayor que CERO
				--->
				<cfreturn>
			<cfelseif Arguments.CantidadUnitaria2 EQ 0>
				<!--- 
					Cantidad Unitaria Anterior = 0 significa que sólo había origenes sin cantidad o se había devuelto todo, pero implica que no hay destinos qué distribuir
						En origenes: Se verifica que si hay destinos no pueda volver CantidadEntradas a CERO
						En destinos: Se verifica que la CantidadEntradas sea mayor que CERO
				--->
				<cfreturn>
			<cfelse>
				<cfset LvarMontoValuacionUnitario 	= "( MOVs_ORI.OCPTMmontoValuacion/#Arguments.CantidadUnitaria1# - MOVs_ORI.OCPTMmontoValuacion/#Arguments.CantidadUnitaria2# )">
				<cfset LvarMontoLocalUnitario 		= "( MOVs_ORI.OCPTMmontoLocal    /#Arguments.CantidadUnitaria1# - MOVs_ORI.OCPTMmontoLocal    /#Arguments.CantidadUnitaria2# )">
			</cfif>
		<cfelse>
			<!--- 
				Cuando no es Ajuste 
					se va a procesar el movimiento actual, 
					siempre despues del Ajuste por cambio de cantidad
					
					El costoUnitario es el costo unitario del movimiento
			--->
			<!--- DEBITO: TR es normal debito * MOVs_ORI.OCPTMmonto es normal positivo --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #OC_Detalle#
					(
						Tipo, OCPTMid, 
						OCTid, Aid, OCid, SNid, OCCid,
						Ocodigo, Alm_Aid, CFcuenta,
						
						OCid_O, OCTTid, OCid_D,

						OCPTDmontoLocal, OCPTDmontoValuacion
					)
				select 	'TR', #LvarOCPTMid#, 
						MOVs_ORI.OCTid, MOVs_ORI.Aid, -1, MOVs_ORI.SNid, MOVs_ORI.OCCid,
						MOVs_ORI.Ocodigo, null, null,

						MOVs_ORI.OCid, null, null, 

						MOVs_ORI.OCPTMmontoLocal, 
						MOVs_ORI.OCPTMmontoValuacion
				  from OCPTmovimientos MOVs_ORI
				 where MOVs_ORI.OCPTMid = #LvarOCPTMid#
			</cfquery>

			<cfif Arguments.CantidadUnitaria2 NEQ 0>
				<cf_errorCode	code = "51498" msg = "La cantidad anterior debe ser CERO cuando no es ajuste por cambio de cantidad">
			<cfelseif Arguments.CantidadUnitaria1 EQ 0>
				<!--- 
					Cantidad Unitaria = 0 significa que es un origen sin cantidad o se está devolviendo todo, pero no hay destinos qué distribuir
						En origenes: Se verifica que si hay destinos no pueda volver CantidadEntradas a CERO
						En destinos: Se verifica que la CantidadEntradas sea mayor que CERO
				--->
				<cfreturn>
			</cfif>
			<cfset LvarMontoValuacionUnitario 	= "( MOVs_ORI.OCPTMmontoValuacion/#Arguments.CantidadUnitaria1# )">
			<cfset LvarMontoLocalUnitario 		= "( MOVs_ORI.OCPTMmontoLocal    /#Arguments.CantidadUnitaria1# )">
		</cfif>

		<!--- 
			2. POR CADA MOVIMIENTO DESTINO DC y DI
				DC_CV CostoOri/EntradasTotal*CantidadDC
				DI_INV CostoOri/EntradasTotal*CantidadDC
					TR	CostoOri/EntradasTotal*CantidadDC_DI
		--->
		<!--- DEBITO: CV/DI es normal credito y MOVs_DST.OCPTMcantidad es normal negativo. --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, Alm_Aid, CFcuenta,

					OCid_O, OCTTid, OCid_D, 
			
					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select 	case MOVs_DST.OCPTMtipoICTV 
						when 'C' then 'CV' 
						when 'I' then 'DI' 
					end, 
					#LvarOCPTMid#,
					MOVs_DST.OCTid, MOVs_DST.Aid, MOVs_DST.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
					MOVs_DST.Ocodigo, MOVs_DST.Alm_Aid, null,

					MOVs_ORI.OCid, null, MOVs_DST.OCid, 
			
					(#LvarMontoValuacionUnitario#)	* (MOVs_DST.OCPTMcantidad) * MOVs_DST.OCPTMtipoCambioVal, 
					(#LvarMontoValuacionUnitario#)	* (MOVs_DST.OCPTMcantidad)
			  from OCPTmovimientos MOVs_ORI
				inner join OCPTmovimientos MOVs_DST
					 on MOVs_DST.OCTid			= MOVs_ORI.OCTid
					and MOVs_DST.Aid			= MOVs_ORI.Aid
					and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C','I')
					and MOVs_DST.OCPTMfechaCV is not null
			 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#
			   and MOVs_ORI.OCPTMmontoValuacion <> 0						<!--- Monto a Distribuir --->
			   and MOVs_DST.OCPTMcantidad <> 0								<!--- Cantidad a Distribuir --->
		</cfquery>
		<!--- CREDITO: TR es normal debito * MOVs_DST.OCPTMcantidad es normal negativo --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, Alm_Aid, CFcuenta,

					OCid_O, OCTTid, OCid_D, 

					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select 	'TR', #LvarOCPTMid#,
					MOVs_ORI.OCTid, MOVs_ORI.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
					MOVs_ORI.Ocodigo, null, null,

					MOVs_ORI.OCid, null, MOVs_DST.OCid, 

					(#LvarMontoValuacionUnitario#)	* (MOVs_DST.OCPTMcantidad) * MOVs_DST.OCPTMtipoCambioVal, 
					(#LvarMontoValuacionUnitario#)	* (MOVs_DST.OCPTMcantidad)
			  from OCPTmovimientos MOVs_ORI
				inner join OCPTmovimientos MOVs_DST
					 on MOVs_DST.OCTid			= MOVs_ORI.OCTid
					and MOVs_DST.Aid			= MOVs_ORI.Aid
					and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
					and MOVs_DST.OCPTMfechaCV is not null
			 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#
			   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
			   and MOVs_DST.OCPTMcantidad <> 0									<!--- Cantidad a Distribuir --->
		</cfquery>

		<!--- TRANSFORMACION DE PRODUCTO --->
		<!--- 
			3. POR CADA TRANSFORMACION TO
				TD_TR CostoOri/EntradasTotal * (Cantidad_TO * proporcionDst_TD)
					TO_TR CostoOri/EntradasTotal * (Cantidad_TO)

				Ojo: Cantidad_TO del TO = sum(Cantidad_TO * proporcionDst_TD) de cada TD
		--->
		<!--- DEBITO: TR es normal debito * TTO.OCTTDcantidad es positivo --->
		<!--- Mete al transito del Producto Transformado (TTD=Destino de la Transformación) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, Alm_Aid, CFcuenta,

					OCid_O, OCTTid, OCid_D, 

					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select 	'TR', #LvarOCPTMid#,
					TTD.OCTid, TTD.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
					MOVs_ORI.Ocodigo, null, null,

					MOVs_ORI.OCid, TE.OCTTid, null, 

					(#LvarMontoLocalUnitario#)	* (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst), 
					(#LvarMontoValuacionUnitario#)	* (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst)
			  from OCPTmovimientos MOVs_ORI
				inner join OCtransporteTransformacionD TTO
					inner join OCtransporteTransformacion TE
						  on TE.OCTTid		= TTO.OCTTid
						 and TE.OCTTestado	= 1
					inner join OCtransporteTransformacionD TTD
						 on TTD.OCTTid 		= TTO.OCTTid
						and TTD.OCTTDtipoOD	= 'D'
					 on TTO.OCTid		= MOVs_ORI.OCTid
					and TTO.Aid			= MOVs_ORI.Aid
					and TTO.OCTTDtipoOD	= 'O'
			 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#

			   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
			   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
			   and TTD.OCTTDproporcionDst <> 0									<!--- Proporcion a Distribuir --->
		</cfquery>
		<!--- CREDITO: TR es normal debito * -TTO.OCTTDcantidad es negativo --->
		<!--- Saca de transito del Producto Mezclado (TTO=Origen de la Transformación) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, Alm_Aid, CFcuenta,

					OCid_O, OCTTid, OCid_D, 

					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select 	'TR', #LvarOCPTMid#,
					TTO.OCTid, TTO.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
					MOVs_ORI.Ocodigo, null, null,

					MOVs_ORI.OCid, TE.OCTTid, null, 
	
					(#LvarMontoLocalUnitario#)	* (-TTO.OCTTDcantidad), 
					(#LvarMontoValuacionUnitario#)	* (-TTO.OCTTDcantidad)
			  from OCPTmovimientos MOVs_ORI
				inner join OCtransporteTransformacionD TTO
					inner join OCtransporteTransformacion TE
						  on TE.OCTTid		= TTO.OCTTid
						 and TE.OCTTestado	= 1
					 on TTO.OCTid		= MOVs_ORI.OCTid
					and TTO.Aid			= MOVs_ORI.Aid
					and TTO.OCTTDtipoOD	= 'O'
			 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#

			   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
			   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
		</cfquery>

		<!---
			4. POR CADA MOVIMIENTO DESTINO DE PRODUCTO TRANSFORMADO TD_DC y TD_DI: Pasar del Transito TD_TR al TD_DC_CV o TD_DI_INV (proporciones de transformacion)

				DC_CV CostoOri/EntradasTotal*Cantidad_TD_DC * (cantidad_TO * proporcionDst / OCTTDcantidad_TD)
				DI_INV CostoOri/EntradasTotal*Cantidad_TD_DI * (cantidad_TO * proporcionDst / OCTTDcantidad_TD)
					TR	CostoOri/EntradasTotal*Cantidad_TD_DC_DI * (cantidad_TO * proporcionDst / OCTTDcantidad_TD)
		--->			
		<!--- DEBITO: CV/DI es normal credito y MOVs_DST.OCPTMcantidad es normal negativo. --->
		<!--- Mete al Costo del Producto Transformado (TTD=Destino de la Transformación) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, Alm_Aid, CFcuenta,
					
					OCid_O, OCTTid, OCid_D, 

					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select 	case MOVs_DST.OCPTMtipoICTV 
						when 'C' then 'CV' 
						when 'I' then 'DI' 
					end, 
					#LvarOCPTMid#,
					TTD.OCTid, TTD.Aid, MOVs_DST.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
					MOVs_DST.Ocodigo, MOVs_DST.Alm_Aid , null,

					MOVs_ORI.OCid, TE.OCTTid, MOVs_DST.OCid, 

					<!--- MD.CostoMovDst_por_MO_PO = MD.cantidadMovDst * ((PD.proporcion * (MO.CostoMovOri / PO.totalCantidadEntradasOri * PO.cantidadMezclada)) / PTD.TotEntradasCantidad)	--->			
					MOVs_DST.OCPTMcantidad * ((TTD.OCTTDproporcionDst * ((#LvarMontoValuacionUnitario#) * TTO.OCTTDcantidad)) / PTD.OCPTentradasCantidad) * MOVs_DST.OCPTMtipoCambioVal, 
					MOVs_DST.OCPTMcantidad * ((TTD.OCTTDproporcionDst * ((#LvarMontoValuacionUnitario#) * TTO.OCTTDcantidad)) / PTD.OCPTentradasCantidad) 
			  from OCPTmovimientos MOVs_ORI
				inner join OCtransporteTransformacionD TTO
					inner join OCtransporteTransformacion TE
						  on TE.OCTTid		= TTO.OCTTid
						 and TE.OCTTestado	= 1
					inner join OCtransporteTransformacionD TTD
						inner join OCproductoTransito PTD
							 on PTD.OCTid				= TTD.OCTid
							and PTD.Aid					= TTD.Aid
						inner join OCPTmovimientos MOVs_DST
							 on MOVs_DST.OCTid			= TTD.OCTid
							and MOVs_DST.Aid			= TTD.Aid
							and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
							and MOVs_DST.OCPTMfechaCV is not null
						 on TTD.OCTTid 		= TTO.OCTTid
						and TTD.OCTTDtipoOD	= 'D'
					 on TTO.OCTid		= MOVs_ORI.OCTid
					and TTO.Aid			= MOVs_ORI.Aid
					and TTO.OCTTDtipoOD	= 'O'
			 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#

			   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
			   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
			   and TTD.OCTTDproporcionDst <> 0									<!--- Proporcion a Distribuir --->
			   and PTD.OCPTentradasCantidad <> 0								<!--- Proporcion a Distribuir --->

			   and MOVs_DST.OCPTMcantidad <> 0									<!--- Cantidad a Distribuir --->
		</cfquery>
		<!--- CREDITO: TR es normal debito * MOVs_DST.OCPTMcantidad es normal negativo --->
		<!--- Saca del Transito del Producto Transformado (TTD=Destino de la Transformación) --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, Alm_Aid, CFcuenta,

					OCid_O, OCTTid, OCid_D, 

					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select 	'TR', #LvarOCPTMid#,
					TTD.OCTid, TTD.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
					MOVs_ORI.Ocodigo, null, null,

					MOVs_ORI.OCid, TE.OCTTid, MOVs_DST.OCid, 

					<!--- MD.CostoMovDst_por_MO_PO = MD.cantidadMovDst * ((PD.proporcion * (MO.CostoMovOri / PO.totalCantidadEntradasOri * PO.cantidadMezclada)) / PTD.TotEntradasCantidad)	--->			
					MOVs_DST.OCPTMcantidad * ((TTD.OCTTDproporcionDst * ((#LvarMontoValuacionUnitario#) * TTO.OCTTDcantidad)) / PTD.OCPTentradasCantidad) * MOVs_DST.OCPTMtipoCambioVal, 
					MOVs_DST.OCPTMcantidad * ((TTD.OCTTDproporcionDst * ((#LvarMontoValuacionUnitario#) * TTO.OCTTDcantidad)) / PTD.OCPTentradasCantidad) 
			  from OCPTmovimientos MOVs_ORI
				inner join OCtransporteTransformacionD TTO
					inner join OCtransporteTransformacion TE
						  on TE.OCTTid		= TTO.OCTTid
						 and TE.OCTTestado	= 1
					inner join OCtransporteTransformacionD TTD
						inner join OCproductoTransito PTD
							 on PTD.OCTid				= TTD.OCTid
							and PTD.Aid					= TTD.Aid
						inner join OCPTmovimientos MOVs_DST
							 on MOVs_DST.OCTid		= TTD.OCTid
							and MOVs_DST.Aid			= TTD.Aid
							and MOVs_DST.OCPTMtipoOD  = 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
							and MOVs_DST.OCPTMfechaCV is not null
						 on TTD.OCTTid 		= TTO.OCTTid
						and TTD.OCTTDtipoOD	= 'D'
					 on TTO.OCTid		= MOVs_ORI.OCTid
					and TTO.Aid			= MOVs_ORI.Aid
					and TTO.OCTTDtipoOD	= 'O'
			 where #preservesinglequotes(Arguments.MOVs_ORI_IDs)#

			   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
			   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
			   and TTD.OCTTDproporcionDst <> 0									<!--- Proporcion a Distribuir --->
			   and PTD.OCPTentradasCantidad <> 0								<!--- Proporcion a Distribuir --->

			   and MOVs_DST.OCPTMcantidad <> 0									<!--- Cantidad a Distribuir --->
		</cfquery>
	</cffunction>

	<cffunction name="OC_Aplica_Ingreso" access="public">
		<cfargument name="Ecodigo"		type="numeric"	required="yes">
		<cfargument name="EDid"			type="numeric"	required="yes">
		<cfargument name="Periodo"			type="numeric"	required="yes">
		<cfargument name="Mes"				type="numeric"	required="yes">

		<cfargument name="conexion"		type="string" 	required="yes">

		<cfquery name="rsOC_VENTAS" datasource="#Arguments.Conexion#">
			select 	e.CCTcodigo, e.EDdocumento as Ddocumento, d.DDlinea as DDid,

					d.OCTid, d.Aid, d.OCid, d.OCIid, oci.OCIcodigo, sn.SNid, oc.SNid as OC_SNid,
					oc.OCtipoOD, oc.OCtipoIC, oc.OCVid, 
					d.Alm_Aid,
					 
					t.CCTtipo,
					e.Ocodigo,
					d.Ccuenta,

					e.EDfecha as OCPTMfecha,
					e.EDtipocambioFecha as OCPTMfechaTC,
					e.EDtipocambioVal,

					d.DDcantidad as OCPTMcantidad,
					d.Ecodigo, a.Ucodigo, 

					oct.OCTtipo, oct.OCTtransporte, oct.OCTestado,
					
					e.Mcodigo as McodigoOrigen, 
					round(c.ingresoLinea, 2) 										as OCPTMmontoOrigen, 
					round(c.ingresoLinea * e.EDtipocambio, 2) 						as OCPTMmontoLocal, 
					round(c.ingresoLinea * e.EDtipocambio / e.EDtipocambioVal, 2) 	as OCPTMmontoValuacion
			from DDocumentosCxC d
				inner join #request.CC_calculoLin# c
				   on c.EDid = d.EDid
				  and c.DDid = d.DDlinea
				inner join EDocumentosCxC e
					inner join CCTransacciones t
						 on t.Ecodigo	= e.Ecodigo
						and t.CCTcodigo	= e.CCTcodigo
					inner join SNegocios sn
						 on sn.Ecodigo	= e.Ecodigo
						and sn.SNcodigo	= e.SNcodigo
					 on e.Ecodigo		= d.Ecodigo
					and e.EDid	= d.EDid
				left join Articulos a
					 on a.Aid = d.Aid
				left join OCordenComercial oc
					 on oc.OCid = d.OCid
				left join OCconceptoIngreso oci
					 on oci.OCIid = d.OCIid
				left join OCtransporte oct
					 on oct.OCTid = d.OCTid
			where d.EDid		= #Arguments.EDid#
			  and d.Ecodigo		= #Arguments.Ecodigo#
			  and d.DDtipo		= 'O'
		</cfquery>

		<cfloop query="rsOC_Ventas">
			<cfif rsOC_Ventas.Aid EQ "">
				<cf_errorCode	code = "51499" msg = "CxC de Producto en Orden Comercial de Transito: Se debe indicar Articulo">
			<cfelseif rsOC_Ventas.OCTid EQ "">
				<cf_errorCode	code = "51500" msg = "CxC de Producto en Orden Comercial de Transito: Se debe indicar Transporte">
			<cfelseif rsOC_Ventas.OCTestado NEQ "A">
				<cf_errorCode	code = "51501"
								msg  = "CxC de Producto en Orden Comercial de Transito: No se permiten movimientos al Transporte @errorDat_1@-@errorDat_2@ porque no está Abierto"
								errorDat_1="#rsOC_Ventas.OCTtipo#"
								errorDat_2="#rsOC_Ventas.OCTtransporte#"
				>
			<cfelseif rsOC_Ventas.OCid EQ "">
				<cf_errorCode	code = "51502" msg = "CxC de Producto en Orden Comercial de Transito: Se debe indicar Órden Comercial">
			<cfelseif rsOC_Ventas.OCIid EQ "">
				<cf_errorCode	code = "51503" msg = "CxC de Producto en Orden Comercial de Transito: Se debe indicar Concepto de Ingreso">
			<cfelseif rsOC_Ventas.OCVid EQ "">
				<cf_errorCode	code = "51504" msg = "CxC de Producto en Orden Comercial de Transito: La Órden Comercial no tiene Tipo de Venta">
			<cfelseif rsOC_Ventas.OCtipoOD NEQ "D" OR (rsOC_Ventas.OCtipoIC NEQ "C" AND rsOC_Ventas.OCtipoIC NEQ "V")>
				<cf_errorCode	code = "51505" msg = "CxC de Producto en Orden Comercial de Transito: La Órden Comercial debe ser tipo Comercial Destino (Venta Transito) o Venta Directa de Almacen">
			<cfelseif rsOC_Ventas.OCtipoIC EQ "V" AND rsOC_Ventas.Alm_Aid EQ "">
				<cf_errorCode	code = "51506" msg = "CxC de Producto en Orden Comercial de Transito: La Órden Comercial Destino tipo Venta Directa de Almacen debe tener Almacen Origen">
			<!--- 
			<cfelseif rsOC_Ventas.OCtipoIC EQ "V" AND rsOC_Ventas.OCIcodigo NEQ "00">
				Se permite Ventas Directas de Almacen de Otros Conceptos diferentes a 00=Producto, porque cantidad=0 y solo se registra el ingreso (no hay costo de venta)
				<cf_errorCode	code = "51507" msg = "CxC de Producto en Orden Comercial de Transito: La Órden Comercial Destino tipo Venta Directa de Almacen sólo puede tener Concepto de Ingreso '00=Producto'">
			--->
			<cfelseif rsOC_Ventas.OCIcodigo NEQ "00" AND rsOC_Ventas.OCPTMcantidad NEQ 0>
				<cf_errorCode	code = "51508" msg = "CxC de Producto en Orden Comercial de Transito: Sólo se puede indicar Cantidad si el Concepto de Ingreso es '00=Producto'">
			<cfelseif rsOC_Ventas.OCIcodigo EQ "00" AND rsOC_Ventas.SNid NEQ rsOC_Ventas.OC_SNid>
				<cf_errorCode	code = "51509" msg = "CxC de Producto en Orden Comercial de Transito: La Órden Comercial debe ser del mismo cliente del documento CxC cuando el Concepto de Ingreso es '00=Producto'">
			</cfif>

			<!--- Verifica OCtransporteProducto --->
			<cfquery name="rsPT" datasource="#Arguments.Conexion#">
				select Aid, OCtipoOD
				  from OCtransporteProducto
				 where OCTid 	= #rsOC_Ventas.OCTid#
				   and OCid 	= #rsOC_Ventas.OCid#
				   and Aid	 	= #rsOC_Ventas.Aid#
				   and OCtipoOD = 'D'
			</cfquery>
			<cfif rsPT.Aid EQ "">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select OCTtipo, OCTtransporte
					  from OCtransporte
					 where OCTid	= #rsOC_Ventas.OCTid#
				</cfquery>
				<cfset LvarOCTtransporte = rsSQL.OCTtipo & ' - ' & rsSQL.OCTtransporte>
				
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select OCcontrato
					  from OCordenComercial
					 where OCid	= #rsOC_Ventas.OCid#
				</cfquery>
				<cfset LvarOCcontrato = rsSQL.OCcontrato>
				
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Acodigo
					  from Articulos
					 where Aid	= #rsOC_Ventas.Aid#
				</cfquery>
				<cfset LvarAcodigo = rsSQL.Acodigo>

				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_Ventas.OCTid#
					   and Aid	 	= #rsOC_Ventas.Aid#
				</cfquery>
				<cfif rsPT.Aid EQ "">
					<cf_errorCode	code = "51510"
									msg  = "CxC de Producto en Orden Comercial de Transito: El Articulo '@errorDat_1@' no se ha registrado en el Transporte '@errorDat_2@'"
									errorDat_1="#LvarAcodigo#"
									errorDat_2="#LvarOCTtransporte#"
					>
				</cfif>

				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_Ventas.OCTid#
					   and OCid 	= #rsOC_Ventas.OCid#
					   and Aid	 	= #rsOC_Ventas.Aid#
				</cfquery>
				<cfif rsPT.Aid EQ "">
					<cf_errorCode	code = "51511"
									msg  = "CxC de Producto en Orden Comercial de Transito: El Articulo '@errorDat_1@' para la orden comercial '@errorDat_2@ no se ha registrado en el Transporte '@errorDat_3@'"
									errorDat_1="#LvarAcodigo#"
									errorDat_2="#LvarOCcontrato#"
									errorDat_3="#LvarOCTtransporte#"
					>
				</cfif>

				<cf_errorCode	code = "51512"
								msg  = "CxC de Producto en Orden Comercial de Transito: El Articulo '@errorDat_1@' para la orden comercial '@errorDat_2@ no se ha registrado en el Transporte '@errorDat_3@' como Destino: OCtipoOD=@errorDat_4@"
								errorDat_1="#LvarAcodigo#"
								errorDat_2="#LvarOCcontrato#"
								errorDat_3="#LvarOCTtransporte#"
								errorDat_4="#rsPT.OCtipoOD#"
				>
			</cfif>

			<!--- Débito a CxC = Venta Positiva --->
			<cfif rsOC_Ventas.CCTtipo EQ "D">
				<cfset LvarOCPTMtipoES			= "S">
				<cfset LvarOCPTMcantidad		= rsOC_Ventas.OCPTMcantidad>
				<cfset LvarOCPTMmontoOrigen		= rsOC_Ventas.OCPTMmontoOrigen>
				<cfset LvarOCPTMmontoLocal		= rsOC_Ventas.OCPTMmontoLocal>
				<cfset LvarOCPTMmontoValuacion	= rsOC_Ventas.OCPTMmontoValuacion>
			<cfelse>
				<cfset LvarOCPTMtipoES			= "E">
				<cfset LvarOCPTMcantidad		= -rsOC_Ventas.OCPTMcantidad>
				<cfset LvarOCPTMmontoOrigen		= -rsOC_Ventas.OCPTMmontoOrigen>
				<cfset LvarOCPTMmontoLocal		= -rsOC_Ventas.OCPTMmontoLocal>
				<cfset LvarOCPTMmontoValuacion	= -rsOC_Ventas.OCPTMmontoValuacion>
			</cfif>

			<cfif rsOC_Ventas.OCtipoIC NEQ "V">
				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select OCPTentradasCantidad, OCPTentradasCostoTotal, OCPTventasCantidad, OCPTventasMontoTotal
					  from OCproductoTransito
					 where OCTid = #rsOC_Ventas.OCTid#
					   and Aid	 = #rsOC_Ventas.Aid#
				</cfquery>
	
				<cfset LvarOCPTentradasCantidad		= rsPT.OCPTentradasCantidad>
				<cfset LvarOCPTentradasCostoTotal	= rsPT.OCPTentradasCostoTotal>
				<cfset LvarOCPTventasCantidad		= rsPT.OCPTventasCantidad 	+ LvarOCPTMcantidad>
				<cfset LvarOCPTventasMontoTotal		= rsPT.OCPTventasMontoTotal + LvarOCPTMmontoValuacion>
	
				<cfquery datasource="#Arguments.Conexion#">
					update OCproductoTransito
					   set OCPTventasCantidad 		= #LvarOCPTventasCantidad#, 
						   OCPTventasMontoTotal 	= #LvarOCPTventasMontoTotal#
					 where OCTid = #rsOC_Ventas.OCTid#
					   and Aid	 = #rsOC_Ventas.Aid#
				</cfquery>
			</cfif>
							
			<!--- 2. Registra Movimiento: OCPTmovimientos de Ingresos --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into OCPTmovimientos
					(
						OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
						OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES, 

						Ocodigo, Alm_Aid,
						Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
						OCPTMfecha, OCPTMfechaTC,
						Ecodigo, Ucodigo, OCPTMcantidad, OCPTMventaCantidad, 
						McodigoOrigen, OCPTMventaOrigen, OCPTMventaLocal, 
						OCPTMventaValuacion, OCPTMtipoCambioVal,
						BMUsucodigo
					)
				values (
						#rsOC_Ventas.OCTid#, #rsOC_Ventas.Aid#, #rsOC_Ventas.OCid#, #rsOC_Ventas.SNid#, null, #rsOC_Ventas.OCIid#, #rsOC_Ventas.OCVid#, 
					<cfif rsOC_Ventas.OCtipoIC NEQ "V">
						'D', 'C',				<!--- Destino + Comercial = Venta --->
						'#LvarOCPTMtipoES#',
						#rsOC_Ventas.Ocodigo#, null,
					<cfelse>
						'D', 'V',				<!--- Destino + Venta Directa de Almacen --->
						'#LvarOCPTMtipoES#',
						null, #rsOC_Ventas.Alm_Aid#,	<!--- Almacen Origen --->
					</cfif>
						'CCFC', '#rsOC_Ventas.Ddocumento#', '#rsOC_Ventas.CCTcodigo#', #rsOC_Ventas.DDid#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_Ventas.OCPTMfecha#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_Ventas.OCPTMfechaTC#">,
						#rsOC_Ventas.Ecodigo#, '#rsOC_Ventas.Ucodigo#', 0, #LvarOCPTMcantidad#,
						#rsOC_Ventas.McodigoOrigen#, #LvarOCPTMmontoOrigen#, #LvarOCPTMmontoLocal#, 
						#LvarOCPTMmontoValuacion#, #rsOC_Ventas.EDtipocambioVal#,
						#session.Usucodigo#
					)
				<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select min(CFcuenta) as CFcuenta
				  from CFinanciera 
				 where Ccuenta = #rsOC_Ventas.Ccuenta#
			</cfquery>
			
			<cfquery datasource="#Arguments.Conexion#">
				insert into OCPTdetalle
					(
						OCPTMid, 
						OCPTDtipoMov, 
						OCTid, Aid, OCPTDperiodo, OCPTDmes,
						Ocodigo, CFcuenta,

						OCid_O, OCid_D, 

						OCPTDmontoValuacion, OCPTDmontoLocal, 

						BMUsucodigo
					)
				values (	
						#LvarOCPTMid#, 
						'I',
						#rsOC_Ventas.OCTid#, #rsOC_Ventas.Aid#, #Arguments.Periodo#, #Arguments.Mes#, 
						#rsOC_Ventas.Ocodigo#, 
						#rsSQL.CFcuenta#, 

						null, #rsOC_Ventas.OCid#,

						#rsOC_Ventas.OCPTMmontoValuacion#, 
						#rsOC_Ventas.OCPTMmontoLocal#, 

						#session.Usucodigo#
					)
			</cfquery>
		</cfloop>
	</cffunction>

	<!--- Destino Otros Ingresos (sin Costos --->
	<cffunction name="OC_Aplica_OCDO" access="public">
		
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="OCOid"			type="numeric"	required="yes">
		<cfargument name="VerAsiento"		type="boolean"	required="yes">
		<cfargument name="conexion"			type="string" 	required="yes">

		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
	
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset OC_DETALLE 	= OC_CreaTablas(Arguments.Conexion)>

		<cftransaction>
			<!--- Período de Auxiliares --->
			<cfset LvarAnoAux = fnLeeParametro(50,"Período de Auxiliares")>
			<cfset LvarMesAux = fnLeeParametro(60,"Mes de Auxiliares")>
	
			<cfquery name="rsOC_DO" datasource="#Arguments.Conexion#">
				select 	e.Ecodigo, e.OCOid, e.OCOnumero, e.OCOfecha,
						e.OCOtipoOD, 
						'OC.Otros Ingresos ' +  OCOobservaciones as OCOobservaciones,
						e.CFcuenta,
						e.SNid,
						e.Mcodigo, e.Ocodigo,
						OCOtotalOrigen, OCOtipoCambio, OCOtipoCambioVal,
						(select round(sum(OCODmontoOrigen),2) from OCotrosDetalle where OCOid = e.OCOid) as OCOtotalLineas
				  from OCotros e
				  where e.Ecodigo 	= #Arguments.Ecodigo#
					and e.OCOid		= #Arguments.OCOid#
			</cfquery>
			<cfif rsOC_DO.OCOid EQ "">
				<cf_errorCode	code = "51513"
								msg  = "OC_DO Destino Otros Ingresos: Documento ID=@errorDat_1@ no existe"
								errorDat_1="#Arguments.OCOid#"
				>
			<cfelseif rsOC_DO.OCOtipoOD NEQ "D">
				<cf_errorCode	code = "51514"
								msg  = "OC_DO Destino Otros Ingresos: Documento @errorDat_1@ no es tipo Destino Otros Ingresos"
								errorDat_1="#rsOC_DO.OCOnumero#"
				>
			<cfelseif rsOC_DO.OCOtotalOrigen NEQ rsOC_DO.OCOtotalLineas>
				<cf_errorCode	code = "51515"
								msg  = "OC_DO Destino Otros Ingresos: El total del Documento @errorDat_1@ no corresponde al Total de las Líneas"
								errorDat_1="#rsOC_DO.OCOnumero#"
				>
			</cfif>
			
			<!--- Moneda de Valuación --->
			<cfinvoke 
				component		= "sif.Componentes.IN_PosteoLin" 
				method			= "IN_MonedaValuacion"  
				returnvariable	= "LvarCOSTOS"
	
				Ecodigo			= "#Arguments.Ecodigo#"
				tcFecha			= "#rsOC_DO.OCOfecha#"
	
				Conexion		= "#Arguments.Conexion#"
			/>
	
			<cfset LvarMcodigoValuacion		= LvarCostos.VALUACION.Mcodigo>
			<cfset LvarTipoCambioValuacion	= LvarCostos.VALUACION.TC>
	


			<cfquery name="rsOC_DST" datasource="#Arguments.Conexion#">
				select 	
						e.OCOnumero, 
						e.Ecodigo, 
						d.OCTid,	t.OCTtipo, t.OCTtransporte, t.OCTestado,
						d.Aid,		a.Acodigo, a.Adescripcion, a.Ucodigo,
						e.SNid,
						d.OCIid_D,	oci.OCIcodigo,	
						d.OCid_D,	oc.OCVid,	
						d.OCODmontoOrigen, e.OCOtipoCambio
					from OCotros e
						inner join OCotrosDetalle d
							 on d.OCOid=e.OCOid
						inner join OCtransporte t
							 on t.OCTid = d.OCTid
						inner join Articulos a
							 on a.Aid = d.Aid
						inner join OCconceptoIngreso oci
							 on oci.OCIid = d.OCIid_D
						inner join OCordenComercial oc
							 on oc.OCid = d.OCid_D
				  where e.OCOid		= #Arguments.OCOid#
			</cfquery>
	
			<!--- Crédito Cuenta a Debitar---> 
			<cfquery datasource="#Arguments.Conexion#">
				insert into #request.INTARC# ( 
						INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, 
						Ccuenta, CFcuenta, Ocodigo,
						Mcodigo, INTMOE, INTCAM, INTMON
					)
				values (
						'OCDO',	1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOC_DO.OCOnumero#">,
						'OCDO',

						'D',
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(rsOC_DO.OCOobservaciones, 1, 40)#">,
						'#dateFormat(rsOC_DO.OCOfecha,"YYYYMMDD")#',
						#LvarAnoAux#,
						#LvarMesAux#,

						0,
						#rsOC_DO.CFcuenta#,
						#rsOC_DO.Ocodigo#,
		
						#rsOC_DO.Mcodigo#,
						#rsOC_DO.OCOtotalOrigen#,
						#rsOC_DO.OCOtipoCambio#,
						round(#rsOC_DO.OCOtotalOrigen*rsOC_DO.OCOtipoCambio#,2)
					)
			</cfquery>

			<cfloop query="rsOC_DST">
				<!--- Verifica OCtransporteProducto --->
				<cfquery name="rsTP" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_DST.OCTid#
					   and Aid	 	= #rsOC_DST.Aid#
					   and OCtipoOD = 'D'
				</cfquery>
				<cfif rsTP.Aid EQ "">
					<cfquery name="rsTP" datasource="#Arguments.Conexion#">
						select Aid, OCtipoOD
						  from OCtransporteProducto
						 where OCTid 	= #rsOC_DST.OCTid#
						   and Aid	 	= #rsOC_DST.Aid#
					</cfquery>
					<cfif rsTP.Aid EQ "">
						<cf_errorCode	code = "51516"
										msg  = "OC_DO Otros Ingresos: Articulo @errorDat_1@ no se ha registrado en el Transporte @errorDat_2@-@errorDat_3@"
										errorDat_1="#rsOC_DST.Acodigo#"
										errorDat_2="#rsOC_DST.OCTtipo#"
										errorDat_3="#rsOC_DST.OCTtransporte#"
						>
					</cfif>
	
					<cf_errorCode	code = "51517"
									msg  = "OC_DO Otros Ingresos: Articulo @errorDat_1@ no está registrado como Destino en el Transporte @errorDat_2@-@errorDat_3@"
									errorDat_1="#rsOC_DST.Acodigo#"
									errorDat_2="#rsOC_DST.OCTtipo#"
									errorDat_3="#rsOC_DST.OCTtransporte#"
					>
				</cfif>
	
				<cfif rsOC_DST.OCTestado NEQ "A">
					<cf_errorCode	code = "51518"
									msg  = "OC_DO Destino Otros Ingresos: No se permiten movimientos al Transporte @errorDat_1@-@errorDat_2@ porque no está Abierto"
									errorDat_1="#rsOC_DST.OCTtipo#"
									errorDat_2="#rsOC_DST.OCTtransporte#"
					>
				<cfelseif rsOC_DST.OCODmontoOrigen LT 0>
					<cf_errorCode	code = "51519" msg = "OC_DO Destino Otros Ingresos: No se permite Otros Ingresos negativo">
				<cfelseif rsOC_DST.OCODmontoOrigen LT 0>
					<cf_errorCode	code = "51520" msg = "OC_DO Destino Otros Ingresos: No se permite Otros Ingresos sin monto">
				<cfelseif rsOC_DST.OCIcodigo EQ "00">
					<cf_errorCode	code = "51521" msg = "OC_DO Destino Otros Ingresos: No se permite registrar Otros Ingresos para el Concepto 00=Producto">
				</cfif>

				<!--- Actualiza Saldos: OCproductoTransito --->
				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select 	OCPTentradasCantidad,	OCPTentradasCostoTotal, 
							OCPTventasCantidad,		OCPTventasMontoTotal,
							OCPTsalidasCantidad,	OCPTsalidasCostoTotal
					  from OCproductoTransito
					 where OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>
	
				<cfset LvarOCPTMtipoES			= "S">
				<cfset LvarOCPTMcantidad		= 0>

				<cfset LvarOCPTMmontoOrigen		= rsOC_DST.OCODmontoOrigen>
				<cfset LvarOCPTMmontoLocal		= rsOC_DST.OCODmontoOrigen * rsOC_DST.OCOtipoCambio>
				<cfset LvarOCPTMmontoValuacion	= LvarOCPTMmontoLocal * LvarTipoCambioValuacion>

				<cfset LvarOCPTventasMontoTotal		= rsPT.OCPTventasMontoTotal + LvarOCPTMmontoValuacion>
	
				<!--- DI-CInv: VERIFICA CONSISTENCIA DE SALDOS: ENTRADAS, SALIDAS Y EXISTENCIAS (sin holgura ) --->
				<cfif rsPT.OCPTentradasCantidad LT 0 OR rsPT.OCPTentradasCostoTotal LT 0>
					<cf_errorCode	code = "51522"
									msg  = "OC_DO Destino Otros Ingresos: Error de datos, las Entradas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, EntradasCantidadTotal=@errorDat_3@, EntradasCostoTotal=@errorDat_4@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#rsPT.OCPTentradasCantidad#"
									errorDat_4="#numberFormat(rsPT.OCPTentradasCostoTotal,",9.99")#"
					>
				<cfelseif rsPT.OCPTsalidasCantidad GT 0 OR rsPT.OCPTsalidasCostoTotal GT 0>
					<cf_errorCode	code = "51523"
									msg  = "OC_DO Destino Otros Ingresos: Error de datos, las Salidas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, SalidasCantidadAnterior=@errorDat_3@, Movimiento=@errorDat_4@, SalidasCantidadTotal=@errorDat_5@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#-rsPT.OCPTsalidasCantidad#"
									errorDat_4="#LvarOCPTMcantidad#"
									errorDat_5="#-LvarOCPTsalidasCantidad#"
					>
				</cfif>

				<cfquery datasource="#Arguments.Conexion#">
					update OCproductoTransito
					   set OCPTventasMontoTotal 	= #LvarOCPTventasMontoTotal#
					 where OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>

				<!--- Registra Movimiento: OCPTmovimientos de Otros Ingresos --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into OCPTmovimientos
						(
							OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
							OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES, 
	
							Ocodigo, Alm_Aid,
							Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
							OCPTMfecha, OCPTMfechaTC,
							OCPTMfechaCV,
							Ecodigo, Ucodigo, OCPTMcantidad, OCPTMventaCantidad, 
							McodigoOrigen, OCPTMventaOrigen, OCPTMventaLocal, 
							OCPTMventaValuacion, OCPTMtipoCambioVal,
							BMUsucodigo
						)
					values (
							#rsOC_DST.OCTid#, #rsOC_DST.Aid#, #rsOC_DST.OCid_D#, #rsOC_DST.SNid#, null, #rsOC_DST.OCIid_D#, #rsOC_DST.OCVid#,
							'D', 'O',	<!--- Destino + Otros = Otros Ingresos --->
							'S',
							#rsOC_DO.Ocodigo#, null,		
							'OCDO', '#rsOC_DST.OCOnumero#', null, #rsOC_DO.recordCount#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_DO.OCOfecha#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_DO.OCOfecha#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							#rsOC_DST.Ecodigo#, '#rsOC_DST.Ucodigo#', 0, 0,
							#rsOC_DO.Mcodigo#, #LvarOCPTMmontoOrigen#, #LvarOCPTMmontoLocal#, 
							#LvarOCPTMmontoValuacion#, #LvarTipoCambioValuacion#,
							#session.Usucodigo#
						)
					<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">

				<!--- GENERA DETALLES CONTABLES DEL MOVIMIENTO --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #OC_Detalle#
						(
							Tipo, OCPTMid,
							OCTid, Aid, OCid, SNid, OCCid, OCIid,
							Ocodigo, Alm_Aid, CFcuenta,
		
							OCid_O, OCTTid, OCid_D, 
					
							OCPTDmontoLocal, OCPTDmontoValuacion
						)
					values (	
							'IN', #LvarOCPTMid#, 
							
							#rsOC_DST.OCTid#, #rsOC_DST.Aid#, #rsOC_DST.OCid_D#, #rsOC_DST.SNid#, -1, #rsOC_DST.OCIid_D#,
							#rsOC_DO.Ocodigo#, null, null,
	
							null, null, #rsOC_DST.OCid_D#,
	
							#LvarOCPTMmontoLocal#, 
							#LvarOCPTMmontoValuacion#
						)
				</cfquery>
			</cfloop>
				
			<!--- Generar detalles --->
			<cfset sbGenerarDetalles(LvarAnoAux, LvarMesAux, Arguments.conexion)>
			<cfset sbGenerarINTARC('OCDO', rsOC_DO.OCOnumero, "OCDO", LvarAnoAux, LvarMesAux, Arguments.Conexion)>

			<!--- Genera el Asiento Contable --->
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "BalanceoMonedaOficina"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion"		value="#Arguments.conexion#"/>
			</cfinvoke>
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "GeneraAsiento" 
						returnvariable	= "LvarIDcontable"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
				<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
				<cfinvokeargument name="Efecha"			value="#rsOC_DO.OCOfecha#"/>
				<cfinvokeargument name="Oorigen"		value="OCDO"/>
				<cfinvokeargument name="Edocbase"		value="#rsOC_DO.OCOnumero#"/>
				<cfinvokeargument name="Ereferencia"	value=""/>						
				<cfinvokeargument name="Edescripcion"	value="Ordenes Comerciales Destino Inventario: Recepcion de Tránsito"/>
				<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
			</cfinvoke>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				update OCotros
				   set OCOfechaAplicacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				     , UsucodigoAplicacion = #session.Usucodigo#
				where OCOid		= #Arguments.OCOid#
			</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="OC_Aplica_CostoVenta" access="public">
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='CCTcodigo'		type='string' 	required='true'>	 <!--- Codigo del movimiento---->
		<cfargument name='Ddocumento'		type='string' 	required='true'>	 <!--- Numero Documento---->
		<cfargument name="Periodo"			type="numeric"	required="yes">
		<cfargument name="Mes"				type="numeric"	required="yes">

		<cfargument name="conexion"			type="string" 	required="yes">

		<cfif Arguments.conexion EQ "">
			<cfset Arguments.conexion = #session.dsn#>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			delete from #OC_DETALLE#
		</cfquery>
			
		<!--- Moneda de Valuación --->
		<cfset LvarMcodigoValuacion = fnLeeParametro(441,"Moneda de Valuacion de Inventarios")>

		<cfquery name="rsOC_DST" datasource="#Arguments.Conexion#">
			select 	
					e.CCTcodigo, e.Ddocumento, 

					d.OCTid, d.DDcodartcon as Aid, d.OCid, sn.SNid, oc.SNid as OC_SNid,
					d.OCIid, oci.OCIcodigo, 
					d.Alm_Aid,
					oc.OCtipoOD, oc.OCtipoIC, oc.OCVid, 
					
					t.CCTtipo,
					
					d.CCTcodigo,
					d.Ddocumento,
					d.DDid,
					
					e.Ocodigo,
					d.Ccuenta as CcuentaIngreso,

					e.Dfecha as OCPTMfecha, 
					coalesce(e.EDtipocambioFecha, e.Dfecha) as OCPTMfechaTC,
					e.EDtipocambioVal, e.Dtipocambio,

					d.DDcantidad as OCPTMcantidad,
					d.Ecodigo, a.Ucodigo, 

					e.Mcodigo as McodigoOrigen, 
					round(d.DDtotal, 2)										as OCPTMmontoOrigen,
					round(d.DDtotal * e.Dtipocambio, 2)						as OCPTMmontoLocal, 
					round(d.DDtotal * e.Dtipocambio / e.EDtipocambioVal, 2)	as OCPTMmontoValuacion
					, a.Acodigo
					, oc.OCcontrato
					, oct.OCTtipo, oct.OCTtransporte, oct.OCTestado
					, d.Dcodigo
			from HDDocumentos d
				inner join HDocumentos e
					inner join CCTransacciones t
						 on t.Ecodigo	= e.Ecodigo
						and t.CCTcodigo	= e.CCTcodigo
					inner join SNegocios sn
						 on sn.Ecodigo	= e.Ecodigo
						and sn.SNcodigo	= e.SNcodigo
					 on e.Ecodigo 		= d.Ecodigo
					and e.CCTcodigo		= d.CCTcodigo
				    and e.Ddocumento	= d.Ddocumento
				left join Articulos a
					 on a.Aid = d.DDcodartcon
				left join OCordenComercial oc
					 on oc.OCid	= d.OCid
				left join OCtransporte oct
					 on oct.OCTid	= d.OCTid
				left join OCconceptoIngreso oci
					 on oci.OCIid 	= d.OCIid
			where d.Ecodigo		= #Arguments.Ecodigo#
			  and d.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			  and d.Ddocumento	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
			  and d.DDtipo		= 'O'
		</cfquery>

		<cfif rsOC_DST.recordCount EQ 0>
			<cfreturn>
		</cfif>

		<cfset LvarOcodigo = rsOC_DST.Ocodigo>
		
		<cfloop query="rsOC_DST">
			<cfif rsOC_DST.Aid EQ "">
				<cf_errorCode	code = "51524" msg = "Costo de Venta de Orden Comercial de Transito: Se debe indicar Articulo">
			<cfelseif rsOC_DST.OCTid EQ "">
				<cf_errorCode	code = "51525" msg = "Costo de Venta de Orden Comercial de Transito: Se debe indicar Transporte">
			<cfelseif rsOC_DST.OCTestado NEQ "A">
				<cf_errorCode	code = "51526"
								msg  = "Costo de Venta de Orden Comercial de Transito: No se permiten movimientos al Transporte @errorDat_1@-@errorDat_2@ porque no está Abierto"
								errorDat_1="#rsOC_DST.OCTtipo#"
								errorDat_2="#rsOC_DST.OCTtransporte#"
				>
			<cfelseif rsOC_DST.OCid EQ "">
				<cf_errorCode	code = "51527" msg = "Costo de Venta de Orden Comercial de Transito: Se debe indicar Órden Comercial">
			<cfelseif rsOC_DST.OCIid EQ "">
				<cf_errorCode	code = "51528" msg = "Costo de Venta de Orden Comercial de Transito: Se debe indicar Concepto de Ingreso">
			<cfelseif rsOC_DST.OCVid EQ "">
				<cf_errorCode	code = "51529" msg = "Costo de Venta de Orden Comercial de Transito: La Órden Comercial no tiene Tipo de Venta">
			<cfelseif rsOC_DST.OCtipoOD NEQ "D" OR (rsOC_DST.OCtipoIC NEQ "C" AND rsOC_DST.OCtipoIC NEQ "V")>
				<cf_errorCode	code = "51530" msg = "Costo de Venta de Orden Comercial de Transito: La Órden Comercial debe ser Destino Comercial o Destino Venta Directa de Almacén">
			<cfelseif rsOC_DST.OCtipoIC EQ "V" AND rsOC_DST.Alm_Aid EQ "">
				<cf_errorCode	code = "51531" msg = "Costo de Venta de Orden Comercial de Transito: La Órden Comercial Destino tipo Venta Directa de Almacen debe tener Almacen Origen">
			<cfelseif rsOC_DST.OCIcodigo NEQ "00" AND rsOC_DST.OCPTMcantidad NEQ 0>
				<cf_errorCode	code = "51532" msg = "Costo de Venta de Orden Comercial de Transito: Sólo se puede indicar Cantidad si el Concepto de Ingreso es '00=Producto'">
			<cfelseif rsOC_DST.OCIcodigo EQ "00" AND rsOC_DST.SNid NEQ rsOC_DST.OC_SNid>
				<cf_errorCode	code = "51533" msg = "Costo de Venta de Orden Comercial de Transito: La Órden Comercial debe ser del mismo cliente del documento CxC cuando el Concepto de Ingreso es '00=Producto'">
			</cfif>
			
			<!--- Débito a CxC = Venta = Salida de Producto en Transito --->
			<cfif rsOC_DST.CCTtipo EQ "D">
				<cfset OCPTMtipoES				= "S">
				<cfset LvarOCPTMcantidad		= -rsOC_DST.OCPTMcantidad>
				<cfset LvarOCPTMmontoOrigen		= -rsOC_DST.OCPTMmontoOrigen>
			<cfelse>
				<cfset OCPTMtipoES				= "E">
				<cfset LvarOCPTMcantidad		= rsOC_DST.OCPTMcantidad>
				<cfset LvarOCPTMmontoOrigen		= rsOC_DST.OCPTMmontoOrigen>
			</cfif>

			<!--- Verifica OCtransporteProducto --->
			<cfquery name="rsPT" datasource="#Arguments.Conexion#">
				select Aid, OCtipoOD
				  from OCtransporteProducto
				 where OCTid 	= #rsOC_DST.OCTid#
				   and Aid	 	= #rsOC_DST.Aid#
				   and OCtipoOD = 'D'
			</cfquery>
			<cfif rsPT.Aid EQ "">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Aid, OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_DST.OCTid#
					   and Aid	 	= #rsOC_DST.Aid#
				</cfquery>
				<cfif rsSQL.Aid EQ "">
					<cf_errorCode	code = "51534" msg = "Costo de Venta de Producto en Orden Comercial de Transito: El Articulo no se ha registrado en el Transporte">
				</cfif>

				<cf_errorCode	code = "51535" msg = "Costo de Venta de Producto en Orden Comercial de Transito: El Articulo no está registrado como Destino en el Transporte">
			</cfif>

			<!--- 1. Busca Movimiento de VENTA original en OCPTmovimientos --->
			<cfquery name="rsMOV" datasource="#Arguments.Conexion#">
				select OCPTMid, OCPTMfechaCV, OCPTMventaCantidad, OCPTMventaOrigen
				  from OCPTmovimientos MOVs_DST
				 where MOVs_DST.OCTid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOC_DST.OCTid#">
				   and MOVs_DST.Aid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOC_DST.Aid#">
				   and MOVs_DST.OCid 				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOC_DST.OCid#">
				   and MOVs_DST.OCPTMtipoOD			= 'D' -- AND MOVs_DST.OCPTMtipoICTV IN ('C', 'V')
				   and MOVs_DST.OCPTMtipoICTV		= '#rsOC_DST.OCtipoIC#'

				   and MOVs_DST.Oorigen				= 'CCFC'
				   and MOVs_DST.OCPTMdocumentoOri	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOC_DST.Ddocumento#">
				   and MOVs_DST.OCPTMreferenciaOri	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOC_DST.CCTcodigo#">
				   and MOVs_DST.OCPTMlineaOri		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOC_DST.DDid#">
			</cfquery>
			<cfif rsMOV.OCPTMid EQ "">
				<cf_errorCode	code = "51536"
								msg  = "Costo de Venta de Orden Comercial de Transito: No se registró la Venta/Ingreso Original: @errorDat_1@ @errorDat_2@, DDid='@errorDat_3@'"
								errorDat_1="#rsOC_DST.CCTcodigo#"
								errorDat_2="#rsOC_DST.CCTcodigo#"
								errorDat_3="#rsOC_DST.DDid#"
				>
			<cfelseif rsMOV.OCPTMfechaCV NEQ "">
				<cf_errorCode	code = "51537" msg = "Costo de Venta de Orden Comercial de Transito: El Costo de Venta ya fue procesado">
			<cfelseif -rsMOV.OCPTMventaCantidad NEQ LvarOCPTMcantidad OR -rsMov.OCPTMventaOrigen NEQ LvarOCPTMmontoOrigen>
				<cf_errorCode	code = "51538"
								msg  = "Costo de Venta de Orden Comercial de Transito: Error en Datos, la cantidad o monto de la venta original fue modificada: DocumentoCantidad=@errorDat_1@, VentaOriginalCantidad=@errorDat_2@, DocumentoMonto=@errorDat_3@, VentaOriginalMonto=@errorDat_4@"
								errorDat_1="#LvarOCPTMcantidad#"
								errorDat_2="#rsMOV.OCPTMventaCantidad#"
								errorDat_3="#LvarOCPTMmontoOrigen#"
								errorDat_4="#rsMov.OCPTMventaOrigen#"
				>
			</cfif>
			<cfset LvarOCPTMid 	= rsMOV.OCPTMid>

			<cfif LvarOCPTMcantidad EQ 0>
			<!--- SIN CANTIDAD NO SE CALCULA COSTO --->
				<!--- No hay Costo de Ventas cuando no hay cantidad vendida (solo hay ingreso), 
						e indirectamente solo cuando el Concepto de Ingreso es diferente de 00=Producto --->
				<cfquery datasource="#Arguments.Conexion#">
					update OCPTmovimientos
					   set OCPTMcantidad		= 0
					   	 , OCPTMmontoOrigen		= 0
						 , OCPTMmontoLocal		= 0
						 , OCPTMmontoValuacion	= 0
						 , OCPTMtipoCambioVal	= #rsOC_DST.EDtipocambioVal#
						 , OCPTMfechaCV			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where OCPTMid = #LvarOCPTMid#
				</cfquery>
			<cfelseif rsOC_DST.OCtipoIC EQ "V">
			<!--- VENTAS DIRECTAS DE ALMACEN --->
				<!--- 
					Venta Directa de Almacen:
					Debito CV		CV Costo de Inventario
					Credito IV				TR Costo de Inventario
				--->
				<!--- Costo de Inventario --->
				<cfif OCPTMtipoES EQ "S">
					<cfset LvarObtenerCosto	= true>
					<cfset LvarCostoOrigen	= 0>
					<cfset LvarCostoLocal	= 0>
				<cfelse>
					<!---
					SE APLICA INCORRECTAMENTE LAS DEVOLUCIONES (NC) A INVENTARIOS CON EL COSTO ACTUAL DE ALMACEN
					<cf_errorCode	code = "51539" msg = "No se ha implementado devoluciones (NC) a inventarios">
					<cfset LvarObtenerCosto	= false>
					<cfset LvarCostoOrigen	= CostoOriginalDeLaVenta>
					<cfset LvarCostoLocal	= CostoOriginalDeLaVenta*rsEDocumentoCxC.Dtipocambio>
					--->
					<cfset LvarObtenerCosto	= true>
					<cfset LvarCostoOrigen	= 0>
					<cfset LvarCostoLocal	= 0>
				</cfif>

				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Dcodigo, Ocodigo
					  from Almacen
					 where Aid = #rsOC_DST.Alm_Aid#
				</cfquery>
				
				<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable	="LvarCOSTOS">
					<cfinvokeargument name="Aid"    			value="#rsOC_DST.Aid#">
					<cfinvokeargument name="Alm_Aid"    		value="#rsOC_DST.Alm_Aid#">
					<cfinvokeargument name="Tipo_Mov"    		value="S">
					<cfinvokeargument name="Tipo_ES"    		value="#OCPTMtipoES#">
					<cfinvokeargument name="Cantidad"    		value="#abs(LvarOCPTMcantidad)#">
					<cfinvokeargument name="ObtenerCosto"    	value="#LvarObtenerCosto#">
					<cfinvokeargument name="CostoOrigen"    	value="#LvarCostoOrigen#">
					<cfinvokeargument name="CostoLocal"    		value="#LvarCostoLocal#">
					<cfinvokeargument name="tcValuacion"    	value="#rsOC_DST.EDtipocambioVal#">
					<cfinvokeargument name="Dcodigo"    		value="#rsSQL.Dcodigo#">
					<cfinvokeargument name="Ocodigo"    		value="#rsSQL.Ocodigo#">
					<cfinvokeargument name="Documento"    		value="#rsOC_DST.Ddocumento#">
					<cfinvokeargument name="Referencia"    		value="#rsOC_DST.CCTcodigo#">
					<cfinvokeargument name="FechaDoc"    		value="#rsOC_DST.OCPTMfechaTC#">
					<cfinvokeargument name="Conexion"    		value="#Arguments.Conexion#">
					<cfinvokeargument name="Ecodigo"    		value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#"><!--- Usuario --->
					<cfinvokeargument name="transaccionactiva"  value="true">                    
				</cfinvoke>

				<cfif OCPTMtipoES EQ "S">
					<cfset LvarOCPTMmontoValuacion		= -abs(LvarCOSTOS.VALUACION.Costo)>
					<cfset LvarOCPTMmontoLocal			= -abs(LvarCOSTOS.LOCAL.Costo)>
					<cfset LvarOCPTMmontoOrigen			= -abs(LvarOCPTMmontoLocal)	/ rsOC_DST.Dtipocambio>
				<cfelse>
					<cfset LvarOCPTMmontoValuacion		= abs(LvarCOSTOS.VALUACION.Costo)>
					<cfset LvarOCPTMmontoLocal			= abs(LvarCOSTOS.LOCAL.Costo)>
					<cfset LvarOCPTMmontoOrigen			= abs(LvarOCPTMmontoLocal)	/ rsOC_DST.Dtipocambio>
				</cfif>

				<!--- Cuenta de Inventario --->
				<cfset rsExistencias = fn_rsExistencias(Arguments.Ecodigo, rsOC_DST.Aid, rsOC_DST.Alm_Aid, Arguments.Conexion)>

				<!--- Crédito Cuenta Inventario: credito * -(-abs(LvarCOSTOS.VALUACION.Costo)) es normal positivo ---> 
				<!--- No se guarda en el detalle porque no se toma en cuenta para ningun ajuste --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #request.INTARC# ( 
							INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, 
							Ccuenta, CFcuenta, Ocodigo,
							Mcodigo, INTMOE, INTCAM, INTMON
						)
					values (
							'CCFC',	1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#:#Arguments.Ddocumento#">,
							'OC:#rsOC_DST.OCcontrato#',

							'C',
							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="OC-D.#rsOC_DST.OCcontrato#,INVENTARIO ALMACEN #rsExistencias.Almcodigo#,ART.#rsExistencias.Acodigo#: #rsExistencias.Adescripcion#">,
							'#dateFormat(rsOC_DST.OCPTMfechaTC,"YYYYMMDD")#',
							#Arguments.Periodo#,
							#Arguments.Mes#,

							0,
							#rsExistencias.CFcuenta#,
							#rsExistencias.Ocodigo#,
			
							#LvarMcodigoValuacion#,
							#-LvarOCPTMmontoValuacion#,
							#LvarCOSTOS.VALUACION.TC#,
							#-LvarOCPTMmontoLocal#
						)
				</cfquery>

				<!--- DEBITO Costo Ventas: CV es normal credito * -abs(LvarCOSTOS.VALUACION.Costo) es normal negativo --->
				<!--- Se guarda en el detalle para consultas (IN-CV) pero no se toma en cuenta para ningun ajuste --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #OC_Detalle#
						(
							Tipo, OCPTMid,
							OCTid, Aid, OCid, SNid, OCCid,
							Ocodigo, Alm_Aid, CFcuenta,

							OCid_O, OCTTid, OCid_D,  

							OCPTDmontoLocal, OCPTDmontoValuacion
						)
					values (
							'CV', #LvarOCPTMid#,
							#rsOC_DST.OCTid#, #rsOC_DST.Aid#, #rsOC_DST.OCid#, -2, 00,
							#rsOC_DST.Ocodigo#, #rsOC_DST.Alm_Aid#, null,

							null, null, #rsOC_DST.OCid#,

							#LvarOCPTMmontoLocal#, 
							#LvarOCPTMmontoValuacion#
						)
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#">
					update OCPTmovimientos
					   set OCPTMcantidad		= #LvarOCPTMcantidad#
					   	 , OCPTMmontoOrigen		= #LvarOCPTMmontoOrigen#		<!--- OJO ESTE DATO NO ESTOY SEGURO --->
						 , OCPTMmontoLocal		= #LvarOCPTMmontoLocal#
						 , OCPTMmontoValuacion	= #LvarOCPTMmontoValuacion#
						 , OCPTMtipoCambioVal	= #rsOC_DST.EDtipocambioVal#
						 , OCPTMfechaCV			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where OCPTMid = #LvarOCPTMid#
				</cfquery>
			<cfelse>
			<!--- VENTAS DE TRANSITO --->
				<!--- 1. Actualiza Saldos: OCproductoTransito --->
				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select OCTid, Aid, OCPTtransformado, 
							OCPTentradasCantidad, OCPTentradasCostoTotal, OCPTsalidasCantidad, OCPTsalidasCostoTotal,
							OCPTventasCantidad, OCPTventasMontoTotal
					  from OCproductoTransito
					 where OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>
	
				<cfif rsPT.OCTid EQ "">
					<cf_errorCode	code = "51540"
									msg  = "Costo de Venta de Orden Comercial de Transito: No se ha registrado Entradas para: Transporte=@errorDat_1@, Artículo=@errorDat_2@, Orden Comercial=@errorDat_3@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#rsOC_DST.OCcontrato#"
					>
				<cfelseif rsPT.OCPTentradasCantidad EQ 0>
					<cf_errorCode	code = "51541"
									msg  = "Costo de Venta de Orden Comercial de Transito: No hay entradas para: Transporte=@errorDat_1@ (id=@errorDat_2@), Artículo=@errorDat_3@ (id=@errorDat_4@), Orden Comercial=@errorDat_5@ (id=@errorDat_6@)"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.OCTid#"
									errorDat_3="#rsOC_DST.Acodigo#"
									errorDat_4="#rsOC_DST.Aid#"
									errorDat_5="#rsOC_DST.OCcontrato#"
									errorDat_6="#rsOC_DST.OCid#"
					>
				</cfif>
	
				<cfset LvarOCPTentradasCantidad		= rsPT.OCPTentradasCantidad>
				<cfset LvarOCPTentradasCostoTotal	= round(rsPT.OCPTentradasCostoTotal * 100) / 100>
				<cfset LvarOCPTcostoUnitario		= LvarOCPTentradasCostoTotal 	/ LvarOCPTentradasCantidad>
				<cfset LvarOCPTsalidasCantidad		= rsPT.OCPTsalidasCantidad 		+ LvarOCPTMcantidad>
				<cfset LvarOCPTsalidasCostoTotal	= round(LvarOCPTsalidasCantidad * LvarOCPTcostoUnitario * 100) / 100>
				<cfset LvarExistenciasAnt			= LvarOCPTentradasCantidad 	+ rsPT.OCPTsalidasCantidad>
				<cfset LvarExistencias 				= LvarOCPTentradasCantidad 	+ LvarOCPTsalidasCantidad>
				<cfset LvarCambioCantidad			= (LvarOCPTMcantidad NEQ 0)>
	
				<cfset LvarOCPTMmontoValuacion		= LvarOCPTcostoUnitario		* LvarOCPTMcantidad>
				<cfset LvarOCPTMmontoLocal			= LvarOCPTMmontoValuacion	* rsOC_DST.EDtipocambioVal>
				<cfset LvarOCPTMmontoOrigen			= LvarOCPTMmontoLocal		/ rsOC_DST.Dtipocambio>

				<!--- DC-CV: VERIFICA CONSISTENCIA DE SALDOS: ENTRADAS, SALIDAS Y EXISTENCIAS (con holgura ) --->
				<cfif LvarOCPTentradasCantidad LT 0 OR LvarOCPTentradasCostoTotal LT 0>
					<cf_errorCode	code = "51542"
									msg  = "Costo de Venta de Orden Comercial de Transito: Error de datos, las Entradas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, Orden Comercial=@errorDat_3@, EntradasCantidadTotal=@errorDat_4@, EntradasCostoTotal=@errorDat_5@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#rsOC_DST.OCcontrato#"
									errorDat_4="#rsPT.OCPTentradasCantidad#"
									errorDat_5="#numberFormat(rsPT.OCPTentradasCostoTotal,",9.99")#"
					>
				<cfelseif LvarOCPTsalidasCantidad GT 0 OR LvarOCPTsalidasCostoTotal GT 0>
					<cf_errorCode	code = "51543"
									msg  = "Costo de Venta de Orden Comercial de Transito: Error de datos, las Salidas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, Orden Comercial=@errorDat_3@, SalidasCantidadTotal=@errorDat_4@, SalidasCostoTotal=@errorDat_5@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#rsOC_DST.OCcontrato#"
									errorDat_4="#-rsPT.OCPTsalidasCantidad#"
									errorDat_5="#numberFormat(-rsPT.OCPTsalidasCostoTotal,",9.99")#"
					>
				<cfelseif rsPT.OCPTventasCantidad LT 0 OR rsPT.OCPTventasMontoTotal LT 0>
					<cf_errorCode	code = "51544"
									msg  = "Costo de Venta de Orden Comercial de Transito: Error de datos, las Ventas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, Orden Comercial=@errorDat_3@, VentasCantidadTotal=@errorDat_4@, VentasMontoTotal=@errorDat_5@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#rsOC_DST.OCcontrato#"
									errorDat_4="#rsPT.OCPTventasCantidad#"
									errorDat_5="#numberFormat(rsPT.OCPTventasMontoTotal,",9.99")#"
					>
				<cfelseif LvarExistencias LT 0>
					<cfset LvarTolerancia = fnLeeParametro(442,"Porcentaje permitido para Existencias Negativas de Tránsito","1")>
					<cfif -LvarExistencias / LvarOCPTentradasCantidad * 100 GT LvarTolerancia>
						<cf_errorCode	code = "51545"
										msg  = "Costo de Venta de Orden Comercial de Transito: No se permite sacar de Tránsito más cantidad que la existente en el Transporte: Transporte=@errorDat_1@, Artículo=@errorDat_2@, Orden Comercial=@errorDat_3@, ExistenciasAnteriores=@errorDat_4@, Movimiento=@errorDat_5@, Existencias=@errorDat_6@"
										errorDat_1="#rsOC_DST.OCTtransporte#"
										errorDat_2="#rsOC_DST.Acodigo#"
										errorDat_3="#rsOC_DST.OCcontrato#"
										errorDat_4="#LvarExistenciasAnt#"
										errorDat_5="#LvarOCPTMcantidad#"
										errorDat_6="#LvarExistencias#"
						>
					</cfif>
				</cfif>
	
				<cfquery datasource="#Arguments.Conexion#">
					update OCproductoTransito
					   set OCPTsalidasCantidad 		= #LvarOCPTsalidasCantidad#, 
						   OCPTsalidasCostoTotal 	= #LvarOCPTsalidasCostoTotal#
					 where OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">
					update OCPTmovimientos
					   set OCPTMcantidad		= #LvarOCPTMcantidad#
					   	 , OCPTMmontoOrigen		= #LvarOCPTMmontoOrigen#		<!--- OJO ESTE DATO NO ESTOY SEGURO --->
						 , OCPTMmontoLocal		= #LvarOCPTMmontoLocal#
						 , OCPTMmontoValuacion	= #LvarOCPTMmontoValuacion#
						 , OCPTMtipoCambioVal	= #rsOC_DST.EDtipocambioVal#
						 , OCPTMfechaCV			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 where OCPTMid = #LvarOCPTMid#
				</cfquery>
				
				<!--- Movimientos Contables --->
				<cfset LvarOCPTMtipoCambioVal = rsOC_DST.EDtipocambioVal>
				<cfset sbGenera_Destinos(Arguments.Ecodigo, 'CV', Arguments.conexion)>
			</cfif>	
		</cfloop>

		<!--- Generar detalles --->
		<cfset sbGenerarDetalles(Arguments.Periodo, Arguments.Mes, Arguments.conexion)>
		<cfset sbGenerarINTARC('CCCV', Arguments.Ddocumento, Arguments.CCTcodigo, Arguments.Periodo, Arguments.Mes, Arguments.Conexion)>
	</cffunction>

	<!--- Destino Entrada a Inventarios --->
	<cffunction name="OC_Aplica_OCDI" access="public">
		
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="OCIid"			type="numeric"	required="yes">
		<cfargument name="VerAsiento"		type="boolean"	required="yes">
		<cfargument name="conexion"			type="string" 	required="yes">

		<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")>
		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
	
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(Arguments.Conexion)>
		<cfset OC_DETALLE 	= OC_CreaTablas(Arguments.Conexion)>

		<cftransaction>
			<!--- Período de Auxiliares --->
			<cfset LvarAnoAux = fnLeeParametro(50,"Período de Auxiliares")>
			<cfset LvarMesAux = fnLeeParametro(60,"Mes de Auxiliares")>
	
			<cfquery name="rsOC_DI" datasource="#Arguments.Conexion#">
				select 	e.Ecodigo, e.OCIid, e.OCInumero, e.OCIfecha,
						e.OCItipoOD, e.Alm_Aid, alm.Almcodigo, alm.Ocodigo, alm.Dcodigo, 
						e.OCid, oc.OCcontrato, oc.OCtipoOD, oc.OCtipoIC
				  from OCinventario e
					inner join Almacen alm
						 on alm.Aid = e.Alm_Aid
					left join OCordenComercial oc
						 on oc.OCid = e.OCid
				  where e.Ecodigo 	= #Arguments.Ecodigo#
					and e.OCIid		= #Arguments.OCIid#
			</cfquery>
			<cfif rsOC_DI.OCIid EQ "">
				<cf_errorCode	code = "51546"
								msg  = "OC_DI Costo Entradas Inventario: Documento ID=@errorDat_1@ no existe"
								errorDat_1="#Arguments.OCIid#"
				>
			<cfelseif rsOC_DI.OCItipoOD NEQ "D">
				<cf_errorCode	code = "51547"
								msg  = "OC_DI Costo Entradas Inventario: Documento @errorDat_1@ no es tipo Destino Entrada a Inventario"
								errorDat_1="#rsOC_DI.OCInumero#"
				>
			<cfelseif rsOC_DI.Alm_Aid EQ "">
				<cf_errorCode	code = "51548"
								msg  = "Costo OCDI:Documento @errorDat_1@ no indicó Almacén de Entrada"
								errorDat_1="#rsOC_DI.OCInumero#"
				>
			<cfelseif rsOC_DI.OCid NEQ "" AND (rsOC_DI.OCtipoOD NEQ "D" OR rsOC_DI.OCtipoIC NEQ "I")>
				<cf_errorCode	code = "51549"
								msg  = "OC_DI Costo Entradas Inventario: Documento @errorDat_1@ tiene la Orden Comercial @errorDat_2@ que no es tipo Destino Inventario"
								errorDat_1="#rsOC_DI.OCInumero#"
								errorDat_2="#rsOC_DI.OCcontrato#"
				>
			</cfif>
	
			<!--- Moneda de Valuación --->
			<cfinvoke 
				component		= "sif.Componentes.IN_PosteoLin" 
				method			= "IN_MonedaValuacion"  
				returnvariable	= "LvarCOSTOS"
	
				Ecodigo			= "#Arguments.Ecodigo#"
				tcFecha			= "#rsOC_DI.OCIfecha#"
	
				Conexion		= "#Arguments.Conexion#"
			/>
	
			<cfset LvarMcodigoValuacion		= LvarCostos.VALUACION.Mcodigo>
			<cfset LvarTipoCambioValuacion	= LvarCostos.VALUACION.TC>
	
			<cfif rsOC_DI.OCid NEQ "">
				<cfset LvarOCid = rsOC_DI.OCid>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into OCordenComercial
						(
						   OCtipoOD,
						   OCtipoIC,
						   Ecodigo,
						   OCcontrato,
						   OCfecha,
						   Mcodigo,
						   OCVid,
						   OCestado,
						   OCmodulo
						)
					values
						(
							'D', 'I', #Arguments.Ecodigo#, 'OCDI-#rsOC_DI.OCInumero#', 
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_DI.OCIfecha#">, 
							#LvarMcodigoValuacion#, null, 'C', 'OCDI'
						)
					<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCid">
	
				<cfquery datasource="#Arguments.Conexion#">
					update OCinventario
					   set OCid 	= #LvarOCid#
					 where OCIid	= #Arguments.OCIid#
				</cfquery>
			</cfif>
				
			<cfquery name="rsOC_DST" datasource="#Arguments.Conexion#">
				select 	
						#LvarOCid# as OCid, 
						e.Ecodigo, 
						d.OCTid, d.Aid, d.OCIcantidad, 
						a.Acodigo, a.Adescripcion, a.Ucodigo,
						t.OCTtipo, t.OCTtransporte
					from OCinventario e
						inner join OCinventarioProducto d
							 on d.OCIid=e.OCIid
						inner join OCtransporte t
							 on t.OCTid = d.OCTid
						inner join Articulos a
							 on a.Aid = d.Aid
				  where e.OCIid		= #Arguments.OCIid#
			</cfquery>
	
			<cfloop query="rsOC_DST">
				<cfquery name="rsPT" datasource="#Arguments.Conexion#">
					select 	pt.OCPTentradasCantidad, 
							pt.OCPTentradasCostoTotal, 
							pt.OCPTsalidasCantidad, 
							pt.OCPTsalidasCostoTotal, 
							pt.OCPTtransformado
					  from OCproductoTransito pt
					 where OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>

				<cfif rsOC_DST.OCIcantidad EQ 0>
					<cf_errorCode	code = "51550" msg = "OC_DI Costo Entradas Inventario: No se permite una Entrada a Inventario sin cantidad">
				<cfelseif rsOC_DST.OCIcantidad LT 0>
					<cf_errorCode	code = "51551" msg = "OC_DI Costo Entradas Inventario: No se permite una Entrada a Inventario negativa">
				<cfelseif rsPT.OCPTentradasCantidad EQ 0>
					<cf_errorCode	code = "51552" msg = "OC_DI Costo Entradas Inventario: No hay existencias para Articulo">
				</cfif>
	
				<!--- Incluye automaticamente OCordenProducto --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select count(1) as cantidad
					  from OCordenProducto
					 where OCid	= #rsOC_DST.OCid#
					   and Aid	= #rsOC_DST.Aid#
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfquery datasource="#Arguments.Conexion#">
						insert into OCordenProducto
							(
								OCid,
								Aid,
								OCPlinea,
								Ucodigo,
								Ecodigo,
								OCPcantidad,
								OCPprecioUnitario,
								OCPprecioTotal
							)
						values
							(
								#LvarOCid#,
								#rsOC_DST.Aid#,
								#rsOC_DST.currentRow#,
								'#rsOC_DST.Ucodigo#',
								#rsOC_DST.Ecodigo#,
								#rsOC_DST.OCIcantidad#,
								#rsPT.OCPTentradasCostoTotal/rsPT.OCPTentradasCantidad#,
								#rsPT.OCPTentradasCostoTotal/rsPT.OCPTentradasCantidad*rsOC_DST.OCIcantidad#
							)
					</cfquery>
				</cfif>
	
				<!--- Incluye automaticamente OCtransporteProducto --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select count(1) as cantidad
					  from OCtransporteProducto
					 where OCTid	= #rsOC_DST.OCTid#
					   and OCid		= #rsOC_DST.OCid#
					   and Aid		= #rsOC_DST.Aid#
					   and OCtipoOD	= 'D'
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfquery datasource="#Arguments.Conexion#">
						insert into OCtransporteProducto
							(
								OCTid,
								OCid,
								Aid,
								Ecodigo,
								OCtipoOD,
	
								OCTPcantidadTeorica,
								OCTPprecioUniTeorico,
								OCTPprecioTotTeorico,
								OCTPcantidadReal,
								OCTPprecioReal
							)
						values
							(
								#rsOC_DST.OCTid#,
								#LvarOCid#,
								#rsOC_DST.Aid#,
								#rsOC_DST.Ecodigo#,
								'D',
								
								#rsOC_DST.OCIcantidad#,
								#rsPT.OCPTentradasCostoTotal/rsPT.OCPTentradasCantidad#,
								#rsPT.OCPTentradasCostoTotal/rsPT.OCPTentradasCantidad*rsOC_DST.OCIcantidad#,
								#rsOC_DST.OCIcantidad#,
								#rsPT.OCPTentradasCostoTotal/rsPT.OCPTentradasCantidad#
							)
					</cfquery>
				</cfif>
	
				<cfset LvarOCPTMtipoES			= "S">
				<cfset LvarOCPTMcantidad		= -rsOC_DST.OCIcantidad>
				<cfset LvarOCPTcostoUnitario	= rsPT.OCPTentradasCostoTotal / rsPT.OCPTentradasCantidad>

				<!--- Todos estos montos tienen el mismo signo que LvarOCPTMcantidad --->
				<cfset LvarOCPTMmontoValuacion	= LvarOCPTMcantidad*LvarOCPTcostoUnitario>
				<cfset LvarOCPTMmontoOrigen		= LvarOCPTMmontoValuacion>
				<cfset LvarOCPTMmontoLocal		= LvarOCPTMmontoValuacion * LvarTipoCambioValuacion>
	
				<cfset LvarOCPTsalidasCantidad	= rsPT.OCPTsalidasCantidad + LvarOCPTMcantidad>
				<cfset LvarOCPTsalidasCosto		= LvarOCPTsalidasCantidad * LvarOCPTcostoUnitario>
				<cfset LvarExistenciasAnt		= rsPT.OCPTentradasCantidad + rsPT.OCPTsalidasCantidad>
				<cfset LvarExistencias 			= rsPT.OCPTentradasCantidad + LvarOCPTsalidasCantidad>
	
				<!--- DI-CInv: VERIFICA CONSISTENCIA DE SALDOS: ENTRADAS, SALIDAS Y EXISTENCIAS (sin holgura ) --->
				<cfif rsPT.OCPTentradasCantidad LT 0 OR rsPT.OCPTentradasCostoTotal LT 0>
					<cf_errorCode	code = "51553"
									msg  = "OC_DI Costo Entradas Inventario: Error de datos, las Entradas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, EntradasCantidadTotal=@errorDat_3@, EntradasCostoTotal=@errorDat_4@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#rsPT.OCPTentradasCantidad#"
									errorDat_4="#numberFormat(rsPT.OCPTentradasCostoTotal,",9.99")#"
					>
				<cfelseif LvarOCPTsalidasCantidad GT 0 OR LvarOCPTsalidasCosto GT 0>
					<cf_errorCode	code = "51554"
									msg  = "OC_DI Costo Entradas Inventario: Error de datos, las Salidas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, SalidasCantidadAnterior=@errorDat_3@, Movimiento=@errorDat_4@, SalidasCantidadTotal=@errorDat_5@"
									errorDat_1="#rsOC_DST.OCTtransporte#"
									errorDat_2="#rsOC_DST.Acodigo#"
									errorDat_3="#-rsPT.OCPTsalidasCantidad#"
									errorDat_4="#LvarOCPTMcantidad#"
									errorDat_5="#-LvarOCPTsalidasCantidad#"
					>
				<cfelseif LvarExistencias LT 0>
					<cfset LvarTolerancia = fnLeeParametro(442,"Porcentaje permitido para Existencias Negativas de Tránsito","1")>
					<cfif -LvarExistencias / rsPT.OCPTentradasCantidad * 100 GT LvarTolerancia>
						<cf_errorCode	code = "51555"
										msg  = "OC_DI Costo Entradas Inventario: No se permite sacar de Tránsito más cantidad que la existente en el Transporte: Transporte=@errorDat_1@, Artículo=@errorDat_2@, ExistenciasAnteriores=@errorDat_3@, Movimiento=@errorDat_4@, Existencias=@errorDat_5@, Tolerancia=@errorDat_6@%"
										errorDat_1="#rsOC_DST.OCTtransporte#"
										errorDat_2="#rsOC_DST.Acodigo#"
										errorDat_3="#LvarExistenciasAnt#"
										errorDat_4="#LvarOCPTMcantidad#"
										errorDat_5="#LvarExistencias#"
										errorDat_6="#numberFormat(LvarTolerancia,"9.99")#"
						>
					</cfif>
				</cfif>
	
				<!--- Salida de OCproductoTransito --->
				<cfquery datasource="#Arguments.Conexion#">
					update OCproductoTransito
					   set OCPTsalidasCantidad 		= #LvarOCPTsalidasCantidad#, 
						   OCPTsalidasCostoTotal 	= #LvarOCPTsalidasCosto#
					 where OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>
	
				<!--- Costo en OCinventarioProducto --->
				<cfquery datasource="#Arguments.Conexion#">
					update OCinventarioProducto
					   set OCIcostoValuacion = #abs(LvarOCPTMmontoValuacion)#
					 where OCIid = #Arguments.OCIid#
					   and OCTid = #rsOC_DST.OCTid#
					   and Aid	 = #rsOC_DST.Aid#
				</cfquery>
	
				<!--- Registra Movimiento: OCPTmovimientos de Destino Inventario = Recepcion en Almacén --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into OCPTmovimientos
						(
							OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
							OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES,
							OCPTMfechaCV,
							
							Ocodigo, Alm_Aid,
							Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
							OCPTMfecha, OCPTMfechaTC,
							Ecodigo, Ucodigo, OCPTMcantidad,
							McodigoOrigen, OCPTMmontoOrigen, OCPTMmontoLocal, 
							OCPTMmontoValuacion, OCPTMtipoCambioVal,
							BMUsucodigo
						)
					values (
							#rsOC_DST.OCTid#, #rsOC_DST.Aid#, #LvarOCid#, null, null, null, null, 
							'D', 'I',				<!--- Destino + Inventario = Entradas a Inventario--->
							'S',					<!--- Salida de Transito --->
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							
							#rsOC_DI.Ocodigo#, #rsOC_DI.Alm_Aid#,		<!--- Almacen Destino --->
							'OCDI', '#rsOC_DI.OCInumero#', null, #rsOC_DST.recordCount#, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_DI.OCIfecha#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_DI.OCIfecha#">,
							#rsOC_DI.Ecodigo#, '#rsOC_DST.Ucodigo#', #LvarOCPTMcantidad#,
							#LvarMcodigoValuacion#, #LvarOCPTMmontoOrigen#, #LvarOCPTMmontoLocal#, 
							#LvarOCPTMmontoValuacion#, #LvarTipoCambioValuacion#,
							#session.Usucodigo#
						)
					<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">

				<!--- Movimientos Contables --->
				<cfset LvarOCPTMtipoCambioVal = LvarTipoCambioValuacion>
				<cfset sbGenera_Destinos(Arguments.Ecodigo, 'DI', Arguments.conexion)>

				<!--- OC Destino Entradas a Inventario: Incluye Costo y Cantidad al Almacén --->
				<cfset OCDI_PosteoLin (Arguments.Ecodigo, rsOC_DI.OCInumero, "OCDI", rsOC_DI.OCIfecha, LvarOCPTMid, -LvarOCPTMcantidad, LvarMcodigoValuacion, Arguments.conexion)>
			</cfloop>
				
			<!--- Generar detalles --->
			<cfset sbGenerarDetalles(LvarAnoAux, LvarMesAux, Arguments.conexion)>
			<cfset sbGenerarINTARC('OCDI', rsOC_DI.OCInumero, "OCDI", LvarAnoAux, LvarMesAux, Arguments.Conexion, rsOC_DI.Almcodigo)>

			<!--- Genera el Asiento Contable --->
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "GeneraAsiento" 
						returnvariable	= "LvarIDcontable"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
				<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
				<cfinvokeargument name="Efecha"			value="#rsOC_DI.OCIfecha#"/>
				<cfinvokeargument name="Oorigen"		value="OCDI"/>
				<cfinvokeargument name="Edocbase"		value="#rsOC_DI.OCInumero#"/>
				<cfinvokeargument name="Ereferencia"	value=""/>						
				<cfinvokeargument name="Edescripcion"	value="Ordenes Comerciales Destino Inventario: Recepcion de Tránsito"/>
				<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
			</cfinvoke>

			<!--- Actualizar el IDcontable del Kardex --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update Kardex 
				   set IDcontable = #LvarIDcontable#
				where Kid IN
					(
						select Kid
						   from #IDKARDEX#
					)
			</cfquery>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				update OCinventario
				   set OCIfechaAplicacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				     , UsucodigoAplicacion = #session.Usucodigo#
				where OCIid		= #Arguments.OCIid#
			</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="OCDI_PosteoLin" access="private"	returntype="void">
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="Documento"		type="string"	required="yes">
		<cfargument name="Referencia"		type="string"	required="yes">
		<cfargument name="Fecha"			type="date"		required="yes">
		<cfargument name="OCPTMid"			type="numeric"	required="yes">
		<cfargument name="Cantidad"			type="numeric"	required="yes">
		<cfargument name="McodigoValuacion"	type="numeric"	required="yes">

		<cfargument name="conexion"		type="string" 	required="yes">
		
		<cfquery name="rsMovsInventario" datasource="#Arguments.Conexion#">
			select  Aid, Alm_Aid, 
					round(sum(OCPTDmontoLocal),2) as montoLocal, round(sum(OCPTDmontoValuacion),2) as montoValuacion
			  from #OC_Detalle#
			 where Tipo = 'DI'
			 <cfif Arguments.OCPTMid NEQ 0>
			 	and OCPTMid = #Arguments.OCPTMid#
			 </cfif>
			 group by Aid, Alm_Aid
		</cfquery>

		<cfloop query="rsMovsInventario">
			<cfif rsMovsInventario.montoValuacion NEQ 0>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Dcodigo, Ocodigo
					  from Almacen
					 where Aid = #rsMovsInventario.Alm_Aid#
				</cfquery>
				
				<!--- Entrada a Inventario --->
				<cfinvoke 
					component		= "sif.Componentes.IN_PosteoLin" 
					method			= "IN_PosteoLin"  
					returnvariable	= "LvarCOSTOS"
	
					Aid				= "#rsMovsInventario.Aid#"
					Alm_Aid			= "#rsMovsInventario.Alm_Aid#"
					Tipo_Mov		= "E"
	
					Tipo_ES			= "E"
					Cantidad		= "#Arguments.Cantidad#"
	
					ObtenerCosto	= "false"
					McodigoOrigen	= "#Arguments.McodigoValuacion#"
					CostoOrigen		= "#-rsMovsInventario.montoValuacion#"
					CostoLocal		= "#-rsMovsInventario.montoLocal#"
					tcValuacion		= "#rsMovsInventario.montoLocal / rsMovsInventario.montoValuacion#"
	
					Dcodigo			= "#rsSQL.Dcodigo#"
					Ocodigo			= "#rsSQL.Ocodigo#"
					Documento		= "#Arguments.Documento#"
					Referencia		= "#Arguments.Referencia#"
					FechaDoc		= "#Arguments.Fecha#"
					Conexion		= "#Arguments.Conexion#"
					Ecodigo			= "#Arguments.Ecodigo#"
					transaccionactiva="true"
				/>
			</cfif>
			
			<!--- Cuenta de Inventario --->
			<cfset rsExistencias = fn_rsExistencias(Arguments.Ecodigo, rsMovsInventario.Aid, rsMovsInventario.Alm_Aid, Arguments.Conexion)>

			<cfquery datasource="#Arguments.Conexion#">
				update #OC_Detalle#
				   set CFcuenta = #rsExistencias.CFcuenta#
				     , Ocodigo	= #rsExistencias.Ocodigo#
				 where Tipo 	= 'DI'
				 <cfif Arguments.OCPTMid NEQ 0>
					and OCPTMid = #Arguments.OCPTMid#
				 </cfif>
				   and Aid		= #rsExistencias.Aid#
				   and Alm_Aid	= #rsExistencias.Alm_Aid#
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="sbGenera_Destinos" access="private">
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="Tipo"				type="string"	required="yes">

		<cfargument name="conexion"			type="string" 	required="yes">

		<cfif rsPT.OCPTtransformado EQ "0">
			<!--- 
				Producto no Transformado:
					Debito CV		CV MontoCadaOrigen_OI_OC / entradasCantidad * CantidadMovimiento_DC
					Debito DI		DI MontoCadaOrigen_OI_OC / entradasCantidad * CantidadMovimiento_DI
					Credito TR			TR MontoCadaOrigen_OI_OC / entradasCantidad * CantidadMovimiento
			--->

			<!--- CREDITO: TR es normal debito * LvarOCPTMcantidad es normal negativo --->
			<!--- Saca del Transito del Producto --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #OC_Detalle#
					(
						Tipo, OCPTMid,
						OCTid, Aid, OCid, SNid, OCCid,
						Ocodigo, Alm_Aid, CFcuenta,

						OCid_O, OCTTid, OCid_D,  

						OCPTDmontoLocal, OCPTDmontoValuacion
					)
				select 	'TR', #LvarOCPTMid#,
						MOVs_ORI.OCTid, MOVs_ORI.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
						MOVs_ORI.Ocodigo, null, null,

						MOVs_ORI.OCid, null, #rsOC_DST.OCid#,

						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad# * #LvarOCPTMtipoCambioVal#, 
						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad#
				  from OCPTmovimientos MOVs_ORI
					inner join OCproductoTransito PTO
						 on PTO.OCTid		= MOVs_ORI.OCTid
						and PTO.Aid			= MOVs_ORI.Aid
				 where MOVs_ORI.OCTid		= #rsOC_DST.OCTid#
				   and MOVs_ORI.Aid			= #rsOC_DST.Aid#
				   and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->

				   and MOVs_ORI.OCPTMmontoValuacion <> 0					<!--- Monto a Distribuir --->
				   and PTO.OCPTentradasCantidad <> 0						<!--- Division por cero --->

				   and #LvarOCPTMcantidad# <> 0								<!--- Cantidad a Distribuir --->
			</cfquery>

			<!--- DEBITO: CV es normal credito * LvarOCPTMcantidad es normal negativo --->
			<!--- DEBITO: DI es normal credito * LvarOCPTMcantidad es normal negativo --->
			<!--- Mete al Costo del Producto --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #OC_Detalle#
					(
						Tipo, OCPTMid,
						OCTid, Aid, OCid, SNid, OCCid,
						Ocodigo, Alm_Aid, CFcuenta, 
						OCid_O, OCTTid, OCid_D,  

						OCPTDmontoLocal, OCPTDmontoValuacion
					)
				select 	'#Arguments.Tipo#', #LvarOCPTMid#,
						#rsOC_DST.OCTid#, #rsOC_DST.Aid#, #rsOC_DST.OCid#, MOVs_ORI.SNid, MOVs_ORI.OCCid,
						<cfif Arguments.Tipo EQ 'DI'>
							null, #rsOC_DI.Alm_Aid#, null,
						<cfelse>
							#rsOC_DST.Ocodigo#, null,	null,			
						</cfif>

						MOVs_ORI.OCid, null, #rsOC_DST.OCid#,

						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad# * #LvarOCPTMtipoCambioVal#, 
						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad#
				  from OCPTmovimientos MOVs_ORI
					inner join OCproductoTransito PTO
						 on PTO.OCTid		= MOVs_ORI.OCTid
						and PTO.Aid			= MOVs_ORI.Aid
				 where MOVs_ORI.OCTid		= #rsOC_DST.OCTid#
				   and MOVs_ORI.Aid			= #rsOC_DST.Aid#
				   and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->

				   and MOVs_ORI.OCPTMmontoValuacion <> 0					<!--- Monto a Distribuir --->
				   and PTO.OCPTentradasCantidad <> 0						<!--- Division por cero --->

				   and #LvarOCPTMcantidad# <> 0								<!--- Cantidad a Distribuir --->
			</cfquery>
		<cfelse>
			<!--- 
				Producto Transformado:
					Credito TR			TR MontoCadaOrigen_OI_OC_COMPONENTES / entradasCantidad * proporcionDeContenido * CantidadMovimiento
					Debito CV		CV MontoCadaOrigen_OI_OC_COMPONENTE / entradasCantidad * proporcionDeContenido * CantidadMovimiento_DC
					Debito DI		DI MontoCadaOrigen_OI_OC_COMPONENTE / entradasCantidad * proporcionDeContenido * CantidadMovimiento_DI
			--->
			
			<!--- CREDITO: TR es normal debito * LvarOCPTMcantidad es normal negativo --->
			<!--- Saca de transito del Producto Transformado (TTD=Destino de la Transformación) --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #OC_Detalle#
					(
						Tipo, OCPTMid,
						OCTid, Aid, OCid, SNid, OCCid,
						Ocodigo, Alm_Aid, CFcuenta,

						OCid_O, OCTTid, OCid_D,  

						OCPTDmontoLocal, OCPTDmontoValuacion
					)
				select 	'TR', #LvarOCPTMid#, 
						TTD.OCTid, TTD.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
						MOVs_ORI.Ocodigo, null, null,

						MOVs_ORI.OCid, TE.OCTTid, #rsOC_DST.OCid#,

						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad#  * (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst / PTD.OCPTentradasCantidad) * #LvarOCPTMtipoCambioVal#, 
						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad#  * (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst / PTD.OCPTentradasCantidad)
				  from OCtransporteTransformacionD TTD
					inner join OCproductoTransito PTD
						 on PTD.OCTid		= TTD.OCTid
						and PTD.Aid			= TTD.Aid
					inner join OCtransporteTransformacion TE
						  on TE.OCTTid		= TTD.OCTTid
						 and TE.OCTTestado	= 1
					inner join OCtransporteTransformacionD TTO
						inner join OCproductoTransito PTO
							 on PTO.OCTid	= TTO.OCTid
							and PTO.Aid		= TTO.Aid
						inner join OCPTmovimientos MOVs_ORI
							 on MOVs_ORI.OCTid			= TTO.OCTid
							and MOVs_ORI.Aid			= TTO.Aid
							and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
						 on TTO.OCTTid		= TTD.OCTTid
						and TTO.OCTTDtipoOD	= 'O'
				 where TTD.OCTid		= #rsOC_DST.OCTid#
				   and TTD.Aid			= #rsOC_DST.Aid#
				   and TTD.OCTTDtipoOD	= 'D'

				   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
				   and PTO.OCPTentradasCantidad <> 0								<!--- Division por cero --->
				   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
				   and TTD.OCTTDproporcionDst <> 0									<!--- Proporcion a Distribuir --->
				   and PTD.OCPTentradasCantidad <> 0								<!--- Proporcion a Distribuir --->

				   and #LvarOCPTMcantidad# <> 0										<!--- Cantidad a Distribuir --->
			</cfquery>
				 
			<!--- DEBITO: CV es normal credito * LvarOCPTMcantidad es normal negativo --->
			<!--- DEBITO: DI es normal credito * LvarOCPTMcantidad es normal negativo --->
			<!--- Mete al Costo del Producto Transformado (TTD=Destino de la Transformación) --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #OC_Detalle#
					(
						Tipo, OCPTMid,
						OCTid, Aid, OCid, SNid, OCCid,
						Ocodigo, Alm_Aid, CFcuenta,

						OCid_O, OCTTid, OCid_D,  

						OCPTDmontoLocal, OCPTDmontoValuacion
					)
				select 	'#Arguments.Tipo#', #LvarOCPTMid#,
						TTD.OCTid, TTD.Aid, #rsOC_DST.OCid#, MOVs_ORI.SNid, MOVs_ORI.OCCid,
						<cfif Arguments.Tipo EQ 'DI'>
							null, #rsOC_DI.Alm_Aid#, null,
						<cfelse>
							#rsOC_DST.Ocodigo#, null, null,
						</cfif>

						MOVs_ORI.OCid, TE.OCTTid, #rsOC_DST.OCid#,

						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad#  * (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst / PTD.OCPTentradasCantidad) * #LvarOCPTMtipoCambioVal#,  
						(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* #LvarOCPTMcantidad#  * (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst / PTD.OCPTentradasCantidad)
				  from OCtransporteTransformacionD TTD
					inner join OCproductoTransito PTD
						 on PTD.OCTid	= TTD.OCTid
						and PTD.Aid		= TTD.Aid
					inner join OCtransporteTransformacion TE
						  on TE.OCTTid		= TTD.OCTTid
						 and TE.OCTTestado	= 1
					inner join OCtransporteTransformacionD TTO
						inner join OCproductoTransito PTO
							 on PTO.OCTid	= TTO.OCTid
							and PTO.Aid		= TTO.Aid
						inner join OCPTmovimientos MOVs_ORI
							 on MOVs_ORI.OCTid		= TTO.OCTid
							and MOVs_ORI.Aid			= TTO.Aid
							and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
						 on TTO.OCTTid		= TTD.OCTTid
						and TTO.OCTTDtipoOD	= 'O'
				 where TTD.OCTid		= #rsOC_DST.OCTid#
				   and TTD.Aid			= #rsOC_DST.Aid#
				   and TTD.OCTTDtipoOD	= 'D'

				   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
				   and PTO.OCPTentradasCantidad <> 0								<!--- Division por cero --->
				   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
				   and TTD.OCTTDproporcionDst <> 0									<!--- Proporcion a Distribuir --->
				   and PTD.OCPTentradasCantidad <> 0								<!--- Proporcion a Distribuir --->

				   and #LvarOCPTMcantidad# <> 0										<!--- Cantidad a Distribuir --->
			</cfquery>
		</cfif>
	</cffunction>	

	<cffunction name="OC_Aplica_TRANSFORMACION" access="public">
		<cfargument name="Ecodigo"		type="numeric"	required="yes">
		<cfargument name="OCTTid"		type="numeric"	required="yes">
		<cfargument name="VerAsiento"	type="boolean"	required="no" default="no">

		<cfargument name="conexion"		type="string"	required="yes">

		<cfif NOT isdefined("OC_DETALLE")>
			<cfset OC_DETALLE = request.OC_DETALLE>
		</cfif>
				
		<cfquery datasource="#Arguments.Conexion#">
			delete from #OC_DETALLE#
		</cfquery>
	
		<!--- Período de Auxiliares --->
		<cfset LvarAnoAux = fnLeeParametro(50,"Período de Auxiliares")>
		<cfset LvarMesAux = fnLeeParametro(60,"Mes de Auxiliares")>

		<cfquery datasource="#Arguments.Conexion#">
			delete OCtransporteTransformacionD
			 where OCTTid 		= #Arguments.OCTTid#
			   and OCTTDcantidad = 0
		</cfquery>

		<cfquery name="rsOC_TT_E" datasource="#Arguments.Conexion#">
			select 	TT.OCTid, 
					T.OCTtransporte,
					OCTTdocumento,
					OCTTestado, 
					OCTTfecha,
					OCTTmanual,
					(select count(1) from OCtransporteTransformacionD where TT.OCTTid 	= #Arguments.OCTTid# and OCTTDtipoOD='O') as cantidad_Ori,
					(select count(1) from OCtransporteTransformacionD where TT.OCTTid 	= #Arguments.OCTTid# and OCTTDtipoOD='D') as cantidad_Dst
			  from OCtransporteTransformacion TT
			  	inner join OCtransporte T
					on T.OCTid = TT.OCTid
			 where OCTTid 	= #Arguments.OCTTid#
		</cfquery>

		<cfif rsOC_TT_E.recordCount EQ 0>
			<cf_errorCode	code = "51556" msg = "Transformacion de Producto en Transito: El Documento de Transformación no existe">
		<cfelseif rsOC_TT_E.OCTTestado NEQ 0>
			<cf_errorCode	code = "51557"
							msg  = "Transformacion de Producto en Transito: El Documento de Transformación '@errorDat_1@' no está Abierto: '@errorDat_2@'"
							errorDat_1="#rsOC_TT_E.OCTTdocumento#"
							errorDat_2="#rsOC_TT_E.OCTTestado#"
			>
		<cfelseif rsOC_TT_E.cantidad_Ori + rsOC_TT_E.cantidad_Dst EQ 0>
			<cf_errorCode	code = "51558"
							msg  = "Transformacion de Producto en Transito: El Documento de Transformación '@errorDat_1@' está vacío"
							errorDat_1="#rsOC_TT_E.OCTTdocumento#"
			>
		<cfelseif rsOC_TT_E.cantidad_Ori EQ 0>
			<cf_errorCode	code = "51559"
							msg  = "Transformacion de Producto en Transito: El Documento de Transformación '@errorDat_1@' no contiene Artículos Origen"
							errorDat_1="#rsOC_TT_E.OCTTdocumento#"
			>
		<cfelseif rsOC_TT_E.cantidad_Dst EQ 0>
			<cf_errorCode	code = "51560"
							msg  = "Transformacion de Producto en Transito: El Documento de Transformación '@errorDat_1@' no contiene Artículos Destino"
							errorDat_1="#rsOC_TT_E.OCTTdocumento#"
			>
		</cfif>

		<!--- Moneda de Valuación --->
		<cfinvoke 
			component		= "sif.Componentes.IN_PosteoLin" 
			method			= "IN_MonedaValuacion"  
			returnvariable	= "LvarCOSTOS"

			Ecodigo			= "#Arguments.Ecodigo#"
			tcFecha			= "#rsOC_TT_E.OCTTfecha#"

			Conexion		= "#Arguments.Conexion#"
		/>

		<cfset LvarMcodigoValuacion		= LvarCostos.VALUACION.Mcodigo>
		<cfset LvarTipoCambioValuacion	= LvarCostos.VALUACION.TC>

		<cfif rsOC_TT_E.OCTTmanual EQ 1>
			<!--- Actualiza la proporcion de distribucion con la Distribucion Manual --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select 	count(1) as cantidad
				  from OCtransporteTransformacionD
				 where OCTTid 	= #Arguments.OCTTid#
				   and coalesce(OCTTDproporcionManualDst,0) = 0
				   and coalesce(OCTTDcantidad,0) <> 0
				   and OCTTDtipoOD = 'D'
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cf_errorCode	code = "51561" msg = "Transformacion de Producto en Transito: Distribución Manual: No se permiten Procentajes manuales en blanco">
			</cfif>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select 	sum(OCTTDproporcionManualDst) as total
				  from OCtransporteTransformacionD
				 where OCTTid 	= #Arguments.OCTTid#
			</cfquery>
			<cfif rsSQL.total NEQ 100>
				<cf_errorCode	code = "51562" msg = "Transformacion de Producto en Transito: Distribución Manual: El Total de Procentajes manuales no es 100%">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
				update OCtransporteTransformacionD
				   set OCTTDproporcionDst = OCTTDproporcionManualDst / 100.0
				where OCTTid	= #Arguments.OCTTid#
				  and Ecodigo	= #Arguments.Ecodigo#
			</cfquery>
		<cfelse>
			<!--- Actualiza la proporcion de distribucion de costos en el destino = TOTAL_DST / CANT_DST --->
			<cfquery datasource="#Arguments.Conexion#">
				update OCtransporteTransformacionD
				   set OCTTDproporcionDst =
						case 
							when OCTTDtipoOD = 'D' then
								OCTTDcantidad /
									(
										select sum(S.OCTTDcantidad)
										  from OCtransporteTransformacionD S
										 where S.OCTTid			= OCtransporteTransformacionD.OCTTid
										   and S.OCTTDtipoOD	= 'D'
									)
							else 0
						end
				where OCTTid	= #Arguments.OCTTid#
				  and Ecodigo	= #Arguments.Ecodigo#
			</cfquery>
		</cfif>
		
		<cfquery name="rsOC_TT_D" datasource="#Arguments.Conexion#">
			select 	case d.OCTTDtipoOD when 'O' then 1 else 2 end as OrderBy,
					d.OCTTDid,
					d.OCTTDtipoOD, d.OCTid, d.Aid, 
					d.Ecodigo, d.Ucodigo, d.OCTTDcantidad,
					d.OCTTDproporcionDst,
					
					p.OCPTtransformado,
					p.OCPTentradasCantidad,
					p.OCPTentradasCostoTotal,
					p.OCPTsalidasCantidad,
					p.OCPTsalidasCostoTotal,
					
					a.Acodigo
			from OCtransporteTransformacionD d
				inner join OCproductoTransito p
					 on p.OCTid = d.OCTid
					and p.Aid	= d.Aid
				inner join Articulos a
					 on a.Aid = d.Aid
			where d.OCTTid	= #Arguments.OCTTid#
			order by 1
		</cfquery>

		<cfquery name="rsTT_TOTAL" datasource="#Arguments.Conexion#">
			select 	sum(PTO.OCPTentradasCostoTotal / PTO.OCPTentradasCantidad * TTO.OCTTDcantidad) as Costo
			from OCtransporteTransformacionD TTO
					inner join OCproductoTransito PTO
						 on PTO.OCTid	= TTO.OCTid
						and PTO.Aid		= TTO.Aid
			where TTO.OCTTid		= #Arguments.OCTTid#
			  and TTO.OCTTDtipoOD	= 'O'
		</cfquery>

		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
	
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset OC_DETALLE 	= OC_CreaTablas(Arguments.Conexion)>

		<cftransaction>
			<cfloop query="rsOC_TT_D">
				<cfif rsOC_TT_E.OCTid NEQ rsOC_TT_D.OCTid>
					<cf_errorCode	code = "51563"
									msg  = "Transformacion de Producto en Transito: El Articulo '@errorDat_1@' no pertenece al mismo Transporte del Documento de Transformacion"
									errorDat_1="#rsOC_TT_D.Acodigo#"
					>
				</cfif>
	
				<cfquery name="rsTP" datasource="#Arguments.Conexion#">
					select distinct OCtipoOD
					  from OCtransporteProducto
					 where OCTid 	= #rsOC_TT_D.OCTid#
					   and Aid	 	= #rsOC_TT_D.Aid#
					order by OCtipoOD desc
				</cfquery>

				<cfif rsTP.recordCount EQ 0>
					<cf_errorCode	code = "51564"
									msg  = "Transformacion de Producto en Transito: El Articulo '@errorDat_1@' no está registrado en el Transporte"
									errorDat_1="#rsOC_TT_D.Acodigo#"
					>
				</cfif>
				<cfif rsOC_TT_D.OCTTDtipoOD EQ 'O'>
					<!--- Productos Origenes de un Transformación = Producto Mezclado --->
					<cfif rsTP.OCtipoOD NEQ 'O'>
						<cf_errorCode	code = "51565"
										msg  = "Transformacion de Producto en Transito: El Articulo Origen '@errorDat_1@' no está registrado en el Transporte como Origen"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					<cfelseif rsOC_TT_D.OCPTtransformado EQ '1'>
						<cf_errorCode	code = "51566"
										msg  = "Transformacion de Producto en Transito: El Articulo Origen '@errorDat_1@' es Producto Transformado y no se permite utilizar para producir otro"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					<cfelseif rsOC_TT_D.OCPTentradasCantidad EQ 0>
						<cf_errorCode	code = "51567"
										msg  = "Transformacion de Producto en Transito: El Articulo Origen '@errorDat_1@' no ha tenido ninguna Entrada"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					</cfif>
					
					<!--- DT-Ori: VERIFICA CONSISTENCIA DE SALDOS: ENTRADAS, SALIDAS Y EXISTENCIAS (sin holgura) --->
					<cfif rsOC_TT_D.OCPTentradasCantidad LT 0 OR rsOC_TT_D.OCPTentradasCostoTotal LT 0>
						<cf_errorCode	code = "51568"
										msg  = "Transformacion de Producto en Transito: Error de datos, las Entradas Totales no pueden ser menor que cero: Artículo Origen=@errorDat_1@, EntradasCantidadTotal=@errorDat_2@, EntradasCostoTotal=@errorDat_3@"
										errorDat_1="#rsOC_TT_D.Acodigo#"
										errorDat_2="#rsOC_TT_D.OCPTentradasCantidad#"
										errorDat_3="#numberFormat(rsOC_TT_D.OCPTentradasCostoTotal,",9.99")#"
						>
					<cfelseif rsOC_TT_D.OCPTsalidasCantidad GT 0 OR rsOC_TT_D.OCPTsalidasCostoTotal GT 0>
						<cf_errorCode	code = "51569"
										msg  = "Transformacion de Producto en Transito: Error de datos, las Salidas Totales no pueden ser menor que cero: Artículo Origen=@errorDat_1@, SalidasCantidadTotal=@errorDat_2@, SalidasCostoTotal=@errorDat_3@"
										errorDat_1="#rsOC_TT_D.Acodigo#"
										errorDat_2="#-rsOC_TT_D.OCPTsalidasCantidad#"
										errorDat_3="#numberFormat(-rsOC_TT_D.OCPTsalidasCostoTotal,",9.99")#"
						>
					<cfelseif rsOC_TT_D.OCPTentradasCantidad + rsOC_TT_D.OCPTsalidasCantidad - rsOC_TT_D.OCTTDcantidad LT 0>
						<!--- LvarExistencias --->
						<cf_errorCode	code = "51570"
										msg  = "Transformacion de Producto en Transito: La existencia no puede quedar menor que cero: Artículo Origen=@errorDat_1@, ExistenciaAnterior=@errorDat_2@, Movimiento=@errorDat_3@, NuevaExistencia=@errorDat_4@"
										errorDat_1="#rsOC_TT_D.Acodigo#"
										errorDat_2="#rsOC_TT_D.OCPTentradasCantidad + rsOC_TT_D.OCPTsalidasCantidad#"
										errorDat_3="#-rsOC_TT_D.OCTTDcantidad#"
										errorDat_4="#rsOC_TT_D.OCPTentradasCantidad + rsOC_TT_D.OCPTsalidasCantidad - rsOC_TT_D.OCTTDcantidad#"
						>
					</cfif>
	
					<!--- Orden Destino Transformacion: Producto Origen o Mezclado--->
					<cfset LvarOCPTMtipoOD			= "D">
					<cfset LvarOCPTMtipoES			= "S">
					<cfset LvarCostoUnitario		= rsOC_TT_D.OCPTentradasCostoTotal/rsOC_TT_D.OCPTentradasCantidad>
					<cfset LvarCostoTotal	 		= round(rsOC_TT_D.OCTTDcantidad * LvarCostoUnitario/100)*100>
					<cfset LvarOCPTMcantidad		= -rsOC_TT_D.OCTTDcantidad>
					<cfset LvarOCPTMmontoValuacion	= -LvarCostoTotal>
					<cfset LvarOCPTMmontoLocal		= round(-LvarCostoTotal * LvarTipoCambioValuacion/100)*100>
	
					<!--- Actualiza Saldos: OCproductoTransito.  Se puede actualizar porque se requiere sin modificar el OCPTentradasCantidad de los Articulos Origen no el de salidas --->
					<cfquery datasource="#Arguments.Conexion#">
						update OCproductoTransito
						   set OCPTsalidasCantidad 		= OCPTsalidasCantidad 	+ #LvarOCPTMcantidad#,
							   OCPTsalidasCostoTotal 	= OCPTsalidasCostoTotal	+ #LvarOCPTMmontoValuacion#
						 where OCTid	= #rsOC_TT_D.OCTid#
						   and Aid		= #rsOC_TT_D.Aid#
					</cfquery>
				<cfelse>
					<!--- Productos Destinos de un Transformación = Producto Transformado --->
					<cfif rsTP.recordCount GT 1>
						<cf_errorCode	code = "51571"
										msg  = "Transformacion de Producto en Transito: El Articulo Destino '@errorDat_1@' se registró en el Transporte tanto como Origen como Destino, no se puede incluir en una Transformacion"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					<cfelseif rsTP.OCtipoOD NEQ 'D'>
						<cf_errorCode	code = "51572"
										msg  = "Transformacion de Producto en Transito: El Articulo Destino '@errorDat_1@' no está registrado en el Transporte como Destino"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					<cfelseif rsOC_TT_D.OCPTtransformado EQ '1'>
						<cf_errorCode	code = "51573"
										msg  = "Transformacion de Producto en Transito: El Articulo Destino '@errorDat_1@' ya es Producto Transformado y no se permite producir otra vez"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					<cfelseif rsOC_TT_D.OCPTentradasCantidad NEQ 0 OR rsOC_TT_D.OCPTentradasCostoTotal NEQ 0>
						<cf_errorCode	code = "51574"
										msg  = "Transformacion de Producto en Transito: El Articulo Destino '@errorDat_1@' ya ha tenido entradas, no se permite producir"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					<cfelseif rsOC_TT_D.OCPTsalidasCantidad NEQ 0 OR rsOC_TT_D.OCPTsalidasCostoTotal NEQ 0>
						<cf_errorCode	code = "51575"
										msg  = "Transformacion de Producto en Transito: El Articulo Destino '@errorDat_1@' ya ha tenido salidas, no se permite producir"
										errorDat_1="#rsOC_TT_D.Acodigo#"
						>
					</cfif>
	
					<!--- Orden Origen Transformacion: Producto Destino --->
					<cfset LvarOCPTMtipoOD			= "O">
					<cfset LvarOCPTMtipoES			= "E">
					<cfset LvarCostoTotal	 		= round(rsTT_TOTAL.Costo * rsOC_TT_D.OCTTDproporcionDst*100)/100>
					<cfset LvarOCPTMcantidad		= rsOC_TT_D.OCTTDcantidad>
					<cfset LvarCostoUnitario		= LvarCostoTotal / LvarOCPTMcantidad>
					<cfset LvarOCPTMmontoValuacion	= LvarCostoTotal>
					<cfset LvarOCPTMmontoLocal		= round(LvarCostoTotal * LvarTipoCambioValuacion*100)/100>
	
					<!--- Actualiza Saldos: OCproductoTransito.  Se puede actualizar porque se requiere sin modificar el OCPTentradasCantidad de los Articulos Origen no el de Destino --->
					<cfquery datasource="#Arguments.Conexion#">
						update OCproductoTransito
						   set OCPTentradasCantidad 	= OCPTentradasCantidad		+ #LvarOCPTMcantidad#, 
							   OCPTentradasCostoTotal 	= OCPTentradasCostoTotal	+ #LvarOCPTMmontoValuacion#,
							   OCPTtransformado 		= 1
						 where OCTid	= #rsOC_TT_D.OCTid#
						   and Aid		= #rsOC_TT_D.Aid#
					</cfquery>
				</cfif>
	
				<!--- Actualiza Costos del Documento de Transformacion: OCtransporteTransformacionD --->
				<cfquery datasource="#Arguments.Conexion#">
					update OCtransporteTransformacionD
					   set OCTTDcostoUnitario	= #LvarCostoUnitario#, 
						   OCTTDcostoTotal 		= #LvarCostoTotal#
					 where OCTTDid	= #rsOC_TT_D.OCTTDid#
				</cfquery>
	
				<!--- Registra Movimiento: OCPTmovimientos de Transformacion, Origen y Destino --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into OCPTmovimientos
						(
							OCTid, Aid, OCid, SNid, OCCid, OCIid, OCVid, 
							OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES,
							Ocodigo, Alm_Aid,
							Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri,
							OCPTMfecha, OCPTMfechaTC,
							Ecodigo, Ucodigo, OCPTMcantidad,
							McodigoOrigen, OCPTMmontoOrigen, OCPTMmontoLocal, OCPTMmontoValuacion,
							BMUsucodigo
						)
					values (
							#rsOC_TT_D.OCTid#, #rsOC_TT_D.Aid#, null, null, null, null, null, 
							'#LvarOCPTMtipoOD#', 'T',	<!--- Transformacion Destino --->
							'#LvarOCPTMtipoES#',
							null, null,
							'OCTR', '#rsOC_TT_E.OCTTdocumento#', '#rsOC_TT_D.OCTTDtipoOD#', #rsOC_TT_D.OCTTDid#, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_TT_E.OCTTfecha#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOC_TT_E.OCTTfecha#">,
							#rsOC_TT_D.Ecodigo#, '#rsOC_TT_D.Ucodigo#', #LvarOCPTMcantidad#,
							#LvarMcodigoValuacion#, #LvarOCPTMmontoValuacion#, #LvarOCPTMmontoLocal#, #LvarOCPTMmontoValuacion#,
							#session.Usucodigo#
						)
					<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#Arguments.Conexion#" returnvariable="LvarOCPTMid">
	
				<!--- 
					Genera los Movimientos Contables
						TD_TR CostoOri/EntradasTotal * (Cantidad_TO * proporcionDst_TD)
							TO_TR CostoOri/EntradasTotal * (Cantidad_TO)
		
						Ojo: Cantidad_TO = sum(Cantidad_TO * proporcionDst_TD) de cada TD
				--->
	
				<cfif rsOC_TT_D.OCTTDtipoOD EQ "O">
					<!--- CREDITO: TR es normal debito * -TTO.OCTTDcantidad es negativo --->
					<!--- Sacar de transito del Producto Mezclado (TTO=Origen de la Transformación) --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #OC_Detalle#
							(
								Tipo, OCPTMid,
								OCTid, Aid, OCid, SNid, OCCid,
								Ocodigo, Alm_Aid, CFcuenta,

								OCid_O, OCTTid, OCid_D, 
			
								OCPTDmontoLocal, OCPTDmontoValuacion
							)
						select 	'TR', #LvarOCPTMid#,
								TTO.OCTid, TTO.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
								MOVs_ORI.Ocodigo, null, null,

								MOVs_ORI.OCid, #Arguments.OCTTid#, null, 
			
								(MOVs_ORI.OCPTMmontoLocal	  / PTO.OCPTentradasCantidad)	* (-TTO.OCTTDcantidad), 
								(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* (-TTO.OCTTDcantidad)
						  from OCtransporteTransformacionD TTO
							inner join OCproductoTransito PTO
								 on PTO.OCTid		= TTO.OCTid
								and PTO.Aid			= TTO.Aid
							inner join OCPTmovimientos MOVs_ORI
								 on MOVs_ORI.OCTid			= TTO.OCTid
								and MOVs_ORI.Aid			= TTO.Aid
								and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
						 where TTO.OCTTid	= #Arguments.OCTTid#
						   and TTO.OCTid 	= #rsOC_TT_D.OCTid#
						   and TTO.Aid	 	= #rsOC_TT_D.Aid#
						   and TTO.OCTTDtipoOD	= 'O'
			
						   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
						   and PTO.OCPTentradasCantidad <> 0								<!--- Division por cero --->
						   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
					</cfquery>
				<cfelse>
					<!--- DEBITO: TR es normal debito * TTO.OCTTDcantidad es positivo --->
					<!--- Meter a transito del Producto Transformado (TTD=Destino de la Transformación) --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #OC_Detalle#
							(
								Tipo, OCPTMid,
								OCTid, Aid, OCid, SNid, OCCid,
								Ocodigo, Alm_Aid, CFcuenta,

								OCid_O, OCTTid, OCid_D, 
			
								OCPTDmontoLocal, OCPTDmontoValuacion
							)
						select 	'TR', #LvarOCPTMid#,
								TTD.OCTid, TTD.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
								MOVs_ORI.Ocodigo, null, null,

								MOVs_ORI.OCid, #Arguments.OCTTid#, null,
			
								(MOVs_ORI.OCPTMmontoLocal	  / PTO.OCPTentradasCantidad)	* (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst), 
								(MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad)	* (TTO.OCTTDcantidad * TTD.OCTTDproporcionDst)
						  from OCtransporteTransformacionD TTD
							inner join OCtransporteTransformacionD TTO
								inner join OCproductoTransito PTO
									 on PTO.OCTid		= TTO.OCTid
									and PTO.Aid			= TTO.Aid
								inner join OCPTmovimientos MOVs_ORI
									 on MOVs_ORI.OCTid			= TTO.OCTid
									and MOVs_ORI.Aid			= TTO.Aid
									and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
								 on TTO.OCTTid 	= TTD.OCTTid
								and TTO.OCTTDtipoOD	= 'O'
						 where TTD.OCTTid		= #Arguments.OCTTid#
						   and TTD.OCTid 		= #rsOC_TT_D.OCTid#
						   and TTD.Aid	 		= #rsOC_TT_D.Aid#
						   and TTD.OCTTDtipoOD	= 'D'
			
						   and MOVs_ORI.OCPTMmontoValuacion <> 0							<!--- Monto a Distribuir --->
						   and PTO.OCPTentradasCantidad <> 0								<!--- Division por cero --->
						   and TTO.OCTTDcantidad <> 0										<!--- Proporcion a Distribuir --->
						   and TTD.OCTTDproporcionDst <> 0									<!--- Proporcion a Distribuir --->
					</cfquery>
				</cfif>	
	
				<!--- OJO:  No se incluye la distribución ni ajuste (por cambio de cantidad) de movimientos destino anteriores, porque no se permite producir productos con movimientos anteriores --->
			</cfloop>
	
			<!--- Generar detalles --->
			<cfset sbGenerarDetalles(LvarAnoAux, LvarMesAux, Arguments.conexion)>
			<cfset sbGenerarINTARC('OCTR', rsOC_TT_E.OCTTdocumento, "OCTR", LvarAnoAux, LvarMesAux, Arguments.Conexion)>

			<!--- Genera el Asiento Contable --->
			<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
						method			= "GeneraAsiento" 
						returnvariable	= "LvarIDcontable"
			>
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
				<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
				<cfinvokeargument name="Efecha"			value="#rsOC_TT_E.OCTTfecha#"/>
				<cfinvokeargument name="Oorigen"		value="OCTR"/>
				<cfinvokeargument name="Edocbase"		value="#rsOC_TT_E.OCTTdocumento#"/>
				<cfinvokeargument name="Ereferencia"	value="#rsOC_TT_E.OCTtransporte#"/>						
				<cfinvokeargument name="Edescripcion"	value="Documento de Transformacion de Producto en Transito OC"/>
				<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
			</cfinvoke>
	
			<cfquery datasource="#Arguments.Conexion#">
				update OCtransporteTransformacion
				   set 	OCTTestado 	= 1,
						OCTTperiodo = #LvarAnoAux#,
						OCTTmes		= #LvarMesAux#
				 where OCTTid	= #Arguments.OCTTid#
			</cfquery>

		</cftransaction>
	</cffunction>

	<cffunction name="sbGenerarDetalles" access="private" output="false">
		<cfargument name="Periodo"		type="numeric"	required="yes">
		<cfargument name="Mes"			type="numeric"	required="yes">
		<cfargument name="Conexion"		type="string"	required="yes">

		<!--- 
			Tipo = 'TR' 'CV' 'IN' son los detalles del OCMovimiento que se está procesando, y sirven para generar las cuentas de Ordenes Comerciales, y se borran cuando ya se han resumido
			Tipo = '**' son los detalles resumidos del OCMovimiento que se está procesando
		--->

		<!--- Genera las Cuentas Financieras de TR, CV, IN --->
		<cfquery name="rsOC_Detalles" datasource="#Arguments.Conexion#">
			update #OC_Detalle#
			   set 	OCid = coalesce(OCid, -1),
			   		SNid = coalesce(SNid, -1),
					OCCid = coalesce(OCCid,-1)
		</cfquery>

		<cfquery name="rsOC_Detalles" datasource="#Arguments.Conexion#">
			select distinct 
					Tipo, OCTid, Aid, 
					OCid, 
					SNid, 
					OCCid,
					coalesce(OCIid,-1) as OCIid
			  from #OC_Detalle#
			 where CFcuenta is null
		</cfquery>

		<cfloop query="rsOC_Detalles">
			<cfif rsOC_Detalles.Tipo EQ "TR">
				<!--- OCid Compra no requerido, Aid Compra, SNid Compra, OCCid Compra, OCIid -1 --->
				<cfset LvarCFcuenta = fnOCobtieneCFcuenta ("TR", rsOC_Detalles.OCid, rsOC_Detalles.Aid, rsOC_Detalles.SNid, rsOC_Detalles.OCCid, -1)>
			<cfelseif rsOC_Detalles.Tipo EQ "CV">
				<!--- OCid Venta, Aid Compra, SNid Compra, OCCid Compra, OCIid -1  --->
				<cfset LvarCFcuenta = fnOCobtieneCFcuenta ("CV", rsOC_Detalles.OCid, rsOC_Detalles.Aid, rsOC_Detalles.SNid, rsOC_Detalles.OCCid, -1)>
			<cfelseif rsOC_Detalles.Tipo EQ "IN">
				<!--- OCid Venta, Aid Venta, SNid Venta, OCCid -1, OCIid Ingreso --->
				<cfset LvarCFcuenta = fnOCobtieneCFcuenta ("IN", rsOC_Detalles.OCid, rsOC_Detalles.Aid, rsOC_Detalles.SNid, -1, rsOC_Detalles.OCIid)>
			<cfelse>
				<cf_errorCode	code = "51576"
								msg  = "Generacion de Cuenta de Ordenes Comerciales: Solo se puede generar la cuenta para tipos: TR,CV,IN: @errorDat_1@"
								errorDat_1="#rsOC_Detalles.Tipo#"
				>
			</cfif>

			<cfquery datasource="#Arguments.Conexion#">
				update #OC_Detalle#
				   set CFcuenta = #LvarCFcuenta#
				 where CFcuenta is null
				   and Tipo		= '#rsOC_Detalles.Tipo#'
				   and OCid		= #rsOC_Detalles.OCid#
				   and OCTid	= #rsOC_Detalles.OCTid#
				   and Aid		= #rsOC_Detalles.Aid#
				   and OCid		= #rsOC_Detalles.OCid#
				   and SNid		= #rsOC_Detalles.SNid#
				   and OCCid 	= #rsOC_Detalles.OCCid#
			</cfquery>
		</cfloop>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from #OC_Detalle#
			 where CFcuenta is null
		</cfquery>

		<cfif rsSQL.cantidad GT 0>
			<cf_errorCode	code = "51577" msg = "Hay cuentas no generadas">
		</cfif>

		<!--- 
			Genera los detalles Resumidos: 
				Movimientos de Inventario:	un sólo movimiento resumido un DB o un CR
				Para los demás calcula:		2 movimientos, total de DBs y total de CRs 
		--->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update #OC_Detalle#
			   set INTTIP = 'C'		-- when Tipo = 'TR' then 'D' else 'C' end
			 where Tipo IN ('OI','DI')
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update #OC_Detalle#
			   set INTTIP = 
			   		case 
						when Tipo = 'TR' then 
							case when OCPTDmontoValuacion>=0 then 'D' else 'C' end
						else 
							case when OCPTDmontoValuacion < 0 then 'D' else 'C' end
					end
				  , OCPTDmontoValuacion = case when OCPTDmontoValuacion>=0 then OCPTDmontoValuacion else -OCPTDmontoValuacion end
				  , OCPTDmontoLocal		= case when OCPTDmontoValuacion>=0 then OCPTDmontoLocal else -OCPTDmontoLocal end
			 where NOT Tipo IN ('OI','DI')
		</cfquery>
				
		<!--- Genera los detalles Resumidos Tipo='**' --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #OC_Detalle#
				(
					Tipo, OCPTMid,
					OCTid, Aid, OCid, SNid, OCCid,
					Ocodigo, CFcuenta,

					OCid_O, OCTTid, OCid_D,  

					INTTIP, OCPTDtipoMov, 
					OCPTDmontoLocal, OCPTDmontoValuacion
				)
			select  '**' , OCPTMid,
					OCTid, Aid, 	-1,-1,-1, 	-- OCid, SNid, OCCid,
					Ocodigo, CFcuenta,

					OCid_O, OCTTid, OCid_D,  

					INTTIP,
					case 
						when Tipo = 'TR' then 'T' 
						when Tipo = 'CV' then 'C' 
						when Tipo = 'IN' then 'I' 
						when Tipo = 'DI' then 'E' 
						when Tipo = 'OI' then 'S' 
						else '*'
					end,
					round(sum(round(OCPTDmontoLocal,2)),2), round(sum(round(OCPTDmontoValuacion,2)),2)
			  from #OC_Detalle#
			 group by 
			 		Tipo, OCPTMid, 
			 		OCTid, Aid, 				-- OCid, SNid, OCCid, 
					Ocodigo, CFcuenta,
					OCid_O, OCTTid, OCid_D,  
					INTTIP
			having	round(sum(OCPTDmontoLocal),2)<>0 OR round(sum(OCPTDmontoValuacion),2)<>0
		</cfquery>

		<!--- Elimina los detalles NO RESUMIDOS --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			 delete from #OC_Detalle#
			 where Tipo <> '**'
		</cfquery>

		<!---
			Ajuste para Balancear el asiento por perdida de precisión a causa del redondeo a 2 decimales
			Se permite como máximo 0.005 * cantidad de lineas
			Se distribuye 0.01 de la diferencia a cada línea hasta que se acabe la diferencia
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	sum(case when INTTIP='D' then OCPTDmontoValuacion else -OCPTDmontoValuacion end) as Diferencia,
					count(1)*0.005 as Holgura,
					count(1) as cantidad
			  from #OC_Detalle#
		</cfquery>
		<cfif rsSQL.Cantidad NEQ 0 AND rsSQL.Diferencia NEQ 0 AND abs(rsSQL.Diferencia) LTE rsSQL.Holgura>
			<cfset LvarDiferencia = abs(rsSQL.Diferencia)>
			<cfif rsSQL.Diferencia GT 0>
				<cfset LvarDif = 0.01>
			<cfelse>
				<cfset LvarDif = -0.01>
			</cfif>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select 	id, INTTIP
				  from #OC_Detalle#
			</cfquery>
			<cfloop query="rsSQL">
				<cfquery datasource="#Arguments.Conexion#">
					update #OC_Detalle#
					   set OCPTDmontoValuacion = OCPTDmontoValuacion <cfif rsSQL.INTTIP EQ "D">-<cfelse>+</cfif>#LvarDif#
					 where id = #rsSQL.id#
				</cfquery>
				<cfset LvarDiferencia = LvarDiferencia - 0.01>
				<cfif LvarDiferencia EQ 0>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		--->

		<!--- Actualiza los contratos en detalles RESUMIDOS --->
        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.Conexion#">
			 update #OC_Detalle#
			    set OCcontratos = 
					case 
							when OCid_O IS NULL and OCPTDtipoMov = 'T' then
								'OC-O.0'
							when OCid_O IS NOT NULL then
								'OC-O.' #_Cat# (select OCcontrato from OCordenComercial where OCid = #OC_Detalle#.OCid_O)
								#_Cat# case when OCid_D IS NOT NULL OR OCTTid IS NOT NULL then ',' end
						end
						#_Cat#
						case 
							when OCTTid IS NOT NULL then
								'OC-T.' #_Cat# (select OCTTdocumento from OCtransporteTransformacion where OCTTid = #OC_Detalle#.OCTTid)
								#_Cat# case when OCid_D IS NOT NULL then ',' end
						end
						#_Cat#
						case 
							when OCid_D IS NOT NULL then
								'OC-D.' #_Cat# (select OCcontrato from OCordenComercial where OCid = #OC_Detalle#.OCid_D)
						end
		</cfquery>
		
		<!--- Amacena los detalles Resumidos en OCPTdetalle --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into OCPTdetalle
				(
					OCPTMid, 
					OCTid, Aid, OCPTDperiodo, OCPTDmes, 
					OCid_O, OCid_D,  OCTTid,
					OCPTDtipoMov, 
					Ocodigo, CFcuenta,

					OCPTDmontoValuacion, OCPTDmontoLocal, 

					BMUsucodigo
				)
			select  OCPTMid, 
					OCTid, Aid, #Arguments.Periodo#, #Arguments.Mes#, 
					OCid_O, OCid_D,  OCTTid,
					OCPTDtipoMov, 
					Ocodigo, CFcuenta, 

					OCPTDmontoValuacion, OCPTDmontoLocal, 

					#session.Usucodigo#
			  from #OC_Detalle#
			 where OCPTDtipoMov <> 'S'		<!--- No se registran los movimientos de Inventario --->
		</cfquery>
	</cffunction>
	
	<cffunction name="sbGenerarINTARC" access="public" output="false">
		<cfargument name="ModuloOrigen"		type="string"	required="yes">
		<cfargument name="Documento"		type="string"	required="yes">
		<cfargument name="Referencia"		type="string"	required="yes">
		<cfargument name="Periodo"			type="numeric"	required="yes">
		<cfargument name="Mes"				type="numeric"	required="yes">
		<cfargument name="Conexion" 		type="string"	required="yes">
		<cfargument name="Almacen"			type="string"	required="no" default="">
		
        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.INTARC# ( 
					INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo,
					Mcodigo, INTMOE, INTCAM, INTMON
				)
			select
				'#Arguments.ModuloOrigen#',	1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Documento#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Referencia#">,
				INTTIP,
				OCcontratos #_Cat# ',' #_Cat#
				  case OCPTDtipoMov 
					when 'T' then
						'TRANSITO'
					when 'C' then
						'COSTO VENTA'
					when 'I' then
						'INGRESO'
					when 'E' then
					<cfif Arguments.Almacen EQ "">
						'DST.ENT.INVENTARIO'
					<cfelse>
						'DST.ENT.INVENTARIO (Almacen=#Arguments.Almacen#)'
					</cfif>
					when 'S' then
					<cfif Arguments.Almacen EQ "">
						'ORI.SAL.INVENTARIO'
					<cfelse>
						'ORI.SAL.INVENTARIO (Almacen=#Arguments.Almacen#)'
					</cfif>
					else ' ?????'
				end #_Cat# ',ART.' #_Cat# (select rtrim(ltrim(art.Acodigo)) #_Cat# ': ' #_Cat# rtrim(ltrim(art.Adescripcion)) from Articulos art where art.Aid = d.Aid ),
				'#dateFormat(now(),"YYYYMMDD")#',
				#Arguments.Periodo#,
				#Arguments.Mes#,
				0,
				d.CFcuenta,
				d.Ocodigo,

				#LvarMcodigoValuacion#,
				OCPTDmontoValuacion,
				case when OCPTDmontoValuacion = 0 then 1 else OCPTDmontoLocal / OCPTDmontoValuacion end,
				OCPTDmontoLocal
			  from #request.OC_Detalle# d
			 order by d.id
		</cfquery>
	</cffunction>

	<cffunction name="fn_rsExistencias" access="private" returntype="query">
		<cfargument name="Ecodigo"		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name="Aid"			type="numeric"	required="yes">
		<cfargument name="Alm_Aid"		type="numeric"	required="yes">
		<cfargument name="Conexion"		type="string"	required="yes">

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#" maxrows="1">
			select 	a.Aid as E_Aid,
					art.Aid, art.Acodigo, art.Adescripcion, 
					alm.Aid as Alm_Aid, alm.Almcodigo, alm.Bdescripcion, alm.Dcodigo, alm.Ocodigo,
					c.CFcuenta, c.Ccuenta, c.CFformato
			  from Articulos art
			  	inner join Almacen alm
				    on alm.Ecodigo	= art.Ecodigo
				   and alm.Aid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">
				left join Existencias a
					left join IAContables b 
						inner join CFinanciera c 
							 on b.IACinventario = c.Ccuenta 
							and b.Ecodigo = c.Ecodigo
						 on a.IACcodigo = b.IACcodigo 
						and a.Ecodigo = b.Ecodigo
					 on a.Alm_Aid 	= alm.Aid 
					and a.Aid		= art.Aid
			 where art.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and art.Aid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
		</cfquery>

		<cfif rsSQL.E_Aid EQ "">
			<cf_errorCode	code = "51578"
							msg  = "Error en OC_transito. No existen existencias para al Artículo '@errorDat_1@ - @errorDat_2@' en el Almacén '@errorDat_3@ - @errorDat_4@'. Proceso Cancelado!"
							errorDat_1="#rsSQL.Acodigo#"
							errorDat_2="#rsSQL.Adescripcion#"
							errorDat_3="#rsSQL.Almcodigo#"
							errorDat_4="#rsSQL.Bdescripcion#"
			>
		<cfelseif rsSQL.CFcuenta EQ "">
			<cf_errorCode	code = "51579"
							msg  = "Error en OC_transito. No se ha definido la cuenta Financiera para al Artículo '@errorDat_1@ - @errorDat_2@' en el Almacén '@errorDat_3@ - @errorDat_4@'. Proceso Cancelado!"
							errorDat_1="#rsSQL.Acodigo#"
							errorDat_2="#rsSQL.Adescripcion#"
							errorDat_3="#rsSQL.Almcodigo#"
							errorDat_4="#rsSQL.Bdescripcion#"
			>
		</cfif>
		
		<cfreturn rsSQL>
	</cffunction>

	<cffunction name="OC_Aplica_CostoVenta_Pendientes" access="public">
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name="Periodo"			type="numeric"	required="yes">
		<cfargument name="Mes"				type="numeric"	required="yes">
		<cfargument name="OCs_DC"			type="numeric"	required="yes">
		<cfargument name="OCs_DV"			type="numeric"	required="yes">
		<cfargument name="CCTcodigo"		type="string"	required="yes">
		<cfargument name="Ddocumento"		type="string"	required="yes">
		<cfargument name='Conexion' 		type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name="VerAsiento"		type="boolean"	required="no" default="no">
		<cfargument name="AnoMes"			type="numeric"	required="no" default="0">
		<cfargument name="Anteriores"		type="boolean"	required="no" default="no">
		
		<!--- 
			Arguments.Anteriores:
				Son Movimientos Anteriores a iniciar el sistema, cuyos costos de venta fueron contabilizados manualmente y marcados como ya calculados, 
				pero que en realidad no fueron calculados con el Sistema de Órdenes Comerciales.
				Su generación va a: 
					- Calcular el Costo de Ventas, 
					- Llenar las estructuras de Órdenes Comerciales, 
					- Pero no va a generar la Póliza Contable
		--->
		
		<!--- Moneda de Valuación --->
		<cfset LvarMcodigoValuacion = fnLeeParametro(441,"Moneda de Valuacion de Inventarios")>
		<cfquery name="rsCCVProductoP" datasource="#Arguments.conexion#">
			select distinct cv.CCTcodigo, cv.Ddocumento, coalesce(dd.EDtipocambioFecha, dd.Dfecha) as Fecha
			  from CCVProducto cv
				inner join HDDocumentos cc
					inner join HDocumentos dd
						 on dd.Ecodigo		= cc.Ecodigo
						and dd.CCTcodigo	= cc.CCTcodigo
						and dd.Ddocumento	= cc.Ddocumento
					inner join OCordenComercial oc
						 on oc.OCid = cc.OCid
						and oc.OCtipoOD = 'D'
				<cfif Arguments.Anteriores>					
					<cfif Arguments.OCs_DC NEQ 1>
						<cf_errorCode	code = "51580" msg = "No se pueden generar Movimientos Anteriores al Inicio del Sistema, si no se marca Movimientos Destino Comercial">
					</cfif>
						and oc.OCtipoIC = 'C'				<!--- Únicamente Movimientos de tipo Destino Comercial --->
					inner join OCPTmovimientos m
						inner join OCtransporte t
							 on t.OCTid		= m.OCTid
							and t.OCTestado	= 'A'			<!--- Únicamente Transportes Abiertos --->
						 on m.Oorigen		= 'CCFC'
						and m.OCPTMlineaOri	= cc.DDid
						and m.OCPTMfechaCV	is null			<!--- Únicamente Movimientos que no tengan calculado su Costo de Ventas --->
				<cfelse>
						and oc.OCtipoIC in ('z'<cfif Arguments.OCs_DC EQ 1>,'C'</cfif><cfif Arguments.OCs_DV EQ 1>,'V'</cfif>)
				</cfif>
					on cc.Ecodigo	 	= cv.Ecodigo
				   and cc.CCTcodigo	 	= cv.CCTcodigo
				   and cc.Ddocumento 	= cv.Ddocumento
				   and cc.DDtipo 		= cv.DDtipo
				   and cc.DDcodartcon	= cv.Aid
			 where cv.Ecodigo 		= #Arguments.Ecodigo#
			   and cv.DDtipo 		= 'O'	<!--- Ordenes Comerciales --->
			<cfif Arguments.Anteriores>
			   and cv.CCVPestado	= 1		<!--- Marcados manualmente como ya calculados, pero no se han calculado en OC --->
			<cfelse>
			   and cv.CCVPestado	= 0		<!--- Pendientes --->
			</cfif>
			<cfif Arguments.Ddocumento NEQ "">
			   and cv.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			   and cv.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
			</cfif>
			<cfif Arguments.AnoMes EQ "-1">
				and CCVPperiodo < 2007
			<cfelseif Arguments.AnoMes NEQ "0">
				and CCVPperiodo*100+CCVPmes = #200700+Arguments.AnoMes#
			</cfif>
		</cfquery>

		<cfloop query="rsCCVProductoP">
			<cfquery datasource="#Arguments.conexion#">
				delete from #request.IMPUESTOS_CXC#
			</cfquery>
			<cfquery datasource="#Arguments.conexion#">
				delete from #request.INTARC#
			</cfquery>
			<cfquery datasource="#Arguments.conexion#">
				delete from #request.INTPRESUPUESTO#
			</cfquery>
			<cfquery datasource="#Arguments.conexion#">
				delete from #request.IDKARDEX#
			</cfquery>
			<cfquery datasource="#Arguments.conexion#">
				delete from #request.OC_DETALLE#
			</cfquery>
			<cftransaction>
				<cftry>
					<cfset GvarCCVPestado = 1>
					<cfset OC_Aplica_CostoVenta (Arguments.Ecodigo, rsCCVProductoP.CCTcodigo, rsCCVProductoP.Ddocumento, Arguments.Periodo, Arguments.Mes, Arguments.conexion)>
					
					<cfif Arguments.Anteriores>
						<cfif Arguments.VerAsiento EQ "1">
							<!--- Genera el Asiento Contable --->
							<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
										method			= "GeneraAsiento" 
										returnvariable	= "LvarIDcontable"
							>
								<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
								<cfinvokeargument name="Eperiodo"		value="#Arguments.Periodo#"/>
								<cfinvokeargument name="Emes"			value="#Arguments.Mes#"/>
								<cfinvokeargument name="Efecha"			value="#rsCCVProductoP.Fecha#"/>
								<cfinvokeargument name="Oorigen"		value="CCCV"/>
								<cfinvokeargument name="Edocbase"		value="#rsCCVProductoP.Ddocumento#"/>
								<cfinvokeargument name="Ereferencia"	value="#rsCCVProductoP.CCTcodigo#"/>
								<cfinvokeargument name="Edescripcion"	value="Costo de Ventas Pendientes CxC de Ordenes Comerciales en Transito"/>
								<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
							</cfinvoke>
						</cfif>
						<cfquery datasource="#Arguments.conexion#">
							update CCVProducto
							   set 	CCVPestado = #GvarCCVPestado#,
									CCVPmsg = 'OK: Se actualizaron las estructuras de Ordenes Comerciales, no se contabilizó'
							 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							   and CCTcodigo	= '#rsCCVProductoP.CCTcodigo#'
							   and Ddocumento 	= '#rsCCVProductoP.Ddocumento#'
							   and DDtipo 		= 'O'		<!--- Órdenes Comerciales --->
							   and CCVPestado	= 1			<!--- Marcado Manualmente --->
						</cfquery>
					<cfelse>
						<!--- Genera el Asiento Contable --->
						<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
									method			= "GeneraAsiento" 
									returnvariable	= "LvarIDcontable"
						>
							<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
							<cfinvokeargument name="Eperiodo"		value="#Arguments.Periodo#"/>
							<cfinvokeargument name="Emes"			value="#Arguments.Mes#"/>
							<cfinvokeargument name="Efecha"			value="#rsCCVProductoP.Fecha#"/>
							<cfinvokeargument name="Oorigen"		value="CCCV"/>
							<cfinvokeargument name="Edocbase"		value="#rsCCVProductoP.Ddocumento#"/>
							<cfinvokeargument name="Ereferencia"	value="#rsCCVProductoP.CCTcodigo#"/>
							<cfinvokeargument name="Edescripcion"	value="Costo de Ventas Pendientes CxC de Ordenes Comerciales en Transito"/>
							<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
						</cfinvoke>
	
						<!--- Actualizar el IDcontable del Kardex OC_DV --->
						<cfquery name="rsSQL" datasource="#session.dsn#">
							update Kardex 
							   set IDcontable = #LvarIDcontable#
							where Kid IN
								(
									select Kid
									   from #request.IDKARDEX#
								)
						</cfquery>
						<cfquery datasource="#Arguments.conexion#">
							update CCVProducto
							   set 	CCVPestado = #GvarCCVPestado#,
									CCVPmsg = 'OK'
							 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							   and CCTcodigo	= '#rsCCVProductoP.CCTcodigo#'
							   and Ddocumento 	= '#rsCCVProductoP.Ddocumento#'
							   and DDtipo 		= 'O'		<!--- Órdenes Comerciales --->
							   and CCVPestado	= 0			<!--- Pendientes --->
						</cfquery>
					</cfif>
				<cfcatch type="any">
					<cftransaction action="rollback"/>
					<cfif Arguments.VerAsiento>
						<cfrethrow>
					</cfif>
					<cfif Arguments.Ddocumento NEQ "">
						<cfrethrow>
					</cfif>
					<cfset LvarMSG = cfcatch.Message>
					<cftry>
						<cfinvoke component="home.public.error.stack_trace" method="fnGetStackTrace" LprmError="#cfcatch#" returnvariable="LvarError"></cfinvoke>
						<cfset LvarPto1 = find(" at /", LvarError)>
						<cfset LvarPto2 = find(".cf",LvarError,LvarPto1)>
						<cfset LvarPto3 = find(" ",LvarError,LvarPto2)>
						<cfset LvarError = "(" & mid(LvarError, LvarPto1+1, LvarPto3 - LvarPto1-1) & ")">
						<cfset LvarMSG = "#LvarMSG# #LvarError#">
					<cfcatch type="any"></cfcatch>
					</cftry>
					<cfquery datasource="#Arguments.conexion#">
						update CCVProducto
						   set CCVPmsg = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMSG#">
						 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						   and CCTcodigo	= '#rsCCVProductoP.CCTcodigo#'
						   and Ddocumento 	= '#rsCCVProductoP.Ddocumento#'
						   and DDtipo 		= 'O'	<!--- Ordenes Comerciales --->
						<cfif Arguments.Anteriores>
						   and CCVPestado	= 1		<!--- Marcado Manualmente --->
						<cfelse>
						   and CCVPestado	= 0		<!--- Pendientes --->
						</cfif>
					</cfquery>
					<cftransaction action="commit"/>
				</cfcatch>
				</cftry>
			</cftransaction>
		</cfloop>
	</cffunction>

	<cffunction name="OC_Cierre_Transporte">
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='OCTid'			type='numeric' 	required="yes">
		<cfargument name="ReAbrir"			type="boolean"	required="no" default="no">
		<cfargument name="VerAsiento"		type="boolean"	required="no" default="no">
		<!---
			Cierre de Transportes:
			
			Cuando se cierran transportes, cada artículo tiene sobrantes o faltantes en inventario en tránsito, que deben pasarse al Costo y dejar la cuenta de Transito en cero.
			
			Sobrantes de Transito (saldo > 0), deben repartirse entre los costos de las salidas realizadas
			Faltantes de Transito (saldo < 0), son costos negativos que fueron realizados durante el cálculo de costo de los movimientos de salida (fueron permitidos por estar dentro de un porcentaje aceptable de faltantes), estos costos negativos deben devolverse al Transito para netear la cuenta
				En principio, los faltantes no debieron permitirse (no debería haber saldo de inventario en transito negativos) pero como estan dentro del porcentaje permitido, durante el calculo del costo se generan estos costos negativos (ingresos) pero dentro del porcentaje permitido,
				y durante el cierre, estos costos negativos se reversan, y se devuelven a transito para netear la cuenta.
			
			La distribucion es el saldo de transito distribuido entre cada movimiento de salida prorrateado por la cantidad salida.
			El saldo proporcional de cada movimiento Origen debe distribuirse proporcionalmente entre cada salida por cantidad salida (pasar de Transito a Costo):
			
			Los productos No Transformados pueden tener movimientos de salida directos (Venta o entradas a inventario) o pueden mezclarse para formar parte de un producto transformado.
			Los productos transformados únicamente pueden tener movimientos de salida directos (Venta o entradas a inventario).
			
			1) Productos No Transformados:
				Las salidas directas (ventas y entradas a inventario) del producto no transformado:
				(Saldo en el Producto no transformado: Pasar del Transito al Costo del Producto no transformado)
					Monto proporcional del Saldo en Transito por la proporcion de cantidad salida
						MontoMovEntrada
						 / TotalEntradas * (TotalEntradas - TotalSalidas) 
							 / TotalSalidas * CantidadMovSalida
			2) Productos Mezclados:
				Las salidas de productos transformados donde el Producto está Mezclado: (en principio deberían pasar del Transito del Producto Mezclado al Transito del Producto Transformado y luego del Transito del Producto Transformado al Costo)
				(Saldo en el Producto mezclado: Pasar del Transito del Producto Mezclado al Costo del Producto Transformado)
					Monto proporcional del Saldo en Transito del Producto Mezclado por la proporcion de cantidad salida del Producto Transformado
						MontoMovEntrada 
						 / TotalEntradas * (TotalEntradas - TotalSalidas) 
						 / TotalSalidas * CantidadMezclada
						 * ProporcionDst
							 / CantidadTransformada * CantidadMovSalida
			3)Productos Transformados:
				Las salidas directas (ventas y entradas a inventario) del producto transformado:
				(Saldo en el Producto Transformado: Pasar del Transito al Costo del Producto Transformado)
					Monto total de cada entrada mezclada proporcional al saldo del producto Transformado por la proporcion de cantidad salida del Producto Transformado
						MontoMovEntrada 
						 / TotalEntradas * CantidadMezclada
						 * ProporcionDst
						 / CantidadTransformada * (TotalEntradas - TotalSalidas)
							 / TotalSalidas * CantidadMovSalida

			Verificaciones:
				Debe tener entradas y salidas
				Entradas deben ser >= 0
				Ventas deben ser >=0
				Salidas deben ser <=0
				Entradas = sum(MovimientosOrigen)
				Ventas = sum(MovimientosVentas) que no sean VentasDirectas
				Salidas = sum(MovimientosDestinos) que no sean VentasDirectas
				Todos los movimientos destinos deben tener Costo calculado

		--->
				
		<!--- Moneda de Valuación --->
		<cfset LvarMcodigoValuacion = fnLeeParametro(441,"Moneda de Valuacion de Inventarios")>

		<!--- Período de Auxiliares --->
		<cfset LvarAnoAux = fnLeeParametro(50,"Período de Auxiliares")>
		<cfset LvarMesAux = fnLeeParametro(60,"Mes de Auxiliares")>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select t.OCTtransporte, count(1) as Cantidad
			  from HDDocumentos cc
			  	inner join OCtransporte t
					 on t.OCTid = cc.OCTid
				inner join CCVProducto cv
					 on cv.Ecodigo 		= cc.Ecodigo
				    and cv.CCTcodigo	= cc.CCTcodigo
				    and cv.Ddocumento	= cc.Ddocumento
				    and cv.DDtipo 		= cc.DDtipo
				    and cv.Aid			= cc.DDcodartcon
				    and cv.CCVPestado	= 0		<!--- Pendientes --->
			 where cc.Ecodigo 		= #Arguments.Ecodigo#
			   and cc.DDtipo 		= 'O'	<!--- Ordenes Comerciales --->
   			   and cc.OCTid			= #Arguments.OCTid#
			group by t.OCTtransporte
		</cfquery>
		<cfif rsSQL.Cantidad GT 0>
			<cf_errorCode	code = "51581"
							msg  = "Cierre de Transporte de Transito: Error de proceso, existen Costos de Ventas pendientes de calcular para el Transporte=@errorDat_1@"
							errorDat_1="#rsSQL.OCTtransporte#"
			>
		</cfif>

		<cfquery name="rsCIERRE" datasource="#session.dsn#">
			select 	pt.OCTid, 	t.OCTtransporte,
					pt.Aid, 	a.Acodigo,	a.Ucodigo,
					pt.OCPTtransformado,
					pt.OCPTentradasCantidad, 	pt.OCPTentradasCostoTotal, 
					pt.OCPTventasCantidad, 		pt.OCPTventasMontoTotal,	
					pt.OCPTsalidasCantidad, 	pt.OCPTsalidasCostoTotal,
					pt.OCPTentradasCantidad 	+ pt.OCPTsalidasCantidad	as OCPTexistencias,
					pt.OCPTentradasCostoTotal 	+ pt.OCPTsalidasCostoTotal	as OCPTsaldo
			  from OCproductoTransito pt
				inner join Articulos a
					on a.Aid = pt.Aid
				inner join OCtransporte t
					on t.OCTid = pt.OCTid
			 where pt.OCTid = #Arguments.OCTid#
			   AND NOT (
					pt.OCPTentradasCantidad = 0 and pt.OCPTentradasCostoTotal = 0 and
					pt.OCPTsalidasCantidad = 0  and pt.OCPTsalidasCostoTotal = 0
					)
		</cfquery>
		
		<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")>
		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
	
		<cfset INTARC 		= LobjCONTA.CreaIntarc(session.dsn)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(session.dsn)>
		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(session.dsn)>
		<cfset OC_DETALLE 	= OC_CreaTablas(session.dsn)>
	
		<cftransaction>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select t.OCTtransporte, OCTestado
				  from OCtransporte t
				 where t.OCTid = #Arguments.OCTid#
			</cfquery>
			<cfif Arguments.ReAbrir>
				<cfif rsSQL.OCTestado NEQ "C">
					<cf_errorCode	code = "51582"
									msg  = "Cierre de Transporte de Transito: El Transporte '@errorDat_1@' no está Cerrado, no se puede reabrir"
									errorDat_1="#rsSQL.OCTtransporte#"
					>
				</cfif>
			<cfelse>
				<cfif rsSQL.OCTestado NEQ "A">
					<cf_errorCode	code = "51583"
									msg  = "Cierre de Transporte de Transito: El Transporte '@errorDat_1@' no está Abierto, no se puede cerrar"
									errorDat_1="#rsSQL.OCTtransporte#"
					>
				</cfif>
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update OCtransporte
				   set 
					<cfif Arguments.Reabrir>
						OCTestado = 'A'
				   	 , OCTfechaCierre	= null
					<cfelse>
						OCTestado = 'C'
				   	 , OCTnumCierre		= OCTnumCierre + 1
				   	 , OCTfechaCierre	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					</cfif>
				     , UsucodigoCierre	= #session.Usucodigo#
				where OCTid		= #Arguments.OCTid#
			</cfquery>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				select t.OCTtransporte, OCTnumCierre
				  from OCtransporte t
				 where t.OCTid = #Arguments.OCTid#
			</cfquery>
			<cfset LvarNumero		= rsSQL.OCTtransporte>
			<cfif Arguments.ReAbrir>
				<cfset LvarReferencia	= "REABRIR #rsSQL.OCTnumCierre#">
			<cfelse>
				<cfset LvarReferencia	= "CIERRE">
				<cfif rsSQL.OCTnumCierre NEQ 1>
					<cfset LvarReferencia	= LvarReferencia & " #rsSQL.OCTnumCierre#">
				</cfif>
			</cfif>

			<cfloop query="rsCIERRE">
				<!--- 
					CIERRE: VERIFICA CONSISTENCIA DE SALDOS: ENTRADAS, SALIDAS Y EXISTENCIAS (con holgura )
				--->
				<cfif rsCIERRE.OCPTentradasCantidad LT 0 OR rsCIERRE.OCPTentradasCostoTotal LT 0>
					<cf_errorCode	code = "51584"
									msg  = "Cierre de Transporte de Transito: Error de datos, las Entradas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, EntradasCantidadTotal=@errorDat_3@, EntradasCostoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#rsCIERRE.OCPTentradasCantidad#"
									errorDat_4="#numberFormat(rsCIERRE.OCPTentradasCostoTotal,",9.99")#"
					>
				<cfelseif rsCIERRE.OCPTentradasCantidad EQ 0 AND rsCIERRE.OCPTentradasCostoTotal NEQ 0>
					<cf_errorCode	code = "51585"
									msg  = "Cierre de Transporte de Transito: Error de datos, hay Costo de Entradas Totales sin cantidad: Transporte=@errorDat_1@, Artículo=@errorDat_2@, EntradasCantidadTotal=@errorDat_3@, EntradasCostoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#rsCIERRE.OCPTentradasCantidad#"
									errorDat_4="#numberFormat(rsCIERRE.OCPTentradasCostoTotal,",9.99")#"
					>
				<cfelseif rsCIERRE.OCPTentradasCantidad EQ 0 AND rsCIERRE.OCPTsalidasCantidad NEQ 0>
					<cf_errorCode	code = "51586"
									msg  = "Cierre de Transporte de Transito: Error de datos, las Entradas Totales no pueden ser cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, EntradasCantidadTotal=@errorDat_3@, EntradasCostoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#rsCIERRE.OCPTentradasCantidad#"
									errorDat_4="#numberFormat(rsCIERRE.OCPTentradasCostoTotal,",9.99")#"
					>
		
				<cfelseif rsCIERRE.OCPTsalidasCantidad EQ 0 AND rsCIERRE.OCPTsalidasCostoTotal NEQ 0>
					<cf_errorCode	code = "51587"
									msg  = "Cierre de Transporte de Transito: Error de datos, hay Costo de Salidas Totales sin cantidad: Transporte=@errorDat_1@, Artículo=@errorDat_2@, SalidasCantidadTotal=@errorDat_3@, SalidasCostoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#-rsCIERRE.OCPTsalidasCantidad#"
									errorDat_4="#numberFormat(-rsCIERRE.OCPTsalidasCostoTotal,",9.99")#"
					>
				<cfelseif rsCIERRE.OCPTsalidasCantidad GT 0 OR rsCIERRE.OCPTsalidasCostoTotal GT 0>
					<cf_errorCode	code = "51588"
									msg  = "Cierre de Transporte de Transito: Error de datos, las Salidas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, SalidasCantidadTotal=@errorDat_3@, SalidasCostoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#-rsCIERRE.OCPTsalidasCantidad#"
									errorDat_4="#numberFormat(-rsCIERRE.OCPTsalidasCostoTotal,",9.99")#"
					>
				<cfelseif rsCIERRE.OCPTsalidasCantidad EQ 0 AND rsCIERRE.OCPTentradasCantidad NEQ 0>
					<cf_errorCode	code = "51589"
									msg  = "Cierre de Transporte de Transito: Error de datos, las Salidas Totales no pueden ser cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, SalidasCantidadTotal=@errorDat_3@, SalidasCostoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#-rsCIERRE.OCPTsalidasCantidad#"
									errorDat_4="#numberFormat(-rsCIERRE.OCPTsalidasCostoTotal,",9.99")#"
					>
		
				<cfelseif rsCIERRE.OCPTventasCantidad LT 0 OR rsCIERRE.OCPTventasMontoTotal LT 0>
					<cf_errorCode	code = "51590"
									msg  = "Cierre de Transporte de Transito: Error de datos, las Ventas Totales no pueden ser menor que cero: Transporte=@errorDat_1@, Artículo=@errorDat_2@, VentasCantidadTotal=@errorDat_3@, VentasMontoTotal=@errorDat_4@"
									errorDat_1="#rsCIERRE.OCTtransporte#"
									errorDat_2="#rsCIERRE.Acodigo#"
									errorDat_3="#rsCIERRE.OCPTventasCantidad#"
									errorDat_4="#numberFormat(rsCIERRE.OCPTventasMontoTotal,",9.99")#"
					>
		
				<cfelseif rsCIERRE.OCPTexistencias LT 0>
					<cfset LvarTolerancia = fnLeeParametro(442,"Porcentaje permitido para Existencias Negativas de Tránsito (0-9%)","1")>
					<cfif -rsCIERRE.OCPTexistencias / rsCIERRE.OCPTentradasCantidad * 100 GT LvarTolerancia>
						<cf_errorCode	code = "51591"
										msg  = "Cierre de Transporte de Transito: Los Faltantes del Articulo no puede ser mayor que un @errorDat_1@% (Parámetro 442): Transporte=@errorDat_2@, Artículo=@errorDat_3@, Existencias=@errorDat_4@, Faltante=@errorDat_5@%"
										errorDat_1="#numberFormat(LvarTolerancia,"9.99")#"
										errorDat_2="#rsCIERRE.OCTtransporte#"
										errorDat_3="#rsCIERRE.Acodigo#"
										errorDat_4="#rsCIERRE.OCPTexistencias#"
										errorDat_5="#numberFormat(-rsCIERRE.OCPTexistencias / rsCIERRE.OCPTentradasCantidad * 100,"9.99")#"
						>
					</cfif>
		
				<cfelseif rsCIERRE.OCPTexistencias GT 0>
					<cfset LvarTolerancia = fnLeeParametro(443,"Porcentaje permitido de sobrantes para Cierre de Transportes (0-99%)","10")>
					<cfif rsCIERRE.OCPTexistencias / rsCIERRE.OCPTentradasCantidad * 100 GT LvarTolerancia>
						<cf_errorCode	code = "51592"
										msg  = "Cierre de Transporte de Transito: Los Sobrantes del Articulo no puede ser mayor que un @errorDat_1@% (Parámetro 443): Transporte=@errorDat_2@, Artículo=@errorDat_3@, Existencias=@errorDat_4@, Faltante=@errorDat_5@%"
										errorDat_1="#numberFormat(LvarTolerancia,"9.99")#"
										errorDat_2="#rsCIERRE.OCTtransporte#"
										errorDat_3="#rsCIERRE.Acodigo#"
										errorDat_4="#rsCIERRE.OCPTexistencias#"
										errorDat_5="#numberFormat(rsCIERRE.OCPTexistencias / rsCIERRE.OCPTentradasCantidad * 100,"9.99")#"
						>
					</cfif>
				</cfif>
		
				<cfif rsCIERRE.OCPTexistencias NEQ 0>
					<!--- Lo normal es:
						rsCIERRE.OCPTexistencias > 0: Sobrante (+) se convierte en Salida (-)
						Sacar sobrantes del transito y pasarlo al costo:
							CREDITO		Transito 	Sobrantes
							DEBITO		Costo		Sobrantes
	
						rsCIERRE.OCPTexistencias < 0: Faltante (-) se convierte en Entrada (+)
						Sacar del Costo y Devolver Faltantes al transito:
							DEBITO		Transito 	Faltantes
							CREDITO		Costo		Faltantes
							
						En otras palabras: 
							En el Cierre se cambia de signo de Existencias (signo -1)
							En Reapertura se mantiene el signo de Existencias (signo +1) (se reversa el signo del Cierre -1*-1)
					--->
	
					<cfif NOT Arguments.Reabrir>
						<cfset LvarSigno = -1>
					<cfelse>
						<cfset LvarSigno = +1>
					</cfif>
					<cfset LvarOCPTMcantidad = rsCIERRE.OCPTexistencias * LvarSigno>
					<cfset LvarOCPTMmonto	 = rsCIERRE.OCPTsaldo 		* LvarSigno>
					<cfif LvarOCPTMcantidad GTE 0>
						<cfset LvarTipoES	= "E">
					<cfelse>
						<cfset LvarTipoES	= "S">
					</cfif>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into OCPTmovimientos
							(
								OCTid, Aid, OCid, SNid, OCCid, OCVid, 
								OCPTMtipoOD, OCPTMtipoICTV, OCPTMtipoES,
								Alm_Aid, Ocodigo,
								OCPTMfechaCV, OCPTMfecha, OCPTMfechaTC,
																
								Oorigen, OCPTMdocumentoOri, OCPTMreferenciaOri, OCPTMlineaOri, 
								
								Ecodigo, Ucodigo, 
								OCPTMcantidad,
								McodigoOrigen, 
								OCPTMmontoOrigen, 
								OCPTMmontoValuacion, 
								OCPTMmontoLocal, OCPTMtipoCambioVal,
								BMUsucodigo
							)
						values (
								#rsCIERRE.OCTid#, #rsCIERRE.Aid#, null, null, null, null, 
								'D', 'X',				<!--- DESTINO + X=CIERRE TRANSPORTE --->
								'#LvarTipoES#',			<!--- Salida=Sobrantes, Entradas=Faltantes --->
	
								null, null,
								<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
								
								'OCCT', '#LvarNumero#', '#LvarReferencia#', 0, 
	
								#Arguments.Ecodigo#, '#rsCIERRE.Ucodigo#', 
								#LvarOCPTMcantidad#,
								#LvarMcodigoValuacion#, 
								#LvarOCPTMmonto#, 
								#LvarOCPTMmonto#, 
								0, 0, 
								#session.Usucodigo#
							)
						<cf_dbidentity1 verificar_transaccion="no" name="rsSQL" datasource="#session.dsn#">
					</cfquery>
					<cf_dbidentity2 verificar_transaccion="no" name="rsSQL" datasource="#session.dsn#" returnvariable="LvarOCPTMid">
	
					<cfif rsCIERRE.OCPTtransformado EQ "0">
						<!--- 
							1) Producto No Transformado 
								Pasar de Transito de cada Movimiento Origen al Costo de cada Movimiento Destino de Producto No Transformado:
									la proporción del saldo en Transito de cada Movimiento Origen del Producto No Transformado ([TotalEntradas - TotalSalidas]/TotalEntradas),
									al costo de cada Movimiento Destino proporcional por cantidadSalida del Producto No Transformado (CantidadMovSalida/TotalSalidas)
					
									MontoMovEntrada
									 / TotalEntradas * (TotalEntradas - TotalSalidas) 
										 / TotalSalidas * CantidadMovSalida
						--->
						<!--- CREDITO: TR es normal debito * LvarSigno es negativo --->
						<!--- Sacar de Transito del Producto --->
						<cfquery datasource="#session.dsn#">
							insert into #OC_Detalle#
								(
									Tipo, OCPTMid, 
									OCTid, Aid, OCid, SNid, OCCid,
									Ocodigo, Alm_Aid, CFcuenta,
	
									OCid_O, OCTTid, OCid_D, 
			
									OCPTDmontoLocal, OCPTDmontoValuacion
								)
							select 	'TR', #LvarOCPTMid#, 
									MOVs_ORI.OCTid, MOVs_ORI.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
									MOVs_ORI.Ocodigo, null, null,
	
									MOVs_ORI.OCid, null, MOVs_DST.OCid, 
			
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
										/ pt.OCPTentradasCantidad 	* (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)
										/ pt.OCPTsalidasCantidad	* MOVs_DST.OCPTMcantidad
									*MOVs_DST.OCPTMtipoCambioVal,
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion	
										/ pt.OCPTentradasCantidad 	* (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)
										/ pt.OCPTsalidasCantidad	* MOVs_DST.OCPTMcantidad
							  from OCproductoTransito pt
								inner join OCPTmovimientos MOVs_ORI
									 on MOVs_ORI.OCTid 	= pt.OCTid
									and MOVs_ORI.Aid	= pt.Aid
									and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
								inner join OCPTmovimientos MOVs_DST
									 on MOVs_DST.OCTid 	= pt.OCTid
									and MOVs_DST.Aid	= pt.Aid
									and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
							 where pt.OCTid 				= #rsCIERRE.OCTid#
							   and pt.Aid					= #rsCIERRE.Aid#
	
							   and MOVs_ORI.OCPTMmontoValuacion <> 0
							   and MOVs_DST.OCPTMcantidad	<> 0
						</cfquery>
						<!--- DEBITO: CV/DI es normal credito * LvarSigno es negativo --->
						<!--- Meter al Costo del Producto --->
						<cfquery datasource="#session.dsn#">
							insert into #OC_Detalle#
								(
									Tipo, OCPTMid, 
									OCTid, Aid, OCid, SNid, OCCid,
									Ocodigo, Alm_Aid, CFcuenta,
	
									OCid_O, OCTTid, OCid_D, 
									
			
									OCPTDmontoLocal, OCPTDmontoValuacion
								)
							select 	case MOVs_DST.OCPTMtipoICTV 
										when 'C' then 'CV' 
										when 'I' then 'DI' 
									end, 
									#LvarOCPTMid#, 
									MOVs_DST.OCTid, MOVs_DST.Aid, MOVs_DST.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
									MOVs_DST.Ocodigo, MOVs_DST.Alm_Aid, null,
	
									MOVs_ORI.OCid, null, MOVs_DST.OCid, 
			
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
										/ pt.OCPTentradasCantidad 	* (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)
											/ pt.OCPTsalidasCantidad	* MOVs_DST.OCPTMcantidad
									*MOVs_DST.OCPTMtipoCambioVal,
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
										/ pt.OCPTentradasCantidad 	* (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)
											/ pt.OCPTsalidasCantidad	* MOVs_DST.OCPTMcantidad
							  from OCproductoTransito pt
								inner join OCPTmovimientos MOVs_ORI
									 on MOVs_ORI.OCTid 	= pt.OCTid
									and MOVs_ORI.Aid	= pt.Aid
									and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
								inner join OCPTmovimientos MOVs_DST
									 on MOVs_DST.OCTid 	= pt.OCTid
									and MOVs_DST.Aid	= pt.Aid
									and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
							 where pt.OCTid 				= #Arguments.OCTid#
							   and pt.Aid					= #rsCIERRE.Aid#
	
							   and MOVs_ORI.OCPTMmontoValuacion <> 0
							   and MOVs_DST.OCPTMcantidad		<> 0
						</cfquery>
				
						<!--- 
							2) Producto Mezclado 
								Pasar de Transito de cada Movimiento Origen del Producto Mezclado al Costo de cada Movimiento Destino de cada Producto Transformado
									la proporción del saldo en Transito de cada Movimiento Origen del Producto Mezclado ([TotalEntradas - TotalSalidas]/TotalEntradas),
									proporcional por cantidadMezclada (cantidadMezclada / TotalSalidas)
									proporcional a cada Producto Transformado (ProporcionDst)
									al costo de cada Movimiento Destino proporcional por cantidadSalida del Producto Transformado (CantidadMovSalida/TotalSalidas)
					
									MontoMovEntrada 
									 / TotalEntradas * (TotalEntradas - TotalSalidas) 
									 / TotalSalidas * CantidadMezclada
									 * ProporcionDst
										 / TotalSalidas * CantidadMovSalida
						--->
						<!--- CREDITO: TR es normal debito * LvarSigno es negativo --->
						<!--- Sacar de Transito del Producto Mezclado (TTO=Origen de la Transformacion) --->
						<cfquery datasource="#session.dsn#">
							insert into #OC_Detalle#
								(
									Tipo, OCPTMid,
									OCTid, Aid, OCid, SNid, OCCid,
									Ocodigo, Alm_Aid, CFcuenta,
	
									OCid_O, OCTTid, OCid_D, 
				
									OCPTDmontoLocal, OCPTDmontoValuacion
								)
							select 	'TR', #LvarOCPTMid#,
									TTO.OCTid, TTO.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
									MOVs_ORI.Ocodigo, null, null,
	
									MOVs_ORI.OCid, TE.OCTTid, MOVs_DST.OCid, 
		
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * (PTO.OCPTentradasCantidad + PTO.OCPTsalidasCantidad)
									  / -PTO.OCPTsalidasCantidad  * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
									*MOVs_DST.OCPTMtipoCambioVal,
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * (PTO.OCPTentradasCantidad + PTO.OCPTsalidasCantidad)
									  / -PTO.OCPTsalidasCantidad  * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
							  from OCproductoTransito PTO
								inner join OCPTmovimientos MOVs_ORI
									 on MOVs_ORI.OCTid 	= PTO.OCTid
									and MOVs_ORI.Aid	= PTO.Aid
									and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
								inner join OCtransporteTransformacionD TTO
									inner join OCtransporteTransformacion TE
										  on TE.OCTTid		= TTO.OCTTid
										 and TE.OCTTestado	= 1
									inner join OCtransporteTransformacionD TTD
										inner join OCproductoTransito PTD
											 on PTD.OCTid	= TTD.OCTid
											and PTD.Aid		= TTD.Aid
										inner join OCPTmovimientos MOVs_DST
											 on MOVs_DST.OCTid 	= TTD.OCTid
											and MOVs_DST.Aid	= TTD.Aid
											and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
										 on TTD.OCTTid 		= TTO.OCTTid
										and TTD.OCTTDtipoOD	= 'D'
									 on TTO.OCTid		= PTO.OCTid
									and TTO.Aid			= PTO.Aid
									and TTO.OCTTDtipoOD	= 'O'
							 where PTO.OCTid 				= #Arguments.OCTid#
							   and PTO.Aid					= #rsCIERRE.Aid#
	
							   and MOVs_ORI.OCPTMmontoValuacion	<> 0
							   and PTO.OCPTentradasCantidad		<> 0
							   and PTO.OCPTsalidasCantidad		<> 0
							   and MOVs_DST.OCPTMcantidad		<> 0
							   and PTD.OCPTsalidasCantidad		<> 0
						</cfquery>
						<!--- DEBITO: CV/DI es normal credito * LvarSigno es negativo --->
						<!--- Meter al Costo del Producto Transformado (TTD=Destino de la Transformacion) --->
						<cfquery datasource="#session.dsn#">
							insert into #OC_Detalle#
								(
									Tipo, OCPTMid, 
									OCTid, Aid, OCid, SNid, OCCid,
									Ocodigo, Alm_Aid, CFcuenta,
	
									OCid_O, OCTTid, OCid_D, 
			
									OCPTDmontoLocal, OCPTDmontoValuacion
								)
							select 	case MOVs_DST.OCPTMtipoICTV 
										when 'C' then 'CV' 
										when 'I' then 'DI' 
									end, 
									#LvarOCPTMid#, 
									TTD.OCTid, TTD.Aid, MOVs_DST.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
									MOVs_DST.Ocodigo, null, null,
	
									MOVs_ORI.OCid, TE.OCTTid, MOVs_DST.OCid, 
		
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * (PTO.OCPTentradasCantidad + PTO.OCPTsalidasCantidad)
									  / -PTO.OCPTsalidasCantidad  * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
									*MOVs_DST.OCPTMtipoCambioVal,
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * (PTO.OCPTentradasCantidad + PTO.OCPTsalidasCantidad)
									  / -PTO.OCPTsalidasCantidad  * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
							  from OCproductoTransito PTO
								inner join OCPTmovimientos MOVs_ORI
									 on MOVs_ORI.OCTid 	= PTO.OCTid
									and MOVs_ORI.Aid	= PTO.Aid
									and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
								inner join OCtransporteTransformacionD TTO
									inner join OCtransporteTransformacion TE
										  on TE.OCTTid		= TTO.OCTTid
										 and TE.OCTTestado	= 1
									inner join OCtransporteTransformacionD TTD
										inner join OCproductoTransito PTD
											 on PTD.OCTid	= TTD.OCTid
											and PTD.Aid		= TTD.Aid
										inner join OCPTmovimientos MOVs_DST
											 on MOVs_DST.OCTid 	= TTD.OCTid
											and MOVs_DST.Aid	= TTD.Aid
											and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
										 on TTD.OCTTid 		= TTO.OCTTid
										and TTD.OCTTDtipoOD	= 'D'
									 on TTO.OCTid		= PTO.OCTid
									and TTO.Aid			= PTO.Aid
									and TTO.OCTTDtipoOD	= 'O'
							 where PTO.OCTid 				= #Arguments.OCTid#
							   and PTO.Aid					= #rsCIERRE.Aid#
	
							   and MOVs_ORI.OCPTMmontoValuacion	<> 0
							   and PTO.OCPTentradasCantidad		<> 0
							   and PTO.OCPTsalidasCantidad		<> 0
							   and MOVs_DST.OCPTMcantidad		<> 0
							   and PTD.OCPTsalidasCantidad		<> 0
						</cfquery>
					<cfelse>
						<!--- 
							3) Producto Transformado
								Pasar de Transito del Producto Transformado, el monto de cada Movimiento Origen de cada Producto Mezclado 
								al Costo de cada Movimiento Destino del Producto Transformado
									la proporción del saldo en Transito del Producto Transformado ([TotalEntradas - TotalSalidas]/CantidadTransformada),
									al costo de cada Movimiento Destino proporcional por cantidadSalida del Producto Transformado (CantidadMovSalida/TotalSalidas)
									(CostoProductoTransformado = MontoMovEntrada / TotalEntradas * PO.cantidadMezclada * PD.ProporcionDst)
					
									MontoMovEntrada 
									 / TotalEntradas * CantidadMezclada
									 * ProporcionDst
									 / CantidadTransformada * (TotalEntradas - TotalSalidas)
										 / TotalSalidas * CantidadMovSalida
						--->
						<!--- CREDITO: TR es normal debito * LvarSigno es negativo --->
						<!--- Sacar de Transito del Producto Transformado (TTD=Destino de la Transformacion) --->
						<cfquery datasource="#session.dsn#">
							insert into #OC_Detalle#
								(
									Tipo, OCPTMid,
									OCTid, Aid, OCid, SNid, OCCid,
									Ocodigo, Alm_Aid, CFcuenta,
	
									OCid_O, OCTTid, OCid_D, 
				
									OCPTDmontoLocal, OCPTDmontoValuacion
								)
							select 	'TR', #LvarOCPTMid#,
									TTD.OCTid, TTD.Aid, MOVs_ORI.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
									MOVs_ORI.Ocodigo, null, null,
	
									MOVs_ORI.OCid, TE.OCTTid, MOVs_DST.OCid, 
		
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
									  / PTD.OCPTentradasCantidad * (PTD.OCPTentradasCantidad + PTD.OCPTsalidasCantidad)
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
									*MOVs_DST.OCPTMtipoCambioVal,
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
									  / PTD.OCPTentradasCantidad * (PTD.OCPTentradasCantidad + PTD.OCPTsalidasCantidad)
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad

							  from OCproductoTransito PTD
								inner join OCPTmovimientos MOVs_DST
									 on MOVs_DST.OCTid 	= PTD.OCTid
									and MOVs_DST.Aid	= PTD.Aid
									and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
								inner join OCtransporteTransformacionD TTD
									inner join OCtransporteTransformacion TE
										  on TE.OCTTid		= TTD.OCTTid
										 and TE.OCTTestado	= 1
									inner join OCtransporteTransformacionD TTO
										inner join OCproductoTransito PTO
											 on PTO.OCTid	= TTO.OCTid
											and PTO.Aid		= TTO.Aid
										inner join OCPTmovimientos MOVs_ORI
											 on MOVs_ORI.OCTid 	= TTO.OCTid
											and MOVs_ORI.Aid	= TTO.Aid
											and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
										 on TTO.OCTTid 		= TTD.OCTTid
										and TTO.OCTTDtipoOD	= 'O'
									 on TTD.OCTid		= PTD.OCTid
									and TTD.Aid			= PTD.Aid
									and TTD.OCTTDtipoOD	= 'D'
							 where PTD.OCTid 				= #Arguments.OCTid#
							   and PTD.Aid					= #rsCIERRE.Aid#
	
							   and MOVs_ORI.OCPTMmontoValuacion	<> 0
							   and PTO.OCPTentradasCantidad		<> 0
							   and MOVs_DST.OCPTMcantidad		<> 0
							   and PTD.OCPTentradasCantidad		<> 0
							   and PTD.OCPTsalidasCantidad		<> 0
						</cfquery>
						<!--- DEBITO: CV/DI es normal credito * LvarSigno es negativo --->
						<!--- Meter al Costo del Producto Transformado (TTD=Destino de la Transformacion) --->
						<cfquery datasource="#session.dsn#">
							insert into #OC_Detalle#
								(
									Tipo, OCPTMid, 
									OCTid, Aid, OCid, SNid, OCCid,
									Ocodigo, Alm_Aid, CFcuenta,
	
									OCid_O, OCTTid, OCid_D, 
			
									OCPTDmontoLocal, OCPTDmontoValuacion
								)
							select 	case MOVs_DST.OCPTMtipoICTV 
										when 'C' then 'CV' 
										when 'I' then 'DI' 
									end, 
									#LvarOCPTMid#, 
									TTD.OCTid, TTD.Aid, MOVs_DST.OCid, MOVs_ORI.SNid, MOVs_ORI.OCCid,
									MOVs_DST.Ocodigo, MOVs_DST.Alm_Aid, null,
	
									MOVs_ORI.OCid, TE.OCTTid, MOVs_DST.OCid, 
			
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
									  / PTD.OCPTentradasCantidad * (PTD.OCPTentradasCantidad + PTD.OCPTsalidasCantidad)
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
									*MOVs_DST.OCPTMtipoCambioVal,
									#LvarSigno# * MOVs_ORI.OCPTMmontoValuacion
									  / PTO.OCPTentradasCantidad * TTO.OCTTDcantidad
									  * TTD.OCTTDproporcionDst
									  / PTD.OCPTentradasCantidad * (PTD.OCPTentradasCantidad + PTD.OCPTsalidasCantidad)
										  / PTD.OCPTsalidasCantidad * MOVs_DST.OCPTMcantidad
							  from OCproductoTransito PTD
								inner join OCPTmovimientos MOVs_DST
									 on MOVs_DST.OCTid 	= PTD.OCTid
									and MOVs_DST.Aid	= PTD.Aid
									and MOVs_DST.OCPTMtipoOD	= 'D' AND MOVs_DST.OCPTMtipoICTV IN ('C', 'I')
								inner join OCtransporteTransformacionD TTD
									inner join OCtransporteTransformacion TE
										  on TE.OCTTid		= TTD.OCTTid
										 and TE.OCTTestado	= 1
									inner join OCtransporteTransformacionD TTO
										inner join OCproductoTransito PTO
											 on PTO.OCTid	= TTO.OCTid
											and PTO.Aid		= TTO.Aid
										inner join OCPTmovimientos MOVs_ORI
											 on MOVs_ORI.OCTid 	= TTO.OCTid
											and MOVs_ORI.Aid	= TTO.Aid
											and MOVs_ORI.OCPTMtipoOD	= 'O' AND MOVs_ORI.OCPTMtipoICTV in ('I','C','O')			<!--- No toma en cuenta movimientos Origenes de Transformación ni Cierre --->
										 on TTO.OCTTid 		= TTD.OCTTid
										and TTO.OCTTDtipoOD	= 'O'
									 on TTD.OCTid		= PTD.OCTid
									and TTD.Aid			= PTD.Aid
									and TTD.OCTTDtipoOD	= 'D'
							 where PTD.OCTid 				= #Arguments.OCTid#
							   and PTD.Aid					= #rsCIERRE.Aid#
	
							   and MOVs_ORI.OCPTMmontoValuacion	<> 0
							   and PTO.OCPTentradasCantidad		<> 0
							   and MOVs_DST.OCPTMcantidad		<> 0
							   and PTD.OCPTentradasCantidad		<> 0
							   and PTD.OCPTsalidasCantidad		<> 0
						</cfquery>
					</cfif>

					<cfquery name="rsTotalDetalle" datasource="#session.dsn#">
						select 	sum(case when Tipo='TR'  then OCPTDmontoValuacion else 0 end)	as TRANSITO,
								sum(case when Tipo<>'TR' then OCPTDmontoValuacion else 0 end)	as COSTO,
								sum(case when Tipo<>'TR' then OCPTDmontoLocal else 0 end)		as LOCAL
						  from #OC_Detalle#
						 where OCPTMid = #LvarOCPTMid#
					</cfquery>
					<cfif round(rsTotalDetalle.TRANSITO) NEQ round(rsTotalDetalle.COSTO)>
						<cf_errorCode	code = "51593"
										msg  = "El total distribuido a Transito (@errorDat_1@) no coincide con el total distribuido al COSTO (@errorDat_2@)"
										errorDat_1="#numberFormat(rsTotalDetalle.TRANSITO,",9")#"
										errorDat_2="#numberFormat(rsTotalDetalle.COSTO,",9")#"
						>
					<cfelseif round(rsTotalDetalle.TRANSITO) NEQ round(LvarOCPTMmonto)>
						<cf_errorCode	code = "51594"
										msg  = "El saldo a distribuir (@errorDat_1@) no coincide con el total distribuido (@errorDat_2@)"
										errorDat_1="#numberFormat(LvarOCPTMmonto,",9")#"
										errorDat_2="#numberFormat(rsTotalDetalle.TRANSITO,",9")#"
						>
					</cfif>

					<cfquery datasource="#session.dsn#">
						update OCPTmovimientos
						   set OCPTMmontoLocal 		= <cfif LvarOCPTMmonto LT 0>-</cfif>#numberFormat(abs(rsTotalDetalle.LOCAL),"9.99")#, 
							   OCPTMtipoCambioVal 	= #abs(rsTotalDetalle.LOCAL / rsTotalDetalle.COSTO)#
						 where OCPTMid = #LvarOCPTMid#
					</cfquery>

					<!--- OC Destino Entradas a Inventario: Ajusta el Costo de Almacen con cantidad = 0 --->
					<cfset OCDI_PosteoLin (Arguments.Ecodigo, "#LvarNumero#", "#LvarReferencia#", now(), LvarOCPTMid, 0, LvarMcodigoValuacion, session.dsn)>
				</cfif>
			</cfloop>

			<!--- Generar detalles --->
			<cfset sbGenerarDetalles(LvarAnoAux, LvarMesAux, session.dsn)>
			<cfset sbGenerarINTARC('OCCT', "#LvarNumero#", "#LvarReferencia#", LvarAnoAux, LvarMesAux, session.dsn)>
			
			<!--- Genera el Asiento Contable --->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
				<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
				<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
				<cfinvokeargument name="Efecha"			value="#now()#"/>
				<cfinvokeargument name="Oorigen"		value="OCCT"/>
				<cfinvokeargument name="Edocbase"		value="#LvarNumero#"/>
				<cfinvokeargument name="Ereferencia"	value=""/>						
				<cfinvokeargument name="Edescripcion"	value="Ordenes Comerciales Cierre de Transporte"/>
				<cfinvokeargument name="PintaAsiento"	value="#Arguments.VerAsiento#"/>
			</cfinvoke>

			<!--- Actualizar el IDcontable del Kardex --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update Kardex 
				   set IDcontable = #LvarIDcontable#
				where Kid IN
					(
						select Kid
						   from #IDKARDEX#
					)
			</cfquery>
		</cftransaction>
	</cffunction>
</cfcomponent>


