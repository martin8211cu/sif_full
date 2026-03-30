
<cflock timeout = "30" type = "Exclusive"> 

    <cflog file="GeneraRecibosPagos" application="no"
    text="Inicia #now()#">

    <cftry>
        <cfquery datasource="asp" name="rscaches">
            select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
            from Empresa e
                join Caches c
                on e.Cid = c.Cid and e.Ereferencia is not null
        </cfquery>

        <cfloop query="rscaches">

            <cfquery name="qCortesACerrar" datasource="#rscaches.Ccache#">
                select id, Codigo, FechaInicio, FechaFin, status, FechaInicioSV, FechaFinSV,cerrado
                from CRCCortes 
                where Ecodigo  = #rscaches.Ecodigo#
                and (Tipo = 'D' and status = '1' and Cerrado = 1)
                and datediff(DAY,FechaFin, getdate()) > 0
            </cfquery>

            <cfif qCortesACerrar.recordCount neq 0>
                <cfloop query="qCortesACerrar">
                    <cfset GenerarRecibosPago = createObject("component", "crc.Componentes.GenerarRecibosPago")>
                    <cfset fileCount=0>
                    <cfset fileCount=GenerarRecibosPago.obtenerRecibosPago(dsn=rscaches.Ccache, ecodigo = rscaches.Ecodigo, corte = qCortesACerrar.Codigo, continuo = true)> 
                    <cfset fileCount=GenerarRecibosPago.obtenerRecibosPago(dsn=rscaches.Ccache, ecodigo = rscaches.Ecodigo, corte = qCortesACerrar.Codigo, continuo = true, acumulado = 1)> 
                    Recibos de Pagos Generados Para : <cfoutput>#qCortesACerrar.Codigo#</cfoutput><br>
                    <cfset EnvioCorreo = createObject("component", "EnvioCorreo")>
                    <cfset EnvioCorreo.envioCorreo(codCorte=qCortesACerrar.Codigo,fileCount=fileCount,contenido="",dsn=rscaches.Ccache,ecodigo=rscaches.Ecodigo,plantilla="RecibosPago-correo.cfm",subject="Recibos de pago generados")>
                    <cflog file="GeneraRecibosPagos" application="no"
                            text="Recibos de Pagos Generados Para : #qCortesACerrar.Codigo#">
                </cfloop>
            </cfif>
            
        </cfloop>

    <cfcatch type="any">
        <cflog file="GeneraRecibosPagos" application="no"
            text="Error: #cfcatch.stacktrace#">
    </cfcatch>
    <cffinally>
        <cflog file="GeneraRecibosPagos" application="no"
            text="Termina #now()#">
    </cffinally>
    </cftry>
    
</cflock>
