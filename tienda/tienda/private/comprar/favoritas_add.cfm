<!--- agrega a mi carrito una copia del contenido del carrito historico especificado en url.id --->
<cfif IsDefined("url.id")>
	<cfinclude template="../../public/carrito_create.cfm">
	<cfquery datasource="#session.dsn#" name="x" >
		if exists (
			select * from Carrito c
			where c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">)
		BEGIN

			update Item
			set cantidad = i.cantidad + j.cantidad
			from Item i, Item j
			where i.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
			  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
			  and j.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			  and j.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
			  and j.id_producto = i.id_producto
			  and j.id_presentacion = i.id_presentacion
			select @@rowcount as updated

			insert Item (
				id_carrito, Ecodigo, id_producto, id_presentacion,
				cantidad, observaciones)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">,
				id_producto, id_presentacion,
				cantidad, observaciones
			from Item i
			where i.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
			  and not exists (select * from Item j
				where j.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
				  and j.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
				  and j.id_producto = i.id_producto
				  and j.id_presentacion = i.id_presentacion
				)
		END
	</cfquery>
	<cfinclude template="../../public/carrito_recalc.cfm">
</cfif>
<cflocation url="../../public/carrito.cfm">
