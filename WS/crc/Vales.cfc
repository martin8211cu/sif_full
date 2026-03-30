<cfcomponent displayname="Vales" rest="true" 
    restPath="/vales" produces="application/json">

    <cfset dsn = "minisif">
    <cfset ecodigo = 2>

    <cffunction name="listaVales" restPath="/lista/{cuentaid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">
        <cfargument name="estado"  required="false"  type="string" default="" restArgName="estado"  restArgSource="query">
        <cfargument name="search"  required="false"  type="string" default="" restArgName="search"  restArgSource="query">
        <cfargument name="PageNumber" required="false" type="string" default="1" restArgName="PageNumber"  restArgSource="query">
        <cfargument name="PageSize" required="false" type="string" default="10" restArgName="PageSize"  restArgSource="query">

        
        <cfset Vales = createObject("component","crc.Componentes.web.Vales")>
        <cfset Vales.init(dsn, ecodigo)>
        <cfset sreturn =  structNew()>
        
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

            <cfset data = Vales.obtenerVales(
                CUENTAID=arguments.cuentaid,
                ESTADO=arguments.estado, 
                SEARCH=arguments.search,
                PageNumber=arguments.PageNumber, 
                PageSize=arguments.PageSize
            )>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener los Vales.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name="obtenerVale" restPath="/folio/{numero}" access="remote"  httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="numero"  required="true"  type="string" restArgName="numero"  restArgSource="path">

        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

            <cfset Vales = createObject("component","crc.Componentes.web.Vales")>
            <cfset Vales.init(dsn, ecodigo)>
            
            <cfset sreturn =  structNew()>
            <cfset data = Vales.obtenerVale(NUMERO=arguments.numero)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener Vale.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
    
    <cffunction name="cancelarVale" restPath="/cancel/{numero}" access="remote"  httpMethod="PUT" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="numero"  required="true"  type="string" restArgName="numero"  restArgSource="path">

        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

            <cfset Vales = createObject("component","crc.Componentes.web.Vales")>
            <cfset Vales.init(dsn, ecodigo)>
            
            <cfset sreturn =  structNew()>
            <cfset data = Vales.cancelarVale(NUMERO=arguments.numero)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al cancelar Vale.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
    
    <cffunction name="crearVale" restPath="/folio" access="remote"  httpMethod="POST" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="body" type="struct" required="true">

        
        <cfset Vales = createObject("component","crc.Componentes.web.Vales")>
        <cfset Vales.init(dsn, ecodigo)>
        
        <cfset var cuentaid = arguments.body.cuentaid>
        <cfset var cliente = arguments.body.cliente>
        <cfset var curp = arguments.body.curp>
        <cfset var monto = arguments.body.monto>
        <cfset var direccion = arguments.body.direccion>
        
        <cfset sreturn =  structNew()>
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

            <cfset data = Vales.crearVale(CUENTAID=cuentaid, CLIENTE=cliente, CURP=curp, MONTO=monto, DIRECCION=direccion)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>
            
            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al crear Vale.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>
            
            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>
</cfcomponent>