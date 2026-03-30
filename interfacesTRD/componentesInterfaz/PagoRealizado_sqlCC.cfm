<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 18-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->

<!---
<cfdump var="#form#">
<cfdump var="#url#"> 
 --->
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

<cfif isdefined("url.Rec_Pag") and not isdefined("form.Rec_Pag")>
	<cfset form.LvarRecibo = url.Rec_Pag>
</cfif>

<cfif isdefined("url.HDid") and not isdefined("form.HDid")>
	<cfset form.HDid = url.HDid>
</cfif>
<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>

<!--- <cfdump var="#form#">
<cfdump var="#url#">  --->

<cfquery name="rsProc" datasource="#session.DSN#">
	select 
			(
				select sum(bb.Dtotal) 
				from BMovimientos bb
				where bb.Ecodigo = bm.Ecodigo	
				   and bb.CCTcodigo = bm.CCTcodigo
				  and bb.Ddocumento = bm.Ddocumento
				  and bb.SNcodigo = bm.SNcodigo
			) as MontoOrigen,
			(
				select sum(bb.Dtotal * bb.Dtipocambio) 
				from BMovimientos bb
				where bb.Ecodigo = bm.Ecodigo	
				   and bb.CCTcodigo = bm.CCTcodigo
				  and bb.Ddocumento = bm.Ddocumento
				  and bb.SNcodigo = bm.SNcodigo
			) as MontoLocal,
			bm.Dtipocambio as TC,
			m.Mcodigo, 
			m.Mnombre,
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			bm.Ddocumento as Recibo, 
			bm.CCTcodigo,
			bm.Ecodigo,
			bm.Dfecha as Fecha, 
			o.Oficodigo as Oficina,  
			h.Edocumento as Asiento
	
		from BMovimientos bm
			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
					and s.Ecodigo = bm.Ecodigo
			inner join CCTransacciones b
				on b.CCTcodigo =bm.CCTcodigo
					and b.Ecodigo = bm.Ecodigo
					and b.CCTpago = 1
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 
			inner join HEContables h
				on h.IDcontable = bm.IDcontable
			inner join Oficinas o
				on o.Ecodigo = bm.Ecodigo
				and o.Ocodigo = bm.Ocodigo
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and bm.Dfecha between #lsparsedatetime(form.FechaI)# and #lsparsedatetime(form.FechaF)#
			<cfif isdefined("form.LvarRecibo") and len(Trim(form.LvarRecibo))>
				and upper(bm.Ddocumento) like '%#ucase(form.LvarRecibo)#%'
			</cfif>
			
			and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			
	union
		
			select 
			(
				select sum(bb.Dtotal) 
				from BMovimientos bb
				where bb.Ecodigo = bm.Ecodigo	
				   and bb.CCTcodigo = bm.CCTcodigo
				  and bb.Ddocumento = bm.Ddocumento
				  and bb.SNcodigo = bm.SNcodigo
			) as MontoOrigen,
			(
				select sum(bb.Dtotal * bb.Dtipocambio) 
				from BMovimientos bb
				where bb.Ecodigo = bm.Ecodigo	
				   and bb.CCTcodigo = bm.CCTcodigo
				  and bb.Ddocumento = bm.Ddocumento
				  and bb.SNcodigo = bm.SNcodigo
			) as MontoLocal,
			bm.Dtipocambio as TC,
			m.Mcodigo, 
			m.Mnombre,
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			bm.Ddocumento as Recibo, 
			bm.CCTcodigo,
			bm.Ecodigo,
			bm.Dfecha as Fecha, 
			o.Oficodigo as Oficina,  
			h.Edocumento as Asiento
	
		from BMovimientos bm
			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
					and s.Ecodigo = bm.Ecodigo
			inner join CCTransacciones b
				on b.CCTcodigo =bm.CCTcodigo
					and b.Ecodigo = bm.Ecodigo
					and b.CCTpago = 1
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 
			inner join EContables h
				on h.IDcontable = bm.IDcontable
			inner join Oficinas o
				on o.Ecodigo = bm.Ecodigo
				and o.Ocodigo = bm.Ocodigo
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and bm.Dfecha between #lsparsedatetime(form.FechaI)# and #lsparsedatetime(form.FechaF)#
			<cfif isdefined("form.LvarRecibo") and len(Trim(form.LvarRecibo))>
				and rtrim(ltrim(upper(bm.Ddocumento))) like rtrim(ltrim('%#ucase(form.LvarRecibo)#%'))
			</cfif>
			and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">	
		
		order by Mcodigo
</cfquery>


<cfquery name="rsReporte" dbtype="query">
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
			Recibo,
			CCTcodigo, 
			Ecodigo,
			Fecha, 
			Oficina,  
			Asiento
	from rsProc
	order by Mcodigo, Fecha, Recibo, Oficina
