<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 6-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
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
<cfif isdefined("url.recibo") and not isdefined("form.recibo")>
	<cfset form.recibo = url.recibo>
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

<cfif isdefined("url.HDid") and not isdefined("form.HDid")>
	<cfset form.HDid = url.HDid>
</cfif>
<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>
<cfif isdefined("url.CCTcodigoA") and not isdefined("form.CCTcodigoA")>
	<cfset form.CCTcodigoA = url.CCTcodigoA>
</cfif>


<cf_dbtemp name="temporalPRDP_v1" returnvariable="temporal" datasource="#session.dsn#">
	<cf_dbtempcol name="id"  			    type="numeric"   	identity="yes">
	<cf_dbtempcol name="HDid"	    type="numeric"   	mandatory="yes">
	<cf_dbtempcol name="Dtotal"				type="money"		mandatory="no">
	<cf_dbtempcol name="SaldoReciboPago"	type="money"		mandatory="no">
	<cf_dbtempcol name="MontoPagadoDelDoc"	type="money"		mandatory="no">
	
	<cf_dbtempcol name="MontoOrigen"		type="money"		mandatory="no">		
	<cf_dbtempcol name="MontoLocal"			type="money" 		mandatory="no">
	
	<cf_dbtempcol name="ref_pago"			type="char(2)"		mandatory="no">
	<cf_dbtempcol name="doc_pago"			type="char(20)"		mandatory="no">
	<cf_dbtempcol name="mon_pago"			type="numeric"		mandatory="no">
	<cf_dbtempcol name="Asiento_pago"		type="integer" 		mandatory="no">
	
	<cf_dbtempcol name="BMfecha"			type="datetime"		mandatory="no">
	<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
	<cf_dbtempcol name="Recibo" 			type="char(20)" 	mandatory="no">	
	<cf_dbtempcol name="SNcodigo"  			type="integer"	 	mandatory="no">
	<cf_dbtempcol name="SNnombre"  			type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="SNnumero"  			type="char(10)"	 	mandatory="no">
	<cf_dbtempcol name="SNidentificacion"	type="char(30)"	 	mandatory="no">		
	<cf_dbtempcol name="SNdireccion"  		type="varchar(255)"	mandatory="no">
	<cf_dbtempcol name="Cformato"  			type="char(100)"	mandatory="no">

	<cf_dbtempcol name="CCTcodigo"			type="char(2)" 		mandatory="no">	
	<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
	<cf_dbtempcol name="OficinaDoc"			type="char(10)"  	mandatory="no">
	<cf_dbtempcol name="OficinaPago"		type="char(10)"  	mandatory="no">
	<cf_dbtempcol name="Asiento"			type="integer" 		mandatory="no">
	<cf_dbtempcol name="TC"					type="float" 		mandatory="no">	
	<cf_dbtempcol name="Mcodigo"  			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="Mnombre"			type="varchar(80)" 	mandatory="no">
	<cf_dbtempkey cols="id">
