<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 18-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->

<!---
<cfdump var="#form#">
<cfdump var="#url#"> 
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Tit = t.Translate('LB_Tit','Consulta de Pagos Realizados')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_USUARIO = t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Codigo = t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_Ident = t.Translate('LB_Ident','Identificación')>
<cfset LB_Pagos = t.Translate('LB_Pagos','Pagos')>
<cfset LB_Recibo = t.Translate('LB_Recibo','Recibo')>
<cfset LB_Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Asiento = t.Translate('LB_Asiento','Asiento')>
<cfset LB_TC = t.Translate('LB_TC','TC')>
<cfset LB_MontoO = t.Translate('LB_MontoO','Monto Origen')>
<cfset LB_MontoL = t.Translate('LB_MontoL','Monto Local')>
<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta')>
<cfset LB_SinReg = t.Translate('LB_SinReg','No se encontraron registros')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>

 
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
	select sum(bm.Dtotal) as MontoOrigen, sum(bm.Dtotal*bm.DTipoCambio) as MontoLocal,
			<!---(
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
			) as MontoLocal,--->
			bm.Dtipocambio as TC,
			m.Mcodigo, 
			m.Mnombre,
			s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, 
			bm.Ddocumento as Recibo, 
			bm.CCTcodigo,
			bm.Ecodigo,
			bm.Dfecha as Fecha, 
			<!---o.Oficodigo as Oficina,  --->
			coalesce(
				(select min(h.Edocumento)
				from HEContables h
				where h.IDcontable = bm.IDcontable)
				,
				(select min(h.Edocumento)
				from EContables h
				where h.IDcontable = bm.IDcontable)
			) as Asiento	
		from BMovimientos bm
			inner join SNegocios s
				on s.SNcodigo = bm.SNcodigo
					and s.Ecodigo = bm.Ecodigo
			inner join CCTransacciones b
				on b.CCTcodigo =bm.CCTcodigo
					and b.Ecodigo = bm.Ecodigo
					<!---and b.CCTpago = 1--->
					and b.CCTcodigo = 'RE' 
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo 
			inner join Oficinas o
				on o.Ecodigo = bm.Ecodigo
				and o.Ocodigo = bm.Ocodigo
		where bm.Ecodigo = #session.Ecodigo#
			and bm.Dfecha between #lsparsedatetime(form.FechaI)# and #lsparsedatetime(form.FechaF)#
			<cfif isdefined("form.LvarRecibo") and len(Trim(form.LvarRecibo))>
				and upper(bm.Ddocumento) like '%#ucase(form.LvarRecibo)#%'
			</cfif>
			and IDcontable>0
			and bm.SNcodigo = #form.SNcodigo#
		group by bm.Dtipocambio,m.Mcodigo, m.Mnombre, s.SNcodigo, s.SNnombre, s.SNnumero, s.SNidentificacion, bm.Ddocumento, bm.CCTcodigo, 
		bm.Ecodigo, bm.Dfecha, IDcontable	<!---o.Oficodigo,--->
		order by m.Mcodigo
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
			<!---Oficina, ---> 
			Asiento
	from rsProc
	order by Mcodigo, Fecha, Recibo <!---, Oficina--->
</cfquery>

<cfif form.formatos EQ 1 OR form.formatos EQ 2>
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
				<cfset params = "&formatos=#form.formatos#&SNcodigo=#form.SNcodigo#&FechaI=#form.FechaI#&FechaF=#form.FechaF#&LvarRecibo=#form.LvarRecibo#">
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
					<a href="DocPagado_PagosRealizados_form.cfm?1=1#params#">#LB_Regresar#</a>  
				<cfelse>
					<a href="PagoRealizado_formCC.cfm?1=1#params#">#LB_Regresar#</a>
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
		  <cfoutput><td colspan="20" align="center" class="niv2">#LB_Tit#</td>
		  <td colspan="2" class="niv4" align="right">#LB_USUARIO#:&nbsp;#session.Usulogin#</td></cfoutput>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<cfoutput><td align="center" colspan="20" class="niv3">#LB_Fecha_Desde#:&nbsp;#lsdateformat(Form.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<cfoutput><td align="center" colspan="20" class="niv3">#LB_Fecha_Hasta#:&nbsp;#lsdateformat(Form.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="22">&nbsp;</td>
		</tr>  
		
			<cfoutput>	
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#LB_Codigo#:</td>
			  <td nowrap="nowrap" class="niv3" align="left">#LB_SocioNegocio#:</td>
			  <td nowrap="nowrap" class="niv3" align="left" colspan="19">#LB_Ident#:</td>
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
			</cfoutput>

			<cf_templatecss>
			<cfoutput query="rsReporte" group="Mcodigo">
				<cfset TotalMontoOrigen = 0>
				<cfset TotalMontoLocal = 0>
				<tr>
					<td colspan="22" align="left" style="font-weight:bold" nowrap="nowrap" class="niv3" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Moneda#: #rsReporte.Mnombre#</td>
				</tr>
				<tr style="font-weight:bold">
				  <td>&nbsp;</td>
				  <td nowrap="nowrap" class="niv3">#LB_Recibo#</td>
				  <!---<td nowrap="nowrap" align="left" class="niv3">#LB_Oficina#</td>--->				  
				  <td nowrap="nowrap" align="left" class="niv3">#LB_Fecha#</td>
				  <td nowrap="nowrap" align="left" class="niv3">#LB_Asiento#</td>
				  <td nowrap="nowrap" align="right" class="niv3">#LB_TC#</td>
				  <td nowrap="nowrap" align="right" class="niv3">#LB_MontoO#</td>
				  <td nowrap="nowrap" align="right" class="niv3" colspan="22">#LB_MontoL#</td>
				</tr>
	
				<cfoutput>
					<cfset params2 ="">
					<cfset LvarListaNon = (CurrentRow MOD 2)>
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					 <cfset params2 = trim('&Recibo=#Recibo#&CCTcodigoA=#CCTcodigo#&Fecha=#Fecha#&Asiento=#Asiento#&TC=#TC#&MontoOrigen=#MontoOrigen#&MontoLocal=#MontoLocal#')>
					  <td>&nbsp;</td>
					  <td class="niv4"><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#CCTcodigo# - #Recibo#</a></td>
  					  <!---<td class="niv4"><a href="PagoRealizado_DetallePago_formCC.cfm?1=1#params2##params#">#Oficina#</a></td>--->
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
				<td class="niv3" colspan="5" style="font-weight:bold">Total:&nbsp;</td>
				<td class="niv3" align="right" style="font-weight:bold">#NumberFormat(TotalMontoOrigen,'_,_.__')#</td>
				<td class="niv3" align="right" style="font-weight:bold" colspan="20">#NumberFormat(TotalMontoLocal,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="22">&nbsp;</td>
			</tr>
			</cfoutput>
			
			<tr>
            	<cfoutput>
				<td colspan="22" align="center" class="niv3">
					------------------------------------------- #LB_FinCons# -------------------------------------------
				</td>
                </cfoutput>
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
        <cfoutput>
		<div align="center"> ------------------------------------------- #LB_SinReg# -------------------------------------------</div>
        </cfoutput>
	</cfif>
	</body>
	</html>
</cfif>