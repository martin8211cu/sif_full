
<!--- NAVEGACION --->
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo >
</cfif>
<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
	<cfset form.Ddocumento = url.Ddocumento >
</cfif>
<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo >
</cfif>

<cfif isdefined("url.fSNcodigo") and not isdefined("form.fSNcodigo")>
	<cfset form.fSNcodigo = url.fSNcodigo >
</cfif>
<cfif isdefined("url.fDdocumento") and not isdefined("form.fDdocumento")>
	<cfset form.fDdocumento = url.fDdocumento >
</cfif>
<cfif isdefined("url.fCCTcodigo") and not isdefined("form.fCCTcodigo")>
	<cfset form.fCCTcodigo = url.fCCTcodigo >
</cfif>
<cfif isdefined("url.fid_direccion") and not isdefined("form.fid_direccion")>
	<cfset form.fid_direccion = url.fid_direccion >
</cfif>
<cfif isdefined("url.fDfechadesde") and not isdefined("form.fDfechadesde")>
	<cfset form.fDfechadesde = url.fDfechadesde >
</cfif>
<cfif isdefined("url.fDfechahasta") and not isdefined("form.fDfechahasta")>
	<cfset form.fDfechahasta = url.fDfechahasta >
</cfif>
<cfif isdefined("url.fDusuario") and not isdefined("form.fDusuario")>
	<cfset form.fDusuario = url.fDusuario >
