<cfsetting requesttimeout="900">
<cfsetting enablecfoutputonly="yes">
<!--- Hay que condicionar el siguiente query.  Puede ser por fechas ? --->

<!--- 
	ojo: 
		como existen 2 queries con los mismos transportes, los cuales tienen muchos filtros, 
		se arma el SQL de los filtros en una variable para ambos queries
--->

<cfsavecontent variable="LvarFromOCtransporteWhere">
<cfoutput>
	  from OCtransporte a
	 where a.Ecodigo = #Session.Ecodigo#
	<!--- Transporte: --->
	<cfif form.OCTtipo NEQ "">
	   and a.OCTtipo = '#form.OCTtipo#'
		<cfif trim(form.OCTtransporte) NEQ "">
	   and a.OCTtransporte = '#Replace(form.OCTtransporte, "'", "''", "ALL")#'
		</cfif>
	</cfif>
	<!--- Incluir únicamente Transportes Abiertos --->
	<cfif isdefined("form.chkSoloAbiertos")>
	   and a.OCTestado = 'A'
	<cfelse>
	   and a.OCTestado <> 'T'
	</cfif>
	<!--- Incluir únicamente Transportes con Saldos Inconsistentes --->
	<cfif isdefined("form.chkSoloConInconsistencias")>
		and (
				select count(1)
				  from OCproductoTransito pt
				 where pt.OCTid = a.OCTid
				   AND (
								pt.OCPTentradasCantidad<0 or pt.OCPTentradasCostoTotal<0 
						or 
								pt.OCPTsalidasCantidad>0 or pt.OCPTsalidasCostoTotal>0 
						or 
								pt.OCPTentradasCantidad+pt.OCPTsalidasCantidad<0 or pt.OCPTentradasCostoTotal+pt.OCPTsalidasCostoTotal<0
						or 
								pt.OCPTventasCantidad<0 or pt.OCPTventasMontoTotal<0 
						or 
								pt.OCPTentradasCantidad-pt.OCPTventasCantidad<0 
					)
			) > 0
	</cfif>

	<!--- Cuando no se filtra por número de contrato, deben tener por lo menos un producto --->
	<cfif trim(form.DstOCcontrato) EQ "" AND trim(form.OriOCcontrato) EQ "">
		and (
				 select count(1)
				   from OCtransporteProducto tp
				  where tp.OCTid = a.OCTid
			 ) > 0
	</cfif>

	<!--- Incluir Transportes con Origenes: --->
	<!--- Mes y Año Contable --->
	<!--- Documento Origen --->
	<cfif form.OriMes NEQ "" OR trim(form.OriDocumento) NEQ "">
		and (
				select count(1)
				  from OCPTmovimientos movs
				<cfif form.OriMes NEQ "">
					inner join OCPTdetalle dets
						 on dets.OCPTMid = movs.OCPTMid
						and dets.OCPTDperiodo	= #form.ORIano#
						and dets.OCPTDmes     	= #form.OriMes#
				</cfif>
				 where movs.OCTid				= a.OCTid
				   and movs.OCPTMtipoOD			= 'O'
				<cfif trim(form.OriDocumento) NEQ "">
				   and movs.OCPTMdocumentoOri 	= '#Replace(form.OriDocumento, "'", "''", "ALL")#'
				</cfif>
			) > 0
	</cfif>
	<!--- Orden Comercial Origen: se saca de OCtransporteProducto porque puede no tener movimientos --->
	<cfif trim(form.OriOCcontrato) NEQ "">
		and (
				select count(1)
				  from OCtransporteProducto tp
					inner join OCordenComercial oc
						 on oc.OCid = tp.OCid
						and oc.OCcontrato = '#Replace(form.OriOCcontrato, "'", "''", "ALL")#' 
				  where tp.OCTid 	= a.OCTid
					and tp.OCtipoOD	= 'O'
			) > 0
	</cfif>

	<!--- Incluir Transportes con Transformaciones: --->
	<!--- Incluir únicamente Transportes con Transformaciones --->
	<!--- Mes y Año Contable --->
	<!--- Documento Origen --->
	<cfif isdefined("form.chkSoloConTransformaciones") OR form.OCTTmes NEQ "" OR trim(form.OriDocumento) NEQ "">
		and (
				select count(1)
				  from OCtransporteTransformacion tt
				 where tt.OCTid			= a.OCTid
				   and tt.OCTTestado 	= 1
				<cfif form.OCTTmes NEQ "">
				   and tt.OCTTperiodo	= #form.OCTTano#
				   and tt.OCTTmes		= #form.OCTTmes#
				</cfif>
				<cfif trim(form.OriDocumento) NEQ "">
				   and tt.OCTTdocumento	= '#Replace(form.OCTTdocumento, "'", "''", "ALL")#'
				</cfif>
			) > 0
	</cfif>

	<!--- Incluir Transportes con Destinos: --->
	<!--- Mes y Año Contable --->
	<!--- Documento Destino --->
	<!--- Tipo de Movimientos Destinos --->
	<!--- Unicamente Movimientos con Costo de Venta Pendiente --->
	<cfset LvarInOCPTMtipoICTV = "'.'">
	<cfif isdefined("form.chkDI")>
		<cfset LvarInOCPTMtipoICTV = "#LvarInOCPTMtipoICTV#,'I'">
	</cfif>
	<cfif isdefined("form.chkDC")>
		<cfset LvarInOCPTMtipoICTV = "#LvarInOCPTMtipoICTV#,'C'">
	</cfif>
	<cfif isdefined("form.chkDT")>
		<cfset LvarInOCPTMtipoICTV = "#LvarInOCPTMtipoICTV#,'T'">
	</cfif>
	<cfif isdefined("form.chkDO")>
		<cfset LvarInOCPTMtipoICTV = "#LvarInOCPTMtipoICTV#,'O'">
	</cfif>
	<cfif isdefined("form.chkDX")>
		<cfset LvarInOCPTMtipoICTV = "#LvarInOCPTMtipoICTV#,'X'">
	</cfif>
	<cfif isdefined("form.chkDV")>
		<cfset LvarInOCPTMtipoICTV = "#LvarInOCPTMtipoICTV#,'V'">
	</cfif>
	<cfset LvarFiltrarOCPTMtipoICTV = LvarInOCPTMtipoICTV NEQ "'.'">
	<!--- Si sólo es de Asignación de Costos: Incluir únicamente Movimientos tipo DI, DC, DV: Excluir Transformación --->
	<cfif NOT LvarFiltrarOCPTMtipoICTV AND isdefined("form.chkIncluirCostos") AND NOT isdefined("form.chkIncluirOD") AND NOT isdefined("form.chkIncluirSaldos")>
		<cfset LvarInOCPTMtipoICTV = "'I','C','X','V'">
		<cfset LvarFiltrarOCPTMtipoICTV = true>
	</cfif>
	
	<cfif form.dstMes NEQ "" OR trim(form.dstDocumento) NEQ "" OR LvarFiltrarOCPTMtipoICTV OR isdefined("form.chkSoloConPendientes")>
		and (
				select count(1)
				  from OCPTmovimientos movs
				<cfif form.dstMes NEQ "">
					inner join OCPTdetalle dets
						 on dets.OCPTMid 		= movs.OCPTMid
						and dets.OCPTDperiodo	= #form.dstAno#
						and dets.OCPTDmes     	= #form.dstMes#
				</cfif>
				<cfif isdefined("form.chkSoloConPendientes")>
					inner join CCVProducto cv
						 on cv.Ecodigo 		= movs.Ecodigo
						and cv.CCTcodigo	= movs.OCPTMreferenciaOri
						and cv.Ddocumento	= movs.OCPTMdocumentoOri
						and cv.DDtipo		= 'O'
						and cv.CCVPestado	= 0
				</cfif>
				 where movs.OCTid				= a.OCTid
				   and movs.OCPTMtipoOD			= 'D'
				<cfif LvarFiltrarOCPTMtipoICTV>
				   and movs.OCPTMtipoICTV	IN (#LvarInOCPTMtipoICTV#)
				</cfif>
				<cfif trim(form.dstDocumento) NEQ "">
				   and movs.OCPTMdocumentoOri 	= '#Replace(form.dstDocumento, "'", "''", "ALL")#'
				</cfif>
			) > 0
	</cfif>
	<!--- Orden Comercial Destino: se saca de OCtransporteProducto porque puede no tener movimientos --->
	<cfif trim(form.dstOCcontrato) NEQ "">
		and (
				select count(1)
				  from OCtransporteProducto tp
					inner join OCordenComercial oc
						 on oc.OCid = tp.OCid
						and oc.OCcontrato = '#Replace(form.dstOCcontrato, "'", "''", "ALL")#' 
				  where tp.OCTid 	= a.OCTid
					and tp.OCtipoOD	= 'D'
			) > 0
	</cfif>
</cfoutput>
</cfsavecontent>
<cfoutput>
<!--
	#LvarFromOCtransporteWhere#
-->
</cfoutput>
<cfquery name="rsTransportes" datasource="#session.dsn#">
	select 
		OCTid, 
		OCTtipo,
		OCTtransporte,
		case OCTestado when 'A' then 'TRANSPORTE ABIERTO' when 'C' then 'TRANSPORTE CERRADO' end as estado,
		OCTvehiculo,
		OCTruta,
		OCTfechaPartida,
		OCTfechaLlegada,
		OCTPfechaBOLdefault,
		OCTPnumeroBOLdefault
	#preservesinglequotes(LvarFromOCtransporteWhere)#
	 order by OCTtransporte
</cfquery>
<cfoutput>
<style type="text/css">
<!--
.font_10b {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.font_10 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.font_11 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	background-color:white;
	white-space:nowrap;
}
.font_11B {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	border: solid 1px ##AAAAAA;
	background-color:##e4e4e4;
	border-collapse:collapse;
	white-space:nowrap;
}
.font_11w {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	background-color:white;
	white-space:nowrap;
	width: auto;
}
.font_11C {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	width:1000px;
	border: solid 1px ##AAAAAA;
	background-color:##e4e4e4;
	border-collapse:collapse;
	white-space:nowrap;
}
.font_12B {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
}
.font_14B {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16px;
	font-weight: bold;
}
-->
</style>

<cf_htmlReportsHeaders 
		title="Impresion de Órdenes Comerciales en Tránsito"
		filename="RepOCT.xls"
		irA="transportesOC-form.cfm?AGTPid="
		download="yes"
		preview="no">

<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
	<tr>
		<td class="font_14B" align="center"><strong>#Session.Enombre#</strong></td>
	</tr>
	<tr>
		<td class="font_14B" align="center"><strong>Reporte de Transportes de Ordenes Comerciales en Transito</strong></td>
	</tr>
	<tr>
		<cfif isdefined("form.chkIncluirOD")>
			<cfset LvarTitulo = "Origenes/Destinos">
			<cfif isdefined("form.chkIncluirSaldos")>
				<cfset LvarTitulo = LvarTitulo & " y Saldos">
				<cfif isdefined("form.chkIncluirMovimientos")>
					<cfset LvarTitulo = LvarTitulo & "/Movimientos">
				</cfif>
			</cfif>
			<cfif isdefined("form.chkIncluirCostos")>
				<cfset LvarTitulo = LvarTitulo & " y Costos Asignados">
			</cfif>
			<cfset LvarTitulo = LvarTitulo & " de Productos en Transito por Transporte">
		<cfelseif isdefined("form.chkIncluirSaldos")>
			<cfset LvarTitulo = "Saldos">
			<cfif isdefined("form.chkIncluirMovimientos")>
				<cfset LvarTitulo = LvarTitulo & " y Movimientos">
			</cfif>
			<cfif isdefined("form.chkIncluirCostos")>
				<cfset LvarTitulo = LvarTitulo & " y Costos Asignados">
			</cfif>
			<cfset LvarTitulo = LvarTitulo & " de Productos en Tránsito por Transporte">
		<cfelseif isdefined("form.chkIncluirCostos")>
			<cfset LvarTitulo = "Asignación de Costos de Productos en Tránsito por Transporte">
		<cfelseif isdefined("form.chkIncluirTotales")>
			<cfset LvarTitulo = "Totales de Productos en Tránsito por Línea de Negocios">
		<cfelse>
			<cfset LvarTitulo = "Lista de Transportes">
		</cfif>
		<td class="font_14B" align="center"><strong>#LvarTitulo#</strong></td>
	</tr>
	<cfset LvarRangoOri = "">
	<cfset LvarRangoDst = "">

	<cfif form.OriMes NEQ "">
			<cfset LvarRangoOri = "Origen:  Desde #dateformat(createdate(form.ORIano,form.OriMes,1),'DD/MM/YYYY')# Hasta #dateformat(dateadd('d', -1, dateadd('m', 1, createdate(form.ORIano,form.OriMes,1))),'DD/MM/YYYY')#">
	</cfif>

	<cfif form.dstMes NEQ "">
			<cfset LvarRangoDst = "Destino:  Desde #dateformat(createdate(form.dstAno,form.dstMes,1),'DD/MM/YYYY')# Hasta #dateformat(dateadd('d', -1, dateadd('m', 1, createdate(form.dstAno,form.dstMes,1))),'DD/MM/YYYY')#">
	</cfif>
	<cfif len(LvarRangoOri)>
		<tr>
			<td class="font_14B" align="center">#LvarRangoOri#</td>
		</tr>
	</cfif>
	<cfif len(LvarRangoDst)>
		<tr>
			<td class="font_14B" align="center">#LvarRangoDst#</td>
		</tr>
	</cfif>
	<tr>
		<td class="font_14B" align="center">&nbsp;</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
	<tr>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
		<td class="font_11">&nbsp;</td>
	</tr>
</cfoutput>
<cfflush interval="64">

<!--- IncluirT: Totales por Línea de Negocio --->
<cfif isdefined("form.chkIncluirTotales")>
	<cfquery name="rsTotal" datasource="#session.dsn#">
		select  
			c.Ccodigo, c.Cdescripcion,
			sum(pt.OCPTentradasCantidad) as entradasCantidad,
			sum(pt.OCPTentradasCostoTotal) as entradasCosto,
			sum(
				case 
					when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
						then pt.OCPTentradasCantidad
						else -pt.OCPTsalidasCantidad
				end
			) as salidasCantidad,
			sum(
				case 
					when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
						then pt.OCPTentradasCostoTotal
						else -pt.OCPTsalidasCostoTotal
				end
			) as salidasCosto,
			sum(
				case 
					when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
						then 0
						else pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad
				end
			) as existenciasCantidad,
			sum(
				case 
					when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
						then 0
						else pt.OCPTentradasCostoTotal + pt.OCPTsalidasCostoTotal
				end
			) as existenciasCosto,
			sum(pt.OCPTventasCantidad) as ventasCantidad,
			sum(pt.OCPTventasMontoTotal) as ventasMonto,
			sum(pt.OCPTentradasCantidad-pt.OCPTventasCantidad) as saldoVentaCantidad
		from OCproductoTransito pt
			inner join OCtransporte t 
				 on t.OCTid=pt.OCTid
			inner join Articulos a 
				 on a.Aid=pt.Aid
			inner join Clasificaciones c 
				 on c.Ecodigo = a.Ecodigo 
				and c.Ecodigo = #Session.Ecodigo#
				and c.Ccodigo = a.Ccodigo
		where 
		(
			select count(1)
			#preservesinglequotes(LvarFromOCtransporteWhere)#
			and  a.OCTid = pt.OCTid
		) > 0
	group by c.Ccodigo, c.Cdescripcion
	</cfquery>
	
	<cfoutput>
		<tr>
			<td colspan="12" class="font_12B" align="left" nowrap="nowrap">
				Totales por línea de negocio (no incluye Ventas de Almacén)
			</td>
		</tr>
		<tr>
		  <td colspan="15" rowspan="2" valign="middle"  class="font_11b" width="10%">Clasificaci&oacute;n</td>
		  <td colspan="2" align="center" valign="top" class="font_11b">Entradas</td>
		  <td colspan="2" align="center" valign="top" class="font_11b">Salidas<br>(Costo)</td>
		  <td colspan="2" align="center" valign="top" class="font_11b">Existencias<br>(Tránsito)</td>
		  <td colspan="3" align="center" valign="top" class="font_11b">Ventas de Tránsito</td>
		</tr>
		<tr>
		  <td align="right" class="font_11b">Cantidad</td>
		  <td align="right" class="font_11b">Costo</td>
		  <td align="right" class="font_11b">Cantidad</td>
		  <td align="right" class="font_11b">Costo</td>
		  <td align="right" class="font_11b">Cantidad</td>
		  <td align="right" class="font_11b">Costo</td>
		  <td align="right" class="font_11b">Cantidad</td>
		  <td align="right" class="font_11b">Monto</td>
		  <td align="right" class="font_11b">Saldo Cant.</td>
		</tr>
	<cfloop query="rsTotal">
		<tr>
			<td colspan="15"  class="font_11" nowrap>&nbsp;#HTMLEditFormat(rsTotal.Cdescripcion)#		&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.entradasCantidad,",9.00")#	&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.entradasCosto,",9.00")#		&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.salidasCantidad,",9.00")#		&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.salidasCosto,",9.00")#		&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.existenciasCantidad,",9.00")#	&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.existenciasCosto,",9.00")#	&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.ventasCantidad,",9.00")#		&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.ventasMonto,",9.00")#			&nbsp;</td>
			<td align="right" class="font_11">&nbsp;#numberFormat(rsTotal.saldoVentaCantidad,",9.00")#	&nbsp;</td>
		</tr>
	</cfloop>
		<tr><td colspan="25" style="border-top:solid 1px ##CCCCCC">&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	</cfoutput>
</cfif>

<!--- Ciclo por rsTransportes 
se pinta un registro por cada uno de los transportes, y luego dos tablas internas
--->
<cfset LvarLineas = 0>
<cfoutput query="rsTransportes">
	<cfset LvarLineas = LvarLineas + 1>
	<cfif LvarLineas GT 100>
	<cfset LvarLineas = 0>
	</table>
	<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
		<tr>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
			<td class="font_11">&nbsp;</td>
		</tr>
	</cfif>	
	<cfif rsTransportes.OCTtipo  EQ "B">
		<cfset lvarTipoTransporte = "BARCO">
	<cfelseif rsTransportes.OCTtipo EQ "A">
		<cfset lvarTipoTransporte = "AVIÓN">
	<cfelseif rsTransportes.OCTtipo EQ "T">
		<cfset lvarTipoTransporte = "TERRESTRE">
	<cfelseif rsTransportes.OCTtipo EQ "F">
		<cfset lvarTipoTransporte = "FERROCARRIL">		
	<cfelseif rsTransportes.OCTtipo EQ "O">
		<cfset lvarTipoTransporte = "OTRO">		
	</cfif>
	<cfset LvarOCTid = rsTransportes.OCTid>
	<tr>
		<td colspan="3" class="font_12B" align="left" nowrap>
			#LvarTipoTransporte#:
		</td>
		<td colspan="2" class="font_12B" align="left" nowrap>
			#OCTtransporte#
		</td>
		<td colspan="6" class="font_12B" align="left" nowrap>
			#rsTransportes.Estado#
		</td>
		<td colspan="12" class="font_12B" align="left" nowrap>&nbsp;</td>
	</tr>

	<!--- IncluirOD: Origenes y Destinos --->
	<cfif isdefined("form.chkIncluirOD")>
		<tr>
			<td colspan="25">
				<cfquery name="rsORIs" datasource="#session.dsn#">
					select  
						case 
							when OCPTMtipoICTV = 'I' then 0
							when OCPTMtipoICTV = 'C' then 1
							when OCPTMtipoICTV = 'O' then 2
							when OCPTMtipoICTV = 'T' then 3
						end as OrderMov,
						case 
							when OCPTMtipoICTV = 'I' then 'OI=Origen Inventario (De Almacén)' 
							when OCPTMtipoICTV = 'C' then 'OC=Origen Comercial (Compras)'
							when OCPTMtipoICTV = 'O' then 'OO=Otros Costos'
						end	as OCtipoIC,
						oc.OCcontrato, 
						a.Acodigo, 
						cc.OCCcodigo,			
						coalesce( sum(movs.OCPTMcantidad) , 0) as Cantidad, 
						coalesce( sum(movs.OCPTMmontoValuacion) , 0) as Monto
					from OCPTmovimientos movs
						inner join OCordenComercial oc
							 on  oc.OCid = movs.OCid
						inner join Articulos a
							 on a.Aid   = movs.Aid
						inner join OCconceptoCompra cc
							 on cc.OCCid = movs.OCCid
					where movs.OCTid = #LvarOCTid#
					  and movs.OCPTMtipoOD 		= 'O'
					  and movs.OCPTMtipoICTV 	<> 'T'
					group by 
						movs.OCPTMtipoICTV,
						oc.OCcontrato, 
						a.Acodigo, 
						cc.OCCcodigo
					UNION
					select  
						100 as OrderMov,
						'Sin Origen' as OCtipoIC,
						oc.OCcontrato, 
						a.Acodigo,
						'00' as OCCcodigo,			
						0 as Cantidad, 
						0 as Monto
					from OCtransporteProducto tp
						inner join OCordenComercial oc
							 on  oc.OCid = tp.OCid
						inner join Articulos a
							 on a.Aid   = tp.Aid
					where tp.OCTid    = #LvarOCTid#
					  and oc.OCtipoOD = 'O'
					  and (
							select count(1)
							  from OCPTmovimientos movs
							 where movs.OCTid			= tp.OCTid 
							   and movs.Aid				= tp.Aid
							   and movs.OCid			= tp.OCid 
							   and movs.OCPTMtipoOD		= 'O'
							   and movs.OCPTMtipoICTV 	<> 'T'
						   ) = 0

					order by OCtipoIC, OCcontrato, Acodigo, OCCcodigo
<!---
					select  
						dd.OCid, dd.Aid, oc.OCcontrato, 
						'Origen Comercial (Compras)' as OCtipoIC,
						a.Acodigo, a.Adescripcion, 
						cc.OCCcodigo,			
						coalesce( sum(DDcantidad) , 0) as Cantidad, 
						coalesce( sum(DDtotallin) , 0) as Monto
					from HDDocumentosCP dd
						inner join OCordenComercial oc
							 on  oc.OCid = dd.OCid
						inner join Articulos a
							 on a.Aid   = dd.DDcoditem
						inner join OCconceptoCompra cc
							 on cc.OCCid = dd.OCCid
					where dd.OCTid = #LvarOCTid#
					  and dd.DDtipo = 'O'
					group by 
						dd.OCid, dd.Aid, oc.OCcontrato, 
						a.Acodigo, a.Adescripcion, 
						cc.OCCcodigo			
				UNION
					select  
						ee.OCid, dd.Aid, oc.OCcontrato, 
						'Origen Salidas de Inventario' as OCtipoIC,
						a.Acodigo, a.Adescripcion, 
						'00' as OCCcodigo,			
						coalesce( OCIcantidad , 0) as Cantidad, 
						coalesce( OCIcostoValuacion , 0) as Monto
					from OCinventarioProducto dd
						inner join OCinventario ee
							 on ee.OCIid = dd.OCIid
							and ee.OCItipoOD = 'O'
						inner join OCordenComercial oc
							 on  oc.OCid = ee.OCid
						inner join Articulos a
							 on a.Aid   = dd.Aid
						inner join OCtransporte t
							 on t.OCTid	= dd.OCTid
					where dd.OCTid    = #LvarOCTid#
				UNION
					select  
						tp.OCid, tp.Aid, oc.OCcontrato, 
						'Sin Origen' as OCtipoIC,
						a.Acodigo, a.Adescripcion, 
						'00' as OCCcodigo,			
						0 as Cantidad, 
						0 as Monto
					from OCtransporteProducto tp
						inner join OCordenComercial oc
							 on  oc.OCid = tp.OCid
						inner join Articulos a
							 on a.Aid   = tp.Aid
					where tp.OCTid    = #LvarOCTid#
					  and oc.OCtipoOD = 'O'
					  and (
						select count(1)
						  from HDDocumentosCP dd
						 where dd.DDtipo	='O'
						   and dd.OCTid		= tp.OCTid 
						   and dd.OCid		= tp.OCid 
						   and dd.OCCid		= (select OCCid from OCconceptoCompra where Ecodigo = dd.Ecodigo and OCCcodigo = '00')
						   and dd.DDcoditem	= tp.Aid
						   )	 = 0
					  and (
						select count(1)
						  from OCinventarioProducto dd
							inner join OCinventario ee
								 on ee.OCIid = dd.OCIid
								and ee.OCItipoOD = 'O'
						 where dd.OCTid	 = tp.OCTid 
						   and ee.OCid	 = tp.OCid 
						   and dd.Aid	 = tp.Aid
						   )	 = 0
					order by OCtipoIC, OCcontrato, Acodigo, OCCcodigo
--->
				</cfquery>
			
				<cfquery name="rsDSTs" datasource="#session.dsn#">
					select  
						case 
							when OCPTMtipoICTV = 'I' then 4
							when OCPTMtipoICTV = 'C' then 5
							when OCPTMtipoICTV = 'O' then 6
							when OCPTMtipoICTV = 'X' then 8
							when OCPTMtipoICTV = 'V' then 9
						end as OrderMov,
						case 
							when OCPTMtipoICTV = 'I' then 'DI=Destino Inventario (Recepcion Almacén)'
							when OCPTMtipoICTV = 'C' then 'DC=Destino Comercial (Ventas de Tránsito)'
							when OCPTMtipoICTV = 'O' then 'DO=Destino Otros Ingresos'
							when OCPTMtipoICTV = 'X' then 'DX=Cierre de Transporte'

							when OCPTMtipoICTV = 'V' then 'DV=Ventas de Almacén'
						end	as OCtipoIC,
						oc.OCcontrato, 
						a.Acodigo, 
						cc.OCIcodigo,			
						coalesce( sum(
							case 
								when OCPTMtipoICTV IN ('C','O','V') 
									then movs.OCPTMventaCantidad
									else -movs.OCPTMcantidad
							end	
						) , 0) as Cantidad, 
						coalesce( sum(
							case 
								when OCPTMtipoICTV IN ('C','O','V') 
									then movs.OCPTMventaValuacion
									else -movs.OCPTMmontoValuacion
							end	
						) , 0) as Monto
					from OCPTmovimientos movs
						inner join OCordenComercial oc
							 on  oc.OCid = movs.OCid
						inner join Articulos a
							 on a.Aid   = movs.Aid
						inner join OCconceptoIngreso cc
							 on cc.OCIid = movs.OCIid
					where movs.OCTid = #LvarOCTid#
					  and movs.OCPTMtipoOD 		= 'D'
					  and movs.OCPTMtipoICTV 	<> 'T'
					group by 
						movs.OCPTMtipoICTV,
						oc.OCcontrato, 
						a.Acodigo, 
						cc.OCIcodigo
					UNION
					select  
						100 as OrderMov,
						'Sin Destino' as OCtipoIC,
						oc.OCcontrato, 
						a.Acodigo,
						'00' as OCIcodigo,			
						0 as Cantidad, 
						0 as Monto
					from OCtransporteProducto tp
						inner join OCordenComercial oc
							 on  oc.OCid = tp.OCid
						inner join Articulos a
							 on a.Aid   = tp.Aid
					where tp.OCTid    = #LvarOCTid#
					  and oc.OCtipoOD = 'D'
					  and (
							select count(1)
							  from OCPTmovimientos movs
							 where movs.OCTid			= tp.OCTid 
							   and movs.Aid				= tp.Aid
							   and movs.OCid			= tp.OCid 
							   and movs.OCPTMtipoOD		= 'D'
							   and movs.OCPTMtipoICTV 	<> 'T'
						   ) = 0

					order by OCtipoIC, OCcontrato, Acodigo, OCIcodigo
<!---
					select  
						oc.OCcontrato, 
						case when oc.OCtipoIC = 'C' then
							'Destino Comercial (Ventas de Transito)' 
							else
							'Destino Venta de Almacen' 
						end	as OCtipoIC,
						a.Acodigo, a.Adescripcion, 
						ci.OCIcodigo,			
						coalesce( sum(DDcantidad) , 0) as Cantidad, 
						coalesce( sum(DDtotal) , 0) as Monto
					from HDDocumentos dd
						inner join OCordenComercial oc
							 on  oc.OCid = dd.OCid
						inner join Articulos a
							 on a.Aid   = dd.DDcodartcon
						inner join OCconceptoIngreso ci
							 on ci.OCIid = dd.OCIid
					where dd.OCTid = #LvarOCTid#
					  and dd.DDtipo = 'O'
					group by 
						oc.OCcontrato, 
						oc.OCtipoIC,
						a.Acodigo, a.Adescripcion 
						,ci.OCIcodigo
				UNION
					select  
						oc.OCcontrato, 
							'Destino Comercial (Ventas de Transito)' 
							else
							'Destino Venta de Almacen' 
						'Destino Entradas a Inventario (Recepcion Almacén)' as OCtipoIC,
						a.Acodigo, a.Adescripcion, 
						'00' as OCIcodigo,			
						coalesce( OCIcantidad , 0) as Cantidad, 
						coalesce( OCIcostoValuacion , 0) as Monto
					from OCinventarioProducto dd
						inner join OCinventario ee
							 on ee.OCIid = dd.OCIid
							and ee.OCItipoOD = 'D'
						inner join OCordenComercial oc
							 on  oc.OCid = ee.OCid
						inner join Articulos a
							 on a.Aid   = dd.Aid
						inner join OCtransporte t
							 on t.OCTid	= dd.OCTid
					where dd.OCTid    = #LvarOCTid#
				UNION
					select  
						oc.OCcontrato, 
						'Sin Destino' as OCtipoIC,
						a.Acodigo, a.Adescripcion, 
						'00' as OCIcodigo,			
						0 as Cantidad, 
						0 as Monto
					from OCtransporteProducto tp
						inner join OCordenComercial oc
							 on  oc.OCid = tp.OCid
						inner join Articulos a
							 on a.Aid   = tp.Aid
					where tp.OCTid    = #LvarOCTid#
					  and oc.OCtipoOD = 'D'
					  and (
						select count(1)
						  from HDDocumentos dd
						 where dd.DDtipo		='O'
						   and dd.OCTid			= tp.OCTid 
						   and dd.OCid			= tp.OCid 
						   and dd.OCIid			= (select OCIid from OCconceptoIngreso where Ecodigo = dd.Ecodigo and OCIcodigo = '00')
						   and dd.DDcodartcon	= tp.Aid
						   )	 = 0
					  and (
						select count(1)
						  from OCinventarioProducto dd
							inner join OCinventario ee
								 on ee.OCIid = dd.OCIid
								and ee.OCItipoOD = 'D'
						 where dd.OCTid	 = tp.OCTid 
						   and ee.OCid	 = tp.OCid 
						   and dd.Aid	 = tp.Aid
						   )	 = 0
					order by OCtipoIC, OCcontrato, Acodigo, OCIcodigo
--->
				</cfquery>
				<cfquery name="rsTRori" datasource="#session.dsn#">
					select 
						ee.OCTTdocumento, 
						a.Acodigo, a.Adescripcion,
						dd.OCTTDcantidad as Cantidad,
						dd.OCTTDcostoTotal as Monto
					from OCtransporteTransformacion ee
						inner join OCtransporteTransformacionD dd
							 on dd.OCTTid=ee.OCTTid
						inner join Articulos a
							 on a.Aid   = dd.Aid
					where dd.OCTid			= #LvarOCTid#
					  and ee.OCTTestado		= 1
					  and dd.OCTTDtipoOD	= 'O'
					order by ee.OCTTdocumento, a.Acodigo
				</cfquery>
				<cfquery name="rsTRdst" datasource="#session.dsn#">
					select 
						ee.OCTTdocumento, 
						a.Acodigo, a.Adescripcion,
						dd.OCTTDcantidad as Cantidad,
						dd.OCTTDcostoTotal as Monto
					from OCtransporteTransformacion ee
						inner join OCtransporteTransformacionD dd
							 on dd.OCTTid=ee.OCTTid
						inner join Articulos a
							 on a.Aid   = dd.Aid
					where ee.OCTTestado		= 1
					  and dd.OCTid			= #LvarOCTid#
					  and dd.OCTTDtipoOD	= 'D'
					order by ee.OCTTdocumento, a.Acodigo
				</cfquery>
				<!---
							<cfif rsORIs.recordcount LT 1>
								<tr>
								<td class="font_11B" colspan="9">NO HAY VENTAS REGISTRADAS. NO SE PROCESA EL COSTO</td>
								</tr>
							</cfif>
								<cfset LvarAid = rsORIs.Aid>
								<cfset LvarObservaciones = " ">
								<cfquery name="rsbuscaObs" dbtype="query">
									select sum(CantidadVentas) as CantidadVentas, sum(MontoVentas) as MontoVentas
									from rsDC
									where rsDC.Aid = #LvarAid#
								</cfquery>
								<cfif rsbuscaObs.recordcount GT 0>
									<cfset LvarObservaciones = " ">
									<cfif rsORIs.CostoCompra EQ 0 or rsORIs.CantidadCompra EQ 0>
										<cfset LvarObservaciones = LvarObservaciones & "No hay compras procesadas <br />" >
									</cfif>
									<cfif rsbuscaObs.CantidadVentas EQ 0 or rsbuscaObs.MontoVentas EQ 0>
										<cfset LvarObservaciones = LvarObservaciones & "No hay ventas procesadas <br />" >
									</cfif>
									<cfif rsORIs.CantidadCompra LT rsbuscaObs.CantidadVentas * 0.9>
										<cfset LvarObservaciones = LvarObservaciones & "Cantidad en Compras <br />" >
									</cfif>
									<cfif rsORIs.CostoCompra LT rsbuscaObs.MontoVentas>
										<cfset LvarObservaciones = LvarObservaciones & "Venta menor al Costo <br />" >
									</cfif>
								<cfelse>
									<cfset LvarObservaciones = "Error: No Existe Contrato de Venta ">
								</cfif>
				--->
				<cfset LvarLineas = LvarLineas + max(rsORIs.recordCount,max(rsDSTs.recordCount,max(rsTRori.recordCount,rsTRdst.recordCount)))>
				<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
					<tr class="font_11B">
						<td width="33%" class="font_11B">Origen</td>
						<td width="33%" class="font_11B">Transformacion</td>
						<td width="33%" class="font_11B">Destino</td>
					</tr>
					<tr valign="top">
						<td width="33%">
							<!---- ORIGEN ---->
							<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
								<tr class="font_11B">
									<td nowrap width="10%" class="font_11B" style="border-top:none">O.C.</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none">Producto</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none">Concepto</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Cantidad</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Monto</td>
								</tr>
								<cfset LvarOCtipoIC		= "">
								<cfset LvarOCcontrato	= "">
								<cfset LvarAcodigo		= "">
								<cfloop query="rsORIs">
									<cfif LvarOCtipoIC NEQ rsORIs.OCtipoIC>
										<cfset LvarOCtipoIC = rsORIs.OCtipoIC>
										<cfset LvarOCcontrato	= "">
										<cfset LVarAcodigo		= "">
										<tr class="font_11B">
											<td class="font_11" nowrap colspan="5">#rsORIs.OCtipoIC#</td>
										</tr>
									</cfif>
									<tr>
									<cfif LvarOCcontrato NEQ rsORIs.OCcontrato>
										<cfset LvarOCcontrato	= rsORIs.OCcontrato>
										<cfset LvarAcodigo		= "">
										<td class="font_11" nowrap >#rsORIs.OCcontrato#</td>
									<cfelse>
										<td class="font_11" nowrap >&nbsp;</td>
									</cfif>
									<cfif LvarAcodigo NEQ rsORIs.Acodigo>
										<cfset LvarAcodigo		= rsORIs.Acodigo>
										<td class="font_11" nowrap >#rsORIs.Acodigo#</td>
									<cfelse>
										<td class="font_11" nowrap >&nbsp;</td>
									</cfif>
										<td class="font_11" nowrap >#rsORIs.OCCcodigo#</td>
										<td class="font_11" nowrap align="right">&nbsp;&nbsp;#NumberFormat(rsORIs.Cantidad, ",0.00")#</td>
										<td class="font_11" nowrap align="right">&nbsp;&nbsp;#NumberFormat(rsORIs.Monto, ",0.00")#</td>
									</tr>
								</cfloop>
							</table>
						</td>
						<td width="33%">
							<!---- TRANSFORMACION ---->
							<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
							<tr><td valign="top">
								<table width="100%" cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
									<tr class="font_11B">
										<td nowrap width="10%" class="font_11B" style="border-top:none">Mezclado</td>
										<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Cantidad</td>
										<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Monto</td>
									</tr>
									<cfset LvarOCTTdoc = "">
									<cfloop query="rsTRori">
										<cfif LvarOCTTdoc NEQ rsTRori.OCTTdocumento>
											<cfset LvarOCTTdoc = rsTRori.OCTTdocumento>
											<tr>
												<td nowrap class="font_11" colspan="3"><strong>Documento #rsTRori.OCTTdocumento#</strong></td>
											</tr>
										</cfif>
										<tr class="font_11">
											<td nowrap >#rsTRori.Acodigo#</td>
											<td nowrap align="right">#NumberFormat(rsTRori.Cantidad, ",0.00")#</td>
											<td nowrap align="right">#NumberFormat(rsTRori.Monto, ",0.00")#</td>
										</tr>
									</cfloop>
								</table>
							</td>
							<td valign="top">	
								<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
									<tr class="font_11B">
										<td nowrap width="10%" class="font_11B" style="border-top:none">Transfor.</td>
										<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Cantidad</td>
										<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Monto</td>
									</tr>
									<cfset LvarOCTTdoc = "">
									<cfloop query="rsTRdst">
										<cfif LvarOCTTdoc NEQ rsTRdst.OCTTdocumento>
											<cfset LvarOCTTdoc = rsTRdst.OCTTdocumento>
											<tr class="font_11">
												<td class="font_11" nowrap colspan="3"><strong>Documento #rsTRdst.OCTTdocumento#</strong></td>
											</tr>
										</cfif>
										<tr class="font_11">
											<td nowrap >#rsTRdst.Acodigo#</td>
											<td nowrap align="right">#NumberFormat(rsTRdst.Cantidad, ",0.00")#</td>
											<td nowrap align="right">#NumberFormat(rsTRdst.Monto, ",0.00")#</td>
										</tr>
									</cfloop>
								</table>
							</td></tr>
							</table>
						</td>
						<td>
							<!---- DESTINOS ---->
							<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
								<tr class="font_11B">
									<td nowrap width="10%" class="font_11B" style="border-top:none">O.C.</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none">Producto</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none">Concepto</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Cantidad</td>
									<td nowrap width="10%" class="font_11B" style="border-top:none" align="right">Monto</td>
								</tr>
								<cfset LvarOCtipoIC		= "">
								<cfset LvarOCcontrato	= "">
								<cfset LvarAcodigo		= "">
								<cfloop query="rsDSTs">
									<cfif LvarOCtipoIC NEQ rsDSTs.OCtipoIC>
										<cfset LvarOCtipoIC = rsDSTs.OCtipoIC>
										<cfset LvarOCcontrato	= "">
										<cfset LVarAcodigo		= "">
										<tr class="font_11B">
											<td nowrap class="font_11" colspan="3">#rsDSTs.OCtipoIC#</td>
										</tr>
									</cfif>
									<tr>
									<cfif LvarOCcontrato NEQ rsDSTs.OCcontrato>
										<cfset LvarOCcontrato	= rsDSTs.OCcontrato>
										<cfset LvarAcodigo		= "">
										<td class="font_11" nowrap >#rsDSTs.OCcontrato#</td>
									<cfelse>
										<td class="font_11" nowrap >&nbsp;</td>
									</cfif>
									<cfif LvarAcodigo NEQ rsDSTs.Acodigo>
										<cfset LvarAcodigo		= rsDSTs.Acodigo>
										<td class="font_11" nowrap >#rsDSTs.Acodigo#</td>
									<cfelse>
										<td class="font_11" nowrap >&nbsp;</td>
									</cfif>
										<td class="font_11" nowrap >#rsDSTs.OCIcodigo#</td>
										<td class="font_11" nowrap align="right">&nbsp;&nbsp;#NumberFormat(rsDSTs.Cantidad, ",0.00")#</td>
										<td class="font_11" nowrap align="right">&nbsp;&nbsp;#NumberFormat(rsDSTs.Monto, ",0.00")#</td>
									</tr>
								</cfloop>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
	</cfif>
	<!--- IncluirS: Saldos --->
	<cfif isdefined("form.chkIncluirSaldos") OR isdefined("form.chkIncluirCostos")>
    <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsPT" datasource="#session.dsn#">
			select  
					t.OCTid, t.OCTtipo, t.OCTtransporte,
					a.Aid, a.Acodigo, 
					pt.OCPTtransformado,
					pt.OCPTentradasCantidad as entradasCantidad,
					pt.OCPTentradasCostoTotal as entradasCosto,

					case 
						when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
							then pt.OCPTentradasCantidad
							else -pt.OCPTsalidasCantidad
					end as salidasCantidad,
					case 
						when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
							then pt.OCPTentradasCostoTotal
							else -pt.OCPTsalidasCostoTotal
					end as salidasCosto,

					case 
						when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
							then 0
							else pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad
					end as existenciasCantidad,
					case 
						when t.OCTestado = 'C' AND t.OCTnumCierre>0 AND t.OCTfechaCierre IS NOT NULL
							then 0
							else pt.OCPTentradasCostoTotal + pt.OCPTsalidasCostoTotal
					end as existenciasCosto,

					pt.OCPTventasCantidad as ventasCantidad,
					pt.OCPTventasMontoTotal as ventasMonto,
					pt.OCPTentradasCantidad-pt.OCPTventasCantidad as saldoVentaCantidad,
					case  when pt.OCPTentradasCantidad < 0 or pt.OCPTentradasCostoTotal < 0 then 'Entradas ' end
					#_Cat#
					case  when pt.OCPTsalidasCantidad>0 or pt.OCPTsalidasCostoTotal>0 then 'Salidas ' end
					#_Cat#
					case  when t.OCTestado <> 'C' AND (
								pt.OCPTentradasCantidad+pt.OCPTsalidasCantidad < 0 
					  		or  pt.OCPTentradasCostoTotal+pt.OCPTsalidasCostoTotal < 0
							)
							 then 'Existencias ' end
					#_Cat#
					case  when pt.OCPTventasCantidad < 0 or pt.OCPTventasMontoTotal < 0 then 'Ventas ' end
					#_Cat#
					case  when t.OCTestado <> 'C' AND (pt.OCPTentradasCantidad-pt.OCPTventasCantidad < 0) then 'SaldoVenta ' end
					as InconsistenciaEn
			from OCproductoTransito pt
				inner join OCtransporte t on t.OCTid=pt.OCTid
				inner join Articulos a on a.Aid=pt.Aid
			where pt.OCTid = #rsTransportes.OCTid#
			order by a.Acodigo
		</cfquery>
	
		<cfif isdefined("form.chkIncluirSaldos")>
			<tr class="font_11B">
				<td colspan="5" rowspan="2"  class="font_11B" width="10%">Artículo</td>
				<td width="1%" align="center" rowspan="2"  class="font_11B">Trans-<br>formado</td>
				<td colspan="8" align="center" valign="middle" rowspan="2"  class="font_11B">Inconsistencias</td>
				<td align="right" class="font_11B" rowspan="2">Costo Uni.</td>
				<td align="center" valign="top" colspan="2" class="font_11B">Entradas</td>
				<td align="center" valign="top" colspan="2" class="font_11B">Salidas<br>(Costo)</td>
				<td align="center" valign="top" colspan="2" class="font_11B">Existencias<br>(Tránsito)</td>
				<td align="center" valign="top" colspan="3" class="font_11B">Ventas</td>
			</tr>
			<tr class="font_11B">
				<td align="right" class="font_11B">Cantidad</td>
				<td align="right" class="font_11B">Costo</td>
				<td align="right" class="font_11B">Cantidad</td>
				<td align="right" class="font_11B">Costo</td>
				<td align="right" class="font_11B">Cantidad</td>
				<td align="right" class="font_11B">Costo</td>
				<td align="right" class="font_11B">Cantidad</td>
				<td align="right" class="font_11B">Monto</td>
				<td align="right" class="font_11B">Saldo Cant.</td>
			</tr>
		</cfif>

		<cfloop query="rsPT">
			<cfset LvarLineas = LvarLineas + 1>
			<cfif isdefined("form.chkIncluirSaldos")>
				<tr>
					<td colspan="5" class="font_11"><strong>#rsPT.Acodigo#</strong></td>
					<td align="center" class="font_11"><cfif rsPT.OCPTtransformado EQ 1><strong>(Producto Transformado)</strong></cfif></td>
					<td colspan="8" align="right" class="font_11">
						<font color="##FF0000">#InconsistenciaEn#</font>
					</td>
					<td align="right" class="font_11">
						<cfif rsPT.entradasCantidad EQ 0>
							<cfset LvarCostoUnitario = 0>
						<cfelse>
							<cfset LvarCostoUnitario = rsPT.entradasCosto/rsPT.entradasCantidad>
						</cfif>
						#numberFormat(LvarCostoUnitario,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.entradasCantidad,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.entradasCosto,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.salidasCantidad,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.salidasCosto,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.existenciasCantidad,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.existenciasCosto,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.ventasCantidad,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.ventasMonto,",9.00")#
					</td>
					<td align="right" class="font_11">
						#numberFormat(rsPT.saldoVentaCantidad,",9.00")#
					</td>
				</tr>
			</cfif>


			<!--- IncluirM: Movimientos --->
			<cfif isdefined("form.chkIncluirMovimientos") OR isdefined("form.chkIncluirCostos")>
				<cfquery name="rsMOVs" datasource="#session.dsn#">
					select  
						m.OCTid, m.Aid, a.Acodigo,
						pt.OCPTtransformado, pt.OCPTentradasCantidad,
						OCPTMtipoOD, OCPTMtipoICTV,

						case 
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'I' then 'OI=Origen Salidas Inventario (De Almacén)'
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'C' then 'OC=Origen Comercial (Compras)'
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'T' then 'OT=Origen Transformación (Productos Dst. Transformados)'
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'O' then 'OO=Otros Costos'
	
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'I' then 'DI=Destino Entradas a Inventario (Recepcion Almacén)'
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'C' then 'DC=Destino Comercial (Ventas de Tránsito)'
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'T' then 'DT=Destino Transformación (Productos Ori. Mezclados)'
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'O' then 'DO=Otros Ingresos'
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'X' then 'DX=Cierre Transporte'

							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'V' then 'DV=Ventas de Almacén'
						end as TipoMov,
	
						case 
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'I' then 0
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'C' then 1
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'O' then 2
							when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'T' then 3
	
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'I' then 4
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'C' then 5
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'T' then 6
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'O' then 7
							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'X' then 8

							when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'V' then 9
						end as OrderMov,
	
						case 
							when OCPTMtipoOD = 'O' then
								(select OCCcodigo from OCconceptoCompra where OCCid = m.OCCid)
							when OCPTMtipoOD = 'D' then
								(select OCIcodigo from OCconceptoIngreso where OCIid = m.OCIid)
						end as Concepto,
	
						oc.OCcontrato,
						m.SNid, 	(select SNcodigo from SNegocios where SNid = m.SNid) as SNcodigo,
						m.Alm_Aid, 	(select Almcodigo from Almacen where Aid = m.Alm_Aid) as Almcodigo, 
						Oorigen, OCPTMreferenciaOri, OCPTMdocumentoOri,
						(select min(OCPTDperiodo*100+OCPTDmes) from OCPTdetalle where OCPTMid = m.OCPTMid and OCPTDtipoMov<>'I') as AnoMes,
						(select min(OCPTDperiodo*100+OCPTDmes) from OCPTdetalle where OCPTMid = m.OCPTMid and OCPTDtipoMov='I') as AnoMesI,
						OCPTMfechaTC,
						OCPTMfechaCV,
						OCPTMcantidad, m.Ucodigo,
						(select Miso4217 from Monedas where Mcodigo = m.McodigoOrigen) as Miso4217,
						OCPTMmontoOrigen,
						OCPTMmontoValuacion,
						OCPTMmontoLocal,
						OCPTMventaCantidad,
						OCPTMventaOrigen,
						OCPTMventaValuacion,
						OCPTMventaLocal,
						1 as x		
					  from OCPTmovimientos m
						inner join OCproductoTransito pt
							 on pt.OCTid 	= m.OCTid
							and pt.Aid		= m.Aid
						inner join Articulos a
							 on a.Aid		= m.Aid
						left join OCordenComercial oc 
							on oc.OCid = m.OCid
					where m.OCTid	= #rsPT.OCTid#
					  and m.Aid		= #rsPT.Aid#

					
				<cfif LvarFiltrarOCPTMtipoICTV OR isdefined("chkSoloDstMes") OR isdefined("form.chkSoloConPendientes")>
					  AND (		OCPTMtipoOD = 'O'	OR
					  			OCPTMtipoOD != 'O'
					<cfif LvarFiltrarOCPTMtipoICTV>
					  		and m.OCPTMtipoICTV	IN (#preservesinglequotes(LvarInOCPTMtipoICTV)#)
					</cfif>
					<cfif isdefined("chkSoloDstMes")>
					  		and (
									select count(1)
									  from OCPTdetalle dets
									 where dets.OCPTMid 		= m.OCPTMid
									   and dets.OCPTDperiodo	= #form.dstAno#
									   and dets.OCPTDmes     	= #form.dstMes#
								) > 0
					</cfif>
					<cfif isdefined("form.chkSoloConPendientes")>
					  		and (
									select count(1)
									  from CCVProducto cv
									 where cv.Ecodigo 		= m.Ecodigo
									   and cv.CCTcodigo		= m.OCPTMreferenciaOri
									   and cv.Ddocumento	= m.OCPTMdocumentoOri
									   and cv.DDtipo		= 'O'
									   and cv.CCVPestado	= 0
								) > 0
					</cfif>
						  )
				</cfif>
					order by OrderMov, OCPTMfechaTC
				</cfquery>
				<cfif NOT isdefined("form.chkIncluirSaldos") AND rsMOVs.recordCount NEQ 0>
					<tr>
						<td colspan="5" class="font_11"><strong>Artículo: #rsPT.Acodigo#</strong></td>
						<td align="center" class="font_11"><cfif rsPT.OCPTtransformado EQ 1><strong>(Producto Transformado)</strong></cfif></td>
					</tr>
				</cfif>
			</cfif>
			<cfif isdefined("form.chkIncluirMovimientos")>
				<cfif rsMOVs.recordCount GT 0>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td colspan="14" class="font_11B" align="center">Movimientos</td>
						<td colspan="2" class="font_11B" align="center">Entradas</td>
						<td colspan="2" class="font_11B" align="center">Salidas</td>
						<td colspan="2" class="font_11B" align="center">Existencias</td>
						<td colspan="3" class="font_11B" align="center">Ventas</td>
					</tr>
					<tr>
						<td class="font_11">&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td align="left" class="font_11b" width="1">
							Aux.
						</td>
						<td align="left" class="font_11b">
							Ref.
						</td>
						<td align="left" class="font_11b">
							Documento
						</td>
						<td align="center" class="font_11b">
							FechaTC
						</td>
						<td align="center" class="font_11b">
							Periodo
						</td>
						<td align="left" class="font_11b">
							O.C.
						</td>
						<td align="left" class="font_11b">
							Socio
						</td>
						<td align="left" class="font_11b">
							Alm.
						</td>
						<td align="center" class="font_11b">
							Conc.
						</td>
						<td colspan="2" align="right" class="font_11b">
							Cantidad
						</td>
						<td colspan="2" align="right" class="font_11b">
							Monto Origen
						</td>
						<td align="right" class="font_11b">
							Monto Local
						</td>
						<td align="right" class="font_11C">Cantidad</td>
						<td align="right" class="font_11C">Costo</td>
						<td align="right" class="font_11C">Cantidad</td>
						<td align="right" class="font_11C">Costo</td>
						<td align="right" class="font_11C">Cantidad</td>
						<td align="right" class="font_11C">Costo</td>
						<td align="right" class="font_11C">Cantidad</td>
						<td align="right" class="font_11C">Monto</td>
						<td align="right" class="font_11C">Saldo Cant.</td>
					</tr>
					<cfset LvarTipoMov = "">
					<cfset LvarCantidad = 0>

					<cfset LvarCantidadM = 0>
					<cfset LvarTOTcantOriM = 0>
					<cfset LvarTOTcostOriM = 0>
					<cfset LvarTOTcantDstM = 0>
					<cfset LvarTOTcostDstM = 0>
					<cfset LvarTOTcantVntM = 0>
					<cfset LvarTOTcostVntM = 0>

					<cfset LvarTOTcantOri = 0>
					<cfset LvarTOTcostOri = 0>
					<cfset LvarTOTcantDst = 0>
					<cfset LvarTOTcostDst = 0>
					<cfset LvarTOTcantVnt = 0>
					<cfset LvarTOTcostVnt = 0>
					<cfloop query="rsMOVs">
						<cfset LvarLineas = LvarLineas + 1>
						<cfif LvarTipoMov NEQ rsMOVs.OCPTMtipoOD & rsMOVs.OCPTMtipoICTV>
							<cfset sbTotalMovsM("M")>
							<cfset LvarTipoMov = rsMOVs.OCPTMtipoOD & rsMOVs.OCPTMtipoICTV>
							<cfset LvarCantidad = LvarCantidad + 1>
							<cfset LvarCantidadM = 0>
							<cfset LvarTOTcantOriM = 0>
							<cfset LvarTOTcostOriM = 0>
							<cfset LvarTOTcantDstM = 0>
							<cfset LvarTOTcostDstM = 0>
							<cfset LvarTOTcantVntM = 0>
							<cfset LvarTOTcostVntM = 0>
							<tr>
								<td class="font_11">&nbsp;</td>
								<td align="left" class="font_11" colspan="15">
									<strong>Movimientos #rsMOVs.TipoMov#</strong>
								</td>
							</tr>
						</cfif>
						<cfset LvarCantidadM = LvarCantidadM + 1>
						<tr>
							<td class="font_11">&nbsp;</td>
							<td align="left" class="font_11">
								#rsMOVs.Oorigen#
							</td>
							<td align="left" class="font_11">
								#rsMOVs.OCPTMreferenciaOri#
							</td>
							<td align="left" class="font_11" nowrap>
								#rsMOVs.OCPTMdocumentoOri#
							</td>
							<td align="center" class="font_11">
								#dateFormat(rsMOVs.OCPTMfechaTC,"DD/MM/YYYY")#
							</td>
							<td align="center" class="font_11">
								<cfif rsMOVs.OCPTMtipoOD EQ "D" and (rsMOVs.OCPTMtipoICTV EQ "C" OR rsMOVs.OCPTMtipoICTV EQ "O" OR rsMOVs.OCPTMtipoICTV EQ "V")>
									#rsMOVs.AnoMesI#
								<cfelse>
									#rsMOVs.AnoMes#
								</cfif>
							</td>
							<td align="left" class="font_11" nowrap>
								#rsMOVs.OCcontrato#
							</td>
							<td align="left" class="font_11">
								#rsMOVs.SNcodigo#
							</td>
							<td align="left" class="font_11">
								#rsMOVs.Almcodigo#
							</td>
							<td align="center" class="font_11">
								#rsMOVs.Concepto#
							</td>
							<cfif rsMOVs.OCPTMtipoOD EQ "O">
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMcantidad,",9.99")#
								</td>
								<td class="font_11">
									#rsMOVs.Ucodigo#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMmontoOrigen,",9.00")#
								</td>
								<td class="font_11">
									#rsMOVs.Miso4217#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMmontoLocal,",9.00")#
								</td>
							<cfelseif rsMOVs.OCPTMtipoICTV EQ "C" OR rsMOVs.OCPTMtipoICTV EQ "O" OR rsMOVs.OCPTMtipoICTV EQ "V">
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaCantidad,",9.99")#
								</td>
								<td class="font_11">
									#rsMOVs.Ucodigo#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaOrigen,",9.00")#
								</td>
								<td class="font_11">
									#rsMOVs.Miso4217#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaLocal,",9.00")#
								</td>
							<cfelse>
								<td align="right" class="font_11">
									#numberFormat(-rsMOVs.OCPTMcantidad,",9.99")#
								</td>
								<td class="font_11">
									#rsMOVs.Ucodigo#
								</td>
								<td align="right" class="font_11">
									#numberFormat(-rsMOVs.OCPTMmontoOrigen,",9.00")#
								</td>
								<td class="font_11">
									#rsMOVs.Miso4217#
								</td>
								<td align="right" class="font_11">
									#numberFormat(-rsMOVs.OCPTMmontoLocal,",9.00")#
								</td>
							</cfif>
							<cfif rsMOVs.OCPTMtipoOD EQ "O">
								<cfset LvarTOTcantOri = LvarTOTcantOri + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostOri = LvarTOTcostOri + rsMOVs.OCPTMmontoValuacion>
								<cfset LvarTOTcantOriM = LvarTOTcantOriM + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostOriM = LvarTOTcostOriM + rsMOVs.OCPTMmontoValuacion>
								<!--- Entradas --->
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMcantidad,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMmontoValuacion,",9.00")#
								</td>
								<!--- Salidas --->
								<td class="font_11">&nbsp;</td>
								<td class="font_11">&nbsp;</td>
								<!--- Existencias --->
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcantOri+LvarTOTcantDst,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcostOri+LvarTOTcostDst,",9.99")#
								</td>
								<!--- Ventas --->
								<td class="font_11">&nbsp;</td>
								<td class="font_11">&nbsp;</td>
							<cfelseif LvarTipoMov EQ "DC" OR LvarTipoMov EQ "DO">
								<cfset LvarTOTcantVnt = LvarTOTcantVnt + rsMOVs.OCPTMventaCantidad>
								<cfset LvarTOTcostVnt = LvarTOTcostVnt + rsMOVs.OCPTMventaValuacion>
								<cfset LvarTOTcantDst = LvarTOTcantDst + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostDst = LvarTOTcostDst + rsMOVs.OCPTMmontoValuacion>
								<cfset LvarTOTcantVntM = LvarTOTcantVntM + rsMOVs.OCPTMventaCantidad>
								<cfset LvarTOTcostVntM = LvarTOTcostVntM + rsMOVs.OCPTMventaValuacion>
								<cfset LvarTOTcantDstM = LvarTOTcantDstM + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostDstM = LvarTOTcostDstM + rsMOVs.OCPTMmontoValuacion>
								<cfif LvarTipoMov EQ "DO">
									<!--- Entradas --->
									<td colspan="2" class="font_11">&nbsp;</td>
									<!--- Salidas --->
									<td colspan="2" align="center" class="font_11">
										N/A
									</td>
								<cfelseif rsMOVs.OCPTMfechaCV EQ "">
									<!--- Entradas --->
									<td colspan="2" class="font_11">&nbsp;</td>
									<!--- Salidas --->
									<td colspan="2" align="center" class="font_11">
										PENDIENTE
									</td>
								<cfelse>
									<!--- Entradas --->
									<td colspan="2" class="font_11" align="right">
										CV 
										#dateFormat(now(),"DD/MM/YYYY")#
										#rsMOVs.AnoMes#:
									</td>
									<!--- Salidas --->
									<td align="right" class="font_11">
										#numberFormat(rsMOVs.OCPTMcantidad,",9.99")#
									</td>
									<td align="right" class="font_11">
										#numberFormat(rsMOVs.OCPTMmontoValuacion,",9.00")#
									</td>
								</cfif>
								<!--- Existencias --->
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcantOri+LvarTOTcantDst,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcostOri+LvarTOTcostDst,",9.99")#
								</td>
								<!--- Ventas --->
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaCantidad,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaValuacion,",9.00")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcantOri-LvarTOTcantVnt,",9.99")#
								</td>
							<cfelseif LvarTipoMov EQ "DV">
								<cfset LvarTOTcantVntM = LvarTOTcantVntM + rsMOVs.OCPTMventaCantidad>
								<cfset LvarTOTcostVntM = LvarTOTcostVntM + rsMOVs.OCPTMventaValuacion>
								<cfset LvarTOTcantDstM = LvarTOTcantDstM + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostDstM = LvarTOTcostDstM + rsMOVs.OCPTMmontoValuacion>
								<cfif rsMOVs.OCPTMfechaCV EQ "">
									<!--- Entradas --->
									<td colspan="2" class="font_11">&nbsp;</td>
									<!--- Salidas --->
									<td colspan="2" align="center" class="font_11">
										PENDIENTE
									</td>
								<cfelse>
									<!--- Entradas --->
									<td colspan="2" class="font_11" align="right">
										CV 
										#dateFormat(rsMOVs.OCPTMfechaCV,"DD/MM/YYYY")#
										#rsMOVs.AnoMes#:
									</td>
									<!--- Salidas --->
									<td align="right" class="font_11">
										#numberFormat(rsMOVs.OCPTMcantidad,",9.99")#
									</td>
									<td align="right" class="font_11">
										#numberFormat(rsMOVs.OCPTMmontoValuacion,",9.00")#
									</td>
								</cfif>
								<!--- Existencias --->
								<td class="font_11" colspan="2">
									N/A
								</td>
								<!--- Ventas --->
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaCantidad,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMventaValuacion,",9.00")#
								</td>
								<td align="right" class="font_11">
									N/A
								</td>
							<cfelse>
								<!--- DI, DT, DX --->
								<cfset LvarTOTcantDst = LvarTOTcantDst + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostDst = LvarTOTcostDst + rsMOVs.OCPTMmontoValuacion>
								<cfset LvarTOTcantDstM = LvarTOTcantDstM + rsMOVs.OCPTMcantidad>
								<cfset LvarTOTcostDstM = LvarTOTcostDstM + rsMOVs.OCPTMmontoValuacion>
								<!--- Entradas --->
								<td class="font_11">&nbsp;</td>
								<td class="font_11">&nbsp;</td>
								<!--- Salidas --->
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMcantidad,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(rsMOVs.OCPTMmontoValuacion,",9.00")#
								</td>
								<!--- Existencias --->
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcantOri+LvarTOTcantDst,",9.99")#
								</td>
								<td align="right" class="font_11">
									#numberFormat(LvarTOTcostOri+LvarTOTcostDst,",9.99")#
								</td>
								<!--- Ventas --->
								<td class="font_11">&nbsp;</td>
								<td class="font_11">&nbsp;</td>
								<td class="font_11">&nbsp;</td>
							</cfif>
						</tr>
						<cfif LvarTipoMov EQ "DC" AND rsMOVs.OCPTMfechaCV NEQ "">
							<cfset LvarCostoOtros  = LvarCostoUnitario * rsMOVs.OCPTMcantidad - rsMOVs.OCPTMmontoValuacion>
							<cfif abs(LvarCostoOtros) GT 0.01>
								<tr>
									<cfset LvarTOTcostDst = LvarTOTcostDst + LvarCostoOtros>
									<cfset LvarTOTcostDstM = LvarTOTcostDstM + LvarCostoOtros>
									<td colspan="3" class="font_11">&nbsp;</td>
									<td colspan="13" class="font_11" align="right">Otros costos posteriores:</td>
									<!--- Salidas --->
									<td align="right" class="font_11">&nbsp;</td>
									<td align="right" class="font_11">
										#numberFormat(LvarCostoOtros,",9.00")#
									</td>
									<!--- Existencias --->
									<td align="right" class="font_11">
										#numberFormat(LvarTOTcantOri+LvarTOTcantDst,",9.99")#
									</td>
									<td align="right" class="font_11">
										#numberFormat(LvarTOTcostOri+LvarTOTcostDst,",9.99")#
									</td>
									<!--- Ventas --->
									<td colspan="3" align="right" class="font_11">&nbsp;</td>
								</tr>
							</cfif>
						</cfif>
					</cfloop>
					<cfset sbTotalMovsM("A")>
					<cfif rsPT.currentRow NEQ rsPT.recordCount or isdefined("form.chkIncluirCostos")>
						<tr><td>&nbsp;</td></tr>
					</cfif>
				</cfif>
			</cfif>
			<!--- IncluirAC: Asignacion de Costos --->
			<cfif isdefined("form.chkIncluirCostos")>
				<cfquery name="rsDSTs" dbtype="query">
					select * from rsMOVs
					 where rsMOVs.OCPTMtipoOD = 'D' 
					   AND rsMOVs.OCPTMtipoICTV <> 'T'
				</cfquery>
				<cfif rsDSTs.recordCount GT 0>
					<tr><td colspan="25">
					<table cellpadding="0" cellspacing="0" border="0" style="width:100%; border-collapse:collapse; padding-left:2px;padding-right:1px;">
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td colspan="11" class="font_11B" align="center">Movimientos Destinos de Ventas e Inventario</td>
							<td colspan="12" class="font_11B" align="center">Costos asignados por Movimiento Origen</td>
							<td rowspan="2" width="100px" class="font_11B" align="right">Utilidad</td>
						</tr>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td class="font_11B" width="1">Aux.</td>
							<td class="font_11B" width="1">Ref.</td>
							<td class="font_11B" width="1">Documento</td>
							<td class="font_11B" align="center">FechaTC</td>
							<td class="font_11B" align="center">Periodo</td>
							<td class="font_11B" width="1">O.C.</td>
							<td class="font_11B" width="1">Socio</td>
							<td class="font_11B" width="1" align="center">Conc.</td>
							<td class="font_11B" width="100px" align="right" colspan="2">Cantidad</td>
							<td class="font_11B" width="100px" align="right">Monto Valuación</td>
							<td class="font_11B" width="1">Aux.</td>
							<td class="font_11B" width="1">Ref.</td>
							<td class="font_11B" width="1">Documento</td>
							<td class="font_11B" align="center">FechaTC</td>
							<td class="font_11B" align="center">Periodo</td>
							<td class="font_11B" width="1">O.C.</td>
							<td class="font_11B" width="1">Socio</td>
							<td class="font_11B" width="1">Alm.</td>
							<td class="font_11B" width="1">Art.</td>
							<td class="font_11B" width="1" align="center">Conc.</td>
							<td class="font_11B" width="100px" width="1" align="right">Unitario</td>
							<td class="font_11B" width="100px" align="right">Costo Asignado</td>
						</tr>
							<cfset LvarTipoMov = "">
							<cfset LvarCantidad = 0>
							<cfset LvarCantidadT = 0>
							<cfset LvarCantidadM = 0>
							<cfset LvarTOTcantDst = 0>
							<cfset LvarTOTcostDst = 0>

							<cfset LvarTOTcostOri = 0>
							<cfloop query="rsDSTs">
								<cfset LvarLineas = LvarLineas + 1>
								<cfif LvarTipoMov NEQ rsDSTs.OCPTMtipoOD & rsDSTs.OCPTMtipoICTV>
									<cfset sbTotalMovsAC("M")>
									<cfset LvarTipoMov = rsDSTs.OCPTMtipoOD & rsDSTs.OCPTMtipoICTV>
									<cfset LvarCantidad = LvarCantidad + 1>

									<cfset LvarCantidadT = LvarCantidadT + 1>
									<cfset LvarCantidadM = 0>

									<cfset LvarTOTcantDstM = 0>
									<cfset LvarTOTcostDstM = 0>

									<cfset LvarTOTcostOriM = 0>
									<tr>
										<td class="font_11">&nbsp;</td>
										<td align="left" class="font_11" colspan="10">
											<strong>Movimientos #rsDSTs.TipoMov#</strong>
										</td>
									</tr>
								</cfif>
								<cfset LvarCantidadM = LvarCantidadM + 1>
								<cfif rsDSTs.OCPTMtipoOD EQ "O">
									<cfset LvarOCPTMcantidad	= rsDSTs.OCPTMcantidad>
									<cfset LvarOCPTMmonto		= rsDSTs.OCPTMmontoValuacion>
								<cfelseif rsDSTs.OCPTMtipoICTV EQ "C" OR rsDSTs.OCPTMtipoICTV EQ "O" OR rsDSTs.OCPTMtipoICTV EQ "V">
									<cfset LvarOCPTMcantidad	= rsDSTs.OCPTMventaCantidad>
									<cfset LvarOCPTMmonto		= rsDSTs.OCPTMventaValuacion>
								<cfelse>
									<cfset LvarOCPTMcantidad	= -rsDSTs.OCPTMcantidad>
									<cfset LvarOCPTMmonto		= -rsDSTs.OCPTMmontoValuacion>
								</cfif>

								<cfset LvarTOTcantDstD = LvarOCPTMcantidad>
								<cfset LvarTOTcostDstD = LvarOCPTMmonto>

								<cfset LvarTOTcantDstM = LvarTOTcantDstM + LvarOCPTMcantidad>
								<cfset LvarTOTcostDstM = LvarTOTcostDstM + LvarOCPTMmonto>

								<cfset LvarTOTcantDst = LvarTOTcantDst + LvarOCPTMcantidad>
								<cfset LvarTOTcostDst = LvarTOTcostDst + LvarOCPTMmonto>
								<tr>
									<td class="font_11W">&nbsp;</td>
									<td align="left" class="font_11W">
										#rsDSTs.Oorigen#
									</td>
									<td align="left" class="font_11W">
										#rsDSTs.OCPTMreferenciaOri#
									</td>
									<td align="left" class="font_11" nowrap>
										#rsDSTs.OCPTMdocumentoOri#
									</td>
									<td align="center" class="font_11W">
										#dateFormat(rsDSTs.OCPTMfechaTC,"DD/MM/YYYY")#
									</td>
									<td align="center" class="font_11W">
										<cfif rsDSTs.OCPTMtipoOD EQ "D" and (rsDSTs.OCPTMtipoICTV EQ "C" OR rsDSTs.OCPTMtipoICTV EQ "O" OR rsDSTs.OCPTMtipoICTV EQ "V")>
											#rsDSTs.AnoMesI#
										<cfelse>
											#rsDSTs.AnoMes#
										</cfif>
									</td>
									<td align="left" class="font_11" nowrap>
										#rsDSTs.OCcontrato#
									</td>
									<td align="left" class="font_11W">
										#rsDSTs.SNcodigo#
									</td>
									<td align="center" class="font_11W">
										#rsDSTs.Concepto#
									</td>
									<td align="right" class="font_11W">
										#numberFormat(LvarOCPTMcantidad,",9.99")#
									</td>
									<td class="font_11W">
										#rsDSTs.Ucodigo#
									</td>
									<td align="right" class="font_11W">
										#numberFormat(LvarOCPTMmonto,",9.00")#
									</td>
									<cfif LvarTipoMov EQ "DV">
										<!--- COSTO DE VENTA DE ALMACEN: El costo esta en el movimiento destino --->
										<cfif rsDSTs.OCPTMfechaCV EQ "">
											<td colspan="7" class="font_11" align="right">
												<strong>COSTO DE VENTA PENDIENTE: Costo Actual Almacén</strong>
											</td>
											<cfquery name="rsSQL" datasource="#session.dsn#" maxrows="1">
												select 
														round ( 
															case when Eexistencia <> 0 
																then coalesce(Ecostototal / Eexistencia,0) 
																else coalesce(Ecostou, 0.00) 
															end
														, 2) as CostoUnitario
												  from Existencias e
												 where e.Aid		= #rsDSTs.Aid#
												   and e.Alm_Aid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSTs.Alm_Aid#" null="#rsDSTs.Alm_Aid EQ ""#">
											</cfquery>
											<cfif rsSQL.recordCount EQ 0 OR LvarOCPTMcantidad EQ 0>
												<cfset LvarUnitario = 0>
											<cfelse>
												<cfset LvarUnitario = rsSQL.CostoUnitario>
											</cfif>
											<cfset LvarCosto = LvarUnitario * LvarOCPTMcantidad>
											<cfset LvarTOTcostOriM 	= LvarTOTcostOriM 	+ LvarCosto>
											<cfset LvarTOTcostOri 	= LvarTOTcostOri 	+ LvarCosto>
										<cfelse>
											<td colspan="7" class="font_11" align="right">
												<strong>COSTO DE VENTA ALMACÉN:</strong>
											</td>
											<cfset LvarCosto = -rsDSTs.OCPTMmontoValuacion>
											<cfif rsDSTs.OCPTMcantidad EQ 0>
												<cfset LvarUnitario = 0>
											<cfelse>
												<cfset LvarUnitario = LvarCosto/-rsDSTs.OCPTMcantidad>
											</cfif>
											<cfset LvarTOTcostOriM 	= LvarTOTcostOriM 	+ LvarCosto>
											<cfset LvarTOTcostOri 	= LvarTOTcostOri 	+ LvarCosto>
										</cfif>
										<td align="left" class="font_11W">
											#rsDSTs.Almcodigo#
										</td>
										<td align="center" class="font_11W">
											#rsDSTs.Acodigo#
										</td>
										<td align="center" class="font_11W">
											#rsDSTs.Concepto#
										</td>
										<td align="right" class="font_11W">
											#numberFormat(LvarUnitario,",9.99")#
										</td>
										<td align="right" class="font_11" style="cursor:pointer;"
											<!--- 
												Costo Asignado:\tCostoUnitarioAlmacen * CantidadVenta\n
												CostoU Almacen:\t#numberFormat(LvarUnitario,",9.99")#\n
												Cantidad Venta:\t#numberFormat(LvarOCPTMcantidad,",9.99")#\n
												Costo Asignado:\t#numberFormat(LvarCosto,",9.99")#
											--->
											onclick="alert('Costo Asignado:\tCostoUnitarioAlmacen * CantidadVenta\nCostoU Almacen:\t#numberFormat(LvarUnitario,",9.99")#\nCantidad Venta:\t#numberFormat(LvarOCPTMcantidad,",9.99")#\nCosto Asignado:\t#numberFormat(LvarCosto,",9.99")#')"
										>
											#numberFormat(LvarCosto,",9.99")#
										</td>
										<td align="right" class="font_11W">
											<strong>#numberFormat(LvarOCPTMmonto-LvarCosto,",9.00")#</strong>
										</td>
									<cfelseif LvarOCPTMcantidad EQ 0>
										<!--- COSTO CANTIDAD MOVIMIENTO DESTINO CERO --->
										<td colspan="11" class="font_11">
											<strong>No hay cantidad para el movimiento destino</strong>
										</td>
										<td align="right" class="font_11" style="cursor:pointer;"
											onclick="alert('El Movimiento Destino no tiene Cantidad, lo que genera un Costo Asignado = 0.00\n')"
										>
											0.00
										</td>
										<cfif rsDSTs.OCPTMtipoICTV EQ "C" OR rsDSTs.OCPTMtipoICTV EQ "O" or rsDSTs.OCPTMtipoICTV EQ "V">
											<td align="right" class="font_11W">
												<strong>#numberFormat(LvarOCPTMmonto,",9.00")#</strong>
											</td>
										<cfelse>
											<td class="font_11" align="right">
												N/A
											</td>
										</cfif>
									<cfelse>
										<cfset LvarTransformado = (rsDSTs.OCPTtransformado EQ 1)>
										<cfif LvarTransformado>
											<!--- COSTO PRODUCTO TRANSFORMADO:  Hay que leer la tabla de Transformaciones --->
											<cfquery name="rsORIs" datasource="#session.dsn#">
												select  
													MOVs_ORI.Aid, a.Acodigo,
													PTD.OCPTtransformado, PTD.OCPTentradasCantidad,
													OCPTMtipoOD, OCPTMtipoICTV,
							
													case 
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'I' then 'OI=Origen Salidas Inventario (De Almacén)'
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'C' then 'OC=Origen Comercial (Compras)'
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'O' then 'OO=Otros Costos'
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'T' then 'OT=Origen Transformación (Productos Dst. Transformados)'
								
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'I' then 'DI=Destino Entradas a Inventario (Recepcion Almacén)'
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'C' then 'DC=Destino Comercial (Ventas de Tránsito)'
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'O' then 'DO=Otros Ingresos'
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'T' then 'DT=Destino Transformación (Productos Ori. Mezclados)'
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'X' then 'DX=Cierre de Transporte'

														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'V' then 'DV=Ventas de Almacén'
													end as TipoMov,
								
													case 
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'I' then 0
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'C' then 1
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'O' then 2
														when OCPTMtipoOD = 'O' AND OCPTMtipoICTV = 'T' then 3
								
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'I' then 4
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'C' then 5
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'O' then 6
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'T' then 7
														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'X' then 8

														when OCPTMtipoOD = 'D' AND OCPTMtipoICTV = 'V' then 9
													end as OrderMov,
								
													case 
														when OCPTMtipoOD = 'O' then
															(select OCCcodigo from OCconceptoCompra where OCCid = MOVs_ORI.OCCid)
														when OCPTMtipoOD = 'D' then
															(select OCIcodigo from OCconceptoIngreso where OCIid = MOVs_ORI.OCIid)
													end as Concepto,
								
													oc.OCcontrato,
													MOVs_ORI.SNid, 	(select SNcodigo from SNegocios where SNid = MOVs_ORI.SNid) as SNcodigo,
													MOVs_ORI.Alm_Aid, 	(select Almcodigo from Almacen where Aid = MOVs_ORI.Alm_Aid) as Almcodigo, 
													Oorigen, OCPTMreferenciaOri, OCPTMdocumentoOri,
													(select min(OCPTDperiodo*100+OCPTDmes) from OCPTdetalle where OCPTMid = MOVs_ORI.OCPTMid and OCPTDtipoMov<>'I') as AnoMes,
													(select min(OCPTDperiodo*100+OCPTDmes) from OCPTdetalle where OCPTMid = MOVs_ORI.OCPTMid and OCPTDtipoMov='I') as AnoMesI,
													OCPTMfechaTC,
													OCPTMcantidad,
													<!---
														MovDst.Costo = MovDst.Cantidad * ((PD.ProporcionDst * ((MovOri.Costo / PO.OCPTentradasCantidad) * PO.cantidadMezclada)) / PD.cantidadTransformada)
													--->			
													TTD.OCTTDproporcionDst, MOVs_ORI.OCPTMmontoValuacion as costoOrigen, PTO.OCPTentradasCantidad as cantOrigen, TTO.OCTTDcantidad as cantMezclada, TTD.OCTTDcantidad as cantTransformada,
													((TTD.OCTTDproporcionDst * ((MOVs_ORI.OCPTMmontoValuacion / PTO.OCPTentradasCantidad) * TTO.OCTTDcantidad)) / TTD.OCTTDcantidad)
													as costoUnitario,
													1 as x		
											  from OCproductoTransito PTD
												inner join OCtransporteTransformacionD TTD
													 on TTD.OCTid		= PTD.OCTid
													and TTD.Aid			= PTD.Aid
													and TTD.OCTTDtipoOD	= 'D'
												inner join OCtransporteTransformacion TE
													  on TE.OCTTid		= TTD.OCTTid
													 and TE.OCTTestado	= 1
												inner join OCtransporteTransformacionD TTO
													inner join OCPTmovimientos MOVs_ORI
														inner join Articulos a
															 on a.Aid	= MOVs_ORI.Aid
														left join OCordenComercial oc 
															on oc.OCid 	= MOVs_ORI.OCid
														inner join OCproductoTransito PTO
															 on PTO.OCTid	= MOVs_ORI.OCTid
															and PTO.Aid		= MOVs_ORI.Aid
														 on MOVs_ORI.OCTid			= TTO.OCTid
														and MOVs_ORI.Aid			= TTO.Aid
														and MOVs_ORI.OCPTMtipoOD 	= 'O' AND MOVs_ORI.OCPTMtipoICTV IN ('I','C','O')
													 on TTO.OCTTid		= TTD.OCTTid
													and TTO.OCTTDtipoOD	= 'O'
												 where PTD.OCTid	= #rsDSTs.OCTid#
												   and PTD.Aid		= #rsDSTs.Aid#

												   and PTO.OCPTentradasCantidad <> 0
												   and TTD.OCTTDcantidad		<> 0
												order by Acodigo, OrderMov, OCPTMfechaTC
											</cfquery>
										<cfelse>
											<!--- Hay que leer los movimientos origenes del Articulo en rsMOVs --->
											<cfquery name="rsORIs" dbtype="query">
												select * from rsMOVs
												 where rsMOVs.OCPTMtipoOD = 'O' 
												   AND rsMOVs.OCPTMtipoICTV <> 'T'
												   AND rsMOVs.Aid = #rsDSTs.Aid#
											</cfquery>
										</cfif>
										<cfif rsORIs.recordCount EQ 0>
											<td colspan="11" class="font_11">
												<strong>No hay origenes para este producto</strong>
											</td>
											<td align="right" class="font_11" style="cursor:pointer;"
												onclick="alert('El Artículo no tiene movimientos Orígenes, lo que genera un Costo Asignado = 0.00\n')"
											>
												0.00
											</td>
										<cfelseif rsDSTs.OCPTMfechaCV EQ "">
											<td colspan="13" class="font_11">
												<strong>COSTO DE VENTA PENDIENTE: Asignación Preliminar del Costo</strong>
											</td>
											</tr>
											<cfset LvarCambioLin = true>
										<cfelse>
											<cfset LvarCambioLin = false>
										</cfif>
										<cfset LvarTOTcostOriD 	= 0>
										<cfloop query="rsORIs">
											<cfset LvarLineas = LvarLineas + 1>
											<cfif rsORIs.OCPTentradasCantidad EQ 0>
												<cfset LvarUnitario = 0>
											<cfelseif LvarTransformado>
												<cfset LvarUnitario = rsORIs.costoUnitario>
											<cfelse>
												<cfset LvarUnitario = rsORIs.OCPTMmontoValuacion/rsORIs.OCPTentradasCantidad>
											</cfif>
	
											<cfset LvarCosto = LvarUnitario * LvarOCPTMcantidad>
	
											<cfset LvarTOTcostOriD 	= LvarTOTcostOriD 	+ LvarCosto>
											<cfset LvarTOTcostOriM 	= LvarTOTcostOriM 	+ LvarCosto>
											<cfset LvarTOTcostOri 	= LvarTOTcostOri 	+ LvarCosto>
											<cfif LvarCambioLin>
												<tr>
												<td colspan="12" class="font_11W">&nbsp;</td>
											<cfelse>
												<cfset LvarCambioLin = true>
											</cfif>
											<td align="left" class="font_11W">
												#rsORIs.Oorigen#
											</td>
											<tr  ><td align="left" class="font_11W">
												#rsORIs.OCPTMreferenciaOri#
											</td>
											<td align="left" class="font_11" nowrap>
												#rsORIs.OCPTMdocumentoOri#
											</td>
											<td align="center" class="font_11W">
												#dateFormat(rsORIs.OCPTMfechaTC,"DD/MM/YYYY")#
											</td>
											<td align="center" class="font_11W">
												#rsORIs.AnoMes#
											</td>
											<td align="left" class="font_11" nowrap>
												#rsORIs.OCcontrato#
											</td>
											<td align="left" class="font_11W">
												#rsORIs.SNcodigo#
											</td>
											<td align="left" class="font_11W">
												#rsORIs.Almcodigo#
											</td>
											<td align="center" class="font_11W">
												#rsORIs.Acodigo#
											</td>
											<td align="center" class="font_11W">
												#rsORIs.Concepto#
											</td>
											<td align="right" class="font_11W">
												#numberFormat(LvarUnitario,",9.99")#
											</td>
											<td align="right" class="font_11" style="cursor:pointer;"
												<cfif LvarTransformado>
													<!---
														MovDst.Costo = MovDst.Cantidad * ((PD.ProporcionDst * ((MovOri.Costo / PO.OCPTentradasCantidad) * PO.cantidadMezclada)) / PD.cantidadTransformada)
													--->
													<!--- 
														Costo Unitario:\t(CostoOrigen/TotalEntradas*CantMezclada) * PropTransformacion / cantidadTransformada\n
														Costo Mov.Origen:\t#numberFormat(rsORIs.OCPTMmontoValuacion,",9.99")#\n
														Total Entradas:\t#numberFormat(rsORIs.OCPTentradasCantidad,",9.99")#\n
														Cant. Mezclada:\t#numberFormat(rsORIs.cantMezclada,",9.99")#\n
														Prop. Transformación:\t#numberFormat(rsORIs.OCTTDproporcionDst*100,",9.99")#%\n
														Cant. Tansformada:\t#numberFormat(rsORIs.cantTransformada,",9.99")#\n\n
														Costo Unitario:\t#numberFormat(LvarUnitario,",9.99")#\n
														Costo Asignado:\tCostoUnitario * CantidadVenta\n
														Cantidad Venta:\t#numberFormat(LvarOCPTMcantidad,",9.99")#\n
														Costo Asignado:\t#numberFormat(LvarCosto,",9.99")#
													--->
													onclick="alert('Costo Unitario:\t(CostoOrigen/TotalEntradas*CantMezclada) * PropTransformacion / cantidadTransformada\nCosto Mov.Origen:\t#numberFormat(rsORIs.costoOrigen,",9.99")#\nTotal Entradas:\t#numberFormat(rsORIs.OCPTentradasCantidad,",9.99")#\nCant. Mezclada:\t#numberFormat(rsORIs.cantMezclada,",9.99")#\nProp. Transformación:\t#numberFormat(rsORIs.OCTTDproporcionDst*100,",9.99")#%\nCant. Tansformada:\t#numberFormat(rsORIs.cantTransformada,",9.99")#\n\nCosto Unitario:\t#numberFormat(LvarUnitario,",9.99")#\nCosto Asignado:\tCostoUnitario * CantidadVenta\nCantidad Venta:\t#numberFormat(LvarOCPTMcantidad,",9.99")#\nCosto Asignado:\t#numberFormat(LvarCosto,",9.99")#')"
												<cfelse>
													<!--- 
														Costo Unitario:\tCostoOrigen / TotalEntradas\n
														Costo Mov.Origen:\t#numberFormat(rsORIs.OCPTMmontoValuacion,",9.99")#\n
														Total Entradas:\t#numberFormat(rsORIs.OCPTentradasCantidad,",9.99")#\n
														Costo Unitario:\t#numberFormat(LvarUnitario,",9.99")#\n\n
														Costo Asignado:\tCostoUnitario * CantidadVenta\n
														Cantidad Venta:\t#numberFormat(LvarOCPTMcantidad,",9.99")#\n
														Costo Asignado:\t#numberFormat(LvarCosto,",9.99")#
													--->
													onclick="alert('Costo Unitario:\tCostoOrigen / TotalEntradas\nCosto Mov.Origen:\t#numberFormat(rsORIs.OCPTMmontoValuacion,",9.99")#\nTotal Entradas:\t#numberFormat(rsORIs.OCPTentradasCantidad,",9.99")#\nCosto Unitario:\t#numberFormat(LvarUnitario,",9.99")#\n\nCosto Asignado:\tCostoUnitario * CantidadVenta\nCantidad Venta:\t#numberFormat(LvarOCPTMcantidad,",9.99")#\nCosto Asignado:\t#numberFormat(LvarCosto,",9.99")#')"
												</cfif>
											>
												#numberFormat(LvarCosto,",9.99")#
											</td>
											<td align="right" class="font_11W">&nbsp;</td>
											<td align="right" class="font_11W">&nbsp;</td>
										</cfloop>
										<cfif rsORIs.recordCount GT 0>
											<tr>
												<td colspan="23" class="font_11">&nbsp;</td>
												<td class="font_11" align="right">
													<strong>#numberFormat(LvarTOTcostOriD,",9.99")#</strong>
												</td>
												<cfif rsDSTs.OCPTMtipoICTV EQ "C" or rsDSTs.OCPTMtipoICTV EQ "V">
													<td class="font_11" align="right">
														<strong>#numberFormat(LvarOCPTMmonto - LvarTOTcostOriD,",9.99")#</strong>
													</td>
												<cfelse>
													<td align="right" class="font_11W">&nbsp;</td>
												</cfif>
												<td align="right" class="font_11W">&nbsp;</td>
											</tr>
										</cfif>
									</cfif>
								</tr>
							</cfloop>
							<cfset sbTotalMovsAC("A")>
							</table>
					</td></tr>
					<cfif rsPT.currentRow NEQ rsPT.recordCount>
						<tr><td>&nbsp;</td></tr>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<tr><td colspan="25" style="border-top:solid 1px ##CCCCCC">&nbsp;</td></tr>
	</cfif>
