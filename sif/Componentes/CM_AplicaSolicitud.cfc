<cfcomponent>
<!---
	Cantidades:
		DScant:				Cantidad Original - Cantidad Cancelada
		DScantcancel:		Cantidad Cancelada
		DScantsurt:			Cantidad Ordenada OC + Cantidad Requisición IN - Cantidad cancelada OC (DOcantidad-DOcantsurtida al momento de la cancelación)
		Cantidad Original:	DScant + coalesce(DScantcancel,0)
		Saldo Cantidad:		DScant - DScantsurt
--->
	<cffunction name="init">
		<cfreturn This>
	</cffunction>

	<cffunction name="DBConcat" returntype="string">
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<cfreturn _Cat>
	</cffunction>

	<cffunction name="CM_AplicaSolicitud" access="public" output="true" returntype="numeric">
		<cfargument name="ESidsolicitud" type="numeric" required="true" hint="Id del encabezado de la Solicitud">
		<cfargument name="Ecodigo" 		 type="numeric" required="no"   hint="Codigo Interno de la Empresa">
		<cfargument name="EcodigoExtra"  type="numeric" required="no"   hint="Codigo Interno de otra Empresa">


		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfif NOT isdefined('Arguments.EcodigoExtra') and isdefined('Arguments.Ecodigo')>
			<cfset Arguments.EcodigoExtra = Arguments.Ecodigo>
		</cfif>

		<!----Obtiene parámetro de contratos directos----->
		<!--- <cfquery name="rsParametro" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Pcodigo = 730
		</cfquery> --->
		<!--- <cfset LvarEsContratosMultiples = (rsParametro.Pvalor EQ 1)> --->
		<!----Obtiene parámetro de múltiples contratos----->
		<cfquery name="rsParametro" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Pcodigo = 4320
		</cfquery>
		<cfset LvarContratosxTramite = (rsParametro.Pvalor EQ 1)>

		<!--- Obtiene características de la Solicitud de Compra, Parámetros de Compras, las Cuentas Financieras y las líneas de Articulos de Inventario que no deben controlar presupuesto --->
		<cfset sbObtieneConfiguracionYcuentas(arguments.ESidsolicitud, arguments.Ecodigo, false, Arguments.EcodigoExtra)>
		<cfset compradorAsignado = this.asignaCompradorSolicitud(arguments.ESidsolicitud, arguments.Ecodigo) >
		<!---
			La diferencia entre MULTIPLES CONTRATOS y CONTRATO UNICO es el dato DContratosCM.DCpreciou:
				1) En contrato unico significa:			Precio Unitario, no hay Cantidad límite del contrato (por tanto, no hay control de disponible)
				2) En múltiples contratos significa:	Precio Unico = Monto Total del Contrato, y hay Cantidad límite y Cantidad Surtida (por tanto, hay control de cantidad disponible)
					Adicionalmente, en Contratos Multiples, si hay mas de un contrato, no se generan ordenes de compra, sino que se insertan en DSProvLineasContrato
		---->

		<cfif LvarEsCompradirecta>
			<!--- GENERACION DE ORDENES DE COMPRA POR SOLICITUDES DE COMPRA DIRECTA --->
			<cfset ImpOrden = this.CM_AplicaSolicitudCompraDirecta(arguments.ESidsolicitud, arguments.Ecodigo) >
		<cfelseif not LvarConRequisicion and LvarEsContratosMultiples>
			<!--- GENERACION DE ORDENES DE COMPRA POR CONTRATOS MULTIPLES, si es por contrato --->
			<cfset this.CM_AplicaSolicitudMultipleCont(arguments.ESidsolicitud, session.Ecodigo, compradorAsignado) >
		<cfelseif not LvarConRequisicion>
			<!--- GENERACION DE ORDENES DE COMPRA POR CONTRATO UNICO, si es por contrato --->
			<cfset ImpOrden = this.CM_AplicaSolicitudContratoUnico(arguments.ESidsolicitud, arguments.Ecodigo) >
		</cfif>
			<!----Si el encabezado de la solicitud es de Requisición de Inventarios genera la Requisición cuando hay existencias en el Almacén ------>
		<cfif LvarConRequisicion>
			<!--- Si controlar Compras Inventario: No controlar Consumo sin Compras (lo que se requiza = Consumo, no se compra) --->
			<cfset requisicion = this.CM_ArticulosRequisicion(arguments.ESidsolicitud,arguments.Ecodigo,Arguments.EcodigoExtra)>
		<cfelseif LvarCPconsumoInventario>
			<!--- CPconsumo y Sin Requisición --->
			<!--- Si controlar Consumo Inventario: No controlar Compras sin Consumo (SC sin requisición = Compras de Inventario sin consumo) --->
			<cfquery name="rsSolicitudCompra" datasource="#Session.DSN#">
				update DSolicitudCompraCM
				   set DSnoPresupuesto = 1
				 where Ecodigo			= #Arguments.Ecodigo#
				   and ESidsolicitud	= #arguments.ESidsolicitud#
				   and DStipo = 'A'
			</cfquery>
		</cfif>

		<!--- Verifica presupuesto --->
		<cfset LvarNAP = this.validaPresupuesto(arguments.ESidsolicitud, arguments.Ecodigo, false, Arguments.EcodigoExtra)>
		<cfif LvarNAP gte 0 >
			<cfif LvarEsCompradirecta>
				<cfset this.cambiarEstado(arguments.ESidsolicitud, arguments.Ecodigo, 25 )>
			<cfelse>
				<cfset this.cambiarEstado(arguments.ESidsolicitud, arguments.Ecodigo, 20 )>
			</cfif>
			<cfset this.asignarNAP(arguments.ESidsolicitud, arguments.Ecodigo, LvarNAP) >
		<cfelse>
			<cfset this.cambiarEstado(arguments.ESidsolicitud, arguments.Ecodigo, -10) >
			<cfset this.asignarNRP(arguments.ESidsolicitud, arguments.Ecodigo, abs(LvarNAP) ) >
			<cftransaction action="commit" />
		</cfif>

		<cfreturn LvarNAP >

	</cffunction>

	<cffunction name="CM_RechazaSolicitud" access="public" output="true">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">

		<!--- 1. Poner estado de pendiente (0) --->
		<cfset this.cambiarEstado(arguments.ESidsolicitud, arguments.Ecodigo, 0 )>
	</cffunction>

	<cffunction name="sbObtieneConfiguracionYcuentas" access="private" output="false">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" 		 type="numeric" required="no"   hint="Codigo Interno de la Empresa">
		<cfargument name="modoConsulta" type="boolean" required="true" default="false">
		<cfargument name="EcodigoExtra"  type="numeric" required="no"   hint="Codigo Interno de otra Empresa">


		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfif NOT isdefined('Arguments.EcodigoExtra') and isdefined('Arguments.Ecodigo')>
			<cfset Arguments.EcodigoExtra = Arguments.Ecodigo>
		</cfif>

		<!----Obtiene parámetro de múltiples contratos----->
		<cfquery name="rsParametro" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Pcodigo = 730
		</cfquery>
		<cfset LvarEsContratosMultiples = (rsParametro.Pvalor EQ 1)>

		<!----Obtiene parámetro de Plan de Compras----->
		<cfquery name="rsPlanCompras" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 2300
		</cfquery>
		<cfset LvarPlanComprasActivo = (rsPlanCompras.Pvalor EQ 1)>

		<!--- Obtiene Tipo Control de Presupuesto en Compras de Articulos de Inventario--->
		<!--- 	Si controlar Consumo Inventario: No controlar Compras sin Consumo (SC sin requisición = Compras de Inventario sin consumo) --->
		<!--- 	Si controlar Compras Inventario: No controlar Consumo sin Compras (lo que se requiza = Consumo, no se compra) --->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo	= #Arguments.Ecodigo#
			   and Pcodigo	= 548
		</cfquery>
		<cfset LvarCPconsumoInventario = rsSQL.Pvalor NEQ 1>
		<cfset LvarCPcomprasInventario = NOT LvarCPconsumoInventario>

		<!--- Obtiene caracteristicas de la solicitud --->
		<cfquery name="rsSolicitudCompra" datasource="#Session.DSN#">
			select a.CMTOcodigo, a.TRcodigo, b.CMTScompradirecta, a.ESestado
			from ESolicitudCompraCM a, CMTiposSolicitud b
			where a.ESidsolicitud = #arguments.ESidsolicitud#
			and a.Ecodigo = #Arguments.Ecodigo#
			and a.Ecodigo = b.Ecodigo
			and a.CMTScodigo = b.CMTScodigo
		</cfquery>
		<cfset LvarConRequisicion	= (rsSolicitudCompra.TRcodigo NEQ "")>
		<cfset LvarEsCompraDirecta	= (rsSolicitudCompra.CMTScompradirecta EQ 1)>

		<cfif LvarConRequisicion AND LvarPlanComprasActivo>
			<cfset request.CP_Automatico = true>
		</cfif>

		<!---Validacion de estados, unicamente puede ser 0(Pendiente) ó 10(En Trámite de aprobación)
			 los estados -10(La solicitud se encuentra Rechazada por Presupuesto) se dejan pasar para que muestre el NRP--->
		<cfif rsSolicitudCompra.ESestado EQ 20>
			<cfthrow message="La solicitud se encuentra Aplicada">
		<cfelseif rsSolicitudCompra.ESestado EQ 25>
			<cfthrow message="La solicitud se encuentra en Orden Compra Directa(Aplicada)">
		<cfelseif rsSolicitudCompra.ESestado EQ 40>
			<cfthrow message="La solicitud se encuentra Parcialmente Surtida">
		<cfelseif rsSolicitudCompra.ESestado EQ 50>
			<cfthrow message="La solicitud se encuentra Surtida">
		<cfelseif rsSolicitudCompra.ESestado EQ 60>
			<cfthrow message="La solicitud se encuentra Cancelada">
		</cfif>
		<!--- Crea las cuentas financieras --->
		<cfset dataCuentaF = this.consultarCF(arguments.ESidsolicitud, arguments.Ecodigo, Arguments.EcodigoExtra) >
		<!--- Asigna cuentas financieras / Usa transaccion --->
		<cfset this.asignarCF(arguments.ESidsolicitud, arguments.Ecodigo, dataCuentaF ) >

		<cfif Arguments.modoConsulta>
			<!--- Determina las cuentas que no deben controlarse (solo cuando es consulta, sino lo determina el proceso completo) --->
			<cfif LvarConRequisicion>
				<cfif LvarCPcomprasInventario>
					<!--- CPcompras y Con Requisición: Consulta --->
					<!--- Si controlar Compras de Inventario: No controlar Solicitudes de Consumo (SC con requisición que efectivamente no hubo que comprar sino que se genera la requisición) --->
					<!--- Genera Requisición cuando las Existencias de Almacen >= Cantidad Solicitadas + Cantidad Requizadas --->
					<cfquery name="rsSolicitudCompra" datasource="#Session.DSN#">
						update DSolicitudCompraCM
						   set DSnoPresupuesto = 1
						 where Ecodigo			= #Arguments.Ecodigo#
						   and ESidsolicitud	= #arguments.ESidsolicitud#
						   and DStipo = 'A'
						   and (
								select coalesce(e.Eexistencia,0)
								  from Existencias e
								 where e.Aid		= DSolicitudCompraCM.Aid
								   and e.Alm_Aid	= DSolicitudCompraCM.Alm_Aid
								)
								>= coalesce(DSolicitudCompraCM.DScant,0)			<!--- Existencias de Articulo+Almacen --->
								+  coalesce(
									(
										select sum(rd.DRcantidad)					<!--- Requisiciones pendientes de aplicar del mismo Articulo+Almacen --->
											from ERequisicion re
												inner join DRequisicion rd
												 on rd.ERid = re.ERid
										 where rd.Aid 	= DSolicitudCompraCM.Aid
										   and re.Aid	= DSolicitudCompraCM.Alm_Aid
									)
								,0)
								+  coalesce(
									(
										select sum(aa.DScant)						<!--- Líneas anteriores de la misma solicitud para el mismo Articulo+Almacen --->
											from DSolicitudCompraCM aa
										 where aa.Aid 			= DSolicitudCompraCM.Aid
										   and aa.Alm_Aid		= DSolicitudCompraCM.Alm_Aid
										   and aa.ESidsolicitud	= DSolicitudCompraCM.ESidsolicitud
										   and aa.DSlinea		< DSolicitudCompraCM.DSlinea
									)
								,0)
					</cfquery>
				</cfif>
			<cfelseif LvarCPconsumoInventario>
				<!--- CPconsumo y Sin Requisición: Consulta --->
				<!--- Si controlar Consumo Inventario: No controlar Compras sin Consumo (SC sin requisición = Compras de Inventario sin consumo) --->
				<cfquery name="rsSolicitudCompra" datasource="#Session.DSN#">
					update DSolicitudCompraCM
					   set DSnoPresupuesto = 1
					 where Ecodigo			= #Arguments.Ecodigo#
					   and ESidsolicitud	= #Arguments.ESidsolicitud#
					   and DStipo = 'A'
				</cfquery>
			</cfif>
			<cfset sbPlanComprasInventario(Arguments.ESidsolicitud,Arguments.Ecodigo)>
		</cfif>
	</cffunction>

	<!---►►Hace la validacion de presupuesto. Retorna el NAP o el NRP generado◄◄--->
	<cffunction name="validaPresupuesto" access="public" output="false" returntype="numeric" hint="Hace la validacion de presupuesto. Retorna el NAP o el NRP generado ">
		<cfargument name="ESidsolicitud" type="numeric" required="true" hint="Id del Encabezado de la Solicitud">
		<cfargument name="Ecodigo" 		 type="numeric" required="no"   hint="Codigo Interno de la Empresa">
		<cfargument name="modoConsulta"  type="boolean" required="true">
		<cfargument name="EcodigoExtra"  type="numeric" required="no">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif NOT isdefined('Arguments.EcodigoExtra') and isdefined('Arguments.Ecodigo')>
			<cfset Arguments.EcodigoExtra = Arguments.Ecodigo>
		</cfif>

		<!---
			Proceso de Control de Presupuesto para Compras:
				Reserva,Compromete y Ejecuta a la misma cuenta que viene arrastrada desde la SC:

			Cuenta Especificada o
				Artículo de Inventario:	Centro Funcional Cuenta de Inventario	+ Clasificación Artículo
				Activos Fijos:			Centro Funcional Cuenta de Inversión	+ Tipo Concepto Servicio
				Servicios:				Centro Funcional Cuenta de Gasto		+ Categoria y Clasificación del Activo
			Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario:
				Parámetro 548 = 0: Controla el Consumo del Artículo y se hace una Compra de Inventario sin Requisición (Es una compra sin cosumo)
				Parámetro 548 = 1: Controla la Compra  del Artículo y se hace una Compra de Inventario con Requisición y se genera la Requisición (Es un consumo sin compra)
		--->

		<!---
			Tipo de Control de Presupuesto para Artículos de Inventario:
				Parámetro 548 = 0: Controlar el Consumo del Artículo
				Parámetro 548 = 1: Controlar la Compra  del Artículo

			Casos:
				SC sin Requisición							(1) Control Compras		(5) Control Consumo

				SC con Requisición
				  Con existencias							(2) Control Compras		(6) Control Consumo
				  Sin existencias y entrada al Gasto		(3) Control Compras		(7) Control Consumo
				  Sin existencias y entrada al Almacén		(4) Control Compras		(8) Control Consumo

				Casos 2 y 5:		No se debe controlar Presupuesto
									Caso 2 = Es Consumo cuando debe controlar compra
									Caso 5 = Es Compra  cuando debe controlar consumo

				Casos 1,3,4,6,7,8:	Reservar cuenta de Inventarios del Centro Funcional
		--->

		<cfif Arguments.modoConsulta>
			<cfset sbObtieneConfiguracionYcuentas(arguments.ESidsolicitud, arguments.Ecodigo, arguments.modoConsulta, Arguments.EcodigoExtra)>
		</cfif>

		<!--- Se calculan los impuestos que van al costo y los que son de Crédito Fiscal --->
		<cfquery datasource="#session.DSN#">
			update DSolicitudCompraCM
			   set DSimpuestoCosto =
				coalesce((
					select round(DSolicitudCompraCM.DStotallinest * i.Iporcentaje/100,2)
					  from Impuestos i
					 where i.Ecodigo = DSolicitudCompraCM.Ecodigo
					   and i.Icodigo = DSolicitudCompraCM.Icodigo
					   and i.Icompuesto = 0
					   and i.Icreditofiscal = 0
				),0)
				+
				coalesce((
					select sum(round(sc.DStotallinest * di.DIporcentaje/100,2))
					  from Impuestos i
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
						and di.DIcreditofiscal	= 0,
						DSolicitudCompraCM sc
					 where i.Ecodigo = DSolicitudCompraCM.Ecodigo
					   and i.Icodigo = DSolicitudCompraCM.Icodigo
					   and i.Icompuesto = 1
					   and sc.DSlinea = DSolicitudCompraCM.DSlinea
				),0)
				 , DSimpuestoCF =
				coalesce((
					select round(DSolicitudCompraCM.DStotallinest * i.Iporcentaje/100,2)
					  from Impuestos i
					 where i.Ecodigo = DSolicitudCompraCM.Ecodigo
					   and i.Icodigo = DSolicitudCompraCM.Icodigo
					   and i.Icompuesto = 0
					   and i.Icreditofiscal = 1
				),0)
				+
				coalesce((
					select sum(round(sc.DStotallinest * di.DIporcentaje/100,2))
					  from Impuestos i
						inner join DImpuestos di
						 on di.Ecodigo	= i.Ecodigo
						and di.Icodigo	= i.Icodigo
						and di.DIcreditofiscal	= 1,
						DSolicitudCompraCM sc

					 where i.Ecodigo = DSolicitudCompraCM.Ecodigo
					   and i.Icodigo = DSolicitudCompraCM.Icodigo
					   and i.Icompuesto = 1
					   and sc.DSlinea = DSolicitudCompraCM.DSlinea
				),0)
			 where Ecodigo			= #Arguments.Ecodigo#
			   and ESidsolicitud	= #arguments.ESidsolicitud#
		</cfquery>

		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<!---
			Modificado: 24/05/2006, Ing. Óscar Bonilla, MBA

			Se quita la creacion de la tabla temporal de la transaccion, para evitar bloqueos en tempdb.
			Se debe actualizar para incluirla antes de la invocación de CM_AplicaSolicitud, y antes del CFTRANSACTION en:
				<CFMX>\interfacesSoin\Componentes\CM_InterfazSolicitudes.cfc	OJO: siempre lo hace dentro de la transaccion
				<CFMX>\sif\cm\operacion\CompradorAutDetalle-aplicar.cfm			OK
				<CFMX>\sif\cm\operacion\solicitudes-sql.cfm						OK

			Se incluye metodo CM_AplicaSolicitud_WorkFlow para invocarse en 	(OJO: pero lo hace dentro de la transaccion):
				<CFMX>\sif\Componentes\Workflow\plantillas.cfc

			<cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>
		--->

		<!---
			Se calcula el monto y cantidad para NAP de Reserva:
			Util para evitar problemas con cancelación de SC y para PlanCompras Multiperíodo
		--->
		<cfquery datasource="#session.DSN#">
			update DSolicitudCompraCM
			   set DSmontoOriNAP	= round(DStotallinest + DSimpuestoCosto, 2)
				 , DScantidadNAP	= case when DScant = 0 then 1 else DScant end
			 where Ecodigo			= #Arguments.Ecodigo#
			   and ESidsolicitud	= #Arguments.ESidsolicitud#
		</cfquery>

		<!---
			Para Plan de Compras Multiperiodo.
				Los items deben controlarse por plan de compras
				Sólo puede haber una solicitud de compra, por tanto, no puede haber consumo
				(los siguientes años no deben generar Solicitud de Compra)
		 --->
		<cfif LvarPlanComprasActivo>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select pc.PCGDxPlanCompras
				  from DSolicitudCompraCM sc
					inner join PCGDplanCompras pc
						on pc.PCGDid = sc.PCGDid
				 where sc.Ecodigo			= #Arguments.Ecodigo#
				   and sc.ESidsolicitud	= #Arguments.ESidsolicitud#
				   and (
						select count(1)
						  from PCGDplanComprasMultiperiodo
						 where PCGDid = sc.PCGDid
						)>0
					and	(
							pc.PCGDxPlanCompras = 0
						<cfif NOT LvarConRequisicion>
							OR
							pc.PCGDreservado<>0 	OR
							pc.PCGDcomprometido<>0 	OR
							pc.PCGDejecutado<>0 	OR
							pc.PCGDpendiente<>0 	OR
							pc.PCGDcantidadConsumo<>0
						</cfif>
						)
			</cfquery>
			<cfif rsSQL.PCGDxPlanCompras EQ 0>
				<cfthrow message="No se puede solicitar un Plan de Compras Multiperiodo que no se controle por plan de compras">
			<cfelseif rsSQL.PCGDxPlanCompras NEQ "">
				<cfthrow message="No se puede solicitar un Plan de Compras Multiperiodo que ya haya sido consumido">
			</cfif>

			<!--- Se ajusta el NAP para reservar únicamente lo solicitado en el Período --->
			<cfquery datasource="#session.DSN#">
				update DSolicitudCompraCM
				   set DSmontoOriNAP =
							coalesce(
								(
									select round(pc.PCGDcostoOri, 2)
									  from PCGDplanCompras pc
									 where pc.PCGDid		= DSolicitudCompraCM.PCGDid
									   and pc.PCGDcostoOri	< DSolicitudCompraCM.DSmontoOriNAP
									   and pc.PCGDxPlanCompras = 1
								)
								, DSmontoOriNAP)
					 , DScantidadNAP =
							coalesce(
								(
									select case when pc.PCGDcantidad = 0 then 1 else pc.PCGDcantidad end
									  from PCGDplanCompras pc
									 where pc.PCGDid 		= DSolicitudCompraCM.PCGDid
									   and pc.PCGDcantidad 	< DSolicitudCompraCM.DScantidadNAP
									   and pc.PCGDxPlanCompras = 1
								)
								, DScantidadNAP)
				 where Ecodigo			= #Arguments.Ecodigo#
				   and ESidsolicitud	= #Arguments.ESidsolicitud#
				   and (
						select count(1)
						  from PCGDplanComprasMultiperiodo
						 where PCGDid = DSolicitudCompraCM.PCGDid
						)>0
			</cfquery>
		</cfif>

		<cfquery name="data" datasource="#session.DSN#">
			select ESidsolicitud, ESnumero, ESfecha, ESobservacion
			from ESolicitudCompraCM
			where Ecodigo=#Arguments.Ecodigo#
			and ESidsolicitud=#arguments.ESidsolicitud#
		</cfquery>

		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.Ecodigo#
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>

		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=#Arguments.Ecodigo#
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>


