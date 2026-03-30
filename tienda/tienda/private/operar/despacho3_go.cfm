<cfparam name="form.num_pedido" type="numeric">
<cfparam name="form.num_envio" type="numeric">

<cfquery datasource="#session.dsn#" name="envio">
	select subtotal, gastos_envio, total
	from CarritoEnvio
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
	  and id_envio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_envio#">
</cfquery>

<cfquery datasource="#session.dsn#" name="carrito">
	select id_tarjeta, moneda
	from Carrito
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
</cfquery>

<cf_tarjeta action="select" key="#carrito.id_tarjeta#" name="tarjeta">
<cfif Len ( carrito.id_tarjeta ) is 0>
	<cfthrow message="Error: el cliente no especificó una tarjeta de crédito al realizar su orden">
</cfif>

<cf_tarjeta_cobro2
	action="autorizar"
	Ecodigosdc="#session.EcodigoSDC#"
	id_tarjeta="#carrito.id_tarjeta#"
	monto="#envio.total#"
	moneda="#carrito.moneda#"
	control="#form.num_pedido#">


<cfif cf_tarjeta_cobro.error NEQ 0>
	<cflocation url="despacho3_rechazo.cfm?msg=#URLEncodedFormat(cf_tarjeta_cobro.mensaje)
		#&num_pedido=#URLEncodedFormat(form.num_pedido)
		#&num_envio=#URLEncodedFormat(form.num_envio)#">
</cfif>

<cfquery datasource="#session.dsn#" name="envio">
	update CarritoEnvio
	set id_transaccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cf_tarjeta_cobro.transaccion.id_transaccion#">,
	    num_autorizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizacion#" null="#Len( cf_tarjeta_cobro.autorizacion) is 0#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
	  and id_envio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_envio#">
</cfquery>

<cflocation url="despacho4.cfm?num_pedido=#form.num_pedido#&num_envio=#form.num_envio#">