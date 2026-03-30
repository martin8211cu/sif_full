<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 6-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset BTN_Regresar = t.Translate('LB_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_ConsPago 	= t.Translate('LB_ConsPago','Consulta de Pagos Realizados')>
<cfset LB_USUARIO 	= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_DetDoct 	= t.Translate('LB_DetDoct','Detalle del Documento')>
<cfset LB_Codigo 	= t.Translate('LB_Codigo','Codigo','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/sif/generales.xml')>
<cfset LB_OcultarDet 	= t.Translate('LB_OcultarDet','Ocultar Cuentas del Detalle')>
<cfset LB_MostrarDet	= t.Translate('LB_MostrarDet','Mostrar Cuentas del Detalle')>
<cfset LB_ENCDOC	= t.Translate('LB_ENCDOC','ENCABEZADO DEL DOCUMENTO')>


<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif not isdefined("url.LvarCuentasOcultas")>
	<cfset url.LvarCuentasOcultas = 2>
</cfif>
<!--- <cfdump var="#form#">
<cfdump var="#url#">  --->
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

<cfif isdefined("url.CPTcodigo") and not isdefined("form.CPTcodigo")>
	<cfset form.CPTcodigo = url.CPTcodigo>
</cfif>

<cfif isdefined("url.IDdocumento") and not isdefined("form.IDdocumento")>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>

<cfif isdefined("url.CPTcodigo") and not isdefined("url.ref_pago")>
	<cfset url.ref_pago = url.CPTcodigo>
</cfif>
<!--- *************************************************************************************************** --->
<cfquery name="rsReporteEnc" datasource="#Session.DSN#">
	select 
		IDdocumento, 
		(
			select min(o.Oficodigo)
			from Oficinas o
			where o.Ecodigo  = he.Ecodigo
				and o.Ocodigo = he.Ocodigo
		) as OficinaEnc,
		(
			select min(cc.Cformato)
			from CContables cc
			where cc.Ccuenta = he.Ccuenta
		) as CuentaDelEncabezado,
		(
			select min(m.Mnombre)
			from Monedas m
			where m.Mcodigo = he.Mcodigo
		) as MonedaEnc,
	
		(
			select coalesce(ds.direccion1,ds.direccion2,'N/A')
			from SNDirecciones snd
				inner join DireccionesSIF ds
					on ds.id_direccion = snd.id_direccion
			where snd.Ecodigo = he.Ecodigo
			and snd.SNcodigo = he.SNcodigo
			and snd.id_direccion = he.id_direccion
		) as DireccionFact,
		coalesce(
				(
					select min(hh.Cconcepto)
					from BMovimientosCxP bb
						inner join HEContables hh
							on hh.IDcontable = bb.IDcontable
					where bb.Ecodigo = he.Ecodigo
						and bb.Ddocumento = he.Ddocumento
						and bb.CPTcodigo = he.CPTcodigo
						and bb.SNcodigo = he.SNcodigo
						and bb.CPTRcodigo = he.CPTcodigo <!--- Solo construcción de Documentos --->
				),
				(
					select min(hh.Cconcepto)
					from BMovimientosCxP bb
						inner join EContables hh
							on hh.IDcontable = bb.IDcontable
					where bb.Ecodigo = he.Ecodigo
						and bb.Ddocumento = he.Ddocumento
						and bb.CPTcodigo = he.CPTcodigo
						and bb.SNcodigo = he.SNcodigo 
						and bb.CPTRcodigo = he.CPTcodigo <!--- Solo construcción de Documentos --->
				)
				) as Lote_pago,
		coalesce(
				(
					select min(hh.Edocumento)
					from BMovimientosCxP bb
						inner join HEContables hh
							on hh.IDcontable = bb.IDcontable
					where bb.Ecodigo = he.Ecodigo
					and bb.Ddocumento = he.Ddocumento
					and bb.CPTcodigo = he.CPTcodigo
					and bb.SNcodigo = he.SNcodigo
					and bb.CPTRcodigo = he.CPTcodigo <!--- Solo construcción de Documentos --->
				),
				(
					select min(hh.Edocumento)
					from BMovimientosCxP bb
						inner join EContables hh
							on hh.IDcontable = bb.IDcontable
					where bb.Ecodigo = he.Ecodigo
					and bb.Ddocumento = he.Ddocumento
					and bb.CPTcodigo = he.CPTcodigo
					and bb.SNcodigo = he.SNcodigo 
					and bb.CPTRcodigo = he.CPTcodigo <!--- Solo construcción de Documentos --->
				)
		) as asiento_pago,
		he.Dtipocambio as TipoCambioEnc,
		he.Ddocumento as DdocEnc,
		he.Dfecha as fechaencabezado,
		he.Dtotal as TotalEnc,
		coalesce(r.Rcodigo, 'N/A') as Rcodigo,
		coalesce (r.Rdescripcion, 'N/A') as Rdescripcion,
		<cf_dbfunction name="concat" args="c.CPTcodigo,' - ',CPTdescripcion ">  as transaccion,
		sn.SNnombre,
		sn.SNnumero,
		sn.SNidentificacion
	from HEDocumentosCP he
		inner join SNegocios sn
			on sn.SNcodigo = he.SNcodigo
			and sn.Ecodigo = he.Ecodigo
		inner join CPTransacciones c 
			on c.Ecodigo = he.Ecodigo 
			and c.CPTcodigo= he.CPTcodigo
		left outer join Retenciones r
			on r.Ecodigo = he.Ecodigo
			and r.Rcodigo = he.Rcodigo
	where he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
	and he.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#url.doc_pago#">
	and he.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.ref_pago#">
	and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsReporteDet" datasource="#session.dsn#">
	select 
		hd.IDdocumento,
			(
				select min(cc.Cformato)
				from CContables cc
				where cc.Ccuenta = hd.Ccuenta
			) as CuentaDelDetalle,
		hd.DOlinea,
		hd.IDdocumento, 
		hd.DDescripcion,
		hd.DDdescalterna,
		hd.DDcantidad,
		hd.DDpreciou,
		hd.DDdesclinea,
		hd.DDtotallin,
		hd.DDtipo,
		hd.Ccuenta,
		hd.Dcodigo,
		(coalesce(i.Iporcentaje, 0) * hd.DDtotallin / 100.00) as impuestolinea,
		i.Icodigo
	from HDDocumentosCP hd
		left outer join Impuestos i
		on i.Ecodigo = hd.Ecodigo
		and  i.Icodigo = hd.Icodigo
	where IDdocumento = #rsReporteEnc.IDdocumento#
</cfquery>

<cfquery name="rsTotalLineas" dbtype="query">
	select 
		sum(DDpreciou) as PrecioUnit, 
		sum(DDtotallin) as TotalLinea,
		sum(impuestolinea) as impuestoEnc
	from rsReporteDet
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
	<cfif isdefined("rsReporteEnc") and rsReporteEnc.recordcount gt 0>
		<table cellpadding="2" cellspacing="0" border="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="9" align="right" nowrap="nowrap">
				<cfset params ="">
				<cfset params2 ="">
				<cfset params3 ="">
				<cfset params = "&formatos=1&SNcodigo=#url.SNcodigo#&FechaI=#url.FechaI#&FechaF=#url.FechaF#&LvarRecibo=#url.LvarRecibo#">
				<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento))>
					<cfset params = params & '&IDdocumento=#form.IDdocumento#'>
				</cfif>
				<cfif isdefined("form.Pagos")>
					<cfset params = params & '&Pagos=#form.Pagos#'>
				</cfif>
				<cfif isdefined("url.LvarReciboB")>
					<cfset params = params & '&LvarReciboB=#url.LvarReciboB#'>
				</cfif>
				<cfif isdefined("url.CPTcodigo")>
					<cfset params = params & '&CPTcodigo=#url.CPTcodigo#'>
				</cfif>
				<cfif isdefined("url.CPTcodigoA")>
					<cfset params = params & '&CPTcodigoA=#url.CPTcodigoA#'>
				</cfif>

				<cfset params2 = trim('&Recibo=#url.Recibo#&Fecha=#url.Fecha#&Asiento=#url.Asiento#&TC=#url.TC#&MontoOrigen=#url.MontoOrigen#&MontoLocal=#url.MontoLocal#')>
				<cfset params3 = "">
				
				<cfif isdefined("rsReporteEnc") and rsReporteEnc.recordcount gt 0>
					<cfset params3 = "&IDdocumento_pago=#url.IDdocumento_pago#&doc_pago=#url.doc_pago#&ref_pago=#url.ref_pago#">
				</cfif>
				
				<cfoutput>
					<cfif isdefined("form.Pagos") and form.Pagos eq 2><!--- #params#<br>#params2#<br>#params3#<br> --->
						<cfset LvarRegresa = "DocPagado_PagosRealizados_form.cfm?1=1#params##params2##params3#">
					<cfelse><!--- 2222 <br> 1-#params#<br> 2 #params2#<br> 3 #params3#<br> <cfdump var="#form#"><cfdump var="#url#"> --->
						<cfset LvarRegresa = "PagoRealizado_DetallePago_form.cfm?1=1#params##params2##params3#">
					</cfif>
				<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
					<!--- <cfset url.LvarCuentasOcultas =""> --->
					<a class="noprint" href="PagoRealizado_DetalleDocumento_form.cfm?1=1#params##params2##params3#&LvarCuentasOcultas=1">#LB_OcultarDet#</a>
				<cfelseif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 1>
					<!--- <cfset url.LvarCuentasOcultas =""> ---> 
					
					<a  class="noprint" href="PagoRealizado_DetalleDocumento_form.cfm?1=1#params##params2##params3#">#LB_MostrarDet#</a>
				</cfif>
				
				<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
					<cf_rhimprime datos="/sif/cp/consultas/PagoRealizado_DetalleDocumento_form.cfm" paramsuri="#params##params2##params3#&LvarCuentasOcultas=1" Regresar="#LvarRegresa#">
					<iframe name="printerIframe" id="printerIframe" height="0" width="0" src="about:blank"></iframe> 
				<cfelseif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 1>
					<cf_rhimprime datos="/sif/cp/consultas/PagoRealizado_DetalleDocumento_form.cfm" paramsuri="#params##params2##params3#" Regresar="#LvarRegresa#">
					<iframe name="printerIframe" id="printerIframe" height="0" width="0" src="about:blank"></iframe> 
				</cfif>
				
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
		  <td colspan="7" align="center" class="niv2"><cfoutput>#LB_ConsPago#</cfoutput></td>
		  <td colspan="2" class="niv4" align="right"><cfoutput>#LB_USUARIO#:&nbsp;#session.Usulogin#</cfoutput> </td>
		</tr>
		<tr style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td colspan="7" align="center" class="niv2"><cfoutput>#LB_DetDoct#</cfoutput></td>
		  <td>&nbsp;</td>
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
			  <td nowrap="nowrap" class="niv3" align="left">#rsReporteEnc.SNnumero#</td>
			  <td nowrap="nowrap" class="niv3" align="left" style="width:1%">#trim(rsReporteEnc.SNnombre)#</td>
			  <td nowrap="nowrap" class="niv3" align="right" colspan="1">#rsReporteEnc.SNidentificacion#</td>
			  <td colspan="6">&nbsp;</td>
			</tr>
			<!--- Inicio del Encabezado --->
		</cfoutput>
		<cf_templatecss>

