<cfsetting requestTimeOut = "3600">
<cflock timeout = "30" type = "Exclusive"> 

    <cflog file="GeneraRecibosPagos" application="no" text="Inicia #now()#">

    <cfparam  name="tipo" default="X">
    <cfif isdefined("url.tipo") and url.tipo neq "">
        <cfset tipo = url.tipo>
    </cfif>
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
            and (Tipo <> 'TM' and status = '1' and Cerrado = 1)
            <cfif isdefined("url.tipo") and url.tipo neq "">
                and Tipo = '#tipo#'
            </cfif>
            and datediff(DAY,FechaFin, getdate()) > 0
        </cfquery>
        
        <cfif qCortesACerrar.recordCount neq 0>
            
            <cfloop query="qCortesACerrar">
                <cftry>
                    <cfset GeneraEstadoCuenta = createObject("component", "crc.Componentes.GenerarEstadosCuenta")>
                    <cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")> 
                    <cfset countEstadosCuenta=''>
                    <cfset countEstadosCuenta=GeneraEstadoCuenta.obtenerEdosCuenta(
                            codCorte = qCortesACerrar.Codigo,
                            dsn = rscaches.Ccache,
                            ecodigo = rscaches.Ecodigo
                        )>
                    
                    Estados de Cuenta Generados Para : <cfoutput>#qCortesACerrar.Codigo#</cfoutput><br>
                    <cfif countEstadosCuenta neq ''>
                        <cfset EnvioCorreo = createObject("component", "EnvioCorreo")>
                        <cfset EnvioCorreo.envioCorreo(codCorte=qCortesACerrar.Codigo,fileCount=countEstadosCuenta,contenido="",dsn=rscaches.Ccache,ecodigo=rscaches.ecodigo,plantilla="EstadoCuenta-correo.cfm",subject="Estado de cuenta generado")>
                    </cfif>
                    <!--- Envio de Correo--->
                    <cfset paramInfo = crcParametros.GetParametroInfo(codigo="30300108",conexion="#rscaches.Ccache#",ecodigo=#rscaches.Ecodigo#,descripcion="Envio automatico de Estados de Cuenta" )>
                    <cfset emailInfo = crcParametros.GetParametroInfo(codigo="30300109",conexion="#rscaches.Ccache#",ecodigo=#rscaches.Ecodigo#,descripcion="Direccion email para envios de correo" )>
                    
                    <cfif paramInfo.valor neq "" and paramInfo.valor neq "0">

                        <cfquery name="qCuentasCorte" datasource="#rscaches.Ccache#">
                            select
                            co.Codigo Corte, 
                            ct.Numero Cuenta, 
                            co.Tipo tipoCorte, 
                            ct.Tipo tipoCuenta,
                            ct.id idCuenta,
                            ct.Numero, 
                            sn.SNnombre,
                            sn.SNemail,
                            sn.SNenviarEmail
                            from CRCCuentas ct
                            inner join CRCCortes co
                            on ct.Tipo = co.Tipo
                            inner join SNegocios sn on sn.SNid = ct.SNegociosSNid
                            inner join CRCMovimientoCuentaCorte mcc
                            on ct.id = mcc.CRCCuentasId
                            and co.Codigo = mcc.Corte
                            inner join CRCEstatusCuentas ec on ec.id = ct.CRCEstatusCuentasid
                            where ec.Orden < ( select id 
                                    from CRCEstatusCuentas
                                    where Orden = (select Pvalor 
                                                    from CRCParametros 
                                                    where Pcodigo = '30300110' and Ecodigo = #rscaches.Ecodigo#)
                            )
                                and co.Codigo = '#qCortesACerrar.Codigo#'
                                and mcc.MontoAPagar > 0
                                and SNenviarEmail = 1
                            <cfif paramInfo.valor NEQ "A">
                                    and ct.TIpo = '#paramInfo.valor#'
                            </cfif>
                            order by Cuenta
                
                        </cfquery>

                        <cftry>
                            
                            <!--- Rutas --->
                            <cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
                            <cfif REFind('(cfmx)$',vsPath_R) gt 0> 
                                <cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
                            <cfelse> 
                                <cfset vsPath_R = "#vsPath_R#\">
                            </cfif>

                            <cfif #Trim(qCuentasCorte.tipoCorte)# eq 'TM'>
                                <!--- <cfset dir = CheckDir("#vsPath_R#DocCortes\#qCortesACerrar.Codigo#")> --->
                                <cfset dirPath="#vsPath_R#DocCortes\#qCortesACerrar.Codigo#\">
                            <cfelse>
                                <!--- <cfset dir = CheckDir("#vsPath_R#DocCortes\#qCortesACerrar.Codigo#")> --->
                                <cfset dirPath="#vsPath_R#DocCortes\#qCortesACerrar.Codigo#\">
                            </cfif>
                            
                            <cfloop query="#qCuentasCorte#">
                                <cfset fileName="#qCortesACerrar.Codigo#_#qCuentasCorte.Numero#_E">
                                <cfset fileNameTotal="#qCortesACerrar.Codigo#_E.pdf">
                                <cfset filePath="#dirPath##fileName#.pdf">

                                <cfset SMTP = createObject( "component","asp.admin.correo.SMTPQueue")>
                                <cfset pdf = SMTP.createEmail(
                                            from = "#emailInfo.valor#"
                                            , to = "#qCuentasCorte.SNemail#"
                                            , subject = "Estado de Cuenta #qCortesACerrar.Codigo#" 
                                            , body =  "Se envio Estado de Cuenta Num. #qCortesACerrar.Codigo#"
                                            , attachmentPath = "#filePath#"
                                            , attachmentExt = "pdf"
                                            , send = "true"
                                )>
                                
                            </cfloop>
                            <!--- FIN CAMBIO: OPARRALES 2018-09-10 Modificacion para enviar correo con archivos y quede registrada la accion en BD --->
                        <cfcatch>
                            <cfrethrow>
                        </cfcatch>
                        </cftry>
                    </cfif>
                <cfcatch type="any">
                    <cfrethrow>
                    <cflog file="GeneraRecibosPagos" application="no"
                        text="Error: #cfcatch.stacktrace#">
                </cfcatch>
                <cffinally>
                    <cflog file="GeneraRecibosPagos" application="no"
                        text="Termina #now()#">
                </cffinally>
                </cftry>   
            </cfloop>

        </cfif>
        
    </cfloop>

</cflock>
