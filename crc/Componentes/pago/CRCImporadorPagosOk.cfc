<cfcomponent output="false" displayname="CRCImporadorPagos" >


	<cfset This.dsn       = ''>
	<cfset This.ecodigo   = ''>
	<cfset This.usucodigo = ''>

	<cffunction name="init" access="public" hint="se pasa como parametro la informacion a utlizar en todos los procesos">
		<cfargument name="dsn"       type="string" required="no" default="#Session.DSN#">
		<cfargument name="ecodigo"   type="string" required="no" default="#Session.Ecodigo#">
		<cfargument name="usucodigo" type="string" required="no" default="#Session.Usucodigo#">

		<cfset This.dsn       = arguments.dsn>
		<cfset This.ecodigo   = arguments.ecodigo>
		<cfset This.usucodigo = arguments.Usucodigo>

	</cffunction>

	<cffunction  name="ImportarPagosExternos">
		<cfargument name="pagos"    	type="array" 		required="yes">
		<cfargument name="form"			type="struct" 	required="yes">
		<cfargument name="TImportado"	type="numeric" 		required="yes">
		<cfargument name="Origen"		type="string" 		default="">
		<cfargument name="offsetLine"	type="numeric" 		default="0">
		<cfargument name="ecodigo"		type="string" 		default="#session.ecodigo#">
		<cfargument name="dsn"			type="string" 		default="#session.dsn#">
		<cfargument name="usucodigo"	type="numeric" 		default="#session.Usucodigo#">

		<cfset init(arguments.dsn,arguments.ecodigo,arguments.usucodigo)>

		<cfset errores = "">
		<cftransaction>
			<cfset _count = 1>
			<cfloop array="#arguments.pagos#" index="index" item="item">
				<cfset errorID = "#_count#0#arguments.pagos[index].Cuenta#">
				<cfset resultado = "">
				
				<cfset resultado = ImportarPagoExterno(
					fecha			= arguments.pagos[index].fecha
					, NumCuenta		= arguments.pagos[index].Cuenta
					, monto			= arguments.pagos[index].monto
					, ID_Caja		= form.ID_Caja
					, Codigo_CCT	= form.CCTCodigo
					, ID_CFuncional	= form.CFid
					, Codigo_Moneda	= form.MCodigo
					, Tipo_Cambio	= form.TCambio
					, ID_Tarjeta	= form.ID_Tarjeta
					, ID_Zona		= form.ID_Zona
					, offsetLine	= arguments.offsetLine
					, errorID		= errorID
					, Origen		= arguments.Origen
				)>
				<cfset _count += 1>
				<cfif resultado neq ''>
					<cftransaction action="rollback">
					<cfset errores = "#errores#¬#resultado#">
				</cfif>
			</cfloop>
		</cftransaction>
		<cfreturn errores>
	</cffunction>

	<cffunction  name="ImportarPagoExterno">
		<cfargument name="fecha"    	type = "date"		required="yes">
		<cfargument name="NumCuenta"    type = "string" 		required="yes">
		<cfargument name="monto"    	type = "string" 		required="yes">

		<cfargument name="ID_Caja"    		type = "numeric" 		required="yes">
		<cfargument name="Codigo_CCT"    	type = "string" 		required="yes">
		<cfargument name="ID_CFuncional"    type = "numeric" 		required="yes">
		<cfargument name="Codigo_Moneda"    type = "numeric" 		required="yes">
		<cfargument name="Tipo_Cambio"    	type = "numeric" 		required="yes">
		<cfargument name="ID_Tarjeta"    	type = "numeric" 		required="yes">
		<cfargument name="ID_Zona"    		type = "numeric" 		required="yes">
		
		<cfargument name="offsetLine"	type="numeric" 		default="0">
		<cfargument name="errorID"		type="numeric" 		default="#datetimeFormat(Now(),'yymmddHHnnssL')#">
		<cfargument name="ecodigo"		type="string" 		default="#session.ecodigo#">
		<cfargument name="dsn"			type="string" 		default="#session.dsn#">
		<cfargument name="usucodigo"	type="numeric" 		default="#session.Usucodigo#">
		<cfargument name="Observacion"	type="string" 		default="Pago importado el #DateFormat(Now(),'yyyy-mm-dd')#">
		<cfargument name="Origen"		type="string" 		default="">
		<cfargument name="generaMovBancario"	type="boolean" 		default=true>
		<cfargument name="debug"	type="boolean" 		default="false">


		<cfset arguments.NumCuenta = right("0000000000#arguments.NumCuenta#", 10)> 

		<cfset init(arguments.dsn,arguments.ecodigo,arguments.usucodigo)>
		
		<cfset error = "">

		<cfset componentPath = "crc.Componentes.CRCCuentas">
		<cfset objCuenta = createObject("component","#componentPath#")>
		
		<!--- Obtener datos de caja--->
		<cfquery name="q_Caja" datasource="#this.dsn#">
			select 
				  t.RIserie
				, c.Ccuenta
				, t.Tid
			from FCajas c 
				inner join TipoTransaccionCaja tc
					on tc.FCid = c.FCid
				inner join Talonarios t
					on tc.Tid = t.Tid
			where
				c.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CAJA#">
				and c.ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#this.ecodigo#">
				and tc.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Codigo_CCT#">
		</cfquery>
		<cfif q_Caja.recordCount eq 0>
			<cfthrow message="No se encontro una Caja">
		</cfif>

		<!--- Datos del Centro Funcional --->
		<cfquery name="q_CFuncional" datasource="#this.dsn#">
			select Ocodigo from CFuncional where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CFuncional#">
		</cfquery>