<!---  Inicio JMRV --->

			<!--- Obtiene las lineas del detalle de la solicitud --->
				<cfquery name="rsDetalleSolicitud" datasource="#session.DSN#">
					select a.*, b.*, round(a.DStotallinest * b.EStipocambio,2) as Monto
					from DSolicitudCompraCM a inner join ESolicitudCompraCM b
						on a.ESidsolicitud = b.ESidsolicitud
					where a.Ecodigo=#Arguments.Ecodigo#
					and a.ESidsolicitud=#arguments.ESidsolicitud#
				</cfquery>


<!--- Para cada linea --->
	<cfloop query = "rsDetalleSolicitud">

	<!--- Para las lineas que son articulos y tienen una distribucion --->
		<cfif isdefined("rsDetalleSolicitud.DStipo") and rsDetalleSolicitud.DStipo EQ "A"
		and isdefined("rsDetalleSolicitud.CPDCid") and rsDetalleSolicitud.CPDCid NEQ "" and rsDetalleSolicitud.CPDCid NEQ 0 >

		<!--- Obtiene la distribucion --->
			<cfinvoke  component="sif.Componentes.PRES_Distribucion"
			   method="GenerarDistribucion"
			   returnVariable="qryDistribucion"
			   CFid="#rsDetalleSolicitud.CFid#"
			   Cid="#rsDetalleSolicitud.Cid#"
			   Aid = "#rsDetalleSolicitud.Aid#"
			   CPDCid="#rsDetalleSolicitud.CPDCid#"
			   Cantidad="#rsDetalleSolicitud.DScant#"
			   Aplica = "1"
			   Tipo = "#rsDetalleSolicitud.DStipo#"
			   Monto="#rsDetalleSolicitud.Monto#">


		<!--- Almacena la distribucion de linea en la tabla --->
				<cfloop query="qryDistribucion">
					<cfinvoke
					component="sif.Componentes.PRES_Distribucion"
					method="insertaDistribucionSC"
					DSlinea="#rsDetalleSolicitud.DSlinea#"
					NumeroLineaReferencia="#rsDetalleSolicitud.DSconsecutivo#"
					TipoMovimiento="RC"
					LineaDistribucion="#qryDistribucion.NumLineaDistribucion#"
					CFid="#qryDistribucion.CFid#"
					rsDistribucionCuenta="#qryDistribucion.cuenta#">
				</cfloop>



		<!--- inserta cada una de las lineas de distribucion --->
		<cfloop query="qryDistribucion">

				<cfquery name="rs" datasource="#session.DSN#">
					insert into #request.intPresupuesto#(
															ModuloOrigen,
															NumeroDocumento,
															NumeroReferencia,
															FechaDocumento,
															AnoDocumento,
															MesDocumento,
															NumeroLinea,
															CFcuenta,
															Ocodigo,
															CodigoOficina,
															Mcodigo,
															MontoOrigen,
															TipoCambio,
															Monto,
															TipoMovimiento,
															PCGDid,PCGDcantidad
														)

					select  'CMSC',																								<!--- as  ModuloOrigen --->
							<cf_dbfunction name="to_char" args="b.ESnumero" > as ESnumero,										<!--- NumeroDocumento --->
							<cf_dbfunction name="to_char" args="b.ESnumero" > as ESnumero1,										<!--- NumeroReferencia --->
							b.ESfecha,																							<!--- FechaDocumento --->
							#rsPeriodoAuxiliar.Pvalor# as Periodo,																<!--- AnoDocumento --->
							#rsMesAuxiliar.Pvalor# as Mes,																		<!--- as MesDocumento --->
							(a.DSconsecutivo * 10000) + #qryDistribucion.NumLineaDistribucion#,									<!--- NumeroLinea  --->
							(select CFcuenta from CFinanciera
							 where CFformato = '#qryDistribucion.cuenta#'),														<!--- CFuenta --->
							c.Ocodigo,																							<!--- Oficina --->
							d.Oficodigo,																						<!--- as CodigoOficina --->
							b.Mcodigo,																							<!--- Mcodigo --->
							#qryDistribucion.Monto# as MontoOrigen,																<!--- as MontoOrigen --->
							1,																									<!--- as TipoCambio --->
							#qryDistribucion.Monto# as Monto,																	<!--- as MontoLocal --->
							'RC',															 									<!--- as TipoMovimiento --->
							a.PCGDid,
							#qryDistribucion.cantidad#

					from ESolicitudCompraCM b
						inner join DSolicitudCompraCM a
								inner join CFuncional c
									inner join Oficinas d
										 on d.Ocodigo = c.Ocodigo
										and d.Ecodigo = c.Ecodigo
								on c.CFid = a.CFid
						on a.ESidsolicitud = b.ESidsolicitud

					where b.ESidsolicitud=#arguments.ESidsolicitud#
					  and a.DSnoPresupuesto = 0
					  and a.DSlinea=#rsDetalleSolicitud.DSlinea#
				</cfquery>
		</cfloop> <!--- qryDistribucion --->

	<cfelse>

		<!--- inserta la linea --->
			<cfquery name="rs" datasource="#session.DSN#">
				insert into #request.intPresupuesto#(
														ModuloOrigen,
														NumeroDocumento,
														NumeroReferencia,
														FechaDocumento,
														AnoDocumento,
														MesDocumento,
														NumeroLinea,
														CFcuenta,
														Ocodigo,
														CodigoOficina,
														Mcodigo,
														MontoOrigen,
														TipoCambio,
														Monto,
														TipoMovimiento,
														PCGDid,PCGDcantidad
													)

				select  'CMSC',																								<!--- as  ModuloOrigen --->
						<cf_dbfunction name="to_char" args="b.ESnumero" > as ESnumero,										<!--- NumeroDocumento --->
						<cf_dbfunction name="to_char" args="b.ESnumero" > as ESnumero1,										<!--- NumeroReferencia --->
						b.ESfecha,																							<!--- FechaDocumento --->
						#rsPeriodoAuxiliar.Pvalor# as Periodo,																<!--- AnoDocumento --->
						#rsMesAuxiliar.Pvalor# as Mes,																		<!--- as MesDocumento --->
						a.DSconsecutivo, 																					<!--- NumeroLinea  --->
						coalesce(a.CFcuenta,a.CFidespecifica),																<!--- CFuenta --->
						c.Ocodigo,																							<!--- Oficina --->
						d.Oficodigo,																						<!--- as CodigoOficina --->
						<!--- Proporción : todos los movimientos de Reservas usan una proporcion
							  con respecto este Monto original de la Reserva
						--->
						b.Mcodigo,																							<!--- Mcodigo --->
							a.DSmontoOriNAP as MontoOrigen,																	<!--- as MontoOrigen --->
						b.EStipocambio,																						<!--- as TipoCambio --->
							round(a.DSmontoOriNAP * b.EStipocambio, 2) as Monto,											<!--- as MontoLocal --->
						'RC',																								<!--- as TipoMovimiento --->
						a.PCGDid, a.DScantidadNAP

				from ESolicitudCompraCM b
					inner join DSolicitudCompraCM a
							inner join CFuncional c
								inner join Oficinas d
									 on d.Ocodigo = c.Ocodigo
									and d.Ecodigo = c.Ecodigo
							on c.CFid = a.CFid
					on a.ESidsolicitud = b.ESidsolicitud

				where b.ESidsolicitud=#arguments.ESidsolicitud#
				  and a.DSnoPresupuesto = 0
				  and a.DSlinea=#rsDetalleSolicitud.DSlinea#
			</cfquery>
		</cfif>

	</cfloop><!--- rsDetalleSolicitud --->

<!---  Fin JMRV --->

		<!--- aprobacion o rechazo de presupuesto --->
		<cfset referencia = data.ESobservacion >
		<cfif len(referencia) gt 25>
			<cfset referencia = mid(referencia, 1, 22) & "..." >
		</cfif>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select count(1) as cantidad from #request.intPresupuesto#
		</cfquery>

		<cfif rsSQL.Cantidad EQ 0>
			<cfset LvarNAP = 0>
		<cfelse>
			<cfset LvarNAP = LobjControl.ControlPresupuestario(	"CMSC",
																data.ESnumero,
																referencia,
																data.ESfecha,
																rsPeriodoAuxiliar.Pvalor,
																rsMesAuxiliar.Pvalor,
																session.DSN,
																Arguments.Ecodigo,0,
																-1,
																arguments.modoConsulta ) >
		</cfif>

		<cfreturn LvarNAP >
	</cffunction>

	<!---►►Funcion para Modificar el estado de la Solicitud◄◄--->
	<cffunction name="cambiarEstado" access="public" output="true" hint="Funcion para Modificar el estado de la Solicitud">
		<cfargument name="ESidsolicitud" type="numeric" required="true" hint="Id del Encabezado de la Solicitud">
		<cfargument name="Ecodigo" 		 type="numeric" required="no"   hint="Codigo Interno de la Empresa">
		<cfargument name="estado" 		 type="numeric" required="true" hint="Estado">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfquery datasource="#session.DSN#">
			update ESolicitudCompraCM
			set ESestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.estado#">
				<cfif arguments.estado EQ 20 or arguments.estado EQ 25>
					, ESfechaAplica = <cf_dbfunction name="now">
				</cfif>
			where ESidsolicitud = #arguments.ESidsolicitud#
			  and Ecodigo       = #Arguments.Ecodigo#
		</cfquery>
	</cffunction>

	<cffunction name="CM_GenerarOrden" access="public" output="false" returntype="boolean">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">

		<!---
			Genera Orden de Compra cuando el tipo de solicitud de compra sea de compra directa o ya haya un contrato de por medio
			La orden de compra no va a estar aplicada, si no que va a la lista de ordenes de compra pendientes de aplicar
		--->
		<cfset ImpOrden = false>

		<!--- Verificar si la solicitud es de tipo de compra directa --->
		<cfquery name="rsCompraDirecta" datasource="#Session.DSN#">
			select a.CMTOcodigo, b.CMTScompradirecta
			from ESolicitudCompraCM a, CMTiposSolicitud b
			where a.ESidsolicitud = #arguments.ESidsolicitud#
			and a.Ecodigo = #Arguments.Ecodigo#
			and a.Ecodigo = b.Ecodigo
			and a.CMTScodigo = b.CMTScodigo
		</cfquery>

		<cfif rsCompraDirecta.CMTScompradirecta EQ 1>
			<!--- GENERACION DE ORDENES DE COMPRA POR SOLICITUDES DE COMPRA DIRECTA --->
			<cfset ImpOrden = this.CM_AplicaSolicitudCompraDirecta(arguments.ESidsolicitud, arguments.Ecodigo) >
		<cfelse>
			<!--- GENERACION DE ORDENES DE COMPRA POR CONTRATO SI EXISTIERAN --->
			<cfset ImpOrden = this.CM_AplicaSolicitudContratoUnico(arguments.ESidsolicitud, arguments.Ecodigo) >
		</cfif>
		<cfreturn ImpOrden>
	</cffunction>

	<!--- ============================================================================ --->
	<cffunction name="CM_AplicaSolicitudCompraDirecta" access="public" output="false" returntype="boolean">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">

		<cfset lvarProvCorp = false>
		<cfset lvarFiltroEcodigo = session.Ecodigo>
		<!--- Verifica si esta activa la Probeduria Corporativa --->
		<cfquery name="rsEmpresaProv" datasource="#session.DSN#">
			select EPCempresaAdmin
			from DProveduriaCorporativa dpc
				inner join EProveduriaCorporativa epc
					on epc.EPCid = dpc.EPCid
			where dpc.DPCecodigo = #session.Ecodigo#
		</cfquery>
		<cfif len(trim(rsEmpresaProv.EPCempresaAdmin))>
			<cfquery name="rsProvCorp" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = #rsEmpresaProv.EPCempresaAdmin#
				and Pcodigo=5100
			</cfquery>
			<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
				<cfset lvarFiltroEcodigo = rsEmpresaProv.EPCempresaAdmin>
				<cfset lvarProvCorp = true>
			</cfif>
		</cfif>

		<!--- Bandera para activar el conlis que muestra la orden generada --->
		<cfset ImpOrden = true>

		<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
		<cflock name="LCK_EOrdenCM#arguments.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
			<!--- Calculo de Consecutivo: ultimo + 1 --->
			<cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
				select coalesce(max(EOnumero), 0) + 1 as EOnumero
				  from EOrdenCM
				 where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				update EOrdenCM
				   set EOnumero = EOnumero
				where Ecodigo = #Arguments.Ecodigo#
				  and EOnumero = #rsConsecutivoOrden.EOnumero-1#
			</cfquery>

			<!--- Generar la Orden de Compra --->
			<!--- Encabezado de Orden de Compra --->
			<cfquery name="selectEOrdenCM" datasource="#Session.DSN#">
				select
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsecutivoOrden.EOnumero#"> as EOnumero,
					a.SNcodigo,
					a.CMCid,
					a.Mcodigo,
					a.Rcodigo,
					a.CMTOcodigo,

					a.ESOobs as Observaciones,
					a.ESOtipocambio as EOtc,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as EOrefcot,
					0.0 as Impuesto,
					0.0 as EOdesc,
					0.0 as EOtotal,

					a.CMFPid,
					a.ESOplazoint as EOplazo,
					a.ESOporcant as EOporcanticipo,
					7 as EOestado,
					ESlugarentrega
				from ESolicitudCompraCM a
				where a.Ecodigo = #Arguments.Ecodigo#
				and a.ESidsolicitud = #arguments.ESidsolicitud#
			</cfquery>