</cf_dbtemp>
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfquery datasource="#session.DSN#">
	insert into #temporal# (
			HDid,
			Dtotal,
			SaldoReciboPago,
			MontoPagadoDelDoc,
	
			ref_pago,
			doc_pago, 
			mon_pago,  
			Asiento_pago,
			
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
			Asiento,
			TC, 
			CCTcodigo,
			Ecodigo,
			MontoOrigen,  
			MontoLocal,
			Mcodigo, 
			Mnombre)
	
	select 
			hd.HDid,
			bm.Dtotal,
			0 as  SaldoReciboPago,
			bm.BMmontoref as MontoPagadoDelDoc,
	
			bm.CCTRcodigo ref_pago, bm.DRdocumento as doc_pago, bm.Mcodigoref as mon_pago,  
			(select hh.Edocumento
			from BMovimientos bb
				inner join HEContables hh
					on hh.IDcontable = bb.IDcontable
			where bb.Ecodigo = bm.Ecodigo
				and bb.Ddocumento = bm.DRdocumento
				and bb.CCTcodigo = bm.CCTRcodigo
				and bb.SNcodigo = bm.SNcodigo

			) as asiento_pago,
			
			bm.BMfecha,
			bm.Dfecha as Fecha, 
			bm.Ddocumento as Recibo, 
	
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			coalesce (direccion1, direccion2, 'N/A') as direccion,
			o.Oficodigo as OficinaDoc,
			(select Oficodigo 
				from Oficinas ofic 
				where ofic.Ecodigo = bm.Ecodigo 
				and ofic.Ocodigo = bm.Ocodigo) 
				as OficinaPago,
			cc.Cformato as cuenta,  
			h.Edocumento as Asiento,
			bm.Dtipocambio as TC, 
			bm.CCTcodigo,
			bm.Ecodigo,
			bm.Dtotal as MontoOrigen,  
			(bm.Dtotal * bm.Dtipocambio) as MontoLocal,
			m.Mcodigo, 
			m.Mnombre
		from BMovimientos bm
			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
					and s.Ecodigo = bm.Ecodigo
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 
			inner join HEContables h
				on h.IDcontable = bm.IDcontable
				
			inner join HDocumentos hd
				on  hd.SNcodigo = bm.SNcodigo
				and hd.Ddocumento = bm.DRdocumento
				and hd.CCTcodigo = bm.CCTRcodigo
				and hd.Ecodigo = bm.Ecodigo
				and hd.Ocodigo = bm.Ocodigo
				
			inner join Oficinas o
				on  o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo
			
			left outer join SNDirecciones a 
				on a.id_direccion =hd.id_direccionFact

			left outer  join DireccionesSIF b
				on a.id_direccion = b.id_direccion

			inner join CContables cc
				on cc.Ccuenta = hd.Ccuenta

			inner join CCTransacciones be
				on be.CCTcodigo =bm.CCTcodigo
					and be.Ecodigo = bm.Ecodigo
					<!---and be.CCTpago = 1--->	
					and be.CCTcodigo = 'RE'				
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Recibo#">
		and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
		<cfif isdefined("url.CCTcodigoA") and len(trim(url.CCTcodigoA))>
			and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigoA#">
		<cfelseif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
			and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
		</cfif>
		
	union
		select 
			hd.HDid,
			bm.Dtotal,
			0 as  SaldoReciboPago,
			bm.BMmontoref as MontoPagadoDelDoc,
	
			bm.CCTRcodigo ref_pago, bm.DRdocumento as doc_pago, bm.Mcodigoref as mon_pago,  

			(select he.Edocumento
			from BMovimientos bc
				inner join EContables he
					on he.IDcontable = bc.IDcontable
			where bc.Ecodigo = bm.Ecodigo
				and bc.Ddocumento = bm.DRdocumento
				and bc.CCTcodigo = bm.CCTRcodigo
				and bc.SNcodigo = bm.SNcodigo

			) as asiento_pago,
			
			bm.BMfecha,
			bm.Dfecha as Fecha, 
			bm.Ddocumento as Recibo, 
	
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			coalesce (direccion1, direccion2, 'N/A') as direccion,
			o.Oficodigo as OficinaDoc,  
			(select Oficodigo 
				from Oficinas ofic 
				where ofic.Ecodigo = bm.Ecodigo 
				and ofic.Ocodigo = bm.Ocodigo) 
				as OficinaPago,
			cc.Cformato as cuenta,  
			h.Edocumento as Asiento,
			bm.Dtipocambio as TC, 
			bm.CCTcodigo,
			bm.Ecodigo,
			bm.Dtotal as MontoOrigen,  
			(bm.Dtotal * bm.Dtipocambio) as MontoLocal,
			m.Mcodigo, 
			m.Mnombre
		from BMovimientos bm
			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
					and s.Ecodigo = bm.Ecodigo
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 
			inner join EContables h
				on h.IDcontable = bm.IDcontable
				
			inner join HDocumentos hd
				on  hd.SNcodigo = bm.SNcodigo
				and hd.Ddocumento = bm.DRdocumento
				and hd.CCTcodigo = bm.CCTRcodigo
				and hd.Ocodigo = bm.Ocodigo
				and hd.Ecodigo = bm.Ecodigo

			inner join Oficinas o
				on  o.Ecodigo = hd.Ecodigo
				and o.Ocodigo = hd.Ocodigo
			
			left outer join SNDirecciones a 
				on a.id_direccion =hd.id_direccionFact

			left outer  join DireccionesSIF b
				on a.id_direccion = b.id_direccion

			inner join CContables cc
				on cc.Ccuenta = hd.Ccuenta

			inner join CCTransacciones be
				on be.CCTcodigo =bm.CCTcodigo
					and be.Ecodigo = bm.Ecodigo
					<!---and be.CCTpago = 1--->
					and be.CCTcodigo = 'RE'
	
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Recibo#">
		and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
		<cfif isdefined("url.CCTcodigoA") and len(trim(url.CCTcodigoA))>
			and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigoA#">
		<cfelseif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
			and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
		</cfif>
