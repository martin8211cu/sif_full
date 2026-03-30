<cf_templatecss>
    <cf_htmlReportsHeaders 
    irA="GEreportesMovimientos.cfm"
    FileName="Movimientos_Gestion_Empleados.xls"
    title="Consulta"
    >

<style type="text/css">
	.RLTtopline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color:#000000;
		border-top-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;		  
	} 
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
		font-size:11px;
		background-color:#F5F5F5;
	}
	.csssolicitante {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
		font-size:11px;
		background-color:#FAFAFA;
	}
	.item {
		font-size:10px;
	}
	.letra {
		font-size:10px;
		padding-bottom:5px;
	}
	.letra2 {
		font-size:11px;
		font-weight:bold;
	}
	.letra3 {
		font-size:15px;
		font-weight:bold;
	}
</style>
<cfif isdefined("form.DEid") and len(trim(form.DEid))>
    <cfquery datasource="#session.DSN#" name="rsDatosEmpleado">
        select 
                coalesce(TESBid,0) as TESBid,
                TESBeneficiario,
                TESBeneficiarioId
        from TESbeneficiario
        where  DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    </cfquery>
    <cfif rsDatosEmpleado.recordcount lte 0>
    	<cf_errorCode	code = "51703" msg = "El Empleado no tiene ningun Tramite">
    </cfif>
</cfif>

<cfset AMes = ArrayNew(1)>
<cfset ArrayAppend(AMes, "Enero")>
<cfset ArrayAppend(AMes, "Febrero")>
<cfset ArrayAppend(AMes, "Marzo")>
<cfset ArrayAppend(AMes, "Abril")>
<cfset ArrayAppend(AMes, "Mayo")>
<cfset ArrayAppend(AMes, "Junio")>
<cfset ArrayAppend(AMes, "Julio")>
<cfset ArrayAppend(AMes, "Agosto")>
<cfset ArrayAppend(AMes, "Septiembre")>
<cfset ArrayAppend(AMes, "Octubre")>
<cfset ArrayAppend(AMes, "Noviembre")>
<cfset ArrayAppend(AMes, "Diciembre")>

<cf_dbfunction name="date_part" args="mm,sp.TESOPfechaPago" returnVariable="LvarMesD">
<cf_dbfunction name="date_part" args="yyyy,sp.TESOPfechaPago" returnVariable="LvarPeriodoD">

<cf_dbfunction name="date_part" args="mm,c.GELfecha"   returnVariable="LvarMesH">
<cf_dbfunction name="date_part" args="yyyy,c.GELfecha" returnVariable="LvarPeriodoH">

