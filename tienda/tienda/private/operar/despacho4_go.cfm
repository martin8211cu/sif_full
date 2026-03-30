<cfparam name="form.num_pedido" type="numeric">
<cfparam name="form.num_envio" type="numeric">
<cfparam name="form.tracking_no" type="string">

<cfquery datasource="#session.dsn#" name="envio">
	update CarritoEnvio
	set tracking_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tracking_no#">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
	  and id_envio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_envio#">
</cfquery>

<!--- enviar correo notificando envio y tracking num --->
<cfinvoke component="tienda.tienda.private.mailer.sendmail" method="sendmail">
	<cfinvokeargument name="template"  value="pedido-recibido.cfm">
	<cfinvokeargument name="pedido"	   value="#form.num_pedido#">
	<cfinvokeargument name="Ecodigo"   value="#session.Ecodigo#">
	<cfinvokeargument name="DSN"	   value="#session.dsn#">	
</cfinvoke>

<cflocation url="despacho5.cfm?num_pedido=#form.num_pedido#&num_envio=#form.num_envio#">
