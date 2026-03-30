<!--- 
	Consulta de Documentos de POS
	Fecha: 25 de Mayo del 2008
	objetivo: 
			Presentar el detalle de un documento de POS que no es de Credito
--->
<cfif isdefined("url.FAX01NTR") and not isdefined("form.FAX01NTR")>
	<cfset form.FAX01NTR = url.FAX01NTR>
</cfif>

<cfquery name="rsDocumentoPOS" datasource="#session.dsn#">
	select 
		t.FAX01NTR as Transaccion,
		t.FAM01COD as CodigoCaja,
		t.FAX01NTE as NumeroTransaccionExterna,
		t.TransExterna as TransaccionExtena,
		c.FAM01CODD as Caja,
		o.Oficodigo as Oficina,
		cl.CDCtipo as Tipo,
		cl.CDCidentificacion as IdentificacionCliente,
		substring(cl.CDCnombre, 1, 35) as NombreCliente,
		t.FAX01FEC as Fecha,
		t.CCTcodigo as CodigoTransaccion,
		t.FAX01DOC as NumeroDocumento,
		t.FAX01MDT + t.FAX01MDL as Descuento,
		t.FAX01MIT as Impuesto,
		t.FAX01TOT as Total,
		FAX01TIP as TipoTransaccion,
			(( select min(Miso4217) from Monedas m where m.Mcodigo = t.Mcodigo)) as Moneda,
		FAX01STA as Status,
		FAX01OBS as Observaciones
		
	from FAX001 t
		left outer join ClientesDetallistasCorp cl
		on cl.CDCcodigo = t.CDCcodigo
	
		inner join FAM001 c
		on c.FAM01COD = t.FAM01COD
		and c.Ecodigo = t.Ecodigo
	
		inner join Oficinas o
		on o.Ocodigo = t.Ocodigo
		and o.Ecodigo = t.Ecodigo
	
	where t.FAX01NTR = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.FAX01NTR#">
	  and t.Ecodigo = #session.Ecodigo# 
</cfquery>

<cfquery name="rsDocumentoPOSdetalle" datasource="#session.dsn#">
	select 
		d.FAX01NTR as NumeroTransaccion,
		d.FAX04LIN as Linea,
		d.FAX04CAN as Cantidad,
		d.FAX04PRE as Precio,
		d.FAX04DESC as Descuento,
		d.FAX04IMP as Impuesto,
		d.FAX04TOT as TotalLinea,
		d.FAX04DEL as LineaAnulada,
		d.FAX04DES as Descripcion,
		d.FAX04DDESC1 as Descripcion1,
		d.FAX04DDESC2 as Descripcion2,
		d.I19DES,
			case 
				when len(rtrim(d.CtaDesF)) > 0 and d.CtaDesF is not null 
				then d.CtaDesF 
				else ((
					select min(CFformato)
					from CFinanciera cf
					where cf.CFcuenta = d.CFcuentaD
					)) 
			end
		as CuentaDescuento,
	
			case 
				when len(rtrim(d.CtaVenF)) > 0 and d.CtaVenF is not null 
				then d.CtaVenF 
				else ((
					select min(CFformato)
					from CFinanciera cf
					where cf.CFcuenta = d.CFcuentaV
					)) 
			end
		as CuentaVenta
	from FAX001 t
		inner join FAX004 d
		on d.FAM01COD = t.FAM01COD
		and d.FAX01NTR = t.FAX01NTR
	
	where t.FAX01NTR = #url.FAX01NTR#
	  and t.Ecodigo  = #session.Ecodigo# 
	  and d.FAX04DEL = 0
</cfquery>

<cfquery name="rsDocumentoPOSPago" datasource="#session.dsn#">
	select 
		(FAX10EF1 + FAX10EF2 + FAX10EF3 ) as Efectivo,
		-FAX10CAM as Cambio,
		(FAX10EF1 + FAX10EF2 + FAX10EF3 - FAX10CAM ) as EfectivoTotal,
		FAX10CHK as Cheques,
		FAX10TCR as TarjetaCredito,
		FAX10OTR as Otros,
		FAX10TOT as Total
	from FAX001 t
		inner join FAX010 p
		on p.FAM01COD = t.FAM01COD
		and p.FAX01NTR = t.FAX01NTR
	
	where t.FAX01NTR = #url.FAX01NTR# 
	  and t.Ecodigo  = #session.Ecodigo#
</cfquery>

<cfquery name="rsDocumentoPOSPagoDetalle" datasource="#session.dsn#">
	select 
		d.FAX01NTR,
		d.FAX12LIN,
		d.Bid,
		b.Bdescripcion,
		d.FATid,
		tc.FATtipo,
		d.FAX12NUM,
		d.FAX12CTA,
		d.FAX12TOT,
		d.FAX12TIP,
		d.IdTipoBn,
		d.NumBono
	from FAX001 t
		inner join FAX012 d
		on d.FAM01COD = t.FAM01COD
		and d.FAX01NTR = t.FAX01NTR
	
		left outer join Bancos b
		on b.Bid = d.Bid
	
	
		left outer join FATarjetas tc
		on tc.FATid = d.FATid
	
	where t.FAX01NTR = #url.FAX01NTR#
	  and t.Ecodigo  = #session.Ecodigo#
</cfquery>


