<!--- Cual va a ser el tipo de cambio. Actualmente por defecto va a ser de tipo 'V' de venta, 
	pero tambien existe el tipo 'C' de Compra (<cfset TC = "TCcompra">)--->
<cfset TC = "TCventa">
<cfif not isdefined("LvarEsPrefacturaControl")>
	<cfset LvarEsPrefacturaControl = true>
	<cfset LvarTitulo = "Prefactura:">
</cfif>
<cfif isdefined('url.NumeroCot') and not isdefined('form.NumeroCot')>
	<cfparam name="form.NumeroCot" default="#url.NumeroCot#">
</cfif>
<!--- Se le coloca el valor de 1 por defecto para realizar los calculos de los montos en el detalle --->
<cfset tipoCalculos = 1>
<cfquery name="rsParam" datasource="#Session.DSN#">
	Select FACALIMP
	From FAP000
</cfquery>

<cfif isdefined('rsParam') and rsParam.recordCount GT 0 and rsParam.FACALIMP NEQ ''>
	<cfif rsParam.FACALIMP EQ 1>	
		<!--- Se calcula primero el descuento y luego el impuesto para las lineas del detalle --->
		<cfset tipoCalculos = 1>	
	<cfelseif rsParam.FACALIMP EQ 2>
		<!--- Se calcula primero el impuesto y luego el descuento para las lineas del detalle --->
		<cfset tipoCalculos = 2>		
	</cfif>
</cfif> 

<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo from Empresas 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cfset modo = 'ALTA'>
<cfif  isdefined('form.NumeroCot') and len(trim(form.NumeroCot))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select 
			NumeroCot, 
			FAX04CVD,
			fac.CDCcodigo,
			CDCnombre,
			Ocodigo,
			Mcodigo, 
			TipoTransaccion, 
			TipoPago, 
			Estatus, 
			case Estatus
				when 0 then 'Digitada'
				when 1 then 'Terminada'
				when 2 then 'Anulada'
				when 3 then 'Vencida'
			end EstatusDesc,			
			PorcDescCliente, 
			PorcDescTotal, 
			coalesce(MonDescuentoF,0) as MonDescuentoF, 
			coalesce(MonDescuentoL,0) as MonDescuentoL, 
			MonImpuesto, 
			MonTotalCot, 
			NumOrdenCompra, 
			Exento, 
			Observaciones, 
			TipoCambio, 
			fac.BMUsucodigo, 
			fechaalta, 
			fac.ts_rversion,
			Direccion,
			Fecha_doc,
			vencimiento
		from FACotizacionesE fac
			inner join ClientesDetallistasCorp c
				on c.CDCcodigo=fac.CDCcodigo
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">
	</cfquery>
	<!--- Consulta para el despliegue del resumen de totales --->
	<cfif tipoCalculos EQ 1>
		<cfquery name="totDetalle" datasource="#session.dsn#">
			Select 
				sum((Cantidad * PrecioUnitario) * (PorDescuento/100)) as sumDescuento,
				sum(Cantidad * PrecioUnitario) as sumSubTotal, 
				sum(	((Cantidad * PrecioUnitario) 
						- ((Cantidad * PrecioUnitario) * (PorDescuento / 100))) 
						*
						<cfif rsForm.Exento NEQ 1>
							(Iporcentaje / 100)
						<cfelse>
							0		
						</cfif>
					) as sumImpuesto,
				sum(
						((Cantidad * PrecioUnitario) 
						- ((Cantidad * PrecioUnitario) * (PorDescuento/100))
						+ (	((Cantidad * PrecioUnitario) 
						- ((Cantidad * PrecioUnitario) * (PorDescuento / 100)))
						* 
						<cfif rsForm.Exento NEQ 1>
							(Iporcentaje / 100)
						<cfelse>
							0		
						</cfif>
						))
						* (PorcDescCliente/100)
					) as sumDescFactura
			from FACotizacionesD cd
				inner join FACotizacionesE ce
					on ce.NumeroCot=cd.NumeroCot
						and ce.Ecodigo=cd.Ecodigo
			
				inner join Impuestos i
					on i.Icodigo=cd.Icodigo
						and i.Ecodigo=ce.Ecodigo
			
			where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cd.NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">
		</cfquery>		
		<cfquery name="rsCantDet" datasource="#session.dsn#">
			select count(Linea) as cantLineas
			from FACotizacionesD
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">
		</cfquery>
	<cfelseif tipoCalculos EQ 2>
		<cfquery name="totDetalle" datasource="#session.dsn#">
			Select 
				sum(Cantidad * PrecioUnitario) as sumSubTotal, 
				sum((Cantidad * PrecioUnitario) * 
					<cfif rsForm.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0		
					</cfif>	
				) as sumImpuesto,
				sum(((Cantidad * PrecioUnitario) + ((Cantidad * PrecioUnitario) * 
					<cfif rsForm.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0		
					</cfif>
				)) * (PorDescuento / 100)) as sumDescuento,
				sum(((Cantidad * PrecioUnitario) + ((Cantidad * PrecioUnitario) * 
					<cfif rsForm.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0		
					</cfif>
				) - (((Cantidad * PrecioUnitario) + ((Cantidad * PrecioUnitario) * 
					<cfif rsForm.Exento NEQ 1>
						(Iporcentaje / 100)
					<cfelse>
						0		
					</cfif>
				)) * (PorDescuento / 100))) * (PorcDescCliente/100)) as sumDescFactura
			from FACotizacionesD cd
				inner join FACotizacionesE ce
					on ce.NumeroCot=cd.NumeroCot
						and ce.Ecodigo=cd.Ecodigo
			
				inner join Impuestos i
					on i.Icodigo=cd.Icodigo
						and i.Ecodigo=ce.Ecodigo
			
			where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cd.NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">
		</cfquery>	
	</cfif>	
