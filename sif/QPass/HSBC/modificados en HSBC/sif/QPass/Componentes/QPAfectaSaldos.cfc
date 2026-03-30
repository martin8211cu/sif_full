<cfcomponent output="no">
	<!--- Proceso de Cálculo de Movimientos y Afectacion de Saldos de Cuentas para modulo Quick Pass --->
	
	<!---
		Documentación:
			El proceso ejecuta por un tiempo máximo de 15 minutos.
			Se dispara mediante una tarea programada automática que debe de ejecutarse cada minuto durante el horario de operación
			definido para la entidad bancaria o entidad administradora de los dispositivos.
			
			Si transcurridos 15 minutos el proceso no ha terminado, automáticamente se "sale" del proceso
			para permitir que otro proceso automático inicie su funcionamiento.
			
			Se controla si el proceso se está ejecutando mediante una bandera a nivel del scope "application"
			
			Si la bandera indica que está operando, y tiene menos de 15 minutos de haber arrancado, se sale de la función. 
			En caso de que esté "operando" hace más de 15 minutos, se permite la ejecución del proceso nuevamente
	--->
	
	<cffunction name="ProcesaMovimiento" access="public" returntype="boolean" output="no">
		<cfargument name="Conexion" type="string" required="yes">

		<cfsetting requesttimeout="900">
        <cfapplication name="SIF_ASP" 
            sessionmanagement="Yes"
            clientmanagement="No"
            setclientcookies="Yes"
            sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

		<cfset LvarFechaMaxima  = dateadd("s",840,now())>

		<cflock scope="application" type="exclusive" timeout="5">
			<cfif isdefined("Application.QPAplicandoProcesaMovimiento") and Application.QPAplicandoProcesaMovimiento EQ 1>
				<cfset LvarFechaControl = Application.QPFechaProcesaMovimiento>
				<cfset LvarFechaControl = dateadd("s",910,LvarFechaControl)>
        		<cfif LvarFechaControl GT now()>
					<cfreturn false>
				</cfif>
			</cfif>
			<cfset Application.QPFechaProcesaMovimiento = now()>
			<cfset Application.QPAplicandoProcesaMovimiento = 1>
		</cflock>

		<!--- Este ID se controla para la base de datos.  Por eso se usa en Ecodigo = 0 --->		
		<cfquery name="_rsUltimoId" datasource="#Arguments.Conexion#">
			select Pvalor
			from QPParametros
			where Ecodigo = 0
			  and Pcodigo = 9999
		</cfquery>
		
		<cfif len(trim(_rsUltimoId.Pvalor)) GT 0>
			<cfset LvarUltimoId = _rsUltimoId.Pvalor>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				insert into QPParametros (Ecodigo, Pcodigo, Mcodigo, Pvalor, Pdescripcion)
				values (0, 9999, 'TP', '0', 'Ultimo Registro de Movimientos Aplicado en la tarea automática')
			</cfquery>
			<cfset LvarUltimoId = 0>
		</cfif>

		<cfset LvarNuevoId = fnProcesaMovimientos(LvarUltimoId, Arguments.Conexion)>
		
		<cflock scope="application" type="exclusive" timeout="5">
			<cfquery datasource="#Arguments.Conexion#">
				update QPParametros 
					set Pvalor = '#LvarNuevoId#'
				where Ecodigo = 0
				  and Pcodigo = 9999
			</cfquery>
			<cfset Application.QPAplicandoProcesaMovimiento = 0>
		</cflock>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="fnProcesaMovimientos" access="private" output="no" returntype="numeric">
		<cfargument name="ArgUltimoId" type="numeric" required="yes">
		<cfargument name="Conexion"	 	type="string" required="yes">

		<cfset LvarQPMCid = Arguments.ArgUltimoId>

		<cfquery name="_rsMovimientosTag" datasource="#Arguments.Conexion#">
			select QPMCid
			from QPMovCuenta 
			where QPMCid >= #Arguments.ArgUltimoId#
			  and QPMCFProcesa is null
			order by QPMCid
		</cfquery>		
		
		<cfloop query="_rsMovimientosTag">
			<cfset LvarQPMCid = _rsMovimientosTag.QPMCid>
			<cfif LvarFechaMaxima LTE now()>
				<cfreturn LvarQPMCid>
			</cfif>
			<cfset fnAfectaMovimiento(LvarQPMCid, Arguments.Conexion)>
		</cfloop>
		
		<cfreturn LvarQPMCid>
	</cffunction>
	
	<cffunction name="fnAfectaMovimiento" access="private" output="no" returntype="boolean">
		<cfargument name="QPMCid" 		type="numeric" required="yes">
		<cfargument name="Conexion"	 	type="string" required="yes">
	
		<!--- 
			Esto se debe de manejar en una transacción por cada registro 
				1. Se debe de bloquear el registro de Movimiento. Para esto, se actualiza la fecha de proceso del registro
				2. Si la fecha de aplicación del registro es nula, se procesa.  En caso contrario, se termina la ejecución de la funcion
				3. Se calcula el monto local si no está calculado
				4. Con el monto local se afecta el saldo de la cuenta
				5. Se graba el valor de monto local ( si no estaba calculado ), y las fechas de control en el registro de movimiento
			Se cierra la transaccion
		--->
		<cftransaction action="begin">
			<cfquery name="_rsActualizaRegistroBloquea" datasource="#Arguments.Conexion#">
				update QPMovCuenta 
				set QPMCFProcesa = #now()#
				where QPMCid = #arguments.QPMCid#
				  and QPMCFProcesa is null
				  and QPMCFAfectacion is null
			</cfquery>
			
			<cfquery name="_rsActualizaRegistroLectura" datasource="#Arguments.Conexion#">
				select QPctaSaldosid , Mcodigo , QPMCMonto , QPMCMontoLoc , QPMCSaldoMonedaLocal, QPMCFInclusion 
				from QPMovCuenta 
				where QPMCid = #arguments.QPMCid#
				  and QPMCFAfectacion is null
			</cfquery>
			
			<cfif _rsActualizaRegistroLectura.recordcount LT 1>
				<cftransaction action="rollback"/>
				<cfreturn false>
			</cfif>
			
			<cfquery name="_rsObtieneSaldoCuenta" datasource="#Arguments.Conexion#">
				select QPctaSaldosSaldo as SaldoActual
				from QPcuentaSaldos 
				where QPctaSaldosid = #_rsActualizaRegistroLectura.QPctaSaldosid#
			</cfquery>
			
			<cfif len(trim(_rsActualizaRegistroLectura.QPMCMontoLoc)) EQ 0 or _rsActualizaRegistroLectura.QPMCMontoLoc EQ 0>
				<!--- Actualiza el monto de la columna con la conversión de momeda --->
				<cfquery name="_rsObtieneConversion" datasource="#Arguments.Conexion#">
					select TCventa
					from Htipocambio
					where Mcodigo = #_rsActualizaRegistroLectura.Mcodigo#
                      and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#_rsActualizaRegistroLectura.QPMCFInclusion#">
					  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#_rsActualizaRegistroLectura.QPMCFInclusion#">
				</cfquery>
				<cfif _rsObtieneConversion.recordcount NEQ 1>
					<cfset LvarQPMCMontoLoc = NumberFormat(_rsActualizaRegistroLectura.QPMCMonto , "9.00")>
				<cfelse>
					<cfset LvarQPMCMontoLoc = NumberFormat(_rsActualizaRegistroLectura.QPMCMonto * _rsObtieneConversion.TCventa, "9.00")>
                </cfif>
			<cfelse>
				<cfset LvarQPMCMontoLoc = _rsActualizaRegistroLectura.QPMCMontoLoc>
			</cfif>	
			
			
			<cfset LvarQPMCSaldoMonedaLocal = _rsObtieneSaldoCuenta.SaldoActual + LvarQPMCMontoLoc>

			<cfquery name="_rsObtieneSaldoCuenta" datasource="#Arguments.Conexion#">
				update QPcuentaSaldos
				set QPctaSaldosSaldo = round(#LvarQPMCSaldoMonedaLocal#, 2)
				where QPctaSaldosid = #_rsActualizaRegistroLectura.QPctaSaldosid#
			</cfquery>

			<!--- Actualiza el registro de movimientos con la fecha de afectacion y el saldo después del movimiento --->
			<cfquery name="_rsActualizaRegistroBloquea" datasource="#Arguments.Conexion#">
				update QPMovCuenta 
					set 
						QPMCFAfectacion = #now()#,
					 	QPMCMontoLoc    = #LvarQPMCMontoLoc#,
						QPMCSaldoMonedaLocal = round(#LvarQPMCSaldoMonedaLocal#, 2)
				where QPMCid = #arguments.QPMCid#
			</cfquery>
			
		</cftransaction>
	
		<cfreturn true>
	</cffunction>
	
</cfcomponent>