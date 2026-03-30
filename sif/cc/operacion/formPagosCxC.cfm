<cfset fnleerconsultas()>
<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
</style>
<iframe id="frameExec" width="0" height="0" frameborder="0">&nbsp;</iframe>
 <cfif modo NEQ "ALTA">
	 <cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoTotales" returnvariable="rsAPagosCxCTotal">
		<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
		<cfinvokeargument name="CCTcodigo"      value="#rsPagos.CCTcodigo#">
		<cfinvokeargument name="Pcodigo"       	value="#rsPagos.Pcodigo#">
	</cfinvoke>
	<cfparam name="Balanceado" default="0">
	<cfif rsAPagosCxCTotal.DisponibleAnticipos EQ 0>
		<cfset Balanceado = 1>
	</cfif>
 </cfif>
<cfset LB_tituloAlterno = t.Translate('LB_tituloAlterno','Encabezado de Cobro')>   
<cfset LB_Banco = t.Translate('LB_Banco','Banco','/sif/generales.xml')> 
<cfset LB_CajaTrans = t.Translate('LB_CajaTrans','Caja Tránsito')> 
<cfset LB_Anticipo = t.Translate('LB_Anticipo','Anticipo')> 
<cfset LB_Notiene = t.Translate('LB_Notiene', 'No tiene')>  
<cfset LB_Referencia = t.Translate('LB_Referencia','Referencia')> 
<cfset LB_Oficina = t.Translate('Oficina','Oficina','/sif/generales.xml')> 
<cfset MSG_Detalle = t.Translate('MSG_Detalle','Detalle','/sif/generales.xml')> 
<cfset LB_Cuenta = t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')> 
<cfset LB_Disponible = t.Translate('LB_Disponible','Disponible')> 
<cfset LB_Observaciones = t.Translate('LB_Observaciones','Observaciones')> 
<cfset BTN_Agregar	= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset LB_ListaCobro = t.Translate('LB_ListaCobro','Lista de Cobros')>
<cfset LB_SelMas = t.Translate('LB_SelMas','Selección Masiva')>
<cfset BTN_ModEnc = t.Translate('BTN_ModEnc','Modificar Encabezado')>
<cfset BTN_GenAnt = t.Translate('BTN_GenAnt','Generar Anticipo')>
<cfset LB_btnNuevo = t.Translate('LB_btnNuevo','Nuevo','/sif/generales.xml')> 
<cfset BTN_BorrarCobro = t.Translate('BTN_BorrarCobro','Borrar Cobro')>
<cfset BTN_Aplicar	= t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset BTN_Ver = t.Translate('BTN_Ver','Ver')>
<cfset BTN_BorrarDet = t.Translate('BTN_BorrarDet','Borrar Detalles')>
<cfset MSG_BorrarDet = t.Translate('MSG_BorrarDet','Realmente desea borrar todos los detalles del Cobro')>
<cfset BTN_BorrarLinea = t.Translate('BTN_BorrarLinea','Borrar Linea')>
<cfset MSG_BorrarLinea = t.Translate('MSG_BorrarLinea','Realmente desea borrar esta línea de Cobro')>
<cfoutput>
<script type="text/javascript">
var MSG_DoctoNoBal = "  #MSG_DoctoNoBal#  ";
var MSG_DeseaAplDocCobr = "  #MSG_DeseaAplDocCobr#  ";
</script>
<!--- OBTENCION DEL TIPO DE CAMBIO HISTORICO --->
<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	SELECT m.Mcodigo,
	       m.Miso4217,
	       m.Mnombre
	FROM Empresas e
	INNER JOIN Monedas m ON e.Ecodigo = m.Ecodigo
	AND e.Mcodigo = m.Mcodigo
	WHERE e. Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>