</cfif>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	Select f.Mcodigo,Mnombre,Miso4217
	from FAP002 f
		inner join Monedas m
			on m.Ecodigo=f.Ecodigo
				and m.Mcodigo=f.Mcodigo
	where f.Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and FAP02FAC=1
</cfquery>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Hfecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
</cfquery>
<cfquery name="rsEtiquetaImp" datasource="#Session.DSN#">
	Select LBLIMP from FAP000
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="rsArchivoImp" datasource="#Session.DSN#">
	Select cfmCotizacion from FAP000
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>

<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<cfoutput>
<form name="form1" method="post" action="cotizaciones-sql.cfm" style="margin: '0'" onSubmit="javascript: return validaMon();">
	<!--- Estatus 0 como Digitada --->
	<input type="hidden" name="Estatus" value="0">
	<!--- Tipo de Cotizacion 1='Prefactura' --->
	<input type="hidden" name="tipoCoti" value="1">	
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<cfif modo NEQ 'ALTA'>
			<tr class="AreaFiltro">
			  <td colspan="5" align="center"><span class="style1">#LvarTitulo#&nbsp;&nbsp;&nbsp;#rsForm.NumeroCot#</span>&nbsp;&nbsp; <strong>(estatus: #rsForm.EstatusDesc#)</strong></td>
			</tr>
		</cfif>	 
		<tr>
			<td align="right"><strong>Cliente:</strong></td>
			<td colspan="2">
				<cfif modo neq 'ALTA'>
					<cf_sifClienteDetCorp tabindex="5" modificable='false' modo='CAMBIO' idquery="#rsForm.CDCcodigo#">
				<cfelse>
					<cf_sifClienteDetCorp tabindex="5" modo='ALTA'>
				</cfif>			
			</td>
		
		<td align="right"><strong>Fecha:</strong></td>
			<td>
				<cfif modo neq "ALTA">
					<cfif isdefined('rsForm')>
						<cfset LvarFecha = rsForm.Fecha_doc>
					<cfelse>
						<cfset LvarFecha = now()>
					</cfif>
				<cfelse>
					<cfset LvarFecha = now()>
				</cfif>	
				<cf_sifcalendario tabindex="5" form="form1" value="#DateFormat(LvarFecha,'dd/mm/yyyy')#" name="Fecha_doc">
			</td>
			
			</tr>
			<td align="right"><strong>Vendedor:</strong></td>
			<td colspan="3">
				<cfif modo NEQ "ALTA">
					<cf_sifvendedores tabindex="1" form="form1" id="#rsForm.FAX04CVD#">
				<cfelse>
					<cf_sifvendedores tabindex="1" form="form1">
				</cfif>			
			</td>
			<td rowspan="8" align="right" valign="top">
				<cfif modo NEQ 'ALTA'>
					<table width="70%"  border="0">
					  <tr>
						<td>
							<fieldset><legend><strong>Totales</strong></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="right" nowrap><strong>Sub Total:</strong></td>
										<td>
											<input name="MonSubTotal" readonly="true" type="text" id="MonSubTotal3" value="<cfif isdefined('totDetalle') and totDetalle.recordCount GT 0>#LSNumberFormat(totDetalle.sumSubTotal,',9.00')#<cfelse>0</cfif>"
													style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" 
													onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
													tabindex="12">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>Descuento:</strong></td>
										<td >
											<input name="MonDescuentoL" readonly="true" type="text" id="MonDescuentoL3" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.MonDescuentoL,',9.00')#"</cfif> style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="13">
										</td>
									</tr>
									<tr>
										<td align="right" nowrap><strong>Descuento Factura:</strong></td>
										<td>
											<input name="MonDescuentoF" readonly="true" type="text" id="MonDescuentoF3" value="<cfif isdefined('totDetalle') and totDetalle.recordCount GT 0>#LSNumberFormat(rsForm.MonDescuentoF,',9.00')#<cfelse>0</cfif>" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="14">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>Neto:</strong></td>
										<td >
											<cfset varNeto = 0>
											<cfif isdefined('totDetalle') 
														and totDetalle.recordCount GT 0 
														and totDetalle.sumSubTotal NEQ ''
														and totDetalle.sumDescuento NEQ ''
														and totDetalle.sumDescFactura NEQ ''>
												<cfset varNeto = totDetalle.sumSubTotal - totDetalle.sumDescuento - totDetalle.sumDescFactura>
											</cfif>									
											<input name="MonNeto" readonly="true" type="text" id="MonNeto" value="#LSNumberFormat(varNeto,',9.00')#" 
												style="text-align: right" size="20" maxlength="18" tabindex="15"
												onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  
												onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>#rsEtiquetaImp.LBLIMP#:</strong></td>
										<td >
											<input name="MonImpuesto" readonly="true" type="text" id="MonImpuesto3" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.MonImpuesto,',9.00')#"</cfif> style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="16">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>Total:</strong></td>
										<td >
											<input readonly="true" name="MonTotalCot" type="text" id="MonTotalCot3" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.MonTotalCot,',9.00')#"</cfif> style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="17">
										</td>
									</tr>							
								</table>
							</fieldset>
						</td>
					  </tr>
					</table>			
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Oficina:</strong></td>
			<td colspan="3">
				<cfif modo NEQ 'ALTA'>
					<cfquery name="VerificaDetalle" datasource="#Session.DSN#">
						select 1 from FACotizacionesD 
						where Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and  NumeroCot = <cfqueryparam value="#rsForm.NumeroCot#" cfsqltype="cf_sql_numeric">
					</cfquery>
				</cfif>
				<cfif modo NEQ 'ALTA' and VerificaDetalle.RecordCount NEQ 0>
					<cf_sifoficinas form="form1" id="#rsForm.Ocodigo#" modificable = "false" tabindex="2">
				<cfelseif modo NEQ 'ALTA' and VerificaDetalle.RecordCount EQ 0>
					<cf_sifoficinas form="form1" id="#rsForm.Ocodigo#" tabindex="2">
				<cfelse>	
					<cf_sifoficinas form="form1" Ocodigo="Ocodigo" tabindex="2">
				</cfif>			
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>Direcci&oacute;n de Facturaci&oacute;n</strong></td>
		<td><input name="Direccion" tabindex="22" type="text" id="Direccion" onFocus="javascript: this.select();" value="<cfif modo NEQ 'Alta'>#rsForm.Direccion#</cfif>" size="35" maxlength="80" <cfif modo neq 'alta'> readonly="true"</cfif>></td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>Transacci&oacute;n:</strong></td>
			<td>
				<select name="TipoTransaccion" tabindex="4" <cfif modo neq 'ALTA'>disabled</cfif>>
					<cfif LvarEsPrefacturaControl>
						<option value="0" <cfif modo NEQ 'ALTA' and rsForm.TipoTransaccion EQ '0'> selected</cfif>>Prefactura</option>
					<cfelse>
						<option value="1" <cfif modo NEQ 'ALTA' and rsForm.TipoTransaccion EQ '1'> selected</cfif>>Cotizaci&oacute;n Factura</option>
						<option value="2" <cfif modo NEQ 'ALTA' and rsForm.TipoTransaccion EQ '2'> selected</cfif>>Cotizaci&oacute;n Nota de Cr&eacute;dito</option>
					</cfif>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Orden de Compra:</strong></td>
			<td nowrap="nowrap"><input name="NumOrdenCompra" type="text" id="NumOrdenCompra2" <cfif modo NEQ 'Alta'> value="#rsForm.NumOrdenCompra#"<cfelse>value=""</cfif> style="text-align: right" size="20" maxlength="18" tabindex="4" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,-1);"  onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"></td>
			<td align="right" nowrap>&nbsp;&nbsp;<strong>% Descuento:</strong></td>
			<td nowrap>
				<input name="PorcDescCliente" type="text" id="PorcDescCliente" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.PorcDescCliente,',9.00')#"<cfelse> value="0"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="6" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2); revisaMonDets(this);"  onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}cambioDescCliente();}">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Moneda:</strong></td>
			<td><select <cfif isdefined('rsCantDet') and rsCantDet.recordCount GT 0 and rsCantDet.cantLineas GT 0> disabled</cfif> name="Mcodigo" onChange="javascript: cambioMoneda(this);" tabindex="7">
					<cfif isdefined('rsMonedas') and rsMonedas.recordCount GT 0>
						<cfloop query="rsMonedas">
							<option value="#Mcodigo#" <cfif modo NEQ 'ALTA' and rsForm.Mcodigo EQ rsMonedas.Mcodigo> selected</cfif>>(#Miso4217#)&nbsp;#Mnombre#</option>
						</cfloop>
					</cfif>
				</select>
			</td>
			<td align="right"><strong>Tipo  Cambio:</strong></td>
			<td><input name="TipoCambio" type="text" id="TipoCambio2" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.TipoCambio,',9.00')#"<cfelse> value="0.00"</cfif> style="text-align: right"  size="20" maxlength="18" tabindex="8" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
		</tr>
		<tr>
			<td align="right" valign="top"><strong>Observaciones:</strong></td>
			<td rowspan="3" valign="top"><textarea tabindex="9" name="Observaciones" cols="25" rows="4" id="textarea2"><cfif modo NEQ 'Alta'>#rsForm.Observaciones#</cfif></textarea></td>
			
			<td align="right"><strong>Días de Vencimiento:</strong></td>
			<cfset dia_venc = 0 >
				<cfif modo neq 'ALTA'>
					<cfset dia_venc = LSNumberFormat((rsForm.vencimiento),"0")>
					<td><cf_inputNumber name="vencimiento" value="#dia_venc#" size="15" enteros="4" decimales="0"></td>
				<cfelse>
					<td><cf_inputNumber name="vencimiento" value="0" size="15" enteros="3" decimales="0"></td>
					</cfif>
			</tr>
		<tr>
		<td>&nbsp;</td>
		
				<td align="right" valign="top"><strong>Pago:</strong></td>
			<td valign="top">
			  <input tabindex="10" name="TipoPago" <cfif modo NEQ 'ALTA' and rsForm.TipoPago EQ '0'> checked<cfelseif modo EQ 'ALTA'> checked</cfif> type="radio"  value="0">
			  Contado
			</td>
		</tr>
		<tr>
			<td align="right">&nbsp;</td>
			<td align="right">&nbsp;</td>
			<td>
			  <input tabindex="11" name="TipoPago" type="radio"  <cfif modo NEQ 'ALTA' and rsForm.TipoPago EQ '1'> checked </cfif> value="1">
				Cr&eacute;dito 
			</td>
			</tr>
		<tr>
			<td align="right">&nbsp;</td>
			<td align="right">&nbsp;</td>
			<td align="right">&nbsp;</td>
			<td><input tabindex="3" type="checkbox" <cfif modo NEQ 'ALTA'>disabled="true"</cfif> name="Exento" value="1" <cfif modo NEQ 'ALTA' and rsForm.Exento EQ '1'> checked</cfif>><strong> Exento</strong></td>
		</tr>			
	<tr>
		<td colspan="5" align="center">
		<cfif modo neq 'ALTA'  >
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">				
			<input type="hidden" name="NumeroCot" value="#rsForm.NumeroCot#">				
			<input type="hidden" name="tipoCalculos" value="#tipoCalculos#">
			<!--- Solo se permite modificar cotizaciones con estatus '0' de Digitadas --->
			<cfif rsForm.Estatus NEQ '0'>
				<input name="imp" type="button" id="imprimir" value="Imprimir" onClick="javascript: funcImprimir()" tabindex="18">
			</cfif>
			<cfif rsForm.Estatus EQ '0'>
				<cf_botones tabindex='12' modo='CAMBIO' includebefore="Imprimir">
			</cfif>
		<cfelse>
			<cf_botones tabindex='12' modo='ALTA'>
		</cfif>		
		</td>
	</tr>  	 	   	  
	</table>
