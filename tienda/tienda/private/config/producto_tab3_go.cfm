<cfparam name="form.modo_foto" default="alta">
<cfset form.modo_foto = LCase(form.modo_foto)>

<!--- Guardar la foto en una variable --->
<cfset foto_binary = "">
<cfif IsDefined("form.foto_1") and Len(form.foto_1) GT 2>
	<cfset binary = createObject("component", "tienda.Componentes.ReadBinary")>
	<cfset foto_binary = binary.BinaryString(binary.upload('form.foto_1'))>
</cfif><!--- IsDefined form.foto_1 --->

<cfif Len(form.id_foto) Neq 0 And form.modo_foto Is 'baja' >
	<cfquery datasource="#session.dsn#">
		delete FotoProducto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">
		  and id_foto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_foto#">
	</cfquery>
<cfelseif Len(foto_binary) Neq 0 And form.modo_foto Is 'alta' >
	<cfquery datasource="#session.dsn#">
		insert FotoProducto (Ecodigo, id_producto, img_foto)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_producto#">,
				#foto_binary#)
	</cfquery>
</cfif>