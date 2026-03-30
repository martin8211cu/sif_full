<cfquery datasource="#session.dsn#">
	if not exists (select * from Presentacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">)
	
	insert Presentacion (
		Ecodigo, id_producto, nombre_presentacion,
		sku, actualizar_precio, publicacion, multiplo)
	select
		Ecodigo, id_producto, ' ', ' ', 1, 1, 1
	from Producto
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
</cfquery>