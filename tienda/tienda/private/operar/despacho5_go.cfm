<cfparam name="form.num_pedido" type="numeric">
<cfparam name="form.num_envio" type="numeric">

<cfquery datasource="#session.dsn#" name="envio">
	update CarritoEnvio
	set estado = 500
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
	  and id_envio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_envio#">
</cfquery>

<!---<cflocation url="despacho5.cfm?num_pedido=#form.num_pedido#&num_envio=#form.num_envio#">
--->
<cflocation url="despacho.cfm">