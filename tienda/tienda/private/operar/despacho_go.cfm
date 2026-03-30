<cfparam name="url.num_pedido" type="numeric" default="0">
<cfparam name="url.num_envio" type="numeric" default="0">

<cfquery datasource="#session.dsn#" name="envio" maxrows="1">
	select c.id_carrito, e.id_envio, e.id_transaccion, e.tracking_no, e.estado
	from Carrito c, CarritoEnvio e
	where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_pedido#">
	  and c.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and e.id_carrito =* c.id_carrito
	  and e.Ecodigo    =* c.Ecodigo
	  and c.id_tarjeta is not null
	  <cfif url.num_envio>
	  and e.id_envio   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.num_envio#">
	  </cfif>
    order by e.id_envio desc
</cfquery>

<cfif Len(envio.id_carrito) is 0>
	<cflocation url="despacho.cfm?ne=#URLEncodedFormat(url.num_pedido)#">
<cfelseif Len(envio.id_envio) is 0>
	<cflocation url="despacho2.cfm?num_pedido=#envio.id_carrito#">
<cfelseif Len(envio.id_transaccion) is 0>
	<cflocation url="despacho3.cfm?num_pedido=#envio.id_carrito#&num_envio=#envio.id_envio#">
<cfelseif Len(envio.tracking_no) is 0>
	<cflocation url="despacho4.cfm?num_pedido=#envio.id_carrito#&num_envio=#envio.id_envio#">
<cfelseif envio.estado neq 500>
	<cflocation url="despacho5.cfm?num_pedido=#envio.id_carrito#&num_envio=#envio.id_envio#">
<cfelse>
	<cflocation url="despacho.cfm?pc=#envio.id_carrito#">
</cfif>
