<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 6-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset BTN_Regresar = t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_CosnsPago = t.Translate('LB_CosnsPago','Consulta de Pagos Realizados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_DetPago 	= t.Translate('LB_DetPago','Detalle del Pago')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset LB_Codigo 	= t.Translate('LB_Codigo','Codigo','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_Pago	= t.Translate('LB_Pago','PAGO')>
<cfset LB_Recibo	= t.Translate('LB_Recibo','Recibo')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_TC	= t.Translate('LB_TC','TC')>
<cfset LB_Asiento	= t.Translate('LB_Asiento','Asiento')>
<cfset LB_MontoOr	= t.Translate('LB_MontoOr','Monto Origen')>
<cfset LB_MontoLoc	= t.Translate('LB_MontoLoc','Monto Local')>
<cfset LB_DOCPAG	= t.Translate('LB_DOCPAG','DOCUMENTOS PAGADOS')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_OrdCmpr	= t.Translate('LB_OrdCmpr','Orden Compra')>
<cfset LB_Cuenta 	= t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&oacute;n','/sif/generales.xml')>
<cfset LB_Pagado	= t.Translate('LB_Pagado','Pagado')>
<cfset LB_SaldoPag	= t.Translate('LB_SaldoPag','Saldo Recibo')>

<cfif isdefined("url.Pagos") and not isdefined("form.Pagos")>
	<cfset form.Pagos = url.Pagos>
	<cfset url.recibo = "">
	<cfif isdefined('url.LvarRecibo')>
		<cfset url.recibo = url.LvarRecibo>
	</cfif>
</cfif>

<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
	<cfset form.formatos = url.formatos>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfif isdefined("url.LvarRecibo") and len(trim(url.LvarRecibo)) and not isdefined("form.LvarRecibo")>
	<cfset form.LvarRecibo = url.LvarRecibo>
</cfif>

<cfif isdefined("url.LvarReciboB") and len(trim(url.LvarReciboB)) and not isdefined("form.LvarReciboB")>
	<cfset form.LvarRecibo = url.LvarReciboB>
</cfif>

<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>
<cfif isdefined("url.CPTcodigo") and not isdefined("form.CPTcodigo")>
	<cfset form.CPTcodigo = url.CPTcodigo>
</cfif>
<cfif isdefined("url.CPTcodigoA") and not isdefined("form.CPTcodigoA")>
	<cfset form.CPTcodigoA = url.CPTcodigoA>
</cfif>

<cf_dbtemp name="temporal_v1" returnvariable="temporal" datasource="#session.dsn#">
	<cf_dbtempcol name="id"  			    type="numeric"   	identity="yes">
	<cf_dbtempcol name="IDdocumento"	    type="numeric"   	mandatory="no">
	<cf_dbtempcol name="Dtotal"				type="money"		mandatory="no">
	<cf_dbtempcol name="SaldoReciboPago"	type="money"		mandatory="no">
	<cf_dbtempcol name="MontoPagadoDelDoc"	type="money"		mandatory="no">
	
	<cf_dbtempcol name="MontoOrigen"		type="money"		mandatory="no">		
	<cf_dbtempcol name="MontoLocal"			type="money" 		mandatory="no">
	
	<cf_dbtempcol name="ref_pago"			type="char(2)"		mandatory="no">
	<cf_dbtempcol name="doc_pago"			type="char(20)"		mandatory="no">
	<cf_dbtempcol name="mon_pago"			type="numeric"		mandatory="no">
	<cf_dbtempcol name="IDcontablePago"		type="numeric"		mandatory="no">
	<cf_dbtempcol name="Lote_pago"			type="integer" 		mandatory="no">
	<cf_dbtempcol name="Asiento_pago"		type="integer" 		mandatory="no">
	<cf_dbtempcol name="Orden_compra"		type="integer" 		mandatory="no">
	
	<cf_dbtempcol name="BMfecha"			type="datetime"		mandatory="no">
	<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
	<cf_dbtempcol name="Recibo" 			type="char(20)" 	mandatory="no">	
	<cf_dbtempcol name="SNcodigo"  			type="integer"	 	mandatory="no">
	<cf_dbtempcol name="SNnombre"  			type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="SNnumero"  			type="char(10)"	 	mandatory="no">
	<cf_dbtempcol name="SNidentificacion"	type="char(30)"	 	mandatory="no">		
	<cf_dbtempcol name="id_direccion"		type="numeric"		mandatory="no">
	<cf_dbtempcol name="SNdireccion"  		type="varchar(255)"	mandatory="no">
	<cf_dbtempcol name="Cformato"  			type="char(100)"	mandatory="no">

	<cf_dbtempcol name="CPTcodigo"			type="char(2)" 		mandatory="no">	
	<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
	<cf_dbtempcol name="OficinaDoc"			type="char(10)"  	mandatory="no">
	<cf_dbtempcol name="OficinaPago"		type="char(10)"  	mandatory="no">
	<cf_dbtempcol name="IDcontable"			type="numeric"		mandatory="no">
	<cf_dbtempcol name="Lote"				type="integer" 		mandatory="no">
	<cf_dbtempcol name="Asiento"			type="integer" 		mandatory="no">
	<cf_dbtempcol name="TC"					type="float" 		mandatory="no">	
	<cf_dbtempcol name="Mcodigo"  			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="Mnombre"			type="varchar(80)" 	mandatory="no">
	<cf_dbtempkey cols="id">
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #temporal# (
			IDdocumento,
			Dtotal,
			SaldoReciboPago,
			MontoPagadoDelDoc,
	
			ref_pago,
			doc_pago, 
			mon_pago,  
			IDcontablePago,
			IDcontable,  
			Orden_compra,
			
			BMfecha,
			Fecha, 
			Recibo, 
			SNcodigo, 
			SNnombre, 
			SNnumero, 
			SNidentificacion, 
			id_direccion,
		
			OficinaDoc,
			OficinaPago,  
			Cformato,
			TC, 
			CPTcodigo,
			Ecodigo,
			MontoOrigen,  
			MontoLocal,
			Mcodigo, 
			Mnombre)
	
	select 
			hd.IDdocumento,
			bm.Dtotal,
			0 as  SaldoReciboPago,
			bm.Dtotal as MontoPagadoDelDoc,
	
			bm.CPTRcodigo ref_pago, 
			bm.DRdocumento as doc_pago, 
			bm.Mcodigoref as mon_pago,  

			(
				select min(bc.IDcontable)
				from BMovimientosCxP bc
				where bc.Ecodigo     = bm.Ecodigo
				and   bc.Ddocumento  = bm.DRdocumento
				and   bc.CPTcodigo   = bm.CPTRcodigo
				and   bc.SNcodigo    = bm.SNcodigo
				and   bc.CPTRcodigo  = bm.CPTRcodigo
				and   bc.DRdocumento = bm.DRdocumento
			) as IDcontablePago,

			bm.IDcontable as IDcontable,
				
			(
				select min(eo.EOnumero)
				from HDDocumentosCP hdd 		<cf_dbforceindex name="HDDocumentosCP_FK1">
					inner join DOrdenCM do 		<cf_dbforceindex name="PK_DORDENCM">
						inner join EOrdenCM eo 	<cf_dbforceindex name="PK_EORDENCM">
						on eo.EOidorden = do.EOidorden
					on do.DOlinea = hdd.DOlinea
				where hdd.IDdocumento = hd.IDdocumento
			) as Orden_compra,
			
			bm.BMfecha,
			bm.Dfecha as Fecha, 
			bm.Ddocumento as Recibo, 
	
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			hd.id_direccion as id_direccion,
			
			coalesce((select min(o.Oficodigo)
				from Oficinas o
				where o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo
				), 'N/A') as OficinaDoc,
				

			(select min(Oficodigo)
				from Oficinas ofic 
				where ofic.Ecodigo = bm.Ecodigo 
				and ofic.Ocodigo = bm.Ocodigo) 
				as OficinaPago,
			
			coalesce((select min(cc.Cformato)
						from CContables cc
						where cc.Ccuenta = hd.Ccuenta
					), 'N/A')as cuenta,

									
			bm.Dtipocambio as TC, 
			bm.CPTcodigo,
			bm.Ecodigo,
			bm.Dtotal as MontoOrigen,  
			(bm.Dtotal * bm.Dtipocambio) as MontoLocal,
			m.Mcodigo, 
			m.Miso4217 as Mnombre
		from BMovimientosCxP bm
			inner join CPTransacciones be
			on be.CPTcodigo =bm.CPTcodigo
			and be.Ecodigo = bm.Ecodigo
			and be.CPTpago = 1

			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
				and s.Ecodigo = bm.Ecodigo

			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 

			left outer join HEDocumentosCP hd
			on  hd.SNcodigo = bm.SNcodigo
			and hd.Ddocumento = bm.DRdocumento
			and hd.CPTcodigo = bm.CPTRcodigo
			and hd.Ecodigo = bm.Ecodigo
			and hd.Ocodigo = bm.Ocodigo
		where bm.Ecodigo = #session.Ecodigo#
		and bm.Ddocumento = '#url.Recibo#'
		and bm.SNcodigo = #url.SNcodigo#
		<cfif isdefined("url.CPTcodigoA") and len(trim(url.CPTcodigoA))>
			and bm.CPTcodigo = '#url.CPTcodigoA#'
		<cfelseif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
			and bm.CPTcodigo = '#url.CPTcodigo#'
		</cfif>
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
	set MontoLocal = (select sum(#temporal#.MontoLocal) from #temporal#),
		MontoOrigen = (select sum(#temporal#.MontoOrigen) from #temporal#)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
	set 
		Lote_pago = (select min(he.Cconcepto) from HEContables he where he.IDcontable = #temporal#.IDcontablePago),
		Asiento_pago = (select min(he.Edocumento) from HEContables he where he.IDcontable = #temporal#.IDcontablePago),
		Lote = (select min(he.Cconcepto) from HEContables he where he.IDcontable = #temporal#.IDcontable),
		Asiento = (select min(he.Edocumento) from HEContables he where he.IDcontable = #temporal#.IDcontable)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
	set 
		Lote_pago = (select min(e.Cconcepto) from EContables e where e.IDcontable = #temporal#.IDcontablePago),
		Asiento_pago = (select min(e.Edocumento) from EContables e where e.IDcontable = #temporal#.IDcontablePago)
	where (Lote_pago is null or Asiento_pago is null)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
	set 
		Lote = (select min(e.Cconcepto) from EContables e where e.IDcontable = #temporal#.IDcontable),
		Asiento = (select min(e.Edocumento) from EContables e where e.IDcontable = #temporal#.IDcontable)
	where (Lote is null or Asiento is null)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
	set 
		SNdireccion = coalesce((
			select min(coalesce(direccion1, direccion2, 'N/A'))
			from SNDirecciones a 
						inner join DireccionesSIF b
						on b.id_direccion = a.id_direccion
			where a.id_direccion = #temporal#.id_direccion),'N/A')
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
	set SaldoReciboPago = (select b.MontoLocal
							from #temporal# b
							where b.id = 1)
</cfquery>

<cfquery name="rsid" datasource="#session.DSN#">
	select id from #temporal#
</cfquery>

<cfoutput query="rsid">
	<cfif rsid.id GT 1>
		<cfquery name="SRPago" datasource="#session.DSN#">
			select b.SaldoReciboPago as valor
			   from #temporal# b
			where b.id = #rsid.id# -1
		</cfquery>
	</cfif>
	<cfquery datasource="#session.DSN#">
		update #temporal#
		set SaldoReciboPago = 	
			<cfif rsid.id GT 1>
				#SRPago.valor#
			<cfelse>
				#temporal#.SaldoReciboPago 
			</cfif>
			- #temporal#.MontoPagadoDelDoc
		where #temporal#.id >= #rsid.id#
	</cfquery>
</cfoutput>
	
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
			id,
			IDdocumento,
			Dtotal,
			SaldoReciboPago,
			MontoPagadoDelDoc,
	
			ref_pago,
			doc_pago, 
			mon_pago,
			Lote_pago,
			Asiento_pago, 
			Orden_compra,
			
			BMfecha,
			Fecha, 
			Recibo, 
			SNcodigo, 
			SNnombre, 
			SNnumero, 
			SNidentificacion, 
			SNdireccion,
		
			OficinaDoc,
			OficinaPago,  
			Cformato,  
			Lote,
			Asiento,
			TC, 
			CPTcodigo,
			Ecodigo,
			MontoOrigen,  
			MontoLocal,
			Mcodigo, 
			Mnombre
	from #temporal#
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

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="9" align="right">
				<cfset params = "&formatos=1&SNcodigo=#url.SNcodigo#&FechaI=#url.FechaI#&FechaF=#url.FechaF#&LvarRecibo=#url.LvarRecibo#">
				<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento))>
					<cfset params = params & '&IDdocumento=#form.IDdocumento#'>
				</cfif>
				
				<cfif isdefined("form.CPTcodigo") and len(trim(form.CPTcodigo))>
					<cfset params = params & '&CPTcodigo=#form.CPTcodigo#'>
				</cfif>
				<cfif isdefined("form.CPTcodigoA") and len(trim(form.CPTcodigoA))>
					<cfset params = params & '&CPTcodigoA=#form.CPTcodigoA#'>
				</cfif>
				<cfif isdefined("url.LvarReciboB") and len(trim(url.LvarReciboB))>
					<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
				</cfif>
				<cfif isdefined("form.Pagos")>
					<cfset params = params & '&Pagos=#form.Pagos#'>
				</cfif>
				<cfset params2 ="">
				<cfset params2 = trim('&Recibo=#Recibo#&Fecha=#Fecha#&Asiento=#Asiento#&TC=#TC#&MontoOrigen=#MontoOrigen#&MontoLocal=#MontoLocal#')>
				<cf_rhimprime datos="/sif/cp/consultas/PagoRealizado_DetallePago_form.cfm" paramsuri="#params##params2#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>	
			<td>&nbsp;</td>
			<td colspan="9" align="right" class="noprint">
					<cfset params3 = "">
				<cfoutput>
					<a href="PagoRealizado_sql.cfm?#params#">#BTN_Regresar#</a> 
				</cfoutput>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="7" class="niv4" align="right"><cfoutput>#LB_Fecha#:&nbsp;#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2"><cfoutput>#LB_CosnsPago#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right"><cfoutput>#LB_USUARIO#:&nbsp;#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2"><cfoutput>#LB_DetPago#</cfoutput></td>
		  <td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="7" class="niv3"><cfoutput>#LB_Fecha_Desde#:&nbsp;#lsdateformat(url.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="7" class="niv3"><cfoutput>#LB_Fecha_Hasta#:&nbsp;#lsdateformat(url.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
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
			  <td colspan="10">&nbsp;</td>
			</tr>
			<tr bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporte.SNnumero#</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#trim(rsReporte.SNnombre)#</td>
			  <td nowrap="nowrap" class="niv3" align="right" colspan="1">#rsReporte.SNidentificacion#</td>
			  <td colspan="10">&nbsp;</td>
			</tr>
			<tr bgcolor="E7E7E7">
				<td align="left" style="font-weight:bold" class="niv3">#LB_Pago#:</td>
				<td colspan="21">&nbsp;</td>
			</tr>
			</cfoutput>
			<cf_templatecss>
            <cfoutput>
			<tr style="font-weight:bold">
			  <td>&nbsp;</td>
			  <td nowrap="nowrap" class="niv3">#LB_Recibo#</td>
			  <td nowrap="nowrap" class="niv3">#LB_Moneda#</td>
			  <td nowrap="nowrap" class="niv3">#LB_Oficina#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_Fecha#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_Asiento#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_TC#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_MontoOr#</td>
			  <td nowrap="nowrap" align="right" class="niv3" colspan="22">#LB_MontoLoc#</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td class="niv3" nowrap="nowrap">#rsReporte.CPTcodigo# - #Recibo#</td>
			  <td class="niv3">#rsReporte.Mnombre#</td>
			  <td class="niv3">#rsReporte.OficinaPago#</td>
			  <td align="right" class="niv3" >#dateformat(Fecha,'dd/mm/yyyy')#</td>
			  <td align="right" class="niv3" >#rsReporte.Lote#-#rsReporte.Asiento#</td>
			  <td align="right" class="niv3" >#NumberFormat(TC,'_,_.__')#</td>
			  <td align="right" class="niv3" >#NumberFormat(MontoOrigen,'_,_.__')#</td>
			  <td align="right" class="niv3" colspan="22">#NumberFormat(MontoLocal,'_,_.__')#</td>
			</tr>
			</cfoutput>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
		</table>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
			<tr bgcolor="E7E7E7">
			<cfoutput>
				<td colspan="11" align="left" style="font-weight:bold; width:1%"   nowrap="nowrap" class="niv3">#LB_DOCPAG#:</td>
			</cfoutput>
			</tr>
			<cfoutput query="rsReporte" group="Mcodigo">
			<tr style="font-weight:bold">
			  <td style="width:7.5%">&nbsp;</td>
			  <td nowrap="nowrap" class="niv3" style="width:1%">#LB_Documento#</td>
			  <td nowrap="nowrap" class="niv3" style="width:1%">#LB_Asiento#</td>
			  <td nowrap="nowrap" class="niv3" style="width:1%">#LB_OrdCmpr#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Cuenta#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Direccion#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Oficina#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Moneda#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_TC#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_Pagado#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_SaldoPag#</td>
			</tr>
			
			<cfoutput>
				<cfset LvarListaNon = (CurrentRow MOD 2)>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					  <cfset params4 = "&doc_pago=#rsReporte.doc_pago#">
					  <cfset params5 = "&ref_pago=#rsReporte.ref_pago#">

					  <td>&nbsp;</td>
					  <td class="niv4" nowrap="nowrap"><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#ref_pago# - #doc_pago#</a></td>
					  <td class="niv4" nowrap="nowrap"><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#Lote_pago#-#Asiento_pago#</a></td>
					  <td class="niv4" nowrap="nowrap"><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#Orden_compra#</a></td>
					  <td class="niv4"><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#Cformato#</a></td>
					  <td class="niv4"><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#SNdireccion#</a></td>
					  <td class="niv4"><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#OficinaDoc#</a></td>
					  <td align="left" class="niv4" ><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#Mnombre#</a></td>
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#NumberFormat(TC,'_,_.__')#</a></td>					  
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#NumberFormat(MontoPagadoDelDoc,'_,_.__')#</a></td>					  
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetalleDocumento_form.cfm?1=1&IDdocumento_pago=#rsReporte.IDdocumento##params##params2##params3##params4##params5#">#NumberFormat(SaldoReciboPago,'_,_.__')#</a></td>
				</tr>

			</cfoutput>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
		
		<tr>
        	<cfset MSG_FinCons 	= t.Translate('MSG_FinCons','Fin de la Consulta')>
			<td colspan="22" align="center" class="niv3">
				------------------------------------------- #MSG_FinCons# -------------------------------------------
			</td>
		</tr>
		</cfoutput>
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