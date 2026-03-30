
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>

<cfif not isdefined("session.DSN")>
	<cfset session.DSN = arguments.dsn>
</cfif>
<cfif not isdefined("session.ecodigo") or session.ecodigo eq 0>
	<cfset session.ecodigo = arguments.ecodigo>
</cfif>

<cfset val = objParams.GetParametroInfo('30300101').Valor>
<cfset _convenio = objParams.GetParametroInfo('30300102').Valor>

<cfif val eq ""><cfthrow message = "No se ha definido el Banco para Importar Pagos"></cfif>
<cfset _banco = createObject("component","crc.cobros.operacion.ImportarBancos.importadores.#val#")>

<cfquery name="q_infoCuenta"  datasource="#session.DSN#">
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
	where A.id = #CuentaID# and A.Ecodigo = #session.ecodigo#;

</cfquery>


	
<cfquery name="q_Corte"  datasource="#session.DSN#">
	select fechainicio, fechafin, tipo from CRCCortes where codigo = '#CodCorte#' and ecodigo = #session.ecodigo#
</cfquery>

<cfquery name="q_transacciones"  datasource="#session.DSN#">
	select 
		  A.CRCCuentasid 
		, A.Fecha
		, A.Tienda
		, A.id
		, A.TipoTransaccion as Tipo
		, A.Ticket as Folio
		, A.Observaciones
		, A.Monto
		, B.Descripcion
	from 
		CRCTransaccion A
		left join CRCTipoTransaccion B
			on A.CRCTipoTransaccionid = B.id
	where 
		A.CRCCuentasid = #CuentaID# 
		<cfif arguments.Tipo eq 'TM'>
			<cfset arrCorte = listToArray(arguments.codigoSelect)>
			<cfset p_diaCorteTM = objParams.GetParametroInfo('30000706').Valor>
			<cfset date_fin = CreateDate(arrCorte[1],arrCorte[2],p_diaCorteTM+1)>
			and A.Fecha between #dateAdd('m', -1, date_fin)# and #date_fin#
		<cfelse>
			and A.Fecha between '#ListToArray(q_Corte.fechainicio,' ',false,false)[1]#' and '#ListToArray(q_Corte.fechafin,' ',false,false)[1]#' 
		</cfif>
		and A.ecodigo=#session.ecodigo#
	order by A.fecha asc;
</cfquery>

<cfquery name="q_tarjetas"  datasource="#session.DSN#">
	select
		  A.id 
		, A.Numero
		, A.Mayorista
		, A.CRCTarjetaAdicionalid
		, B.SNnombre
	from CRCTarjeta A
		left join CRCTarjetaAdicional B
			on A.CRCTarjetaAdicionalid = B.id
	where 
		A.CRCCuentasid = #CuentaID#
		and A.Ecodigo = #session.ecodigo#;
</cfquery>

<cfquery name="q_ResumenCorte" datasource="#session.DSN#">
	select isnull(MontoAPagar - MontoPagado,0) MontoAPagar from CRCMovimientoCuentaCorte where CRCCuentasid = #CuentaID# and Corte = '#CodCorte#'
</cfquery>

