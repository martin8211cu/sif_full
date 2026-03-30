<cfparam name="form.cantidad" default="1">
<cfparam name="form.observaciones" default="">
<cfinclude template="carrito_create.cfm">
<cfif IsDefined("session.id_carrito")>
	<cfif form.cantidad EQ 0>
		<cfquery datasource="#session.dsn#" >
			delete Item
			where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">
			  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pres#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" >
			update Item
			set cantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cantidad#">,
			observaciones = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.observaciones#">
			where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">
			  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pres#">
			if @@rowcount = 0 BEGIN
				insert Item (
					id_carrito, Ecodigo, id_producto, id_presentacion,
					cantidad, observaciones, precio_unit)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pres#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cantidad#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.observaciones#">,
					0
				from Presentacion p, Carrito c
				where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
				  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">
				  and p.id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pres#">
				  and c.id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
				  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
			END
		</cfquery>
	</cfif>
	<cfinclude template="carrito_recalc.cfm">
</cfif>