<cfif AFTRtipo eq -1 or AFTRtipo eq 1>
    <cfquery name="rsAnticipos" datasource="#session.dsn#">
        select 
            a.GEAid,
            a.GEAnumero,
            a.GEAtotalOri,
            a.GEAdescripcion,
            a.Ecodigo,
            case a.GEAestado
            when  0 then 'En Preparaci&oacute;n'
            when  1 then 'En Aprobaci&oacute;n'
            when  2 then 'Aprobada'
            when  3 then 'Rechazada'
            when  4 then 'Pagada'
            when  5 then 'Liquidada'
            when  6 then 'Terminada' 
            else 'Estado desconocido'
            end as estado,
            b.TESBeneficiario,
            a.TESSPid,
            sp.TESSPid,
            sp.TESSPnumero,
            case sp.TESSPestado
            when 0 then 'En Preparaci&oacute;n SP'
            when 1 then 'En Aprobaci&oacute;n SP'
            when 2 then 'SP Aprobada'
            when 3 then 'SP Rechazada'
            when 23 then 'Rechazada en Tesoreria'
            when 10 then 'En Preparaci&oacute;n OP'
            when 101 then 'En Aprobaci&oacute;n OP'
            when 103 then 'En OP rechazada'
            when 11 then 'En Emision OP'
            when 110 then 'En OP sin aplicar'
            when 12 then 'En OP pagada'
            when 13 then 'En OP anulada'
            end as EstadoSP,
            sp.TESOPid,
            op.TESOPnumero,
            case op.TESOPestado
            when 10 then 'En Preparaci&oacute;n OP'
            when 101 then 'En Aprobaci&oacute;n OP'
            when 103 then 'En OP rechazada'
            when 11 then 'En Emision OP'
            when 110 then 'En OP sin aplicar'
            when 12 then 'En OP pagada'
            when 13 then 'En OP anulada'
            end as EstadoOP,
            a.GEAfechaPagar,
            sp.TESOPfechaPago,
            coalesce(
                (select min(Edocumento) from DContables ec   where ec.Ddocumento  = <cf_dbfunction name="to_char" args="op.TESOPnumero">  and ec.Ecodigo  = a.Ecodigo),
                (select min(Edocumento) from HDContables hec where hec.Ddocumento = <cf_dbfunction name="to_char" args="op.TESOPnumero">  and hec.Ecodigo = a.Ecodigo),
                0
            ) as IDcontable
        from GEanticipo a
        inner join TESsolicitudPago sp
            on sp.TESSPid= a.TESSPid
        inner join TESordenPago op
            on op.TESOPid=sp.TESOPid
        inner join TESbeneficiario b
            on b.TESBid=a.TESBid
        where a.Ecodigo=#session.Ecodigo# 
        <cfif isdefined("rsDatosEmpleado") and rsDatosEmpleado.TESBid gt 0>
        	and a.TESBid = #rsDatosEmpleado.TESBid#
        </cfif>
        and a.GEAestado in (4,5,6)
        <cfif isdefined("form.periodoini") and len(trim(form.periodoini)) and isdefined("form.mesini") and len(trim(form.mesini)) and isdefined("form.periodofin") and len(trim(form.periodofin)) and isdefined("form.mesfin") and len(trim(form.mesfin))>
            and #preserveSingleQuotes(LvarMesD)# between #form.mesini# and #form.mesfin#
            and #preserveSingleQuotes(LvarPeriodoD)# between #form.periodoini# and #form.periodofin#
        <cfelseif isdefined("form.periodoini") and len(trim(form.periodoini)) and isdefined("form.mesini") and len(trim(form.mesini))>
            and #preserveSingleQuotes(LvarMesD)#     >= #form.mesini#
            and #preserveSingleQuotes(LvarPeriodoD)# >= #form.periodoini#
        <cfelseif isdefined("form.periodofin") and len(trim(form.periodofin)) and isdefined("form.mesfin") and len(trim(form.mesfin))>
            and #preserveSingleQuotes(LvarMesD)#     <= #form.mesfin#
            and #preserveSingleQuotes(LvarPeriodoD)# <= #form.periodofin#
        </cfif>
        and  a.GEAtipoP=1
        order by sp.TESOPfechaPago desc,a.GEAnumero desc
    </cfquery> 
