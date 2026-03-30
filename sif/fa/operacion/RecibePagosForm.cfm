<cfset modo="CAMBIO">


<cfquery datasource="#session.DSN#" name="rsForm">
	select VentaID, nombre_cliente, cedula_cliente, moneda, prima , 
		total_productos, cheque_Bid, tipo_tarjeta, Ocodigo, tipo_compra,
		( select coalesce ( sum (prima_minima_total) , 0)
			from VentaD
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and VentaID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
		 ) as prima_minima ,
		( select max ( Icodigo )
			from VentaD
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and VentaID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
		 ) as Icodigo
	from VentaE
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and VentaID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
</cfquery>
	
	<!--- Cajas asignadas al usuario --->
	<cfquery name="rsCajasUsuario" datasource="#Session.DSN#">
		select a.FCid, b.FCcodigo, b.FCdesc, b.Ocodigo
		from UsuariosCaja a, FCajas b
		where a.EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Ocodigo#">
			and a.FCid = b.FCid
	</cfquery>
	<!--- Impuestos --->
	<cfquery name="rsImpuestos" datasource="#Session.DSN#">
		select Icodigo, Idescripcion, Iporcentaje from Impuestos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Idescripcion                                 
	</cfquery>
	<!--- Departamentos --->
	<cfquery name="rsDepartamentos" datasource="#session.dsn#">
		select Dcodigo, Ddescripcion
		from Departamentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
	<!--- Almacenes --->
	<cfquery name="rsAlmacenes" datasource="#session.dsn#">
		select Aid, Bdescripcion
		from Almacen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Ocodigo#">
	</cfquery>
	<!--- Transacciones (de CxC) para una caja --->
	<cfquery name="rsTiposTransaccion" datasource="#Session.DSN#">
		select a.FCid, a.CCTcodigo, b.CCTdescripcion, isnull(convert(varchar,a.Tid),'') as Tid
		from TipoTransaccionCaja a, CCTransacciones b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ecodigo = b.Ecodigo 
			and a.CCTcodigo = b.CCTcodigo
	</cfquery>
	
	
	
<cfquery datasource="#session.DSN#" name="rsmonedas">
	select Miso4217, Mnombre
	from Monedas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by Mnombre
</cfquery>
<cfquery datasource="aspsecure" name="rsTipoTarjeta">
	select tc_tipo, nombre_tipo_tarjeta, mascara, BMUsucodigo, BMfechamod
	from TipoTarjeta
</cfquery>
<cfquery datasource="#session.DSN#" name="rsBancos">
	select Bid  ,Ecodigo ,Bdescripcion ,Bdireccion  ,Btelefon  ,Bfax ,Bemail ,Iaba ,ts_rversion
	from Bancos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by Bdescripcion