<form method="post" name="form1" action="SQLPagosCxC.cfm" onSubmit="return validaForm(this);">
  <table width="100%" border="0" cellpadding="2" cellspacing="0">
    <tr> 
      <td>
		<input name="haydetalle" 		type="hidden" id="haydetalle"	  	value="<cfif isdefined("rsLineas") and rsLineas.recordCount GT 0>SI<cfelse>NO</cfif>">
		<input name="KCCTcodigo" 		type="hidden" id="KCCTcodigo" 	 	value="<cfif modo NEQ "ALTA">#KCCTcodigo#</cfif>">
		<input name="KPcodigo" 	 		type="hidden" id="KPcodigo" 		value="<cfif modo NEQ "ALTA">#KPcodigo#</cfif>">
		<input name="monedalocal" 		type="hidden" id="monedalocal" 		value="#rsMonedaLocal.Mcodigo#">
		<input name="Seleccionado" 		type="hidden" id="Seleccionado" 	value="<cfif modo NEQ "ALTA">#rsPagos.Seleccionado#</cfif>">
		<input name="timestampE"		type="hidden" id="timestampE" 		value="<cfif modo NEQ "ALTA">#ts#</cfif>">
		<input name="Balance" 			type="hidden" id="Balance" 			value="<cfif modo NEQ "ALTA">#Balanceado#</cfif>">
		<input name="UsarCatalogoCts" 	type="hidden" id="UsarCatalogoCts" 	value="#UsarCatalogoCts#">
		<input name="UsaCtaBanco" 		type="hidden" id="UsaCtaBanco" 		value="#UsaCtaBanco#">
        
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td colspan="6" valign="top" class="tituloAlterno">#LB_tituloAlterno#</td>
          </tr>
          <tr>
            <td colspan="6">&nbsp;</td>
          </tr>
          <tr>
            <td align="right" nowrap><strong>#LB_Documento#:&nbsp;</strong></td>
            <td nowrap><cfif modo NEQ "ALTA">
                <input type="hidden" id="Pcodigo" name="Pcodigo" value="#rsPagos.Pcodigo#">
                #rsPagos.Pcodigo#
                <cfelse>
                <input name="Pcodigo" type="text" id="Pcodigo" size="25" value="" tabindex="1" maxlength="20">
              </cfif>
            </td>
            <td align="right" nowrap><strong>#LB_Transaccion#:&nbsp;</strong></td>
			</cfoutput>
            <td nowrap>
              <select name="CCTcodigo" id="CCTcodigo" tabindex="1" <cfif modo NEQ "ALTA">disabled</cfif> style="width:215px">
                <cfoutput query="rsTransacciones">
                  <option value="#CCTcodigo#" <cfif modo NEQ "ALTA" and rsPagos.CCTcodigo EQ rsTransacciones.CCTcodigo>selected</cfif>>#Transaccion#</option>
                </cfoutput>
              </select>
			<cfoutput>
            </td>
            <td align="right" nowrap><strong>Total:&nbsp;</strong></td>
            <td nowrap>
              <input name="Ptotal_anterior" type="hidden" id="Ptotal_anterior" value="<cfif modo NEQ "ALTA">#rsPagos.Ptotal#<cfelse>0.00</cfif>">
              <input name="Ptotal" type="text" id="Ptotal" style="text-align: right"  
			  value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsPagos.Ptotal,'none')#<cfelse>0.00</cfif>" 
			  size="20" maxlength="18" tabindex="1" 
			  onFocus="this.value=qf(this); this.select();" 
			  onBlur="fm(this,2);"  
			  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
            </td>
          </tr>
          <tr>
            <td align="right" valign="middle" nowrap><strong>#LB_SocioNegocio#:&nbsp;</strong>
            <td nowrap>
              <cfif modo NEQ "ALTA" and rsPagos.SNcodigo gt 0>
                
                  <input name="SNcodigo" type="hidden" value="#rsSocioNegocios.SNcodigo#">
                  <input name="SNnombre" type="hidden" value="#rsSocioNegocios.SNnombre#">
                  <input name="SNnumero" type="hidden" value="#rsSocioNegocios.SNnumero#">
                  <strong>#rsSocioNegocios.SNnumero# &nbsp;&nbsp;#rsSocioNegocios.SNnombre#</strong>
                <cfelse>
                <cf_sifsociosnegocios2 form="form1" tabindex="1">
              </cfif>
            </td>
            <td align="right" nowrap><strong>#LB_Banco#:&nbsp;</strong></td>
            <td nowrap>
			</cfoutput>
            	<select name="CBid" tabindex="1" id="CBid" onchange="validaCtaTran(this.form); funcPoneMoneda(this.form);">
					<option value="">{Caja Tránsito}</option>
                	<cfoutput query="rsCuentaBanco">
						<option value="#CBid#" <cfif modo NEQ "ALTA" and rsPagos.CBid EQ rsCuentaBanco.CBid>selected</cfif>>#CBcodigo# #Miso4217#</option>
					</cfoutput>
                </select>
			<cfoutput>
            <iframe name="ifrMoneda" id="ifrMoneda" width="0" height="0">
            </iframe>
            <script language="javascript" type="text/javascript">
                function funcPoneMoneda(f)
                    {
						var LvarCBid = f.CBid.value;
                        document.getElementById('ifrMoneda').src = "PagoMoneda.cfm?CBid=" + LvarCBid;
                    }
            </script>
            </td>
            <td align="right" nowrap><strong>#LB_Anticipo#:&nbsp;</strong></td>
            <td nowrap>
              <input name="AnticipoLabel" type="text" id="AnticipoLabel" style="text-align: right" value="<cfif modo NEQ "ALTA" and rsAPagosCxCTotal.TotalAnticipos NEQ 0>#LSCurrencyFormat(rsAPagosCxCTotal.TotalAnticipos,'none')#<cfelse>#LB_Notiene#</cfif>" size="17" maxlength="18" tabindex="-1" class="cajasinborde" readonly>
            </td>
          </tr>
          <tr>
            <td align="right" nowrap><strong>#LB_Referencia#:&nbsp;</strong>
            </td>
            <td nowrap><input name="Preferencia" type="text" id="Preferencia2" size="39" maxlength="255" tabindex="1"  value="<cfif modo NEQ "ALTA">#rsPagos.Preferencia#</cfif>">
            </td>
            <td align="right" nowrap><strong>#LB_Oficina#:&nbsp;</strong></td>
            <td nowrap>
			  </cfoutput>
              <select name="Ocodigo" id="Ocodigo" tabindex="1" style="width:215px">
                <cfoutput query="rsOficinas">
                  <option value="#Ocodigo#" <cfif modo NEQ "ALTA" and rsPagos.Ocodigo EQ rsOficinas.Ocodigo>selected</cfif>>#Odescripcion#</option>
                </cfoutput>
              </select>
			  <cfoutput>
            </td>
            <td align="right" nowrap><strong>#MSG_Detalle#:&nbsp;</strong></td>
            <td nowrap>
              <input name="DetalleLabel" type="text" id="DetalleLabel" style="text-align: right" 
			  value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(totaldetalle,'none')#<cfelse>0.00</cfif>" 
			  size="17" maxlength="18" tabindex="-1" class="cajasinborde" readonly>
            </td>
          </tr>
		<tr>
			<td align="right" nowrap><strong>M&eacute;todo de Pago: &nbsp;</strong></td>
			<td nowrap width="250px">
				<cfoutput>
					<select name="PMetPago" id="PMetPago" tabindex="1" style="width:250px">
	                  <option value="PUE" <cfif isdefined("rsPagos.PMetPago") AND #TRIM(rsPagos.PMetPago)# EQ "PUE">selected</cfif>>PUE - Pago en una sola exhibici&oacute;n</option>
	                  <option value="PPD" <cfif isdefined("rsPagos.PMetPago") AND #TRIM(rsPagos.PMetPago)#EQ "PPD">selected</cfif>>PPD - Pago en parcialidades o diferido</option>
	              </select>
				</cfoutput>
            </td>
		</tr>
		 <!---Eleccion de la cuenta Encabezado desde el Catalogo--->
          <tr><td align="right"><cfif UsarCatalogoCts><strong>#LB_Cuenta#:&nbsp;</strong></cfif></td> <td>
		    </cfoutput>
				<cfif UsarCatalogoCts>
					<select name="ID" id= "ID" tabindex="-1" <cfif UsaCtaBanco>disabled=true</cfif>>
						<cfoutput query="rsCatalogoCuentas">
							<option value="#ID#" 
								<cfif modo NEQ "ALTA" and rsPagos.ID EQ rsCatalogoCuentas.ID> selected="selected"</cfif>>
						  			#Descripcion_Cuenta#
							</option>
						</cfoutput>	
					</select>
				</cfif>	
		  </td><cfoutput>
          <td align="right" nowrap><strong>#LB_Moneda#:&nbsp;</strong></td>
            <td nowrap>
			  </cfoutput>
              
              <cfif modo NEQ "ALTA" and rsLineas.recordCount GT 0>
                <input type="hidden" id="Mcodigo" name="Mcodigo" value="<cfoutput>#rsPagos.Mcodigo#</cfoutput>">
                <cfoutput>#MonedaE#</cfoutput>
                <cfelse>
                	<span id='Contenedor_Moneda'>
                        <select name="Mcodigo" id="Mcodigo" tabindex="1" onChange="javascript: obtenerTC(this.form); ">
                          <cfoutput query="rsMonedas">
                            <option value="#Mcodigo#" 
                                <cfif modo NEQ "ALTA" and rsPagos.Mcodigo EQ rsMonedas.Mcodigo>selected<cfelseif modo EQ "ALTA" and rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo>selected</cfif>>#Mnombre# #Miso4217#</option>
                          </cfoutput>
                        </select>
                    </span>
              </cfif>
			  <cfoutput>
        </td>
            <td align="right" nowrap><strong>#LB_Disponible#:&nbsp;</strong></td>
            <td nowrap>
              <input name="DisponibleLabel" type="text" id="DisponibleLabel" style="text-align: right" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsAPagosCxCTotal.DisponibleAnticipos,'none')#<cfelse>0.00</cfif>" size="17" maxlength="18" tabindex="-1" class="cajasinborde" readonly>
            </td>
          </tr>
          <tr>
            <td align="right" nowrap rowspan="2" valign="top"><strong>#LB_Observaciones#:&nbsp;</strong></td>
            <td nowrap rowspan="2"><textarea cols="36" rows="3" name="Pobservaciones" tabindex="1" ><cfif modo NEQ "ALTA">#rsPagos.Pobservaciones#</cfif>
        </textarea>
            </td>
            <td align="right" nowrap><strong>#LB_Fecha#:&nbsp;</strong></td>
            <td nowrap>
              <cfif modo NEQ "ALTA">
                <cfset fecha= DateFormat(rsPagos.Pfecha,'dd/mm/yyyy')>
                <cfelse>
                <cfset fecha= DateFormat(Now(),'dd/mm/yyyy')>
              </cfif>
              <cf_sifcalendario name="Pfecha" id="Pfecha" tabindex="1" 
					onchange="obtenerTC(this.form);" onblur="obtenerTC(this.form);" value="#fecha#">
            </td>
          </tr>
          <tr>
            <td align="right" nowrap><strong>#LB_Tipo_de_Cambio#:&nbsp;</strong></td>
            <td nowrap> 
				<input name="Ptipocambio" type="text" id="Ptipocambio" style="text-align: right" tabindex="-1" size="20" maxlength="20" 
				onFocus="this.value=qf(this); this.select();" 
				onBlur="fm(this,4);"  
				onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
				value="<cfif modo NEQ "ALTA">#rsPagos.Ptipocambio#<cfelse>0.00</cfif>" 
				onChange="javascript:validatc(this.form); if (this.form.DPmontodoc != null) validaSaldo(this.form);" 
				<cfif modo NEQ "ALTA" and rsLineas.recordCount GT 0>disabled</cfif>>
			</td>
          </tr>
          <tr>
            <td colspan="6" align="center" nowrap>
              <cfif modo EQ "ALTA">
                <br/>
                <font size="2">
                	<input name="AgregarE" 		type="submit"  value="#BTN_Agregar#" 	 class="btnGuardar" 	tabindex="1" onClick="javascript:setBtn(this);">
                	<input name="Regresar" 		type="button"  value="#LB_ListaCobro#" 	 class="btnAnterior"	tabindex="1" onClick="javascript:Lista();">
                </font>
                <cfelse>
                <cfif modo NEQ "ALTA" and rsAPagosCxCTotal.DisponibleAnticipos NEQ 0>
                  	<input name="btn_selMasiva" type="button"	value="#LB_SelMas#" 	 class="btnNormal" 		tabindex="1" onClick="javascript: funcPantallaSeleccion();">
                </cfif>
                <cfif isdefined('rsPagos.Pcodigo') &&  FindNoCase('CRC-', rsPagos.Pcodigo) eq 0>
                    <input name="CambiarE" 		type="submit" 	value="#BTN_ModEnc#" class="btnGuardar" 	tabindex="1" onClick="javascript: setBtn(this); habilitarVE(); deshabilitarVD()">
                    <input name="Generar" 		type="submit" 	value="#BTN_GenAnt#" 	 class="btnNormal" 		tabindex="1" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name);">
                </cfif>
                	<input name="F5" 			type="hidden" 	value="0">
                	<input name="ListaE"		type="button"  	value="#LB_ListaCobro#"  class="btnAnterior" 	tabindex="1" onClick="javascript:Lista();">
                	<input name="Nuevo"			type="button"  	value="#LB_btnNuevo#" 	 class="btnNuevo" 		tabindex="1" onClick="javascript: NuevoPago();">
				<cfset MSG_EliminaCobro = t.Translate('MSG_EliminaCobro','¿Realmente desea borrar este Cobro?')>	
				<cfif rsPagos.Seleccionado eq 0>
                    <cfif isdefined('rsPagos.Pcodigo') &&  FindNoCase('CRC-', rsPagos.Pcodigo) eq 0>
					    <input name="BorrarE" 		type="submit" 	value="#BTN_BorrarCobro#" 		 class="btnEliminar" 	tabindex="1" onClick="javascript: setBtn(this); deshabilitarValidacion(this.name); return confirm('#MSG_EliminaCobro#')">
                    </cfif>
                </cfif>		
				&nbsp;
				<cfif rsLineas.RecordCount GT 0>
				  	<input name="Aplicar" 		type="submit" 	value="#BTN_Aplicar#" 		class="btnAplicar" 		tabindex="1"  onClick="javascript:setBtn(this); deshabilitarValidacion(this.name);">
				  	<input name="Ver" 			type="submit" 	value="#BTN_Ver#"			class="btnAplicar" 		tabindex="1"  onClick="javascript:setBtn(this); deshabilitarValidacion(this.name);">
				</cfif>
		    </td>
          </tr>
