
<cflock timeout = "30" type = "Exclusive"> 
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
            and ((Tipo <> 'TM' and status = '0' and Cerrado = 0) or (Tipo ='TM' and status = 1))
            and datediff(DAY,FechaFin, getdate()) > 0
        </cfquery>

        <cfdump var="#qCortesACerrar#">

        <cfif qCortesACerrar.recordCount neq 0>
            <cfloop query="qCortesACerrar">
                <cfset CRCProcesoCorte = createObject("component", "crc.Componentes.cortes.CRCProcesoCorte").
                                            init(Ecodigo=rscaches.Ecodigo, conexion="#rscaches.Ccache#")>
                <cfset contenido=''>
                <cfset contenido=CRCProcesoCorte.procesarCorte()>
                Proceso de cierre de corte realizado : <cfoutput>#qCortesACerrar.Codigo#</cfoutput><br>
                <cfset EnvioCorreo = createObject("component", "EnvioCorreo")>
                <cfset EnvioCorreo.envioCorreo(codCorte=qCortesACerrar.Codigo,fileCount="0",contenido=contenido,dsn=rscaches.Ccache,ecodigo=rscaches.ecodigo,plantilla="ProcesoCorte-correo.cfm",subject="Proceso de corte generado")>
            </cfloop>
        </cfif>
        
    </cfloop>
</cflock>
