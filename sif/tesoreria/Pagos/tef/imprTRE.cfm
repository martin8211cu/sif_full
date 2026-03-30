<cfset GvarTEF = structNew()>
<cfset GvarTEF.TEF			= "TRE">
<cfset GvarTEF.TESTMPtipo	= "3">
<cfset GvarTEF.Proceso		= "Emisión de Órdenes de Pago - Generación de Transferencias Electrónicas">
<cfset GvarTEF.Lote			= "Lote de Generación de Transferencias Electrónicas">
<cfset GvarTEF.Accion		= "Generación">
<cfset GvarTEF.Accion2		= "Generar">
<cf_dbfunction name="OP_concat" returnvariable="_cat">
<cfif isdefined("url.TESTLid") and not isdefined('form.TESTLid')>
	<cfset form.TESTLid = url.TESTLid>
</cfif>
<cfquery datasource="#session.dsn#" name="rsForm">
    select	TESTLid, tl.CBid, Edescripcion as empPago, Bdescripcion as bcoPago, Mnombre as monPago, Miso4217, CBcodigo, tl.TESMPcodigo, TESMPdescripcion, TESTLfecha,
    	   	case TESTLestado when 0 then '<strong>En preparacion</strong>' when 1 then '<strong>En #GvarTEF.Accion#</strong>' when 2 then '<strong>No Emitido</strong>' when 3 then '<strong>Emitido</strong>' end as Estado,
           	tl.TESTMPtipo, mp.TESTMPtipo, mp.TESTGid, (case when mp.TESTGid is null then fi.FMT01DES else tg.TESTGdescripcion end) as Formato, mp.TESTGtipoConfirma,
           	case mp.TESTGcodigoTipo 
            	when 0 then
                    case mp.TESTGtipoCtas
                        when 0 then 'Cuentas Nacionales: Cualquier cuenta de cualquier Banco'
                        when 1 then 'Cuentas Nacionales: Sólo Cuentas Propias del Mismo Banco de Pago'
                        when 2 then 'Cuentas Nacionales: Sólo Cuentas Interbancarias de otros Bancos'
                        when 3 then 'Cuentas Nacionales: Sólo Cuentas Interbancarias de cualquier Banco'
                        when 4 then 'Cuentas Nacionales: Ctas propias del mismo Bco e Interbancarias de otros'
                    end
                when 1 then 'Cuentas ABA'
                when 2 then 'Cuentas SWIFT'
                when 3 then 'Cuentas IBAN'
                else 'Otro tipo de cuenta'
            end as tipoCuenta,
            case mp.TESTGtipoConfirma
                when 1 then 'Una única confirmación por Lote'
                when 2 then 'Una confirmación por Orden de Pago'
            end as tipoConfirma,
            coalesce (fm.FMT01DES, '(No enviar eMail al Beneficiario)') as FormatoEmail, mp.FMT01COD, fi.FMT01tipfmt, fi.FMT01TXT, fm.FMT01TXT as FMT01TXTemail, tl.TESTLestado,
            TESTLreferencia, TESTLreferenciaComision, TESTLtotalDebitado, TESTLtotalComision, TESTLcantidad, TESTLdatos, TESTLmsg
    from TEStransferenciasL tl
        inner join TEScuentasBancos tcb
            inner join CuentasBancos cb
                inner join Monedas m
                     on m.Mcodigo 	= cb.Mcodigo
                    and m.Ecodigo  	= cb.Ecodigo
                inner join Bancos b
                     on b.Ecodigo 	= cb.Ecodigo
                    and b.Bid  		= cb.Bid
                inner join Empresas e
                    on e.Ecodigo	= cb.Ecodigo
                 on cb.CBid=tcb.CBid
             on tcb.TESid	= tl.TESid
            and tcb.CBid	= tl.CBid
            and tcb.TESCBactiva = 1
        inner join TESmedioPago mp
            <!--- Formato Generación TEF --->
            left join TEStransferenciaG tg 
                on tg.TESTGid = mp.TESTGid
            <!--- Formato Impresion TEF --->
            left join FMT001 fi
                on fi.FMT01COD = mp.FMT01COD
            <!--- Formato Impresion eMail --->
            left join FMT001 fm
                on fm.FMT01COD = mp.FMT01CODemail
             on mp.TESid		= tl.TESid
            and mp.CBid			= tl.CBid
            and mp.TESMPcodigo 	= tl.TESMPcodigo
    where tl.TESid = #session.Tesoreria.TESid#	
      and cb.CBesTCE = 0	
      and TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">		
