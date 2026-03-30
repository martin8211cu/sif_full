<cfif Not IsDefined("session.id_carrito") and IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
<!--- Asegurar que el session.id_carrito pertenece al usuario y la tienda especificada --->
	<cfquery datasource="#session.dsn#" name="id_carrito">
		select convert (varchar, a.id_carrito) as id_carrito, sum(a.subtotal) as total
		from Carrito a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and a.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">
		  and a.estado = 0
		group by a.id_carrito
	</cfquery>
	<cfif id_carrito.RecordCount NEQ 0>
		<cfset session.id_carrito = id_carrito.id_carrito>
		<cfset session.total_carrito = id_carrito.total>
		<cfset StructDelete(session, "carrito_anonimo")>
	</cfif>
</cfif>
