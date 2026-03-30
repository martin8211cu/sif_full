<cfcomponent displayname="Parametros" rest="true"
    restPath="/parametros" produces="application/json"
>
    <cfset dsn = "minisif">
    <cfset ecodigo = 2>

    <cffunction name="listaParametros" restPath="/lista/{codigo}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="codigo"  required="true"  type="string" restArgName="codigo"  restArgSource="path">
        
        <cfset Parametros = createObject("component","crc.Componentes.CRCParametros")>
        <cfset sreturn =  structNew()>
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            <cfset data = Parametros.GetParametro(
                codigo = arguments.codigo,
                conexion = dsn,
                Ecodigo = ecodigo
            )>
            <cfset sreturn.success = true>
            <cfset sreturn.data = {
                valor = data
            }>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener parámetro.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
</cfcomponent>