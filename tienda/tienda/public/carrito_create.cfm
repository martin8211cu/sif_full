<cfinclude template="carrito_buscar.cfm">
<cfif Not IsDefined("session.id_carrito")>
<!--- Asegurar que el session.id_carrito pertenece al usuario y la tienda especificada --->
	<cftransaction>
	<cfquery datasource="#session.dsn#" name="id_carrito">
		insert Carrito (Ecodigo, Usucodigo, Usulogin, moneda)
		values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.comprar_moneda#">)
		select convert (varchar, @@identity) as id_carrito, 0 as total
	</cfquery>
	<cfset session.id_carrito = id_carrito.id_carrito>
	<cfset session.total_carrito = id_carrito.total>
	<cfif session.Usucodigo EQ 0>
		<cfset session.carrito_anonimo = true>
	<cfelse>
		<cfset session.carrito_anonimo = false>
	</cfif>
	</cftransaction>
</cfif>
