<cfcomponent displayname="Autenticacion" rest="true" restPath="/auth" produces="application/json">

    <cfset dsn = "minisif">
    <cfset ecodigo = 2>

    <cffunction name="enviar_codigo_verificacion" restPath="/enviar_codigo_verificacion" access="remote" httpMethod="POST" consumes="application/json" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="body" type="struct" required="true">
        <cfset var email = arguments.body.email>

        <cfset WSAutenticacion = createObject("component","crc.Componentes.web.WSAutenticacion")>
        <cfset WSAutenticacion.init(dsn, ecodigo)>

        <cfset sreturn =  structNew()>
        <cftry>
            <cfset data = WSAutenticacion.enviarCodigoVerificacion(email=email)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al enviar el codigo de verificacion.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name="verificar_codigo" restPath="/verificar_codigo" access="remote" httpMethod="POST" consumes="application/json" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="body" type="struct" required="true">

        <cfset WSAutenticacion = createObject("component","crc.Componentes.web.WSAutenticacion")>
        <cfset WSAutenticacion.init(dsn, ecodigo)>

        <cfset var email = arguments.body.email>
        <cfset var codigo = arguments.body.codigo>

        <cfset sreturn =  structNew()>
        <cftry>
            <cfset data = WSAutenticacion.verificarCodigo(email, codigo)>
            <cfset sreturn.success = data.success>
            <cfif data.success>
                <cfset sreturn.data = data.user>
            <cfelse>
                <cfset sreturn.message = data.message>
            </cfif>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al verificar el codigo de verificacion.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
    
    <cffunction name="obtener_socio" restPath="/obtener_socio" access="remote" httpMethod="POST" consumes="application/json" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="body" type="struct" required="true">

        <cfset WSAutenticacion = createObject("component","crc.Componentes.web.WSAutenticacion")>
        <cfset WSAutenticacion.init(dsn, ecodigo)>

        <cfset var email = arguments.body.email>

        <cfset sreturn =  structNew()>
        <cftry>
            <cfset data = WSAutenticacion.obtenerSocioPorEmail(email)>
            <cfset sreturn.success = data.success>
            <cfif data.success>
                <cfset sreturn.data = data.user>
            <cfelse>
                <cfset sreturn.message = data.message>
            </cfif>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener el Socio de Negocio.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
</cfcomponent>