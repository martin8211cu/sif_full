<cfcomponent output="false" displayname="CRCChequearProducto" extends="CRCCompras">
 
 
 	<cfset This.C_CHEQUEO_OK = '0'>  
 	<cfset This.C_PARAM_PORCIENTO_SOBRE_GIRO_VALES = '30000714'>  
 	<cfset This.C_TIPOD_DOCUMENTO_FIRMA 	   = 'FIRMA'>  

	<cffunction name="init" access="public" output="no" returntype="CRCChequearProducto" hint="constructor del componente con parametros de entradas primarios">  
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#"> 

		<cfset Super.init( arguments.DSN, arguments.Ecodigo)>

 		<cfreturn this> 
	</cffunction>
 

	<cffunction name="chequear" returntype="struct" hint="chequea que la informacion de la compra que se desea realizar sea correcta">
		<cfargument name="Tipo_Transaccion" required="no"  type="string"  default="" >
		<cfargument name="Num_Tarjeta"  	required="no"  type="string"  default=""> 
		<cfargument name="Num_Folio" 		required="no"  type="string"  default="">
		<cfargument name="Cod_ExtTienda" 	required="no"  type="string"  default="">
		<cfargument name="CodExtDist" 		required="no"  type="string"  default=""> 
		<cfargument name="Monto" 			required="no"  type="string"  default="0"> 
		<cfargument name="token" 	        required="no"  type="string"  default=""> 
  		
  		<cftry> 

	 		<cfset chequearToken(arguments.token)> 
			<cfset resultCheck = chequearProducto(Tipo_Transaccion = arguments.Tipo_Transaccion,
											      Num_Tarjeta      = arguments.Num_Tarjeta,
											      Num_Folio        = arguments.Num_Folio,
											      Cod_Tienda       = arguments.Cod_ExtTienda,
											      CodExtDist       = arguments.CodExtDist,
											      ChequearMonto    = false)>

			<cfreturn resultCheck>

		<cfcatch> 
			<cfreturn crearMensaje(cfcatch.errorcode, cfcatch.message)>
		</cfcatch>
		</cftry> 
 
    </cffunction>


	<cffunction name="chequearProducto" returntype="struct" hint="chequea que la informacion de la compra que se desea realizar sea correcta">
		<cfargument name="Tipo_Transaccion" required="no"  type="string"  default="" >
		<cfargument name="Num_Tarjeta"  	required="no"  type="string"  default=""> 
		<cfargument name="Num_Folio" 		required="no"  type="string"  default="">
		<cfargument name="Cod_Tienda" 		required="no"  type="string"  default="">
		<cfargument name="CodExtDist" 		required="no"  type="string"  default=""> 
		<cfargument name="Monto" 			required="no"  type="string"  default="0">
		<cfargument name="ChequearMonto"    required="no"  type="boolean" default=true>  
		<cfargument name="incluirInfoTA"    required="no"  type="boolean" default=true>  


			<cftry>
				<cfset arguments.Num_Tarjeta = replace(arguments.Num_Tarjeta," ","","all")>
				<!-- VALIDACION DE PARAMETRO MONTO-->
				<cfif arguments.ChequearMonto  and (isNumeric(arguments.Monto) eq false or arguments.Monto lte 0)> 
					<cfthrow errorcode="#This.C_ERROR_MONTO_VACIO#" type="TransaccionException" message = "El valor del monto debe ser numerico y mayor que 0"> 
				</cfif>

				<!--- OBTENCION DE ID PARA TIPO DE TRANSACCION --->
				<cfquery name="q_TipoTransaccion" datasource="#This.DSN#">
					select id, TipoMov
					from   CRCTipoTransaccion
					where  Codigo = '#arguments.Tipo_Transaccion#'
					and    afectaCompras = 1;
				</cfquery>	

				<cfif q_TipoTransaccion.recordcount eq 0>
					<cfthrow errorcode="#This.C_ERROR_TIPO_TRANSACCION#" type="TransaccionException" message = "Tipo de Transaccion [#trim(arguments.Tipo_Transaccion)#] No reconocida">
				</cfif>	

		  		<cfset rsCuenta = obtenerCuenta(Tipo_Transaccion=#arguments.Tipo_Transaccion#,
		  										CodExtDist=#arguments.CodExtDist#,
		  										Cod_Tienda=#arguments.Cod_Tienda#,
		  										Num_Folio=#arguments.Num_Folio#,
		  										Num_Tarjeta=#arguments.Num_Tarjeta#)>	
	  								 
		 		<cfset validarCuenta(orden=#rsCuenta.orden#)> 
		 		<cfset validarCuentaActivaParaCompra(orden=#rsCuenta.orden#)>  

		 		<!--- validacion de disponibilidad para la cuenta--->
		 		<cfset loc.ValorDisponible = validarDisponibilidad(
								 			 Tipo_Transaccion= #arguments.Tipo_Transaccion#, 	
								 			 SaldoActual     = rsCuenta.SaldoActual, 
								 			 MontoAprobado   = rsCuenta.MontoAprobado,
								 			 Monto           = #arguments.Monto#, 
								 			 SocioNegocioID  = rsCuenta.SNegociosSNid, 
											 CuentaID        = rsCuenta.ID)>

				<!--- validacion de disponibildiad para una tarjeta adicional---->	
				<cfset loc.valorDisponibleTA = ''>
				<cfset loc.sTarjetaAdicional = ''>
				<cfif rsCuenta.MontoTarjetaAdicional gt 0>
					<cfset loc.valorDisponibleTA = validarDisponibilidadTA(Tipo_Transaccion = #arguments.Tipo_Transaccion#,
																		   Tipo_Producto    = #getTipoProductoPorTipoTran(arguments.Tipo_Transaccion)#,
															               MontoAprobado    = rsCuenta.MontoTarjetaAdicional,
															               Monto            = #arguments.Monto#,
															               cuentaID         =  rsCuenta.ID,
															               numeroTarjeta    =  #arguments.Num_Tarjeta#
															               )>


				</cfif>
  
		 		<cfset result = structNew()>
		 		<!-- para productos de vales se busca la informacion de valor de cheque en blanco y si permite contravale-->
 				<cfset result.ValorChequeBlanco = "">
		 		<cfset result.PermiteContraVale = "">

		 		<cfquery name="qCuentaCredito" datasource="#This.DSN#">
		 			select DMontoValeCredito, iif(PermiteContraValor is null or PermiteContraValor = 0, 'N', 'S') PermiteContraValor,
							isnull(PorcSobregiro,0) PorcSobregiro
		 			from CRCTCParametros
		 			where SNegociosSNid = #rsCuenta.SNegociosSNid#
		 			and CRCCuentasid = #rsCuenta.id#
		 		</cfquery>
 
		 		<cfif qCuentaCredito.recordCount neq 0>
		 			<cfset result.ValorChequeBlanco = qCuentaCredito.DMontoValeCredito>
		 			<cfset result.PermiteContraVale = qCuentaCredito.PermiteContraValor>
		 		</cfif>

		 		<!--- si es vale interno se adiciona el porciento de sobre giro--->
		 		<!--- <cfset loc.cporcientoSobreGiro = 0>
		 		<cfif arguments.Tipo_Transaccion eq This.C_TT_VALES and  arguments.CodExtDist eq '' and arguments.Cod_Tienda eq ''>  --->
					<cfset loc.cporcientoSobreGiro = qCuentaCredito.PorcSobregiro>
		 		<!--- </cfif> --->

		 		<!--- se obtiene la firma del socio de negocio--->
		 		<cfquery name="rsFirma" datasource="#This.DSN#">
					select SNOarchivo, SNOcontenido , SNOcontenttype
					from   SNegociosObjetos
					where  Ecodigo        =  #This.Ecodigo#
					and    SNcodigo       =  #rsCuenta.SNcodigo#
					and    SNOTipoArchivo = '#This.C_TIPOD_DOCUMENTO_FIRMA#'
					order by SNOid desc
				</cfquery> 

				<cfquery name="rsAnotaciones" datasource="#This.DSN#">
					select SNAtipo, SNAdescripcion, SNcodigo from SNAnotaciones
					where SNApuntoVenta = 1
						and SNcodigo = #rsCuenta.SNcodigo#
				</cfquery> 

				<cfset anotaciones = "">
				<cfset strU = "">
				<cfloop query="rsAnotaciones">
					<cfset anotaciones = "#anotaciones##strU##rsAnotaciones.SNAdescripcion#">
					<cfset strU = "|">
				</cfloop>

				<cfset loc.Firma = ''>
				<cfset loc.Firmas = []>
				<cfif rsFirma.recordcount gt 0 > 
					<cfloop query="#rsFirma#">
						<cfset loc.Firma = toBase64(#rsFirma.SNOcontenido#)> 
						<cfset ArrayAppend(loc.Firmas, loc.Firma)>
					</cfloop>
				</cfif>

		 		<cfset result.Firma 	   		 = "#loc.Firma#">
		 		<cfset result.Firmas 	   		 = "#ArrayToList(loc.Firmas)#">
		 		<cfset result.Disponible   		 = #loc.ValorDisponible# >
		 		<!--- <cfset result.DisponibleTA   	 = #loc.valorDisponibleTA#> --->
		 		<cfset result.EstadoCuenta 		 = rsCuenta.EstatusCuenta>
		 		<cfset result.Cliente      		 = rsCuenta.SNnombre>
		 		<cfset result.Telefono    		 = rsCuenta.SNtelefono> 
		 		<cfset result.Cuenta       		 = rsCuenta.NumeroCuenta> 
		 		<cfset result.FechaExpiracion 	 = rsCuenta.FechaExpiracion> 
		 		<cfset result.porcientoSobreGiro = loc.cporcientoSobreGiro> 
		 		<cfset result.Codigo      		 = This.C_CHEQUEO_OK>
		 		<cfset result.Anotaciones        = anotaciones>
		 		<cfset result.Mensaje    		 = "Operacion exitosa">

 
				<cfif isdefined("rsCuenta.EsTarjetaAdicional") and rsCuenta.EsTarjetaAdicional eq 1>

					<cfquery name="qTarjetaAdicional" datasource="#This.dsn#">
						select ta.id, SNnombre, TCdireccion1, Telefono, TCciudad,  
							isnull(MontoMaximo,0) MontoMaximo, isnull(MontoT,0) MontoT,
							Disponible = case 
								when case when isnull(MontoMaximo,0) - isnull(MontoT,0) < 0 then 0 else isnull(MontoMaximo,0) - isnull(MontoT,0) end  - c.SaldoActual > 0
									then case when isnull(MontoMaximo,0) - isnull(MontoT,0) < 0 then 0 else isnull(MontoMaximo,0) - isnull(MontoT,0) end  - c.SaldoActual
								else 0
							end
						from CRCTarjetaAdicional ta
						inner join CRCTarjeta t on t.CRCTarjetaAdicionalid = ta.id
						inner join CRCCuentas c on t.CRCCuentasid = c.id 
						left join (
							select j.CRCTarjetaAdicionalid, sum(Monto*case when TipoMov = 'D' then -1 else 1 end) MontoT
							from CRCTransaccion t
							inner join CRCTarjeta j on t.CRCTarjetaid = j.id
							inner join CRCCortes c on t.Fecha between c.FechaInicio and dateadd(d,1,c.FechaFin) and c.Tipo = 'TC'
								and c.codigo = (select min(codigo) codigo from CRCCortes where Tipo='TC' and Cerrado = 0 and Ecodigo = #this.Ecodigo#)
							group by j.CRCTarjetaAdicionalid
						) jt on ta.id = jt.CRCTarjetaAdicionalid
						where t.Numero  = '#arguments.Num_Tarjeta#'		
					</cfquery>
					
					<cfif qTarjetaAdicional.recordcount gt 0>
						<cfset result.Cliente 	      = qTarjetaAdicional.SNnombre>  
						<cfset result.Telefono    		 = qTarjetaAdicional.Telefono>
						<cfif qTarjetaAdicional.MontoMaximo gt 0>
							<cfset result.Disponible = qTarjetaAdicional.Disponible >  
						</cfif>

					</cfif>
	 
				</cfif>
  
		 		<cfreturn result>
 	 
			<cfcatch> 
				<cfreturn crearMensaje(cfcatch.errorcode, cfcatch.message)>
			</cfcatch>
			</cftry> 
 
	</cffunction>

 
	<cffunction name="validarCuentaActivaParaCompra" hint="Chequea que la cuenta este en un estado que pueda comprar">
		<cfargument name="orden" type="numeric" required="yes" >

		<!--parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIM_EST_CUENTA_COMPRAR#",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Permitir compras hasta estado")>

		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_CONF_LIMITE_ESTADO_COMPRA#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset crcLimiteEstadoCompra = paramInfo.valor>
 
		<cfif orden gte crcLimiteEstadoCompra>
			<cfthrow errorcode="#This.C_ERROR_CUENTA_NO_ACTIVA_PARA_COMPRA#" message="Cuenta no activa para compras">
		</cfif>		
	</cffunction>
	


	<cffunction name="validarDisponibilidad" returntype="numeric" hint="valida que la cuenta tenga saldo disponible, el saldo de cuenta mas el monto de la compra sea mayor que el monto de credito. Devuelve el disponible">
		<cfargument name="Tipo_Transaccion" 	 required="yes"    type="string">
		<cfargument name="SaldoActual"   		 required="yes"    type="numeric">
		<cfargument name="MontoAprobado" 		 required="yes"    type="numeric">
		<cfargument name="Monto"		 		 required="yes"    type="numeric">
		<cfargument name="SocioNegocioID" 		 required="yes"    type="numeric">
		<cfargument name="CuentaID" 			 required="yes"    type="numeric">
		<cfargument name="MontoTarjetaAdicional" required="false"  type="numeric" default="0">

		<cfset loc.returnoValorDisp = 0>
		<cfset loc.MontoSaldoActual = arguments.SaldoActual + arguments.Monto>
		<cfset loc.MontoPromosion   = 0>

		<cfquery name="q_Promos" datasource="#This.DSN#">
			select top 1
				FechaDesde,
				FechaHasta,
				Monto,
				Porciento,
				aplicaVales, aplicaTC, aplicaTM
			from CRCPromocionCredito
			where Ecodigo = '#This.Ecodigo#'
			and '#DateFormat(Now(), "yyyy/mm/dd")#'  between FechaDesde and FechaHasta 
		</cfquery> 

		<cfset loc.MontoPromosion = 0>

		<cfif q_Promos.recordCount gt 0>
			<cfif q_Promos.Porciento eq 1>
				<cfset loc.MontoPromosionCalc = (#arguments.MontoAprobado# * (q_Promos.Monto / 100))>
			<cfelse>
				<cfset loc.MontoPromosionCalc = q_Promos.Monto>
			</cfif>

			<cfif arguments.Tipo_Transaccion eq This.C_TT_VALES and q_Promos.aplicaVales eq 1>
				<cfquery name="q_CRCTCParams" datasource="#This.DSN#">
					select DCreditoAbierto
					from  CRCTCParametros 
					where  SNegociosSNid = #arguments.SocioNegocioID# 
					and CRCCuentasid = #arguments.CuentaID#
				</cfquery> 				
				<cfif q_CRCTCParams.recordcount ge 1 >
					<cfset q_CRCTCParams = QueryGetRow(q_CRCTCParams, 1)>
					<cfif q_CRCTCParams.DCreditoAbierto eq 1>						
						<cfset loc.MontoPromosion = loc.MontoPromosionCalc>
					</cfif>
				</cfif>
			<cfelseif (arguments.Tipo_Transaccion eq This.C_TT_TARJETA and q_Promos.aplicaTC eq 1)
					or (arguments.Tipo_Transaccion eq This.C_TT_MAYORISTA and q_Promos.aplicaTM eq 1)>
				<cfset loc.MontoPromosion = loc.MontoPromosionCalc>
			</cfif>
		</cfif>


		<cfif abs(loc.MontoSaldoActual) gt arguments.MontoAprobado + loc.MontoPromosion>
			<cfthrow errorcode="#This.C_ERROR_DISPONIBILIDAD_SALDO#" type="TransaccionException" message = "La cuenta no tiene saldo disponible">
		</cfif>	
 
		<cfset loc.returnoValorDisp = (arguments.MontoAprobado + loc.MontoPromosion) - abs(loc.MontoSaldoActual)>	

		<cfreturn loc.returnoValorDisp>
	</cffunction>
 
	<cffunction name="validarDisponibilidadTA" access="private"  returntype="numeric" hint="chequear que el total de compras en el corte no supere el monto maxico asignado por corte que tiene la tarjeta adicional">
		<cfargument name="Tipo_Transaccion" required="yes"  type="string">
		<cfargument name="Tipo_Producto"    required="yes"  type="string">
		<cfargument name="MontoAprobado"    required="yes"  type="numeric">
		<cfargument name="Monto"		 	required="yes"  type="numeric" default="0">
		<cfargument name="cuentaID"         required="yes"  type="numeric">
		<cfargument name="numeroTarjeta"    required="yes"  type="string">

		<cfif arguments.MontoAprobado lt arguments.Monto> 
			<cfthrow errorcode="#This.C_ERROR_DISPONIBILIDAD_SALDO_TA#" type="TransaccionException" message = "El monto de la tarjeta adicional: #arguments.numeroTarjeta# es superior al monto de credito maximo permitido para consumir">
			 
		</cfif>

		<cfquery name="qTranTarjCorte" datasource="#This.DSN#">
		   select isnull(sum(t.Monto),0)  MontoCompras
		   from CRCTransaccion t
		   inner join CRCTarjeta ta
		   on t.CRCTarjetaid = ta.id
		   inner join CRCCuentas c
		   on t.CRCCuentasid = c.id
		   inner join CRCMovimientoCuentaCorte mcc
		   on c.id = mcc.CRCCuentasid
		   where  c.id = #arguments.cuentaID#
		   and    ta.Numero  = '#arguments.numeroTarjeta#'
		   and    mcc.Corte in  (select Codigo
					   	              from CRCCortes cr  
					   	              where cr.Tipo    = '#arguments.Tipo_Producto#'
					   	              and   cr.cerrado = 0
					   	              and   t.Fecha between cr.FechaInicio and cr.FechaFin ) 
		</cfquery>
 

		<cfif (qTranTarjCorte.MontoCompras + arguments.Monto) gt #arguments.MontoAprobado# >
			<cfthrow errorcode="#This.C_ERROR_DISPONIBILIDAD_SALDO_TA#" type="TransaccionException" message = "La tarjeta adicional: #arguments.numeroTarjeta# no tiene saldo disponible">
		</cfif> 
		<cfreturn #arguments.MontoAprobado# - qTranTarjCorte.MontoCompras >

	</cffunction>
 
 

 
</cfcomponent>