<cfset LB_Documento 	= t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Factura 	= t.Translate('LB_Factura','Factura')>
<cfset LB_PROVEEDOR		= t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_DirFact 	= t.Translate('LB_DirFact','Direcci&oacute;n facturaci&oacute;n')>
<cfset LB_LoteAs	= t.Translate('LB_LoteAs','Lote/Asiento')>
<cfset LB_Cuenta 	= t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo Cambio','/sif/generales.xml')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_RetPagar	= t.Translate('LB_RetPagar','Retenci&oacute;n al Pagar')>
<cfset LB_Impuesto 	= t.Translate('LB_Impuesto','Impuesto')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_Subtotal = t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
<cfset LB_Ninguna 	= t.Translate('LB_Ninguna','Ninguna')>
<cfset LB_DetDocto	= t.Translate('LB_DetDocto','DETALLE DEL DOCUMENTO')>
<cfset LB_OrdCmpr	= t.Translate('LB_OrdCmpr','Orden Compra')>
<cfset LB_Linea 	= t.Translate('LB_Linea','L&iacute;nea')>
<cfset LB_Descripcion = t.Translate('Descripcion','Descripci&oacute;n','/sif/generales.xml')>
<cfset LB_Cantidad 	= t.Translate('LB_Cantidad','Cantidad')>
<cfset LB_Precio 	= t.Translate('LB_Precio','Precio')>
<cfset LB_Descuento	= t.Translate('LB_Descuento','Descuento')>
<cfset LB_CodImp 	= t.Translate('LB_CodImp','Cod. Imp.')>

		<cfoutput>
			<tr><td colspan="9" style="font-weight:bold; width:1%" bgcolor="E2E2E2"><div align="center">#LB_ENCDOC#</div></td></tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>#LB_Documento#:</strong>&nbsp;</div></td>
				<td class="niv3"><div align="left">#rsReporteEnc.DdocEnc#</td>
				<td class="niv3"><div align="right"><strong>#LB_Transaccion#:</strong>&nbsp;</div></td>
				<td class="niv3">#rsReporteEnc.transaccion#</td>
				<td class="niv3"><div align="right"><strong>#LB_Fecha#&nbsp;#LB_Factura#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#dateformat(rsReporteEnc.fechaencabezado,'dd/mm/yyyy')#
				</td>
			</tr>
			<tr nowrap="nowrap">
				<td class="niv3"><div align="right">&nbsp;<strong>#LB_PROVEEDOR#:</strong>&nbsp;</div></td>
				<td nowrap="nowrap" align="left"  colspan="1" class="niv3">
					#rsReporteEnc.SNnombre#
				</td>
				<td align="right" nowrap valign="top" class="niv3"><strong>#LB_DirFact#:</strong>&nbsp;</td>
				<td valign="top" class="niv3">
					<cfif not len(trim(rsReporteEnc.DireccionFact))>
						#LB_Ninguna#
					<cfelse>
						#rsReporteEnc.DireccionFact#
					</cfif> 
				</td>
				<td valign="top" class="niv3" align="right"><strong>#LB_LoteAs#:</strong>&nbsp;</td> 
				<td valign="top" class="niv3">#rsReporteEnc.Lote_pago# - #rsReporteEnc.Asiento_pago#</td>
			</tr>
			<tr>
				<td class="niv3"><div align="right">&nbsp;<strong>#LB_Cuenta#:</strong>&nbsp;</div></td>
					<td nowrap class="niv3">
					#rsReporteEnc.CuentaDelEncabezado#
				</td>
				<td class="niv3"><div align="right"><strong>#LB_Moneda#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsReporteEnc.MonedaEnc#
				</td>
				<td nowrap class="niv3"> <div align="right"><strong>#LB_Tipo_de_Cambio#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#NumberFormat(rsReporteEnc.TipoCambioEnc,'_,_.__')#
				</td>				
			</tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>#LB_Oficina#:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsReporteEnc.OficinaEnc#
				</td>
				<td nowrap align="right" class="niv3"><strong>#LB_RetPagar#:</strong>&nbsp;</td>
				<td class="niv3">
					#rsReporteEnc.Rdescripcion#
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
					#NumberFormat(rsReporteEnc.TotalEnc,'_,_.__')#
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
				<td colspan="20" align="center" style="font-weight:bold; width:1%" nowrap="nowrap"><cfoutput>#LB_DetDocto#</cfoutput></td>
			</tr>
			<tr> 
				<td class="subTitulo" colspan="20">
					<!--- registro seleccionado --->
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr bgcolor="E7E7E7" class="subTitulo">
                                	<cfoutput>
									<!--- <td width="1%">&nbsp;</td> ---> 
									<td width="4%" valign="bottom"><strong>&nbsp;#LB_OrdCmpr#</strong></td>	
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
                                    </cfoutput>
								</tr>
								
								
								<cfoutput query="rsReporteDet"> 
									<cfset rsORDCOM= querynew("EOnumero")>
									<cfif isdefined("rsReporteDet") and len(trim(rsReporteDet.DOlinea)) GT 0>
										<cfquery name="rsORDCOM" datasource="#session.DSN#">
											select eo.EOnumero
												from HDDocumentosCP hdd
													inner join DOrdenCM do
														on do.DOlinea = hdd.DOlinea
														and do.Ecodigo = hdd.Ecodigo
													inner join EOrdenCM eo
														on eo.EOidorden = do.EOidorden
												where hdd.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteDet.IDdocumento#">
													and hdd.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteDet.DOlinea#">
										</cfquery>
									</cfif>
									<tr class="niv4">
										<td class="niv4" align="center"><cfif isdefined("rsORDCOM") and len(trim(rsORDCOM.EOnumero))>#rsORDCOM.EOnumero#</cfif></td>
										<td class="niv4" align="center">#CurrentRow#</td>
										<td class="niv4">#rsReporteDet.DDescripcion#</td>
										<cfif isdefined("url.LvarCuentasOcultas") and url.LvarCuentasOcultas eq 2>
											<td class="niv4">#rsReporteDet.CuentaDelDetalle#</td>
										</cfif>
										<td class="niv4" align="right">#LSCurrencyFormat(rsReporteDet.DDcantidad,'none')#</td>
										<td class="niv4" align="right">#LvarOBJ_PrecioU.enCF_RPT(rsReporteDet.DDpreciou)#</td>
										<td class="niv4" align="right">#LSCurrencyFormat(rsReporteDet.DDdesclinea,'none')#</td>
										<td class="niv4" align="left">&nbsp;#rsReporteDet.Icodigo#</td>
										<td class="niv4" align="right">#LSCurrencyFormat(rsReporteDet.impuestolinea,'none')#</td>
										<td class="niv4" align="right">&nbsp;#LSCurrencyFormat(rsReporteDet.DDtotallin,'none')#</td>
										<td class="niv4" align="right" width="3%">
										</td>
									</tr>
								</cfoutput> 
								
								<cfif rsReporteDet.Recordcount GT 0>
									<tr>
										<td>&nbsp;</td> 
										<td>&nbsp;</td> 
										<td><font size="1">&nbsp;</font></td>
										<td><font size="1">&nbsp;</font></td>
										<td>&nbsp;</td>
										<td width="14%">&nbsp;</td>
										<td>&nbsp;</td>
										<td><div align="right"><font size="1"><strong><cfoutput>#LB_Total#:</cfoutput></strong></font></div></td>
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
                <cfoutput>
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
