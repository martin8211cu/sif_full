<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined('dataLineas') and dataLineas.recordCount GT 0 and isdefined('form.DOlinea') and form.DOlinea NEQ ''>
	<cfquery name="rsImpuestos" datasource="#session.DSN#">
		select Icodigo, Idescripcion, Iporcentaje
		from Impuestos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by Icodigo
	</cfquery>
	
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
	
	<cfloop query="dataLineas">
		<cfoutput>
		<cfif dataLineas.DOlinea EQ form.DOlinea>
			<cfset Tolerancia = 0>
			<cfif dataLineas.DDRtipoitem EQ 'A'>
            <cfset LvarArticulo = dataLineas.Aid>
				<cfquery name="rsTolerancia" datasource="#session.DSN#">
					select coalesce(Ctolerancia,0) as Ctolerancia,
						case when Ctolerancia is null then 'F'
							 else 'V'
						end as ArticuloTieneTolerancia
					from  Clasificaciones  A , Articulos B
					where  A.Ecodigo = B.Ecodigo
					and A.Ccodigo = B.Ccodigo
					and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataLineas.Aid#">
				</cfquery>
				<cfset Tolerancia = (rsTolerancia.Ctolerancia * dataLineas.saldo)/100>
				<!--- <cfdump var="#rsTolerancia#">
				<cfdump var="#Tolerancia#">
				<cfdump var="#dataLineas.saldo#" --->
			</cfif>
			<cfset MaxCantidad = Tolerancia +dataLineas.DOCantidad >
			<cfset unidadOrdenC = dataLineas.Ucodigo>				
			<cfset codIcodFact = dataLineas.IcodigoFAC>	
			<cfif isdefined('rsImpuestos') and rsImpuestos.recordCount GT 0 and dataLineas.Icodigo NEQ ''>
				<cfquery name="rsImpuestoOC" dbtype="query">
					select *
					from rsImpuestos
					where Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(dataLineas.Icodigo)#">
				</cfquery>
			</cfif>
			<!--- <cfdump var="#dataLineas#"> --->
			<input type="hidden" name="ArticuloTieneTolerancia" value="<cfif dataLineas.DDRtipoitem eq 'A'>#rsTolerancia.ArticuloTieneTolerancia#<cfelse>'F'</cfif>">
			<input type="hidden" name="cambioDescuentos" value="0">
			<input type="hidden" name="Aid" value="#Aid#">
  		    <input type="hidden" name="Tolerancia" value="#Trim(Tolerancia)#">
			<input type="hidden" name="DOcantidad" value="#DOcantidad#">		
			<input type="hidden" name="BanderaTolerancia" value="0">
  			<input type="hidden" name="DDRtotallin" value="<cfif len(trim(dataLineas.DDRtotallin)) >#LSNumberFormat(dataLineas.DDRtotallin,',9.00')#<cfelse>0.00</cfif>">					 
			<input type="hidden" name="saldo" value="<cfif len(trim(dataLineas.saldo)) >#LSNumberFormat(dataLineas.saldo,',9.00')#<cfelse>0.00</cfif>">
			<input type="hidden" name="tipoItem" value="#dataLineas.DDRtipoitem#">
            <input type="hidden" name="ToleranciaA" value="<cfif dataLineas.DDRtipoitem eq 'A'>#ObtieneTolerancia(LvarArticulo)#<cfelse>0</cfif>">
			<cfif isdefined('rsForm.EPDid') and rsForm.EPDid NEQ ''>
				<input type="hidden" name="EPDid" value="#rsForm.EPDid#">
			</cfif>
						
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="24%" nowrap align="right"><strong>N&uacute;mero de Orden:</strong></td>
				<td width="35%">&nbsp;&nbsp;&nbsp;#EOnumero#</td>
				<td width="1%">&nbsp;</td>
				<td width="22%" align="right"><strong>Unidad OC:</strong></td>
				<td width="18%">&nbsp;&nbsp;
					<input name="DDRfactor" value="1" type="hidden">
                    <input type="hidden" name="UcodigoOC" value="#UcodigoOC#">
					&nbsp;&nbsp;&nbsp;#UcodigoOC# </td>
			  </tr>
			  <tr>
				<td align="right"><strong>Cantidad Recibida en Unidad OC: </strong></td>
				<td>&nbsp;&nbsp;&nbsp;
					#DDRcantordenconv#</td>
				<td>&nbsp;</td>
				<td align="right"><strong>Unidad Recepci&oacute;n:</strong></td>
				<td>&nbsp;&nbsp;
                  <select name="Ucodigo" onChange="cambiaUnidad(this.value)" >
                    <cfloop query="rsUnidades">
                      <option value="#rsUnidades.Ucodigo#" <cfif trim(unidadOrdenC) eq trim(rsUnidades.Ucodigo) >selected</cfif> >#rsUnidades.Ucodigo#</option>
                    </cfloop>
                  </select>
				</td>
			  </tr>
			  <tr>
				<td nowrap align="right"><strong>Descripci&oacute;n Alterna/Observaciones:</strong></td>
				<td>&nbsp;
                  <input type="hidden" name="DOobservaciones" value="#Trim(dataLineas.DOobservaciones)#">
                  <input type="hidden" name="DOalterna" value="#Trim(dataLineas.DOalterna)#">
                  <a href="javascript: infoDet();"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a> &nbsp;&nbsp;</td>
				<td>&nbsp;</td>
				<td align="right"><strong>Cantidad Factura:</strong></td>
				<td>&nbsp;&nbsp;
                  <input tabindex="4" type="text" name="DDRcantorigen" id="DDRcantorigen2"  style="text-align:right" 
					   size="14" maxlength="14" 
					   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}calcTotLinea(this,1);}" 
					   onFocus="javascript:this.select();" 
					   onChange="valida_cantidad(1); javascript: fm(this,4);"
					   value="<cfif len(trim(dataLineas.DDRcantorigen)) and dataLineas.DDRcantorigen neq 0>#LSNumberFormat(dataLineas.DDRcantorigen,',9.0000')#<cfelseif len(trim(dataLineas.saldo)) >#LSNumberFormat(dataLineas.saldo,',9.0000')#<cfelse>0.0000</cfif>"
					   onBlur="<cfif rsParametroExcesos.RecordCount gt 0 and rsParametroExcesos.Pvalor eq 1>valida_cantidadRecibida();<cfelseif dataLineas.DDRtipoitem EQ 'A'>valida_cantidadRecibidaContraTolerancia();</cfif> cambiaImpuesto(document.form2.IcodigoCB,0); total(); fm(this,4); actReclamo(0);">
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Precio Unitario en OC:</strong></td>
				<td>&nbsp;&nbsp;
					<input type="hidden" name="McodigoOC" id="McodigoOC" value="#dataLineas.Mcodigo#">
					<input type="hidden" name="TipoCambioOC" id="TipoCambioOC" value="#dataLineas.EOtc#">
 					<input type="hidden" name="DOpreciou" id="DOpreciou" value="#dataLineas.DDRprecioorig#">
					#LvarOBJ_PrecioU.enCF(dataLineas.DDRprecioorig)#
				</td>
				<td>&nbsp;</td>
				<td align="right"><strong>Cantidad recibida:</strong></td>
				<td>&nbsp;&nbsp;
                  <input tabindex="5" type="text" name="DDRcantrec" id="DDRcantrec"  style="text-align:right" 
						   size="14" maxlength="14" 
						   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
						   onFocus="javascript:this.select();" 
						   onChange="javascript: fm(this,4);"
						   value="<cfif len(trim(dataLineas.DDRcantrec))  and dataLineas.DDRcantrec gte 0 >#LSNumberFormat(dataLineas.DDRcantrec,',9.0000')#<cfelseif len(trim(dataLineas.saldo)) >#LSNumberFormat(dataLineas.saldo,',9.0000')#<cfelse>0.0000</cfif>"
						   onBlur="<cfif rsParametroExcesos.RecordCount gt 0 and rsParametroExcesos.Pvalor eq 1>valida_cantidadRecibida();<cfelseif dataLineas.DDRtipoitem EQ 'A'>valida_cantidadRecibidaContraTolerancia();</cfif> total(); fm(this,4); actReclamo(0);"> 
                </td>
			  </tr>
			  <cfif dataLineas.DDRtipoitem EQ 'A'>
                <tr>
                	<td colspan="3">&nbsp;</td>
                    <td colspan="2" style="font-size:4px; color:red; font-style:italic" align="right">
                        <div id="Legenda" style="display:none">
	                        El articulo seleccionado tiene una tolerancia de <cfoutput>#ObtieneTolerancia(LvarArticulo)#</cfoutput>
                        </div>
                    </td>
                </tr>
			  </cfif>   
				<tr>
				<td nowrap align="right"><strong>Precio Unitario en Factura :</strong></td>
				<td>
					&nbsp;&nbsp;
					<input type="hidden" name="McodigoF" id="McodigoF" value="#dataLineas.McodigoF#">
					<input type="hidden" name="TipoCambioF" id="TipoCambioF" value="#dataLineas.EDRtc#">
					<cfif len(trim(dataLineas.DDRpreciou)) and dataLineas.DDRpreciou neq 0 >
						<cfset LvarPrecio = dataLineas.DDRpreciou>
					<cfelseif len(trim(dataLineas.DDRprecioorig)) and dataLineas.DDRprecioorig neq 0>
						<cfset LvarPrecio = dataLineas.DDRprecioorig>
					<cfelse>
						<cfset LvarPrecio = 0>
					</cfif>
					<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
					#LvarOBJ_PrecioU.inputNumber("DDRpreciou", LvarPrecio, "1", false, "", "", "calcTotLinea(this,2);cambiaImpuesto(IcodigoCB,0); total(); fm(this,#LvarOBJ_PrecioU.getDecimales()#); actReclamo(0);", "")#
				</td>
				<td>&nbsp;</td>
				<td align="right"><strong>% Impuesto OC:</strong></td>
				<td>&nbsp;&nbsp;			
					<input type="hidden" name="IcodigoOC" id="IcodigoOC" value="<cfif isdefined('rsImpuestoOC') and rsImpuestoOC.recordCount GT 0>#rsImpuestoOC.Icodigo#</cfif>">
					<input type="hidden" name="IporcentajeOC" id="IporcentajeOC" value="<cfif isdefined('rsImpuestoOC') and rsImpuestoOC.recordCount GT 0>#rsImpuestoOC.Iporcentaje#<cfelse>0.00</cfif>">
					<cfif isdefined('rsImpuestoOC') and rsImpuestoOC.recordCount GT 0>
						#rsImpuestoOC.Icodigo# - #LSNumberFormat(rsImpuestoOC.Iporcentaje,9.00)#%
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td nowrap align="right"><strong>% Descuento OC :</strong></td>
				<td>
                	<input name="DOporcdesc" value="#DOporcdesc#" type="hidden">
					&nbsp;&nbsp;#LSNumberFormat(DOporcdesc,9.0000)# </td>
				<td>&nbsp;</td>
				<td align="right"><strong>% Impuesto Factura:</strong></td>
				<td>
					&nbsp;&nbsp;
					<input type="hidden" name="Icodigo" value="">
					<select name="IcodigoCB" onChange="javascript: cambiaImpuesto(this,0); actReclamo(0);">
						<cfloop query="rsImpuestos">
							<option value="#rsImpuestos.Icodigo#~#rsImpuestos.Iporcentaje#" 
							<cfif codIcodFact NEQ '' and trim(codIcodFact) eq trim(rsImpuestos.Icodigo) >
								selected
							</cfif> 
							>#rsImpuestos.Icodigo# - #LSNumberFormat(rsImpuestos.Iporcentaje,9.00)#%</option>						
						</cfloop>
					</select>	
                </td>
			  </tr>  
			  <tr>
				<td align="right"><strong>% Descuento Factura:</strong></td>
				<td>&nbsp;
                  <input type="hidden" name="DDRdescporclin" value="<cfif len(trim(dataLineas.DDRdescporclin)) and dataLineas.DDRdescporclin neq 0>#LSCurrencyFormat(dataLineas.DDRdescporclin,'none')#<cfelse>0.00</cfif>">
                  <input tabindex="2" type="text" name="DDRdescporclin_tmp" id="DDRdescporclin_tmp2"  style="text-align:right" 
					   size="22" maxlength="20" 
					   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} calculaMontoDesc(this); cambiaImpuesto(IcodigoCB,0); actReclamo(0);}" 
					   onFocus="javascript:this.select();" 
					   onChange="javascript: fm(this,4);"
					   onBlur="javascript:fm(this,4);"
					   value="<cfif len(trim(dataLineas.DDRdescporclin)) and dataLineas.DDRdescporclin neq 0>#LSNumberFormat(dataLineas.DDRdescporclin,',9.00')#<cfelse>0.0000</cfif>"></td>
				<td>&nbsp;</td>
				<td align="right" nowrap><strong>Monto Impuesto en Factura:</strong></td>
				<td>
					&nbsp;&nbsp;
					<input  tabindex="6" type="text" name="DDRmtoimpfact" id="DDRmtoimpfact"  style="text-align:right" 
						   size="22" maxlength="20" 
						   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} cambiaImpuesto(IcodigoCB,0); actReclamo(0);}" 
						   onFocus="javascript:this.select();" 
						   onChange="javascript: fm(this,4);"
						   onBlur="javascript:fm(this,4);"
						   value="<cfif len(trim(dataLineas.DDRmtoimpfact))  and dataLineas.DDRmtoimpfact neq 0 >#LSNumberFormat(dataLineas.DDRmtoimpfact,',9.00')#<cfelse>0.00</cfif>"> 										
				</td>
			  </tr>		  
			  <tr>
				<td align="right" nowrap><strong>Monto Descuento Factura: </strong></td>
				<td>&nbsp;&nbsp;
                  <input type="hidden" name="DDRdesclinea" value="<cfif len(trim(dataLineas.DDRdesclinea)) and dataLineas.DDRdesclinea neq 0>#LSCurrencyFormat(dataLineas.DDRdesclinea,'none')#<cfelse>0.00</cfif>">
                  <input tabindex="3" type="text" name="DDRdesclinea_tmp" id="DDRdesclinea_tmp2"  style="text-align:right" 
					   size="22" maxlength="20" 
					   onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} calculaPorcenDesc(this); cambiaImpuesto(IcodigoCB,0); actReclamo(0);}" 
					   onFocus="javascript:this.select();" 
 			           onChange="javascript: fm(this,4);"
					   onBlur="javascript:fm(this,4);"
					   value="<cfif len(trim(dataLineas.DDRdesclinea)) and dataLineas.DDRdesclinea neq 0>#LSNumberFormat(dataLineas.DDRdesclinea,',9.00')#<cfelse>0.0000</cfif>">									</td>
			    <td>&nbsp;</td>
			    <td align="right" id="tdTexRecl"><strong>Reclamo:</strong></td>
			    <td align="left"  id="tdChekRecl">&nbsp;&nbsp;
                  <input disabled type="checkbox" name="DDRgenreclamo" id="DDRgenreclamo" <cfif dataLineas.DDRgenreclamo eq 1>checked </cfif>></td>
			  </tr>  
			  <tr>
				<td align="right"><strong>Total Linea con Descuento :</strong></td>
				<td>&nbsp;&nbsp;
			    <input type="text" name="DDRtotallincd" id="DDRtotallincd"  style="text-align:right; border-width:0;" 
						   size="22" maxlength="20" 
						   value="<cfif len(trim(dataLineas.DDRtotallincd)) and dataLineas.DDRtotallincd neq 0>#LSNumberFormat(dataLineas.DDRtotallincd,',9.00')#<cfelse>0.00</cfif>" readonly ></td>
				<td>&nbsp;</td>
				<td align="right" nowrap><strong>Observaciones Reclamo:</strong></td>
				<td>&nbsp;&nbsp;<input type="hidden" name="DDRobsreclamo" id="DDRobsreclamo" value="#dataLineas.DDRobsreclamo#">
                  <a href="javascript:info_detalle();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> Observaciones"></a>
				</td>
			  </tr>  				  
			  <tr>
				<td align="right">&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="right">&nbsp;</td>
				<td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="right">&nbsp;</td>
				<td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>			  			    		     
			</table>
		</cfif>
		</cfoutput>
	</cfloop>
