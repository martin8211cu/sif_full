<cfif isdefined('url.Linea') and not isdefined('form.Linea')>
	<cfparam name="form.Linea" default="#url.Linea#">
</cfif>

<cfset modoDet = 'ALTA'>
<cfif  isdefined('form.Linea') and len(trim(form.Linea))>
	<cfset modoDet = 'CAMBIO'>
</cfif>

<cfif modoDet NEQ 'ALTA'>
	<cfquery name="rsFormDet" datasource="#session.DSN#">
		Select 
			Linea, 
			Cantidad, 
			TipoLinea, 
			Aid, 
			Alm_Aid, 
			Cid, 
			Icodigo, 
			Descripcion, 
			PrecioUnitario, 
			PorDescuento, 
			MonDescuento, 
			TotalLinea, 
			BMUsucodigo, 
			fechaalta, 
			ts_rversion,
			periodo		
		from FACotizacionesD
		where Linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Linea#">			
		and NumeroCot = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">
	</cfquery>
	

	<cfif isdefined('rsFormDet') and rsFormDet.Icodigo NEQ ''>
		<cfquery name="rsImpuestos" datasource="#Session.DSN#">
			select Icodigo,Idescripcion,Iporcentaje
			from Impuestos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsFormDet.Icodigo#">
		</cfquery>
	</cfif>	

	
</cfif>
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select Ocodigo, convert(varchar,Aid) as Aid, Bdescripcion 
	from Almacen 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<!---<cfif isdefined('rsForm.Ocodigo') and rsForm.Ocodigo NEQ ''>
			and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.Ocodigo#">
		</cfif>--->