<form name="form1">
	<table width="100%" cellpadding="2" cellspacing="0" align="center">
		<tr>
			<td valign="top" width="50%">

				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
					<tr>
						<td>&nbsp;</td>
						<td colspan="8" align="right">
												
							<cf_rhimprime datos="/RPSA/TransaccionesPOS-DetalleDoc.cfm" paramsuri="&FAX01NTR=#form.FAX01NTR#">
							<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
						</td>
					</tr>
					<tr><td colspan="4"><strong>Datos del Documento:</strong><span style="font-size: 18px"> <cfoutput>&nbsp;#rsDocumentoPOS.CodigoTransaccion#&nbsp;-&nbsp;#rsDocumentoPOS.NumeroDocumento#</cfoutput></span></td></tr>
					<tr>
						<td colspan="2" align="center">
							<cfoutput>
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"> 
									<tr><td colspan="4">&nbsp;</td></tr>
									<tr>
										<td align="left"><strong>Socio:&nbsp;</strong></td>
										<td >#rsDocumentoPOS.IdentificacionCliente#- #rsDocumentoPOS.NombreCliente#</td>
										<td align="right"><strong>Fecha:&nbsp;</strong></td>
										<td align="right">#LSDateformat(rsDocumentoPOS.Fecha,"dd/mm/yyyy")#</td>
									</tr>
									<tr>
										<td align="left"><strong>Oficina:&nbsp;</strong></td>
										<td>#rsDocumentoPOS.Oficina#</td>
										<td align="right"><strong>Subtotal:&nbsp;</strong></td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOS.Total - rsDocumentoPOS.Impuesto + rsDocumentoPOS.Descuento,"none")#</td>
									</tr>
									<tr>
										<td align="left"><strong>Caja:</strong></td>
										<td>#rsDocumentoPOS.caja#</td>
										<td align="right"><strong>Descuento:&nbsp;</strong></td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOS.Descuento,"none")#</td>
									</tr>
									<tr>
										<td align="left"><strong>Transacci&oacute;n:</strong></td>
										<td align="left">#rsDocumentoPOS.Transaccion#</td>
										<td align="right"><strong>Impuesto:&nbsp;</strong></td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOS.Impuesto,"none")#</td>
									</tr>
									<tr>
										<td colspan="2">&nbsp;</td>
										<td align="right"><strong>Total:&nbsp;</strong></td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOS.Total,"none")#</td>
									</tr>
								</table>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="left"><strong>Observaciones:</strong>&nbsp; #rsDocumentoPOS.Observaciones#</td>
					</tr>
					</cfoutput>
				</table>
				<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Detalles de L&iacute;nea(s) del Documento</strong></td>
						<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Formas de Pago/Aplicaciones</strong></td>
					</tr>
					<tr>
						<td width="50%" valign="top">
							<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
								<tr>
									<td nowrap align="right"><strong>Cant.&nbsp;</strong></td>
									<td nowrap><strong>Desc Item</strong></td>
									<td nowrap align="right"><strong>Precio&nbsp;<br />Unitario&nbsp;</strong></td>
									<td nowrap align="right"><strong>Desc.&nbsp;</strong></td>
									<td nowrap align="right"><strong>Total&nbsp;<br />Linea&nbsp;</strong></td>
								</tr>
								<cfoutput query="rsDocumentoPOSdetalle">
									<tr class ="<cfif rsDocumentoPOSdetalle.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
										<td align="right">#numberformat(rsDocumentoPOSdetalle.cantidad, ',.00')#&nbsp;</td>
										<td> #rsDocumentoPOSdetalle.Descripcion#</td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOSdetalle.Precio,"none")#&nbsp;</td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOSdetalle.Descuento,"none")#&nbsp;</td>
										<td align="right">#LScurrencyFormat(rsDocumentoPOSdetalle.TotalLinea,"none")#&nbsp;</td>
									</tr>
								</cfoutput>
								<td colspan="4" nowrap align="center">***** Fin de Detalle *****</td>
						  </table>
						</td>
						<td width="50%" valign="top">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
								  <td nowrap><strong>&nbsp;Tipo</strong></td>
									<td nowrap><strong>Banco<br />Tarjeta</strong></td>
									<td nowrap ><strong>Numero</strong></td>
									<td nowrap align="right"><strong>Monto</strong></td>
								<cfoutput query="rsDocumentoPOSPagoDetalle">
									<tr class="<cfif rsDocumentoPOSPagoDetalle.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
										<td  nowrap >&nbsp;#rsDocumentoPOSPagoDetalle.FAX12TIP#</td>
										<td  nowrap><cfif len(trim(rsDocumentoPOSPagoDetalle.Bdescripcion))>#rsDocumentoPOSPagoDetalle.Bdescripcion#<cfelse>#rsDocumentoPOSPagoDetalle.FATtipo#</cfif></td>
										<td  nowrap>#rsDocumentoPOSPagoDetalle.FAX12NUM & rsDocumentoPOSPagoDetalle.FAX12CTA#</td>
										<td  nowrap align="right">
											<cfif rsDocumentoPOSPagoDetalle.FAX12TIP EQ 'EF'>
												#LScurrencyFormat(rsDocumentoPOSPago.EfectivoTotal,"none")#
											<cfelse>
												#LScurrencyFormat(rsDocumentoPOSPagoDetalle.FAX12TOT,"none")# 
											</cfif>
											
										</td>
									</tr>
								</cfoutput>
								<tr><td colspan="5" nowrap align="center">***** Fin de Formas de Pago *****</td></tr>
							</table>
						</td>
					</tr>
				</table>
			</td>	
		</tr>
		<tr><td align="center" class="noprint"><input type="button"  value="Regresar" name="btnConsultar" onclick="history.back();"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>	
</form>
