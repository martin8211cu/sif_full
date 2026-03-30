<html><head><title>Procesando...</title></head>
<body>
<form action="producto.cfm" method="post" name="redirsql">
	<cfif IsDefined("form.cambio") OR IsDefined("form.dup")>
		<cfquery datasource="#session.DSN#" >
			update Producto
			set nombre_producto = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_producto#">
			  , publicacion = <cfif isdefined("form.publicacion")>1<cfelse>0</cfif>
			  , txt_descripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_descripcion#">
			  , precio          = <cfif len(trim(form.precio)) gt 0 ><cfqueryparam cfsqltype="cf_sql_money" value="#form.precio#"><cfelse>null</cfif>
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

		<input name="modo" type="hidden" value="CAMBIO">

		<cfif IsDefined("form.cambio")>
			<cfoutput><input name="id_producto" type="hidden" value="#Form.id_producto#"></cfoutput>
		</cfif>
		<cfset id_producto = form.id_producto>

	<cfelseif IsDefined("form.alta")>
		<cfquery datasource="#session.DSN#" name="prod" >
			insert Producto (Ecodigo, nombre_producto, publicacion, txt_descripcion, precio)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_producto#">,
			<cfif isdefined("form.publicacion")>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_descripcion#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.precio#" null="#Len(trim(form.precio)) IS 0#">)
			select convert (varchar, @@identity) as id_producto
		</cfquery>

		<cfquery datasource="#session.DSN#" >
			insert ProductoCategoria(Ecodigo, id_producto, id_categoria)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#prod.id_producto#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#">)
		</cfquery>
		<cfset id_producto = prod.id_producto>

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

	<!--- Guardar detalle de presentaciones --->
	<cfif IsDefined("form.alta") OR IsDefined("form.cambio") OR IsDefined("form.dup")>
		<cfset pres_count = 0>
		<cfloop from="1" to="20" index="n">
			<cfif not IsDefined("form.chkEliminar_#n#") >
				<cfif IsDefined("form.id_presentacion_#n#")>
					<cfset pres_count = pres_count + 1>
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
					<cfset pres_count = pres_count + 1>
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
						 <cfif isdefined("form.actualizar_precio_#n#")>1<cfelse>0</cfif>
						)
					</cfquery>
				</cfif>
			<cfelseif IsDefined("form.id_presentacion_#n#")>
				<!---<cfoutput >Eliminando form.id_presentacion_#n# : Evaluate("form.id_presentacion_#n#")</cfoutput><br>--->
				<cfquery datasource="#session.dsn#">
					delete Presentacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
					  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate("form.id_presentacion_#n#")#">
				</cfquery>
			</cfif>
		</cfloop><!--- presentacion --->
		
		<cfif isdefined("form.cambio")>
			<!--- CALCULA EL PORCENTAJE QUE DEBE APLICAR --->
			<cfset porcentaje = 0 >
			<cfif len(trim(form.hprecio)) gt 0 and len(trim(form.precio)) gt 0 and form.precio neq form.hprecio>
				<cfset diferencia = form.precio - form.hprecio >
				<cfset porcentaje = ((100 * diferencia)/form.hprecio)/100>
	
				<cfquery name="rsPrecio" datasource="#session.DSN#">
					update Presentacion
					set precio = precio + precio*#porcentaje#
					where id_producto=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and actualizar_precio = 1
				</cfquery>
			</cfif>
		</cfif>
		
		<!--- Agregar presentacion unica si no hay otra --->
		<cfif pres_count IS 0>
			<cfquery datasource="#session.dsn#">
			    if not exists (select * from Presentacion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">)
				
				insert Presentacion (
					Ecodigo, id_producto, nombre_presentacion,
					sku, actualizar_precio, publicacion, multiplo)
				select
					Ecodigo, id_producto, ' ',
					'*', 1, 1, 1
				from Producto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			</cfquery>
		</cfif>
		<!--- Guardar también las imágenes --->
		<cfif IsDefined("form.foto_1") and Len(form.foto_1) GT 2>
			<cffile action="Upload" fileField="form.foto_1"
				destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*">
			<!--- cfdump var="#GetTempDirectory()#"--->
			<cffile action="readbinary" file="#GetTempDirectory()##cffile.serverFile#" variable="tmp" >
			<cffile action="delete" file="#gettempdirectory()##cffile.serverFile#" >
			<!--- se borra y luego se crea para que tenga un id_foto diferente --->
			<cfquery datasource="#session.dsn#">
				delete FotoProducto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
				insert FotoProducto (Ecodigo, id_producto, img_foto)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">,
						0x<cfoutput><cfloop from="1" to="#Len(tmp)#" index="i"><cfif tmp[i] GE 0 AND tmp[i] LE 15
						>0#FormatBaseN((tmp[i]+256)mod 256,16)#<cfelseif tmp[i] GT 0 
						>#FormatBaseN(tmp[i],16)#<cfelse>#FormatBaseN(tmp[i]+256,16)#</cfif></cfloop></cfoutput>)
			</cfquery>
		</cfif><!--- IsDefined form.foto_1 --->
		
	</cfif><!--- form.alta || form.cambio osease detalles --->

	<cfif IsDefined("form.dup")>
		<cfquery datasource="#session.dsn#" name="dup">
			declare @newid numeric(18)			
			insert Producto (Ecodigo, nombre_producto, publicacion, txt_descripcion)
			select Ecodigo, nombre_producto + ' [Copia]', publicacion, txt_descripcion
			from Producto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			select @newid = @@identity
			
			insert ProductoCategoria (id_producto, Ecodigo, id_categoria)
			select @newid, Ecodigo, id_categoria
			from ProductoCategoria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			
			insert FotoProducto (Ecodigo, id_producto, img_foto)
			select Ecodigo, @newid, img_foto
			from FotoProducto 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			
			insert Presentacion (Ecodigo, id_producto, nombre_presentacion, sku, precio, publicacion, txt_descripcion)
			select Ecodigo, @newid, nombre_presentacion, sku, precio, publicacion, txt_descripcion
			from Presentacion 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			
			insert FotoPresentacion (Ecodigo, id_producto, id_presentacion, img_foto)
			select Ecodigo, @newid, id_presentacion, img_foto
			from FotoPresentacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_producto#">
			
			select @newid as newid
		</cfquery>
		<cfoutput><input name="id_producto" type="hidden" value="#dup.newid#"></cfoutput>
	</cfif>
<cfoutput>
	<cfif isdefined("Form.Pagina")   ><input name="Pagina" type="hidden" value="#Form.Pagina#">
		</cfif>
	<cfif isdefined("Form.id_categoria")   ><input type="hidden" name="id_categoria" value="#HTMLEditFormat( form.id_categoria )#">
		</cfif>
</cfoutput>
</form><script type="text/javascript">document.redirsql.submit();</script>
</body>
</HTML>