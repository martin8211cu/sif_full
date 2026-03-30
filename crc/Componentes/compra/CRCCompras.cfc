<cfcomponent output="false" displayname="CRCCompras" extends="crc.Componentes.transacciones.CRCTransaccion">

	
	<cfset This.C_ERROR_INFO_VALES 	         = '00005'>
	<cfset This.C_ERROR_DISPONIBILIDAD_SALDO = '00006'>
	<cfset This.C_ERROR_TIENDA_DIST_EXTERNO  = '00007'>
	<cfset This.C_ERROR_VALE_CANCELADO       = '00008'>
	<cfset This.C_ERROR_CUENTA_NO_ENCONTRADA = '00009'> 
	<cfset This.C_ERROR_MONTO_VACIO			 = '00010'>
	<cfset This.C_ERROR_TICKET_REPETIDO		 = '00011'>
	
	
	<cfset This.C_ERROR_CONF_LIMITE_ESTADO_COMPRA 	 = '00012'> 
	<cfset This.C_ERROR_CUENTA_NO_ACTIVA_PARA_COMPRA = '00013'>  
	<cfset This.C_ERROR_TOKEN         				 = '00014'>  
	<cfset This.C_ERROR_DATOS_EMPRESA 		    	 = '00015'>
	<cfset This.C_ERROR_ELIMINACION_TRANSACCION	     = '00016'>	
	<cfset This.C_ERROR_VALE_EXPIRADO          	     = '00017'>	
	<cfset This.C_ERROR_DISPONIBILIDAD_SALDO_TA 	 = '00018'>	
	
	<!--- Parametros de configuracion --->
	<cfset This.C_PARAM_LIM_EST_CUENTA_COMPRAR = '30000707'> 

	<!--- estado de los productos--->
	<cfset This.C_ESTADO_FOLIO_ACTIVO    = 'A'> 
	<cfset This.C_ESTADO_FOLIO_CANCELADO = 'C'>
	<cfset This.C_ESTADO_TARJETA_ACTIVO  = 'A'> 
	<cfset This.ESTADO_FOLIO_CONSUMIDO   = 'CS'> 
	

 
	<cffunction name="init" access="private" returntype="CRCCompras"> 
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
		<cfset Super.init(arguments.DSN, arguments.Ecodigo)>

		<cfreturn this>
	</cffunction>	
  
	<cffunction name="obtenerCuenta" access="private" returntype="query" hint="busca un registro de cuentas dada la información recibida como parametro"> 
		<cfargument name="Tipo_Transaccion" required="true"   type="string">
		<cfargument name="CodExtDist" 		required="false"  type="string">
		<cfargument name="Cod_Tienda" 		required="false"  type="string">
		<cfargument name="Num_Folio" 		required="false"  type="string">
		<cfargument name="Num_Tarjeta"  	required="false"  type="string"> 


		<!-- buscar el identificador de la cuenta -->
 		<cfif arguments.Tipo_Transaccion eq This.C_TT_VALES> 

 			<!--- el valor del folio no puede ser vacio --->
 			<cfif trim(arguments.Num_Folio) eq ""  > 
 				<cfthrow errorcode="#This.C_ERROR_INFO_VALES#" message="Para transacciones de vales el valor del folio es obligatorio" />
 			</cfif>

 			<!--- compra por vale de un distribuidor--->
	 		<cfif arguments.CodExtDist neq '' and arguments.Cod_Tienda neq ''>
	 			 
	 			<!---  vale con informacion del distribuidor en tienda externa --->
	 			<cfset rsCuenta = obCuentaValeExterno(CodExtDist=arguments.CodExtDist, Cod_Tienda=arguments.Cod_Tienda,
	 				Num_Folio=arguments.Num_Folio, Tipo_Producto= #This.C_TP_DISTRIBUIDOR#)>

	 		<cfelse>

	 			<!---  vale de un distribuidor de la tienda --->
	 			<cfset rsCuenta =obCuentaVale(Num_Folio=arguments.Num_Folio)>

	 		</cfif>

	 	<cfelseif arguments.Tipo_Transaccion eq #This.C_TT_MAYORISTA# or arguments.Tipo_Transaccion eq #This.C_TT_TARJETA# >
			<!--- compra por tarjeta mayorista o tarjeta de credito--->

			<cfif trim(arguments.Num_Tarjeta) eq "">
				<cfthrow errorcode="#This.C_ERROR_INFO_VALES#" message="Se debe enviar el número de tarjeta para transacciones con tarjeta de crédito o tarjeta mayorista" >
			</cfif>

 			<cfset rsCuenta = obCuentaTarjeta(Num_Tarjeta   = arguments.Num_Tarjeta, 
 											  Tipo_Producto = getTipoProductoPorTipoTran(arguments.Tipo_Transaccion))> 
 		<cfelse>
 			<cfthrow errorcode="#This.C_ERROR_TIPO_TRANSACCION#" type="TransaccionException" message = "Tipo de Transaccion [#trim(arguments.Tipo_Transaccion)#] No reconocida">
        </cfif>
  
        <cfreturn rsCuenta> 	
         
	</cffunction>


	<cffunction name="obCuentaValeExterno"  returntype="query" hint="busca información de cuenta por vale y tienda externa ">
		<cfargument name="CodExtDist"    required="yes">
		<cfargument name="Cod_Tienda"    required="yes">
		<cfargument name="Num_Folio"     required="yes">
		<cfargument name="Tipo_Producto" required="yes">

		<cfquery name="qTiendaExt" datasource="#This.DSN#">
			select id, ExpRegFolio from CRCTiendaExterna where Codigo = '#arguments.Cod_Tienda#'
		</cfquery>

		<cfif qTiendaExt.recordCount eq 0>
			<cfthrow errorcode="#This.C_ERROR_TIENDA_DIST_EXTERNO#" message="No se encontró información de tienda para vale externo" />
		</cfif>

		<cfset 	valorTiendaExterna = '-#qTiendaExt.id#' & ':' & '#arguments.CodExtDist#-'>
 	
		<cfquery name="rsParam" datasource="#This.DSN#">
			select SNegociosSNid
			from CRCTCParametros
			where TiendaExterna  like '%#valorTiendaExterna#%'	
		</cfquery> 
		<cfif rsParam.recordcount eq 0>
			<cfthrow errorcode="#This.C_ERROR_TIENDA_DIST_EXTERNO#" message="No se encontró información de distribuidor para vale externo" />
		</cfif> 

		<!-- chequear que exista una expresion regular asoiada a la tienda para aplicarla al folio
		pasado como parametro -->
		<cfif trim(qTiendaExt.ExpRegFolio) neq ''> 
			<cfif  refind( qTiendaExt.ExpRegFolio, arguments.Num_Folio) eq false>

				 <cfthrow errorcode="#This.C_ERROR_TIENDA_DIST_EXTERNO#" message="El folio enviado no aplica en la expresion regular registrada para la tienda externa" />
			</cfif>

		</cfif>
 
		<!--- chequear vale externo  no este cancelado--->
		<cfquery name="rsValeExtCancelado" datasource="#This.DSN#">
			select top 1 Estado
			from CRCValesExtCancelados vec
			inner join CRCTiendaExterna te
			on 	  vec.CRCTiendaExternaid    = te.id
			where vec.Folio = '#arguments.Num_Folio#' 
			and   te.Codigo = '#arguments.Cod_Tienda#' 
		</cfquery> 

		<cfif rsValeExtCancelado.recordcount neq 0>
			
			<cfset loc.EstadoFolio = ''>
			<cfif rsValeExtCancelado.Estado  eq #This.C_ESTADO_FOLIO_CANCELADO#>
				<cfset loc.EstadoFolio = 'Cancelado'>
			<cfelseif rsValeExtCancelado.Estado  eq #This.ESTADO_FOLIO_CONSUMIDO#>
				<cfset loc.EstadoFolio = 'Consumido'>
			</cfif>

			<cfthrow errorcode="#This.C_ERROR_VALE_CANCELADO#" message="El vale externo con número de folio #arguments.Num_Folio# se encuentra registrado en el sistema  como #loc.EstadoFolio#" />

		</cfif> 
 
		<cfreturn obtenerCuentaSNegocio(SNid=#rsParam.SNegociosSNid#, Tipo_Producto=#arguments.Tipo_Producto#)>

	</cffunction>	


	<cffunction name="obtenerCuentaSNegocio" returntype="query"  access="private"  hint="obtener cuenta por id socio negocio">
		<cfargument name="SNid"          required="yes"   type="numeric"> 
		<cfargument name="Tipo_Producto" required="yes">
 
		<cfquery name="rsCuenta" datasource="#This.DSN#">
			SELECT c.ID, c.CRCEstatusCuentasid, ec.Orden, isnull(c.SaldoActual,0) as SaldoActual, c.MontoAprobado, 
				   c.SNegociosSNid, null AS TarjetaID, c.Tipo as TipoProducto, sn.SNnombre, concat(sn.SNtelefono,isnull( concat(', ',sn.SNFax),0)) SNtelefono, ec.Descripcion EstatusCuenta, c.Numero as NumeroCuenta, '' as FechaExpiracion, 0 as MontoTarjetaAdicional, sn.SNcodigo
			FROM   CRCCuentas c
			INNER JOIN CRCEstatusCuentas ec
			ON c.CRCEstatusCuentasid = ec.id  
			INNER JOIN SNegocios sn 
			ON    sn.SNid  = c.SNegociosSNid
			WHERE sn.SNid  = #arguments.SNid#
			AND   c.Tipo   = '#arguments.Tipo_Producto#'
		</cfquery>

		<cfif rsCuenta.recordCount eq 0>
			<cfthrow errorcode="#This.C_ERROR_CUENTA_NO_ENCONTRADA#" message="No se encontró información de cuenta para el código de cliente y de tienda externa enviado">
		</cfif> 

		<cfreturn rsCuenta>		
 
	</cffunction>


	<cffunction name="obCuentaVale" returntype="query"  hint="obtener cuenta por folio de un distribuidor interno o de la tienda">
		<cfargument name="Num_Folio" required="yes"   type="string" >	

		<cfquery name="rsCuenta" datasource="#This.DSN#">
			SELECT c.ID, c.CRCEstatusCuentasid, ec.Orden, isnull(c.SaldoActual,0) as SaldoActual, c.MontoAprobado,
				   c.SNegociosSNid, null AS TarjetaID, c.Tipo as TipoProducto ,f.Estado as EstadoFolio, sn.SNnombre, concat(sn.SNtelefono,isnull( concat(', ',sn.SNFax),0)) SNtelefono, ec.Descripcion EstatusCuenta, c.Numero as NumeroCuenta, f.FechaExpiracion, 0 as MontoTarjetaAdicional, sn.SNcodigo
			FROM   CRCCuentas c 
			INNER JOIN CRCEstatusCuentas ec
			ON c.CRCEstatusCuentasid = ec.id
			INNER JOIN CRCControlFolio f 
			ON  f.CRCCuentasid = c.id
			INNER JOIN SNegocios sn 
			ON    sn.SNid  = c.SNegociosSNid
			WHERE f.Numero = '#arguments.Num_Folio#'
			and  c.Tipo = '#This.C_TP_DISTRIBUIDOR#'
		</cfquery>

		<cfif rsCuenta.RecordCount eq 0>
			<cfthrow errorcode="#This.C_ERROR_CUENTA_NO_ENCONTRADA#" message="No se encontró una cuenta con el siguiente número de folio asociado: #arguments.Num_Folio#">
		</cfif>
		<cfif rsCuenta.EstadoFolio neq #This.C_ESTADO_FOLIO_ACTIVO#>
			<cfthrow errorcode="#This.C_ERROR_VALE_CANCELADO#" message="El vale con número de folio #arguments.Num_Folio# no está activo">
		</cfif>

		<cfset loc.currentDate = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))> 
		<cfif rsCuenta.FechaExpiracion neq '' and rsCuenta.FechaExpiracion lt #loc.currentDate#>
			<cfthrow errorcode="#This.C_ERROR_VALE_EXPIRADO#" message="El vale con número de folio #arguments.Num_Folio# ya ha expirado">
		</cfif> 
		<cfreturn rsCuenta>	

	</cffunction>


	<cffunction name="obCuentaTarjeta" returntype="query" hint="busca un cuenta por el codigo de la tarjeta">
		<cfargument name="Num_Tarjeta"   required="yes"  type="string" >	
		<cfargument name="Tipo_Producto" required="yes"  type="string" >	

		<cfquery name="rsCuenta" datasource="#This.DSN#">
			SELECT c.ID, c.CRCEstatusCuentasid, ec.Orden, isnull(c.SaldoActual,0) as SaldoActual,c.MontoAprobado,
				   c.SNegociosSNid, t.id AS TarjetaID, c.Tipo as TipoProducto, sn.SNnombre, sn.SNtelefono, ec.Descripcion EstatusCuenta, c.Numero as NumeroCuenta, t.Estado EstadoTarjeta,'' as FechaExpiracion, isnull(ta.MontoMaximo,0) as MontoTarjetaAdicional, sn.SNcodigo,
				   case when CRCTarjetaAdicionalid is null then 0 else 1 end EsTarjetaAdicional
			FROM   CRCCuentas c 
			INNER JOIN CRCEstatusCuentas ec
			ON c.CRCEstatusCuentasid = ec.id
			INNER JOIN CRCTarjeta t 
			ON c.id = t.CRCCuentasid
			LEFT JOIN CRCTarjetaAdicional ta
			ON t.CRCTarjetaAdicionalid = ta.id
			INNER JOIN SNegocios sn 
			ON     sn.SNid  = c.SNegociosSNid   
			WHERE  t.Numero = '#arguments.Num_Tarjeta#' 
			and    c.Tipo   = '#arguments.Tipo_Producto#'  
		</cfquery>

		<cfif rsCuenta.recordCount eq 0 or rsCuenta.EstadoTarjeta neq This.C_ESTADO_TARJETA_ACTIVO>
			<cfthrow errorcode="#This.C_ERROR_CUENTA_NO_ENCONTRADA#" message="No se encontro una cuenta con la siguiente tarjeta asociada: #arguments.Num_Tarjeta#, o la tarjeta no esta activada">
		</cfif>  	
		
		<cfreturn rsCuenta>	

	</cffunction>


	<cffunction name="validarTicket" returntype="void" hint="para las transacciones de compra se valida que el atributo de ticket tenga valor y que no este repetido en la base de datos">
		<cfargument name="Num_Ticket" type="string" required="yes" >

		<!--- VALIDACION TICKET REPETIDO --->
		<cfquery name="q_Unique" datasource="#This.DSN#">
			Select top 1 'x' 
			from  CRCTransaccion 
			where Ticket  = '#arguments.Num_Ticket#' 
			and   Ecodigo = '#This.Ecodigo#'
		</cfquery>
 
		<cfif q_Unique.recordcount neq 0>
			<cfthrow errorcode="#This.C_ERROR_TICKET_REPETIDO#" type="TransaccionException" message = "El ticket ya existe">
		</cfif> 		

	</cffunction>	


	<cffunction name="crearMensaje" hint="creador de mensaje" returntype="struct" access="private">
		<cfargument name="codigo" type="string">
		<cfargument name="mensaje" type="string">

		<cfset result = structNew()>
		<cfset result.codigo  = #arguments.codigo#> 
		<cfset result.mensaje = #arguments.mensaje#> 
		<cfreturn  result>

	</cffunction>

  	
 
	<cffunction name="chequearToken" returntype="void" access="private" hint="chequea el token enviado via WS, retorna error si no es correcto">
		<cfargument name="token" required="no"  type="string"  default=""> 

		<cfinvoke method="tokenPrivado" returnvariable="tokenOrig" component="crc.Componentes.compra.WSGetToken"/>
	  
		<cfif #tokenOrig# neq arguments.token>
			<cfthrow errorcode="#This.C_ERROR_TOKEN#" type="TransaccionException" message = "No se envio el token o el enviado es incorrecto">
		</cfif>
 
	</cffunction>


 	<cffunction name="eliminarTransaccionCompra" returntype="string" hint="elimina una transaccion de compra">
 		<cfargument name="transactionID" type="numeric" required="true">
 		<cfargument name="cancelacion" 	 type="boolean" required="false" default="true">

 		<cfquery name="q_Transaccion" datasource="#This.DSN#">
 			select id, CRCCuentasid, Monto, CRCTarjetaid, Folio, Fecha,Tienda,Ticket,Cliente,
 			       CURP, Descripcion,cadenaEmpresa, sucursal, caja, Parciales, Observaciones,CRCTipoTransaccionid,
 			       TipoTransaccion, TipoMov, 
 			       isnull(afectaSaldo,0) afectaSaldo, 
 			       isnull(afectaInteres,0) afectaInteres,
 			       isnull(afectaCompras,0) afectaCompras,
 			       isnull(afectaPagos,0) afectaPagos,
 			       isnull(afectaCondonaciones,0) afectaCondonaciones,
 			       isnull(afectaGastoCobranza,0) afectaGastoCobranza,
 			       isnull(afectaSeguro,0)  afectaSeguro
 			from CRCTransaccion
 			where id = #arguments.transactionID# 
 		</cfquery>

 
 		<cfif q_Transaccion.recordcount eq 0> 
			<cfthrow errorcode="#This.C_ERROR_ELIMINACION_TRANSACCION#" type="TransaccionException" message = "No existe registro para la transaccion identificada con el numero: #arguments.transactionID#"> 
 		</cfif>

 		<cfset loc.idTransaccionCancelada = ''>
 		<cfif #arguments.cancelacion# eq true>

	 		<!---  crear registro en la tabla CRCTransaccionesCanceladas--->
	  	<cfset loc.idTransaccionCancelada = crearCRCTransaccionCancelada(CuentaID  = #q_Transaccion.CRCCuentasid#,
															    Tipo_TransaccionID = #q_Transaccion.CRCTipoTransaccionid#,
															    TarjetaID 		   = #q_Transaccion.CRCTarjetaid#,
															    Num_Folio 		   = #q_Transaccion.Folio#,
																Fecha_Transaccion  = #now()#,
															    Cod_Tienda    	   = #q_Transaccion.Tienda#,
															    Num_Ticket    	   = #q_Transaccion.Ticket#,
																Monto         	   = #q_Transaccion.Monto#,
															    Cliente       	   = #q_Transaccion.Cliente#,
															    Parcialidades 	   = #q_Transaccion.Parciales#,
															    Fecha_Inicio_Pago  = #now()#,
															    Observaciones 	   = #q_Transaccion.Observaciones#,
															    CURP               = #q_Transaccion.CURP#,
															    Descripcion   	   = #q_Transaccion.Descripcion#,
															    cadenaEmpresa 	   = #q_Transaccion.cadenaEmpresa#,
															    sucursal      	   = #q_Transaccion.sucursal#,
															    caja               = #q_Transaccion.caja#,
															    TipoTransaccion    = #q_Transaccion.TipoTransaccion#,
															    TipoMov            = #q_Transaccion.TipoMov#,
															    afectaSaldo          = #q_Transaccion.afectaSaldo#,
															    afectaInteres        = #q_Transaccion.afectaInteres#,
															    afectaCompras        = #q_Transaccion.afectaCompras#,
															    afectaPagos          = #q_Transaccion.afectaPagos#,
															    afectaCondonaciones  = #q_Transaccion.afectaCondonaciones#,
															    afectaGastoCobranza  = #q_Transaccion.afectaGastoCobranza#,
															    afectaSeguro         = #q_Transaccion.afectaSeguro#
															    )>  
 
		</cfif>		

 		<cfset loc.CuentaID = q_Transaccion.CRCCuentasid>
 
 		<!--- chequear si la fecha de transaccion esta dentro de un corte en estado de calculo 1 o campo cerrado = 0  --->
 		<cfquery name="qCorteTransaccion" datasource="#This.DSN#">
 			select c.Codigo, c.FechaInicio, c.FechaFin, c.status 
 			from   CRCCortes c
 			where  exists (select 'x' 
 						   from CRCTransaccion t
 						   where t.FechaInicioPago between c.FechaInicio and c.FechaFin
 						   and   t.id = #arguments.transactionID#) 
 			and (Cerrado ='#This.C_STATUS_ABIERTO#' or status = '#This.C_STATUS_MP_CALC#')
 	    </cfquery>
 	      
 	    <cfif qCorteTransaccion.recordCount eq 0>
			<cfthrow errorcode="#This.C_ERROR_ELIMINACION_TRANSACCION#" type="TransaccionException" message = "La transaccion no se encuentra en un periodo que este abierto o con estado en monto calculado"> 
 	    </cfif>

 	    <!--- chequear que  los movimientos cuentas no tengan pagos asociados en el caso
 	         de que el campo status sea 1--->
 	    <cfif qCorteTransaccion.status eq #This.C_STATUS_MP_CALC#>

	 	    <cfquery name="qMovCuentaConPagos" datasource="#This.DSN#">
	 	    	select 'x'
	 	    	from   CRCMovimientoCuenta
	 	    	where  Corte = '#qCorteTransaccion.Codigo#'
	 	    	and    Pagado <> 0
	 	    	and    CRCTransaccionid = #arguments.transactionID#
	 	    </cfquery>

	 	    <cfif qMovCuentaConPagos.recordcount eq 0>
	 	    	<cfthrow errorcode="#This.C_ERROR_ELIMINACION_TRANSACCION#" type="TransaccionException" message = "La transaccion ya tiene pagos realizados"> 
	 	    </cfif>

	 	</cfif>

	 	<cfquery name="qCortesTran" datasource="#this.dsn#">
	 		select distinct mc.Corte 
	 		from CRCMovimientoCuenta mc 
	 		inner join CRCTransaccion t 
	 		on t.id = mc.CRCTransaccionid
	 		where t.id = #arguments.transactionID#

	 	</cfquery>

	 	<cfset loc.cortes = ''>
		<cfloop query = "qCortesTran"> 
			<cfset loc.cortes = ListAppend(loc.cortes,#qCortesTran.Corte#)>  
		</cfloop>

 	   
 	    <!--- borrar los movimiento cuenta dado el id de la transaccion ---> 
 	    <cfquery datasource="#This.DSN#">
 	    	delete from CRCMovimientoCuenta where CRCTransaccionid = #arguments.transactionID#;
 	    	delete from CRCTransaccion      where id = #arguments.transactionID#
 	    </cfquery>

 	    <!--- se actualizan en cero la columna MontoRequerido si no existe movimiento cuenta para la cuenta --->
    	 <cfquery datasource="#This.DSN#">
    		delete mcc  
    		from CRCMovimientoCuentaCorte mcc
    		where CRCCuentasid = #loc.CuentaID#
    		and mcc.Corte not in (select mc.Corte
    			                  from CRCMovimientoCuenta mc
    			                  inner join CRCTransaccion t 
    			                  on mc.CRCTransaccionid = t.id
    			                  where t.CRCCuentasid   = #loc.CuentaID#)
    	</cfquery>
 	
  
 		<!--- para movimiento cuenta corte se llama al metodo para que actualice los registros ---->
 			 	<!--- iterando para obtener los cortes --->
 		<cfset caMccPorCorteCuenta(cortes=#loc.cortes#, CuentaID=#loc.CuentaID#)>

 	    <!--- si el estado de calculo del corte (status) es 1, volver a generar el corte
 	           se deja procesando en un hilo --->
<!---  	    <cfif qCorteTransaccion.status eq #This.C_STATUS_MP_CALC#>
 	    	<cfthread name="thCrearToken">
 	    		<cfset fechaReprocesarCorte = DateAdd("d", 1, qCorteTransaccion.FechaFin)> 
	 	    	<cfset cRCProcesoCorte      = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte")>
	 	    	<cfset cRCProcesoCorte.procesarCorte(fechaCorte=fechaReprocesarCorte)>
	 		</cfthread>
	 	<cfelse>  --->
	 		<!--- actualizar la informacion de la cuenta --->
 		<cfquery datasource="#this.dsn#">
 			update CRCCuentas
 			set Compras = iif(Compras - #q_Transaccion.Monto# <0, 0, Compras - #q_Transaccion.Monto#) ,
 			    SaldoActual = iif(SaldoActual - #q_Transaccion.Monto# <0, 0, SaldoActual - #q_Transaccion.Monto#)
 			where id = #q_Transaccion.CRCCuentasid#
 		</cfquery> 
<!---  	    </cfif> --->

		<cfreturn loc.idTransaccionCancelada>
 	</cffunction>


 	<cffunction name="getTipoProductoPorTipoTran" returntype="string" access="private" hint="devuelve el tipo de producto por el tipo de transaccion">
 		 <cfargument name="Tipo_Transaccion" type="string" required="true" hint="tipo de transaccion de la cual se busca el tipo de producto">

 		<cfif arguments.Tipo_Transaccion eq This.C_TT_VALES>
 			<cfreturn This.C_TP_DISTRIBUIDOR>
 		<cfelseif arguments.Tipo_Transaccion eq This.C_TT_TARJETA>
 			<cfreturn This.C_TP_TARJETA>
 		<cfelseif arguments.Tipo_Transaccion eq This.C_TT_MAYORISTA>
 			<cfreturn This.C_TP_MAYORISTA>
 		<cfelse>
 			<creturn ''>
 		</cfif>

 	</cffunction>




<cffunction name="crearCRCTransaccionCancelada" access="public" returntype="string" hint="crea un nuevo registro de transacciones canceladas">
	<cfargument name="CuentaID"  		  required="yes" type="numeric">
	<cfargument name="Tipo_TransaccionID" required="yes" type="numeric"> 
	<cfargument name="Fecha_Transaccion"  required="yes" type="date">
	<cfargument name="Monto" 		      required="yes" type="numeric">
	<cfargument name="TarjetaID"  		  required="no"  type="string" 	default="">
	<cfargument name="Num_Folio" 		  required="no"  type="string" 	default="">
	<cfargument name="Cod_Tienda" 		  required="no"  type="string" 	default="">
	<cfargument name="Num_Ticket" 		  required="no"  type="string" 	default="">
	<cfargument name="Cliente" 			  required="no"  type="string" 	default="">
	<cfargument name="Parcialidades"  	  required="no"  type="numeric" default="1">
	<cfargument name="Fecha_Inicio_Pago"  required="no"  type="date" 	default="#arguments.Fecha_Transaccion#">
	<cfargument name="Observaciones"      required="no"  type="string" 	default=""> 
	<cfargument name="CURP" 			  required="no"  type="string" 	default="">
	<cfargument name="Descripcion" 	      required="no"  type="string"  default=""> 
	<cfargument name="cadenaEmpresa" 	  required="no"  type="string"  default="">
	<cfargument name="sucursal" 	      required="no"  type="string"  default="">
	<cfargument name="caja" 	  		  required="no"  type="string"  default=""> 
	<cfargument name="usarTagLastID" 	  required="no"  type="boolean" default=true> 
	<cfargument name="afectaSaldo" 	  	   required="no"  type="numeric" default=0> 
	<cfargument name="afectaInteres" 	   required="no"  type="numeric" default=0> 
	<cfargument name="afectaCompras" 	   required="no"  type="numeric" default=0> 
	<cfargument name="afectaPagos" 	  	   required="no"  type="numeric" default=0> 
	<cfargument name="afectaCondonaciones" required="no"  type="numeric" default=0> 
	<cfargument name="afectaGastoCobranza" required="no"  type="numeric" default=0> 
	<cfargument name="afectaSeguro" 	   required="no"  type="numeric" default=0> 
	<cfargument name="TipoTransaccion"     required="no"  type="string"  default=""> 
	<cfargument name="TipoMov"             required="no"  type="string"  default=""> 

		  
		<cfquery  datasource="#This.DSN#">
			insert into CRCTransaccionesCanceladas ( 
				Monto
				,TipoTransaccion
				,FechaInicioPago
				,CRCTipoTransaccionid
				,CRCTarjetaid
				,Tienda
				,Ticket
				,Folio
				,Cliente
				,Fecha
				,Observaciones
				,Parciales
				,Ecodigo
				,CURP
				,TipoMov
				,afectaSaldo 
				,afectaInteres 
				,afectaCompras 
				,afectaCondonaciones 
				,afectaGastoCobranza 
				,afectaSeguro 
			)values (
					 #arguments.Monto#
					 ,'#arguments.TipoTransaccion#'
					 ,#arguments.Fecha_Inicio_Pago#
					 ,#arguments.Tipo_TransaccionID#
					 ,<cfqueryparam value ="#arguments.TarjetaID#" cfsqltype="cf_sql_numeric" null="#arguments.TarjetaID eq ''#">
					 ,'#arguments.Cod_Tienda#'
					 ,'#arguments.Num_Ticket#'
					 ,'#arguments.Num_Folio#'
					 ,'#arguments.Cliente#'
					 ,#arguments.Fecha_Transaccion#
					 ,'#arguments.Observaciones#'
					 ,#arguments.Parcialidades#
					 ,#This.Ecodigo#
					 ,'#arguments.CURP#'
					 ,'#arguments.TipoMov#'
					 , #arguments.afectaSaldo#
					 , #arguments.afectaInteres#
					 , #arguments.afectaCompras#
					 , #arguments.afectaCondonaciones#
					 , #arguments.afectaGastoCobranza#
					 , #arguments.afectaSeguro#
			) 
			 
		</cfquery> 	
	 	 
		<cfquery name="lastID_inserted" datasource="#This.DSN#">
				select IDENT_CURRENT( 'CRCTransaccionesCanceladas' ) as lastID
		</cfquery>

		<cfreturn  lastID_inserted.lastID>
  
	</cffunction>   	

 	 
</cfcomponent>