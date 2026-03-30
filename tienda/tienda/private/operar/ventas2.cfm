
<cfset f_desde = LSParseDateTime(url.desde)>
<cfset f_hasta = DateAdd("d", 1, LSParseDateTime(url.hasta))>

<cfquery datasource="#session.dsn#" name="data">
select r.sku, p.nombre_producto,
	r.nombre_presentacion, i.id_carrito, i.cantidad,
	i.precio_unit, i.subtotal as subtotal_linea, c.moneda, c.subtotal as subtotal_pedido
from Carrito c, Item i, Producto p, Presentacion r
where c.fcompra >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_desde#">
  and c.fcompra <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_hasta#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  and c.id_tarjeta is not null
  and i.Ecodigo         = c.Ecodigo
  and i.id_carrito      = c.id_carrito
  and p.Ecodigo         = i.Ecodigo
  and p.id_producto     = i.id_producto
  and r.Ecodigo         = i.Ecodigo
  and r.id_producto     = i.id_producto
  and r.id_presentacion = i.id_presentacion
order by c.id_carrito, p.nombre_producto, r.nombre_presentacion
</cfquery>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Consulta de ventas</cf_templatearea>
<cf_templatearea name="header"><cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">



<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<cf_web_portlet titulo="Consulta de ventas">
		<cfoutput>
		<table border="0" align="center">
  <tr>
    <td>Desde</td>
    <td>#DateFormat(f_desde,'dd/mm/yyyy')#</td>
  </tr>
  <tr>
    <td>Hasta</td>
    <td>#DateFormat(f_hasta,'dd/mm/yyyy')#</td>
  </tr>
</table></cfoutput>

		
		<table width="100%" border="0" cellpadding="3" cellspacing="0">
          <tr>
            <td width="2%" valign="top" bgcolor="#CCCCCC">&nbsp;</td>
            <td width="10%" valign="top" bgcolor="#CCCCCC"><strong>Pedido</strong></td>
            <td width="7%" valign="top" bgcolor="#CCCCCC"><strong>SKU</strong></td>
            <td width="13%" valign="top" bgcolor="#CCCCCC"><strong>Producto</strong></td>
            <td width="18%" valign="top" bgcolor="#CCCCCC"><strong>Presentaci&oacute;n</strong></td>
            <td width="13%" align="right" valign="top" bgcolor="#CCCCCC"><strong>Cantidad</strong></td>
            <td colspan="2" align="right" valign="top" bgcolor="#CCCCCC"><strong>Precio unitario </strong></td>
            <td colspan="2" align="right" valign="top" bgcolor="#CCCCCC"><strong>Subtotal</strong></td>
            <td width="2%" valign="top" bgcolor="#CCCCCC">&nbsp;</td>
          </tr>
		  <cfset sum_precio_unit = 0>
		  <cfset sum_subtotal = 0>
		  
		  <cfoutput query="data" group="id_carrito"> 
          <tr bgcolor="##f8f8f8">
            <td colspan="11" valign="top" height="6"></td>
            </tr>
		  <cfoutput >
          <tr>
            <td valign="top">&nbsp;</td>
            <td valign="top">#id_carrito#</td>
            <td valign="top">#sku#</td>
            <td valign="top">#nombre_producto#</td>
            <td valign="top">#nombre_presentacion#</td>
            <td align="right" valign="top">#NumberFormat( cantidad, 0)#</td>
            <td width="17%" align="right" valign="top">#NumberFormat( precio_unit, ',000.00')#</td>
            <td width="6%" align="left" valign="top">#moneda#</td>
            <td width="6%" align="right" valign="top">#NumberFormat( subtotal_linea, ',000.00')#</td>
            <td width="6%" align="left" valign="top">#moneda#</td>
            <td valign="top">&nbsp;</td>
          </tr> 
		  </cfoutput>
		 
		  
          <tr bgcolor="##eeeeee">
            <td valign="top">&nbsp;</td>
            <td colspan="2" valign="top">&nbsp;</td>
            <td colspan="5" valign="top">Subtotal del pedido  (no incluye gastos de env&iacute;o)</td>
            <td align="right" valign="top"><strong>#NumberFormat( subtotal_pedido, ',000.00')#</strong></td>
            <td align="left" valign="top"><strong>#moneda#</strong>&nbsp;</td>
            <td valign="top">&nbsp;</td>
          </tr>
		  </cfoutput>
		  <cfquery datasource="#session.dsn#" name="total">
			select sum (i.subtotal) as subtotal, c.moneda
			from Carrito c, Item i
			where c.fcompra >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_desde#">
			  and c.fcompra <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#f_hasta#">
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and i.Ecodigo         = c.Ecodigo
			  and i.id_carrito      = c.id_carrito
			group by c.moneda
		  </cfquery>
		  
		  <cfoutput>
          <tr bgcolor="##CCCCCC">
            <td valign="top">&nbsp;</td>
            <td colspan="2" valign="top">&nbsp;</td>
            <td colspan="5" valign="top">Subtotal General (no incluye gastos de env&iacute;o) </td>
            <td align="right" valign="top"><strong>#NumberFormat( total.subtotal, ',000.00')#</strong></td>
            <td align="left" valign="top"><strong>#total.moneda#</strong>&nbsp;</td>
            <td valign="top">&nbsp;</td>
          </tr></cfoutput>
        </table>
		</cf_web_portlet>


</cf_templatearea>
</cf_template>