<cfset MSG_DocGenPuntoVta = t.Translate('MSG_DocGenPuntoVta','Documento Generado desde Punto de Venta. No se puede eliminar.')>
		  <cfif rsPagos.Seleccionado eq 1>
			<tr>
				<td colspan="6" align="center" class="auxiliar"  >
					<cf_translate key="documento_auxiliar">#MSG_DocGenPuntoVta#</cf_translate>
				</td>
			</tr>
		  </cfif>
     </cfif>
		<style type="text/css" >
			.auxiliar{ 
				font-size:smaller;
				color:##FF0033;
				font-weight:bold;
			}
		</style>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
	<tr>
		<td> 
          	<input name="Ddocumento" 		type="hidden" id="Ddocumento" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.Ddocumento#</cfif>">
			<input name="DPid" 				type="hidden" id="DPid" 			value="<cfif modoDet NEQ "ALTA">#rsDetalle.DPid#</cfif>">
			<input name="KDoc_CCTcodigo" 	type="hidden" id="KDoc_CCTcodigo" 	value="<cfif modoDet NEQ "ALTA">#rsDetalle.Doc_CCTcodigo#</cfif>">
			<input name="KDdocumento" 		type="hidden" id="KDdocumento" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.Ddocumento#</cfif>">
			<input name="CCTcodigod" 		type="hidden" id="CCTcodigod" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.CCTcodigo#</cfif>">
			<input name="PPnumero" 			type="hidden" id="PPnumero" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.PPnumero#</cfif>">
			<input name="Mcodigod" 			type="hidden" id="Mcodigod" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.Mcodigo#</cfif>">
			<input name="Ccuentad" 			type="hidden" id="Ccuentad" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.Ccuenta#</cfif	>">
			<input name="montoret" 			type="hidden" id="montoret" 		value="<cfif modoDet NEQ "ALTA">#rsDetalle.DPmontoretdoc#</cfif>">
			<input name="timestampd" 		type="hidden" id="timestampd" 		value="<cfif modoDet NEQ "ALTA">#ts2#</cfif>">
			<input name="FC" 				type="hidden" id="FC" 				value="<cfif modoDet NEQ "ALTA" and rsDetalle.DPtipocambio EQ 1>iguales<cfelseif modoDet NEQ "ALTA" and rsDetalle.DPtipocambio EQ rsPagos.Ptipocambio>encabezado<cfelse>calculado</cfif>">
			<input name="ta" 				type="hidden" id="ta" 				value=" <cfif modo NEQ "ALTA">#rsAPagosCxCTotal.TotalAnticipos#</cfif>">
			<input name="tl" type="hidden" id="tl" value="<cfif isdefined("rstotalcubierto")>#tl#</cfif>">
			<input name="datos" 			type="hidden" id="datos" 			value="">
			<input name="Anticipo" 			type="hidden" id="Anticipo" 		value="0">
          	<table border="0" width="100%" cellpadding="0 " cellspacing="0">
            <cfset LB_DetCobro = t.Translate('LB_DetCobro','Detalle de Cobro')>
            	<tr><td colspan="4" class="tituloAlterno" nowrap>#LB_DetCobro#</td></tr>
				<tr><td colspan="4">&nbsp;</td></tr>
            	<tr> 
					<td width="20%" align="right" nowrap><strong>#LB_Documento#:&nbsp;</strong></td>
					<td width="30%" nowrap> 
						<cfif modoDet NEQ "ALTA">
							<cfif isdefined ("form.GSNid") and form.GSNid GT 0>
								<cf_sifDocsPagoCxC query="#rsDocsPagoCxC#" form="form1" tabindex="1">
							<cfelse>
								<cf_sifDocsPagoCxC query="#rsDocsPagoCxC#" form="form1" tabindex="1">
							</cfif>
                        <cfelse>						  
                         	<cfif isdefined ("form.GSNid") and form.GSNid EQ 0>
                                <cf_sifDocsPagoCxC form="form1" tabindex="1">
                            <cfelse>
                                <cf_sifDocsPagoCxC form="form1" tabindex="1">
                          	</cfif>
						</cfif>
					</td>
					<td width="25%" align="right" nowrap><strong>#LB_MontoMonedaDocto#:&nbsp;</strong></td>
					<td width="25%" nowrap> 
							<input name="DPmontodoc" type="text" id="DPmontodoc" size="20" maxlength="18" tabindex="2" style="text-align: right"  
							onfocus="this.value=qf(this); this.select();" 
							onblur="javascript: fm(this,4); validaSaldo(this.form);"
							onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}javascript:calcularMontoAPagar(this.value);"
							onChange="javascript:validaSaldo(this.form);" 
							value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsDetalle.DPmontodoc,'none')#<cfelse>0.00</cfif>"
							<cfif modoDet NEQ "ALTA" and (rsDetalle.DPtipocambio EQ 1 or rsDetalle.DPtipocambio EQ rsPagos.Ptipocambio)>disabled<cfelseif modoDet EQ "ALTA">disabled</cfif>>
					</td>
				</tr>
     			<tr> 
