<cfinclude template="despacho_query.cfm">


<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Registro de despacho </cf_templatearea>
<cf_templatearea name="header">
<cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">

<link href="despacho.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
<!--
	subtlinea = new Object();
	cantlinea = new Object();
	subtprod = 0;
	cantprod = 0;
	objRegExp  = new RegExp('(-?[0-9]+)([0-9]{3})');
	function CurrencyFormat(n) {
		var strValue = ''+Math.floor(n);
		while(objRegExp.test(strValue)) {
			strValue = strValue.replace(objRegExp, '$1,$2');
		}
		var frac = Math.round((n - Math.floor(n)) * 100);
		if (frac<10) frac = '0' + frac;
		strValue += '.' + frac;
		return strValue
	}
	function cantchange(saldo,sufijo,precio_unit) {
		var cantx = document.all["cant_" + sufijo];
		var pendx = document.all["pend_" + sufijo];
		var subtx = document.all["subt_" + sufijo];
		var n = saldo - cantx.value;
		pendx.value = n;
		pendx.style.color = (n < 0) ? 'red' : 0;
		subtx.value = CurrencyFormat(cantx.value * precio_unit);
		if (subtlinea[sufijo]) {
			subtprod -= subtlinea[sufijo];
		}
		if (cantlinea[sufijo]) {
			cantprod -= cantlinea[sufijo];
		}
		subtlinea[sufijo] = (cantx.value * precio_unit);
		cantlinea[sufijo] = cantx.value;
		subtprod += subtlinea[sufijo];
		cantprod += cantlinea[sufijo];
		document.all.subtotal_productos.value = CurrencyFormat(subtprod);
	}
	function validar(f) {
		if (cantprod == 0) {
			alert("Indique los productos que desea enviar");
			<cfoutput>
			f.cant_#data.id_producto#_#data.id_presentacion#.focus();
			</cfoutput>
			return false;
		}
		return true;
	}
-->
</script>

<cfinclude template="/home/menu/pNavegacion.cfm">
		<cf_web_portlet titulo="Registro de Despacho">
		
		

		<form name="form1" action="despacho2_go.cfm" method="post" style="margin:0 " onSubmit="return validar(this);">
		<cfinclude template="despacho_hdr.cfm">

			<br>
			<table width="958"  border="0" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
			  <tr bgcolor="#CCCCCC">
			    <td width="77"  class="picklist_header">C&oacute;digo</td>
				<td width="215" class="picklist_header">Nombre</td>
				<td width="216" class="picklist_header">Presentaci&oacute;n</td>
				<td width="61" align="right"  class="picklist_header">Pedido&nbsp;</td>
				<td width="61" align="right"  class="picklist_header">Saldo&nbsp;</td>
			    <td width="73" align="right"  class="picklist_header">Env&iacute;o</td>
			    <td width="131" align="right" class="picklist_header">Subtotal (<cfoutput>#data.moneda#</cfoutput>) </td>
			    <td width="76" align="right"  class="picklist_header">Pendiente</td>
		      </tr>
			<cfoutput query="data">
			
			<cfquery datasource="#session.dsn#" name="this_cant">
				select coalesce ( sum (cantidad), 0) as cantidad
				from CarritoEnvioItem
				where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_producto#">
				  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_presentacion#">
			</cfquery>
			  <tr>
			    <td class="picklist_data">#sku#</td>
				<td class="picklist_data">#nombre_producto#&nbsp;</td>
				<td class="picklist_data">#nombre_presentacion#&nbsp;</td>
				<td class="picklist_data" align="right">#NumberFormat(cantidad,',0')#</td>
				<td class="picklist_data" align="right">#NumberFormat(cantidad-this_cant.cantidad,',0')#</td>
			    <td class="picklist_data" align="right"><input onFocus="this.select()" onChange="cantchange(#NumberFormat(cantidad-this_cant.cantidad, '0')#, '#id_producto#_#id_presentacion#', #NumberFormat(precio_unit,'0.0000')#)" class="despacho_cant" name="cant_#id_producto#_#id_presentacion#" id="cant_#id_producto#_#id_presentacion#" type="text" size="8" maxlength="6"></td>
			    <td align="right" nowrap class="picklist_data"><input tabindex="-1" readonly="" class="despacho_pend" name="subt_#id_producto#_#id_presentacion#" id="subt_#id_producto#_#id_presentacion#" type="text" size="15" maxlength="20">		        </td>
			    <td class="picklist_data" align="right"><input tabindex="-1" readonly="" class="despacho_pend" name="pend_#id_producto#_#id_presentacion#" id="pend_#id_producto#_#id_presentacion#" type="text" size="8" maxlength="6"></td>
		      </tr>
		  </cfoutput>	
			  <tr>
			    <td>&nbsp;</td>
			    <td colspan="2" valign="top"><span class="picklist_data">
				<cfset despacho_progreso_paso = 2><cfinclude template="despacho_progreso.cfm">
			    </span></td>
			    <td valign="top">&nbsp;</td>
			    <td colspan="4" valign="top"><table width="350"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="143" bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data">&nbsp;</td>
                    <td bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data">&nbsp;</td>
                    <td bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr>
                    <td bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data">Subtotal Productos </td>
                    <td width="137" bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data"><input tabindex="-1" readonly="" class="despacho_pend" name="subtotal_productos" id="subtotal_productos" type="text" size="20" maxlength="20"></td>
                    <td width="70" bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data">&nbsp;</td>
                  </tr>
                  <tr>
                    <td bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data">Medio de env&iacute;o:</td>
                    <td colspan="2" bordercolor="#CCCCCC" bgcolor="#FFFFFF" class="picklist_data"><cfoutput>#envio.nombre_transportista#</cfoutput></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                                </table></td>
		      </tr>
</table>
		    
		    <br>
		    <table width="667" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="649" align="center"><input name="submit" type="submit" value="Paquete listo"></td>
              </tr>
            </table>
		    <br>
</form>
<script type="text/javascript">
<!--<cfoutput>
document.form1.cant_#data.id_producto#_#data.id_presentacion#.focus();
//</cfoutput>-->
</script>
		</cf_web_portlet>


</cf_templatearea>
</cf_template>
