<cfcomponent output="false" displayname="CRCCortes" 
    extends="crc.Componentes.CRCBase"
    hint="Componente para manejar cortes">
    
    <cffunction name="init" access="private" returntype="CRCCuenta"> 
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
		<cfset Super.init(this.DSN, this.Ecodigo)>

		<cfreturn this>
	</cffunction>

    <cffunction name="obtenerUltimosCortesCerradosPorTipo" access="public" returntype="array">
        <cfargument name="tipo"  required="true"  type="string">
        <cfargument name="cantidad"  required="false"  type="numeric" default="3">

        <cfquery name="qUltimosCortesCerrados" datasource="#this.DSN#">
            select top(#arguments.cantidad#) fechainicio, fechafin, codigo from CRCCortes  
                where 
                    status >= 1
                    and Tipo = '#arguments.tipo#'
                    and Ecodigo = #this.Ecodigo#
                    order by FechaFin desc;
        </cfquery>

        <cfreturn this.db.queryToArray(qUltimosCortesCerrados)>
    </cffunction>

    <cffunction name="obtenerDetalleCorte" access="public" returntype="struct">
        <cfargument name="corte"  required="true"  type="string">

        <cfquery name="qDetalleCorte" datasource="#this.DSN#">
            select fechainicio, fechafin, codigo, status, ltrim(rtrim(Tipo)) as Tipo from CRCCortes  
                where 
                    codigo = '#arguments.corte#'
                    and Ecodigo = #this.Ecodigo#;
        </cfquery>

        <cfreturn this.db.queryRowToStruct(qDetalleCorte)>
    </cffunction>

    <cffunction name="obtenerMovimientos" access="public" returntype="struct">
        <cfargument name="corte"  required="true"  type="string">
        <cfargument name="cuentaid"  required="true"  type="string">

        <cfquery name="q_Corte" datasource="#this.DSN#">
            select fechainicio, fechafin, codigo, status, ltrim(rtrim(Tipo)) as Tipo from CRCCortes  
                where 
                    codigo = '#arguments.corte#'
                    and Ecodigo = #this.Ecodigo#;
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
                ,A.id
                , A.SaldoVencido
                , A.Intereses
                , A.MontoAPagar
                , A.MontoRequerido
                , A.Pagado + A.Descuento as Pagado
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
                A.Corte = '#arguments.corte#' 
                <!--- and A.MontoAPagar - (A.Pagado + A.Descuento) > 0 --->
                and B.CRCCuentasid = #arguments.cuentaid# and A.Ecodigo = #this.Ecodigo#
                and rtrim(ltrim(B.TipoTransaccion)) not in ('SG','RP')
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
                , A.id
                , A.SaldoVencido
                , A.Intereses
                , A.MontoAPagar
                , A.MontoRequerido
                , A.Pagado + A.Descuento as Pagado
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
                A.Corte = '#arguments.corte#' 
                and B.CRCCuentasid = #arguments.cuentaid# and A.Ecodigo = #this.Ecodigo#
                and rtrim(ltrim(B.TipoTransaccion)) = 'SG'
                <!--- and A.MontoRequerido > 0 --->
                and A.CRCConveniosid is null
                order by B.Fecha asc; 
        </cfquery>

        <cfset Max_Descuento = 0>
        <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
        <cfset val = objParams.getParametroInfo(codigo='30000701', conexion=this.DSN, ecodigo=this.Ecodigo)>
        <cfset PorcientoInteres = val.valor/100>
        
        <cfquery name="q_CortePagoPrev" datasource="#this.DSN#">
			select fechainicio, fechafin, codigo from CRCCortes 
				where Dateadd(day,-2,'#q_Corte.fechainicio#') between fechainicio and fechafin 
				and ecodigo = #this.Ecodigo#
				and tipo = '#q_corte.tipo#'
		</cfquery>
        <cfquery name="q_MCCPrev" datasource="#this.DSN#">
            select *
                from CRCMovimientoCuentaCorte 
                where corte='#q_CortePagoPrev.codigo#' and CRCCuentasid = #arguments.cuentaid# and Ecodigo = #this.ecodigo#;
        </cfquery>
        <cfquery name="q_MCC" datasource="#this.DSN#">
            select *
                from CRCMovimientoCuentaCorte 
                where corte='#arguments.corte#' and CRCCuentasid = #arguments.cuentaid# and Ecodigo = #this.ecodigo#;
        </cfquery>

        <!--- Procesar movimientos usando la función --->
        <cfset datosProcesados = procesarMovimientosCuenta(
            q_MovCuenta = q_MovCuenta,
            q_MovCuentaSG = q_MovCuentaSG,
            Max_Descuento = Max_Descuento,
            PorcientoInteres = PorcientoInteres,
            q_MCCPrev = q_MCCPrev
        )>

        <cfreturn datosProcesados>
    </cffunction>

    <cffunction name="procesarMovimientosCuenta" access="private" returntype="struct">
        <cfargument name="q_MovCuenta" type="query" required="true">
        <cfargument name="q_MovCuentaSG" type="query" required="true">
        <cfargument name="Max_Descuento" type="numeric" required="true">
        <cfargument name="PorcientoInteres" type="numeric" required="true">
        <cfargument name="q_MCCPrev" type="query" required="true">

        <cfset var result = {}>
        <cfset result.arrayMovCuenta = []>
        <cfset result.arrayMovCuentaSG = []>
        <cfset result.totales = {}>
        <cfset result.totales.Total_Compras = 0>
        <cfset result.totales.Total_AbonoCorte = 0>
        <cfset result.totales.Total_Descuento = 0>
        <cfset result.totales.Total_SaldoPost = 0>
        <cfset result.totales.Total_SaldoVencido = 0>
        <cfset result.totales.Total_Intereses = 0>
        <cfset result.totales.Total_Pagado = 0>

        <!--- Procesar q_MovCuenta --->
        <cfloop query="#arguments.q_MovCuenta#">
            <cfset var Parcialidad = REMatch("\(\d+?\/\d+?\)",arguments.q_MovCuenta.Descripcion)[1]>
            <cfset var Descuento = 0>
            <cfif trim(arguments.q_MovCuenta.TipoTransaccion) eq 'VC'>
                <cfset Descuento = arguments.q_MovCuenta.MontoAPagar * (arguments.Max_Descuento / 100)>
            </cfif>
            <cfset var SaldoVencidoD = 0>
            <cfset var InteresesD = 0>
            <cfif trim(arguments.q_MovCuenta.TipoTransaccion) neq ''>
                <cfset SaldoVencidoD = arguments.q_MovCuenta.SV>
                <cfset InteresesD = SaldoVencidoD - (SaldoVencidoD / (1 + arguments.PorcientoInteres))>
            </cfif>
            
            <cfset var primerosChart = left(TRIM(Parcialidad), 3)>
            <cfset var asterisco = (primerosChart eq '(1/') ? '*' : ''>

            <cfset var fila = {
                Id: arguments.q_MovCuenta.id,
                Fecha: dateFormat(arguments.q_MovCuenta.Fecha,'yyyy-mm-dd'),
                TiendaTicket: arguments.q_MovCuenta.Tienda & '-' & arguments.q_MovCuenta.Ticket,
                TiendaExtFolio: (arguments.q_MovCuenta.TiendaExt neq '' ? arguments.q_MovCuenta.TiendaExt & ' ' : '') & arguments.q_MovCuenta.Folio,
                Cliente: left(Ucase(arguments.q_MovCuenta.Cliente),30),
                Monto: arguments.q_MovCuenta.Monto,
                SaldoVencidoD: SaldoVencidoD,
                Folio: arguments.q_MovCuenta.Folio,
                Pagado: arguments.q_MovCuenta.Pagado,
                InteresesD: InteresesD,
                Parcialidad: Parcialidad,
                MontoAPagar: arguments.q_MovCuenta.MontoAPagar,
                Descuento: Descuento,
                SaldoPost: arguments.q_MovCuenta.SaldoPost,
                Asterisco: asterisco
            }>
            <cfset arrayAppend(result.arrayMovCuenta, fila)>

            <cfset result.totales.Total_Compras += arguments.q_MovCuenta.Monto>
            <cfset result.totales.Total_AbonoCorte += arguments.q_MovCuenta.MontoAPagar>
            <cfset result.totales.Total_Descuento += Descuento>
            <cfset result.totales.Total_SaldoPost += arguments.q_MovCuenta.SaldoPost>
            <cfset result.totales.Total_SaldoVencido += SaldoVencidoD>
            <cfset result.totales.Total_Intereses += InteresesD>
            <cfset result.totales.Total_Pagado += arguments.q_MovCuenta.Pagado>

        </cfloop>

        <!--- Procesar q_MovCuentaSG --->
        <cfif arguments.q_MovCuentaSG.recordCount gt 0>
            <cfset var filaSG = {
                Fecha: dateFormat(arguments.q_MovCuentaSG.Fecha,'yyyy-mm-dd'),
                TiendaTicket: arguments.q_MovCuentaSG.Tienda & '-' & arguments.q_MovCuentaSG.Ticket,
                TiendaExtFolio: (arguments.q_MovCuentaSG.TiendaExt neq '' ? arguments.q_MovCuentaSG.TiendaExt & ' ' : '') & arguments.q_MovCuentaSG.Folio,
                Cliente: arguments.q_MovCuentaSG.Cliente,
                Monto: arguments.q_MovCuentaSG.Monto,
                SaldoVencidoD: NumberFormat(arguments.q_MCCPrev.SaldoVencido,'0.00') - result.totales.Total_SaldoVencido,
                InteresesD: NumberFormat(arguments.q_MCCPrev.Intereses,'0.00') - result.totales.Total_Intereses,
                Parcialidad: '(1)',
                MontoAPagar: arguments.q_MovCuentaSG.MontoAPagar,
                Descuento: 0,
                SaldoPost: arguments.q_MovCuentaSG.SaldoPost,
                Asterisco: ''
            }>
            <cfset arrayAppend(result.arrayMovCuentaSG, filaSG)>
        </cfif>

        <cfreturn result>
    </cffunction>
</cfcomponent>