</cfquery> 
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	function valida_rango( _this,dec ){
    	var numero = new Number(qf(_this.value));
		
		if (numero == 0 && _this.value != ''){
			alert('El Rango no puede ser 0');
			_this.value = '';
			_this.focus();
			return
		}
		
		if( _this.value != '' ){
			fm(_this,dec);
		}
	}
	
	function ValidaPrima( _this){
    	var Prima = new Number(qf(_this.value));
		var TotalPagar = new Number(qf(document.form1.total_productos.value));
		//alert(Prima);alert(TotalPagar);		
		if (Prima != 0 && TotalPagar != 0 && Prima > TotalPagar ){
			alert('La Prima no puede ser mayor que el total a pagar');
			_this.value = '';
			_this.focus();
			return false
		}
		
		if( _this.value != '' ){
			fm(_this,2);
		}
	}

	function validar(){
		if (document.form1.cheque_numero.disabled != true){
			var cheque = new Number(qf(document.form1.cheque_numero.value));
			if (cheque == 0){
				alert('El numero de cheque no puede estar en blanco');
				document.form1.cheque_numero.focus();
				return false
			}
		}
		document.form1.monto_recibido.disabled = false;
		document.form1.monto_recibido.value = qf(document.form1.monto_recibido.value);
	}
	
	function Habilitar(_this){
	var campo = new Number(_this.value);
	//alert(campo);
		if (campo == 1) {
			document.form1.total_productos.disabled = false;
			document.form1.monto_recibido.value = document.form1.total_productos.value;
			document.form1.monto_recibido.disabled = true;
			document.form1.total_productos.disabled = true;
			document.form1.radRep.checked = true;
			document.form1.cheque_numero.disabled = true;
			document.form1.cheque_cuenta.disabled = true;
			document.form1.Bid.disabled = true;
			document.form1.Autoriza.disabled = true;
			document.form1.num_tarjeta.disabled = true;
			document.form1.tipo_tarjeta.disabled = true;
		}
	}
	
	
	function HabilitaCampo(_this) {
		var opc = new Number(_this.value);
		if (opc == 1) {
			document.form1.total_productos.disabled = true;
			document.form1.cheque_numero.disabled = true;
			document.form1.cheque_cuenta.disabled = true;
			document.form1.Bid.disabled = true;
			document.form1.Autoriza.disabled = true;
			document.form1.num_tarjeta.disabled = true;
			document.form1.tipo_tarjeta.disabled = true;
		}
		if (opc == 2) {
			document.form1.Autoriza.disabled = true;
			document.form1.num_tarjeta.disabled = true;
			document.form1.tipo_tarjeta.disabled = true;
			document.form1.cheque_numero.disabled = false;
			document.form1.cheque_cuenta.disabled = false;
			document.form1.Bid.disabled = false;
			document.form1.monto_recibido.disabled = false;

		}
		if (opc == 3) {
			document.form1.cheque_numero.disabled = true;
			document.form1.cheque_cuenta.disabled = true;
			document.form1.Bid.disabled = true;
			document.form1.Autoriza.disabled = false;
			document.form1.num_tarjeta.disabled = false;
			document.form1.tipo_tarjeta.disabled = false;
			document.form1.monto_recibido.disabled = false;
		}
	}
</script>

