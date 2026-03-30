<!---Obtiene los caches sobre los que se va a trabajar --->
<cfquery datasource="asp" name="rscaches">
    select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
    from Empresa e
        join Caches c
        on e.Cid = c.Cid and e.Ereferencia is not null
    where Ereferencia in (1)
</cfquery>

 <cfloop query="rscaches">

    <cfset p_diaCorteTM = getParametro(rscaches.Ccache, rscaches.Ecodigo, '30000706')>
    <cfset p_aplicaGastoCobranza = getParametro(rscaches.Ccache, rscaches.Ecodigo, '30000715')>
    <cfset p_cortesSinPagos = getParametro(rscaches.Ccache, rscaches.Ecodigo, '30000716')>
    <cfset p_montoGastoCobranza = getParametro(rscaches.Ccache, rscaches.Ecodigo, '30000717')>

<cfset current_day = day(now())>
<cfset debug = false>
<!---     Verificamos si es dia de emision de estados de ceuntas --->
    <cfif current_day eq p_diaCorteTM or debug>
    <!---     Si esta activo Aplicar Gastos de Cobranza Automaticos --->
        <cfif p_aplicaGastoCobranza eq 'S'>    
            <!---     Inicia Gastos de cobranza automaticos --->
            <cfquery  name="rsTMGastoCobranza" datasource="#rscaches.Ccache#">
                select  cuentasaldo.*, isnull(cuentapago.fecha_ultimo_pago, cuentasaldo.primera_transaccion) fecha_ultimo_pago,
                    datediff(month, isnull(cuentapago.fecha_ultimo_pago, cuentasaldo.primera_transaccion),getdate()) cortenopago
                from  (
                    select c.id, c.Ecodigo, sum(
                        case when t.TipoMov = 'C' then t.Monto else t.Monto * -1 end
                    ) saldo,
                    min(t.Fecha) primera_transaccion
                    from CRCTransaccion t
                    inner join CRCCuentas c
                        on t.CRCCuentasid = c.id
                    where c.Tipo = 'TM'
                        and c.CRCEstatusCuentasid != (select Pvalor from CRCParametros where Pcodigo = '30100501' and Ecodigo = #rscaches.ecodigo#)
                    group by c.id, c.Ecodigo
                ) cuentasaldo
                left join (
                    select c.id, c.Ecodigo, max(t.Fecha) fecha_ultimo_pago
                    from CRCTransaccion t
                    inner join CRCCuentas c
                        on t.CRCCuentasid = c.id
                    where c.Tipo = 'TM'
                        and t.TipoTransaccion = 'PG'
                    group by c.id, c.Ecodigo
                ) cuentapago
                on cuentasaldo.id = cuentapago.id and cuentasaldo.Ecodigo = cuentapago.Ecodigo
                where datediff(month, isnull(cuentapago.fecha_ultimo_pago, cuentasaldo.primera_transaccion),getdate()) >= #p_cortesSinPagos#
                    and cuentasaldo.saldo > 0
                    and cuentasaldo.Ecodigo = #rscaches.Ecodigo#
            </cfquery>

            <cfif rsTMGastoCobranza.recordCount gt 0>
<!---           Se obtiene la transacciond de gasto de cobranza --->
                <cfquery name="q_TipoTransaccion" datasource="#rscaches.Ccache#">
					select id, Descripcion
					from   CRCTipoTransaccion
					where  Codigo = 'GC'
					and afectaGastoCobranza = 1
					and	TipoMov = 'C'
				</cfquery>	  
 
				<cfset loc.TransaccionGCID = q_TipoTransaccion.ID>
				<cfset loc.TransaccionGCDESC = q_TipoTransaccion.Descripcion>

                <cfloop query="rsTMGastoCobranza">
                    <cfset loc.FechaT = now()> 
                    <cfset loc.FechaT = CreateDate(DatePart('yyyy',#loc.FechaT#), DatePart('m',#loc.FechaT#),DatePart('d',#loc.FechaT#))>                    
                    <cfset objCRCTransaccion = createObject("component","crc.Componentes.compra.CRCTransaccionCompra")>
		            <cfset objCRCTransaccion.init(rscaches.Ccache, rscaches.Ecodigo)>
                    <cfset loc.tranID = objCRCTransaccion.crearTransaccion(CuentaID=rsTMGastoCobranza.id,
                                                        Tipo_TransaccionID = #loc.TransaccionGCID#,
                                                        Fecha_Transaccion= #loc.FechaT#,
                                                        Monto = #p_montoGastoCobranza#, 
                                                        Descuento = 0,
                                                        Observaciones = "#loc.TransaccionGCDESC#",
                                                        usarTagLastID = false,
                                                        AfectaMovCuenta = true)>
                </cfloop>
            </cfif>
            <!---     Termina Gastos de cobranza automaticos --->
        </cfif>
    
<!---     inicia Emision de estados de Cuentas --->
<!--- TODO --->
<!---     Termina Emision de estados de Cuentas --->

    </cfif>
 </cfloop>



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
 </cffunction>