<cfif IsDefined("form.cambio") OR IsDefined("form.alta")>
	<!--- Guardar txt_descripcion --->
	<cfset form.txt_descripcion = Trim(form.txt_descripcion)>
	<cfquery datasource="#session.DSN#" >
		update Producto
		set txt_descripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_descripcion#" null="#Len(Trim(form.txt_descripcion)) Is 0#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
	</cfquery>
	
	<!--- Guardar imágenes (solamente se insertan) --->
	<cfif IsDefined("form.foto_1") and Len(form.foto_1) GT 2>
		<cfset binary = createObject("component", "tienda.Componentes.ReadBinary")>
		<cfset foto_binary = binary.BinaryString(binary.upload('form.foto_1'))>

		<cfquery datasource="#session.dsn#">
			insert FotoProducto (Ecodigo, id_producto, img_foto)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">,
					#foto_binary#)
		</cfquery>
	</cfif>
	
</cfif><!--- form.alta || form.cambio --->