<cfif arguments.debug>
	<cfdump  var="#q_Caja#" label="Caja">
</cfif>
		<!--- Datos del Periodo Auxiliar --->
		<cfquery name = "rsPERIODOAUX" datasource = "#this.dsn#">
			SELECT  Pvalor as Periodo
			from Parametros
			where Pcodigo = 50
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#" >
		</cfquery>
		

		<!--- Obtener el Departamento --->
		<cfquery name="q_Dep" datasource="#this.dsn#">
			select Dcodigo from Departamentos where ecodigo = #this.ecodigo#
		</cfquery>

		<cfset ETnumero = "N/A">

		<cftry>

			<!--- Datos del Socio de Negocio --->
			<cfquery name="q_SN" datasource="#this.dsn#">
				select 
					sn.SNCodigo
					, sn.SNRetencion
					, sn.id_direccion
					, c.id as cta_id
					, g.DEid
					, g.FechaAsignacion
					, DATEADD(D,30,g.FechaAsignacion) as FechaHasta
					, DATEDIFF(D,DATEADD(D,30,g.FechaAsignacion), Cast ( '#DateFormat(fecha,"yyyy-mm-dd")#' as Date)) as DiffDays
					, g.PorcentajeCobranzaAntes
					, g.PorcentajeCobranzaDespues
					, c.CRCCategoriaDistid as catidCta
					, c.Tipo as tipoCta
				from CRCCuentas c
					inner join SNegocios sn
						on sn.SNid = c.SnegociosSNid
					inner join (
						select
							c.id
							, ISNULL(c.DatosEmpleadoDEid,ISNULL(c.DatosEmpleadoDEid2,-1)) as DEid
							, ISNULL(Cast(c.FechaGestor as date),ISNULL(cast(c.FechaAbogado as date),null)) as FechaAsignacion
							, de.PorcentajeCobranzaAntes
							, de.PorcentajeCobranzaDespues
						from CRCCuentas c
							left join DatosEmpleado de
								on de.DEid = ISNULL(c.DatosEmpleadoDEid,ISNULL(c.DatosEmpleadoDEid2,-1))
						where right(concat('0000000000',c.Numero),10) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NumCuenta#"> ) as g
						on g.id = c.id
				where right(concat('0000000000', c.Numero),10) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NumCuenta#"> and c.Ecodigo = #this.Ecodigo# 
			</cfquery>
			
<cfif arguments.debug>
	<cfdump  var="#q_SN#" label="Datos Cuenta">
</cfif>
			<cfif q_SN.recordCount eq 0>
				<cfthrow message="No se encontro una Cuenta o Socio de Negocio para la Cuenta [#arguments.NumCuenta#] linea [#(index + arguments.offsetLine)#]">
			</cfif>

			<!--- Obtener datos del corte del pago --->
			<cfquery name="q_Corte" datasource="#this.dsn#">
				select Codigo, FechaInicio, FechaFin
				from CRCCortes where Ecodigo = #this.Ecodigo# 
					and '#DateFormat(arguments.fecha,"yyyy-mm-dd")#' between FechaInicio and DateAdd(D,1,FechaFin)
					and Tipo = '#q_SN.tipoCta#'
			</cfquery>
<cfif arguments.debug>
	<cfdump  var="#q_Corte#" label="Corte de Pago">
</cfif>			
			<!--- Montos de Pago--->
			<cfset porcDesc = 0>
			<cfif trim(q_SN.tipoCta) eq 'D'>
				<cfset porcDesc = objCuenta.getPorcientoDescuento(arguments.fecha,q_SN.catidCta,q_Corte.Codigo,this.dsn,this.ecodigo)>
			</cfif>

<cfif arguments.debug>
	<cfdump  var="#porcDesc#" label="Porciento Descuento">
</cfif>

			<cfset LvarETtotal   	= arguments.monto>
			<cfset LvarETmontodes  	= arguments.monto * (porcDesc/100)>
			<cfset LvarETUnitario  	= arguments.monto + LvarETmontodes>
			<cfset LvarETimpuesto  	= 0>
			<cfset LvarETDescrip  	= arguments.Observacion>

			<!--- Fecha de Pago--->
			<cfset LvarDescDate  = LSDateFormat(arguments.fecha,'YYYYMMDD')>
			<cfset LvarDescTime  = LSTimeFormat(arguments.fecha, 'HH:mm:ss')>
			<cfset LvarFecha     = LvarDescDate &' '& LvarDescTime>

			<cfset CRCGestor = ''>
			<cfset CRCPorcCom = 0>
			<cfif q_SN.DEid ge 0>
				<cfset CRCGestor = q_SN.DEid>
				<cfif q_SN.DiffDays le 0>
					<cfset CRCPorcCom = q_SN.PorcentajeCobranzaAntes>
				<cfelse>
					<cfset CRCPorcCom = q_SN.PorcentajeCobranzaDespues>
				</cfif>
			</cfif>

			<cfcookie name="Socio"     value="#q_SN.SNcodigo#">

			<cfif not isNumeric(q_SN.id_direccion)>
				<cf_ErrorCode code="-1"  msg="La direccion es requerida.">
			</cfif>

	<!--- Insertar Encabezado de Transaccion --->
		
			<cfquery name="Insert_ET" datasource="#this.dsn#">
				insert ETransacciones (
						FCid
						, Ecodigo
						, Ocodigo
						, SNcodigo
						, Mcodigo 
						, ETtc
						, CCTcodigo
						, Ccuenta
						, Tid
						, ETfecha
						, ETtotal
						, ETestado
						, Usucodigo
						, Ulocalizacion
						, Usulogin
						, ETporcdes
						, ETmontodes
						, ETimpuesto
						, ETobs
						, ETdocumento
						, ETserie
						, CFid
						, ETexterna
						, id_direccion
						, CodSistemaExt
						, ETperiodo
						, ETobservacion
				) values (
						<!--- FCid --->					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CAJA#">
						<!--- Ecodigo --->				, <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
						<!--- Ocodigo --->				, <cfqueryparam cfsqltype="cf_sql_integer" value="#q_CFuncional.Ocodigo#">
						<!--- SNcodigo --->				, <cfqueryparam cfsqltype="cf_sql_integer" value="#q_SN.SNcodigo#">
						<!--- Mcodigo --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Codigo_Moneda#">
						<!--- ETtc --->					, <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Tipo_Cambio#">
						<!--- CCTcodigo --->			, <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Codigo_CCT#">
						<!--- Ccuenta --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Caja.Ccuenta#">
						<!--- Tid --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Caja.Tid#">
						<!--- ETfecha --->				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fecha#">
						<!--- ETtotal --->				, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETtotal#">
						<!--- ETestado --->				, <cfqueryparam cfsqltype="cf_sql_char" value="P"> <!--- P pendiente, C cobrada, A anulada--->
						<!--- Usucodigo --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#this.Usucodigo#">
						<!--- Ulocalizacion --->		, <cfqueryparam cfsqltype="cf_sql_char" value="00">
						<!--- Usulogin --->				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">
						<!--- ETporcdes --->			, 0
						<!--- ETmontodes --->			, <cfqueryparam cfsqltype="cf_sql_money" value="0">
						<!--- ETimpuesto --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETimpuesto#">
						<!--- ETobs --->				, rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarETDescrip#">))
						<!--- ETdocumento --->			, <cfqueryparam cfsqltype="cf_sql_integer" value="0000">
						<!--- ETserie --->				, <cfqueryparam cfsqltype="cf_sql_char" value="#q_Caja.RIserie#">
						<!--- CFid --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CFuncional#">
						<!--- ETexterna --->			, <cfqueryparam cfsqltype="cf_sql_char" value="N">
						<!--- id_direccion --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_SN.id_direccion#">
						<!--- CodSistemaExt --->		, <cfqueryparam cfsqltype="cf_sql_varchar" value="ERP-MAN">
						<!--- ETperiodo --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPERIODOAUX.Periodo#">      
						<!--- ETobservacion --->		, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Origen#">     
				)
				<cf_dbidentity1 datasource="#this.dsn#">
			</cfquery>
			<cf_dbidentity2 datasource="#this.dsn#" name="Insert_ET" returnvariable="ETnumero">


	<!--- Insertar Detalle de Transaccion --->

			<cfquery name="Insert_DT" datasource="#this.dsn#">
				insert DTransacciones (
						FCid
						, ETnumero
						, Ecodigo
						, DTtipo
						, Dcodigo
						, DTfecha
						, DTcant
						, DTpreciou
						, DTdeslinea
						, DTreclinea
						, DTtotal
						, DTborrado
						, DTdescripcion
						, CFid
						, Ocodigo
						, DTestado
						, DTimpuesto
						, CRCCuentaid
						, CRCConceptoPago
						<cfif CRCGestor neq ''>
							, CRCDEid
							, CRCDEidPorc
						</cfif>
					) values (
						<!--- FCid --->				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CAJA#">
						<!--- ETnumero --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
						<!--- Ecodigo --->			, <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
						<!--- DTtipo --->			, <cfqueryparam cfsqltype="cf_sql_char" value="C">
						<!--- Dcodigo --->			, <cfqueryparam cfsqltype="cf_sql_integer" value="#q_Dep.Dcodigo#">
						<!--- DTfecha --->			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fecha#">
						<!--- DTcant --->			, <cfqueryparam cfsqltype="cf_sql_float" value="1">
						<!--- DTpreciou --->		, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETUnitario#">
						<!--- DTdeslinea --->		, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETmontodes#">
						<!--- DTreclinea --->		, <cfqueryparam cfsqltype="cf_sql_money" value="0">
						<!--- DTtotal --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETtotal#">
						<!--- DTborrado --->		, <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						<!--- DTdescripcion --->	, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarETDescrip#">
						<!--- CFid --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CFuncional#">
						<!--- Ocodigo --->			, <cfqueryparam cfsqltype="cf_sql_integer" value="#q_CFuncional.Ocodigo#">
						<!--- DTestado --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="V">
						<!--- DTimpuesto --->		, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETimpuesto#">
						<!--- CRCCuentaid --->		, <cfqueryparam cfsqltype="cf_sql_integer" value="#q_SN.cta_id#">
						<!--- CRCConceptoPago --->	, <cfqueryparam cfsqltype="cf_sql_varchar" value="O">
													<cfif CRCGestor neq ''>
						<!--- CRCDEid --->				, <cfqueryparam cfsqltype="cf_sql_money" value="#CRCGestor#">
						<!--- CRCDEidPorc --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#CRCPorcCom#">
													</cfif>
					)
			</cfquery>

		<!--- Insertar Pago --->
			<cfquery name="Insert_FP" datasource="#this.dsn#">
				insert into FPagos(
							FCid
						, ETnumero
						, Mcodigo
						, FPtc
						, FPmontoori
						, FPmontolocal
						, FPfechapago
						, Tipo
						, FPdocnumero
						, FPdocfecha
						, FPtipotarjeta
						, FPautorizacion
						, FPagoDoc
						, FPfactorConv
						, FPVuelto
					)values(
						<!---  FCid ---> 			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CAJA#">
						<!--- ETnumero --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
						<!--- Mcodigo --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Codigo_Moneda#">
						<!--- FPtc --->				, <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Tipo_Cambio#">
						<!--- FPmontoori --->		, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETtotal#">
						<!--- FPmontolocal --->		, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETtotal#">
						<!--- FPfechapago --->		, <cfqueryparam cfsqltype="cf_sql_date" value="#DateTimeFormat(arguments.fecha,"yyyy-mm-dd hh:nn:ss")#">
						<!--- Tipo --->				, <cfqueryparam cfsqltype="cf_sql_varchar" value="T">
						<!--- FPdocnumero --->		, <cfqueryparam cfsqltype="cf_sql_varchar" value="0000-0000-0000-0000">
						<!--- FPdocfecha --->		, <cfqueryparam cfsqltype="cf_sql_date" value="1969-12-31">
						<!--- FPtipotarjeta --->	, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID_Tarjeta#">
						<!--- FPautorizacion --->	, <cfqueryparam cfsqltype="cf_sql_varchar" value="0000">
						<!--- FPagoDoc --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETtotal#">
						<!--- FPfactorConv --->		, <cfqueryparam cfsqltype="cf_sql_float" value="1">
						<!--- FPVuelto --->			, <cfqueryparam cfsqltype="cf_sql_money" value="0">
					)
			</cfquery>

			<cfquery datasource="#this.dsn#">
				update ETransacciones set ETestado = 'T' where ETnumero = #ETnumero# and ecodigo = #this.ecodigo#;
			</cfquery>

		<!--- Aplicar Pago --->

			<cfquery name="rsLineasDetalleAplicar" datasource="#Session.DSN#">
				select *
				from DTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
					and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_CAJA#">
					and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
					and DTborrado = 0
			</cfquery>
			<cfset objPago = createObject("component", "crc.Componentes.pago.CRCTransaccionPago").init(DSN=#this.DSN#, Ecodigo=#this.Ecodigo#)>
			
			<!--- Se crea tabla temporal para guardar el desglose del pago --->
			<cfset createTable = objPago.Create_CRCDESGLOSE()>
<cfif arguments.debug>
	<cfdump  var="#rsLineasDetalleAplicar#" label="rsLineasDetalleAplicar">
</cfif>			
			<cfloop query="rsLineasDetalleAplicar">
				<cfset objPago.pago( 
					  CuentaID		 = rsLineasDetalleAplicar.CRCCuentaid
					, Monto			 = rsLineasDetalleAplicar.DTtotal
					, MontoDescuento = rsLineasDetalleAplicar.DTdeslinea
					, Observaciones	 = rsLineasDetalleAplicar.DTdescripcion
					, FechaPago 	 = rsLineasDetalleAplicar.DTfecha
					, FCid 			 = arguments.ID_CAJA
					, ETnumero 		 = ETnumero
					, debug 		 = arguments.debug
				)> 
			</cfloop>
			<cfquery name="rsContabilizaFacturaDigital" datasource="#this.dsn#">
				select coalesce(Pvalor,'0') as usa
				from Parametros
				where Pcodigo = 16372
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#" >
			</cfquery>
			<cfif isDefined("rsContabilizaFacturaDigital.usa") and rsContabilizaFacturaDigital.usa eq 1>
				<cfset ContabilizarTransa = "conta">
			<cfelse>
				<cfset ContabilizarTransa = "aplica">
			</cfif>

			<!--- Invocar al componente de pagos--->

			<cfinvoke component="crc.Componentes.pago.CRCFuncionesPago"  method="AplicarTransaccionPago">
				<cfinvokeargument name="ETnumero" value="#ETnumero#">
				<cfinvokeargument name="FCid" value="#arguments.ID_CAJA#">
				<cfinvokeargument name="Contabilizar" value="#ContabilizarTransa#">
				<cfinvokeargument name="PrioridadEnvio" value="0">
				<!--- Se envia FAFC en CPNAPmoduloOri para aplicar pagado en poliza de ingresos--->
				<cfinvokeargument name="CPNAPmoduloOri" value="FAFC">
				<cfinvokeargument name="ModuloOrigen" value="CRC_NothingToDo">
				<cfinvokeargument name='generaMovBancario' value="#arguments.generaMovBancario#">
			</cfinvoke>
		<cfcatch type="any">
			<cfset error = "#(index + arguments.offsetLine)#~#errorID#~#ETnumero#~#cfcatch.message#">
			<cfif trim(ETnumero) neq 'N/A'>
				<cfquery datasource="#this.dsn#">
					update Etransacciones set ETobs = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarETDescrip#: Transaccion fallida #arguments.errorID#: #mid(cfcatch.message,1,100)#">)) where ETnumero = #ETnumero# and Ecodigo = #this.ecodigo#
					update Dtransacciones set DTdescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarETDescrip#: Transaccion fallida #arguments.errorID#: #mid(cfcatch.message,1,100)#">))where ETnumero = #ETnumero# and Ecodigo = #this.ecodigo#
				</cfquery>
			</cfif>
		</cfcatch>
		</cftry>
		<cfreturn error>
	</cffunction>

	<cffunction  name="getCaja">
		<cfargument  name="ecodigo" default="#Session.Ecodigo#">
		<cfargument  name="dsn" default="#Session.dsn#">

		<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
		<cfset Caja = objParams.GetParametroInfo('30200506')>
		<cfif Caja.codigo eq ''><cfthrow message="El parametro [30200506: Caja para Importador de Pagos] no existe"></cfif>
		<cfif Caja.valor eq ''><cfthrow message="El parametro [30200506: Caja para Importador de Pagos] no tiene valor"></cfif>

		
		<cfquery name="q_Caja" datasource="#arguments.DSN#">
			select top(1)
				c.FCid
				, c.FCcodigo
				, c.FCdesc
				, zv.nombre_zona
				, zv.id_zona
				, cf.CFid
				, cf.CFcodigo
				, cf.CFdescripcion
			from FCajas c
				inner join Oficinas o
				on c.Ocodigo = o.Ocodigo
				inner join  ZonaVenta zv
				on zv.id_zona = o.id_zona
				inner join CFuncional cf
					on c.Ocodigo = cf.Ocodigo
					and c.Ecodigo = cf.Ecodigo
			where 	c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
				and c.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Caja.valor#" >
		</cfquery>
		<cfreturn q_Caja>
	</cffunction>

	<cffunction  name="getTarjeta">
		<cfargument  name="ecodigo" default="#Session.Ecodigo#">
		<cfargument  name="dsn" default="#Session.dsn#">

		<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
		<cfset Tarjeta = objParams.GetParametroInfo('30200507')>
		<cfif Tarjeta.codigo eq ''><cfthrow message="El parametro [30200507: Tarjeta para Importador de Pagos en Oxxo] no existe"></cfif>
		<cfif Tarjeta.valor eq ''><cfthrow message="El parametro [30200507: Tarjeta para Importador de Pagos en Oxxo] no esta definido"></cfif>

		<cfquery name="q_Tarjeta" datasource="#arguments.dsn#">
			select * from FATarjetas where FATid = #Tarjeta.valor#
		</cfquery>
		
		<cfreturn q_Tarjeta>

	</cffunction>

	<cffunction  name="getTipoTransaccion">
		<cfargument  name="ID_Caja" required="true">
		<cfargument  name="ecodigo" default="#Session.Ecodigo#">
		<cfargument  name="dsn" default="#Session.dsn#">

		<cfquery name="q_TiposTransaccion" datasource="#arguments.DSN#">
			select a.CCTcodigo, b.CCTdescripcion, coalesce(<cf_dbfunction name="to_char" args="a.Tid">,'') as Tid
			from TipoTransaccionCaja a, CCTransacciones b, FAtransacciones c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ID_Caja#">
				and a.Ecodigo = b.Ecodigo
				and a.CCTcodigo = b.CCTcodigo
				and b.CCTcodigo = c.CCTcodigo
				and a.Ecodigo = b.Ecodigo
				and b.Ecodigo = c.Ecodigo
				and exists( select 1 from Talonarios t
						where t.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
						and t.Tid = a.Tid)
		</cfquery>
		<cfreturn q_TiposTransaccion>
	</cffunction>

	<cffunction  name="getPagoExtMetadata">
		<cfargument  name="html" default="true">
		<cfargument  name="dsn" default="#session.dsn#">
		<cfargument  name="ecodigo" default="#session.ecodigo#">
		<cfargument  name="pagosBanco" default="false">

		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset LB_Caja 				= t.Translate('LB_Caja','Caja')>
		<cfset LB_Tarjeta 			= t.Translate('LB_Tarjeta','Tarjeta')>
		<cfset LB_Zona 				= t.Translate('LB_Zona','Zona')>
		<cfset LB_CFuncional 		= t.Translate('LB_CFuncional','C. Funcional')>
		<cfset LB_Transaccion 		= t.Translate('LB_Transaccion','Transaccion')>
		<cfset LB_Moneda 			= t.Translate('LB_Moneda','Moneda')>
		<cfset LB_TipoCambio 		= t.Translate('LB_TipoCambio','Tipo de Cambio')>
		<cfset LB_Referenciado 		= t.Translate('LB_Referenciado','Referenciado')>
		<cfset LB_NoReferenciado 		= t.Translate('LB_NoReferenciado','No Referenciado')>

		<cfset q_Caja = getCaja(arguments.ecodigo,arguments.dsn)>
		<cfset q_Tarjeta = getTarjeta(arguments.ecodigo,arguments.dsn)>
		<cfset q_TiposTransaccion = getTipoTransaccion(q_Caja.FCid,arguments.ecodigo,arguments.dsn)>

		<cfif arguments.html>
			<cfsavecontent variable = "PagosExtMetadata"> 
				<table>
					<tr>
						<td align="right"><cfoutput>#LB_Caja#:&nbsp;</cfoutput> </td>
						<td height="20">
							<input type="hidden" name="id_caja" value="<cfoutput>#q_Caja.FCid#</cfoutput>">
							<strong><cfoutput>(#trim(q_Caja.FCcodigo)#) #trim(q_Caja.FCdesc)#</cfoutput></strong>
						</td>
						<td>&emsp;&emsp;&emsp;</td>
						<td align="right"><cfoutput>#LB_Tarjeta#:&nbsp;</cfoutput> </td>
						<td height="20">
							<input type="hidden" name="id_tarjeta" value="<cfoutput>#q_Tarjeta.FATid#</cfoutput>">
							<strong><cfoutput>(#trim(q_Tarjeta.FATcodigo)#) #trim(q_Tarjeta.FATdescripcion)#</cfoutput></strong>
						</td>
					</tr>
					<tr>
						<td align="right"><cfoutput>#LB_Zona#:&nbsp;</cfoutput> </td>
						<td height="20">
							<input type="hidden" value="<cfoutput>#q_Caja.id_zona#</cfoutput>" name="id_zona">
							<strong><cfoutput>#q_Caja.nombre_zona#</cfoutput></strong>
						</td>
						<td>&emsp;&emsp;&emsp;</td>
						<td align="right"><font size="2"><cfoutput>#LB_Transaccion#</cfoutput>:&nbsp;</font> </td>
						<td>
							<select name="CCTcodigo">
								<cfloop query="q_TiposTransaccion">
									<cfoutput>
										<option value="#q_TiposTransaccion.CCTcodigo#">#q_TiposTransaccion.CCTdescripcion#</option>
									</cfoutput>
								</cfloop>
							</select>
						</td>
					<tr>
					</tr>
						<td align="right"><font size="2"><cfoutput>#LB_Moneda#</cfoutput>:&nbsp;</font> </td>
						<td>
							<cf_sifmonedas cualTC="C" onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="4" style="width:150px">
						</td>
						<td>&emsp;&emsp;&emsp;</td>
						<td align="right"><font size="2"><cfoutput>#LB_CFuncional#</cfoutput>:&nbsp;</font> </td>
						<td>
							<!--- <cf_cboCFid form="form1" tabindex="1"> --->
							<cf_conlis
								Campos="CFid,CFcodigo,CFdescripcion"
								values="#q_Caja.CFid#,#q_Caja.CFcodigo#,#q_Caja.CFdescripcion#"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								Size="0,10,20"
								tabindex="5"
								Title="Lista de Centros Funcionales"
								Tabla="CFuncional cf
								inner join Oficinas o
								on o.Ecodigo=cf.Ecodigo
								and o.Ocodigo=cf.Ocodigo"
								Columnas="distinct cf.CFid,cf.CFcodigo,Concat(cf.CFdescripcion,' (Oficina: ',rtrim(o.Oficodigo),')') as CFdescripcion"
								Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
								Desplegar="CFcodigo,CFdescripcion"
								Etiquetas="Codigo,Descripcion"
								filtrar_por="cf.CFcodigo,CFdescripcion"
								Formatos="S,S"
								Align="left,left"
								form="form1"
								Asignar="CFid,CFcodigo,CFdescripcion"
								Asignarformatos="S,S,S,S"
							/>
						</td>
					</tr>
					<tr>
						<td align="right"><font size="2"><cfoutput>#LB_TipoCambio#</cfoutput>:&nbsp;</font> </td>
						<td>
							<input type="text" name="TCambio" size="5" value="1.0" onkeypress="return soloNumeros(event);">
						</td>
					</tr>
					<cfif Arguments.PagosBanco>
						<tr>
							<td align="right"><font size="2"><cfoutput>#LB_Referenciado#</cfoutput>:&nbsp;</font> </td>
							<td>
								<input type="checkbox" name="esReferenciado" id="esReferenciado" onclick="referenciados(1);">
							</td>
						</tr>
						<tr>
							<td align="right"><font size="2"><cfoutput>#LB_NoReferenciado#</cfoutput>:&nbsp;</font> </td>
							<td>
								<input type="checkbox" name="noEsReferenciado" id="noEsReferenciado"  onclick="referenciados(0);">
							</td>
						</tr>
					</cfif>
				</table>
			</cfsavecontent>
		<cfelse>

			<cfquery name="q_moneda" datasource="#arguments.dsn#">
				select Mcodigo from Empresas where Ecodigo = #arguments.ecodigo#
			</cfquery>

			<cfset PagosExtMetadata = structNew()>
			<cfset PagosExtMetadata.ID_Caja 		= q_Caja.FCid>
			<cfset PagosExtMetadata.Codigo_CCT 		= q_TiposTransaccion.CCTcodigo>
			<cfset PagosExtMetadata.ID_CFuncional 	= q_Caja.CFid>
			<cfset PagosExtMetadata.Codigo_Moneda 	= q_moneda.Mcodigo>
			<cfset PagosExtMetadata.Tipo_Cambio 	= 1>
			<cfset PagosExtMetadata.ID_Tarjeta 		= q_Tarjeta.FATid>
			<cfset PagosExtMetadata.ID_Zona 		= q_Caja.id_zona>
		</cfif>

		<cfreturn PagosExtMetadata>

	</cffunction>

</cfcomponent>