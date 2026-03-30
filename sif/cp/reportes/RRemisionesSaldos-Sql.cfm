<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')>
<cfset MSG_CantDoc = t.Translate('MSG_CantDoc','La cantidad de Documentos a presentar sobrepasa los 20,000 registros.','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset MSG_AGenerar = t.Translate('MSG_AGenerar','Se van a generar','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset MSG_RegFiltro = t.Translate('MSG_RegFiltro','registros con los filtros actuales','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset MSG_RangoFiltro = t.Translate('MSG_RangoFiltro','Reduzca el rango utilizando los filtros.','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset MSG_ProcCanc = t.Translate('MSG_ProcCanc','Proceso Cancelado.','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_Debito = t.Translate('LB_Debito','Débito','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_Credito = t.Translate('LB_Credito','Crédito','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset TIT_ImpHist = t.Translate('TIT_ImpHist','Reporte de remisiones por socio','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset TIT_Rep = t.Translate('TIT_Rep','Reporte de remisiones por socio','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_DelSocio = t.Translate('LB_DelSocio','Socio de negocio','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_DelSocioIND = t.Translate('LB_DelSocioIND','Identificaci&oacute;n','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_DelSocioc = t.Translate('LB_DelSocioc','C&oacute;digo Socio','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_DesdeFec = t.Translate('LB_DesdeFec','Desde la fecha','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_HastaFec = t.Translate('LB_HastaFec','Hasta la fecha','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_TipoTr = t.Translate('LB_TipoTr','Tipo de la Transacci&oacute;n','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_FechaCons = t.Translate('LB_FechaCons','Fecha de la Consulta','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_Hora = t.Translate('LB_Hora','Hora','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_TotTr = t.Translate('LB_TotTr','Totales por Transacci&oacute;n','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_TotSoc = t.Translate('LB_TotSoc','Totales por Socio','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_TotMon = t.Translate('LB_TotMon','Totales por Moneda','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Saldo','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/cp/reportes/RFacturas-SQL.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha Documento','/sif/generales.xml')>
<cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento','/sif/generales.xml')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','/sif/generales.xml')>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfparam name="Saldo" default="0">
<cfif  val(Saldo)>
	<cfset Saldo = 1>
<cfelse>
	<cfset Saldo = 0>
</cfif>

<cfif isdefined("form.Documento") and len(trim(form.Documento))>
	<cfset LvarDocumento = form.Documento>
<cfelse>
	<cfset LvarDocumento = "">
</cfif>

<cfquery name="rsProc" datasource="#session.DSN#">
    select 
    he.EDtotal as MontoOrigen,
    he.EDtotal * he.EDtipocambio as MontoLocal,
    he.EDtipocambio as TC,
    m.Mcodigo,
    m.Mnombre,
    s.SNcodigo, s.SNnombre, substring(s.SNnumero,1,9) as SNnumero, s.SNidentificacion,
    he.IDdocumento as HDid,
    he.EDdocumento as Recibo,
    he.CPTcodigo,
    he.Ecodigo,
    s.SNnombre,
    convert(varchar,he.EDfecha,103) as Fecha,
    he.EDusuario as EDusuario,
    o.Odescripcion as OficinaDes,
    o.Oficodigo as Oficina,
    coalesce(
    (select min(h.Edocumento) from HEContables h where h.IDcontable = he.IDcontable),
    (select min(h.Edocumento) from EContables h where h.IDcontable = he.IDcontable)
    ) as Asiento,
    0.00 as EDsaldo,
    convert(varchar,he.EDvencimiento, 103) as FechaDocumentoVencimiento,
    coalesce(ds.direccion1, ds.direccion2, 'N/A') as direccion
    from 
    EDocumentosCPR he
    inner join SNegocios s
    on s.SNcodigo = he.SNcodigo
    and s.Ecodigo = he.Ecodigo
    inner join CPTransacciones b
    on b.Ecodigo = he.Ecodigo
    and b.CPTcodigo = he.CPTcodigo
    inner join Monedas m
    on m.Mcodigo = he.Mcodigo
    inner join Oficinas o
    on o.Ecodigo = he.Ecodigo
    and o.Ocodigo = he.Ocodigo
    left outer join SNDirecciones sd
    on sd.id_direccion = he.id_direccion
    and sd.SNid = s.SNid
    left outer join DireccionesSIF ds
    on ds.id_direccion = sd.id_direccion
    where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	and he.EDfecha between #lsparsedatetime(form.fechaIni)# and #lsparsedatetime(form.fechaFin)#
	<cfif isdefined("form.Documento") and len(Trim(form.Documento))>
		and he.EDdocumento like '%#form.Documento#%'
	</cfif>
    and he.EVestado = 1
</cfquery>

<cfset HoraReporte = Now()>

<style type="text/css">
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
</style>

<cf_htmlReportsHeaders
	title="#TIT_ImpHist#"
	filename="RepSaldosRemisiones.xls"
	irA="RRemisionesSaldos.cfm"
	download="yes"
	preview="no">

<table border="0" cellspacing="0" cellpadding="0" width="92%" align="center">
    <tr>
		<td colspan="8" align="center" bgcolor="#E4E4E4">
			<cfoutput>
			<span class="style3">#Session.Enombre#</span>
			</cfoutput>
		</td>
	</tr>
    <tr>
		<td colspan="10" align="center">&nbsp;</td>
	</tr>
	<tr>
		<cfoutput><td colspan="8" align="center"><span class="style1">#TIT_Rep#</span></td></cfoutput>
	</tr>
    <tr>
		<cfoutput>
		<td colspan="8" align="center">
			<span class="style1">#LB_DesdeFec#: #dateformat(form.fechaIni,'dd/mm/yyyy')#&nbsp;&nbsp;#LB_HastaFec#:
			#dateformat(form.fechaFin,'dd/mm/yyyy')#
		</cfoutput>
			</span>
		</td>
	</tr>
	<tr>
		<td colspan="8" align="center">
			<cfoutput>
				<font size="2"><strong>#LB_FechaCons#:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>#LB_Hora#:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#
				</font>
			</cfoutput>
		</td>
	</tr>
    <tr class="style5" bgcolor="#E4E4E4" colspan="8" >
		<td colspan="2" align="center">
		    <span class="style1"><cfoutput>#LB_DelSocioc#:</cfoutput></span>&nbsp;&nbsp;
		    <span class="style2"><cfoutput>#rsProc.SNnumero#</cfoutput></span>&nbsp;&nbsp;
		</td>
		<td colspan="3" align="center">
		    <span class="style1"><cfoutput>#LB_DelSocio#:</cfoutput></span>
		    <span class="style2"><cfoutput>#rsProc.SNnombre#</cfoutput></span>&nbsp;&nbsp;
		</td>
		<td colspan="3" align="center">
		    <span class="style1"><cfoutput>#LB_DelSocioIND#:</cfoutput></span>
		    <span class="style2"><cfoutput>	#rsProc.SNidentificacion#</cfoutput></span>
		</td>
	</tr>
    <tr  class="style5" bgcolor="#E4E4E4">
			<td colspan="8" align="left"  style="width:20% font-size: 12px;">
				<cfoutput>
					<font size="2">Documentos:</font>
				</cfoutput>
			</td>
	</tr>
	<cfset px = 12>
	<tr class="style5" bgcolor="#E4E4E4">
		<td colspan="8" align="left"  style="text-indent:<cfoutput>#px#</cfoutput>px">
			<cfoutput>
				<font size="2">Moneda:#rsProc.Mnombre#</font>
			</cfoutput>
		</td>
	</tr>
    <tr class="style5" bgcolor="#E4E4E4">
		<cfoutput>
			<td nowrap="nowrap" align="left" style="width: 13%;">#LB_TipoTr#</td>
			<td nowrap="nowrap" align="left" style="width: 15%;">#LB_Documento#</td>
			<td nowrap="nowrap" align="left" style="width: 18%;">#LB_Oficina#</td>
			<td nowrap="nowrap" align="left" style="width: 10%;">#LB_Fecha#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">#LB_FechaVencimiento#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">#LB_Moneda#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">#LB_Monto#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">&nbsp;</td>
		</cfoutput>
	</tr>
    <cfloop query="rsProc">
        <cfoutput>
            <cfquery name="rsReporteDet" datasource="#session.DSN#">
                select * from (
                    select distinct eo.EOidorden as orderer, eo.Observaciones as Recibo,
                    convert(varchar,eo.EOfecha, 103) as Dfecha2,
                    null as Asiento,
                    -1 as Etipocambio,
                    (eo.EOtotal) as MontoOrigen,
                    '-' as FechaDocumentoVencimiento,
                    (eo.EOtotal) as MontoLocal,
                    null as CuentaDelDetalle,
                    eo.Mcodigo,
                    m.Mnombre,
                    0 as BMmontoref,
                    eo.CMTOcodigo as CPTcodigo,
                    0 as Oficina,
                    convert(varchar,eo.EOfecha, 103) as Dfecha,
                    '' as DRdocumento,
                    eo.SNcodigo,
                    '' as OficinaDes
                        from DDocumentosCPR dd
                        inner join DOrdenCM do on
                        dd.Linea = do.DRemisionlinea
                        inner join EDocumentosCPR d
                        on d.IDdocumento = dd.IDdocumento
                        inner join EOrdenCM eo
                        on do.EOidorden = eo.EOidorden
                        left outer join CFinanciera cfi
                        on cfi.Ccuenta = d.Ccuenta
                        inner join Monedas m
                        on m.Mcodigo = d.Mcodigo
                        and m.Ecodigo = d.Ecodigo
                        inner join CPTransacciones cpt
                        on cpt.Ecodigo   = d.Ecodigo
                        and cpt.CPTcodigo = d.CPTcodigo
                        left outer join CFuncional cfun
                        on cfun.CFid = do.CFid
                        and cfun.Ecodigo = d.Ecodigo
                        left outer join Oficinas o
                        on o.Ocodigo = cfun.Ocodigo
                        and o.Ecodigo = d.Ecodigo
                        where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProc.HDid#">
                        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    union
                    select distinct dx.IDdocumento as orderer,
                    dx.EDdocumento as Recibo,
                    convert(varchar,dx.EDfecha, 103) as Dfecha2,
                    null as Asiento,
                    dx.EDtipocambio,
                    dx.EDtotal as MontoOrigen,
                    convert(varchar,dx.EDvencimiento, 103) as FechaDocumentoVencimiento,
                    dx.EDtotal * dx.EDtipocambio as MontoLocal,
                    (select cc.Cformato from CContables cc where cc.Ccuenta = dx.Ccuenta) as CuentaDelDetalle,
                    dx.Mcodigo,
                    m.Mnombre,
                    0 as BMmontoref,
                    dx.CPTcodigo,
                    dx.Ocodigo as Oficina,
                    convert(varchar,dx.EDfecha, 103) as Dfecha,
                    '' as DRdocumento,
                    dx.SNcodigo,
                    o.Odescripcion as OficinaDes
                        from DDocumentosCPR dd
                        inner join DDocumentosCxP ddx
                        on dd.DFacturalinea = ddx.Linea
                        inner join EDocumentosCPR d
                        on d.IDdocumento = dd.IDdocumento
                        inner join EDocumentosCxP dx
                        on ddx.IDdocumento = dx.IDdocumento
                        left outer join CFinanciera cfi
                        on cfi.Ccuenta = d.Ccuenta
                        inner join Monedas m
                        on m.Mcodigo = d.Mcodigo
                        and m.Ecodigo = d.Ecodigo
                        inner join CPTransacciones cpt
                        on cpt.Ecodigo   = d.Ecodigo
                        and cpt.CPTcodigo = d.CPTcodigo
                        inner join Oficinas o
                        on o.Ecodigo = dx.Ecodigo
                        and o.Ocodigo = dx.Ocodigo
                        where d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProc.HDid#">
                        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                ) queryU
                order by queryU.orderer asc
            </cfquery>
            <!--- cabecera --->
            <tr class="style2">
                <td nowrap="nowrap" align="left">#CPTcodigo#</td>
                <td nowrap="nowrap"  align="left">#rsProc.Recibo#</td>
                <td nowrap="nowrap" align="left">#rsProc.OficinaDes#</td>
                <td nowrap="nowrap" align="left">#rsProc.Fecha#</td>
                <td nowrap="nowrap" align="left">#rsProc.FechaDocumentoVencimiento#</td>
                <td nowrap="nowrap" align="left">#rsProc.Mnombre#</td>
                <td nowrap="nowrap" align="center">#NumberFormat(rsProc.MontoLocal,',_.__')#</td>
                <td nowrap="nowrap" align="center"></td>
            </tr>
        </cfoutput>
        <!--- loop del detalle --->
        <cfloop query="rsReporteDet">
            <cfoutput>
                <cfset px = 0>
				<cfif rsReporteDet.CPTcodigo Neq 'RM' or rsReporteDet.CPTcodigo Neq 'DR'>
					<cfset px = 10>
			 	</cfif>
                <tr nowrap="nowrap" class="style2">
                    <td style="text-indent: <cfoutput>#px#</cfoutput>px" nowrap="nowrap" align="left">&nbsp;&nbsp;#rsReporteDet.CPTcodigo#</td>
                    <td nowrap="nowrap" align="left">#rsReporteDet.Recibo#</td>
                    <td nowrap="nowrap" align="left">#rsReporteDet.OficinaDes#</td>
                    <td nowrap="nowrap" align="left">#rsReporteDet.Dfecha2#</td>
                    <td nowrap="nowrap" align="left">#rsReporteDet.FechaDocumentoVencimiento#</td>
                    <td nowrap="nowrap" align="left">#rsReporteDet.Mnombre#</td>
                    <td nowrap="nowrap" align="center">#NumberFormat(rsReporteDet.MontoLocal,',_.__')#</td>
                    <td nowrap="nowrap" align="center"></td>
                </tr>
            </cfoutput>
        </cfloop>
        <!--- SEPARADOR --->
        <tr nowrap="nowrap" class="style2" bgcolor="#E4E4E4">
            <td colspan = "8">&nbsp;</td>
        </tr>
    </cfloop>
</table>