</cfif>
<cfif AFTRtipo eq -1 or AFTRtipo eq 2>
    <cfquery name="rsLiqAprobadas" datasource="#session.dsn#">
        select 
            c.GELid,
            c.TESBid,
            c.GELdescripcion,
            c.Mcodigo,
            c.Ecodigo,
            c.GELreembolso,
            c.GELid,
            c.GELnumero,
            b.TESBeneficiario,
            c.GELfecha,
            c.GELnumero,
            c.TESSPid,
            coalesce(c.GELtotalGastos,0) as GELtotalGastos,
            coalesce(c.GELtotalAnticipos,0) as GELtotalAnticipos,
            coalesce(c.GELtotalDepositos,0) as GELtotalDepositos,
            case c.GELestado
                when 0 then 'Preparaci&oacute;n'
                when 1 then 'En Aprobaci&oacute;n'
                when 2 then 'Aprobada'
                when 3 then 'Rechazada'
                when 4 then 'Finalizada'
                when 5 then 'Por reintegrar'
            end as Titulo,
            m.Miso4217,
            case when coalesce(c.IDcontable,0) > 0 then 
                    coalesce(
                        (select Edocumento from EContables ec where ec.IDcontable  = c.IDcontable and ec.Ecodigo  = c.Ecodigo),
                        (select Edocumento from HEContables hec where hec.IDcontable = c.IDcontable and hec.Ecodigo  = c.Ecodigo),
                        0
                    )    
            else 
                    coalesce(
                        (select min(ec.Edocumento) from DContables ec   where ec.Ddocumento  = <cf_dbfunction name="to_char" args="c.GELnumero"> and ec.Dreferencia  = 'GE.Liquidacion' and ec.Ecodigo  = c.Ecodigo),
                        (select min(hec.Edocumento) from HDContables hec where hec.Ddocumento = <cf_dbfunction name="to_char" args="c.GELnumero"> and hec.Dreferencia = 'GE.Liquidacion' and hec.Ecodigo = c.Ecodigo),
                        0
                    ) 
            end as IDcontable
        from GEliquidacion c
        inner join TESbeneficiario b
            on c.TESBid=b.TESBid
        inner join Monedas m 
            on m.Mcodigo=c.Mcodigo
        where c.Ecodigo=#session.Ecodigo#
        <cfif isdefined("rsDatosEmpleado") and rsDatosEmpleado.TESBid gt 0>
        	and c.TESBid = #rsDatosEmpleado.TESBid#
        </cfif>
            and c.GELestado in (2,4) 				<!--- Aprobada, Finalizada --->
            and coalesce(c.CCHid,0)	 = 0   			<!--- Que no sea pagada por Caja Chica --->	
            and coalesce(c.TESSPid_Adicional,0) = 0 <!--- Que no genero SP --->	
        <cfif isdefined("form.periodoini") and len(trim(form.periodoini)) and isdefined("form.mesini") and len(trim(form.mesini)) and isdefined("form.periodofin") and len(trim(form.periodofin)) and isdefined("form.mesfin") and len(trim(form.mesfin))>
            and #preserveSingleQuotes(LvarMesH)# between #form.mesini# and #form.mesfin#
            and #preserveSingleQuotes(LvarPeriodoH)# between #form.periodoini# and #form.periodofin#
         <cfelseif isdefined("form.periodoini") and len(trim(form.periodoini)) and isdefined("form.mesini") and len(trim(form.mesini))>
            and #preserveSingleQuotes(LvarMesH)#     >= #form.mesini#
            and #preserveSingleQuotes(LvarPeriodoH)# >= #form.periodoini#
        <cfelseif isdefined("form.periodofin") and len(trim(form.periodofin)) and isdefined("form.mesfin") and len(trim(form.mesfin))>
            and #preserveSingleQuotes(LvarMesH)#     <= #form.mesfin#
            and #preserveSingleQuotes(LvarPeriodoH)# <= #form.periodofin#
        </cfif>
        order by  c.GELfecha desc, c.GELnumero desc
    </cfquery> 
    
    <cfquery name="rsLiqSPPagadas" datasource="#session.dsn#">
        select 
            c.GELid,
            c.TESBid,
            c.GELdescripcion,
            c.Mcodigo,
            c.Ecodigo,
            c.GELreembolso,
            c.GELid,
            c.GELnumero,
            b.TESBeneficiario,
            c.GELfecha,
            c.GELnumero,
            c.TESSPid,
            sp.TESSPid,
            sp.TESSPnumero,
            sp.TESOPfechaPago,
            case sp.TESSPestado
                when 12 then 'En OP pagada'
                else 'Sin OP'
            end as EstadoSP,
            sp.TESOPid,
            op.TESOPnumero,
            case op.TESOPestado
                when 12 then 'En OP pagada'
                else 'Sin OP'
            end as EstadoOP,
            coalesce(c.GELtotalGastos,0) as GELtotalGastos,
            coalesce(c.GELtotalAnticipos,0) as GELtotalAnticipos,
            coalesce(c.GELtotalDepositos,0) as GELtotalDepositos,
            case c.GELestado
                when 0 then 'Preparaci&oacute;n'
                when 1 then 'En Aprobaci&oacute;n'
                when 2 then 'Aprobada'
                when 3 then 'Rechazada'
                when 4 then 'Finalizada'
                when 5 then 'Por reintegrar'
            end as Titulo,
            m.Miso4217,
            case when coalesce(c.IDcontable,0) > 0 then 
                coalesce(
                    (select Edocumento from EContables ec   where ec.IDcontable  = c.IDcontable and ec.Ecodigo  = c.Ecodigo),
                    (select Edocumento from HEContables hec where hec.IDcontable = c.IDcontable and hec.Ecodigo  = c.Ecodigo),
                    0
                )    
            else 
                coalesce(
                    (select min(Edocumento) from DContables ec   where ec.Ddocumento  = <cf_dbfunction name="to_char" args="op.TESOPnumero">  and ec.Ecodigo  = c.Ecodigo),
                    (select min(Edocumento) from HDContables hec where hec.Ddocumento = <cf_dbfunction name="to_char" args="op.TESOPnumero">  and hec.Ecodigo = c.Ecodigo),
                    0
                ) 
            end as IDcontable	
        from GEliquidacion c
        inner join TESsolicitudPago sp
            on sp.TESSPid = c.TESSPid_Adicional
            and sp.EcodigoOri = c.Ecodigo
        inner join TESordenPago op
            on op.TESOPid = sp.TESOPid
        inner join TESbeneficiario b
            on b.TESBid = c.TESBid
        inner join Monedas m 
            on m.Mcodigo = c.Mcodigo
        where c.Ecodigo = #session.Ecodigo#
        <cfif isdefined("rsDatosEmpleado") and rsDatosEmpleado.TESBid gt 0>
        	and c.TESBid = #rsDatosEmpleado.TESBid#
        </cfif>
            and c.GELestado in (2,4)
            and c.GELtipoP=1
            and coalesce(c.TESSPid_Adicional,0) > 0
            and coalesce(c.CCHid,0)	 = 0
        <cfif isdefined("form.periodoini") and len(trim(form.periodoini)) and isdefined("form.mesini") and len(trim(form.mesini)) and isdefined("form.periodofin") and len(trim(form.periodofin)) and isdefined("form.mesfin") and len(trim(form.mesfin))>
            and #preserveSingleQuotes(LvarMesD)# between #form.mesini# and #form.mesfin#
            and #preserveSingleQuotes(LvarPeriodoD)# between #form.periodoini# and #form.periodofin#
        <cfelseif isdefined("form.periodoini") and len(trim(form.periodoini)) and isdefined("form.mesini") and len(trim(form.mesini))>
            and #preserveSingleQuotes(LvarMesD)#     >= #form.mesini#
            and #preserveSingleQuotes(LvarPeriodoD)# >= #form.periodoini#
        <cfelseif isdefined("form.periodofin") and len(trim(form.periodofin)) and isdefined("form.mesfin") and len(trim(form.mesfin))>
            and #preserveSingleQuotes(LvarMesD)#     <= #form.mesfin#
            and #preserveSingleQuotes(LvarPeriodoD)# <= #form.periodofin#
        </cfif>
        order by  sp.TESOPfechaPago desc, c.GELnumero desc
    </cfquery> 
