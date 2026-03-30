<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 20-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->

<cfif isdefined("url.LvarReciboB") and len(trim("url.LvarReciboB"))>
	<cfset url.recibo = url.LvarReciboB>
</cfif>
<cfif isdefined("url.Pagos") and url.Pagos EQ 1>
	<cfset url.LvarRecibo = "">
</cfif>
<cfif isdefined("url.LvarReciboB") and len(trim("url.LvarReciboB"))>
	<cfset url.LvarRecibo = url.LvarReciboB>
</cfif>

<cfquery name="rsReporteEnc" datasource="#session.DSN#">
	select 
		m.Mcodigo as Mcodigo, 
		s.SNcodigo as SNcodigo, 
		he.IDdocumento as IDdocumento,
		he.Ddocumento as Recibo, 
		he.CPTcodigo as CPTcodigo,
		he.Dfecha as Fecha, 

		sum(he.Dtotal) as MontoOrigen,
		sum(he.Dtotal * he.Dtipocambio) as MontoLocal,
		min(he.Dtipocambio) as TC,
		min(m.Mnombre) as Mnombre,
		min(s.SNnombre) as SNnombre, 
		min(substring(s.SNnumero,1,9)) as SNnumero, 
		min(s.SNidentificacion) as SNidentificacion, 
		min(he.Ecodigo) as Ecodigo,
		min(he.EDusuario) EDusuario,
		min(o.Oficodigo) as Oficina,
		
		min(coalesce(ee.Cconcepto,e.Cconcepto)) as Lote,
		min(coalesce(ee.Edocumento,e.Edocumento)) as Asiento,
		
		min( coalesce(ed.EDsaldo, 0.00) ) as EDsaldo,
		min( coalesce (ds.direccion1, ds.direccion2, 'N/A') ) as direccion
	from HEDocumentosCP he
		inner join SNegocios s
			on s.SNcodigo = he.SNcodigo
				and s.Ecodigo = he.Ecodigo
		left outer join SNDirecciones sd
				inner join DireccionesSIF ds
				on ds.id_direccion = sd.id_direccion
			on sd.id_direccion = he.id_direccion
			and sd.SNid = s.SNid
		inner join Monedas m
			on m.Mcodigo = he.Mcodigo 
		inner join Oficinas o
			on o.Ecodigo = he.Ecodigo
			and o.Ocodigo = he.Ocodigo
		left outer join BMovimientosCxP bm
			on bm.SNcodigo = he.SNcodigo
			  and bm.Ddocumento = he.Ddocumento
			  and bm.CPTcodigo = he.CPTcodigo
			  and bm.Ecodigo = he.Ecodigo
			  and bm.CPTRcodigo = he.CPTcodigo
			  and bm.DRdocumento = he.Ddocumento
		left outer join HEContables ee
			on ee.IDcontable = bm.IDcontable
		left outer join EContables e
			on e.IDcontable = bm.IDcontable
		  
		inner join CPTransacciones b
			on b.Ecodigo = he.Ecodigo
				and b.CPTcodigo =he.CPTcodigo
		<cfif isdefined("url.chk_DocSaldo")>
			inner 
		<cfelse>
			left outer
		</cfif>
			join EDocumentosCP ed
				on ed.IDdocumento = he.IDdocumento
	where 
		he.IDdocumento = #url.IDdocumento#
		and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and he.Dfecha between #lsparsedatetime(url.FechaI)# and #lsparsedatetime(url.FechaF)#
		<cfif isdefined("url.LvarRecibo") and len(Trim(url.LvarRecibo))>
			and he.Ddocumento like '%#url.LvarRecibo#%'
		</cfif>
		and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">

		group by 
			 m.Mcodigo,
			 s.SNcodigo, 
			 he.IDdocumento, 
			 he.Ddocumento, 
			 he.CPTcodigo,
			 he.Dfecha
</cfquery>

