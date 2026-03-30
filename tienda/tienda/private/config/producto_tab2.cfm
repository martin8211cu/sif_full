<cfquery name="rs_presentacion" datasource="#Session.DSN#">
	select *
	from Presentacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_producto#" null="#Len(url.id_producto) Is 0#">
	order by upper(nombre_presentacion) asc
</cfquery>

<table width="800" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
  <tr>
    <td width="5">&nbsp;</td>
    <td width="777">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="left"><strong>Mostrar en website </strong>: Si esta activado, muestra el producto o sus presentaciones en la tienda virtual</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="left"><strong>Sincroniza</strong>: Si esta activado y el precio del producto cambia, actualiza de manera proporcional el precio de la presentaci&oacute;n del producto.</td>
  </tr>
  <cfif modo neq 'ALTA'>
    <tr>
      <td>&nbsp;</td>
      <td align="left"><strong>Para eliminar presentaciones</strong>: Haga clic en la &quot;X&quot; de la columna Eliminar </td>
    </tr>
  </cfif>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<table width="800" border="0" cellspacing="0">
  <tr align="center" valign="top" class="tituloListas">
    <td width="1%">&nbsp;</td>
    <cfif modo neq 'ALTA'>
      <td width="1%">Eliminar</td>
    </cfif>
    <td width="10%">SKU</td>
    <td width="10%">Presentaci&oacute;n</td>
    <td width="10%">Unidades</td>
    <td width="10%">Precio (<cfoutput>#moneda.moneda#</cfoutput>)</td>
    <td width="5%" nowrap>Sincroniza</td>
    <td width="30%">Caracter&iacute;sticas</td>
    <td width="5%">Mostrar en website </td>
  </tr>
  <cfset next_row = 1>
  <cfif modo EQ "CAMBIO">
    <cfoutput query="rs_presentacion">
      <tr align="center" valign="top" id="newrow_#CurrentRow#">
        <td nowrap> <b>#CurrentRow#</b> </td>
        <td nowrap> <a href="##" onClick="DeleteRow(#CurrentRow#);">[X]</a>
        <input type="hidden" id="chkEliminar_#CurrentRow#" name="chkEliminar_#rs_presentacion.id_presentacion#" value=""></td>
        <td>
          <input name="id_presentacion_#CurrentRow#" type="hidden" value="#rs_presentacion.id_presentacion#">
          <input name="sku_#CurrentRow#" type="text" class="flat" tabindex="8" onFocus="select()" value="#rs_presentacion.sku#" size="10" maxlength="30"  alt="El c&oacute;digo de la presentaci&oacute;n">
        </td>
        <td><input name="nombre_presentacion_#CurrentRow#" type="text" class="flat" tabindex="8" onFocus="select()" value="#HTMLEditFormat(rs_presentacion.nombre_presentacion)#" size="20" maxlength="30"  alt="El nombre de la presentaci&oacute;n"></td>
        <td><input name="multiplo_#CurrentRow#" type="text" class="flat_money" tabindex="8" onFocus="select()" value="#rs_presentacion.multiplo#" size="10" maxlength="16"  onBlur="onBlur_unidades(this)" alt="La Unidad de la presentaci&oacute;n"></td>
        <td><input name="precio_#CurrentRow#" type="text" class="flat_money" tabindex="8" onFocus="select()" value="<cfif len(trim(rs_presentacion.precio)) gt 0 >#LSNumberFormat(rs_presentacion.precio,',9.00')#</cfif>" size="10" maxlength="16" onblur="formato(this);"  alt="El precio de la presentaci&oacute;n"></td>
        <td><input name="actualizar_precio_#CurrentRow#" type="checkbox" tabindex="8" value="1" <cfif rs_presentacion.actualizar_precio EQ 1>checked</cfif>></td>
        <td><textarea style="width:100%" name="txt_descripcion_#CurrentRow#" cols="20" rows="2" class="flat" tabindex="8" onFocus="select()" >#rs_presentacion.txt_descripcion#</textarea></td>
        <td><input name="publicacion_#CurrentRow#" type="checkbox" tabindex="8" value="1" <cfif rs_presentacion.publicacion EQ 1>checked</cfif>></td>
        <cfset next_row = next_row + 1>
      </tr>
    </cfoutput>
  </cfif>
  <cfloop from="#next_row#" index="n" to="20" >
    <cfoutput>
      <tr align="center" valign="top" id="newrow_#n#" <cfif n neq next_row >class="hidden"<cfelse>class="visible"</cfif> >
        <td><b>#n#</b></td>
          <td><a href="##" onClick="DeleteRow(#n#);">[X]</a>
        <input type="hidden" id="chkEliminar_#n#" name="chkEliminar_new" value=""></td>
        <td><input name="sku_#n#" type="text" class="flat" tabindex="5" onFocus="select()" value="" onBlur="valida_rows('#n#');" size="10" maxlength="30"  alt="El c&oacute;digo de la presentaci&oacute;n"></td>
        <td><input name="nombre_presentacion_#n#" type="text" class="flat" tabindex="5" onFocus="select()" value="" onBlur="valida_rows('#n#');" size="20" maxlength="30"  alt="El nombre de la presentaci&oacute;n"></td>
        <td><input name="multiplo_#n#" type="text" class="flat_money" tabindex="5" onFocus="select()" value="1" onBlur="valida_rows('#n#');onBlur_unidades(this);" size="10" maxlength="16" alt="La Unidad de la presentaci&oacute;n"></td>
        <td><input name="precio_#n#" type="text" class="flat_money" tabindex="5" onFocus="select()" value="" size="10" maxlength="16" onblur="formato(this);" alt="El precio de la presentaci&oacute;n"></td>
        <td><input name="actualizar_precio_#n#" type="checkbox" tabindex="5" value="1" checked></td>
        <td><textarea style="width:100%" name="txt_descripcion_#n#" cols="20" rows="2" class="flat" tabindex="5" onFocus="select()" ></textarea></td>
        <td><input name="publicacion_#n#" type="checkbox" tabindex="5" value="1" checked></td>
      </tr>
    </cfoutput>
  </cfloop>
</table>

<script type="text/javascript">
	<cfoutput>
	next_row = #Max(next_row,2)#;
	</cfoutput>
	function newrow() {
		if (next_row != 0) {
			row_obj = document.getElementById("newrow_" + next_row)
			if (row_obj != null) {
				row_obj.className = "visible";
				++next_row;
			}
		}
	}
	
	function valida_rows(value){
		next_row = parseInt(value) + 1;
		row_obj = document.getElementById("newrow_" + next_row);
		// inputs
		sku_obj      = document.getElementById("sku_" + value);
		nombre_obj   = document.getElementById("nombre_presentacion_" + value);
		multiplo_obj = document.getElementById("multiplo_" + value);
		if ( row_obj && row_obj.className == 'hidden' && trim(sku_obj.value) != '' && trim(nombre_obj.value) != ''&& trim(multiplo_obj.value) != ''){
			newrow();
		}
	}
	
	function onBlur_unidades(obj){
		if ( trim(obj.value) == '' ){
			obj.value = 1;
		}
	}
	
	function validarTab(){
		// valida los inputs dinamicos
		for(var i=1; i<20; i++){
			precio = 'document.form1.precio_' + i;
			if ( trim(eval(precio).value).length > 0 ){
				eval(precio).value = qf(eval(precio).value);
			}
		}
		return true;
	}
	
	function DeleteRow(RowNum){
		row_obj = document.getElementById("newrow_" + RowNum)
		if (row_obj != null) {
			row_obj.className = "hidden";
		}
		document.form1['chkEliminar_'+RowNum].value = '1';
	}

</script>