<cfset LB_Saldo 		= t.Translate('LB_Saldo','Saldo')>
                
					<td align="right" nowrap><strong>#LB_Saldo#:&nbsp;</strong> 
						<input name="Dsaldo" type="hidden" id="Dsaldo" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#LSCurrencyFormat(rsDocumento.Dsaldo,'none')#<cfelse>0.00</cfif>">
					</td>
					<td nowrap> 
						<input name="DsaldoLabel" type="text" id="DsaldoLabel" class="cajasinborde" size="40" maxlength="18" 
							tabindex="-1" 
							style="text-align: right"  
							onfocus="this.value=qf(this); this.select();" 
							onblur="fm(this,2);"  
							onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#LSCurrencyFormat(rsDocumento.Dsaldo,'none')#<cfelse>0.00</cfif>" readonly>
					</td>
	<cfset LB_RetMonedaDocto = t.Translate('LB_RetMonedaDocto','Retención en Moneda del Documento')>
					<td align="right" nowrap><strong>#LB_RetMonedaDocto#:&nbsp;</strong></td>
					<td nowrap> 
						<input name="DPmontoretdoc" type="text" id="DPmontoretdoc" size="20" maxlength="18" tabindex="2" style="text-align: right"  onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2); validaSaldo(this.form);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#LSCurrencyFormat(rsDetalle.DPmontoretdoc,'none')#<cfelse>0.00</cfif>" onChange="javascript:validaSaldo(this.form);" <cfif modo NEQ "ALTA" and modoDet NEQ "ALTA" and rsDetalle.DPmontoretdoc EQ 0>disabled<cfelseif modo NEQ "ALTA" and modoDet EQ "ALTA">disabled</cfif>>
					</td>
				</tr>
            	<tr> 
					<td align="right" nowrap><strong>#LB_Cuenta#:&nbsp;</strong></td>
					<td nowrap> 
						<input name="CcuentadLabel" type="text" id="CcuentadLabel" class="cajasinborde" style="text-align: right" 
							size="40" maxlength="40" tabindex="-1" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#rsCuentaD.Cdescripcion#</cfif>" readonly>
					</td>
					<td align="right" nowrap><strong>#LB_MontoMonedaCobro#:&nbsp;</strong></td>
					<td nowrap> 
					 <input name="DPtotal_anterior" type="hidden" id="DPtotal_anterior" value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#rsDetalle.DPtotal#<cfelse>0.00</cfif>"> 
						<input name="DPtotal" type="text" id="DPtotal" size="20" maxlength="18" tabindex="2" style="text-align: right"  
							onfocus="this.value=qf(this); this.select();" 
							onblur="javascript: fm(this,2); validaSaldo(this.form);"  
							onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							onChange="javascript:validaSaldo(this.form);" 
							value="<cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">#LSCurrencyFormat(rsDetalle.DPtotal,'none')#<cfelse>0.00</cfif>" <cfif modo NEQ "ALTA" and modoDet EQ "ALTA">disabled</cfif>>
					</td>
				</tr>
				<!--- 29082018 - MEGS: SE MUESTRA EL TIPO DE CAMBIO SIEMPRE Y CUANDO EL COBRO SEA EN MONEDA LOCAL Y
				                       EL DOCUMENTO RELACIONADO ES EN MONEDA EXTRANJERA --->
				<cfif isDefined("rsMonedaLocal") AND isDefined("rsDetalle") AND rsMonedaLocal.RecordCount GT 0 AND rsMonedaLocal.Mcodigo NEQ rsDetalle.Mcodigo>
					<tr id="idTrTC">
				<cfelse>
					<tr id="idTrTC" style="display:none">
				</cfif>
					<td align="right" nowrap><strong>Tipo de Cambio:&nbsp;</strong></td>
					<td>
						<input type="text" style="text-align: right" id="TipoCambioMonExt" name="TipoCambioMonExt"
						  size="20" maxlength="18" tabindex="1"
						  value="<cfif isDefined("rsDetalle.DPTipoCambioME")>#rsDetalle.DPTipoCambioME#</cfif>"
						  onFocus="this.value=qf(this); this.select();"
						  onBlur="fm(this,4);"
						  onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}javascript:calcularMontoAPagar(this.value);"></td>
					<td colspan="2">&nbsp;</td>
					<!--- td align="right" nowrap><strong>Monto en Moneda Extrajera:&nbsp;</strong></td>
					<td>
						<input type="text" style="text-align: right" id="montoMonExtranjera" name="montoMonExtranjera"
						  size="20" maxlength="18" tabindex="-1"
						  value="<cfif isDefined("rsDetalle.DPMontoMonExtran")>#rsDetalle.DPMontoMonExtran#</cfif>"
						  onFocus="this.value=qf(this); this.select();"
						  onBlur="fm(this,4);"
						  onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}javascript:calcularMontoAPagar(this.value);"></td> --->
				</tr>
				<tr> 
					<td colspan="4" align="center" nowrap> <br/>
						<cfif modoDet EQ "ALTA">
						  		<input name="AgregarD" type="submit" value="#BTN_Agregar#" 		 class="btnGuardar"  tabindex="2" onClick="javascript:setBtn(this); habilitarValidacion();">
							<cfif rsLineas.recordCount GT 0>
							  	<input name="BorrarDD" type="submit" value="#BTN_BorrarDet#" class="btnEliminar" tabindex="2" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name); return confirm('¿#MSG_BorrarDet#?')">
							</cfif>
						<cfelse>
						  		<input name="CambiarD" type="submit" value="Modificar" 		 class="btnGuardar"  tabindex="2" onClick="javascript: setBtn(this); habilitarValidacion();">
						  		<input name="BorrarD"  type="submit" value="#BTN_BorrarLinea#" 	 class="btnEliminar" tabindex="2" onClick="javascript:setBtn(this); deshabilitarValidacion(this.name); return confirm('¿#MSG_BorrarLinea#?')">
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
          	</table>
		</td>
	</tr>
	</cfif>
  </table>
	<!--- Navegacion para la lista de Pagos (principal) --->
	<input type="hidden" name="pageNum_rsLista" value="<cfif isdefined('form.PageNum_rsLista') and len(trim(form.PageNum_rsLista))>#form.PageNum_rsLista#<cfelse>1</cfif>" />
	<input type="hidden" name="fecha" 			value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >#form.fecha#<cfelse>-1</cfif>" />
	<input type="hidden" name="transaccion" 	value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >#form.transaccion#<cfelse>-1</cfif>" />	
	<input type="hidden" name="usuario" 		value="<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >#form.usuario#<cfelse>-1</cfif>" />	
	<input type="hidden" name="moneda" 			value="<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >#form.moneda#<cfelse>-1</cfif>" />	
