<cfparam name="url.id" default="0">
<cfset pmt_id_carrito=url.id>
<cfquery datasource="#session.dsn#" name="carrito">
	select 
	c.Ecodigo, c.id_carrito, c.subtotal, c.gastos_envio, c.total, c.moneda, s.nombre_estado,
	c.observaciones,
	c.id_tarjeta, c.direccion_envio, c.direccion_facturacion
	from Carrito c, Estado s
	where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and c.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">
	  and s.estado = c.estado
</cfquery>
<cfset credit_card = carrito>
<cfif carrito.RecordCount EQ 0>
  <cflocation url="../../public/index.cfm">
</cfif>

<cfquery datasource="#session.dsn#" name="items">
	select
		i.id_producto, i.id_presentacion,
		i.cantidad, i.precio_unit, i.subtotal, i.total, i.observaciones,
		p.nombre_producto, r.nombre_presentacion
	from Item i, Producto p, Presentacion r
	where i.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#carrito.id_carrito#">
	  and r.Ecodigo = i.Ecodigo
	  and r.id_producto = i.id_producto
	  and r.id_presentacion = i.id_presentacion
	  and p.Ecodigo = i.Ecodigo
	  and p.id_producto = i.id_producto
	order by upper(p.nombre_producto), upper(r.nombre_presentacion)
</cfquery>
<cfquery datasource="#session.dsn#" name="notas">
	select
		nota, fecha, Usulogin
	from Nota n
	where n.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#carrito.id_carrito#">
	  and uso_interno = 0 <!--- No mostrar al usuario las notas privadas --->
	order by id_nota desc
</cfquery>

<cf_template>
<cf_templatearea name=title>Compra registrada </cf_templatearea>
<cf_templatearea name=body>

<cfinclude template="../../public/estilo.cfm">

<table width="100%" border="0">
        <!--DWLayoutTable-->
        <tr> 
          <td valign="top">
          <table align="center" border="0" cellspacing="2" style="background-color:#ffffff;border:solid 1px #000000; text-shadow: 6px;">
              <!--DWLayoutTable-->
			  <cfoutput>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">Orden No. <span class="orderno">#carrito.Ecodigo#-#carrito.id_carrito#</span></td>
              </tr>
              <tr>
                <td colspan="3" align="right" style="border-bottom:solid 2px ##c0c0c0;padding-bottom:4px;"><!--DWLayoutEmptyCell-->&nbsp;</td>
                </tr>
              <tr>
                <td colspan="3"> <strong>La transacci&oacute;n ha sido completada con &eacute;xito</strong></td>
                </tr>
              <tr>
                <td colspan="3">El n&uacute;mero de su pedido es #carrito.Ecodigo#-#carrito.id_carrito#, y se detalla a continuaci&oacute;n.</td>
                </tr>
              <tr>
                <td colspan="2"><!--DWLayoutEmptyCell-->&nbsp;</td>
                <td><!--DWLayoutEmptyCell-->&nbsp;</td>
              </tr>
              <tr>
                <td colspan="3">
				<cf_direccion action="display" key="#carrito.direccion_envio#" prefix="env" title="Dirección de envío">
				<cf_direccion action="display" key="#carrito.direccion_facturacion#" prefix="fac" title="Dirección de facturación">
				</td>
              </tr>
				<cfif Len(Trim(carrito.observaciones))>
				<tr><td colspan="3">Observaciones</td></tr>
				<tr><td colspan="3">#HTMLEditFormat(envio.observaciones)#</td></tr>
				</cfif>
			  </cfoutput>
              <tr>
                <td colspan="3" valign="top" align="center" class="tituloListas">Detalle del pedido </td>
              </tr>
              <tr>
                <td colspan="3" valign="top">
      <table border="0" cellpadding="4" cellspacing="0">
        <tr align="center">
          <td style="color:#ffffff;background-color:#999999"><strong>Cantidad</strong></td>
          <td style="color:#ffffff;background-color:#999999"><strong>Producto</strong><strong></strong></td>
          <td style="color:#ffffff;background-color:#999999"><strong>Precio unitario</strong></td>
          <td style="color:#ffffff;background-color:#999999"><strong>Subtotal</strong></td>
          <td style="color:#ffffff;background-color:#999999"><strong>Moneda</strong></td>
        </tr><cfoutput query="items">
        <tr>
          <td align="center">#cantidad#</td>
          <td>#nombre_producto#&nbsp;#nombre_presentacion#</td>
          <td align="right">#LSCurrencyFormat(precio_unit,"none")#</td>
          <td align="right">#LSCurrencyFormat(subtotal,"none")#</td>
          <td align="right">#carrito.moneda#</td>
        </tr></cfoutput>
		<cfset firstline="yes">
	    <cfoutput query="carrito"><cfif subtotal NEQ 0>
			<cfset style1=""><cfif firstline><cfset style1='style="border-top:solid 1px black;"'></cfif>
			<cfset firstline="no">
			<tr>
			  <td align="right">&nbsp;</td>
			  <td align="right"><strong>Subtotal</strong></td>
			  <td align="right">&nbsp;</td>
			  <td align="right" #style1#>#LSCurrencyFormat(subtotal,"none")#</td>
			  <td align="right" #style1#>#moneda#</td>
			</tr></cfif>
		</cfoutput>
        <cfoutput query="carrito"><cfif gastos_envio NEQ 0>
			<tr>
			  <td align="right">&nbsp;</td>
			  <td align="right"><strong>Gastos por env&iacute;o</strong></td>
			  <td align="right">&nbsp;</td>
			  <td align="right">#LSCurrencyFormat(gastos_envio,"none")#</td>
			  <td align="right">#moneda#</td>
			</tr></cfif>
        </cfoutput>
		<cfset firstline="yes">
		<cfoutput query="carrito"><cfif carrito.total NEQ 0>
			<cfset style1=""><cfif firstline><cfset style1='style="border-top: solid 2px ##c0c0c0"'></cfif>
			<cfset style2=""><cfif firstline><cfset style2='style="border-top:double 3px black;"'></cfif>
			<cfset firstline="no">
			<tr>
			  <td align="right" #style1#>&nbsp;</td>
			  <td align="right" #style1#><strong>Total</strong></td>
			  <td align="right" #style1#>&nbsp;</td>
			  <td align="right" #style2#>#LSCurrencyFormat(total,"none")#</td>
			  <td align="right" #style2#>#moneda#</td>
			</tr>
        </cfoutput></cfif>
        <cfoutput>
        <tr>
          <td colspan="5" align="left" valign="top"><em>#carrito.observaciones#</em></td>
	    </tr>
        </cfoutput>
    </table></td></tr>
              <tr>
                <td colspan="3" valign="top" >
				
				<cf_tarjeta action="display" key="#carrito.id_tarjeta#">
				</td>
              </tr>
              <tr>
                <td colspan="3" align="center" valign="top" ><form name="form1" method="get" action="/cfmx/tienda/tienda/public/index.cfm">
                  <input type="submit" name="Submit" value="Listo">
                </form></td>
              </tr>
          </table>          
          </td>
        </tr>
</table>
</cf_templatearea>
</cf_template>
