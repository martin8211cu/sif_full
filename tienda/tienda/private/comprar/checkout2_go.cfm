<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>

<cf_direccion action="readform" name="facturar_a" prefix="fac">
<cf_direccion action="update" data="#facturar_a#" name="facturar_inserted">

<cfquery datasource="#session.dsn#">
	update Carrito
	set direccion_facturacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#facturar_inserted.id_direccion#">
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>

<cflocation url="payment.cfm">