</form>
</cfoutput>
<!--- Lineas del documento --->
<cfif isdefined("KCCTcodigo") and Len(Trim(KCCTcodigo)) NEQ 0>
	<cfif rsLineas.recordCount GT 0>
		<!--- registro seleccionado --->
		<cfif isDefined("KDoc_CCTcodigo") and Len(Trim(KDoc_CCTcodigo)) GT 0
		and isDefined("KDdocumento") and Len(Trim(KDdocumento)) GT 0 >
			<cfset seleccionado1 = Trim(KDoc_CCTcodigo & '|' & KDdocumento) ><cfelse><cfset seleccionado1 = "" ></cfif>
	<cfset LB_MonedaDocto = t.Translate('LB_MonedaDocto','Moneda del Documento')>
	<cfset LB_FechaDocto = t.Translate('LB_FechaDocto','Fecha del Documento')>
	<cfset LB_MontoDocto = t.Translate('LB_MontoDocto','Monto del Documento')>
	<cfset LB_MontoCobro = t.Translate('LB_MontoDocto','Monto del Cobro')>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
			<tr height="15" bgcolor="#E2E2E2" class="subTitulo" >
			  <td width="3%" align="center" nowrap >&nbsp;</td>
				<cfoutput><td width="10%" align="center" nowrap>#LB_Transaccion#</td></cfoutput>
				<cfoutput><td width="30%" nowrap>&nbsp;#LB_Documento# 
				</td></cfoutput>
				<cfoutput><td align="center" width="15%" nowrap> 
				  #LB_MonedaDocto# </td></cfoutput>
				<cfoutput><td  align="center" width="15%" nowrap> 
				  #LB_FechaDocto# </td></cfoutput>
				<cfoutput><td align="right" width="15%" nowrap> 
				  #LB_MontoDocto# </td></cfoutput>
				<cfoutput><td  align="right" width="15%" nowrap> 
				  #LB_MontoCobro# </td></cfoutput>
			</tr>
			<cfoutput query="rsLineas">
				<tr class="<cfif #rsLineas.CurrentRow# MOD 2>listaPar<cfelse>listaNon</cfif>"
					style="cursor: pointer;"
					onClick="javascript:Editar('#DPid#|#IDpago#|#IDLinea#');"
					onMouseOver="javascript: style.color = 'red'" 
					onMouseOut="javascript: style.color = 'black'"
					height="15">
					<td height="20"align="center" nowrap>
						<cfif modoDet NEQ 'ALTA' and Trim(rsLineas.IDlinea) EQ seleccionado1>
							<img src="/cfmx/sif/imagenes/addressGo.gif" height="12" width="12" border="0">
						</cfif>
					</td>
					<td align="center" nowrap>#Doc_CCTcodigo#</td>
					<td nowrap>#Ddocumento#</td>
					<td align="center" nowrap>#Moneda#</td>
					<td align="center" nowrap>#DateFormat(Dfecha,'dd/mm/yyyy')#</a></td>
					<td align="right" nowrap>#LSCurrencyFormat(DPmontodoc,'none')#</td>
					<td align="right" nowrap>#LSCurrencyFormat(DPtotal,'none')#</td>
				</tr>
			</cfoutput>
			<cfif isdefined("totaldetalle")>
				<tr>
					<td class="topline" colspan="7" align="right">
					<b>Total: </b> <cfoutput>#LSCurrencyFormat(totaldetalle, 'none')#</cfoutput>
					</td>
				</tr>
			</cfif>
		</table>
	<cfelse>
        <cfset MSG_DoctoSinLinea = t.Translate('MSG_DoctoSinLinea','El documento no tiene líneas de detalle')>
		<p align="center" class="listaCorte"><cfoutput>#MSG_DoctoSinLinea#</cfoutput></p>
	</cfif>
