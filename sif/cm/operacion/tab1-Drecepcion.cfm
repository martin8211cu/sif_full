<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined('dataLineas') and dataLineas.recordCount GT 0 and isdefined('form.DOlinea') and form.DOlinea NEQ ''>
<!--- 	<cfquery name="detLinea" dbtype="query">
		select EOnumero,DOconsecutivo,Aid,Cid,DOdescripcion,DOcantidad
			,DDRcantrec,saldo,UcodigoOC,descUnidad,Ucodigo,DDRcantorigen
			,codArtServ,descrArtServ,DDRpreciou,DDRprecioorig,DDRgenreclamo

			,DOobservaciones,DOalterna,DDRcantordenconv,DDRobsreclamo
			, numparte
		from dataLineas
		where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
	</cfquery>
</cfif>

<cfif isdefined('detLinea') and detLinea.recordCount GT 0>--->
<cfset detLinea=dataLineas>
	<cfoutput query="detLinea"><cfif detLinea.DOlinea EQ form.DOlinea>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="24%" nowrap align="right"><strong>N&uacute;mero de Orden:</strong></td>
			<td width="35%">&nbsp;&nbsp;&nbsp;#EOnumero#</td>
			<td width="1%">&nbsp;</td>
			<td width="22%" align="right"><strong>Saldo OC: </strong></td>
			<td width="18%">
				&nbsp;&nbsp;
				<input tabindex="1" type="text" name="saldo" id="saldo"  style="text-align:right; border-width:0;" 
					   size="22" maxlength="20" 
					   value="<cfif len(trim(detLinea.saldo)) >#LSNumberFormat(detLinea.saldo,',9.00')#<cfelse>0.00</cfif>" readonly >
				</td>
		  </tr>
		  <tr>
			<td align="right"><strong>L&iacute;nea:</strong></td>
			<td>&nbsp;&nbsp;&nbsp;#DOconsecutivo#</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Unidad OC:</strong></td>
			<td>
				<input name="DDRfactor" value="1" type="hidden">
				<input type="hidden" name="UcodigoOC" value="#UcodigoOC#">
				&nbsp;&nbsp;&nbsp;#UcodigoOC#
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right"><strong>Codigo Articulo/Servicio: </strong></td>
			<td>&nbsp;&nbsp;&nbsp;#codArtServ#</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Unidad Recepci&oacute;n: </strong></td>
			<td>&nbsp;&nbsp;
				<select name="Ucodigo" onChange="cambiaUnidad(this.value)" >
					<cfloop query="rsUnidades">
						<option value="#rsUnidades.Ucodigo#" <cfif trim(detLinea.UcodigoOC) eq trim(rsUnidades.Ucodigo) >selected</cfif> >#rsUnidades.Ucodigo#</option>
					</cfloop>
				</select>	
			</td>
		  </tr>
		  <tr>
			<td align="right"><strong>Cantidad OC:</strong></td>
			<td>
				<input type="hidden" name="Aid" value="#Aid#">
				<input type="hidden" name="DOcantidad" value="#DOcantidad#">
				&nbsp;&nbsp;&nbsp;#DOcantidad#
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Cantidad Factura: </strong></td>
			<td>&nbsp;&nbsp;
				<input type="text" name="DDRcantorigen" id="DDRcantorigen"  style="text-align:right" 
				   size="12" maxlength="12" 
				   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}calcTotLinea(this,1);}" 
				   onFocus="javascript:this.select();" 
				   onChange="javascript: fm(this,2);"
				   value="<cfif len(trim(detLinea.DDRcantorigen)) and detLinea.DDRcantorigen neq 0>#LSNumberFormat(detLinea.DDRcantorigen,',9.00')#<cfelseif len(trim(detLinea.saldo)) >#LSNumberFormat(detLinea.saldo,',9.00')#<cfelse>0.00</cfif>"
				   onblur="valida_cantidadRecibida(); generarReclamo(); valida_cantidad(); total(); fm(this,2); actReclamo();">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right"><strong>Cantidad Recibida en Unidad OC: </strong></td>
			<td>
				&nbsp;&nbsp;&nbsp;
				#DDRcantordenconv#
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Cantidad recibida: </strong></td>
			<td>&nbsp;&nbsp;
				<input tabindex="1" type="text" name="DDRcantrec" id="DDRcantrec"  style="text-align:right" 
					   size="12" maxlength="12" 
					   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					   onFocus="javascript:this.select();" 
					   onChange="javascript: fm(this,2);"
					   value="<cfif len(trim(detLinea.DDRcantrec))  and detLinea.DDRcantrec neq 0 >#LSNumberFormat(detLinea.DDRcantrec,',9.00')#<cfelseif len(trim(detLinea.saldo)) >#LSNumberFormat(detLinea.saldo,',9.00')#<cfelse>0.00</cfif>"
					   onblur="valida_cantidadRecibida(); generarReclamo();  total(); fm(this,2); actReclamo();"> 
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right"><strong>Descripci&oacute;n Alterna/Observaciones:</strong></td>
			<td>
				&nbsp;&nbsp;&nbsp;
				<input type="hidden" name="DOobservaciones" value="#Trim(detLinea.DOobservaciones)#">
				<input type="hidden" name="DOalterna" value="#Trim(detLinea.DOalterna)#">
				<a href="javascript: infoDet();"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>	
			</td>
			<td>&nbsp;</td>
			<td align="right"><strong>Reclamo:</strong></td>
			<td>&nbsp;&nbsp;
				<input type="checkbox" name="DDRgenreclamo" id="DDRgenreclamo" <cfif detLinea.DDRgenreclamo eq 1>checked</cfif>  >
				<!--- 
					<cfif (detLinea.DDRcantrec gte detLinea.DDRcantorigen) and (detLinea.DDRprecioorig gte detLinea.DDRpreciou) >disabled</cfif> 
					
				
				--->
			</td>
		  </tr>  
		  <tr>
			<td align="right"><strong>N&uacute;mero de Parte:</strong></td>
			<td>#detLinea.numparte#</td>
			<td>&nbsp;</td>
			<td align="right" nowrap><strong>Observaciones Reclamo: </strong></td>
			<td>&nbsp;&nbsp;
				<input type="hidden" name="DDRobsreclamo" id="DDRobsreclamo" value="#detLinea.DDRobsreclamo#">
				<a href="javascript:info_detalle();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> Observaciones"></a>			
			</td>
		  </tr>		  
		  <tr>
			<td align="right" nowrap><strong>Descripci&oacute;n:</strong></td>
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
	</cfif></cfoutput>