</cfquery>
<cfif rsForm.TESTMPtipo NEQ #GvarTEF.TESTMPtipo#> <!--- Verifica Tipo de Lote --->
    <cfthrow message="Se esta tratando de Procesar un Lote que no es un #GvarTEF.Lote#">
</cfif>

<cfquery datasource="#session.dsn#" name="rsOPs">
    select count(1) as cantidad, sum(round(op.TESOPtotalPago,2)) as total, count(distinct TESTDreferencia) as conReferencia
      from TESordenPago op
        left join TEStransferenciasD td
             on td.TESid 	= op.TESid
            and td.TESOPid 	= op.TESOPid
            and td.TESTLid	= op.TESTLid
            and td.TESTDestado <> 3
     where op.TESid		= #session.Tesoreria.TESid#
       and op.CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
       and op.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
       and op.TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESTLid#">	
</cfquery>
<cfoutput>
<style type="text/css">
	<!--
	.style1 {
		font-size: 16px;
		font-weight: bold;
		text-align:center;
	}
	-->
</style>
<cf_templatecss>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="style1" colspan="6">#GvarTEF.Lote#</td>
    <tr><td colspan="6">&nbsp;</td>
    <tr>
        <td valign="top" nowrap>Numero Lote:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.TESTLid#</strong></td>
        <td valign="top" nowrap>Cuenta Bancaria de Pago:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.CBcodigo#</strong></td>
    </tr>		  
    <tr>
    	<td valign="top" nowrap>Estado del Lote:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.Estado#</strong></td>
        <td valign="top" nowrap>Moneda de Pago:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.monPago#</strong></td>
	</tr>		  
    <tr>
        <td valign="top" nowrap>Empresa de Pago:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.empPago#</strong></td>
        <td valign="top" nowrap>Medio de Pago:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.TESMPcodigo#</strong><br><strong>#rsForm.TESMPdescripcion#</strong></td>
    </tr>		  
    <tr>
        <td valign="top" nowrap>Banco de Pago:</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.bcoPago#</strong></td>
        <td valign="top" nowrap>Fecha de lote:</td>
        <td>&nbsp;</td>
        <td valign="top"><cfset fechaLote = LSDateFormat(rsForm.TESTLfecha,'dd/mm/yyyy')><strong>#fechaLote#</strong></td>
    </tr>
    <tr>
        <td valign="top" nowrap>Monto Total de OPs en Lote:&nbsp</td>
        <td>&nbsp;</td>
        <td valign="top"><strong>#rsForm.Miso4217#&nbsp;#NumberFormat(rsOPs.total,",9.99")#</strong></td>
        <td valign="top" nowrap></td>
        <td>&nbsp;</td>
        <td valign="top"></td>
    </tr>
    <cfquery name="rsOPNoProcesadas" datasource="#session.dsn#">
        select 	op.TESOPid, op.TESOPnumero, op.TESOPbeneficiario
                ,ip.TESTPbanco #_cat# ' - ' #_cat# ip.Miso4217 #_cat# ' - ' #_cat# ip.TESTPcodigo #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
                ,'<font color="##FF0000" style="font-weight:bolder">' #_cat#
                case
                    when mp.TESid <> tl.TESid OR mp.CBid <> tl.CBid OR mp.TESMPcodigo <> tl.TESMPcodigo then
                         <!--- Otro medio de pago --->
                        'Otro Medio de Pago: '  #_cat# rtrim(mp.TESMPcodigo)
                    when ip.Miso4217 <> op.Miso4217Pago then
                        <!--- No es Misma Moneda --->
                        'Cta.Destino de otra moneda'
                    when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
                        <!--- No es Mismo TESTGcodigoTipo --->
                        'Cta.Destino Tipo ' #_cat# 
                            case ip.TESTPcodigoTipo
                                when 0 then 'Nacional'
                                when 1 then 'ABA'
                                when 2 then 'SWIFT'
                                when 3 then 'IBAN'
                                else 'Especial'
                            end
                    when mp.TESTGcodigoTipo = 0 then
                        case
                            when ip.Bid is null then
                                <!--- No hay banco --->
                                'Cta.Destino sin Banco'
                            when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
                                'Cta.Destino propia de otro banco'
                            when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
                                'Cta.Destino no es propia del banco de pago'
                            when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0) then
                                'Cta.Destino no es interbancaria'
                            when mp.TESTGtipoCtas = 2 and NOT (ip.Bid <> cb.Bid) then
                                'Cta.Destino no es de otros bancos'
                            when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
                                'Cta.Destino no es interbancaria'
                            when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 1 and ip.Bid <> cb.Bid) then
                                'Cuenta Destino es propia de otro banco'
                            when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 0 and ip.Bid = cb.Bid) then
                                'Cuenta Destino no es propia del banco de pago'
                        end
                end #_cat# '</font>' as error
          from TESordenPago op 
            inner join TEStransferenciasL tl on tl.TESTLid = op.TESTLid 
            left join TEStransferenciaP ip on ip.TESTPid = op.TESTPid 
            inner join TESmedioPago mp 
                inner join CuentasBancos cb on cb.CBid = mp.CBid 
            on mp.TESid = op.TESid and mp.CBid = op.CBidPago and mp.TESMPcodigo = op.TESMPcodigo 
         where op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
           and cb.CBesTCE = 0			
           and op.TESid = #session.Tesoreria.TESid#
           and 
                case
                    when mp.TESid <> tl.TESid OR mp.CBid <> tl.CBid OR mp.TESMPcodigo <> tl.TESMPcodigo then
                        <!--- Otro medio de pago --->
                        1
                    when ip.Miso4217 <> op.Miso4217Pago then
                        <!--- No es Misma Moneda --->
                        2
                    when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
                        <!--- No es Mismo TESTGcodigoTipo --->
                        3
                    when mp.TESTGcodigoTipo = 0 then
                        case
                            when ip.Bid is null then
                                4
                            when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
                                5
                            when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
                                6
                            when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0) then
                                7
                            when mp.TESTGtipoCtas = 2 and NOT (ip.Bid <> cb.Bid) then
                                8
                            when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
                                9
                            when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 1 and ip.Bid <> cb.Bid) then
                                10
                            when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 0 and ip.Bid = cb.Bid) then
                                11
                        end
                end > 0 
        order by op.TESOPnumero
    </cfquery>
	<cfif rsOPNoProcesadas.recordCount NEQ 0>
        <tr><td align="center" colspan="6"><strong><font color="##FF0000">Ordenes de Pago que no pueden ser procesadas en el Lote</font></strong></td></tr>
        <tr><td colspan="6">&nbsp;</td></tr>  
        <tr><td colspan="6" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsOPNoProcesadas">
                	<tr>
                        <td class="tituloListas" align="center"><strong>N° Orden</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Cta.Destino</strong></td>
                        <td class="tituloListas" align="center"><strong>Inconsistencia</strong></td>
                    </tr>
                	<tr class="<cfif rsOPNoProcesadas.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsOPNoProcesadas.TESOPnumero#</td>
                        <td>#rsOPNoProcesadas.TESOPbeneficiario#</td>
                        <td>#rsOPNoProcesadas.ctaD#</td>
                        <td align="right">#rsOPNoProcesadas.error#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="3"><cfset sbPoneDetalle(rsOPNoProcesadas.TESOPid)></td></tr>
                </cfloop>
            </table>	
        </td></tr>
        </table>
        <cfabort>
    </cfif>
    <cf_dbfunction name="to_char" args="op.TESOPid" returnvariable= "LvarTESOPid">
    <cfif isdefined("url.btnSeleccionarOP")>
        <cfquery name="rsOPSinLote" datasource="#session.dsn#">
            SELECT 
                case
                    when ip.Miso4217 <> op.Miso4217Pago then
                        <!--- No es Misma Moneda --->
                        'Diferente moneda'
                    when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
                        <!--- No es Mismo TESTGcodigoTipo --->
                        'Diferente tipo de Cuenta'
                    when mp.TESTGcodigoTipo <> 0 then
                        ''
                    when mp.TESTGcodigoTipo = 0 then
                        case
                            when ip.Bid is null then
                                <!--- No hay banco --->
                                'Falta asignar Banco'
                            when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
                                'Cuenta Propia de Otro Banco'
                            when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
                                'Sólo Cuentas Propias del mismo Banco'
                            when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0 and ip.Bid <> cb.Bid) then
                                'Sólo Cuentas de otros Bancos'
                            when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
                                'Sólo Cuentas Interbancarias'
                            when mp.TESTGtipoCtas = 4 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0 and ip.Bid <> cb.Bid) then
                                'Sólo Cuentas propias del mismo banco o Interbancarias de otros bancos'
                            else
                                ''
                        end
                end as Error,
                op.TESOPid, op.TESOPnumero, op.TESOPbeneficiario, op.Miso4217Pago, op.TESOPtotalPago
                ,ip.TESTPbanco #_cat# ': ' #_cat# ip.TESTPcuenta #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
             FROM TESordenPago op
                inner join TESmedioPago mp
                    inner join CuentasBancos cb
                        on cb.CBid = mp.CBid
                     on mp.TESid		= op.TESid
                    and mp.CBid			= op.CBidPago
                    and mp.TESMPcodigo 	= op.TESMPcodigo
                inner join TEStransferenciaP ip
                     on ip.TESTPid	= op.TESTPid
             where op.TESid			= #session.Tesoreria.TESid#
               and cb.CBesTCE = 0		
               and op.CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
               and op.TESCFLid		IS null
               and op.TESTLid		IS null
               and op.TESOPestado	= 11
               and op.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
            order by TESOPnumero
        </cfquery>
        <tr>
            <td align="center" colspan="6">
                <strong>Lista de Ordenes de Pago enviadas a Emisión sin Lote de #GvarTEF.Accion# Asignadas</strong>
                <cfset key = 'TESOPid'>
            </td>
        </tr>  
        <tr><td colspan="6">&nbsp;</td></tr>  
        <tr><td colspan="6" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsOPSinLote">
                	<tr>
                        <td class="tituloListas" align="center"><strong>N° Orden</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Cta.Destino</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>Pago</strong></td>
                        <td class="tituloListas" align="center"><strong>Inconsistencia</strong></td>
                    </tr>
                	<tr class="<cfif rsOPSinLote.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsOPSinLote.TESOPnumero#</td>
                        <td>#rsOPSinLote.TESOPbeneficiario#</td>
                        <td>#rsOPSinLote.ctaD#</td>
                        <td align="right">#rsOPSinLote.Miso4217Pago# #NumberFormat(rsOPSinLote.TESOPtotalPago,",9.99")#</td>
                        <td align="center">#rsOPSinLote.Error#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="4"><cfset sbPoneDetalle(rsOPSinLote.TESOPid)></td></tr>
                </cfloop>
            </table>		
        </td></tr>
	<cfelseif rsForm.TESTLestado EQ "0">
		<!--- EN PREPARACION --->
        <cfquery name="rsOrden" datasource="#session.dsn#">
            SELECT  op.TESOPid, TESOPnumero, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago, ip.TESTPbanco #_cat# ': ' #_cat# ip.TESTPcuenta #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
             FROM TESordenPago op
                inner join TEStransferenciaP ip
                     on ip.TESTPid	= op.TESTPid
            where op.TESid	   = #session.Tesoreria.TESid#	
              and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
            order by op.TESOPnumero
        </cfquery>
        <tr><td colspan="6">&nbsp;</td></tr>  
        <tr><td colspan="6" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsOrden">
                	<tr>
                        <td class="tituloListas" align="center"><strong>N° Orden</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Cta.Destino</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>#replace(rsForm.monPago,",","")#</strong></td>
                    </tr>
                	<tr class="<cfif rsOrden.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsOrden.TESOPnumero#</td>
                        <td>#rsOrden.TESOPbeneficiario#</td>
                        <td>#rsOrden.ctaD#</td>
                        <td align="right">#rsOrden.Miso4217Pago# #NumberFormat(rsOrden.TESOPtotalPago,",9.99")#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="3"><cfset sbPoneDetalle(rsOrden.TESOPid)></td></tr>
                </cfloop>
            </table>		
        </td></tr>
	<cfelseif rsForm.TESTLestado EQ "1">
        <!--- EN IMPRESION/GENERACION: N/A --->
    <cfelse>
        <tr><td colspan="6">&nbsp;</td></tr>  
        <!--- Se comenta a peticion de chantal para que no salga el msj
		<cfif rsForm.TESTLestado EQ "2">
        	<tr><td colspan="6" align="center">
            <cfif rsForm.TESTLmsg EQ "OK">
                <strong><font color="##0000FF">El Resultado en el Banco corresponde con los datos registrados: Se puede emitir los Pagos.</font></strong>
                </td></tr>
            <cfelseif trim(rsForm.TESTLmsg) EQ "">
                <strong><font color="##0000FF">Debe registrar y verificar el Resultado de las Transferencias en el Banco</font></strong>
                </td></tr>
            <cfelse>
                <strong><font color="##FF0000">#rsForm.TESTLmsg#</font></strong>
                </td></tr>
            </cfif>
		</cfif>--->
        <cfquery name="rsOrden" datasource="#session.dsn#">
            SELECT op.TESOPid, op.TESOPnumero, op.TESOPbeneficiario, op.Miso4217Pago, op.TESOPtotalPago,
                td.TESTDreferencia ,ip.TESTPbanco #_cat# ': ' #_cat# ip.TESTPcuenta #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
             FROM TESordenPago op
                inner join TEStransferenciaP ip
                     on ip.TESTPid	= op.TESTPid
                inner join TEStransferenciasD td
                     on td.TESid 	= op.TESid
                    and td.TESOPid 	= op.TESOPid
                    and td.TESTLid	= op.TESTLid
            where op.TESid	   = #session.Tesoreria.TESid#	
              and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
            order by op.TESOPnumero
        </cfquery>
        <tr><td colspan="6">&nbsp;</td></tr>  
        <tr><td colspan="6" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsOrden">
                	<tr>
                        <td class="tituloListas" align="center"><strong>N° Orden</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Cta.Destino</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>#replace(rsForm.monPago,",","")#</strong></td>
                        <td class="tituloListas" align="center"><strong>No.Referencia</strong></td>
                    </tr>
                	<tr class="<cfif rsOrden.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsOrden.TESOPnumero#</td>
                        <td>#rsOrden.TESOPbeneficiario#</td>
                        <td>#rsOrden.ctaD#</td>
                        <td align="right">#rsOrden.Miso4217Pago# #NumberFormat(rsOrden.TESOPtotalPago,",9.99")#</td>
                        <td>#rsOrden.TESTDreferencia#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="3"><cfset sbPoneDetalle(rsOrden.TESOPid)></td></tr>
                </cfloop>
            </table>
        </td></tr>
 	</cfif>