</cfquery>

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
	<!---<cfdump var="#rsReporte#">  --->
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right">
				<cfset params = "&formatos=1&SNcodigo=#form.SNcodigo#&FechaI=#form.FechaI#&FechaF=#form.FechaF#&LvarRecibo=#form.LvarRecibo#">
				<cfif isdefined("form.Pagos")>
					<cfset params = params & '&Pagos=#form.Pagos#'>
				</cfif>
				<cfif isdefined("form.HDid") and len(trim(form.HDid))>
					<cfset params = params & '&HDid=#form.HDid#'>
				</cfif>
				<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
					<cfset params = params & '&CCTcodigo=#form.CCTcodigo#'>
				</cfif>
				<cfif isdefined("url.LvarReciboB") and len(trim(url.LvarReciboB))>
					<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
				</cfif>

				<cf_rhimprime datos="/sif/cc/consultas/PagoRealizado_sqlCC.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right" class="noprint">
				<cfoutput>
				<cfif isdefined("form.Pagos")>
					<a href="DocPagado_PagosRealizados_form.cfm?1=1#params#">Regresar</a>  
				<cfelse>
					<a href="PagoRealizado_formCC.cfm?1=1#params#">Regresar</a>
				</cfif>
				</cfoutput>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="20" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right">Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="20" align="center" class="niv2">Consulta de Pagos Realizados</td>
		  <td colspan="2" class="niv4" align="right">Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="20" class="niv3">Fecha&nbsp;Desde:&nbsp;<cfoutput>#lsdateformat(Form.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="20" class="niv3">Fecha&nbsp;Hasta:&nbsp;<cfoutput>#lsdateformat(Form.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="22">&nbsp;</td>
		</tr>  
		
			<cfoutput>	
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">C&oacute;digo:</td>
			  <td nowrap="nowrap" class="niv3" align="left">Socio de Negocios:</td>
			  <td nowrap="nowrap" class="niv3" align="left" colspan="19">Identificación:</td>
			  <td>&nbsp;</td>
			</tr>
			<tr bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporte.SNnumero#</td>
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporte.SNnombre#</td>
			  <td nowrap="nowrap" class="niv3" align="left" colspan="19">#rsReporte.SNidentificacion#</td>
			  <td>&nbsp;</td>
			</tr>
			<tr bgcolor="E7E7E7">
				<td align="left" style="font-weight:bold" class="niv3">Pagos:</td>
				<td colspan="21">&nbsp;</td>
			</tr>
			</cfoutput>

			<cf_templatecss>
			<cfoutput query="rsReporte" group="Mcodigo">
				<cfset TotalMontoOrigen = 0>
				<cfset TotalMontoLocal = 0>
				<tr>
					<td colspan="22" align="left" style="font-weight:bold" nowrap="nowrap" class="niv3" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Moneda: #rsReporte.Mnombre#</td>
				</tr>
				<tr style="font-weight:bold">
				  <td>&nbsp;</td>
				  <td nowrap="nowrap" class="niv3">Recibo</td>
				  <td nowrap="nowrap" align="left" class="niv3">Oficina</td>				  
				  <td nowrap="nowrap" align="left" class="niv3">Fecha</td>
				  <td nowrap="nowrap" align="left" class="niv3">Asiento</td>
				  <td nowrap="nowrap" align="right" class="niv3">TC</td>
				  <td nowrap="nowrap" align="right" class="niv3">Monto Origen</td>
				  <td nowrap="nowrap" align="right" class="niv3" colspan="22">Monto Local</td>
				</tr>
	
				<cfoutput>
					<cfset params2 ="">
					<cfset LvarListaNon = (CurrentRow MOD 2)>
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					 <cfset params2 = trim('&Recibo=#Recibo#&CCTcodigoA=#CCTcodigo#&Fecha=#Fecha#&Asiento=#Asiento#&TC=#TC#&MontoOrigen=#MontoOrigen#&MontoLocal=#MontoLocal#')>
					  <td>&nbsp;</td>
					  <td class="niv4"><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#CCTcodigo# - #Recibo#</a></td>
  					  <td class="niv4"><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#Oficina#</a></td>
					  <td align="left" class="niv4" ><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#dateformat(Fecha,'dd/mm/yyyy')#</a></td>
					  <td align="left" class="niv4" ><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#Asiento#</a></td>
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#NumberFormat(TC,'_,_.__')#</a></td>
					  <td align="right" class="niv4" ><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#NumberFormat(MontoOrigen,'_,_.__')#</a></td>
					  <td align="right" class="niv4" colspan="22"><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#NumberFormat(MontoLocal,'_,_.__')#</a></td>
					</tr>
	
					<cfset TotalMontoOrigen = TotalMontoOrigen + MontoOrigen>
					<cfset TotalMontoLocal = TotalMontoLocal + MontoLocal>
				</cfoutput>
			<tr>
				<td>&nbsp;</td>
				<td class="niv3" colspan="4" style="font-weight:bold">Total:&nbsp;</td>
				<td class="niv3" align="right" style="font-weight:bold">#NumberFormat(TotalMontoOrigen,'_,_.__')#</td>
				<td class="niv3" align="right" style="font-weight:bold" colspan="20">#NumberFormat(TotalMontoLocal,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="22">&nbsp;</td>
			</tr>
			</cfoutput>
			
			<tr>
				<td colspan="22" align="center" class="niv3">
					------------------------------------------- Fin de la Consulta -------------------------------------------
				</td>
			</tr>
		</table>
		<script language="javascript" type="text/javascript">
			<cfoutput>
				function Detallado(LvarFecha,LvarAsiento,LvarRecibo){
					var LvarFecha1 = LvarFecha;
					var LvarAsiento1 = LvarAsiento;
					var LvarRecibo1 = LvarRecibo;
					
					
					/*document.form1.action="PagoRealizado_DetallePago_form.cfm?fecha=LvarFecha1&asiento=LvarAsiento1&recibo=LvarRecibo1";
					document.form1.submit();*/
				}
			</cfoutput>
		</script>
	<cfelse>
		<div align="center"> ------------------------------------------- No se encontraron registros -------------------------------------------</div>
	</cfif>
	</body>
	</html>
</cfif>