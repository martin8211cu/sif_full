
<cfcomponent extends="crc.Componentes.transacciones.CRCTransaccion">
    <cffunction  name="AplicarCondonacion">
        <cfargument name="ID_Condonacion"   required="yes"  type="numeric">
        <cfargument name="esFuturo"         required="yes"  type="numeric">
        <cfargument name="DSN"              required="no"   type="string"   default ="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"   type="numeric"  default="#session.ecodigo#">

        <cfset Super.init(#arguments.DSN#,#arguments.Ecodigo#)>

        <cfquery name="q_CondonacionE" datasource="#arguments.DSN#">
            select id, CRCCuentasid, CRCTipoTransaccionid, MontoCondonacion, Observaciones, CodigoTipoTransaccion, TipoMov
                from CRCCondonaciones where id = #arguments.ID_Condonacion# and ecodigo = #arguments.ecodigo#
        </cfquery>

        <cfif arguments.esFuturo>
            <cfset afectar = afectarCondonacionFuturo(
                q_CondonacionE  = q_CondonacionE,
                DSN             = arguments.DSN,
                Ecodigo         = arguments.Ecodigo
            )>
        
        <cfelse>
            <cfset afectar = afectarCondonacionPasado(
                q_CondonacionE  = q_CondonacionE,
                DSN             = arguments.DSN,
                Ecodigo         = arguments.Ecodigo
            )>
        </cfif>

        <cfquery datasource="#arguments.DSN#">
            update CRCCondonaciones 
            set 
                CondonacionAplicada = 1, 
                Estado = 'A',
                FechaAplicacion = CURRENT_TIMESTAMP 
            where 
                id = #arguments.ID_Condonacion# 
                and ecodigo = #arguments.ecodigo#;
        </cfquery>

    </cffunction>

    <cffunction  name="afectarCondonacionPasado">
        <cfargument name="q_CondonacionE"   required="yes"  type="query">
        <cfargument name="DSN"              required="no"   type="string"   default ="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"   type="numeric"  default="#session.ecodigo#">

        
        <cfset idTransaccion = crearTransaccion(
            CuentaID            = q_CondonacionE.CRCCUENTASID,
            Tipo_TransaccionID  = q_CondonacionE.CRCTIPOTRANSACCIONID,
            Fecha_Transaccion   = Now(),
            Monto               = q_CondonacionE.MONTOCONDONACION,
            Observaciones       = q_CondonacionE.OBSERVACIONES
        )>

        <cfquery datasource="#arguments.DSN#">
            update A set A.Condonaciones = A.Condonaciones + B.Monto
                from CRCMovimientoCuenta as A 
                    inner join CRCCondonacionDetalle as B
                        on A.id = B.CRCMovimientoCuentaid
                where B.CRCCondonacionesid = #q_CondonacionE.id# and A.ecodigo = #arguments.ecodigo#
        </cfquery>

        <cfquery datasource="#arguments.DSN#">
            update c set c.Condonaciones = c.Condonaciones + co.MontoCondonacion
                from CRCCuentas c 
                inner join CRCCondonaciones as co
                on c.id = co.CRCCuentasid
                where c.id = #q_CondonacionE.CRCCUENTASID#  
        </cfquery>
 
        <!---  <cfquery name="cortes" datasource="#arguments.DSN#">
            select distinct A.Corte
                from CRCMovimientoCuenta as A 
                    inner join CRCCondonacionDetalle as B
                        on A.id = B.CRCMovimientoCuentaid
                where B.CRCCondonacionesid = #q_CondonacionE.id# and A.ecodigo = #arguments.ecodigo#
        </cfquery>
--->
        <cfset CRCReProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCReProcesoCorte").
                                    init(Ecodigo=#arguments.Ecodigo#, conexion=#arguments.DSN#)>
 
        <cfset CRCReProcesoCorte.reProcesarCorte(cuentaID  = #q_CondonacionE.CRCCUENTASID#)>
        
        <!---
        <cfset cortes = ValueList(cortes.Corte)>

        <cfset caMccPorCorteCuenta(cortes= cortes, CuentaID= q_CondonacionE.CRCCuentasid )>


        <cfset afectarCuenta(
                Monto                   = q_CondonacionE.MontoCondonacion ,
                CuentaID                = q_CondonacionE.CRCCUENTASID ,
                CodigoTipoTransaccion   = q_CondonacionE.CodigoTipoTransaccion ,
                TipoMovimiento          = q_CondonacionE.TipoMov 
        )>
        
        <!-- si afecta Condonaciones tambien afecta el saldo actual -->
        <cfquery name="q_Afectacion" datasource="#This.DSN#">
            update CRCCuentas set SaldoActual = (ISNull(SaldoActual,0 ) - #NumberFormat(q_CondonacionE.MontoCondonacion,'0.00')#) where id = #q_CondonacionE.CRCCUENTASID#;
        </cfquery>

    --->

    </cffunction>

    <cffunction  name="afectarCondonacionFuturo">
        <cfargument name="q_CondonacionE"   required="yes"  type="query">
        <cfargument name="DSN"              required="no"   type="string"   default ="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"   type="numeric"  default="#session.ecodigo#">

        
        <cfquery datasource ="#arguments.DSN#">
            update T set T.CRCCondonacionesid = #q_CondonacionE.id#
                from CRCTransaccion as T
                    inner join CRCMovimientoCuenta as A 
                        on T.id = A.CRCTransaccionid
                    inner join CRCCondonacionDetalle as B
                        on A.id = B.CRCMovimientoCuentaid
                where B.CRCCondonacionesid = #q_CondonacionE.id# and A.ecodigo = #arguments.ecodigo#
        </cfquery>

    </cffunction>

</cfcomponent>