<form action= "RecibePagosSQL.cfm" method="post" name="form1" onSubmit="return validar();  " >
	<cfoutput>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
			
				<tr>
					<td>			
					  <table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" >
                       <tr class="titulolistas">
                         <td colspan="4" align="left" nowrap><strong>Los siguientes datos son necesarios para el registro contable de la factura </strong></td>
                        </tr>
                       <tr class="titulolistas">
                         <td align="right" nowrap>Caja&nbsp;:&nbsp;</td>
                         <td align="left"><select name="FCid" onChange="javascript:tiposTransaccion();;">
                           <cfloop query="rsCajasUsuario">
                             <option value="#FCid#|#Ocodigo#">#trim(FCcodigo)#, #FCdesc#</option>
                           </cfloop>
                         </select></td>
                         <td align="right" nowrap>&nbsp;</td>
                         <td align="right">&nbsp;</td>
                       </tr>
                       <tr class="titulolistas">
                         <td align="right" nowrap>Transacci&oacute;n&nbsp;:&nbsp;</td>
                         <td align="left"><select name="CCTcodigo">
						 <cfset FCid_first = rsCajasUsuario.FCid>
							<cfloop query="rsTiposTransaccion">
								<cfif FCid_first is FCid>
									<option value="#CCTcodigo#">#HTMLEditFormat(CCTdescripcion)#</option>
								</cfif>
                           </cfloop>
                         </select></td>
                         <td align="right" nowrap>&nbsp;</td>
                         <td align="right">&nbsp;</td>
                       </tr>
                       <tr class="titulolistas">
                         <td align="right" nowrap>Impuesto&nbsp;:&nbsp;</td>
                         <td align="left"><select name="Icodigo" tabindex="1">
                           <cfloop query="rsImpuestos">
                             <option value="#Trim(rsImpuestos.Icodigo)#" <cfif Trim(rsImpuestos.Icodigo) is Trim(rsForm.Icodigo)>selected</cfif> >#rsImpuestos.Idescripcion#</option>
                           </cfloop>
                         </select></td>
                         <td align="right" nowrap>&nbsp;</td>
                         <td align="right">&nbsp;</td>
                       </tr>
                       <tr class="titulolistas">
                        <td align="right" nowrap>Departamento&nbsp;:&nbsp;</td>
                        <td align="left"><select name="Dcodigo">
                          <cfloop query="rsDepartamentos">
                            <option value="#Dcodigo#">#Ddescripcion#</option>
                          </cfloop>
                        </select></td>
                        <td align="right" nowrap>&nbsp;</td>
                        <td align="right">&nbsp;</td>
                      </tr>
                       <tr class="titulolistas">
                         <td align="right" nowrap>Almac&eacute;n&nbsp;:&nbsp;</td>
                         <td align="left"><select name="Alm_Aid">
                           <cfloop query="rsAlmacenes">
                             <option value="#Aid#">#Bdescripcion#</option>
                           </cfloop>
                         </select></td>
                         <td align="right" nowrap>&nbsp;</td>
                         <td align="right">&nbsp;</td>
                       </tr>
                       <tr class="titulolistas">
                        <td align="right" nowrap>Moneda:</td>
                        <td align="right">
                          <div align="left">
                            <select name="moneda" id="select2" disabled>
                              <cfloop query="rsmonedas">
                                <option  value="#rsmonedas.Miso4217#" <cfif isdefined("rsForm") and rsForm.moneda EQ rsmonedas.Miso4217>selected</cfif> >#rsmonedas.Mnombre#</option>
                              </cfloop>
                            </select>
                        </div></td>
                        <td align="right" nowrap>Monto Total:</td>
                        <td align="right"><div align="left">
                            <input name="total_productos"  type="text" style="text-align: right;"  disabled   value="<cfif isdefined("rsForm")>#LSCurrencyFormat(rsForm.total_productos,'none')#</cfif>" size="20" maxlength="20" alt="El Monto">
                        </div></td>
                      </tr>
                      <tr>
                        <td nowrap><div align="right">Tipo de Compra: </div></td>
                        <td nowrap><strong>
                          <input name="radTC"  id="radio4" type="radio"  onClick="javascript: Habilitar(this);" value="1" <cfif rsForm.tipo_compra is 'CO'>checked</cfif>>
                          <label for="radio4">Contado</label>
						  <!---
                          <input type="radio" id="radio5" name="radTC" value="2" onClick="javascript: HabilitaCampo(this);" <cfif rsForm.tipo_compra is 'CR'>checked</cfif>>
                          <label for="radio5">Cr&eacute;dito un solo pago</label>
						  --->
                          <input type="radio" name="radTC" value="3" id="radio6" onClick="javascript: HabilitaCampo(this);" <cfif rsForm.tipo_compra is 'FI'>checked</cfif>>
                          <label for="radio6">Cr&eacute;dito</label>
                        </strong></td>
                        <td align="right" nowrap>&nbsp;</td>
                        <td align="right">
                          <div align="left"> </div></td>
                      </tr>
                      <tr>
                        <td nowrap><div align="right">Monto Pagado o Prima: </div></td>
                        <td>
						<cfif rsForm.tipo_compra is 'CO'>
							<cfset monto_recibido = rsForm.total_productos>
						<cfelse>
							<cfset monto_recibido = rsForm.prima_minima>
						</cfif>
						<input type="text" name="monto_recibido"  onBlur="valida_rango(this,2);ValidaPrima(this);"value="#LSCurrencyFormat(monto_recibido, 'none')#"  size="20" maxlength="20" style="text-align: right;"    onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="el monto pagado" ></td>
                        <td nowrap><div align="right"></div></td>
                        <td><div align="left"></div></td>
                      </tr>
                      <tr class="titulolistas">
                        <td nowrap><div align="right">M&eacute;todo de Pago:</div></td>
                        <td nowrap>
                          <div align="left">
                            <input name="radRep"  id="radio7" type="radio"  onClick="javascript: HabilitaCampo(this);" value="1" checked>
                            <strong><label for="radio7">Efectivo</label>
                        </strong></div></td>
                        <td nowrap>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td nowrap>&nbsp;</td>
                        <td nowrap><strong>
                          <input type="radio" id="radio8" name="radRep" value="2" onClick="javascript: HabilitaCampo(this);">
                          <label for="radio8">Cheque</label>
                        </strong></td>
                        <td nowrap>&nbsp; </td>
                        <td>&nbsp;</td>
                      </tr>
                     
                            <tr>
							<td>&nbsp;</td>
                              <td nowrap>
                                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" dwcopytype="CopyTableCell" >
                                  <tr>
                                    <td width="41%" nowrap>
                                      <div align="right">N&uacute;mero Cheque:</div></td>
                                    <td width="59%"><input type="text" name="cheque_numero" size="30" maxlength="60" ></td>
                                  </tr>
                                  <tr>
                                    <td nowrap>
                                      <div align="right">Cuenta:</div></td>
                                    <td><input type="text" name="cheque_cuenta" size="30" maxlength="60" ></td>
                                  </tr>
                                  <tr>
                                    <td nowrap>
                                      <div align="right">Banco:</div></td>
                                    <td><select name="Bid" id="Bid">
                                        <cfloop query="rsBancos">
                                          <option  value="#rsBancos.Bid#" <cfif isdefined("rsForm") and rsForm.cheque_Bid EQ rsBancos.Bid>selected</cfif> >#rsBancos.Bdescripcion#</option>
                                        </cfloop>
                                      </select>
                                    </td>
                                  </tr>
                              </table></td>
							  <td>&nbsp;</td>
							  <td>&nbsp;</td>
                            </tr>
                     
                      <tr>
                        <td nowrap>&nbsp;</td>
                        <td nowrap>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td nowrap>&nbsp;</td>
                        <td nowrap>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td >&nbsp;</td>
                        <td ><strong>
                          <input type="radio" name="radRep" value="3" id="radio9" onClick="javascript: HabilitaCampo(this);">
                          <label for="radio9">Tarjeta Cr&eacute;dito</label>
                        </strong></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td nowrap>&nbsp;</td>
                        <td nowrap>
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" dwcopytype="CopyTableCell" >
                            <tr>
                              <td width="41%" nowrap><div align="right">Tipo de Tarjeta: </div></td>
                              <td width="59%" align="left">
                                <select name="tipo_tarjeta" id="tipo_tarjeta" >
                                  <cfloop query="rsTipoTarjeta">
                                    <option  value="#rsTipoTarjeta.tc_tipo#" <cfif isdefined("rsForm") and rsForm.tipo_tarjeta EQ rsTipoTarjeta.tc_tipo>selected</cfif> >#rsTipoTarjeta.nombre_tipo_tarjeta #</option>
                                  </cfloop>
                                </select>                              </td>
                            </tr>
                            <tr>
                              <td nowrap><div align="right">N&deg; de Autorizaci&oacute;n:</div></td>
                              <td align="left"><input type="text" name="Autoriza" size="30" maxlength="30"></td>
                            </tr>
                            <tr>
                              <td nowrap><div align="right">&Uacute;ltimos 4 D&iacute;gitos:</div></td>
                              <td align="left"><input type="text" name="num_tarjeta" size="30" maxlength="30">
							  <input type="hidden" name="VentaID" value="<cfif isdefined("form.VentaID")>#form.VentaID#</cfif>">                              </td>
                            </tr>
                        </table></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan="4" nowrap><div align="center">
                            <input type="submit" name="btnAceptar" value="Aceptar">
                        </div></td>
                      </tr>
                    </table></td>
				</tr>
		</table>
	</cfoutput>
</form>					
<script language="JavaScript" type="text/javascript">
	
	if (document.form1.radRep[0].checked) {
		document.form1.radRep[0].click();	
		
	}
	else if (document.form1.radRep[1].checked) {
		document.form1.radRep[1].click();	
	}
	else if (document.form1.radRep[2].checked) {
		document.form1.radRep[2].click();	
	}
	else if (document.form1.radRep[3].checked) {
		document.form1.radRep[3].click();
	}
	
	function tiposTransaccion() {
			var form = document.form1;
			var caja = form.FCid.value.split("|")[0];
			var combo = form.CCTcodigo;
			var cont = 0;
			combo.length=0;
			<cfoutput query="rsTiposTransaccion">
				if (#FCid#==caja){
					combo.length=cont+1;
					combo.options[cont].value='#CCTcodigo#';
					combo.options[cont].text='#CCTdescripcion#';
					cont++;
				}
			</cfoutput>
		}
</script> 