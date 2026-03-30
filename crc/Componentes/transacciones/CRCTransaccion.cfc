<cfcomponent output="false" displayname="CRCTransaccion" hint="Componente base para las transacciones">
 
	<!--- ERRORES ---> 
	<cfset This.C_ERROR_CUENTA_NO_ACTIVADA    = '00001'>
	<cfset This.C_ERROR_CONF_LIMITE_ESTADO_CA = '00002'>
 	<cfset This.C_ERROR_CONF_LIMITE_ESTADO_GI = '00003'>
	<cfset This.C_ERROR_FECHA_TRANSACCION	  = '00012'>
	<cfset This.C_ERROR_TIPO_TRANSACCION      = '00004'>
	<cfset This.C_ERROR_LIM_CAMBIO_ESTADO 			= '10008'>

 	<!--- ESTATUS DE MOVIMIENTO  CON RESPECTO AL CALCULO --->
 	<cfset This.C_STATUS_ABIERTO  = '0'>
 	<cfset This.C_STATUS_MP_CALC  = '1'>
  	<cfset This.C_STATUS_SV_CALC  = '2'> 
  	<cfset This.C_STATUS_CERRADO  = '3'> 	

	<!---PARAMETROS DE CONFIGURAION --->
	<cfset This.C_PARAM_LIMITE_ESTADO_CA = '30000708'> 
	 
	<!---TIPOS DE TRANSASCCIONES --->
	<cfset This.C_TT_VALES     = 'VC'>
	<cfset This.C_TT_MAYORISTA = 'TM'>
	<cfset This.C_TT_TARJETA   = 'TC'>
	<cfset This.C_TT_INTERESES = 'IN'>
	<cfset This.C_TT_SEGURO    = 'SG'>
	<cfset This.C_TT_SEGUROV   = 'SV'>

	<!--- TIPO DE PRODUCTOS--->
	<cfset This.C_TP_DISTRIBUIDOR = 'D'>
	<cfset This.C_TP_TARJETA      = 'TC'>
	<cfset This.C_TP_MAYORISTA    = 'TM'>

	<!--- TIPO DE MOVIMIENTOSS--->
	<cfset This.C_MOV_DEBITO = 'D'>
	<cfset This.CREDITO = 'C'>
  
	<cfset This.DSN     = ''>
	<cfset This.Ecodigo = ''> 

	<cfset This.crcLimEstadoCuentaActiva  =''>
	<cfset This.pLimiteCambioEstadoCuenta =''> 
	<!---cfset This.pestadoCuentaActiva       ='' ---> 

	<cfset This.C_PARAM_LIM_CAMBIO_ESTADO    = '30000710'>
	<!--- cfset This.C_PARAM_ESTADO_ACTIVO_CUENTA = '30000714' --->
   
	<cffunction name="init" access="public" output="no" returntype="CRCTransaccion" hint="constructor del componente con parametros de entradas primarios">  
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >
 
		<cfset This.DSN 	= arguments.DSN>
		<cfset This.Ecodigo = arguments.Ecodigo>

		<cfset initParametros()>

		<cfreturn this>

	</cffunction>


	<cffunction name="initParametros" returntype="void" access="private" hint="busca informacion de parametros referente a la cuenta">

		<!--parametros--> 
		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIMITE_ESTADO_CA#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Permitir generar operaciones hasta estado" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_CONF_LIMITE_ESTADO_CA#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
 		<cfset This.crcLimEstadoCuentaActiva = paramInfo.valor>


		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIM_CAMBIO_ESTADO#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Cambio autómatico hasta estado" )>
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_LIM_CAMBIO_ESTADO#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pLimiteCambioEstadoCuenta = paramInfo.valor>


		<!---cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_ESTADO_ACTIVO_CUENTA#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Estado Activo de una Cuenta" )>
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_LIM_CAMBIO_ESTADO#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pestadoCuentaActiva = paramInfo.valor --->

			

	</cffunction>


 	<cffunction name="validarCuenta" returntype="void" access="private" hint="valida  esta activa">
 		<cfargument name="orden" type="numeric" required="true" >

 		<!--parametros-->   
		<cfif orden gt This.crcLimEstadoCuentaActiva>
			<cfthrow errorcode="#This.C_ERROR_CUENTA_NO_ACTIVADA#" message="Cuenta no activada">
		</cfif> 
 	</cffunction>

 	
 
	<cffunction name="crearTransaccion" access="public" returntype="numeric" hint="crea un nuevo registro de transaccion">
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
		<cfargument name="AfectaMovCuenta" 	  required="no"  type="boolean" default="true">
		<cfargument name="cadenaEmpresa" 	  required="no"  type="string"  default="">
		<cfargument name="sucursal" 	      required="no"  type="string"  default="">
		<cfargument name="caja" 	  		  required="no"  type="string"  default="">
		<cfargument name="Descuento" 		  required="no"  type="numeric" default=0>
		<cfargument name="usarTagLastID" 	  required="no"  type="boolean" default=true>
		<cfargument name="MontoAPagar" 	  	  required="no"  type="numeric" default=0>
		<cfargument name="Cod_ExtTienda" 	  required="no"  type="string" default="">

		<cfquery name="rsTipoTransaccion" datasource="#This.DSN#">
			select Codigo as Tipo_Transaccion, Descripcion, TipoMov, afectaSaldo, afectaInteres, afectaCompras, afectaPagos, afectaCondonaciones,
				afectaGastoCobranza, afectaSeguro
			from CRCTipoTransaccion where id = #arguments.Tipo_TransaccionID#
		</cfquery>		
		<cfset estatusCliente = obtieneEstatusCliente(Arguments.CuentaID)>

		<cfif trim(arguments.Observaciones) eq "">
			<cfset arguments.Observaciones = rsTipoTransaccion.Descripcion>
		</cfif> 
 
		<cfquery name="q_Transaccion" datasource="#This.DSN#">
			insert into CRCTransaccion (
					CRCCuentasid,
					CRCTipoTransaccionid,
					TipoTransaccion,
					CRCTarjetaid,
					Folio,
					Fecha,
					Tienda,
					Ticket,
					Monto,
					Cliente,
					Parciales,
					FechaInicioPago,
					Observaciones,
					CURP,
					Ecodigo,
					Usucrea,
					Usumodif,
					createdat,
					TipoMov, 
					afectaSaldo, 
					afectaInteres, 
					afectaCompras, 
					afectaPagos, 
					afectaCondonaciones,
					afectaGastoCobranza,
					afectaSeguro,
					Descripcion,
					cadenaEmpresa,
					sucursal,
					caja,
					Descuento,
					TiendaExt,
					estatusCliente
			)values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CuentaID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Tipo_TransaccionID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTipoTransaccion.Tipo_Transaccion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TarjetaID#" null="#len(trim(arguments.TarjetaID)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#left(arguments.num_Folio,10)#">,
					#arguments.Fecha_Transaccion#,
					<cfqueryparam cfsqltype="cf_sql_varchar"     value="#left(arguments.Cod_Tienda,50)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"     value="#left(arguments.Num_Ticket,20)#">,
					ROUND(<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Monto#">,2),
					<cfqueryparam cfsqltype="cf_sql_varchar"     value="#left(arguments.Cliente,150)#">,
					<cfqueryparam cfsqltype="cf_sql_integer"     value="#arguments.Parcialidades#">,
					#arguments.Fecha_Inicio_Pago#,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#left(arguments.Observaciones,500)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#left(arguments.CURP,18)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#This.Ecodigo#">,	
					<cfqueryparam cfsqltype="cf_sql_numeric"  null="yes">,
					<cfqueryparam cfsqltype="cf_sql_numeric"  null="yes">,
					CURRENT_TIMESTAMP,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsTipoTransaccion.TipoMov#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaSaldo#" null="#len(trim(rsTipoTransaccion.afectaSaldo)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaInteres#" null="#len(trim(rsTipoTransaccion.afectaInteres)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaCompras#" null="#len(trim(rsTipoTransaccion.afectaCompras)) eq 0#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaPagos#" null="#len(trim(rsTipoTransaccion.afectaPagos)) eq 0#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaCondonaciones#" null="#len(trim(rsTipoTransaccion.afectaCondonaciones)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaGastoCobranza#" null="#len(trim(rsTipoTransaccion.afectaGastoCobranza)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTipoTransaccion.afectaSeguro#" null="#len(trim(rsTipoTransaccion.afectaSeguro)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.Descripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.cadenaEmpresa#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.sucursal#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.caja#">,
					ROUND(<cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Descuento#">,2),
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Cod_ExtTienda#" null="#len(trim(arguments.Cod_ExtTienda)) eq 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#estatusCliente#"> 

			) 
			<cf_dbidentity1 datasource="#This.DSN#">
		</cfquery> 	
 		<cf_dbidentity2 datasource="#This.DSN#" name="transacion">	

 		<cfset loct.idTransaccion = '' > 
 		<cfif arguments.usarTagLastID eq true> 

			<cfset loct.idTransaccion = transacion.identity>
			
		<cfelse>

			<cfquery name="lastID_inserted" datasource="#This.DSN#">
 				select IDENT_CURRENT( 'CRCTransaccion' ) as lastID
 			</cfquery>

 			<cfset loct.idTransaccion = lastID_inserted.lastID>

		</cfif>

		<cfif rsTipoTransaccion.TipoMov eq "C" and AfectaMovCuenta>
			
			<cfquery name="rsCuenta" datasource="#THIS.DSN#">
				select id, SNegociosSNid, Tipo as TipoProducto 
				from CRCCuentas where id = #arguments.CuentaID#
			</cfquery>

			<cfset cortes = cTranMovCuenta(TransaccionID= loct.idTransaccion ,
								TipoMovimiento    = rsTipoTransaccion.TipoMov ,
								Fecha_Inicio_Pago = arguments.Fecha_Inicio_Pago ,
								Parcialidades     = arguments.Parcialidades ,
								Monto             = arguments.Monto ,
								Observaciones     = arguments.Observaciones ,
								SNid              =  rsCuenta.SNegociosSNid ,
								TipoProducto      =  rsCuenta.TipoProducto,
								MontoAPagar       =  arguments.MontoAPagar)>
			
			<cfset caMccPorCorteCuenta(cortes= cortes ,CuentaID= rsCuenta.id )>
 

			<cfset afectarCuenta(Monto= arguments.Monto ,
									CuentaID              = rsCuenta.id ,
									CodigoTipoTransaccion = rsTipoTransaccion.Tipo_Transaccion ,
									TipoMovimiento        = rsTipoTransaccion.TipoMov )>
 		
		</cfif>
 		 
		<cfreturn  loct.idTransaccion >

	</cffunction> 

	<cffunction name="obtieneEstatusCliente" access="public" returntype="numeric" hint="Obtiene estatus del cliente">
		<cfargument name="CuentaID"  		  required="yes" type="numeric">
		<cfquery name="rsGetEstatus" datasource="#This.DSN#">
			select crc.CRCEstatusCuentasid from CRCCuentas crc
			where crc.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CuentaID#">
			and crc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#This.Ecodigo#">
		</cfquery>	
		<cfif rsGetEstatus.RecordCount eq 0>
			<cfthrow message="No se encontró la cuenta asociada a algún estatus">
		</cfif>
		<cfreturn rsGetEstatus.CRCEstatusCuentasid>
	</cffunction> 

	<cffunction name="cTranMovCuenta" returntype="string" access="private" hint="crea los registros en la tabla de movimeintos">

		<cfargument name="TransaccionID"      required="yes"   type="numeric">
		<cfargument name="TipoMovimiento"	  required="yes"   type="string">
		<cfargument name="Fecha_Inicio_Pago"  required="yes"   type="date">
		<cfargument name="Parcialidades"  	  required="yes"   type="numeric">
		<cfargument name="Monto"  	  		  required="yes"   type="numeric">
 		<cfargument name="Observaciones"  	  required="yes"   type="string">
 		<cfargument name="SNid"  	  		  required="yes"   type="numeric">
 		<cfargument name="TipoProducto"       required="yes"   type="string">
 		<cfargument name="MontoAPagar"        required="false" type="numeric">
 	

		<cfset CRCCorteFactory = createObject( "component","crc.Componentes.cortes.CRCCorteFactory")> 
		<cfset CRCorte = CRCCorteFactory.obtenerCorte(TipoProducto=#arguments.TipoProducto#,conexion=#This.DSN#, Ecodigo=#This.ECodigo#,  SNid=#arguments.SNid#)>
 		
 		<cfset cortes = CRCorte.GetCorteCodigos(fecha='#arguments.Fecha_Inicio_Pago#',parcialidades=#arguments.Parcialidades#, SNid=#arguments.SNid#)>
 
		<cfset montoParcialidades = #NumberFormat(arguments.Monto/arguments.Parcialidades, "00.00")#>
		<cfset loctran.cortesList = ListToArray(cortes,',',false,false)>
  
		<cfset mcclog.MontoAPagar = arguments.MontoAPagar>
		<cfset status      = #This.C_STATUS_ABIERTO#>
		<!-- en el caso de los mayorista el monto a pagar es igual al monto requerido-->
		<cfif arguments.TipoProducto eq This.C_TP_MAYORISTA>
			<cfset mcclog.MontoAPagar = #arguments.Monto#>
		</cfif>
 			 
		<cfset insertScript = ''>
		<cfset totalDesglose = 0.00>
		<cfloop index='i' from='1' to='#arguments.Parcialidades#'>
			<cfif arguments.Parcialidades gt 1>
				<cfset montoParcialidades = NumberFormat(Round(arguments.Monto/arguments.Parcialidades), "00.00")>
				<cfif i eq arguments.Parcialidades>
					<cfset diff = (arguments.Monto - totalDesglose)>
					<cfif diff gt 0>
						<cfset montoParcialidades = NumberFormat(arguments.Monto - totalDesglose, "00.00")>
					<cfelse>
						<cfset montoParcialidades = NumberFormat(totalDesglose - arguments.Monto, "00.00")>
					</cfif>
				</cfif>
				<cfset totalDesglose += montoParcialidades>
				
			</cfif>
			<cfset obsMsg = "(#i#/#arguments.Parcialidades#) #arguments.Observaciones#"> 
			<cfset insertScript = insertScript & insertScriptMovC(TransaccionID = #arguments.TransaccionID#,
												   TipoMovimiento = #arguments.TipoMovimiento#,
												   Corte          = #loctran.cortesList [i]#,
												   MontoRequerido = #montoParcialidades#,
												   MontoAPagar    = #mcclog.MontoAPagar#,
												   Observaciones  = #obsMsg#)  & ";"> 

		</cfloop>	
		
		<cfset insertScript = replace(insertScript, "''","'") >
		
		<cfscript> 
			QueryExecute(insertScript,[],{datasource="#This.DSN#"}); 
 		</cfscript>
	 
		<cfreturn cortes>		
	  
	</cffunction> 

	<cffunction name="insertScriptMovC" access="private" returntype="string" hint="crea un string de script de creacion para la tabla de movimiento cuenta">
		<cfargument name="TransaccionID"  required="yes" type="numeric">
		<cfargument name="TipoMovimiento" required="yes" type="string">
		<cfargument name="Corte" 	      required="yes" type="string">
		<cfargument name="MontoRequerido" required="yes" type="numeric">
		<cfargument name="Observaciones"  required="yes" type="string">
		<cfargument name="MontoAPagar"    required="no" type="numeric" default="0">
		<cfargument name="Intereses"    required="no" type="numeric" default="0">
		

		<cfset insertScript =
"insert into CRCMovimientoCuenta (
CRCTransaccionid,TipoMovimiento,Corte,MontoRequerido,MontoAPagar,Descuento,Pagado,Intereses
,SaldoVencido,Condonaciones,Descripcion,Ecodigo)
VALUES
(#arguments.TransaccionID#,'#trim(arguments.TipoMovimiento)#','#arguments.Corte#',#arguments.MontoRequerido#,ROUND( #arguments.MontoAPagar#,2)
,0,0,0,0,0,'#arguments.Observaciones#', #This.Ecodigo#)">

         <cfreturn #insertScript#>
	
	</cffunction>


	<cffunction name="caMccPorCorteCuenta" access="public" returntype="void" hint="actualiza o crea registros en la tabla mcc por cortes e id de cuenta. Se us en la compra">
		<cfargument name="cortes"   		   required="yes"   type="string">
		<cfargument name="CuentaID"		       required="yes"   type="numeric">
  

		<!-- actualiza los mivimiento cuenta cortes-->
		<cfquery name="q_UpdateMCC" datasource="#This.DSN#">
			update mcc set 
				MontoRequerido = round(t.MontoRequerido,2),
				    MontoAPagar    = round(t.MontoAPagar,2),
				    MontoPagado    = round(t.MontoPagado,2),
				    Intereses      = round(t.Intereses,2),
					Descuentos     = round(t.Descuentos,2), 
				    SaldoVencido   = ROUND(iif(t.MontoPagado > 0, t.SaldoVencido , t.SaldoVencido - mcc.MontoPagado) ,2),
				    Condonaciones  = round(t.Condonaciones,2),
					GastoCobranza = round(isnull(tGC.MontoGastoCobranza,0),2),
				    cerrado        = 1
			from CRCMovimientoCuentaCorte mcc
			inner join( 
					select  t.CRCCuentasid, 
							mc.Corte, 
							sum(mc.MontoRequerido) MontoRequerido,
							sum(mc.MontoAPagar) MontoAPagar,
							sum(mc.Intereses) Intereses,
							sum(mc.Descuento) Descuentos,
							sum(mc.Condonaciones) Condonaciones,
							sum(mc.Pagado) MontoPagado,
							sum(mc.SaldoVencido) SaldoVencido
					from CRCMovimientoCuenta mc
						inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
					where 
						t.CRCCuentasid = #CuentaID#
					and t.TipoTransaccion not in ('RP')
					and mc.Corte in (
									  <cfqueryparam value="#arguments.cortes#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> 
						            ) 
					and t.Ecodigo = #This.Ecodigo#
					group by t.CRCCuentasid, mc.Corte
			) t
			on mcc.CRCCuentasid = t.CRCCuentasid
			left join ( 
					select  t.CRCCuentasid, 
							mc.Corte, 
							isnull(sum(mc.MontoRequerido),0) MontoGastoCobranza
					from CRCMovimientoCuenta mc
						inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
					where 
						t.CRCCuentasid = #CuentaID#
					and mc.Corte in (
									  <cfqueryparam value="#arguments.cortes#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> 
						            ) 
					and t.afectaGastoCobranza = 1
					and t.Ecodigo = #This.Ecodigo#
					group by t.CRCCuentasid, mc.Corte
			)tGC on mcc.CRCCuentasid = tGC.CRCCuentasid
			where mcc.Corte = t.Corte
		</cfquery>	


		<!-- crea los movimientos cuenta cortes -->
		<cfquery name="q_CreateMCC" datasource="#This.DSN#">
			insert into  CRCMovimientoCuentaCorte(CRCCuentasid, Corte, MontoRequerido, MontoAPagar,Intereses,Descuentos,Condonaciones, MontoPagado,SaldoVencido, Seguro, FechaLimite,Ecodigo, cerrado,GastoCobranza)
			select  t.CRCCuentasid, 
				    mc.Corte, 
				    ROUND(sum(mc.MontoRequerido),2) MontoRequerido,
				    ROUND(sum(mc.MontoAPagar),2) MontoAPagar,
				    ROUND(sum(mc.Intereses),2) Intereses,
				    ROUND(sum(mc.Descuento),2) Descuentos,
				    ROUND(sum(mc.Condonaciones),2) Condonaciones,
				    ROUND(sum(mc.Pagado),2) MontoPagado,
				    ROUND(sum(mc.SaldoVencido),2) SaldoVencido,
				    0 as seguro,
				    CURRENT_TIMESTAMP,
				    t.Ecodigo,
				    0,
					round(isnull(sum(tGC.MontoGastoCobranza),0),2)
			from CRCMovimientoCuenta mc
			inner join CRCTransaccion t
			on t.id = mc.CRCTransaccionid and t.TipoTransaccion not in ('RP')
			left join ( 
					select  t.id, 
							mc.Corte, 
							isnull(sum(mc.MontoRequerido),0) MontoGastoCobranza
					from CRCMovimientoCuenta mc
						inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
					where 
						t.CRCCuentasid = #CuentaID#
					and mc.Corte in (
									  <cfqueryparam value="#arguments.cortes#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> 
						            ) 
					and t.afectaGastoCobranza = 1
					and t.Ecodigo = #This.Ecodigo#
					group by t.id, mc.Corte
			)tGC on t.id = tGC.id
			where t.CRCCuentasid = #CuentaID#
			and mc.Corte in ( 
							  <cfqueryparam value="#arguments.cortes#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> 
				            )

			and   not exists (select corte 
				                     from CRCMovimientoCuentaCorte mcc
				                     where mcc.CRCCuentasid = #CuentaID#
				                     and   mcc.Corte = mc.Corte
				                     and   mcc.Ecodigo = #This.Ecodigo#
				                     ) 
			and t.Ecodigo = #This.Ecodigo#
			group by t.Ecodigo, t.CRCCuentasid, mc.Corte
	 
		</cfquery>	
 
	</cffunction>


	<cffunction name="CrearActualizarMccPorCortes" access="private" returntype="void" hint="actualiza o crea registros en la tabla mcc por cortes e id de cuenta. Se us en la compra">
		<cfargument name="cortes"    required="yes"   type="string">
		<cfargument name="cuentaID"  required="false" type="string"  default=""> 
		<cfargument name="anterior"  required="false" type="boolean" default="false"> 

		<!-- actualiza los mivimiento cuenta cortes-->
		<cfquery name="q_UpdateMCC" datasource="#This.DSN#">
			update mcc
				set MontoRequerido = round(t.MontoRequerido,2),
				    MontoAPagar    = round(t.MontoAPagar,2),
				    MontoPagado    = round(t.MontoPagado,2),
				    Intereses      = round(t.Intereses,2),
					Descuentos     = round(t.Descuentos,2), 
				    SaldoVencido   = ROUND(iif(t.MontoPagado > 0, t.SaldoVencido , t.SaldoVencido - mcc.MontoPagado) ,2),
				    Condonaciones  = round(t.Condonaciones,2),
				    cerrado        = 1
			from CRCMovimientoCuentaCorte mcc
			inner join( 
					select  t.CRCCuentasid, 
							mc.Corte, 
							sum(mc.MontoRequerido) MontoRequerido,
							sum(mc.MontoAPagar) MontoAPagar,
							sum(mc.Intereses) Intereses,
							sum(mc.Descuento) Descuentos,
							sum(mc.Condonaciones) Condonaciones,
							sum(mc.Pagado) MontoPagado,
							sum(mc.SaldoVencido) SaldoVencido
					from CRCMovimientoCuenta mc
						inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
					where   mc.Corte in (
									  <cfqueryparam value="#arguments.cortes#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> 
						            ) 
					<cfif #arguments.cuentaID# neq "">
						and t.CRCCuentasid = #arguments.cuentaID#
					</cfif> 
					and t.Ecodigo = #This.Ecodigo#
					and t.TipoTransaccion not in ('RP')
					group by t.CRCCuentasid, mc.Corte
			) t
			on mcc.CRCCuentasid = t.CRCCuentasid
			where mcc.Corte = t.Corte
		</cfquery>	


		<!-- crea los movimientos cuenta cortes -->
		<cfquery name="q_CreateMCC" datasource="#This.DSN#">
			insert into  CRCMovimientoCuentaCorte(CRCCuentasid, Corte, MontoRequerido, MontoAPagar,Intereses,Descuentos,Condonaciones, MontoPagado,SaldoVencido, Seguro, FechaLimite,Ecodigo, cerrado)
			select  t.CRCCuentasid, 
				    mc.Corte, 
				    ROUND(sum(mc.MontoRequerido),2) MontoRequerido,
				    ROUND(sum(mc.MontoAPagar),2) MontoAPagar,
				    ROUND(sum(mc.Intereses),2) Intereses,
				    ROUND(sum(mc.Descuento),2) Descuentos,
				    ROUND(sum(mc.Condonaciones),2) Condonaciones,
				    ROUND(sum(mc.Pagado),2) MontoPagado,
				    ROUND(sum(mc.SaldoVencido),2) SaldoVencido,
				    0 as seguro,
				    CURRENT_TIMESTAMP,
				    t.Ecodigo,
				    0
			from CRCMovimientoCuenta mc
			inner join CRCTransaccion t
			on t.id = mc.CRCTransaccionid
			where mc.Corte in ( 
							  <cfqueryparam value="#arguments.cortes#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> 
				            )

			and   not exists (select corte 
				                     from CRCMovimientoCuentaCorte mcc
				                     where   mcc.Corte = mc.Corte
				                     and   mcc.Ecodigo = #This.Ecodigo#
				                     <cfif #arguments.cuentaID# neq "">
										and t.CRCCuentasid = #arguments.cuentaID#
									</cfif> 
				                     ) 
			and t.Ecodigo = #This.Ecodigo#
			and t.TipoTransaccion not in ('RP')
			<cfif #arguments.cuentaID# neq "">
				and t.CRCCuentasid = #arguments.cuentaID#
			</cfif> 
			group by t.Ecodigo, t.CRCCuentasid, mc.Corte
	 
		</cfquery>	

</cffunction>

<!---	<cffunction name="CrearActualizarMccPorCortes" access="private" returntype="void" hint="actualiza o crea registros en la tabla mcc por cortes e id de cuenta. Se us en la compra">
		<cfargument name="cortes"     required="yes"    type="string"> 
		<cfargument name="cuentaID"   required="false"  type="string" default=""> 
 		<cfargument name="anterior"   required="false"  type="boolean" default="false"> 

		<!-- actualiza los mivimiento cuenta cortes-->
		<cfquery name="q_UpdateMCC" datasource="#This.DSN#">
			update mcc
				set  MontoRequerido = ROUND(t.MontoRequerido,2),
				<cfif arguments.anterior eq false>
				    MontoAPagar    = ROUND(mcc.MontoRequerido + isnull(tAnt.SaldoVencido,0) + isnull(tAnt.Intereses,0),2), 
				</cfif>
				    MontoPagado    = round(iif(t.MontoPagado > 0, t.MontoPagado + mcc.Seguro, t.MontoPagado),2),
				    <cfif arguments.anterior eq true>
				    Intereses      = case when (t.Intereses > 0)
				                     then 
										CASE t.Tipo
										WHEN '#This.C_TP_DISTRIBUIDOR#' 
												THEN round((t.MontoAPagar - t.MontoPagado - t.Descuentos - t.Condonaciones)
													* (#This.pPorcInteresDistribuidor/100#),2)

										WHEN '#This.C_TP_MAYORISTA#'    
												THEN round((t.MontoAPagar - t.MontoPagado - t.Descuentos - t.Condonaciones)
													 * (#This.pPorcInteresMayorista/100#),2)
										WHEN '#This.C_TP_TARJETA#'      
										THEN  
											iif(t.MontoPagado >= isnull((select top 1 iif(pm.Porciento=1, 
																					  t.MontoAPagar * pm.MontoPagoMin/100,
																					  pm.MontoPagoMin ) as PagoMinimo
																				from CRCPagoMinimo  pm
																				where (pm.SaldoMax > 0 and (t.MontoAPagar- t.MontoPagado)
																					 between pm.SaldoMin and pm.SaldoMax)
																				or    (pm.SaldoMax = 0 and (t.MontoAPagar- t.MontoPagado)>=pm.SaldoMin))
																			   ,0)
												,round((t.MontoAPagar + mcc.Seguro - t.MontoPagado - t.Descuentos - t.Condonaciones) * #This.pPorcInteresPagoMinimo/100#,2)
												,round((t.MontoAPagar + mcc.Seguro - t.MontoPagado - t.Descuentos - t.Condonaciones) * #This.pPorcInteresSinPagoMinimo/100#,2)
											)
										 ELSE 
										 0
										 END
									else 
										0
									end   
				    ,
				    </cfif>
				    SaldoVencido   = ROUND(iif(t.MontoPagado > 0, t.SaldoVencido , t.SaldoVencido - mcc.MontoPagado) ,2),
				    Condonaciones  = ROUND(t.Condonaciones,2),
					GastoCobranza  = ROUND(isnull(tGasto.MontoRequerido,0),2)
			from CRCMovimientoCuentaCorte mcc
			inner join( 
					select  t.CRCCuentasid, mc.Corte, c.Tipo,
							sum(mc.MontoRequerido) MontoRequerido,
							sum(mc.MontoAPagar) MontoAPagar,
							sum(mc.Intereses) Intereses,
							sum(mc.Descuento) Descuentos,
							sum(mc.Condonaciones) Condonaciones,
							sum(mc.Pagado) MontoPagado,
							sum(mc.SaldoVencido) SaldoVencido
					from CRCMovimientoCuenta mc
						inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
						inner join CRCCuentas c
						on c.id = t.CRCCuentasid
					where 
						mc.Corte in (
									  <cfqueryparam value="#arguments.cortes#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> 
						            ) 
					and t.Ecodigo = #This.Ecodigo#
					<cfif #arguments.cuentaID# neq "">
						and t.CRCCuentasid = #arguments.cuentaID#
					</cfif>
					group by t.CRCCuentasid, mc.Corte, c.Tipo
			) t
			on mcc.CRCCuentasid = t.CRCCuentasid
			left join( 
					select  t.CRCCuentasid, mc.Corte, c.Tipo,
							isnull(sum(mc.MontoRequerido),0) MontoRequerido
					from CRCMovimientoCuenta mc
					inner join CRCTransaccion t
						on t.id = mc.CRCTransaccionid
					inner join CRCCuentas c
						on c.id = t.CRCCuentasid
					where 
						mc.Corte in (
									  <cfqueryparam value="#arguments.cortes#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> 
						            ) 
						and t.Ecodigo = #This.Ecodigo#
						and t.afectaGastoCobranza = 1
						<cfif #arguments.cuentaID# neq "">
							and t.CRCCuentasid = #arguments.cuentaID#
						</cfif>
					group by t.CRCCuentasid, mc.Corte, c.Tipo
			) tGasto
			on mcc.CRCCuentasid = tGasto.CRCCuentasid
			left join ( select mccA.CRCCuentasid, mccA.SaldoVencido, mccA.Intereses
			             from  CRCMovimientoCuentaCorte mccA
			             where mccA.Corte in (select Codigo 
			             	             from CRCCortes 
			             	             where status = 2 )
			             )tAnt
			on  mcc.CRCCuentasid = tAnt.CRCCuentasid
			where mcc.Corte = t.Corte
			<cfif #arguments.cuentaID# neq "">
				and t.CRCCuentasid = #arguments.cuentaID#
			</cfif>
		</cfquery>	
 
		<!-- crea los movimientos cuenta cortes -->
		<cfquery name="q_CreateMCC" datasource="#This.DSN#">
			insert into  CRCMovimientoCuentaCorte(CRCCuentasid, Corte, MontoRequerido, MontoAPagar,Intereses,Descuentos,Condonaciones, MontoPagado,SaldoVencido, Seguro, FechaLimite,Ecodigo)
			select  t.CRCCuentasid, 
				    mc.Corte, 
				    ROUND(sum(mc.MontoRequerido),2) MontoRequerido,
				    ROUND(sum(mc.MontoAPagar),2) MontoAPagar,
				    ROUND(sum(mc.Intereses),2) Intereses,
				    ROUND(sum(mc.Descuento),2) Descuentos,
				    ROUND(sum(mc.Condonaciones),2) Condonaciones,
				    ROUND(sum(mc.Pagado),2) MontoPagado,
				    ROUND(sum(mc.SaldoVencido),2) SaldoVencido,
				    0 as seguro,
				    CURRENT_TIMESTAMP,
				    t.Ecodigo
			from CRCMovimientoCuenta mc
			inner join CRCTransaccion t
			on t.id = mc.CRCTransaccionid
			where  mc.Corte in ( 
							  <cfqueryparam value="#arguments.cortes#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> 
				            )

			and   not exists (select corte 
				                     from CRCMovimientoCuentaCorte mcc
				                     where  mcc.Corte = mc.Corte
				                     and   mcc.Ecodigo = #This.Ecodigo#
				                     ) 
			and t.Ecodigo = #This.Ecodigo#
			<cfif #arguments.cuentaID# neq "">
				and t.CRCCuentasid = #arguments.cuentaID#
			</cfif>
			group by t.Ecodigo, t.CRCCuentasid, mc.Corte
	 
		</cfquery>	
 
	</cffunction>

--->

	<cffunction name="afectarCuenta" access="public" hint="funcion para afectar la cuenta">

		<cfargument name="CuentaID" 				required="yes" 		type="numeric">
		<cfargument name="Monto" 					required="yes" 		type="numeric">
		<cfargument name="CodigoTipoTransaccion" 	required="yes" 		type="string"> 
		<cfargument name="TipoMovimiento" 			required="false" 	type="string" default="C" hint="C=Credito, D= Debito"> 
 
		<cfset lvarSigno = IIf(arguments.TipoMovimiento eq "C", -1, 1)>
		<cfset lvarMonto = arguments.Monto >

		<cfquery name="q_TipoTransaccion" datasource="#This.DSN#">
			select
				afectaSaldo,
				afectaInteres,
				afectaCompras,
				afectaPagos,
				afectaCondonaciones,
				afectaGastoCobranza,
				afectaSeguro
			from CRCTipoTransaccion
			where
				Ecodigo = '#This.Ecodigo#'
				and Codigo = '#arguments.CodigoTipoTransaccion#'
				;
		</cfquery>

		<cfif q_TipoTransaccion.recordcount ge 1>
			<cfset q_TipoTransaccion = QueryGetRow(q_TipoTransaccion, 1)>
		<cfelse>
			<cfthrow type="TransaccionException" message = "No se encontro codigo de tipo de transaccion [#arguments.CodigoTipoTransaccion#]">
		</cfif>
		<cfset afectaA = ''>
		<cfif q_TipoTransaccion.afectaSaldo eq 1>
			<cfset afectaA = 'SaldoActual'>
		<cfelseif q_TipoTransaccion.afectaInteres eq 1>
			<cfset afectaA = 'Interes'>
		<cfelseif q_TipoTransaccion.afectaCompras eq 1>
			<cfset afectaA = 'Compras'>
			<!--- si afecta compra tambien afecta el saldo actual --->
<!--- 			<cfset afectarSoloSAldo(CuentaID=arguments.CuentaID)> --->

			<cfquery name="q_Afectacion" datasource="#This.DSN#">
				update CRCCuentas set SaldoActual = round(ISNull(SaldoActual,0 ) + #lvarMonto#,2) where id = #arguments.CuentaID#;
			</cfquery>
			
		<cfelseif q_TipoTransaccion.afectaPagos eq 1>
			<cfset afectaA = 'Pagos'>
			<!--- cuando afecta pago se multiplica por el signo, ya este concepto se puede reversar --->
			<cfset lvarMonto = lvarMonto * lvarSigno>
		<cfelseif q_TipoTransaccion.afectaCondonaciones eq 1>
			<cfset afectaA = 'Condonaciones'>
		<cfelseif q_TipoTransaccion.afectaGastoCobranza eq 1>
			<cfset afectaA = 'GastoCobranza'> 
		<cfelseif q_TipoTransaccion.afectaSeguro eq 1>
			<cfset afectaA = 'SaldoActual'>
		</cfif>

		<cfif afectaA neq ''>
			<cfif afectaA eq 'SaldoActual'>
				<cfquery name="q_Afectacion" datasource="#This.DSN#">
					update CRCCuentas 
						set SaldoActual = round(ISNull(SaldoActual,0 )+#lvarMonto#,2) where id = #arguments.CuentaID#;
				</cfquery>
<!--- 				<cfset afectarSoloSAldo(CuentaID=arguments.CuentaID)> --->
			<cfelse>
				<cfquery name="q_Afectacion" datasource="#This.DSN#">
					update CRCCuentas 
						set #afectaA# = case when round(ISNull(#afectaA#,0 )+#lvarMonto#,2) >= 0 
											then round(ISNull(#afectaA#,0 )+#lvarMonto#,2)
											else 0
										end 
					where id = #arguments.CuentaID#;
				</cfquery>
			</cfif>
		</cfif>

		<!--- Actualiza SaldoActual de la Cuenta por transacciones --->
		<cfquery datasource="#This.DSN#">
			
			update c
			set
				c.SaldoActual = case when ct.Monto < 0 then 0 else ct.Monto end <!--- ,
				c.saldoAFavor = case when ct.Monto < 0 then ct.Monto * -1 else 0 end --->
			from CRCCuentas c
			inner join (
				select 
				c.id, 
					sum(isnull(
								case t.TipoMov when 'D' then t.Monto * -1 else t.Monto end
								,0)) Monto
				from CRCTransaccion t
				inner join CRCCuentas c
					on t.CRCCuentasid = c.id
				where c.id = #arguments.CuentaID#
				group by c.id
			) ct
				on c.id = ct.id
		</cfquery>
		
	</cffunction>	

	<cffunction name="afectarSoloSAldo" hint="afectar solo el saldo actual para cualquier operacion que lo requiera">
		<cfargument name="CuentaID" required="yes" type="numeric">

		<cfquery name="rActCuentaSA" datasource="#This.dsn#">
		 	update c set c.SaldoActual = i.MOntoM	 		
			from CRCCuentas c
			inner join SNegocios sn on c.SNegociosSNid = sn.SNid
			inner join (select sum(Monto*case when TipoMov = 'D' then -1 else 1 end) as MOntoM, t.CRCCuentasid from CRCTransaccion t group by t.CRCCuentasid) i
				on i.CRCCuentasid = c.id
			where  c.id = #arguments.CuentaID#
		</cfquery>

	</cffunction>



 	<cffunction name="crearScriptTransacccion" access="private" returntype="string" hint="crea un string con el script de creacion de transacción"> 
		<cfargument name="CuentaID"  		   required="yes" type="numeric">
		<cfargument name="Tipo_TransaccionID"  required="yes" type="numeric"> 
		<cfargument name="Tipo_Transaccion"    required="yes" type="string" hint="codigo de la transaccion"> 
		<cfargument name="Tipo_Movimiento"     required="yes" type="string"> 
		<cfargument name="Fecha_Transaccion"   required="yes" type="date">
		<cfargument name="Monto" 		       required="yes" type="numeric">
		<cfargument name="TarjetaID"  		   required="no"  type="string" 	default="">
		<cfargument name="Num_Folio" 		   required="no"  type="string" 	default="">
		<cfargument name="Cod_Tienda" 		   required="no"  type="string" 	default="">
		<cfargument name="Num_Ticket" 		   required="no"  type="string" 	default="">
		<cfargument name="Cliente" 			   required="no"  type="string" 	default="">
		<cfargument name="Parcialidades"  	   required="no"  type="numeric"    default="1">
		<cfargument name="Fecha_Inicio_Pago"   required="no"  type="date" 	    default="#arguments.Fecha_Transaccion#">
		<cfargument name="Observaciones"       required="no"  type="string" 	default=""> 
		<cfargument name="CURP" 			   required="no"  type="string" 	default="">
		<cfargument name="afectaSaldo" 		   required="no"  type="numeric" 	default="0">
		<cfargument name="afectaInteres" 	   required="no"  type="numeric" 	default="0">
		<cfargument name="afectaCompras" 	   required="no"  type="numeric" 	default="0">
		<cfargument name="afectaPagos" 		   required="no"  type="numeric" 	default="0">
		<cfargument name="afectaCondonaciones" required="no"  type="numeric" 	default="0">
		<cfargument name="afectaGastoCobranza" required="no"  type="numeric" 	default="0">
		<cfargument name="Corte" 			   required="no"  type="string" 	default="">
 			
 			<cfif len(arguments.TarjetaID) eq 0>
 				<cfset arguments.TarjetaID = "null">
 			</cfif>
			<cfset sqlTran = "insert into CRCTransaccion (
								CRCCuentasid,
								CRCTipoTransaccionid,
								TipoTransaccion,
								CRCTarjetaid,
								Folio,
								Fecha,
								Tienda,
								Ticket,
								Monto,
								Cliente,
								Parciales,
								FechaInicioPago,
								Observaciones,
								CURP,
								Ecodigo,
								Usucrea,
								Usumodif,
								createdat,
								TipoMov, 
								afectaSaldo, 
								afectaInteres, 
								afectaCompras, 
								afectaPagos, 
								afectaCondonaciones,
								afectaGastoCobranza,
								Corte
						)values (
							#arguments.CuentaID#,
							#arguments.Tipo_TransaccionID#,
							'#arguments.Tipo_Transaccion#',
							#arguments.TarjetaID#,
							'#arguments.Num_Folio#',
							#now()#,
							'#arguments.Cod_Tienda#',
							'#arguments.Num_Ticket#',
							ROUND(#arguments.Monto#,2),
							'#arguments.Cliente#',
							#arguments.Parcialidades#,
							#arguments.Fecha_Inicio_Pago#,
							'#arguments.Observaciones#',
							'#arguments.CURP#',
							#This.Ecodigo#,
							null,
							null,
							#now()#, 
							'#arguments.Tipo_Movimiento#',
							#arguments.afectaSaldo#,
							#arguments.afectaInteres#,
							#arguments.afectaCompras#,
							#arguments.afectaPagos#,
							#arguments.afectaCondonaciones#,
							#arguments.afectaGastoCobranza#,
							'#arguments.Corte#'
							)
						">	
           
			<cfreturn sqlTran>

 	</cffunction>	


 	<cffunction name="creaMovimientoCuentaCorte" access="private" hint="crea un string con el script de creacion de movimiento cuenta corte" >
 		<cfargument name="CRCCuentasid" 	type="numeric"    required="true">
 		<cfargument name="Corte" 	   		type="string"     required="true">
 		<cfargument name="FechaLimite"  	type="date"       required="true">
 		<cfargument name="MontoRequerido"   type="numeric"    required="true">
 		<cfargument name="MontoAPagar"   	type="numeric"    required="false"	default="0">
 		<cfargument name="Intereses"   		type="numeric"    required="false"  default="0">
 		<cfargument name="Descuentos"   	type="numeric"    required="false"  default="0">
 		<cfargument name="Condonaciones"    type="numeric"    required="false"  default="0">
 		<cfargument name="Seguro"   	    type="numeric"    required="false"  default="0">
 		<cfargument name="MontoPagado"      type="numeric"    required="false"  default="0">
 		<cfargument name="SaldoVencido"     type="numeric"    required="false"  default="0">
 		<cfargument name="cerrado"          type="numeric"    required="false"  default="0">
 
 		<cfset sqlTran = "INSERT INTO CRCMovimientoCuentaCorte(
 							CRCCuentasid,
 							Corte,
 							FechaLimite,
 							MontoRequerido,
 							MontoAPagar,
 							Intereses,
 							Descuentos,
 							Condonaciones,
 							Seguro,
 							MontoPagado,
 							Ecodigo,
 							Usucrea,
 							Usumodif,
 							createdat,
 							updatedat,
 							deletedat,
 							cerrado,
 							SaldoVencido
 							)VALUES(
 								#arguments.CRCCuentasid#,
 								'#arguments.Corte#',
 								#arguments.FechaLimite#,
 								ROUND(#arguments.MontoRequerido#,2),
 								ROUND(#arguments.MontoAPagar#,2),
 								ROUND(#arguments.Intereses#,2),
 								ROUND(#arguments.Descuentos#,2),
 								ROUND(#arguments.Condonaciones#,2),
 								ROUND(#arguments.Seguro#,2),
 								ROUND(#arguments.MontoPagado#,2),
 								#This.Ecodigo#,
 								null,
 								null,
 								null, 
 								null,
 								null, 
 								#arguments.cerrado#, 
 								ROUND(#arguments.SaldoVencido#,2)
 							)">

 
 		<cfreturn sqlTran>
 	</cffunction>

 
	 <cffunction name="formatStringToDate"  returntype="date" access="public" hint="espera un string tipo dd/mm/yyyy y lo convierte a fecha">
		<cfargument name="fecha" type="string" required="true">
  
		<!---cfset regex = '([0-9]{2})\\([0-9]{2})\\([0-9]{4})' --->
		<!---cfset regex = '(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)[0-9]{2}' --->
		<!--- cfset MatchedDate = REMatchNoCase(regex, arguments.fecha) --->

 		<cfset loc.dateFormatted = ''>
	  	<cfset dateSplit = listToArray(arguments.fecha,"/")>   
		<cfif Arraylen(dateSplit) eq 3 
					and (len(dateSplit[1]) eq 2 and IsNumeric(dateSplit[1]) and LSParseNumber(dateSplit[1]) le 32) 
					and (len(dateSplit[2]) eq 2 and IsNumeric(dateSplit[2]) and LSParseNumber(dateSplit[2]) le 13)
					and (len(dateSplit[3]) eq 4 and IsNumeric(dateSplit[3]))
						  >
 		
			<cfset loc.dateFormatted = createDate(LSParseNumber(Mid(arguments.fecha,7,4))   ,LSParseNumber(Mid(arguments.fecha,4,2)),LSParseNumber(Mid(arguments.fecha,1,2)))>

 			<cfreturn loc.dateFormatted>

		<cfelse>
			<cfthrow errorcode="#This.C_ERROR_FECHA_TRANSACCION#" type="TransaccionException" message = "Error en el formato de fechas">
	    </cfif>
	      
	</cffunction>
    
 
</cfcomponent>