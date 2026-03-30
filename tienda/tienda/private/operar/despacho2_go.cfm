<cfquery datasource="#session.dsn#" name="items">
	select id_producto, id_presentacion, precio_unit
	from Item
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
</cfquery>

<cfset id_envio = 0>
<cffunction name="header">
<!--- inserta el encabezado, solamente se invoca si hay detalles --->
	<cfif id_envio is 0>
		<cfquery datasource="#session.dsn#" name="inserted">
			insert CarritoEnvio (id_carrito, Ecodigo, fecha_envio)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				getdate())
			select @@identity as id_envio
		</cfquery>
		<cfset id_envio = inserted.id_envio>
	</cfif>
</cffunction>
<cfset total = 0>
<cfloop query="items">
	<cfset sufijo = "_" & items.id_producto & "_" & items.id_presentacion>
	<cfset cant = 0>
	<cfset cant = form['cant' & sufijo]>
	
	<cfif Len(cant) NEQ 0 and cant NEQ 0>
		<cfset header()>
		<cfset total_linea = Round(cant * items.precio_unit * 100) / 100.0>
		<cfset total = total + total_linea>
		<cfquery datasource="#session.dsn#">
			insert CarritoEnvioItem
				(Ecodigo, id_carrito, id_producto, id_presentacion, id_envio,
				precio_unit, cantidad, subtotal, total)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#items.id_producto#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#items.id_presentacion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_envio#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#items.precio_unit#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#cant#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#total_linea#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#total_linea#">)
		</cfquery>
	</cfif>
</cfloop>

<cfif id_envio>
	<cfquery datasource="#session.dsn#">
		update CarritoEnvio
		set subtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#total#">,
		    total = <cfqueryparam cfsqltype="cf_sql_money" value="#total#">,
		    gastos_envio = 0
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_pedido#">
		  and id_envio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_envio#">
	</cfquery>
	<cflocation url="despacho3.cfm?num_pedido=#form.num_pedido#&num_envio=#id_envio#">
<cfelse>
	<cflocation url="despacho2.cfm?num_pedido=#form.num_pedido#">
</cfif>