</cfif>
<cf_templateheader title="SIF - Cuentas por Cobrar">
	
	<cfif len(trim(form.fDfechadesde)) eq 0>
		<cfset vDfechadesde = createdate(year(now()), month(now()), 01)>
	<cfelse>
		<cfset vDfechadesde = LSParsedatetime(form.fDfechadesde) >
	</cfif>
	<cfif len(trim(form.fDfechahasta)) eq 0>
		<cfset vDfechahasta = createdate(year(now()), month(now()), daysinmonth(now()))>
	<cfelse>
		<cfset vDfechahasta = LSParsedatetime(form.fDfechahasta) >
	</cfif>
	
	<cfif vDfechadesde gt vDfechahasta>
		<cfset tmp = vDfechadesde>
		<cfset vDfechadesde = vDfechahasta >
		<cfset vDfechahasta = tmp >	
	</cfif>

	<cfquery name="rsSocio" datasource="#session.DSN#">
		select SNnumero, SNnombre
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fSNcodigo#">
	</cfquery>
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
			
			(coalesce(i.Iporcentaje,0) * hd.DDtotal/100.00) as impuestolinea,
			i.Icodigo,
			he.id_direccionFact
		
			from DDocumentos hd
				inner join Documentos he
					on he.Ddocumento = hd.Ddocumento
					and he.CCTcodigo= hd.CCTcodigo
					and he.Ecodigo=hd.Ecodigo
					and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">

				inner join SNegocios sn
					on sn.SNcodigo = he.SNcodigo
						and sn.Ecodigo = he.Ecodigo
				inner join CCTransacciones c 
					on c.Ecodigo = hd.Ecodigo 
					and c.CCTcodigo= hd.CCTcodigo
				left outer join Retenciones r
					on r.Ecodigo = he.Ecodigo
					and r.Rcodigo = he.Rcodigo
				left outer join  Impuestos i
					on i.Ecodigo = hd.Ecodigo
					and  i.Icodigo = hd.Icodigo
			where hd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and hd.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
				and hd.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
	</cfquery>
	
		<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select 
			(select o.Oficodigo
				from Oficinas o
				where o.Ecodigo  = he.Ecodigo
					and o.Ocodigo = he.Ocodigo) as OficinaEnc,
		
		
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
		
			c.CCTcodigo  as transaccion,
			
			sn.SNnombre,
			sn.SNnumero,
			sn.SNidentificacion,
			
			he.id_direccionFact
		
			from Documentos he

				inner join SNegocios sn
					on sn.SNcodigo = he.SNcodigo
						and sn.Ecodigo = he.Ecodigo
				inner join CCTransacciones c 
					on c.Ecodigo = he.Ecodigo 
					and c.CCTcodigo= he.CCTcodigo
				left outer join  Retenciones r
					on r.Ecodigo = he.Ecodigo
					and r.Rcodigo = he.Rcodigo
			where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and he.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
				and he.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddocumento#">
	</cfquery>

	
	<cfquery name="data_direcciones" datasource="#session.DSN#">
		select b.id_direccion, coalesce(c.direccion1, c.direccion2) as direccion
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
	</cfquery>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cambiar Direcciones'>
		<form name="form1" method="post" action="adminDirecciones-sql.cfm">
		<cfoutput>
		<table width="100%"   cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td>

								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr><td style="padding:2px;" colspan="4"><strong>Proceso para cambiar direcciones a documentos</strong></td></tr>
									<tr>
										<td style="padding:2px;" nowrap="nowrap" colspan="2" width="50%" ><strong>Socio de Negocios:</strong> #rsSocio.SNnumero# - #rsSocio.SNnombre#</td>
										<td style="padding:2px;" valign="middle"><strong>Direcci&oacute;n:</strong></td>
										<td valign="middle" >
											<select style="width:290px" name="id_direccion" id="id_direccion" >
												<cfloop query="data_direcciones">
													<option value="#data_direcciones.id_direccion#" <cfif rsReporte.id_direccionFact eq data_direcciones.id_direccion >selected="selected"</cfif>  >#data_direcciones.direccion#</option>
												</cfloop>
											</select>
											<input type="submit" class="btnGuardar" name="btnModificar" value="Modificar">
										</td>
									</tr>
									<tr><td style="padding:2px;" colspan="4"><strong>Rango de Fechas:</strong> #LSDateformat(vDfechadesde, 'dd/mm/yyyy')# al #LSDateformat(vDfechahasta,'dd/mm/yyyy')#</td></tr>
								</table>	

							</td></tr>	


							<tr><td>&nbsp;</td></tr>							
							<tr>
								<td valign="top">
										<cfset navegacion = '' >
										<cfset campos_extra = '' >
										<!--- NAVEGACION --->
										<cfif isdefined("form.fSNcodigo")>
											<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#" >
											<cfset campos_extra = campos_extra & ",'#form.fSNcodigo#' as fSNcodigo" >
										</cfif>
										<cfif isdefined("form.fDdocumento")>
											<cfset navegacion = navegacion & "&fDdocumento=#form.fDdocumento#" >
											<cfset campos_extra = campos_extra & ",'#form.fDdocumento#' as fDdocumento" >
										</cfif>
										<cfif isdefined("form.fCCTcodigo")>
											<cfset navegacion = navegacion & "&fCCTcodigo=#form.fCCTcodigo#" >
											<cfset campos_extra = campos_extra & ",'#form.fCCTcodigo#' as fCCTcodigo" >
										</cfif>
										<cfif isdefined("form.fid_direccion")>
											<cfset navegacion = navegacion & "&fid_direccion=#form.fid_direccion#" >	
											<cfset campos_extra = campos_extra & ",'#form.fid_direccion#' as fid_direccion" >
										</cfif>
										<cfif isdefined("form.fDfechadesde")>
											<cfset navegacion = navegacion & "&fDfechadesde=#LSDateFormat(vDfechadesde,'dd/mm/yyyy')#" >
											<cfset tmp = LSDateFormat(vDfechadesde,'dd/mm/yyyy') >	
											<cfset campos_extra = campos_extra & ",'#tmp#' as fDfechadesde" >
										</cfif>
										<cfif isdefined("form.fDfechahasta")>
											<cfset navegacion = navegacion & "&fDfechahasta=#LSDateFormat(vDfechahasta,'dd/mm/yyyy')#" >
											<cfset tmp = LSDateFormat(vDfechahasta,'dd/mm/yyyy') >	
											<cfset campos_extra = campos_extra & ",'#tmp#' as fDfechahasta" >
										</cfif>
										<cfif isdefined("form.fDusuario")>
											<cfset navegacion = navegacion & "&fDusuario=#form.fDusuario#" >
											<cfset campos_extra = campos_extra & ",'#form.fDusuario#' as fDusuario" >
										</cfif>
								</td>
							</tr>
						</table>
				</td>
			</tr>	
		</table>
		</cfoutput>	

		<cfif rsDocumento.recordcount eq 0>
			<cflocation url="adminDirecciones-facturas.cfm?dummy=ok#navegacion#">
		</cfif>


		<cfquery name="rsTotalLineas" dbtype="query">
			select 
				sum(DDpreciou) as PrecioUnit, 
				sum(DDtotal) as TotalLinea,
				sum(impuestolinea) as impuestoEnc
			from rsReporte
		</cfquery>
		
		<!--- ENCABEZADO --->
		<table  width="100%">
		<cfoutput>
			<tr><td colspan="6" style="font-weight:bold; width:1%" bgcolor="E2E2E2"><div align="center">ENCABEZADO DEL DOCUMENTO</div></td></tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>Documento:</strong>&nbsp;</div></td>
				<td class="niv3"><div align="left">#rsDocumento.DdocEnc#</td>
				<td class="niv3"><div align="right"><strong>Transacción:</strong>&nbsp;</div></td>
				<td class="niv3">#rsDocumento.transaccion#</td>
				<td class="niv3"><div align="right"><strong>Fecha&nbsp;Factura:</strong>&nbsp;</div></td>
				<td class="niv3">
					#dateformat(rsDocumento.fechaencabezado,'dd/mm/yyyy')#				</td>
			</tr>
			<tr nowrap="nowrap">
				<td class="niv3"><div align="right">&nbsp;<strong>Proveedor:</strong>&nbsp;</div></td>
				<td nowrap="nowrap" align="left"  colspan="1" class="niv3">
					#rsDocumento.SNnombre#				</td>
				<td align="right" nowrap valign="top" class="niv3"><strong>Direcci&oacute;n facturaci&oacute;n:</strong>&nbsp;</td>
				<td valign="top" class="niv3" colspan="3">
					<cfif not len(trim(rsDocumento.DireccionFact))>
						Ninguna
					<cfelse>
						#rsDocumento.DireccionFact#
					</cfif>				</td>
			  				
			</tr>
			<tr>
				<td class="niv3"><div align="right">&nbsp;<strong>Cuenta:</strong>&nbsp;</div></td>
					<td nowrap class="niv3">
					#rsDocumento.CuentaDelEncabezado#				</td>
				<td class="niv3"><div align="right"><strong>Moneda:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsDocumento.MonedaEnc#				</td>
				<td align="right"><strong>Tipo Cambio:</strong>&nbsp;</td>
				<td align="right">#NumberFormat(rsDocumento.TipoCambioEnc,'_,_.__')#</td>
			</tr>
			<tr> 
				<td class="niv3"><div align="right"><strong>Oficina:</strong>&nbsp;</div></td>
				<td class="niv3">
					#rsDocumento.OficinaEnc#				</td>
				<td nowrap align="right" class="niv3"><strong>Retenci&oacute;n al Pagar:</strong>&nbsp;</td>
				<td class="niv3" colspan="3">
					#rsDocumento.Rdescripcion#				</td>
			</tr>
			<tr>
				<td colspan="5" class="niv3"><div align="right"><strong>Subtotal:</strong>&nbsp;</div></td>
				<td align="right">#NumberFormat(rsTotalLineas.TotalLinea,'_,_.__')#</td>
			</tr>

			<tr>
				<td colspan="5" class="niv3"><div align="right"><strong>Impuesto:</strong>&nbsp;</div></td>
				<td align="right">#NumberFormat(rsTotalLineas.impuestoEnc,'_,_.__')#</td>
			</tr>
			<tr>
				<td colspan="5" class="niv3"><div align="right"><strong>Total:</strong>&nbsp;</div></td>
				<td class="niv3" align="right"> 
					#NumberFormat(rsDocumento.TotalEnc,'_,_.__')#				</td>
			</tr>
		</cfoutput>
			<tr>
				<td >&nbsp;</td>
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
									<tr style="padding:3px;">
										<td>&nbsp;</td> 
										<td>&nbsp;</td> 
										<td><font size="1">&nbsp;</font></td>
										<td><font size="1">&nbsp;</font></td>
										<td>&nbsp;</td>
										<td width="14%">&nbsp;</td>
										<td style="padding:3px;"><div align="right"><font size="1"><strong>Total:</strong></font></div></td>
										<td style="padding:3px;">
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
			   </td>
			  </tr>
			</table>
			
		<table align="center" >
		<tr><td>
		<cfoutput>
			<input type="hidden" name="CCTcodigo" value="#form.CCTcodigo#" />
			<input type="hidden" name="Ddocumento" value="#htmleditformat(form.Ddocumento)#" />
			<input type="hidden" name="SNcodigo" value="#form.SNcodigo#" />
			<input type="hidden" name="fCCTcodigo" value="#form.fCCTcodigo#" />
			<input type="hidden" name="fDdocumento" value="#form.fDdocumento#" />											
			<input type="hidden" name="fSNcodigo" value="#form.fSNcodigo#" />
			<input type="hidden" name="fid_direccion" value="#form.fid_direccion#" />
			<input type="hidden" name="fDfechadesde" value="#form.fDfechadesde#" />
			<input type="hidden" name="fDfechahasta" value="#form.fDfechahasta#" />
			<input type="hidden" name="fDusuario" value="#trim(form.fDusuario)#" />
			<input type="button" class="btnAnterior" name="btnAnterior" value="Regresar" onclick="javascript:regresar();">
		</cfoutput>
		</td></tr>
		</table>
		</form>
		
		<cf_web_portlet_end>
		
		<script language="javascript1.2" type="text/javascript">
			function regresar(){
				<cfset navegacion = ''>
				<cfif isdefined("form.SNcodigo") >
					<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#" >
				</cfif>
				<cfif isdefined("form.Ddocumento")>
					<cfset navegacion = navegacion & "&Ddocumento=#form.Ddocumento#" >
				</cfif>
				<cfif isdefined("form.CCTcodigo") >
					<cfset navegacion = navegacion & "&CCTcodigo=#form.CCTcodigo#" >
				</cfif>
				
				<cfif isdefined("form.fSNcodigo")>
					<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#" >
				</cfif>
				<cfif isdefined("form.fDdocumento")>
					<cfset navegacion = navegacion & "&fDdocumento=#form.fDdocumento#" >
				</cfif>
				<cfif isdefined("form.fCCTcodigo")>
					<cfset navegacion = navegacion & "&fCCTcodigo=#form.fCCTcodigo#" >
				</cfif>
				<cfif isdefined("form.fid_direccion")>
					<cfset navegacion = navegacion & "&fid_direccion=#form.fid_direccion#" >	
				</cfif>
				<cfif isdefined("form.fDfechadesde")>
					<cfset navegacion = navegacion & "&fDfechadesde=#form.fDfechadesde#" >
				</cfif>
				<cfif isdefined("form.fDfechahasta")>
					<cfset navegacion = navegacion & "&fDfechahasta=#form.fDfechahasta#" >
				</cfif>
				<cfif isdefined("form.fDusuario")>
					<cfset navegacion = navegacion & "&fDusuario=#form.fDusuario#" >
				</cfif>
				
				location.href = 'adminDirecciones-facturas.cfm?dummy=ok<cfoutput>#navegacion#</cfoutput>';
			}
		</script>
		
		
	<cf_templatefooter>