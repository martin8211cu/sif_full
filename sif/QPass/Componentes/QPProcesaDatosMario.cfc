<!--- 
	Documentación:
	Tabla de Control:
		qpl_id				Numeric		Número de lote generado. (identity)
		qpl_origen			Integer		1 -  SOIN / Banco
										2 -  Banco / SOIN
		qpl_fecha_ingreso	Datetime	Fecha de ingreso. 
		qpl_cant_registros	Integer		Cantidad de registros hijos generados por este lote.
		qpl_fecha_caducidad	Datetime	Fecha de caducidad de los registros
		qpl_total_monto		Money		Monto totalizado de montos a cobrar.
		qpl_estado			Integer		Estado de proceso.  A definir los valores que se tendrían para control, sugiero:
										1-Incluido
										2-Listo para Procesar por sistema destino
										3-Procesando (Espera de Respuesta)
										4-En proceso de actualización de datos (para mantener bloqueos de control )
										5-Procesado y disponible para actualización de sistema origen
										6-Procesado por Sistema Origen
		qpl_fecha_proceso1	Datetime 	Fecha Hora Proceso para estado 3 - Fecha en que se actualiza al estado 3
		qpl_fecha_proceso2	Datetime	Fecha Hora Proceso para estado 5 - Fecha en que se actualiza al estado 5
		qpl_fecha_proceso3	Datetime	Fecha Hora Proceso para Estado 6 - Fecha en que se actualiza al estado 6
	
	Tabla de entrada:
		qpl_id				Numeric		Número de lote en el cual fue generado.
		qpld_id				Numeric		Secuencial del registro hijo. 
		qpld_tipo_mov		Integer		1 =  Bloqueo
										2 = Cobro
										3 = Modificación de Datos
		qpld_causa			Integer		Código de causa u operación que se cobra
		qpld_ente			Integer		ID del cliente que el banco utiliza a nivel interno.
		qpld_cuenta			Char(20)	Número de cuenta COBIS.
		qpld_monto			Money		Monto a cobrar. Se debe incluir decimales si el mismo los trajera.
		qpld_moneda			Smallint	Código de la moneda a cobrar el monto. 
										USD :  Dólar Americano
										CRC:   Colón Costarricense, etc
		qpld_fecha			Datetime	Fecha del movimiento.
		qpld_descripcion	Varchar(255) Descripción del movimiento. 
		qpld_PAN			Varchar(20)	Número o Código de Dispositivo

	
	
	Tabla de Salida:
		qpl_id				Numeric		Número de lote en el cual fue generado.
		qpdl_id				Integer		Secuencial del registro hijo. 
		qpdl_tipo_mov		Integer		1 =  Bloqueo
										2 = Cobro
										3 = Modificación de Datos
		qpdl_causa			Integer		Código de causa u operación que se cobra
		qpdl_ente			Integer		ID del cliente que el banco utiliza a nivel interno.
		qpdl_cuenta			Char(15)	Número de cuenta.
		qpdl_monto			Money		Monto enviado a cobrar. Se debe incluir decimales si el mismo los trajera.
		qpdl_moneda			char(15)	Código de la moneda a cobrar el monto. 
										USD :  Dólar Americano
										CRC:   Colón Costarricense, etc
		qpdl_monto_no_blq	Money		Monto no cobrado. Se debe incluir decimales si el mismo los trajera. En caso de cobrarse todo el monto este monto será igual a cero
		qpdl_moneda_no_blq	Smallint	Código de la moneda del monto no cobrado. 
										USD :  Dólar Americano
										CRC:   Colón Costarricense, etc
		qpdl_fecha_blq		Datetime	Fecha del cobro realizado.
		qpdl_cod_error		Char(1)		Código del resultado del cobro.
		qpdl_desc_cod_error	Varchar(255) Descripción del código de resultado del cobro
		qpdl_lista			Char(2)		Código de la lista a ser incluido el cliente
		qpdl_cod_bloqueo	Integer 	Secuencial del bloqueo para ligar el bloqueo al movimiento en SOIN, para consulta en IVR y página Web. Se rellena con ceros a la izquierda.
		qpdl_cod_bloqueo2 	integer,
		qpdl_estado			integer		Control de Procesamiento en Sistema Origen:
										0: No procesado
										1: Procesado
		qpdl_PAN			varchar(20)	Número o Código del Dispositivo