<cfquery name="q_resumen"  datasource="#session.DSN#">
	<cfif arguments.Tipo eq 'TM'>
		<cfset arrCorte = listToArray(arguments.codigoSelect)>
		<cfset p_diaCorteTM = objParams.GetParametroInfo('30000706').Valor>
		<cfset date_fin = CreateDate(arrCorte[1],arrCorte[2],p_diaCorteTM+1)>
	</cfif>
	select A.Corte,
		 (select top(1) FechaFin from CRCCortes where FechaInicio >= (select FechaFin from CRCCortes where Codigo= '#CodCorte#') order by FechaInicio asc) as FechaLimite
		, (isNull(A.MontoPagado,0)+ isNull(A.Descuentos,0) + isNull(A.Condonaciones,0)) as Pagos
		, IsNull((select Sum(IsNull(
				case 
					when (A.TipoMov = 'C' and A.afectaCompras = 1) then A.Monto
					when (A.TipoMov = 'D' and A.TipoTransaccion in ('XT','TR')) then A.Monto *-1
					else 0
				end
			,0)) as Compras from  CRCTransaccion A
			where  A.CRCCuentasid = #CuentaID#  
				<cfif arguments.Tipo eq 'TM'>
					and A.Fecha between #dateAdd('m', -1, date_fin)# and #date_fin#
				<cfelse>
					and A.Fecha >= '#ListToArray(q_Corte.fechainicio,' ',false,false)[1]#' and A.Fecha <='#ListToArray(q_Corte.fechafin,' ',false,false)[1]#'
				</cfif>
				and A.Ecodigo = #session.ecodigo# ),0) as Compras
		, isnull(CorteB.Intereses,0) Intereses
		, IsNull((select Sum(IsNull(A.Monto,0)) as Compras from  CRCTransaccion A
			left join CRCTipoTransaccion B on A.CRCTipoTransaccionid = B.id
			where  A.CRCCuentasid = #CuentaID#  and B.afectaGastoCobranza = 1
				<cfif arguments.Tipo eq 'TM'>
					and A.Fecha between #dateAdd('m', -1, date_fin)# and #date_fin#
				<cfelse>
					and A.Fecha >= '#ListToArray(q_Corte.fechainicio,' ',false,false)[1]#' and A.Fecha <='#ListToArray(q_Corte.fechafin,' ',false,false)[1]#'
				</cfif>
				and A.Ecodigo = #session.ecodigo# ),0) as OtrosCargos
		, C.SaldoActual as SaldoActual
		, IsNull((select Sum(IsNull(A.Monto,0)) as Compras from  CRCTransaccion A
			left join CRCTipoTransaccion B on A.CRCTipoTransaccionid = B.id
			where  A.CRCCuentasid = #CuentaID#  and (B.afectaPagos = 1 or B.afectaCondonaciones = 1)
				<cfif arguments.Tipo eq 'TM'>
					and A.Fecha between #dateAdd('m', -1, date_fin)# and #date_fin#
				<cfelse>
					and A.Fecha >= '#ListToArray(q_Corte.fechainicio,' ',false,false)[1]#' and A.Fecha <='#ListToArray(q_Corte.fechafin,' ',false,false)[1]#' 
				</cfif>
				and A.Ecodigo = #session.ecodigo# ),0) as PagosPendientes
		, 0 as SaldoPendiente
		, 0 as PagoMinimo
		, A.MontoAPagar - A.MontoPagado as MontoAPagar
		, C.MontoAprobado
		, (C.MontoAprobado - C.SaldoActual) as CreditoDisponible
		, IsNull((select Sum(IsNull(
				case 
					when (A.TipoMov = 'C' and A.afectaCompras = 1) then A.Monto
					when (A.TipoMov = 'D' and A.TipoTransaccion in ('XT','TR')) then A.Monto *-1
					else 0
				end
			,0)) as Compras from  CRCTransaccion A
			where  A.CRCCuentasid = #CuentaID#  
				<cfif arguments.Tipo eq 'TM'>
					and A.Fecha < #date_fin#
				<cfelse>
					and A.Fecha >= '#ListToArray(q_Corte.fechainicio,' ',false,false)[1]#' and A.Fecha <='#ListToArray(q_Corte.fechafin,' ',false,false)[1]#' 
				</cfif>
				and A.ecodigo = #session.ecodigo# ),0) as TodasLasCompras
		, IsNull((select Sum(IsNull(A.Monto,0)) as Compras from  CRCTransaccion A
			left join CRCTipoTransaccion B on A.CRCTipoTransaccionid = B.id
			where  A.CRCCuentasid = #CuentaID#  and (B.afectaPagos = 1 or B.afectaCondonaciones = 1)
				<cfif arguments.Tipo eq 'TM'>
					and A.Fecha < #dateAdd('m', -1, date_fin)# 
				<cfelse>
					and A.Fecha >= '#ListToArray(q_Corte.fechainicio,' ',false,false)[1]#' and A.Fecha <='#ListToArray(q_Corte.fechafin,' ',false,false)[1]#'
				</cfif>
				and A.Ecodigo = #session.ecodigo# ),0) as TodosLosPagos
		, IsNull((select Sum(IsNull(A.Monto,0)) as Compras from  CRCTransaccion A
			left join CRCTipoTransaccion B on A.CRCTipoTransaccionid = B.id
			where  A.CRCCuentasid = #CuentaID#  and (B.afectaGastoCobranza = 1 or B.afectaInteres = 1)
				<cfif arguments.Tipo eq 'TM'>
					and A.Fecha < #date_fin#
				<cfelse>
					and A.Fecha < '#ListToArray(q_Corte.fechafin,' ',false,false)[1]#'  
				</cfif>
				and A.Ecodigo = #session.ecodigo# ),0) as TodosOtrosCargos
	from 
		CRCCuentas C
		left join CRCMovimientoCuentaCorte A
			on C.id = A.CRCCuentasid
		inner join CRCCortes B
			on B.Codigo = A.Corte
			and B.Codigo = '#CodCorte#'
	left join (
		select *
		from (
			select * 
			from CRCMovimientoCuentaCorte mca
			where mca.Corte = '#CodCorte#'
			and mca.CRCCuentasid = #CuentaID#
		) CorteA
	) CorteA on c.id = CorteA.CRCCuentasid
	left join (
		select top 1 mcb.* 
		from CRCCortes c
		inner join (
			select *
			from CRCCortes
			where Codigo = '#CodCorte#'
		) CorteA
			on datediff(day, c.FechaFIn , CorteA.FechaInicio) = 1
			and c.Tipo = CorteA.Tipo
		inner join CRCMovimientoCuentaCorte mcb
			on mcb.Corte = c.Codigo
		where mcb.CRCCuentasid = #CuentaID#
	) CorteB on c.id = CorteB.CRCCuentasid
	where
			C.id = #CuentaID#
		and C.Ecodigo = #session.ecodigo#
		and (B.Codigo = '#CodCorte#' or B.Codigo is null) 
	;
</cfquery>

<cfquery name="q_Empresa" datasource="#session.DSN#">
	select Enombre from Empresa where Ereferencia = #session.ecodigo#
</cfquery>

<!---
<cfif q_resumen.RecordCount eq 0>
	<cfthrow message = "USUARIO SIN OPERACIONES PARA GENERAR PDF">
</cfif>
--->

<!---
<cfset q_resumen.SaldoActual = q_resumen.TodasLasCompras + q_resumen.Intereses + q_resumen.TodosOtrosCargos - q_resumen.TodosLosPagos>
--->
<cfset q_resumen.CreditoDisponible = NumberFormat(q_resumen.MontoAprobado,'0.00') - NumberFormat(q_resumen.SaldoActual,'0.00')>



<cfset componentPath = "crc.Componentes.CRCCuentas">
<cfset objCuenta = createObject("component","#componentPath#")>

<cfset componentPath = "crc.Componentes.CRCBarcodeGenerator">
<cfset objBarcode = createObject("component","#componentPath#")>

<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>



<!--- Calcular el pago minimo --->
<cfset montoApagar = 0>
<cfif q_ResumenCorte.recordCount gt 0> 
	<cfset montoApagar = q_ResumenCorte.MontoAPagar>
</cfif>
<cfset q_resumen.pagoMinimo = objCuenta.getPagoMinino(montoApagar)>
<!--- 
 <cffunction  name="getParametro">
    <cfargument  name="DSN" required="true">
    <cfargument  name="Ecodigo" required="true">
    <cfargument  name="Codigo" required="true">

    <cfquery name="rsParametro" datasource="#arguments.DSN#">
        select Pvalor from CRCParametros
        where Pcodigo = '#arguments.Codigo#'
    </cfquery>
    <cfif rsParametro.recordCount gt 0>
        <cfreturn rsParametro.Pvalor>
    <cfelse>
        <cfthrow message="No se ha definido el Parametro #arguments.Codigo#">
    </cfif>
 </cffunction> ---> 