<cfcomponent displayname="Transacciones" rest="true" 
    restPath="/transacciones" produces="application/json">

    <cfset dsn = "minisif">
    <cfset ecodigo = 2>

    <cffunction name="listaTransacciones" restPath="/lista/{snid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="snid"  required="true"  type="string" restArgName="snid"  restArgSource="path">
        <cfargument name="cuentaid"  required="false"  type="string" default="" restArgName="cuentaid"  restArgSource="query">
        <cfargument name="PageNumber" required="false" type="string" default="1" restArgName="PageNumber"  restArgSource="query">
        <cfargument name="PageSize" required="false" type="string" default="10" restArgName="PageSize"  restArgSource="query">
        <cfargument name="TipoTransaccion" required="false" type="string" default="ALL" restArgName="TipoTransaccion"  restArgSource="query">

        <cfset Transacciones = createObject("component","crc.Componentes.web.Transacciones")>
        <cfset Transacciones.init(dsn, ecodigo)>
        <cfset sreturn =  structNew()>
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            
            <cfset data = Transacciones.obtenerTransacciones(
                SNID=arguments.snid,
                CuentaId=arguments.cuentaid, 
                PageNumber=arguments.PageNumber, 
                PageSize=arguments.PageSize,
                TipoTransaccion=arguments.TipoTransaccion
            )>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener las transacciones.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name="listaTransaccionesCliente" restPath="/lista/{snid}/cliente/{curp}" access="remote"  httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="snid"  required="true"  type="string" restArgName="snid"  restArgSource="path">
        <cfargument name="curp"  required="true"  type="string" restArgName="curp"  restArgSource="path">
        <cfargument name="PageNumber" required="false" type="string" default="1" restArgName="PageNumber"  restArgSource="query">
        <cfargument name="PageSize" required="false" type="string" default="10" restArgName="PageSize"  restArgSource="query">

        <cfset Transacciones = createObject("component","crc.Componentes.web.Transacciones")>
        <cfset Transacciones.init(dsn, ecodigo)>
        <cfset sreturn =  structNew()>
        <cftry>

            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

            <cfset data = Transacciones.obtenerTransaccionesClientes(
                SNID=arguments.snid,
                CURP=arguments.curp, 
                PageNumber=arguments.PageNumber, 
                PageSize=arguments.PageSize
            )>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener las transacciones.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
    
    <cffunction name="transactionDetalle" restPath="/transaccion/{transaccionid}" access="remote"  httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="transaccionid"  required="true"  type="string" restArgName="transaccionid"  restArgSource="path">

        <cfset Transacciones = createObject("component","crc.Componentes.web.Transacciones")>
        <cfset Transacciones.init(dsn, ecodigo)>
        <cfset sreturn =  structNew()>
        <cftry>

            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

            <cfset data = Transacciones.obtenerDetalleTransaccion(arguments.transaccionid)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener las transacciones.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
</cfcomponent>