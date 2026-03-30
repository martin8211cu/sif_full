<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 6-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->


<!--- <cfdump var="#form#">
<cf_dump var="#url#"> ---> 
 
<cfif isdefined("url.Pagos") and not isdefined("form.Pagos")>
	<cfset form.Pagos = url.Pagos>
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

<cfif isdefined("url.LvarRecibo") and not isdefined("form.LvarRecibo")>
	<cfset form.LvarRecibo = url.LvarRecibo>
</cfif>

<cfif isdefined("url.LvarReciboB") and not isdefined("form.LvarReciboB")>
	<cfset form.LvarReciboB = url.LvarReciboB>
</cfif>

<cfif isdefined("url.doc_pago") and not isdefined("form.doc_pago")>
	<cfset form.LvarRecibo = url.doc_pago>
</cfif>

<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>
<cfif isdefined("url.CPTcodigo") and not isdefined("form.CPTcodigo")>
	<cfset form.CPTcodigo = url.CPTcodigo>
</cfif>
<!--- <cfif isdefined("url.Recibo") and not isdefined("form.Recibo")>
	<cfset form.Recibo = url.Recibo>
</cfif> --->


<cf_dbtemp name="temporalPR_v1" returnvariable="temporal" datasource="#session.dsn#">
	<cf_dbtempcol name="id"  			    type="numeric"   	identity="yes">
	<cf_dbtempcol name="IDcontable"		    type="numeric"   	mandatory="no">
	<cf_dbtempcol name="MontoOrigen"		type="money"		mandatory="no">		
	<cf_dbtempcol name="MontoLocal"			type="money" 		mandatory="no">
	<cf_dbtempcol name="TC"					type="float" 		mandatory="no">	
	<cf_dbtempcol name="Mcodigo"  			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="Mnombre"			type="varchar(80)" 	mandatory="no">
	
	<cf_dbtempcol name="SNcodigo"  			type="integer"	 	mandatory="no">
	<cf_dbtempcol name="SNnombre"  			type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="SNnumero"  			type="char(10)"	 	mandatory="no">
	<cf_dbtempcol name="SNidentificacion"	type="char(30)"	 	mandatory="no">	
	
	<cf_dbtempcol name="Recibo" 			type="char(20)" 	mandatory="no">
	<cf_dbtempcol name="CPTcodigo"			type="char(2)" 		mandatory="no">	
	<cf_dbtempcol name="Ecodigo"  			type="integer" 		mandatory="no">
	<cf_dbtempcol name="Fecha"				type="datetime" 	mandatory="no">
	<cf_dbtempcol name="Asiento"			type="integer" 		mandatory="no">
	<cf_dbtempcol name="Lote"  				type="integer"	mandatory="no">

	<cf_dbtempkey cols="id">
</cf_dbtemp>


