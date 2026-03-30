<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>

<cf_direccion action="readform" name="enviar_a" prefix="env">
<cf_direccion action="update" data="#enviar_a#" name="enviar_inserted">

<cfquery datasource="#session.dsn#">
	update Carrito
	set direccion_envio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#enviar_inserted.id_direccion#">
	, observaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.observaciones#">
	, transportista = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.transportista#">
	<cfif IsDefined("form.misma")>
	,   direccion_facturacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#enviar_inserted.id_direccion#">
	</cfif>
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>

<cfif IsDefined("form.misma")>
<cflocation url="payment.cfm">
<cfelse>
<cflocation url="checkout2.cfm">
</cfif>