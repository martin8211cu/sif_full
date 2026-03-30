<cfcomponent output="false" displayname="Transacciones" 
    extends="crc.Componentes.CRCBase" 
    hint="Componente para manejo de transacciones"
>
    
    <cffunction name="init" access="public" output="no" returntype="Transacciones" hint="constructor del componente con parametros de entradas primarios">  
        <cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
        <cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >      
        <cfset Super.init(arguments.DSN, arguments.Ecodigo)>

        <cfreturn this>
    </cffunction>

    <cffunction name="obtenerTransacciones" access="public" returntype="struct">
        <cfargument name="SNID" required="true" type="string">
        <cfargument name="CuentaId" required="false" type="string">
        <cfargument name="PageNumber" required="false" type="string" default="1">
        <cfargument name="PageSize" required="false" type="string" default="10">
        <cfargument name="TipoTransaccion" required="false" type="string" default="ALL">

        <cfquery name="qMetadataQuery" datasource="#this.DSN#">
            SELECT COUNT(*) AS TotalRecords
            from CRCTransaccion t
            inner join CRCCuentas c
                on t.CRCCuentasid = c.id
            where c.SNegociosSNid = #arguments.SNID#
            <cfif structKeyExists(arguments, "CuentaId") and arguments.CuentaId neq "">
                and c.id = #arguments.CuentaId#
            </cfif>
            <cfif structKeyExists(arguments, "TipoTransaccion") and arguments.TipoTransaccion neq "ALL">
                and t.TipoTransaccion = '#arguments.TipoTransaccion#'
            <cfelse>
                and t.TipoTransaccion in ('VC', 'TC',  'PG') 
            </cfif>
        </cfquery>

        <cfset total = this.db.queryRowToStruct(qMetadataQuery, 1)>

        <cfset metadata = {
            TotalRecords = total.TotalRecords,
            TotalPages = ceiling(total.TotalRecords / arguments.PageSize),
            PageNumber = arguments.PageNumber,
            PageSize = arguments.PageSize
        }>


        <cfquery name="qTransacciones" datasource="#this.DSN#">
            select 
                t.id, t.CRCCuentasid, t.Fecha, t. Monto, tt.Descripcion, t.TipoTransaccion, t.TipoMov,
                t.Parciales, c.Tipo
            from CRCTransaccion t
            inner join CRCCuentas c
                on t.CRCCuentasid = c.id
            inner join CRCTipoTransaccion tt
                on t.CRCTipoTransaccionid = tt.id
            where c.SNegociosSNid = #arguments.SNID#
            <cfif structKeyExists(arguments, "CuentaId") and arguments.CuentaId neq "">
                and c.id = #arguments.CuentaId#
            </cfif>
            <cfif structKeyExists(arguments, "TipoTransaccion") and arguments.TipoTransaccion neq "ALL">
                and t.TipoTransaccion = '#arguments.TipoTransaccion#'
            <cfelse>
                and t.TipoTransaccion in ('VC', 'TC',  'PG') 
            </cfif>
            order by t.Fecha desc
            OFFSET (#PageNumber# - 1) * #PageSize# ROWS 
            FETCH NEXT #PageSize# ROWS ONLY
        </cfquery>

        <cfset data = this.db.queryToArray(qTransacciones)>

        <cfset sreturn =  structNew()>
        <cfset sreturn.metadata = metadata>
        <cfset sreturn.items = data>

        <cfreturn sreturn>
    </cffunction>

    <cffunction name="obtenerTransaccionesClientes" access="public" returntype="struct">
        <cfargument name="SNID" required="true" type="string">
        <cfargument name="CURP" required="true" type="string">
        <cfargument name="PageNumber" required="false" type="string" default="1">
        <cfargument name="PageSize" required="false" type="string" default="10">

        <cfquery name="qMetadataQuery" datasource="#this.DSN#">
            SELECT COUNT(*) AS TotalRecords
            from CRCTransaccion t
            inner join CRCCuentas c
                on t.CRCCuentasid = c.id
            where c.SNegociosSNid = #arguments.SNID#
                and t.CURP = '#arguments.CURP#'
        </cfquery>

        <cfset total = this.db.queryRowToStruct(qMetadataQuery, 1)>

        <cfset metadata = {
            TotalRecords = total.TotalRecords,
            TotalPages = ceiling(total.TotalRecords / arguments.PageSize),
            PageNumber = arguments.PageNumber,
            PageSize = arguments.PageSize
        }>
        <cfquery name="qTransacciones" datasource="#this.DSN#">
             select 
                t.id, t.Fecha, t. Monto, t.TipoTransaccion, t.TipoMov,
                t.Parciales, c.Tipo, t.Cliente, t.CURP,
                Sum(mc.MontoRequerido) + sum(mc.Intereses) Credito,
                Sum(mc.Pagado) + sum(mc.Descuento) + sum(mc.Condonaciones) Debito,
                (Sum(mc.MontoRequerido) + sum(mc.Intereses)) -
                (Sum(mc.Pagado) + sum(mc.Descuento) + sum(mc.Condonaciones)) Saldo
            from CRCMovimientoCuenta mc
            inner join CRCTransaccion t
                on mc.CRCTransaccionid = t.id
            inner join CRCCuentas c
                on t.CRCCuentasid = c.id
            where c.SNegociosSNid = #arguments.SNID#
                and t.CURP = '#arguments.CURP#'
            group by t.id, t.Fecha, t. Monto, t.TipoTransaccion, t.TipoMov,
                t.Parciales, c.Tipo, t.Cliente, t.CURP
            order by t.Fecha desc
            OFFSET (#PageNumber# - 1) * #PageSize# ROWS 
            FETCH NEXT #PageSize# ROWS ONLY
        </cfquery>
        <cfset data = this.db.queryToArray(qTransacciones)>
        <cfset sreturn =  structNew()>
        <cfset sreturn.metadata = metadata>
        <cfset sreturn.items = data>
        <cfreturn sreturn>
    </cffunction>

    <cffunction name="obtenerDetalleTransaccion" access="public" returntype="array">
        <cfargument name="transaccionid"  required="true"  type="string" >

        <cfquery name="qDetalle" datasource="#this.DSN#">
             select 
                mc.MontoAPagar, (mc.Pagado + mc.Descuento + mc.Condonaciones) Pagado,
                mc.Descripcion Parcialidad, mc.Corte
            from CRCMovimientoCuenta mc
            inner join CRCTransaccion t
                on mc.CRCTransaccionid = t.id
            inner join CRCCuentas c
                on t.CRCCuentasid = c.id
            where mc.CRCTransaccionid = #arguments.transaccionid#
            order by mc.Corte asc
        </cfquery>
        <cfset data = this.db.queryToArray(qDetalle)>
        <cfreturn data>
    </cffunction>
</cfcomponent>