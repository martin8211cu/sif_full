
<cfcomponent extends="crc.Componentes.transacciones.CRCTransaccion">

    <cffunction  name="AplicarTransferencia">
        <cfargument name="Transaccion_id"   required="yes"   type="string">
        <cfargument name="Monto"            required="yes"   type="numeric">
        <cfargument name="PagadoNeto"       required="yes"   type="numeric">
        <cfargument name="DSN"              required="no"    type="string" default="#this.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#this.ecodigo#">

        <cfset Super.init(arguments.DSN,arguments.Ecodigo)>

        
        <!--- Obtener datos de la transaccion --->
        <cfset q_tranqry =  getTransaccion(arguments.Transaccion_id, arguments.dsn, arguments.ecodigo)>

        <!--- Obtener corte actual y anterior que son afectados--->
        <cfset cortes =  getCortes(arguments.Transaccion_id,arguments.dsn,arguments.ecodigo)>

        <cfset montoNeto = arguments.Monto - arguments.PagadoNeto>  

        <cfquery name="rsTipotransaccion" datasource="#this.dsn#">
            select * from CRCTipoTransaccion where Codigo = 'XT' and Ecodigo = #this.Ecodigo#
        </cfquery>

        <cfif rsTipotransaccion.recordCOunt eq 0>
            <cfthrow message="No se ha definido el Tipo de Transaccion para Transferencias (XT)">
        </cfif>

        <cftransaction>
        
            <!--- Realizar la transaccion "saldar pagos del transaccion" --->
            <cfset idTransaccionS = crearTransaccion(
                              CuentaID            = q_tranqry.CRCCUENTASID
                            , Tipo_TransaccionID  = rsTipotransaccion.id
                            , Fecha_Transaccion   = Now()
                            , Monto               = montoNeto
                            , Observaciones       = "[#arguments.Transaccion_id#] Saldado x Cancelacion de Venta: #q_tranqry.OBSERVACIONES#"
                            , usarTagLastID       = false
                    )>
  
            <!--- Actualizar Parcialidades (MovimientoCuenta) --->
            <cfset ActualizarParcialidades(
                      transaccion_id = q_tranqry.id
                    , dsn = arguments.dsn
                    , ecodigo = arguments.ecodigo
            )>
            <!--- Actualizar Resumen de Corte (MovimientoCuentaCorte) --->
            <cfif IsArray(cortes)>
			    <cfset caMccPorCorteCuenta(cortes = arrayToList(cortes)  ,CuentaID = q_tranqry.CRCCUENTASID )>
            <cfelse>
			    <cfset caMccPorCorteCuenta(cortes = cortes  ,CuentaID = q_tranqry.CRCCUENTASID )>
            </cfif>

            <!--- Realizar afectacion a cuenta de la transaccion "saldar de transaccion" --->
            <cfquery name="q_Afectacion" datasource="#This.DSN#">
                update CRCCuentas set 
                      SaldoActual = (ISNull(SaldoActual,0 )-#q_tranqry.Monto#) 
                    , Interes = 0
                    , SaldoVencido = 0
                    , Condonaciones = 0
                    <cfif arguments.PagadoNeto gt 0>
                    , saldoAFavor += #NumberFormat(arguments.PagadoNeto,'0.00')#
                    </cfif>
                where id = #q_tranqry.CRCCUENTASID#;
            </cfquery>
            
        </cftransaction>
    </cffunction>

    <cffunction  name="ActualizarParcialidades">
        <cfargument name="transaccion_id"       required="yes"   type="numeric">
        <cfargument name="DSN"              required="no"    type="string" default="#this.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <!--- Actualizar las parcialidades cuyo corte sea estado 1 (parcialidades a pagar actualmente)--->
        <cfquery datasource="#arguments.dsn#">
            update mc set 
                  mc.Pagado =  Round(isNull(mc.Pagado,0) + (isNull(mc.MontoAPagar,0) - (isNull(mc.Descuento,0) + isNull(mc.Pagado,0))),2)
            from CRCMovimientoCuenta mc
            inner join CRCCortes c
                on c.Codigo = mc.corte
            inner join CRCTransaccion t
                on t.id = mc.CRCTransaccionid
            where mc.status = 1 and mc.CRCTransaccionid = #arguments.transaccion_id#
        </cfquery>
        
        <!--- Actualizar las parcialidades cuyo corte sea estado 0 (parcialidades a pagar a futuro)--->
        <cfquery datasource="#arguments.dsn#">
            update mc set 
                  mc.Pagado = Round(isNull(mc.Pagado,0) + (isNull(mc.MontoRequerido,0) - (isNull(mc.Descuento,0) + isNull(mc.Pagado,0))),2)
            from CRCMovimientoCuenta mc
            inner join CRCCortes c
                on c.Codigo = mc.corte
            inner join CRCTransaccion t
                on t.id = mc.CRCTransaccionid
            where IsNull(mc.status,0)  = 0 and mc.CRCTransaccionid = #arguments.transaccion_id#
        </cfquery>
    </cffunction>

    <cffunction  name="getCortes">
        <cfargument name="Transaccion_id"      required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <cfquery name="q_Cortes" datasource="#arguments.DSN#">
            select 
                cr.codigo
            from CRCTransaccion cv
                inner join CRCCuentas cu
                    on cu.id = cv.CRCCuentasid
                inner join CRCCortes cr
                    on cr.Tipo like concat('%',rtrim(ltrim(cu.Tipo)),'%')
            where
                isNull(cr.status,0) <= 1 
                and cv.id = #arguments.Transaccion_id#
                and cv.ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfreturn listToArray(ValueList(q_Cortes.codigo),',')>
    </cffunction>

    <cffunction  name="getTransaccion">
        <cfargument name="Transaccion_id"      required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">
        <cfquery name="q_tranqry" datasource="#arguments.DSN#">
            select c.*
                from CRCTransaccion c
                where c.id = #arguments.Transaccion_id# and c.ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfreturn q_tranqry>
    </cffunction>

    <cffunction  name="CancelaPago">
        <cfargument name="Transaccion_id"      required="yes"   type="numeric">
        <cfargument name="debug"      required="false"   type="boolean" default="false">

        <cfif arguments.debug>  <cfdump  var="#arguments#" label="Argumentos">  </cfif>

        <!--- Se Obtiene y Valida la Transaccion --->
        <cfquery name="rsTransaccion" datasource="#this.dsn#">
            select t.id, c.id CuentaId, t.Monto, t.Fecha, et.ETcomision, c.Tipo CuentaTipo, dt.DTdeslinea,
            t.Monto - dt.DTdeslinea MontoNeto, et.FCid, t.ETnumero, et.CFid
            from CRCTransaccion t
            inner join CRCCuentas c on t.CRCCuentasid = c.id
            inner join ETransacciones et on t.ETnumero = et.ETnumero and t.Ecodigo = et.Ecodigo and t.Ecodigo = et.Ecodigo
            inner join DTransacciones dt on et.ETnumero = dt.ETnumero and et.Ecodigo = dt.Ecodigo
            where t.id = #arguments.Transaccion_id#
                and t.TipoTransaccion = 'PG'
                and t.ReversaId is null
                and t.Ecodigo = #this.Ecodigo#
        </cfquery>

        <cfif rsTransaccion.recordCOunt eq 0 >
            <cfthrow message="No se encontro la Transaccion de Pago o ya fue Reversada #arguments.Transaccion_id#">
        </cfif>
        <cfif arguments.debug> <cfdump  var="#rsTransaccion#" label="Trasaccion"> </cfif>
        
        <!--- Afectacion en Sistema de Credito --->
        <!--- OBTENCION DE ID PARA TIPO DE TRANSACCION --->
		<cfquery name="q_TipoTransaccion" datasource="#This.DSN#">
			select id, Codigo,TipoMov
			from   CRCTipoTransaccion
			where  Codigo = 'RP'
				and afectaPagos = 1
				and	TipoMov = 'C'
                and Ecodigo = #this.Ecodigo#
		</cfquery>	
		
		<cfset _fecha = formatStringToDate("#LSDateFormat(now(),'dd/mm/yyyy')#")>

		<cfif q_TipoTransaccion.recordcount eq 0>
			<cfthrow errorcode="#This.C_ERROR_TIPO_TRANSACCION#" type="TransaccionException" message = "Tipo de Transaccion [RP] No reconocida">
		</cfif>	
        <cfset montoTotal = rsTransaccion.Monto>
        
        <!--- Se generara Transaccion de Reversa de Pago --->
		<cfset tranIDCancelada = crearTransaccion(CuentaID=rsTransaccion.CuentaId,
								Tipo_TransaccionID = q_TipoTransaccion.id,
								Fecha_Transaccion= _fecha,
							    Monto = montoTotal,
							    Observaciones = 'Pago Reversado')>

        <cfset cortes = reversaPago(
            CuentaID = rsTransaccion.CuentaId,
            Monto = montoTotal,
            FechaPago = _fecha,
            FCid = rsTransaccion.FCid,
            ETnumero = rsTransaccion.ETnumero,
            transaccionID = arguments.Transaccion_id,
            debug = arguments.debug
            )>
                                    
        <cfquery name="rsContabilizaFacturaDigital" datasource="#this.dsn#">
            select coalesce(Pvalor,'0') as usa
            from Parametros
            where Pcodigo = 16372
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#" >
          </cfquery>
          <cfif isDefined("rsContabilizaFacturaDigital.usa") and rsContabilizaFacturaDigital.usa eq 1>
            <cfset ContabilizarTransa = "conta">
        <cfelse>
            <cfset ContabilizarTransa = "aplica">
        </cfif>

        <!--- Afectaccion Contable por la Reversa de Pago --->
        <cfinvoke component="crc.Componentes.pago.CRCFuncionesPago"  method="AplicarTransaccionPago">
            <cfinvokeargument name="ETnumero" value="#rsTransaccion.ETnumero#">
            <cfinvokeargument name="FCid" value="#rsTransaccion.FCid#">
            <cfinvokeargument name="Contabilizar" value="#ContabilizarTransa#">
            <cfinvokeargument name="PrioridadEnvio" value="0">
            <!--- Se envia FAFC en CPNAPmoduloOri para aplicar pagado en poliza de ingresos--->
            <cfinvokeargument name="CPNAPmoduloOri" value="FAFC">
            <cfinvokeargument name="ModuloOrigen" value="CRC">
            <cfinvokeargument name="Reversar" value="true">
        </cfinvoke>
        
        <!--- Se actualiza la transaccion Reversada con el Id de Trasaccion de reversa --->
        <cfquery datasource="#this.dsn#">
            update CRCtransaccion set ReversaId = #tranIDCancelada#
            where id = #arguments.Transaccion_id#
        </cfquery>

        <!--- Verificammos si la transaccion reversada se le aplico la nota de Credito por Descuento --->
        <cfquery name="rsDescuentoAplicado" datasource="#this.dsn#">
            select * 
            from CRCGenerarNC
            where ETnumero = '#rsTransaccion.ETnumero#'
                and Ecodigo = #this.Ecodigo#
        </cfquery>

        <!--- Verificammos si la transaccion reversada se le aplico la nota de Credito por Descuento --->
        <cfquery datasource="#this.dsn#">
            Update ETransacciones 
            set ETestado = 'A'
            where ETnumero = '#rsTransaccion.ETnumero#'
                and Ecodigo = #this.Ecodigo#
        </cfquery>
        
        <cfif rsDescuentoAplicado.recordCount gt 0 and rsTransaccion.DTdeslinea gt 0>
            <!--- Generamos Factura por el Concepto de Descuento --->
            <cfset creaFacturaDescuento(CFid = rsTransaccion.CFid, Monto=rsTransaccion.DTdeslinea)>
        </cfif>

        <cfset _mycfc = createObject("component", "crc.Componentes.cortes.CRCReProcesoCorte")>
        <cfset _mycfc.reProcesarCorte(cuentaID = rsTransaccion.CuentaId, dsn = "#this.dsn#", ecodigo = this.Ecodigo)>

        <cfif arguments.debug>
            <cfdump  var="FIN" abort>
        </cfif>

    </cffunction>

    <cffunction  name="creaFacturaDescuento">
        <cfargument name="CFid" required = "true" type="numeric">
        <cfargument name="Monto" required = "true" type="numeric">

        <!--- Obtiene el id del Socio de Negocio --->
        <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
        <cfset val = objParams.GetParametroInfo('30200101')>
        <cfif val.valor eq ''><cfthrow message="El parametro [30200101 - Cuenta generica de cliente vales] no esta definido"></cfif>
        
        <cfset valC = objParams.GetParametroInfo('30200505')>
        <cfif valC.valor eq ''><cfthrow message="El parametro [30200505 - Concepto de Servicio por Pronto Pago] no esta definido"></cfif>

        <!--- Obtiene los datos del Socio de Negocio --->
        <cfquery name="q_SNegocio" datasource="#this.dsn#">
            select SNcodigo,isNull(SNcuentacxc,'') SNcuentacxc,* 
            from SNegocios where SNid = #val.valor#
        </cfquery>

        <!--- Valida que exista el Socio de Negocio --->
        <cfif q_SNegocio.recordCount eq 0>
            <cfthrow message="El Socio de Negocio especificado en el parametro [30200101 - Cuenta generica de cliente vales] no existe">
        </cfif>
        <!--- Valida que esté configurada el id de CxC --->
        <cfif q_SNegocio.SNcuentacxc eq ''>
            <cfthrow message="No se ha configurado una Cuenta por Cobrar para el Socio de Negocio [#q_SNegocio.SNnumero#: #q_SNegocio.SNnombre#]">
        </cfif>
        <!--- Obtiene los datos de la cuenta por cobrar --->
        <cfquery name="q_CuentaCxC" datasource="#this.dsn#">
            select * from CContables where Ccuenta = #q_SNegocio.SNcuentacxc#;
        </cfquery>
        <!--- Valida que la cuenta especificada exista --->
        <cfif q_CuentaCxC.recordCount eq 0>
            <cfthrow message="El Socio de Negocio especificado en el parametro [30200101 - Cuenta generica de cliente vales] no existe">
        </cfif>

        <!--- Obtener Codigo de Moneda Local (Moneda de Empresa) --->
        <cfquery name="q_Moneda" datasource="#this.dsn#">
            select e.Mcodigo, m.Miso4217
            from empresas e
                inner join Monedas m
                    on m.Mcodigo = e.Mcodigo
            where e.Ecodigo = #this.ecodigo#;
        </cfquery>

        <!--- id de Centro Funcional --->
        <cfset CentroFuncionalID = arguments.CFid>

        <!--- Se obtiene el Ocodigo para el detalle del pago--->
        <cfquery name="q_CFuncional" datasource="#this.dsn#">
            select cf.Ocodigo, Dcodigo, cf.CFcodigo
                from CFuncional cf
                where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">
        </cfquery>

        <!--- id de concepto, crear parametro Cid--->
        <cfset ConceptoServicioID = valC.valor>
        <!--- Se obtiene el Ocodigo para el detalle del pago--->
        <cfquery name="q_CServicio" datasource="#this.dsn#">
            select c.Cid, c.Ccodigo, c.Cdescripcion, c.Cformato
            from Conceptos c
            where c.Ecodigo = #this.Ecodigo#
                and c.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">
        </cfquery>
        <!--- Valida que la cuenta especificada exista --->
        <cfif q_CServicio.Cformato eq "" >
            <cfthrow message="No se ha definido la Cuenta Contable en el Concepto de Servicio especificado en el parametro [30200505 - Concepto de Servicio por Pronto Pago]">
        </cfif>

        <!--- Fecha de Nota de Credito --->
        <cfset FC_Date = DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')>

        <!--- Determinar el codigo de documento --->
        <cfset CodigoDocumento = "CRC-NCD-#DateTimeFormat(now(),'yymmddhhmmss')#">
        <!--- Inserta encabezado de FC --->
        <cfquery name="insertEnc" datasource="#this.dsn#">
            INSERT INTO FAPreFacturaE
                (Ecodigo, PFDocumento, Ocodigo, SNcodigo, Mcodigo, FechaCot, FechaVen, PFTcodigo, TipoPago, Estatus,
                    Descuento, Impuesto, Total, NumOrdenCompra,
                    Observaciones, TipoCambio, BMUsucodigo, fechaalta, id_direccion, Fecha_doc,vencimiento,Rcodigo)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CodigoDocumento#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#q_CFuncional.Ocodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_SNegocio.SNcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Moneda.Mcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FC_Date#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FC_Date#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="PF">,
                0,
                'P',
                0,
                0, 0,
                null,
                '',
                1, <!--- TODO --->
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#q_SNegocio.id_direccion#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#FC_Date#">,
                0,
                -1
                )
            <cf_dbidentity1 datasource="#this.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#this.DSN#" name="q_insertEncabezadoNC">
        <cfset idE_FC = q_insertEncabezadoNC.identity>

        <!--- Inserta Detalle de NC  --->
        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <cfset _formatoDescuento = mascara.AplicarMascara(q_CServicio.Cformato, q_CFuncional.CFcodigo, '!')>
        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
            <cfinvokeargument name="Lprm_CFformato" 		value="#_formatoDescuento#"/>
            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
            <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
            <cfinvokeargument name="Lprm_Ecodigo" 			value="#this.Ecodigo#"/>
        </cfinvoke>
        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
        </cfif>
    <!---         Se obtiene la cuenta contable --->
        <cfquery name="rsCcuentaServicio" datasource="#this.dsn#">
            select Ccuenta,Cdescripcion from CContables where Cformato = '#trim(_formatoDescuento)#' and Ecodigo = #this.Ecodigo#
        </cfquery>

        <cfquery name="proxLinea" datasource="#this.dsn#">
            select 	(coalesce(max(Linea),0) + 1) as Linea
            from 	FAPreFacturaD
            where 	Ecodigo = #this.Ecodigo#
                and IDpreFactura = #idE_FC#
        </cfquery>

        <cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
        <cfset _icodigo = crcObjParametros.GetParametro(codigo='30300106',conexion=this.dsn,ecodigo=this.ecodigo)>

        <cfif _icodigo eq ''>
            <cfthrow errorcode="30300106" type="ParametroException" message = "No se ha configurado el Impuesto para Notas de Credito y Comisiones">
        </cfif>	

        <cfquery name="rsImpuestos" datasource="#this.DSN#">
            select Icodigo,Idescripcion,Iporcentaje, ieps, IEscalonado, TipoCalculo, ValorCalculo
            from Impuestos
            where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
                and Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#_icodigo#">
        </cfquery>

        <cfset _total = LSParseNumber(arguments.Monto)>
        <cfset _subtotal = (_total/(1+(rsImpuestos.Iporcentaje/100))) >
            
        <cfquery name="q_insertDetalleNC" datasource="#this.DSN#" >
            INSERT INTO FAPreFacturaD
                    (Ecodigo, Linea, IDpreFactura, Cantidad, TipoLinea, Aid, Alm_Aid, Cid, CFid, Icodigo, Descripcion,
                    Descripcion_Alt, PrecioUnitario, DescuentoLinea, TotalLinea, BMUsucodigo, fechaalta, Ccuenta, codIEPS, FAMontoIEPSLinea, afectaIVA)
            VALUES  (<cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#proxLinea.Linea#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_FC#">,
                    1,
                    'S',
                    null,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#_icodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_CServicio.Cdescripcion#">,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#_subtotal#">,
                    0,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#_subtotal#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mm/yyyy')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCcuentaServicio.Ccuenta#">,
                    -1,
                    0,
                    1
                )
        </cfquery>

        <!--- Actualiza Encabezado --->
        <cfquery name="validaIEPS" datasource="#this.dsn#">
            select SUM(isnull(FAMontoIEPSLinea,0)) as valid from FAPreFacturaD d
                        inner join FAPreFacturaE ce
                            on ce.IDpreFactura = d.IDpreFactura
                                and ce.Ecodigo = d.Ecodigo
            where d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
                        and d.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_FC#">
        </cfquery>
        <cfquery name="rsTotales" datasource="#this.DSN#">
            SELECT SUM(sumImpuesto) AS sumImpuesto, SUM(sumDescuento) sumDescuento, SUM(sumSubTotal) sumSubTotal, SUM(IEPS) IEPS
            FROM (SELECT SUM(d.DescuentoLinea) as sumDescuento, SUM(Cantidad * PrecioUnitario) as sumSubTotal, SUM(isnull(FAMontoIEPSLinea,0)) as IEPS,
                        case d.afectaIVA
                            when 0 then
                                SUM((((Cantidad * PrecioUnitario) - d.DescuentoLinea) + d.FAMontoIEPSLinea) * (i.Iporcentaje / 100))
                            else
                                SUM(((Cantidad * PrecioUnitario) - d.DescuentoLinea) * (i.Iporcentaje / 100))
                            end as sumImpuesto
                    from FAPreFacturaD d
                        inner join FAPreFacturaE ce
                            on ce.IDpreFactura = d.IDpreFactura
                                and ce.Ecodigo = d.Ecodigo
                        inner join Impuestos i
                            on i.Icodigo = d.Icodigo
                                and i.Ecodigo = ce.Ecodigo
                        left join Impuestos ii
                            on ii.Icodigo = d.codIEPS
                                and ii.Ecodigo = ce.Ecodigo
                        where d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#this.Ecodigo#">
                        and d.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_FC#">
                        group by afectaIVA
                )as impuestos
        </cfquery>
        <cfif isdefined('rsTotales')
            and rsTotales.recordCount GT 0
            and rsTotales.sumSubTotal NEQ ''
            and rsTotales.sumImpuesto NEQ ''
            and rsTotales.sumDescuento NEQ ''>
            <cfset TotalCot = 0>
            <cfif validaIEPS.valid GT 0 >
                <cfset TotalCot = (rsTotales.sumSubTotal - rsTotales.sumDescuento + rsTotales.IEPS + rsTotales.sumImpuesto) >
            <cfelse>
                <cfset TotalCot = (rsTotales.sumSubTotal - rsTotales.sumDescuento + rsTotales.sumImpuesto) >
            </cfif>
            <cfquery name="update" datasource="#this.DSN#">
                    update FAPreFacturaE
                        set
                            Impuesto	=	<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.sumImpuesto#">,
                            <cfif validaIEPS.valid GT 0 >
                                FAieps		=	<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.IEPS#">,
                        <cfelse>
                                FAieps		=	0,
                            </cfif>
                            Total		=	<cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#"> - coalesce(Descuento,0)
                    where Ecodigo = <cfqueryparam value="#this.Ecodigo#" cfsqltype="cf_sql_integer">
                        and IDpreFactura = <cfqueryparam value="#idE_FC#" cfsqltype="cf_sql_numeric">
                </cfquery>
        <cfelse>
            <cfquery name="update" datasource="#this.DSN#">
                update FAPreFacturaE
                    set
                        Impuesto = 0,
                        Total = 0,
                        FAieps = 0
                where Ecodigo= <cfqueryparam value="#this.Ecodigo#" cfsqltype="cf_sql_integer">
                    and IDpreFactura = <cfqueryparam value="#idE_FC#" cfsqltype="cf_sql_numeric">
            </cfquery>
        </cfif>

        <!--- Realiza la aplicacion del documentos --->
        <cfinvoke component="sif.fa.Componentes.FA_Facturacion"
                    method="AplicaPreFactura"
                    idPrefactura	= "#idE_FC#"
                    Ecodigo = "#this.Ecodigo#"
                    dsn = "#this.dsn#"
        />
    </cffunction>

    <cffunction  name="reversaPago">
        <cfargument name="CuentaID"   type="numeric" required="true">
		<cfargument name="Monto"      type="numeric" required="true">
		<cfargument name="FechaPago"        required = "true" type="date">
		<cfargument name="transaccionID"	required = "true" type="numeric">
		<cfargument name="FCid" 			required = "false" type="numeric" default = 0>
		<cfargument name="ETnumero" 		required = "false" type="numeric" default = 0>
		<cfargument name="debug"		required = "false" type="boolean" default = "false">

        <!--- variables para controlar saldo del monto pagado y descuento --->
        <cfset lvarSaldoMonto = arguments.Monto>
        
        <!-- obtener el componente de corte -->
 		<cfset cCorte = createobject("component", "crc.Componentes.cortes.CRCCortes")>	
        <cfset cCuenta = createobject("component", "crc.Componentes.CRCCuentas")>		

        <cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
		<cfset statusConvenio = crcObjParametros.GetParametro(codigo='30100501',conexion=this.dsn,ecodigo=this.ecodigo)>

		<cfset strPagos = structNew()>
        <cfset strPagos.Seguro = 0>
        <cfset strPagos.Intereses = 0>
        <cfset strPagos.InteresesVencidos = 0>
        <cfset strPagos.Descuento = 0>
        <cfset strPagos.GastoCobranza = 0>
        <cfset strPagos.Ventas = 0>
        <cfset strPagos.Afavor = 0>

        <cfquery name="rsCuenta" datasource="#this.dsn#">
            select * from CRCCuentas where id = #arguments.CuentaID#
        </cfquery>

        <cfquery name="rsOrdenEstatusAct" datasource="#this.dsn#">
            select id, Orden from CRCEstatusCuentas where id = #rsCuenta.CRCEstatusCuentasid#
        </cfquery>

        <cfquery name="rsOrdenEstatusParam" datasource="#this.dsn#">
            select id, Orden from CRCEstatusCuentas where id = #statusConvenio#
        </cfquery>

        <!-- buscar cortes con monto a pagar calculado-->
		<cfquery name="qCorteAPagar" datasource="#This.dsn#"> 
			select top 1 Codigo
			from CRCCortes 
			where  status = #This.C_STATUS_MP_CALC#
			and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
	    </cfquery>

		<!--- 		Si no se obtiene un corte en status uno, se busca el primer corte abierto --->
		<cfif qCorteAPagar.recordCount eq 0>
			<cfquery name="qCorteAPagar" datasource="#This.dsn#"> 
				select min(Codigo) Codigo
				from CRCCortes 
				where  status = 0
				and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
		</cfif>

		<cfset This.cortesMP = qCorteAPagar.Codigo>
        
        <!-- buscar cortes con monto a Saldo vencido calculado-->
		<cfquery name="qCorteAnterior" datasource="#This.dsn#"> 
			select top 1 Codigo
			from CRCCortes 
			where  status = 2
			and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
	    </cfquery>

        <cfset This.cortesAnterior = qCorteAnterior.Codigo>

        <cfquery name="qCorteActual" datasource="#This.dsn#"> 
            select min(Codigo) Codigo
            from CRCCortes 
            where  status = 1
            and  Tipo = <cfqueryparam value ="#rsCuenta.Tipo#" cfsqltype="cf_sql_varchar"> 
        </cfquery>

        <cfset This.cortesActual = qCorteActual.Codigo>
		<!--- Si no se obtiene un corte en status 2, se busca el primer status 1 --->
		<cfif qCorteAnterior.recordCount eq 0>
			<cfset This.cortesAnterior = This.cortesActual>
		</cfif>

		

        <cfif arguments.debug><cfdump var='#arguments#' abort='false' label="Argumentos"></cfif> 
        <cfif arguments.debug><cfdump var='#This.cortesMP#' abort='false' label="CorteActual"></cfif> 
        <cfif arguments.debug><cfdump var='#lvarSaldoMonto#' abort='false' label="Monto"></cfif> 
        <cfif arguments.debug><cfdump var='#rsCuenta#' abort='false' label="Datos de Cuenta"></cfif>         
        
        <!--- Pasos de Reversa --->
        <!--- 1. si queda saldo en el monto pagago, se debe poner como saldo a favor...  --->
        <!---	se obtienen los Movimientos de Cuentas correspondientes de cortes a futuro que tengan saldo pendiente --->
        <cfif rsCuenta.saldoAFavor neq "" and rsCuenta.saldoAFavor gt 0>
            <cfset _monto = lvarSaldoMonto>
            <cfif lvarSaldoMonto gte rsCuenta.saldoAFavor>
                <cfset _monto = rsCuenta.saldoAFavor>
            </cfif>
			<cfquery datasource="#this.dsn#">
				update CRCcuentas set saldoAFavor = isnull(saldoAFavor,0) - #NumberFormat(_monto,'9.99')#
				where id = #arguments.CuentaID#
            </cfquery>
            
            <cfset lvarSaldoMonto -= _monto>
			<cfset strPagos.Afavor = _monto>
        </cfif>

       
        <cfif NumberFormat(lvarSaldoMonto,'9.999') gt 0 >
        <!--- 2. Si queda disponible, se revierten los pagos a futuro con descuento--->
            <!---	se obtienen los Movimientos de Cuentas correspondientes de cortes a futuro que tengan monto pagado --->
            <cfquery name="rsMovCtasMontoPagoFuturo" datasource="#this.dsn#">
                select t.CRCCuentasid, t.id TransaccionId, t.TipoTransaccion, t.FechaInicioPago,
                    c.id, c.Pagado, c.Descuento, c.Pagado + c.Descuento PagoTotal, c.MontoRequerido, c.MontoAPagar,
                    0 Intereses, c.Corte, t.Monto
                from CRCMovimientoCuenta c 
                inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
                where t.CRCCuentasid = #arguments.CuentaID# 
                    and c.Pagado + c.Descuento > 0 
                    <cfif trim(rsCuenta.Tipo) eq 'D'>
                        and c.Corte >= '#This.cortesAnterior#' 
                        and c.Descuento > 0 
                    <cfelse>
                        and c.Corte > '#This.cortesMP#'
                    </cfif>
                order by c.Corte desc, t.TipoTransaccion desc, c.Descuento desc
            </cfquery>

            <cfif arguments.debug><cfdump var='#rsMovCtasMontoPagoFuturo#' abort='false' label="PagoFuturoDescuento">	 </cfif>
            
            <!---	por cada movimiento cuenta con pago a futuro --->
            <cfloop query="rsMovCtasMontoPagoFuturo">
                
                <cfset _monto = NumberFormat(lvarSaldoMonto,'9.99')>
                <cfif lvarSaldoMonto gte rsMovCtasMontoPagoFuturo.MontoRequerido>
                    <cfset _montopt = rsMovCtasMontoPagoFuturo.PagoTotal>
                    <cfif rsMovCtasMontoPagoFuturo.PagoTotal gte rsMovCtasMontoPagoFuturo.MontoRequerido>
                        <cfset _monto = rsMovCtasMontoPagoFuturo.MontoRequerido>
                    <cfelse>
                        <cfset _monto = rsMovCtasMontoPagoFuturo.PagoTotal>
                    </cfif>
                <cfelse>
                    <cfset _montopt = lvarSaldoMonto>
                </cfif>

                <cfset lvarDescuento = _montopt*rsMovCtasMontoPagoFuturo.Descuento/rsMovCtasMontoPagoFuturo.PagoTotal>
                <cfset lvarPagado = _montopt*rsMovCtasMontoPagoFuturo.Pagado/rsMovCtasMontoPagoFuturo.PagoTotal>

                <!--- <cfif lvarPagado + lvarDescuento gt _monto>
                    <cfset lvarDescuento = _monto*lvarDescuento/(lvarPagado + lvarDescuento)>
                    <cfset lvarPagado = _monto*lvarPagado/(lvarPagado + lvarDescuento)>
                </cfif> --->


                <cfif lvarPagado gte rsMovCtasMontoPagoFuturo.MontoRequerido>
                    <cfset lvarPagado = rsMovCtasMontoPagoFuturo.MontoRequerido - lvarDescuento>
                </cfif>

                <cfset lvarMonto = rsMovCtasMontoPagoFuturo.Monto>
                <cfset lvarIntereses = rsMovCtasMontoPagoFuturo.Intereses>

                <!--- <cfif arguments.debug>
                    <cfdump  var="#{ 
                        lvarDescuento = lvarDescuento,
                        lvarPagado = lvarPagado,
                        lvarSaldoMonto = lvarSaldoMonto
                    }#" label="Monto paga">
                </cfif> --->


                <cfquery datasource="#this.dsn#">
                    update c
                        set c.Pagado -= #NumberFormat(lvarPagado,'9.99')#,
                            c.Descuento -= #NumberFormat(lvarDescuento,'9.99')#
                    from CRCMovimientoCuenta c 						
                    where c.id = #rsMovCtasMontoPagoFuturo.id#
                </cfquery>

                <cfif lvarPagado lte lvarIntereses>
                    <cfif rsMovCtasMontoPagoFuturo.TipoTransaccion eq 'GC'>
                        <cfset strPagos.GastoCobranza += _monto>
                    <cfelse>
                        <cfset strPagos.Intereses += _monto>
                    </cfif>
                <cfelse>
                    <cfif rsMovCtasMontoPagoFuturo.TipoTransaccion eq 'GC'>
                        <cfset strPagos.GastoCobranza += lvarMonto>
                        <cfset strPagos.Intereses += _monto - lvarMonto>
                    <cfelse>
                        <cfset strPagos.Ventas += NumberFormat(_monto,'9.99') - lvarIntereses>
                    </cfif>
                </cfif>

                <cfset strPagos.Descuento += NumberFormat(lvarDescuento,'9.99')>
                <cfset lvarSaldoMonto -= NumberFormat(_monto,'9.99')>
                
                <cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
                    <cfbreak>
                </cfif>
            </cfloop>                
        </cfif>


        <cfif NumberFormat(lvarSaldoMonto,'9.999') gt 0 >
        <!--- 3. Si queda disponible, se revierten los pagos a futuro con Saldo Vencido--->
            <!---	se obtienen los Movimientos de Cuentas correspondientes de cortes a futuro que tengan monto pagado --->
            <cfquery name="rsMovCtasMontoPagoFuturo" datasource="#this.dsn#">
                select t.CRCCuentasid, t.id TransaccionId, t.TipoTransaccion, t.FechaInicioPago,
                    c.id, c.Pagado - isnull(mca.Intereses,0) Pagado, c.Descuento, (c.Pagado - isnull(mca.Intereses,0)) + c.Descuento PagoTotal, c.MontoRequerido, c.MontoAPagar,
                    isnull(mca.Intereses,0) Intereses, c.Corte, t.Monto
                from CRCMovimientoCuenta c 
                inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
                left join (
                    select mca.CRCTransaccionId,
                        sum(mca.Intereses) Intereses, sum(mca.MontoRequerido) MontoRequerido
                    from  CRCMovimientoCuenta mca
                    where mca.Corte = '#This.cortesAnterior#'
                    group by mca.CRCTransaccionId
                ) mca on t.id = mca.CRCTransaccionid
                where c.Corte >= '#This.cortesAnterior#' 
                    and t.CRCCuentasid = #arguments.CuentaID# 
                    and (c.Pagado - isnull(mca.Intereses,0)) + c.Descuento > 0 
                    and c.Descuento = 0
                order by c.Corte desc, t.TipoTransaccion desc, isnull(mca.Intereses,0) desc
            </cfquery>

            <cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPagoFuturo#' abort='false' label="PagoFuturoIntereses">	 </cfif>
            
            <!---	por cada movimiento cuenta con pago a futuro --->
            <cfloop query="rsMovCtasMontoPagoFuturo">
                
                <cfset _monto = NumberFormat(lvarSaldoMonto,'9.99')>
                <cfif lvarSaldoMonto gte rsMovCtasMontoPagoFuturo.Pagado>
                    <cfset _monto = rsMovCtasMontoPagoFuturo.Pagado>
                </cfif>

                <cfset lvarPagado = rsMovCtasMontoPagoFuturo.Pagado>
                <cfset lvarMonto = rsMovCtasMontoPagoFuturo.Monto>

                <cfquery datasource="#this.dsn#">
                    update c
                        set c.Pagado -= #NumberFormat(_monto,'9.99')#
                    from CRCMovimientoCuenta c 						
                    where c.id = #rsMovCtasMontoPagoFuturo.id#
                </cfquery>

                
                <cfif rsMovCtasMontoPagoFuturo.TipoTransaccion eq 'GC'>
                    <cfset strPagos.GastoCobranza += _monto>
                <cfelse>
                    <cfset strPagos.Ventas += _monto>
                </cfif>
                
                <cfset lvarSaldoMonto -= NumberFormat(_monto,'9.99')>
                <cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
                    <cfbreak>
                </cfif>
            </cfloop>                
        </cfif>

        <cfif NumberFormat(lvarSaldoMonto,'9.999') gt 0 >
        <!--- 4. Si queda disponible, se revierten los pagos a futuro con intereses--->
            <!---	se obtienen los Movimientos de Cuentas correspondientes de cortes a futuro que tengan monto pagado --->
            <cfquery name="rsMovCtasMontoPagoFuturo" datasource="#this.dsn#">
                select t.CRCCuentasid, t.id TransaccionId, t.TipoTransaccion, t.FechaInicioPago,
                    c.id, c.Pagado, c.Descuento, c.Pagado + c.Descuento PagoTotal, c.MontoRequerido, c.MontoAPagar,
                    isnull(mca.Intereses,0) Intereses, c.Corte, t.Monto
                from CRCMovimientoCuenta c 
                inner join CRCTransaccion t on t.id = c.CRCTransaccionid 
                left join (
                    select mca.CRCTransaccionId,
                        sum(mca.Intereses) Intereses, sum(mca.MontoRequerido) MontoRequerido
                    from  CRCMovimientoCuenta mca
                    where mca.Corte = '#This.cortesAnterior#'
                    group by mca.CRCTransaccionId
                ) mca on t.id = mca.CRCTransaccionid
                where c.Corte >= '#This.cortesAnterior#' 
                    and t.CRCCuentasid = #arguments.CuentaID# 
                    and c.Pagado + c.Descuento > 0 
                    and mca.Intereses > 0
                order by c.Corte desc, t.TipoTransaccion desc, isnull(mca.Intereses,0) desc
            </cfquery>

            <cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPagoFuturo#' abort='false' label="PagoFuturoIntereses">	 </cfif>
            
            <!---	por cada movimiento cuenta con pago a futuro --->
            <cfloop query="rsMovCtasMontoPagoFuturo">
                
                <cfset _monto = NumberFormat(lvarSaldoMonto,'9.99')>
                <cfif lvarSaldoMonto gte rsMovCtasMontoPagoFuturo.Intereses>
                    <cfset _monto = rsMovCtasMontoPagoFuturo.Intereses>
                </cfif>

                <cfset lvarPagado = rsMovCtasMontoPagoFuturo.Intereses>
                <cfset lvarMonto = rsMovCtasMontoPagoFuturo.Monto>

                <cfquery datasource="#this.dsn#">
                    update c
                        set c.Pagado -= #NumberFormat(_monto,'9.99')#
                    from CRCMovimientoCuenta c 						
                    where c.id = #rsMovCtasMontoPagoFuturo.id#
                </cfquery>
                
                <cfset strPagos.Intereses += _monto>
                
                <cfset lvarSaldoMonto -= NumberFormat(_monto,'9.99')>
                <cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
                    <cfbreak>
                </cfif>
            </cfloop>                
        </cfif>


        <cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
        <!--- 5. Se Revierten pagos del corte --->
            <cfset porDesc = 0>
            <cfif trim(rsCuenta.Tipo) eq "#this.C_TP_DISTRIBUIDOR#" and rsOrdenEstatusAct.Orden lt rsOrdenEstatusParam.Orden>
                <cfquery name="q_codCortePago" datasource="#this.dsn#">
                    select top 1 *
                    from CRCCortes ct
                    where #arguments.FechaPago# between FechaInicio and dateadd(day, 1, FechaFin)
                        and Tipo = 'D'
                </cfquery>
                <cfset porDesc = cCuenta.getPorcientoDescuento(arguments.FechaPago,rsCuenta.CRCCategoriaDistid,"#q_codCortePago.codigo#")>
            </cfif>
            <!--- se obtienen los Movimientos de Cuentas correspondientes al corte a Pagar que tengan saldo pendiente --->
            <cfquery name="rsMovCtasMontoPago" datasource="#this.dsn#">
                select  t.CRCCuentasid, t.id TransaccionId, t.FechaInicioPago, t.TipoTransaccion,
                        c.id, c.Pagado, c.Descuento, c.Pagado + c.Descuento PagoTotal,
	                    mca.Intereses, mca.MontoRequerido
                from CRCMovimientoCuenta c 
                inner join CRCTransaccion t on t.id = c.CRCTransaccionid
                inner join (
                    select mca.CRCTransaccionId,
                        sum(mca.Intereses) Intereses, sum(mca.MontoRequerido) MontoRequerido
                    from  CRCMovimientoCuenta mca
                    where mca.Corte = <cfqueryparam value ="#This.cortesAnterior#" cfsqltype="cf_sql_varchar">
                    group by mca.CRCTransaccionId
                ) mca on t.id = mca.CRCTransaccionid 
                where c.Corte = <cfqueryparam value ="#This.cortesAnterior#" cfsqltype="cf_sql_varchar"> 
                and t.CRCCuentasid = #arguments.CuentaID#
                and c.Pagado + c.Descuento > 0
                order by t.TipoTransaccion desc, t.FechaInicioPago desc, c.id desc
            </cfquery>
            
            <cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPago#' abort='false' label="Monto requerido"></cfif>
            <!--- por cada movimiento cuenta al Corte --->
            <cfloop query="rsMovCtasMontoPago">
                <cfset _monto = NumberFormat(lvarSaldoMonto,'9.99')>
                <cfif lvarSaldoMonto gte rsMovCtasMontoPago.PagoTotal>
                    <cfset _monto = rsMovCtasMontoPago.PagoTotal>
                </cfif>

                <cfset lvarDescuento = rsMovCtasMontoPago.Descuento>
                <cfset lvarPagado = rsMovCtasMontoPago.Pagado>
                <cfset lvarIntereses = rsMovCtasMontoPago.Intereses>

                <cfquery datasource="#this.dsn#">
                    update c
                        set c.Pagado -= #NumberFormat((lvarPagado*_monto)/PagoTotal,'9.99')#,
                            c.Descuento -= #NumberFormat((lvarDescuento*_monto)/PagoTotal,'9.99')#
                    from CRCMovimientoCuenta c 						
                    where c.id = #rsMovCtasMontoPago.id#
                </cfquery>
                
                <cfif lvarPagado lte lvarIntereses>
                    <cfif rsMovCtasMontoPago.TipoTransaccion eq 'GC'>
                        <cfset strPagos.GastoCobranza += _monto>
                    <cfelse>
                        <cfset strPagos.Intereses += _monto>
                    </cfif>
                <cfelse>
                    <cfif rsMovCtasMontoPago.TipoTransaccion eq 'GC'>
                        <cfset strPagos.GastoCobranza += _monto - lvarIntereses>
                    <cfelse>
                        <cfset strPagos.Ventas += _monto - NumberFormat((lvarDescuento*_monto)/PagoTotal,'9.99') - lvarIntereses>
                    </cfif>
                    <cfset strPagos.Intereses += lvarIntereses>
                </cfif>
                <cfset strPagos.Descuento += NumberFormat((lvarDescuento*_monto)/PagoTotal)>
                <cfset lvarSaldoMonto = NumberFormat(lvarSaldoMonto - _monto,'9.99')>

                <cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>

        <cfif NumberFormat(lvarSaldoMonto,'9.99') gt 0 >
        <!--- 6. Se Revierten pagos del corte anterior --->
            <cfset porDesc = 0>
            <cfif trim(rsCuenta.Tipo) eq "#this.C_TP_DISTRIBUIDOR#" and rsOrdenEstatusAct.Orden lt rsOrdenEstatusParam.Orden>
                <cfquery name="q_codCortePago" datasource="#this.dsn#">
                    select top 1 *
                    from CRCCortes ct
                    where #arguments.FechaPago# between FechaInicio and dateadd(day, 1, FechaFin)
                        and Tipo = 'D'
                </cfquery>
                <cfset porDesc = cCuenta.getPorcientoDescuento(arguments.FechaPago,rsCuenta.CRCCategoriaDistid,"#q_codCortePago.codigo#")>
            </cfif>
            <!--- se obtienen los Movimientos de Cuentas correspondientes al corte a Pagar que tengan saldo pendiente --->
            <cfquery name="rsMovCtasMontoPago" datasource="#this.dsn#">
                select  c.Corte,t.CRCCuentasid, t.id TransaccionId, t.FechaInicioPago, t.TipoTransaccion,
                        c.id, c.Pagado, c.Descuento, c.Pagado + c.Descuento PagoTotal,
                        c.Intereses, c.MontoRequerido, c.MontoAPagar
                from CRCMovimientoCuenta c 
                inner join CRCTransaccion t on t.id = c.CRCTransaccionid
                where c.Corte <= '#This.cortesActual#'
                and t.CRCCuentasid = #arguments.CuentaID#
                and c.Pagado + c.Descuento < c.MontoAPagar
                order by c.Corte desc, t.TipoTransaccion desc, t.FechaInicioPago desc, c.id desc
            </cfquery>
            
            <cfif arguments.debug><cfdump var="#lvarSaldoMonto#"><cfdump var='#strPagos#'><cfdump var='#rsMovCtasMontoPago#' abort='false' label="Monto Saldo Vencido"></cfif>
            <!--- por cada movimiento cuenta al Corte --->
            <cfloop query="rsMovCtasMontoPago">
                <cfset _monto = NumberFormat(lvarSaldoMonto,'9.99')>
                <cfif lvarSaldoMonto gte rsMovCtasMontoPago.Pagado>
                    <cfset _monto = rsMovCtasMontoPago.Pagado>
                </cfif>

                <cfset lvarPagado = rsMovCtasMontoPago.Pagado>
                <cfset lvarIntereses = rsMovCtasMontoPago.Intereses>

                <cfquery datasource="#this.dsn#">
                    update c
                        set c.Pagado -= #NumberFormat(_monto,'9.99')#
                    from CRCMovimientoCuenta c 						
                    where c.id = #rsMovCtasMontoPago.id#
                </cfquery>
                
                <cfif lvarPagado lte lvarIntereses>
                    <cfif rsMovCtasMontoPago.TipoTransaccion eq 'GC'>
                        <cfset strPagos.GastoCobranza += _monto>
                    <cfelse>
                        <cfset strPagos.Intereses += _monto>
                    </cfif>
                <cfelse>
                    <cfif rsMovCtasMontoPago.TipoTransaccion eq 'GC'>
                        <cfset strPagos.GastoCobranza += _monto - lvarIntereses>
                    <cfelse>
                        <cfset strPagos.Ventas += _monto - lvarIntereses>
                    </cfif>
                    <cfset strPagos.Intereses += lvarIntereses>
                </cfif>
                <cfset lvarSaldoMonto = NumberFormat(lvarSaldoMonto - _monto,'9.99')>

                <cfif NumberFormat(lvarSaldoMonto,'9.99') lte 0 >
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>

        <cfif arguments.debug><cfdump var='#NumberFormat(lvarSaldoMonto,'9.99')#' abort='false' label="Saldo">	 </cfif>

        <!--- Verificacion del monto de descuento --->
        <cfif rsTransaccion.DTdeslinea neq strPagos.descuento>
            <cfset strPagos.descuento = rsTransaccion.DTdeslinea>
        </cfif>

        <cfif arguments.debug><cfdump var='#strPagos#' abort='true'></cfif>
        
        <cfset Create_CRCDESGLOSE()>

        <cfquery datasource="#this.dsn#">
			insert into #request.crcdesglose#
				(CUENTAID,DESCUENTO,GASTOCOBRANZA,INTERESES,SEGURO,VENTAS,AFAVOR)
			values(
				#arguments.CuentaID#,
				round(cast(#NumberFormat(strPagos.Descuento,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.GastoCobranza,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Intereses + strPagos.InteresesVencidos,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Seguro,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Ventas - strPagos.Descuento,'9.0000')# as money),2),
				round(cast(#NumberFormat(strPagos.Afavor,'9.0000')# as money),2)
			)
		</cfquery>

    </cffunction>

    <cffunction  name="Create_CRCDESGLOSE">
		<cf_dbtemp name="CRC_DESGLOSE" returnvariable="CRC_DESGLOSE" datasource="#this.dsn#">
			<cf_dbtempcol name="CUENTAID"       type="numeric"      mandatory="yes">
			<cf_dbtempcol name="DESCUENTO"      type="money"        mandatory="yes">
			<cf_dbtempcol name="GASTOCOBRANZA"  type="money"        mandatory="yes">
			<cf_dbtempcol name="INTERESES"     type="money"        mandatory="yes">
			<cf_dbtempcol name="SEGURO"         type="money"        mandatory="yes">
			<cf_dbtempcol name="VENTAS"         type="money"        mandatory="yes">
			<cf_dbtempcol name="AFAVOR"         type="money"        mandatory="yes">
			<cf_dbtempkey cols="CUENTAID">
		</cf_dbtemp>

		<cfset request.crcdesglose = CRC_DESGLOSE>
	</cffunction>

</cfcomponent>