</cfif>

<script language="javascript" type="text/javascript">
/*////////////////////////////////////////////*/	
			<cfif len(trim(rsForm.EPDid))>	
				funcInactivaCampos(1);				
			</cfif>
			function funcInactivaCampos(parAccion){
				var f = document.form2;	
				var vbAccion = '';
				if (parAccion == 1){
					vbAccion = true;
				}
				else{
					vbAccion = false;
				}
				f['DDRpreciou'].disabled = vbAccion;
				f['DDRdescporclin_tmp'].disabled = vbAccion;
				f['DDRdesclinea_tmp'].disabled = vbAccion;
				f['Ucodigo'].disabled = vbAccion;
				f['DDRtotallincd'].disabled = vbAccion;
				f['DDRcantorigen'].disabled = vbAccion;				
				f['IcodigoCB'].disabled = vbAccion;
				f['DDRmtoimpfact'].disabled = vbAccion;
				f['IcodigoCB'].disabled = vbAccion;					
				f['DDRdesclinea_tmp2'].disabled = vbAccion;
				f['DDRdescporclin_tmp2'].disabled = vbAccion;
				f['DDRdescporclin'].disabled = vbAccion;
				//f['DDRcantrec'].disabled = vbAccion;
			}
/*////////////////////////////////////////////*/	
	
	function validaDet(){		
		var error = false;		
		var mensaje = "Se presentaron los siguientes errores:\n";
		var f = document.form2;		
		var TipoItem = f.tipoItem.value;	
		funcInactivaCampos(0);
		// Validacion del Detalle
		if ( document.form2.DDRpreciou.value == 0){
			error = true;
			mensaje += " - No se permite el precio unitario en factura en cero.\n";
			//document.form2.DDRpreciou.focus();
		}
		if(document.form2.DDRcantorigen.value == 0){
			error = true;
			mensaje += " - No se permite la cantidad en factura en cero.\n";
			//document.form2.DDRcantorigen.focus();
		}
		if(!valida_cantidad(0)){
			return false;
		}
		<cfif rsParametroExcesos.RecordCount gt 0 and rsParametroExcesos.Pvalor eq 1>
			if(TipoItem == "A"){
				if(!valida_cantidadRecibida()){
					return false;
				} 			
			}
		<cfelseif rsParametroExcesos.Pvalor eq 0 >
			if(TipoItem == "A"){
				if(!valida_cantidadRecibidaContraTolerancia()){
					return false;
				}
			}
		</cfif>
		if ( error ){
			alert(mensaje);
			return false;
		}			
		document.form2.DDRgenreclamo.disabled = false;
		
		return true;
	}
					
	function cambiaUnidad(value){
		var f = document.form2;	
		var monedaOC 		= <cfoutput>#dataLineas.Mcodigo#</cfoutput>;
		var monedaEmpresa 	= <cfoutput>#rsEmpresa.Mcodigo#</cfoutput>;		
		var Aid = f['Aid'].value;
		var Ucodigo = trim(f['UcodigoOC'].value);
		var Ucodigoref = trim(f['Ucodigo'].value);
		var existe = false;		
		var factor = 1;

		// solo hace este procesamiento si los codigos de unidad son diferentes 
		if ( Ucodigo != Ucodigoref ){ // codigos de unidad
			// valida primero en conversion
			if ( conversion[Ucodigo] && conversion[Ucodigo][Ucodigoref]){
				existe = true;
				factor = conversion[Ucodigo][Ucodigoref];
			}
			// si no hay dato en conversion, busca en conversiones por articulo
			if (!existe && conversion_art[Aid] && conversion_art[Aid][Ucodigo] && conversion_art[Aid][Ucodigo][Ucodigoref] ){
				existe = true;
				factor = conversion_art[Aid][Ucodigo][Ucodigoref];
			}			
			if ( !existe ){
				f['DDRfactor'].value = 0;
				f['DDRcantorigen'].value = 0;
				fm(f['DDRcantorigen'], 4);
				f['DDRpreciou'].value = 0;
				fm(f['DDRpreciou'], <cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
				f['DDRcantrec'].value = 0;
				fm(f['DDRcantrec'], 4);
			}
			else{
				f['DDRfactor'].value = factor;
				f['DDRcantorigen'].value = parseFloat(qf(f['saldo'].value))*factor;
				fm(f['DDRcantorigen'], 4);
	
				f['DDRcantrec'].value = parseFloat(qf(f['saldo'].value))*factor;
				fm(f['DDRcantrec'], 4);
			}
			f.DDRpreciou.value = '<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>';	
			f.DDRmtoimpfact.value = '0.0000';				
			f.DDRdescporclin_tmp.value = '0.00';
			f.DDRdescporclin.value = '0.00';
			f.DDRdesclinea.value='0.00';
			f.DDRdesclinea_tmp.value='0.00';
			<cfif not len(trim(rsForm.EPDid))>
			f.DDRdesclinea_tmp.disabled=0;
			</cfif>
			alert('Debe digitar el nuevo el precio unitario para la factura');				
			f['DDRpreciou'].focus();	
		}else{
			f['DDRfactor'].value = 1;
			f['DDRcantorigen'].value = f['saldo'].value;
			fm(f['DDRcantorigen'],4);
			f['DDRcantrec'].value = f['saldo'].value;
			fm(f['DDRcantrec'],4);
			f['DDRpreciou'].value = f['DOpreciou'].value;
			fm(f['DDRpreciou'],<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
			existe = true; 
			
			total();
			calcTotLinea(document.form2.DDRpreciou,2);		
			cambiaImpuesto(document.form2.IcodigoCB,<cfoutput>0</cfoutput>);
			actReclamo(0);	
		}	
	}


	function infoDet(){
		open('../consultas/Orden-info.cfm', 'Orden','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=420,left=250, top=200,screenX=250,screenY=200');	
	}

	function info_detalle(){
		var obj = document.form2.DDRgenreclamo;
		if (obj.checked ){
			open('documentos-detalleinfo.cfm', 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
		}
		else
		{
		alert("No hay Documentos de Reclamos, por lo tanto no se pueden ver observaciones");
		}
	}	

	function valida_cantidadRecibida(){
	// La cantidad recibida no puede ser mayor a la cantidad del documento
		var f = document.form2;
		var hide="none";
		var visible="block";
		var TipoItem = f.tipoItem.value;
		var Tolerancia = 0;
		 if(TipoItem == 'A'){var Tolerancia = f.ToleranciaA.value;} 
		
		var ToleranciaInferior = Math.abs((parseFloat(qf(f['DDRcantorigen'].value))-parseFloat(Tolerancia)));
		
		if ( parseFloat(qf(f['DDRcantorigen'].value)) < parseFloat(qf(f['DDRcantrec'].value)) ){
			//alert('La cantidad recibidad no puede ser mayor a la cantidad.');
			f['DDRcantrec'].value = f['DDRcantorigen'].value;
			return false;
		}
		if(TipoItem == 'A'){
			 if ( parseFloat(qf(f['DDRcantrec'].value)) < ToleranciaInferior){
				f['DDRcantrec'].value = ToleranciaInferior;
				 document.getElementById('Legenda').style.display = visible; 
				return false;
			} 
			 document.getElementById('Legenda').style.display = hide; 
		}		
	return true;
	}
	
	function valida_cantidadRecibidaContraTolerancia(){
	// La cantidad recibida no puede superar el numero maximo de tolerancia para excesos, esto aplica 
	//para cantidad superiores o inferiores
		var hide="none";
		var visible="block"; 
		var f = document.form2;
		var TipoItem = f.tipoItem.value;
		var Tolerancia = 0;
		if(TipoItem == 'A'){ var Tolerancia = f.ToleranciaA.value;}
		var ToleranciaSuperior = (parseFloat(qf(f['DDRcantorigen'].value))+parseFloat(Tolerancia));
		var ToleranciaInferior = Math.abs(((parseFloat(qf(f['DDRcantorigen'].value))-parseFloat(Tolerancia))));
	
		if ( parseFloat(qf(f['DDRcantrec'].value)) > ToleranciaSuperior){
			f['DDRcantrec'].value = ToleranciaSuperior;
			document.getElementById('Legenda').style.display = visible;
			return false;
		}
		 if ( parseFloat(qf(f['DDRcantrec'].value)) < Math.abs(ToleranciaInferior)){
			f['DDRcantrec'].value = ToleranciaInferior;
			document.getElementById('Legenda').style.display = visible;
			return false;
		} 
		document.getElementById('Legenda').style.display = hide;
		return true;
	}	
	
	
/*	function generarReclamo(){
		var deshabilitar = true;
		var Band = document.form2.BanderaTolerancia;

		if(document.form2.ArticuloTieneTolerancia.value == 'F' || document.form2.tipoItem.value != 'A' || Band.value == '0'){
			if(hayReclamo())
				deshabilitar = false;

			document.form2.DDRgenreclamo.disabled = deshabilitar;
		}
	}*/
	
	function obtenerFactor(){
		var f = document.form2;

		var Aid = f['Aid'].value;
		var Ucodigo = trim(f['UcodigoOC'].value);
		var Ucodigoref = trim(f['Ucodigo'].value);

		// solo hace este procesamiento si los codigos de unidad son diferentes 
		if ( Ucodigo != Ucodigoref ){ // codigos de unidad
			// valida primero en conversion
			if ( conversion[Ucodigo] && conversion[Ucodigo][Ucodigoref]){
				return conversion[Ucodigo][Ucodigoref];
			}
			// si no hay dato en conversion, busca en conversiones por articulo
			if (conversion_art[Aid] && conversion_art[Aid][Ucodigo] && conversion_art[Aid][Ucodigo][Ucodigoref] ){
				return conversion_art[Aid][Ucodigo][Ucodigoref];
			}
		}
		else{
			return 1
		}
		
		return 0;
	}			
	
	function valida_cantidad(origen){
		// el origen indica de donde se invoco la funcion
		// 1 desde un imput ,  0 desde la validacion antes de summit
		var factor = parseFloat(obtenerFactor());
		var value1 = parseFloat(qf(document.form2.DDRcantorigen.value));
		var value2 = parseFloat(qf(document.form2.saldo.value)) ;
		var value3 = parseFloat(qf(document.form2.Tolerancia.value)) ;
//		document.form2.DDRgenreclamo.disabled = false;
		
		<cfif not len(trim(rsForm.EPDid))>
		cambiaImpuesto(document.form2.IcodigoCB,<cfoutput>0</cfoutput>); 
		</cfif>
		
		if (document.form2.ArticuloTieneTolerancia.value == 'V' 
				&& document.form2.tipoItem.value == 'A' 
				&& value1 > ((value2*factor)+value3 )){
				
			if (factor > 0 ){
				if (origen == 1 ){
					alert('Ha excedido la tolerancia permitida para el artículo seleccionado.');
				}
				document.form2.BanderaTolerancia.value ='1';
				<cfif not len(trim(rsForm.EPDid))>
//					document.form2.DDRgenreclamo.disabled = false;
					document.form2.DDRgenreclamo.checked = true;
				</cfif>
				return true;
			}
			else{
				if (origen == 1 ){
					alert("No se encontro el factor de conversión de la unidad " +  trim(document.form2.UcodigoOC.value) + " a la unidad " + trim(document.form2.Ucodigo.value)+ ".");
				}
				document.form2.DDRfactor.value = 0;
				document.form2.DDRcantorigen.value = 0;
				document.form2.DDRcantrec.value = 0;
				return false;
			}
		}
		else{
			document.form2.BanderaTolerancia.value ='0';
			if(!hayReclamo())
			{
//				document.form2.DDRgenreclamo.disabled = true;
				document.form2.DDRgenreclamo.checked = false;
			}
			return true;
		}
		
		return true;
	}
	
	function actReclamo(paramValida)
	{
		
		if(paramValida == 1)
			if (!document.getElementById) 
					return false;
  			else
				{
					col1 = document.getElementById('tdChekRecl');
					col2 = document.getElementById('tdTexRecl');
					col1.style.display = "";
 					col2.style.display = "";
				}
		else
			if (!document.getElementById)
					return false;
			else	
				{
					col1 = document.getElementById('tdChekRecl');
					col2 = document.getElementById('tdTexRecl');
					col1.style.display = "none";
 					col2.style.display = "none";
				}
	}
	
	<!--- Funcion que calcula un monto de acuerdo al parametro de la forma de calcular el impuesto --->
	function calcularMonto(cantidad, precio, descuento, impuesto)
	{
		var monto = cantidad * precio;
		var montoImpuesto = 0;
			montoImpuesto = (monto * ((100 - descuento) / 100)) * (impuesto / 100);
		return (monto * ((100 - descuento) / 100)) + montoImpuesto;
	}
	
	<!--- Esta funcion devuelve true si hay reclamo debido a que la cantidad recibida es menor a la facturada, o si son iguales pero las condiciones de la orden son mejores que los de la factura --->	
	function hayReclamo()
	{
		var cantFactura = parseFloat(qf(document.form2.DDRcantorigen.value));
		var cantRecibida = parseFloat(qf(document.form2.DDRcantrec.value));
	
		if(cantFactura > cantRecibida)			
			return true;		
		else
		{
			<cfif len(trim(rsForm.EPDid)) gt 0>
				return false;
			<cfelse>
				var precioFactura = parseFloat(qf(document.form2.DDRpreciou.value));
				var precioOrden = parseFloat(qf(document.form2.DOpreciou.value));
				var descuentoFactura = parseFloat(qf(document.form2.DDRdescporclin.value));
				var descuentoOrden = parseFloat(qf(document.form2.DOporcdesc.value));
				var impuestoSeleccionado = document.form2.IcodigoCB.value.split("~");
				var impuestoFactura = parseFloat(qf(impuestoSeleccionado[1]));
				var impuestoOrden = parseFloat(qf(document.form2.IporcentajeOC.value));
				var tipoCambioF = parseFloat(qf(document.form2.TipoCambioF.value));
				var tipoCambioOC = parseFloat(qf(document.form2.TipoCambioOC.value));

				if(document.form2.McodigoF.value != document.form2.McodigoOC.value)
					precioOrden = precioOrden * (tipoCambioOC / tipoCambioF);

				var montoCondicionesFactura = calcularMonto(10, precioFactura, descuentoFactura, impuestoFactura);
				var montoCondicionesOrden = calcularMonto(10, precioOrden, descuentoOrden, impuestoOrden);

				if(cantFactura == cantRecibida && montoCondicionesFactura > montoCondicionesOrden)
					return true;
			</cfif>
		}

		return false;
	}

	function calcTotLinea(obj, opt){
		if(opt == 1){//Desce Cantidad en Factura
			obj.form.DDRtotallin.value = redondear(qf(obj.form.DDRpreciou.value) * qf(obj.value), 2);			
		}else{
			if(opt == 2){//Desce Precio Unitario
				obj.form.DDRtotallin.value = redondear(qf(obj.form.DDRcantorigen.value) * qf(obj.value), 2);
			}
		}
		fm(obj.form.DDRtotallin,2);
		calculaMontoDesc(document.form2.DDRdescporclin);
		//calculaPorcenDesc(document.form2.DDRdesclinea_tmp);
	}

	function calculaPorcenDesc(obj){		
		obj.form.cambioDescuentos.value=1;	
		if(obj.form.DOpreciou.value != '' && qf(obj.form.DOpreciou.value) > 0 && obj.form.DOcantidad.value != '' && qf(obj.form.DOcantidad.value) > 0){
			var porcDesc = 0;
			var totalPagar =  parseFloat(qf(obj.form.DDRtotallin.value));
			var valorMontoDesc =  parseFloat(qf(obj.value));

			if(totalPagar > 0 && ESNUMERO(valorMontoDesc) && valorMontoDesc > 0){
<!---				if(valorMontoDesc <= totalPagar){ --->
					porcDesc = (valorMontoDesc * 100) / totalPagar;
					obj.form.DDRdesclinea.value = valorMontoDesc;
					obj.form.DDRdescporclin.value = porcDesc;
					obj.form.DDRdescporclin_tmp.value = porcDesc;			
					fm(obj.form.DDRdescporclin,4);
					fm(obj.form.DDRdescporclin_tmp,4);
					<cfif not len(trim(rsForm.EPDid))>
					if(obj.disabled == false)
						obj.form.DDRdescporclin_tmp.disabled=1;
					</cfif>
<!---				}else--->				
//				alert('Error, monto del porcentaje inválido, no se permiten montos superiores al total de la linea que es de ' + totalPagar);--->
//					obj.form.DDRdesclinea_tmp.value = '0.0000';
//					obj.form.DDRdesclinea.value = '0.0000';
//					obj.form.DDRdescporclin.value = '0.0000';
//					obj.form.DDRdescporclin_tmp.value = '0.0000';			
//					obj.form.DDRdescporclin_tmp.disabled=0;		
//				}
			}else{
				obj.form.DDRdesclinea.value = '0.0000';
				obj.form.DDRdescporclin.value = '0.0000';
				obj.form.DDRdescporclin_tmp.value = '0.0000';
				<cfif not len(trim(rsForm.EPDid))>
				obj.form.DDRdescporclin_tmp.disabled=0;
				</cfif>
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
					<cfif not len(trim(rsForm.EPDid))>
					obj.form.DDRdesclinea_tmp.disabled=1;
					</cfif>
				}else{
					alert('Error, porcentaje inválido, no se permiten montos superiores a 100');
					obj.form.DDRdescporclin_tmp.value = '0.00';
					obj.form.DDRdescporclin.value = '0.00';
					obj.form.DDRdesclinea.value='0.00';
					obj.form.DDRdesclinea_tmp.value='0.00';
					<cfif not len(trim(rsForm.EPDid))>
					obj.form.DDRdesclinea_tmp.disabled=0;
					</cfif>
				}
			}else{
				obj.form.DDRdescporclin.value = '0.00';
				obj.form.DDRdesclinea.value='0.00';
				obj.form.DDRdesclinea_tmp.value='0.00';
				<cfif not len(trim(rsForm.EPDid))>
				obj.form.DDRdesclinea_tmp.disabled=0;
				</cfif>
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
		fm(document.form2.DDRtotallincd,4);
	}
	
	function total(){
		var value1 = parseFloat(qf(document.form2.DDRcantorigen.value));
		var value2 = parseFloat(qf(document.form2.DDRpreciou.value));
		
		document.form2.DDRtotallin.value = redondear(value1*value2,2)
		document.form2.DDRtotallin.value = fm(document.form2.DDRtotallin.value,2)
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
			
			fm(document.form2.DDRmtoimpfact,4);
		}
	}

	function actualizaBanderaTolerancia()
	{
		var factor = parseFloat(obtenerFactor());
		var value1 = parseFloat(qf(document.form2.DDRcantorigen.value));
		var value2 = parseFloat(qf(document.form2.saldo.value)) ;
		var value3 = parseFloat(qf(document.form2.Tolerancia.value)) ;
		
		if (document.form2.ArticuloTieneTolerancia.value == 'V' && document.form2.tipoItem.value == 'A' && value1 > ((value2*factor)+value3 ))
		{
			if (factor > 0 )
			{
				document.form2.BanderaTolerancia.value ='1';
			}
		}
		else
		{
			document.form2.BanderaTolerancia.value ='0';
		}
	}
	
	actualizaBanderaTolerancia();
	total();
	calcTotLinea(document.form2.DDRpreciou,<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
	<cfif not len(trim(rsForm.EPDid))>
	cambiaImpuesto(document.form2.IcodigoCB,<cfoutput>0</cfoutput>);
	</cfif>
	actReclamo(1);
	<cfif modo neq 'ALTA' and len(trim(rsForm.EPDid))>
		//SOLO CUANDO TIENE POLIZA, al cargar los datos 
		valida_cantidad(1);
	</cfif>
</script>		

<cffunction name="ObtieneTolerancia" returntype="numeric" access="private">
	<cfargument name="Aid" type="string" required="yes">
    
    <cfquery name="rsTolerancia" datasource="#session.DSN#">
        select coalesce(Ctolerancia,0) as Ctolerancia
        from  Clasificaciones  A , Articulos B
        where  A.Ecodigo = B.Ecodigo
        	and A.Ccodigo = B.Ccodigo
        	and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
        </cfquery>
        <cfset LvarTolerancia = 0>
        <cfif rsTolerancia.Ctolerancia gt 0>
	        <cfset LvarTolerancia = rsTolerancia.Ctolerancia>
        </cfif>
	<cfreturn LvarTolerancia>
</cffunction>