</form>
</cfoutput>		

<cfif modo neq 'ALTA'>
	<table width="100%"  border="0">
 		<tr>
			<td class="tituloListas">Detalles de la Prefactura</td>
	  	</tr>
	  	<tr>
			<td>
				<cfinclude template="cotizacionesDet-form.cfm">
			</td>
	  	</tr>
	  	<tr>
			<td>
				<cfinclude template="cotizacionesDet-lista.cfm">
			</td>
	  	</tr>
	</table>
</cfif>

<iframe id="frExenDesc" name="frExenDesc" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>

<cf_qforms form="form1" objForm="objForm">
	<script language="javascript" type="text/javascript">
		<cfif modo neq 'ALTA'>
		function funcImprimir(){
			var width = 700;
			var height = 500;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			if (confirm('¿Desea Imprimir la Cotización?')) {
				<cfoutput>
				var params = "?NumeroCot=#rsForm.NumeroCot#&ruta="+escape('#rsArchivoImp.cfmCotizacion#');
				var nuevo = window.open('reporte_documento.cfm'+params,'Cotizaciones','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
				</cfoutput>
				nuevo.focus();
			}
			return false;
		}
		</cfif>
		function funcCDCidentificacion(){
			if(document.form1.CDCcodigo.value != ''){
				var params = "&porcDesc=PorcDescCliente&exen=Exento";
	
				document.all["frExenDesc"].src="/cfmx/sif/pv/operacion/traeDescExen.cfm?valor="+document.form1.CDCcodigo.value+"&formulario=form1"+params;
			}else{
				document.form1.PorcDescCliente.value = '0.00';
				document.form1.Exento.checked = false;
			}
		}

		function cambioMoneda(cb){
			if (cb.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){
				document.form1.TipoCambio.value = "1.00";
				document.form1.TipoCambio.disabled = true;
			}else{
				<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
				
				//Verificar si existe en el recordset
				var nRows = rsTCsug.getRowCount();
				if (nRows > 0) {
					for (row = 0; row < nRows; ++row) {
						if (rsTCsug.getField(row, "Mcodigo") == cb.value) {
							document.form1.TipoCambio.value = rsTCsug.getField(row, "<cfoutput>#TC#</cfoutput>");
							document.form1.TipoCambio.disabled = false;
							row = nRows;
						}else{
							document.form1.TipoCambio.value = "0.00";					
						}
					}									
				}else{
					document.form1.TipoCambio.value = "0.00";			
				}
			}
		}
	
		function sugerirTClocal() {
			if (document.form1.Mcodigo.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){								
				document.form1.TipoCambio.value = "1.00";
				document.form1.TipoCambio.disabled = true;
			}
		}	

		function validaMon(){
			document.form1.TipoCambio.value = qf(document.form1.TipoCambio.value);
			document.form1.PorcDescCliente.value = qf(document.form1.PorcDescCliente.value);
			<cfif modo neq 'ALTA'>
				document.form1.MonSubTotal.value = qf(document.form1.MonSubTotal.value);
				document.form1.MonDescuentoF.value = qf(document.form1.MonDescuentoF.value);
				document.form1.MonNeto.value = qf(document.form1.MonNeto.value);
				document.form1.MonImpuesto.value = qf(document.form1.MonImpuesto.value);
				document.form1.MonTotalCot.value = qf(document.form1.MonTotalCot.value);
				document.form1.MonDescuentoL.value = qf(document.form1.MonDescuentoL.value);			
			</cfif>		
					
			//Habilitando los objetos
			document.form1.TipoCambio.disabled = false;
			document.form1.Exento.disabled = false;		
			document.form1.Mcodigo.disabled = false;
			document.form1.TipoTransaccion.disabled = false;		
	
			return true;
		}
	
		function cambioDescCliente(){
			<cfif modo NEQ 'ALTA'>
				//Ejecuta la funcion del detalle que realiza los calculos respectivos del mismo
				if (calcDescTotal) {calcDescTotal();}	
			</cfif>
		}
		function revisaMonDets(por){
			cambioDescCliente();
		}
	
		function deshabilitaValidacion() {
			objForm.FAX04CVD.required = false;
			objForm.Ocodigo.required = false;
			objForm.CDCcodigo.required = false;
			objForm.Mcodigo.required = false;
			objForm.TipoTransaccion.required = false;
			objForm.TipoCambio.required = false;
			objForm.PorcDescCliente.required = false;
		}

		function funcBaja() {
			if(!confirm('¿Desea eliminar esta cotización ?')){
				return false;
			}
			deshabilitaValidacion();
			return true;		
		}
	
		// Funcion para validar que el porcentaje digitado no sea mayor a100
		function _Porcen(){	
			if ( (new Number(qf(this.value)) > 100) || (new Number(qf(this.value)) < 0 )){
				this.error = 'El campo no puede ser mayor a 100 ni menor que cero';
				this.value = '';
			}
		}	
	
	// Validaciones para los campos de % no sean mayores a 100 		
	_addValidator("isPorcen", _Porcen);	

	objForm.FAX04CVD.required = true;
	objForm.FAX04CVD.description = "Vendedor";
	
	objForm.CDCcodigo.required = true;
	objForm.CDCcodigo.description = "Cliente";
	
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description = "Oficina";	
	
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";

	objForm.TipoTransaccion.required = true;
	objForm.TipoTransaccion.description = "Tipo de Transacción";
	
	objForm.TipoCambio.required = true;
	objForm.TipoCambio.description = "Tipo de Cambio";	
	
	objForm.PorcDescCliente.required = true;
	objForm.PorcDescCliente.description = "Descuento en Factura";	
	
	objForm.PorcDescCliente.validatePorcen();
	sugerirTClocal();	
	cambioMoneda(document.form1.Mcodigo);
</script>
