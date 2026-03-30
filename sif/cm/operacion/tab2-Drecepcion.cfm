<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined('dataLineas') and dataLineas.recordCount GT 0 and isdefined('form.DOlinea') and form.DOlinea NEQ ''>
 	<cfquery name="detLineaTab2" dbtype="query">
		select EOnumero,DOconsecutivo,DOdescripcion,codArtServ,descrArtServ,
			#LvarOBJ_PrecioU.enSQL_AS("DDRprecioorig")#,
			#LvarOBJ_PrecioU.enSQL_AS("DDRpreciou")#,
			#LvarOBJ_PrecioU.enSQL_AS("DOpreciou")#,
			DDRtotallin,
			DOporcdesc,DDRdescporclin,DDRdesclinea,DDRdesclinea,DDRtotallincd,Icodigo,DDRimptoporclin,DDRmtoimpfact
			, IcodigoFAC,numparte
		from dataLineas
		where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
	</cfquery>
</cfif>

<cfquery name="rsConversion" datasource="#session.DSN#">
	select Ucodigo, Ucodigoref, CUfactor 
	from ConversionUnidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsConversionArt" datasource="#session.DSN#">
	select distinct a.Aid, b.Adescripcion, b.Ucodigo, c.Ucodigo as Ucodigoref, CUAfactor
	from DDocumentosRecepcion a
	
	inner join Articulos b
	on a.Aid=b.Aid
	
	inner join ConversionUnidadesArt c
	on b.Aid=c.Aid
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	
	order by a.Aid
</cfquery>
<cfoutput>
	<script language="javascript" type="text/javascript">
		var conversion    = new Object();
		var conversion_art = new Object();

		// objeto con datos de tabla de conversiones 
		<cfloop query="rsConversion">
			if ( !conversion["#trim(rsConversion.Ucodigo)#"] ){
			conversion["#trim(rsConversion.Ucodigo)#"] = new Object();
			}
			conversion["#trim(rsConversion.Ucodigo)#"]["#trim(rsConversion.Ucodigoref)#"] = "#rsConversion.CUfactor#";
		</cfloop>
		
		// objeto con datos de tabla de conversiones por articulo
		<cfloop query="rsConversionArt">
			if ( !conversion_art["#rsConversionArt.Aid#"] ){
				conversion_art["#rsConversionArt.Aid#"] = new Object();
			}
	
			if ( !conversion_art["#rsConversionArt.Aid#"]["#trim(rsConversionArt.Ucodigo)#"] ){ 
				conversion_art["#rsConversionArt.Aid#"]["#trim(rsConversionArt.Ucodigo)#"] = new Object();
			}
	
			conversion_art["#rsConversionArt.Aid#"]["#trim(rsConversionArt.Ucodigo)#"]["#trim(rsConversionArt.Ucodigoref)#"] = "#rsConversionArt.CUAfactor#";
		</cfloop>
	</script>
</cfoutput>
<cfquery name="rsImpuestos" datasource="#session.DSN#">
	select Icodigo, Idescripcion, Iporcentaje
	from Impuestos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Icodigo
</cfquery>
<cfif isdefined('rsImpuestos') and rsImpuestos.recordCount GT 0 and detLineaTab2.Icodigo NEQ ''>
	<cfquery name="rsImpuestoOC" dbtype="query">
		select *
		from rsImpuestos
		where Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#detLineaTab2.Icodigo#">
	</cfquery>
</cfif>



<cfif isdefined('detLineaTab2') and detLineaTab2.recordCount GT 0>
	<cfoutput query="detLineaTab2">
		<input type="hidden" name="cambioDescuentos" value="0">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="24%" nowrap align="right"><strong>N&uacute;mero de Orden:</strong></td>
			<td width="35%">&nbsp;&nbsp;&nbsp;#EOnumero#</td>
			<td width="1%">&nbsp;</td>
			<td width="22%" align="right"><strong>% Descuento OC : </strong></td>
			<td width="18%">
				<input name="DOporcdesc" value="#DOporcdesc#" type="hidden">
				&nbsp;&nbsp;&nbsp;#DOporcdesc#
