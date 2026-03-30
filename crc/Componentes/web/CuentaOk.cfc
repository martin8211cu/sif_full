<cfcomponent output="false" displayname="CRCCuenta" 
    extends="crc.Componentes.CRCBase"
    hint="Componente para manejo de cuentas"
>

    <cffunction name="init" access="private" returntype="CRCCuenta"> 
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >		
		<cfset Super.init(this.DSN, this.Ecodigo)>

		<cfreturn this>
	</cffunction>
    
    <cffunction name="obtenerCuentasPorSNid" access="public" returntype="array">
        <cfargument name="SNid" required="true" type="numeric">

        <cfquery name="qCuentas" datasource="#this.DSN#">
            select 
                c.id, c.SNegociosSNid as SNid, c.Numero, c.Tipo,
                c.MontoAprobado, c.SaldoActual, c.SaldoVencido, c.saldoAFavor,
                c.Compras, c.Pagos, c.Interes, c.Condonaciones,
                ec.Descripcion as Estado
            from CRCCuentas c
            inner join CRCEstatusCuentas ec
                on c.CRCEstatusCuentasid = ec.id
            where SNegociosSNid = <cfqueryparam value="#arguments.SNid#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn this.db.queryToArray(qCuentas)>
    </cffunction>

    <cffunction name="obtenerDetalleCuenta" access="public" returntype="struct">
        <cfargument name="cuentaid" required="true" type="numeric">

        <cfset Cortes = createObject("component","crc.Componentes.cortes.CRCCortes")>
        <cfset Cortes.init(
            TipoCorte="D",
            conexion=this.DSN, 
            ECodigo=this.Ecodigo
        )>

        <cfquery name="qCuenta" datasource="#this.DSN#">
            select 
                c.id, c.SNegociosSNid as SNid, c.Numero, c.Tipo,
                c.MontoAprobado, c.SaldoActual, c.SaldoVencido, c.saldoAFavor,
                c.Compras, c.Pagos, c.Interes, c.Condonaciones,
                ec.Descripcion as Estado
            from CRCCuentas c
            inner join CRCEstatusCuentas ec
                on c.CRCEstatusCuentasid = ec.id
            where c.id = <cfqueryparam value="#arguments.cuentaid#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif qCuenta.recordCount GT 0>
            <cfset cuenta = this.db.queryRowToStruct(qCuenta, 1)>
            <cfset cuenta.CorteCerrado = Cortes.buscarUltimoCorteCalculado(qCuenta.Tipo)>
            <cfset cuenta.CorteInfo = obtenerPagoRequerido(arguments.cuentaid)>

            <cfset info = obtenerInformacionCuenta(arguments.cuentaid)>
            <cfset cuenta.info = info>

            <cfif cuenta.TIPO eq "TC">
                <cfset tarjetas = obtenerTarjetas(arguments.cuentaid)>
                <cfset cuenta.trajetas = tarjetas>
            </cfif>

            <cfreturn cuenta>
        <cfelse>
            <cfreturn {}>
        </cfif>
    </cffunction>
    
    <cffunction name="obtenerInformacionCuenta" access="public" returntype="struct">
        <cfargument name="cuentaid" required="true" type="numeric">

        <cfquery name="q_infoCuenta"  datasource="#this.DSN#">
            select 
                    B.SNnombre
                ,	B.SNid
                ,	B.SNcodigo
                ,	C.direccion1
                ,	C.direccion2
                ,	C.Colonia
                ,	C.estado
                ,	C.codPostal
                ,	A.Numero
                ,	B.SNtelefono
                ,	A.CRCCategoriaDistid
                ,	D.Titulo Categoria
                ,	D.EmisorQ1
                ,	D.EmisorQ2
                ,   isnull(D.DescuentoInicial,0) DescuentoInicial
            from CRCCuentas A
                inner join SNegocios B
                    on B.SNid = A.SNegociosSNid
                inner join DireccionesSIF C
                    on B.id_direccion = C.id_direccion
                left join CRCCategoriaDist D
                    on A.CRCCategoriaDistid = D.id
            where A.id = #CuentaID# and A.Ecodigo = #this.ecodigo#;

        </cfquery>

        <cfif q_infoCuenta.recordCount GT 0>
            <cfreturn this.db.queryRowToStruct(q_infoCuenta, 1)>
        <cfelse>
            <cfreturn {}>
        </cfif>
    </cffunction>

    <cffunction name="obtenerTarjetas" access="public" returntype="array">
        <cfargument name="cuentaid" required="true" type="numeric">

        <cfquery name="q_tarjetas"  datasource="#this.DSN#">
            select
                A.id , c.SNegociosSNid SNid, A.CRCCuentasid,
                A.Numero, A.Estado,
                IIF(A.Mayorista is null, 0, 1) esMayorista, IIF(A.CRCTarjetaAdicionalid is null,0,1) esAdicional, A.CRCTarjetaAdicionalid,
                IIF(B.SNid is null, sn.SNnombre, B.SNnombre) Nombre, IIF(B.MontoMaximo is null, c.MontoAprobado, B.MontoMaximo) MontoAprobado
            from CRCTarjeta A
            inner join CRCCuentas c
                on A.CRCCuentasid = c.id
            inner join SNegocios sn
                on c.SNegociosSNid = sn.SNid
            left join CRCTarjetaAdicional B
                on A.CRCTarjetaAdicionalid = B.id
            where 
                A.CRCCuentasid = #arguments.cuentaid#
                and A.Ecodigo = #this.Ecodigo#;
        </cfquery>

        <cfreturn this.db.queryToArray(q_tarjetas)>
    </cffunction>

    <cffunction name="obtenerPagoRequerido" access="public" returntype="struct">
		<cfargument name="cuentaid" required="true" >

		<cfset _pagoreq = 1>
        
        <cfquery name="rsUltimoCorteCerrado" datasource="#this.DSN#">
            select c.id Cuentaid, max(mcc.Corte) Corte, c.Tipo, isnull(c.SaldoActual,0) SaldoActual,
                ct.FechaInicio, ct.FechaFin, DATEADD(day, -1, ct.FechaInicioSV) FechaLimitePago,
                isnull(c.SaldoVencido,0) SaldoVencido, isnull(c.MontoAprobado,0) MontoAprobado,
                isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) CRCDEid,
                isnull(c.FechaAbogado,c.FechaGestor) FechaAsignacion, c.CRCCategoriaDistid,
                isnull(c.Condonaciones,0) Condonaciones, isnull(c.Interes,0) Intereses, c.CRCEstatusCuentasid,
                isnull(d.PorcentajeCobranzaAntes,0) PorcentajeCobranzaAntes, isnull(d.PorcentajeCobranzaDespues,0) PorcentajeCobranzaDespues,
                sum(mcc.MontoRequerido -isnull(mcc.GastoCobranza,0)-isnull(mcc.Seguro,0)) Compras,
                isnull(sum(mcc.Seguro),0) Seguro, 
                isnull(sum(mcc.MontoAPagar),0)  MontoAPagar, 
                isnull(sum(mcc.GastoCobranza),0) GastoCobranza,
                isnull(sum(mcc.MontoPagado),0) Pagos, 
                isnull(sum(mcc.Descuentos),0) Descuentos
            from CRCMovimientoCuentaCorte mcc
            inner join CRCCuentas c
                on c.id = mcc.CRCCuentasid
            inner join CRCCortes ct
                on ct.Codigo = mcc.Corte
            left join DatosEmpleado d
                on isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) = d.DEid and c.Ecodigo = d.Ecodigo
            where ct.cerrado = 1
                and ct.status = 1
                and mcc.CRCCuentasid = #arguments.cuentaid#
            group by  c.id, c.Tipo, isnull(c.SaldoActual,0), 
                ct.FechaInicio, ct.FechaFin, DATEADD(day, -1, ct.FechaInicioSV),
                isnull(c.SaldoVencido,0), isnull(c.MontoAprobado,0),
                isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2),
                isnull(c.FechaAbogado,c.FechaGestor), c.CRCCategoriaDistid,
                isnull(c.Condonaciones,0), isnull(c.Interes,0), c.CRCEstatusCuentasid,
                isnull(d.PorcentajeCobranzaAntes,0), isnull(d.PorcentajeCobranzaDespues,0) 
            order by Corte desc
        </cfquery>
        
        <cfif rsUltimoCorteCerrado.recordCount eq 0>
            <cfset _pagoreq = 0>
            <cfquery name="rsUltimoCorteCerrado" datasource="#this.DSN#">
                select top 1 c.id Cuentaid, mcc.Corte, c.Tipo, isnull(c.SaldoActual,0) SaldoActual, 
                    ct.FechaInicio, ct.FechaFin, DATEADD(day, -1, ct.FechaInicioSV) FechaLimitePago,
                    isnull(c.SaldoVencido,0) SaldoVencido, isnull(c.MontoAprobado,0) MontoAprobado,
                    isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) CRCDEid,
                    isnull(c.FechaAbogado,c.FechaGestor) FechaAsignacion,
                    (mcc.MontoRequerido -isnull(mcc.GastoCobranza,0)-isnull(mcc.Seguro,0)) Compras, isnull(c.Condonaciones,0) Condonaciones, c.CRCCategoriaDistid,
                    isnull(mcc.MontoAPagar,0)  MontoAPagar, isnull(c.Interes,0) Intereses, isnull(mcc.MontoPagado,0) Pagos, isnull(mcc.Descuentos,0) Descuentos,
                    isnull(d.PorcentajeCobranzaAntes,0) PorcentajeCobranzaAntes, isnull(d.PorcentajeCobranzaDespues,0) PorcentajeCobranzaDespues,
                    isnull(mcc.Seguro,0) Seguro, isnull(mcc.GastoCobranza,0) GastoCobranza,
                    c.CRCEstatusCuentasid
                from CRCMovimientoCuentaCorte mcc
                inner join CRCCuentas c
                    on c.id = mcc.CRCCuentasid
                inner join CRCCortes ct
                    on ct.Codigo = mcc.Corte
                left join DatosEmpleado d
                    on isnull(c.DatosEmpleadoDEid,c.DatosEmpleadoDEid2) = d.DEid and c.Ecodigo = d.Ecodigo
                where mcc.CRCCuentasid = #arguments.cuentaid#
                    and ct.status = 0
                order by Corte
            </cfquery>

        </cfif>
        <cfif rsUltimoCorteCerrado.recordCount gt 0>
            <cfset corteData = this.db.queryRowToStruct(rsUltimoCorteCerrado, 1)>
            <cfquery name="rsCorteActual" datasource="#this.DSN#">
                select top 1 *
                from CRCCortes ct
                where getdate() between FechaInicio and dateadd(day, 1, FechaFin)
                    and Tipo = '#rsUltimoCorteCerrado.Tipo#'
            </cfquery>
            <cfquery name="q_CortePago" datasource="#this.DSN#">
                select fechainicio, fechafin, Dateadd(day,2,fechafin)as fechaEntregaRelacion, codigo from CRCCortes 
                    where Dateadd(day,1,'#rsUltimoCorteCerrado.fechafin#') between fechainicio and fechafin 
                    and ecodigo = #this.Ecodigo#
                    and tipo = '#rsUltimoCorteCerrado.tipo#'
            </cfquery>

            <cfset NewCycleStartDate = ListToArray(dateFormat(q_CortePago.fechainicio,'yyyy-mm-dd'),'-',false,false)>
            <cfset NewCycleStartDate = CreateDate(NewCycleStartDate[1],NewCycleStartDate[2],NewCycleStartDate[3])>
            <cfset corteData.NewCycleStartDate = NewCycleStartDate>
            <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
            <cfset val = objParams.getParametroInfo(codigo='30006101', conexion=this.DSN, ecodigo=this.Ecodigo)>
            <cfset bancoValue = objParams.GetParametroInfo(codigo='30300101', conexion=this.DSN, ecodigo=this.Ecodigo).Valor>
            <cfset convenio = objParams.GetParametroInfo(codigo='30300102', conexion=this.DSN, ecodigo=this.Ecodigo).Valor>

            <cfquery name="q_infoCuenta"  datasource="#this.DSN#">
                select 
                        B.SNnombre
                    ,	B.SNid
                    ,	B.SNcodigo
                    ,	C.direccion1
                    ,	C.direccion2
                    ,	C.Colonia
                    ,	C.estado
                    ,	C.codPostal
                    ,	A.Numero
                    ,	B.SNtelefono
                    ,	A.CRCCategoriaDistid
                    ,	D.Titulo
                    ,	D.EmisorQ1
                    ,	D.EmisorQ2
                    ,   isnull(D.DescuentoInicial,0) DescuentoInicial
                from CRCCuentas A
                    inner join SNegocios B
                        on B.SNid = A.SNegociosSNid
                    inner join DireccionesSIF C
                        on B.id_direccion = C.id_direccion
                    left join CRCCategoriaDist D
                        on A.CRCCategoriaDistid = D.id
                where A.id = #rsUltimoCorteCerrado.Cuentaid# and A.Ecodigo = #this.Ecodigo#;

            </cfquery>

            <cfset datosPagos = structNew()>
            <cfset numCorte = right(rsUltimoCorteCerrado.Corte,1)>
            <cfif numCorte eq 1>
                <cfset EmisorDeposito = q_infoCuenta.EmisorQ1>
            <cfelse>
                <cfset EmisorDeposito = q_infoCuenta.EmisorQ2>
            </cfif>

            <cfset banco = createObject("component","crc.cobros.operacion.ImportarBancos.importadores.#bancoValue#")>
            <cfset datosPagos.CONVENIO = convenio>
	        <cfset objBarcode = createObject("component","crc.Componentes.CRCBarcodeGenerator")>
            <cfset _ref = objBarcode.CreateRefBBVAD(NumCuenta="#q_infoCuenta.Numero#", FechaLimite=q_CortePago.fechafin -1)>
            <cfset datosPagos.REFERENCIA = "#_ref#">
            <cfset datosPagos.EMISOR_DEPOSITO = "#EmisorDeposito#">
            <cfset datosPagos.OXXO_BARRCODE_URL = "/crc/images/#q_infoCuenta.Numero#.jpg">
            <cfset corteData.OPCIONES_PAGO = datosPagos>

            <cfset desuentosByDates = []>
            <cfset Max_Descuento = 0>
            <cfloop from="1" to="30" index="i">
                <cfset dateDiffVar = Datediff('d',NewCycleStartDate,q_CortePago.FechaFin)>
                
                <cfif dateDiffVar lt val.valor + 3 and dateDiffVar gte 1 >
                    <cfquery name="q_movCuentaCorteA" datasource="#this.DSN#">
                        select Sum(mc.MontoAPagar - (mc.Pagado + mc.Condonaciones + mc.Descuento)) as MontoAPagar
                            from CRCMovimientoCuenta mc
                                inner join CRCTransaccion t
                                    on t.id = mc.CRCTransaccionid
                            where 
                                rtrim(ltrim(t.TipoTransaccion)) = 'VC'
                                and mc.corte='#rsUltimoCorteCerrado.Corte#' and t.CRCCuentasid = #rsUltimoCorteCerrado.Cuentaid# and mc.Ecodigo = #this.Ecodigo#;
                    </cfquery>
                    <cfquery name="q_movCuentaCorteB" datasource="#this.DSN#">
                        select MontoAPagar - (MontoPagado + Condonaciones +Descuentos) MontoAPagar 
                            from CRCMovimientoCuentaCorte 
                            where corte='#rsUltimoCorteCerrado.Corte#' and CRCCuentasid = #rsUltimoCorteCerrado.Cuentaid# and Ecodigo = #this.Ecodigo#;
                    </cfquery>
                    <cfset newDescuento = getPorcientoDescuento(fechaPago=NewCycleStartDate,categoriaid=rsUltimoCorteCerrado.CRCCategoriaDistid,codigoCorte='#q_CortePago.codigo#')>
                    <cfif newDescuento gt Max_Descuento> 
                        <cfset Max_Descuento = newDescuento> 
                    </cfif>
                    <cfset descuento = newDescuento>
                    <cfset lastDay4Pay = NewCycleStartDate> 
                    <cfset desuentoObj = structNew()>
                    <cfset desuentoObj.fecha = DateFormat(NewCycleStartDate,"yyyy/mm/dd")>
                    <cfset desuentoObj.descuento = descuento>
                    <cfset desuentoObj.AbonoProgramado = "$#LSCurrencyFormat(q_movCuentaCorteB.MontoAPagar, "none")#">
                    <cfset desuentoObj.AbonoDescuento = "$#LSCurrencyFormat(NumberFormat(q_movCuentaCorteA.MontoAPagar,"00.00") * (descuento/100), "none")#">
                    <cfset desuentoObj.AbonoTotal = "$#LSCurrencyFormat(NumberFormat(q_movCuentaCorteB.MontoAPagar,"00.00") - (NumberFormat(q_movCuentaCorteA.MontoAPagar,"00.00") * (descuento/100)),"none")#">
                    <cfset arrayAppend(desuentosByDates, desuentoObj)>
                </cfif>
                <cfset NewCycleStartDate=DateAdd("d",1,NewCycleStartDate)> 
            </cfloop>
            <cfset corteData.PROGRAMACION_DESUENTOS = desuentosByDates>
            
            <cfreturn corteData>
        <cfelse>
            <cfreturn {}>
        </cfif>
	</cffunction>

	<cffunction name="getPorcientoDescuento" returntype="numeric">
		<cfargument name="fechaPago" type="date" required="true">
		<cfargument name="categoriaid" type="integer" required="true">
		<cfargument name="codigoCorte" type="string" required="true">

		<cfquery name="rsCategoria" datasource="#this.DSN#">
			select DescuentoInicial , PenalizacionDia
			from CRCCategoriaDist where Ecodigo = #this.Ecodigo# and id = #Arguments.categoriaid#
		</cfquery>

		<cfquery name="rsCorte" datasource="#this.DSN#">
			select Codigo, FechaInicio, FechaFin
			from CRCCortes where Ecodigo = #this.Ecodigo# and codigo = '#arguments.codigoCorte#'
		</cfquery>

		<cfif rsCategoria.recordcount eq 0 or rsCorte.recordcount eq 0>
			<cfreturn 0>
		</cfif>

		<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
		<cfset diasPenDesc = crcParametros.GetParametro(codigo='30006101',conexion=this.DSN,ecodigo=this.Ecodigo)>
		<cfset descIni = rscategoria.DescuentoInicial>
		<cfset penDia = rscategoria.PenalizacionDia>
		<cfset fechaFinCorte = dateFormat(rsCorte.FechaFin,"yyyy-mm-dd")>
		
		<cfset fechaPago = dateFormat(arguments.fechaPago,"yyyy-mm-dd")>

		<cfset difFecha = datediff("d",fechaPago,fechaFinCorte)+1>

		<cfif difFecha lte 0 or difFecha gte diasPenDesc>
			<cfreturn descIni>
		<cfelse>
			<cfreturn descIni - ((diasPenDesc - difFecha)*penDia)>
		</cfif>

	</cffunction>
</cfcomponent>