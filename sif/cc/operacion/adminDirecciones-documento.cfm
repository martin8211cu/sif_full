<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 6-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
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
	<cfset form.LvarRecibo = url.LvarReciboB>
</cfif>

<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>


<!--- *************************************************************************************************** --->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsReporte" datasource="#Session.DSN#">
	select 
		(select o.Oficodigo
			from Oficinas o
			where o.Ecodigo  = he.Ecodigo
				and o.Ocodigo = he.Ocodigo) as OficinaEnc,
	
		(select cc.Cformato
			from CContables cc
			where cc.Ccuenta = hd.Ccuenta) as CuentaDelDetalle,
	
		(select cc.Cformato
			from CContables cc
			where cc.Ccuenta = he.Ccuenta) as CuentaDelEncabezado,
	
		(select m.Mnombre
			from Monedas m
			where m.Mcodigo = he.Mcodigo) as MonedaEnc,
	
		(select coalesce(ds.direccion1,ds.direccion2,'N/A')
			from SNDirecciones snd
				inner join DireccionesSIF ds
					on ds.id_direccion = snd.id_direccion
			where snd.Ecodigo = he.Ecodigo
				and snd.SNcodigo = he.SNcodigo
				and snd.id_direccion = he.id_direccionFact
			) as DireccionFact,
			
			coalesce(
				(select hh.Edocumento
					from  BMovimientos bb
						inner join HEContables hh
							on hh.IDcontable = bb.IDcontable
					where bb.Ecodigo = he.Ecodigo
						and bb.Ddocumento = he.Ddocumento
						and bb.CCTcodigo = he.CCTcodigo
						and bb.CCTRcodigo = he.Dtref
						and bb.DRdocumento = he.Ddocref
						and bb.SNcodigo = he.SNcodigo
					),
					(select hh.Edocumento
					from BMovimientos bb
						inner join EContables hh
							on hh.IDcontable = bb.IDcontable
					where bb.Ecodigo = he.Ecodigo
						and bb.Ddocumento = he.Ddocumento
						and bb.CCTcodigo = he.CCTcodigo
						and bb.CCTRcodigo = he.Dtref
						and bb.DRdocumento = he.Ddocref
						and bb.SNcodigo = he.SNcodigo
						)
					) as asiento_pago,
					
		he.Dtipocambio as TipoCambioEnc,
		he.Ddocumento as DdocEnc,
		he.Dfecha as fechaencabezado,
		he.Dtotal as TotalEnc,
		coalesce(r.Rcodigo, 'N/A') as Rcodigo,
		coalesce (r.Rdescripcion, 'N/A') as Rdescripcion,
	
		c.CCTcodigo  #_Cat# ' - ' #_Cat# CCTdescripcion  as transaccion,
		hd.HDid, 
		hd.DDescripcion,
		hd.DDdescalterna,
		hd.DDcantidad,
		hd.DDpreciou,
		hd.DDdesclinea,
		hd.DDtotal,
		hd.DDtipo,
		hd.Ccuenta,
		hd.Dcodigo,
		
		sn.SNnombre,
		sn.SNnumero,
		sn.SNidentificacion,
		
		(i.Iporcentaje * hd.DDtotal/100.00) as impuestolinea,
		i.Icodigo
	
		from HDDocumentos hd
			inner join HDocumentos he
				on he.HDid = hd.HDid
			inner join SNegocios sn
				on sn.SNcodigo = he.SNcodigo
					and sn.Ecodigo = he.Ecodigo
			inner join CCTransacciones c 
				on c.Ecodigo = hd.Ecodigo 
				and c.CCTcodigo= hd.CCTcodigo
			left outer join Retenciones r
				on r.Ecodigo = he.Ecodigo
				and r.Rcodigo = he.Rcodigo
			inner join Impuestos i
				on i.Ecodigo = hd.Ecodigo
				and  i.Icodigo = hd.Icodigo
		where hd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and hd.HDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HDid_pago#">
</cfquery>

<cfquery name="rsTotalLineas" dbtype="query">
	select 
		sum(DDpreciou) as PrecioUnit, 
		sum(DDtotal) as TotalLinea,
		sum(impuestolinea) as impuestoEnc
	from rsReporte
</cfquery>