<cfquery name="rsReporteDet" datasource="#session.DSN#">
	select 
		bm.Ddocumento as Recibo,
		bm.Dfecha,
		bm.Mcodigo,
		bm.BMmontoref,
		bm.CPTcodigo,

		min(coalesce(ec.Cconcepto,eec.Cconcepto)) as LoteDet,
		min(coalesce(ec.Edocumento,eec.Edocumento)) as Asiento,
		
		min(bm.Dtipocambio) as Dtipocambio,
		sum(coalesce(bm.Dtotal, 0)) as MontoOrigen,
		sum(coalesce(bm.Dtotal * bm.Dtipocambio, 0)) as MontoLocal,
		
		min(cc.Cformato) as CuentaDelDetalle,

		min(m.Mnombre) as Mnombre

	from BMovimientosCxP  bm
		inner join Monedas m
			on m.Mcodigo = bm.Mcodigo
	left outer join EContables ec
		on ec.IDcontable = bm.IDcontable
	left outer join HEContables eec
		on eec.IDcontable = bm.IDcontable
	left outer join CContables cc
		on cc.Ccuenta = bm.Ccuenta
	where 
		bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and bm.CPTcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPTcodigo#">
		and bm.Ddocumento <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.Recibo#">
		and bm.CPTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" maxlength="2" value="#url.CPTcodigo#">
		and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#url.Recibo#">
		and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
	group by 
		bm.Ddocumento,
		bm.Dfecha,
		bm.Mcodigo,
		bm.BMmontoref,
		bm.CPTcodigo

	order by bm.Mcodigo, bm.Dfecha, bm.CPTcodigo, bm.Ddocumento
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Regresar 	= t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_ConsPago 	= t.Translate('LB_ConsPago','Consulta de Pagos Realizados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset Lbl_Codigo 	= t.Translate('LB_Codigo','Codigo','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_LoteAs	= t.Translate('LB_LoteAs','Lote/Asiento')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_OC	= t.Translate('LB_OC','OC')>
<cfset LB_TC	= t.Translate('LB_TC','TC')>
<cfset LB_MontoOr	= t.Translate('LB_MontoOr','Monto Origen')>
<cfset LB_MontoLoc	= t.Translate('LB_MontoLoc','Monto Local')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_Saldo	= t.Translate('LB_Saldo','Saldo')>
<cfset LB_PagReal	= t.Translate('LB_PagReal','Pagos Realizados')>
<cfset LB_Recibo	= t.Translate('LB_Recibo','Recibo')>
<cfset LB_Cuenta 	= t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_Asiento	= t.Translate('LB_Asiento','Asiento')>
<cfset LB_MontDoc	= t.Translate('LB_MontDoc','Monto del Doc.')>

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
				<cfset params = "&formatos=1&SNcodigo=#url.SNcodigo#&FechaI=#url.FechaI#&FechaF=#url.FechaF#&LvarRecibo=#url.LvarRecibo#&CPTcodigo=#url.CPTcodigo#&IDdocumento=#url.IDdocumento#">
				<cfif isdefined("url.chk_DocSaldo")>
					<cfset params = params & "&chk_DocSaldo=#url.chk_DocSaldo#">
				</cfif>
				<cfif isdefined("url.Recibo")>
					<cfset params = params & "&Recibo=#url.Recibo#">
				</cfif>
				<cf_rhimprime datos="/sif/cp/consultas/DocPagado_PagosRealizados_form.cfm" paramsuri="#params#">
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
					<a href="DocPagado_sql.cfm?1=1#params#">#LB_Regresar#</a> 
				</cfoutput>
			</td>
		</tr>
		<cfoutput>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="7" class="niv4" align="right">#LB_Fecha#:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2">#LB_ConsPago#</td>
		  <td colspan="4" class="niv4" align="right">#LB_USUARIO#:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="7" class="niv3">#LB_Fecha_Desde#:&nbsp;<cfoutput>#lsdateformat(url.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="7" class="niv3">#LB_Fecha_Hasta#:&nbsp;<cfoutput>#lsdateformat(url.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>  
		</cfoutput>
			<cfoutput>	
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#Lbl_Codigo#:</td>
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
			</cfoutput>
			<cf_templatecss>
			<tr style="font-weight:bold">
			<cfoutput>
				  <td nowrap="nowrap" class="niv4" style="width:17%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Documento#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Direccion#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Oficina#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Fecha#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_LoteAs#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Moneda#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_OC#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_USUARIO#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#TC#</td>
				  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">#LB_MontoOr#</td>
				  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">#LB_MontoLoc#</td>
				  <td nowrap="nowrap" align="right" class="niv4" style="width:1%"colspan="19">#LB_Saldo#</td>
			</cfoutput>
				</tr>
			<cfoutput>
				<cfquery name="rsOC" datasource="#session.DSN#">
					select eo.EOnumero
					from DOrdenCM do
						inner join EOrdenCM eo
							on eo.EOidorden = do.EOidorden
					where do.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and do.DOlinea in (select hdd.DOlinea 
											from HDDocumentosCP hdd
											where hdd.IDdocumento =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdocumento#">
										   )
				</cfquery>
				<tr>
				  <td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#rsReporteEnc.CPTcodigo# - #rsReporteEnc.Recibo#</a></td>
				  <td style="width:1%" nowrap><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#trim(rsReporteEnc.direccion)#</a></td>
				  <td><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#rsReporteEnc.Oficina#</a></td>
				  <td align="left"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#dateformat(rsReporteEnc.Fecha,'dd/mm/yyyy')#</a></td>
				  <td align="left"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#rsReporteEnc.Lote# - #rsReporteEnc.Asiento#</a></td>
				  <td align="left"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#rsReporteEnc.Mnombre#</a></td>
				  
				  <td align="left"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#rsOC.EOnumero#</a></td>
				  <td align="left"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#rsReporteEnc.EDusuario#</a></td>
				  
				  <td align="right"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.TC,'_,_.__')#</a></td>
				  <td align="right"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.MontoOrigen,'_,_.__')#</a></td>
				  <td align="right"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.MontoLocal,'_,_.__')#</a></td>
				  <td align="right" colspan="19"><a href="PagoRealizado_DetalleDocumento_form.cfm?Pagos=2&doc_pago=#recibo#&IDdocumento_pago=#url.IDdocumento##params##params2##params3#" class="niv4">#NumberFormat(rsReporteEnc.EDsaldo,'_,_.__')#</a></td>
				</tr>
			</cfoutput>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
		</table>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
			<tr bgcolor="E7E7E7">
				<td colspan="9" align="left" style="font-weight:bold; width:1%"   nowrap="nowrap" class="niv3"><cfoutput>#LB_PagReal#:</cfoutput></td>
			</tr>
			<cfflush interval="128">
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
				  <td nowrap="nowrap" align="left" class="niv3" style="width:1%">#LB_Fecha#</td>
				  <td nowrap="nowrap" align="left" class="niv3" style="width:1%">#LB_Asiento#</td>
				  <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#TC#</td>
				  <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_MontoOr#</td>
				  <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_MontoLoc#</td>
				  <td nowrap="nowrap" align="right" class="niv3" style="width:1%">#LB_MontDoc#</td>
				</tr>
			<cfoutput>
				<cfset LvarListaNon = (CurrentRow MOD 2)>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
				  <td>&nbsp;</td>
				  <td nowrap="nowrap"><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2##params3#" class="niv4">#CPTcodigo# - #Recibo#</a></td>
				  <td nowrap="nowrap"><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#CuentaDelDetalle#</a></td>				  
				  <td><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#dateformat(Dfecha, 'dd/mm/yyyy')#</a></td>
				  <td><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#LoteDet# - #Asiento#</a></td>
				  <td align="right"><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#NumberFormat(Dtipocambio,'_,_.__')#</a></td>
				  <td align="right"><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#NumberFormat(MontoOrigen,'_,_.__')#</a></td>
				  <td align="right"><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#NumberFormat(MontoLocal,'_,_.__')#</a></td>
				  <td align="right"><a href="PagoRealizado_sql.cfm?Pagos=1&doc_pago=#recibo##params##params2#" class="niv4">#NumberFormat(BMmontoref,'_,_.__')#</a></td>	
	  			</tr>

				<cfset TotalMontoOrigen = TotalMontoOrigen + MontoOrigen>
				<cfset TotalMontoLocal = TotalMontoLocal + MontoLocal>
			</cfoutput>
		 <tr>
			<td>&nbsp;</td>
			<td class="niv3" colspan="4" style="font-weight:bold">#LB_Total#:&nbsp;</td>
			<td>&nbsp;</td>
			<td class="niv3" align="right" style="font-weight:bold">#NumberFormat(TotalMontoOrigen,'_,_.__')#</td>
			<td class="niv3" align="right" style="font-weight:bold" colspan="1">#NumberFormat(TotalMontoLocal,'_,_.__')#</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
		</cfoutput>
		<cfif isdefined("rsReporteDet") and rsReporteDet.recordcount eq 0>
			<tr>
				<td colspan="22" align="center" class="niv3">
					<cfset Msg_NoPagosaDocto	= t.Translate('Msg_NoPagosaDocto','No se han hecho pagos a este documento')>
						 <strong>#Msg_NoPagosaDocto#</strong>
				</td>
			</tr>
		</cfif>
		
		<tr>
			<cfoutput>
			<td colspan="22" align="center" class="niv3">
					<cfset MSG_FinCons 	= t.Translate('MSG_FinCons','Fin de la Consulta')>
				------------------------------------------- #MSG_FinCons# -------------------------------------------
			</td>
			</cfoutput>
		</tr>
	</table>
	<cfelse>
		<cfoutput>
		<cfset MSG_SinReg 	= t.Translate('MSG_SinReg','No se encontraron registros')>
		<div align="center"> ------------------------------------------- #MSG_SinReg# -------------------------------------------</div>
		</cfoutput>
    </cfif>
	</body>
	</html>
</cfif>