</td>
		  </tr>
		  <tr>
			<td align="right"><strong>L&iacute;nea:</strong></td>
			<td>&nbsp;&nbsp;&nbsp;#DOconsecutivo#</td>
			<td>&nbsp;</td>
			<td align="right"><strong>% Descuento Factura:</strong></td>
			<td>
				&nbsp;&nbsp;
				<input type="hidden" name="DDRdescporclin" value="<cfif len(trim(detLineaTab2.DDRdescporclin)) and detLineaTab2.DDRdescporclin neq 0>#LSCurrencyFormat(detLineaTab2.DDRdescporclin,'none')#<cfelse>0.00</cfif>">				
				<input type="text" name="DDRdescporclin_tmp" id="DDRdescporclin_tmp"  style="text-align:right" 
				   size="22" maxlength="20" 
				   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} calculaMontoDesc(this);}" 
				   onFocus="javascript:this.select();" 
				   onChange="javascript: fm(this,4);"
				   onBlur="javascript:fm(this,4);"
				   value="<cfif len(trim(detLineaTab2.DDRdescporclin)) and detLineaTab2.DDRdescporclin neq 0>#LSNumberFormat(detLineaTab2.DDRdescporclin,',9.00')#<cfelse>0.0000</cfif>">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right"><strong>Codigo Articulo/Servicio: </strong></td>
			<td>&nbsp;&nbsp;&nbsp;#codArtServ#</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Monto Descuento Factura: </strong></td>
			<td>
				&nbsp;&nbsp;
				<input  type="hidden" name="DDRdesclinea" value="<cfif len(trim(detLineaTab2.DDRdesclinea)) and detLineaTab2.DDRdesclinea neq 0>#LSCurrencyFormat(detLineaTab2.DDRdesclinea,'none')#<cfelse>0.00</cfif>">				
              	<input type="text" name="DDRdesclinea_tmp" id="DDRdesclinea_tmp"  style="text-align:right" 
				   size="22" maxlength="20" 
				   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} calculaPorcenDesc(this);}" 
				   onFocus="javascript:this.select();" 
				   onChange="javascript: fm(this,4);"
				   onBlur="javascript:fm(this,4);"
				   value="<cfif len(trim(detLineaTab2.DDRdesclinea)) and detLineaTab2.DDRdesclinea neq 0>#LSNumberFormat(detLineaTab2.DDRdesclinea,',9.00')#<cfelse>0.0000</cfif>">			
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Precio Unitario en  OC:</strong></td>
			<td>&nbsp;&nbsp;
				<input type="hidden" name="DOpreciou" id="DOpreciou" value="#detLineaTab2.DDRprecioorig#">
				#LvarOBJ_PrecioU.enCF_COMAS(detLineaTab2.DDRprecioorig, true)#
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Total Linea con Descuento : </strong></td>
			<td>&nbsp;&nbsp;
				<input tabindex="1" type="text" name="DDRtotallincd" id="DDRtotallincd"  style="text-align:right; border-width:0;" 
					   size="22" maxlength="20" 
					   value="<cfif len(trim(detLineaTab2.DDRtotallincd)) and detLineaTab2.DDRtotallincd neq 0>#LSNumberFormat(detLineaTab2.DDRtotallincd,',9.00')#<cfelse>0.00</cfif>" readonly >
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right"><strong>Precio Unitario en Factura : </strong></td>
			<td>
				&nbsp;&nbsp;
				<cfif len(trim(detLineaTab2.DDRpreciou)) and detLineaTab2.DDRpreciou neq 0 >
					<cfset LvarValor = detLineaTab2.DDRpreciou>
				<cfelseif len(trim(detLineaTab2.DDRprecioorig)) and detLineaTab2.DDRprecioorig neq 0>
					<cfset LvarValor = detLineaTab2.DDRprecioorig>
				<cfelse>
					<cfset LvarValor = 0>
				</cfif>"
				<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
				#LvarOBJ_PrecioU.inputNumber("DDRpreciou", LvarValor, "1", false, "", "", "generarReclamo(); total(); actReclamo();", "")#
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong>% Impuesto OC: </strong></td>
			<td>
				&nbsp;&nbsp;			
				<input type="hidden" name="IcodigoOC" id="IcodigoOC" value="<cfif isdefined('rsImpuestoOC') and rsImpuestoOC.recordCount GT 0>#rsImpuestoOC.Icodigo#</cfif>">
				<cfif isdefined('rsImpuestoOC') and rsImpuestoOC.recordCount GT 0>
					#rsImpuestoOC.Icodigo# - #LSNumberFormat(rsImpuestoOC.Iporcentaje,9.00)#%
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right"><strong>Total de l&iacute;nea sin descuento:</strong></td>
			<td>
				&nbsp;&nbsp;
				<input tabindex="1" type="text" name="DDRtotallin" id="DDRtotallin"  style="text-align:right; border-width:0;" 
					   size="22" maxlength="20" 
					   value="<cfif len(trim(detLineaTab2.DDRtotallin)) >#LSNumberFormat(detLineaTab2.DDRtotallin,',9.00')#<cfelse>0.00</cfif>" readonly >
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong>% Impuesto Factura:</strong></td>
			<td>
				&nbsp;&nbsp;
				<cfoutput>
					<input type="hidden" name="Icodigo" value="">
					<select name="IcodigoCB" onChange="javascript: cambiaImpuesto(this,#rsOrden.Pvalor#); actReclamo();">
						<cfloop query="rsImpuestos">
							<option value="#rsImpuestos.Icodigo#~#rsImpuestos.Iporcentaje#" <cfif detLineaTab2.IcodigoFAC NEQ '' and trim(detLineaTab2.IcodigoFAC) eq trim(rsImpuestos.Icodigo) >selected</cfif> >#rsImpuestos.Icodigo# - #LSNumberFormat(rsImpuestos.Iporcentaje,9.00)#%</option>						
						</cfloop>
					</select>
				</cfoutput>
			</td>
		  </tr>  
		  <tr>
			<td align="right"><strong>N&uacute;mero de Parte:</strong></td>
			<td>&nbsp;&nbsp;#detLineaTab2.numparte#</td>
			<td>&nbsp;</td>
			<td align="right" nowrap><strong>Monto Impuesto en Factura:</strong></td>
			<td>
				&nbsp;&nbsp;
				<input tabindex="1" type="text" name="DDRmtoimpfact" id="DDRmtoimpfact"  style="text-align:right" 
					   size="22" maxlength="20" 
					   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					   onFocus="javascript:this.select();" 
					   onChange="javascript: fm(this,2);"
					   onBlur="javascript:fm(this,2);"
					   value="<cfif len(trim(detLineaTab2.DDRmtoimpfact))  and detLineaTab2.DDRmtoimpfact neq 0 >#LSNumberFormat(detLineaTab2.DDRmtoimpfact,',9.00')#<cfelse>0.00</cfif>"> 						
			</td>
		  </tr>  		  
		  <tr>
			<td align="right"><strong>Descripci&oacute;n:</strong></td>
			<td colspan="4">&nbsp;&nbsp;&nbsp;#descrArtServ#</td>
		  </tr>  
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>     
		</table>
	</cfoutput>
	<script language="javascript" type="text/javascript">
		function total(){
			var value1 = parseFloat(qf(document.getElementById("DDRcantrec").value));
			var value2 = parseFloat(qf(document.getElementById("DDRpreciou").value));
			
			document.getElementById("DDRtotallin").value = value1*value2;
			document.getElementById("DDRtotallin").value = fm(document.getElementById("DDRtotallin").value,2)
		}
		
		function calculaPorcenDesc(obj){		
			obj.form.cambioDescuentos.value=1;	
			if(obj.form.DOpreciou.value != '' && qf(obj.form.DOpreciou.value) > 0 && obj.form.DOcantidad.value != '' && qf(obj.form.DOcantidad.value) > 0){
				var porcDesc = 0;
				var totalPagar =  parseFloat(qf(obj.form.DDRtotallin.value));
				var valorMontoDesc =  parseFloat(qf(obj.value));

				if(totalPagar > 0 && ESNUMERO(valorMontoDesc) && valorMontoDesc > 0){
					if(valorMontoDesc <= totalPagar){
						porcDesc = (valorMontoDesc * 100) / totalPagar;
						obj.form.DDRdesclinea.value = valorMontoDesc;
						obj.form.DDRdescporclin.value = porcDesc;
						obj.form.DDRdescporclin_tmp.value = porcDesc;			
						fm(obj.form.DDRdescporclin,4);
						fm(obj.form.DDRdescporclin_tmp,4);
						obj.form.DDRdescporclin_tmp.disabled=1;
					}else{
					
						alert('Error, monto del porcentaje inválido, no se permiten montos superiores al total de la linea que es de ' + totalPagar);
						obj.form.DDRdesclinea_tmp.value = '0.0000';
						obj.form.DDRdesclinea.value = '0.0000';
						obj.form.DDRdescporclin.value = '0.0000';
						obj.form.DDRdescporclin_tmp.value = '0.0000';			
						obj.form.DDRdescporclin_tmp.disabled=0;			
					}
				}else{
					obj.form.DDRdesclinea.value = '0.0000';
					obj.form.DDRdescporclin.value = '0.0000';
					obj.form.DDRdescporclin_tmp.value = '0.0000';			
					obj.form.DDRdescporclin_tmp.disabled=0;
				}
			}else{
				alert('Debe digitar primero la cantidad y el precio unitario');
				obj.form.DOmontodesc.value = '0.0000';
				obj.form.DDRdesclinea_tmp.value = '0.0000';			
				obj.form.DDRdescporclin.value = '0.0000';
				obj.form.DDRdescporclin_tmp.value = '0.0000';			
			}
			
			totalLinConDesc();
		}
		
		
		function calculaMontoDesc(obj){		
			obj.form.cambioDescuentos.value=1;		
			if(obj.form.DOpreciou.value != '' && qf(obj.form.DOpreciou.value) > 0 && obj.form.DOcantidad.value != '' && qf(obj.form.DOcantidad.value) > 0){	
				var montoDesc = 0;
				var totalPagar =  parseFloat(qf(obj.form.DDRtotallin.value));
				var valorPorcDesc =  parseFloat(qf(obj.value));
					
				if(ESNUMERO(valorPorcDesc) && valorPorcDesc > 0){
					if(valorPorcDesc <= 100){
						montoDesc = (totalPagar * valorPorcDesc) / 100;
						obj.form.DDRdescporclin.value = valorPorcDesc;
						obj.form.DDRdesclinea.value = montoDesc;
						obj.form.DDRdesclinea_tmp.value = montoDesc;			
						fm(obj.form.DDRdesclinea,4);
						fm(obj.form.DDRdesclinea_tmp,4);
						obj.form.DDRdesclinea_tmp.disabled=1;			
					}else{
						alert('Error, porcentaje inválido, no se permiten montos superiores a 100');
						obj.form.DDRdescporclin_tmp.value = '0.00';
						obj.form.DDRdescporclin.value = '0.00';
						obj.form.DDRdesclinea.value='0.00';
						obj.form.DDRdesclinea_tmp.value='0.00';
						obj.form.DDRdesclinea_tmp.disabled=0;				
					}
				}else{
					obj.form.DDRdescporclin.value = '0.00';
					obj.form.DDRdesclinea.value='0.00';
					obj.form.DDRdesclinea_tmp.value='0.00';
					obj.form.DDRdesclinea_tmp.disabled=0;
				}
			}else{
				alert('Debe digitar primero la cantidad y el precio unitario');
				obj.form.DDRdescporclin.value = '0.00';
				obj.form.DDRdescporclin_tmp.value = '0.00';			
				obj.form.DDRdesclinea.value='0.00';
				obj.form.DDRdesclinea_tmp.value='0.00';
			}		
			
			totalLinConDesc();
		}	
		
		function totalLinConDesc(){
			var totalPagar = qf(document.form2.DDRtotallin.value);
			document.form2.DDRtotallincd.value = totalPagar - qf(document.form2.DDRdesclinea.value);
			fm(document.form2.DDRtotallincd,2);
		}
		
		function cambiaImpuesto(obj,param){
			if(obj.value != ''){
				var p = obj.value.split("~");
					obj.form.Icodigo.value = p[0];
				var porcen = p[1];
				
				if (param == 1){
					if(qf(obj.form.DDRtotallin.value) > 0){
						obj.form.DDRmtoimpfact.value = (qf(obj.form.DDRtotallin.value) * porcen) / 100;
					}else{
						obj.form.DDRmtoimpfact.value = '0.00';
					}			
				}else{
					if(qf(obj.form.DDRtotallincd.value) > 0){
						obj.form.DDRmtoimpfact.value = (qf(obj.form.DDRtotallincd.value) * porcen) / 100;
					}else{
						obj.form.DDRmtoimpfact.value = '0.00';
					}					
				}						
				
				fm(document.form2.DDRmtoimpfact,2);				
			}
		}
		
		function calcTotLinea(obj, opt){
			if(opt == 1){//Desce Cantidad en Factura
				obj.form.DDRtotallin.value = qf(obj.form.DDRpreciou.value) * qf(obj.value);			
			}else{
				if(opt == 2){//Desce Precio Unitario
					obj.form.DDRtotallin.value = qf(obj.form.DDRcantorigen.value) * qf(obj.value);
				}
			}
			fm(obj.form.DDRtotallin,2);
			calculaPorcenDesc(document.form2.DDRdesclinea_tmp);
		}

		total();		
		totalLinConDesc();
		calcTotLinea(document.form2.DDRpreciou,2);		
		calculaPorcenDesc(document.form2.DDRdesclinea_tmp);
		cambiaImpuesto(document.form2.IcodigoCB,<cfoutput>#rsOrden.Pvalor#</cfoutput>);		
		actReclamo();
	</script>
</cfif>
