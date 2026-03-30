
<cfcomponent extends="crc.Componentes.transacciones.CRCTransaccion">
    <cffunction  name="AplicarTransferencia">
        <cfargument name="Transaccion_id"   required="yes"   type="string">
        <cfargument name="Monto"            required="yes"   type="numeric">
        <cfargument name="PagadoNeto"       required="yes"   type="numeric">
        <cfargument name="Cuenta_id"       required="yes"   type="numeric">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">

        <cfset Super.init(arguments.DSN,arguments.Ecodigo)>

        
        <!--- Obtener datos de la transaccion --->
        <cfset q_tranqry =  getTransaccion(arguments.Transaccion_id, arguments.dsn, arguments.ecodigo)>

        <!--- Obtener corte actual y anterior que son afectados--->
        <cfset cortes =  getCortes(arguments.Transaccion_id,arguments.dsn,arguments.ecodigo)>

        <cfset montoNeto = arguments.Monto - arguments.PagadoNeto>  

        <cfquery name="rsTipotransaccion" datasource="#Session.dsn#">
            select * from CRCTipoTransaccion where Codigo = 'TR' and Ecodigo = #Session.Ecodigo#
        </cfquery>

        <cfif rsTipotransaccion.recordCOunt eq 0>
            <cfthrow message="No se ha definido el Tipo de Transaccion para Transferencias (TR)">
        </cfif>

        <cftransaction>
        
            <!--- Realizar la transaccion "saldar pagos del transaccion" --->
            <cfset idTransaccionS = crearTransaccion(
                              CuentaID            = q_tranqry.CRCCUENTASID
                            , Tipo_TransaccionID  = rsTipotransaccion.id
                            , Fecha_Transaccion   = Now()
                            , Monto               = montoNeto
                            , Observaciones       = "[#arguments.Transaccion_id#] Saldado x Transferencia: #q_tranqry.OBSERVACIONES#"
                            , usarTagLastID       = false
                    )>
  
            <!--- Elimina Parcialidades Transferidas (MovimientoCuenta) --->
            <cfset EliminarParcialidades(
                      transaccion_id = q_tranqry.id
                    , dsn = arguments.dsn
                    , ecodigo = arguments.ecodigo
            )>

            <!--- Actualizar Parcialidades (MovimientoCuenta) --->
            <cfset ActualizarParcialidades(
                      transaccion_id = q_tranqry.id
                    , dsn = arguments.dsn
                    , ecodigo = arguments.ecodigo
            )>
            <!--- Actualizar Resumen de Corte (MovimientoCuentaCorte) --->
            <cfif IsArray(cortes)>
			    <cfset caMccPorCorteCuenta(cortes = arrayToList(cortes)  ,CuentaID = q_tranqry.CRCCUENTASID )>
            <cfelse>
			    <cfset caMccPorCorteCuenta(cortes = cortes  ,CuentaID = q_tranqry.CRCCUENTASID )>
            </cfif>

            <!--- Realizar afectacion a cuenta de la transaccion "saldar de transaccion" --->
            <cfquery name="q_Afectacion" datasource="#This.DSN#">
                update CRCCuentas set 
                      SaldoActual = (ISNull(SaldoActual,0 )-#q_tranqry.Monto#) 
                    , Interes = 0
                    , SaldoVencido = 0
                    , Condonaciones = 0
                    <cfif arguments.PagadoNeto gt 0>
                    , saldoAFavor += #NumberFormat(arguments.PagadoNeto,'0.00')#
                    </cfif>
                where id = #q_tranqry.CRCCUENTASID#;
            </cfquery>
    
    
            <cfset fechaIniciopago = now()>
            <cfif dateDiff('d', q_tranqry.FechaInicioPago, now()) lt 0>
                <cfset fechaIniciopago = q_tranqry.FechaInicioPago>
            </cfif>
            <cfset fechaIniciopago = CreateDate(year(fechaIniciopago),month(fechaIniciopago),day(fechaIniciopago))>

            <!--- Realizar la transaccion "recalendarizacion de pagos del transaccion" --->
            <cfset idTransaccionR = crearTransaccion(
                            CuentaID = arguments.Cuenta_id
                            , Tipo_TransaccionID = q_tranqry.CRCTIPOTRANSACCIONID
                            , Fecha_Transaccion   = Now()
                            , Fecha_Inicio_Pago   = fechaIniciopago
                            , Monto               = arguments.Monto
                            , Num_Folio           = '#q_tranqry.Folio#' 
                            , Monto               = arguments.Monto 
                            , Observaciones       = "#q_tranqry.OBSERVACIONES#"
                            , Cliente             = "#q_tranqry.Cliente#"
                            , CURP                = "#q_tranqry.CURP#"
                            , Parcialidades       = q_tranqry.Parciales
                            , usarTagLastID       = false
                            , Num_Ticket          = "#q_tranqry.Ticket#"
                            , Cod_Tienda          = "#q_tranqry.tienda#"
                            , Descripcion         = "#q_tranqry.Descripcion#"   	    
                            , cadenaEmpresa    	  = "#q_tranqry.cadenaEmpresa#"
                            , sucursal 	          = "#q_tranqry.sucursal#"
                            , caja                 = "#q_tranqry.caja#"  
                            
                    )>
        </cftransaction>
    </cffunction>

    <cffunction  name="ActualizarParcialidades">
        <cfargument name="transaccion_id"       required="yes"   type="numeric">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <!--- Actualizar las parcialidades cuyo corte sea estado 1 (parcialidades a pagar actualmente)--->
        <cfquery datasource="#arguments.dsn#">
            update mc set 
                  mc.Pagado =  Round(isNull(mc.Pagado,0) + (isNull(mc.MontoAPagar,0) - (isNull(mc.Descuento,0) + isNull(mc.Pagado,0))),2)
            from CRCMovimientoCuenta mc
            inner join CRCCortes c
                on c.Codigo = mc.corte
            inner join CRCTransaccion t
                on t.id = mc.CRCTransaccionid
            where mc.status = 1 and mc.CRCTransaccionid = #arguments.transaccion_id#
        </cfquery>
        
        <!--- Actualizar las parcialidades cuyo corte sea estado 0 (parcialidades a pagar a futuro)--->
        <cfquery datasource="#arguments.dsn#">
            update mc set 
                  mc.Pagado = Round(isNull(mc.Pagado,0) + (isNull(mc.MontoRequerido,0) - (isNull(mc.Descuento,0) + isNull(mc.Pagado,0))),2)
            from CRCMovimientoCuenta mc
            inner join CRCCortes c
                on c.Codigo = mc.corte
            inner join CRCTransaccion t
                on t.id = mc.CRCTransaccionid
            where IsNull(mc.status,0)  = 0 and mc.CRCTransaccionid = #arguments.transaccion_id#
        </cfquery>
    </cffunction>

    <cffunction  name="EliminarParcialidades">
        <cfargument name="transaccion_id"       required="yes"   type="numeric">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        
        <!--- Actualizar las parcialidades cuyo corte sea estado 0 (parcialidades a pagar a futuro)--->
        <cfquery datasource="#arguments.dsn#">
            delete from CRCMovimientoCuenta where CRCTransaccionid = #arguments.transaccion_id#
        </cfquery>
    </cffunction>

    <cffunction  name="getCortes">
        <cfargument name="Transaccion_id"      required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <cfquery name="q_Cortes" datasource="#arguments.DSN#">
            select 
                cr.codigo
            from CRCTransaccion cv
                inner join CRCCuentas cu
                    on cu.id = cv.CRCCuentasid
                inner join CRCCortes cr
                    on cr.Tipo like concat('%',rtrim(ltrim(cu.Tipo)),'%')
            where
                isNull(cr.status,0) <= 1 
                and cv.id = #arguments.Transaccion_id#
                and cv.ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfreturn listToArray(ValueList(q_Cortes.codigo),',')>
    </cffunction>

    <cffunction  name="getTransaccion">
        <cfargument name="Transaccion_id"      required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <cfquery name="q_tranqry" datasource="#arguments.DSN#">
            select c.*
                from CRCTransaccion c
                where c.id = #arguments.Transaccion_id# and c.ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfreturn q_tranqry>
    </cffunction>


</cfcomponent>