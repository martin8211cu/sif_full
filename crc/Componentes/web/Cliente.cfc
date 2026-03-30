<cfcomponent output="false" displayname="Cliente" 
    extends="crc.Componentes.CRCBase" 
    hint="Componente para manejo de Clientes"
>
    
    <cffunction name="init" access="public" output="no" returntype="Cliente" hint="constructor del componente con parametros de entradas primarios">  
        <cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
        <cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >      
        <cfset Super.init(arguments.DSN, arguments.Ecodigo)>

        <cfreturn this>
    </cffunction>

    <cffunction name="obtenerClientes" access="public" returntype="struct">
        <cfargument name="SNID" required="true" type="string">
        <cfargument name="search" required="false" type="string">
        <cfargument name="PageNumber" required="false" type="string" default="1">
        <cfargument name="PageSize" required="false" type="string" default="10">

        <cfquery name="qMetadataQuery" datasource="#this.DSN#">
            SELECT COUNT(*) AS TotalRecords
            from (
                select t.Cliente, t.Curp,
                    Sum(mc.MontoRequerido) MontoRequerido, Sum(mc.MontoAPagar) MontoAPagar, sum(mc.Intereses) Intereses,
                    Sum(mc.Pagado) Pagado, sum(mc.Descuento) Descuento, sum(mc.Condonaciones) Condonaciones
                from CRCMovimientoCuenta mc
                inner join CRCTransaccion t
                    on mc.CRCTransaccionid = t.id
                inner join CRCCuentas c
                    on t.CRCCuentasid = c.id
                where c.SNegociosSNid = #arguments.SNID#
                    and t.TipoTransaccion = 'VC'
                group by t.Cliente, t.Curp
            ) r
            where Cliente like '%#arguments.search#%' or CURP like '%#arguments.search#%'
        </cfquery>

        <cfset total = this.db.queryRowToStruct(qMetadataQuery, 1)>

        <cfset metadata = {
            TotalRecords = total.TotalRecords,
            TotalPages = ceiling(total.TotalRecords / arguments.PageSize),
            PageNumber = arguments.PageNumber,
            PageSize = arguments.PageSize
        }>


        <cfquery name="qClientes" datasource="#this.DSN#">
            select r.Cliente, r.CURP,
                r.MontoRequerido + r.Intereses Creditos,
                r.Pagado + r.Descuento + r.Condonaciones Debitos,
                (r.MontoRequerido + r.Intereses) - (r.Pagado + r.Descuento + r.Condonaciones) Saldo
            from (
                select t.Cliente, t.Curp,
                    Sum(mc.MontoRequerido) MontoRequerido, Sum(mc.MontoAPagar) MontoAPagar, sum(mc.Intereses) Intereses,
                    Sum(mc.Pagado) Pagado, sum(mc.Descuento) Descuento, sum(mc.Condonaciones) Condonaciones
                from CRCMovimientoCuenta mc
                inner join CRCTransaccion t
                    on mc.CRCTransaccionid = t.id
                inner join CRCCuentas c
                    on t.CRCCuentasid = c.id
                where c.SNegociosSNid = #arguments.SNID#
                    and t.TipoTransaccion = 'VC'
                group by t.Cliente, t.Curp
            ) r
            where Cliente like '%#arguments.search#%' or CURP like '%#arguments.search#%'
            order by r.Cliente asc
            OFFSET (#PageNumber# - 1) * #PageSize# ROWS 
            FETCH NEXT #PageSize# ROWS ONLY
        </cfquery>

        <cfset data = this.db.queryToArray(qClientes)>

        <cfset sreturn =  structNew()>
        <cfset sreturn.metadata = metadata>
        <cfset sreturn.items = data>

        <cfreturn sreturn>
    </cffunction>
</cfcomponent>