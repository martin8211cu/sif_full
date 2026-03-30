<cfcomponent displayname="Cliente" rest="true"
    restPath="/clientes" produces="application/json"
>
    <cfset dsn = "minisif">
    <cfset ecodigo = 2>

    <cffunction name="listaClientes" restPath="/lista/{snid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="snid"  required="true"  type="string" restArgName="snid"  restArgSource="path">
        <cfargument name="search" required="false" type="string" default="" restArgName="search"  restArgSource="query">
        <cfargument name="PageNumber" required="false" type="string" default="1" restArgName="PageNumber"  restArgSource="query">
        <cfargument name="PageSize" required="false" type="string" default="10" restArgName="PageSize"  restArgSource="query">

        <cfset Clientes = createObject("component","crc.Componentes.web.Cliente")>
        <cfset Clientes.init(dsn, ecodigo)>
        <cfset sreturn =  structNew()>
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            <cfset data = Clientes.obtenerClientes(
                SNID = arguments.snid,
                search = arguments.search,
                PageNumber = arguments.PageNumber,
                PageSize = arguments.PageSize
            )>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener el detalle del cliente.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
</cfcomponent>