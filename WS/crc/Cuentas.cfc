<cfcomponent displayname="Cuenta" rest="true" 
    restPath="/cuentas" produces="application/json">

    <cfset dsn = "minisif">
    <cfset ecodigo = 2>
    
    <cffunction name="listaCuentas" restPath="/lista/{snid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="snid"  required="true"  type="string" restArgName="snid"  restArgSource="path">
 
        <cfset Cuentas = createObject("component","crc.Componentes.web.Cuenta")>
        <cfset Cuentas.init(dsn, ecodigo)>

 		<cfset sreturn =  structNew()>
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            <cfset data = Cuentas.obtenerCuentasPorSNid(arguments.snid)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener las cuentas.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name="detalleCuenta" restPath="/detalle/{cuentaid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">

        <cfset Cuentas = createObject("component","crc.Componentes.web.Cuenta") >
        <cfset Cuentas.init(dsn, ecodigo)>

        <cfset sreturn =  structNew()>
        <cftry> 
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            <cfset data = Cuentas.obtenerDetalleCuenta(arguments.cuentaid)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener el detalle de la cuenta.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name="infoCuenta" restPath="/info/{cuentaid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">

        <cfset Cuentas = createObject("component","crc.Componentes.web.Cuenta") >
        <cfset Cuentas.init(dsn, ecodigo)>

        <cfset sreturn =  structNew()>
        <cftry> 
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            <cfset data = Cuentas.obtenerInformacionCuenta(arguments.cuentaid)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener informacion de la cuenta.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
    
    <cffunction name="historicoCuenta" restPath="/historico/{cuentaid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">

        <cfset sreturn =  structNew()>
        <cfset sreturn.success = true>
        <cfset sreturn.message = "El servicio de cuentas esta funcionando correctamente.">
        <cfreturn sreturn>
    </cffunction>
</cfcomponent>