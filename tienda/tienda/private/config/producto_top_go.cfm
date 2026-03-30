<cfif IsDefined("form.cambio") And Len(form.id_producto)>
	<cfset form.nombre_producto = Trim(form.nombre_producto)>
	<cfquery datasource="#session.DSN#" >
		update Producto
		set nombre_producto = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_producto#">
		  , publicacion = <cfif isdefined("form.publicacion")>1<cfelse>0</cfif>
		  , precio      = <cfqueryparam cfsqltype="cf_sql_money" value="#form.precio#" null="#Len(Trim(form.precio)) Is 0#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
	</cfquery>
	
	<cfif IsDefined("form.id_categoria")>
		<cfquery datasource="#Session.DSN#">
			delete ProductoCategoria 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
			insert ProductoCategoria(Ecodigo, id_producto, id_categoria)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#">)
		</cfquery>
	</cfif>

	<cfset id_producto = form.id_producto>
<cfelseif IsDefined("form.alta") Or (IsDefined("form.cambio") And Len(form.id_producto) Is 0)>
	<cfquery datasource="#session.DSN#" name="prod" >
		insert Producto (Ecodigo, nombre_producto, publicacion, precio)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.nombre_producto)#">,
		<cfif isdefined("form.publicacion")>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_money" value="#form.precio#" null="#Len(trim(form.precio)) IS 0#">)
		select convert (varchar, @@identity) as id_producto
	</cfquery>
	<cfset form.id_producto = prod.id_producto>
	
	<cfquery datasource="#session.DSN#" >
		insert ProductoCategoria(Ecodigo, id_producto, id_categoria)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#">)
	</cfquery>

<cfelseif IsDefined("form.baja")>
	<cfquery datasource="#session.DSN#" >
		delete Presentacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
		delete ProductoCategoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
		delete FotoPresentacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
		delete FotoProducto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
		delete Producto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
	</cfquery>
</cfif>