</cfif> 

<cffunction name="fnleerconsultas" access="private" output="no" returntype="any">
	<!---Monedas--->
    <cfquery name="rsMonedas" datasource="#Session.DSN#">
        select 	Mcodigo, 
				Mnombre,
                Miso4217
        	from Monedas 
        where Ecodigo = #Session.Ecodigo#
        	order by Mcodigo
    </cfquery> 
    <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
        select 	Mcodigo 
        	from Empresas
        where Ecodigo =  #Session.Ecodigo# 
    </cfquery>
    <!---Transaccion--->
	<cf_dbfunction name="concat" args="rtrim(ltrim(CCTcodigo,'-',CCTdescripcion))" returnvariable="LvarConcat">
	<cf_dbfunction name="sPart" args="rtrim(ltrim(CCTdescripcion))+1+10" delimiters="+" returnvariable="LvarsPart">
    <cfquery name="rsTransacciones" datasource="#Session.DSN#">
        select CCTcodigo, CCTdescripcion , 
            case when   
                <cf_dbfunction name="length" args="#LvarConcat#"> > 10  then
                <cf_dbfunction name="concat" args="CCTcodigo+'-'+#LvarsPart#" delimiters="+">	
            else 
                <cf_dbfunction name="concat" args="rtrim(ltrim(CCTcodigo,'-',CCTdescripcion))"> 
            end as Transaccion
        from CCTransacciones  
        where Ecodigo =  #Session.Ecodigo#  
        and CCTtipo = 'C' 
        and coalesce(CCTpago,0) = 1
        order by CCTcodigo 
    </cfquery>
    <!---Oficina--->
    <cfquery name="rsOficinas" datasource="#Session.DSN#">
        select Ocodigo, Odescripcion
        from Oficinas where Ecodigo =  #Session.Ecodigo#  
        order by Ocodigo 
    </cfquery>
    <!---Modo--->
    <cfif isdefined("Form.Cambio")>
        <cfset modo="CAMBIO">
    <cfelse>
        <cfif not isdefined("Form.modo")>
            <cfset modo="ALTA">
        <cfelseif Form.modo EQ "CAMBIO">
            <cfset modo="CAMBIO">
        <cfelse>
            <cfset modo="ALTA">
        </cfif>
    </cfif>
    <cfif isdefined("Form.modoDet") and len(trim(form.modoDet)) eq 0>
        <cfset modoDet = "ALTA">
    </cfif>
    <cfif not isdefined("Form.modoDet")>
        <cfset modoDet = "ALTA">
    </cfif>
    <cfif isDefined("Form.NuevoE")>
        <cfset modo = "ALTA">
        <cfset modoDet = "ALTA">
    <cfelseif isDefined("Form.datos") and Form.datos NEQ "">
        <cfset modo = "CAMBIO">
        <cfset modoDet = "ALTA">
    </cfif>
    <!---Datos del Pago--->
    <cfif not isDefined("Form.NuevoE")>
        <cfif isDefined("Form.datos") and Form.datos NEQ "">
            <cfset arreglo = ListToArray(Form.datos,"|")>
            <cfset sizeArreglo = ArrayLen(arreglo)>
            <cfif sizeArreglo EQ 5>
                <cfset DPid =  Rtrim(arreglo[1])>
                <cfset KCCTcodigo = Rtrim(arreglo[2])>
                <cfset KPcodigo = Rtrim(arreglo[3])>
                <cfset KDoc_CCTcodigo = Rtrim(arreglo[4])>
                <cfset KDdocumento = Rtrim(arreglo[5])>
                <cfset modoDet = "CAMBIO">
            <cfelse>
                <cfset KCCTcodigo = Rtrim(arreglo[1])>
                <cfset KPcodigo = Rtrim(arreglo[2])>
            </cfif>
        <cfelseif isdefined("Form.KCCTcodigo") and isdefined("Form.KPcodigo")>
            <cfset KCCTcodigo = Rtrim(Form.KCCTcodigo)>
            <cfset KPcodigo = Rtrim(Form.KPcodigo)>
            <cfif isDefined("Form.KDoc_CCTcodigo") and isDefined("Form.KDdocumento")>
                <cfset KDoc_CCTcodigo = Rtrim(Form.KDoc_CCTcodigo)>
                <cfset KDdocumento = Rtrim(Form.KDdocumento)>
            </cfif>
        </cfif>
    </cfif>
    <!---Cuenta Encabezado, si hay datos en "Catalogo deposito transito" lo usa, sino usa el "paramentro configurable"--->
    <cfquery name="rsCatalogoCuentas" datasource="#Session.DSN#">
    	select a.Descripcion_Cuenta, ID,  b.Ccuenta, b.CFcuenta  
        from CuentasCxC  a
        	inner join CFinanciera b
            	on a.CFcuenta = b.CFcuenta 
        where a.Ecodigo = #Session.Ecodigo#
        	and a.CBid is null
        order by a.ID
     </cfquery>    
  
     <cfif rsCatalogoCuentas.RecordCount  GT 0>
		<cfset UsarCatalogoCts = true>
        <!--- Verifica en modo cambio si la cuenta usada es Bancaria --->
        <cfif modo NEQ "ALTA">
        	<cfquery datasource="#session.dsn#" name="rsCtaBanco">
                select cb.Ccuenta
                from CuentasBancos cb
                    inner join Pagos p
                    on cb.Ecodigo = p.Ecodigo and cb.CBid = coalesce(p.CBid,-1)
                    inner join CuentasCxC cc
                    on cc.CBid = cb.CBid
                where cb.Ecodigo = #session.Ecodigo#
                    and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
                    and p.CBid is not null
            </cfquery>
            <cfif rsCtaBanco.recordcount GT 0>
            	<cfset UsaCtaBanco = true>
            	<cfset CcuentaEncabezado = rsCtaBanco.Ccuenta>
            <cfelse>
                <cfquery name="rsCatalogo" datasource="#Session.DSN#">
                    select b.Ccuenta
                    from CuentasCxC  a
                        inner join CFinanciera b
                            on a.CFcuenta = b.CFcuenta 
                            and a.Ecodigo = b.Ecodigo
                        inner join Pagos c
                            on c.ID = a.ID
                            and c.Ecodigo = a.Ecodigo	
                        where  a.Ecodigo =  #Session.Ecodigo#  
                        and c.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KCCTcodigo#"> 
                        and c.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KPcodigo#"> 
                </cfquery>
                <cfset UsaCtaBanco = false>
            	<cfset CcuentaEncabezado = rsCatalogo.Ccuenta>
            </cfif>
        <cfelse>
        	<cfset UsaCtaBanco = false>
        	<cfset CcuentaEncabezado = rsCatalogoCuentas.Ccuenta>
        </cfif>
     <cfelse>
            <cfquery name="rsParametroCcuentaTransito" datasource="#session.DSN#">
                select Pvalor, Pdescripcion
                from Parametros 
                where Pcodigo = 650
                and Ecodigo =  #Session.Ecodigo# 
            </cfquery>
            <cfif rsParametroCcuentaTransito.Pvalor eq ''>
        <cfset ERR_CuentaDepTran = t.Translate('ERR_CuentaDepTran','La Cuenta Depósitos en Tránsito no está defnida')>
                <cf_errorCode	code = "50159" msg = "#ERR_CuentaDepTran#.">
            </cfif>
        <cfset UsarCatalogoCts = false>
        <cfset UsaCtaBanco = false><!---SML 22/07/2014 Para definir la variable y no marque error al seleccionar el menu de cobro y al seleccionar el cobro ---> 
        <cfset CcuentaEncabezado = rsParametroCcuentaTransito.Pvalor>       
     </cfif>
    <cfif modo NEQ "ALTA">
	<cf_dbfunction name="concat" args="rtrim(a.CCTcodigo)+'|'+rtrim(a.Pcodigo)"  returnvariable="IDPago" delimiters= "+">
        <cfquery name="rsPagos" datasource="#Session.DSN#">
            select 	a.CCTcodigo, rtrim(a.Pcodigo) as Pcodigo, 
					a.Mcodigo, 
					a.Ptipocambio, a.Seleccionado, 
                   	a.Ccuenta as Ccuenta, 
					a.Ptotal, 
					a.Pfecha as Pfecha, 
                   	a.Preferencia, a.Pobservaciones, 
					#PreserveSingleQuotes(IDPago)# as IDPago, 
					a.Ocodigo, a.SNcodigo, a.GSNid, 
					a.ts_rversion, 
                   	b.Cformato, b.Cdescripcion,
                   	ID, CBid,
					PMetPago
           from Pagos a, CContables b
            where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KCCTcodigo#"> 
            and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KPcodigo#"> 
            and a.Ecodigo =  #Session.Ecodigo#  
            and a.Ecodigo = b.Ecodigo
            and a.Ccuenta = b.Ccuenta
        </cfquery>
    
        <cfif isdefined("rsPagos")	and rsPagos.recordcount eq 1>
            <cfquery name="rsSocioNegocios" datasource="#session.DSN#">
                select 
                    SNnombre, 
                    SNcodigo, 
                    SNid, 
                    SNnumero
                from SNegocios
                    where Ecodigo =  #Session.Ecodigo# 
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagos.SNcodigo#">
            </cfquery>
        </cfif>
        <cfset ts = "">
        <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsPagos.ts_rversion#" returnvariable="ts">
        </cfinvoke>
        <cfquery name="nombreMoneda" datasource="#Session.DSN#">
            select Mnombre 
            from Monedas 
            where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagos.Mcodigo#">
        </cfquery>
        <cfset MonedaE = nombreMoneda.Mnombre>
        <cfquery name="rsLineas" datasource="#Session.DSN#">
            select 	DPid,
					<cf_dbfunction name="concat" args="rtrim(a.CCTcodigo),'|',rtrim(a.Pcodigo)" > as IDpago, 
					<cf_dbfunction name="concat" args="rtrim(a.Doc_CCTcodigo),'|',rtrim(a.Ddocumento)" > as IDLinea, 
                   	rtrim(a.Pcodigo) as Pcodigo, a.CCTcodigo, a.Doc_CCTcodigo, a.Ddocumento, 
                   	e.Mnombre as Moneda, a.DPmontodoc, a.DPtotal, 
					d.Dfecha
            from DPagos a, CCTransacciones c, Documentos d, Monedas e
            where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KCCTcodigo#"> 
              and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KPcodigo#"> 
              and a.Ecodigo =  #Session.Ecodigo#  
              and a.Ecodigo = d.Ecodigo 
              and a.Ddocumento = d.Ddocumento
              and a.Doc_CCTcodigo = d.CCTcodigo
              and d.Ecodigo = c.Ecodigo
              and d.CCTcodigo = c.CCTcodigo
              and d.Mcodigo = e.Mcodigo
              and d.Ecodigo = e.Ecodigo
              and c.CCTtipo = 'D'
              and coalesce(c.CCTpago, 0) != 1
            order by d.Dfecha, d.Mcodigo, a.DPtotal desc, a.Doc_CCTcodigo, a.Ddocumento
        </cfquery>
         <cfset Moneda = rsLineas.Moneda><!--- Nuevo GAFH --->
       
        <cfquery name="rstotalcubierto" datasource="#Session.DSN#">
            select coalesce(sum(DPtotal),0.00) as tl
            from DPagos 
            where Ecodigo =  #Session.Ecodigo# 
            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KCCTcodigo#"> 
            and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KPcodigo#"> 
            <cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
			and (rtrim(Doc_CCTcodigo) != <cfqueryparam cfsqltype="cf_sql_char" value="#KCCTcodigo#"> 
			or rtrim(Ddocumento) != <cfqueryparam cfsqltype="cf_sql_char" value="#KDdocumento#">)
            </cfif>
        </cfquery>
        <cfset tl = rstotalcubierto.tl>
        <cfquery name="rstotaldetalle" datasource="#Session.DSN#">
            select coalesce(sum(round(DPtotal, 2)),0.00) as total
            from DPagos 
            where Ecodigo =  #Session.Ecodigo# 
            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KCCTcodigo#"> 
            and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KPcodigo#"> 
        </cfquery>
        <cfset totaldetalle = rstotaldetalle.total>
    </cfif>
    <cfif modo NEQ "ALTA" and modoDet NEQ "ALTA">
        <cfquery name="rsDetalle" datasource="#Session.DSN#">
            select 	DPid,rtrim(Pcodigo) as Pcodigo, rtrim(CCTcodigo) as CCTcodigo, 
					rtrim(Doc_CCTcodigo) as Doc_CCTcodigo, rtrim(Ddocumento) as Ddocumento,
                    Mcodigo, 
					Ccuenta, 
					DPtipocambio,DPtotal, DPmontodoc, DPmontoretdoc, ts_rversion, PPnumero,
					DPTipoCambioME
            from DPagos 
            where Ecodigo =  #Session.Ecodigo# 
              and DPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DPid#">
        </cfquery>
        <cfset ts2 = "">
        <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDetalle.ts_rversion#" returnvariable="ts2">
        </cfinvoke>
		<cf_dbfunction name="concat" args="a.CCTcodigo,'-',a.Ddocumento,'-',b.Mnombre" returnvariable= "doc">
        <cfquery name="rsDocumento" datasource="#Session.DSN#">
            select #PreserveSingleQuotes(doc)#  as doc,
                   a.Dsaldo, b.Mcodigo, a.CCTcodigo 
            from Documentos a, Monedas b
            where a.Ecodigo =  #Session.Ecodigo#  
            and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalle.Ddocumento#"> 
            and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalle.Doc_CCTcodigo#"> 
            and a.Mcodigo = b.Mcodigo 
        </cfquery>
        <cfquery name="rsCuenta" datasource="#Session.DSN#">
            select Cdescripcion
            from CContables 
            where Ecodigo =  #Session.Ecodigo# 
            and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CcuentaEncabezado#"> 
        </cfquery>
        <cfset cuenta = rsCuenta.Cdescripcion> 
        <cfquery name="rsCuentaD" datasource="#Session.DSN#">
            select Cdescripcion 
            from CContables 
            where Ecodigo =  #Session.Ecodigo# 
            and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.Ccuenta#"> 
        </cfquery>
        <cfset cuentaD = rsCuentaD.Cdescripcion>
        <cfquery name="rsDocsPagoCxC" datasource="#session.DSN#">	
            select <cf_dbfunction name="concat" args="distinct (c.Doc_CCTcodigo+'-'+rtrim(c.Ddocumento)+'-'+a.Mnombre)" delimiters= '+'>  as DTM,
                rtrim(c.Ddocumento) as Documento,
                b.SNcodigo as SNcodigo2,
                c.Doc_CCTcodigo as CCTcodigoConlis
            from Pagos b
                inner join DPagos c
                    on c.Ecodigo =  b.Ecodigo
                    and c.CCTcodigo = b.CCTcodigo
                    and c.Pcodigo = b.Pcodigo 
                inner join Monedas a
                    on a.Ecodigo = c.Ecodigo
                    and a.Mcodigo = c.Mcodigo
            where c.Ecodigo =  #Session.Ecodigo# 
                and c.Doc_CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KDoc_CCTcodigo#">
                and c.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#KPcodigo#">
                and c.Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#KDdocumento#">
        </cfquery>
    </cfif>
    <cfquery name="rsCuentaBanco" datasource="#session.DSN#">
        select 
        	cb.CBcodigo, 
            cb.CBid, 
            cb.Mcodigo, 
            m.Miso4217
        from CuentasBancos cb
        	inner join CuentasCxC cc
            on cc.CBid = cb.CBid
            inner join Monedas m
            on m.Mcodigo = cb.Mcodigo
        where cb.Ecodigo = #session.Ecodigo#
        	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        order by cb.CBcodigo
    </cfquery> 
</cffunction>