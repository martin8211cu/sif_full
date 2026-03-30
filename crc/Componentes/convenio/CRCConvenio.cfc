
<cfcomponent extends="crc.Componentes.transacciones.CRCTransaccion">
    <cffunction  name="AplicarConvenio">
        <cfargument name="ID_Convenio"    required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">

        <cfset Super.init(arguments.DSN,arguments.Ecodigo)>

        
        <!--- Obtener datos del convenio --->
        <cfset q_Convenio =  getConvenio(arguments.ID_Convenio,arguments.dsn,arguments.ecodigo)>

        <!--- Obtener corte actual y anterior que son afectados--->
        <cfset cortes =  getCortes(arguments.ID_Convenio,arguments.dsn,arguments.ecodigo)>
        
        <!--- Calcular el monto total del convenio--->
        <cfif q_Convenio.esPorcentaje neq 1>
            <cfset montoConvenido =  q_Convenio.MontoConvenio + q_Convenio.MontoGastoCobranza>
        <cfelse>
            <cfset montoConvenido =  q_Convenio.MontoConvenio + (q_Convenio.MontoConvenio * (q_Convenio.MontoGastoCobranza/100))>
        </cfif>

        <!--- Obtener el ID de Estado de Cuenta para "Cuenta Conveniada" --->
        <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
        <cfset EstadoCuentaID = objParams.getParametroInfo('30100501')>
        <cfif EstadoCuentaID.valor eq ''>
            <cfthrow message="No se ha configurado el parametro [30100501 - Estado de Cuenta Conveniada]">
        <cfelse>
            <cfset EstadoCuentaID = EstadoCuentaID.valor>
        </cfif>

        <cftransaction>
        
            <!--- Realizar la transaccion "saldar pagos del convenio" --->
            <cfset idTransaccionS = crearTransaccion(
                              CuentaID            = q_Convenio.CRCCUENTASID
                            , Tipo_TransaccionID  = q_Convenio.CRCTIPOTRANSACCIONID
                            , Fecha_Transaccion   = Now()
                            , Monto               = montoConvenido
                            , Observaciones       = "[#arguments.ID_Convenio#] Saldado x Convenio: #q_Convenio.OBSERVACIONES#"
                            , usarTagLastID       = false
                    )>

            <!--- Actualizar Parcialidades (MovimientoCuenta) --->
            <cfset ActualizarParcialidades(
                      q_Convenio = q_Convenio
                    , dsn = arguments.dsn
                    , ecodigo = arguments.ecodigo
            )>

            <!--- Actualizar Resumen de Corte (MovimientoCuentaCorte) --->
			<cfset caMccPorCorteCuenta(cortes = arrayToList(cortes)  ,CuentaID = q_Convenio.CRCCUENTASID )>

            <!--- Realizar afectacion a cuenta de la transaccion "saldar de convenio" --->
            <cfquery name="q_Afectacion" datasource="#This.DSN#">
                update CRCCuentas set 
                      SaldoActual = (ISNull(SaldoActual,0 )-#q_Convenio.MontoConvenio#) 
                    , Interes = 0
                    , SaldoVencido = 0
                    , Condonaciones = 0
                    , CRCEstatusCuentasid = #EstadoCuentaID#
                where id = #q_Convenio.CRCCUENTASID#;
            </cfquery>

            <!--- Realizar la transaccion "recalendarizacion de pagos del convenio" --->
            <cfset idTransaccionR = crearTransaccion(
                            CuentaID            = q_Convenio.CRCCUENTASID
                            , Tipo_TransaccionID  = q_Convenio.CRCTIPOTRANSACCIONID2
                            , Fecha_Transaccion   = Now()
                            , Fecha_Inicio_Pago   = "#DateFormat(q_Convenio.FechaInicio,'yyyy-mm-dd')#"
                            , Monto               = montoConvenido
                            , Observaciones       = "[#arguments.ID_Convenio#] Recalendarizacion de Pagos x Convenio: #q_Convenio.OBSERVACIONES#"
                            , Parcialidades       = q_Convenio.Parcialidades
                            , usarTagLastID       = false
                    )>

            <cfquery name="q_Afectacion2" datasource="#This.DSN#">
                update CRCConvenios set 
                      TIDSaldo = #idTransaccionS#
                    , TIDRecal = #idTransaccionR#
                where id = #arguments.ID_Convenio#;
            </cfquery>
        </cftransaction>
    </cffunction>

    <cffunction  name="ActualizarParcialidades">
        <cfargument name="q_Convenio"       required="yes"   type="query">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <!--- Actualizar las parcialidades cuyo corte sea estado 1 (parcialidades a pagar actualmente)--->
        <cfquery datasource="#arguments.dsn#">
            update mc set 
                  mc.Pagado = Round(isNull(mc.Pagado,0) + (isNull(mc.MontoAPagar,0) - (isNull(mc.Descuento,0) + isNull(mc.Pagado,0))),2)
                , mc.CRCConveniosid = #q_Convenio.id#
            from CRCMovimientoCuenta mc
                inner join CRCCortes c
                    on c.Codigo = mc.corte
                inner join CRCTransaccion t
                    on t.id = mc.CRCTransaccionid
            where c.status = 1 and t.CRCCuentasid = #q_Convenio.CRCCUENTASID#;
        </cfquery>
        <!--- Actualizar las parcialidades cuyo corte sea estado 0 (parcialidades a pagar a futuro)--->
        <cfquery datasource="#arguments.dsn#">
            update mc set 
                  mc.Pagado = Round(isNull(mc.Pagado,0) + (isNull(mc.MontoRequerido,0) - (isNull(mc.Descuento,0) + isNull(mc.Pagado,0))),2)
                , mc.CRCConveniosid = #q_Convenio.id#
            from CRCMovimientoCuenta mc
                inner join CRCCortes c
                    on c.Codigo = mc.corte
                inner join CRCTransaccion t
                    on t.id = mc.CRCTransaccionid
            where IsNull(c.status,0)  = 0 and t.CRCCuentasid = #q_Convenio.CRCCUENTASID#;
        </cfquery>
    </cffunction>

    <cffunction  name="getCortes">
        <cfargument name="ID_Convenio"      required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <cfquery name="q_Cortes" datasource="#arguments.DSN#">
            select 
                cr.codigo
            from CRCConvenios cv
                inner join CRCCuentas cu
                    on cu.id = cv.CRCCuentasid
                inner join CRCCortes cr
                    on cr.Tipo like concat('%',rtrim(ltrim(cu.Tipo)),'%')
            where
                isNull(cr.status,0) <= 1 
                and cv.id = #arguments.ID_Convenio#
                and cv.ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfreturn listToArray(ValueList(q_Cortes.codigo),',')>
    </cffunction>

    <cffunction  name="getConvenio">
        <cfargument name="ID_Convenio"      required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <cfquery name="q_Convenio" datasource="#arguments.DSN#">
            select c.*, tt1.Codigo as codigo1, tt2.Codigo as codigo2
                from CRCConvenios c
                inner join CRCTipoTransaccion tt1
                    on tt1.id = c.CRCTIPOTRANSACCIONID
                inner join CRCTipoTransaccion tt2
                    on tt2.id = c.CRCTIPOTRANSACCIONID2
                where c.id = #arguments.ID_Convenio# and c.ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfreturn q_Convenio>
    </cffunction>


</cfcomponent>