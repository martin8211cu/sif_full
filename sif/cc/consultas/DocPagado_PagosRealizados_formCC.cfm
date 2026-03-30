<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 18-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_FECHA = t.Translate('LB_FECHA','Fecha','/sif/generales.xml')>
<cfset LB_ConsPagReal = t.Translate('LB_ConsPagReal','Consulta de Pagos Realizados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','DocPagado_sqlCC.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&amp;oacute;n','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Asiento = t.Translate('LB_Asiento','Asiento','DocPagado_sqlCC.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_TC = t.Translate('LB_TC','TC','DocPagado_sqlCC.xml')>
<cfset LB_MontoOr = t.Translate('LB_MontoOr','Monto Origen','DocPagado_sqlCC.xml')>
<cfset LB_MontoLoc = t.Translate('LB_MontoLoc','Monto Local','DocPagado_sqlCC.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','DocPagado_sqlCC.xml')>
<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta','DocPagado_sqlCC.xml')>
<cfset LB_SinReg = t.Translate('LB_SinReg','No se encontraron registros','DocPagado_sqlCC.xml')>
<cfset LB_PagosRe = t.Translate('LB_PagosRe','Pagos Realizados')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Recibo = t.Translate('LB_Recibo','Recibo')>
<cfset LB_Cuenta = t.Translate(' LB_Cuenta','Cuenta ','/sif/generales.xml')>
<cfset LB_MontoDoc = t.Translate('LB_MontoDoc','Monto del Doc.')>
<cfset LB_NoPagos = t.Translate('LB_NoPagos','No se han hecho pagos a este documento')>
<cfset LB_Total = t.Translate(' LB_Total','Total','/sif/generales.xml')>



<cfif isdefined("url.LvarReciboB") and len(trim("url.LvarReciboB"))>
	<cfset url.recibo = url.LvarReciboB>
</cfif>
<cfif isdefined("url.Pagos") and url.Pagos EQ 1>
	<cfset url.LvarRecibo = "">
</cfif>
<cfif isdefined("url.LvarReciboB") and len(trim("url.LvarReciboB"))>
	<cfset url.LvarRecibo = url.LvarReciboB>
</cfif>

<cfquery name="rsProc" datasource="#session.DSN#">
	select 
			(
				select sum(bb.Dtotal) 
				from HDocumentos bb
				where bb.HDid = he.HDid
			) as MontoOrigen,
			(
				select sum(bb.Dtotal * bb.Dtipocambio) 
				from HDocumentos bb
				where bb.HDid = he.HDid
			) as MontoLocal,			
			he.Dtipocambio as TC,
			m.Mcodigo, 
			m.Mnombre,
			s.SNcodigo, s.SNnombre, substring(s.SNnumero,1,9) as SNnumero, s.SNidentificacion, 
			he.HDid,
			he.Ddocumento as Recibo, 
			he.CCTcodigo,
			he.Ecodigo,
			he.Dfecha as Fecha, 
			he.Dusuario as EDusuario,
			o.Oficodigo as Oficina,
			coalesce(
				(select min(h.Edocumento)
				from HEContables h
				where h.IDcontable = bm.IDcontable)
				,
				(select min(h.Edocumento)
				from EContables h
				where h.IDcontable = bm.IDcontable)
			) as Asiento,
			coalesce(ed.Dsaldo, 0.00) as EDsaldo,
			coalesce(ds.direccion1, ds.direccion2, 'N/A') as direccion
	
		from HDocumentos he
			inner join SNegocios s
			on s.SNcodigo = he.SNcodigo
			and s.Ecodigo = he.Ecodigo

			inner join CCTransacciones b
			on b.Ecodigo = he.Ecodigo
			and b.CCTcodigo =he.CCTcodigo

			inner join Monedas m
			on m.Mcodigo = he.Mcodigo 

			inner join Oficinas o
			on o.Ecodigo = he.Ecodigo
			and o.Ocodigo = he.Ocodigo

			left outer join SNDirecciones sd
			on sd.id_direccion = he.id_direccionFact
			and sd.SNid = s.SNid

			left outer join DireccionesSIF ds
			on ds.id_direccion = sd.id_direccion

			left outer join BMovimientos bm
			on bm.SNcodigo = he.SNcodigo
			and bm.Ddocumento = he.Ddocumento
			and bm.CCTcodigo = he.CCTcodigo
			and bm.Ecodigo = he.Ecodigo
			and bm.CCTRcodigo = he.CCTcodigo
			and bm.DRdocumento = he.Ddocumento

			<cfif isdefined("url.chk_DocSaldo")>
				inner join Documentos ed
			<cfelse>
				left outer join Documentos ed
			</cfif>
				on ed.Ecodigo     = he.Ecodigo
				and ed.CCTcodigo  = he.CCTcodigo
				and ed.Ddocumento = he.Ddocumento
				and ed.SNcodigo   = he.SNcodigo
		where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
		  and he.HDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HDid#">
		  and he.Dfecha between #lsparsedatetime(url.FechaI)# and #lsparsedatetime(url.FechaF)#
		  <cfif isdefined("url.LvarRecibo") and len(Trim(url.LvarRecibo))>
			and he.Ddocumento like '%#url.LvarRecibo#%'
		  </cfif>
</cfquery>

<cfquery name="rsReporteEnc" dbtype="query">
	select distinct
			MontoOrigen,  
			MontoLocal,
			TC,
			Mcodigo, 
			Mnombre,
			SNcodigo, 
			SNnombre, 
			SNnumero, 
			SNidentificacion, 
			HDid,
			Recibo,
			CCTcodigo, 
			Ecodigo,
			Fecha, 
			Oficina,
			EDusuario,  
			Asiento,
			EDsaldo,
			direccion
	from rsProc
	order by Mcodigo, Fecha, Recibo
</cfquery>

<cfquery name="rsReporteDet" datasource="#session.DSN#">
	select 
	bm.Ddocumento as Recibo,
	bm.BMfecha,
    coalesce(
        (select min(h.Edocumento)
        from HEContables h
		where h.IDcontable = bm.IDcontable)
        ,
        (select min(h.Edocumento)
        from EContables h
		where h.IDcontable = bm.IDcontable)
    ) as Asiento,
	bm.Dtipocambio,
	(
	  select sum(b.Dtotal) 
	  	from BMovimientos b
	   	where b.Ecodigo = bm.Ecodigo
			and b.CCTcodigo = bm.CCTcodigo
			and b.Ddocumento = bm.Ddocumento
			and b.CCTRcodigo = bm.CCTRcodigo 
			and b.DRdocumento = bm.DRdocumento
			and b.BMfecha = bm.BMfecha
	) as MontoOrigen,
	(
	  select sum(bb.Dtotal * bb.Dtipocambio) 
		from BMovimientos bb
	   	where bb.Ecodigo = bm.Ecodigo
			and bb.CCTcodigo = bm.CCTcodigo
			and bb.Ddocumento = bm.Ddocumento
			and bb.CCTRcodigo = bm.CCTRcodigo 
			and bb.DRdocumento = bm.DRdocumento
			and bb.BMfecha = bm.BMfecha
	) as MontoLocal,
	(select cc.Cformato
			from CContables cc
			where cc.Ccuenta = bm.Ccuenta) as CuentaDelDetalle,
	bm.Mcodigo,
	m.Mnombre,
	bm.BMmontoref,
	bm.CCTcodigo

from BMovimientos  bm
	inner join Monedas m
		on m.Mcodigo = bm.Mcodigo
where 
	bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and bm.CCTcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.CCTcodigo#">
	and bm.Ddocumento <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.Recibo#">
	and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" maxlength="2" value="#url.CCTcodigo#">
	and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#url.Recibo#">

	and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">

union

	select 
	bm.Ddocumento as Recibo,
	bm.BMfecha,
	hc.Edocumento as Asiento,
	bm.Dtipocambio,
	(
	  select sum(b.Dtotal) 
	  	from BMovimientos b
	   	where b.Ecodigo = bm.Ecodigo
			and b.CCTcodigo = bm.CCTcodigo
			and b.Ddocumento = bm.Ddocumento
			and b.CCTRcodigo = bm.CCTRcodigo 
			and b.DRdocumento = bm.DRdocumento
			and b.BMfecha = bm.BMfecha
	) as MontoOrigen,
	(
	  select sum(bb.Dtotal * bb.Dtipocambio) 
		from BMovimientos bb
	   	where bb.Ecodigo = bm.Ecodigo
			and bb.CCTcodigo = bm.CCTcodigo
			and bb.Ddocumento = bm.Ddocumento
			and bb.CCTRcodigo = bm.CCTRcodigo 
			and bb.DRdocumento = bm.DRdocumento
			and bb.BMfecha = bm.BMfecha
	) as MontoLocal,
	(select cc.Cformato
			from CContables cc
			where cc.Ccuenta = bm.Ccuenta) as CuentaDelDetalle,
	bm.Mcodigo,
	m.Mnombre,
	bm.BMmontoref,
	bm.CCTcodigo
	
from BMovimientos  bm
	inner join Monedas m
		on m.Mcodigo = bm.Mcodigo
	inner join EContables hc
		on hc.IDcontable = bm.IDcontable
where 
	bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and bm.CCTcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.CCTcodigo#">
	and bm.Ddocumento <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.Recibo#">
	and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" maxlength="2" value="#url.CCTcodigo#">
	and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#url.Recibo#">
	and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">

order by Mcodigo
</cfquery>

<cfif url.formatos EQ 1>
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
		* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px; }
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 10px; }
		</style>
	</head>
	<body>

	<cfif isdefined("rsReporteEnc") and rsReporteEnc.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="11" align="right">
				<cfset params = "&formatos=1&SNcodigo=#url.SNcodigo#&FechaI=#url.FechaI#&FechaF=#url.FechaF#&LvarRecibo=#url.LvarRecibo#&CCTcodigo=#url.CCTcodigo#&HDid=#url.HDid#">
				<cfif isdefined("url.chk_DocSaldo")>
					<cfset params = params & "&chk_DocSaldo=#url.chk_DocSaldo#">
				</cfif>
				<cfif isdefined("url.Recibo")>
					<cfset params = params & "&Recibo=#url.Recibo#">
				</cfif>
				<cf_rhimprime datos="/sif/cc/consultas/DocPagado_PagosRealizados_formCC.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>	
			<td>&nbsp;</td>
			<td colspan="11" align="right" class="noprint">
					<cfset params2 ="">
					<cfset params2 = trim('&LvarReciboB=#rsReporteEnc.Recibo#&Recibo=#rsReporteEnc.Recibo#&Fecha=#rsReporteEnc.Fecha#&Asiento=#rsReporteEnc.Asiento#&TC=#rsReporteEnc.TC#&MontoOrigen=#rsReporteEnc.MontoOrigen#&MontoLocal=#rsReporteEnc.MontoLocal#')>
					<cfset params3 = "">
				<cfoutput>
					<a href="DocPagado_sqlCC.cfm?1=1#params#">#LB_Regresar#</a> 
				</cfoutput>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="7" class="niv4" align="right"><cfoutput>#LB_FECHA#:&nbsp;#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2"><cfoutput>#LB_ConsPagReal#</cfoutput></td>
		  <td colspan="4" class="niv4" align="right"><cfoutput>#LB_USUARIO#:&nbsp;#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="7" class="niv3"><cfoutput>#LB_Fecha_Desde#:&nbsp;#dateformat(url.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="7" class="niv3"><cfoutput>#LB_Fecha_Hasta#:&nbsp;#dateformat(url.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>  
			<cfoutput>	
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#LB_Codigo#:</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#LB_SocioNegocio#:</td>
			  <td nowrap="nowrap" class="niv3" align="right" style="width:18%" colspan="1">#LB_Identificacion#:</td>
			  <td colspan="9">&nbsp;</td>
			</tr>
			<tr bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporteEnc.SNnumero#</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#trim(rsReporteEnc.SNnombre)#</td>
			  <td nowrap="nowrap" class="niv3" align="right" colspan="1">#rsReporteEnc.SNidentificacion#</td>
			  <td colspan="9">&nbsp;</td>
			</tr>
			<tr bgcolor="E7E7E7">
				<td align="left" style="font-weight:bold" class="niv3">#LB_Documento#:</td>
				<td colspan="21">&nbsp;</td>
			</tr>
			<cf_templatecss>
			<tr style="font-weight:bold">
              <td nowrap="nowrap" class="niv4" style="width:17%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Documento#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Direccion#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Oficina#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_FECHA#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Asiento#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Moneda#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_USUARIO#</td>
              <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_TC#</td>
              <td nowrap="nowrap" align="right" class="niv4" style="width:1%">#LB_MontoOr#</td>
              <td nowrap="nowrap" align="right" class="niv4" style="width:1%">#LB_MontoLoc#</td>
              <td nowrap="nowrap" align="right" class="niv4" style="width:1%"colspan="19">#LB_Saldo#</td>
            </tr>
            <tr>
			  <td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#rsReporteEnc.CCTcodigo# - #rsReporteEnc.Recibo#</a></td>
			  <td style="width:1%" nowrap><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#trim(rsReporteEnc.direccion)#</a></td>
			  <td><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#rsReporteEnc.Oficina#</a></td>
			  <td align="left"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#dateformat(rsReporteEnc.Fecha,'dd/mm/yyyy')#</a></td>
			  <td align="left"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#rsReporteEnc.Asiento#</a></td>
			  <td align="left"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#rsReporteEnc.Mnombre#</a></td>
			  
			  <td align="left"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#rsReporteEnc.EDusuario#</a></td>
				  
			  <td align="right"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.TC,'_,_.__')#</a></td>
			  <td align="right"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.MontoOrigen,'_,_.__')#</a></td>
			  <td align="right"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.MontoLocal,'_,_.__')#</a></td>
			  <td align="right" colspan="19"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?Pagos=2&Rec_pag=#recibo#&HDid_pago=#url.HDid##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.EDsaldo,'_,_.__')#</a></td>
			</tr>
			</cfoutput>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
		</table>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
			<tr bgcolor="E7E7E7">
				<td colspan="9" align="left" style="font-weight:bold; width:1%"   nowrap="nowrap" class="niv3"><cfoutput>#LB_PagosRe#:</cfoutput></td>

			</tr>
			<cfoutput query="rsReporteDet" group="Mcodigo">
				<cfset TotalMontoOrigen = 0>
				<cfset TotalMontoLocal = 0>
            <tr>
                <td colspan="22" align="left" style="font-weight:bold" nowrap="nowrap" class="niv3" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Moneda#: #rsReporteDet.Mnombre#</td>
            </tr>
            <tr style="font-weight:bold">
              <td style="width:7%">&nbsp;</td>
              <td nowrap="nowrap" align="left" class="niv3" style="width:14%">#LB_Recibo#</td>
              <td nowrap="nowrap" align="left" class="niv3" style="width:14%">#LB_Cuenta#</td>
              <td nowrap="nowrap" align="left" class="niv3" style="width:1%">#LB_FECHA#</td>
              <td nowrap="nowrap" align="left" class="niv3" style="width:1%">#LB_Asiento#</td>
              <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_TC#</td>
              <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_MontoOr#</td>
              <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_MontoLoc#</td>
              <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_MontoDoc#</td>
            </tr>
            <cfset LvarListaNon = (CurrentRow MOD 2)>
            <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
              <td>&nbsp;</td>
              <td nowrap="nowrap"><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2##params3#" class="niv4">#CCTcodigo# - #Recibo#</a></td>
              <td nowrap="nowrap"><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#CuentaDelDetalle#</a></td>				  
              <td><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#dateformat(BMfecha, 'dd/mm/yyyy')#</a></td>
              <td><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#Asiento#</a></td>
              <td align="right"><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#NumberFormat(Dtipocambio,'_,_.__')#</a></td>
              <td align="right"><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#NumberFormat(MontoOrigen,'_,_.__')#</a></td>
              <td align="right"><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#NumberFormat(MontoLocal,'_,_.__')#</a></td>
              <td align="right"><a href="PagoRealizado_sqlCC.cfm?Pagos=1&Rec_pag=#recibo##params##params2#" class="niv4">#NumberFormat(BMmontoref,'_,_.__')#</a></td>	
            </tr>

            <cfset TotalMontoOrigen = TotalMontoOrigen + MontoOrigen>
            <cfset TotalMontoLocal = TotalMontoLocal + MontoLocal>
            <tr>
                <td>&nbsp;</td>
                <td class="niv3" colspan="4" style="font-weight:bold">#LB_Total#:&nbsp;</td>
                <td>&nbsp;</td>
                <td class="niv3" align="right" style="font-weight:bold">#NumberFormat(TotalMontoOrigen,'_,_.__')#</td>
                <td class="niv3" align="right" style="font-weight:bold" colspan="1">#NumberFormat(TotalMontoLocal,'_,_.__')#</td>
            </tr>
   		 	</cfoutput>
    	<cfoutput>     
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
		<cfif isdefined("rsReporteDet") and rsReporteDet.recordcount eq 0>
			<tr>
				<td colspan="22" align="center" class="niv3">
						 <strong>#LB_NoPagos#</strong>
				</td>
			</tr>
		</cfif>
		
		<tr>
			<td colspan="22" align="center" class="niv3">
            	<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta')>
				------------------------------------------- #LB_FinCons# -------------------------------------------
			</td>
		</tr>
		</cfoutput>
	</table>
	<cfelse>
		<cfoutput>
        <cfset LB_SinReg = t.Translate('LB_SinReg','No se encontraron registros')>
		<div align="center"> ------------------------------------------- #LB_SinReg# -------------------------------------------</div>
 		</cfoutput>       
	</cfif>
	</body>
	</html>
</cfif>