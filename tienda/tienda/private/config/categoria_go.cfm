<cfsetting enablecfoutputonly="no">

<cfif IsDefined("form.cambio")>
	<cfquery datasource="#session.dsn#" name="original">
		select categoria_padre,orden_relativo from Categoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#">
	</cfquery>
	<cfquery datasource="#session.DSN#" >
		update Categoria
		set nombre_categoria = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_categoria#">
		, orden_relativo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden_relativo#">
		, formato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.formato#">
		, columnas = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.columnas#">
		, txt_descripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_descripcion#">
		, txt_pie = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_pie#">
		, opc_desc_prod = <cfif IsDefined("form.opc_desc_prod")>1<cfelse>0</cfif>
		, opc_img_prod = <cfif IsDefined("form.opc_img_prod")>1<cfelse>0</cfif>
		, opc_desc_pres = <cfif IsDefined("form.opc_desc_pres")>1<cfelse>0</cfif>
		, opc_img_pres = <cfif IsDefined("form.opc_img_pres")>1<cfelse>0</cfif>
		, color_borde = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.color_borde#">
		, color_fondo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.color_fondo#">
		, categoria_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.categoria_padre#" >
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#">
	</cfquery>
	<cfset id_categoria = form.id_categoria>
<cfelseif IsDefined("form.alta")>
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="id_categoria">
			select coalesce ( max (id_categoria), -1) + 1 as id_categoria
			from Categoria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfset id_categoria = id_categoria.id_categoria>
		<cfif id_categoria IS 0>
			<cfquery datasource="#session.dsn#">
			insert Categoria (id_categoria, Ecodigo, categoria_padre, nombre_categoria, orden_relativo,profundidad)
			values (0, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				0, 'ROOT', 0, 0)
			</cfquery>
			<cfset id_categoria = 1>
		</cfif>
		<cfquery datasource="#session.DSN#">
			insert Categoria (id_categoria, Ecodigo, nombre_categoria, orden_relativo,
				formato, columnas, txt_descripcion, txt_pie,
				opc_desc_prod, opc_img_prod, opc_desc_pres, opc_img_pres,
				color_borde, color_fondo, categoria_padre)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#" >,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_categoria#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden_relativo#">,
				
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.formato#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.columnas#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.txt_pie#">,
				
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.opc_desc_prod')#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.opc_img_prod')#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.opc_desc_pres')#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.opc_img_pres')#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.color_borde#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.color_fondo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.categoria_padre#" >)
		</cfquery>
		<!--- Actualizar arbol de dependencias --->
		<cfquery datasource="#session.dsn#">
			<!--- autorelacion --->
			insert CategoriaRelacion (Ecodigo, hijo, distancia, ancestro)
			select c.Ecodigo, c.id_categoria, 0, c.id_categoria
			from Categoria c
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and c.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			<!--- ancestros de mi padre --->
			insert CategoriaRelacion (Ecodigo, hijo, distancia, ancestro)
			select c.Ecodigo, c.id_categoria, r.distancia + 1, r.ancestro
			from Categoria c, CategoriaRelacion r
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and r.hijo = c.categoria_padre
			  and c.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
		</cfquery>
	</cftransaction>
<cfelseif IsDefined("form.baja")>
	<cfquery datasource="#session.DSN#" >
		delete CategoriaRelacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#"> in (hijo, ancestro)
	</cfquery>
	<cfquery datasource="#session.DSN#" >
		delete Categoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_categoria#">
	</cfquery>
</cfif>
<cfif  IsDefined("form.cambio") or IsDefined("form.alta")>
	<!--- Guardar imagen --->
	<cfif IsDefined("form.foto") and Len(form.foto) GT 2>
		<cffile action="Upload" fileField="form.foto"
			destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*">
		<!--- cfdump var="#GetTempDirectory()#"--->
		<cffile action="readbinary" file="#GetTempDirectory()##cffile.serverFile#" variable="tmp" >
		<cffile action="delete" file="#gettempdirectory()##cffile.serverFile#" >
		<cfquery datasource="#session.dsn#">
			update Categoria
			set img_foto = 0x<cfoutput><cfloop from="1" to="#Len(tmp)#" index="i"><cfif tmp[i] GE 0 AND tmp[i] LE 15
					>0#FormatBaseN((tmp[i]+256)mod 256,16)#<cfelseif tmp[i] GT 0 
					>#FormatBaseN(tmp[i],16)#<cfelse>#FormatBaseN(tmp[i]+256,16)#</cfif></cfloop></cfoutput>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
		</cfquery>	
	</cfif>
</cfif>

<!--- Regenerar arbol de categorias --->
<cfif isdefined("form.cambio") and 
	(original.categoria_padre neq form.categoria_padre or original.orden_relativo neq form.orden_relativo)>
	<cftransaction>
		<!--- 1. correr hacia delante los que me estorben --->
		<cfquery datasource="#session.dsn#">
			update Categoria
			set orden_relativo = orden_relativo + 1
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and categoria_padre = <cfqueryparam value="#form.categoria_padre#" cfsqltype="cf_sql_numeric">
			  and orden_relativo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden_relativo#">
			  and id_categoria != <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_categoria#">
		</cfquery>
		<!--  2. restaurar el orden de las categorias dentro de mi mismo padre --->
		<cfquery datasource="#session.dsn#" name="ordenado">
			select c.categoria_padre, c.id_categoria, coalesce(p.profundidad, 0) as profundidad_padre, p.path_categoria as path_padre
			from Categoria c, Categoria p
			where c.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and p.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and c.categoria_padre = <cfqueryparam value="#form.categoria_padre#" cfsqltype="cf_sql_numeric">
			  and p.id_categoria    = <cfqueryparam value="#form.categoria_padre#" cfsqltype="cf_sql_numeric">
			  and c.id_categoria != 0
			order by c.categoria_padre, c.orden_relativo, upper(c.nombre_categoria)
		</cfquery>
		<cfoutput query="ordenado" group="categoria_padre">
			<cfset OrdenBajoPadre = 0>
			<cfoutput>
				<cfset OrdenBajoPadre = OrdenBajoPadre + 1>
				<cfquery datasource="#Session.DSN#">
					update Categoria
					set orden_relativo = <cfqueryparam cfsqltype="cf_sql_integer" value="#OrdenBajoPadre#">,
						<!--- profundidad = case when categoria_padre is null then 1 else 0 end, --->
						profundidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#ordenado.profundidad_padre + 1#">,
						path_categoria = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ordenado.path_padre#/#NumberFormat(OrdenBajoPadre,'000')#">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and id_categoria = <cfqueryparam value="#ordenado.id_categoria#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfoutput>
		</cfoutput>
	</cftransaction>
	<!--- 3. Arreglar el arbol de categorias --->
	<cfset fix_Ecodigo = session.Ecodigo>
	<cfinclude template="categoria_fix.cfm">
</cfif>

<cfset args = "">

<cfif isdefined("form.Pagina")>
	<cfset args = ListAppend(args, "Pagina=" & Form.Pagina, "&")>
</cfif>
<cfif isdefined("form.cambio")>
	<cfset args = ListAppend(args, "id_categoria=" & URLEncodedFormat(form.id_categoria), "&")>
</cfif>
<cfif isdefined("form.categoria_padre")>
	<cfset args = ListAppend(args, "categoria_padre=" & URLEncodedFormat(form.categoria_padre), "&")>
</cfif>

<cflocation url="categoria.cfm?#args#">
