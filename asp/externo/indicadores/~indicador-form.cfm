<cfset modo = 'ALTA'>
<cfset uv_list = "sum,first,last,avg,wavg,max,min">
<cfset uvd_list = "Suma,Primer valor,Último valor,Promedio,Promedio ponderado,Valor máximo,Valor mínimo">

<cfif isdefined("form.indicador")>
	<cfset modo = 'CAMBIO' >
	
	<cfquery name="data" datasource="asp">
		select 	indicador, 
				nombre_indicador, 
				SScodigo, 
				SMcodigo, 
				es_corporativo, 
				es_graficable, 
				es_default,
				es_diario,
				limite_rojo_sup, 
				limite_amarillo_sup, 
				limite_amarillo_inf, 
				limite_rojo_inferior, 
				formato, 
				calculo, 
				cfm_detalle,
				descripcion_funcional,
				posicion,
				publicado,
				observaciones,
				filtro_tiempo,
				filtro_of,
				filtro_depto,
				filtro_cf,
				ts_rversion,
				unidad_medida,
				desc_valor,
				desc_total,
				desc_peso_valor,
				desc_peso_total,
				uso_valor,
				uso_total
		from Indicador
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
	</cfquery>
</cfif>

<script type="text/javascript" language="javascript1.2" src="../menu/utilesMonto.js"></script>
<script type="text/javascript" language="javascript1.2">
	function change_sistema(obj, form ){
		combo = form.SMcodigo;
		combo.length = 0;

		var cont = 0;

		combo.length = cont+1;
		combo.options[cont].value = '';
		combo.options[cont].text = '- seleccionar -';	
		cont = 1;
		
		<cfloop query="rsModulos">
		if ( obj.value == '<cfoutput>#Trim(rsModulos.SScodigo)#</cfoutput>' ) {
			combo.length = cont+1;
			combo.options[cont].value = '<cfoutput>#Trim(rsModulos.SMcodigo)#</cfoutput>';
			combo.options[cont].text = '<cfoutput>#Trim(rsModulos.SMcodigo)# - #rsModulos.SMdescripcion#</cfoutput>';	
			
			<cfif modo neq 'ALTA' and trim(data.SMcodigo) eq trim(rsModulos.SMcodigo) >
				combo.options[cont].selected = true;
			</cfif>
			cont = cont + 1;
		}
		</cfloop>
	}
	
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}

	function conlisFiles(objeto){
		closePopup();
		window.gPopupWindow = window.open('files.cfm?p='+escape(document.form1.calculo.value)+'&objeto='+objeto,'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}

	function conlisFilesSelect(objeto,filename){

		document.form1[objeto].value = filename;
		closePopup();
		window.focus();
		document.form1[objeto].focus();
	}
	
	// ===========================================================================================
	//								Conlis de Indicadores
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	/*	
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  */
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("conlisIndicadores.cfm",250,200,650,400);
	}
	// ===========================================================================================
	
	function validar(form){
		var error = false;
		var mensaje = 'Se presentaron los siguientes errores:\n';
		
		if ( trim(form.indicador.value) == '' ){
			error = true;
			mensaje += ' - El campo Indicador es requerido.\n'
		}

		if ( trim(form.nombre_indicador.value) == '' ){
			error = true;
			mensaje += ' - El campo Nombre es requerido.\n'
		}

		if ( trim(form.SScodigo.value) == '' ){
			error = true;
			mensaje += ' - El campo Sistema es requerido.\n'
		}

		if ( trim(form.SMcodigo.value) == '' ){
			error = true;
			mensaje += ' - El campo Módulo es requerido.\n'
		}

		if ( trim(form.limite_rojo_sup.value) == '' ){
			error = true;
			mensaje += ' - El campo Límite Rojo superior es requerido.\n'
		}

		if ( trim(form.limite_amarillo_sup.value) == '' ){
			error = true;
			mensaje += ' - El campo Límite Amarillo superior es requerido.\n'
		}

		if ( trim(form.limite_amarillo_inf.value) == '' ){
			error = true;
			mensaje += ' - El campo Límite Amarillo inferior es requerido.\n'
		}

		if ( trim(form.limite_rojo_inferior.value) == '' ){
			error = true;
			mensaje += ' - El campo Límite Rojo inferior es requerido.\n'
		}
		
		if ( trim(form.calculo.value) == '' ){
			error = true;
			mensaje += ' - El campo Script Cálculo es requerido.\n'
		}

		if ( error ){
			alert(mensaje);
		}
		
		return !error;
		
	}
</script> 

<cfoutput>
<form name="form1" method="post" action="indicador-sql.cfm" onSubmit="return validar(this);" >
	<table width="100%" cellpadding="1" cellspacing="1" border="0">
		<tr>
			<td>Indicador:&nbsp;</td>
			<td colspan="3">
				<input type="text" name="indicador" size="20" maxlength="20" value="<cfif modo neq 'ALTA'>#trim(data.indicador)#</cfif>" onfocus="this.select();" >
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="_indicador" value="#trim(data.indicador)#" >
				</cfif>
			</td>
		</tr>

		<tr>
			<td>Nombre:&nbsp;</td>
			<td colspan="3"><input type="text" name="nombre_indicador" size="60" maxlength="120" value="<cfif modo neq 'ALTA'>#data.nombre_indicador#</cfif>" onfocus="this.select();"></td>
		</tr>
		
		<tr>
			<td nowrap valign="top">Descripci&oacute;n:&nbsp;<br>(Funcional)</td>
			<td colspan="3"><textarea  name="descripcion_funcional" cols="49" rows="4"  style="font-family:Arial, Helvetica, sans-serif;" onFocus="this.select();"><cfif modo neq 'ALTA'>#trim(data.descripcion_funcional)#</cfif></textarea></td>
		</tr>
	
		<tr>
			<td valign="top">Sistema</td>
			<td valign="top" colspan="3">
				<select name="SScodigo" onChange="javascript:change_sistema(this, document.form1);">
					<option value="" >- seleccionar -</option>
					<cfloop query="rsSistemas">
						<option value="#Trim(rsSistemas.SScodigo)#" <cfif modo neq 'ALTA' and trim(data.SScodigo) eq trim(rsSistemas.SScodigo)>selected</cfif> >#rsSistemas.SScodigo# - #rsSistemas.SSdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		
		<tr>
			<td valign="top">Módulo</td>
			<td valign="top" colspan="3">
				<select name="SMcodigo" >
				<option value="" >- seleccionar -</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td></td>
			<td colspan="3">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1"><input type="checkbox" name="es_corporativo" <cfif modo neq 'ALTA' and data.es_corporativo eq 1>checked</cfif> ></td>
						<td valign="middle">Corporativo</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td></td>
			<td colspan="3">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1"><input type="checkbox" name="es_graficable" id="es_graficable" <cfif modo neq 'ALTA' and data.es_graficable eq 1>checked</cfif> ></td>
						<td valign="middle"><label for="es_graficable">Graficable</label></td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td></td>
			<td colspan="3">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1"><input type="checkbox" name="es_default"  id="es_default" <cfif modo neq 'ALTA' and data.es_default eq 1>checked</cfif> ></td>
						<td valign="middle"><label for="es_default">Predeterminado</label></td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td></td>
			<td colspan="3">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1" valign="top"><input type="checkbox" name="es_diario" id="es_diario" <cfif modo neq 'ALTA' and data.es_diario eq 1>checked</cfif> ></td>
						<td valign="middle"><label for="es_diario"><strong>Diario.</strong> Un indicador diario, al consultarse, suma todos los valores y los totales para obtener la relaci&oacute;n, mientras que un indicador no-diario compara la suma de los valores contra el total.</label></td>
					</tr>
				</table>
			</td>
		</tr>

		<tr>
			<td></td>
			<td colspan="3">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1"><input type="checkbox" name="publicado" <cfif modo neq 'ALTA' and data.publicado eq 1>checked</cfif> ></td>
						<td valign="middle">Publicado</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td nowrap>L&iacute;mite Rojo superior:&nbsp;</td>
			<td><input type="text" name="limite_rojo_sup" value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(data.limite_rojo_sup, 'none')#<cfelse>0.00</cfif>" tabindex="1" size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
			<td nowrap width="1%">L&iacute;mite Rojo inferior:&nbsp;</td>
			<td><input type="text" name="limite_rojo_inferior" value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(data.limite_rojo_inferior, 'none')#<cfelse>0.00</cfif>" tabindex="1" size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr>

		<tr>
			<td nowrap>L&iacute;mite Amarillo superior:&nbsp;</td>
			<td><input type="text" name="limite_amarillo_sup" value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(data.limite_amarillo_sup, 'none')#<cfelse>0.00</cfif>" tabindex="1" size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
			<td nowrap width="1%">L&iacute;mite Amarillo inferior:&nbsp;</td>
			<td><input type="text" name="limite_amarillo_inf" value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(data.limite_amarillo_inf, 'none')#<cfelse>0.00</cfif>" tabindex="1" size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr>

		<tr>
			<td>Formato:&nbsp;</td>
			<td colspan="3">
				<select name="formato">
					<option value="$" <cfif modo neq 'ALTA' and data.formato eq '$'>selected</cfif> >D&oacute;lares</option>
					<option value="%" <cfif modo neq 'ALTA' and data.formato eq '%'>selected</cfif> >Porcentaje</option>
					<option value="N" <cfif modo neq 'ALTA' and data.formato eq 'N'>selected</cfif> >Num&eacute;rico</option>
					<option value="F" <cfif modo neq 'ALTA' and data.formato eq 'F'>selected</cfif> >Factor</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td nowrap>Script para C&aacute;lculo:&nbsp;</td>
			<td colspan="3" nowrap>
				<input name="calculo" onBlur="pagina(this)" type="text" id="calculo" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(data.calculo)#</cfif>" size="40" maxlength="255" >
                <a href="javascript:conlisFiles('calculo')"><img src="foldericon.gif" width="16" height="16" border="0"></a><br>* Este script debe ser un componente (extension .cfc).
			</td>
		</tr>

		<tr>
			<td nowrap>P&aacute;gina cfm:&nbsp;</td>
			<td colspan="3" nowrap>
				<input name="cfm_detalle" onBlur="pagina(this)" type="text" id="cfm_detalle" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(data.cfm_detalle)#</cfif>" size="40" maxlength="255" >
                <a href="javascript:conlisFiles('cfm_detalle')"><img src="foldericon.gif" width="16" height="16" border="0"></a>
			</td>
		</tr>

		<tr>
			<td nowrap>Filtro por Tiempo:&nbsp;</td>
			<td colspan="3">
				<select name="filtro_tiempo">
					<option value="" >- seleccionar -</option>
					<option value="1" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 1>selected</cfif> >Mes vs Mes anterior</option>
					<option value="2" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 2>selected</cfif>>Mes vs Acumulado mes anterior</option>
					<option value="3" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 3>selected</cfif>>Mes vs Mes a&ntilde;o anterior</option>
					<option value="4" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 4>selected</cfif> >Mes vs Acumulado mes a&ntilde;o anterior</option>
					<option value="5" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 5>selected</cfif>>A&ntilde;o vs Acumulado a&ntilde;o anterior</option>
					<option value="6" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 6>selected</cfif>>D&iacute;a 1 vs D&iacute;a 2</option>
					<option value="7" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 7>selected</cfif> >Mes actual</option>
					<option value="8" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 8>selected</cfif>>Mes anterior</option>
					<option value="9" <cfif modo neq 'ALTA' and data.filtro_tiempo eq 9>selected</cfif>>Acumulado mes actual</option>
				</select>				
			</td>
		</tr>

		<tr>
			<td nowrap>Filtro por Oficina:&nbsp;</td>
			<td colspan="3">
				<select name="filtro_of">
					<option value="N" <cfif modo neq 'ALTA' and data.filtro_of eq 'N'>selected</cfif> >No Aplica</option>
					<option value="S" <cfif modo neq 'ALTA' and data.filtro_of eq 'S'>selected</cfif>>Seleccionar</option>
					<option value="F" <cfif modo neq 'ALTA' and data.filtro_of eq 'F'>selected</cfif>>Tomar el asignado al usuario</option>
				</select>				
			</td>
		</tr>

		<tr>
			<td nowrap>Filtro por Departamento:&nbsp;</td>
			<td colspan="3">
				<select name="filtro_depto">
					<option value="N" <cfif modo neq 'ALTA' and data.filtro_depto eq 'N'>selected</cfif>>No Aplica</option>
					<option value="S" <cfif modo neq 'ALTA' and data.filtro_depto eq 'S'>selected</cfif>>Seleccionar</option>
					<option value="F" <cfif modo neq 'ALTA' and data.filtro_depto eq 'F'>selected</cfif>>Tomar el asignado al usuario</option>
				</select>				
			</td>
		</tr>

		<tr>
			<td nowrap>Filtro por Centro Funcional:&nbsp;</td>
			<td colspan="3">
				<select name="filtro_cf">
					<option value="N" <cfif modo neq 'ALTA' and data.filtro_cf eq 'N'>selected</cfif>>No Aplica</option>
					<option value="S" <cfif modo neq 'ALTA' and data.filtro_cf eq 'S'>selected</cfif>>Seleccionar</option>
					<option value="F" <cfif modo neq 'ALTA' and data.filtro_cf eq 'F'>selected</cfif>>Tomar el asignado al usuario</option>
				</select>				
			</td>
		</tr>

		<tr>
			<td nowrap>Posici&oacute;n:&nbsp;</td>
			<td colspan="3"><input type="text" name="posicion" value="<cfif modo NEQ 'ALTA'>#data.posicion#</cfif>" tabindex="1" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr>
		
		<tr>
		  <td nowrap>Unidad de medida</td>
		  <td colspan="3"><input type="text" name="unidad_medida" value="<cfif modo NEQ 'ALTA'>#data.unidad_medida#</cfif>" tabindex="1" size="40" maxlength="30" onFocus="this.select();"  ></td>
	  </tr>
		<tr>
		  <td nowrap>Descripci&oacute;n de la columna 'valor' </td>
		  <td colspan="3"><input type="text" name="desc_valor" value="<cfif modo NEQ 'ALTA'>#data.desc_valor#</cfif>" tabindex="1" size="40" maxlength="30" onFocus="this.select();"   ></td>
	  </tr>
		<tr>
		  <td nowrap>Descripci&oacute;n de la columna 'total' </td>
		  <td colspan="3"><input type="text" name="desc_total" value="<cfif modo NEQ 'ALTA'>#data.desc_total#</cfif>" tabindex="1" size="40" maxlength="30" onFocus="this.select();"  ></td>
	  </tr>
		<tr>
		  <td nowrap>Descripci&oacute;n de la columna 'peso_valor' </td>
		  <td colspan="3"><input type="text" name="desc_peso_valor" value="<cfif modo NEQ 'ALTA'>#data.desc_peso_valor#</cfif>" tabindex="1" size="40" maxlength="30" onFocus="this.select();"  ></td>
	  </tr>
		<tr>
		  <td nowrap>Descripci&oacute;n de la columna 'peso_total' </td>
		  <td colspan="3"><input type="text" name="desc_peso_total" value="<cfif modo NEQ 'ALTA'>#data.desc_peso_total#</cfif>" tabindex="1" size="40" maxlength="30" onFocus="this.select();"  ></td>
	  </tr>
		<tr>
		  <td nowrap>Uso del valor </td>
		  <td colspan="3">
		  <select name="uso_valor">
		  <cfloop from="1" to="#ListLen(uv_list)#" index="i">
		  <option value="#ListGetAt(uv_list,i)#" <cfif modo NEQ 'ALTA' and Trim(data.uso_valor) is Trim(ListGetAt(uv_list,i))>selected</cfif>>#HTMLEditFormat(ListGetAt(uvd_list,i))#</option>
		  </cfloop>
		  </select>
		  </td>
	  </tr>
		<tr>
		  <td nowrap>Uso del total </td>
		  <td colspan="3">
		  <select name="uso_total">
		  <cfloop from="1" to="#ListLen(uv_list)#" index="i">
		  <option value="#ListGetAt(uv_list,i)#" <cfif modo NEQ 'ALTA' and Trim(data.uso_total) is Trim(ListGetAt(uv_list,i))>selected</cfif>>#HTMLEditFormat(ListGetAt(uvd_list,i))#</option>
		  </cfloop>
		  </select></td>
	  </tr>
		<tr>
			<td nowrap valign="top">Observaciones:&nbsp;<br>(Internas)</td>
			<td colspan="3"><textarea  name="observaciones" cols="49" rows="6"  style="font-family:Arial, Helvetica, sans-serif;"  onFocus="this.select();"><cfif modo neq 'ALTA'>#trim(data.observaciones)#</cfif></textarea></td>
		</tr>
		
		<tr>
			<td colspan="4" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="btnAgregar" value="Agregar">
				<cfelse>
					<input type="submit" name="btnModificar" value="Modificar" onClick="if (trim(this.form.indicador.value ) != trim(this.form._indicador.value) ) {return confirm('Va a modificar el código de Indicador.\n Desea continuar?');}">
					<input type="submit" name="btnEliminar" value="Eliminar" onClick="return confirm('Va a eliminar el Indicador y sus datos usuarios relacionados.\n Desea continuar?');">
					<input type="submit" name="btnNuevo" value="Nuevo">
				</cfif>
			</td>
		</tr>
	
	</table>
	
	<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo))>
		<input type="hidden" name="fSScodigo" value="#form.fSScodigo#">
	</cfif>

	<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo))>
		<input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#">
	</cfif>
</form>

</cfoutput>

<script type="text/javascript" language="javascript1.2">
	// sistemas/modulos del mantenimiento
	change_sistema(document.form1.SScodigo, document.form1);

	function pagina(obj){
		obj.value = obj.value.
				replace(/\\/g, '/').
				replace(/^https?:\/\/([A-Za-z0-9._]+)(:[0-9]{1,5})?/,'').
				replace(/^\/cfmx/, '').
				replace(/^[A-Za-z]:/,'');
		if (trim(obj.value) != '' && obj.value.charAt(0) != '/') {
			obj.value = "/" + obj.value;
		}
	}
</script> 