</table>
</cfoutput>

<cffunction name="sbPoneDetalle" output="true" returntype="void">
	<cfargument name="TESOPid" type="numeric" required="yes">
    
	<cfquery datasource="#session.dsn#" name="rsSolicitudes">
		select 
			sp.TESOPid,
			sp.TESSPid,
			dp.TESDPid,
			op.CBidPago,
			mp.Mnombre, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago,
			sp.TESSPnumero,
			sp.TESSPfechaPagar,
			e.Edescripcion,
			dp.TESDPmoduloOri,
			dp.TESDPdocumentoOri, 
			dp.TESDPreferenciaOri,
			dp.Miso4217Ori,
			dp.TESDPmontoAprobadoOri,
			case when coalesce(op.TESOPtipoCambioPago, 0) 	= 0 then 1 else op.TESOPtipoCambioPago 		end as TESOPtipoCambioPago,
			case when coalesce(dp.TESDPtipoCambioOri, 0) 	= 0 then 1 else dp.TESDPtipoCambioOri 		end as TESDPtipoCambioOri,
			case when coalesce(dp.TESDPfactorConversion, 0) = 0	then 1 else dp.TESDPfactorConversion	end as TESDPfactorConversion,
			coalesce(dp.TESDPmontoPago, 0) as TESDPmontoPago,
			case sp.TESSPtipoDocumento
				when 0 		then 'Manual'
				when 5 		then 'ManualCF' 
				when 1 		then 'CxP' 
				when 2 		then 'Antic.CxP' 
				when 3 		then 'Antic.CxC' 
				when 4 		then 'Antic.POS' 
				when 6 		then 'Antic.GE' 
				when 7 		then 'Liqui.GE' 
				when 8		then 'Fondo.CCh' 
				when 9 		then 'Reint.CCh' 
				when 10		then 'TEF Bcos' 
				when 100 	then 'Interfaz' 
				else 'Otro'
			end as TIPO,
			dp.TESDPmontoPagoLocal,
			cpc.CPCid, cpc.TESDPmontoSolicitadoOri as CPCoriginal, cpc.CPClocal
		from TESordenPago op
			left join TESdetallePago dp
				inner join Empresas e
				  on e.Ecodigo = dp.EcodigoOri
				inner join Monedas me
					 on me.Miso4217	= dp.Miso4217Ori
					and me.Ecodigo	= dp.EcodigoOri
				inner join Monedas m
					 on m.Miso4217	= dp.Miso4217Ori
					and m.Ecodigo	= dp.EcodigoOri
				inner join TESsolicitudPago sp
				  on sp.TESid 	= dp.TESid
				 and sp.TESSPid = dp.TESSPid
				inner join CFinanciera cf
					 on cf.Ecodigo  = dp.EcodigoOri
					and cf.CFcuenta = dp.CFcuentaDB
			  on dp.TESid 	= op.TESid
			 and dp.TESOPid = op.TESOPid
			left join TESdetallePagoCPC cpc
				inner join CPCesion c on c.CPCid = cpc.CPCid
				inner join Monedas mc on mc.Mcodigo = c.Mcodigo
			   on TESDPidNew		= dp.TESDPid
			  and mc.Miso4217		<> dp.Miso4217Ori
			  and me.Miso4217		in (dp.Miso4217Ori,mc.Miso4217)
			  and op.Miso4217Pago	in (dp.Miso4217Ori,mc.Miso4217)
			left join Empresas ep
				inner join Monedas mep
				   on mep.Mcodigo = ep.Mcodigo
				  and mep.Ecodigo = ep.Ecodigo
			  on ep.Ecodigo = op.EcodigoPago
			left join Monedas mp
			  on mp.Miso4217	= op.Miso4217Pago
			 and mp.Ecodigo		= op.EcodigoPago
		where op.TESid = #session.tesoreria.TESid#
		  and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESOPid#">
		  and op.TESOPestado in (10,11)
	</cfquery>	
    <cfif rsSolicitudes..recordcount EQ 0>
    	<cfreturn>
    </cfif>
	<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td class="tituloListas" align="left"><strong>Num.<BR>Solicitud</strong></td>
			<td class="tituloListas" align="left"><strong>Origen</strong></td>
			<td class="tituloListas" align="left"><strong>Documento</strong></td>
			<td class="tituloListas" align="right"><strong>Monto<BR>Documento</strong></td>
			<td class="tituloListas" align="center"><strong>Tipo&nbsp;Cambio<BR>Documento</strong></td>
			<td class="tituloListas" align="center"><strong>Factor<BR>Conversion</strong></td>
			<td class="tituloListas" align="right"><strong>Monto Pago<cfif rsSolicitudes.CBidPago NEQ ""><BR><cfoutput>#rsSolicitudes.Mnombre#<BR>(#rsSolicitudes.Miso4217Pago#)</cfoutput></cfif></strong></td>
		</tr>
		<cfset LvarTotalSP = 0>
		<cfset LvarLista = "ListaPar">
		<cfset LvarSolicitud = "">
		<cfloop query="rsSolicitudes">
			<cfset LvarTotalSP = LvarTotalSP + TESDPmontoPago>
			<cfif LvarLista NEQ "ListaPar">
				<cfset LvarLista = "ListaPar">
			<cfelse>
				<cfset LvarLista = "ListaNon">
			</cfif>
			<cfif LvarSolicitud NEQ rsSolicitudes.TESSPid>
				<cfset LvarSolicitud = rsSolicitudes.TESSPid>
				<tr class="#LvarLista#">
					<td align="left" nowrap>
						#TESSPnumero#
					</td>
					<td align="center" nowrap>
						#TIPO#
					</td>
                    <td align="center" nowrap colspan="5"></td>
					<cfif LvarLista NEQ "ListaPar">
						<cfset LvarLista = "ListaPar">
					<cfelse>
						<cfset LvarLista = "ListaNon">
					</cfif>
				</tr>
			</cfif>
			<tr class="#LvarLista#">
				<td>&nbsp;</td>
				<td align="center" nowrap>
					#TESDPmoduloOri#
				</td>
				<td align="left" nowrap>
					#TESDPdocumentoOri#
				</td>
                <td align="right" nowrap>
					<input name="TESDPmontoAprobadoOri_#TESDPid#" id="TESDPmontoAprobadoOri_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Ori#
				</td>
				<td align="right" nowrap>
					<cfif CBidPago EQ "">
                        <cfset LvarTC = 0>
                        <cfset LvarFC = 0>
                        <cfset LvarMP = 0>
                    <cfelseif CPCid NEQ "">
                        <cfset LvarTC = TESDPtipoCambioOri>
                        <cfset LvarFC = TESDPfactorConversion>
                        <cfset LvarMP = TESDPmontoAprobadoOri>
                    <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                        <cfset LvarTC = 1>
                        <cfset LvarFC = 1/TESOPtipoCambioPago>
                        <cfset LvarMP = TESDPmontoAprobadoOri/TESOPtipoCambioPago>
                    <cfelseif Miso4217Ori EQ Miso4217Pago>
                        <cfset LvarTC = TESOPtipoCambioPago>
                        <cfset LvarFC = 1>
                        <cfset LvarMP = TESDPmontoAprobadoOri>
                    <cfelseif Miso4217Pago EQ Miso4217EmpresaPago>
                        <cfset LvarTC = TESOPtipoCambioPago>
                        <cfset LvarFC = TESDPfactorConversion>
                        <cfset LvarMP = TESDPmontoPago>
                    <cfelse>
                        <cfset LvarTC = TESOPtipoCambioPago>
                        <cfset LvarFC = TESDPfactorConversion>
                        <cfset LvarMP = TESDPmontoPago>
                    </cfif>
                    <cfif CBidPago EQ "">
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="0"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; display:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > 
                    <cfelseif CPCid NEQ "">
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; border:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > #Miso4217EmpresaPago#s/#Miso4217Ori#
                    <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="1.0000"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; display:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > n/a
                    <cfelseif Miso4217Ori EQ Miso4217Pago>
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="#NumberFormat(TESOPtipoCambioPago,",0.0000")#"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; border:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > #Miso4217EmpresaPago#s/#Miso4217Ori#
                    <cfelse>
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
                                size="8"
                                style="text-align:right;"
                                onFocus="this.value=qf(this); this.select(); LvarValueOri = this.value;" 
                                onBlur="if (LvarValueOri != this.value) {sbCambioTC(this); GvarCambiado = true;} fm(this,4);" 
                                onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                            > #Miso4217EmpresaPago#s/#Miso4217Ori#
                    </cfif>
				</td>
				<td align="right" nowrap>
					<cfif CBidPago EQ "">
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; display:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                    <cfelseif CPCid NEQ "">
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(1/TESOPtipoCambioPago,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    <cfelseif Miso4217Ori EQ Miso4217Pago>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#1.0000#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px; display:none;"
                            readonly="yes"
                            tabindex="-1"
                        > n/a
                    <cfelseif Miso4217Pago EQ Miso4217EmpresaPago>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    <cfelse>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            style="text-align:right;"
                            onFocus="this.value=qf(this); this.select();" 
                            onChange="javascript: sbCambioFC(this); fm(this,4); GvarCambiado = true;" 
                            onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    </cfif>
             	</td>
				<cfif CBidPago EQ "">
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="0.00"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelseif CPCid NEQ "">
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoAprobadoOri/TESOPtipoCambioPago,",0.00")#"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelseif Miso4217Ori EQ Miso4217Pago>
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelse>
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoPago,",0.00")#"
                            size="17"
                            style="text-align:right;"
                            onFocus="this.value=qf(this); this.select();" 
                            onBlur="javascript: sbCambioMonto(this); fm(this,2);" 
                            onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                            onChange="GvarCambiado = true;"
                        >
                        #Miso4217Pago#
                    </td>
                </cfif>
			</tr>
		</cfloop>
	</table>


</cffunction>
