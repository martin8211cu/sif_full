<!--- 
	Documentación:
	Tabla de Control:
		a. QPListaControl: que llevará el control de los lotes procesados y pendientes de procesar.
					Contiene los siguienes Campos:
							qplc_id:				Número de lote generado.
							qplc_origen: 			SOIN o HSBC
							qplc_fecha_ingreso: 	Fecha en que se invoca la tarea programada “ActualizaListaEntrada”
							qplc_cant_registros: 	cuenta todos los tags postpagos que se van a incluir en la tabla QPListaEntrada.
							qplc_estado: 			Estado de proceso.										
														1-Incluido											
														2-Listo para Procesar por sistema destino
														3-Procesando (Espera de Respuesta)
														4-En proceso de actualización de datos (para mantener bloqueos de control )
														5-Procesado y disponible para actualización de sistema origen
														6-Procesado por Sistema Origen
							qplc_fecha_proceso1: 	Fecha Hora Proceso para estado 3 - Fecha en que se actualiza al estado 3.
							qplc_fecha_proceso2: 	Fecha Hora Proceso para estado 5 - Fecha en que se actualiza al estado 5.
							qplc_fecha_proceso3: 	Fecha Hora Proceso para Estado 6 - Fecha en que se actualiza al estado 6.

	
	Tabla de entrada:
		b. QPListaEntrada: 
					Contiene los siguienes Campos:
							qpldc_id: 				Secuencial del registro hijo. 
							qplc_id: 				Número de lote en el cual fue generado.
							qpldc_tipo_mov: 		1 =  Actualizacion de listas
							qpldc_ente: 			ID del cliente que el banco utiliza a nivel interno.
							qpldc_identificacion: 	Identificación registrada en QuickPass.
							qpldc_cuenta: 			Número de cuenta COBIS registrada en QuickPass
							qpldc_fecha: 			Fecha de cuando se inserta el registro en esta tabla.
							qpldc_descripcion: 		Descripción del movimiento. 
							qpldc_PAN: 				Número o Código de Dispositivo
							qpldc_Tag: 				Número interno del QuickPass


	
	
	Tabla de Salida:
		c.QPListaSalida: 
					Contiene los siguienes Campos:
							qpdlc_id: 				Secuencial del registro hijo. 
							qplc_id: 				Número de lote en el cual fue generado.
							qpdlc_tipo_mov: 		1= Actualizacion de listas
							qpdlc_ente: 			ID del cliente que el banco utiliza a nivel interno.
							qpdlc_cuenta: 			Número de cuenta.
							qpdlc_fecha_consulta: 	fecha que el banco devuelve el registro.
							qpdlc_cod_error: 		Código si generó error
							qpdlc_desc_cod_error: 	Descripción del código.
							qpdlc_lista: 			Código de la lista a ser incluido el cliente
							qpdlc_estado: 			Control de Procesamiento en Sistema Origen:
														0: No procesado
														1: Procesado
							qpdlc_PAN:				Número o Código del Dispositivo
							qpdlc_Tag: 				Número interno del QuickPass
	
Funciones:
	fnProcesaConsultaSalida: 			Proceso de registros enviados por el Banco.
	fnResultadoConsultaDatosInterfaz: 	Recibe los resultados de las consutlas enviadas por la Interfaz al Banco.
	fnConsultaSaldosInterfaz: 			Envia a Consultar Saldos por la Interfaz al Banco.

--->