</cfif>

<script language="javascript" type="text/javascript">
	function cambiaUnidad(value){
		var f = document.form2;	

		var monedaOC 		= <cfoutput>#detLinea.Mcodigo#</cfoutput>;
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
				fm(f['DDRcantorigen'], 2);
				f['DDRpreciou'].value = 0;
				fm(f['DDRpreciou'], <cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
				f['DDRcantrec'].value = 0;
				fm(f['DDRcantrec'], 4);
			}
			else{
				f['DDRfactor'].value = factor;
				f['DDRcantorigen'].value = parseFloat(qf(f['saldo'].value))*factor;
				fm(f['DDRcantorigen'], 2);
	
				f['DDRcantrec'].value = parseFloat(qf(f['saldo'].value))*factor;
				fm(f['DDRcantrec'], 2);
				f['DDRpreciou'].value = parseFloat(qf(f['DOpreciou'].value))*factor;
				
				//Se realiza la conversi[on de monedas de acuerdo al tipo de cambio del encabezado del documento de recepcion
				if(monedaOC != document.form1.Mcodigo.value){
					if(monedaOC != monedaEmpresa){
						f['DDRpreciou'].value * parseFloat(qf(document.form1.EDRtc.value));
					}else{
						f['DDRpreciou'].value / parseFloat(qf(document.form1.EDRtc.value));
					}
				}
				
				fm(f['DDRpreciou'], <cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);	
			}
		}
		else{
			f['DDRfactor'].value = 1;
			f['DDRcantorigen'].value = f['saldo'].value;
			fm(f['DDRcantorigen'],2);
			f['DDRcantrec'].value = f['saldo'].value;
			fm(f['DDRcantrec'],2);
			f['DDRpreciou'].value = f['DOpreciou'].value;
			fm(f['DDRpreciou'],<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
			existe = true; 
		}

		f['DDRcantorigen'].focus();
	}

	function infoDet(){
		open('../consultas/Orden-info.cfm', 'Orden','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=420,left=250, top=200,screenX=250,screenY=200');	
	}

	function info_detalle(){
		var obj = document.getElementById("DDRgenreclamo");
		if ( !obj.disabled && obj.checked ){
			open('documentos-detalleinfo.cfm', 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
		}
	}	

	function valida_cantidadRecibida(){
	// La cantidad recibida no puede ser mayor a la cantidad del documento
		var f = document.form2;
		if ( parseFloat(qf(f['DDRcantorigen'].value)) < parseFloat(qf(f['DDRcantrec'].value)) ){
			//alert('La cantidad recibidad no puede ser mayor a la cantidad.');
			f['DDRcantrec'].value = f['DDRcantorigen'].value;
		}
	}	
	function generarReclamo(){
		var deshabilitar = true;
		var cantrec = document.getElementById("DDRcantrec");
		var cantori = document.getElementById("DDRcantorigen");

		var preciouOC = document.getElementById("DOpreciou");
		var precio    = document.getElementById("DDRpreciou");

		if ( parseFloat(qf(preciouOC.value)) < parseFloat(qf(precio.value)) ){
			deshabilitar = false;
		}

		if ( parseFloat(qf(cantrec.value)) < parseFloat(qf(cantori.value)) ){
			deshabilitar = false;
		}

		document.getElementById("DDRgenreclamo").disabled = deshabilitar;
	}	
	
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
	
	function valida_cantidad(){
		var factor = parseFloat(obtenerFactor());
		var value1 = parseFloat(qf(document.getElementById("DDRcantorigen").value));
		var value2 = parseFloat(qf(document.getElementById("saldo").value)) ;
		
		if ( value1 > (value2*factor) ){
			if (factor > 0 ){
				alert('La cantidad del Documento es mayor al saldo de la Orden de Compra.');
				document.getElementById("DDRfactor").value = 1;
				document.getElementById("DDRcantorigen").value = value2;
				document.getElementById("DDRcantrec").value = value2;
				document.getElementById("DDRcantorigen").focus();
				//document.getElementById("Ucodigo_"+i).value = document.getElementById("UcodigoOC_"+i).value;
			}
			else{
				alert("No de encontro el factor de conversión de la unidad " +  trim(document.getElementById("UcodigoOC").value) + " a la unidad " + trim(document.getElementById("Ucodigo").value)+ ".");
				document.getElementById("DDRfactor").value = 0;
				document.getElementById("DDRcantorigen").value = 0;
				document.getElementById("DDRcantrec").value = 0;
				document.getElementById("DDRcantorigen").focus();
			}
		}
	}
	
	function actReclamo(){
		var cant1 = parseFloat(qf(document.form2.DDRcantrec.value));
		var cant2 = parseFloat(qf(document.form2.DDRcantorigen.value));
		var salir = false;
		document.form2.DDRgenreclamo.disabled = true;
		document.form2.DDRgenreclamo.checked = false;
		
		if(salir == false && ((cant1 < cant2) || (cant1 > cant2))){
			document.form2.DDRgenreclamo.disabled = false;
			document.form2.DDRgenreclamo.checked = true;			
			salir = true;
		}
		
		cant1 = parseFloat(qf(document.form2.DDRpreciou.value));
		cant2 = parseFloat(qf(document.form2.DOpreciou.value));		
		if(salir == false && ((cant1 - cant2) > 0)){
			document.form2.DDRgenreclamo.disabled = false;
			document.form2.DDRgenreclamo.checked = true;			
			salir = true;
		}
		
		cant1 = document.form2.Icodigo.value;
		cant2 = document.form2.IcodigoOC.value;
		if(salir == false && cant1 != cant2){
			document.form2.DDRgenreclamo.disabled = false;
			document.form2.DDRgenreclamo.checked = true;			
			salir = true;
		}			
	}
</script>