</cfoutput>
<cfoutput>
	</table>
	<strong>FIN DEL REPORTE</strong>
</cfoutput>

<cffunction name="sbTotalMovsM" access="private" output="true">
	<cfargument name="Nivel"	type="string"	required="yes">
	<cfif LvarCantidadM GT 1>
						<tr>
							<td class="font_11" colspan="15">&nbsp;</td>
						<cfif mid(LvarTipoMov,1,1) EQ "O">
							<!--- Entradas --->
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantOriM,",9.99")#</strong>
							</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostOriM,",9.00")#</strong>
							</td>
							<!--- Salidas --->
							<td colspan="6" class="font_11">&nbsp;</td>
						<cfelse>
							<!--- Entradas --->
							<td colspan="2" class="font_11">&nbsp;</td>
							<!--- Salidas --->
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantDstM,",9.99")#</strong>
							</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostDstM,",9.00")#</strong>
							</td>
							<!--- Existencias --->
							<td colspan="2" class="font_11">&nbsp;</td>
							<cfif LvarTipoMov EQ "DC" OR LvarTipoMov EQ "DV">
								<!--- Ventas --->
								<td align="right" class="font_11">
									<strong>#numberFormat(LvarTOTcantVntM,",9.99")#</strong>
								</td>
								<td align="right" class="font_11">
									<strong>#numberFormat(LvarTOTcostVntM,",9.00")#</strong>
								</td>
								<td class="font_11">&nbsp;</td>
							<cfelse>
								<td colspan="3" class="font_11">&nbsp;</td>
							</cfif>
						</cfif>
						</tr>
	</cfif>
	<cfif LvarTipoMov NEQ "DV" AND (rsMOVs.OCPTMtipoICTV EQ "V" OR Arguments.Nivel EQ "A")>
						<tr>
							<td class="font_11">&nbsp;</td>
							<td class="font_11" colspan="14"><strong>TOTAL ARTICULO:</strong>&nbsp;</td>
							<!--- Entradas --->
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantOri,",9.99")#</strong>
							</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostOri,",9.00")#</strong>
							</td>
							<!--- Salidas --->
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantDst,",9.99")#</strong>
							</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostDst,",9.00")#</strong>
							</td>
							<!--- Existencias --->
							<td colspan="2" class="font_11">&nbsp;</td>
							<!--- Ventas --->
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantVntM,",9.99")#</strong>
							</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostVntM,",9.00")#</strong>
							</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantOriM-LvarTOTcantVntM,",9.00")#</strong>
							</td>
						</tr>
	</cfif>
