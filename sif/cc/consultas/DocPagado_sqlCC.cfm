<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 20-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_FECHA = t.Translate('LB_FECHA','Fecha','/sif/generales.xml')>
<cfset LB_ConsDocPag = t.Translate('LB_ConsDocPag','Consulta de Documentos Pagados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_DoccS = t.Translate('LB_DoccS','Docs con Saldo')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Direccion = t.Translate('LB_Direccion','Direcci&amp;oacute;n','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Asiento = t.Translate('LB_Asiento','Asiento')>
<cfset LB_TC = t.Translate('LB_TC','TC')>
<cfset LB_MontoOr = t.Translate('LB_MontoOr','Monto Origen')>
<cfset LB_MontoLoc = t.Translate('LB_MontoLoc','Monto Local')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta ')>
<cfset LB_SinReg = t.Translate('LB_SinReg','No se encontraron registros')>


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

<cfif isdefined("url.chk_DocSaldo") and not isdefined("form.chk_DocSaldo")>
	<cfset form.chk_DocSaldo = url.chk_DocSaldo>
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
	
		<cfif isdefined("url.chk_DocSaldo")>
		from Documentos he
		<cfelse>
		from HDocumentos he
		</cfif>		
		
			inner join SNegocios s
			on s.SNcodigo = he.SNcodigo
			and s.Ecodigo = he.Ecodigo

			inner join Monedas m
			on m.Mcodigo = he.Mcodigo 
			
			inner join Oficinas o
			on o.Ecodigo = he.Ecodigo
			and o.Ocodigo = he.Ocodigo

			inner join CCTransacciones b
			on b.Ecodigo = he.Ecodigo
			and b.CCTcodigo =he.CCTcodigo

			left outer join BMovimientos bm
			on bm.SNcodigo = he.SNcodigo
			and bm.Ddocumento = he.Ddocumento
			and bm.CCTcodigo = he.CCTcodigo
			and bm.Ecodigo = he.Ecodigo
			and bm.CCTRcodigo = he.CCTcodigo
			and bm.DRdocumento = he.Ddocumento

			left outer join SNDirecciones sd
			on sd.id_direccion = he.id_direccionFact

			left outer join DireccionesSIF ds
			on ds.id_direccion = sd.id_direccion

			<cfif isdefined("form.chk_DocSaldo")>
				inner join Documentos ed
			<cfelse>
				left outer join Documentos ed
			</cfif>
				on ed.Ecodigo     = he.Ecodigo
				and ed.CCTcodigo  = he.CCTcodigo
				and ed.Ddocumento = he.Ddocumento
				and ed.SNcodigo   = he.SNcodigo
		where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and he.Dfecha between #lsparsedatetime(form.FechaI)# and #lsparsedatetime(form.FechaF)#
		and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		<cfif isdefined("form.LvarRecibo") and len(Trim(form.LvarRecibo))>
			and he.Ddocumento like '%#form.LvarRecibo#%'
		</cfif>
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
	order by Mcodigo, Recibo, Fecha
</cfquery>

<cfif form.formatos EQ 2>
	<cf_QueryToFile query="#rsReporte#" filename="DocumentoPagado.xls" jdbc="false">
</cfif>

<cfif form.formatos EQ 1>
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
		* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
		.niv1 { font-size: 18px; }
		.niv2 { font-size: 16px; }
		.niv3 { font-size: 12px; }
		.niv4 { font-size: 8px; }
		</style>
	</head>
	<body>
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td style="width:1%">&nbsp;</td>
			<td colspan="22" align="right">
				<cfset params = "&formatos=1&SNcodigo=#form.SNcodigo#&FechaI=#form.FechaI#&FechaF=#form.FechaF#&LvarRecibo=#form.LvarRecibo#">
				<cfif isdefined("form.chk_DocSaldo")>
					<cfset params = params & "&chk_DocSaldo=#form.chk_DocSaldo#">
				</cfif>
				<cf_rhimprime datos="/sif/cc/consultas/DocPagado_sqlCC.cfm" paramsuri="#params#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="22" align="right" class="noprint">
				<cfoutput>
					<a href="DocPagado_formCC.cfm?1=1#params#">#LB_Regresar#</a> 
				</cfoutput>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="20" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right"><cfoutput>#LB_FECHA#:&nbsp;#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="20" align="center" class="niv2"><cfoutput>#LB_ConsDocPag#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right"><cfoutput>#LB_USUARIO#:&nbsp;#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="20" class="niv3"><cfoutput>#LB_Fecha_Desde#:&nbsp;#dateformat(Form.FechaI, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center" colspan="20" class="niv3"><cfoutput>#LB_Fecha_Hasta#:&nbsp;#dateformat(Form.FechaF, 'dd/mm/yyyy')#</cfoutput></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="1">&nbsp;</td>
		</tr>  
		
			<cfoutput>	
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
				<td align="left" nowrap style="font-weight:bold" class="niv3">#LB_DoccS#:</td>
				<td colspan="21">&nbsp;</td>
			</tr>
			</cfoutput>

			<cf_templatecss>
			<cfoutput query="rsReporte" group="Mcodigo">
				<cfset TotalMontoOrigen = 0>
				<cfset TotalMontoLocal = 0>
				<cfset TotalSaldos = 0>
				<tr>
					<td colspan="22" align="left" style="font-weight:bold" nowrap="nowrap" class="niv3" bgcolor="F4F4F4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Moneda#: #rsReporte.Mnombre#</td>
				</tr>
				<cfoutput>
				<tr style="font-weight:bold">
				  <td nowrap="nowrap" class="niv4" style="width:13%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LB_Documento#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Direccion#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Oficina#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_FECHA#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_Asiento#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_USUARIO#</td>
				  <td nowrap="nowrap" align="left" class="niv4" style="width:1%">#LB_TC#</td>
				  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">#LB_MontoOr#</td>
				  <td nowrap="nowrap" align="right" class="niv4" style="width:1%">#LB_MontoLoc#</td>
				  <td nowrap="nowrap" align="right" class="niv4" style="width:1%"colspan="19">#LB_Saldo#</td>
				</tr>
	
					<cfset params2 ="">	
					<cfset LvarListaNon = (CurrentRow MOD 2)>
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>
					 <cfset params2 = trim('&HDid=#HDid#&CCTcodigo=#CCTcodigo#&Recibo=#Recibo#&Fecha=#Fecha#&Asiento=#Asiento#&TC=#TC#&MontoOrigen=#MontoOrigen#&MontoLocal=#MontoLocal#')>
					  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#CCTcodigo# - #Recibo#</a></td>
					  <td style="width:1%" nowrap><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#trim(direccion)#</a></td>
					  <td><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#Oficina#</a></td>
					  <td align="left"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#dateformat(Fecha,'dd/mm/yyyy')#</a></td>
					  <td align="left"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#Asiento#</a></td>
					  <td align="left"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#EDusuario#</a></td>
					  
					  <td align="right"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#NumberFormat(TC,'_,_.__')#</a></td>
					  <td align="right"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#NumberFormat(MontoOrigen,'_,_.__')#</a></td>
					  <td align="right"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#NumberFormat(MontoLocal,'_,_.__')#</a></td>
					  <td align="right" colspan="19"><a href="DocPagado_PagosRealizados_formCC.cfm?1=1#params2##params#" class="niv4">#NumberFormat(EDsaldo,'_,_.__')#</a></td>
					</tr>
	
					<cfset TotalMontoOrigen = TotalMontoOrigen + MontoOrigen>
					<cfset TotalMontoLocal = TotalMontoLocal + MontoLocal>
					<cfset TotalSaldos = TotalSaldos + EDsaldo>
				</cfoutput>
			<tr>
				<td class="niv4" style="font-weight:bold" colspan="7">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total:&nbsp;</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalMontoOrigen,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold">#NumberFormat(TotalMontoLocal,'_,_.__')#</td>
				<td class="niv4" align="right" style="font-weight:bold" colspan="15">#NumberFormat(TotalSaldos,'_,_.__')#</td>

			</tr>
			<tr>
				<td colspan="25">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="25" align="center" class="niv3">
					------------------------------------------- #LB_FinCons# -------------------------------------------
				</td>
			</tr>
			</cfoutput>
		</table>
	<cfelse>
		<cfoutput>
		<div align="center"> ------------------------------------------- #LB_SinReg# -------------------------------------------</div>
 		</cfoutput>       
	</cfif>
	</body>
	</html>
</cfif>