<!--- Inserta todos los documentos del Socio de Negocios en el rango de fechas. --->
<cfquery datasource="#session.DSN#">
	insert into #temporal# (
		IDcontable,
		MontoOrigen,
		MontoLocal,
		TC,
		Mcodigo,
		Mnombre,
		
		SNcodigo,
		SNnombre,
		SNnumero,
		SNidentificacion,
		
		Recibo,
		CPTcodigo,
		Ecodigo,
		Fecha,
		Asiento,
		Lote
	)

	select 
			bm.IDcontable,
			(
			    select sum( bb.Dtotal * case when cc.CPTtipo ='C' then -1.00 else 1.00 end) 
				from BMovimientosCxP bb
					inner join CPTransacciones cc
					on  cc.CPTcodigo   	= bb.CPTcodigo
					and cc.Ecodigo 		= bb.Ecodigo
					and cc.CPTpago 		= 1
				where bb.Ecodigo = bm.Ecodigo	
				   and bb.CPTcodigo = bm.CPTcodigo
				  and bb.Ddocumento = bm.Ddocumento
				  and bb.SNcodigo = bm.SNcodigo
			) as MontoOrigen,
			(
				select sum( (bb.Dtotal * case when cp.CPTtipo ='C' then -1.00 else 1.00 end) * bb.Dtipocambio) 
				from BMovimientosCxP bb
					inner join CPTransacciones cp
						on  cp.CPTcodigo   	= bb.CPTcodigo
						and cp.Ecodigo 		= bb.Ecodigo
						and cp.CPTpago 		= 1
				where bb.Ecodigo = bm.Ecodigo	
				   and bb.CPTcodigo = bm.CPTcodigo
				  and bb.Ddocumento = bm.Ddocumento
				  and bb.SNcodigo = bm.SNcodigo
			) as MontoLocal, 
			bm.Dtipocambio as TC,
			m.Mcodigo, 
			m.Mnombre,
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			bm.Ddocumento as Recibo, 
			bm.CPTcodigo,
			bm.Ecodigo,
			bm.Dfecha as Fecha, 
			<CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
			<CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null">
	
		from BMovimientosCxP bm
			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
					and s.Ecodigo = bm.Ecodigo
			inner join CPTransacciones b
				on b.CPTcodigo =bm.CPTcodigo
					and b.Ecodigo = bm.Ecodigo
					and b.CPTpago = 1
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and bm.Dfecha between #lsparsedatetime(form.FechaI)# and #lsparsedatetime(form.FechaF)#
			<cfif isdefined("form.LvarRecibo") and len(Trim(form.LvarRecibo))>
				and bm.Ddocumento = '#form.LvarRecibo#'
			</cfif>
			<cfif isdefined("form.chk") and len(Trim(form.chk))>
				and bm.SNcodigo in(#form.chk#) 
			</cfif>
		order by SNcodigo desc, Mcodigo desc
</cfquery>	
<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<!--- Actualiza el Asiento --->
<cfquery datasource="#session.DSN#">
	update #temporal#
		 set Asiento =
			( select h.Edocumento 
			from HEContables h
			where h.IDcontable = #temporal#.IDcontable),
		Lote =
			( select h.Cconcepto
			from HEContables h
			where h.IDcontable = #temporal#.IDcontable)
</cfquery>

<cfquery datasource="#session.DSN#">
	update #temporal#
		 set Asiento =
			( select h.Edocumento 
			from EContables h
			where h.IDcontable = #temporal#.IDcontable),
		  Lote =
			( select h.Cconcepto
			from EContables h
			where h.IDcontable = #temporal#.IDcontable)
</cfquery>

	
<!--- Reporte agrupado para eliminar los registros repetidos --->
<cfquery name="rsReporte" datasource="#Session.DSN#">
	select 
			Mcodigo, 
			SNcodigo, 
			Recibo,
			CPTcodigo,
			min(Fecha) as Fecha, 
			min(MontoOrigen) as MontoOrigen,  
			min(MontoLocal) as MontoLocal,
			min(TC) as TC,
			min(Mnombre) as Mnombre ,
			min(SNnombre) as SNnombre, 
			min(SNnumero) as SNnumero, 
			min(SNidentificacion) as SNidentificacion, 
			min(Asiento) as Asiento,
			min(Lote) as Lote
	from #temporal#
	group by 
			Mcodigo, 
			SNcodigo, 
			Recibo,
			CPTcodigo
	order by Mcodigo, Fecha, Recibo
</cfquery>

<!---
<cfdump var="#rsReporte#">
 <cfdump var="#form#">
<cfdump var="#url#">
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset BTN_Regresar 	= t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_CosnsPago = t.Translate('LB_CosnsPago','Consulta de Pagos Realizados')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Codigo 	= t.Translate('LB_Codigo','Codigo','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_Pagos	= t.Translate('LB_Pagos','Pagos')>
<cfset LB_Recibo	= t.Translate('LB_Recibo','Recibo')>
<cfset LB_LoteAs	= t.Translate('LB_LoteAs','Lote / Asiento')>
<cfset LB_TC	= t.Translate('LB_TC','TC')>
<cfset LB_MontoOr	= t.Translate('LB_MontoOr','Monto Origen')>
<cfset LB_MontoLoc	= t.Translate('LB_MontoLoc','Monto Local')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>

<cfif form.formatos EQ 1>
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
	<!--- <cfdump var="#rsReporte#">   --->
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right">
				<cfset params = "&formatos=1&FechaI=#form.FechaI#&FechaF=#form.FechaF#&LvarRecibo=#form.LvarRecibo#">
				<cfif isdefined("form.Pagos")>
					<cfset params = params & '&Pagos=#form.Pagos#'>
				</cfif>
				<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento))>
					<cfset params = params & '&IDdocumento=#form.IDdocumento#'>
				</cfif>
				<cfif isdefined("form.CPTcodigo") and len(trim(form.CPTcodigo))>
					<cfset params = params & '&CPTcodigo=#form.CPTcodigo#'>
				</cfif>
				<cfif isdefined("url.LvarReciboB") and len(trim(url.LvarReciboB))>
					<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
				</cfif>

				<cf_rhimprime datos="/sif/cp/consultas/PagoRealizado_sql.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right" class="noprint">
				<cfoutput>
				<cfif isdefined("form.Pagos")>
					<a href="DocPagado_PagosRealizados_form.cfm?1=1#params#">#BTN_Regresar#</a>  
				<cfelse>
					<a href="PagoRealizado_form.cfm?1=1#params#">#BTN_Regresar#</a>
				</cfif>
				</cfoutput>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="20" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right"><cfoutput>#LB_Fecha#:&nbsp;#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="20" align="center" class="niv2"><cfoutput>#LB_CosnsPago#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right"><cfoutput>#LB_USUARIO#:&nbsp;#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="20" class="niv3"><cfoutput>#LB_Fecha_Desde#:&nbsp;#lsdateformat(Form.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="20" class="niv3"><cfoutput>#LB_Fecha_Hasta#:&nbsp;#lsdateformat(Form.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="22">&nbsp;</td>
		</tr>  
		
			<cfoutput query="rsReporte" group="SNcodigo">

				<!--- &SNcodigo=#form.SNcodigo# --->
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#LB_Codigo#:</td>
			  <td nowrap="nowrap" class="niv3" align="left">#LB_SocioNegocio#:</td>
			  <td nowrap="nowrap" class="niv3" align="left" colspan="19">#LB_Identificacion#:</td>
			  <td>&nbsp;</td>
			</tr>
			<tr bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporte.SNnumero#</td>
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporte.SNnombre#</td>
			  <td nowrap="nowrap" class="niv3" align="left" colspan="19">#rsReporte.SNidentificacion#</td>
			  <td>&nbsp;</td>
			</tr>
			<tr bgcolor="E7E7E7">
				<td align="left" style="font-weight:bold" class="niv3">#LB_Pagos#:</td>
				<td colspan="21">&nbsp;</td>
			</tr>

			<cf_templatecss>
			
				<cfset TotalMontoOrigen = 0>
				<cfset TotalMontoLocal = 0>
				<tr>
					<td colspan="22" align="left" style="font-weight:bold" nowrap="nowrap" class="niv3" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Moneda#: #rsReporte.Mnombre#</td>
				</tr>
				<tr style="font-weight:bold">
				  <td>&nbsp;</td>
				  <td nowrap="nowrap" class="niv3">#LB_Recibo#</td>
				  <td nowrap="nowrap" align="left" class="niv3">#LB_Fecha#</td>
				  <td nowrap="nowrap" align="left" class="niv3">#LB_LoteAs#</td>
				  <td nowrap="nowrap" align="right" class="niv3">#LB_TC#</td>
				  <td nowrap="nowrap" align="right" class="niv3">#LB_MontoOr#</td>
				  <td nowrap="nowrap" align="right" class="niv3" colspan="22">#LB_MontoLoc#</td>
				</tr>
	
				<cfoutput>
					<cfset params2 ="">
					<cfset LvarListaNon = (CurrentRow MOD 2)>
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					 <cfset params2 = trim('&Recibo=#URLEncodedFormat(Recibo)#&CPTcodigoA=#CPTcodigo#&Fecha=#Fecha#&Asiento=#Asiento#&TC=#TC#&MontoOrigen=#MontoOrigen#&MontoLocal=#MontoLocal#')>
					  <td>&nbsp;</td>
					  <td class="niv4"><a href="PagoRealizado_DetallePago_form.cfm?1=1#params2##params#&SNcodigo=#rsReporte.SNcodigo#">#CPTcodigo# - #Recibo#</a></td>
					  <td align="left" class="niv4" ><a href="PagoRealizado_DetallePago_form.cfm?1=1#params2##params#&SNcodigo=#rsReporte.SNcodigo#">#dateformat(Fecha,'dd/mm/yyyy')#</a></td>
					  <td align="left" class="niv4" ><a href="PagoRealizado_DetallePago_form.cfm?1=1#params2##params#&SNcodigo=#rsReporte.SNcodigo#">#Lote# - #Asiento#</a></td>
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetallePago_form.cfm?1=1#params2##params#&SNcodigo=#rsReporte.SNcodigo#">#NumberFormat(TC,'_,_.__')#</a></td>
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetallePago_form.cfm?1=1#params2##params#&SNcodigo=#rsReporte.SNcodigo#">#NumberFormat(MontoOrigen,'_,_.__')#</a></td>
					  <td align="right" class="niv4" colspan="22"><a href="PagoRealizado_DetallePago_form.cfm?1=1#params2##params#&SNcodigo=#rsReporte.SNcodigo#">#NumberFormat(MontoLocal,'_,_.__')#</a></td>
					</tr>
	
					<cfset TotalMontoOrigen = TotalMontoOrigen + MontoOrigen>
					<cfset TotalMontoLocal = TotalMontoLocal + MontoLocal>
				</cfoutput>
			<tr>
				<td>&nbsp;</td>
				<td class="niv3" colspan="4" style="font-weight:bold">#LB_Total#:&nbsp;</td>
				<td class="niv3" align="right" style="font-weight:bold">#NumberFormat(TotalMontoOrigen,'_,_.__')#</td>
				<td class="niv3" align="right" style="font-weight:bold" colspan="20">#NumberFormat(TotalMontoLocal,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="22">&nbsp;</td>
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