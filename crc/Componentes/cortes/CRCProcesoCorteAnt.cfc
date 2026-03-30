  <cfcomponent displayname="CRCProcesoCorte" extends="crc.Componentes.transacciones.CRCTransaccion">
   
	<cfset devFileName = "cortes_dev_environment">
	

  	<!---PARAMETROS DE CONFIGURAION --->
  	<cfset This.C_PARAM_LIM_EST_GENERA_INT = '30100901'> 
  	<cfset This.C_PARAM_PORC_INT_TM   	   = '30000702'> 
  	<cfset This.C_PARAM_PORC_INT_D    	   = '30000701'>
  	<cfset This.C_PARAM_PORC_INT_TC_PM 	   = '30000703'>	
  	<cfset This.C_PARAM_PORC_INT_TC_SPM    = '30000704'>
  	<cfset This.C_PARAM_LIM_ESTADO_CUENTA_PROM = '30000705'>
  	

  	<cfset This.C_PARAM_APLICAR_GCA 		    = '30000715'>
  	<cfset This.C_PARAM_CANT_CORTES_APLICAR_GCA = '30000716'>
  	<cfset This.C_PARAM_VALOR_GCA  				= '30000717'>

  	 
  	<cfset This.C_PARAM_DIA_SEGURO_MAYORISTA    = '30000706'>
  	<cfset This.C_PARAM_MONTO_SEGURO_VIDA       = '30000721'>
  	<cfset This.C_PARAM_ROL_ADM_CREDITO         = '30200711'>
  
  	<cfset This.C_ERROR_CONF_PORC_INT_MAYORISTA     = '10001'>
  	<cfset This.C_ERROR_PORCIENTO_PAGO_MIN          = '10002'>
  	<cfset This.C_ERROR_PORCIENTO_SIN_PAGO_MIN      = '10003'>
  	<cfset This.C_ERROR_CORTE_NO_ENCONTRADO         = '10004'>
  	<cfset This.C_ERROR_CORTES_CERRAR_NO_ENCONTRADO = '10005'>
  	<cfset This.C_ERROR_LIM_ESTADO_CUENTA_PROM 	    = '10006'>

  	<cfset This.C_ERROR_GASTO_AUTM_COBRANZAM   	    = '10009'>
  	 
	<cfset This.pLimEstadoCuentaIntereses =''>
	<cfset This.pPorcInteresPagoMinimo    =''>
	<cfset This.pPorcInteresSinPagoMinimo =''>
	<cfset This.pPorcInteresMayorista     =''>
	<cfset This.pPorcInteresDistribuidor  =''> 
	<cfset This.pLimiteEstadoCuentaPromosion  =''> 

	<cfset This.pAplicarGC  = ''> 
	<cfset This.pValorGC    = ''> 
	<cfset This.pCantidadCortesAplicarGC  =''> 
	 
 	<cfset This.cortesAnteriores = ''>
 	<cfset This.cortesACerrar    = ''>
 	<cfset This.fechaActual      = ''>
 	<cfset This.listadoCortesACerrar = ''>
 	
 	<cfset This.Tipo_Producto  = ''>
 	<cfset This.cuentaID       = ''>
 	<cfset This.pMontoSeguroVida = ''>
	<cfset This.pRolAdminCredito = ''>
	
	<cfset logStack = ''>

	 
	<cfset isReproceso = false>
	

    <cffunction name="init" output="false" returntype="CRCProcesoCorte" hint="constructor del componente proceso de corte">  
		<cfargument name="conexion" type="string" required="false" default="#session.dsn#"> 
		<cfargument name="ECodigo"  type="string" required="false" default="#session.Ecodigo#">  
		<cfargument name="isReproceso"  type="boolean" required="false" default="false">  
		<cfset Super.init(#arguments.conexion#, #arguments.Ecodigo#)>
		<cfset this.isReproceso = arguments.isReproceso>
		<cfreturn This>
    </cffunction>	


  	<cffunction name="procesarCorte" access="public" returntype="string" hit="funcion que se encarga de procesar el corte para los productos">
  		<cfargument name="fechaCorte" type="string"  required="false" default="">
		<cfargument name="cuentaID"   type="string"  required="false" default="">
		 

		<cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
		<cfset This.statusConvenio = crcObjParametros.GetParametro(codigo='30100501',conexion=this.dsn,ecodigo=this.ecodigo)>
		<cfset registerLog("inicio proceso: fecha del sistema #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())#")>

  		<cfif arguments.fechaCorte eq "">
  			<cfset This.fechaActual = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>	
  		<cfelse>
  			<cfset This.fechaActual = CreateDate(DatePart('yyyy',arguments.fechaCorte), DatePart('m',arguments.fechaCorte),DatePart('d',arguments.fechaCorte))>
  		</cfif>

		<cftransaction>
			<cftry>
 				
 				<!--- se inicialian los parametros --->
				<cfset inicializarParametros()>
				<cfset validarArgumentoTipoCuenta(cuentaID = arguments.cuentaID)>
	 

				<!---1 obtener los cortes anteriores(SV) y los cortes a cerrar(MP). --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: obtenerCortesAProcesar")>
				<cfset obtenerCortesAProcesar()>

				<!---2 se cierran los cortes que ya fueron calculados su saldo vencido e intereses ---> 
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: ponerStatusCerrado")>
				<cfset ponerStatusCerrado()>
	
				<!---3 calculo de interes y saldo vencido para corte anterior--->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: calculoParaCorteAnterior")>
				<cfset calculoParaCorteAnterior()>

				<!---4 se cambia status los cortes que ya fueron calculados su saldo vencido e intereses---> 
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: ponerStatusCerradoSV")>
				<cfset ponerStatusCerradoSV()>

				<!---5 se vuelve a obtener los cortes a procesar --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: obtenerCortesAProcesar")>
				<cfset obtenerCortesAProcesar()>

				<!---6  cortes que ya terminan su calendario y quedan con saldo vencido--->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: crearParcialidadPorSaldoVencido")>
				<cfset crearParcialidadPorSaldoVencido()>  

				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: obtenerCortesAProcesar")>
				<cfset obtenerCortesAProcesar()>

				<!---9 calculo de seguro para producto de credito tarjeta de credito y mayorista --->	
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: calculoDeSeguroTarjeta")>
				<cfset calculoDeSeguroTarjeta()>   

				<!--- 15 gasto automatico cobranza  --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: genearGAstoAutomaticoCobranza")>
				<cfset genearGAstoAutomaticoCobranza()>					
  
				<!---7 calculo para el corte que se cierra --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: calculoParaMC")>
				<cfset calculoParaMC()>

				<!--- 8 calculo para movimiento cuenta corte--->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: caculoParaMCC")>
				<cfset caculoParaMCC()>
 
				<!--- calculo del seguro para producto de credito distribuidor --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: calculoDeSeguroDistribuidor")>
				<cfset calculoDeSeguroDistribuidor()>   

				<!--- 12 se crean transacciones por intereses generados --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: crearTransactionPorIntereses")>
				<cfset crearTransactionPorIntereses()>
				
				<!--- 10 calculo para las cuentas --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: actualizarMCC")>
				<cfset actualizarMCC()>
				
				<!--- 11 calculo para las cuentas --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: actualizarCuentas")>
				<cfset actualizarCuentas()>

				<!--- 11 se cierran los cortes que ya fueron calculados su monto a pagar
				      .Si existe saldo a favor tamien se incorpora---> 
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: ponerStatusCerradoMP")>
				<cfset ponerStatusCerradoMP()>



				<!--- 13 actualizar el estatus de la cuenta --->
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: actualizarEstadoCuenta")>	
				<cfset actualizarEstadoCuenta()>		

				<!--- 14 actualizar categorias del distribuidor
				<cfset registerLog("proceso corte fecha " & now() & "llamado: actualizarCategoriaDistribuidor")>
				 cfset actualizarCategoriaDistribuidor() --->

				
				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: eliminarDetallesCondNoAplicadas")>
				<cfset eliminarDetallesCondNoAplicadas()>

				<cfset registerLog("proceso corte fecha #lsDateFormat(now(),'dd/mm/yyyy')# #lsTimeFormat(now())# llamado: vencerConveniosNoAplicados")>
				<cfset vencerConveniosNoAplicados()>

				
				<!--- envio de correos electronico a los administradores de credito y cobranza --->
				<!--- cfset envioCorreo() --->

				<cfcatch type="any">
					<cfset registerLog("Error en el proceso de corte:" & cfcatch.errorcode & cfcatch.message)>
					<cftransaction action = "rollback" /> 
					<cfrethrow>
				</cfcatch>
			</cftry>
		</cftransaction>
 
		<cfreturn logStack>

 	</cffunction>


 	<cffunction name="inicializarParametros">

		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>

		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIM_ESTADO_CUENTA_PROM#",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Recibir promociones de categoría hasta estado" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_LIM_ESTADO_CUENTA_PROM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset This.pLimiteEstadoCuentaPromosion = paramInfo.valor>

		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_APLICAR_GCA #",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Aplicar gasto de cobranza automatico por saldo vencido" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_GASTO_AUTM_COBRANZAM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset This.pAplicarGC = paramInfo.valor>

		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_CANT_CORTES_APLICAR_GCA #",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Cantidad de cortes para realizar gasto de cobranza por saldo vencido" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_GASTO_AUTM_COBRANZAM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset This.pCantidadCortesAplicarGC = paramInfo.valor>


		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_VALOR_GCA #",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Valor para la generación automatica de gasto de cobranza" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_GASTO_AUTM_COBRANZAM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset This.pValorGC = paramInfo.valor>

		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_ROL_ADM_CREDITO#",conexion=#This.DSN#,ecodigo=#This.ecodigo#, descripcion="Rol de administradores de credito" )> 
		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_GASTO_AUTM_COBRANZAM#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset This.pRolAdminCredito = paramInfo.valor>

 	</cffunction>


	<cffunction name="validarArgumentoTipoCuenta" >
	 	<cfargument name="cuentaID"   type="string"  required="false" default="">

		<!--- si se pasa como parametro el id de la cuenta se busca el tipo de transaccion para filtrar en el corte --->	
		<cfif arguments.cuentaID neq ""> 
			<cfquery name="qCuenta" datasource="#this.dsn#">
				select id, Tipo from CRCCuentas where id = #arguments.cuentaID#
			</cfquery>	

			<cfif qCuenta.recordCount eq 0>
				<cfthrow errorcode="#This.C_ERROR_CUENTA_NO_ENCOTRADA#"  type="CRCTransaccionException" message="No existe cuenta para el codigo pasado como parametro: #arguments.cuentaID#" >
			</cfif>

			<cfset This.Tipo_Producto = qCuenta.Tipo> 
			<cfset This.cuentaID      = qCuenta.id>

		</cfif> 	

 	</cffunction>


 	<cffunction name="ponerStatusCerrado" returntype="void" access="private" hint="se cierran aquellos cortes que fueron procesados su sv y que no estan en el periodo con fecha actual">
 			 
        <cfquery name="qCerrar" datasource="#This.dsn#">
        	update mc
        	set status = '#This.C_STATUS_CERRADO#'
        	from CRCCortes mc
        	where mc.status = '#This.C_STATUS_SV_CALC#'
        	and  not  <cfqueryparam value = "#This.fechaActual#"CFSQLType = 'CF_SQL_DATE'> between FechaInicioSV and FechaFinSV
    	</cfquery>

 	</cffunction>

	<cffunction name="ponerStatusCerradoMP" returntype="void" access="private" hint="se cierran aquellos cortes que fueron procesados su sv y que no estan en el periodo con fecha actual">
 		

        <cfquery datasource="#This.dsn#">
        	update mc
        	set 
				cerrado = 1,
				status = '#This.C_STATUS_MP_CALC#'
        	from CRCCortes mc
        	where cerrado = 0
				and Codigo in (<cfqueryparam value="#This.cortesACerrar#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )
    	</cfquery>
 
 
 	</cffunction>

	<cffunction name="ponerStatusCerradoSV" returntype="void" access="private" hint="se cambia status de aquellos cortes que fueron procesados su sv y que no estan en el periodo con fecha actual">
 		
        <cfquery datasource="#This.dsn#">
        	update mc
        	set  status = '#This.C_STATUS_SV_CALC#'
        	from CRCCortes mc
        	where status = '#This.C_STATUS_MP_CALC#'
				and Codigo in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )
    	</cfquery>

 	</cffunction>

	<cffunction name="initParametros" returntype="void" access="private" hint="busca informacion de parametros referente a la cuenta">

		<!---parametros---> 
		<cfset Super.initParametros()>

		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")> 
		
		<!--- limite estado cuenta genera intereses--->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_LIM_EST_GENERA_INT#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Genera intereses hasta estado" )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_CONF_LIMITE_ESTADO_GI#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>
		<cfset This.pLimEstadoCuentaIntereses = paramInfo.valor>

		<!--- porciento intereses para mayorista--->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_PORC_INT_TM#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Porcentaje de interés por retraso" )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_CONF_PORC_INT_MAYORISTA#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pPorcInteresMayorista = paramInfo.valor>		

		<!--- porciento intereses para distribuidor--->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_PORC_INT_D#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,
			descripcion="Porcentaje de interés por retraso" )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_CONF_PORCIENTO_INTERES_D#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>		
		<cfset This.pPorcInteresDistribuidor = paramInfo.valor>

		<!--- porciento interes tarjeta de credito,pago minimo --->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_PORC_INT_TC_PM#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Porcentaje de interes con pago mínimo" )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_PORCIENTO_PAGO_MIN#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pPorcInteresPagoMinimo = paramInfo.valor>	

		<!--- porciento intereses tarjeta credito, sin pago minimo--->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_PORC_INT_TC_SPM#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Porcentaje de interes sin cubrir pago mínimo" )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_PORCIENTO_SIN_PAGO_MIN#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pPorcInteresSinPagoMinimo = paramInfo.valor>	


		<!--- dias seguro mayorista --->
		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_DIA_SEGURO_MAYORISTA#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Dia para generacion de estado de cuenta Mayoristas." )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_PORCIENTO_SIN_PAGO_MIN#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pDiaSeguroMayorista = paramInfo.valor>	


		<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#This.C_PARAM_MONTO_SEGURO_VIDA#",conexion=#This.DSN#,ecodigo=#This.ecodigo#,descripcion="Monto de seguro vida" )>
 		<cfif paramInfo.valor eq ''>
			<cfthrow errorcode="#This.C_ERROR_PORCIENTO_SIN_PAGO_MIN#"  type="CRCTransaccionException" message="No se ha definido el parametro de configuracion: #paramInfo.descripcion#" >
		</cfif>	
		<cfset This.pMontoSeguroVida = paramInfo.valor>			



	</cffunction> 	 	

	<cffunction name="obtenerCortesAProcesar" access="private" hint="busca los cortes a procesar saldo vencido y monto a pagar">
 
 		<!--- obtener el componente de corte --->
		<cfset This.cortesAnteriores = ''>
 		<cfset This.cortesACerrar    = ''>
 		<cfset cCorte = createobject("component", "crc.Componentes.cortes.CRCCortes").init(TipoCorte = "",
 																					       conexion  = #This.DSN#, 
 																					       ECodigo   = #This.ECodigo#)>

 		<!--- cortes a calcular su salvo vencido--->  
		<cfset This.cortesAnteriores = cCorte.obtenerCortesSV(fechaActual=This.fechaActual, Tipo_Producto = This.Tipo_Producto )> 

		<!--- cortes a cerrar y/o calcular monto a pagar --->  
		<cfset This.listadoCortesACerrar = cCorte.obtenerCortesACerrar(status=This.C_STATUS_MP_CALC, fechaActual=This.fechaActual,Tipo_Producto = This.Tipo_Producto)>
		
		<cfloop index="i" from="1" to="#ArrayLen(This.listadoCortesACerrar)#" step="1"> 
			<cfif listContains(This.cortesACerrar, #This.listadoCortesACerrar[i].Codigo#) eq 0>
				<cfset This.cortesACerrar = ListAppend(This.cortesACerrar,#This.listadoCortesACerrar[i].Codigo#)>   
			</cfif>
		</cfloop>
 
	</cffunction>

 	<cffunction name="calculoParaCorteAnterior" access="private" returntype="void" hint="calculo de interes y saldo vencido para los cortes anteriores">  
		
		
 		<cfif This.cortesAnteriores neq ''>

			<cfquery name="rsCorte" datasource="#This.DSN#">
				select * from CRCCortes where Codigo = '#This.cortesACerrar#'
			</cfquery>
			<cfset CRCCortes = createObject( "component","crc.Componentes.cortes.CRCCortes").init(TipoCorte = '#rsCorte.Tipo#', conexion=THIS.dsn,ecodigo = this.Ecodigo)>
			<cfset corteAnterior = CRCCortes.AnteriorCorte(corte="#This.cortesAnteriores#", dsn=THIS.dsn,ecodigo = this.Ecodigo)>
			<cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
			<cfset This.statusConvenio = crcObjParametros.GetParametro(codigo='30100501',conexion=this.dsn,ecodigo=this.ecodigo)>
			
	 		<cfquery name="rsCalcCorteAnterior" datasource="#This.DSN#">
				update mc	set
				<!--- select c.id,  mc.MontoAPagar, mc.Pagado , mc.Descuento , mc.Condonaciones, --->
				 	mc.SaldoVencido =  case when (mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> ) > 0 
					 					then round((mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> ),2) 
										else 0 
									end,
				    mc.status       =  '#This.C_STATUS_SV_CALC#',
					mc.Intereses    =  case when ((mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> ) > 0 
					                               and (
													   ec.Orden <> #This.statusConvenio#
												   		and ec.Orden < #This.pLimEstadoCuentaIntereses#
												   )
					                               and  t.CRCCondonacionesid is null 
												   and ( 
													   		mc.Condonaciones = 0 
															or (
																mc.Condonaciones > 0 
																and mc.Condonaciones < isnull(cn.SV,0)
															)
														)
													)
										then 
											CASE c.Tipo
											WHEN '#This.C_TP_DISTRIBUIDOR#' 
											 	    THEN round( ((mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> ))
											 	        * (#This.pPorcInteresDistribuidor/100#),2)

											WHEN '#This.C_TP_MAYORISTA#'    
											        THEN round(((mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> ))
											             * (#This.pPorcInteresMayorista/100#),2)
											WHEN '#This.C_TP_TARJETA#'      
												THEN  
													CASE WHEN mcc.MontoPagado >= ( select isnull((select  min(MontoPagoMin) MontoPagoMin
																					from CRCPagoMinimo
																					where mcc.MontoAPagar between SaldoMin and SaldoMax
																						and Ecodigo = #this.Ecodigo#),
																						mcc.MontoAPagar * (select Pvalor from CRCParametros where Pcodigo = '30200501')/100)
																					)
														THEN round(((mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> )) * #This.pPorcInteresPagoMinimo/100#,2)
													ELSE
														round(((mc.MontoAPagar <!--- + mc.Intereses --->) - (mc.Pagado + mc.Descuento <!--- + mc.Condonaciones ---> )) * #This.pPorcInteresSinPagoMinimo/100#,2)
													END
											 ELSE 
											 mc.Intereses
											 END
										else 
											mc.Intereses
									  	end
				from CRCMovimientoCuenta as mc
				inner join CRCTransaccion t
					on mc.CRCTransaccionid = t.id
				inner join CRCCuentas c
					on t.CRCCuentasid = c.id
				left join (
					SELECT 
						SUM(
							case when (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end > 0
									then (ISNULL(A.MontoAPagar, 0) + ISNULL(A.Intereses, 0)) - (ISNULL(A.Pagado, 0) + ISNULL(A.Descuento, 0)) - case when A.MontoRequerido = 0 then A.UltimoRequerido else A.MontoRequerido end
									else A.Intereses
								end
						) SV,
						B.CRCCuentasid
					FROM (
							select  A.Ecodigo,A.Corte,A.CRCTransaccionid,A.MontoAPagar,A.Intereses,A.Condonaciones,A.Pagado,A.Descuento,A.MontoRequerido,
								UltimoRequerido = (
									select top 1 MontoRequerido 
									from CRCMovimientoCuenta 
									where MontoRequerido > 0 
										and CRCTransaccionid = A.CRCTransaccionid)
							from CRCMovimientoCuenta A
					) A
					INNER JOIN CRCTransaccion B ON A.CRCTransaccionid = B.id
					INNER JOIN CRCCortes ct on A.Corte = ct.Codigo and A.Ecodigo = ct.Ecodigo
					WHERE A.Ecodigo=#this.ecodigo#
					AND ct.status = 2
					AND MontoAPagar - (Pagado + A.Descuento) > 0
					group by B.CRCCuentasid
				) cn on cn.CRCCuentasid = c.id
				inner join CRCMovimientoCuentaCorte mcc
					on c.id = mcc.CRCCuentasid
					<!--- <cfif this.isReproceso>
						and mcc.Corte = '#corteAnterior#'
					<cfelse> --->
						and mcc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" cfsqltype="cf_sql_varchar" list="yes"/>)
					<!--- </cfif> --->
				inner join CRCCortes cc on mcc.Corte = cc.Codigo
				inner join CRCEstatusCuentas ec
					on ec.id = c.CRCEstatusCuentasid
				where 
				<!--- <cfif this.isReproceso>
					mc.Corte = '#corteAnterior#'
				<cfelse> --->
					mc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" cfsqltype="cf_sql_varchar" list="yes"/> )
				<!--- </cfif> --->
				and c.Ecodigo =  #This.ecodigo# 
				and (
					cc.Tipo in (select Tipo from CRCCortes 
											where Codigo in (<cfqueryparam value="#This.cortesACerrar#" 
															cfsqltype="cf_sql_varchar"
															list="yes"/>) )
					or cc.Tipo = 'TM'
				)
				<cfif  This.cuentaID neq "">
				  and c.id = #This.cuentaID#
				</cfif>
				 
			 </cfquery> 
			<!---Se cambia el status de las cuentas conveniadas que hayan incumplido --->
			<cfquery datasource="#This.DSN#">
				update c set c.CRCEstatusCuentasid = (select Pvalor from CRCParametros where Pcodigo = '30100110' and Ecodigo = #this.ecodigo#)
				from CRCCuentas c
				inner join (
				select c.id, sum(mc.SaldoVencido) SaldoVencido
				from CRCMovimientoCuenta as mc
								inner join CRCTransaccion t
									on mc.CRCTransaccionid = t.id
								inner join CRCCuentas c
									on t.CRCCuentasid = c.id
								inner join CRCMovimientoCuentaCorte mcc
									on c.id = mcc.CRCCuentasid
									and mc.Corte = mcc.Corte
									and mcc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" cfsqltype="cf_sql_varchar" list="yes"/>)
					inner join CRCCortes cr
						on cr.Codigo = mcc.Corte
						and cr.Tipo in (select Tipo From CRCCortes cr2 where cr2.Codigo in (<cfqueryparam value="#This.cortesACerrar#"  cfsqltype="cf_sql_varchar" list="yes"/> ))
				where c.CRCEstatusCuentasid = (select Pvalor from CRCParametros where Pcodigo = '30100501' and Ecodigo = #this.ecodigo#)
				group by c.id
				) c1 on c.id = c1.id
				where c1.SaldoVencido > 0
			</cfquery> 
 		</cfif> 


 	</cffunction>

 
 	<cffunction name="crearParcialidadPorSaldoVencido" access="private" hint="se buscan los movimiento cuenta que no tengan mas parcialidades y tengan Saldo Vencido. Se crea un registro nuevo para mov cuenta">  
 		 
		<cfquery name="rsParcDeuda" datasource="#This.DSN#">
			select c.Tipo as TipoProducto, mc.id , mc.Corte, mc.MontoRequerido, mc.MontoAPagar, mc.Pagado, 
				   mc.Descuento, mc.Intereses, mc.Condonaciones, mc.SaldoVencido, mc.TipoMovimiento,
				   t.id as TransaccionID, mc.Descripcion, t.Observaciones, t.TipoTransaccion, c.id CuentaID, c.SNegociosSNid SNid
			from  CRCMovimientoCuenta mc
			inner join CRCTransaccion t
			on mc.CRCTransaccionid = t.id
			inner join CRCCuentas c
			on t.CRCCuentasid  = c.id
			inner join CRCEstatusCuentas ec
			on ec.id = c.CRCEstatusCuentasid
			where mc.SaldoVencido > 0
			and   not exists (select 'x' from CRCMovimientoCuenta mc1
			                  where mc1.id> mc.id
							  and   mc1.CRCTransaccionid = mc.CRCTransaccionid
							  and   mc1.Ecodigo=#This.Ecodigo#)
			and mc.corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )  
			and mc.Ecodigo=#This.Ecodigo# 
			<cfif  This.cuentaID neq "">
				  and c.id = #This.cuentaID#
			</cfif>
		</cfquery>
		
		<cfif rsParcDeuda.recordCount gt 0>
			
			<cfset scriptInsertMC  = "">
			<cfset scriptInsertMCC = "">
			<cfset loc.listadoMCC  = "">
			

			<cfloop query="rsParcDeuda">
				 
				<cfset CRCCorteFactory = createObject( "component","crc.Componentes.cortes.CRCCorteFactory")>
				<cfset CRCorte   = CRCCorteFactory.obtenerCorte(TipoProducto='#rsParcDeuda.TipoProducto#',
																conexion=This.dsn,
																ECodigo=This.Ecodigo,
																SNid=rsParcDeuda.SNid)>
				<cfif trim(rsParcDeuda.TipoProducto) eq 'TM'>
					<cfset loc.corte = CRCorte.ProximoCorte(corte=#rsParcDeuda.Corte#,estado=0, SNid=rsParcDeuda.SNid)>
				<cfelse>
					<cfset loc.corte = CRCorte.ProximoCorte(corte=#rsParcDeuda.Corte#,estado=0)>
				</cfif>

				<cfif loc.corte eq ''>
					<cfthrow errorcode="#This.C_ERROR_LIM_ESTADO_CUENTA_PROM#"  type="CRCTransaccionException" message="No se pudo generar proximo corte por saldo vencido. Por favor, consultar al administrador" >
				</cfif>
			 
				<!--- adicionarlo al listado de cortes a cerrar--->
				<cfif listContains(This.cortesACerrar, loc.corte) eq 0>
					<cfset This.cortesACerrar = ListAppend(This.cortesACerrar, loc.corte)>
				</cfif>

				<cfset _cuentaId = rsParcDeuda.CuentaID>
				<!--- este corte nace cerrado---> 
				
				<cfset Parcialidades = REMatch("\(\d+?\/\d+?\)",rsParcDeuda.Descripcion)[1]>
				<cfset Parcialidades = Replace(Parcialidades,'(','','all')>
				<cfset Parcialidades = Replace(Parcialidades,')','','all')>
				<cfset Parcialidad = listToArray(Parcialidades,'/')>
				<cfset obsvCorteAdicional = "(#Parcialidad[1]+1#/#Parcialidad[2]#) " & rsParcDeuda.Observaciones & " - Corte adicional por deudas"> 
				<cfset scriptInsertMC = "">
				<cfset scriptInsertMC = insertScriptMovC(TransaccionID  = TransaccionID,
				                      				   TipoMovimiento = rsParcDeuda.TipoMovimiento,
				                      				   Corte          = #loc.corte#,
				                      				   MontoRequerido = 0,
				                      				   Observaciones  = #obsvCorteAdicional#,
													   Intereses      = rsParcDeuda.Intereses) & ";">

				<cfscript>
					QueryExecute(scriptInsertMC,[],{datasource="#This.DSN#"}); 
				</cfscript>

				<!--- chequear movimiento cuenta corte. Si no existe se crea--->

					<cfquery name="qSearchMCC" datasource="#This.DSN#">
				       select 'x' 
				       from CRCMovimientoCuentaCorte
				       where CRCCuentasid = #_cuentaId#
				       and   Corte = '#loc.corte#' 
					</cfquery>

					<cfset loc.listadoMCC  = ListAppend(loc.listadoMCC, #loc.corte# & "_" & #_cuentaId#)> 

					<cfif qSearchMCC.recordCount eq 0>
							<cfset scriptInsertMCC = "">
							<!--- <cfdump  var="#rsParcDeuda['CuentaID'][currentRow]#"> --->
							<cfset scriptInsertMCC = creaMovimientoCuentaCorte(CRCCuentasid=#rsParcDeuda['CuentaID'][currentRow]#,
																								 Corte=#loc.corte#,
																								 FechaLimite=now(),
																								 MontoRequerido=0,
																								 MontoAPagar=0,
																								 Intereses=0,
																								 Descuentos=0,
																								 Condonaciones=0,
																								 Seguro=0,
																								 MontoPagado=0,
																								 SaldoVencido=0,
																								 cerrado=0
																								 ) & ";">
					</cfif>

				

			</cfloop> 

		</cfif>

 	</cffunction> 		
 
 
 	<cffunction name="calculoParaMC" access="private" returntype="void" hint="Calculo para movimiento cuenta. Se incluyen los valores de saldo a favor en el caso de que la cuenta tenga esta informacion">  
		
		<cfquery datasource="#This.dsn#" name="rstestt">
			update mcc set
				mcc.MontoAPagar = round(MontoRequerido + isnull(mcAnt.SaldoVencido,0) + isnull(mcAnt.Intereses,0) - isnull(mcAnt.Condonaciones,0),2), 
				status  = '#This.C_STATUS_MP_CALC#'
			from   CRCMovimientoCuenta mcc
			inner join CRCtransaccion t on t.id = mcc.CRCTransaccionId and t.TipoTransaccion not in ('RP')
			left join (select mcA.CRCTransaccionid, mcA.SaldoVencido, mcA.Intereses, mcA.Condonaciones
			           from CRCMovimientoCuenta mcA
					   where mcA.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> ) 
					   ) mcAnt
				on mcc.CRCTransaccionid = mcAnt.CRCTransaccionid 
			where mcc.Corte in (<cfqueryparam value="#This.cortesACerrar#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )
			<cfif #This.cuentaID# neq "">
				 and mcc.CRCTransaccionid in (select id 
				 							  from CRCTransaccion tc 
				 							  where  tc.CRCCuentasid = #This.cuentaID# 
				 							  and   tc.id = mcc.CRCTransaccionid   )
			</cfif>	
			 
		</cfquery>		 
		<!--- se buscan las cuentas que tienen movimiento cuenta a procesar en este corte
		y que tengan saldo a favor  para repartirlo en el campo pago de movimiento cuenta  --->		
		<cfset procesarSaldoAFavor()>
 
 	</cffunction>


 	<cffunction name="procesarSaldoAFavor" access="private" hint="para cortes  cerrar se chequea si su cuenta tiene saldo a favor para repartir en el campo Pagado en movimiento cuenta">
		
		<!--- se buscan las cuentas que tienen movimiento cuenta a procesar en este corte
		y que tengan saldo a favor  --->
   		<cfquery name="qCuentaSaldoFavor" datasource="#This.dsn#">
        	select distinct  id, saldoAFavor 
        	from  CRCCuentas c
        	where  c.id in  ( select  t.CRCCuentasid 
        					 from  CRCTransaccion t
        					 inner join  CRCMovimientoCuenta mc
        					 on mc.CRCTransaccionid = t.id
        					 where mc.Corte  in (<cfqueryparam value="#This.cortesACerrar#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> ) 
        					 and mc.MontoAPagar > (mc.Pagado + mc.Descuento)
        					)
        	and  c.saldoAFavor > 0
			<cfif #This.cuentaID# neq "">
				and c.id = #This.cuentaID#
			</cfif>
    	</cfquery>  
 
    	<cfloop query="qCuentaSaldoFavor"> 
		   		<cfset loc.saldoAFavor = #qCuentaSaldoFavor.saldoAFavor# >

				<cfquery name="rsCuenta" datasource="#this.dsn#">
					select * from CRCCuentas where id = #qCuentaSaldoFavor.id#
				</cfquery>
			<!---
				<cfquery datasource="#this.dsn#">
					update CRCCuentas 
					set saldoAFavor = 0
					where id = #qCuentaSaldoFavor.id# 
				</cfquery>

				<cftry>
					<cfset CRCPagosExt = createObject("component","crc.Componentes.pago.CRCImporadorPagos")>
					<cfset PagosMetadata = CRCPagosExt.getPagoExtMetadata(false,this.dsn,this.ecodigo)>
				<cfcatch type="any">
					<cfrethrow>
					<cfset registerLog("Ocurrio un Error actualizando el sado a favor:  #cfcatch.message#","Error")>
				</cfcatch>
				</cftry>
				--->
				
				<!---
				<cfset resultado = CRCPagosExt.ImportarPagoExterno(
					fecha			= qMovCuentaSaldoFavor.FechaFin
					, NumCuenta		= rsCuenta.Numero
					, monto			= loc.saldoAFavor
					, ID_Caja		= PagosMetadata.ID_Caja
					, Codigo_CCT	= PagosMetadata.Codigo_CCT
					, ID_CFuncional	= PagosMetadata.ID_CFuncional
					, Codigo_Moneda	= PagosMetadata.Codigo_Moneda
					, Tipo_Cambio	= PagosMetadata.Tipo_Cambio
					, ID_Tarjeta	= PagosMetadata.ID_Tarjeta
					, ID_Zona		= PagosMetadata.ID_Zona
					, dsn 			= this.dsn
					, ecodigo		= this.ecodigo
					, usucodigo		= 0
					, Observacion 	= "Pago con Saldo a Favor"
					, generaMovBancario = false
				)> --->
				 
				<cfquery name="qMovCuentaSaldoFavor" datasource="#This.dsn#">
					select mc.id mcID, mc.MontoAPagar, mc.Pagado, mc.Descuento, t.CRCCuentasid, t.id transaccionID, t.TipoTransaccion
					from  CRCTransaccion t
					inner join  CRCMovimientoCuenta mc
					on mc.CRCTransaccionid = t.id
					where mc.Corte  in (<cfqueryparam value="#This.cortesACerrar#"  cfsqltype="cf_sql_varchar" list="yes"/> ) 
					and mc.MontoAPagar > (mc.Pagado + mc.Descuento)
					and t.CRCCuentasid = #qCuentaSaldoFavor.id#
					order by t.FechaInicioPago, mc.id
				</cfquery>   
	
				<cfloop query="qMovCuentaSaldoFavor">

					<cfset loc.porcDesFuturo = 0>
					<cfif trim(rsCuenta.Tipo) eq "#this.C_TP_DISTRIBUIDOR#" and trim(qMovCuentaSaldoFavor.TipoTransaccion) eq "#this.C_TT_VALES#">
						<cfquery name="rsCategoria" datasource="#this.DSN#">
							select DescuentoInicial , PenalizacionDia
							from CRCCategoriaDist where Ecodigo = #this.Ecodigo# and id = #rsCuenta.CRCCategoriaDistid#
						</cfquery>
						<cfset loc.porcDesFuturo = rsCategoria.DescuentoInicial>
					</cfif>

					

					<cfset loc.varMontoRequerido = NumberFormat(qMovCuentaSaldoFavor.MontoAPagar - qMovCuentaSaldoFavor.Descuento - qMovCuentaSaldoFavor.Pagado,'9.99')>

					<cfset loc.lvarDescuento = calculaDescuentoSaldo(monto=loc.varMontoRequerido, porciento=loc.porcDesFuturo)>

					<cfif NumberFormat(loc.saldoAFavor,'9.99') + loc.lvarDescuento gte loc.varMontoRequerido>
						<cfset loc.lvarPagado = loc.varMontoRequerido - loc.lvarDescuento>
					<cfelse>
						<cfset loc.lvarDescuento = calculaDescuentoSaldo(monto=NumberFormat(loc.saldoAFavor,'9.99'), porciento=loc.porcDesFuturo)>
						<cfset loc.lvarPagado = NumberFormat(loc.saldoAFavor,'9.99')>
					</cfif>
					<cfset loc.saldoAFavor = NumberFormat(loc.saldoAFavor - loc.lvarPagado,'9.99')>
					
					<cfquery datasource="#this.dsn#">
						update CRCMovimientoCuenta 
						set Pagado = round(Pagado + #loc.lvarPagado#,2),
							Descuento = round(Descuento + #loc.lvarDescuento#,2)
						where id = #qMovCuentaSaldoFavor.mcID# 
					</cfquery>

					<cfif loc.saldoAFavor lte 0>
						<cfbreak>
					</cfif>
				</cfloop>	
				
				<cfif loc.saldoAFavor lte 0>
					<cfset loc.saldoAFavor = 0> 
				</cfif>

				<!--- actualizar pagos en movimiento cuenta corte --->
				 
				<cfquery datasource="#this.dsn#">
					update CRCMovimientoCuentaCorte
					set MontoPagado = round(MontoPagado + #loc.lvarPagado#,2),
						Descuentos = round(Descuentos + #loc.lvarDescuento#,2) 
					where CRCCuentasId = #qMovCuentaSaldoFavor.mcID# 
						and Corte in (<cfqueryparam value="#This.cortesACerrar#"  cfsqltype="cf_sql_varchar" list="yes"/> ) 
				</cfquery> 

				<!--- actualizar el salso a favor, en la cuenta--->	
				<cfquery datasource="#this.dsn#">
					update CRCCuentas 
					set saldoAFavor = round(#loc.saldoAFavor#,2)
					where id = #qCuentaSaldoFavor.id# 
				</cfquery>
	    	 
    	</cfloop>  

 	</cffunction>

 	<cffunction name="caculoParaMCC" access="private" returntype="void" hint="Calculo para movimeinto cuenta corte"> 
 		<!--- <CF_DUMPTABLE VAR="CRCMovimientoCuentaCorte" abort="false">  --->
 	 	<cfset CrearActualizarMccPorCortes(cortes=#This.cortesAnteriores#, anterior=true)>
 	 	<!--- <CF_DUMPTABLE VAR="CRCMovimientoCuentaCorte" abort="false"> --->
 	 	<cfset CrearActualizarMccPorCortes(cortes=#This.cortesACerrar# , anterior=false)>
 	 	<!--- <CF_DUMPTABLE VAR="CRCMovimientoCuentaCorte" abort="true">  --->
 	</cffunction>	

	 <cffunction name="actualizarMCC" access="private" returntype="void" hint="actualiza las cuentas asociadas a los movimeintos cuentas cortes actualizados">
		<!--- chequear movimiento cuenta corte. Si no existe se crea--->
		<cfquery name="insMCC" datasource="#This.DSN#">
			insert into CRCMovimientoCuentaCorte 
			(
			CRCCuentasid, Corte, FechaLimite, MontoRequerido, MontoAPagar, Intereses,
			Descuentos, Condonaciones, Seguro, MontoPagado, Ecodigo, cerrado, SaldoVencido, GastoCobranza
			) 
			select mc.CRCCuentasid,  mc.Corte, FechaLimite = '1900-01-02',  
				mc.MontoRequerido, mc.MontoAPagar, mc.Intereses, mc.Descuento, mc.Condonaciones,
				0, mc.Pagado, #this.Ecodigo#, 0, mc.SaldoVencido, 0
			from CRCMovimientoCuentaCorte mcc
			right join (
				select t.CRCCuentasid, mc.Corte
				, sum(mc.MontoRequerido) MontoRequerido
				, sum(mc.MontoAPagar) MontoAPagar
				, sum(mc.Descuento) Descuento
				, sum(mc.Pagado) Pagado
				, sum(mc.Intereses) Intereses
				, sum(mc.SaldoVencido) SaldoVencido
				, sum(mc.Condonaciones) Condonaciones
				from CRCMovimientoCuenta mc
				inner join CRCTransaccion t
					on mc.CRCTransaccionid = t.id
				inner join CRCCortes ct
					on mc.Corte = ct.Codigo
				where ct.Codigo >= '#This.cortesACerrar#'
					and left(ct.Codigo,1) = '#left(This.cortesACerrar,1)#'
				group by t.CRCCuentasid , mc.Corte
			) mc
				on mcc.CRCCuentasid = mc.CRCCuentasid and mcc.Corte = mc.Corte
			where mcc. CRCCuentasid is null and mcc.Corte is null
		</cfquery>
	</cffunction> 

 	<cffunction name="actualizarCuentas" access="private" returntype="void" hint="actualiza las cuentas asociadas a los movimeintos cuentas cortes actualizados">

 		<!--- en la cuenta el saldo vencido--->
 		<cfquery name="rActCuentaSV" datasource="#This.dsn#">
 			update c
 			set Interes      =  case when c.Tipo = 'TM' 
			 						then
									 (select sum(Intereses) Intereses from CRCMovimientoCuenta mc
										inner join CRCTransaccion t
											on t.id = mc.CRCTransaccionid 
										where t.CRCCuentasid = c.id
											and mc.status = 2
											and mc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
																					cfsqltype="cf_sql_varchar"
																					list="yes"/>))
									else mcc.Intereses end ,
				Condonaciones      =  case when c.Tipo = 'TM' 
			 						then
									 (select sum(Condonaciones) Intereses from CRCMovimientoCuenta mc
										inner join CRCTransaccion t
											on t.id = mc.CRCTransaccionid 
										where t.CRCCuentasid = c.id
											and mc.status = 2
											and mc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
																					cfsqltype="cf_sql_varchar"
																					list="yes"/>))
									else mcc.Condonaciones end , 
 				SaldoVencido = case when c.Tipo = 'TM' 
			 						then
									 (select sum(SaldoVencido) SaldoVencido from CRCMovimientoCuenta mc
										inner join CRCTransaccion t
											on t.id = mc.CRCTransaccionid 
										where t.CRCCuentasid = c.id
											and mc.status = 2
											and mc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
																					cfsqltype="cf_sql_varchar"
																					list="yes"/>))
									else
										case when mcc.SaldoVencido > 0 then round(mcc.SaldoVencido,2) else 0 end
									end
 			from CRCCuentas c
 			inner join (select mcc1.Corte, mcc1.CRCCuentasid,sum(mcc1.Intereses) Intereses, sum(mcc1.Condonaciones) Condonaciones, sum(mcc1.SaldoVencido) SaldoVencido
 				        from CRCMovimientoCuentaCorte mcc1
 				        where   Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )
						group by mcc1.Corte, mcc1.CRCCuentasid
 				        ) mcc
 			on c.id = mcc.CRCCuentasid
			 and c.Tipo != 'TM'
			inner join CRCCortes cc on mcc.Corte = cc.Codigo 
									and cc.Tipo in (
											select Tipo from CRCCortes where Codigo in (
												<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>
											)
									)
			left join (
				select CRCCuentasid, Corte 
				from CRCMovimientoCuentaCorte
				where Corte in (<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			) mcccr on c.id = mcccr.CRCCuentasid
 			<cfif  This.cuentaID neq "">
				  where  c.id = #This.cuentaID#
			</cfif>
 		</cfquery>
		 
 		<!--- en la cuenta el saldo actual que no son Mayoristas--->
 		<cfquery name="rActCuentaSA" datasource="#This.dsn#">
		 	update c set 
			c.SaldoActual = case when i.MOntoM > 0 then i.MOntoM else 0 end,
						 Compras       = 0,
						 GastoCobranza = 0,
						 Pagos         = 0
						 <cfif isdefined("this.isReproceso") and not this.isReproceso>
						 	,Condonaciones = 0 	
						 </cfif>	 		
			from CRCCuentas c
			inner join (select mcc1.Corte, mcc1.CRCCuentasid
 				        from CRCMovimientoCuentaCorte mcc1
 				        where   Corte in (<cfqueryparam value="#This.cortesACerrar#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )
						group by mcc1.Corte, mcc1.CRCCuentasid
 				        ) mcc
			on c.id = mcc.CRCCuentasid
				and c.Tipo != 'TM'
			inner join CRCCortes cc on mcc.Corte = cc.Codigo and cc.Tipo in (
									select Tipo from CRCCortes where Codigo in (
									<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			)
			inner join SNegocios sn on c.SNegociosSNid = sn.SNid
			inner join (select sum(Monto*case when TipoMov = 'D' then -1 else 1 end) as MOntoM, t.CRCCuentasid from CRCTransaccion t group by t.CRCCuentasid) i
				on i.CRCCuentasid = c.id
			inner join (
				select CRCCuentasid, Corte 
				from CRCMovimientoCuentaCorte
				where Corte in (<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			) mcccr on c.id = mcccr.CRCCuentasid
			
			<cfif  This.cuentaID neq "">
				  where c.id = #This.cuentaID#
			</cfif>
 			
 			
 		</cfquery> 	

		<!--- en la cuenta el saldo actual que son Mayoristas--->
		<cfquery name="rActCuentaSA" datasource="#This.dsn#">
		 	update c set 
			 SaldoActual = case when i.MOntoM > 0 then i.MOntoM else 0 end,
						 Compras       = 0,
						 GastoCobranza = 0,
						 Pagos         = 0,
						 Condonaciones = 0 		 		
			from CRCCuentas c
			inner join (select mcc1.Corte, mcc1.CRCCuentasid
 				        from CRCMovimientoCuentaCorte mcc1
 				        where   Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )
						group by mcc1.Corte, mcc1.CRCCuentasid
 				        ) mcc
			on c.id = mcc.CRCCuentasid
				and c.Tipo = 'TM'
			inner join CRCCortes cc on mcc.Corte = cc.Codigo and cc.Tipo in (
									select Tipo from CRCCortes where Codigo in (
									<cfqueryparam value="#This.cortesAnteriores#" cfsqltype="cf_sql_varchar" list="yes"/>)
			)
			inner join SNegocios sn on c.SNegociosSNid = sn.SNid
			inner join (select sum(Monto*case when TipoMov = 'D' then -1 else 1 end) as MOntoM, t.CRCCuentasid from CRCTransaccion t group by t.CRCCuentasid) i
				on i.CRCCuentasid = c.id
			inner join (
				select CRCCuentasid, Corte 
				from CRCMovimientoCuentaCorte
				where Corte in (<cfqueryparam value="#This.cortesAnteriores#" cfsqltype="cf_sql_varchar" list="yes"/>)
			) mcccr on c.id = mcccr.CRCCuentasid
			<cfif  This.cuentaID neq "">
				  where c.id = #This.cuentaID#
			</cfif>
 			
 			
 		</cfquery>
 	
 	</cffunction>


   <!--- <cffunction name="readProcessDate" returntype="void" hint="se busca la fecha para el corte, se busca en el fichero dev o la fecha actual">
 
 		<cfset This.fechaActual = ''>
 		<cftry>
 			<cfset strPath = GetDirectoryFromPath( GetCurrentTemplatePath())  & devFileName>
	    	<cfif FileExists(strPath)> 
		    	<cfset devDate = FileRead(strPath)>  
			    <cfif devDate neq "">   
			    	<cfset This.fechaActual = CreateDate(Mid(devDate,7,4),Mid(devDate,4,2),Mid(devDate,1,2))>  
			    </cfif>
			</cfif>	 
		<cfcatch>  
		</cfcatch>	
		</cftry>
			 
		<cfif This.fechaActual eq "">
			<cfset This.fechaActual = CreateDate(DatePart('yyyy',now()), DatePart('m',now()),DatePart('d',now()))>	
		</cfif> 
  
    </cffunction> --->

    <cffunction name="crearTransactionPorIntereses" returntype="void" hint="se crean transacciones por intereses generados en los cortes anteriores"> 
  		
 		<cfquery name="qMovCuentaInt" datasource="#This.dsn#">
 			select c.id cuentaID, c.Tipo, mc.Intereses, mc.Corte, t.Fecha FechaTransaccion, t.TipoTransaccion, t.id transaccionID,
			 	cc.FechaInicioSV, cc.FechaFinSV
			from  CRCMovimientoCuenta mc
			inner join CRCTransaccion t
			on mc.CRCTransaccionid = t.id
			inner join CRCCortes cc on mc.Corte = cc.Codigo and cc.Tipo in (
									select Tipo from CRCCortes where Codigo in(
									<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			)
			inner join CRCCuentas c
			on t.CRCCuentasid  = c.id
			left join (
				select CRCCuentasid, Corte 
				from CRCMovimientoCuentaCorte
				where Corte in (<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			) mcccr on c.id = mcccr.CRCCuentasid
			where mc.Intereses > 0
			and  mc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> ) 
			<cfif  This.cuentaID neq "">
				  and c.id = #This.cuentaID#
			</cfif>
		</cfquery>		

  		<cfif qMovCuentaInt.recordCount gt 0 > 
			<cfquery name="rsTipoTransaccionIN" datasource="#This.DSN#">
				select id, Codigo as Tipo_Transaccion, Descripcion, TipoMov, afectaSaldo, afectaInteres, afectaCompras, afectaPagos, afectaCondonaciones,afectaGastoCobranza
				from CRCTipoTransaccion where Codigo = '#This.C_TT_INTERESES#'
			</cfquery> 	

			<cfif rsTipoTransaccionIN.recordCount gt 0 >
				<cfloop query="qMovCuentaInt">
					
					<cfif qMovCuentaInt.Tipo eq 'TM'>
						<cfquery name="rsMaxCorte" dbtype="query">
							select max(Corte) as Corte, cuentaID
							from qMovCuentaInt
							where cuentaID = #qMovCuentaInt.CuentaId#
							group by cuentaID
						</cfquery>
					</cfif>

					<cfif (  qMovCuentaInt.Tipo eq 'TM' 
							and DateDiff('d', now(), qMovCuentaInt.FechaInicioSV) lte 0 
							and DateDiff('d', now(), qMovCuentaInt.FechaFinSV) gt 0
							and (isdefined("rsMaxCorte") and rsMaxCorte.recordCount gt 0)
							and qMovCuentaInt.Corte eq rsMaxCorte.Corte
						  )
							
							or (qMovCuentaInt.Tipo neq 'TM')
					>
					
						<cfset loc.FechaT = ''>
						<cfif qMovCuentaInt.TipoTransaccion eq #This.C_TT_MAYORISTA#>
							<cfset loc.FechaT = #qMovCuentaInt.FechaTransaccion#>
						<cfelse>
							<cfset loc.FechaT = obtenerFechaFinCorteACerrar(Tipo_Producto = #qMovCuentaInt.Tipo#)>   
						</cfif>

						<cfif loc.FechaT neq ''>

							<cfset loc.FechaT = CreateDate(DatePart('yyyy',#loc.FechaT#), DatePart('m',#loc.FechaT#),DatePart('d',#loc.FechaT#))>

							<cfset crearTransaccion(CuentaID 		   = #qMovCuentaInt.cuentaID#,
													Tipo_TransaccionID = #rsTipoTransaccionIN.id#, 
													Fecha_Transaccion  = #loc.FechaT#,  
													Monto         	   = #qMovCuentaInt.Intereses#, 
													Parcialidades 	   =  1, 
													Observaciones 	   =  '#rsTipoTransaccionIN.Descripcion#',
													Descripcion 	   =  '[#qMovCuentaInt.transaccionID#] - #rsTipoTransaccionIN.Descripcion#',
													usarTagLastID      = false,
													MontoAPagar        = #qMovCuentaInt.Intereses#,
													AfectaMovCuenta    = false)>  
						</cfif>
					</cfif>
				</cfloop>
				
				<!--- elimina las transacciones de interes generadas para el corte anterior, para volverlas a crear --->
				<!--- <cfquery  datasource="#This.dsn#">
					delete CRCTransaccion 
					where  TipoTransaccion = '#This.C_TT_INTERESES#'
					and    Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> ) 
				</cfquery>  

				<cfset scriptInsert = ''>
				<cfloop query="qMovCuentaInt">
					<cfset scriptInsert = scriptInsert & crearScriptTransacccion(CuentaID=qMovCuentaInt.cuentaID,
											Tipo_TransaccionID= rsTipoTransaccionIN.id,
											Tipo_Transaccion  = rsTipoTransaccionIN.Tipo_Transaccion,
											Tipo_Movimiento   = rsTipoTransaccionIN.TipoMov,
											Fecha_Transaccion=now(),
											Monto=qMovCuentaInt.Intereses, 
											Observaciones="Intereses generados en Corte:" & rsTipoTransaccionIN.Descripcion,
											afectaSaldo=iif(len(rsTipoTransaccionIN.afectaSaldo) eq 0, 0,rsTipoTransaccionIN.afectaSaldo),
											afectaInteres=iif(len(rsTipoTransaccionIN.afectaInteres) eq 0, 0,rsTipoTransaccionIN.afectaInteres),
											afectaCompras=iif(len(rsTipoTransaccionIN.afectaCompras) eq 0, 0,rsTipoTransaccionIN.afectaCompras),
											afectaPagos=iif(len(rsTipoTransaccionIN.afectaPagos) eq 0, 0,rsTipoTransaccionIN.afectaPagos),
											afectaCondonaciones=iif(len(rsTipoTransaccionIN.afectaCondonaciones) eq 0, 0,rsTipoTransaccionIN.afectaCondonaciones),
											afectaGastoCobranza=iif(len(rsTipoTransaccionIN.afectaGastoCobranza) eq 0, 0,rsTipoTransaccionIN.afectaGastoCobranza),  
											AfectaMovCuenta = false,
											Corte = qMovCuentaInt.Corte) & ";" >
				</cfloop> 

				<cfscript>
					QueryExecute(scriptInsert,[],{datasource="#This.DSN#"}); 
			 	</cfscript>				
				--->
		 	</cfif>
 		</cfif>  

    </cffunction>


    <cffunction name="actualizarCategoriaDistribuidor" access="private" hint="Actualiza la categoria del distribuidor">

    	<!-- buscar un corte de distirbuidor -->
    	<cfset loc.corteDistribuidor = ''>
    	<cfloop index="i" from="1" to="#ArrayLen(This.listadoCortesACerrar)#" step="1">  
    		<cfif  trim(This.listadoCortesACerrar[i].Tipo) eq trim(This.C_TP_DISTRIBUIDOR)>
    			<cfset loc.corteDistribuidor = #This.listadoCortesACerrar[i].Codigo#>
    		</cfif>  
		</cfloop>

		<cfif loc.corteDistribuidor neq ''> 
	    	<cfquery datasource="#This.DSN#"> 
				update ct set  ct.CRCCategoriaDistid =  isnull(case 
											when catc.CatId > ct.CRCCategoriaDistid
												then 
													case 
														when et.Orden <= (select Orden from CRCEstatusCuentas where id = #This.pLimiteEstadoCuentaPromosion#)
															then catc.CatId
														else ct.CRCCategoriaDistid
													end
												else
												   	catc.CatId
											end, (select top 1 id from CRCCategoriaDist where Ecodigo  = #THIS.Ecodigo# order by Orden))
				from CRCCuentas ct
				inner join CRCEstatusCuentas et
					on ct.CRCEstatusCuentasid = et.id
				inner join ( 
					select c.id as CuentaId, 
							CatId = (	select top 1 id 
										from CRCCategoriaDist
										where sum(isnull(t.Monto,0)) between MontoMin and 
											case 
												when (MontoMax is null or MontoMax = 0) then sum(isnull(t.Monto,0)) + 1
												else MontoMax
										end
									) , sum(isnull(t.Monto,0)) Monto 
					from CRCCuentas c
					left join CRCTransaccion t
						on c.id = t.CRCCuentasid
						and t.TipoTransaccion = '#This.C_TT_VALES#'
						and t.Fecha between (select distinct FechaInicio from CRCCortes where Codigo in (<cfqueryparam value="#loc.corteDistribuidor#" cfsqltype="cf_sql_varchar" list="yes"/> )) 
										and (select distinct FechaFin from CRCCortes where Codigo in (<cfqueryparam value="#loc.corteDistribuidor#" cfsqltype="cf_sql_varchar" list="yes"/> ))
					where  c.Tipo = '#This.C_TP_DISTRIBUIDOR#'
					group by c.id
				) catc
					on ct.id = catc.CuentaId
				<cfif  This.cuentaID neq "">
				  where c.id = #This.cuentaID#
			</cfif>
			</cfquery>
		
		</cfif>

    </cffunction>


    <cffunction name="actualizarEstadoCuenta" access="private" returntype="void" hint="actualiza el estado de la cuenta en dependencia de la informacion de saldo vencido">
		<cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
		<cfset statusConvenio = crcObjParametros.GetParametro(codigo='30100501',conexion=this.dsn,ecodigo=this.ecodigo)>

		<cfquery datasource="#This.dsn#" name="rsActulizaEstado" >
 			update ct set  			 
				ct.CRCEstatusCuentasid  = case when ct.Tipo = 'TC' and pm.MontoPagado < pm.MontoPagoMin
				then 
					case when et.Orden <= (
						select top 1 Orden 
						from CRCEstatusCuentas 
						where Orden > et.Orden 
						and Orden <= #This.pLimiteCambioEstadoCuenta#
						and  case ct.Tipo
							when '#This.C_TP_DISTRIBUIDOR#' then AplicaVales 
							when '#This.C_TP_TARJETA#'      then AplicaTC 
							when '#This.C_TP_MAYORISTA#'    then AplicaTM 
							end = 1
						order by Orden 
						) 
					then (
						select top 1 id 
						from CRCEstatusCuentas 
						where Orden > et.Orden 
						and Orden <= #This.pLimiteCambioEstadoCuenta#
						and  case ct.Tipo
							when '#This.C_TP_DISTRIBUIDOR#' then AplicaVales 
							when '#This.C_TP_TARJETA#'      then AplicaTC 
							when '#This.C_TP_MAYORISTA#'    then AplicaTM 
							end = 1
						order by Orden 
						)
					else ct.CRCEstatusCuentasid
					end
				when ct.SaldoVencido > 0 and ct.Tipo != 'TC'
				then 
					case when et.Orden <= (
						select top 1 Orden 
						from CRCEstatusCuentas 
						where Orden > et.Orden 
						and Orden <= #This.pLimiteCambioEstadoCuenta#
						and  case ct.Tipo
							when '#This.C_TP_DISTRIBUIDOR#' then AplicaVales 
							when '#This.C_TP_TARJETA#'      then AplicaTC 
							when '#This.C_TP_MAYORISTA#'    then AplicaTM 
							end = 1
						order by Orden 
						) 
					then (
						select top 1 id 
						from CRCEstatusCuentas 
						where Orden > et.Orden 
						and Orden <= #This.pLimiteCambioEstadoCuenta#
						and  case ct.Tipo
							when '#This.C_TP_DISTRIBUIDOR#' then AplicaVales 
							when '#This.C_TP_TARJETA#'      then AplicaTC 
							when '#This.C_TP_MAYORISTA#'    then AplicaTM 
							end = 1
						order by Orden 
						)
					else ct.CRCEstatusCuentasid
					end
				else
				( select top 1 id 
					from CRCEstatusCuentas 
					where case ct.Tipo
					when '#This.C_TP_DISTRIBUIDOR#' then AplicaVales 
					when '#This.C_TP_TARJETA#'      then AplicaTC 
					when '#This.C_TP_MAYORISTA#'    then AplicaTM 
					end = 1
					order by Orden
				)
				end
			from CRCCuentas ct
			inner join CRCEstatusCuentas et
			 on ct.CRCEstatusCuentasid = et.id
			inner join CRCMovimientoCuentaCorte mcc
			 on ct.id = mcc.CRCCuentasid  
			 and mcc.Corte in  (<cfqueryparam value="#This.cortesACerrar#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )  
			inner join (
				select mcc.CRCCuentasid, mcc.MontoAPagar, mcc.MontoPagado,
					case when   mcc.MontoAPagar < (
						select 
							isnull(
								case when pm.Porciento = 0 
									then pm.MontoPagoMin 
									else  mcc.MontoAPagar * (pm.MontoPagoMin/100) 
								end,(select p.Pvalor from CRCParametros p where p.Pcodigo = '30200501')) MontoPagoMin
						from CRCPagoMinimo pm where pm.SaldoMin <=  mcc.MontoAPagar and pm.SaldoMax >=  mcc.MontoAPagar and pm.Ecodigo = #this.ecodigo#
					) then mcc.MontoAPagar
					else 
						(select isnull(
							(
								select case when pm.Porciento > 0
										then  mcc.MontoAPagar * (pm.MontoPagoMin/100)
										else pm.MontoPagoMin
									end
								FROM CRCPagoMinimo pm
								WHERE pm.SaldoMin <= mcc.MontoAPagar
									AND pm.SaldoMax >= mcc.MontoAPagar
									AND pm.Ecodigo = #this.ecodigo#
							),
							mcc.MontoAPagar * (
												SELECT p.Pvalor
												FROM CRCParametros p
												WHERE p.Pcodigo = '30200501' and p.Ecodigo = #this.ecodigo#
							)/100) 
						)
					end MontoPagoMin
					from CRCMovimientoCuentaCorte mcc 
					inner join CRCCortes c on mcc.Corte = c.Codigo
						and c.Tipo in (select Tipo from CRCCortes 
											where Codigo in (<cfqueryparam value="#This.cortesACerrar#" 
															cfsqltype="cf_sql_varchar"
															list="yes"/>) )
					where mcc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
															cfsqltype="cf_sql_varchar"
															list="yes"/>)
			) pm on pm.CRCCuentasid = ct.id
			where ct.CRCEstatusCuentasid != #statusConvenio#
				and et.Orden <= #This.pLimiteCambioEstadoCuenta#
			<cfif  This.cuentaID neq "">
				  and ct.id = #This.cuentaID#
			</cfif> 		
			
		</cfquery>
		
    </cffunction>


    <cffunction name="calculoDeSeguroTarjeta" access="private" hint="se busca y guarda el valor de seguro de cada cuenta de tarjetas de credito y mayorista">
    	 

    	 <cfif This.pMontoSeguroVida neq ''>
	    	 <!--- se buscan todas las cuentas que tengan informacion en movimiento cuenta corte para los cortes a cerrar ---> 

	    	<cfquery name="qSeguro" datasource="#this.dsn#"> 
				select c.id cuentaID,  c.Tipo
				from CRCTCParametros cp
				inner join SNegocios sn
				on cp.SNegociosSNid = sn.SNid
				inner join CRCCuentas c
				on  c.SNegociosSNid =  sn.SNid
				where cp.CRCCuentasid = c.id
				and c.CRCEstatusCuentasid != (select Pvalor from CRCParametros where Pcodigo = '30100501' and Ecodigo = #this.ecodigo#)
				and  (  (c.Tipo = '#This.C_TP_TARJETA#'   and cp.TCSeguro = 1) or
					    (c.Tipo = '#This.C_TP_MAYORISTA#' and cp.TMSeguro = 1) 
					 )
				and  not exists (select 1 
					             from CRCMovimientoCuenta mc
					             inner join CRCTransaccion t
					             on t.id = mc.CRCTransaccionid
					             where t.CRCCuentasid  = c.id
					             and t.TipoTransaccion = '#This.C_TT_SEGUROV#'
					             and  mc.Corte in (<cfqueryparam value="#This.cortesACerrar#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> ) 
				                )

	    	</cfquery>
 		 
	    	<cfif qSeguro.recordCount gt 0>

		  		<cfquery name="qTipoTransaccion" datasource="#this.dsn#">
		  			select top 1 id, Descripcion from CRCTipoTransaccion
		  			where afectaSeguro = 1
		  			and   Codigo       = '#This.C_TT_SEGUROV#'
		  		</cfquery>    	

				<!--- se genera pone valor de seguro si es la fecha de seguro---> 
				<cfset loc.diaActual = DatePart('d',now())>      		

	    		<cfloop query="qSeguro">

	    			<cfset loc.ValorSeguro = 0> 
	    			<cfset loc.TipoCuenta  = trim(qSeguro.Tipo) > 

	    			<cfif loc.TipoCuenta eq This.C_TP_TARJETA >
 
						<cfset loc.ValorSeguro = This.pMontoSeguroVida> 
	 				
	 				<cfelseif loc.TipoCuenta eq This.C_TP_MAYORISTA and  #This.pDiaSeguroMayorista# eq #loc.diaActual#  >
	 					<cfset loc.ValorSeguro = #This.pMontoSeguroVida#>
	    			</cfif>
	 				  
	 				<cfif loc.ValorSeguro gt 0> 
	 					 
		    			<cfquery datasource="#this.dsn#">
					  		update 	CRCMovimientoCuentaCorte 
					  		set Seguro  = round(#loc.ValorSeguro#, 2)
					  		where   CRCCuentasid = #qSeguro.cuentaID# 
					  		and  Corte in  (<cfqueryparam value="#This.cortesACerrar#" 
									                cfsqltype="cf_sql_varchar"
									                list="yes"/> ) 
									             
		    			</cfquery>
	 
				  		<cfif qTipoTransaccion.recordCount gt 0 >

				  			<cfset loc.FechaT = ''>
				  			<cfif loc.TipoCuenta eq This.C_TP_TARJETA >
				  				<cfset loc.FechaT = obtenerFechaFinCorteACerrar(Tipo_Producto = '#qSeguro.Tipo#')>

				  				<cfif loc.FechaT neq ''>
									<cfset loc.FechaT = CreateDate(DatePart('yyyy',#loc.FechaT#), DatePart('m',#loc.FechaT#),DatePart('d',#loc.FechaT#))>
								</cfif>  
				  			</cfif>
	 
				  			<cfif loc.FechaT neq ''>
	 
			  					<cfset crearTransaccion(CuentaID 		   = #qSeguro.CuentaID#,
													    Tipo_TransaccionID = #qTipoTransaccion.id#, 
														Fecha_Transaccion  = #loc.FechaT#,  
														Monto         	   = #loc.ValorSeguro#, 
													    Parcialidades 	   =  1, 
													    Observaciones 	   =  '#qTipoTransaccion.Descripcion#',
													    usarTagLastID      = false)>  
	 
	 			  			</cfif>
					    </cfif>
	 
		    		</cfif>

	    		</cfloop>
	 
	    	</cfif>
         </cfif>
    </cffunction>

    <cffunction name="obtenerFechaFinCorteACerrar" access="private"  > 
    	<cfargument name="Tipo_Producto" required="true" type="string">


    	<cfset loc.FF_CorteCerrar = ''>
    	<cfloop index="i" from="1" to="#ArrayLen(This.listadoCortesACerrar)#" step="1">
 

    		<cfif trim(This.listadoCortesACerrar[i].tipo) eq trim(arguments.Tipo_Producto)>
    			<cfset loc.FF_CorteCerrar = #This.listadoCortesACerrar[i].FechaFin#> 
    		</cfif> 
		</cfloop>
 		
 		 
		<cfreturn #loc.FF_CorteCerrar#>

    </cffunction>


    
	<cffunction name="calculoDeSeguroDistribuidor" access="private" hint="se busca y guarda el valor de seguro para el distribuidor. Este valor es calculado ">
    	 
    	 <!--- se buscan todas las cuentas que tengan informacion en movimiento cuenta corte para los cortes a cerrar --->
    	<cfquery name="qSeguro" datasource="#this.dsn#"> 
			select c.id cuentaID, c.Tipo, mcc.MontoAPagar - (mcc.MontoPagado + mcc.Descuentos) MontoAPagar, cd.PorcientoSeguro, mcc.id mccID, cp.DSeguro
			from CRCTCParametros cp
			inner join SNegocios sn
			on cp.SNegociosSNid = sn.SNid
			inner join CRCCuentas c
			on  c.SNegociosSNid =  sn.SNid
			inner join CRCMovimientoCuentaCorte mcc
			on mcc.CRCCuentasid = c.id
			inner join CRCCategoriaDist cd
			on cd.id = c.CRCCategoriaDistid
			where mcc.Corte in (<cfqueryparam value="#This.cortesACerrar#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> )   
			and c.CRCEstatusCuentasid != (select Pvalor from CRCParametros where Pcodigo = '30100501' and Ecodigo = #this.ecodigo#)
			and  cp.CRCCuentasid = c.id
			and     (c.Tipo = '#This.C_TP_DISTRIBUIDOR#' and cp.DSeguro  = 1)
			and  mcc.MontoAPagar > mcc.MontoPagado + mcc.Descuentos 
			 

    	</cfquery> 
		
    	<cfif qSeguro.recordCount gt 0>
 
	  		<cfquery name="qTipoTransaccion" datasource="#this.dsn#">
	  			select top 1 id, Descripcion from CRCTipoTransaccion
	  			where afectaSeguro = 1
	  			and   Codigo       = '#This.C_TT_SEGURO#'
	  		</cfquery>    	

			<!--- se genera pone valor de seguro si es la fecha de seguro---> 
			<cfset loc.diaActual = DatePart('d',now())>      		

    		<cfloop query="qSeguro">

    			<cfset loc.ValorSeguro = 0> 
    			<cfset loc.TipoCuenta  = trim(qSeguro.Tipo) > 

    			<!--- and qSeguro.DMontoValeCredito neq '' and  qSeguro.DCreditoAbierto neq '' --->
    			<cfif loc.TipoCuenta eq This.C_TP_DISTRIBUIDOR>

    				<!--- el porciento de seguro se buscan en categorias del distribuidor ----> 
    			    <cfset loc.ValorSeguro = qSeguro.MontoAPagar * qSeguro.PorcientoSeguro / 100 >
    
    			</cfif>
 				 

 				<cfif loc.ValorSeguro gt 0> 
 					 
	    			<cfquery datasource="#this.dsn#">
				  		update 	CRCMovimientoCuentaCorte 
				  		set Seguro = round(#loc.ValorSeguro#, 2)
				  		where   id = #qSeguro.mccID# 
	    			</cfquery>
 
			  		<cfif qTipoTransaccion.recordCount gt 0 >
 
		  				<cfset loc.FechaT = obtenerFechaFinCorteACerrar(Tipo_Producto = '#qSeguro.Tipo#')> 
		  				<cfif loc.FechaT neq ''>
							<cfset loc.FechaT = CreateDate(DatePart('yyyy',#loc.FechaT#), DatePart('m',#loc.FechaT#),DatePart('d',#loc.FechaT#))>
						</cfif>  
			  			    
			  			<cfif loc.FechaT neq ''>


			  				<cfset crearTransaccion(CuentaID 		   = #qSeguro.CuentaID#,
												    Tipo_TransaccionID = #qTipoTransaccion.id#, 
													Fecha_Transaccion  = #loc.FechaT#,  
													Monto         	   = #loc.ValorSeguro#, 
												    Parcialidades 	   =  1, 
												    Observaciones 	   =  '#qTipoTransaccion.Descripcion#',
												    usarTagLastID      = false,
												    MontoAPagar        = #loc.ValorSeguro#)>   
			  			</cfif>
 
				    </cfif>
 
	    		</cfif>

    		</cfloop>
 
    	</cfif>
	</cffunction>

 

    <cffunction name="genearGAstoAutomaticoCobranza" returntype="void" access="private" hint="despues de x Cortes no ha pagado hacer un gasto de cobranza de manera automatica">

		<cfif This.pAplicarGC eq 'S' and This.pCantidadCortesAplicarGC neq '' and This.pValorGC neq '' >
  		
  
    		<cfquery name="qCortesAut" datasource="#this.dsn#">
    			select up.id CRCCuentasid, up.Tipo, 
					cr.Codigo, 
					case when (
								select min(t.FechaInicioPago) FechaInicioPago
								from CRCTransaccion t
								where TipoMov = 'C' and FechaInicioPago > up.Fecha and t.CRCCuentasid = up.id
								group by t.CRCCuentasid
						) > up.Fecha 
						then
							(
								select min(t.FechaInicioPago) FechaInicioPago
								from CRCTransaccion t
								where TipoMov = 'C' and FechaInicioPago > up.Fecha and t.CRCCuentasid = up.id
								group by t.CRCCuentasid
							)
						else up.Fecha 
					end Fecha,
					cc.Codigo CorteHasta, isnull(mcc.MontoPagado,0) MontoPagado,
					cantidad = (select count(1) -1 from CRCCortes where Codigo between cr.Codigo and cc.Codigo)
				from 
				(
					select c.id, c.Tipo,   
						isnull(max(t.Fecha) , (
							select min(FechaInicioPago) 
							from CRCTransaccion 
							where TipoMov = 'C' and CRCCuentasid = c.id)
						) Fecha
					from CRCCuentas c
					left join CRCTransaccion t  on t.CRCCuentasid = c.id and TipoTransaccion = 'PG' and t.ReversaId is null
					where c.SaldoActual > 0 and c.Tipo <> 'TM'
					and c.CRCEstatusCuentasid != (select Pvalor from CRCParametros where Pcodigo = '30100501' and Ecodigo = #this.ecodigo#)
					group by c.id, c.Tipo
				) up
				inner join CRCCortes cr on 
					case when (
								select min(t.FechaInicioPago) FechaInicioPago
								from CRCTransaccion t
								where TipoMov = 'C' and FechaInicioPago > up.Fecha and t.CRCCuentasid = up.id
								group by t.CRCCuentasid
						) > up.Fecha 
						then
							(
								select min(t.FechaInicioPago) FechaInicioPago
								from CRCTransaccion t
								where TipoMov = 'C' and FechaInicioPago > up.Fecha and t.CRCCuentasid = up.id
								group by t.CRCCuentasid
							)
						else up.Fecha 
					end between cr.FechaInicio and cr.FechaFin and up.Tipo = cr.Tipo
				inner join (
					select Codigo, Tipo from CRCCortes where Codigo in (<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
				) cc on cr.Tipo = cc.Tipo
				inner join (
						select t.CRCCuentasid, mc.Corte, isnull(sum(mc.Pagado),0) MontoPagado
						from CRCMovimientoCuenta mc 
						inner join CRCTransaccion t on mc.CRCTransaccionid = t.id 
						where mc.CRCConveniosid is null and mc.Corte IN (<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
						group by t.CRCCuentasid,mc.Corte
				) mcc on up.id = mcc.CRCCuentasid 
				where ( select sum(MontoPagado) - sum(SaldoVencido)  
						from CRCMovimientoCuentaCorte 
						where CRCCuentasid = up.id and Corte BETWEEN cr.Codigo AND cc.Codigo
				) <= 0<!--- and cr.Codigo = mcc.Corte --->
				and (select count(1) -1 from CRCCortes where Codigo between cr.Codigo and cc.Codigo) >= #This.pCantidadCortesAplicarGC#
				<cfif  This.cuentaID neq "">
				  	and up.id = #This.cuentaID#
				</cfif> 
    			<!--- select c.Tipo, mcc.CRCCuentasid, count(Corte) cantidad, isnull(sum(mcc.MontoPagado),0) MontoPagado
    			FROM   CRCMovimientoCuentaCorte mcc 
    			inner join CRCCuentas c
    			on c.id = mcc.CRCCuentasid 
    			where  mcc.Corte in (select top #This.pCantidadCortesAplicarGC# cr.Codigo
    				                 from CRCCortes cr
    				                 where (cr.status = 2 or cr.status = 3)
    				                 and   cr.Tipo =  c.Tipo
    				                 order by cr.FechaFin desc) 
    			group by  mcc.CRCCuentasid,c.Tipo --->
				</cfquery>
				
    		<cfif qCortesAut.recordCount gt 0 >
				<cfquery name="q_TipoTransaccion" datasource="#This.DSN#">
					select id, Descripcion
					from   CRCTipoTransaccion
					where  Codigo = 'GC'
					and afectaGastoCobranza = 1
					and	TipoMov = '#This.CREDITO#'
				</cfquery>	  
 
				<cfif q_TipoTransaccion.recordCount gt 0>  
					<cfset loc.TransaccionGCID = q_TipoTransaccion.ID>
					<cfset loc.TransaccionGCDESC = q_TipoTransaccion.Descripcion>

					<cfloop query="#qCortesAut#">

 						<cfif qCortesAut.cantidad gte #This.pCantidadCortesAplicarGC# and qCortesAut.MontoPagado eq 0>

							<cfset loc.FechaT = ''> 
			  				<cfset loc.FechaT = obtenerFechaFinCorteACerrar(Tipo_Producto = #qCortesAut.Tipo#)>

			  				<cfif loc.FechaT neq ''>
								<cfset loc.FechaT = CreateDate(DatePart('yyyy',#loc.FechaT#), DatePart('m',#loc.FechaT#),DatePart('d',#loc.FechaT#))>
							</cfif>  
				  		  
				  			<cfif loc.FechaT neq ''> 							
								
								<cfset loc.tranID = crearTransaccion(CuentaID=qCortesAut.CRCCuentasid,
										Tipo_TransaccionID = #loc.TransaccionGCID#,
										Fecha_Transaccion= #loc.FechaT#,
									    Monto = #This.pValorGC#, 
										Descuento = 0,
									    Observaciones = "#loc.TransaccionGCDESC#",
										usarTagLastID = false,
										AfectaMovCuenta = true)>
	  						</cfif>
	  					</cfif>
					</cfloop>

				</cfif>
    		</cfif>


    	</cfif>

    </cffunction>

 
    <cffunction name="registerLog">
    	<cfargument name="texto" type="string" required="true">
		<cfargument name="tipo" type="string" required="false" default="Information">

    	<cflog file="procesoCorte" application="no" text="#arguments.texto#" type="#arguments.tipo#">
		<cfset logStack = '#logStack# #arguments.texto# <br>'>
    </cffunction>

    


    <cffunction name="eliminarDetallesCondNoAplicadas" hint="Se eliminan los detalles de las condonaciones no aplicadas">
  
    	<cfquery datasource="#this.dsn#">
    		delete  cd
    		from CRCCondonacionDetalle cd
    		inner join CRCCondonaciones c
    		on c.id = cd.CRCCondonacionesid
    		where  c.CondonacionAplicada <> 1
    	</cfquery>

    	<cfquery datasource="#this.dsn#"> 
    		update CRCCondonaciones set estado = 'V'
    		where  CondonacionAplicada <> 1 
    	</cfquery>

    </cffunction>


    <cffunction name="vencerConveniosNoAplicados" hint="Se pasan a estado vencido los convenios no aplicados">
    
    	<cfquery datasource="#this.dsn#"> 
    		update CRCConvenios set estado = 'V'
    		where  ConvenioAplicado <> 1 
    	</cfquery>

    </cffunction>  

	<cffunction name="calculaDescuentoSaldo" returntype="numeric">
		<cfargument name="monto" type="numeric" required="true" >
		<cfargument name="porciento" type="numeric" required="true" >
		<cfset rDescuento = arguments.monto * arguments.porciento /100>
		
		<cfreturn rDescuento>
	</cffunction>  
 

  </cfcomponent>