<!--- *************************************************************************************************** --->
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
				<cfset params ="">
				<cfset params2 ="">
				<cfset params3 ="">
				<cfset params = "&formatos=1&SNcodigo=#url.SNcodigo#&FechaI=#url.FechaI#&FechaF=#url.FechaF#&LvarRecibo=#url.LvarRecibo#">
				<cfif isdefined("form.IDocumento") and len(trim(form.IDocumento))>
					<cfset params = params & '&HDid=#form.IDocumento#'>
				</cfif>
				<cfif isdefined("form.Pagos")>
					<cfset params = params & '&Pagos=#form.Pagos#'>
				</cfif>
				<cfif isdefined("url.LvarReciboB")>
					<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
				</cfif>
				<cfif isdefined("url.CCTcodigo")>
					<cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
				</cfif>
				<!--- <cfdump var="#params#"> --->
				<cfset params2 = trim('&Recibo=#url.Recibo#&Fecha=#url.Fecha#&Asiento=#url.Asiento#&TC=#url.TC#&MontoOrigen=#url.MontoOrigen#&MontoLocal=#url.MontoLocal#')>
					<cfset params3 = "">
				<cfif isdefined("rsReporte") and rsReporte.recordcount gt 0>
					<cfset params3 = "&HDid=#rsReporte.HDid#&HDid_pago=#url.HDid_pago#">
				</cfif>
				<cf_rhimprime datos="/sif/cc/consultas/PagoRealizado_DetalleDocumento_formCC.cfm" paramsuri="#params##params2##params3#">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
			</td>
		</tr>
		<tr>	
			<td>&nbsp;</td>
			<td colspan="9" align="right" class="noprint">
				<cfoutput>
					<cfif isdefined("form.Pagos") and form.Pagos eq 2>
						<a href="DocPagado_PagosRealizados_formCC.cfm?#params##params2##params3#">Regresar</a> 
					<cfelse>
						<a href="PagoRealizado_DetallePago_formCC.cfm?#params##params2##params3#">Regresar</a> 
					</cfif>
				</cfoutput>
			</td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv1"><cfoutput>#session.Enombre#</cfoutput></td>
		  <td colspan="7" class="niv4" align="right">Fecha:&nbsp;<cfoutput>#dateformat(now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2">Consulta de Pagos Realizados</td>
		  <td colspan="2" class="niv4" align="right">Usuario:&nbsp;<cfoutput>#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2">Detalle del Documento</td>
		  <td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>  
		
		<cfoutput>	
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left" style="width:15%">C&oacute;digo:</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">Socio de Negocios:</td>
			  <td nowrap="nowrap" class="niv3" align="right" style="width:18%" colspan="1">Identificación:</td>
			  <td colspan="6">&nbsp;</td>
			</tr>
			<tr bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporte.SNnumero#</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#trim(rsReporte.SNnombre)#</td>
			  <td nowrap="nowrap" class="niv3" align="right" colspan="1">#rsReporte.SNidentificacion#</td>
			  <td colspan="6">&nbsp;</td>
			</tr>
			<!--- Inicio del Encabezado --->
			
		</cfoutput>
		<cf_templatecss>

		<cfoutput>
			<tr><td colspan="9" style="font-weight:bold; width:1%" bgcolor="E2E2E2"><div align="center">ENCABEZADO DEL DOCUMENTO</div></td></tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>Documento:</strong>&nbsp;</div></td>
				<td class="niv3"><div align="left">#rsReporte.DdocEnc#</td>
				<td class="niv3"><div align="right"><strong>Transacción:</strong>&nbsp;</div></td>
				<td class="niv3">#rsReporte.transaccion#</td>
				<td class="niv3"><div align="right"><strong>Fecha&nbsp;Factura:</strong>&nbsp;</div></td>
				<td class="niv3">
					#dateformat(rsReporte.fechaencabezado,'dd/mm/yyyy')#
				</td>
			</tr>
			<tr nowrap="nowrap">
				<td class="niv3"><div align="right">&nbsp;<strong>Proveedor:</strong>&nbsp;</div></td>
				<td nowrap="nowrap" align="left"  colspan="1" class="niv3">
					#rsReporte.SNnombre#
				</td>
				<td align="right" nowrap valign="top" class="niv3"><strong>Direcci&oacute;n facturaci&oacute;n:</strong>&nbsp;</td>
				<td valign="top" class="niv3">
					<cfif not len(trim(rsReporte.DireccionFact))>
						Ninguna
					<cfelse>
						#rsReporte.DireccionFact#
					</cfif> 
				</td>
				<td valign="top" class="niv3" align="right"><strong>Asiento:</strong>&nbsp;</td> 
				<td valign="top" class="niv3">#rsReporte.Asiento_pago#</td>
			</tr>
			<tr>
				<td class="niv3"><div align="right">&nbsp;<strong>Cuenta:</strong>&nbsp;</div></td>
					<td nowrap class="niv3">
					#rsReporte.CuentaDelEncabezado#
				</td>
				<td class="niv3"><div align="right"><strong>Moneda:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsReporte.MonedaEnc#
				</td>
				<td nowrap class="niv3"> <div align="right"><strong>Tipo Cambio:</strong>&nbsp;</div></td>
				<td class="niv3">
					#NumberFormat(rsReporte.TipoCambioEnc,'_,_.__')#
				</td>				
			</tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>Oficina:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsReporte.OficinaEnc#
				</td>
				<td nowrap align="right" class="niv3"><strong>Retenci&oacute;n al Pagar:</strong>&nbsp;</td>
				<td class="niv3">
					#rsReporte.Rdescripcion#
				</td>
				<td align="right"><strong>Subtotal:</strong>&nbsp;</td>
				<td>#NumberFormat(rsTotalLineas.TotalLinea,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="5" align="right"><strong>Impuesto:</strong>&nbsp;</td>
				<td align="left">#NumberFormat(rsTotalLineas.impuestoEnc,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="5" class="niv3"><div align="right"><strong>Total:</strong>&nbsp;</div></td>
				<td class="niv3"> 
					#NumberFormat(rsReporte.TotalEnc,'_,_.__')#
				</td>
			</tr>
		</cfoutput>
			<tr>
				<td colspan="12">&nbsp;</td>
			</tr>
		</table>
		<!--- Fin del Encabezado --->
		
			<!--- ************************************************************************************************ --->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor="E2E2E2">
				<td colspan="20" align="center" style="font-weight:bold; width:1%" nowrap="nowrap">DETALLE DEL DOCUMENTO</td>
			</tr>
			<tr> 
				<td class="subTitulo" colspan="20">
					<!--- registro seleccionado --->
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr bgcolor="E7E7E7" class="subTitulo">
									<td width="4%" valign="bottom"><strong>&nbsp;L&iacute;nea</strong></td>
									<td width="40%" valign="bottom"><strong>&nbsp;Descripci&oacute;n</strong></td>
									<td width="13%" valign="bottom"> <div align="right"><strong>Cantidad</strong></div></td>
									<td width="13%" valign="bottom"> <div align="right"><strong>Precio</strong></div></td>
									<td width="13%" valign="bottom"><div align="right"><strong>Descuento</strong></div></td>
									<td width="13%" valign="bottom"><div align="left"><strong>&nbsp;Cod. Imp.</strong></div></td>
									<td width="13%" valign="bottom"><div align="right"><strong>Impuesto</strong></div></td>
									<td width="13%" valign="bottom"> <div align="right"><strong>Total</strong></div></td>
									<td width="3%"  valign="bottom">&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								
								
								<cfoutput query="rsReporte"> 
									<tr>
										<td align="center">#CurrentRow#</td>
										<td>#rsReporte.DDescripcion#</td>
										<td align="right">#LSCurrencyFormat(rsReporte.DDcantidad,'none')#</td>
										<td align="right">#LSCurrencyFormat(rsReporte.DDpreciou,'none')#</td>
										<td align="right">#LSCurrencyFormat(rsReporte.DDdesclinea,'none')#</td>
										<td align="left">&nbsp;#rsReporte.Icodigo#</td>
										<td align="right">#LSCurrencyFormat(rsReporte.impuestolinea,'none')#</td>
										<td align="right">&nbsp;#LSCurrencyFormat(rsReporte.DDtotal,'none')#</td>
										<td align="right" width="3%">
										</td>
									</tr>
								</cfoutput> 
								
								<cfif rsReporte.Recordcount GT 0>
									<tr>
										<td>&nbsp;</td> 
										<td>&nbsp;</td> 
										<td><font size="1">&nbsp;</font></td>
										<td><font size="1">&nbsp;</font></td>
										<td>&nbsp;</td>
										<td width="14%">&nbsp;</td>
										<td>&nbsp;</td>
										<td><div align="right"><font size="1"><strong>Total:</strong></font></div></td>
										<td>
											<div align="right">
												<font size="1">
													<strong>
													<cfoutput>
														#LSCurrencyFormat(rsTotalLineas.TotalLinea,'none')#
													</cfoutput>
													</strong>
												</font>
											</div>
										</td>
										<td width="3%">&nbsp;</td>
									</tr>
								</cfif>
							</table>
						</form>
					 </td>
				</tr>
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
				
				
				/*document.form1.action="PagoRealizado_DetallePago_url.cfm?fecha=LvarFecha1&asiento=LvarAsiento1&recibo=LvarRecibo1";
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