<cfcomponent displayname="Corte" rest="true" 
    restPath="/cortes" produces="application/json">

    <cfset dsn = "minisif">
    <cfset ecodigo = 2>
    
    <cffunction name="listaCortes" restPath="/lista/{tipo}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="tipo"  required="true"  type="string" restArgName="tipo"  restArgSource="path">
        <cfargument name="cantidad"  required="false"  type="string" restArgName="cantidad"  restArgSource="query" default="3">
 
        <cfset Cortes = createObject("component","crc.Componentes.web.Corte")>
        <cfset Cortes.init(dsn, ecodigo)>

 		<cfset sreturn =  structNew()>
        <cftry>
            <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
            <cfset data = Cortes.obtenerUltimosCortesCerradosPorTipo(arguments.tipo, arguments.cantidad)>
            <cfset sreturn.success = true>
            <cfset sreturn.data = data>

            <cfcatch>
                <cfset sreturn.success = false>
                <cfset sreturn.message = "Error al obtener los cortes.">
                <cfset sreturn.detail = cfcatch.message>
            </cfcatch>

            <cffinally>
                <cfreturn sreturn>
            </cffinally>
        </cftry>
    </cffunction>

    <cffunction name="estadoCuenta" restPath="/estadoCuenta/{tipo}/{corte}/{cuentaid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="tipo"  required="true"  type="string" restArgName="tipo"  restArgSource="path">
        <cfargument name="corte"  required="true"  type="string" restArgName="corte"  restArgSource="path">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">

        <cfset Cuentas = createObject("component","crc.Componentes.web.Cuenta") >
        <cfset Cuentas.init(dsn, ecodigo)>
        <cfset Cortes = createObject("component","crc.Componentes.web.Corte")>
        <cfset Cortes.init(dsn, ecodigo)>

        <cfset cuenta = Cuentas.obtenerDetalleCuenta(arguments.cuentaid)>

        <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>
        <cfset fileName = "#arguments.corte#_#cuenta.Numero#">
        <cfset vsPath_R = "#ExpandPath(GetContextRoot())#">
        <cfset dirPath = "#vsPath_R#\DocCortes\#arguments.corte#\">
        <cfset filePath = "#dirPath##fileName#.pdf">

        <cfif !FileExists(filePath)>
            <cfset filePath = "#dirPath##fileName#_E.pdf">
        </cfif>
        <cfif !FileExists(filePath)>
            <cfthrow message="El estado de cuenta no existe."> 
        </cfif>

        <cfcontent type="application/pdf" file="#filePath#" deletefile="false" reset="true">
    </cffunction>
    
    <cffunction name="detalleCorte" restPath="/detalle/{cuentaid}/{corte}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">
        <cfargument name="corte"  required="true"  type="string" restArgName="corte"  restArgSource="path">

        <cfset result = structNew()>
        <cfset Cuentas = createObject("component","crc.Componentes.web.Cuenta") >
        <cfset Cuentas.init(dsn, ecodigo)>
        <cfset Cortes = createObject("component","crc.Componentes.web.Corte")>
        <cfset Cortes.init(dsn, ecodigo)>
        <cfset result.corte = Cortes.obtenerDetalleCorte(arguments.corte)>
        <cfset datosProcesados = Cortes.obtenerMovimientos(arguments.corte, arguments.cuentaid)>
        <cfset arrayAppend(datosProcesados.ARRAYMOVCUENTA, datosProcesados.ARRAYMOVCUENTASG, true)>
        <cfset result.movimientos = datosProcesados.ARRAYMOVCUENTA>
        <cfset result.totales = datosProcesados.TOTALES>

        <cfreturn result>
    </cffunction>
    
    <cffunction name="recibosPagos" restPath="/recibos/{corte}/{cuentaid}" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
        <cfargument name="corte"  required="true"  type="string" restArgName="corte"  restArgSource="path">
        <cfargument name="cuentaid"  required="true"  type="string" restArgName="cuentaid"  restArgSource="path">

        <cfset createObject("component","WS.crc.Auth").ValidateApiKey()>

        <cfset codCorte = arguments.corte>
        <cfset vsPath_R = "#ExpandPath(GetContextRoot())#">
        <cfset dirPath="#vsPath_R#\DocCortes\#codCorte#\">
        
        <cfset fileName="#arguments.corte#_#arguments.cuentaid#RP">
        <cfset filePath="#dirPath##fileName#.pdf">
        <cfif !FileExists(filePath)>
            <cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
            
            <cfset pdf = objEstadoCuenta.createReciboPago(
                    CodigoSelect	= "#arguments.corte#"
                ,	CuentaId		= "#arguments.cuentaid#"
                ,	dsn				= dsn
                ,	ecodigo			= ecodigo
                ,	saveAs			= "#fileName#"
                )>
        </cfif>

        <cfif !FileExists(filePath)>
            <cfthrow message="El recibo de pago no existe."> 
        </cfif>

        <cfcontent type="application/pdf" file="#filePath#" deletefile="false" reset="true">
    </cffunction>
</cfcomponent>