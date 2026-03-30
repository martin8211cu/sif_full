<cfcomponent output="false" displayname="CRCTransaccionCompra" extends="CRCCompras">
  
  	<cfset This.C_OK = '0'>
	<cfset This.C_PARAM_DIAS_TOLERANCIA = '30000709'>
	<cfset This.C_PARAM_DIAS_FECHA_EXPIRACION_CONTRAVALE = '30000712'>
	<cfset This.C_ERROR_CONTRAVLE_EXISTENTE  = '10016'>
	<cfset This.C_ERROR_FECHA_TRANSACCION_CC = '10018'>
	<cfset This.ERROR_TICKET_REPETIDO 	     = '10019'>
 
	<cffunction name="init" access="private" returntype="CRCTransaccionCompra"> 
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
		<cfset Super.init(arguments.DSN, arguments.Ecodigo)>

		<cfreturn this>
	</cffunction>
 
 	<cffunction name="procesarCompra" access="public" returntype="struct" hint="procesar compra">
		<cfargument name="Fecha_Transaccion"  required="yes"   type="string">
		<cfargument name="Monto" 		      required="yes"   type="string">
		<cfargument name="Tipo_Transaccion"   required="yes"   type="string">
		<cfargument name="Num_Ticket" 		  required="yes"   type="string">
		<cfargument name="Num_Tarjeta"  	  required="no"    type="string" default=""> 
		<cfargument name="Cod_Tienda" 		  required="no"    type="string" default="">
		<cfargument name="Cod_ExtTienda" 	  required="no"    type="string" default="">
		<cfargument name="Num_Folio" 		  required="no"    type="string" default="">
		<cfargument name="CodExtDist" 		  required="no"    type="string" default="">
		<cfargument name="Cliente" 			  required="no"    type="string" default="">
		<cfargument name="Observaciones"      required="no"    type="string" default=""> 
		<cfargument name="Parcialidades"  	  required="no"    type="string" default="">
		<cfargument name="Fecha_Inicio_Pago"  required="no"    type="string" default="">
		<cfargument name="CURP" 			  required="no"    type="string" default="">
		<cfargument name="GeneraContraVale"   required="no"    type="string" default="">
   		<cfargument name="token" 	          required="no"    type="string" default=""> 
   		<cfargument name="cadenaEmpresa" 	  required="no"    type="string" default=""> 
   		<cfargument name="sucursal" 	      required="no"    type="string" default=""> 
   		<cfargument name="caja" 	          required="no"    type="string" default=""> 
  
  		<cfset loc.ContraVale = ''>

		 
    	<cftransaction>	
	    	<cftry>

	    		<cfset chequearToken(arguments.token)> 
 				
 				<cfif trim(arguments.Parcialidades) eq '' or isNumeric(arguments.Parcialidades) eq false
 						or arguments.Parcialidades lt 1>
 					<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "Se debe enviar la cantidad de parcialidades. El valor debe ser numerico y mayor que cero">
 				</cfif>

 				<!--- para una compra de mayorista el valor de la parcialidad es 1 --->
 				<cfif arguments.Tipo_Transaccion eq This.C_TT_MAYORISTA  and trim(arguments.Parcialidades) gt 1>
 					<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "Para una compra de mayorista solo se permite una parcialidad">
 				</cfif>

	    		<!--- ticket obligatorio--->
	    		<!--- chequear que la informacion de cadenaEmpresa, sucursal y caja haya sido enviada--->	
				<cfif trim(arguments.Num_Ticket) eq "" >
					<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "El numero o codigo del ticket es obligatorio">
				</cfif>
 
				<!--- OBTENCION DE ID PARA TIPO DE TRANSACCION --->
				<cfquery name="q_TipoTransaccion" datasource="#This.DSN#">
					select id, TipoMov, Descripcion
					from   CRCTipoTransaccion
					where  Codigo = '#arguments.Tipo_Transaccion#'
					and    afectaCompras = 1
				</cfquery>	

				<cfif q_TipoTransaccion.recordcount eq 0>
					<cfthrow errorcode="#This.C_ERROR_TIPO_TRANSACCION#" type="TransaccionException" message = "Tipo de Transaccion [#trim(arguments.Tipo_Transaccion)#] No reconocida">
				</cfif>		

				<!--- chequear que la informacion de cadenaEmpresa, sucursal y caja haya sido enviada--->	
				<cfif 	trim(arguments.cadenaEmpresa) eq "" or trim(arguments.sucursal) eq "" or trim(arguments.caja) eq "">
					<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "Los datos de cadena empresa, sucursal y caja son obligatorios">
				</cfif>

				<!--- el codigo de la tienda no debe ser vacio--->	
				<cfif 	trim(arguments.Cod_Tienda) eq "" >
					<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "El codigo de la tienda no debe ser vacio">
				</cfif>


				<!--- actualizar la informacion enviada como parametro en correspondencia del tipo de transaccion--->
				<cfif arguments.Tipo_Transaccion eq This.C_TT_TARJETA or arguments.Tipo_Transaccion eq This.C_TT_MAYORISTA>
				
					<cfset arguments.Num_Folio  = ''>
					<cfset arguments.CodExtDist = ''> 
				
				<cfelseif arguments.Tipo_Transaccion eq This.C_TT_VALES>
					<!--- si es de vales chequear que el curp y el nombre del cliente tengan valores--->
					<cfif trim(arguments.Cliente) eq "" or trim(arguments.CURP) eq "">
						<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "Cuando la transaccion es de tipo vales, los campos de Cliente y CURP deben ser enviados">
					</cfif>
				</cfif> 

				<cfset CRCChequearProducto = createObject("component","crc.Componentes.compra.CRCChequearProducto")>
				<cfset CRCChequearProducto.init(this.dsn,this.ecodigo)>				
				<cfset arguments.Num_Tarjeta = replace(arguments.Num_Tarjeta," ","","all")>
				<cfset result = CRCChequearProducto.chequearProducto(
													Tipo_Transaccion = arguments.Tipo_Transaccion,
												  	Num_Tarjeta      = arguments.Num_Tarjeta,
												  	Num_Folio        = arguments.Num_Folio,
												  	Cod_Tienda       = arguments.Cod_ExtTienda,
												  	CodExtDist       = arguments.CodExtDist, 
												  	Monto            = arguments.Monto)>  	 
 
				<cfif result.codigo neq this.C_OK>
					<cfthrow errorcode="#result.codigo#" type="TransaccionException" message = "#result.mensaje#">
				</cfif>
  
				<!--- 1-la fecha de transaccion no puede ser menor que la fecha inicial del corte actual
				       ni mayor que la fecha actual 
				    2- la fecha de incio pago no puede ser menor que la fecha de transaccion --->

				<cfset loc.Fecha_Inicio_Pago = '' >
				<cfif arguments.Tipo_Transaccion eq This.C_TT_MAYORISTA>
					<cfset loc.Fecha_Inicio_Pago = #arguments.Fecha_Transaccion# >
				<cfelse>
					<cfif not isDefined('arguments.Fecha_Inicio_Pago')>
						<cfset loc.Fecha_Inicio_Pago = #arguments.Fecha_Transaccion# > 
					<cfelse>
						<cfset loc.Fecha_Inicio_Pago = #arguments.Fecha_Inicio_Pago# > 
					</cfif>
				</cfif>


 				<cfset fechasF = chequeoFechas(TipoTransaccion  = #arguments.Tipo_Transaccion#,
					 						    FechaTransaccion = #arguments.Fecha_Transaccion#, 
				 								FechaInicioPago  = #loc.Fecha_Inicio_Pago#)>	

 
				<cfset chequeoTicket(cadenaEmpresa = arguments.cadenaEmpresa,
									 sucursal 	   = arguments.sucursal,
									 caja          = arguments.caja,
									 parcialidades = arguments.Parcialidades,
									 ticket        = arguments.Num_Ticket,
									 FechaInicioPago  = fechasF.FechaInicioPago)>	


		  		<cfset rsCuenta = obtenerCuenta(Tipo_Transaccion=#arguments.Tipo_Transaccion#,
		  										CodExtDist=#arguments.CodExtDist#,
		  										Cod_Tienda=#arguments.Cod_ExtTienda#,
		  										Num_Folio=#arguments.Num_Folio#,
		  										Num_Tarjeta=#arguments.Num_Tarjeta#)>
		  
		   		<cfset idTransaccion = crearTransaccion(CuentaID = #rsCuenta.id#,
													    Tipo_TransaccionID = #q_TipoTransaccion.id#,
													    TarjetaID = #rsCuenta.TarjetaID#,
													    Num_Folio = #arguments.Num_Folio#,
														Fecha_Transaccion = #fechasF.FechaTransaccion#,
													    Cod_Tienda    = #arguments.Cod_Tienda#,
													    Num_Ticket    = #arguments.Num_Ticket#,
														Monto         = #arguments.Monto#,
													    Cliente       = #arguments.Cliente#,
													    Parcialidades = #arguments.Parcialidades#,
													    Fecha_Inicio_Pago = #fechasF.FechaInicioPago#,
													    Observaciones = #arguments.Observaciones#,
													    CURP          = #arguments.CURP#,
													    Descripcion   = #q_TipoTransaccion.Descripcion#,
													    cadenaEmpresa = #arguments.cadenaEmpresa#,
													    sucursal      = #arguments.sucursal#,
													    caja          = #arguments.caja#, 
													    Cod_ExtTienda    = #arguments.Cod_ExtTienda#
													    )> 
		 
				<!-- afectar al folio en el caso de compra por vales-->
				<!--- Si el folio es externo, agregarlo a la lista de cancelados --->
 				<!-- chequear si hay que devolver un contra valor o numero de folio nuevo -->
 				<cfif arguments.Tipo_Transaccion eq This.C_TT_VALES > 
					
					<cfset loc.ContraVale = afectarFolio(CuentaID=#rsCuenta.id#,
													Num_Folio=#arguments.Num_Folio#,
													CodExtDist=#arguments.CodExtDist#,
													Cod_Tienda=#arguments.Cod_ExtTienda#,
													Observaciones=#arguments.Observaciones#,
													GeneraContraVale=#arguments.GeneraContraVale#)>
					<cfquery name="rsContravale" datasource="#this.dsn#">
						select FechaExpiracion from CRCControlFolio where Numero = '#loc.ContraVale#'
					</cfquery>
					<cfset loc.FechaExpiracion = rsContravale.FechaExpiracion>
		 		</cfif>		 
 
		 		<cftransaction action="commit">

			 <cfcatch> 
				<cfrethrow>
		 		<cftransaction action="rollback"> 
		 		<cfreturn crearMensaje(cfcatch.errorcode, cfcatch.message)>
		 	</cfcatch>
		 	</cftry>

		</cftransaction>

		<cfset result = structNew()>

		<cfset result.codigo 	 = This.C_OK >
		<cfset result.mensaje 	 = "Operacion exitosa" >
		<cfif arguments.Tipo_Transaccion eq 'VC'>
			<cfset result.contraVale = #loc.ContraVale#>
			<cfset result.FechaExpiracion = #DateFormat(loc.FechaExpiracion,"yyyy/mm/dd")#>
		</cfif>
		<cfset result.ConsecutivoTransaccion = #idTransaccion#>
 
 		<cfreturn result>
 
 	</cffunction>

 
	<!---cffunction name="cMovCuenta" returntype="string" access="private" hint="crea los registros en la tabla de movimeintos">

		<cfargument name="TransaccionID"      required="yes"   type="numeric">
		<cfargument name="TipoMovimiento"	  required="yes"   type="string">
		<cfargument name="Fecha_Inicio_Pago"  required="yes"   type="date">
		<cfargument name="Parcialidades"  	  required="yes"   type="numeric">
		<cfargument name="Monto"  	  		  required="yes"   type="numeric">
 		<cfargument name="Observaciones"  	  required="yes"   type="string">
 		<cfargument name="SNid"  	  		  required="yes"   type="numeric">
 		<cfargument name="TipoProducto"       required="yes"   type="string">
 	

		<cfset CRCCorteFactory = createObject( "component","crc.Componentes.cortes.CRCCorteFactory")> 
		<cfset CRCorte = CRCCorteFactory.obtenerCorte(TipoProducto=#arguments.TipoProducto#,conexion=#This.DSN#, Ecodigo=#This.ECodigo#,  SNid=#arguments.SNid#)>

		<cfset cortes = CRCorte.GetCorteCodigos(fecha='#arguments.Fecha_Inicio_Pago#',parcialidades=#arguments.Parcialidades#)>

		<cfset montoParcialidades = #NumberFormat(arguments.Monto/arguments.Parcialidades, "00.00")#>
		<cfset cortesList = ListToArray(cortes,',',false,false)>

		<cfset MontoAPagar = 0>
		<cfset status      = #This.C_STATUS_ABIERTO#>
		<!-- en el caso de los mayorista el monto a pagar es igual al monto requerido-->
		<cfif arguments.TipoProducto eq This.C_TP_MAYORISTA>
			<cfset MontoAPagar = #arguments.Monto#>
		</cfif>

		<cfset insertScript = ''>
		<cfloop index='i' from='1' to='#arguments.Parcialidades#'>

			<cfset obsMsg = "(#i#/#arguments.Parcialidades#) #arguments.Observaciones#"> 
			<cfset insertScript = insertScript & insertScriptMovC(TransaccionID = #arguments.TransaccionID#,
												   TipoMovimiento = #arguments.TipoMovimiento#,
												   Corte          = #cortesList[i]#,
												   MontoRequerido = #montoParcialidades#,
												   MontoAPagar    = #MontoAPagar#,
												   Observaciones  = #obsMsg#)  & ";"> 
		</cfloop>	

		<cfset insertScript = replace(insertScript, "''","'") >
		
		<cfscript> 
			QueryExecute(insertScript,[],{datasource="#This.DSN#"}); 
 		</cfscript>
		
		<cfreturn cortes>		
	
	</cffunction ---> 
 

 	<cffunction name="chequeoFechas" access="private" hint="validación de fechas" returntype="struct">
 		<cfargument name="TipoTransaccion"  type="string"  required="true" hint="fecha inicio pago">
 		<cfargument name="FechaTransaccion" type="string"  required="true" hint="fecha inicio pago">
 		<cfargument name="FechaInicioPago"  type="string"  required="true" hint="fecha inicio pago">
			 
		<cfset fechaActual = now()>
	  
		<cfset FechaTransaccion = formatStringToDate(arguments.FechaTransaccion)>
		<cfset FechaInicioPago  = formatStringToDate(arguments.FechaInicioPago)>
 
		<cfif len(FechaTransaccion) eq 0 or len(FechaInicioPago) eq 0>
			<cfthrow errorcode="#This.C_ERROR_FECHA_TRANSACCION#" type="TransaccionException" message = "Error en el formato de fechas">
		</cfif>
	  
		<!-- 1- fecha de inicio de pago debe ser igual o mayor que la fecha de transaccion --> 
		<cfif FechaInicioPago lt  FechaTransaccion>
			<cfthrow errorcode="#This.C_ERROR_FECHA_TRANSACCION#" type="TransaccionException" message = "La fecha de inicio de pago debe ser igual o mayor que la fecha de transaccion">
		</cfif>
 
		<!--- 2-la fecha transaccion no debe ser menor que fecha actual. Si es menor que la fecha actual chequear
				el parametro de configuracion sobre la tolerancia por transacciones erroneas--->
		<cfif FechaTransaccion  lt fechaActual>
			<cfset paramInfo = crcParametros.GetParametroInfo(codigo='#This.C_PARAM_DIAS_TOLERANCIA#',conexion=#This.DSN#,ecodigo=#This.Ecodigo#,descripcion="Días de tolerancia por transacción atrasada")>
			<cfif paramInfo.valor eq "" >
				<cfthrow  type="CRCCortesTarjetaCreditoException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#">
			</cfif>	
			<cfset loc.diasTolerancia = paramInfo.valor>

			<cfset fechaTolerancia = DateAdd('d', -loc.diasTolerancia, Now())> 
			 
			<cfif  FechaTransaccion lt fechaTolerancia >
				<cfthrow errorcode="#This.C_ERROR_FECHA_TRANSACCION#" type="TransaccionException" message = "La fecha de transaccion es menor que la fecha actual y esta fuera del rango de tolerancia de #loc.diasTolerancia# dias">
			</cfif> 
 
			<cfset FechaTransaccion = fechaActual>
			<cfif  FechaTransaccion gt  FechaInicioPago>
				<cfset FechaInicioPago = fechaActual>
			</cfif>l
			
		</cfif>
  

		<!--- chequear que la de la transaccion no caiga en una en un corte que exista y no este abierto--->
		<cfquery name="qChequearPC" datasource="#this.dsn#">
			select   Tipo from CRCCortes 
			where  <cfqueryparam value ="#FechaInicioPago#" cfsqltype="cf_sql_date"> between FechaInicio and FechaFin
			and  Tipo = <cfqueryparam value ="#getTipoProductoPorTipoTran(arguments.TipoTransaccion)#" cfsqltype="cf_sql_varchar"> 
			and cerrado = 1  
		</cfquery>
 
		<cfif qChequearPC.recordcount gt 0 and trim(qChequearPC.Tipo) neq This.C_TT_MAYORISTA>
			<cfthrow errorcode="#This.C_ERROR_FECHA_TRANSACCION_CC#" type="TransaccionException" message = "La fecha de inicio de pago esta en un periodo o corte que ya fue cerrado">
		</cfif>
 
		<cfset dateSTruct = structNew()>
		<cfset dateSTruct.FechaTransaccion = FechaTransaccion>
		<cfset dateSTruct.FechaInicioPago  = FechaInicioPago>

		<cfreturn dateSTruct>

 	</cffunction>


 	<cffunction name="afectarFolio" access="private" returntype="string" hint="afectar el folio despues de ser usado. Genera contravale si se pide y se pone fecha de expiración del contravale"> 
 		<argument name="CuentaID" 	       type="numeric" required="true">
 		<argument name="Num_Folio"	       type="string" required="true">
 		<argument name="CodExtDist"        type="string" required="false" default=''>
 		<argument name="Cod_Tienda"        type="string" required="false" default=''>
 		<argument name="Observaciones" 	   type="string" required="false" default=''>
 		<argument name="GeneraContraVale"  type="string"  required="false" default=''>
 		
 		

 		<cfset loc.ContraVale = "">
 		<cfif arguments.CodExtDist neq '' and arguments.Cod_Tienda neq ''>
 
 			<cfquery name="qTiendaExt" datasource="#This.dsn#">

 				select id 
 				from CRCTiendaExterna
 				where Codigo = '#arguments.Cod_Tienda#' 

 			</cfquery>
             
 			<cfif qTiendaExt.recordCount gt 0>
 
 
 				<!--- insertar el folio como cancelado--->
				<cfquery   datasource="#This.dsn#">

					 insert into CRCValesExtCancelados
					(Folio,  
					CRCTiendaExternaid,
					FechaCancelado,
					Observaciones,
					Ecodigo,
					Estado,
					CRCCuentasid
					)
					values(
						'#arguments.Num_Folio#', 
				  		#qTiendaExt.id#, 
				  		#now()#,
				  		'#arguments.Observaciones#',
				  		#This.Ecodigo#,
						'#This.ESTADO_FOLIO_CONSUMIDO#',
						#arguments.CuentaID#
					)
  	
				</cfquery>

 			</cfif>

			
 		<cfelse>

 			
 			<!--- cancelar folio interno--->
 			<cfquery datasource="#This.DSN#">
 				update CRCControlFolio 
 				set Estado = '#This.C_ESTADO_FOLIO_CANCELADO#'
 				where CRCCuentasid = #rsCuenta.id#
 				and   Numero = #arguments.Num_Folio#
		 	</cfquery>

			<cfquery datasource="#This.DSN#" name="rsFolio">
 				select Lote, Numero from CRCControlFolio 
 				where CRCCuentasid = #rsCuenta.id#
 				and   Numero = #arguments.Num_Folio#
		 	</cfquery>
		 	
		 	<cfif  arguments.GeneraContraVale  eq '1'>
			 
		 		<!--- Se genera un contravale el código de contravale---->
				<cfif (left(rsFolio.Lote,2) neq 'IM' and mid(arguments.Num_Folio,5,1) eq '0') or left(rsFolio.Lote,2) eq 'IM'>
					<cfset folioTemp = arguments.Num_Folio>
					<cfif left(rsFolio.Lote,2) eq 'IM' >
						<cfset CRCFolios = createObject( "component","crc.Componentes.CRCFolios")>
						<cfset folioTemp = CRCFolios.CreaLote(Cuentaid=arguments.CuentaID,
																	CantidadFolios=1,
																	EstadoFolio="X",
																	dsn=#this.dsn#,
																	Ecodigo=#this.ecodigo#,
																	usucodigo=0
																).folioInicial>
					</cfif>
		 			<cfset loc.ContraVale = generarContraVale(Num_Folio=folioTemp,CRCCuentasid=arguments.CuentaID)> 
					
		 		</cfif>
			</cfif>

 		</cfif>
 		
 		<cfreturn loc.ContraVale>
 	</cffunction>


 	<cffunction name="generarContraVale" returntype="string" hint="Se genera un contravale el código de contravale. Se chequea que la cuenta permita general contravale">
 		<argument name="Num_Folio"		type="string" required="true">
 		<argument name="CRCCuentasid"	type="numeric" required="true">

 		<cfset loc.tipo = Mid(arguments.Num_Folio,5,1)>
 		<cfif loc.tipo neq 0>
 			<cfreturn "">
 		</cfif> 

 		<!--- se chequea si permite contravalor la cuenta de distribuidor---> 
		<cfquery datasource="#this.dsn#" name="rsParamPermiteCV">
			select PermiteContraValor
			from CRCTCParametros cp
			inner join SNegocios sn
			on cp.SNegociosSNid = sn.SNid
			inner join CRCCuentas c
			on  c.SNegociosSNid =  sn.SNid
			where  c.id = #arguments.CRCCuentasid#
			and    DMontoValeCredito is not null
	        and    DCreditoAbierto is not null
	        and    DSeguro 	is not null
		</cfquery> 		
  
 		<cfif rsParamPermiteCV.PermiteContraValor neq '1'>
 			<cfreturn "">
 		</cfif>
 
 		<cfset loc.CodigoContraVale = "">
		<cfquery name="qFolioLote" datasource="#This.DSN#">
			select Lote from CRCControlFolio where Numero = '#arguments.Num_Folio#'
		</cfquery>


		<cfif qFolioLote.recordcount gt 0>
 			
			<cfset loc.primero = Left(arguments.Num_Folio,4)>
			<cfset loc.segundo = Right(arguments.Num_Folio,4)>

			<cfset loc.CodigoContraVale = loc.primero & 1 & loc.segundo> 

			<!--- chequear que el contravale ya exista--->	
			<cfquery name="qFolioExiste" datasource="#This.DSN#">
				select Numero from CRCControlFolio where Numero = '#loc.CodigoContraVale#'
			</cfquery>

			<cfif qFolioExiste.recordcount gt 0 >
				<cfthrow errorcode="#This.C_ERROR_CONTRAVLE_EXISTENTE#"  type="CRCTransaccionException" message="El contravale que se quiere generar ya existe" >
			</cfif>

			<!--- calculando fecha de expiracion--->
			<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

			<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_DIAS_FECHA_EXPIRACION_CONTRAVALE#",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Cantidad de dias para calculo fecha expiracion de contravale" )> 
			<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_PARAM_DIAS_FECHA_EXPIRACION_CONTRAVALE#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#, consulte al administrador" >
			</cfif> 

			<cfset loc.currentDate     = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))> 
			<cfset loc.FechaExpiracion = dateadd('d',paramInfo.valor,loc.currentDate)>

			<cfquery datasource="#This.DSN#">
				INSERT INTO CRCControlFolio (CRCCuentasid,Lote,Numero,Estado,Ecodigo,createdat,FechaExpiracion)
				VALUES (#arguments.CRCCuentasid#,'#qFolioLote.Lote#','#loc.CodigoContraVale#','#This.C_ESTADO_FOLIO_ACTIVO#',#This.Ecodigo#,#now()#,#loc.FechaExpiracion#); 
	 		</cfquery>	
 
		</cfif> 
 		<cfreturn loc.CodigoContraVale>

 	</cffunction>



 	<cffunction name="reverso" access="public" returntype="struct" hint="procesa la accion de reverso, elimina una transaccion por los datos de la cadena, sucursal, caja y ticket "> 
   		<cfargument name="cadenaEmpresa" required="no"  type="string" default=""> 
   		<cfargument name="sucursal" 	 required="no"  type="string" default=""> 
   		<cfargument name="caja" 	     required="no"  type="string" default=""> 
   		<cfargument name="ticket" 	     required="no"  type="string" default=""> 
   		<cfargument name="token" 	     required="no"  type="string" default=""> 
   	
    	<cftransaction>	
    	<cftry>
	 		<cfset chequearToken(arguments.token)>

	 		<!--- los valores pasado como parametros no pueden ser vacios--->
	 		<cfif trim(arguments.cadenaEmpresa) eq "" or trim(arguments.sucursal) eq "" or
	 				trim(arguments.caja) eq "" or trim(arguments.ticket) eq "">

				<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "Los datos de cadena empresa, sucursal , caja  y ticket son obligatorios"> 
	 		</cfif>

	 		<!--- chequear que exista una transaccion realizada con cadena empresa, sucursal caja, ticket--->
	 		<cfquery name="qTransaccion" datasource="#This.dsn#">
	 			select id, TipoTransaccion, Folio
	 			from   CRCTransaccion
	 			where cadenaEmpresa = '#trim(arguments.cadenaEmpresa)#'
	 			and   sucursal = '#trim(arguments.sucursal)#'
	 			and   caja     = '#trim(arguments.caja)#'
	 			and   ticket   = '#trim(arguments.ticket)#' 
	 		</cfquery>

	 		<cfif qTransaccion.recordcount eq 0>
	 			<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "No se encontro informacion de transaccion dados los parametros enviados para el proceso de reverso">
	 		</cfif>

	 		<cfset loc.Folio = qTransaccion.Folio> 
	 		<cfset eliminarTransaccionCompra(transactionID = qTransaccion.id, 
	 										 cancelacion   = false)>

	 		<!--- si tiene folio, debe estar consumido, se activo. Si es un vale externo se quita de la lista
	 			de vales externos cancelados--->  
	 		<cfif loc.Folio neq ''>
		 		<cfquery datasource="#This.dsn#">
		 			update CRCControlFolio
		 			set Estado = 'A'
		 			where Numero = '#loc.Folio#'
		 		</cfquery>

		 		<!--- si es externo se elimina de la lista de folios externos cancelados--->
		 		<cfquery datasource="#this.dsn#">
		 			delete from CRCValesExtCancelados where Folio = '#loc.Folio#'
		 		</cfquery>
 
		 	</cfif>



	 	<cftransaction action="commit">

	 	<cfcatch>
	 		<cftransaction action="rollback">	 
	 		<cfreturn crearMensaje(cfcatch.errorcode, cfcatch.message)>
	 	</cfcatch>
	 	</cftry>			 	

 		<cfset result = structNew()> 
		<cfset result.codigo  		 = This.C_OK >
		<cfset result.folioActivado  = #qTransaccion.Folio# >
		<cfset result.mensaje 	     = "Operacion exitosa" > 
		<cfreturn #result#>

   	</cffunction>

 
 	<cffunction name="cancelacion" access="public" returntype="struct" hint="elimina una transaccion por el consecutivo o id de transaccion" >
   		<cfargument name="consecutivoTransaccion" required="no"  type="string" default="">  
   		<cfargument name="token"  				  required="no"  type="string" default=""> 
   	
     	<cftransaction>	
    	<cftry>  	
	   		<cfset chequearToken(arguments.token)>

	   		<cfif trim(arguments.consecutivoTransaccion) eq "" > 
				<cfthrow errorcode="#This.C_ERROR_DATOS_EMPRESA#" type="TransaccionException" message = "El valor de consecutivo de empresa no debe ser vacio"> 
	 		</cfif>

	 		<cfset loc.transactionID = LSParseNumber(arguments.consecutivoTransaccion) >
 
	 		<!--- en la cancelacion si la transacion fue con un vale se genera siempre un vale
	 			chequear eque le producto no sea un contravle --->
	 		<cfquery name="qTransaction" datasource="#this.dsn#">
		 		 select CRCCuentasid, Folio, TipoTransaccion from CRCTransaccion 
		 		 where id = #loc.transactionID# 
	 		</cfquery>

	 		<cfif qTransaction.recordcount eq 0>
				<cfthrow errorcode="#This.C_ERROR_ELIMINACION_TRANSACCION#" message="No existe una transaccion con el codigo:#arguments.consecutivoTransaccion#">
	 		</cfif>

			<cfset loc.contraVale = "">

		 	<cfif qTransaction.TipoTransaccion eq 'VC'> 
				<cfquery datasource="#This.DSN#" name="rsFolio">
					select Lote, Numero from CRCControlFolio 
					where CRCCuentasid = #qTransaction.CRCCuentasid#
					and   Numero = '#qTransaction.Folio#'
				</cfquery>
				<cfset CRCFolios = createObject( "component","crc.Componentes.CRCFolios")>
				<!--- Se genera un contravale el código de contravale---->
				<cfif (left(rsFolio.Lote,2) neq 'IM' and mid(qTransaction.Folio,5,1) eq '0') or left(rsFolio.Lote,2) eq 'IM'>
					<cfset loc.contraVale = CRCFolios.CreaLote(Cuentaid=LSParseNumber(qTransaction.CRCCuentasid),
																CantidadFolios=1,
																EstadoFolio="A",
																dsn=#this.dsn#,
																Ecodigo=#this.ecodigo#,
																usucodigo=0
															).folioInicial> 
				<cfelse>
					<cfset folioTemp = qTransaction.Folio>
					<cfif left(rsFolio.Lote,2) eq 'IM' or (left(rsFolio.Lote,2) neq 'IM' and mid(qTransaction.Folio,5,1) eq '1') >
						<cfset folioTemp = CRCFolios.CreaLote(Cuentaid=LSParseNumber(qTransaction.CRCCuentasid),
																	CantidadFolios=1,
																	EstadoFolio="X",
																	dsn=#this.dsn#,
																	Ecodigo=#this.ecodigo#,
																	usucodigo=0
																).folioInicial>
						<cfset loc.ContraVale = generarContraVale(Num_Folio=folioTemp,CRCCuentasid=qTransaction.CRCCuentasid)>
					</cfif>
				</cfif>
			</cfif>

			<cfset loc.registroCancelacionID =  eliminarTransaccionCompra(#loc.transactionID#)>
  
	 		<cftransaction action="commit">

	 	<cfcatch>
	 		<cftransaction action="rollback">	 
	 		<cfreturn crearMensaje(cfcatch.errorcode, cfcatch.message)>
	 	</cfcatch>
	 	</cftry>

 		<cfset result = structNew()> 
		<cfset result.contraVale    = #loc.contraVale# >
		<cfset result.codigo        = This.C_OK >
		<cfset result.mensaje 	    = "Operacion exitosa" > 
		<cfset result.transaccionID = "#loc.registroCancelacionID#" > 

		<cfreturn #result#>   		

   	</cffunction>   	



   	<cffunction name="chequeoTicket" access="private" returntype="void" hint="Chequea que la inforamcion de ticket sea unica">
   		<cfargument name="cadenaEmpresa" 	required="yes"  	type="string" default=""> 
   		<cfargument name="sucursal" 	 	required="yes"  	type="string" default=""> 
   		<cfargument name="caja" 	     	required="yes"  	type="string" default=""> 
   		<cfargument name="ticket"    	 	required="yes"  	type="string" default="">
		<cfargument name="parcialidades"    required="false"  	type="string" default="0"> 
		<cfargument name="FechaInicioPago"  required="false"  	type="date"   default="#now()#"> 

   		<cfquery name="qChequeoTicket" datasource="#This.dsn#">
   			select 1 from CRCTransaccion 
   			where Ticket        = '#arguments.ticket#'
			and   Parciales		= #arguments.parcialidades#
   			and   sucursal      = '#arguments.sucursal#'
   			and   caja          = '#arguments.caja#'
   			and   cadenaEmpresa = '#arguments.cadenaEmpresa#' 
   			and   FechaInicioPago = #arguments.FechaInicioPago#
   		</cfquery>

   		<cfif qChequeoTicket.recordcount gt 0>
   			<cfthrow errorcode="#This.ERROR_TICKET_REPETIDO#" message="El ticket: #arguments.ticket# ya se encuentra registrado para la cadena:#arguments.cadenaEmpresa# , sucursal:#arguments.sucursal#, caja: #arguments.caja#, parciales: #arguments.parcialidades# y Fecha de inicio de pago">
   		</cfif>

   	</cffunction>



</cfcomponent>