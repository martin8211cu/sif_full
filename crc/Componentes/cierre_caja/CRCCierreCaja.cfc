
<cfcomponent>

    <cffunction  name="TotalesCierreCaja">
        <cfargument  name="Mcodigo" required="true">
        <cfargument  name="FCid" required="true">
        <cfargument  name="FACid" default = "-1">
        <cfargument  name="dsn" default = "#session.DSN#">
        <cfargument  name="ecodigo" default = "#session.ecodigo#">
    
        <cfquery name="rsPagos" datasource="#arguments.dsn#">
            select
                sum(ETtotal - coalesce(ETmontoRetencion,0)) as MontoOriginal,
                    m.Msimbolo, m.Miso4217,
                    'Nota de Credito' as Origen
                    , 'C' as tipo
                    ,m.Mcodigo
                from  ETransacciones et
                    inner join Monedas m
                    on et.Mcodigo = m.Mcodigo
                    and et.Ecodigo = m.Ecodigo
                inner join CCTransacciones ct
                    on et.CCTcodigo = ct.CCTcodigo
                    and et.Ecodigo = ct.Ecodigo
                where et.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                    <cfif arguments.FACid eq -1 >
                        and et.FACid is null
                    <cfelse>
                        and et.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                    </cfif>
                    and et.ETestado = 'C'
                    and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                    and et.ETesLiquidacion = 0
                    and ct.CCTtipo = 'C'
                group by m.Msimbolo,m.Miso4217,m.Mcodigo
            UNION ALL
            select
                sum(ETtotal- coalesce(ETmontoRetencion,0)) as MontoOriginal,
                    m.Msimbolo,m.Miso4217,
                    'Facturas de credito' as Origen
                    , 'H' as tipo
                    ,m.Mcodigo
                from  ETransacciones et
                inner join Monedas m
                    on  et.Mcodigo = m.Mcodigo
                    and et.Ecodigo = m.Ecodigo
                inner join CCTransacciones ct
                    on et.CCTcodigo = ct.CCTcodigo
                    and et.Ecodigo   = ct.Ecodigo
                where et.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                    and et.ETesLiquidacion = 0
                    <cfif arguments.FACid eq -1 >
                        and et.FACid is null
                    <cfelse>
                        and et.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                    </cfif>
                    and et.ETestado = 'C'
                    and coalesce(ct.CCTvencim,0) <> -1
                    and ct.CCTtipo = 'D'
                    and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                group by m.Msimbolo,m.Miso4217,m.Mcodigo
            UNION ALL
            select
                sum(ETtotal- coalesce(ETmontoRetencion,0)) as MontoOriginal,
                    m.Msimbolo,m.Miso4217,
                    'Facturas de contado' as Origen
                    , 'F' as tipo
                    ,m.Mcodigo
                from  ETransacciones et
                inner join Monedas m
                    on  et.Mcodigo = m.Mcodigo
                    and et.Ecodigo = m.Ecodigo
                inner join CCTransacciones ct
                    on et.CCTcodigo = ct.CCTcodigo
                    and et.Ecodigo   = ct.Ecodigo
                where et.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                    and et.ETesLiquidacion = 0
                    <cfif arguments.FACid eq -1 >
                        and et.FACid is null
                    <cfelse>
                        and et.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                    </cfif>
                    and et.ETestado = 'C'
                    and ct.CCTvencim = -1
                    and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                group by m.Msimbolo,m.Miso4217,m.Mcodigo
            UNION ALL
                select (coalesce(a.MontoOriginal,0) + coalesce(b.MontoOriginal,0))  as MontoOriginal, c.Msimbolo,c.Miso4217,
                    'Liquidacion cobradores',
                    'L',
                    c.Mcodigo
                from (
                    select coalesce(  sum(Ptotal) ,0) as MontoOriginal , #Mcodigo#  as Moneda
                    from  HPagos p
                    inner join FALiquidacionRuteros  f
                        on f.NumLote = p.Plote
                        and f.Ecodigo = p.Ecodigo
                    where p.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                        and PesLiquidacion = 1
                        <cfif arguments.FACid eq -1 >
                            and p.FACid is null
                        <cfelse>
                            and p.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                        </cfif>
                        and f.estado = 'P'
                        <cfif arguments.FACid eq -1 >
                            and f.FACid is null
                        <cfelse>
                            and f.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                        </cfif>
                        and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                    ) as b
                    inner join  (
                        select
                            coalesce(sum(ETtotal- coalesce(ETmontoRetencion,0)) ,0) as MontoOriginal , #Mcodigo#   as Moneda
                        from  ETransacciones et
                            inner join FALiquidacionRuteros  f
                                on f.NumLote = et.ETlote
                                and f.Ecodigo = et.Ecodigo
                        where et.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                            <cfif arguments.FACid eq -1 >
                                and et.FACid is null
                            <cfelse>
                                and et.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                            </cfif>
                            and et.ETestado = 'C'
                            and f.estado = 'P'
                            <cfif arguments.FACid eq -1 >
                                and f.FACid is null
                            <cfelse>
                                and f.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                            </cfif>
                            and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                            and et.ETesLiquidacion = 1
                        ) as a
                        on a.Moneda= b.Moneda
                    inner join Monedas c
                        on c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
            UNION ALL
                select  (coalesce(a.MontoOriginal,0)
                        - coalesce(c.MontoComision,0))  as MontoOriginal,
                        m.Msimbolo,m.Miso4217,
                        'Recibos' as Origen ,
                        'R' as tipo,
                        a.Mcodigo
                from  (
                    select
                        coalesce( sum(Dtotalref - coalesce(BMmontoretori,0)),0) as MontoOriginal,
                            #Mcodigo# as Mcodigo
                        from  HPagos p
                        inner join BMovimientos b
                                on p.Ecodigo = b.Ecodigo
                                and p.CCTcodigo = b.CCTcodigo
                                and p.Pserie + convert(char,ltrim(p.Pdocumento))   = b.Ddocumento
                        inner join CCTransacciones t
                                on b.CCTcodigo = t.CCTcodigo
                                and b.Ecodigo = t.Ecodigo
                                and coalesce(t.CCTvencim,0) != -1
                        where p.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                        and PesLiquidacion = 0
                            <cfif arguments.FACid eq -1 >
                                and p.FACid is null
                            <cfelse>
                                and p.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                            </cfif>
                            and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                    ) as a
                    inner join (
                            select
                                coalesce(sum(
                                    case when  VolumenGNCheck 		= 1 then VolumenGN 			else 0 end
                                        + case when  VolumenGLRCheck 		= 1 then VolumenGLR 		else 0 end
                                        + case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		else 0 end
                                        + case when  ProntoPagoCheck 		= 1 then ProntoPago 		else 0 end
                                        + case when  ProntoPagoClienteCheck	= 1 then ProntoPagoCliente	else 0 end
                                        + case when  montoAgenciaCheck 		= 1 then montoAgencia 		else 0 end
                                        ) ,0) as MontoComision,
                                    #Mcodigo#	 as Mcodigo
                            from  HPagos p
                                inner join COMFacturas b
                                    on p.Ecodigo = b.Ecodigo
                                    and p.CCTcodigo = b.CCTcodigoE
                                    and p.Pcodigo = b.PcodigoE
                            where p.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                                and PesLiquidacion = 0
                                <cfif arguments.FACid eq -1 >
                                    and p.FACid is null
                                <cfelse>
                                    and p.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                                </cfif>
                                and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                        ) as c
                        on a.Mcodigo = c.Mcodigo
                    inner join Monedas m
                        on m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
            UNION ALL
                select
                    sum(Ptotal) as MontoOriginal,
                    m.Msimbolo,m.Miso4217,
                    'Devoluciones' as Origen
                    , 'D' as tipo
                    ,m.Mcodigo
                from  HPagos p
                    inner join Monedas m
                        on p.Mcodigo = m.Mcodigo
                        and p.Ecodigo = m.Ecodigo
                    inner join BMovimientos bm
                        on p.CCTcodigo = bm.CCTRcodigo
                        and p.Pcodigo = bm.DRdocumento
                        and p.Ecodigo = bm.Ecodigo
                    inner join SNegocios sn
                        on p.SNcodigo = sn.SNcodigo
                        and p.Ecodigo  = sn.Ecodigo
                where p.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
                    and PesLiquidacion = 0
                    and coalesce(PfacturaContado,'N') = 'D'
                    <cfif arguments.FACid eq -1 >
                        and p.FACid is null
                    <cfelse>
                        and p.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                    </cfif>
                    and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                group by m.Msimbolo,m.Miso4217,m.Mcodigo
            UNION ALL
                select
                    sum(dp.DPEmonto) as MontoOriginal,
                    m.Msimbolo,
                    m.Miso4217,
                    'CxC Empleados' as Origen,
                    'CxCE' as tipo,
                    m.Mcodigo
                from EPagosExtraordinarios ep
                    inner join DPagosExtraordinarios dp
                        on ep.EPEid = dp.EPEid
                    inner join Monedas m
                        on dp.Ecodigo = m.Ecodigo
                        and dp.Mcodigo = m.Mcodigo
                where dp.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
                    and ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                    and ep.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                    <cfif arguments.FACid eq -1 >
                        and ep.FACid is null
                    <cfelse>
                        and ep.FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FACid#">
                    </cfif>
                group by m.Msimbolo,m.Miso4217,m.Mcodigo
        </cfquery>
        <cfreturn rsPagos>
    </cffunction>

    <cffunction  name="DrawCierreCaja">
        <cfargument  name="CajaID"      required = "true">
        <cfargument  name="CierreID"    required = "true">
        <cfargument  name="dsn"         default = "#session.dsn#">
        <cfargument  name="ecodigo"     default = "#session.ecodigo#">

        <cfset FCid  = arguments.CajaID>
        <cfset FACid  = arguments.CierreID>

        <cfquery name="q_CierreCaja" datasource = "#arguments.dsn#">
            select FCAfecha from FACierres where FACid = #FACid# and ecodigo = #arguments.ecodigo#;
        </cfquery>
        
        
        <cfquery name="rsMonedaLocal" datasource="#arguments.DSN#">
            select convert(varchar,a.Mcodigo) as Mcodigo, m.Msimbolo, m.Miso4217, m.Mnombre 
            from Empresas a
                inner join Monedas m
                    on a.Mcodigo = m.Mcodigo
                    and a.Ecodigo = m.Ecodigo
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
        </cfquery>
        <cfset Msimbolo  = "#rsMonedaLocal.Msimbolo#">
        <cfset MCodigo  = "#rsMonedaLocal.Mcodigo#">
        <cfset Mnombre = "#rsMonedaLocal.Mnombre#">
        <cfset Miso4217 = "#rsMonedaLocal.Miso4217#">

        <cfquery name="rsCaja" datasource="#arguments.DSN#">
            select rtrim(FCcodigo)+', '+FCdesc as FCcaja, isnull(MontoFondeo,0) MontoFondeo
            from FCajas
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
        </cfquery>

        <cfset rsPagos = TotalesCierreCaja(Mcodigo=MCodigo,FCid=FCid,FACid=FACid)>

        <style type="text/css">
            .cajaMonedas{
                border:thin solid #0079C1;
                box-shadow: 2px 2px 5px #888888;
                margin:2em;
                font-size: 1.25em;
                padding-left:0;
                padding-right:0;

            }
            .cajaMonedas header{
                background-color: #0079C1;
                color: white;
                padding: 0.45em;
            }
            .cajaMonedas li{
                list-style: none;
                margin-left: -15;
                width:100%;
                margin:0;
                padding:0;
            }
            .cajaMonedas ul {
                margin:0;
                padding:0;
            }
            .cajaMonedas label{
                display: inline-block;
                font-style: normal;
                font-weight: bold;
                margin:0;
                text-align: right;
                width: 6em;
            }
            .cajaMonedas p{
                display: inline;
                font-style: normal;
                font-weight: normal;
                margin: 0;
                padding: 0;
            }
            .cajaMonedas .tablefooter{
                font-size: 1.2em;
                padding-left:0px;
                padding-right:0px;
            }
            .cajaMonedas .contenido{
                font-size: 0.7 em;
                padding-left:2px;
                padding-right:2px;
                width:100%;

            }
        </style>

        <cfsavecontent  variable="CierreHTML">
            <cfoutput>
                <strong><font size="2">Caja: #rsCaja.FCcaja#</font></strong>
                </br>
                <font size="2">Fecha de Cierre: #DateTimeFormat(q_CierreCaja.FCAfecha, 'dd/mm/yyyy HH:NN')#</font>
                <div class="cajaMonedas ">
                    <header>
                        <strong>Documentos facturados #Mnombre# (#Miso4217#)</strong>
                    </header>
                    <div class="contenido">
                        <cfset total = 0>
                        <table border="0" width="100%">
                            <cfloop query="rsPagos">
                                <tr>
                                    <td width="10px">
                                        <label>
                                            <cfscript>
                                                switch("#Tipo#"){
                                                    case "F": writeOutput("Fac. Cont:"); break;
                                                    case "L": writeOutput("Liquidacion:"); break;
                                                    case "R": writeOutput("Recibos:"); break;
                                                    case "C": writeOutput("Nota. Cred:"); break;
                                                    case "D": writeOutput("Devoluciones:"); break;
                                                    case "H": writeOutput("Fac. Cred:"); break;
                                                    case "CxCE": writeOutput("CxC.Empleados:"); break;
                                                    default: writeOutput("*Otros:"); break;
                                                }
                                            </cfscript>
                                        </label>
                                    </td>
                                    <td width="15px">
                                        <p>#Msimbolo# #LSNumberFormat(MontoOriginal, ',9.00')#</p>
                                    </td>
                                </tr>
                                <cfif Tipo neq 'C' and Tipo neq 'H'>
                                    <cfset total += MontoOriginal>
                                </cfif>
                            </cfloop>
                            <tr>
                                <td width="10px"> <label> Fondeo: </label> </td>
                                <td width="15px">
                                    <p>#Msimbolo# #LSNumberFormat(rsCaja.MontoFondeo, ',9.99')#</p>
                                    <input type="hidden" name="MontoFondeo" value="#LSNumberFormat(rsCaja.MontoFondeo, ',9.99')#"
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" >&nbsp; </td>
                            </tr>
                            <tr>
                                <td width="10px" class="tablefooter">
                                    <label>Total:</label>
                                </td>
                                <td width="15px" class="tablefooter">
                                    <strong>#Msimbolo##LSNumberFormat(total+rsCaja.MontoFondeo,',9.00')#</strong>
                                    <input type="hidden" value="#total#" id="total_#Miso4217#"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </cfoutput>
        </cfsavecontent>


        <cfreturn CierreHTML>

    </cffunction>

</cfcomponent>