</cfquery>
<!---<cf_dump var="#rsFormDet#">--->
<cfoutput>
<form name="formDetCoti" method="post" action="cotizaciones-sql.cfm" onSubmit="javascript: return valida();">
	<!--- Tipo de Cotizacion 1='Prefactura' y 2='Cotizacion' --->
	<cfif isdefined('form.tipoCoti')>
		<input type="hidden" name="tipoCoti" value="#form.tipoCoti#">	
	</cfif>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
        <td align="right">
			<div id="idArt_2L">
				<strong>Almacen:</strong> 			
			</div>		
		</td>
        <td>
			<div id="idArt_2">
				<select name="Alm_Aid" onChange="javascript: cambioAlmacen(this);" tabindex="21">
					<cfloop query="rsAlmacenes"> 
						<option value="#rsAlmacenes.Aid#" 
							<cfif modoDet NEQ "ALTA">
								<cfif  rsAlmacenes.Aid EQ rsFormDet.Alm_Aid>
									selected
								</cfif>
							<cfelse>
								<cfif rsAlmacenes.Ocodigo EQ rsForm.Ocodigo>
									selected
								</cfif>
							</cfif>
						>
						#rsAlmacenes.Bdescripcion#
						</option>
					</cfloop> 
				</select>			
			</div>				
		</td>
		
      </tr>
      <tr>
        <td align="right"><strong>Tipo:</strong></td>
        <td><select name="TipoLinea" onChange="javascript: cambioTipoL(this);" tabindex="19">
          <option value="A" <cfif modoDet NEQ 'ALTA' and rsFormDet.TipoLinea EQ 'A'> selected</cfif>>Articulo</option>
          <option value="S" <cfif modoDet NEQ 'ALTA' and rsFormDet.TipoLinea EQ 'S'> selected</cfif>>Servicio</option>
        </select></td>
        <td align="right">
			<div id="idArt_1L">
				<strong>Articulo:</strong>			
			</div>		
			<div id="idServL">
				<strong>Servicio:</strong>			
			</div>		
		</td>
        <td>
			<div id="idArt_1">
				<cfif modoDet neq 'ALTA' and rsFormDet.TipoLinea EQ 'A'>
					<cfquery name="rsArticulo" datasource="#session.DSN#">
						select Aid, Acodigo, Adescripcion
						from Articulos
						where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Aid#">
					</cfquery>
					<cf_sifarticulos tabindex="20" form="formDetCoti" query=#rsArticulo# validarExistencia="1" size="22">
				<cfelse>
					<cf_sifarticulos tabindex="20" form="formDetCoti" validarExistencia="1" size="22">
				</cfif>			
			</div>
			<div id="idServ">
				<cfif modoDet neq 'ALTA' and rsFormDet.TipoLinea EQ 'S'>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select Cid, Ccodigo, Cdescripcion
						from Conceptos
						where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Cid#">
					</cfquery>
					<cf_sifconceptos tabindex="17" form="formDetCoti" query=#rsConcepto# size="22">
				<cfelse>
					<cf_sifconceptos tabindex="17" form="formDetCoti" size="22">
				</cfif>
			</div>				
		</td>
		<td align="right"><strong>Periodo</strong></td>
			<td>
				<cfif modo neq "ALTA">
					<cfif isdefined('rsFormDet')>
						<cfset LvarFecha = rsFormDet.periodo>
					<cfelse>
						<cfset LvarFecha = now()>
					</cfif>
				<cfelse>
					<cfset LvarFecha = now()>
				</cfif>	
				<cf_sifcalendario tabindex="5" form="formDetCoti" value="#DateFormat(LvarFecha,'dd/mm/yyyy')#" name="periodo">
			</td>
			</tr>
		
      <tr>
        <td align="right"><strong>Descripci&oacute;n:</strong></td>
        <td><input name="Descripcion" tabindex="22" type="text" id="Descripcion2" onFocus="javascript: this.select();" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Descripcion#</cfif>" size="35" maxlength="80" <cfif mododet neq 'alta'> readonly="true"</cfif>></td>
        <td align="right"><strong>Cantidad:</strong></td>
        <td><input name="Cantidad" type="text" id="Cantidad2" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.Cantidad,',9.00')#"<cfelse> value="1"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="23" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calcDescTotal();}"></td>
        <td align="right"><strong>Precio:</strong></td>
        <td><input name="PrecioUnitario" type="text" id="PrecioUnitario" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.PrecioUnitario,',9.00')#"<cfelse> value="0.00"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="24" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}calcDescTotal();}"></td>
      </tr>
      <tr>
        <td align="right" nowrap><strong>% Descuento:</strong></td>
        <td><input name="PorDescuento" type="text" id="PorDescuento" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.PorDescuento,',9.00')#"<cfelse> value="0.00"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="25" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}calcDescTotal();}"></td>
        <td align="right" nowrap><strong>Descuento:</strong> </td>
        <td><input name="MonDescuento" readonly="true" type="text" id="MonDescuento" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.MonDescuento,',9.00')#"<cfelse> value="0.00"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
        <td align="right"><strong>Impuesto:</strong></td>
        <td nowrap>
			<cfif modoDet EQ 'Alta'>
				<cfquery name="rsImp" datasource="#session.DSN#">
					select Icodigo, Idescripcion
					from Impuestos 
					where Ecodigo = #session.Ecodigo#
					order by Idescripcion
				</cfquery>
				<select name="Icodigo" id="Icodigo" tabindex="1">
					<cfloop query="rsImp">
						<option value="#rsImp.Icodigo#">#rsImp.Icodigo#</option>
					</cfloop>
				</select>
			<cfelse>
				<input name="Idescripcion" class="cajasinbordeb" readonly="true" type="text" id="Idescripcion" value="<cfif modoDet NEQ 'Alta' and isdefined('rsImpuestos') and rsImpuestos.recordCount GT 0>#rsImpuestos.Icodigo#</cfif>" size="40" maxlength="80" tabindex="27">
				<input type="hidden" name="Icodigo" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Icodigo#</cfif>">
				<input type="hidden" name="Iporcen" value="<cfif modoDet NEQ 'Alta' and isdefined('rsImpuestos') and rsImpuestos.recordCount GT 0>#rsImpuestos.Iporcentaje#</cfif>">						
			</cfif>
		</td>
      </tr>
      <tr>
        <td colspan="5" align="right"><strong>Total:</strong></td>
        <td><input name="TotalLinea" readonly="true" type="text" id="TotalLinea2" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.TotalLinea,',9.00')#"<cfelse> value="0.00"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="28" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
      </tr>
      <tr>
        <td colspan="6" align="center">
			<input type="hidden" name="PorcDescCliente" value="">	
			<input type="hidden" name="NumeroCot" value="#form.NumeroCot#">	
			<input type="hidden" name="tipoCalculos" value="#tipoCalculos#">	
			<input type="hidden" name="Exento" value="#rsForm.Exento#">
			
			<input type="hidden" name="ts_rversion" value="#ts#">			
			<cfif modoDet neq 'ALTA'  >
				<cfset tsDet = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsFormDet.ts_rversion#" returnvariable="tsDet">
				</cfinvoke>
				<input type="hidden" name="ts_rversionDet" value="#tsDet#">	
							
				<input type="hidden" name="Linea" value="#form.Linea#">
				
				<cfif rsForm.Estatus EQ '0'>
					<cf_botones tabindex="29" modo='CAMBIO' sufijo="Det">
				</cfif>				
			<cfelse>
				<cfif rsForm.Estatus EQ '0'>
					<cf_botones tabindex="29" modo='ALTA' sufijo="Det">
				</cfif>							
			</cfif>		
		</td>
      </tr>	  
    </table>