</cfif>
<cfquery name="rsEmpresa" datasource="#session.dsn#">
    select Edescripcion 
    from Empresas
    where Ecodigo = #session.Ecodigo#
</cfquery>

<cfflush interval="64">
<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
		<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
		<td colspan="6" class="letra" align="center"><b>Reporte de Movimientos de Gastos de Empleado de Tesoreria por Periodo</b></td>
	</tr>
	<cfoutput> 
	<tr>
		<td colspan="6" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
    <tr>
		<td colspan="6" align="center" class="letra"><b>Periodo Inicial:</b> #form.periodoini# &nbsp; <b>Mes Inicial:&nbsp;</b>#AMes[form.mesini]#</td>
	</tr>
    <tr>
		<td colspan="6" align="center" class="letra"><b>Periodo Final:</b> #form.periodofin# &nbsp; <b>Mes Final:&nbsp;</b>#AMes[form.mesfin]#</td>
	</tr>
    <tr>
		<td colspan="6" align="center" class="letra">&nbsp;</td>
	</tr>
	</cfoutput> 		
</table>

<cfif AFTRtipo eq -1 or AFTRtipo eq 2>
	<cfoutput>
        <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
            <tr>
                <td align="center" colspan="8" bgcolor="##cccccc" >
                    <strong>Liquidaciones pagadas por Tesoreria</strong>
                </td>
            </tr>	
        </table>
    </cfoutput>
    <cfif rsLiqAprobadas.recordcount gt 0>
        <table width="98%" cellpadding="2" border="0" cellspacing="1" align="center">
            <cfoutput>		
                <tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
                    <td width="8%"  class="tituloListas" colspan="0" align="left" nowrap="nowrap">N°Liquidaci&oacute;n</td>
                    <td width="16%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Empleado</td>
                    <td width="14%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Fecha</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Descripción</td>
                    <td width="15%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Estado</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Monto Anticipos</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Monto Gastos</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Monto Depósito</td>
                    <td width="18%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Pago al Empleado</td>
                    <td width="18%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Devoluci&oacute;n</td>
                    <td width="10%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">P&oacute;liza</td>
                </tr>
                
                <cfloop query="rsLiqAprobadas">
                    <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                        <td align="left" style="font-size:9px" >
                            <a href="javascript:doConlis(#rsLiqAprobadas.GELid#,'L');" style="border-bottom: 1px dotted black;text-decoration: none;">
                                #rsLiqAprobadas.GELnumero#
                            </a>
                        </td>
                        <td align="left" style="font-size:11px">#rsLiqAprobadas.TESBeneficiario#</td>	
                        <td align="left" style="font-size:11px">#LSDateFormat(rsLiqAprobadas.GELfecha, 'dd/mm/yyyy')#</td>
                        <td align="left" style="font-size:11px">#rsLiqAprobadas.GELdescripcion#</td>	
                        <td align="left" style="font-size:11px">#rsLiqAprobadas.Titulo#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsLiqAprobadas.GELtotalAnticipos, ',9.00')#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsLiqAprobadas.GELtotalGastos, ',9.00')#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsLiqAprobadas.GELtotalDepositos, ',9.00')#</td>	
                        <td align="right" style="font-size:11px">#LSNumberFormat(rsLiqAprobadas.GELreembolso, ',9.00')#</td>
                        <td align="right" style="font-size:11px">#LSNumberFormat(rsLiqAprobadas.GELreembolso, ',9.00')#</td>
                        <td align="right" style="font-size:12px">#rsLiqAprobadas.IDcontable#</td>
                    </tr>
                </cfloop>
            </cfoutput>
        </table>
    <cfelse>
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td align="center" colspan="8">
                    <strong>--- No se encontraron datos ----</strong>
                </td>
            </tr>	
        </table>
    </cfif>
    
    <cfoutput>
        <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
            <tr>
                <td align="center" colspan="8">&nbsp;</td>
            </tr>	
            <tr>
                <td align="center" colspan="8" bgcolor="##cccccc" >
                    <strong>Liquidaciones que Generaron Solicitud de Pago por Pago Adicional al Empleado</strong>
                </td>
            </tr>	
        </table>
    </cfoutput>
    
    <cfif rsLiqSPPagadas.recordcount gt 0>
        <table width="98%" cellpadding="1" border="0" cellspacing="1" align="center">	
            <cfoutput>		
                <tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
                    <td width="8%"  class="tituloListas" colspan="0" align="left" nowrap="nowrap">N°Liquidaci&oacute;n</td>
                    <td width="16%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Empleado</td>
                    <td width="14%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Fecha Pago</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Descripción</td>
                    <td width="15%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Estado</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Monto Anticipos</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Monto Gastos</td>
                    <td width="35%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Monto Depósito</td>
                    <td width="18%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Pago al Empleado</td>
                    <td width="18%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">Devoluci&oacute;n</td>
                    <td width="10%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">N° Solicido Pago/Estado</td>
                    <td width="10%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">N° Orden Pago/Estado</td>
                    <td width="10%" class="tituloListas" colspan="0" align="left" nowrap="nowrap">P&oacute;liza</td>
                </tr>
                
                <cfloop query="rsLiqSPPagadas">
                    <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                        <td align="left" style="font-size:9px">
                            <a href="javascript:doConlis(#rsLiqSPPagadas.GELid#,'L');" style="border-bottom: 1px dotted black;text-decoration: none;">
                                #rsLiqSPPagadas.GELnumero#
                            </a>
                        </td>
                        <td align="left" style="font-size:11px">#rsLiqSPPagadas.TESBeneficiario#</td>	
                        <td align="left" style="font-size:11px">#LSDateFormat(rsLiqSPPagadas.TESOPfechaPago, 'dd/mm/yyyy')#</td>
                        <td align="left" style="font-size:11px">#rsLiqSPPagadas.GELdescripcion#</td>	
                        <td align="left" style="font-size:11px">#rsLiqSPPagadas.Titulo#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsLiqSPPagadas.GELtotalAnticipos, ',9.00')#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsLiqSPPagadas.GELtotalGastos, ',9.00')#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsLiqSPPagadas.GELtotalDepositos, ',9.00')#</td>	
                        <td align="right" style="font-size:11px">#LSNumberFormat(rsLiqSPPagadas.GELreembolso, ',9.00')#</td>
                        <td align="right" style="font-size:11px">#LSNumberFormat(rsLiqSPPagadas.GELreembolso, ',9.00')#</td>
                        <td align="right" style="font-size:11px">#rsLiqSPPagadas.TESSPnumero#/#rsLiqSPPagadas.EstadoSP#</td>
                        <td align="right" style="font-size:11px">#rsLiqSPPagadas.TESOPnumero#/#rsLiqSPPagadas.EstadoOP#</td>				
                        <td align="right" style="font-size:12px">#rsLiqSPPagadas.IDcontable#</td>
                    </tr>
                </cfloop>
            </cfoutput>
        </table>
    <cfelse>
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td align="center" colspan="8">
                    <strong>--- No se encontraron datos ----</strong>
                </td>
            </tr>	
        </table>
    </cfif>