<cfcomponent output="no">
	<cffunction name="fnProcesaConsultaSalida" access="private" output="no"  returntype="numeric" description="Proceso de registros enviados por el Banco">
		<cfargument name="conexion" 			type="string" 	required="yes">
        <cfargument name="Ecodigo" 				type="numeric" 	required="yes">
		<cfargument name="qplc_id"				type="numeric"	required="yes">
		<cfargument name="qpdlc_id"				type="numeric"	required="yes">

		<!--- Procesar cada registro de la tabla QPListaSalida que esté en estado 0 :  Pendiente de Procesar
			1. Actualizar en la tabla QPassTag el color de la lista de todos los registros procesados.
		--->

		<cfquery name="rsConsultaDatosSalida" datasource="#Arguments.conexion#">
			select 
				s.qpdlc_id, 		
				s.qpdlc_tipo_mov, 	
				s.qpdlc_ente,
				s.qpdlc_cuenta, 	
				s.qpdlc_cod_error, 
				s.qpdlc_desc_cod_error,
				s.qpdlc_lista, 
				s.qpdlc_PAN,
                s.qpdlc_Tag
			from QPListaSalida s
			where s.qpdlc_id 		= #arguments.qpdlc_id#
			  and s.qplc_id 			= #Arguments.qplc_id#
			  and s.qpdlc_estado 	= 0
		</cfquery>

		<cfloop query="rsConsultaDatosSalida">
			<cfset LvarQPTidTag = rsConsultaDatosSalida.qpdlc_Tag>

			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select max(QPvtaTagid) as QPvtaTagid
				from QPventaTags a
				where QPTidTag = #LvarQPTidTag#
				  and QPvtaEstado = 1				
			</cfquery>
			
			<cfif len(trim(rs.QPvtaTagid)) LT 1>
				<cfreturn 0>
			</cfif>

			<!--- Actualiza datos del Cliente ( Ente ) --->
            <!--- <cfif len(trim(rsConsultaDatosSalida.qpdlc_ente))>
                <cfquery datasource="#Arguments.Conexion#">
                    update QPcliente
                    set QPCente = #rsConsultaDatosSalida.qpdlc_ente#
                    where QPcteid = #LvarQPcteid#
                </cfquery>
            </cfif>			 --->
            
            <!--- Actualiza datos del TAG ( Lista en la que debe estar ) --->
            <cfquery datasource="#Arguments.Conexion#">
                update QPassTag
                set QPTlista = '#rsConsultaDatosSalida.qpdlc_lista#'
                where QPTidTag = #LvarQPTidTag#
            </cfquery>
            <!--- Actualiza el registro de QPListaSalida  para evitar que sea reprocesado --->
            <cfquery datasource="#Arguments.Conexion#">
                update QPListaSalida
                set qpdlc_estado = 1
                where qpdlc_id = #rsConsultaDatosSalida.qpdlc_id#
                  and qpdlc_estado = 0
            </cfquery>
    	</cfloop>
    	<cfreturn 1>
	</cffunction>

	<cffunction name="fnResultadoConsultaDatosInterfaz" access="public" output="no" returntype="numeric" description="Recibe los resultados de las consutlas enviadas por la Interfaz al Banco">
		<cfargument name="conexion" 			type="string" 	required="yes">
        <cfargument name="Ecodigo" 				type="numeric" 	required="yes">

        <cfapplication name="SIF_ASP" 
            sessionmanagement="Yes"
            clientmanagement="No"
            setclientcookies="Yes"
            sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

		<cfsetting requesttimeout="3600">  <!--- Una hora maximo de proceso --->

		<!--- 
			Verificar si existen procesos pendientes listos para ser aplicados en el sistema - que provienen de la interfaz.
			Si Existen, procesa cada uno de los grupos de registros para que afecten el sistema
			Los registros para procesar están en estado 5
		--->
		<cfquery name="rsProcesoPendiente" datasource="#Arguments.Conexion#">
        	select qplc_id, qplc_fecha_ingreso, qplc_estado
            from QPListaControl
            where qplc_origen = 1
			  and qplc_estado = 5
        </cfquery>

        <cfif isdefined("rsProcesoPendiente") and rsProcesoPendiente.Recordcount EQ 0>
        	<cfreturn 0>
        </cfif>

		<cfloop query="rsProcesoPendiente">
			<cfquery name="rsDatos" datasource="#Arguments.conexion#">
				select 
					s.qpdlc_id
				from QPListaSalida s
				where s.qplc_id = #rsProcesoPendiente.qplc_id#
				  and s.qpdlc_estado = 0
			</cfquery>

			<cfloop query="rsDatos">
            		<cftransaction action="begin">
						<cfset fnProcesaConsultaSalida(arguments.conexion, arguments.ecodigo, rsProcesoPendiente.qplc_id, rsDatos.qpdlc_id)>
                    </cftransaction>
			</cfloop>
			
			<!--- Actualiza registro de control si no hay registros de detalle sin procesar. --->
			<cfquery name="_rsEstadoProcesoPendiente" datasource="#Arguments.conexion#">
				select count(1) as Cantidad
				from QPListaControl c
					inner join QPListaSalida s
					on s.qplc_id = c.qplc_id
				where c.qplc_id = #rsProcesoPendiente.qplc_id#
				  and c.qplc_estado 		= 5
				  and c.qplc_origen 		= 1
				  and s.qpdlc_estado 	= 0
			</cfquery>

			<cfif _rsEstadoProcesoPendiente.Cantidad EQ 0>
					<cfquery datasource="#arguments.conexion#">
						update QPListaControl
						set 
							qplc_fecha_proceso3	= #now()#, 
							qplc_estado			= 6
						where qplc_id = #rsProcesoPendiente.qplc_id#
						  and qplc_estado = 5
						  and qplc_origen = 1
					</cfquery>
			</cfif>
		</cfloop>
		<cfreturn 1>
	</cffunction>
    
	<cffunction name="fnConsultaSaldosInterfaz" output="no" access="public" returntype="numeric" description="Envia a Consultar Saldos por la Interfaz al Banco">
		<cfargument name="conexion" 			type="string" 	required="yes">
        <cfargument name="Ecodigo" 				type="numeric" 	required="yes">
        <cfargument name="qpldc_tipo_mov" 		type="numeric" 	required="no" default="1">

        <cfapplication name="SIF_ASP" 
            sessionmanagement="Yes"
            clientmanagement="No"
            setclientcookies="Yes"
            sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
		<cfsetting RequestTimeout = "14400">

        <cfquery name="rsParametro" datasource="#arguments.conexion#">
            select Pvalor
            from QPParametros
            where Ecodigo = #Arguments.Ecodigo#
              and Pcodigo = 9997
		</cfquery>
        
        <cfif rsParametro.recordcount eq 0>
    		<cfset LvarFechaDesde = createdate(2000, 1, 1)>
            <cfquery datasource="#arguments.conexion#">
                insert QPParametros (Ecodigo, Pcodigo, Pvalor, Pdescripcion, Mcodigo)
                values (#Arguments.Ecodigo#, 9997, #LvarFechaDesde#, 'Hora de la ultima ejecucion de Consultas de Saldos con el Banco', 'QP')
            </cfquery>
        <cfelse>
	        <cfset LvarFechaDesde = rsParametro.Pvalor>	
        </cfif>

		<cfset LvarFechaDesde = createdate(2000, 1, 1)>
        <cfset LvarFechaProceso  = #now()#>	
        <cfset LvarFechaHasta = dateadd('s', -5, #LvarFechaProceso#)>

		<!--- 
			Verificar si existen procesos pendientes en Espera de Respuesta por sistema destino.
			Si Existen, debe de esperar a que el proceso termine antes de continuar nuevamente
			porque el proceso puede que no este concluido y generaria registros duplicados
		--->
		<cfquery name="rsVerificaProcesoPendiente" datasource="#Arguments.Conexion#">
        	select qplc_id, qplc_fecha_ingreso, qplc_estado
            from QPListaControl
            where qplc_origen = 1
			  and qplc_estado > 1
              and qplc_estado < 6
        </cfquery>

        <cfif isdefined("rsVerificaProcesoPendiente") and rsVerificaProcesoPendiente.Recordcount GT 0>
        	<cfreturn 0>
        </cfif>

		<cfquery name="rsVerificaProcesoPendiente" datasource="#Arguments.Conexion#">
        	select qplc_id, qplc_fecha_ingreso, qplc_estado
            from QPListaControl
			where qplc_origen = 1
			  and qplc_estado = 1
			order by qplc_fecha_ingreso
        </cfquery>
        
        <cfif isdefined("rsVerificaProcesoPendiente") and rsVerificaProcesoPendiente.Recordcount GT 0>
			<cfloop query="rsVerificaProcesoPendiente">
				<!--- 
					Si existe un registro de control, y la fecha tiene menos de 1 hora de haberse insertado
					Se regresa el control sin procesar para esperar a que termine el proceso
					
					Si no se ha cambiado el estado a 2 en una hora, se debe de asumir que el proceso no termino ( ver cfsetting que tiene 240 minutos )
					y por lo tanto debe de eliminar el registro de control porque ya no será procesado
						
				--->
				<cfif dateadd('h', 1, rsVerificaProcesoPendiente.qplc_fecha_ingreso) GTE now()>
					<cfreturn 0>
				</cfif> 
	
				<cfquery datasource="#Arguments.Conexion#">
					delete from QPListaControl
					where qplc_id = #rsVerificaProcesoPendiente.qplc_id#
					  and Ecodigo = #Arguments.Ecodigo#
					  and qplc_origen = 1
					  and qplc_estado = 1
				</cfquery>
			</cfloop>
        </cfif>



            <cfquery name="rsQPListaControl" datasource="#arguments.conexion#">
                insert into QPListaControl (
                    qplc_origen,
                    qplc_fecha_ingreso,
                    qplc_cant_registros,
                    qplc_estado
                    )
               values(
                    1,
                    #now()#,
                    0,
                    1 <!--- 1-Incluido --->
                   )
                   <cf_dbidentity1 datasource="#arguments.conexion#" verificar_transaccion="no">
            </cfquery>
            <cf_dbidentity2 datasource="#arguments.conexion#" name="rsQPListaControl" verificar_transaccion="no">
     
            <cfquery name="rsRegistros" datasource="#arguments.conexion#">
                 insert into QPListaEntrada(
                        qplc_id,
                        qpldc_tipo_mov,
                        qpldc_ente,
                        qpldc_identificacion,
                        qpldc_cuenta, 
                        qpldc_fecha,
                        qpldc_descripcion,
                        qpldc_PAN,
                        qpldc_Tag
                     )
                select 
                	#rsQPListaControl.identity# 	as id,
                    1              					as tipo_mov, <!--- 1 Actualizacion de listas --->
                    cl.QPCente   					as ente,
                    cl.QPcteDocumento				as identificacion,
                    substring(cb.QPctaBancoNum,1,20) as cuenta,
                    #now()# 						as fecha,
                    'Consulta de Saldo' 			as descripcion,
                    mv.QPTPAN,
                    mv.QPTidTag
                from QPventaTags vt
                    inner join QPassTag mv
                    on mv.QPTidTag = vt.QPTidTag

                    inner join QPcuentaSaldos cs
                    on cs.QPctaSaldosid = vt.QPctaSaldosid

                    inner join QPcliente cl
                   	on cl.QPcteid = vt.QPcteid

                    inner join QPcuentaBanco cb
                    on cb.QPctaBancoid = cs.QPctaBancoid 
                
                where vt. Ecodigo = #Arguments.Ecodigo#
                  and vt.QPvtaEstado = 1
                  and cs.QPctaSaldosTipo = 1
			</cfquery>

			<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
            <cfset javaRT.gc()>

            <cfquery datasource="#arguments.conexion#">
            	update QPListaControl
                set	qplc_cant_registros 	= coalesce( (select count(1) 
                										from QPListaEntrada e 
                                                    	where e.qplc_id = QPListaControl.qplc_id), 0),
                    qplc_estado			= 2,
                    qplc_fecha_ingreso	= #now()#
                where qplc_id = #rsQPListaControl.identity#
            </cfquery>

            <cfquery name="rsCantidad" datasource="#arguments.conexion#">
                select count(1) as cantidad
                from QPListaEntrada
                where qplc_id = #rsQPListaControl.identity#
            </cfquery>
    
            <cfif rsCantidad.cantidad eq 0>
                <cfquery datasource="#arguments.conexion#">
                    delete from QPListaControl
                    where qplc_id = #rsQPListaControl.identity#
                </cfquery>
            <cfelse>
	            <cfquery datasource="#arguments.conexion#">
                    update QPParametros
                    set Pvalor = #LvarFechaHasta#
                    where Ecodigo = #Arguments.Ecodigo#
                      and Pcodigo = 9997
            	</cfquery>
		    </cfif>
		<cfreturn 1>
	</cffunction>
</cfcomponent>