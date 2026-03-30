<cfif IsDefined("session.id_carrito")>
  <cfquery datasource="#session.dsn#" name="carrito">
	  select 
	  moneda, subtotal, gastos_envio, total
	  from Carrito c
	  where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
  </cfquery>
  <cfif carrito.RecordCount EQ 0>
	  [ No existe el carrito <cfoutput>#session.id_carrito#</cfoutput> ]
  <cfelse>
	  <form action="carrito_go.cfm" method="post" onSubmit="return valida(this)">
	  <cfquery datasource="#session.dsn#" name="items">
		  select
			  i.id_producto, i.id_presentacion,
			  i.cantidad, i.precio_unit, i.subtotal, i.total, i.observaciones,
			  p.nombre_producto, r.nombre_presentacion
		  from Item i, Producto p, Presentacion r
		  where i.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
		    and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
		    and r.Ecodigo = i.Ecodigo
		    and r.id_producto = i.id_producto
		    and r.id_presentacion = i.id_presentacion
		    and p.Ecodigo = i.Ecodigo
		    and p.id_producto = i.id_producto
		  order by upper(p.nombre_producto), upper(r.nombre_presentacion)
	  </cfquery>
	  <!--- funciones para omitir los valores de los items que no cambien --->
	  <script type="text/javascript">
	<!--
	function valida_ctl(ctl,cant) {
		if (ctl.value == cant) {
			ctl.id = '';
			ctl.name = '';
		}
	}
	function valida(f)
	{
		<cfoutput query="items">
		valida_ctl (f.cant_#id_producto#_#id_presentacion#, '#cantidad#');</cfoutput>
		return true;
	}
	//-->
	</script>
	  <table border="0" align="center" cellpadding="4" cellspacing="0">
        <tr align="center" valign="top">
          <td><strong>Cantidad</strong></td>
          <td><strong>Producto</strong><strong></strong></td>
          <td align="right"><strong>Precio unitario</strong></td>
          <td align="right"><strong>Subtotal</strong></td>
          <td align="right"><strong>Moneda</strong></td>
        </tr><cfoutput query="items">
        <tr valign="top">
          <td align="right">
            <input tabindex="1" name="cant_#id_producto#_#id_presentacion#" id="cant_#id_producto#_#id_presentacion#" type="text" class="flat" style="text-align:right" onFocus="select()" value="#NumberFormat(cantidad,'0')#" size="4" maxlength="4">
            </td>
          <td>
		  <a tabindex="0" href="producto2.cfm?prod=#id_producto#&pres=#id_presentacion#"><span class="prod_item">#nombre_producto#&nbsp;#nombre_presentacion#</span></a>
		  <cfif Len(Trim(observaciones)) GT 0><br>
		  <span class="enc_item">#observaciones#</span></cfif></td>
          <td align="right" class="prec_item">#LSCurrencyFormat(precio_unit,"none")#</td>
          <td align="right" class="prec_item">#LSCurrencyFormat(subtotal,"none")#</td>
          
        <td align="right" class="prec_item"><cfif subtotal NEQ 0>#carrito.moneda#</cfif></td>
        </tr></cfoutput>
	    <cfoutput query="carrito"><cfif subtotal NEQ 0>
        <tr valign="top">
          <td align="right">&nbsp;</td>
          <td align="right"><strong>Subtotal (#moneda#)</strong></td>
          <td align="right">&nbsp;</td>
          <td align="right" class="prec_item" <cfif carrito.CurrentRow EQ 1>style="border-top:solid 1px black;"</cfif>>
			  #LSCurrencyFormat(subtotal,"none")#</td>
          <td align="right" class="prec_item" <cfif carrito.CurrentRow EQ 1>style="border-top:solid 1px black;"</cfif>>
			  #moneda#</td>
        </tr></cfif>
	    </cfoutput>
	    <cfoutput query="carrito"><cfif gastos_envio NEQ 0>
        <tr valign="top">
          <td align="right">&nbsp;</td>
          <td align="right"><strong>Gastos por env&iacute;o</strong></td>
          <td align="right">&nbsp;</td>
          <td align="right" class="prec_item">#LSCurrencyFormat(gastos_envio,"none")#</td>
          <td align="right" class="prec_item">#moneda#</td>
        </tr></cfif>
	    </cfoutput>
	    <cfoutput query="carrito">
        <tr valign="top">
          <td align="right">&nbsp;</td>
          <td align="right"><cfif carrito.CurrentRow EQ 1><strong>Total</strong></cfif></td>
          <td align="right">&nbsp;</td>
          <td align="right" class="prec_item" <cfif carrito.CurrentRow EQ 1>style="border-top:double 3px black;"</cfif>>
			  <strong>#LSCurrencyFormat(total,"none")#</strong></td>
          <td align="right" class="prec_item" <cfif carrito.CurrentRow EQ 1>style="border-top:double 3px black;"</cfif>>
			  <strong>#moneda#</strong></td>
        </tr>
        </cfoutput>
	    <tr valign="top">
	      <td colspan="5" align="center">&nbsp;</td>
        </tr>
	    <tr valign="top"><td colspan="5" align="center"><table border="0" cellspacing="2" cellpadding="0" width="92%">
	        <tr>
	          <td width="148">
	            <input name="update" type="image" value="Actualizar" src="../images/btn_actualizar.gif" alt="Actualizar">
	            </td>
	          <td width="148">
	            <input name="return" type="image" onClick="location.href = 'index.cfm'" value="Seguir comprando" src="../images/btn_seguir_comprando.gif" alt="Seguir comprando">
	            </td>
	          <td width="148">
	            <input name="checkout" type="image" value="Ir a pagar" src="../images/btn_pagar.gif" alt="Ir a pagar">
	            </td>
	          </tr>
	        </table>
	    </td>
	    </tr>
    </table>
	  </form>
  </cfif>
	  
          </cfif>
		  