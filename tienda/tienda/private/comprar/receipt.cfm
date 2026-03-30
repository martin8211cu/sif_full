<cfparam name="url.id" default="0">
<cfquery datasource="#session.dsn#" name="carrito">
	select 
	c.Ecodigo, c.id_carrito, c.subtotal, c.gastos_envio, c.total, c.moneda, s.nombre_estado,
	c.observaciones, c.direccion_envio, c.direccion_facturacion
	from Carrito c, Estado s
	where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and c.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">
	  and s.estado = c.estado
</cfquery>
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
<cf_templatearea name=title>Confirmar env&iacute;o
</cf_templatearea>
<cf_templatearea name=header><cfinclude template="/tienda/tienda/public/carrito_p.cfm">
</cf_templatearea>
<cf_templatearea name=body>

<cfinclude template="../../public/estilo.cfm">

<table width="100%">
        <!--DWLayoutTable-->
        <tr> 
          <td valign="top">
          <table align="center" border="0" cellspacing="2" style="background-color:#f0f0f0;border:solid 2px #c0c0c0; text-shadow: 6px;">
              <!--DWLayoutTable-->
			  <cfoutput>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">Orden No. <span class="orderno">#carrito.Ecodigo#-#carrito.id_carrito#</span></td>
              </tr>
              <tr>
                <td colspan="3" align="right" style="border-bottom:solid 2px ##c0c0c0;padding-bottom:4px;"><a href="favoritas_add.cfm?id=#carrito.id_carrito#"><img src="../../images/btn_agregar.gif" alt="Agregar a mi compra" width="140" height="16" border="0"></a></td>
                </tr>
              <tr>
                <td colspan="2"><strong>Estado:</strong></td>
                <td>#carrito.nombre_estado#</td>
              </tr>
              <tr>
                <td colspan="2">
				<cf_direccion action="label" key="#carrito.direccion_envio#" title="Enviar a">
				
		        </td>
                <td>
				<cf_direccion action="label" key="#carrito.direccion_facturacion#" title="Facturar a">
			  </td>
              </tr></cfoutput>
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
    </table>
  
</td></tr>
          </table>          <table align="center" border="0" cellspacing="2">
              <tr>
                <td colspan="4" valign="top">Anotaciones
                  <table width="100%" border="0" cellspacing="0" cellpadding="4">
				  <cfoutput query="notas">
                    <tr valign="top" bgcolor="<cfif CurrentRow MOD 2 EQ 0>##ffffff<cfelse>##f0f0f0</cfif>">
				    <td><em>#Usulogin#</em></td>
                      <td>
					  <em>#LSDateFormat(fecha,'short')#,
					  #LSTimeFormat(fecha,'short')#</em></td>
                      <td>#nota#</td>
                    </tr>
                  </cfoutput>
				  </table>
                </td>
              </tr>
          </table></td>
        </tr>
      </table>
	  
	  </cf_templatearea>
</cf_template>