</cfif>

<cfif AFTRtipo eq -1 or AFTRtipo eq 1>
	<cfoutput>
        <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
            <tr>
                <td align="center" colspan="8">&nbsp;</td>
            </tr>	
            <tr>
                <td align="center" colspan="8" bgcolor="##cccccc" >
                    <strong>Anticipos Pagados por Tesorer&iacute;a</strong>
                </td>
            </tr>	
        </table>
    </cfoutput>
    
    <cfif rsAnticipos.recordcount gt 0>
        <table width="98%" cellpadding="1" border="0" cellspacing="1" align="center">	
            <cfoutput>		
                <tr bgcolor="CCCCCC" nowrap="nowrap" style="background-color:CCCCCC" align="center" class="tituloListas">
                    <td nowrap class="tituloListas" width="8%" colspan="0" align="left">N°Anticipo</td>
                    <td nowrap class="tituloListas" width="16%" colspan="0" align="left">Empleado</td>
                    <td nowrap class="tituloListas" width="14%" colspan="0" align="left">Fecha</td>
                    <td nowrap class="tituloListas" width="35%" colspan="0" align="left">Descripción</td>
                    <td nowrap class="tituloListas" width="15%" colspan="0" align="left">Estado</td>
                    <td nowrap class="tituloListas" width="35%" colspan="0" align="left">Monto del Anticipo</td>
                    <td nowrap class="tituloListas" width="10%" colspan="0" align="left">N° Solicido Pago/Estado</td>
                    <td nowrap class="tituloListas" width="10%" colspan="0" align="left">N° Orden Pago/Estado</td>
                    <td nowrap class="tituloListas" width="10%" colspan="0" align="left">P&oacute;liza</td>
                </tr>
                
                <cfloop query="rsAnticipos">
                    <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
                        <td align="left" style="font-size:9px">
                            <a href="javascript:doConlis(#rsAnticipos.GEAid#,'A');" style="border-bottom: 1px dotted black;text-decoration: none;">
                                #rsAnticipos.GEAnumero#
                            </a>
                        </td>
                        <td align="left" style="font-size:11px">#rsAnticipos.TESBeneficiario#</td>	
                        <td align="left" style="font-size:11px">#LSDateFormat(rsAnticipos.GEAfechaPagar, 'dd/mm/yyyy')#</td>
                        <td align="left" style="font-size:11px">#rsAnticipos.GEAdescripcion#</td>	
                        <td align="left" style="font-size:11px">#rsAnticipos.estado#</td>	
                        <td align="left" style="font-size:11px">#LSNumberFormat(rsAnticipos.GEAtotalOri, ',9.00')#</td>	
                        <td align="right" style="font-size:11px">#rsAnticipos.TESSPnumero#/#rsAnticipos.EstadoSP#</td>
                        <td align="right" style="font-size:11px">#rsAnticipos.TESOPnumero#/#rsAnticipos.EstadoOP#</td>				
                        <td align="right" style="font-size:12px">#rsAnticipos.IDcontable#</td>
                    </tr>
                </cfloop>
            </cfoutput>
        </table>
    <cfelse>
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td align="center" colspan="8">
                    <strong>--- No se encontraron datos ----</strong>
                </td>
            </tr>	
        </table>
    </cfif>
</cfif>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr><td align="center" colspan="8">&nbsp;</td></tr>	
    <tr>
        <td align="center" colspan="8">
            <strong>--- Fin del Reporte ----</strong>
        </td>
    </tr>
    <tr><td align="center" colspan="8">&nbsp;</td></tr>		
</table>
<script language="javascript1.1" type="text/javascript">

var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
if(popUpWinSN) {
if(!popUpWinSN.closed) popUpWinSN.close();
}
popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
window.onfocus = closePopUp;
}

function doConlis(id,tipo){
<cfoutput>
popUpWindow("/cfmx/sif/tesoreria/GestionEmpleados/RepDisponible_popUp.cfm?id="+id+"&transac="+tipo,350,250,800,500);					
</cfoutput>
}

function closePopUp(){
if(popUpWinSN) {
if(!popUpWinSN.closed) popUpWinSN.close();
popUpWinSN=null;
}
}
</script>