</form>
<iframe name="frSP" id="frSP" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>
</cfoutput>

<cf_qforms form="formDetCoti" objForm="objFormDet">
<script language="javascript" type="text/javascript">
	var exentoImp = -1;	
	
	if(document.form1.Exento.checked)
		exentoImp = 1;	
	else
		exentoImp = 0;	
		
	function cambioAlmacen(cb){
		if(document.formDetCoti.Aid.value != ''){
			cargaImpPreciou('A');
		}
	}
	
	function funcAcodigo(){
		if(document.formDetCoti.Aid.value != ''){
			cargaImpPreciou('A');
			if(document.formDetCoti.Adescripcion.value != '')
				document.formDetCoti.Descripcion.value = document.formDetCoti.Adescripcion.value;
		}else{
			funcExtraAcodigo();
		}
	}

	function funcExtraCcodigo(){
		funcExtraAcodigo();
	}	
	
	function funcExtraAcodigo(){
		document.formDetCoti.PrecioUnitario.value = '0.00';
		document.formDetCoti.Icodigo.value = '';
		document.formDetCoti.Idescripcion.value = '';
		document.formDetCoti.MonDescuento.value = '0.00';
		document.formDetCoti.TotalLinea.value = '0.00';
	}
	
	function funcCcodigo(){
		if(document.formDetCoti.Cid.value != ''){
			cargaImpPreciou('C');
			if(document.formDetCoti.Cdescripcion.value != '')
				document.formDetCoti.Descripcion.value = document.formDetCoti.Cdescripcion.value;			
		}else{
			funcExtraAcodigo();
		}	
	}	

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function cargaImpPreciou(tip){
		var params ="";
		var dato = "";				
		if(tip == 'A'){//Articulo
			dato = document.formDetCoti.Acodigo.value;
		}else{//Concepto o servicio
			dato = document.formDetCoti.Cid.value;
		}
		
		if(document.form1.Mcodigo.value != ''){
			if(document.form1.Ocodigo.value != ''){		
				params = "?dato=" + trim(dato)
							+ "&oficina=" + trim(document.form1.Ocodigo.value)
							+ "&moneda=" + trim(document.form1.Mcodigo.value)		
							+ "&tipo=" + tip					
							+ "&almacen=Alm_Aid"
							+ "&preciou=PrecioUnitario"					
							+ "&codImpuesto=Icodigo"	
							+ "&desImpuesto=Idescripcion"
							+ "&porcenImpuesto=Iporcen"
							+ "&monDesc=MonDescuento"
							+ "&TotLin=TotalLinea"
							+ "&form=formDetCoti";
		
				if(document.formDetCoti.Alm_Aid.value != '')
					params = params + "&bodega=" + document.formDetCoti.Alm_Aid.value;
			
				if (trim(dato)!="") {
					var fr = document.getElementById("frSP");
					fr.src = "/cfmx/sif/pv/operacion/execFA_Trae_Precio.cfm" + params;
				}					
			}else{
				alert('Error, debe elegir una oficina para esta cotización');			
			}				
		}else{
			alert('Error, no existe una moneda para esta cotización');			
		}	
	}
	
	function valida(){
		document.formDetCoti.Cantidad.value = qf(document.formDetCoti.Cantidad.value);
		document.formDetCoti.PrecioUnitario.value = qf(document.formDetCoti.PrecioUnitario.value);		
		document.formDetCoti.PorDescuento.value = qf(document.formDetCoti.PorDescuento.value);		
		document.formDetCoti.MonDescuento.value = qf(document.formDetCoti.MonDescuento.value);		
		document.formDetCoti.TotalLinea.value = qf(document.formDetCoti.TotalLinea.value);		
		document.formDetCoti.PorcDescCliente.value = qf(document.form1.PorcDescCliente.value);		
			document.formDetCoti.periodo.value = qf(document.form1.periodo.value);			
		return true;
	}

	function calcDescTotal(){ 
		var porCorrectos = true;

		//Verificacion de Porcentajes que no sean mayores a 100
		var porDescLinea = parseFloat(qf(document.formDetCoti.PorDescuento.value));
		var porImpLin = parseFloat(qf(document.formDetCoti.Iporcen.value));
		var porDescFact = parseFloat(qf(document.form1.PorcDescCliente.value));
		
		if(porDescLinea < 0 || porDescLinea > 100){
			alert('Error, el porcentaje de la linea es inválido');
			document.formDetCoti.PorDescuento.value = '0.00';
			document.formDetCoti.MonDescuento.value = '0.00';
			porCorrectos = false;
		}else{
			if(porDescFact < 0 || porDescFact > 100){			
				alert('Error, el porcentaje del descuento de la factura es inválido');
				document.form1.PorcDescCliente.value = '0.00';
				porCorrectos = false;					
			}else{
				if(exentoImp != '1'){
					if(porImpLin < 0 || porImpLin > 100){			
						alert('Error, el porcentaje del impuesto de la linea es inválido');
						document.formDetCoti.Iporcen.value = '0.00';
						porCorrectos = false;			
					}			
				}else{//La factura es exenta de impuestos
					porImpLin = 0;
				}
			}
		}
		
		//Si los 3 porcentajes son validos, entonces se procede a la realizacion de los calculos de los montos
		if(porCorrectos){
			//Calculo del total sin descuento
			var subTotal = parseFloat(qf(document.formDetCoti.Cantidad.value)) * parseFloat(qf(document.formDetCoti.PrecioUnitario.value));		
			<cfif tipoCalculos EQ 1>			
				//Calculo del monto por descuento
				var monDescLinea = 0;
				monDescLinea = subTotal * (porDescLinea / 100) ;
				document.formDetCoti.MonDescuento.value = monDescLinea;
				fm(document.formDetCoti.MonDescuento,2);			
				
				//Calculo del impuesto
				var monImpLin = 0;
				monImpLin = ((subTotal - monDescLinea) * (porImpLin / 100));

				//Calculo del Descuento en Factura, solo que para el total de la linea no se va a ocupar
				// Si se usa para el calculo del total de la factura
				var monDescFact = 0;
				monDescFact = ((subTotal + monImpLin - monDescLinea) * (porDescFact / 100));
				
				document.formDetCoti.TotalLinea.value = subTotal + monImpLin - monDescLinea;
				fm(document.formDetCoti.TotalLinea,2);
				
			<cfelseif tipoCalculos EQ 2>
				//Calculo del impuesto
				var monImpLin = 0;
				monImpLin = subTotal * (porImpLin / 100);		
				
				//Calculo del monto por descuento
				monDescLinea = ((subTotal + monImpLin) * (porDescLinea / 100));
				document.formDetCoti.MonDescuento.value = monDescLinea;
				fm(document.formDetCoti.MonDescuento,2);
				
				//Calculo del Descuento en Factura, solo que para el total de la linea no se va a ocupar
				// Si se usa para el calculo del total de la factura				
				var monDescFact = 0;
				monDescFact = ((subTotal + monImpLin - monDescLinea) * (porDescFact / 100));
												
				document.formDetCoti.TotalLinea.value = subTotal + monImpLin - monDescLinea;
				fm(document.formDetCoti.TotalLinea,2);												
			</cfif>				
		}else{
			calcDescTotal();
		}
	}
	
	function cambioTipoL(valor){
		if(valor.value=="A"){
			document.getElementById("idArt_1L").style.display = '';
			document.getElementById("idArt_1").style.display = '';
			document.getElementById("idArt_2L").style.display = '';			
			document.getElementById("idArt_2").style.display = '';						
			document.getElementById("idServL").style.display = 'none';
			document.getElementById("idServ").style.display = 'none';			
			objFormDet.Aid.required = true;
			objFormDet.Alm_Aid.required = true;
			objFormDet.Cid.required = false;		
		} else if(valor.value=="S") {
			document.getElementById("idServL").style.display = '';
			document.getElementById("idServ").style.display = '';			
			document.getElementById("idArt_1L").style.display = 'none';
			document.getElementById("idArt_1").style.display = 'none';			
			document.getElementById("idArt_2L").style.display = 'none';				
			document.getElementById("idArt_2").style.display = 'none';							
			objFormDet.Alm_Aid.required = false;
			objFormDet.Aid.required = false;			
			objFormDet.Cid.required = true;			
		}    			
		<cfif modoDet EQ 'ALTA'>
			//Limpiado de objetos
			document.formDetCoti.Cid.value = '';
			document.formDetCoti.Icodigo.value = '';			
			//document.formDetCoti.Idescripcion.value = '';		
			document.formDetCoti.Aid.value = '';
			document.formDetCoti.Acodigo.value = '';
			document.formDetCoti.Adescripcion.value = '';			
			document.formDetCoti.Cid.value = '';
			document.formDetCoti.Ccodigo.value = '';
			document.formDetCoti.Cdescripcion.value = '';						
			document.formDetCoti.PrecioUnitario.value = '0.00';	
		</cfif>
	}

    function deshabilitaValidacionDet() {
		objFormDet.Aid.required = false;
		objFormDet.Alm_Aid.required = false;
		objFormDet.Cid.required = false;		
		objFormDet.Cantidad.required = false;
		objFormDet.TipoLinea.required = false;
		objFormDet.Icodigo.required = false;
		objFormDet.PrecioUnitario.required = false;
		objFormDet.PorDescuento.required = false;
		objFormDet.MonDescuento.required = false;
		objFormDet.TotalLinea.required = false;
		objFormDet.periodo.required = false;
	}

    function funcBajaDet() {
		if(!confirm('¿Desea eliminar esta línea de detalle de cotización ?')){
			return false;
		}
		deshabilitaValidacionDet();
		return true;		
	}

	// Funcion para validar que el porcentaje digitado no sea mayor a100
	function _mayor(){	
		if ( (new Number(qf(this.value)) > 100) || (new Number(qf(this.value)) < 0 )){
			this.error = 'El campo no puede ser mayor a 100 ni menor que cero';
			this.value = '';
		}
	}	
	
	// Validaciones para los campos de % no sean mayores a 100 		
	_addValidator("ismayor", _mayor);

	objFormDet.Aid.required = true;
	objFormDet.Aid.description = "Articulo";
	objFormDet.Alm_Aid.required = true;
	objFormDet.Alm_Aid.description = "Almacén";			
	objFormDet.Cid.required = true;		
	objFormDet.Cid.description = "Servicio";			

	objFormDet.Cantidad.required = true;
	objFormDet.Cantidad.description = "Cantidad";
	
	objFormDet.TipoLinea.required = true;
	objFormDet.TipoLinea.description = "Tipo de Línea";
	
	objFormDet.Icodigo.required = true;
	objFormDet.Icodigo.description = "impuesto";		
	
	objFormDet.PrecioUnitario.required = true;
	objFormDet.PrecioUnitario.description = "Precio Unitario";
	
	objFormDet.PorDescuento.required = true;
	objFormDet.PorDescuento.description = "Porcentaje de Descuento";	

	objFormDet.MonDescuento.required = true;
	objFormDet.MonDescuento.description = "Monto de Descuento";

	objFormDet.TotalLinea.required = true;
	objFormDet.TotalLinea.description = "Total de Línea";		
	
	objFormDet.PorDescuento.validatemayor();	
	cambioTipoL(document.formDetCoti.TipoLinea);
</script>