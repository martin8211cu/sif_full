
<cfcomponent>

    <cfset this.dsn = "minisif">
    <cfset this.ecodigo = 0>

    <cffunction  name="init" access="public">
        <cfargument  name="dsn" required="true">
        <cfargument  name="ecodigo" required="true">
        
        <cfset this.dsn = arguments.dsn>
        <cfset this.ecodigo = arguments.ecodigo>

        <cfreturn this>
    </cffunction>

    <cffunction  name="sincroniza" access="public">
        <cfargument  name="corte" required="true">
        <cfargument  name="ecodigo" required="false" default="#this.ecodigo#">
        
        <cfif this.ecodigo eq 0>
            <cfthrow message="No se definido el codigo de Empresa">
        </cfif>                    
                
        <cfset corte = arguments.corte>
        
        <!--- CORTES --->
        <cfquery name="rsCortes" datasource="#this.dsn#">
            select id, case Tipo when 'D' then 0 else 1 end ModelCode, Tipo, Codigo, FechaInicio, FechaFin, dateadd(day,-1,FechaInicioSV) FechaFinSV
            from CRCCortes
            where Ecodigo = #this.ecodigo#
                and Codigo = '#corte#'
        </cfquery>
        
        <cfloop query="rsCortes">
            <cfquery name="existeCorte" datasource="EstadoCuentaWeb">
                SELECT * FROM [Administrador].[Periodo] WHERE [NumPeriodo] = #rsCortes.id# and [ModelCode] = #rsCortes.ModelCode#
            </cfquery>
            <cfif existeCorte.recordCount gt 0>
                <cfquery datasource="EstadoCuentaWeb">
                    UPDATE [Administrador].[Periodo]
                        SET [FechaInicio] = '#rsCortes.FechaInicio#'
                            ,[FechaFin] = '#rsCortes.FechaFin#'
                    WHERE [NumPeriodo] = #rsCortes.id# and [ModelCode] = #rsCortes.ModelCode#;
                </cfquery>
            <cfelse>
                <cfquery datasource="EstadoCuentaWeb">     
                    INSERT [Administrador].[Periodo] ( [NumPeriodo],[ModelCode],[FechaInicio],[FechaFin] )
                    VALUES (#rsCortes.id#, #rsCortes.ModelCode#, '#rsCortes.FechaInicio#', '#rsCortes.FechaFin#' );
                </cfquery>
            </cfif>
        
            <!--- CLIENTES --->
            <cfquery name="qCuentasCorte" datasource="#this.dsn#">
                select
                    co.Codigo Corte, 
                    co.Tipo tipoCorte, 
                    ct.Tipo tipoCuenta,
                    ct.id idCuenta,
                    ct.Numero NumeroCuenta,  
                    SNcodigoext ClienteID, 
                    isnull(ct.saldoAFavor,0) saldoAFavor,
                    case when charindex(',', s.SNnombre) = 0
                        then left(ltrim(rtrim(s.SNnombre)),charindex(' ', s.SNnombre) -1)
                        else left(ltrim(rtrim(s.SNnombre)),charindex(',', s.SNnombre) -1)
                    end Nombre,
                    case when charindex(',', s.SNnombre) = 0
                        then substring(s.SNnombre,charindex(' ', s.SNnombre),len(s.SNnombre))
                        else substring(s.SNnombre,charindex(',', s.SNnombre) +1,len(s.SNnombre))
                    end Apellidos,
                    s.SNnombre,
                    s.SNemail Email,
                    left(s.SNdireccion,50) Direccion,
                    left(s.SNdireccion,50) DireccionAuxiliar,
                    sd.ciudad Ciudad,
                    sd.codPostal CP,
                    s.SNtelefono Telefono,
                    s.TarjH EsTarjetaHabiente,
                    s.disT EsDistribuidor,	
                    ct.CRCEstatusCuentasid EstatusCliente  
                from CRCCuentas ct
                inner join SNegocios s
                    on ct.SNegociosSNid = s.SNid
                inner join DireccionesSIF sd
                    on s.id_direccion = sd.id_direccion
                inner join CRCCortes co
                    on ct.Tipo = co.Tipo
                left join CRCMovimientoCuentaCorte mcc
                    on ct.id = mcc.CRCCuentasId
                    and co.Codigo = mcc.Corte
                inner join CRCEstatusCuentas ec on ec.id = ct.CRCEstatusCuentasid
                where co.Codigo = '#rsCortes.Codigo#'
                    <!--- and mcc.MontoAPagar > 0 --->
                    and  ec.Orden < ( select id 
                                    from CRCEstatusCuentas
                                    where Orden = (select Pvalor 
                                                    from CRCParametros 
                                                    where Pcodigo = '30300110' and Ecodigo = #this.Ecodigo#)
                            )
            </cfquery>
        
            <cfloop query="qCuentasCorte">
                <!--- SE INSERTA O ACTUALIZA CLIENTE --->
                <cfquery name="existeCuenta" datasource="EstadoCuentaWeb">
                    SELECT * FROM Cliente WHERE [ClienteID] = #qCuentasCorte.idCuenta#
                </cfquery>
                <cfif existeCuenta.recordCount gt 0>
                    <cfquery datasource="EstadoCuentaWeb">
                        UPDATE Cliente
                            SET [NumeroCuenta] = '#qCuentasCorte.NumeroCuenta#'
                                ,[Nombre] = '#qCuentasCorte.Nombre#'
                                ,[Apellidos] = '#qCuentasCorte.Apellidos#'
                                ,[Email] = '#qCuentasCorte.Email#'
                                ,[Direccion] = '#qCuentasCorte.Direccion#'
                                ,[DireccionAuxiliar] = '#qCuentasCorte.DireccionAuxiliar#'
                                ,[Ciudad] = '#qCuentasCorte.Ciudad#'
                                ,[CP] = '#qCuentasCorte.CP#'
                                ,[Telefono] = '#qCuentasCorte.Telefono#'
                                ,[EsTarjetaHabiente] = #qCuentasCorte.EsTarjetaHabiente#
                                ,[EsDistribuidor] = #qCuentasCorte.EsDistribuidor#
                                ,[EstatusCliente] = #qCuentasCorte.EstatusCliente#
                        WHERE [ClienteID] = #qCuentasCorte.idCuenta#;
                    </cfquery>
                <cfelse>
                    <cfquery datasource="EstadoCuentaWeb">     
                        INSERT Cliente ( [ClienteID],[NumeroCuenta],[Nombre],[Apellidos],[Email],[Direccion],[DireccionAuxiliar],
                                        [Ciudad],[CP],[Telefono],[EsTarjetaHabiente],[EsDistribuidor],[EstatusCliente] )
                        VALUES (#qCuentasCorte.idCuenta#,'#qCuentasCorte.NumeroCuenta#','#qCuentasCorte.Nombre#','#qCuentasCorte.Apellidos#',
                                '#qCuentasCorte.Email#','#qCuentasCorte.Direccion#','#qCuentasCorte.DireccionAuxiliar#','#qCuentasCorte.Ciudad#',
                                '#qCuentasCorte.CP#','#qCuentasCorte.Telefono#',#qCuentasCorte.EsTarjetaHabiente#,#qCuentasCorte.EsDistribuidor#, 
                                #qCuentasCorte.EstatusCliente# );
                    </cfquery>
                </cfif>
        
                <cfset CuentaID = qCuentasCorte.idCuenta>
                <cfset CodCorte = qCuentasCorte.Corte>
                <cfset arguments.Tipo = qCuentasCorte.tipoCuenta>
                <cfinclude template="../../../crc/credito/reportes/EstadosCuenta_querys.cfm">
        
                <!--- DATOS CORTE --->
                <cfif rsCortes.ModelCode>
                    <!--- TARJETAHABIENTES --->
                    <!--- SE INSERTA O ACTUALIZA CABECERA --->
                    <cfquery name="existeCab" datasource="EstadoCuentaWeb">
                        SELECT * FROM [Tarjetahabiente].[CabeceraT] WHERE [PeriodNum] = #rsCortes.id# and [ClienteId] = #qCuentasCorte.idCuenta#
                    </cfquery>
                    <cfif existeCab.recordCount gt 0>
                        <cfquery datasource="EstadoCuentaWeb">
                            UPDATE [Tarjetahabiente].[CabeceraT]
                                SET [AccountNumber] = '#qCuentasCorte.NumeroCuenta#'
                                    ,[Tarjetahabiente] = '#qCuentasCorte.SNnombre#'
                                    ,[Colonia] = ''
                                    ,[Calle] = '#left(qCuentasCorte.Direccion,50)#'
                                    ,[Ciudad] = '#qCuentasCorte.Ciudad#'
                                    ,[Estado] = '#q_infoCuenta.Estado#'
                                    ,[CP] = '#qCuentasCorte.CP#'
                                    ,[FechaCorte] = '#left(rsCortes.FechaFin,10)#'
                                    ,[FechaLimite] = '#left(rsCortes.FechaFinSV,10)#'
                                    ,[PagoMinimo] = #(q_resumen.PagoMinimo neq "") ? q_resumen.PagoMinimo :0#
                                    ,[CreditLimit] = #(q_resumen.MontoAprobado neq "") ? q_resumen.MontoAprobado :0#
                                    ,[PagoSI] = #(trim(q_ResumenCorte.MontoAPagar) neq "") ? q_ResumenCorte.MontoAPagar : 0#
                                    ,[Comment] = 'ESTIMADO TARJETAHABIENTE CONSULTE SU ESTADO DE CUENTA EN www.tiendasfull.com TELS; 7-29-41-29/30'
                                    ,[CustStatus] = #qCuentasCorte.EstatusCliente#
                                    ,[Pagos] = #(q_resumen.TodosLosPagos neq "") ? q_resumen.TodosLosPagos :0#
                                    ,[Compras] = #(q_resumen.Compras neq "") ? q_resumen.Compras :0#
                                    ,[Intereses] = #(q_resumen.Intereses neq "") ? q_resumen.Intereses :0#
                                    ,[SaldoActual] = #(q_resumen.SaldoActual neq "") ? q_resumen.SaldoActual :0#
                                    ,[UltimoPeriodo] = '#dateformat(left(rsCortes.FechaInicio,10),"YYYY/MM/DD")#'
                                    ,[Periodo] = '#dateformat(left(rsCortes.FechaFin,10),"YYYY/MM/DD")#'
                                    ,[PagosFavor] = #qCuentasCorte.saldoAFavor#
                            WHERE [PeriodNum] = #rsCortes.id# and [ClienteID] = #qCuentasCorte.idCuenta#;
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="EstadoCuentaWeb">     
                            INSERT [Tarjetahabiente].[CabeceraT] 
                            ( [ClienteID],[PeriodNum],[AccountNumber],[Tarjetahabiente],[Colonia],[Calle],[Ciudad],[Estado],
                                [CP],[FechaCorte],[FechaLimite],[PagoMinimo],[CreditLimit],[PagoSI],[Comment],
                                [CustStatus],[Pagos],[Compras],[Intereses],[SaldoActual],[UltimoPeriodo],[Periodo],[PagosFavor] )
                            VALUES (#qCuentasCorte.idCuenta#,#rsCortes.id#,'#qCuentasCorte.NumeroCuenta#','#qCuentasCorte.SNnombre#','',
                                    '#left(qCuentasCorte.Direccion,50)#','#qCuentasCorte.Ciudad#','#q_infoCuenta.Estado#','#qCuentasCorte.CP#',
                                    '#left(rsCortes.FechaFin,10)#','#left(rsCortes.FechaFinSV,10)#',
                                    #(q_resumen.PagoMinimo neq "") ? q_resumen.PagoMinimo : 0#,
                                    #(q_resumen.MontoAprobado neq "") ? q_resumen.MontoAprobado : 0#,
                                    #(q_ResumenCorte.MontoAPagar neq "") ? q_ResumenCorte.MontoAPagar : 0#,
                                    null,#qCuentasCorte.EstatusCliente#,
                                    #(q_resumen.TodosLosPagos neq "") ? q_resumen.TodosLosPagos : 0#,
                                    #(q_resumen.Compras neq "") ? q_resumen.Compras : 0#,
                                    #(q_resumen.Intereses neq "") ? q_resumen.Intereses : 0#,
                                    #(q_resumen.SaldoActual neq "") ? q_resumen.SaldoActual : 0#,
                                    '#dateformat(left(rsCortes.FechaInicio,10),"YYYY/MM/DD")#',
                                    '#dateformat(left(rsCortes.FechaFin,10),"YYYY/MM/DD")#',#qCuentasCorte.saldoAFavor# );
                        </cfquery>
                    </cfif>
        
                    <!--- SE INSERTA O ACTUALIZA DETALLE MOVIMIENTO --->
                    <cfquery datasource="EstadoCuentaWeb">     
                        delete from [Tarjetahabiente].[DetalleMovimiento]
                        WHERE [NumeroPeriodo] = #rsCortes.id# and [ClienteID] = #qCuentasCorte.idCuenta#
                    </cfquery>
                    <cfif q_transacciones.recordCount gt 0>
        
                        <cfloop query="q_transacciones">
                            <cfquery datasource="EstadoCuentaWeb"> 
                                INSERT INTO [Tarjetahabiente].[DetalleMovimiento]
                                    ([ClienteID],[NumeroPeriodo],[Tienda],[Tipo],[Folio],[Descripcion],[Importe],[Fecha])
                                VALUES
                                    (#qCuentasCorte.idCuenta#
                                    ,#rsCortes.id#
                                    ,'#q_transacciones.Tienda#'
                                    ,'#left(q_transacciones.Tipo,20)#'
                                    ,'#q_transacciones.id#'
                                    ,'#left(q_transacciones.Descripcion,20)#'
                                    ,#q_transacciones.Monto#
                                    ,'#q_transacciones.Fecha#')
                            </cfquery>
                        </cfloop>
        
                    </cfif>
                    
                    <!--- SE INSERTA O ACTUALIZA DESGLOSE OPERACION --->
                    <cfquery datasource="EstadoCuentaWeb">     
                        delete from [Tarjetahabiente].[DesgloseOperacion]
                        WHERE [NumeroPeriodo] = #rsCortes.id# and [ClienteID] = #qCuentasCorte.idCuenta#
                    </cfquery>
                    <cfif q_tarjetas.recordCount gt 0>
        
                        <cfloop query="q_tarjetas">
                            
                            <cfquery name="q_MovCuenta"  datasource="#this.DSN#">
                                                    
                                select B.Ticket , B.Monto , A.MontoRequerido , isnull(mmcA.SaldoVencido,0) SaldoVencido , isnull(mmcA.Intereses,0) Intereses ,
                                    A.Descripcion , A.MontoAPagar, A.Pagado, pg.PagadoActual, pg.DeudaActual
                                from CRCMovimientoCuenta as A 
                                inner join CRCTransaccion B on A.CRCTransaccionid = B.id 
                                inner join (
                                    select mc.CRCTransaccionid, sum(Pagado + Descuento) PagadoActual, sum(MontoRequerido + Intereses) DeudaActual
                                    from CRCMovimientoCuenta mc
                                    group by mc.CRCTransaccionid
                                ) pg on B.id = pg.CRCTransaccionid
                                left join CRCTarjeta C on B.CRCTarjetaid = C.id 
                                left join ( 
                                    select t.id transaccionId, mc.SaldoVencido, mc.Intereses
                                    from CRCMovimientoCuenta mc 
                                    inner join CRCTransaccion t on mc.CRCTransaccionid = t.id 
                                    inner join ( 
                                        select top 1 c.* 
                                        from CRCCortes c 
                                        inner join ( 
                                            select * 
                                            from CRCCortes 
                                            where Codigo = '#CodCorte#' 
                                        ) CorteA on datediff(day, c.FechaFIn , CorteA.FechaInicio) = 1 and c.Tipo = CorteA.Tipo 
                                    ) CorteA on mc.Corte = CorteA.Codigo 
                                    where t.CRCCuentasid = #CuentaId# 
                                ) mmcA on B.id = mmcA.transaccionId 
                                where A.Corte = '#CodCorte#' and B.CRCCuentasid = #CuentaId# 
                                    and A.MontoApagar > A.Pagado
                                    and A.Ecodigo = #this.Ecodigo# and ( 
                                        C.id = #q_tarjetas.id# 
                                        <cfif q_tarjetas.CRCTarjetaAdicionalid eq ''>
                                            or C.id is null 
                                        </cfif>
                                    ) 
                                order by B.Fecha asc;
                            </cfquery>
        
                            <cfloop query="#q_MovCuenta#">
                                <cfset Parcialidad = REMatch("\(\d+?\/\d+?\)",q_MovCuenta.Descripcion)[1]>
                                <cfset arrPar = listToArray(replace(replace(Parcialidad,'(',""),')',""),'/')>
                                <cfset curPar = LSParseNumber(arrPar[1])>
                                <cfset totPar = LSParseNumber(arrPar[2])>
                                <cfset aboXCubrir = totPar - curPar + 1>
                                <cfif totPar gt curPar>
                                    <cfset aboXCubrir = 1>
                                </cfif>
        
                                <cfquery datasource="EstadoCuentaWeb">   
                                    INSERT INTO [Tarjetahabiente].[DesgloseOperacion]
                                            ([ClienteID]
                                            ,[NumeroPeriodo]
                                            ,[NumeroTarjeta]
                                            ,[TipoTarjeta]
                                            ,[TarjetaHabiente]
                                            ,[Folio]
                                            ,[CompraInicial]
                                            ,[SaldoVencido]
                                            ,[Recargos]
                                            ,[AbonosXCubrir]
                                            ,[AbonoCorte]
                                            ,[SaldoPostPago]
                                            ,[Estatus])
                                        VALUES
                                            (#qCuentasCorte.idCuenta#
                                            ,#rsCortes.id#
                                            ,'#q_tarjetas.Numero#'
                                            ,<cfif q_tarjetas.CRCTarjetaAdicionalid eq ''>0<cfelse>0</cfif>
                                            ,<cfif q_tarjetas.SNnombre eq ''>'#qCuentasCorte.SNnombre#'<cfelse>'#q_tarjetas.SNnombre#'</cfif>
                                            ,'#q_MovCuenta.Ticket#'
                                            ,#q_MovCuenta.Monto#
                                            ,#q_MovCuenta.SaldoVencido#
                                            ,#q_MovCuenta.Intereses#
                                            ,#aboXCubrir#
                                            ,#q_MovCuenta.MontoAPagar#
                                            ,#q_MovCuenta.DeudaActual - (q_MovCuenta.PagadoActual + q_MovCuenta.MontoAPagar)#
                                            ,#qCuentasCorte.EstatusCliente#)
                                </cfquery>
        
        
                            </cfloop>    
        
                        </cfloop>
        
                    </cfif>
        
                <cfelse>
                    <!--- DISTRIBUIDORES --->
                    <!--- SE INSERTA O ACTUALIZA CABECERA --->
                    <cfquery name="existeCab" datasource="EstadoCuentaWeb">
                        SELECT * FROM [Distribuidor].[CabeceraD] WHERE [PeriodNum] = #rsCortes.id# and [ClienteId] = #qCuentasCorte.idCuenta#
                    </cfquery>
                    
                    <cfif existeCab.recordCount gt 0>
                        <cfquery datasource="EstadoCuentaWeb">
                            UPDATE [Distribuidor].[CabeceraD]
                                SET [AccountNumber] = '#qCuentasCorte.NumeroCuenta#'
                                    ,[Distribuidor] = '#qCuentasCorte.SNnombre#'
                                    ,[Direccion] = '#left(qCuentasCorte.Direccion,50)#'
                                    ,[CreditLimit] = #q_resumen.MontoAprobado#
                                    ,[Telefonos] = '#qCuentasCorte.Telefono#'
                                    ,[StartDate] = '#left(rsCortes.FechaInicio,10)#'
                                    ,[EndDate] = '#left(rsCortes.FechaFin,10)#'
                                    ,[DueDate] = '#left(rsCortes.FechaFinSV,10)#'
                            WHERE [PeriodNum] = #rsCortes.id# and [ClienteID] = #qCuentasCorte.idCuenta#;
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="EstadoCuentaWeb">     
                            INSERT [Distribuidor].[CabeceraD] 
                            ( [ClienteID]
                            ,[PeriodNum]
                            ,[AccountNumber]
                            ,[Distribuidor]
                            ,[Direccion]
                            ,[CreditLimit]
                            ,[Telefonos]
                            ,[StartDate]
                            ,[EndDate]
                            ,[DueDate] )
                            VALUES (#qCuentasCorte.idCuenta#,#rsCortes.id#,'#qCuentasCorte.NumeroCuenta#','#qCuentasCorte.SNnombre#',
                                    '#left(qCuentasCorte.Direccion,50)#',#q_resumen.MontoAprobado#,'#qCuentasCorte.Telefono#','#left(rsCortes.FechaInicio,10)#',
                                    '#left(rsCortes.FechaFin,10)#','#left(rsCortes.FechaFinSV,10)#' );
                        </cfquery>
                    </cfif>
        
                    <!--- SE INSERTA O ACTUALIZA DETALLE --->
                    <cfquery datasource="EstadoCuentaWeb">     
                        delete from [Distribuidor].[Detalle]
                        WHERE [NumeroPeriodo] = #rsCortes.id# and [ClienteID] = #qCuentasCorte.idCuenta#
                    </cfquery>
        
                    <cfquery name="q_MovCuenta"  datasource="#this.DSN#">
                        select 
                            B.Fecha
                            , B.Ticket
                            , B.Folio
                            , B.TiendaExt
                            , B.Tienda
                            , case B.TipoTransaccion
                                when 'VC' then B.Cliente
                                else TT.Descripcion end as Cliente
                            , B.CURP
                            , B.Monto
                            , A.SaldoVencido
                            , A.Intereses
                            , A.MontoAPagar - (A.Pagado + A.Descuento) MontoAPagar
                            , A.MontoRequerido - (A.Pagado + A.Descuento) MontoRequerido
                            <!--- , isNull(C.Pagos,0) as Pagos --->
                            , A.Descripcion
                            , B.TipoTransaccion
                            , case when (A.MontoAPagar - A.MontoRequerido) - (A.Pagado + A.Descuento) >= 0
                                    then (A.MontoAPagar - A.MontoRequerido) - (A.Pagado + A.Descuento)
                                    else 0
                                end AS SV
                            , B.monto - isnull(C.Pagos,0) - (A.MontoAPagar - (A.Pagado + A.Descuento)) AS SaldoPost
                        from CRCMovimientoCuenta as A 
                            inner join CRCTransaccion B 
                                on A.CRCTransaccionid = B.id 
                            left join (
                                select CRCTransaccionid, Sum(A.Pagado)+ sum(A.Descuento) - sum(A.Intereses) + sum(A.Condonaciones) as Pagos
                                from CRCMovimientoCuenta A 
                                inner join CRCCortes B  on B.Codigo = A.Corte
                                where  B.FechaFin <= '#DateFormat(q_Corte.fechafin,'yyyy-mm-dd')#'
                                group by A.CRCTransaccionid
                            ) as C
                                on C.CRCTransaccionid = B.id
                            inner join CRCTipoTransaccion TT
                                on TT.Codigo = B.TipoTransaccion
                                and TT.Ecodigo = B.Ecodigo 
                        where 
                            A.Corte = '#CodCorte#' 
                            and A.MontoAPagar - (A.Pagado + A.Descuento) > 0
                            and B.CRCCuentasid = #CuentaID# and A.Ecodigo = #this.ecodigo#
                            and rtrim(ltrim(B.TipoTransaccion)) <> 'SG'
                            and A.CRCConveniosid is null
                            order by B.Fecha asc; 
                    </cfquery>
        
                    <cfquery name="q_MovCuentaSG"  datasource="#this.DSN#">
                        select 
                            B.Fecha
                            , B.Ticket
                            , B.Folio
                            , B.TiendaExt
                            , B.Tienda
                            , case B.TipoTransaccion
                                when 'VC' then B.Cliente
                                else TT.Descripcion end as Cliente
                            , B.CURP
                            , B.Monto
                            , A.SaldoVencido
                            , A.Intereses
                            , A.MontoAPagar - (A.Pagado + A.Descuento) MontoAPagar
                            , A.MontoRequerido - (A.Pagado + A.Descuento) MontoRequerido
                            , A.Descripcion
                            , B.TipoTransaccion
                            , A.MontoAPagar - A.MontoRequerido as SV
                            , B.monto - isnull(C.Pagos,0) - A.MontoRequerido AS SaldoPost
                        from CRCMovimientoCuenta as A 
                            inner join CRCTransaccion B 
                                on A.CRCTransaccionid = B.id 
                            left join (select CRCTransaccionid, Sum(A.Pagado)+ sum(A.Descuento) - sum(A.Intereses) + sum(A.Condonaciones) as Pagos
                                from CRCMovimientoCuenta A inner join CRCCortes B  on B.Codigo = A.Corte
                                where  B.FechaFin < '#DateFormat(q_Corte.fechafin,'yyyy-mm-dd')#' 
                                group by A.CRCTransaccionid
                            ) as C
                                on C.CRCTransaccionid = B.id
                            inner join CRCTipoTransaccion TT
                                on TT.Codigo = B.TipoTransaccion
                                and TT.Ecodigo = B.Ecodigo 
                        where 
                            A.Corte = '#CodCorte#' 
                            and B.CRCCuentasid = #CuentaID# and A.Ecodigo = #this.ecodigo#
                            and rtrim(ltrim(B.TipoTransaccion)) = 'SG'
                            and A.MontoRequerido > 0
                            and A.CRCConveniosid is null
                            order by B.Fecha asc; 
                    </cfquery>
        
                    <cfset val = objParams.GetParametroInfo('30000701')>
                    <cfif val.codigo eq ''><cfthrow message="El parametro [30000701 - Porcentaje de interes por retraso] no existe"></cfif>
                    <cfif val.valor eq ''><cfthrow message="El parametro [30000701 - Porcentaje de interes por retraso] no esta definido"></cfif>
                    <cfset PorcientoInteres = val.valor/100>
        
                    <cfloop query="#q_MovCuenta#">
                        <cfset Parcialidad = REMatch("\(\d+?\/\d+?\)",q_MovCuenta.Descripcion)[1]>
                        <cfset primerosChart = left(TRIM(#Parcialidad#), 3)>
                        <cfset arrPar = listToArray(replace(replace(Parcialidad,'(',""),')',""),'/')>
                        <cfset curPar = LSParseNumber(arrPar[1])>
                        <cfset totPar = LSParseNumber(arrPar[2])>
                        <cfset aboXCubrir = totPar - curPar + 1>
                        <cfif totPar gt curPar>
                            <cfset aboXCubrir = 1>
                        </cfif>
                        <cfset Descuento = 0>
                        <cfset Max_Descuento = q_infoCuenta.DescuentoInicial>   
                        <cfif trim(q_MovCuenta.TipoTransaccion) eq 'VC'>
                            <cfset Descuento = q_MovCuenta.MontoAPagar * (Max_Descuento / 100)>
                            <!--- <cfset q_MovCuenta.SaldoPost = q_MovCuenta.SaldoPost - Descuento> --->
                        </cfif>
                        <cfset SaldoVencidoD = 0>
                        <cfset InteresesD = 0>
                        <cfif trim(q_MovCuenta.TipoTransaccion) neq ''>
                            <cfset SaldoVencidoD = q_MovCuenta.SV>
                            <cfset InteresesD = SaldoVencidoD - (SaldoVencidoD / (1 + PorcientoInteres))>
                            <cfset SaldoVencidoD = SaldoVencidoD> <!---  - InteresesD --->
                        </cfif>
        
                        
                        
                        <cfquery datasource="EstadoCuentaWeb">     
                            INSERT INTO [Distribuidor].[Detalle]
                                ([ClienteID]
                                ,[NumeroPeriodo]
                                ,[FechaCompra]
                                ,[NotaVenta]
                                ,[NegocioVale]
                                ,[Cliente]
                                ,[CompraInicial]
                                ,[SaldoVencido]
                                ,[InteresMoratorio]
                                ,[AbonosXCubrir]
                                ,[AbonoCorte]
                                ,[Descuento]
                                ,[SaldoPostPago]
                                ,[DueDate]
                                ,[NewCupon]
                                ,[CustStatus])
                            VALUES (#qCuentasCorte.idCuenta#,
                                    #rsCortes.id#,
                                    '#q_MovCuenta.Fecha#',
                                    '#q_MovCuenta.Tienda#-#q_MovCuenta.Ticket#',
                                    '<cfif q_MovCuenta.TiendaExt neq ''>#q_MovCuenta.TiendaExt# </cfif>#q_MovCuenta.Folio#',
                                    '#q_MovCuenta.Cliente#',
                                    #q_MovCuenta.Monto#,
                                    #SaldoVencidoD#,
                                    #InteresesD#,
                                    #aboXCubrir#,
                                    #q_MovCuenta.MontoAPagar#,
                                    #Descuento#,
                                    #q_MovCuenta.SaldoPost#,
                                    '#left(rsCortes.FechaFinSV,10)#',
                                    <cfif primerosChart eq '(1/'>1<cfelse>0</cfif>,
                                    #qCuentasCorte.EstatusCliente# 
                                );
                        </cfquery>
        
                        <!--- SE INSERTA INFORMACION DEL USUARIO VALE --->
                        <cfquery name="q_DatosReporte" datasource="ldcom">
                            select distinct top 1 Curp_id, Curp_Clave, Curp_Nombre, concat(Curp_Apellido1, ' ', Curp_Apellido2) CURP_Apellidos, Curp_Fecha_Nacimiento,
                                case Curp_Sexo when 1 then 'Hombre' else 'Mujer' end Sexo, Curp_Email, 
                                CURP_Calle, CURP_Codigo_Postal, concat(Curp_Telefono1, ', ', Curp_Telefono2) CURP_TELEFONOS,
                                n1.Nivel1_Nombre Estado, n2.Nivel2_Nombre Ciudad, n3.Nivel3_Nombre Colonia
                            from curp c
                            inner join Nivel1 n1 on c.NIvel1_Id = n1.Nivel1_id
                            inner join Nivel2 n2 on c.NIvel1_Id = n2.Nivel1_id and c.NIvel2_Id = n2.Nivel2_id
                            inner join Nivel3 n3 on c.NIvel1_Id = n3.Nivel1_id and c.NIvel2_Id = n3.Nivel2_id and c.NIvel3_Id = n3.Nivel3_id
                            where upper(ltrim(rtrim(Curp_Clave))) = '#ucase(trim(q_MovCuenta.Curp))#'
                        </cfquery>
        
                        <cfif q_DatosReporte.recordCount gt 0>
                            <cfquery datasource="EstadoCuentaWeb">     
                                INSERT INTO [Distribuidor].[UsuariosVales]
                                    ([CuponUserAccountNumber]
                                    ,[FirstName]
                                    ,[LastName]
                                    ,[Address]
                                    ,[Address2]
                                    ,[City]
                                    ,[EmailAddress])
                                VALUES ('#q_DatosReporte.Curp_id#',
                                        '#q_DatosReporte.Curp_Nombre#',
                                        '#q_DatosReporte.CURP_Apellidos#',
                                        '#q_DatosReporte.CURP_Calle#',
                                        '#q_DatosReporte.Colonia#',
                                        '#q_DatosReporte.Ciudad#',
                                        '#q_DatosReporte.Curp_Email#'
                                    );
                            </cfquery>
                        </cfif>
                    </cfloop>
        
                </cfif>
            </cfloop>
        
        </cfloop>
            
    </cffunction>
</cfcomponent>