--->

<cfcomponent output="no">
	<cffunction name="fnEnviaDatosInterfaz" output="no" access="public" returntype="numeric" description="Envia Datos por la Interfaz al Banco">
		<cfargument name="conexion" 			type="string" 	required="yes">
        <cfargument name="Ecodigo" 				type="numeric" 	required="yes">
        <cfargument name="qpld_tipo_mov" 		type="numeric" 	required="no" default="1">

		<cfsetting requesttimeout="1800">  <!--- Media hora maximo de proceso --->

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
              and Pcodigo = 9998
		</cfquery>
        
        <cfif rsParametro.recordcount eq 0>
    		<cfset LvarFechaDesde = createdate(2000, 1, 1)>
            <cfquery datasource="#arguments.conexion#">
                insert QPParametros (Ecodigo, Pcodigo, Pvalor, Pdescripcion, Mcodigo)
                values (#Arguments.Ecodigo#, 9998, #LvarFechaDesde#, 'Hora de la ultima ejecucion de Transferencias con el Banco', 'QP')
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
        	select qpl_id, qpl_fecha_ingreso, qpl_estado
            from QPControl
            where qpl_origen = 1
			  and qpl_estado > 1
              and qpl_estado < 6
        </cfquery>

        <cfif isdefined("rsVerificaProcesoPendiente") and rsVerificaProcesoPendiente.Recordcount GT 0>
        	<cfreturn 0>
        </cfif>

		<cfquery name="rsVerificaProcesoPendiente" datasource="#Arguments.Conexion#">
        	select qpl_id, qpl_fecha_ingreso, qpl_estado
            from QPControl
			where qpl_origen = 1
			  and qpl_estado = 1
			order by qpl_fecha_ingreso
        </cfquery>
        
        <cfif isdefined("rsVerificaProcesoPendiente") and rsVerificaProcesoPendiente.Recordcount GT 0>
			<cfloop query="rsVerificaProcesoPendiente">
				<!--- 
					Si existe un registro de control, y la fecha tiene menos de 1 hora de haberse insertado
					Se regresa el control sin procesar para esperar a que termine el proceso
					
					Si no se ha cambiado el estado a 2 en una hora, se debe de asumir que el proceso no termino ( ver cfsetting que tiene 30 minutos )
					y por lo tanto debe de eliminar el registro de control porque ya no será procesado
						
				--->
				<cfif dateadd('h', 1, rsVerificaProcesoPendiente.qpl_fecha_ingreso) GTE now()>
					<cfreturn 0>
				</cfif> 
	
				<cfquery datasource="#Arguments.Conexion#">
					delete from QPControl
					where qpl_id = #rsVerificaProcesoPendiente.qpl_id#
					  and Ecodigo = #Arguments.Ecodigo#
					  and qpl_origen = 1
					  and qpl_estado = 1
				</cfquery>
			</cfloop>
        </cfif>



            <cfquery name="rsQPControl" datasource="#arguments.conexion#">
                insert into QPControl (
                    qpl_origen,
                    qpl_fecha_ingreso,
                    qpl_cant_registros,
                    qpl_fecha_caducidad,
                    qpl_total_monto,
                    qpl_estado
                    )
               values(
                    1,
                    #now()#,
                    0,
                    #dateadd('h', 4, now())#,
                    0,
                    1 <!--- 1-Incluido --->
                   )
                   <cf_dbidentity1 datasource="#arguments.conexion#" verificar_transaccion="no">
            </cfquery>
            <cf_dbidentity2 datasource="#arguments.conexion#" name="rsQPControl" verificar_transaccion="no">
     
            <cfquery name="rsRegistros" datasource="#arguments.conexion#">
                 insert into QPEntrada(
                        qpl_id,
                        qpld_tipo_mov,
                        qpld_causa,
                        qpld_ente,
                        qpld_identificacion,
                        qpld_cuenta, 
                        qpld_monto, 
                        qpld_moneda, 
                        qpld_fecha,
                        qpld_descripcion,
                        qpld_PAN 
                     )
               select 
                	#rsQPControl.identity# 	as id,
                    1              			as tipo_mov, <!--- 1 -  SOIN / HSBC --->
                    c.QPCcodigo    			as causa, 
                    min(cl.QPCente)   		as ente,
                    min(cl.QPcteDocumento)	as identificacion,
                    substring(cb.QPctaBancoNum,1,20)	as cuenta,
                    sum(QPMCMonto*-1.00) 	as Monto,
                    m.Miso4217 				as moneda, 
                    #now()# 				as fecha,
                    min(c.QPCdescripcion) 	as descripcion,
                    mv.QPTPAN
                from QPventaTags vt
                    inner join QPMovCuenta mv
                     on mv.QPTidTag      = vt.QPTidTag
                    and mv.QPctaSaldosid = vt.QPctaSaldosid
                    and mv.QPcteid 		 = vt.QPcteid

                    inner join QPcuentaSaldos cs
                    on cs.QPctaSaldosid = vt.QPctaSaldosid

                    inner join QPcliente cl
                   	on cl.QPcteid = vt.QPcteid

                    inner join QPcuentaBanco cb
                    on cb.QPctaBancoid = cs.QPctaBancoid 
                
                    inner join QPCausa c
                    on c.QPCid = mv.QPCid
                
                    inner join Monedas m
                    on m.Mcodigo = mv.Mcodigo
                
                where vt. Ecodigo = #Arguments.Ecodigo#
                  and vt.QPvtaEstado = 1
                  and cs.QPctaSaldosTipo = 1
                  and c.QPCtipo not in (3, 4, 5)  <!--- solo se envían las causas que no sean: 3: Membresia (se saca de acá porque no se requieren agrupadas), 4: Venta, 5: Recarga --->
                  and mv.QPMCFAfectacion is not null
                  and mv.QPMCFAfectacion > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaDesde#">
                  and mv.QPMCFAfectacion <= #LvarFechaHasta#
                           
                group by cb.QPctaBancoNum, c.QPCcodigo, m.Miso4217, mv.QPTPAN
                having sum(QPMCMonto * -1.00) > 0
			</cfquery>

	    <!--- MEMBRESIAS --->
	    <!--- Busca todos los movimientos de membresia tipo postpagos  --->
	    <cfquery name="rsMembresias" datasource="#arguments.conexion#">
			select 
		    mv.QPTidTag, mv.QPctaSaldosid, mv.QPcteid
                from QPventaTags vt
                    inner join QPMovCuenta mv
                     on mv.QPTidTag      = vt.QPTidTag
                    and mv.QPctaSaldosid = vt.QPctaSaldosid
                    and mv.QPcteid 		 = vt.QPcteid

                    inner join QPcuentaSaldos cs
                    on cs.QPctaSaldosid = vt.QPctaSaldosid
               
                where vt. Ecodigo = #Arguments.Ecodigo#
                  and vt.QPvtaEstado = 1
                  and cs.QPctaSaldosTipo = 1
                  and mv.QPCid = 3  
                  and mv.QPMCFAfectacion is not null
                  and mv.QPMCFAfectacion > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaDesde#">
                  and mv.QPMCFAfectacion <= #LvarFechaHasta#
		  and mv.QPMCMonto < 0
		group by mv.QPTidTag, mv.QPctaSaldosid, mv.QPcteid
	    </cfquery>
	<!--- <cf_dump var="#rsMembresias#"> --->
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()>
  
  
	<cfloop query="rsMembresias">
	    <cfset LvarTagCiclo = rsMembresias.QPTidTag> <!--- <cf_dump var="#LvarTagCiclo#"> --->
        <cfset LvarQPctaSaldosidCiclo = rsMembresias.QPctaSaldosid>
        <cfset LvarQPcteidCiclo = rsMembresias.QPcteid>
<!--- <cfoutput>Tag #LvarTagCiclo#</cfoutput><br>	--->
<!--- <cflog file="LogProcesaDatos" text="Tag #LvarTagCiclo# " time="yes" date="yes" type="information">   --->

	    <!--- Este tag tiene monto negativo? --->
	    <cfquery name="rsMontosMembresias" datasource="#arguments.conexion#">
            select sum(QPMCMonto) as MontoMembresias
            from QPMovCuenta a
            where a.QPTidTag = #LvarTagCiclo#
                and a.QPctaSaldosid = #LvarQPctaSaldosidCiclo#
                and a.QPcteid = #LvarQPcteidCiclo#
                and a.QPCid =3
	    </cfquery>

	    <!--- si tiene monto negativo inserta --->
	    <cfif rsMontosMembresias.MontoMembresias lt 0>
            <cfquery name="rsMontosMembresias" datasource="#arguments.conexion#">
                select convert(integer, #rsMontosMembresias.MontoMembresias#) * -1 as MontoMembresias from dual
            </cfquery> 
    
    <!--- 	<cfoutput>Va insertar #rsMontosMembresias.MontoMembresias# cobros para el tag #LvarTagCiclo# </cfoutput><br> --->
    <!---	<cflog file="LogProcesaDatos" text="Va insertar #rsMontosMembresias.MontoMembresias# cobros para el tag #LvarTagCiclo# " time="yes" date="yes" type="information"> --->
    
            <cfquery name="rsMembresiasTop" datasource="#arguments.conexion#">
            select top #rsMontosMembresias.MontoMembresias#
                mv.QPMCid
                    from QPventaTags vt
                        inner join QPMovCuenta mv
                         on mv.QPTidTag      = vt.QPTidTag
                        and mv.QPctaSaldosid = vt.QPctaSaldosid
                        and mv.QPcteid 		 = vt.QPcteid
    
                        inner join QPcuentaSaldos cs
                        on cs.QPctaSaldosid = vt.QPctaSaldosid
                   
                    where vt. Ecodigo = #Arguments.Ecodigo#
                      and vt.QPvtaEstado = 1
                      and cs.QPctaSaldosTipo = 1
                      
              and mv.QPTidTag = #LvarTagCiclo# 
              and mv.QPCid = 3 
              and mv.QPMCMonto < 0
                      and mv.QPMCFAfectacion is not null
                      and mv.QPMCFAfectacion > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaDesde#">
                      and mv.QPMCFAfectacion <= #LvarFechaHasta#
            group by mv.QPTidTag, mv.QPTPAN, mv.QPMCid
            order by mv.QPMCid desc <!--- el orden descendente es necesario --->
            </cfquery>
    
            <cfloop query="rsMembresiasTop">
            <cfset LvarQPMCid = rsMembresiasTop.QPMCid>
    
                <cfquery datasource="#arguments.conexion#">
                     insert into QPEntrada(
                            qpl_id,
                            qpld_tipo_mov,
                            qpld_causa,
                            qpld_ente,
                            qpld_identificacion,
                            qpld_cuenta, 
                            qpld_monto, 
                            qpld_moneda, 
                            qpld_fecha,
                            qpld_descripcion,
                            qpld_PAN 
                         )
                   select 
                        #rsQPControl.identity# 	as id,
                        1              			as tipo_mov, <!--- 1 -  SOIN / HSBC --->
                        c.QPCcodigo    			as causa, 
                        cl.QPCente   		as ente,
                        cl.QPcteDocumento	as identificacion,
                        substring(cb.QPctaBancoNum,1,20)	as cuenta,
                        QPMCMonto*-1.00 	as Monto,
                        m.Miso4217 				as moneda, 
                        #now()# 				as fecha,
                        mv.QPMCdescripcion 	as descripcion,
                        mv.QPTPAN
                    from QPventaTags vt
                        inner join QPMovCuenta mv
                         on mv.QPTidTag      = vt.QPTidTag
                        and mv.QPctaSaldosid = vt.QPctaSaldosid
                        and mv.QPcteid 		 = vt.QPcteid
    
                        inner join QPcuentaSaldos cs
                        on cs.QPctaSaldosid = vt.QPctaSaldosid
    
                        inner join QPcliente cl
                        on cl.QPcteid = vt.QPcteid
    
                        inner join QPcuentaBanco cb
                        on cb.QPctaBancoid = cs.QPctaBancoid 
                    
                        inner join QPCausa c
                        on c.QPCid = mv.QPCid
                    
                        inner join Monedas m
                        on m.Mcodigo = mv.Mcodigo
                    
                    where vt. Ecodigo = #Arguments.Ecodigo#
                      and vt.QPvtaEstado = 1
                      and cs.QPctaSaldosTipo = 1
                      and c.QPCtipo = 3  <!--- solo se envían las causas 3: Membresia (Para que sean una por una) --->
              and mv.QPMCid = #LvarQPMCid# 
              and mv.QPTidTag = #LvarTagCiclo#
                      and QPMCFAfectacion is not null
                      and mv.QPMCFAfectacion > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaDesde#">
                      and mv.QPMCFAfectacion <= #LvarFechaHasta#
                </cfquery>
    
            </cfloop>
<!--- <cfoutput>Terminó de cobrar el tag #LvarTagCiclo# </cfoutput><br> --->
<!--- <cflog file="LogProcesaDatos" text="Terminó de cobrar el tag #LvarTagCiclo# " time="yes" date="yes" type="information"> --->
	    </cfif>
        <cfset rsMontosMembresias = javacast("null","")>
		<cfset rsMembresiasTop = javacast("null","")>
		<cfset javaRT.gc()>
    </cfloop>
<!--- <cfoutput>Terminó todos los tags</cfoutput><br>
<cfoutput>Actualiza QPControl</cfoutput><br> ---> 
<!--- <cflog file="LogProcesaDatos" text="Terminó todos los tags y Actualiza QPControl " time="yes" date="yes" type="information"> --->

            <cfquery datasource="#arguments.conexion#">
            	update QPControl
                set	qpl_cant_registros 	= coalesce( (select count(1) 
                									from QPEntrada e 
                                                    where e.qpl_id = QPControl.qpl_id), 0),
                	qpl_total_monto 	= coalesce( (select sum(qpld_monto) 
                    								from QPEntrada e 
                                                    where e.qpl_id = QPControl.qpl_id), 0),
                    qpl_estado			= 2,
                    qpl_fecha_ingreso	= #now()#
                where qpl_id = #rsQPControl.identity#
            </cfquery>
<!--- <cfoutput>Revisa si hay registros en QPEntrada</cfoutput><br> --->
<!--- <cflog file="LogProcesaDatos" text="Revisa si hay registros en QPEntrada " time="yes" date="yes" type="information"> --->
            <cfquery name="rsCantidad" datasource="#arguments.conexion#">
                select count(1) as cantidad
                from QPEntrada
                where qpl_id = #rsQPControl.identity#
            </cfquery>
    
            <cfif rsCantidad.cantidad eq 0>
<!---             	<cfoutput>No encontró registros en QPEntrada para el lote </cfoutput><br> --->
                <!--- <cflog file="LogProcesaDatos" text="No encontró registros en QPEntrada para el lote " time="yes" date="yes" type="information"> --->
                <cfquery datasource="#arguments.conexion#">
                    delete from QPControl
                    where qpl_id = #rsQPControl.identity#
                </cfquery>
            <cfelse>
<!---             	<cfoutput>Si encontró registros en QPEntrada para el lote </cfoutput><br> --->
                <!--- <cflog file="LogProcesaDatos" text="Si encontró registros en QPEntrada para el lote" time="yes" date="yes" type="information"> --->
	            <cfquery name="rsParametro" datasource="#arguments.conexion#">
                    update QPParametros
                    set Pvalor = #LvarFechaHasta#
                    where Ecodigo = #Arguments.Ecodigo#
                      and Pcodigo = 9998
            	</cfquery>
		    </cfif>
<!---       <cflog file="LogProcesaDatos" text="Todo Terminó bien" time="yes" date="yes" type="information"> --->
			<!--- <cfoutput>Todo Terminó bien</cfoutput><br> --->
            <!--- <cftransaction action="commit"/> --->
        <!--- </cftransaction> --->
		<cfreturn 1>
	</cffunction>

	<cffunction name="fnRecibeDatosInterfaz" access="public" output="no" returntype="numeric" description="Recibe los datos enviados por la Interfaz al Banco">
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
        	select qpl_id, qpl_fecha_ingreso, qpl_estado
            from QPControl
            where qpl_origen = 1
			  and qpl_estado = 5
        </cfquery>

        <cfif isdefined("rsProcesoPendiente") and rsProcesoPendiente.Recordcount EQ 0>
        	<cfreturn 0>
        </cfif>

		<cfloop query="rsProcesoPendiente">
			<cfquery name="rsDatos" datasource="#Arguments.conexion#">
				select 
					s.qpdl_id
				from QPSalida s
				where s.qpl_id = #rsProcesoPendiente.qpl_id#
				  and s.qpdl_estado = 0
			</cfquery>

			<cfloop query="rsDatos">
            		<cftransaction action="begin">
						<cfset fnProcesaSalida(arguments.conexion, arguments.ecodigo, rsProcesoPendiente.qpl_id, rsDatos.qpdl_id)>
                    </cftransaction>
			</cfloop>
			
			<!--- Actualiza registro de control si no hay registros de detalle sin procesar. --->
			<cfquery name="_rsEstadoProcesoPendiente" datasource="#Arguments.conexion#">
				select count(1) as Cantidad
				from QPControl c
					inner join QPSalida s
					on s.qpl_id = c.qpl_id
				where c.qpl_id = #rsProcesoPendiente.qpl_id#
				  and c.qpl_estado 		= 5
				  and c.qpl_origen 		= 1
				  and s.qpdl_estado 	= 0
			</cfquery>

			<cfif _rsEstadoProcesoPendiente.Cantidad EQ 0>
					<cfquery datasource="#arguments.conexion#">
						update QPControl
						set 
							qpl_fecha_proceso3	= #now()#, 
							qpl_estado			= 6
						where qpl_id = #rsProcesoPendiente.qpl_id#
						  and qpl_estado = 5
						  and qpl_origen = 1
					</cfquery>
			</cfif>
		</cfloop>
		<cfreturn 1>
	</cffunction>

	<cffunction name="fnProcesaSalida" access="private" output="no"  returntype="numeric" description="Proceso de registros enviados por el Banco">
		<cfargument name="conexion" 			type="string" 	required="yes">
        <cfargument name="Ecodigo" 				type="numeric" 	required="yes">
		<cfargument name="qpl_id"				type="numeric"	required="yes">
		<cfargument name="qpdl_id"				type="numeric"	required="yes">

		<!--- Procesar cada registro de la tabla QPSalida que esté en estado 0 :  Pendiente de Procesar
			1. Insertar en la tabla de Movimientos ( todos los registros procesados )
			2. Actualizar los datos del cliente:
				Ente
				Lista para el TAG
		--->

		<cfquery name="rsDatossalida" datasource="#Arguments.conexion#">
			select 
				s.qpdl_id, 		
				s.qpdl_tipo_mov, 	
				s.qpdl_causa,
				s.qpdl_ente,
				s.qpdl_cuenta, 	
				s.qpdl_monto,		
				s.qpdl_moneda,
				s.qpdl_monto_no_blq, 	
				s.qpdl_moneda_no_blq,
				s.qpdl_fecha_blq, 
				s.qpdl_cod_error, 
				s.qpdl_desc_cod_error,
				s.qpdl_lista, 
				s.qpdl_cod_bloqueo, 
				s.qpdl_cod_bloqueo2,
				s.qpdl_PAN
			from QPSalida s
			where s.qpdl_id 		= #arguments.qpdl_id#
			  and s.qpl_id 			= #Arguments.qpl_id#
			  and s.qpdl_estado 	= 0
		</cfquery>

		<cfloop query="rsDatossalida">

			<!--- Obtener el ID del TAG de proceso --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select QPTidTag
				from QPassTag
				where Ecodigo = #Arguments.Ecodigo#
				  and QPTPAN   = '#rsDatossalida.qpdl_PAN#'
			</cfquery>

			<cfif rs.recordcount NEQ 1>
				<cfreturn 0>
			</cfif>
			
			<cfset LvarQPTidTag = rs.QPTidTag>

			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select max(QPvtaTagid) as QPvtaTagid
				from QPventaTags a
				where QPTidTag = #LvarQPTidTag#
				  and QPvtaEstado = 1				
			</cfquery>
			
			<cfif len(trim(rs.QPvtaTagid)) LT 1>
				<cfreturn 0>
			</cfif>

			<cfset LvarQPvtaTagid = rs.QPvtaTagid>


			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select QPctaSaldosid, QPcteid
				from QPventaTags
				where QPvtaTagid = #LvarQPvtaTagid#
			</cfquery>

			<cfset LvarQPctaSaldosid 	= rs.QPctaSaldosid>
			<cfset LvarQPcteid			= rs.QPcteid>

			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select max(QPvtaTagid) as QPvtaTagid
				from QPventaTags a
				where QPTidTag = #LvarQPTidTag#
				  and QPvtaEstado = 1				
			</cfquery>

			<cfif rsDatossalida.qpdl_tipo_mov NEQ 3 and len(trim(LvarQPTidTag)) and len(trim(LvarQPvtaTagid))>
				<!--- Obtener Causa del catalogo de causas --->
                <cfquery name="rs" datasource="#Arguments.Conexion#">
                    select QPCid, QPCdescripcion
                    from QPCausa
                    where QPCcodigo = '#rsDatossalida.qpdl_causa#'
                      and Ecodigo = #Arguments.Ecodigo#
                </cfquery>

                <cfif len(trim(rs.QPCid)) LT 1>
                    <cfreturn 0>
                </cfif>

                <cfset LvarQPCid = rs.qPCid>
                <cfset LvarQPCdescripcion = rs.QPCdescripcion>

                <!--- Obtener codigo de Cuenta de Bancos --->
                <cfquery name="rs" datasource="#Arguments.Conexion#">
                    select min(QPctaBancoid) as CuentaBanco
                    from QPcuentaBanco
                    where Ecodigo   	= #Arguments.Ecodigo#
                      and QPctaBancoNum	= '#rsDatosSalida.qpdl_cuenta#'
                </cfquery>

                <cfset LvarCuentaBancoid = rs.CuentaBanco>

                <cfquery name="_rsMonedaTransaccionQP" datasource="#Arguments.Conexion#" cachedwithin="#createtimespan(6,0,0,0)#">
                    select min(m.Mcodigo) as Moneda
                    from Monedas m 
                    where m.Miso4217 = '#rsDatosSalida.qpdl_moneda#' 
                    and m.Ecodigo = #arguments.Ecodigo# 
                </cfquery>
                <cfset LvarMoneda = _rsMonedaTransaccionQP.Moneda>

                <!--- Obtiene el movimiento que contiene la categoría marcada para la importación de movimientos de Autopostas del Sol (ADS) --->
                <cfquery name="rsMovimiento" datasource="#Arguments.conexion#">
                    select min(QPMovid) as QPMovid
                    from QPCausaxMovimiento
                    where Ecodigo = #arguments.Ecodigo#
                    and QPCid = #LvarQPCid# <!--- indica si la causa es la que se usa en la importación de movimientos de Autopostas del Sol (ADS) --->
                </cfquery>
                <cfset LvarQPMovid = rsMovimiento.QPMovid>

                <cfquery datasource="#Arguments.conexion#">
                    insert into QPMovCuenta (
                        QPCid, 
                        QPctaSaldosid, 
                        QPcteid, 	
                        QPMovid, 	
                        QPTidTag, 	
                        QPTPAN,
                        QPMCFInclusion,
                        Mcodigo, 
                        QPMCMonto, 
                        
                        QPMCMontoLoc, 
                        QPMCdescripcion, 
                        BMFecha)
                    select
                        #LvarQPCid#, 
                        #LvarQPctaSaldosid#,
                        #LvarQPcteid#,
                        #LvarQPMovid#,
                        #LvarQPTidTag#,
                        qpdl_PAN,
                        qpdl_fecha_blq, 
                        #LvarMoneda#,
                        s.qpdl_monto - s.qpdl_monto_no_blq,
                        0, <!--- Acá TC? --->
                        '#LvarQPCdescripcion#',
                        #now()# 
                    from QPSalida s
                    where s.qpdl_id = #arguments.qpdl_id#		<!--- Registros del lote en Proceso --->
                      and s.qpdl_estado = 0   									<!--- Solamente registros que estén procesados --->
                </cfquery>
			</cfif>        
			<!--- Actualiza datos del Cliente ( Ente ) --->
            <cfif len(trim(rsDatossalida.qpdl_ente))>
                <cfquery datasource="#Arguments.Conexion#">
                    update QPcliente
                    set QPCente = #rsDatossalida.qpdl_ente#
                    where QPcteid = #LvarQPcteid#
                </cfquery>
            </cfif>			
            
            <!--- Actualiza datos del TAG ( Lista en la que debe estar ) --->
            <cfquery datasource="#Arguments.Conexion#">
                update QPassTag
                set QPTlista = '#rsDatossalida.qpdl_lista#'
                where QPTidTag = #LvarQPTidTag#
            </cfquery>
            <!--- Actualiza el registro de QPSalida  para evitar que sea reprocesado --->
            <cfquery datasource="#Arguments.Conexion#">
                update QPSalida
                set qpdl_estado = 1
                where qpdl_id = #rsDatossalida.qpdl_id#
                  and qpdl_estado = 0
            </cfquery>
    	</cfloop>
    <cfreturn 1>
</cffunction>
</cfcomponent>



