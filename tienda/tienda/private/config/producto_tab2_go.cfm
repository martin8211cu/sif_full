<!--- Este 20 coincide con el que esta en producto_tab2.cfm --->
<cfloop from="1" to="20" index="n">

	<cfif IsDefined("form.id_presentacion_#n#") and IsDefined("form.chkEliminar_" & form['id_presentacion_' & n])
		and Len (form['chkEliminar_' & form['id_presentacion_' & n] ]) >
		<cfquery datasource="#session.dsn#">
			delete Presentacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['id_presentacion_' & n]#">
		</cfquery>
	<cfelseif IsDefined("form.id_presentacion_#n#")>
		<cfquery datasource="#session.dsn#">
			update Presentacion
			set nombre_presentacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate("form.nombre_presentacion_#n#")#">,
			 sku = <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate("form.sku_#n#")#">,
			 precio = <cfif len(trim(Evaluate("form.precio_#n#"))) gt 0 ><cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate("form.precio_#n#")#"><cfelse>null</cfif>,
			 publicacion = <cfif isdefined("form.publicacion_#n#")><cfqueryparam cfsqltype="cf_sql_tinyint" value="#Evaluate("form.publicacion_#n#")#"><cfelse>0</cfif>,
			 txt_descripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Evaluate("form.txt_descripcion_#n#")#">,
			 multiplo = <cfif  len(trim(Evaluate("form.multiplo_#n#"))) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("form.multiplo_#n#")#"><cfelse>1</cfif>,
			 actualizar_precio = <cfif isdefined("form.actualizar_precio_#n#")>1<cfelse>0</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate("form.id_presentacion_#n#")#">
		</cfquery>
		
	<cfelseif IsDefined("form.sku_#n#") and len(trim(Evaluate("form.sku_#n#"))) gt 0 and isdefined("form.nombre_presentacion_#n#") and isdefined("form.multiplo_#n#") >
		<cfquery datasource="#session.dsn#">
			insert Presentacion (Ecodigo, id_producto, nombre_presentacion, sku, precio, publicacion, txt_descripcion, multiplo, actualizar_precio )
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate("form.nombre_presentacion_#n#")#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate("form.sku_#n#")#">,
			<cfif len(trim(Evaluate("form.precio_#n#"))) gt 0 ><cfqueryparam cfsqltype="cf_sql_money" value="#Evaluate("form.precio_#n#")#"><cfelse>null</cfif>,
			<cfif isdefined("form.publicacion_#n#")><cfqueryparam cfsqltype="cf_sql_tinyint" value="#Evaluate("form.publicacion_#n#")#"><cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Evaluate("form.txt_descripcion_#n#")#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("form.multiplo_#n#")#">,
			<cfif isdefined("form.actualizar_precio_#n#")>1<cfelse>0</cfif>)
		</cfquery>
	</cfif>
</cfloop><!--- presentacion --->
