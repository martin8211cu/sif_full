<cfif IsDefined("session.id_carrito")>
<cfquery datasource="#session.dsn#" name="recalc">
	update Item
		set precio_unit = 0,
		subtotal = 0,
		total    = 0
	where Item.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Item.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">

	update Item
		set precio_unit = coalesce (p.precio, q.precio, 0),
		subtotal = cantidad * coalesce (p.precio, q.precio, 0),
		total    = cantidad * coalesce (p.precio, q.precio, 0)
	from Presentacion p, Producto q
	where Item.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Item.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and p.id_producto = Item.id_producto
	  and p.id_presentacion = Item.id_presentacion
	  and q.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and q.id_producto = Item.id_producto
	  
	update Carrito
	set subtotal = ( select sum(subtotal)
	from Item i
	where i.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#"> )
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
<!---
	<!--- Gastos por envío --->
	update Carrito set envio = 2.95, total = total + 2.95
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	if @@rowcount = 0 begin
		insert Subtotal (id_carrito, Ecodigo, subtotal, envio, total)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">,
			0,12.95,12.95)
		end
--->

	update Carrito
	set fupdate = getdate(), total = subtotal
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	
	select subtotal as total
	from Carrito
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	
</cfquery>
<cfset session.total_carrito = recalc.total>
</cfif>