<!--- <cf_dump var=#selectEOrdenCM#> --->
			<cfquery name="insertEOrdenCM" datasource="#Session.DSN#">
				insert into EOrdenCM (
					Ecodigo, EOnumero, SNcodigo, CMCid, Mcodigo,
					Rcodigo, CMTOcodigo, EOfecha, Observaciones,
					EOtc, EOrefcot, Impuesto, EOdesc,
					EOtotal, Usucodigo, EOfalta, CMFPid,
					EOplazo, EOporcanticipo, EOestado, EOlugarentrega
					)
					VALUES(
					   #session.Ecodigo#,
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEOrdenCM.EOnumero#"         voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_integer"           value="#selectEOrdenCM.SNcodigo#"         voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEOrdenCM.CMCid#"            voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEOrdenCM.Mcodigo#"          voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectEOrdenCM.Rcodigo#"          voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectEOrdenCM.CMTOcodigo#"       voidNull>,
					   <cf_dbfunction name="now">,
					   <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="255" value="#selectEOrdenCM.Observaciones#"    voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_float"             value="#selectEOrdenCM.EOtc#"             voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEOrdenCM.EOrefcot#"         voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_money"             value="#selectEOrdenCM.Impuesto#"         voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_money"             value="#selectEOrdenCM.EOdesc#"           voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_money"             value="#selectEOrdenCM.EOtotal#"          voidNull>,
					   #session.Usucodigo#,
					   <cf_dbfunction name="now">,
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEOrdenCM.CMFPid#"           voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_integer"           value="#selectEOrdenCM.EOplazo#"          voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEOrdenCM.EOporcanticipo#"   voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_integer"           value="#selectEOrdenCM.EOestado#"         voidNull>,
					   <cf_jdbcquery_param cfsqltype="cf_sql_varchar"           value="#selectEOrdenCM.ESlugarentrega#"   voidNull>
				)
				<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="insertEOrdenCM" verificar_transaccion="false">
		</cflock>

		<!--- Detalle de Orden de Compra --->
		<cfquery name="rsDetalleSolicitud" datasource="#Session.DSN#">
			select b.*, a.CFid, c.CAid, s.Ppais, d.NumeroParte, b.CPDCid
			from ESolicitudCompraCM a
				inner join DSolicitudCompraCM b
				on a.Ecodigo = b.Ecodigo
				and a.ESidsolicitud = b.ESidsolicitud

				inner join SNegocios s
				on a.Ecodigo = s.Ecodigo
				and a.SNcodigo = s.SNcodigo

				left outer join Articulos c
				on b.Ecodigo = c.Ecodigo
				and b.Aid = c.Aid

					left outer join NumParteProveedor d
						on c.Aid = d.Aid
						and c.Ecodigo = d.Ecodigo
						and s.SNcodigo = d.SNcodigo
						and a.ESfecha between d.Vdesde and d.Vhasta

			where a.Ecodigo = #Arguments.Ecodigo#
			and a.ESidsolicitud = #arguments.ESidsolicitud#
		</cfquery>