</cffunction>

<cffunction name="sbTotalMovsAC" access="private" output="true">
	<cfargument name="Nivel"	type="string"	required="yes">
	<cfif LvarCantidadM GT 0>
						<tr>
							<td colspan="9" class="font_11">&nbsp;</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantDstM,",9.00")#</strong>
							</td>
							<td class="font_11">&nbsp;</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostDstM,",9.00")#</strong>
							</td>
							<td colspan="11" class="font_11">&nbsp;</td>
							<td class="font_11" align="right">
								<strong>#numberFormat(LvarTOTcostOriM,",9.99")#</strong>
							</td>
							<cfset LvarOCPTMtipoICTV = mid(LvarTipoMov,2,1)>
							<cfif LvarOCPTMtipoICTV EQ "C" or LvarOCPTMtipoICTV EQ "O" or LvarOCPTMtipoICTV EQ "V">
								<td class="font_11" align="right">
									<strong>#numberFormat(LvarTOTcostDstM - LvarTOTcostOriM,",9.99")#</strong>
								</td>
							<cfelse>
								<td class="font_11" align="right">
									N/A
								</td>
							</cfif>
						</tr>
	</cfif>
	<cfif Arguments.Nivel EQ "A" AND LvarCantidadT GT 1>
						<tr>
							<td class="font_11">&nbsp;</td>
							<td class="font_11" colspan="8"><strong>TOTAL ARTICULO:</strong>&nbsp;</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcantDst,",9.00")#</strong>
							</td>
							<td class="font_11">&nbsp;</td>
							<td align="right" class="font_11">
								<strong>#numberFormat(LvarTOTcostDst,",9.00")#</strong>
							</td>
							<td colspan="11" class="font_11">&nbsp;</td>
							<td class="font_11" align="right">
								<strong>#numberFormat(LvarTOTcostOri,",9.99")#</strong>
							</td>
							<td class="font_11" align="right">
								<strong>#numberFormat(LvarTOTcostDst - LvarTOTcostOri,",9.99")#</strong>
							</td>
						</tr>
	</cfif>
</cffunction>
	
<cffunction name="fnFiltroMovsDst" access="private" output="true" returntype="void">
	<cfargument name="OCPTM"	type="string"	required="yes">
	<cfargument name="OCTT"		type="string"	required="yes">
	<cfargument name="OCTid"	type="numeric"	required="no" default="-1">
	<cfargument name="Aid" 		type="string"	required="no" default="-1">

	<cfif form.dstMes NEQ "" AND (Arguments.OCTT NEQ "" OR isdefined("chkSoloDstMes"))>
		inner join OCPTdetalle dets
			 on dets.OCPTMid 		= #OCPTM#.OCPTMid
			and dets.OCPTDperiodo	= #form.dstAno#
			and dets.OCPTDmes     	= #form.dstMes#
	</cfif>
	<cfif isdefined("form.chkSoloConPendientes")>
		inner join CCVProducto cv
			 on cv.Ecodigo 		= #OCPTM#.Ecodigo
			and cv.CCTcodigo	= #OCPTM#.OCPTMreferenciaOri
			and cv.Ddocumento	= #OCPTM#.OCPTMdocumentoOri
			and cv.DDtipo		= 'O'
			and cv.CCVPestado	= 0
	</cfif>
</cffunction>
