<cfparam name="url.num_pedido" type="numeric" default="0">
<cfparam name="url.num_envio"  type="numeric" default="0">

<cfquery datasource="#session.dsn#" name="data">
	select i.id_producto, i.id_presentacion, c.direccion_envio,
		i.cantidad, p.nombre_producto, r.nombre_presentacion, r.sku, r.multiplo, c.fcompra,
		i.precio_unit, c.moneda,
		c.id_carrito, e.id_envio,
		coalesce(e.cantidad,0) as cantidad_envio, coalesce(e.subtotal,0) as subtotal_envio
	from Carrito c, Item i, Producto p, Presentacion r, CarritoEnvioItem e
	where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
	  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and c.id_tarjeta is not null
	  and i.Ecodigo         = c.Ecodigo
	  and i.id_carrito      = c.id_carrito
	  and p.Ecodigo         = i.Ecodigo
	  and p.id_producto     = i.id_producto
	  and r.Ecodigo         = i.Ecodigo
	  and r.id_producto     = i.id_producto
	  and r.id_presentacion = i.id_presentacion
	  and e.Ecodigo         =* i.Ecodigo
	  and e.id_carrito      =* i.id_carrito
	  and e.id_producto     =* i.id_producto
	  and e.id_presentacion =* i.id_presentacion
	  and e.id_envio        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_envio#">
</cfquery>

<cfif data.RecordCount IS 0>
	<cflocation url="despacho.cfm?ne=#URLEncodedFormat(url.num_pedido)#">
</cfif>

<cfquery datasource="#session.dsn#" name="envio">
	select e.subtotal, e.gastos_envio, e.total, e.num_autorizacion,
		c.id_carrito, e.id_envio, t.nombre_transportista, e.tracking_no
	from Carrito c, CarritoEnvio e, Transportista t
	where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
	  and c.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and e.id_carrito =* c.id_carrito
	  and e.Ecodigo    =* c.Ecodigo
	  and e.id_envio   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_envio#">
	  and t.transportista =* c.transportista
</cfquery>