</cfquery>
<cfquery datasource="#session.DSN#">
	update #temporal#
	set MontoLocal = (select sum(#temporal#.MontoLocal) from #temporal#),
		MontoOrigen = (select sum(#temporal#.MontoOrigen) from #temporal#)
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
	<cfquery datasource="#session.DSN#">
		update #temporal#
		set SaldoReciboPago = 	
			<cfif rsid.id GT 1>
				(select b.SaldoReciboPago
				from #temporal# b
				where b.id = #rsid.id# -1)
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
			HDid,
			Dtotal,
			SaldoReciboPago,
			MontoPagadoDelDoc,
	
			ref_pago,
			doc_pago, 
			mon_pago, 
			Asiento_pago, 
			
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
			Asiento,
			TC, 
			CCTcodigo,
			Ecodigo,
			MontoOrigen,  
			MontoLocal,
			Mcodigo, 
			Mnombre
	from #temporal#
</cfquery>

<cfif url.formatos EQ 1 or url.formatos EQ 2>
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
    
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_FECHA = t.Translate('LB_FECHA','Fecha','/sif/generales.xml')>
<cfset LB_ConsPagReal = t.Translate('LB_ConsPagReal','Consulta de Pagos Realizados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_DetPago = t.Translate('LB_DetPago','Detalle del Pago')>
<cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Recibo = t.Translate('LB_Recibo','Recibo','/sif/cc/consultas/DocPagado_PagosRealizados_formCC.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Cuenta = t.Translate(' LB_Cuenta','Cuenta ','/sif/generales.xml')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&amp;oacute;n','/sif/generales.xml')>

<cfset LB_TC = t.Translate('LB_TC','TC','DocPagado_sqlCC.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','DocPagado_sqlCC.xml')>
<cfset LB_MontoLoc = t.Translate('LB_MontoLoc','Monto Local','DocPagado_sqlCC.xml')>
<cfset LB_MontoOr = t.Translate('LB_MontoOr','Monto Origen','DocPagado_sqlCC.xml')>
<cfset LB_Asiento = t.Translate('LB_Asiento','Asiento','DocPagado_sqlCC.xml')>
<cfset LB_PAGO = t.Translate('LB_PAGO','PAGO')>
<cfset LB_DOCPAGADOS = t.Translate('LB_DOCPAGADOS','DOCUMENTOS PAGADOS')>
<cfset LB_MonedaDoc = t.Translate('LB_MonedaDoc','Moneda Doc.')>
<cfset LB_TCDoc = t.Translate('LB_TCDoc','TC Doc.')>
<cfset LB_MontoPagadoDoc = t.Translate('LB_MontoPagadoDoc','Monto Pagado del Doc.')>
<cfset LB_SaldoReciboPago = t.Translate('LB_SaldoReciboPago','Saldo del Recibo de Pago')>

	<body>
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="9" align="right">
				<cfset params = "&formatos=#url.formatos#&SNcodigo=#url.SNcodigo#&FechaI=#url.FechaI#&FechaF=#url.FechaF#&LvarRecibo=#url.LvarRecibo#">
				<cfif isdefined("form.HDid") and len(trim(form.HDid))>
					<cfset params = params & '&HDid=#form.HDid#'>
				</cfif>
				
				<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
					<cfset params = params & '&CCTcodigo=#form.CCTcodigo#'>
				</cfif>
				<cfif isdefined("form.CCTcodigoA") and len(trim(form.CCTcodigoA))>
					<cfset params = params & '&CCTcodigo=#form.CCTcodigoA#'>
				</cfif>
				<cfif isdefined("url.LvarReciboB") and len(trim(url.LvarReciboB))>
					<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
				</cfif>
				<!--- <cfdump var="#params#"> --->
				
				<cfif isdefined("form.Pagos")>
					<cfset params = params & '&Pagos=#form.Pagos#'>
				</cfif>
				<cfset params2 ="">
				<cfset params2 = trim('&Recibo=#Recibo#&Fecha=#Fecha#&Asiento=#Asiento#&TC=#TC#&MontoOrigen=#MontoOrigen#&MontoLocal=#MontoLocal#')>
				 <!--- Aqui  agrego  el enviar a Excel --->				
				<cfif formatos EQ 2 >
					<cfset LvarFileName = "Cobro_#trim(url.recibo)#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
					<cfcontent type="application/vnd.ms-excel">
					<cfheader 	name="Content-Disposition" value="attachment;filename=#LvarFileName#">
					<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>	
				<cfelse>	
					<cf_rhimprime datos="/sif/cc/consultas/PagoRealizado_DetallePago_formCC.cfm" paramsuri="#params##params2#">
					<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>		
				</cfif>
			</td>
		</tr>
		<tr>	
			<td>&nbsp;</td>
			<td colspan="9" align="right" class="noprint">
					<cfset params3 = "">
					<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
						<cfset params3 = "&HDid=#rsReporte.HDid#">
					</cfif>
				<cfoutput>
					<a href="PagoRealizado_sqlCC.cfm?#params#">#LB_Regresar#</a> 
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
          <cfoutput>
		  <td colspan="7" align="center" class="niv2">#LB_ConsPagReal#</td>
		  <td colspan="2" class="niv4" align="right">#LB_USUARIO#:&nbsp;#session.Usulogin#</td>
          </cfoutput>
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
				<td align="left" style="font-weight:bold" class="niv3">#LB_PAGO#:</td>
				<td colspan="21">&nbsp;</td>
			</tr>
			</cfoutput>
			<cf_templatecss>
			<tr style="font-weight:bold">
			<cfoutput>
			  <td>&nbsp;</td>
			  <td nowrap="nowrap" class="niv3">#LB_Recibo#</td>
			  <td nowrap="nowrap" class="niv3">#LB_Moneda#</td>
			  <td nowrap="nowrap" class="niv3">#LB_Oficina#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_FECHA#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_Asiento#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_TC#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_MontoOr#</td>
			  <td nowrap="nowrap" align="right" class="niv3" colspan="22">#LB_MontoLoc#</td>
			</cfoutput>
			</tr>
			<cfoutput>
			<tr>
			  <td>&nbsp;</td>
			  <td class="niv3" nowrap="nowrap">#rsReporte.CCTcodigo# - #Recibo#</td>
			  <td class="niv3">#rsReporte.Mnombre#</td>
			  <td class="niv3">#rsReporte.OficinaPago#</td>
			  <td align="right" class="niv3" >#dateformat(Fecha,'dd/mm/yyyy')#</td>
			  <td align="right" class="niv3" >#Asiento#</td>
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
				<td colspan="11" align="left" style="font-weight:bold; width:1%"   nowrap="nowrap" class="niv3">#LB_DOCPAGADOS#:</td>
				</cfoutput>
			</tr>
			<cfoutput query="rsReporte" group="Mcodigo">
			<tr style="font-weight:bold">
			  <td style="width:7.5%">&nbsp;</td>
			  <td nowrap="nowrap" class="niv3" style="width:1%">#LB_Documento#</td>
			  <td nowrap="nowrap" class="niv3" style="width:1%">#LB_Asiento#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Cuenta#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Direccion#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_Oficina#</td>
			  <td nowrap="nowrap" align="left" class="niv3">#LB_MonedaDoc#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_TCDoc#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_MontoPagadoDoc#</td>
			  <td nowrap="nowrap" align="right" class="niv3">#LB_SaldoReciboPago#</td>
			</tr>
			<cfoutput>
				<cfset LvarListaNon = (CurrentRow MOD 2)>
				<cfquery name="rsMonedasDet" datasource="#session.DSN#">
					select Mnombre
					from Monedas 
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mon_pago#"><!--- Moneda del pago (del detalle por documento). --->
				</cfquery>
				<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					<cfset params3 = params3 & "&doc_pago=#rsReporte.doc_pago#">
					<cfset params3 = params3 & "&ref_pago=#rsReporte.ref_pago#">
				  <td>&nbsp;</td>
				  <td class="niv4" nowrap="nowrap"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#ref_pago# - #doc_pago#</a></td>
				  <td class="niv4" nowrap="nowrap"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#Asiento_pago#</a></td>
				  <td class="niv4"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#Cformato#</a></td>
				  <td class="niv4"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#SNdireccion#</a></td>
				  <td class="niv4"><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#OficinaDoc#</a></td>
				  <td align="left" class="niv4" ><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#rsMonedasDet.Mnombre#</a></td>
				  <td align="right" class="niv4" ><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#NumberFormat(TC,'_,_.__')#</a></td>					  
				  <td align="right" class="niv4" ><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#NumberFormat(MontoPagadoDelDoc,'_,_.__')#</a></td>					  
				  <td align="right" class="niv4" ><a href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1&HDid_pago=#rsReporte.HDid##params##params2##params3#">#NumberFormat(SaldoReciboPago,'_,_.__')#</a></td>
				</tr>

			</cfoutput>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>
		</cfoutput>		
		<tr>
			<td colspan="22" align="center" class="niv3">
            	<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta')>
				<cfoutput>
				------------------------------------------- #LB_FinCons# -------------------------------------------
				</cfoutput>
            </td>
		</tr>
	</table>
	<script language="javascript" type="text/javascript">
		<cfoutput>
			function Detallado(LvarFecha,LvarAsiento,LvarRecibo){
				var LvarFecha1 = LvarFecha;
				var LvarAsiento1 = LvarAsiento;
				var LvarRecibo1 = LvarRecibo;
				
				
				/*document.form1.action="PagoRealizado_DetallePago_url.cfm?fecha=LvarFecha1&asiento=LvarAsiento1&recibo=LvarRecibo1";
				document.form1.submit();*/
			}
		</cfoutput>
	</script>
	<cfelse>
        <cfset LB_SinReg = t.Translate('LB_SinReg','No se encontraron registros')>
		<cfoutput>
		<div align="center"> ------------------------------------------- #LB_SinReg# -------------------------------------------</div>
		
		</cfoutput>
	</cfif>
	</body>
	</html>
</cfif>