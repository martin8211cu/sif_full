<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 6-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfif not isdefined("url.LvarCuentasOcultas")>
	<cfset url.LvarCuentasOcultas = 2>
</cfif>

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

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_FECHA = t.Translate('LB_FECHA','Fecha','/sif/generales.xml')>
<cfset LB_ConsPagReal = t.Translate('LB_ConsPagReal','Consulta de Pagos Realizados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&oacute;n','/sif/generales.xml')>
<cfset LB_TRAMITE = t.Translate('LB_TRAMITE','Transacción','/sif/generales.xml')>
<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_Cuenta = t.Translate(' LB_Cuenta','Cuenta ','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio 	= t.Translate('LB_Tipo_de_Cambio','Tipo Cambio','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Subtotal 	= t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción','/sif/generales.xml')>


<cfset LB_Documento = t.Translate('LB_Documento','Documento','DocPagado_sqlCC.xml')>
<cfset LB_Asiento = t.Translate('LB_Asiento','Asiento','DocPagado_sqlCC.xml')>

<cfset LB_DetDocumento = t.Translate('LB_DetDocumento','Detalle del Documento','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_ENCDOCUMENTO = t.Translate('LB_ENCDOCUMENTO','ENCABEZADO DEL DOCUMENTO','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_FechaFac = t.Translate('LB_FechaFac','Fecha Factura','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_DirFacturacion = t.Translate('LB_DirFacturacion','Direcci&oacute;n facturaci&oacute;n','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_Ninguna = t.Translate('LB_Ninguna','Ninguna','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_OcultarCtasDet = t.Translate('LB_OcultarCtasDet','Ocultar Cuentas del Detalle','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_MostrarCtasDet = t.Translate('LB_MostrarCtasDet','Mostrar Cuentas del Detalle','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_RetPago = t.Translate('LB_RetPago','Retenci&oacute;n al Pagar','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_Impuesto = t.Translate('LB_Impuesto','Impuesto','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_Linea = t.Translate('LB_Linea','L&iacute;nea','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_Cantidad = t.Translate('LB_Cantidad','Cantidad','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_Precio = t.Translate('LB_Precio','Precio','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_Descuento = t.Translate('LB_Descuento','Descuento','PagoRealizado_DetalleDocumento_formCC.xml')>
<cfset LB_CodImp = t.Translate('LB_CodImp','Cod. Imp.','PagoRealizado_DetalleDocumento_formCC.xml')>
    
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
				
				
				<cfif isdefined("form.Pagos") and form.Pagos eq 2><!--- #params#<br>#params2#<br>#params3#<br> --->
					<cfset LvarRegresa = "DocPagado_PagosRealizados_formCC.cfm?1=1#params##params2##params3#">
				<cfelse><!--- 2222 <br> 1-#params#<br> 2 #params2#<br> 3 #params3#<br> <cfdump var="#form#"><cfdump var="#url#"> --->
					<cfset LvarRegresa = "PagoRealizado_DetallePago_formCC.cfm?1=1#params##params2##params3#">
				</cfif>
				<cfoutput>
					<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
						<!--- <cfset url.LvarCuentasOcultas =""> --->
						<a class="noprint" href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1#params##params2##params3#&LvarCuentasOcultas=1">#LB_OcultarCtasDet#</a>
					<cfelseif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 1>
						<!--- <cfset url.LvarCuentasOcultas =""> ---> 
						
						<a  class="noprint" href="PagoRealizado_DetalleDocumento_formCC.cfm?1=1#params##params2##params3#">#LB_MostrarCtasDet#</a>
					</cfif>
					<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
						<cf_rhimprime datos="/sif/cc/consultas/PagoRealizado_DetalleDocumento_formCC.cfm" paramsuri="#params##params2##params3#&LvarCuentasOcultas=1" Regresar="#LvarRegresa#">
						<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
					<cfelseif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 1>
						<cf_rhimprime datos="/sif/cc/consultas/PagoRealizado_DetalleDocumento_formCC.cfm" paramsuri="#params##params2##params3#" Regresar="#LvarRegresa#">
						<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
					</cfif>
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
		  <td colspan="2" class="niv4" align="right">#LB_USUARIO#:&nbsp;#session.Usulogin# </td>
          </cfoutput>
		</tr>
		<tr style="font-weight:bold">
          <cfoutput>
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2">#LB_DetDocumento#</td>
		  <td>&nbsp;</td>
          </cfoutput>
		</tr>
		<tr>
			<td colspan="10">&nbsp;</td>
		</tr>  
		
		<cfoutput>	
			<tr style="font-weight:bold" bgcolor="CCCCCC">
			  <td nowrap="nowrap" class="niv3" align="left" style="width:15%">#LB_Codigo#:</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#LB_SocioNegocio#:</td>
			  <td nowrap="nowrap" class="niv3" align="right" style="width:18%" colspan="1">#LB_Identificacion#:</td>
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
			<tr><td colspan="9" style="font-weight:bold; width:1%" bgcolor="E2E2E2"><div align="center">#LB_ENCDOCUMENTO#</div></td></tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>#LB_Documento#:</strong>&nbsp;</div></td>
				<td class="niv3"><div align="left">#rsReporte.DdocEnc#</td>
				<td class="niv3"><div align="right"><strong>#LB_TRAMITE#:</strong>&nbsp;</div></td>
				<td class="niv3">#rsReporte.transaccion#</td>
				<td class="niv3"><div align="right"><strong>#LB_FechaFac#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#dateformat(rsReporte.fechaencabezado,'dd/mm/yyyy')#
				</td>
			</tr>
			<tr nowrap="nowrap">
				<td class="niv3"><div align="right">&nbsp;<strong>#LB_PROVEEDOR#:</strong>&nbsp;</div></td>
				<td nowrap="nowrap" align="left"  colspan="1" class="niv3">
					#rsReporte.SNnombre#
				</td>
				<td align="right" nowrap valign="top" class="niv3"><strong>#LB_DirFacturacion#:</strong>&nbsp;</td>
				<td valign="top" class="niv3">
					<cfif not len(trim(rsReporte.DireccionFact))>
						#Ninguna#
					<cfelse>
						#rsReporte.DireccionFact#
					</cfif> 
				</td>
				<td valign="top" class="niv3" align="right"><strong>#LB_Asiento#:</strong>&nbsp;</td> 
				<td valign="top" class="niv3">#rsReporte.Asiento_pago#</td>
			</tr>
			<tr>
				<td class="niv3"><div align="right">&nbsp;<strong>#LB_Cuenta#:</strong>&nbsp;</div></td>
					<td nowrap class="niv3">
					#rsReporte.CuentaDelEncabezado#
				</td>
				<td class="niv3"><div align="right"><strong>#LB_Moneda#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsReporte.MonedaEnc#
				</td>
				<td nowrap class="niv3"> <div align="right"><strong>#LB_Tipo_de_Cambio#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#NumberFormat(rsReporte.TipoCambioEnc,'_,_.__')#
				</td>				
			</tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>#LB_Oficina#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsReporte.OficinaEnc#
				</td>
				<td nowrap align="right" class="niv3"><strong>#LB_RetPago#:</strong>&nbsp;</td>
				<td class="niv3">
					#rsReporte.Rdescripcion#
				</td>
				<td align="right"><strong>#LB_Subtotal#:</strong>&nbsp;</td>
				<td>#NumberFormat(rsTotalLineas.TotalLinea,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="5" align="right"><strong>#LB_Impuesto#:</strong>&nbsp;</td>
				<td align="left">#NumberFormat(rsTotalLineas.impuestoEnc,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="5" class="niv3"><div align="right"><strong>#LB_Total#:</strong>&nbsp;</div></td>
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
				<cfoutput>
				<td colspan="20" align="center" style="font-weight:bold; width:1%" nowrap="nowrap">#LB_DetDocumento#</td>
				</cfoutput>
			</tr>
			<tr> 
				<td class="subTitulo" colspan="20">
					<!--- registro seleccionado --->
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<cfoutput>
								<tr bgcolor="E7E7E7" class="subTitulo">
									<td width="4%" valign="bottom"><strong>&nbsp;#LB_Linea#</strong></td>
									<td width="40%" valign="bottom"><strong>&nbsp;#LB_Descripcion#</strong></td>
									<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
										<td width="35%" valign="bottom"><strong>&nbsp;#LB_Cuenta#:</strong></td>
									</cfif>
									<td width="13%" valign="bottom"> <div align="right"><strong>#LB_Cantidad#</strong></div></td>
									<td width="13%" valign="bottom"> <div align="right"><strong>#LB_Precio#</strong></div></td>
									<td width="13%" valign="bottom"><div align="right"><strong>#LB_Descuento#</strong></div></td>
									<td width="13%" valign="bottom"><div align="left"><strong>&nbsp;#LB_CodImp#</strong></div></td>
									<td width="13%" valign="bottom"><div align="right"><strong>#LB_Impuesto#</strong></div></td>
									<td width="13%" valign="bottom"> <div align="right"><strong>#LB_Total#</strong></div></td>
									<td width="3%"  valign="bottom">&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								</cfoutput>
								
								<cfoutput query="rsReporte"> 
									<tr>
										<td align="center">#CurrentRow#</td>
										<td>#rsReporte.DDescripcion#</td>
										<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
											<td class="niv4">#rsReporte.CuentaDelDetalle#</td>
										</cfif>
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
                                        <cfoutput>
										<td><div align="right"><font size="1"><strong>#LB_Total#:</strong></font></div></td>
                                        </cfoutput>
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
				<cfoutput>
					<td colspan="22" align="center" class="niv3">
            		<cfset LB_FinCons = t.Translate('LB_FinCons','Fin de la Consulta')>
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