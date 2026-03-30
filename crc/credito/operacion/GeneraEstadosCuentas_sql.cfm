
    <!--- 
    Creado por Jose Gutierrez 
    17/04/2018
    --->
    <cfset returnTo="GeneraEstadosCuentas.cfm">
    <cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
    <cfset LB_TituloH 				= t.Translate('LB_TituloH','Avanzar Corte')>


    <cfset LvarPagina = "GeneraEstadosCuentas.cfm">

    <cfoutput>
        <cfif isDefined('form.Corte') and form.avanzar eq "1">  
            
            <!---se buscan los cortes con el campo cerrado = 0 ordenados descendentemente.
            se toma el la fecha fin del primer registro y se buscan en los siguientes
            que tenga igual fecha para que sean parte del proceso a cerrar --->
            <cfquery name="qCortesACerrar" datasource="#session.dsn#">
                select *
                from  CRCCortes c
                where Codigo = '#form.Corte#'
                and Ecodigo = #session.Ecodigo#
            </cfquery>
            
            <cftry>
                <cfset GeneraEstadoCuenta = createObject("component", "crc.Componentes.GenerarEstadosCuenta")>
                
                <cfset GeneraEstadoCuenta.obtenerEdosCuenta(
                        codCorte = qCortesACerrar.Codigo,
                        dsn = session.dsn,
                        ecodigo = session.Ecodigo
                    )>
                Estados de Cuenta Generados Para : <cfoutput>#qCortesACerrar.Codigo#</cfoutput><br>
            <cfcatch type="any">
                <cfthrow message="#cfcatch.message#">
            </cfcatch>
            </cftry>

        <cfelseif isDefined('form.avanzar') and form.avanzar eq "0"> 

            <cfquery name="qCortesACerrar" datasource="#session.dsn#">
                select *
                from  CRCCortes c
                where Codigo = '#form.CorteD#'
                and Ecodigo = #session.Ecodigo#
            </cfquery>

            <cftry>
                <cfset GenerarRecibosPago = createObject("component", "crc.Componentes.GenerarRecibosPago")>
                <cfset GenerarRecibosPago.obtenerRecibosPago(dsn=session.dsn, ecodigo = session.Ecodigo)> 
            <cfcatch type="exception">
                <cfthrow message="#cfcatch.message#">
            </cfcatch>
            </cftry>

        </cfif>
            

    </cfoutput>
    <!---VALIDADOR--->

    <cfoutput>
        <form action="#returnTo#" method="post" name="sql">
            <cfif isdefined("Form.Nuevo")>
                <input name="Nuevo" type="hidden" value="Nuevo">
            </cfif>
            <cfif isdefined("Form.Regresar")>
                <input name="Regresar" type="hidden" value="Regresar">
            </cfif>
            
        </form>

        <HTML>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
            <body>
                <script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
            </body>
        </HTML>

    </cfoutput>




