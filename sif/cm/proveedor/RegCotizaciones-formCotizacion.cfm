<cfquery name="rsProcesoCompra" datasource="sifpublica">
	select a.Ecodigo, a.cncache, a.CMFPid, a.CMIid
	from ProcesoCompraProveedor a, InvitadosProcesoCompra b
	where a.PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
	and a.PCPid = b.PCPid
	and a.CMPfmaxofertas >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	and b.UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<cfif rsProcesoCompra.recordCount GT 0>

	<!--- Monedas --->
	<cfquery name="rsMonedas" datasource="#rsProcesoCompra.cncache#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoCompra.Ecodigo#">
		order by Mcodigo
	</cfquery>
	
	<!--- Formas de Pago --->
	<cfquery name="rsCMFormasPago" datasource="#rsProcesoCompra.cncache#">
		select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
		from CMFormasPago
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoCompra.Ecodigo#">
		order by CMFPcodigo
	</cfquery>
	
	<!--- Incoterm --->
	<cfquery name="rsCMIncoterm" datasource="#rsProcesoCompra.cncache#">
		select CMIid, CMIcodigo, CMIdescripcion, CMIpeso
		from CMIncoterm
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoCompra.Ecodigo#">
		order by CMIcodigo
	</cfquery>
	
	<cfquery name="rsLineasProceso" datasource="sifpublica">
		select  a.LPCid, a.PCPid, a.CEcodigo, 
				a.Ecodigo, a.EcodigoASP, a.cncache, 
				a.DSlinea, a.ESidsolicitud, a.DScant, 
				a.Unidad, a.DSdescripcion, a.DSdescalterna, 
				a.DSobservacion
		from LineasProcesoCompras a, InvitadosProcesoCompra b
		where a.PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
		and a.PCPid = b.PCPid
		and b.UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	</cfquery>
	
	<cfif modo EQ "CAMBIO">
		<cfquery name="rsEncabezado" datasource="sifpublica">
			select a.UsucodigoP, 
				   rtrim(a.CPnumero) as CPnumero, a.CMFPid, a.PCPid, a.CPfechacoti,
				   a.CPdescripcion, a.CPobs,
				   a.CPprocesado, CPsubtotal,
				   a.CPtotdesc, a.CPtotimp, a.CPtotal,
				   a.Mcodigo, a.CPtipocambio,
				   a.CMIid,  a.ECfechavalido, 
				   a.CPfechaaplica, a.CPestado, a.ts_rversion
			from CotizacionesProveedor a
			where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
			and a.UsucodigoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		</cfquery>
		
		<cfquery name="rsDetalles" datasource="sifpublica">
			select a.DCPlinea, a.LPCid, a.DCPcantidad, a.DCPpreciou, a.DCPgarantia, 
				   a.DCPplazocredito, a.DCPplazoentrega, a.DCPimpuestos, a.DCPdesclin, a.DCPtotimp, 
				   a.DCPtotallin, a.DCPdescprov, a.DCPunidadcot, a.DCPconversion, a.ts_rversion
			from DCotizacionProveedor a
			where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
		</cfquery>
	<cfelseif isdefined("Form.PCPid") and len(trim(Form.PCPid))>
		<cfquery name="rsEncabezado" datasource="sifpublica">
			select a.UsucodigoP, 
				   rtrim(a.CPnumero) as CPnumero, a.CMFPid, a.PCPid, a.CPfechacoti,
				   a.CPdescripcion, a.CPobs,
				   a.CPprocesado, CPsubtotal,
				   a.CPtotdesc, a.CPtotimp, a.CPtotal,
				   a.Mcodigo, a.CPtipocambio,
				   a.CMIid,  a.ECfechavalido, 
				   a.CPfechaaplica, a.CPestado, a.ts_rversion
			from CotizacionesProveedor a
			where a.PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
			and a.UsucodigoP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		</cfquery>
	</cfif>
	
	<cfset listaCPnum = ''>
	<cfif isdefined('rsCPnumero') and rsCPnumero.recordCount GT 0>
		<cfset listaCPnum = ValueList(rsCPnumero.CPnumero, ',')>
	</cfif>
	
	<cfoutput>
		<script src="/cfmx/sif/js/utilesMonto.js" language="javascript" type="text/javascript"></script>
		<script src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="javascript" type="text/javascript">
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		
			function doConlisModificar(linea,DSlinea,unidad) {		
				var width = 650;
				var height = 250;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				var params = '?f=form1&i='+linea+'&DSlinea1='+DSlinea+'&Unidad='+unidad;			
				var nuevo = window.open('/cfmx/sif/cm/proveedor/conlisModificacion.cfm'+params, 'FormModificar', 'menu=no, scrollbars=yes, top=' + top + ',left=' + left + ',width=' + width + ',height=' + height);
				nuevo.focus();
			}
			
			function validarForm(f) {
				<cfloop query="rsLineasProceso">
					f.obj.DCPgarantia_#rsLineasProceso.LPCid#.value = qf(f.obj.DCPgarantia_#rsLineasProceso.LPCid#.value);
					f.obj.DCPplazocredito_#rsLineasProceso.LPCid#.value = qf(f.obj.DCPplazocredito_#rsLineasProceso.LPCid#.value);
					f.obj.DCPplazoentrega_#rsLineasProceso.LPCid#.value = qf(f.obj.DCPplazoentrega_#rsLineasProceso.LPCid#.value);
					f.obj.DCPpreciou_#rsLineasProceso.LPCid#.value = qf(f.obj.DCPpreciou_#rsLineasProceso.LPCid#.value);
					f.obj.DCPimpuestos_#rsLineasProceso.LPCid#.value = qf(f.obj.DCPimpuestos_#rsLineasProceso.LPCid#.value);
					f.obj.DCPdesclin_#rsLineasProceso.LPCid#.value = qf(f.obj.DCPdesclin_#rsLineasProceso.LPCid#.value);
				</cfloop>
			}

			<!--- Objectos para el manejo de plazos de crédito según la forma de pago --->
			var fp = new Object();
			<cfloop query="rsCMFormasPago">
				fp['#CMFPid#'] = #CMFPplazo#;
			</cfloop>
			
			function getPlazo(id) {
				if (fp[id] != null) {
				<cfloop query="rsLineasProceso">
					document.form1.DCPplazocredito_#rsLineasProceso.LPCid#.value = fp[id];
				</cfloop>
				}
			}

		</script>
		<form name="form1" method="post" action="RegCotizaciones-sql.cfm" style="margin:0;" onSubmit="javascript: return validarForm(this);">
			<input type="hidden" name="PCPid" value="#Form.PCPid#">
			<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
				<input type="hidden" name="CPid" value="#Form.CPid#">
			</cfif>
			<cfif isdefined("Form.returnLista") and Len(Trim(Form.returnLista))>
				<input type="hidden" name="returnLista" value="#Form.returnLista#">
			</cfif>
			<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr bgcolor="##CCCCCC">
				<td colspan="8" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Registro de Cotizaci&oacute;n</strong></td>
			  </tr>
			  <tr>
				<td align="right" nowrap class="fileLabel">Fecha Cotizaci&oacute;n:</td>
				<td nowrap>
					<cfif modo EQ "CAMBIO">
						<cfset fechacoti = LSDateFormat(rsEncabezado.CPfechacoti, 'dd/mm/yyyy')>
					<cfelse>
						<cfset fechacoti = LSDateFormat(Now(), 'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario form="form1" name="CPfechacoti" value="#fechacoti#">
				</td>
				<td align="right" nowrap class="fileLabel">N&uacute;mero:</td>
				<td nowrap>
					<input name="CPnumero" type="text" size="10" maxlength="10" value="<cfif modo EQ 'CAMBIO'>#rsEncabezado.CPnumero#</cfif>">
				</td>
				<td align="right" nowrap class="fileLabel">Descripci&oacute;n:</td>
				<td nowrap><input name="CPdescripcion" type="text" id="CPdescripcion" size="40" maxlength="100" value="<cfif modo EQ 'CAMBIO'>#rsEncabezado.CPdescripcion#</cfif>"></td>
				<td align="right" nowrap class="fileLabel">Procesado por:</td>
				<td nowrap><input name="CPprocesado" type="text" id="CPprocesado" size="30" maxlength="120" value="<cfif modo EQ 'CAMBIO'>#rsEncabezado.CPprocesado#</cfif>"></td>
			  </tr>
			  <tr>
				<td align="right" nowrap class="fileLabel">Moneda:</td>
				<td nowrap>
				  <select name="Mcodigo">
					<cfloop query="rsMonedas">
					  <option value="#rsMonedas.Mcodigo#"<cfif modo EQ "CAMBIO" and rsMonedas.Mcodigo EQ rsEncabezado.Mcodigo> selected</cfif>>#rsMonedas.Mnombre#</option>
					</cfloop>
				  </select>
				</td>
				<td align="right" nowrap class="fileLabel">Tipo Cambio:</td>
				<td nowrap>
				  <input type="text" name="CPtipocambio" size="12" maxlength="12" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ "CAMBIO">#LSNumberFormat(rsEncabezado.CPtipocambio,',9.00')#<cfelse>1.00</cfif>">
				</td>
				<td class="fileLabel" align="right" nowrap>Forma Pago:</td>
				<td nowrap>
					<select name="CMFPid" onChange="javascript: getPlazo(this.value);">
					  <cfloop query="rsCMFormasPago">
						<option value="#CMFPid#" <cfif modo EQ 'CAMBIO' and rsCMFormasPago.CMFPid eq rsEncabezado.CMFPid> selected<cfelseif isdefined("Form.PCPid") and len(trim(Form.PCPid)) and rsCMFormasPago.CMFPid eq rsProcesoCompra.CMFPid> selected</cfif>>#rsCMFormasPago.CMFPcodigo# - #rsCMFormasPago.CMFPdescripcion#</option>
					  </cfloop>
					</select>
				</td>
				<td class="fileLabel" align="right" nowrap>Incoterm:</td>
				<td nowrap>
					<select name="CMIid">
					  <option value="">--Ninguno--</option>
					  <cfloop query="rsCMIncoterm">
						<option value="#rsCMIncoterm.CMIid#" <cfif modo EQ 'CAMBIO' and rsCMIncoterm.CMIid eq rsEncabezado.CMIid> selected<cfelseif isdefined("Form.PCPid") and len(trim(Form.PCPid)) and rsCMIncoterm.CMIid eq rsProcesoCompra.CMIid> selected</cfif>>#rsCMIncoterm.CMIcodigo# - #rsCMIncoterm.CMIdescripcion#</option>
					  </cfloop>
					</select>
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap class="fileLabel">V&aacute;lido hasta: </td>
				<td nowrap>
					  <cfset fechavalida = Now() >
					  <cfif modo EQ 'CAMBIO'>
						<cfset fechavalida = rsEncabezado.ECfechavalido >
					  </cfif>
					  <cf_sifcalendario tabindex="1" name="ECfechavalido" value="#LSDateFormat(fechavalida, 'dd/mm/yyyy')#"> 
				</td>
				<td align="right" nowrap class="fileLabel">Observaciones:</td>
				<td colspan="5" nowrap><input type="text" name="CPobs" style="width: 100%" value="<cfif modo EQ 'CAMBIO'>#rsEncabezado.CPobs#</cfif>">			</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr bgcolor="##CCCCCC">
				<td colspan="8" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Bienes y Servicios</strong></td>
			  </tr>
			  <tr>
				<td colspan="8">
					<table width="950"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td class="tituloListas" width="153" nowrap>L&iacute;nea</td>
						<td class="tituloListas" width="65" align="center" nowrap>Cantidad</td>
						<td class="tituloListas" width="65" align="center" nowrap>Unidades</td>
						<td class="tituloListas" width="70" align="center" nowrap>Garant&iacute;a</td>
						<td class="tituloListas" width="87" align="center" nowrap>Plazo Cr&eacute;dito </td>
						<td class="tituloListas" width="87" align="center" nowrap>Plazo Entrega </td>
						<td class="tituloListas" width="91" align="center" nowrap>Precio unitario </td>
						<td class="tituloListas" width="85" align="center" nowrap>% Impuesto</td>
						<td class="tituloListas" width="80" align="center" nowrap>Descuento</td>
						<td class="tituloListas" width="93" align="right" nowrap>Total</td>
						<td class="tituloListas" width="20" align="center" nowrap>&nbsp;</td>
					  </tr>
				  </table>
				  <div style="overflow:auto; height: 200; margin:0;" >
					<table width="950"  border="0" cellspacing="0" cellpadding="2">
					  <cfloop query="rsLineasProceso">
					  <cfif modo EQ "CAMBIO">
						  <cfquery name="rsDetalleLinea" dbtype="query">
							select *
							from rsDetalles
							where LPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasProceso.LPCid#">
						  </cfquery>					  
					  </cfif>
					  <tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
						<td width="153" nowrap>
							#rsLineasProceso.DSdescripcion#
							<input type="hidden" name="DCPdescprov_#rsLineasProceso.LPCid#" value="<cfif modo EQ "CAMBIO">#rsDetalleLinea.DCPdescprov#</cfif>">
						</td>
						<td width="65" align="center" nowrap>
							<input type="text" style="border: none; text-align: right" name="DCPcantidad_#rsLineasProceso.LPCid#" value="<cfif modo EQ "CAMBIO">#rsDetalleLinea.DCPcantidad#<cfelse>#rsLineasProceso.DScant#</cfif>" size="6" tabindex="-1" readonly>
						</td>
						<td width="65" align="center" nowrap>
							<input type="text" style="border: none;" name="DCPunidadcot_#rsLineasProceso.LPCid#" value="<cfif modo EQ "CAMBIO">#rsDetalleLinea.DCPunidadcot#<cfelse>#rsLineasProceso.Unidad#</cfif>" size="10" tabindex="-1" readonly>
							<input type="hidden" name="DCPconversion_#rsLineasProceso.LPCid#" value="<cfif modo EQ "CAMBIO">#rsDetalleLinea.DCPconversion#<cfelse>1.00</cfif>">
						</td>
						<td width="70" align="center" nowrap><input name="DCPgarantia_#rsLineasProceso.LPCid#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCPgarantia#<cfelse>0</cfif>" size="5" maxlength="10">&nbsp;d&iacute;as</td>
						<td width="87" align="center" nowrap><input name="DCPplazocredito_#rsLineasProceso.LPCid#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCPplazocredito#<cfelse>0</cfif>" size="5" maxlength="10" readonly>&nbsp;d&iacute;as</td>
						<td width="87" align="center" nowrap><input name="DCPplazoentrega_#rsLineasProceso.LPCid#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#rsDetalleLinea.DCPplazoentrega#<cfelse>0</cfif>" size="5" maxlength="10">&nbsp;d&iacute;as</td>
						<td width="91" align="center" nowrap><input name="DCPpreciou_#rsLineasProceso.LPCid#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCPpreciou,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;"></td>
						<td width="85" align="center" nowrap><input name="DCPimpuestos_#rsLineasProceso.LPCid#" type="text" style="text-align: right;" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCPimpuestos,',9.00')#<cfelse>0.00</cfif>" size="6" maxlength="10"></td>
						<td width="80" align="center" nowrap><input name="DCPdesclin_#rsLineasProceso.LPCid#" type="text" size="12" maxlength="20" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCPdesclin,',9.00')#<cfelse>0.00</cfif>" style="text-align: right;"></td>
						<td width="93" align="center" nowrap><input name="DCPtotallin_#rsLineasProceso.LPCid#" type="text" size="15" maxlength="20" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsDetalleLinea.DCPtotallin,',9.00')#<cfelse>0.00</cfif>" style="text-align: right; border: none;" tabindex="-1" readonly></td>
						<td width="20" align="center" nowrap><a href="javascript: doConlisModificar('#rsLineasProceso.LPCid#','#rsLineasProceso.DSlinea#','#rsLineasProceso.Unidad#'); " tabindex="-1" title="Modificar Requerimientos"><img src="../../imagenes/iedit.gif" width="16" height="16" border="0" align="Modificar Linea"></a></td>				  	
					  </tr>
					  </cfloop>
					</table>
					</div>
					<table width="950"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td align="center">
							<input type="submit" name="btnGuardar" value="Guardar" onClick="javascript: habilitarValidacion();">
						  <cfif modo NEQ "ALTA">
							<input type="submit" name="btnAplicar" value="Aplicar" onClick="javascript: habilitarValidacion(); ">
						  </cfif>
						  <cfif isdefined("Form.returnLista")>
							<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href = 'RegCotizaciones.cfm?PCPid=#Form.PCPid#';">
						  <cfelse>
							<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href = 'RegCotizaciones.cfm';">
						  </cfif>
						</td>
					  </tr>
					  <tr>
						<td align="center">&nbsp;</td>
					  </tr>
					</table>
				</td>
			  </tr>
			</table>
		</form>
	</cfoutput>
	
	<script language="javascript" type="text/javascript">
		function __isNotCero() {
			if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
				this.error = "El campo " + this.description + " no puede ser cero!";
			}
		}
		
		function __isFechaValida() {
			if (this.required && this.obj.form.ECfechavalido.value != "") {
				var a = this.obj.form.CPfechacoti.value.split("/");
				var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
				var b = this.obj.form.ECfechavalido.value.split("/");
				var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
				if (fin < ini) {
					this.error = "La fecha de cotización no puede ser mayor a la fecha de validez de cotización";
				}
			}
		}
	
		function habilitarValidacion() {
			objForm.CPfechacoti.required = true;
			objForm.CPnumero.required = true;
			objForm.CPdescripcion.required = true;
			objForm.CMFPid.required = true;
			objForm.CPprocesado.required = true;
			objForm.CPobs.required = true;
			<cfoutput query="rsLineasProceso">
				objForm.DCPgarantia_#rsLineasProceso.LPCid#.required = true;
				objForm.DCPgarantia_#rsLineasProceso.LPCid#.description = "Garantía";
				//objForm.DCPgarantia_#rsLineasProceso.LPCid#.validateNotCero();
				objForm.DCPplazocredito_#rsLineasProceso.LPCid#.required = true;
				objForm.DCPplazocredito_#rsLineasProceso.LPCid#.description = "Plazo de Crédito";
				//objForm.DCPplazocredito_#rsLineasProceso.LPCid#.validateNotCero();
				objForm.DCPplazoentrega_#rsLineasProceso.LPCid#.required = true;
				objForm.DCPplazoentrega_#rsLineasProceso.LPCid#.description = "Plazo de Entrega";
				//objForm.DCPplazoentrega_#rsLineasProceso.LPCid#.validateNotCero();
				objForm.DCPpreciou_#rsLineasProceso.LPCid#.required = true;
				objForm.DCPpreciou_#rsLineasProceso.LPCid#.description = "Precio Unitario";
				objForm.DCPpreciou_#rsLineasProceso.LPCid#.validateNotCero();
				objForm.DCPimpuestos_#rsLineasProceso.LPCid#.required = true;
				objForm.DCPimpuestos_#rsLineasProceso.LPCid#.description = "% Impuesto";
				objForm.DCPdesclin_#rsLineasProceso.LPCid#.required = true;
				objForm.DCPdesclin_#rsLineasProceso.LPCid#.description = "Descuento";
			</cfoutput>
		}
		
		function inhabilitarValidacion() {
			objForm.CPfechacoti.required = false;
			objForm.CPnumero.required = false;
			objForm.CPdescripcion.required = false;
			objForm.CMFPid.required = false;
			objForm.CPprocesado.required = false;
			objForm.CPobs.required = false;
			<cfoutput query="rsLineasProceso">
				objForm.DCPgarantia_#rsLineasProceso.LPCid#.required = false;
				objForm.DCPplazocredito_#rsLineasProceso.LPCid#.required = false;
				objForm.DCPplazoentrega_#rsLineasProceso.LPCid#.required = false;
				objForm.DCPpreciou_#rsLineasProceso.LPCid#.required = false;
				objForm.DCPimpuestos_#rsLineasProceso.LPCid#.required = false;
				objForm.DCPdesclin_#rsLineasProceso.LPCid#.required = false;
			</cfoutput>
		}
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		_addValidator("isNotCero", __isNotCero);
		_addValidator("isFechaValida", __isFechaValida);
		
		objForm.CPfechacoti.required = true;
		objForm.CPfechacoti.description = "Fecha de Cotización";
		objForm.CPfechacoti.validateFechaValida();
		objForm.CPnumero.required = true;
		objForm.CPnumero.description = "Número";
		objForm.CPdescripcion.required = true;
		objForm.CPdescripcion.description = "Descripción";
		objForm.CMFPid.required = true;
		objForm.CMFPid.description = "Forma de Pago";
		objForm.CPprocesado.required = true;
		objForm.CPprocesado.description = "Procesado por";
		objForm.CPobs.required = true;
		objForm.CPobs.description = "Observaciones";

		<cfif modo EQ 'ALTA'>
			getPlazo(document.form1.CMFPid.value);
		</cfif>
		
	</script>

<cfelse>
	<p align="center">
		<strong>No puede registrar cotizaciones para el proceso de compra seleccionado</strong>
		<br>
		<br>
		<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href = 'RegCotizaciones.cfm';">
	</p>
</cfif>	