<!--- <cf_dump var=#arguments#> --->
		<cfloop query="rsDetalleSolicitud">
			<!--- Obtener el consecutivo de la linea --->
			<cfquery name="rsConsecutivoLinea" datasource="#Session.DSN#">
				select coalesce(max(DOconsecutivo), 0) + 1 as DOconsecutivo
				from DOrdenCM
				where Ecodigo = #Arguments.Ecodigo#
				and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertEOrdenCM.identity#">
			</cfquery>

			<!--- Siempres de controla cantidad, solo cuando es Plan de Compras Gobierno y la linea no controla por cantidad --->
			<cfset LvarControlXcantidad = 1>
			<cfif  isdefined('rsDetalleSolicitud.PCGDid') and len(trim(rsDetalleSolicitud.PCGDid))>
				<cfquery name="rsControlXcantidad" datasource="#Session.DSN#">
				  Select  b.PCGDxCantidad
					  from PCGDplanCompras a
								inner join FPEPlantilla b
											 on a.FPEPid = b.FPEPid
							where a.PCGDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.PCGDid#">
						 and a.Ecodigo = #session.Ecodigo#
				</cfquery>

				<cfset LvarControlXcantidad = #rsControlXcantidad.PCGDxCantidad#>
			</cfif>

			<cfquery name="insertDOrdenCM" datasource="#Session.DSN#">
				insert into DOrdenCM (Ecodigo, EOidorden, EOnumero, DOconsecutivo, ESidsolicitud, DSlinea, CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid, CFid, Icodigo, Ucodigo, DClinea, CFcuenta, CAid, DOdescripcion, DOalterna, DOobservaciones,
								DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOfechaes, DOgarantia, Ppais, DOfechareq, numparte, FPAEid, CFComplemento, PCGDid, OBOid,
								DOcontrolCantidad, DOmontodesc, DOporcdesc, CPDCid)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetalleSolicitud.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertEOrdenCM.identity#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivoOrden.EOnumero#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsecutivoLinea.DOconsecutivo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetalleSolicitud.ESidsolicitud#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.DSlinea#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleSolicitud.DStipo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.Cid#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.Aid#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.Alm_Aid#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDetalleSolicitud.ACcodigo#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsDetalleSolicitud.ACid#" voidNull>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleSolicitud.Icodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleSolicitud.Ucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.CFcuenta#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.CAid#" voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleSolicitud.DSdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleSolicitud.DSdescalterna#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDetalleSolicitud.DSobservacion#" voidNull>,

					<cfqueryparam cfsqltype="cf_sql_float" value="#rsDetalleSolicitud.DScant#">,
					0.00,
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleSolicitud.DSmontoest#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleSolicitud.DStotallinest#">,
					<cfif Len(Trim(rsDetalleSolicitud.DSfechareq)) NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsDetalleSolicitud.DSfechareq#">,
					<cfelse>
						<cf_dbfunction name="now">,
					</cfif>
					0,
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsDetalleSolicitud.Ppais#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsDetalleSolicitud.DSfechareq#" voidNull>
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDetalleSolicitud.NumeroParte#" voidNull>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.FPAEid#" voidNull>
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsDetalleSolicitud.CFComplemento#" voidNull>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.PCGDid#" voidNull>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.OBOid#" voidNull>

					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarControlXcantidad#" voidNull>
					,0,0
					<!---JMRV. Inicio. 30/04/2014 --->
					<cfif rsDetalleSolicitud.CPDCid neq "">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.CPDCid#">
					<cfelse>
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="0">
					</cfif>
					<!---JMRV. Fin. 30/04/2014 --->
				)
			</cfquery>

			<!---UPDATE DE LA CANTIDAD SURTIDA DEL CONTRATO(con la cantidad de la OC generada)---->
			<cfif LvarContratosxTramite>
				<cfquery datasource="#session.DSN#">
					update DContratosCM
						set DCcantsurtida = DCcantsurtida + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDetalleSolicitud.DScant#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and ECid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.ECid#">
						and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleSolicitud.DClinea#">
				</cfquery>
				<!--- <cfreturn arguments.estructura> --->
			</cfif>
		</cfloop>

		<!--- Copia la forma de Pago de la SC a la OC --->
		<cfquery name="updateCMProcesoCompra" datasource="#Session.DSN#">
			insert into TESOPformaPago (
				TESOPFPtipoId, TESOPFPid, TESOPFPtipo, TESOPFPcta
			)
			select 2, #insertEOrdenCM.identity#, TESOPFPtipo, TESOPFPcta
			  from TESOPformaPago
			 where TESOPFPtipoId 	= 1
			   and TESOPFPid		= #arguments.ESidsolicitud#
			   and TESOPFPtipo		in (1,2,3)
		</cfquery>


		<cfset CalculaTotalesOC (session.Ecodigo, insertEOrdenCM.identity)>

		<!--- Actualizacion de la Solicitud de Compra --->
		<cfquery name="updateCMProcesoCompra" datasource="#Session.DSN#">
			update ESolicitudCompraCM set
				ESestado = 25
				, ESfechaAplica = <cf_dbfunction name="now">
			where Ecodigo = #Arguments.Ecodigo#
			and ESidsolicitud = #arguments.ESidsolicitud#
		</cfquery>

		<cfreturn ImpOrden>
	</cffunction>

	<!--- ============================================================================ --->
	<cffunction name="CM_AplicaSolicitudContratoUnico" access="public" output="false" returntype="boolean">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">

		<cfset ImpOrden = false>

		<!--- Verifica Parametro: No Validar Moneda en Contratos --->
		<cfset lvarNoVerificaMoneda = false>
		<cfquery name="rsNoMoneda" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			and Pcodigo=5305
		</cfquery>
		<cfif rsNoMoneda.Pvalor eq 1>
			<cfset lvarNoVerificaMoneda = true>
		</cfif>

		<!--- Verifica si esta activa la Probeduria Corporativa --->
		<cfset lvarProvCorp = false>
		<cfset lvarFiltroEcodigo = Arguments.Ecodigo>

		<cfquery name="rsEmpresaProv" datasource="#session.DSN#">
			select EPCempresaAdmin
			from DProveduriaCorporativa dpc
				inner join EProveduriaCorporativa epc
					on epc.EPCid = dpc.EPCid
			where dpc.DPCecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif len(trim(rsEmpresaProv.EPCempresaAdmin))>
			<cfquery name="rsProvCorp" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = #rsEmpresaProv.EPCempresaAdmin#
				and Pcodigo=5100
			</cfquery>
			<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
				<cfset lvarFiltroEcodigo = rsEmpresaProv.EPCempresaAdmin>
				<cfset lvarProvCorp = true>
			</cfif>
		</cfif>


		<cfif lvarProvCorp>
			<!--- Verifica Existencia de Socio de Negocio, Tipo Orden en la Empresa --->
			<cfquery name="rsExiste" datasource="#Session.DSN#">
				<!--- Articulos --->
				select distinct g.SNcodigo, g.CMTOcodigo
				from ESolicitudCompraCM a
					inner join DSolicitudCompraCM b
						on a.ESidsolicitud = b.ESidsolicitud and a.Ecodigo = b.Ecodigo and b.DStipo = 'A'
					<cfif not lvarNoVerificaMoneda>
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo
					inner join Monedas mA
						on mA.Miso4217 = m.Miso4217 and mA.Ecodigo = #lvarFiltroEcodigo#
					</cfif>
					inner join DContratosCM f
						on b.Aid = f.Aid and b.DStipo = f.DCtipoitem and #lvarFiltroEcodigo# = f.Ecodigo <cfif not lvarNoVerificaMoneda>and mA.Mcodigo = f.Mcodigo</cfif>
					inner join EContratosCM g
						on f.ECid = g.ECid and f.Ecodigo = g.Ecodigo and <cf_dbfunction name="now"> between g.ECfechaini and g.ECfechafin
				where a.Ecodigo = #Arguments.Ecodigo#
				and a.ESidsolicitud = #arguments.ESidsolicitud#

				union

				<!--- Servicios --->
				select distinct g.SNcodigo, g.CMTOcodigo
				from ESolicitudCompraCM a
					inner join DSolicitudCompraCM b
						on a.ESidsolicitud = b.ESidsolicitud and a.Ecodigo = b.Ecodigo and b.DStipo = 'S'
					<cfif not lvarNoVerificaMoneda>
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo
					inner join Monedas mA
						on mA.Miso4217 = m.Miso4217 and mA.Ecodigo = #lvarFiltroEcodigo#
					</cfif>
					inner join DContratosCM f
						on b.Cid = f.Cid and b.DStipo = f.DCtipoitem and #lvarFiltroEcodigo# = f.Ecodigo <cfif not lvarNoVerificaMoneda>and mA.Mcodigo = f.Mcodigo</cfif>
					inner join EContratosCM g
						on f.ECid = g.ECid and f.Ecodigo = g.Ecodigo and <cf_dbfunction name="now"> between g.ECfechaini and g.ECfechafin
				where a.Ecodigo = #Arguments.Ecodigo#
				and a.ESidsolicitud = #arguments.ESidsolicitud#
			</cfquery>
			<cfif rsExiste.recordcount gt 0>
				<cfquery name="rsSocioExiste" datasource="#Session.DSN#">
					select snC.SNnombre
					from SNegocios snC
					where snC.Ecodigo = #lvarFiltroEcodigo#
					  and snC.SNcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(rsExiste.SNcodigo)#" list="yes">)
					  and not exists(select 1 from SNegocios snS
							where snS.Ecodigo = #Arguments.Ecodigo# and snS.SNidentificacion = snC.SNidentificacion)
				</cfquery>
				<cfif rsSocioExiste.recordcount gt 0>
					<cfthrow message="No se han definido los siguientes Socios de Negocio en la empresa Solicitante: #ValueList(rsSocioExiste.SNnombre)#. Deberá de importarlos de la empresa Administradora.">
				</cfif>

				<cfquery name="rsTipoOrdenExiste" datasource="#Session.DSN#">
					select toC.CMTOdescripcion
					from CMTipoOrden toC
					where toC.Ecodigo = #lvarFiltroEcodigo#
					  and toC.CMTOcodigo in(<cfqueryparam cfsqltype="cf_sql_char" value="#ValueList(rsExiste.CMTOcodigo)#" list="yes">)
					  and not exists(select 1 from CMTipoOrden toS
							where toS.Ecodigo = #Arguments.Ecodigo# and toS.CMTOcodigo = toC.CMTOcodigo)
				</cfquery>
				<cfif rsTipoOrdenExiste.recordcount gt 0>
					<cfthrow message="No se han definido los siguientes Tipo de Orden en la empresa Solicitante: #ValueList(rsTipoOrdenExiste.CMTOdescripcion)#.">
				</cfif>

			</cfif>
		</cfif>

		<!--- Averiguar si hay contratos definidos para las lineas de esta solicitud de compra --->
		<cfquery name="rsAllRows" datasource="#Session.DSN#">
			<!--- Articulos --->
			select a.ESnumero, a.ESfecha, b.DSconsecutivo, b.ESidsolicitud, b.DSlinea, b.DStipo,
				   b.Cid, b.Aid, b.Alm_Aid, b.ACcodigo, b.ACid,
				   a.CFid, f.Icodigo, b.Ucodigo, b.CFcuenta, h.CAid,
				   b.DSdescripcion, b.DSdescalterna, b.DSobservacion,
				   b.DScant, 0.00 as DScantsurtida, f.DCgarantia, f.DCpreciou, f.DCdiasEntrega,
				   b.DSfechareq, <cfif lvarProvCorp>sS.SNcodigo, sS.SNnombre, sS.Ppais,<cfelse>s.SNcodigo, s.SNnombre, s.Ppais,</cfif>
				   a.CMCid, g.Rcodigo, g.CMTOcodigo, g.CMFPid, g.ECplazocredito, g.ECporcanticipo, <cfif not lvarNoVerificaMoneda>a.Mcodigo<cfelse>f.Mcodigo</cfif>, f.DCtc,
				   p.NumeroParte,
				   b.FPAEid, b.CFComplemento, b.PCGDid, b.OBOid, b.CPDCid

			from ESolicitudCompraCM a

				inner join DSolicitudCompraCM b
					on a.ESidsolicitud = b.ESidsolicitud and a.Ecodigo = b.Ecodigo and b.DStipo = 'A'

				<cfif lvarProvCorp and not lvarNoVerificaMoneda>
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo
					inner join Monedas mA
						on mA.Miso4217 = m.Miso4217 and mA.Ecodigo = #lvarFiltroEcodigo#
				</cfif>

				inner join DContratosCM f
					on b.Aid = f.Aid and b.DStipo = f.DCtipoitem and <cfif lvarProvCorp>#lvarFiltroEcodigo#<cfelse>b.Ecodigo</cfif> = f.Ecodigo <cfif not lvarNoVerificaMoneda>and <cfif lvarProvCorp>mA.Mcodigo<cfelse>a.Mcodigo</cfif> = f.Mcodigo</cfif>

				inner join EContratosCM g
					on f.ECid = g.ECid and f.Ecodigo = g.Ecodigo and <cf_dbfunction name="now"> between g.ECfechaini and g.ECfechafin

				inner join SNegocios s
					on g.SNcodigo = s.SNcodigo and g.Ecodigo = s.Ecodigo

				<cfif lvarProvCorp>
					inner join SNegocios sS
						on sS.Ecodigo = b.Ecodigo and sS.SNidentificacion = s.SNidentificacion
				</cfif>

				inner join Articulos h
					on f.Aid = h.Aid

				left outer join NumParteProveedor p
					on h.Aid = p.Aid and h.Ecodigo = p.Ecodigo and s.SNcodigo = p.SNcodigo and a.ESfecha between p.Vdesde and p.Vhasta

			where a.Ecodigo = #Arguments.Ecodigo#
			and a.ESidsolicitud = #arguments.ESidsolicitud#

			union

			<!--- Servicios --->
			select a.ESnumero, a.ESfecha, b.DSconsecutivo, b.ESidsolicitud, b.DSlinea, b.DStipo,
				   b.Cid, b.Aid, b.Alm_Aid, b.ACcodigo, b.ACid,
				   a.CFid, f.Icodigo, b.Ucodigo, b.CFcuenta, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> as CAid,
				   b.DSdescripcion, b.DSdescalterna, b.DSobservacion,
				   b.DScant, 0.00 as DScantsurtida, f.DCgarantia, f.DCpreciou, f.DCdiasEntrega,
				   b.DSfechareq, <cfif lvarProvCorp>sS.SNcodigo, sS.SNnombre, sS.Ppais,<cfelse>s.SNcodigo, s.SNnombre, s.Ppais,</cfif>
				   a.CMCid, g.Rcodigo, g.CMTOcodigo, g.CMFPid, g.ECplazocredito, g.ECporcanticipo, <cfif not lvarNoVerificaMoneda>a.Mcodigo<cfelse>f.Mcodigo</cfif>, f.DCtc,
				   <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as  NumeroParte,
				   b.FPAEid, b.CFComplemento, b.PCGDid, b.OBOid, b.CPDCid
			from ESolicitudCompraCM a

				inner join DSolicitudCompraCM b
					on a.ESidsolicitud = b.ESidsolicitud and a.Ecodigo = b.Ecodigo and b.DStipo = 'S'

				<cfif lvarProvCorp and not lvarNoVerificaMoneda>
					inner join Monedas m
						on m.Mcodigo = a.Mcodigo
					inner join Monedas mA
						on mA.Miso4217 = m.Miso4217 and mA.Ecodigo = #lvarFiltroEcodigo#
				</cfif>

				inner join DContratosCM f
					on b.Cid = f.Cid and b.DStipo = f.DCtipoitem and <cfif lvarProvCorp>#lvarFiltroEcodigo#<cfelse>b.Ecodigo</cfif> = f.Ecodigo <cfif not lvarNoVerificaMoneda>and <cfif lvarProvCorp>mA.Mcodigo<cfelse>a.Mcodigo</cfif> = f.Mcodigo</cfif>

				inner join EContratosCM g
					on f.ECid = g.ECid and f.Ecodigo = g.Ecodigo and <cf_dbfunction name="now"> between g.ECfechaini and g.ECfechafin

				inner join SNegocios s
					on g.SNcodigo = s.SNcodigo and g.Ecodigo = s.Ecodigo
				<cfif lvarProvCorp>
					inner join SNegocios sS
						on sS.Ecodigo = b.Ecodigo and sS.SNidentificacion = s.SNidentificacion
				</cfif>

			where a.Ecodigo = #Arguments.Ecodigo#
			and a.ESidsolicitud = #arguments.ESidsolicitud#
		</cfquery>

		<!--- si el parametro de contratos directos está activo, los contratos no deben jugar en los trámites de las solicitudes de compra --->
		<cfif LvarContratosxTramite>
			<cfset rsAllRows.recordCount = 0>
		</cfif>

		<!--- Si existen lineas de la solicitud de compra que tengan contratos --->
		<cfif rsAllRows.recordCount GT 0>
			<cfif lvarNoVerificaMoneda>
				<cfquery name="rsMonedas" dbtype="query">
					select distinct SNcodigo, Mcodigo
					from rsAllRows
				</cfquery>
				<cfquery name="rsMonedasD" dbtype="query">
					select SNcodigo, count(1) as Cantidad
					from rsMonedas
					group by SNcodigo
					having count(1) > 1
				</cfquery>
				<cfif rsMonedasD.recordcount gt 0>
					<cfthrow message="Solo se permiten contratos con la misma moneda en todas sus lineas, favor revisar. Proceso Cancelado!!!">
				</cfif>
			</cfif>
			<!--- Bandera para activar el conlis que muestra la orden generada --->
			<cfset ImpOrden = true>

			<cfquery name="rsProveedor" dbtype="query">
				select distinct CMCid, SNcodigo, Rcodigo, CMTOcodigo, CMFPid, ECplazocredito, ECporcanticipo, Mcodigo, DCtc, ESnumero
				from rsAllRows
			</cfquery>

			<cfset EOidordenArray = ArrayNew(1)>
			<cfset EOnumeroArray = ArrayNew(1)>
			<cfset ProveedorArray = ArrayNew(1)>
			<cfset MonedaArray = ArrayNew(1)>
			<cfset FPArray = ArrayNew(1)>

				<!--- INSERCION DE ENCABEZADOS DE ORDENES DE COMPRA --->
				<!--- Mientras existan ordenes con combinación de proveedores y moneda distintos --->
				<cfloop query="rsProveedor">
					<!--- Guardar Datos del Proveedor --->
					<cfset ArrayAppend(ProveedorArray, rsProveedor.SNcodigo)>
					<cfset ArrayAppend(MonedaArray, rsProveedor.Mcodigo)>
					<cfset ArrayAppend(FPArray, rsProveedor.CMFPid)>

					<!--- Obtiene el tipo de cambio --->
					<cfset LvarTipoCambio = 1>
					<cfquery name="rsTC" datasource="#Session.DSN#">
						select tc.TCventa
						from Htipocambio tc
						where tc.Mcodigo = #rsProveedor.Mcodigo#
						  and tc.Ecodigo = <cfqueryparam value="#Arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						  and tc.Hfecha <= <cf_dbfunction name="now">
						  and tc.Hfechah > <cf_dbfunction name="now">
					</cfquery>
					<cfif rsTC.recordcount gt 0 and rsTC.TCventa gt 0>
						<cfset LvarTipoCambio = rsTC.TCventa>
					</cfif>

					<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
					<cflock name="LCK_EOrdenCM#arguments.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
						<!--- Calculo de Consecutivo: ultimo + 1 --->
						<cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
							select coalesce(max(EOnumero), 0) + 1 as EOnumero
							  from EOrdenCM
							 where Ecodigo = #Arguments.Ecodigo#
						</cfquery>
						<cfquery datasource="#Session.DSN#">
							update EOrdenCM
							   set EOnumero = EOnumero
							where Ecodigo = #Arguments.Ecodigo#
							  and EOnumero = #rsConsecutivoOrden.EOnumero-1#
						</cfquery>

						<!--- Guardar el numero del encabezado de Orden de Compra --->
						<cfset ArrayAppend(EOnumeroArray, rsConsecutivoOrden.EOnumero)>

						<cfquery name="insertEOrdenCM" datasource="#Session.DSN#">
							insert into EOrdenCM (Ecodigo, EOnumero, SNcodigo, CMCid, Mcodigo, Rcodigo, CMTOcodigo, EOfecha, Observaciones, EOtc, EOrefcot, Impuesto, EOdesc, EOtotal, Usucodigo, EOfalta, CMFPid, EOplazo, EOporcanticipo, EOestado)
							values (
								#Arguments.Ecodigo#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivoOrden.EOnumero#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsProveedor.SNcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProveedor.CMCid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProveedor.Mcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsProveedor.Rcodigo#" null="#Len(Trim(rsProveedor.Rcodigo)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsProveedor.CMTOcodigo#">,
								<cf_dbfunction name="now">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Orden de Compra generada por Solicitud de Compra no. #rsProveedor.ESnumero#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTipoCambio#">,
								null,
								0.0,
								0.0,
								0.0,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								<cf_dbfunction name="now">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProveedor.CMFPid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsProveedor.ECplazocredito#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProveedor.ECporcanticipo#" scale="2">,
								8
							)
							<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
						</cfquery>
						<cf_dbidentity2 datasource="#Session.DSN#" name="insertEOrdenCM" verificar_transaccion="false">
						<cfset ArrayAppend(EOidordenArray, insertEOrdenCM.identity)>
					</cflock>
				</cfloop>
				<!--- INSERCION DE LINEAS DE ORDENES DE COMPRA --->
				<cfloop from="1" to="#ArrayLen(EOidordenArray)#" index="i">
					<cfquery name="rsLineas" dbtype="query">
						select *
						from rsAllRows
						where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ProveedorArray[i]#">
						and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MonedaArray[i]#">
						and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FPArray[i]#">
					</cfquery>

					<cfloop query="rsLineas">
						<!--- Obtener el consecutivo de la linea --->
						<cfquery name="rsConsecutivoLinea" datasource="#Session.DSN#">
							select coalesce(max(DOconsecutivo), 0) + 1 as DOconsecutivo
							from DOrdenCM
							where Ecodigo = #Arguments.Ecodigo#
							and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EOidordenArray[i]#">
						</cfquery>
						<cfif len(trim(rsLineas.DCdiasEntrega)) gt 0 and rsLineas.DCdiasEntrega neq 0>
							<cfset lvarFechaEst =  DateAdd('d',rsLineas.DCdiasEntrega,rsLineas.ESfecha)>
						<cfelse>
							<cfif Len(Trim(rsLineas.DSfechareq)) NEQ 0>
							   <cfset lvarFechaEst =  rsLineas.DSfechareq>
							<cfelse>
							   <cfset lvarFechaEst = Now()>
							</cfif>
						</cfif>
						<cfquery name="insertDOrdenCM" datasource="#Session.DSN#">
							insert into DOrdenCM (	Ecodigo, EOidorden, EOnumero, DOconsecutivo, ESidsolicitud, DSlinea, CMtipo, Cid, Aid, Alm_Aid, ACcodigo, ACid, CFid, Icodigo, Ucodigo, DClinea, CFcuenta, CAid, DOdescripcion, DOalterna, DOobservaciones,
													DOcantidad, DOcantsurtida, DOpreciou, DOtotal, DOfechaes, DOgarantia, Ppais, DOfechareq, numparte, FPAEid, CFComplemento, PCGDid, OBOid, DOmontodesc, DOporcdesc, CPDCid)
							values (
								#Arguments.Ecodigo#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#EOidordenArray[i]#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#EOnumeroArray[i]#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsecutivoLinea.DOconsecutivo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.ESidsolicitud#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.DSlinea#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsLineas.DStipo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.Cid#" null="#Len(Trim(rsLineas.Cid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.Aid#" null="#Len(Trim(rsLineas.Aid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.Alm_Aid#" null="#Len(Trim(rsLineas.Alm_Aid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLineas.ACcodigo#" null="#Len(Trim(rsLineas.ACcodigo)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLineas.ACid#" null="#Len(Trim(rsLineas.ACid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.CFid#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsLineas.Icodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsLineas.Ucodigo#">,
								null,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.CFcuenta#" null="#Len(Trim(rsLineas.CFcuenta)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.CAid#" null="#Len(Trim(rsLineas.CAid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineas.DSdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineas.DSdescalterna#" null="#Len(Trim(rsLineas.DSdescalterna)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineas.DSobservacion#" null="#Len(Trim(rsLineas.DSobservacion)) EQ 0#">,

								<cfqueryparam cfsqltype="cf_sql_float" value="#rsLineas.DScant#">,
								0.00,
								<cfqueryparam cfsqltype="cf_sql_money" value="#rsLineas.DCpreciou#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#rsLineas.DScant * rsLineas.DCpreciou#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFechaEst#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLineas.DCgarantia#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsLineas.Ppais#" null="#Len(Trim(rsLineas.Ppais)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsLineas.DSfechareq#" null="#Len(Trim(rsLineas.DSfechareq)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineas.NumeroParte#" null="#Len(Trim(rsLineas.NumeroParte)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.FPAEid#" null="#Len(Trim(rsLineas.FPAEid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineas.CFComplemento#" null="#Len(Trim(rsLineas.CFComplemento)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.PCGDid#" null="#Len(Trim(rsLineas.PCGDid)) EQ 0#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.OBOid#" null="#Len(Trim(rsLineas.OBOid)) EQ 0#">,
								0,0,
								<!---JMRV. Inicio. 30/04/2014 --->
								<cfif isDefined('rsDetalleSolicitud.CPDCid') && rsDetalleSolicitud.CPDCid neq "">
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.CPDCid#">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="0">
								</cfif>
								<!---JMRV. Fin. 30/04/2014 --->
							)
						</cfquery>
					</cfloop>

					<cfset CalculaTotalesOC (Arguments.Ecodigo, EOidordenArray[i])>
				</cfloop>

				<!--- Actualizacion de la Solicitud de Compra --->
				<cfquery name="updateCMProcesoCompra" datasource="#Session.DSN#">
					update ESolicitudCompraCM set
						ESestado = 20
					, ESfechaAplica = <cf_dbfunction name="now">
					where Ecodigo = #Arguments.Ecodigo#
					and ESidsolicitud = #arguments.ESidsolicitud#
				</cfquery>
		</cfif><!--- FIN GENERACION DE ORDENES DE COMPRA POR CONTRATO --->

		<!---=======================================================================================================
			APLICACION DE SOLICITUDES DE COMPRA: Se corrigió la generacion de Requisiciones para que no se generara ni 2 veces ni cuando hubiera NRP

			<!-----CON TIPO REQUISICION: VERIFICAR SI LOS ARTICULOS EN LA SOLICITUD TIENEN EN EXISTENCIA PARA ESE ALMACEN, si es afirmativo inserta en ERequisicion y DRequisicion----->
		=============================================================================================================----->

		<cfreturn ImpOrden>
	</cffunction>

	<!----=======================================================================================================
		Función para la aplicación de la solicitud cuando esta encendido el parémtros de múltiples contratos
	=============================================================================================================----->
	<cffunction name="CM_AplicaSolicitudMultipleCont" access="public" output="true">
		<cfargument name="ESidsolicitud" 	type="numeric" 	required="true">
		<cfargument name="Ecodigo" 			type="numeric" 	required="true" default="#session.Ecodigo#">
		<cfargument name="CMCid" 			type="numeric" 	required="false" default="-1">

		<!----//////////////////////////////////////////////////////////////////////////////
			Nota: Siempre que las cantidades de uno o varios contratos, no alcance
			para surtir la solicitud, se hace una separación de la línea de la misma
			donde se ACTUALIZA la cantidad solicitada (DScant) por las cantidades que si
			se pueden surtir por contratos, y se crea UNA nueva línea cuyo valor de DScant
			son las cantidades que se envian a proceso de compra.
		///////////////////////////////////////////////////////////////////////////////////----->

		<!---Variables---->
		<cfset vnLineaAsignada = 0>			<!---Variable con la cantidad de lineas que fueron asignadas---->
		<cfset vnLineas = 0>				<!---Variable con la cantidad de lineas de la solicitud---->
		<cfset vnOrdenes = structnew()>		<!---Estructura con las ordenes de compra creadas para el Socio Negocio (SNcodigo)---->
		<cfset vnCMCid = ''>				<!---Variable con el CMCid (comprador) 	que será asignado a todas las OC generadas por los contratos---->

		<!---- ACTUALIZAR EL COMPRADOR ASIGNADO EN EL ENCABEZADO DE LA SOLICITUD ---->
		<cfif Arguments.CMCid EQ -1>
			<cfset vnCMCid = this.asignaCompradorSolicitud(arguments.ESidsolicitud, arguments.Ecodigo) >
		<cfelse>
			<cfset vnCMCid = Arguments.CMCid>
		</cfif>

		<!---- 2.4 VER SI TIENE CONTRATOS Y CUANTOS ----->
		<!--- 1. Traer todas las lineas de la solicitud---->
		<cfquery name="rsLineaSolic" datasource="#session.DSN#">
			select 	a.DSlinea,
					a.Aid,
					a.Cid,
					a.ACid,
					b.ESfecha,
					b.CMTScodigo,
					b.CFid,
					a.DScant,
					c.CFcomprador,
					c.CFautoccontrato,
					b.EStotalest

			from DSolicitudCompraCM a

				inner join ESolicitudCompraCM b
					on a.ESidsolicitud = b.ESidsolicitud
					and a.Ecodigo = b.Ecodigo

					inner join CFuncional c
						on b.CFid = c.CFid
						and b.Ecodigo = c.Ecodigo
			where a.Ecodigo = #Arguments.Ecodigo#
				and a.ESidsolicitud = #arguments.ESidsolicitud#
		</cfquery>
		<!---- 2.RECORRER CADA LINEA DE LA SOLICITUD----->
		<cfloop query="rsLineaSolic">
			<cfset vnCantSolic = 0>						<!---Limpiar la variable de cantidades solicitadas---->
			<cfset vnCantDisponible = 0>				<!---Limpiar la variable de cantidades disponibles---->
			<cfset vnLinea = rsLineaSolic.DSlinea>		<!---Variable numerica (vn) con el ID de la linea que se va a procesar----->
			<cfset vnCantSolic = rsLineaSolic.DScant>	<!---Variable con la cantidad de bienes solicitados---->
			<cfset vnCMCidLinea = "">						<!---Variable con el comprador asignado---->
			<!--- 3. Verificar si tiene contratos y cuantos---->
			<cfquery name="rsTieneContratos" datasource="#session.DSN#">
				select count(1) as CantContratos
				from DSolicitudCompraCM a
					inner join DContratosCM b
						on a.Ecodigo = b.Ecodigo
						and a.Ucodigo = b.Ucodigo
						<cfif isdefined("rsLineaSolic.Aid") and len(trim(rsLineaSolic.Aid))><!---Si es un articulo---->
							and a.Aid = b.Aid
						<cfelseif isdefined("rsLineaSolic.Cid") and len(trim(rsLineaSolic.Cid))><!---Si es un servicio---->
							and a.Cid = b.Cid
						<cfelse><!---Si es un activo--->
							and a.ACid = b.ACid
						</cfif>
						and (coalesce(b.DCcantcontrato,0) - coalesce(b.DCcantsurtida,0)) > 0	<!---La cantidad disponible del contrato es mayor a 0, es decir hay diponible--->

					inner join EContratosCM c
						on b.ECid = c.ECid
						and b.Ecodigo = c.Ecodigo
						and <cf_dbfunction name="now"> between c.ECfechaini and c.ECfechafin

				where a.Ecodigo = #Arguments.Ecodigo#
					and a.ESidsolicitud = #arguments.ESidsolicitud#
					and a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnLinea#">
					<cfif isdefined("rsLineaSolic.Aid") and len(trim(rsLineaSolic.Aid))><!---Si es un articulo---->
						and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaSolic.Aid#">
					<cfelseif isdefined("rsLineaSolic.Cid") and len(trim(rsLineaSolic.Cid))><!---Si es un servicio---->
						and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaSolic.Cid#">
					<cfelse><!---Si es un activo--->
						and a.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineaSolic.ACid#">
					</cfif>
			</cfquery>

			<!--- si el parametro de contratos directos está activo, los contratos no deben jugar en los trámites de las solicitudes de compra --->
			<cfif LvarContratosxTramite>
				<cfset rsTieneContratos.CantContratos = 0>
			</cfif>

			<!----4. EL BIEN NO TIENE CONTRATOS----->
			<cfif rsTieneContratos.CantContratos EQ 0>
				<!---ENVIA A PROCESO DE PUBLICACION DE COMPRAS: Asigna el comprador del Encabezado Solicitud --->
				<cfset this.asignaCompradorLinea(arguments.ESidsolicitud, arguments.Ecodigo, vnLinea, vnCMCid)>

			<!---5. EL BIEN TIENE UNO O MAS CONTRATOS---->
			<cfelse>
				<!----Asigna comprador----->
				<cfquery name="rsContratos" datasource="#session.DSN#"><!----Traer los contratos----->
					select 	e.ECid,
							e.CMTOcodigo,
							e.CMFPid,
							e.CMIid,
							e.ECplazocredito,
							e.ECporcanticipo,
							e.ECtiempoentrega,
							d.Mcodigo,
							d.DCtipoitem,
							d.Cid,
							d.Aid,
							d.ACcodigo,
							d.ACid,
							d.Icodigo,
							d.Ucodigo,
							d.DCdescripcion,
							d.DCdescalterna,
							c.DSobservacion,
							coalesce(d.DCtc,1.0) as DCtc,
							coalesce(d.DCcantcontrato,0) as DCcantcontrato,
							coalesce(d.DCpreciou / d.DCcantcontrato,0) as DCpreciou,
							d.DCgarantia,
							d.DClinea,
							coalesce(d.DCcantcontrato,0) - coalesce(d.DCcantsurtida,0) as CantDisponible,
							coalesce(d.DCcantsurtida,0) as DCcantsurtida,
							c.ESidsolicitud,
							c.DSlinea,
							coalesce(c.DScant,0) as DScant,
							e.SNcodigo,
							f.CFid,
							c.DSfechareq,
							f.CMTScodigo,
							coalesce(d.DCpreciou, 0.00) as totalLinea,
							f.NAP,
							f.NAPcancel,
							c.FPAEid,
							c.CFComplemento,
							c.PCGDid,
							c.OBOid

					from	DSolicitudCompraCM c

							inner join ESolicitudCompraCM f
								on c.ESidsolicitud = f.ESidsolicitud
								and c.Ecodigo = f.Ecodigo

							inner join DContratosCM d
								on c.Ecodigo = d.Ecodigo
								<!---El bien del contrato tenga la misma unidad de medida que la solicitud---->
								and c.Ucodigo = d.Ucodigo
								and c.DStipo = d.DCtipoitem
								<!---La cantidad disponible del contrato es mayor a 0, es decir hay diponible--->
								and (coalesce(d.DCcantcontrato,0) - coalesce(d.DCcantsurtida,0)) > 0
								<cfif isdefined("rsLineaSolic.Aid") and len(trim(rsLineaSolic.Aid))><!---Si es un articulo---->
									and c.Aid = d.Aid
								<cfelseif isdefined("rsLineaSolic.Cid") and len(trim(rsLineaSolic.Cid))><!---Si es un servicio---->
									and c.Cid = d.Cid
								<cfelse><!---Si es un activo--->
									and c.ACid = d.ACid
								</cfif>
								inner join EContratosCM e
									on d.ECid = e.ECid
									<!----Al momento/dia de la aplicacion este vigente el contrato----->
									and <cf_dbfunction name="now"> between e.ECfechaini and e.ECfechafin

					where c.Ecodigo = #Arguments.Ecodigo#
						and c.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnLinea#">
				</cfquery>

				<!---4.1 EL BIEN TIENE 1 SOLO CONTRATO---->
				<cfif rsTieneContratos.CantContratos EQ 1>
					<cfset vnCantDisponible = rsContratos.CantDisponible>	<!---Varibles con la cantidad disponible en el contrato---->
					<!---Obtiene el comprador asignado---->
					<cfset vnCMCidLinea = this.DeterminaCompradorContrato_CMult(rsLineaSolic.CMTScodigo,rsLineaSolic.CFid)>
					<!---Asigna al comprador por linea de la solicitud----->
					<cfset this.asignaCompradorLinea(arguments.ESidsolicitud, arguments.Ecodigo, vnLinea, vnCMCidLinea)>
					<!---- SI LA CANTIDAD DISPONIBLE DEL BIEN EN EL CONTRATO ES MAYOR O IGUAL A LA SOLICITADA EN LA LINEA---->
					<cfif vnCantDisponible GTE vnCantSolic>
						<!----	Se genera OC para proveedor/socio de negocio, al que aun no se le haya "abierto" un encabezado (OC),
								Si ya existiera uno solamente se le agrega una línea a la misma, esto para evitar crear una OC por c/linea---->
						<cfset vnOrdenes = this.CrearOrden(rsContratos.SNcodigo, rsContratos, vnOrdenes, vnCMCidLinea, rsContratos.DScant,0)>
					<!----SI LA CANTIDAD DISPONIBLE DEL CONTRATO ES MENOR QUE LA SOLICITADA---->
					<cfelseif vnCantDisponible LT vnCantSolic>
						<!----	Se genera OC para proveedor/socio de negocio, al que aun no se le haya "abierto" un encabezado (OC),
								Si ya existiera uno solamente se le agrega una línea a la misma, esto para evitar crear una OC por c/linea---->
						<!----Se crea orden de compra por la cantidad que puede ser surtida por contratos---->
						<cfset vnOrdenes = this.CrearOrden(rsContratos.SNcodigo, rsContratos, vnOrdenes, vnCMCidLinea, vnCantDisponible, 0)>
						<!---Actualización de cantidad y total de la linea de la solicitud----->
						<cfset this.ActualizaLineaSolicitud(arguments.ESidsolicitud,vnLinea,vnCantDisponible)>
						<cfset vnCantSolic =  vnCantSolic - vnCantDisponible><!---Se actualiza la cantidad solicitada---->
						<!---SOBRAN LINEAS INSERTA UNA LINEA POR LAS QUE VAN AL PROCESO DE PUBLICACION---->
						<cfif vnCantSolic NEQ 0>
							<!---Inserta linea por las cantidades que sobraron (van al proceso de publicacion)----->
							<cfset this.CrearLineaSolicitud(arguments.ESidsolicitud,vnLinea,vnCantSolic,vnCMCid)>
						</cfif><!---Fin de si sobran lineas---->
					</cfif><!---Fin de la cantidad disponible >= que la solicitada----->
					<!----ENVIAR CORREOS AL AUTORIZADOR DE OC DE LA LINEA Y USUARIOS AUTORIZADOS POR EL---->
					<cfset this.EnviodeCorreos(vnCMCidLinea, arguments.Ecodigo, 'Orden de Compra',arguments.ESidsolicitud, 'Solicitud')>

				<!----4.2. EL BIEN TIENE N CONTRATOS---->
				<cfelse>
					<!----Obtener el comprador---->
					<cfset vnCMCidLinea = this.DeterminaCompradorContrato_CMult(rsLineaSolic.CMTScodigo,rsLineaSolic.CFid)>
					<!---Asigna al comprador por linea de la solicitud(que quedará para surir por proceso de publicacion)----->
					<cfset this.asignaCompradorLinea(arguments.ESidsolicitud, arguments.Ecodigo, vnLinea, vnCMCid)>
					<!---Seleccionar sumatoria de bienes en los contratos existentes---->
					<cfquery name="Contrato" dbtype="query">
						select sum(DCcantcontrato - DCcantsurtida) as TotalContratos
						from rsContratos
					</cfquery>
					<cfset vnCantDisponible	= Contrato.TotalContratos>
					<!---- SI LA CANTIDAD DISPONIBLE DEL BIEN EN LOS CONTRATOS ES MAYOR O IGUAL A LA SOLICITADA EN LA LINEA---->
					<cfif vnCantDisponible GTE vnCantSolic>
						<!---a)Inserta linea en DSProvLineasContrato---->
						<cfset this.InsertaSeleccionProveedor(vnLinea, arguments.Ecodigo)>
					<!----SI LA CANTIDAD DISPONIBLE DE LOS CONTRATOS ES MENOR QUE LA SOLICITADA---->
					<cfelseif vnCantDisponible LT vnCantSolic>
						<!---DIVIDE LINEA (ACTUALIZA LA CANTIDAD POR LOS CONTRATOS Y CREA NUEVA LINEA POR LAS QUE VAN A SER SURTIDAS POR PROCESO DE PUBLICACION--->
						<cfset vnCantContratos = vnCantSolic - vnCantDisponible><!---Cantidad que puede ser surtida por contratos--->
						<!---a)Actualiza la cantidad que puede ser surtida por contratos en la linea de la solicitud--->
						<cfset this.ActualizaLineaSolicitud(arguments.ESidsolicitud,vnLinea,vnCantDisponible)>
						<!---b)Inserta la nueva linea por las que sobran que seran surtidas por Proceso de compra--->
						<cfset this.CrearLineaSolicitud(arguments.ESidsolicitud,vnLinea,vnCantContratos,vnCMCid)>
						<!----c)Inserta en el encabezado de selección de proveedores---->
						<cfset this.InsertaSeleccionProveedor(vnLinea, arguments.Ecodigo)>
					</cfif><!---Fin de la cantidad disponible >= que la solicitada----->
					<!----ENVIAR CORREOS AL AUTORIZADOR DE OC ---->
					<cfset this.EnviodeCorreos(vnCMCidLinea, arguments.Ecodigo, 'Selección de proveedores',arguments.ESidsolicitud, 'Solicitud')>
				</cfif><!---Fin de si tiene uno o mas contratos--->
			</cfif><!---Fin de si tiene contratos---->
		</cfloop><!---Fin de loop de lineas de la solicitud---->
	</cffunction>

	<!---►►Funcion para Validar si se puede aplicar la Solicitud de Compra◄◄--->
	<cffunction name="puedeAplicar" access="public" output="true" returntype="boolean" hint="Funcion para Validar si se puede aplicar la Solicitud de Compra">
		<cfargument name="ESidsolicitud" type="numeric" required="true" hint="Id del Encabezado de la Solicitud">
		<cfargument name="Ecodigo" 		 type="numeric" required="no"   hint="Codigo Interno de la Empresa">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<!--- Valida que la solicitud tenga lineas de detalle --->
		<cfquery name="rs1" datasource="#session.DSN#">
			select count(1) as cantidad
			from DSolicitudCompraCM
			where ESidsolicitud = #arguments.ESidsolicitud#
			  and Ecodigo       = #Arguments.Ecodigo#
		</cfquery>
		<cfif rs1.cantidad gt 0 >
			<cfquery name="rs2" datasource="#session.DSN#">
				select count(1) as cantidad
				from DSolicitudCompraCM
				where ESidsolicitud = #arguments.ESidsolicitud#
				  and Ecodigo       = #Arguments.Ecodigo#
				  and ( DSmontoest <= 0 or DScant <= 0 )
			</cfquery>
			<cfif rs2.cantidad gt 0>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="asignarNAP" access="public" output="true">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="NAP" type="numeric" required="true" >

		<cfquery datasource="#session.DSN#">
			update ESolicitudCompraCM
			set NAP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.NAP#">
			where ESidsolicitud = #arguments.ESidsolicitud#
			  and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
	</cffunction>

	<cffunction name="asignarNRP" access="public" output="true">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="NRP" type="numeric" required="true" >

		<cfquery datasource="#session.DSN#">
			update ESolicitudCompraCM
			set NRP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.NRP#">
			where ESidsolicitud = #arguments.ESidsolicitud#
			  and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
	</cffunction>

	<!---►►Funcion para recuperar la información de la Solicitud de Compra◄◄--->
	<cffunction name="obtenerTiposolicitud" access="public" returntype="query" output="true" hint="Funcion para recuperar la información de la Solicitud de Compra">
		<cfargument name="ESidsolicitud" type="numeric" required="true" hint="Id del Encabezado de la Solicitud">

		<cfquery name="rsTipo" datasource="#session.DSN#">
			select ts.CMTScodigo, ts.CMTSasignacion,ts.CMTSconRequisicion, es.CFid, es.ESnumero
			from ESolicitudCompraCM es
				inner join CMTiposSolicitud ts
					on ts.Ecodigo = es.Ecodigo and ts.CMTScodigo = es.CMTScodigo
			where es.ESidsolicitud = #Arguments.ESidsolicitud#
		</cfquery>
		<cfreturn rsTipo>
	</cffunction>

	<cffunction name="obtenerCompradorCF" access="public" returntype="query" output="true">
		<cfargument name="CFpk" type="numeric" required="true">

		<cfquery name="rsCFComprador" datasource="#session.DSN#">
			select CFcomprador as CMCid
			 from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFpk#">
			  and CFcomprador is not null
		</cfquery>

		<cfreturn rsCFComprador >
	</cffunction>

	<cffunction name="obtenerComprador" access="public" returntype="numeric" output="true">
		<cfargument name="CMTScodigo" type="string"  required="yes">
		<cfargument name="Ecodigo" 	  type="numeric" required="no">

		<cfif NOT isdefined('Arguments.Ecodigo') and Isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<!---►►Proveeduría Corporativa◄◄--->
		<cfquery name="rsProvCorp" datasource="#session.DSN#">
			select Coalesce(Pvalor, 'N') Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 5100
		</cfquery>
		<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
			<cfquery name="rsDProvCorp" datasource="#session.DSN#">
				select Ecodigo from DProveduriaCorporativa where DPCecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfif rsDProvCorp.recordCount>
				<cfset Arguments.Ecodigo = rsDProvCorp.Ecodigo>
			</cfif>
		</cfif>

		<cfset compradorAsignado = "" >

		<!--- seleccionar los compradores que atienden el mismo tipo de solicitud de la orden --->
		<!--- o todos los compradores que no tienen especializacion definida (pueden comprar de todo) --->
		<cfquery name="dataComprador" datasource="#session.DSN#">
			select a.CMCid
			 from CMEspecializacionComprador a

			inner join CMCompradores b
				on a.CMCid	     = b.CMCid
			  and b.CMCestado    = 1
			  and b.CMCparticipa = 1

			where a.Ecodigo		= #Arguments.Ecodigo#
			  and a.CMTScodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CMTScodigo#">

			union

			select CMCid
			 from CMCompradores
			where Ecodigo    	= #Arguments.Ecodigo#
			  and CMCestado		= 1
			  and CMCparticipa	= 1
			  and CMCid not in ( select CMCid
								   from CMEspecializacionComprador
								  where Ecodigo = #Arguments.Ecodigo# )
		</cfquery>

		<cfif dataComprador.RecordCount gt 0>
			<cfquery name="dataCarga" datasource="#session.DSN#">
				select a.CMCid, (select count(1) from ESolicitudCompraCM b where b.CMCid = a.CMCid) as carga
				from CMCompradores a
				where a.Ecodigo      = #Arguments.Ecodigo#
				  and a.CMCparticipa = 1
				  and a.CMCid in ( <cfif len(trim(ValueList(dataComprador.CMCid)))>#ValueList(dataComprador.CMCid)#<cfelse>-1</cfif> )
				order by carga asc
			</cfquery>
			<cfset compradorAsignado = dataCarga.CMCid>
		<cfelse>
			<!--- asigna el comprador default --->
			<cfquery name="dataCDefault" datasource="#session.DSN#">
				select CMCid
				from CMCompradores
				where Ecodigo = #Arguments.Ecodigo#
				  and CMCdefault=1
			</cfquery>

			<cfif dataCDefault.RecordCount gt 0 >
				<cfset compradorAsignado = dataCDefault.CMCid>
			<cfelse>
				<cf_errorCode	code = "51093" msg = "No se encontró Comprador para quién asociar esta solicitud">
			</cfif>
		</cfif>

		<cfreturn compradorAsignado>
	</cffunction>

	<!--- ============================================================================ --->
	<!--- FUNCIONES PARA LA PARTE DE PRESUPUESTO 									   --->
	<!--- ============================================================================ --->
	<cffunction name="AplicarMascara" access="public" output="true" returntype="string">
		<cfargument name="cuenta"   type="string" required="true">
		<cfargument name="objgasto" type="string" required="true">

		<cfset vCuenta = arguments.cuenta >
		<cfset vObjgasto = arguments.objgasto >

		<cfif len(trim(vCuenta))>
			<cfloop condition="Find('?',vCuenta,0) neq 0">
				<cfif len(trim(vObjgasto))>
					<cfset caracter = mid(vObjgasto, 1, 1) >
					<cfset vObjgasto = mid(vObjgasto, 2, len(vObjgasto)) >
					<cfset vCuenta = replace(vCuenta,'?',caracter) >
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn vCuenta >
	</cffunction>

	<cffunction name="consultarCF" access="public" output="true" returntype="query">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="EcodigoExtra"  type="numeric" required="no"   hint="Codigo Interno de otra Empresa">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfif NOT isdefined('Arguments.EcodigoExtra') and isdefined('Arguments.Ecodigo')>
			<cfset Arguments.EcodigoExtra = Arguments.Ecodigo>
		</cfif>

		<cfset tmp = "">
		<cfset dataCuentaF = QueryNew("formato,fecha,DSlinea,Ocodigo") >

		<!--- Se escogen las Cuentas que en la Solicitud se indicó: Especificar Cuentas, siempre que no se hallan calculado anteriormente --->
		<cfquery name="data2" datasource="#session.DSN#">
			select a.DSlinea, b.ESfecha as fecha, c.CFformato as formato
					, (select Ocodigo from CFuncional where CFid = a.CFid) as Ocodigo
			from ESolicitudCompraCM b
				inner join DSolicitudCompraCM a
				on a.ESidsolicitud=b.ESidsolicitud

				inner join CFinanciera c
				on a.CFidespecifica=c.CFcuenta

			where a.DSespecificacuenta = 1
			and a.Ecodigo=#Arguments.Ecodigo#
			and a.ESidsolicitud = #arguments.ESidsolicitud#
			and a.CFcuenta is null
		</cfquery>

		<cfloop query="data2">
			<cfset newRow = QueryAddRow(dataCuentaF, 1)>
			<cfset temp = QuerySetCell(dataCuentaF, "formato", trim(data2.formato) )>
			<cfset temp = QuerySetCell(dataCuentaF, "fecha", data2.fecha)>
			<cfset temp = QuerySetCell(dataCuentaF, "DSlinea", data2.DSlinea)>
			<cfset temp = QuerySetCell(dataCuentaF, "Ocodigo", data2.Ocodigo)>
		</cfloop>

		<!--- Se Arman las Cuentas que en la Solicitud No se indicó: Especificar Cuentas, siempre que no se hallan calculado anteriormente --->

		<!--- Articulos:	CentroFuncional Inventarios	+ Complemento de la Clasificación del Articulo --->
		<!--- Servicio:		CentroFuncional Gastos		+ Complemento del Tipo de Concepto de Servicio --->
		<!--- ActivoFijos:	CentroFuncional Inversiones	+ Complemento de la Categoria + Clasificación del Activo --->
		<cfquery name="data1" datasource="#session.DSN#">
			select  a.CFid, a.DStipo, a.Aid, a.Cid, a.ACcodigo, a.ACid,
					(select SNid from SNegocios where Ecodigo=b.Ecodigo and SNcodigo=b.SNcodigo) as SNid,
					b.ESfecha as fecha,
					a.DSlinea
					, (select Ocodigo from CFuncional where CFid = a.CFid) as Ocodigo
					, a.CFComplemento as actEmpresarial
			  from DSolicitudCompraCM a
				inner join ESolicitudCompraCM b
					 on b.ESidsolicitud=a.ESidsolicitud
			where a.Ecodigo		  = #Arguments.Ecodigo#
			  and a.ESidsolicitud = #arguments.ESidsolicitud#
			  and a.DSespecificacuenta = 0
			  and a.CFcuenta is null
		</cfquery>
		<cfloop query="data1">
			<cfset newRow = QueryAddRow(dataCuentaF, 1)>
			<cfif NOT LEN(TRIM(data1.SNid))>
				<cfset data1.SNid = -1>
			</cfif>

			<!---►►Se sustituyen los "?" por el Objeto de gasto configurado en el Auxiliar  y los los "_" por el complemento de la Actividad Empresarial◄◄--->
			<cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
				<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="CFid" 			value="#data1.CFid#"/>
				<cfinvokeargument name="SNid" 			value="#data1.SNid#"/>
				<cfinvokeargument name="tipoItem" 		value="#data1.DStipo#"/>
				<cfinvokeargument name="Aid" 			value="#data1.Aid#"/>
				<cfinvokeargument name="Cid" 			value="#data1.Cid#"/>
				<cfinvokeargument name="ACcodigo" 		value="#data1.ACcodigo#"/>
				<cfinvokeargument name="ACid" 			value="#data1.ACid#"/>
				<cfinvokeargument name="ActEcono" 		value="#data1.actEmpresarial#"/>
				<cfinvokeargument name="EcodigoExtra" 	value="#Arguments.EcodigoExtra#"/>
			</cfinvoke>
			<cfset temp = QuerySetCell(dataCuentaF, "formato", LvarCFformato)>
			<cfset temp = QuerySetCell(dataCuentaF, "fecha",   data1.fecha)>
			<cfset temp = QuerySetCell(dataCuentaF, "DSlinea", data1.DSlinea)>
			<cfset temp = QuerySetCell(dataCuentaF, "Ocodigo", data1.Ocodigo)>
		</cfloop>

		<cfreturn dataCuentaF >
	</cffunction>

	<!--- Asigna a las lineas de la solicitud un id de Cuenta Financiera --->
	<cffunction name="asignarCF" access="public" output="false" >
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="dataCuentaF" type="query" required="true" >

		<cfif dataCuentaF.recordcount gt 0>

			<cfloop query="dataCuentaF">
				<cfif not len(trim(dataCuentaF.formato)) >
					<cfquery name="info" datasource="#session.DSN#">
						select DSconsecutivo
						from DSolicitudCompraCM
						where DSlinea = #dataCuentaF.DSlinea#
					</cfquery>
					<cf_errorCode	code = "51094"
									msg  = "No se generó la Cuenta Financiera para la línea @errorDat_1@ de la solicitud. Verifique los datos.<br>Proceso cancelado."
									errorDat_1="#info.DSconsecutivo#"
					>
				</cfif>

				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
					<cfinvokeargument name="Lprm_CFformato" 		value="#dataCuentaF.formato#"/>
					<cfinvokeargument name="Lprm_fecha" 			value="#dataCuentaF.fecha#"/>
					<cfinvokeargument name="Lprm_Ocodigo" 			value="#dataCuentaF.Ocodigo#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
					<cfinvokeargument name="Lprm_Ecodigo"	        value="#Arguments.Ecodigo#"/>
				</cfinvoke>

				<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
					<cftransaction action="rollback"/>
					<cf_errorCode	code = "50314"
									msg  = "@errorDat_1@ [@errorDat_2@]"
									errorDat_1="#LvarError#"
									errorDat_2="#dataCuentaF.formato#"
					>
				<cfelse>
					<!--- trae el id de la cuenta financiera --->
					<cfquery name="rsTraeCuenta" datasource="#session.DSN#">
						select CFcuenta
						from CFinanciera a, CPVigencia b
						where a.Ecodigo = #Arguments.Ecodigo#
						  and a.CFformato = '#dataCuentaF.formato#'
						  and a.CPVid = b.CPVid
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(dateFormat(dataCuentaF.fecha))#"> between b.CPVdesde and b.CPVhasta
					</cfquery>

					<cfif rsTraeCuenta.RecordCount gt 0 and len(trim(rsTraeCuenta.CFcuenta))>
						<cfquery name="updateSolicitud" datasource="#session.DSN#">
							update DSolicitudCompraCM
							set CFcuenta = #rsTraeCuenta.CFcuenta#,
								DSformatocuenta = '#dataCuentaF.formato#'
							where DSlinea = #dataCuentaF.DSlinea#
							  and Ecodigo = #Arguments.Ecodigo#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		<cfelse>
			<cfquery name="info" datasource="#session.DSN#">
				select distinct a.ESnumero
				from ESolicitudCompraCM a
					inner join DSolicitudCompraCM b
						on b.ESidsolicitud	=	a.ESidsolicitud
				where a.ESidsolicitud = #arguments.ESidsolicitud#
				and b.CFcuenta is null
			</cfquery>
			<cfif info.recordcount GT 0>
				<cf_errorCode	code = "51096"
								msg  = "No se han generado Cuentas Financieras para las líneas de la solicitud @errorDat_1@. Verifique los datos. Proceso cancelado!."
								errorDat_1="#info.ESnumero#"
				>
			</cfif>
		</cfif>

	</cffunction>

	<!----=======================================================================================================
		Función para insertar en ERequisicion y DRequisicion, si el artículo no esta en un a OC
		y si tiene existencia en el almacán de la solicitud
	=============================================================================================================----->
	<cffunction name="CM_ArticulosRequisicion" access="public" output="true">
		<cfargument name="ESidsolicitud" 	type="numeric" required="true">
		<cfargument name="Ecodigo" 			type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="EcodigoExtra"  	type="numeric" required="no"   hint="Codigo Interno de otra Empresa">

		<cfif NOT isdefined('Arguments.EcodigoExtra') and isdefined('Arguments.Ecodigo')>
			<cfset Arguments.EcodigoExtra = Arguments.Ecodigo>
		</cfif>

		<cfquery name="rsEsActividadEmpresarial" datasource="#session.dsn#">
			Select Pvalor from Parametros where Ecodigo = #session.ecodigo# and Pcodigo = 2200
		</cfquery>

		<cfquery name="rsExistenciaArticulos" datasource="#session.DSN#">
			select
				 c.Eexistencia as Eexistencia, coalesce(a.DScant,0) as DScant, a.ESnumero, a.Aid,
					a.Alm_Aid, e.CFid as CFuncionalEncab, d.Dcodigo, d.Ocodigo, a.DSlinea,
					a.CFid, e.TRcodigo, alm.Almcodigo, a.FPAEid, a.CFComplemento,
					e.Usucodigo, e.CMTScodigo, e.ESobservacion, a.CFcuenta, e.Interfaz

			from DSolicitudCompraCM a

				inner join Almacen alm
					on alm.Aid = a.Alm_Aid

				inner join ESolicitudCompraCM e
					on a.ESidsolicitud = e.ESidsolicitud

				inner join CFuncional d
					on e.CFid = d.CFid

				inner join Existencias c
					on a.Aid = c.Aid
					and a.Alm_Aid = c.Alm_Aid

			where a.Ecodigo = #Arguments.Ecodigo#
				and a.ESidsolicitud = #arguments.ESidsolicitud#
				and a.Aid not in (select z.Aid
									from DOrdenCM z
									where z.Ecodigo = #Arguments.Ecodigo#
										and z.ESidsolicitud = #arguments.ESidsolicitud#
									)
				and coalesce(c.Eexistencia,0)
						>= coalesce(a.DScant,0)								<!--- Existencias de Articulo+Almacen --->
						+  coalesce(
							(
								select sum(rd.DRcantidad)					<!--- Requisiciones pendientes de aplicar del mismo Articulo+Almacen --->
									from ERequisicion re
										inner join DRequisicion rd
										 on rd.ERid = re.ERid
								 where rd.Aid 	= a.Aid
								   and re.Aid	= a.Alm_Aid
							)
						,0)
						+  coalesce(
							(
								select sum(aa.DScant)						<!--- Líneas anteriores de la misma solicitud para el mismo Articulo+Almacen --->
									from DSolicitudCompraCM aa
								 where aa.Aid 			= a.Aid
								   and aa.Alm_Aid		= a.Alm_Aid
								   and aa.ESidsolicitud	= a.ESidsolicitud
								   and aa.DSlinea		< a.DSlinea
							)
						,0)
			order by a.Alm_Aid
		</cfquery>

		<cfif rsExistenciaArticulos.recordcount eq 0>
			<cfthrow detail="Favor verifique la existencia en el almacén del artículo que está solicitando">
		</cfif>
		<cfif len(trim(rsExistenciaArticulos.Usucodigo)) eq 0>
			<cfthrow detail="Favor el usuario del encabezado de la solicitud">
		</cfif>

		<cfquery name="rsUSU_SC" datasource="#session.DSN#">
			select Usucodigo, Usulogin from Usuario where Usucodigo = #rsExistenciaArticulos.Usucodigo#
		</cfquery>

		<cfquery name="rsConsecutivosRequisicion" datasource="#session.dsn#">
			Select Pvalor from Parametros where Ecodigo = #Arguments.EcodigoExtra# and Pcodigo = 361
		</cfquery>

		<cfif rsExistenciaArticulos.RecordCount NEQ 0>
			<cfoutput query="rsExistenciaArticulos" group="Alm_Aid">

				<cfif rsConsecutivosRequisicion.Pvalor eq 1>
					<!----Obtiene el consecutivo----->
					<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
								method			= "nextVal"
								returnvariable	= "LvarERdocumento"

								Ecodigo			= "#Arguments.EcodigoExtra#"
								ORI				= "INRQ"
								REF				= "SCRQ-#CMTScodigo#"
								datasource		= "#session.dsn#"
					/>
				</cfif>
				<!----Cargar el encabezado----->
				<cfif rsConsecutivosRequisicion.Pvalor eq 1>
					<cfset lvarDes = "Solicitud de Requisición #LvarERdocumento#, SC:#ESnumero#">
				<cfelse>
					<cfset lvarDes = mid(ESobservacion,1, 80)>
				</cfif>

				<!---►►Agregar Identificación Representante de la empresa a las requisiciones cuando se usa Proveeduría Corporativa◄◄--->
				<cfquery name="rsParam5310" datasource="#session.dsn#">
					select Pvalor from Parametros where Pcodigo = 5310 and Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfif NOT rsParam5310.RecordCount or len(trim(rsParam5310.Pvalor)) eq 0>
					<cfset rsParam5310.Pvalor = 0>
				</cfif>
				<cfquery name="rsEmpresa" datasource="#session.dsn#">
					select Eidresplegal from Empresa where Ereferencia = #Arguments.Ecodigo#
				</cfquery>
				<cfquery name="rsERequisicion" datasource="#session.DSN#">
					select ERdocumento
						from ERequisicion
					where Ecodigo     = #Arguments.EcodigoExtra#
					 and ERdocumento =
							<cfif rsConsecutivosRequisicion.Pvalor eq 1>
								<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#CMTScodigo#:#LvarERdocumento#-#Almcodigo#">
							<cfelseif Arguments.EcodigoExtra NEQ Arguments.Ecodigo and len(trim(rsParam5310.Pvalor)) and LEN(TRIM(rsEmpresa.Eidresplegal))>
								<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#ESnumero#-#Almcodigo#-#rsEmpresa.Eidresplegal#">
							<cfelse>
								<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#ESnumero#-#Almcodigo#">
							</cfif>
				</cfquery>
				<cfif rsERequisicion.recordCount>
					<cfthrow message="Se requiere generar la requisicion '#rsERequisicion.ERdocumento#', pero la misma ya existe">
				</cfif>
				<cfquery name="InsertaERequisicion" datasource="#session.DSN#">
					insert into ERequisicion (ERdescripcion,
											Ecodigo,
											EcodigoRequi,
											Aid,
											ERdocumento,
											TRcodigo,
											Dcodigo,
											Ocodigo,
											CFid,
											ERFecha,
											ERtotal,
											ERusuario,
											EReferencia,
											PRJAid,
											BMUsucodigo,
											Externo)
					values(
							<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#lvarDes#">,
							#Arguments.EcodigoExtra#,
							#Arguments.Ecodigo#,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Alm_Aid#">,
							<cfif rsConsecutivosRequisicion.Pvalor eq 1>
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#CMTScodigo#:#LvarERdocumento#-#Almcodigo#">,
							<cfelseif Arguments.EcodigoExtra NEQ Arguments.Ecodigo and rsParam5310.Pvalor and LEN(TRIM(rsEmpresa.Eidresplegal))>
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(ESnumero)#-#TRIM(Almcodigo)#-#TRIM(rsEmpresa.Eidresplegal)#">,
							<cfelse>
								<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#ESnumero#-#Almcodigo#">,
							</cfif>
							<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#TRcodigo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Dcodigo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Ocodigo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#CFuncionalEncab#">,
							<cf_dbfunction name="now">,
							0,
							'#rsUSU_SC.Usulogin#',
							<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsExistenciaArticulos.ESnumero#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
							#rsUSU_SC.Usucodigo#,
							#rsExistenciaArticulos.Interfaz#
							)
					<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="InsertaERequisicion" verificar_transaccion="false">
				<cfoutput>
					<!----Cargar el detalle----->
					<cfquery name="InsertaDRequisicion" datasource="#session.DSN#">
						insert into DRequisicion (ERid,
												Aid,
												DSlinea,
												CFid,
												DRcantidad,
												DRcosto,
												BMUsucodigo,
												FPAEid,
												CFComplemento,
												CFcuenta
												)

							values(  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#InsertaERequisicion.identity#">
									,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsExistenciaArticulos.Aid#">
									,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsExistenciaArticulos.DSlinea#">
									,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsExistenciaArticulos.CFid#">
									,<cf_jdbcquery_param cfsqltype="cf_sql_float"   value="#rsExistenciaArticulos.DScant#">
									,0
									,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsUSU_SC.Usucodigo#">
									,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsExistenciaArticulos.FPAEid#" 			voidNull>
									,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsExistenciaArticulos.CFComplemento#" 	voidNull>
									,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsExistenciaArticulos.CFcuenta#" 		voidNull>
									)
					</cfquery>
					<cfif LvarCPcomprasInventario>
						<!--- CPcompras Con requisición y Generando la Requisición --->
						<!--- Si controlar Compras de Inventario: No controlar Solicitudes de Consumo (SC con requisición que efectivamente no hubo que comprar sino que se genera la requisición) --->
						<!--- Genera Requisición cuando las Existencias de Almacen >= Cantidad Solicitadas + Cantidad Requizadas --->
						<cfquery name="rsSolicitudCompra" datasource="#Session.DSN#">
							update DSolicitudCompraCM
							   set DSnoPresupuesto = 1
							 where Ecodigo			= #Arguments.Ecodigo#
							   and ESidsolicitud	= #arguments.ESidsolicitud#
							   and DSlinea			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistenciaArticulos.DSlinea#">
							   and DStipo = 'A'
						</cfquery>
					</cfif>
				</cfoutput>
			</cfoutput>
		</cfif>
		<cfset sbPlanComprasInventario(Arguments.ESidsolicitud,Arguments.Ecodigo)>
	</cffunction>

	<cffunction name="CM_AplicaSolicitud_WorkFlow" access="public" output="true" returntype="numeric">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" 		 type="numeric" required="true">
		<cfargument name="EcodigoExtra"  type="numeric" required="no"   hint="Codigo Interno de otra Empresa">

		<cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfif NOT isdefined('Arguments.EcodigoExtra') and isdefined('Arguments.Ecodigo')>
			<cfset Arguments.EcodigoExtra = Arguments.Ecodigo>
		</cfif>

		<cfinvoke
			 component		= "sif.Componentes.PRES_Presupuesto"
			 method			= "CreaTablaIntPresupuesto"
			 Conexion		= "#session.dsn#"
			 ContaPresupuestaria="true"
		/>


		<cfreturn CM_AplicaSolicitud(Arguments.ESidsolicitud, Arguments.Ecodigo, Arguments.EcodigoExtra)>

	</cffunction>

	<!----=======================================================================================================
		Función para asignar el comprador de la solicitud
	=============================================================================================================----->
	<cffunction name="asignaCompradorSolicitud" access="public" output="true" returntype="numeric">
		<cfargument name="ESidsolicitud" 	type="numeric" 	required="yes">		<!---Tipo de solicitud---->
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">		<!---ID del centro funcional---->

		<!--- 1. Obtiene datos del tipo de solicitud--->
		<cfset rsTipoSolicitud = this.obtenerTiposolicitud(arguments.ESidsolicitud) >

		<!--- 2. Si la solicitud es de requisicion NO tiene que asignar el comprador--->
		<cfif rsTipoSolicitud.CMTSconRequisicion eq 1>
			<cfset LvarCMCid = -1>
		</cfif>

		<!--- 3. Obtiene Comprador asignado del centro funcional, se salta el comprador del CF cuando es asignacion por especializacion --->
		<cfif rsTipoSolicitud.CMTSasignacion neq 1 and rsTipoSolicitud.CMTSconRequisicion neq 1>
			<cfset dataCFuncional = this.obtenerCompradorCF(rsTipoSolicitud.CFid)>
		</cfif>
		<!--- <cf_dump var=#dataCFuncional#> --->
		<!--- 4. Determina el comprador:
				Prioridad:
					Comprador del Centro Funcional
					Comprador con menos carga que sea especializado para el tipo de solicitud o no tenga especialización
					Comprador default
				Nota: si el parametro de Orden de Asignacion del Comprador esta con valor 1, la prioridad es:
					Comprador con menos carga que sea especializado para el tipo de solicitud o no tenga especialización
					Comprador default
		--->
		<cfif rsTipoSolicitud.CMTSasignacion eq 1 and rsTipoSolicitud.CMTSconRequisicion neq 1>
			<cfset LvarCMCid = this.obtenerComprador(rsTipoSolicitud.CMTScodigo, arguments.Ecodigo) >
		<cfelse>
			<cfif rsTipoSolicitud.CMTSconRequisicion neq 1 and dataCFuncional.recordCount gt 0 and len(trim(dataCFuncional.CMCid)) and dataCFuncional.CMCid neq 0 >
				<cfset LvarCMCid = dataCFuncional.CMCid >
			<cfelseif rsTipoSolicitud.CMTSconRequisicion eq 1>
				<cfset LvarCMCid = -1>
			<cfelse>
				<cfset LvarCMCid = this.obtenerComprador(rsTipoSolicitud.CMTScodigo, arguments.Ecodigo) >
			</cfif>
		</cfif>

		<cfif rsTipoSolicitud.CMTSconRequisicion neq 1>
			<!--- 4. Asigna el comprador Cuando el tipo no es de requisicion--->
			<cfquery datasource="#session.DSN#">
				update ESolicitudCompraCM
				   set CMCid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCMCid#">
				 where ESidsolicitud = #arguments.ESidsolicitud#
				   and Ecodigo 		 = #Arguments.Ecodigo#
			</cfquery>
		</cfif>
		<cfreturn LvarCMCid>
	</cffunction>

	<!----=======================================================================================================
		Función para asignar el comprador por linea de la solicitud
	=============================================================================================================----->
	<cffunction name="asignaCompradorLinea" access="public" output="true">
		<cfargument name="ESidsolicitud" 	type="numeric" 	required="true">
		<cfargument name="Ecodigo" 			type="numeric" 	required="true" default="#session.Ecodigo#">
		<cfargument name="DSlinea" 			type="numeric" 	required="true">
		<cfargument name="CMCid" 			type="numeric" 	required="true">

		<cfquery datasource="#session.DSN#">
			update DSolicitudCompraCM
			set CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CMCid#">
			where Ecodigo = #Arguments.Ecodigo#
				and ESidsolicitud = #arguments.ESidsolicitud#
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DSlinea#">
		</cfquery>

	</cffunction>

	<!----==================================================================================
			Función que actualiza las cantidades de la solicitud y el total de la línea
	========================================================================================----->
	<cffunction name="ActualizaLineaSolicitud">
		<cfargument name="ESidsolicitud" 	type="string" 	required="yes">
		<cfargument name="DSlinea" 			type="string" 	required="yes">
		<cfargument name="Cantidad" 		type="string" 	required="yes">	<!---Cantidad por insertar---->

		<!----Actualiza la cantidad---->
		<cfquery datasource="#session.DSN#">
			update DSolicitudCompraCM
				set DScant 			= <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Cantidad#">,
					DStotallinest 	= round(DSmontoest * <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Cantidad#">,2)
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DSlinea#">
				and ESidsolicitud = #arguments.ESidsolicitud#
		</cfquery>

	</cffunction>
	<!-----===============================================================================
			Funcion que inserta en la estructura: DSProvLineasContrato (encabezado)
	===================================================================================== ---->
	<cffunction name="InsertaSeleccionProveedor">
		<cfargument name="DSlinea" 			type="string" 	required="yes">	<!----ID de la linea de la solicitud----->
		<cfargument name="Ecodigo" 			type="string" 	required="yes" default="#session.Ecodigo#">

		<cfquery name="Inserta" datasource="#session.DSN#"><!---Inserta linea en DSProvLineasContrato---->
			insert into DSProvLineasContrato(DSlinea,
											Ecodigo,
											BMUsucodigo,
											Estado,
											fechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DSlinea#">,
					#Arguments.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					0,
					<cf_dbfunction name="now">
				)
		</cfquery>
	</cffunction>
	<!-----===============================================================================
			Funcion que inserta una linea en DSolicitudCompraCM (DUPLICADA)
			Son las que van a proceso de publicación
	===================================================================================== ---->
	<cffunction name="CrearLineaSolicitud">
		<cfargument name="ESidsolicitud" 	type="string" 	required="yes">
		<cfargument name="DSlinea" 			type="string" 	required="yes">
		<cfargument name="Cantidad" 		type="string" 	required="yes">	<!---Cantidad por insertar---->
		<cfargument name="CMCid" 			type="string" 	required="yes">	<!---Comprador asignado---->

		<cfquery  name="selectLinea" datasource="#session.DSN#">
			select 	ESidsolicitud,
					ESnumero,
					(
						select max(DSconsecutivo)+1 from DSolicitudCompraCM
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						   and ESidsolicitud = #arguments.ESidsolicitud#
					) as DSconsecutivo,
					Aid,
					Alm_Aid,
					Cid,
					ACcodigo,
					ACid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CMCid#"> as CMCid,
					Icodigo,
					Ucodigo,
					CFcuenta,
					CFid,
					DSdescripcion,
					DSdescalterna,
					DSobservacion,
					DSreflin,
					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Cantidad#"> as DScant,
					0 as DScantsurt,
					DSmontoest,
					round(DSmontoest * <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Cantidad#">,2) as DStotallinest,
					DStipo,
					DSfechareq,
					DSformatocuenta,
					DSespecificacuenta,
					CFidespecifica,
					BMUsucodigo,
					DScantcancel,
					FPAEid,
					CFComplemento,
					PCGDid,
					OBOid
			from DSolicitudCompraCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DSlinea#">
				and ESidsolicitud = #arguments.ESidsolicitud#
		</cfquery>
		<cfquery  name="InsertaLinea" datasource="#session.DSN#">
			insert into DSolicitudCompraCM(	ESidsolicitud, Ecodigo,
											ESnumero, DSconsecutivo,
											Aid, Alm_Aid,
											Cid, ACcodigo, ACid,
											CMCid, Icodigo, Ucodigo,
											CFcuenta, CFid, DSdescripcion,
											DSdescalterna, DSobservacion, DSreflin,
											DScant, DScantsurt, DSmontoest, DStotallinest, DStipo,
											DSfechareq, DSformatocuenta, DSespecificacuenta,
											CFidespecifica, BMUsucodigo, DScantcancel,
											FPAEid, CFComplemento, PCGDid, OBOid)
				VALUES(
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.ESidsolicitud#"      voidNull>,
						   #session.Ecodigo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.ESnumero#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectLinea.DSconsecutivo#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.Aid#"                voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.Alm_Aid#"            voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.Cid#"                voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectLinea.ACcodigo#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectLinea.ACid#"               voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.CMCid#"              voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectLinea.Icodigo#"            voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectLinea.Ucodigo#"            voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.CFcuenta#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.CFid#"               voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectLinea.DSdescripcion#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1024"value="#selectLinea.DSdescalterna#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectLinea.DSobservacion#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.DSreflin#"           voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectLinea.DScant#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectLinea.DScantsurt#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectLinea.DSmontoest#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectLinea.DStotallinest#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectLinea.DStipo#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectLinea.DSfechareq#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectLinea.DSformatocuenta#"    voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectLinea.DSespecificacuenta#" voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.CFidespecifica#"     voidNull>,
						   #session.Usucodigo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectLinea.DScantcancel#"       voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.FPAEid#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectLinea.CFComplemento#"      voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.PCGDid#"             voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectLinea.OBOid#"              voidNull>
					)

			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="InsertaLinea" verificar_transaccion="false">

		<!---Obtener el tipo de la solicitud---->
		<cfset rsTipoSolicitud = this.obtenerTiposolicitud(arguments.ESidsolicitud) >
		<!---Obtiene comprador ----->
		<cfset vnComprador = this.obtenerComprador(rsTipoSolicitud.CMTScodigo, session.Ecodigo) >
		<!---Asigna al comprador por linea de la solicitud----->
		<cfset this.asignaCompradorLinea(arguments.ESidsolicitud, session.Ecodigo, InsertaLinea.identity , vnComprador)>

	</cffunction>

	<!-----===============================================================================
			Funcion que devuelve el CMCid del comprador para solicitud tipo contrato,
			cuando el parámetro de múltiples contratos esta encendido

			Tiene prioridad autorizador sobre comprador
	===================================================================================== ---->

	<cffunction name="determinaCompradorContrato_CMult" >
		<cfargument name="CMTScodigo" 	type="string" 	required="yes">		<!---Tipo de solicitud---->
		<cfargument name="CFid" 		type="numeric" 	required="yes">		<!---ID del centro funcional---->

		<cfset _varCat = DBconcat()>
		<cfquery name="rsCFuncional" datasource="#session.DSN#">
			select CFcomprador, CFautoccontrato, CFcodigo #_varCat# ' - ' #_varCat# CFdescripcion as CtroFuncional
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<cfif rsCFuncional.Recordcount NEQ 0>
			<cfif (len(trim(rsCFuncional.CFcomprador)) and rsCFuncional.CFcomprador NEQ 0) and (len(trim(rsCFuncional.CFautoccontrato)) and rsCFuncional.CFautoccontrato NEQ 0)>
				<cfset vnCMCid = rsCFuncional.CFautoccontrato>
			<cfelseif (len(trim(rsCFuncional.CFcomprador)) and rsCFuncional.CFcomprador NEQ 0) and (not len(trim(rsCFuncional.CFautoccontrato)) or rsCFuncional.CFautoccontrato EQ 0)>
				<cfset vnCMCid = rsCFuncional.CFcomprador>
			<cfelseif (len(trim(rsCFuncional.CFautoccontrato)) and rsCFuncional.CFautoccontrato NEQ 0) and (not len(trim(rsCFuncional.CFcomprador)) or rsCFuncional.CFcomprador EQ 0)>
				<cfset vnCMCid = rsCFuncional.CFautoccontrato>
			<cfelse>
				<cf_errorCode	code = "51097"
								msg  = "No se ha asignado un comprador o comprador autorizador de OC de contratos para el centro funcional de la solicitud: <cfoutput>@errorDat_1@</cfoutput> . <br> Comuníquese con el administrador del sistema."
								errorDat_1="#rsCFuncional.CtroFuncional#"
				>
				<!----<cfset vnCMCid = obtenerComprador(arguments.CMTScodigo, session.Ecodigo) >----->
			</cfif>
		<cfelse>
			<cf_errorCode	code = "51098" msg = "El centro funcional no existe">
		</cfif>

		<cfreturn vnCMCid>
	</cffunction>

	<!-----==================================================================================================
		Función que inserta en EOrdenCM y DOrdenCM CUANDO ESTA ACTIVADO EL PARAMETRO DE MULTIPLES CONTRATOS
	========================================================================================================= ---->
	<cffunction name="CrearOrden" returntype="struct">
		<cfargument name="SNcodigo" 		type="numeric" 	required="yes">		<!----Socio de negocio---->
		<cfargument name="datosContrato" 	type="query" 	required="yes">		<!----Query con los datos del contrato---->
		<cfargument name="estructura" 		type="struct" 	required="no">		<!----Estructura que guarda los ID's de los encabezados "abiertos" para c/proveedor---->
		<cfargument name="CMComprador" 		type="string" 	required="yes">		<!----Comprador asignado según criterios del autorizador de ordenes---->
		<cfargument name="CantidadOrden" 	type="string" 	required="yes">		<!----Cantidad de bienes por los cuales se hará la OC--->
		<cfargument name="ActualizaTotal" 	type="string" 	required="yes">		<!----Bit para actualizar (1) o no actualizar (0) la cantidad de linea de la solicitud (DScant),
																					en el caso de que la cantidad disponible de los contratos es > que la solicitada, no hace falta
																					realizar dicha actualizacion--->

		<cfif not StructKeyExists(arguments.estructura, "#arguments.SNcodigo#_#arguments.datosContrato.Mcodigo#")><!---Si no se ha creado la OC para ese proveedor--->
			<!--- Obtiene la descripción de la solicitud --->
			<cfquery name="rsDescripcionSolicitud" datasource="#Session.DSN#">
				select substring(ESobservacion, 1, 204) as ESobservacion
				from ESolicitudCompraCM
				where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ESidsolicitud#">
			</cfquery>

			<!--- Se crea la descripción de la orden de compra a generar con un máximo de 255 caracteres --->
			<cfset vnDescripcionSolicitud = "Orden de compra generada por contrato">
			<cfif isdefined("rsDescripcionSolicitud") and rsDescripcionSolicitud.RecordCount gt 0 and len(trim(rsDescripcionSolicitud.ESobservacion)) gt 0>
				<cfset vnDescripcionSolicitud = vnDescripcionSolicitud & " - Solicitud: " & rsDescripcionSolicitud.ESobservacion>
			</cfif>
			<cfset vnDescripcionSolicitud = trim(vnDescripcionSolicitud)>
			<cfif len(trim(vnDescripcionSolicitud)) gt 255>
				<cfset vnDescripcionSolicitud = Mid(vnDescripcionSolicitud, 1, 255)>
			</cfif>

			<!--- Obtiene el tipo de cambio --->
			<cfset LvarTipoCambio = 1>
			<cfquery name="rsTC" datasource="#Session.DSN#">
				select tc.TCventa
				from Htipocambio tc
				where tc.Mcodigo = #arguments.datosContrato.Mcodigo#
				  and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and tc.Hfecha <= <cf_dbfunction name="now">
				  and tc.Hfechah > <cf_dbfunction name="now">
			</cfquery>
			<cfif rsTC.recordcount gt 0 and rsTC.TCventa gt 0>
				<cfset LvarTipoCambio = rsTC.TCventa>
			</cfif>

			<!--- Control de concurrencia y duplicados (cflock + cftransaction + update) de consecutivos de EOrden --->
			<cflock name="LCK_EOrdenCM#Session.Ecodigo#" timeout="20" throwontimeout="yes" type="exclusive">
				<!--- Calculo de Consecutivo: ultimo + 1 --->
				<cfquery name="rsConsecutivoOrden" datasource="#Session.DSN#">
					select coalesce(max(EOnumero), 0) + 1 as EOnumero
					  from EOrdenCM
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfquery datasource="#Session.DSN#">
					update EOrdenCM
					   set EOnumero = EOnumero
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and EOnumero = #rsConsecutivoOrden.EOnumero-1#
				</cfquery>

				<cfquery name="InsertaOC" datasource="#session.DSN#"><!----Inserta el encabezado---->
					insert into EOrdenCM (	Ecodigo,
											EOnumero,
											SNcodigo,
											CMCid,
											Mcodigo,
											Rcodigo,
											CMTOcodigo,
											EOfecha,
											Observaciones,
											EOtc,
											EOrefcot,
											Impuesto,
											EOdesc,
											EOtotal,
											Usucodigo,
											EOfalta,
											CMFPid,
											EOplazo,
											EOporcanticipo,
											EOestado,
											NAP,
											NAPcancel,
											CMIid,
											EOdiasEntrega)
					values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivoOrden.EOnumero#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CMComprador#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.Mcodigo#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.datosContrato.CMTOcodigo#">,
							<cf_dbfunction name="now">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#vnDescripcionSolicitud#">,
							<!----///// Modificado 2P el 26/10/2005  valor anterior = 1.0 /////////----->
							<cfqueryparam cfsqltype="cf_sql_float" value="#LvarTipoCambio#">,
							null,
							0.0,
							0.0,
							0.0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cf_dbfunction name="now">,
							<cfif len(trim(arguments.datosContrato.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.CMFPid#"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.datosContrato.ECplazocredito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ECporcanticipo#">,
							8,
							<cfif len(trim(arguments.datosContrato.NAP))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.NAP#"><cfelse>null</cfif>,
							<cfif len(trim(arguments.datosContrato.NAPcancel))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.NAPcancel#"><cfelse>null</cfif>,
							<cfif len(trim(arguments.datosContrato.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.CMIid#"><cfelse>null</cfif>,
							<cfif len(trim(arguments.datosContrato.ECtiempoentrega))><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.datosContrato.ECtiempoentrega#"><cfelse>null</cfif>
							)
					<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="InsertaOC" verificar_transaccion="false">

				<cfset structInsert(arguments.estructura, "#arguments.SNcodigo#_#arguments.datosContrato.Mcodigo#", InsertaOC.identity) ><!---Actualiza la estructura de encabezados por Socio de negocio--->
			</cflock>
			<cfset vnIDorden = InsertaOC.identity><!---Variable numerica (vn) con el identity autonumerico que se generó----->

		<cfelse><!---NO EXISTE YA UNA OC PARA ESE PROVEEDOR, dentro del recorrido de los contratos---->
			<cfset vnIDorden = arguments.estructura["#arguments.SNcodigo#_#arguments.datosContrato.Mcodigo#"]><!---Buscar el ID de la orden ya generada para ese proveedor---->
		</cfif>

		<cfquery name="rsEOnumero" datasource="#session.DSN#"><!---Obtener el EOnumero de la OC creada--->
			select EOnumero from EOrdenCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnIDorden#">
		</cfquery>

		<cfquery name="rsConsecutivoLinea" datasource="#Session.DSN#"><!----Calcular el DOconsecutivo---->
			select coalesce(max(DOconsecutivo), 0) + 1 as DOconsecutivo
			from DOrdenCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnIDorden#">
		</cfquery>

		<cfquery name="rsAlmacen" datasource="#session.DSN#">
			select Alm_Aid from DSolicitudCompraCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ESidsolicitud#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.DSlinea#">
		</cfquery>

		<cfquery name="InsertaD" datasource="#session.DSN#"><!---Inserta el detalle---->
			insert into DOrdenCM (	Ecodigo,
									EOidorden,
									EOnumero,
									DOconsecutivo,
									ESidsolicitud,
									DSlinea,
									CMtipo,
									Cid,
									Aid,
									Alm_Aid,
									ACcodigo,
									ACid,
									CFid,
									Icodigo,
									Ucodigo,
									DClinea,
									CFcuenta,
									CAid,
									DOdescripcion,
									DOalterna,
									DOobservaciones,

									DOcantidad,
									DOcantsurtida,
									DOpreciou,
									DOtotal,
									DOfechaes,
									DOgarantia,
									Ppais,
									DOfechareq,
									numparte,
									BMUsucodigo,
									FPAEid,
									CFComplemento,
									PCGDid,
									OBOid,
									DOmontodesc, DOporcdesc
								)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnIDorden#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEOnumero.EOnumero#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsecutivoLinea.DOconsecutivo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ESidsolicitud#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.DSlinea#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.datosContrato.DCtipoitem#">,
					<cfif len(trim(arguments.datosContrato.Cid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.Cid#"><cfelse>null</cfif>,
					<cfif len(trim(arguments.datosContrato.Aid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.Aid#"><cfelse>null</cfif>,
					<!----/*/-*/-*/-*/-*/ null, -*/-*/-*/-*/-*/---->
					<cfif rsAlmacen.RecordCount NEQ 0 and len(trim(rsAlmacen.Alm_Aid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacen.Alm_Aid#"><cfelse>null</cfif>,
					<cfif len(trim(arguments.datosContrato.ACcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ACcodigo#"><cfelse>null</cfif>,
					<cfif len(trim(arguments.datosContrato.ACid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ACid#"><cfelse>null</cfif>,
					<cfif len(trim(arguments.datosContrato.CFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.CFid#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.datosContrato.Icodigo#">,
					<cfif len(trim(arguments.datosContrato.Ucodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#arguments.datosContrato.Ucodigo#"><cfelse>null</cfif>,
					null,
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.datosContrato.DCdescripcion#">,
					<cfif len(trim(arguments.datosContrato.DCdescalterna))><cfqueryparam cfsqltype="cf_sql_char" value="#arguments.datosContrato.DCdescalterna#"><cfelse>null</cfif>,
					<cfif len(trim(arguments.datosContrato.DSobservacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.datosContrato.DSobservacion#"><cfelse>null</cfif>,

					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.CantidadOrden#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.datosContrato.DCpreciou#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#LSNumberFormat(arguments.datosContrato.DCpreciou * arguments.CantidadOrden, '9.00')#">,
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.datosContrato.DCgarantia#">,
					null,
					<cfif len(trim(arguments.datosContrato.DSfechareq))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.datosContrato.DSfechareq#"><cfelse>null</cfif>,
					null,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.FPAEid#" null="#Len(Trim(arguments.datosContrato.FPAEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.datosContrato.CFComplemento#" null="#Len(Trim(arguments.datosContrato.CFComplemento)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.PCGDid#" null="#Len(Trim(arguments.datosContrato.PCGDid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.OBOid#" null="#Len(Trim(arguments.datosContrato.OBOid)) EQ 0#">,
					0.0, 0.0
				)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="InsertaD" verificar_transaccion="false">

		<cfset vnDOlinea = InsertaD.identity><!---Variabke con el ID generado dela linea del detalle---->

		<!---INSERTA EN LA TABLA CMOCContrato (Detalle de las OC's generadas por contrato)----->
		<cfquery datasource="#session.DSN#">
			insert into CMOCContrato (	DOlinea,
										EOidorden,
										Ecodigo,
										SNcodigo,
										ECid,
										CMOCCcantidad,
										BMUsucodigo,
										fechaalta)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDOlinea#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnIDorden#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ECid#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.CantidadOrden#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cf_dbfunction name="now">
					)
		</cfquery>

		<cfset CalculaTotalesOC (Session.Ecodigo, vnIDorden)>

		<!----UPDATE DE LA CANTIDAD,CANT SURTIDA DE LA SOLICITUD (En lugar de duplicar la linea en el detalle se actualiza, cuando se crean OC de contratos)---->
		<cfif arguments.ActualizaTotal  EQ 1>
			<cfquery datasource="#session.DSN#">
				update DSolicitudCompraCM
					set DScant = DScant + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.CantidadOrden#">,
					DScontratos = 1
				where Ecodigo = #session.Ecodigo#
					and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ESidsolicitud#">
					and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.DSlinea#">
			</cfquery>
		</cfif>

		<!---UPDATE DE LA CANTIDAD SURTIDA DEL CONTRATO(con la cantidad de la OC generada)---->
		<cfquery datasource="#session.DSN#">
			update DContratosCM
				set DCcantsurtida = DCcantsurtida + <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.CantidadOrden#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ECid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.ECid#">
				and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosContrato.DClinea#">
		</cfquery>
		<cfreturn arguments.estructura>
	</cffunction>

	<!----============================================================================================
		Función para el envio de correos al comprador autorizador y usuarios autorizados por el
	==================================================================================================----->
	<cffunction name="EnviodeCorreos">
		<cfargument name="Autorizador" 		required="yes" type="string">	<!---ID del comprador autorizador (CMCid)----->
		<cfargument name="empresa" 			required="yes" type="string">	<!---Ecodigo de la empresa---->
		<cfargument name="OpcionIngresar" 	required="yes" type="string">	<!---Opcion a la cual se le debe indicar que ingrese---->
		<cfargument name="ESidsolicitud" 	required="yes" type="string">	<!---ID de la solicitud de compra aplicada---->
		<cfargument name="Origen" 			required="yes" type="string">	<!---Indicador de si viene de la aplicacion de seleccion de proveedores o la aplicacion de la solicitud---->

		<cfset _varCat = DBconcat()>
		<!----Datos de la solicitud de compra----->
		<cfquery name="rsSolicitud" datasource="#session.DSN#">
			select ESnumero, ESfecha
			from ESolicitudCompraCM
			where ESidsolicitud = #arguments.ESidsolicitud#
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
		</cfquery>

		<cfquery name="rsOrdenes" datasource="#session.DSN#">
			select distinct a.EOnumero, b.SNcodigo, c.SNnombre
			from DOrdenCM  a
				<cfif len(trim(arguments.Origen)) and arguments.Origen EQ 'Seleccion'>
					<!---Traer solo las OC's que se generaron en la seleccion de proveedores---->
					inner join DSProvLineasContrato e
						  on a.DSlinea = e.DSlinea
						  and a.Ecodigo = e.Ecodigo
				</cfif>
				inner join EOrdenCM b
					on a.EOidorden = b.EOidorden
					and a.Ecodigo = b.Ecodigo

					inner join SNegocios c
						on b.SNcodigo = c.SNcodigo
						and b.Ecodigo = c.Ecodigo
			where a.ESidsolicitud = #arguments.ESidsolicitud#
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
		</cfquery>

		<!----Si el correo se envia por seleccion de proveedores solo envia a el autorizador de oc---->
		<!---Correos electrónicos---->
		<cfif len(trim(arguments.OpcionIngresar)) and arguments.OpcionIngresar EQ 'Selección de proveedores'>
			<cfquery name="rsMail" datasource="#session.DSN#">
				select coalesce(c.Pemail1,c.Pemail2) as rsCorreo,c.Pnombre #_varCat# ' ' #_varCat# c.Papellido1 #_varCat# ' ' #_varCat# c.Papellido2 as nombre
				from CMCompradores a
					inner join Usuario b
						on a.Usucodigo = b.Usucodigo
					inner join DatosPersonales c
						on b.datos_personales = c.datos_personales
				where a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Autorizador#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			</cfquery>
		<cfelse>
			<cfquery name="rsMail" datasource="#session.DSN#">
				select coalesce(c.Pemail1,c.Pemail2) as rsCorreo,c.Pnombre #_varCat# ' ' #_varCat# c.Papellido1 #_varCat# ' ' #_varCat# c.Papellido2 as nombre
				from CMUsuarioAutorizado a
					inner join Usuario b
						on a.Usucodigo = b.Usucodigo
					inner join DatosPersonales c
						on b.datos_personales = c.datos_personales
				where a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Autorizador#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">

				union

				select coalesce(c.Pemail1,c.Pemail2) as rsCorreo,c.Pnombre #_varCat# ' ' #_varCat# c.Papellido1 #_varCat# ' ' #_varCat# c.Papellido2 as nombre

				from CMCompradores a
					inner join Usuario b
						on a.Usucodigo = b.Usucodigo
					inner join DatosPersonales c
						on b.datos_personales = c.datos_personales
				where a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Autorizador#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa#">
			</cfquery>
		</cfif>

		<cfset hostname = session.sitio.host>
		<cfset CEcodigo = session.CEcodigo>

		<cfloop query="rsMail">
			<!--- Se arma el cuerpo del mail ---->
			<cfsavecontent variable="email_body">
				<html>
					<head>
						<style type="text/css">
							.tituloIndicacion {
								font-size: 10pt;
								font-variant: small-caps;
								background-color: #CCCCCC;
							}
							.tituloListas {
								font-weight: bolder;
								vertical-align: middle;
								padding: 2px;
								background-color: #F5F5F5;
							}
							.listaNon { background-color:#FFFFFF; vertical-align:middle; padding-left:5px;}
							.listaPar { background-color:#FAFAFA; vertical-align:middle; padding-left:5px;}
							body,td {
								font-size: 12px;
								background-color: #f8f8f8;
								font-family: Verdana, Arial, Helvetica, sans-serif;
							}
						</style>
					</head>
					<body>
						<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td colspan="7">
									<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
										<tr>
											<td nowrap width="6%"><strong>De:</strong></td>
											<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
										</tr>
										<tr>
											<td><strong>Para:</strong></td>
											<td><cfoutput>#rsMail.nombre#</cfoutput></td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td>Aplicaci&oacute;n de <cfoutput>#arguments.OpcionIngresar#</cfoutput></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="2%">&nbsp;</td>
								<td colspan="6">
									Sr(a)/ Srta: &nbsp;<cfoutput>#rsMail.nombre#</cfoutput>.<br><br>
									Se ha aplicado la solicitud de compra <cfoutput>#rsSolicitud.ESnumero#</cfoutput>&nbsp;,
									con fecha <cfoutput>#LSdateFormat(rsSolicitud.ESfecha,'dd/mm/yyyy')#</cfoutput>&nbsp;.<br>
									<cfif rsOrdenes.RecordCount NEQ 0 and arguments.OpcionIngresar NEQ 'Selección de proveedores'>
										Se generaron las siguientes ordenes de compra:
									</cfif>
								</td>
							</tr>
							<cfif rsOrdenes.RecordCount NEQ 0 and arguments.OpcionIngresar NEQ 'Selección de proveedores'>
								<tr>
									<td>&nbsp;</td>
									<td width="22%"><strong>Número</strong></td>
									<td width="76%"><strong>Proveedor</strong></td>
								</tr>
								<cfoutput>
									<cfloop query="rsOrdenes">
										<tr>
											<td>&nbsp;</td>
											<td>#rsOrdenes.EOnumero#</td>
											<td>#rsOrdenes.SNnombre#</td>
										</tr>
									</cfloop>
								</cfoutput>
							</cfif>
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan = "6">
									<strong>Por favor ingrese a la opción de: <cfoutput>#arguments.OpcionIngresar#</cfoutput>, complete la información necesaria y aplique la misma.</strong>
								</td>
							</tr>
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr><td colspan="7">&nbsp;</td></tr>
						</table>
					</body>
				</html>
			</cfsavecontent>
			<cfset email_subject = "Aplicación de Orden de compra">
			<cfset email_to = rsMail.rsCorreo>
			<cfset Email_remitente = "gestion@soin.co.cr">

			<cfif len(trim(email_to))>
				<cfquery datasource="#session.DSN#">
					insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#Email_remitente#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
				</cfquery>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="CalculaTotalesOC" access="private" output="no" returntype="void">
		<cfargument name="Ecodigo" 		type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="EOidorden" 	type="numeric" required="true">

		<!---
			Calcula impuestos del detalle y Calcula totales de la OC
		--->
		<cfinvoke
			 component		= "sif.Componentes.CM_AplicaOC"
			 method			= "calculaTotalesEOrdenCM"

			 EOidorden		= "#Arguments.EOidorden#"
			 Ecodigo		= "#Arguments.Ecodigo#"
		/>
	</cffunction>

	<cffunction name="sbPlanComprasInventario" access="private" output="false" returntype="void">
		<cfargument name="ESidsolicitud" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">

		<cfif LvarPlanComprasActivo>
			<cfif LvarCPconsumoInventario>
				<cfthrow message="Error de Configuración: El Control de Presupuesto en Compras de Artículos de Inventario debe estar parametrizado como Controlar la Compra cuando el Plan de Compras de Gobierno está activo">
			<cfelseif LvarConRequisicion>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select a.Acodigo, a.Adescripcion, alm.Almcodigo, alm.Bdescripcion
					  from DSolicitudCompraCM sc
						inner join Articulos a
							on a.Aid = sc.Aid
						inner join Almacen alm
							on alm.Aid = sc.Alm_Aid
					 where sc.Ecodigo			= #Arguments.Ecodigo#
					   and sc.ESidsolicitud		= #arguments.ESidsolicitud#
					   and sc.DSnoPresupuesto	= 0
					   and sc.DStipo = 'A'
				</cfquery>
				<cfif rsSQL.recordCount NEQ 0>
					<cfthrow message="No hay suficientes existencias del Articulo '#trim(rsSQL.Acodigo)# - #trim(rsSQL.Adescripcion)#' en el Almacén '#trim(rsSQL.Almcodigo)# - #trim(rsSQL.Bdescripcion)#' para satisfacer la Solicitud de Requisición">
				</cfif>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>
