<cfif
	IsDefined("session.carrito_anonimo") AND 
	IsDefined("session.Usucodigo") AND
	IsDefined("session.id_carrito") AND
	session.carrito_anonimo AND 
	session.Usucodigo NEQ 0 AND
	session.id_carrito NEQ 0>
	<!--- el usuario ya se logueó, asignarle el carrito --->
	
	<cfquery datasource="#session.dsn#">
		update Carrito
		set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		,   Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">
		where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
		  and Usucodigo = 0
	</cfquery>
	
	<cfset StructDelete(session, "carrito_anonimo")>
	
</cfif>